#!/usr/bin/env python3
"""Check that the corrected RTLLM suite did not use single-thought operators."""

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
    "status",
]

EOH_STRATEGIES = {"M-S", "M-R", "M-I", "C-F", "M-E", "M-F"}


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ppa-candidates", type=Path, required=True)
    parser.add_argument("--method-manifest", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    methods = [row["method_key"] for row in read_csv(args.method_manifest)]
    counts = {method: Counter() for method in methods}
    for row in read_csv(args.ppa_candidates):
        method = row["backend"]
        if method not in counts:
            continue
        counts[method][row["strategy"]] += 1

    output_rows = []
    failed = False
    for method in methods:
        method_counts = counts[method]
        single = method_counts["single_thought_operator"]
        failed = failed or single > 0
        output_rows.append(
            {
                "method_key": method,
                "candidate_count": str(sum(method_counts.values())),
                "initial_count": str(method_counts["initial"]),
                "single_thought_count": str(single),
                "eoh_strategy_count": str(
                    sum(method_counts[strategy] for strategy in EOH_STRATEGIES)
                ),
                "status": "fail" if single else "pass",
            }
        )

    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDS, lineterminator="\n")
        writer.writeheader()
        writer.writerows(output_rows)

    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
