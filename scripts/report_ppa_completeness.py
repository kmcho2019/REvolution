#!/usr/bin/env python3
"""Write per-problem PPA completeness status for classic-vs-QD claims."""

from __future__ import annotations

import argparse
import csv
import math
from dataclasses import dataclass
from pathlib import Path


FIELDS = [
    "benchmark",
    "problem",
    "classic_valid_ppa",
    "qd_valid_ppa",
    "reference_ppa_valid",
    "comparison_status",
    "classic_valid_ppa_count",
    "qd_valid_ppa_count",
    "reference_missing_reason",
]


@dataclass(frozen=True)
class ProblemKey:
    benchmark: str
    problem: str


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def method_key(row: dict[str, str]) -> str:
    if "method" in row:
        return row["method"]
    if "backend" in row:
        return row["backend"]
    raise AssertionError("candidate CSV needs method or backend column")


def problem_key(row: dict[str, str]) -> ProblemKey:
    return ProblemKey(row["benchmark"], row["problem"])


def finite_float(value: str) -> bool:
    if value == "":
        return False
    parsed = float(value)
    return math.isfinite(parsed)


def candidate_has_ppa(row: dict[str, str]) -> bool:
    return finite_float(row["area"]) and finite_float(row["power"])


def reference_is_valid(row: dict[str, str]) -> bool:
    return finite_float(row["ref_area"]) and finite_float(row["ref_power"])


def parse_missing_reference(value: str) -> ProblemKey:
    if ":" in value:
        benchmark, problem = value.split(":", 1)
        assert benchmark
        assert problem
        return ProblemKey(benchmark, problem)
    assert value
    return ProblemKey("", value)


def matches_missing_reference(key: ProblemKey, missing: set[ProblemKey]) -> bool:
    return key in missing or ProblemKey("", key.problem) in missing


def completeness_rows(
    candidate_rows: list[dict[str, str]],
    reference_rows: list[dict[str, str]],
    classic_method: str,
    qd_method: str,
    missing_references: set[ProblemKey],
) -> list[dict[str, str]]:
    counts: dict[tuple[str, ProblemKey], int] = {}
    problems: set[ProblemKey] = set()
    for row in candidate_rows:
        key = problem_key(row)
        problems.add(key)
        if candidate_has_ppa(row):
            item = (method_key(row), key)
            counts[item] = counts.get(item, 0) + 1

    references: dict[ProblemKey, str] = {}
    for row in reference_rows:
        key = problem_key(row)
        problems.add(key)
        references[key] = "yes" if reference_is_valid(row) else "no"

    output = []
    for key in sorted(problems, key=lambda item: (item.benchmark, item.problem)):
        classic_count = counts.get((classic_method, key), 0)
        qd_count = counts.get((qd_method, key), 0)
        reference_valid = references.get(key, "no")
        reason = ""
        if matches_missing_reference(key, missing_references):
            reference_valid = "no"
            reason = "marked_missing"
        elif key not in references:
            reason = "missing_row"
        elif reference_valid == "no":
            reason = "invalid_metrics"
        output.append(
            {
                "benchmark": key.benchmark,
                "problem": key.problem,
                "classic_valid_ppa": yes_no(classic_count > 0),
                "qd_valid_ppa": yes_no(qd_count > 0),
                "reference_ppa_valid": reference_valid,
                "comparison_status": comparison_status(classic_count, qd_count, reference_valid),
                "classic_valid_ppa_count": str(classic_count),
                "qd_valid_ppa_count": str(qd_count),
                "reference_missing_reason": reason,
            }
        )
    return output


def yes_no(value: bool) -> str:
    return "yes" if value else "no"


def comparison_status(classic_count: int, qd_count: int, reference_valid: str) -> str:
    if reference_valid == "no":
        return "diagnostic_only"
    if classic_count == 0 or qd_count == 0:
        return "candidate_missing"
    return "headline"


def write_rows(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDS, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ppa-candidates", type=Path, required=True)
    parser.add_argument("--reference-ppa-metrics", type=Path, required=True)
    parser.add_argument("--classic-method", required=True)
    parser.add_argument("--qd-method", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--reference-missing-problem",
        action="append",
        default=[],
        help="Problem or BENCHMARK:PROBLEM with missing/defaulted reference PPA.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    rows = completeness_rows(
        read_csv(args.ppa_candidates),
        read_csv(args.reference_ppa_metrics),
        args.classic_method,
        args.qd_method,
        {parse_missing_reference(item) for item in args.reference_missing_problem},
    )
    write_rows(args.output, rows)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
