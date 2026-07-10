#!/usr/bin/env python3
"""Report canonical per-method/problem HV-AUC from a ppa_candidates.csv.

Input: the reference-complete candidate chronology exported by the PPA
distribution analysis (columns include ``backend``, ``problem``,
``circuit_type``, ``generation``, ``g_P``, ``g_A``, ``g_T``). HV-AUC
follows the 20260630 corrected-suite rule via
``revolution.qd.pareto_analysis`` so every package recomputes it through
one shared implementation.
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

from revolution.qd.pareto_analysis import (  # noqa: E402
    cumulative_hypervolume_curve,
    hypervolume_auc,
)

SEQUENTIAL_KEYS = ("g_P", "g_A", "g_T")
COMBINATIONAL_KEYS = ("g_P", "g_A")
OUTPUT_FIELDS = ["backend", "problem", "circuit_type", "hv_final", "hv_auc"]


def objective_keys(circuit_type: str) -> tuple[str, ...]:
    if circuit_type == "sequential":
        return SEQUENTIAL_KEYS
    if circuit_type == "combinational":
        return COMBINATIONAL_KEYS
    raise AssertionError(f"unknown circuit type: {circuit_type}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ppa-candidates", type=Path, required=True)
    parser.add_argument("--num-generations", type=int, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)
    assert args.num_generations >= 1

    with args.ppa_candidates.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows

    groups: dict[tuple[str, str], list[dict[str, str]]] = {}
    for row in rows:
        groups.setdefault((row["backend"], row["problem"]), []).append(row)

    output_rows: list[dict[str, str]] = []
    for (backend, problem), group in sorted(groups.items()):
        circuit_type = group[0]["circuit_type"]
        assert all(row["circuit_type"] == circuit_type for row in group), (
            backend,
            problem,
        )
        keys = objective_keys(circuit_type)
        points_by_generation: dict[int, list[tuple[float, ...]]] = {}
        for row in group:
            point = tuple(float(row[key]) for key in keys)
            points_by_generation.setdefault(int(row["generation"]), []).append(point)
        curve = cumulative_hypervolume_curve(points_by_generation, args.num_generations)
        output_rows.append(
            {
                "backend": backend,
                "problem": problem,
                "circuit_type": circuit_type,
                "hv_final": f"{curve[-1]:.12g}",
                "hv_auc": f"{hypervolume_auc(curve):.12g}",
            }
        )

    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=OUTPUT_FIELDS, lineterminator="\n")
        writer.writeheader()
        writer.writerows(output_rows)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
