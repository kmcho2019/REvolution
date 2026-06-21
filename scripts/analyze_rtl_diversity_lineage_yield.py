#!/usr/bin/env python3
# pyright: reportArgumentType=false, reportGeneralTypeIssues=false
"""Analyze parent-child yield from RTL diversity lineage audit files."""

from __future__ import annotations

import argparse
import csv
import json
import math
from pathlib import Path
from typing import Any

import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_AUDIT_CSV = (
    REPO_ROOT
    / "exp/diversity_check/wp0_lineage_source_audit_20260621_055941_UTC/"
    "lineage_source_files.csv"
)
DEFAULT_OUTPUT_DIR = REPO_ROOT / "exp/diversity_check/wp0_lineage_descendant_yield"
SOURCE_TABLES = {"archive_cells.csv", "global_pareto_archive.csv"}
EDGE_FIELDS = (
    "root",
    "relative_path",
    "source_table",
    "method_name",
    "seed_dir",
    "benchmark",
    "problem",
    "child_id",
    "parent_id",
    "parent_found",
    "child_generation",
    "parent_generation",
    "generation_delta",
    "child_strategy",
    "parent_strategy",
    "child_quality",
    "parent_quality",
    "quality_delta",
    "child_cell_id",
    "parent_cell_id",
    "new_cell",
    "child_pareto_rank",
    "parent_pareto_rank",
)


def main() -> None:
    args = parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    edges = lineage_edges(args.lineage_files_csv)
    parent_yield = parent_yield_rows(edges)
    aggregate = aggregate_rows(edges)
    write_csv(args.output_dir / "lineage_edges.csv", edges)
    write_csv(args.output_dir / "lineage_parent_yield.csv", parent_yield)
    write_csv(args.output_dir / "lineage_aggregate.csv", aggregate)
    summary = build_summary(args.output_dir, edges, parent_yield, aggregate)
    (args.output_dir / "lineage_yield_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    write_markdown(args.output_dir / "lineage_yield_report.md", summary, aggregate)
    print(json.dumps(summary, indent=2, sort_keys=True))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--lineage-files-csv",
        type=Path,
        default=DEFAULT_AUDIT_CSV,
        help="lineage_source_files.csv from audit_rtl_diversity_lineage_sources.py.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="Directory for lineage edge and yield artifacts.",
    )
    return parser.parse_args()


def lineage_edges(lineage_files_csv: Path) -> list[dict[str, object]]:
    assert lineage_files_csv.is_file(), f"missing audit CSV: {lineage_files_csv}"
    files = pd.read_csv(lineage_files_csv)
    rows = []
    for _, file_row in files.iterrows():
        path = Path(str(file_row["path"]))
        if path.name not in SOURCE_TABLES:
            continue
        if int(file_row["lineage_nonempty_cells"]) == 0:
            continue
        table = pd.read_csv(path)
        candidates = {
            str(row["candidate_id"]): row
            for _, row in table.iterrows()
            if nonempty(row.get("candidate_id"))
        }
        meta = source_meta(str(file_row["root"]), str(file_row["relative_path"]))
        for _, child in table.iterrows():
            child_id = str(child["candidate_id"])
            for parent_id in parse_parent_ids(child["parent_ids_json"]):
                parent = candidates.get(parent_id)
                rows.append(edge_row(file_row, meta, path.name, child_id, parent_id, child, parent))
    return rows


def edge_row(
    file_row: pd.Series,
    meta: dict[str, str],
    source_table: str,
    child_id: str,
    parent_id: str,
    child: pd.Series,
    parent: pd.Series | None,
) -> dict[str, object]:
    child_quality = finite_float(child.get("quality_score"))
    parent_quality = finite_float(parent.get("quality_score") if parent is not None else None)
    child_generation = finite_int(child.get("generation"))
    parent_generation = finite_int(parent.get("generation") if parent is not None else None)
    child_cell = str(child.get("cell_id", ""))
    parent_cell = str(parent.get("cell_id", "")) if parent is not None else ""
    return {
        "root": str(file_row["root"]),
        "relative_path": str(file_row["relative_path"]),
        "source_table": source_table,
        "method_name": meta["method_name"],
        "seed_dir": meta["seed_dir"],
        "benchmark": meta["benchmark"],
        "problem": meta["problem"],
        "child_id": child_id,
        "parent_id": parent_id,
        "parent_found": parent is not None,
        "child_generation": child_generation,
        "parent_generation": parent_generation,
        "generation_delta": (
            child_generation - parent_generation
            if child_generation is not None and parent_generation is not None
            else ""
        ),
        "child_strategy": str(child.get("strategy", "")),
        "parent_strategy": str(parent.get("strategy", "")) if parent is not None else "",
        "child_quality": child_quality if child_quality is not None else "",
        "parent_quality": parent_quality if parent_quality is not None else "",
        "quality_delta": (
            child_quality - parent_quality
            if child_quality is not None and parent_quality is not None
            else ""
        ),
        "child_cell_id": child_cell,
        "parent_cell_id": parent_cell,
        "new_cell": parent is not None and child_cell != parent_cell,
        "child_pareto_rank": finite_int(child.get("pareto_rank")),
        "parent_pareto_rank": finite_int(parent.get("pareto_rank") if parent is not None else None),
    }


def parent_yield_rows(edges: list[dict[str, object]]) -> list[dict[str, object]]:
    frame = pd.DataFrame(edges)
    if frame.empty:
        return []
    rows = []
    groups = frame.groupby(
        [
            "source_table",
            "method_name",
            "seed_dir",
            "benchmark",
            "problem",
            "parent_id",
        ],
        sort=True,
    )
    for keys, group in groups:
        source_table, method, seed, benchmark, problem, parent_id = keys
        rows.append(
            {
                "source_table": source_table,
                "method_name": method,
                "seed_dir": seed,
                "benchmark": benchmark,
                "problem": problem,
                "parent_id": parent_id,
                "child_edge_count": int(len(group)),
                "parent_found": bool(group["parent_found"].any()),
                "new_cell_child_count": int(group["new_cell"].sum()),
                "positive_quality_delta_count": positive_count(group["quality_delta"]),
                "best_child_quality": finite_max(group["child_quality"]),
                "mean_child_quality": finite_mean(group["child_quality"]),
                "best_quality_delta": finite_max(group["quality_delta"]),
                "mean_quality_delta": finite_mean(group["quality_delta"]),
            }
        )
    return rows


def aggregate_rows(edges: list[dict[str, object]]) -> list[dict[str, object]]:
    frame = pd.DataFrame(edges)
    if frame.empty:
        return []
    rows = []
    for keys, group in frame.groupby(["source_table", "method_name"], sort=True):
        source_table, method = keys
        rows.append(
            {
                "source_table": source_table,
                "method_name": method,
                "edge_count": int(len(group)),
                "parent_found_edges": int(group["parent_found"].sum()),
                "parent_found_rate": rate(group["parent_found"].sum(), len(group)),
                "unique_parent_count": int(group["parent_id"].nunique()),
                "new_cell_edges": int(group["new_cell"].sum()),
                "positive_quality_delta_edges": positive_count(group["quality_delta"]),
                "mean_quality_delta": finite_mean(group["quality_delta"]),
                "best_quality_delta": finite_max(group["quality_delta"]),
            }
        )
    return rows


def build_summary(
    output_dir: Path,
    edges: list[dict[str, object]],
    parent_yield: list[dict[str, object]],
    aggregate: list[dict[str, object]],
) -> dict[str, object]:
    edge_frame = pd.DataFrame(edges)
    return {
        "version": 1,
        "output_dir": output_dir.as_posix(),
        "edge_count": len(edges),
        "parent_yield_rows": len(parent_yield),
        "aggregate_rows": len(aggregate),
        "parent_found_edges": int(edge_frame["parent_found"].sum()) if edges else 0,
        "positive_quality_delta_edges": (
            positive_count(edge_frame["quality_delta"]) if edges else 0
        ),
        "new_cell_edges": int(edge_frame["new_cell"].sum()) if edges else 0,
        "artifacts": {
            "lineage_edges_csv": (output_dir / "lineage_edges.csv").as_posix(),
            "lineage_parent_yield_csv": (
                output_dir / "lineage_parent_yield.csv"
            ).as_posix(),
            "lineage_aggregate_csv": (output_dir / "lineage_aggregate.csv").as_posix(),
            "lineage_yield_report_md": (
                output_dir / "lineage_yield_report.md"
            ).as_posix(),
        },
    }


def write_markdown(
    path: Path,
    summary: dict[str, object],
    aggregate: list[dict[str, object]],
) -> None:
    lines = [
        "# RTL Diversity Lineage Yield Analysis",
        "",
        f"- Edge count: {summary['edge_count']}",
        f"- Parent-yield rows: {summary['parent_yield_rows']}",
        f"- Parent-found edges: {summary['parent_found_edges']}",
        f"- Positive quality-delta edges: {summary['positive_quality_delta_edges']}",
        f"- New-cell edges: {summary['new_cell_edges']}",
        "",
        "## Aggregate",
        "",
        markdown_table(aggregate),
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def source_meta(root: str, relative_path: str) -> dict[str, str]:
    parts = Path(relative_path).parts
    if "main_screening_screening_seed3" in root:
        return {
            "method_name": parts[0],
            "seed_dir": parts[1],
            "benchmark": parts[-3],
            "problem": parts[-2],
        }
    return {
        "method_name": "",
        "seed_dir": "",
        "benchmark": parts[-3] if len(parts) >= 3 else "",
        "problem": parts[-2] if len(parts) >= 2 else "",
    }


def parse_parent_ids(value: Any) -> list[str]:
    if not nonempty(value):
        return []
    if isinstance(value, str):
        parsed = json.loads(value)
        assert isinstance(parsed, list)
        return [str(item) for item in parsed]
    if isinstance(value, list):
        return [str(item) for item in value]
    raise AssertionError(f"unexpected parent field: {value!r}")


def finite_float(value: Any) -> float | None:
    parsed = pd.to_numeric(value, errors="coerce")
    if pd.isna(parsed):
        return None
    return float(parsed)


def finite_int(value: Any) -> int | None:
    parsed = finite_float(value)
    return int(parsed) if parsed is not None else None


def finite_values(values: pd.Series) -> list[float]:
    parsed = pd.to_numeric(values, errors="coerce")
    return [float(value) for value in parsed if not math.isnan(float(value))]


def finite_max(values: pd.Series) -> float | str:
    finite = finite_values(values)
    return max(finite) if finite else ""


def finite_mean(values: pd.Series) -> float | str:
    finite = finite_values(values)
    return sum(finite) / len(finite) if finite else ""


def positive_count(values: pd.Series) -> int:
    return sum(int(value > 0) for value in finite_values(values))


def rate(numerator: int | float, denominator: int) -> float:
    return float(numerator) / denominator if denominator else 0.0


def nonempty(value: Any) -> bool:
    if value is None:
        return False
    if isinstance(value, float) and pd.isna(value):
        return False
    if isinstance(value, str):
        text = value.strip()
        return text not in {"", "[]", "{}", "None", "nan", "NaN"}
    if isinstance(value, list | tuple | dict | set):
        return len(value) > 0
    return True


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    fieldnames = sorted({key for row in rows for key in row}) if rows else list(EDGE_FIELDS)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def markdown_table(rows: list[dict[str, object]]) -> str:
    if not rows:
        return "_No rows._"
    columns = list(rows[0])
    lines = [
        "| " + " | ".join(columns) + " |",
        "| " + " | ".join("---" for _ in columns) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(row[column]) for column in columns) + " |")
    return "\n".join(lines)


if __name__ == "__main__":
    main()
