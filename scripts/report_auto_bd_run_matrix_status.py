#!/usr/bin/env python3
"""Report completion status for an Auto-BD run matrix."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parents[1]
SCAFFOLD_DIR = (
    REPO_ROOT
    / "docs"
    / "journal_features"
    / "revamp_history"
    / "20260618_232234_KST_auto_bd_research"
)
DEFAULT_MATRIX = SCAFFOLD_DIR / "auto_bd_main_screening_run_matrix.json"
DEFAULT_OUTPUT_JSON = SCAFFOLD_DIR / "auto_bd_main_screening_run_status.json"
DEFAULT_OUTPUT_MD = SCAFFOLD_DIR / "auto_bd_main_screening_run_status.md"
RESULT_FILES = {
    "candidates.parquet",
    "elites.parquet",
    "archive_snapshots.parquet",
    "per_generation_metrics.parquet",
    "per_problem_metrics.parquet",
    "descriptor_vectors.parquet",
    "netlist_hashes.parquet",
    "method_summary.json",
    "run_manifest.json",
}


def build_status(matrix_path: Path) -> dict[str, Any]:
    """Build a run-status payload from one matrix JSON file."""

    matrix = load_json(matrix_path)
    entries = list_at(matrix, "entries")
    manifest_rows = manifest_status_rows(list_at(matrix, "manifest_commands"))
    entry_rows = [entry_status(row) for row in entries]
    arm_seed_rows = arm_seed_status_rows(entry_rows)
    return {
        "version": 1,
        "matrix_path": rel(matrix_path),
        "phase": matrix["phase"],
        "arms": matrix["arms"],
        "manifest_summary": count_statuses(manifest_rows),
        "entry_summary": count_statuses(entry_rows),
        "arm_seed_summary": count_statuses(arm_seed_rows),
        "manifest_status": manifest_rows,
        "entry_status": entry_rows,
        "arm_seed_status": arm_seed_rows,
        "next_pending_commands": next_pending_commands(entry_rows),
    }


def manifest_status_rows(rows: list[Any]) -> list[dict[str, Any]]:
    output = []
    for row in rows:
        assert isinstance(row, dict)
        command = str(row["command_string"])
        output_path = Path(command.split(" --output ", 1)[1])
        output.append(
            {
                "arm_name": row["arm_name"],
                "seed": int(row["seed"]),
                "status": "complete" if output_path.is_file() else "pending",
                "run_manifest_path": rel(output_path),
                "command_string": command,
            }
        )
    return output


def entry_status(row: Any) -> dict[str, Any]:
    assert isinstance(row, dict)
    save_path = Path(str(row["save_path"]))
    benchmark = str(row["benchmark"])
    completed = [
        str(problem)
        for problem in row["problems"]
        if problem_summary_path(save_path, benchmark, str(problem)).is_file()
    ]
    missing = [
        str(problem)
        for problem in row["problems"]
        if str(problem) not in completed
    ]
    if len(completed) == len(row["problems"]):
        status = "complete"
    elif save_path.exists():
        status = "partial"
    else:
        status = "pending"
    return {
        "arm_name": row["arm_name"],
        "phase": row["phase"],
        "seed": int(row["seed"]),
        "benchmark": benchmark,
        "status": status,
        "completed_problem_count": len(completed),
        "problem_count": len(row["problems"]),
        "completed_problems": completed,
        "missing_problems": missing,
        "save_path": rel(save_path),
        "command_string": row["command_string"],
    }


def arm_seed_status_rows(entry_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    groups: dict[tuple[str, int], list[dict[str, Any]]] = {}
    for row in entry_rows:
        groups.setdefault((str(row["arm_name"]), int(row["seed"])), []).append(row)

    output = []
    for (arm_name, seed), rows in sorted(groups.items()):
        save_path = Path(str(rows[0]["save_path"]))
        seed_root = save_path
        standard_dir = seed_root / "standard_results"
        statuses = {str(row["status"]) for row in rows}
        if statuses == {"complete"}:
            status = "standard_results_complete" if standard_results_complete(standard_dir) else "runs_complete"
        elif "partial" in statuses or "complete" in statuses:
            status = "partial"
        else:
            status = "pending"
        output.append(
            {
                "arm_name": arm_name,
                "seed": seed,
                "status": status,
                "benchmark_groups_complete": sum(
                    1 for row in rows if row["status"] == "complete"
                ),
                "benchmark_group_count": len(rows),
                "standard_results_path": rel(standard_dir),
                "save_path": rel(seed_root),
            }
        )
    return output


def problem_summary_path(save_path: Path, benchmark: str, problem: str) -> Path:
    return (
        save_path
        / "revolution"
        / "openai_gpt-oss-120b"
        / benchmark
        / problem
        / f"{problem}_summary.json"
    )


def standard_results_complete(path: Path) -> bool:
    if not path.is_dir():
        return False
    return RESULT_FILES <= {item.name for item in path.iterdir()}


def count_statuses(rows: list[dict[str, Any]]) -> dict[str, int]:
    output: dict[str, int] = {"total": len(rows)}
    for row in rows:
        status = str(row["status"])
        output[status] = output.get(status, 0) + 1
    return output


def next_pending_commands(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    return [
        {
            "arm_name": row["arm_name"],
            "seed": row["seed"],
            "benchmark": row["benchmark"],
            "command_string": row["command_string"],
        }
        for row in rows
        if row["status"] != "complete"
    ][:4]


def render_markdown(payload: dict[str, Any]) -> str:
    lines = [
        "# Auto-BD Main Screening Run Status",
        "",
        f"- Matrix: `{payload['matrix_path']}`",
        f"- Phase: `{payload['phase']}`",
        f"- Arms: {', '.join(f'`{arm}`' for arm in payload['arms'])}",
        "",
        "## Summary",
        "",
        markdown_table(
            ["Level", "Total", "Complete", "Partial", "Pending", "Runs Complete", "Standard Results"],
            [
                summary_row("Manifest", payload["manifest_summary"]),
                summary_row("Benchmark Command", payload["entry_summary"]),
                summary_row("Arm/Seed", payload["arm_seed_summary"]),
            ],
        ),
        "",
        "## Arm / Seed Status",
        "",
        markdown_table(
            ["Arm", "Seed", "Status", "Benchmark Groups", "Standard Results"],
            [
                [
                    code(row["arm_name"]),
                    row["seed"],
                    code(row["status"]),
                    f"{row['benchmark_groups_complete']}/{row['benchmark_group_count']}",
                    code(row["standard_results_path"]),
                ]
                for row in payload["arm_seed_status"]
            ],
        ),
        "",
        "## Next Pending Commands",
        "",
    ]
    for row in payload["next_pending_commands"]:
        lines.extend(
            [
                f"- `{row['arm_name']}` seed `{row['seed']}` `{row['benchmark']}`:",
                "",
                "```bash",
                row["command_string"],
                "```",
                "",
            ]
        )
    return "\n".join(lines).rstrip() + "\n"


def summary_row(label: str, summary: dict[str, int]) -> list[object]:
    return [
        label,
        summary.get("total", 0),
        summary.get("complete", 0),
        summary.get("partial", 0),
        summary.get("pending", 0),
        summary.get("runs_complete", 0),
        summary.get("standard_results_complete", 0),
    ]


def markdown_table(headers: list[str], rows: list[list[object]]) -> str:
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(value) for value in row) + " |")
    return "\n".join(lines)


def code(value: object) -> str:
    return f"`{value}`"


def load_json(path: Path) -> dict[str, Any]:
    assert path.is_file(), f"missing JSON file: {path}"
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict), f"JSON root must be a mapping: {path}"
    return payload


def list_at(payload: dict[str, Any], key: str) -> list[Any]:
    value = payload[key]
    assert isinstance(value, list), f"{key} must be a list"
    return value


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def rel(path: Path) -> str:
    if path.is_absolute() and path.is_relative_to(REPO_ROOT):
        return path.relative_to(REPO_ROOT).as_posix()
    return path.as_posix()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--matrix", type=Path, default=DEFAULT_MATRIX)
    parser.add_argument("--output-json", type=Path, default=DEFAULT_OUTPUT_JSON)
    parser.add_argument("--output-md", type=Path, default=DEFAULT_OUTPUT_MD)
    args = parser.parse_args(argv)

    payload = build_status(args.matrix)
    write_json(args.output_json, payload)
    args.output_md.parent.mkdir(parents=True, exist_ok=True)
    args.output_md.write_text(render_markdown(payload), encoding="utf-8")
    print(f"Auto-BD run status -> {args.output_md}")
    print(f"Auto-BD run status data -> {args.output_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
