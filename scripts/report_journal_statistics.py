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
import math
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
    cluster_bootstrap_mean_ci,
    evaluate_equivalence_gate,
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


HYPERVOLUME_EPSILON = 1e-9


def hypervolume_log_ratio_stats(
    samples: list[PairedSample], *, seed: int
) -> dict[str, object]:
    """Predeclared hypervolume gate statistic.

    Per unit: log((HV_t + eps)/(HV_b + eps)) with eps=1e-9. Missing
    treatment where the baseline exists is imputed HV_t = 0 (penalized);
    units with zero baseline or zero treatment hypervolume are counted and
    reported rather than silently dropped. CI is a cluster bootstrap over
    problems.
    """

    log_ratios_by_cluster: dict[str, list[float]] = {}
    baseline_zero = treatment_zero = imputed = 0
    for sample in samples:
        if sample.baseline is None:
            continue
        treatment = sample.treatment
        if treatment is None:
            treatment = 0.0
            imputed += 1
        if sample.baseline <= 0.0:
            baseline_zero += 1
        if treatment <= 0.0:
            treatment_zero += 1
        cluster = "/".join(sample.unit_id.split("/")[1:])
        log_ratios_by_cluster.setdefault(cluster, []).append(
            math.log((treatment + HYPERVOLUME_EPSILON) / (sample.baseline + HYPERVOLUME_EPSILON))
        )
    mean, ci_low, ci_high = cluster_bootstrap_mean_ci(
        log_ratios_by_cluster, seed=seed
    )
    epsilon_sensitivity = {}
    for eps in (1e-6, 1e-12):
        alt_by_cluster: dict[str, list[float]] = {}
        for sample in samples:
            if sample.baseline is None:
                continue
            treatment = sample.treatment if sample.treatment is not None else 0.0
            cluster = "/".join(sample.unit_id.split("/")[1:])
            alt_by_cluster.setdefault(cluster, []).append(
                math.log((treatment + eps) / (sample.baseline + eps))
            )
        alt_mean, alt_low, _ = cluster_bootstrap_mean_ci(alt_by_cluster, seed=seed)
        epsilon_sensitivity[f"{eps:g}"] = {"mean": alt_mean, "ci_low": alt_low}
    return {
        "mean_log_ratio": mean,
        "ci_low": ci_low,
        "ci_high": ci_high,
        "epsilon": HYPERVOLUME_EPSILON,
        "epsilon_sensitivity": epsilon_sensitivity,
        "baseline_zero_units": baseline_zero,
        "treatment_zero_units": treatment_zero,
        "imputed_missing_treatment_units": imputed,
    }


def resolve_metric_floor(
    metric: str, samples: list[PairedSample]
) -> float | None:
    """Predeclared penalization floors for missing-treatment imputation.

    Pass-indicator metrics floor at 0. Quality/PPA metrics floor at the
    worst observed value across both arms (so imputation is at least as bad
    as any real outcome). Hypervolume uses the log-ratio statistic instead.
    """

    if metric in ("functional_any_pass", "valid_ppa_any_pass"):
        return 0.0
    if metric == "hypervolume":
        return None
    observed = [
        value
        for sample in samples
        for value in (sample.baseline, sample.treatment)
        if value is not None
    ]
    return min(observed) if observed else None


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
        "| Metric | Units | Paired | Missing-T (loss) | Imputed | "
        "Mean Δ (gate) | 95% cluster CI | Complete-case Δ | "
        "Win rate (non-tied) | Sign-test p |",
        "| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |",
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
            f"{summary.missing_treatment_count} | {summary.imputed_loss_count} | "
            f"{_format_float(summary.mean_delta)} | {ci} | "
            f"{_format_float(summary.complete_case_mean_delta)} | {win} | {p_value} |"
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
            metric,
            samples[metric],
            seed=args.bootstrap_seed,
            missing_treatment_floor=resolve_metric_floor(metric, samples[metric]),
        )
        for metric in METRICS
    }
    # Per-seed complete-case mean deltas (descriptive) plus true
    # leave-one-seed-out recomputation of the penalized gate statistic.
    per_seed_means: dict[str, dict[str, float | None]] = {}
    loso_gate_stats: dict[str, dict[str, dict[str, float | None]]] = {}
    for seed_label, _, _ in args.pair:
        per_seed_means[seed_label] = {}
        loso_gate_stats[seed_label] = {}
        for metric in METRICS:
            deltas = [
                sample.delta
                for sample in samples[metric]
                if sample.unit_id.startswith(f"{seed_label}/")
                and sample.delta is not None
            ]
            per_seed_means[seed_label][metric] = (
                sum(deltas) / len(deltas) if deltas else None
            )
            if len(args.pair) > 1:
                held_out = [
                    sample
                    for sample in samples[metric]
                    if not sample.unit_id.startswith(f"{seed_label}/")
                ]
                loso_summary = summarize_paired_metric(
                    metric,
                    held_out,
                    seed=args.bootstrap_seed,
                    missing_treatment_floor=resolve_metric_floor(metric, held_out),
                )
                loso_gate_stats[seed_label][metric] = {
                    "mean_delta": loso_summary.mean_delta,
                    "ci_low": loso_summary.bootstrap_ci_low,
                    "ci_high": loso_summary.bootstrap_ci_high,
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
    hypervolume_stats: dict[str, object] = {}
    equivalence_gates: list[GateCheck] = []
    if args.gate_profile == "reference_ppa":
        hypervolume_stats = hypervolume_log_ratio_stats(
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
        hv_mean = hypervolume_stats["mean_log_ratio"]
        hv_low = hypervolume_stats["ci_low"]
        gates = evaluate_reference_ppa_gates(
            best_quality=summaries["best_quality"],
            avg_ppa_improvement=summaries["avg_ppa_improvement"],
            hypervolume_log_ratio_mean=(
                hv_mean if isinstance(hv_mean, float) else None
            ),
            hypervolume_log_ratio_ci_low=(
                hv_low if isinstance(hv_low, float) else None
            ),
            treatment_valid_ppa_any_pass=treatment_valid,
            baseline_valid_ppa_any_pass=baseline_valid,
        )
        equivalence_gates = evaluate_equivalence_gate(summaries["best_quality"])
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
        "per_seed_mean_deltas": per_seed_means,
        "leave_one_seed_out_penalized": loso_gate_stats,
        "hypervolume_log_ratio": hypervolume_stats,
        "gate_profile": args.gate_profile,
        "gates": [check.as_dict() for check in gates],
        "gates_passed": all(check.passed for check in gates) if gates else None,
        "equivalence_gates": [check.as_dict() for check in equivalence_gates],
        "equivalence_passed": (
            all(check.passed for check in equivalence_gates)
            if equivalence_gates
            else None
        ),
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
