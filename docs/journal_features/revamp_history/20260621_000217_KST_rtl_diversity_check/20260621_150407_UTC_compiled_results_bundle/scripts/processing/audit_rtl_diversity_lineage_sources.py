#!/usr/bin/env python3
"""Audit RTL diversity artifacts for recoverable parent-child lineage."""

from __future__ import annotations

import argparse
import csv
import json
from collections.abc import Iterable
from pathlib import Path
from typing import Any

import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT_DIR = REPO_ROOT / "exp/diversity_check/wp0_lineage_source_audit"
DEFAULT_ROOTS = (
    REPO_ROOT
    / "exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp",
    Path(
        "/aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/"
        "revolution/_models_openai-gpt-oss-120b/RTLLM"
    ),
    Path(
        "/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/"
        "exp/auto_bd_research/main_screening_screening_seed3"
    ),
    Path("/home/kmcho/1_RESEARCH/2026_Revolution_Journal_Ext/code_repo/REvolution"),
    Path("/home/kmcho/1_RESEARCH/2026_REvolution_Journal_Ext/code_repo/REvolution"),
)
LINEAGE_KEYS = {
    "parent_id",
    "parent_ids",
    "parent_ids_json",
    "parent_candidate",
    "parent_candidate_id",
    "parent_candidates",
    "ancestor",
    "ancestor_id",
    "ancestor_ids",
    "lineage",
    "lineage_id",
}
GENERATION_KEYS = {"generation", "generation_num", "step", "epoch"}
OPERATOR_KEYS = {
    "operator",
    "operator_name",
    "strategy",
    "generated_mode",
    "origin_pool",
    "parent_count",
    "requested_parent_count",
}
TABULAR_NAMES = {
    "archive_snapshots.parquet",
    "candidates.parquet",
    "per_generation_metrics.parquet",
}
CSV_NAME_MARKERS = (
    "archive",
    "candidate",
    "catalog",
    "event",
    "lineage",
    "visualization",
)


def main() -> None:
    args = parse_args()
    output_dir = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)
    roots = tuple(args.roots) if args.roots else DEFAULT_ROOTS
    root_rows = [root_row(root) for root in roots]
    file_rows = []
    for root in roots:
        if root.is_dir():
            for path in iter_artifact_paths(root):
                file_rows.append(file_row(root, path))
    write_csv(output_dir / "lineage_source_files.csv", file_rows)
    write_csv(output_dir / "lineage_source_roots.csv", root_rows)
    summary = build_summary(output_dir, root_rows, file_rows)
    (output_dir / "lineage_source_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    write_markdown(output_dir / "lineage_source_audit.md", summary, file_rows)
    print(json.dumps(summary, indent=2, sort_keys=True))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--root",
        dest="roots",
        action="append",
        type=Path,
        default=[],
        help="Artifact root to scan. Defaults to the restart audit roots.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="Directory for CSV, JSON, and Markdown audit outputs.",
    )
    return parser.parse_args()


def root_row(root: Path) -> dict[str, object]:
    return {
        "root": root.as_posix(),
        "exists": root.exists(),
        "is_dir": root.is_dir(),
    }


def iter_artifact_paths(root: Path) -> Iterable[Path]:
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        if path.name == "generation_log.jsonl":
            yield path
        elif path.name == "qd_archive_event.json":
            yield path
        elif path.name in TABULAR_NAMES:
            yield path
        elif path.suffix == ".csv" and any(marker in path.name for marker in CSV_NAME_MARKERS):
            yield path


def file_row(root: Path, path: Path) -> dict[str, object]:
    records, columns, read_status, read_error = read_records(path)
    field_counts: dict[str, int] = {}
    lineage_nonempty = 0
    lineage_edges = 0
    generation_nonempty = 0
    operator_nonempty = 0
    for record in records:
        flat = flatten_record(record)
        for key, value in flat.items():
            field = key.split(".")[-1]
            if field in LINEAGE_KEYS:
                field_counts[field] = field_counts.get(field, 0) + 1
                if nonempty(value):
                    lineage_nonempty += 1
                    lineage_edges += edge_count(value)
            if field in GENERATION_KEYS and nonempty(value):
                generation_nonempty += 1
            if field in OPERATOR_KEYS and nonempty(value):
                operator_nonempty += 1
    lineage_columns = sorted(set(columns).intersection(LINEAGE_KEYS))
    return {
        "root": root.as_posix(),
        "path": path.as_posix(),
        "relative_path": path.relative_to(root).as_posix(),
        "file_kind": file_kind(path),
        "read_status": read_status,
        "read_error": read_error,
        "record_count": len(records),
        "column_count": len(columns),
        "lineage_columns": json.dumps(lineage_columns),
        "lineage_field_counts": json.dumps(field_counts, sort_keys=True),
        "lineage_nonempty_cells": lineage_nonempty,
        "lineage_edge_count": lineage_edges,
        "generation_nonempty_cells": generation_nonempty,
        "operator_nonempty_cells": operator_nonempty,
    }


def read_records(path: Path) -> tuple[list[dict[str, Any]], list[str], str, str]:
    try:
        if path.name == "generation_log.jsonl":
            records = read_jsonl(path)
        elif path.name == "qd_archive_event.json":
            records = [json.loads(path.read_text(encoding="utf-8"))]
        elif path.suffix == ".parquet":
            frame = pd.read_parquet(path)
            return frame.to_dict("records"), list(frame.columns), "ok", ""
        else:
            frame = pd.read_csv(path, dtype=str, nrows=None)
            return frame.to_dict("records"), list(frame.columns), "ok", ""
        columns = sorted({key for record in records for key in flatten_record(record)})
        return records, columns, "ok", ""
    except Exception as exc:  # pragma: no cover - corrupt external artifact
        return [], [], "failed", f"{type(exc).__name__}: {exc}"


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            obj = json.loads(line)
            assert isinstance(obj, dict)
            rows.append(obj)
    return rows


def flatten_record(record: dict[str, Any]) -> dict[str, Any]:
    flat: dict[str, Any] = {}
    visit_record("", record, flat)
    return flat


def visit_record(prefix: str, value: Any, flat: dict[str, Any]) -> None:
    if isinstance(value, dict):
        for key, child in value.items():
            child_key = f"{prefix}.{key}" if prefix else str(key)
            visit_record(child_key, child, flat)
    elif isinstance(value, list):
        flat[prefix] = value
        for index, child in enumerate(value):
            child_key = f"{prefix}.{index}" if prefix else str(index)
            visit_record(child_key, child, flat)
    else:
        flat[prefix] = value


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


def edge_count(value: Any) -> int:
    if isinstance(value, list | tuple | set):
        return len(value)
    if isinstance(value, str) and value.strip().startswith("["):
        parsed = json.loads(value)
        assert isinstance(parsed, list)
        return len(parsed)
    return 1


def file_kind(path: Path) -> str:
    if path.name == "generation_log.jsonl":
        return "generation_log"
    if path.name == "qd_archive_event.json":
        return "qd_archive_event"
    if path.suffix == ".parquet":
        return "parquet_table"
    return "csv_table"


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    fieldnames = sorted({key for row in rows for key in row})
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def build_summary(
    output_dir: Path,
    root_rows: list[dict[str, object]],
    file_rows: list[dict[str, object]],
) -> dict[str, object]:
    readable = [row for row in file_rows if row["read_status"] == "ok"]
    lineage_files = [
        row for row in readable if int_field(row, "lineage_nonempty_cells") > 0
    ]
    return {
        "version": 1,
        "output_dir": output_dir.as_posix(),
        "root_count": len(root_rows),
        "existing_root_count": sum(int(bool_field(row, "is_dir")) for row in root_rows),
        "file_count": len(file_rows),
        "readable_file_count": len(readable),
        "lineage_file_count": len(lineage_files),
        "lineage_edge_count": sum(
            int_field(row, "lineage_edge_count") for row in readable
        ),
        "generation_file_count": sum(
            int(int_field(row, "generation_nonempty_cells") > 0) for row in readable
        ),
        "operator_file_count": sum(
            int(int_field(row, "operator_nonempty_cells") > 0) for row in readable
        ),
        "roots": root_rows,
        "artifacts": {
            "lineage_source_files_csv": (
                output_dir / "lineage_source_files.csv"
            ).as_posix(),
            "lineage_source_roots_csv": (
                output_dir / "lineage_source_roots.csv"
            ).as_posix(),
            "lineage_source_audit_md": (
                output_dir / "lineage_source_audit.md"
            ).as_posix(),
        },
    }


def write_markdown(
    path: Path,
    summary: dict[str, object],
    file_rows: list[dict[str, object]],
) -> None:
    lineage = [
        row for row in file_rows if int_field(row, "lineage_nonempty_cells") > 0
    ]
    lines = [
        "# RTL Diversity Lineage Source Audit",
        "",
        f"- Existing roots: {summary['existing_root_count']}/{summary['root_count']}",
        f"- Scanned files: {summary['file_count']}",
        f"- Readable files: {summary['readable_file_count']}",
        f"- Files with non-empty lineage fields: {summary['lineage_file_count']}",
        f"- Recovered parent/lineage edges: {summary['lineage_edge_count']}",
        f"- Files with generation fields: {summary['generation_file_count']}",
        f"- Files with operator fields: {summary['operator_file_count']}",
        "",
        "## Interpretation",
        "",
        "The scanned corpora expose generation and operator summaries, but only "
        "files with non-empty lineage fields can support parent-child or "
        "descendant-yield claims.",
        "",
    ]
    if lineage:
        lines.extend(["## Lineage-Capable Files", ""])
        for row in lineage[:50]:
            lines.append(
                "- "
                f"`{row['path']}`: edges={row['lineage_edge_count']}, "
                f"fields={row['lineage_field_counts']}"
            )
    else:
        lines.extend(
            [
                "## Lineage-Capable Files",
                "",
                "None found in the scanned roots.",
            ]
        )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def int_field(row: dict[str, object], key: str) -> int:
    value = row[key]
    assert isinstance(value, int)
    return value


def bool_field(row: dict[str, object], key: str) -> bool:
    value = row[key]
    assert isinstance(value, bool)
    return value


if __name__ == "__main__":
    main()
