#!/usr/bin/env python3
"""Paired classic-vs-QD statistics for the journal-revamp gates.

Joins per-problem run summaries from baseline (classic) and treatment (QD)
run roots into problem-seed paired units, then emits:

- ``paired_deltas.csv``: one row per unit and metric with baseline,
  treatment, delta, and pairing status (missing treatment where the baseline
  has data is recorded and counted as a treatment loss, per the goal spec);
- ``statistical_tests.json``: paired summaries (mean delta, seeded bootstrap
  95% CI, win rate over non-tied pairs, exact sign test) plus gate checks;
- ``statistical_tests.md``: the same, human-readable.

Run roots are discovered with the same loader as
``scripts/backend_comparison_report.py`` so metric semantics stay identical
across reports. Units: ``--pair <seed>=<baseline_root>=<treatment_root>``
may be repeated to pool problem-seed pairs across seeds.

Note on units: ``avg_ppa_improvement`` and pass rates are converted from
percent to fractions at load time, so gate thresholds (+0.05, +5 points)
are evaluated on fraction/point scales exactly as predeclared.
"""

from __future__ import annotations

import argparse
import csv
import importlib.util
import json
import sys
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parent.parent
if str(REPO_ROOT / "src") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "src"))

from revolution.journal_stats import (  # noqa: E402
    GateCheck,
    PairedSample,
    PairedSummary,
    bootstrap_mean_ci,
    evaluate_functional_gates,
    evaluate_reference_ppa_gates,
    summarize_paired_metric,
)

_COMPARISON_SPEC = importlib.util.spec_from_file_location(
    "backend_comparison_report", REPO_ROOT / "scripts" / "backend_comparison_report.py"
)
assert _COMPARISON_SPEC is not None and _COMPARISON_SPEC.loader is not None
_comparison = importlib.util.module_from_spec(_COMPARISON_SPEC)
sys.modules.setdefault("backend_comparison_report", _comparison)
_COMPARISON_SPEC.loader.exec_module(_comparison)

METRICS = (
    "best_quality",
    "avg_ppa_improvement",
    "hypervolume",
    "functional_any_pass",
    "valid_ppa_any_pass",
)


def _row_metrics(row: Any) -> dict[str, float | None]:
    best_quality = row.best_score if row.best_score is not None else row.qd_best_quality
    avg_ppa = (
        row.avg_ppa_improvement_pct / 100.0
        if row.avg_ppa_improvement_pct is not None
        else None
    )
    return {
        "best_quality": best_quality,
        "avg_ppa_improvement": avg_ppa,
        "hypervolume": float(row.pareto_hypervolume or 0.0),
        "functional_any_pass": 1.0 if row.functionality_rate > 0.0 else 0.0,
        "valid_ppa_any_pass": 1.0 if row.valid_ppa_sample_count > 0 else 0.0,
    }


def load_unit_metrics(
    root: Path, *, label: str
) -> dict[tuple[str, str], dict[str, float | None]]:
    rows = _comparison._load_summary_rows(label, root)
    units: dict[tuple[str, str], dict[str, float | None]] = {}
    for row in rows:
        units[(row.benchmark, row.problem)] = _row_metrics(row)
    return units


def build_paired_samples(
    pairs: list[tuple[str, Path, Path]],
    *,
    baseline_label: str,
    treatment_label: str,
) -> dict[str, list[PairedSample]]:
    samples: dict[str, list[PairedSample]] = {metric: [] for metric in METRICS}
    for seed, baseline_root, treatment_root in pairs:
        baseline_units = load_unit_metrics(baseline_root, label=baseline_label)
        treatment_units = load_unit_metrics(treatment_root, label=treatment_label)
        unit_keys = sorted(set(baseline_units) | set(treatment_units))
        for benchmark, problem in unit_keys:
            unit_id = f"{seed}/{benchmark}/{problem}"
            base = baseline_units.get((benchmark, problem), {})
            treat = treatment_units.get((benchmark, problem), {})
            for metric in METRICS:
                samples[metric].append(
                    PairedSample(
                        unit_id=unit_id,
                        baseline=base.get(metric),
                        treatment=treat.get(metric),
                    )
                )
    return samples


def hypervolume_relative_stats(
    samples: list[PairedSample], *, seed: int
) -> tuple[float | None, float | None, float | None]:
    relative_deltas = [
        (sample.treatment - sample.baseline) / sample.baseline
        for sample in samples
        if sample.baseline is not None
        and sample.treatment is not None
        and sample.baseline > 0.0
    ]
    return bootstrap_mean_ci(relative_deltas, seed=seed)


def write_paired_deltas_csv(
    path: Path, samples: dict[str, list[PairedSample]]
) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(
            ["unit_id", "metric", "baseline", "treatment", "delta", "status"]
        )
        for metric in METRICS:
            for sample in samples[metric]:
                if sample.baseline is not None and sample.treatment is None:
                    status = "missing_treatment_counted_as_loss"
                elif sample.baseline is None and sample.treatment is not None:
                    status = "missing_baseline"
                elif sample.baseline is None and sample.treatment is None:
                    status = "missing_both"
                else:
                    status = "paired"
                writer.writerow(
                    [
                        sample.unit_id,
                        metric,
                        sample.baseline,
                        sample.treatment,
                        sample.delta,
                        status,
                    ]
                )


def _format_float(value: float | None) -> str:
    return "n/a" if value is None else f"{value:+.4f}"


def write_markdown(
    path: Path,
    *,
    summaries: dict[str, PairedSummary],
    gates: list[GateCheck],
    gate_profile: str,
    baseline_label: str,
    treatment_label: str,
    pair_count: int,
) -> None:
    lines = [
        "# Journal Statistical Tests",
        "",
        f"Baseline: `{baseline_label}` | Treatment: `{treatment_label}` | "
        f"Seed pairs: {pair_count}",
        "",
        "Deltas are treatment minus baseline on problem-seed units. "
        "`avg_ppa_improvement` and pass metrics use fraction scale.",
        "",
        "| Metric | Units | Paired | Missing-T (loss) | Mean Δ | 95% CI | "
        "Win rate (non-tied) | Sign-test p |",
        "| --- | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for metric in METRICS:
        summary = summaries[metric]
        ci = (
            f"[{_format_float(summary.bootstrap_ci_low)}, "
            f"{_format_float(summary.bootstrap_ci_high)}]"
        )
        win = (
            "n/a"
            if summary.win_rate_non_tied is None
            else f"{summary.win_rate_non_tied:.0%} ({summary.wins}W/{summary.losses}L/{summary.ties}T)"
        )
        p_value = "n/a" if summary.sign_test_p is None else f"{summary.sign_test_p:.4f}"
        lines.append(
            f"| {metric} | {summary.unit_count} | {summary.paired_count} | "
            f"{summary.missing_treatment_count} | {_format_float(summary.mean_delta)} | "
            f"{ci} | {win} | {p_value} |"
        )
    if gates:
        lines.extend(
            [
                "",
                f"## Gate checks ({gate_profile})",
                "",
                "| Check | Required | Observed | Passed |",
                "| --- | --- | --- | --- |",
            ]
        )
        for check in gates:
            observed = "n/a" if check.observed is None else f"{check.observed:.4f}"
            lines.append(
                f"| {check.name} | {check.required} | {observed} | "
                f"{'✅' if check.passed else '❌'} |"
            )
        overall = all(check.passed for check in gates)
        lines.extend(["", f"**Overall gate: {'PASS' if overall else 'FAIL'}**"])
    lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")


def parse_pair(raw: str) -> tuple[str, Path, Path]:
    parts = raw.split("=")
    if len(parts) != 3:
        raise argparse.ArgumentTypeError(
            "--pair expects <seed>=<baseline_root>=<treatment_root>"
        )
    return parts[0], Path(parts[1]), Path(parts[2])


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--pair",
        type=parse_pair,
        action="append",
        required=True,
        help="<seed>=<baseline_root>=<treatment_root>; repeat per seed.",
    )
    parser.add_argument("--baseline-name", default="classic")
    parser.add_argument("--treatment-name", default="qd")
    parser.add_argument(
        "--gate-profile",
        choices=("reference_ppa", "functional", "none"),
        default="none",
        help="Apply predeclared final-gate thresholds for this suite family.",
    )
    parser.add_argument("--bootstrap-seed", type=int, default=42)
    parser.add_argument("--output-dir", type=Path, required=True)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    for _, baseline_root, treatment_root in args.pair:
        for root in (baseline_root, treatment_root):
            if not root.is_dir():
                print(f"error: run root not found: {root}", file=sys.stderr)
                return 2

    samples = build_paired_samples(
        args.pair,
        baseline_label=args.baseline_name,
        treatment_label=args.treatment_name,
    )
    summaries = {
        metric: summarize_paired_metric(
            metric, samples[metric], seed=args.bootstrap_seed
        )
        for metric in METRICS
    }
    # Benchmark-family breakdown: unit ids are "<seed>/<benchmark>/<problem>",
    # so families never blend (CVDP functional metrics stay separate from
    # reference-normalized suites).
    benchmarks = sorted(
        {sample.unit_id.split("/")[1] for sample in samples[METRICS[0]]}
    )
    per_benchmark: dict[str, dict[str, PairedSummary]] = {}
    for benchmark in benchmarks:
        per_benchmark[benchmark] = {
            metric: summarize_paired_metric(
                metric,
                [
                    sample
                    for sample in samples[metric]
                    if sample.unit_id.split("/")[1] == benchmark
                ],
                seed=args.bootstrap_seed,
            )
            for metric in METRICS
        }

    gates: list[GateCheck] = []
    if args.gate_profile == "reference_ppa":
        hv_mean, hv_low, _ = hypervolume_relative_stats(
            samples["hypervolume"], seed=args.bootstrap_seed
        )
        treatment_valid = sum(
            1
            for sample in samples["valid_ppa_any_pass"]
            if (sample.treatment or 0.0) > 0.0
        )
        baseline_valid = sum(
            1
            for sample in samples["valid_ppa_any_pass"]
            if (sample.baseline or 0.0) > 0.0
        )
        gates = evaluate_reference_ppa_gates(
            best_quality=summaries["best_quality"],
            avg_ppa_improvement=summaries["avg_ppa_improvement"],
            hypervolume_relative_improvement=hv_mean,
            hypervolume_ci_low=hv_low,
            treatment_valid_ppa_any_pass=treatment_valid,
            baseline_valid_ppa_any_pass=baseline_valid,
        )
    elif args.gate_profile == "functional":
        functional = summaries["functional_any_pass"]
        delta_points = (
            functional.mean_delta * 100.0 if functional.mean_delta is not None else None
        )
        ci_low_points = (
            functional.bootstrap_ci_low * 100.0
            if functional.bootstrap_ci_low is not None
            else None
        )
        gates = evaluate_functional_gates(
            pass_rate_delta_points=delta_points,
            pass_rate_ci_low_points=ci_low_points,
        )

    args.output_dir.mkdir(parents=True, exist_ok=True)
    write_paired_deltas_csv(args.output_dir / "paired_deltas.csv", samples)
    payload: dict[str, Any] = {
        "baseline": args.baseline_name,
        "treatment": args.treatment_name,
        "seed_pairs": [seed for seed, _, _ in args.pair],
        "bootstrap_seed": args.bootstrap_seed,
        "metrics": {metric: summaries[metric].as_dict() for metric in METRICS},
        "per_benchmark": {
            benchmark: {
                metric: summary.as_dict() for metric, summary in metrics.items()
            }
            for benchmark, metrics in per_benchmark.items()
        },
        "gate_profile": args.gate_profile,
        "gates": [check.as_dict() for check in gates],
        "gates_passed": all(check.passed for check in gates) if gates else None,
    }
    (args.output_dir / "statistical_tests.json").write_text(
        json.dumps(payload, indent=2), encoding="utf-8"
    )
    write_markdown(
        args.output_dir / "statistical_tests.md",
        summaries=summaries,
        gates=gates,
        gate_profile=args.gate_profile,
        baseline_label=args.baseline_name,
        treatment_label=args.treatment_name,
        pair_count=len(args.pair),
    )
    print(f"Wrote paired deltas + statistical tests to {args.output_dir}")
    for metric in METRICS:
        summary = summaries[metric]
        print(
            f"  {metric}: mean_delta={_format_float(summary.mean_delta)} "
            f"paired={summary.paired_count} missing_t={summary.missing_treatment_count}"
        )
    if gates:
        print(f"  gate({args.gate_profile}): "
              f"{'PASS' if payload['gates_passed'] else 'FAIL'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
