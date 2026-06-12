#!/usr/bin/env python3
"""Descriptor-objective correlation report for the BD redundancy bound.

P2 of the journal revamp predeclares: a behavior-descriptor axis with
|r| >= 0.8 against any PPA objective (g_P/g_A/g_T) is a re-parameterized
objective and must be replaced or stripped of its diversity claim.

Methodology (fixes the exploratory pooled analysis): Pearson r is
computed WITHIN each problem (cross-problem pooling inflates correlation
through problem-level effects), then aggregated across problems by the
median of |r|. Problems contribute only when they have enough archive
members and nonzero variance on both series.

Data source: per-problem ``archive_cells.csv`` from QD run roots. Archive
members are selection-biased toward good candidates; the report records
this caveat and the per-problem sample counts so the freeze decision can
weigh the evidence honestly.
"""

from __future__ import annotations

import argparse
import csv
import json
import math
import sys
from collections import defaultdict
from pathlib import Path

OBJECTIVES = ("g_P", "g_A", "g_T")


def pearson(xs: list[float], ys: list[float]) -> float | None:
    n = len(xs)
    if n < 2:
        return None
    mean_x, mean_y = sum(xs) / n, sum(ys) / n
    var_x = sum((x - mean_x) ** 2 for x in xs)
    var_y = sum((y - mean_y) ** 2 for y in ys)
    if var_x == 0.0 or var_y == 0.0:
        return None
    cov = sum((x - mean_x) * (y - mean_y) for x, y in zip(xs, ys))
    return cov / math.sqrt(var_x * var_y)


def collect_problem_series(
    run_roots: list[Path], axes: list[str]
) -> dict[str, dict[str, list[float]]]:
    """Map problem -> series for each axis and objective."""

    series: dict[str, dict[str, list[float]]] = defaultdict(lambda: defaultdict(list))
    for root in run_roots:
        for cells_csv in sorted(root.rglob("archive_cells.csv")):
            problem = cells_csv.parent.name
            for row in csv.DictReader(cells_csv.open()):
                try:
                    descriptors = json.loads(row["descriptors_json"])
                    objectives = {key: float(row[key]) for key in OBJECTIVES}
                except (KeyError, ValueError, json.JSONDecodeError):
                    continue
                if len(descriptors) != len(axes):
                    continue
                for axis, value in zip(axes, descriptors):
                    series[problem][axis].append(float(value))
                for key, value in objectives.items():
                    series[problem][key].append(value)
    return series


def evaluate(
    series: dict[str, dict[str, list[float]]],
    *,
    axes: list[str],
    min_samples: int,
    threshold: float,
) -> dict[str, object]:
    per_problem: dict[str, dict[str, dict[str, float | None]]] = {}
    aggregates: dict[str, dict[str, dict[str, object]]] = {}
    for axis in axes:
        aggregates[axis] = {}
        for objective in OBJECTIVES:
            abs_rs: list[float] = []
            for problem, data in sorted(series.items()):
                if len(data.get(axis, [])) < min_samples:
                    continue
                r = pearson(data[axis], data[objective])
                per_problem.setdefault(problem, {}).setdefault(axis, {})[objective] = r
                if r is not None:
                    abs_rs.append(abs(r))
            median_abs = (
                sorted(abs_rs)[len(abs_rs) // 2] if abs_rs else None
            )
            aggregates[axis][objective] = {
                "median_abs_r": median_abs,
                "max_abs_r": max(abs_rs) if abs_rs else None,
                "problems_evaluated": len(abs_rs),
                "problems_over_threshold": sum(1 for r in abs_rs if r >= threshold),
            }
    verdicts = {}
    for axis in axes:
        worst = max(
            (entry["median_abs_r"] or 0.0) for entry in aggregates[axis].values()
        )
        verdicts[axis] = "REDUNDANT" if worst >= threshold else "OK"
    return {
        "axes": axes,
        "objectives": list(OBJECTIVES),
        "min_samples_per_problem": min_samples,
        "redundancy_threshold": threshold,
        "caveat": (
            "archive-member data is selection-biased toward good candidates; "
            "within-problem correlation with median aggregation avoids "
            "cross-problem pooling inflation"
        ),
        "aggregates": aggregates,
        "verdicts": verdicts,
        "per_problem": per_problem,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", type=Path, action="append", required=True)
    parser.add_argument(
        "--axes",
        nargs="+",
        default=["logic_depth", "ff_depth", "comb_width_log"],
        help="Axis names in descriptors_json order.",
    )
    parser.add_argument("--min-samples-per-problem", type=int, default=5)
    parser.add_argument("--redundancy-threshold", type=float, default=0.8)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)

    for root in args.run_root:
        if not root.is_dir():
            print(f"error: run root not found: {root}", file=sys.stderr)
            return 2
    series = collect_problem_series(args.run_root, args.axes)
    report = evaluate(
        series,
        axes=args.axes,
        min_samples=args.min_samples_per_problem,
        threshold=args.redundancy_threshold,
    )
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "descriptor_objective_correlation.json").write_text(
        json.dumps(report, indent=2), encoding="utf-8"
    )
    lines = [
        "# Descriptor-Objective Correlation",
        "",
        f"Threshold |r| >= {args.redundancy_threshold:g} (median across problems, "
        f"min {args.min_samples_per_problem} samples/problem). "
        f"{report['caveat']}.",
        "",
        "| Axis | Objective | median(abs r) | max(abs r) | problems | >= thr | Verdict |",
        "| --- | --- | --- | --- | --- | --- | --- |",
    ]
    for axis in args.axes:
        for objective in OBJECTIVES:
            entry = report["aggregates"][axis][objective]
            med = entry["median_abs_r"]
            mx = entry["max_abs_r"]
            lines.append(
                f"| {axis} | {objective} | "
                f"{'n/a' if med is None else f'{med:.3f}'} | "
                f"{'n/a' if mx is None else f'{mx:.3f}'} | "
                f"{entry['problems_evaluated']} | {entry['problems_over_threshold']} | "
                f"{report['verdicts'][axis]} |"
            )
    lines.append("")
    (args.output_dir / "descriptor_objective_correlation.md").write_text(
        "\n".join(lines), encoding="utf-8"
    )
    for axis, verdict in report["verdicts"].items():
        print(f"{axis}: {verdict}")
    print(f"Report -> {args.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
