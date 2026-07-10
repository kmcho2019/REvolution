#!/usr/bin/env python3
"""Audit a ppa_candidates.csv for single-thought operator contamination.

Ported from the 20260630 corrected RTLLM suite tooling
(``RTLLM_full_suite/20260630/tools/audit_operator_contract.py``) into a
tracked, tested location. Every arm of a headline classic-vs-QD
comparison must audit to ``single_thought_count=0``; a nonzero count
invalidates the comparison (the June-22 contamination lesson).

Strategy names mirror the classic EoH suite in
``revolution.algorithm.EvolStrategyMethod``.
"""

from __future__ import annotations

import argparse
import csv
from collections import Counter
from pathlib import Path

FIELDS = [
    "method_key",
    "candidate_count",
    "initial_count",
    "single_thought_count",
    "eoh_strategy_count",
    "other_strategy_count",
    "status",
]

EOH_STRATEGIES = frozenset({"M-S", "M-R", "M-I", "C-F", "M-E", "M-F"})
SINGLE_THOUGHT = "single_thought_operator"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def audit_rows(
    candidate_rows: list[dict[str, str]], methods: list[str]
) -> list[dict[str, str]]:
    """Count per-method operator strategies and flag single-thought use."""
    counts: dict[str, Counter[str]] = {method: Counter() for method in methods}
    for row in candidate_rows:
        method = row["backend"]
        if method not in counts:
            continue
        counts[method][row["strategy"]] += 1

    output_rows: list[dict[str, str]] = []
    for method in methods:
        method_counts = counts[method]
        single = method_counts[SINGLE_THOUGHT]
        total = sum(method_counts.values())
        initial = method_counts["initial"]
        eoh = sum(method_counts[strategy] for strategy in EOH_STRATEGIES)
        output_rows.append(
            {
                "method_key": method,
                "candidate_count": str(total),
                "initial_count": str(initial),
                "single_thought_count": str(single),
                "eoh_strategy_count": str(eoh),
                "other_strategy_count": str(total - initial - single - eoh),
                "status": "fail" if single else "pass",
            }
        )
    return output_rows


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ppa-candidates", type=Path, required=True)
    parser.add_argument(
        "--methods",
        nargs="*",
        default=None,
        help="Method keys to audit; defaults to every backend in the CSV.",
    )
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)

    candidate_rows = read_csv(args.ppa_candidates)
    methods = args.methods or sorted({row["backend"] for row in candidate_rows})
    assert methods
    output_rows = audit_rows(candidate_rows, methods)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDS, lineterminator="\n")
        writer.writeheader()
        writer.writerows(output_rows)

    return 1 if any(row["status"] == "fail" for row in output_rows) else 0


if __name__ == "__main__":
    raise SystemExit(main())
