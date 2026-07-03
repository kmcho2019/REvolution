#!/usr/bin/env python3
"""Emit the per-seed screen summary table from packaged analysis outputs.

One row per seed plus a mean row, generated from the tracked
``aggregate_backend_metrics.csv`` (pareto analysis) and canonical
``hv_auc.csv`` of each seed package — the reproducible path for tables
like ``p0_v2_anchor/tables/three_seed_summary.csv`` (periodic review
action F-3: no hand-copied numbers).
"""

from __future__ import annotations

import argparse
import csv
from pathlib import Path

FIELDS = [
    "seed",
    "baseline_mean_hv",
    "treatment_mean_hv",
    "treatment_over_baseline_pct",
    "baseline_mean_hv_auc",
    "treatment_mean_hv_auc",
    "baseline_coverage",
    "treatment_coverage",
    "baseline_pareto_pts",
    "treatment_pareto_pts",
]


def parse_seed_spec(spec: str) -> tuple[str, Path, Path]:
    seed, aggregate_csv, hv_auc_csv = spec.split(":", 2)
    return seed, Path(aggregate_csv), Path(hv_auc_csv)


def read_aggregate(path: Path, backend: str) -> dict[str, str]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = [
            row
            for row in csv.DictReader(handle)
            if row["backend"] == backend and row["benchmark"] == "ALL"
        ]
    assert len(rows) == 1, (path, backend)
    return rows[0]


def mean_hv_auc(path: Path, backend: str) -> float:
    with path.open(newline="", encoding="utf-8") as handle:
        values = [
            float(row["hv_auc"])
            for row in csv.DictReader(handle)
            if row["backend"] == backend
        ]
    assert values, (path, backend)
    return sum(values) / len(values)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--seed",
        action="append",
        required=True,
        type=parse_seed_spec,
        help="SEED:aggregate_backend_metrics.csv:hv_auc.csv (repeatable).",
    )
    parser.add_argument("--baseline", required=True)
    parser.add_argument("--treatment", required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)

    rows: list[dict[str, str]] = []
    base_hv_total = treat_hv_total = base_auc_total = treat_auc_total = 0.0
    for seed, aggregate_csv, hv_auc_csv in args.seed:
        base = read_aggregate(aggregate_csv, args.baseline)
        treat = read_aggregate(aggregate_csv, args.treatment)
        base_hv = float(base["mean_hypervolume"])
        treat_hv = float(treat["mean_hypervolume"])
        base_auc = mean_hv_auc(hv_auc_csv, args.baseline)
        treat_auc = mean_hv_auc(hv_auc_csv, args.treatment)
        base_hv_total += base_hv
        treat_hv_total += treat_hv
        base_auc_total += base_auc
        treat_auc_total += treat_auc
        rows.append(
            {
                "seed": seed,
                "baseline_mean_hv": base["mean_hypervolume"],
                "treatment_mean_hv": treat["mean_hypervolume"],
                "treatment_over_baseline_pct": f"{treat_hv / base_hv * 100:.1f}",
                "baseline_mean_hv_auc": f"{base_auc:.9f}",
                "treatment_mean_hv_auc": f"{treat_auc:.9f}",
                "baseline_coverage": f"{base['pareto_valid_problem_count']}/{base['problem_count']}",
                "treatment_coverage": f"{treat['pareto_valid_problem_count']}/{treat['problem_count']}",
                "baseline_pareto_pts": base["mean_pareto_point_count"],
                "treatment_pareto_pts": treat["mean_pareto_point_count"],
            }
        )
    count = len(rows)
    rows.append(
        {
            "seed": "mean",
            "baseline_mean_hv": f"{base_hv_total / count:.17g}",
            "treatment_mean_hv": f"{treat_hv_total / count:.17g}",
            "treatment_over_baseline_pct": f"{treat_hv_total / base_hv_total * 100:.1f}",
            "baseline_mean_hv_auc": f"{base_auc_total / count:.9f}",
            "treatment_mean_hv_auc": f"{treat_auc_total / count:.9f}",
            "baseline_coverage": "",
            "treatment_coverage": "",
            "baseline_pareto_pts": "",
            "treatment_pareto_pts": "",
        }
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDS, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
