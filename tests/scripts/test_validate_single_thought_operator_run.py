import csv
import json
from pathlib import Path

from scripts.validate_single_thought_operator_run import main as validate_main


def _subset_config(root: Path) -> Path:
    path = root / "subset.yaml"
    path.write_text(
        "selected_problems:\n"
        "  - benchmark: RTLLM\n"
        "    problem: Prob004_adder_8bit\n",
        encoding="utf-8",
    )
    return path


def _write_problem_summary(
    problem_root: Path,
    problem: str,
    mode: str,
    *,
    final_details: bool = True,
) -> None:
    operator_kind = (
        "single_thought_operator"
        if mode.endswith("_unified")
        else "eoh_strategies"
    )
    payload = {
        "problem_name": problem,
        "benchmark_name": "RTLLM",
        "accumulated_success_rates": {
            "functionality": 0.5,
            "synthesis_ppa": 0.25,
        },
        "final_population_ppa": {
            "best_score": 0.2,
            "average_score": 0.2,
            "best_metrics": {"area": 90.0, "power": 0.9},
        },
        "final_population_ppa_details": (
            [{"id": "child", "score": 0.2}] if final_details else []
        ),
        "ref_ppa_metric": {"area": 100.0, "power": 1.0},
        "backend_details": {
            "search_mode": "revolution_qd",
            "qd_config": {
                "operator": {
                    "kind": operator_kind,
                    "one_parent_fraction": 0.5,
                    "archive_context_size": 4,
                    "two_parent_allow_intra_bin": True,
                }
            },
        },
    }
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps(payload, indent=2),
        encoding="utf-8",
    )


def _write_archive_cells(problem_root: Path) -> None:
    (problem_root / "archive_summary.json").write_text(
        json.dumps(
            {
                "archive_type": "grid_quantile",
                "cell_mode": "pareto_front",
                "descriptor_profile": "journal_logic_ff_width_3d",
                "objective_names": ["g_P", "g_A"],
                "total_archive_members": 1,
                "occupied_cells": 1,
            }
        ),
        encoding="utf-8",
    )
    with (problem_root / "archive_cells.csv").open(
        "w",
        encoding="utf-8",
        newline="",
    ) as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "cell_id",
                "candidate_id",
                "quality_score",
                "strategy",
                "parent_count",
                "g_P",
                "g_A",
                "g_T",
            ],
        )
        writer.writeheader()
        writer.writerow(
            {
                "cell_id": "cell-0",
                "candidate_id": "child",
                "quality_score": 0.2,
                "strategy": "single_thought_operator",
                "parent_count": 1,
                "g_P": 0.1,
                "g_A": 0.1,
                "g_T": 0.0,
            }
        )


def _write_classic(root: Path) -> None:
    problem = "Prob004_adder_8bit"
    problem_root = root / "classic" / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    payload = {
        "problem_name": problem,
        "benchmark_name": "RTLLM",
        "accumulated_success_rates": {
            "functionality": 0.5,
            "synthesis_ppa": 0.25,
        },
        "final_population_ppa": {
            "best_score": 0.2,
            "average_score": 0.2,
            "best_metrics": {"area": 90.0, "power": 0.9},
        },
        "final_population_ppa_details": [{"id": "classic", "score": 0.2}],
        "ref_ppa_metric": {"area": 100.0, "power": 1.0},
    }
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps(payload),
        encoding="utf-8",
    )


def _write_qd(
    root: Path,
    mode: str,
    *,
    forbidden_context: bool = False,
    archive_cells: bool = True,
    final_details: bool = True,
) -> None:
    problem = "Prob004_adder_8bit"
    problem_root = root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    _write_problem_summary(
        problem_root,
        problem,
        mode,
        final_details=final_details,
    )
    if archive_cells:
        _write_archive_cells(problem_root)

    parent_dir = problem_root / "Gen0" / "parent"
    child_dir = problem_root / "Gen1" / "child"
    parent_dir.mkdir(parents=True)
    child_dir.mkdir(parents=True)
    parent_code = parent_dir / "code.sv"
    parent_code.write_text("module parent_code_sentinel; endmodule\n", encoding="utf-8")
    (parent_dir / "code_feedback.txt").write_text(
        "parent feedback sentinel text",
        encoding="utf-8",
    )
    (parent_dir / "qd_archive_event.json").write_text(
        json.dumps({"candidate_id": "parent", "cell_id": "cell-0"}),
        encoding="utf-8",
    )

    generated_rows = [
        {
            "generation": 0,
            "generated_candidates": [
                {
                    "id": "parent",
                    "strategy": "initial",
                    "parent_count": None,
                    "parent_arity": 0,
                    "origin_pool": "initial",
                    "status": "success",
                    "generated_mode": "whole",
                    "code_file_path": str(parent_code),
                }
            ],
        },
        {
            "generation": 1,
            "population_ppa_details": [
                {
                    "id": "child",
                    "strategy": "single_thought_operator",
                    "parent_count": 1,
                    "requested_parent_count": 1,
                    "score": 0.2,
                    "ppa_metrics": {"area": 90.0, "power": 0.9},
                }
            ],
            "generated_candidates": [
                {
                    "id": "child",
                    "strategy": "single_thought_operator",
                    "parent_count": 1,
                    "requested_parent_count": 1,
                    "parent_arity": 1,
                    "origin_pool": "success_pool",
                    "status": "success",
                    "generated_mode": "whole",
                    "code_file_path": str(child_dir / "code.sv"),
                }
            ],
        },
    ]
    (problem_root / "generation_log.jsonl").write_text(
        "\n".join(json.dumps(row) for row in generated_rows) + "\n",
        encoding="utf-8",
    )

    context = {
        "task": "single_thought_operator",
        "parent_count": 1,
        "problem_description": "build the circuit",
        "parent": {
            "example": 1,
            "thought": "use a small adder",
            "evaluation_status": "succeeded",
            "ppa_summary": {"quality_score": 0.2},
        },
        "archive_context": [
            {
                "thought": "another idea",
                "evaluation_status": "succeeded",
                "quality_score": 0.1,
            }
        ],
    }
    if forbidden_context:
        context["parent"]["feedback"] = "parent feedback sentinel text"
    (child_dir / "prompt_snapshot.txt").write_text(
        "CONTEXT_JSON:\n"
        + json.dumps(context, indent=2)
        + "\n\nReturn exactly ONE JSON object",
        encoding="utf-8",
    )
    (child_dir / "prompt_snapshot.json").write_text(
        json.dumps(
            {
                "strategy": "single_thought_operator",
                "parent_count": 1,
                "requested_parent_count": 1,
                "parent_ids": ["parent"],
                "origin_pool": "success_pool",
                "resolved_mode": "whole",
            }
        ),
        encoding="utf-8",
    )


def _write_manifest(
    root: Path,
    *,
    total_worker_slots: int,
    max_active_problems: int = 4,
    max_workers_per_problem: int = 4,
    one_parent_fraction: float = 0.5,
) -> None:
    (root / "hard_iteration_manifest.txt").write_text(
        "\n".join(
            [
                f"total_worker_slots={total_worker_slots}",
                f"max_active_problems={max_active_problems}",
                f"max_workers_per_problem={max_workers_per_problem}",
                "mode.grid_quantile_pareto_journal_bd_eoh.qd_operator_kind=eoh_strategies",
                "mode.grid_quantile_pareto_journal_bd_unified.qd_operator_kind=single_thought_operator",
                "mode.grid_quantile_pareto_journal_bd_unified."
                f"qd_operator_one_parent_fraction={one_parent_fraction}",
            ]
        )
        + "\n",
        encoding="utf-8",
    )


def test_validate_single_thought_operator_run_accepts_clean_prompt(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_classic(tmp_path)
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_unified")

    exit_code = validate_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--eoh-mode",
            "grid_quantile_pareto_journal_bd_eoh",
            "--unified-mode",
            "grid_quantile_pareto_journal_bd_unified",
            "--require-full-subset",
        ]
    )

    payload = json.loads(
        (tmp_path / "single_thought_operator_validation.json").read_text(
            encoding="utf-8"
        )
    )
    assert exit_code == 0
    assert payload["failure_count"] == 0
    assert payload["operator_audit"]["operator_candidate_count"] == 1
    assert payload["operator_audit"]["prompt_snapshot_count"] == 1


def test_validate_accepts_code_from_thought_prompt(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_classic(tmp_path)
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_unified")
    sample_dir = (
        tmp_path
        / "grid_quantile_pareto_journal_bd_unified"
        / "RTLLM"
        / "Prob004_adder_8bit"
        / "Gen1"
        / "child"
        / "code_sample_0"
    )
    sample_dir.mkdir()
    context = {
        "task": "code_from_thought",
        "problem_description": "build the circuit",
        "thought_spec": {"summary": "use a small adder"},
        "thought_id": "child",
    }
    (sample_dir / "prompt_snapshot.txt").write_text(
        "CONTEXT_JSON:\n"
        + json.dumps(context, indent=2)
        + "\n\nReturn exactly ONE JSON object",
        encoding="utf-8",
    )
    seeded_dir = sample_dir.parent / "code_sample_1"
    seeded_dir.mkdir()
    seeded_context = {
        "task": "code_from_thought_seeded",
        "problem_description": "build the circuit",
        "thought_spec": {"summary": "use a small adder"},
        "thought_id": "child",
        "parent_code": "module parent_code_sentinel; endmodule",
    }
    (seeded_dir / "prompt_snapshot.txt").write_text(
        "CONTEXT_JSON:\n"
        + json.dumps(seeded_context, indent=2)
        + "\n\nReturn exactly ONE JSON object",
        encoding="utf-8",
    )

    exit_code = validate_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--eoh-mode",
            "grid_quantile_pareto_journal_bd_eoh",
            "--unified-mode",
            "grid_quantile_pareto_journal_bd_unified",
            "--require-full-subset",
        ]
    )

    payload = json.loads(
        (tmp_path / "single_thought_operator_validation.json").read_text(
            encoding="utf-8"
        )
    )
    assert exit_code == 0
    assert payload["failure_count"] == 0
    assert payload["operator_audit"]["prompt_snapshot_count"] == 3


def test_validate_single_thought_operator_acceptance_allows_16_workers(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_manifest(
        tmp_path,
        total_worker_slots=16,
        max_active_problems=13,
        max_workers_per_problem=4,
    )
    _write_classic(tmp_path)
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_unified")

    exit_code = validate_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--eoh-mode",
            "grid_quantile_pareto_journal_bd_eoh",
            "--unified-mode",
            "grid_quantile_pareto_journal_bd_unified",
            "--acceptance-hard-subset",
        ]
    )

    payload = json.loads(
        (tmp_path / "single_thought_operator_validation.json").read_text(
            encoding="utf-8"
        )
    )
    assert exit_code == 1
    assert not any("worker" in error for error in payload["acceptance_errors"])


def test_validate_single_thought_operator_uses_manifest_parent_fraction(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_manifest(tmp_path, total_worker_slots=16, one_parent_fraction=1.0)
    _write_classic(tmp_path)
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_unified")

    exit_code = validate_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--eoh-mode",
            "grid_quantile_pareto_journal_bd_eoh",
            "--unified-mode",
            "grid_quantile_pareto_journal_bd_unified",
            "--acceptance-hard-subset",
        ]
    )

    payload = json.loads(
        (tmp_path / "single_thought_operator_validation.json").read_text(
            encoding="utf-8"
        )
    )
    assert exit_code == 1
    assert payload["operator_audit"]["expected_one_parent_fraction"] == 1.0
    assert not any(
        "one-parent fraction" in error for error in payload["acceptance_errors"]
    )


def test_validate_counts_generation_log_ppa_not_archive_rows(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_classic(tmp_path)
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_unified")
    problem_root = (
        tmp_path
        / "grid_quantile_pareto_journal_bd_unified"
        / "RTLLM"
        / "Prob004_adder_8bit"
    )
    rows = [
        json.loads(line)
        for line in (problem_root / "generation_log.jsonl")
        .read_text(encoding="utf-8")
        .splitlines()
    ]
    rows[1]["population_ppa_details"].append(
        {
            "id": "child_2",
            "strategy": "single_thought_operator",
            "parent_count": 2,
            "requested_parent_count": 2,
            "score": 0.1,
            "ppa_metrics": {"area": 95.0, "power": 0.95},
        }
    )
    (problem_root / "generation_log.jsonl").write_text(
        "\n".join(json.dumps(row) for row in rows) + "\n",
        encoding="utf-8",
    )

    exit_code = validate_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--eoh-mode",
            "grid_quantile_pareto_journal_bd_eoh",
            "--unified-mode",
            "grid_quantile_pareto_journal_bd_unified",
            "--require-full-subset",
        ]
    )

    payload = json.loads(
        (tmp_path / "single_thought_operator_validation.json").read_text(
            encoding="utf-8"
        )
    )
    problem_key = "RTLLM/Prob004_adder_8bit"
    assert exit_code == 0
    assert (
        payload["metrics_by_mode"]["grid_quantile_pareto_journal_bd_unified"][
            problem_key
        ]["valid_ppa_sample_count"]
        == 2
    )


def test_validate_counts_generation_log_ppa_before_archive_initialization(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_classic(tmp_path)
    _write_qd(
        tmp_path,
        "grid_quantile_pareto_journal_bd_eoh",
        archive_cells=False,
        final_details=False,
    )
    _write_qd(
        tmp_path,
        "grid_quantile_pareto_journal_bd_unified",
        archive_cells=False,
        final_details=False,
    )

    exit_code = validate_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--eoh-mode",
            "grid_quantile_pareto_journal_bd_eoh",
            "--unified-mode",
            "grid_quantile_pareto_journal_bd_unified",
            "--require-full-subset",
        ]
    )

    payload = json.loads(
        (tmp_path / "single_thought_operator_validation.json").read_text(
            encoding="utf-8"
        )
    )
    problem_key = "RTLLM/Prob004_adder_8bit"
    assert exit_code == 0
    assert (
        payload["metrics_by_mode"]["grid_quantile_pareto_journal_bd_unified"][
            problem_key
        ][
            "valid_ppa_sample_count"
        ]
        == 1
    )
    assert (
        payload["metrics_by_mode"]["grid_quantile_pareto_journal_bd_unified"][
            problem_key
        ][
            "average_quality_score"
        ]
        == 0.2
    )


def test_validate_single_thought_operator_run_rejects_feedback_in_prompt(tmp_path):
    subset_config = _subset_config(tmp_path)
    _write_classic(tmp_path)
    _write_qd(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_qd(
        tmp_path,
        "grid_quantile_pareto_journal_bd_unified",
        forbidden_context=True,
    )

    exit_code = validate_main(
        [
            "--run-root",
            str(tmp_path),
            "--subset-config",
            str(subset_config),
            "--eoh-mode",
            "grid_quantile_pareto_journal_bd_eoh",
            "--unified-mode",
            "grid_quantile_pareto_journal_bd_unified",
        ]
    )

    payload = json.loads(
        (tmp_path / "single_thought_operator_validation.json").read_text(
            encoding="utf-8"
        )
    )
    assert exit_code == 1
    assert any("forbidden prompt keys" in error for error in payload["acceptance_errors"])
