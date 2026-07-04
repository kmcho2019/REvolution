#!/usr/bin/env python3
"""Compute the Branch-B utility metric from packaged PPA candidate tables.

Frozen-contract definition (journal_narrative.md): the fraction of
problem-seed units where the QD archive holds a testbench-passing,
valid-PPA candidate that classic's best candidate does NOT dominate
and that strictly improves at least one PPA axis. Units where classic
is uncovered count as utility when QD covers them (QD offers a design
where classic has none); units covered by neither count in the
denominator only.

Inputs are per-seed package files: the treatment ``ppa_candidates.csv``
and the shared ``best_candidate_by_backend_problem.csv`` (both emitted
by report_ppa_distribution.py). Dominance uses the repo's canonical
``pareto_analysis.dominates`` epsilon semantics.
"""

from __future__ import annotations

import argparse
import csv
import os
import sys
from pathlib import Path

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.qd.pareto_analysis import dominates  # noqa: E402

SEQUENTIAL_KEYS = ("g_P", "g_A", "g_T")
COMBINATIONAL_KEYS = ("g_P", "g_A")
OUTPUT_FIELDS = [
    "seed",
    "units",
    "qd_only_covered",
    "nondominated_improving",
    "utility_units",
    "utility_fraction",
]


def objective_keys(circuit_type: str) -> tuple[str, ...]:
    if circuit_type == "sequential":
        return SEQUENTIAL_KEYS
    if circuit_type == "combinational":
        return COMBINATIONAL_KEYS
    raise AssertionError(f"unknown circuit type: {circuit_type}")


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows, path
    return rows


def unit_has_utility(
    classic_best: tuple[float, ...] | None,
    treatment_points: list[tuple[float, ...]],
) -> tuple[bool, bool]:
    """Return (qd_only_covered, nondominated_improving) for one unit."""
    if not treatment_points:
        return False, False
    if classic_best is None:
        return True, False
    for point in treatment_points:
        improves = any(v > b for v, b in zip(point, classic_best, strict=True))
        if improves and not dominates(classic_best, point):
            return False, True
    return False, False


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--seed-package",
        action="append",
        required=True,
        type=lambda s: tuple(s.split(":", 1)),
        help="SEED:ppa_distribution_dir (repeat per seed).",
    )
    parser.add_argument("--baseline", required=True)
    parser.add_argument("--treatment", required=True)
    parser.add_argument("--problems-per-seed", type=int, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)

    rows_out: list[dict[str, str]] = []
    total_units = total_utility = total_qd_only = total_nondom = 0
    for seed, package_dir in args.seed_package:
        package = Path(package_dir)
        best_rows = read_csv(package / "data" / "best_candidate_by_backend_problem.csv")
        candidate_rows = read_csv(package / "data" / "ppa_candidates.csv")

        classic_best: dict[str, tuple[float, ...]] = {}
        for row in best_rows:
            if row["backend"] != args.baseline:
                continue
            keys = objective_keys(row["circuit_type"])
            classic_best[row["problem"]] = tuple(float(row[k]) for k in keys)

        treatment_points: dict[str, list[tuple[float, ...]]] = {}
        for row in candidate_rows:
            if row["backend"] != args.treatment:
                continue
            keys = objective_keys(row["circuit_type"])
            treatment_points.setdefault(row["problem"], []).append(
                tuple(float(row[k]) for k in keys)
            )

        qd_only = nondom = 0
        for problem in set(classic_best) | set(treatment_points):
            only, improving = unit_has_utility(
                classic_best.get(problem), treatment_points.get(problem, [])
            )
            qd_only += only
            nondom += improving
        utility = qd_only + nondom
        units = args.problems_per_seed
        rows_out.append(
            {
                "seed": seed,
                "units": str(units),
                "qd_only_covered": str(qd_only),
                "nondominated_improving": str(nondom),
                "utility_units": str(utility),
                "utility_fraction": f"{utility / units:.6f}",
            }
        )
        total_units += units
        total_utility += utility
        total_qd_only += qd_only
        total_nondom += nondom

    rows_out.append(
        {
            "seed": "ALL",
            "units": str(total_units),
            "qd_only_covered": str(total_qd_only),
            "nondominated_improving": str(total_nondom),
            "utility_units": str(total_utility),
            "utility_fraction": f"{total_utility / total_units:.6f}",
        }
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=OUTPUT_FIELDS, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows_out)
    print(open(args.output).read())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
