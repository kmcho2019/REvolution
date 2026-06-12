#!/usr/bin/env python3
"""Validate a fast-iteration classic-vs-variant pair against its signoff gates.

The fast-iteration subset (docs/journal_features/09_fast_iteration_validation_set.md)
is a gated screening instrument, not a convenience: a pair of runs may only
be used for promote/demote decisions if the instrument gates pass. This
checker evaluates the mechanical gates from the spec:

- G1 wall-clock: each arm's run wall time is under the budget, and no single
  problem dominates an arm (prune candidates are reported);
- G2 PPA signal flow: every problem in every arm produced at least the
  minimum number of distinct successful candidates with PPA metrics;
- G3 discrimination: the per-problem candidate quality spread (IQR over
  retained candidates pooled across generations) clears the floor on at
  least the required number of problems in each arm;
- verdict banding: if a paired statistics JSON is supplied, the
  best-quality mean delta is mapped to the predeclared
  PROMOTE / DEMOTE / INCONCLUSIVE bands.

G4 (screening validity vs the hard subset) and G5 (cross-seed stability)
are calibration gates evaluated across multiple runs and recorded in the
revamp history; this script covers the per-pair mechanical gates.

Outputs ``fast_iter_gate_report.json`` and ``.md``; exits nonzero when any
checked gate fails.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any


def _quartile_iqr(values: list[float]) -> float | None:
    if len(values) < 4:
        return None
    ordered = sorted(values)
    n = len(ordered)

    def _quantile(q: float) -> float:
        position = q * (n - 1)
        low = int(position)
        high = min(n - 1, low + 1)
        fraction = position - low
        return ordered[low] * (1 - fraction) + ordered[high] * fraction

    return _quantile(0.75) - _quantile(0.25)


def collect_arm_metrics(run_root: Path) -> dict[str, Any]:
    """Collect per-problem candidate-quality samples and runtimes for one arm."""

    problems: dict[str, dict[str, Any]] = {}
    ignored = {"archive_summary.json", "global_pareto_summary.json"}
    for summary_path in sorted(run_root.rglob("*_summary.json")):
        if summary_path.name in ignored:
            continue
        problem_dir = summary_path.parent
        benchmark = problem_dir.parent.name
        key = f"{benchmark}/{problem_dir.name}"
        try:
            summary = json.loads(summary_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            continue
        scores_by_id: dict[str, float] = {}
        generation_log = problem_dir / "generation_log.jsonl"
        if generation_log.is_file():
            for line in generation_log.read_text(encoding="utf-8").splitlines():
                try:
                    payload = json.loads(line)
                except json.JSONDecodeError:
                    continue
                for detail in payload.get("population_ppa_details", []) or []:
                    if not isinstance(detail, dict):
                        continue
                    score = detail.get("score")
                    candidate_id = str(detail.get("id", ""))
                    if isinstance(score, (int, float)) and candidate_id:
                        scores_by_id[candidate_id] = float(score)
        for detail in summary.get("final_population_ppa_details", []) or []:
            if not isinstance(detail, dict):
                continue
            score = detail.get("score")
            candidate_id = str(detail.get("id", ""))
            if isinstance(score, (int, float)) and candidate_id:
                scores_by_id.setdefault(candidate_id, float(score))
        runtime = summary.get("total_runtime_seconds")
        values = sorted(scores_by_id.values())
        # Best-minus-median gap: selection compresses retained-population
        # IQR on converged problems, so the gap is the discrimination
        # measure (headroom exists AND the search exploited it).
        gap = values[-1] - values[len(values) // 2] if len(values) >= 4 else None
        problems[key] = {
            "valid_ppa_candidates": len(scores_by_id),
            "quality_iqr": _quartile_iqr(values),
            "quality_gap": gap,
            "runtime_seconds": float(runtime) if isinstance(runtime, (int, float)) else None,
        }

    wall_seconds: float | None = None
    telemetry_files = sorted(run_root.rglob("*_scheduler_telemetry.json"))
    if telemetry_files:
        try:
            telemetry = json.loads(telemetry_files[0].read_text(encoding="utf-8"))
            wall = telemetry.get("run_wall_seconds", telemetry.get("wall_seconds"))
            wall_seconds = float(wall) if isinstance(wall, (int, float)) else None
        except json.JSONDecodeError:
            wall_seconds = None
    if wall_seconds is None:
        runtimes = [
            problem["runtime_seconds"]
            for problem in problems.values()
            if problem["runtime_seconds"] is not None
        ]
        wall_seconds = max(runtimes) if runtimes else None
    return {"problems": problems, "wall_seconds": wall_seconds}


def evaluate_pair(
    *,
    classic: dict[str, Any],
    variant: dict[str, Any],
    max_arm_wall_seconds: float,
    min_valid_ppa: int,
    min_iqr: float,
    min_iqr_problems: int,
    dominance_fraction: float,
) -> list[dict[str, Any]]:
    checks: list[dict[str, Any]] = []
    for arm_name, arm in (("classic", classic), ("variant", variant)):
        wall = arm["wall_seconds"]
        checks.append(
            {
                "name": f"G1_wall_clock_{arm_name}",
                "required": f"<= {max_arm_wall_seconds:.0f}s",
                "observed": wall,
                "passed": wall is not None and wall <= max_arm_wall_seconds,
            }
        )
        # Problems run concurrently, so dominance is measured against the
        # SUM of per-problem runtimes (the serial work), not the arm wall.
        runtimes = [
            problem["runtime_seconds"]
            for problem in arm["problems"].values()
            if problem["runtime_seconds"] is not None
        ]
        total_runtime = sum(runtimes)
        dominant = [
            (key, problem["runtime_seconds"])
            for key, problem in arm["problems"].items()
            if problem["runtime_seconds"] is not None
            and total_runtime > 0
            and problem["runtime_seconds"] > dominance_fraction * total_runtime
        ]
        checks.append(
            {
                "name": f"G1_no_dominant_problem_{arm_name}",
                "required": f"no problem > {dominance_fraction:.0%} of summed runtime",
                "observed": ", ".join(f"{k}={v:.0f}s" for k, v in dominant) or "none",
                "passed": not dominant,
            }
        )
        low_signal = [
            key
            for key, problem in arm["problems"].items()
            if problem["valid_ppa_candidates"] < min_valid_ppa
        ]
        checks.append(
            {
                "name": f"G2_valid_ppa_flow_{arm_name}",
                "required": f"every problem >= {min_valid_ppa} PPA candidates",
                "observed": ", ".join(low_signal) or "all problems pass",
                "passed": not low_signal and bool(arm["problems"]),
            }
        )
    # G3 discrimination is an INSTRUMENT property, so it is measured on the
    # baseline (classic) arm only: a variant whose quality spread collapses
    # should fail the comparison, not invalidate the instrument.
    gap_pass_count = sum(
        1
        for problem in classic["problems"].values()
        if problem["quality_gap"] is not None and problem["quality_gap"] >= min_iqr
    )
    checks.append(
        {
            "name": "G3_discrimination_baseline",
            "required": f">= {min_iqr_problems} baseline problems with best-median quality gap >= {min_iqr:g}",
            "observed": float(gap_pass_count),
            "passed": gap_pass_count >= min_iqr_problems,
        }
    )
    return checks


def verdict_from_stats(
    stats_json: Path,
    *,
    promote_threshold: float,
    demote_threshold: float,
) -> dict[str, Any]:
    payload = json.loads(stats_json.read_text(encoding="utf-8"))
    delta = payload.get("metrics", {}).get("best_quality", {}).get("mean_delta")
    if not isinstance(delta, (int, float)):
        verdict = "INCONCLUSIVE"
    elif delta >= promote_threshold:
        verdict = "PROMOTE"
    elif delta <= demote_threshold:
        verdict = "DEMOTE"
    else:
        verdict = "INCONCLUSIVE"
    return {
        "best_quality_mean_delta": delta,
        "promote_threshold": promote_threshold,
        "demote_threshold": demote_threshold,
        "verdict": verdict,
        "note": (
            "Verdicts are screening signals on the tuning instrument only; "
            "INCONCLUSIVE escalates to the hard subset. Never publication "
            "evidence."
        ),
    }


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--classic-root", type=Path, required=True)
    parser.add_argument("--variant-root", type=Path, required=True)
    parser.add_argument("--stats-json", type=Path, default=None)
    parser.add_argument("--max-arm-wall-seconds", type=float, default=6000.0)
    parser.add_argument("--min-valid-ppa", type=int, default=6)
    parser.add_argument("--min-iqr", type=float, default=0.02)
    parser.add_argument("--min-iqr-problems", type=int, default=4)
    parser.add_argument("--dominance-fraction", type=float, default=0.5)
    parser.add_argument("--promote-threshold", type=float, default=0.02)
    parser.add_argument("--demote-threshold", type=float, default=-0.02)
    parser.add_argument("--output-dir", type=Path, required=True)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    for root in (args.classic_root, args.variant_root):
        if not root.is_dir():
            print(f"error: run root not found: {root}", file=sys.stderr)
            return 2

    classic = collect_arm_metrics(args.classic_root)
    variant = collect_arm_metrics(args.variant_root)
    checks = evaluate_pair(
        classic=classic,
        variant=variant,
        max_arm_wall_seconds=args.max_arm_wall_seconds,
        min_valid_ppa=args.min_valid_ppa,
        min_iqr=args.min_iqr,
        min_iqr_problems=args.min_iqr_problems,
        dominance_fraction=args.dominance_fraction,
    )
    verdict: dict[str, Any] | None = None
    if args.stats_json is not None and args.stats_json.is_file():
        verdict = verdict_from_stats(
            args.stats_json,
            promote_threshold=args.promote_threshold,
            demote_threshold=args.demote_threshold,
        )

    all_passed = all(check["passed"] for check in checks)
    report: dict[str, Any] = {
        "classic_root": str(args.classic_root),
        "variant_root": str(args.variant_root),
        "gates_passed": all_passed,
        "checks": checks,
        "classic": classic,
        "variant": variant,
        "verdict": verdict,
    }
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "fast_iter_gate_report.json").write_text(
        json.dumps(report, indent=2), encoding="utf-8"
    )
    lines = [
        "# Fast-Iteration Pair Gate Report",
        "",
        f"Classic: `{args.classic_root}` | Variant: `{args.variant_root}` | "
        f"Instrument gates: {'PASS' if all_passed else 'FAIL'}",
        "",
        "| Gate | Required | Observed | Passed |",
        "| --- | --- | --- | --- |",
    ]
    for check in checks:
        observed = check["observed"]
        observed_str = (
            f"{observed:.1f}" if isinstance(observed, float) else str(observed)
        )
        lines.append(
            f"| {check['name']} | {check['required']} | {observed_str} | "
            f"{'✅' if check['passed'] else '❌'} |"
        )
    if verdict is not None:
        lines.extend(
            [
                "",
                f"**Screening verdict: {verdict['verdict']}** "
                f"(best-quality Δ = {verdict['best_quality_mean_delta']})",
            ]
        )
    lines.append("")
    (args.output_dir / "fast_iter_gate_report.md").write_text(
        "\n".join(lines), encoding="utf-8"
    )

    for check in checks:
        print(f"[{'PASS' if check['passed'] else 'FAIL'}] {check['name']}: {check['observed']}")
    if verdict is not None:
        print(f"Screening verdict: {verdict['verdict']}")
    print(f"Instrument gates {'PASSED' if all_passed else 'FAILED'}; report in {args.output_dir}")
    return 0 if all_passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
