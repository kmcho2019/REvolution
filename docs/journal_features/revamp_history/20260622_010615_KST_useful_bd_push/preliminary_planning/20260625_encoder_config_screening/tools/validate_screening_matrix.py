#!/usr/bin/env python3
"""Validate the preliminary screening command matrix."""

from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any


PACKAGE = Path(__file__).resolve().parents[1]
TABLES = PACKAGE / "tables"
REQUIRED_ARMS = {
    "classic_revolution_8x5",
    "code_thought_sr_front_slot_8x5",
    "masterrtl_structural_mix_8x5",
}
COMMON_FLAGS = {
    "--population_size 8",
    "--num_generations 5",
    "--max_tokens 128000",
    "--diff_max_tokens 128000",
    "--vllm_min_model_len 128000",
    "--total_worker_slots 32",
    "--max_active_problems 8",
    "--max_workers_per_problem 4",
}
QD_FLAGS = {
    "--search_mode revolution_qd",
    "--qd_archive_type grid_quantile",
    "--qd_cell_mode elite_pareto_slot",
    "--qd_champion_lane_fraction 0.80",
    "--qd_two_parent_probability 0.0",
}


def main() -> None:
    rows = read_csv(TABLES / "screening_matrix.csv")
    arms = {row["arm"] for row in rows}
    assert arms == REQUIRED_ARMS, arms
    for row in rows:
        args = row["command_args"]
        for flag in COMMON_FLAGS:
            assert flag in args, (row["arm"], flag)
        if row["stage"] == "screen":
            for flag in QD_FLAGS:
                assert flag in args, (row["arm"], flag)
    subset_rows = read_csv(TABLES / "prelim_screen_subset.csv")
    assert len(subset_rows) == 8
    write_json(
        TABLES / "screening_matrix_validation.json",
        {
            "status": "pass",
            "arms": sorted(arms),
            "subset_size": len(subset_rows),
            "checks": sorted(COMMON_FLAGS | QD_FLAGS),
        },
    )


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        return list(csv.DictReader(handle))


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
