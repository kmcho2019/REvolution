#!/usr/bin/env python3
"""Summarize the tiny live smoke run."""

from __future__ import annotations

import argparse
import csv
import json
from collections.abc import Iterable
from pathlib import Path
from typing import Any


PACKAGE = Path(__file__).resolve().parents[1]
TABLES = PACKAGE / "tables"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("smoke_root", type=Path)
    args = parser.parse_args()
    rows = [summarize_arm(path) for path in sorted(args.smoke_root.iterdir()) if path.is_dir()]
    write_csv(TABLES / "live_smoke_summary.csv", rows)
    (TABLES / "live_smoke_root.txt").write_text(str(args.smoke_root.resolve()) + "\n")


def summarize_arm(path: Path) -> dict[str, Any]:
    summary_path = one(path.glob("seed_1001/openai_gpt-oss-120b/RTLLM/Prob045_alu/Prob045_alu_summary.json"))
    summary = json.loads(summary_path.read_text())
    archive_path = summary_path.with_name("archive_summary.json")
    archive = json.loads(archive_path.read_text()) if archive_path.exists() else {}
    success_counts = summary["accumulated_strategy_counts_by_result"]["success"]
    fail_counts = summary["accumulated_strategy_counts_by_result"]["fail"]
    return {
        "arm": path.name,
        "problem": summary["problem_name"],
        "candidates": summary["total_candidates_generated"],
        "successes": sum(success_counts.values()),
        "failures": sum(fail_counts.values()),
        "synthesis_ppa_rate": summary["accumulated_success_rates"]["synthesis_ppa"],
        "best_score": summary["generation_statistics"][-1]["best_score"],
        "descriptor_profile": archive.get("descriptor_profile", ""),
        "global_pareto_size": archive.get("global_pareto_size", ""),
        "archive_history_length": archive.get("history_length", ""),
        "archive_initialized": archive.get("initialized", ""),
        "run_seconds": round(summary["total_runtime_seconds"], 2),
    }


def one(paths: Iterable[Path]) -> Path:
    items = list(paths)
    assert len(items) == 1, items
    return items[0]


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    main()
