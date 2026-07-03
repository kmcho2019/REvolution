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


def _write_problem(
    path: Path,
    rows: list[dict[str, float]],
    cell_mode: str = "pareto_front",
) -> None:
    problem_root = path / "grid_quantile_pareto_journal_bd" / "RTLLM" / "Prob004_adder_8bit"
    problem_root.mkdir(parents=True)
    summary = {
        "archive_type": "grid_quantile",
        "cell_mode": cell_mode,
        "descriptor_profile": "journal_logic_ff_width_3d",
        "objective_names": ["g_P", "g_A"],
        "occupied_cells": 1,
        "total_archive_members": len(rows),
        "max_elites_per_cell": 5,
        "max_front_size": len(rows),
        "global_pareto_size": len(rows),
    }
    (problem_root / "archive_summary.json").write_text(
        json.dumps(summary, indent=2),
        encoding="utf-8",
    )
    history = {
        "occupied_cells": 1,
        "total_archive_members": len(rows),
        "max_front_size": len(rows),
        "global_pareto_size": len(rows),
    }
    (problem_root / "archive_history.jsonl").write_text(json.dumps(history) + "\n", encoding="utf-8")
    with (problem_root / "archive_cells.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "cell_id",
                "member_index",
                "cell_member_count",
                "front_size",
                "pareto_rank",
                "crowding_distance",
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
                    "cell_member_count": len(rows),
                    "front_size": len(rows),
                    "pareto_rank": row.get("pareto_rank", 1),
                    "crowding_distance": "inf",
                    "candidate_id": f"cand-{index}",
                    "quality_score": row["quality_score"],
                    "g_P": row["g_P"],
                    "g_A": row["g_A"],
                    "g_T": 0.0,
                    "objectives_json": json.dumps(objectives),
                    "descriptors_json": "[1.0, 0.0, 2.0]",
                }
            )
    global_rows = [
        row
        for row in rows
        if not any(
            other is not row
            and other["g_P"] >= row["g_P"]
            and other["g_A"] >= row["g_A"]
            and (other["g_P"] > row["g_P"] or other["g_A"] > row["g_A"])
            for other in rows
        )
    ]
    with (problem_root / "global_pareto_archive.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "candidate_id",
                "benchmark",
                "problem",
                "objectives_json",
                "descriptors_json",
            ],
        )
        writer.writeheader()
        for index, row in enumerate(global_rows):
            objectives = {"g_P": row["g_P"], "g_A": row["g_A"]}
            writer.writerow(
                {
                    "candidate_id": f"cand-{index}",
                    "benchmark": "RTLLM",
                    "problem": "Prob004_adder_8bit",
                    "objectives_json": json.dumps(objectives),
                    "descriptors_json": "[1.0, 0.0, 2.0]",
                }
            )
    (problem_root / "global_pareto_summary.json").write_text(
        json.dumps({"total_global_pareto_members": len(global_rows)}),
        encoding="utf-8",
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


def test_validate_pareto_front_run_accepts_elite_pareto_slot(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_problem(
        tmp_path,
        [
            {"quality_score": 10.0, "g_P": 0.1, "g_A": 0.1, "pareto_rank": 2},
            {"quality_score": 0.9, "g_P": 0.9, "g_A": 0.1, "pareto_rank": 1},
        ],
        cell_mode="elite_pareto_slot",
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
    assert exit_code == 0
    assert payload["failure_count"] == 0


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


def test_validate_pareto_front_run_accepts_ranked_dominated_member(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_problem(
        tmp_path,
        [
            {"quality_score": 0.1, "g_P": 0.9, "g_A": 0.9, "pareto_rank": 1},
            {"quality_score": 0.9, "g_P": 0.1, "g_A": 0.1, "pareto_rank": 2},
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
    assert exit_code == 0
    assert payload["failure_count"] == 0
