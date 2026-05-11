import csv
import importlib.util
import json
from pathlib import Path


SCRIPT_PATH = Path(__file__).resolve().parents[2] / "scripts" / "validate_two_tier_fail_pool_run.py"
SPEC = importlib.util.spec_from_file_location("validate_two_tier_fail_pool_run", SCRIPT_PATH)
assert SPEC is not None
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)
validate_two_tier_main = MODULE.main


def _subset_config(path: Path) -> Path:
    config_path = path / "subset.yaml"
    config_path.write_text(
        "selected_problems:\n"
        "  - benchmark: RTLLM\n"
        "    problem: Prob004_adder_8bit\n",
        encoding="utf-8",
    )
    return config_path


def _write_mode_stub(path: Path, mode: str) -> None:
    problem_root = path / mode / "RTLLM" / "Prob004_adder_8bit"
    problem_root.mkdir(parents=True)
    (problem_root / "Prob004_adder_8bit_summary.json").write_text(
        json.dumps({"problem": "Prob004_adder_8bit"}),
        encoding="utf-8",
    )


def _write_target_problem(
    path: Path,
    *,
    generated_counts: dict[str, int] | None = None,
) -> None:
    problem_root = path / "grid_quantile_pareto_journal_bd" / "RTLLM" / "Prob004_adder_8bit"
    problem_root.mkdir(parents=True)
    planned_counts = {"archive": 4, "fail_pool": 3, "seed": 3}
    generated_counts = generated_counts or {"archive": 4, "fail_pool": 3, "seed": 3}
    summary = {
        "archive_type": "grid_quantile",
        "cell_mode": "pareto_front",
        "descriptor_profile": "journal_logic_ff_width_3d",
        "objective_names": ["g_P", "g_A"],
        "occupied_cells": 1,
        "total_archive_members": 2,
        "archive_member_count": 2,
        "max_elites_per_cell": 5,
        "max_front_size": 2,
        "phase": "fill",
        "fail_pool_size": 3,
        "coverage_fail_share": 0.75,
        "p_fail_cap": 0.6,
        "effective_fail_share": 0.6,
        "total_budget": 10,
        "generated_candidate_count": 10,
        "planned_parent_source_counts": planned_counts,
        "generated_parent_source_counts": generated_counts,
    }
    (problem_root / "archive_summary.json").write_text(
        json.dumps(summary, indent=2),
        encoding="utf-8",
    )
    history = [
        {
            "phase": "warmup",
            "occupied_cells": 0,
            "total_archive_members": 0,
            "archive_member_count": 0,
            "fail_pool_size": 1,
        },
        summary,
    ]
    (problem_root / "archive_history.jsonl").write_text(
        "\n".join(json.dumps(row) for row in history) + "\n",
        encoding="utf-8",
    )
    with (problem_root / "archive_cells.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "cell_id",
                "member_index",
                "cell_member_count",
                "front_size",
                "candidate_id",
                "objectives_json",
            ],
        )
        writer.writeheader()
        for index in range(2):
            writer.writerow(
                {
                    "cell_id": "0,0,0",
                    "member_index": index,
                    "cell_member_count": 2,
                    "front_size": 2,
                    "candidate_id": f"cand-{index}",
                    "objectives_json": json.dumps({"g_P": 0.1 * index, "g_A": 0.2}),
                }
            )


def test_validate_two_tier_fail_pool_accepts_feature_fields(tmp_path):
    subset_config = _subset_config(tmp_path)
    for mode in ("classic", "grid_struct", "grid_quantile_journal_bd"):
        _write_mode_stub(tmp_path, mode)
    _write_target_problem(tmp_path)

    exit_code = validate_two_tier_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--pareto-journal-mode",
            "grid_quantile_pareto_journal_bd",
            "--require-full-subset",
        ]
    )

    payload = json.loads(
        (tmp_path / "two_tier_fail_pool_validation.json").read_text(encoding="utf-8")
    )
    assert exit_code == 0
    assert payload["failure_count"] == 0
    assert payload["initialized_generation_count"] == 1
    assert payload["capped_generation_count"] == 1
    assert (tmp_path / "two_tier_fail_pool_validation.md").is_file()


def test_validate_two_tier_fail_pool_rejects_unknown_source_label(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_target_problem(tmp_path, generated_counts={"archive": 4, "unknown": 6})

    exit_code = validate_two_tier_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--pareto-journal-mode",
            "grid_quantile_pareto_journal_bd",
        ]
    )

    payload = json.loads(
        (tmp_path / "two_tier_fail_pool_validation.json").read_text(encoding="utf-8")
    )
    assert exit_code == 1
    assert payload["failure_count"] > 0
    assert "unknown source labels" in payload["problems"][0]["errors"][0]
