import csv
import json
from pathlib import Path

from scripts.validate_pareto_front_run import main as validate_pareto_main


def _subset_config(path: Path) -> Path:
    config_path = path / "subset.yaml"
    config_path.write_text(
        "selected_problems:\n"
        "  - benchmark: RTLLM\n"
        "    problem: Prob004_adder_8bit\n",
        encoding="utf-8",
    )
    return config_path


def _write_problem(path: Path, rows: list[dict[str, float]]) -> None:
    problem_root = path / "grid_quantile_pareto_journal_bd" / "RTLLM" / "Prob004_adder_8bit"
    problem_root.mkdir(parents=True)
    summary = {
        "archive_type": "grid_quantile",
        "cell_mode": "pareto_front",
        "descriptor_profile": "journal_logic_ff_width_3d",
        "objective_names": ["g_P", "g_A"],
        "occupied_cells": 1,
        "total_archive_members": len(rows),
        "max_elites_per_cell": 5,
        "max_front_size": len(rows),
    }
    (problem_root / "archive_summary.json").write_text(
        json.dumps(summary, indent=2),
        encoding="utf-8",
    )
    history = {
        "occupied_cells": 1,
        "total_archive_members": len(rows),
        "max_front_size": len(rows),
    }
    (problem_root / "archive_history.jsonl").write_text(json.dumps(history) + "\n", encoding="utf-8")
    with (problem_root / "archive_cells.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "cell_id",
                "member_index",
                "front_size",
                "candidate_id",
                "quality_score",
                "g_P",
                "g_A",
                "g_T",
                "objectives_json",
                "descriptors_json",
            ],
        )
        writer.writeheader()
        for index, row in enumerate(rows):
            objectives = {"g_P": row["g_P"], "g_A": row["g_A"]}
            writer.writerow(
                {
                    "cell_id": "0,0,0",
                    "member_index": index,
                    "front_size": len(rows),
                    "candidate_id": f"cand-{index}",
                    "quality_score": row["quality_score"],
                    "g_P": row["g_P"],
                    "g_A": row["g_A"],
                    "g_T": 0.0,
                    "objectives_json": json.dumps(objectives),
                    "descriptors_json": "[1.0, 0.0, 2.0]",
                }
            )


def _write_classic_problem(path: Path) -> None:
    problem_root = path / "classic" / "RTLLM" / "Prob004_adder_8bit"
    problem_root.mkdir(parents=True)
    (problem_root / "Prob004_adder_8bit_summary.json").write_text(
        json.dumps({"problem": "Prob004_adder_8bit"}),
        encoding="utf-8",
    )


def test_validate_pareto_front_run_accepts_multi_member_front(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_problem(
        tmp_path,
        [
            {"quality_score": 0.1, "g_P": 0.9, "g_A": 0.1},
            {"quality_score": 0.9, "g_P": 0.1, "g_A": 0.9},
        ],
    )

    exit_code = validate_pareto_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--pareto-qd-mode",
            "grid_quantile_pareto_journal_bd",
            "--acceptance-hard-subset",
        ]
    )

    assert exit_code == 0
    payload = json.loads((tmp_path / "pareto_front_validation.json").read_text(encoding="utf-8"))
    assert payload["failure_count"] == 0
    assert payload["max_front_size_seen"] == 2
    assert (tmp_path / "pareto_front_validation.md").is_file()


def test_validate_pareto_front_run_accepts_classic_problem_summary(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_classic_problem(tmp_path)
    _write_problem(
        tmp_path,
        [
            {"quality_score": 0.1, "g_P": 0.9, "g_A": 0.1},
            {"quality_score": 0.9, "g_P": 0.1, "g_A": 0.9},
        ],
    )

    exit_code = validate_pareto_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--classic-mode",
            "classic",
            "--pareto-qd-mode",
            "grid_quantile_pareto_journal_bd",
            "--require-full-subset",
            "--acceptance-hard-subset",
        ]
    )

    payload = json.loads((tmp_path / "pareto_front_validation.json").read_text(encoding="utf-8"))
    assert exit_code == 0
    assert payload["acceptance_error_count"] == 0


def test_validate_pareto_front_run_rejects_dominated_same_cell_member(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_problem(
        tmp_path,
        [
            {"quality_score": 0.1, "g_P": 0.9, "g_A": 0.9},
            {"quality_score": 0.9, "g_P": 0.1, "g_A": 0.1},
        ],
    )

    exit_code = validate_pareto_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--pareto-qd-mode",
            "grid_quantile_pareto_journal_bd",
        ]
    )

    payload = json.loads((tmp_path / "pareto_front_validation.json").read_text(encoding="utf-8"))
    assert exit_code == 1
    assert payload["failure_count"] > 0
    assert "dominates" in json.dumps(payload)
