#!/usr/bin/env python3
"""Regenerate the T72 source-aligned runtime regression table."""

from __future__ import annotations

import csv
from pathlib import Path

from revolution.source_aligned_descriptor_evaluator import SourceAlignedRTLDescriptorEvaluator


ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
T70_TABLE = (
    TECHNIQUE.parent
    / "T70_generated_rtl_extractor_smoke/tables/t70_extractor_results.csv"
)
OUTPUT = TECHNIQUE / "tables/source_aligned_runtime_regression.csv"
FIELDS = [
    "candidate_id",
    "problem",
    "kind",
    "top",
    "code_relpath",
    "expected_masterrtl_graph_edges",
    "actual_masterrtl_graph_edges",
    "graph_edges_match",
    "expected_rtltimer_dff_refs",
    "actual_rtltimer_dff_refs",
    "dff_refs_match",
    "masterrtl_operator_log_edges",
    "rtltimer_state_timing_class",
]


def main() -> None:
    assert T70_TABLE.is_file()
    rows = read_rows(T70_TABLE)
    evaluator = SourceAlignedRTLDescriptorEvaluator()
    with OUTPUT.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDS, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow(regression_row(row, evaluator))


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def regression_row(
    row: dict[str, str],
    evaluator: SourceAlignedRTLDescriptorEvaluator,
) -> dict[str, object]:
    metrics = evaluator.extract_metrics(
        code_file_path=ROOT / row["code_relpath"],
        top_module_name=row["top"],
    )
    expected_edges = int(row["masterrtl_graph_edges"])
    actual_edges = int(metrics["source_aligned_masterrtl_graph_edges"])
    expected_dff = int(row["rtltimer_dff_refs"])
    actual_dff = int(metrics["source_aligned_rtltimer_dff_refs"])
    return {
        "candidate_id": row["candidate_id"],
        "problem": row["problem"],
        "kind": row["kind"],
        "top": row["top"],
        "code_relpath": row["code_relpath"],
        "expected_masterrtl_graph_edges": expected_edges,
        "actual_masterrtl_graph_edges": actual_edges,
        "graph_edges_match": expected_edges == actual_edges,
        "expected_rtltimer_dff_refs": expected_dff,
        "actual_rtltimer_dff_refs": actual_dff,
        "dff_refs_match": expected_dff == actual_dff,
        "masterrtl_operator_log_edges": f"{metrics['masterrtl_operator_log_edges']:.6f}",
        "rtltimer_state_timing_class": int(metrics["rtltimer_state_timing_class"]),
    }


if __name__ == "__main__":
    main()
