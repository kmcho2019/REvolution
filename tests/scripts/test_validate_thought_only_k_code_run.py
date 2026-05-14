import json
from pathlib import Path

from scripts.validate_thought_only_k_code_run import main as validate_main


def _subset_config(root: Path) -> Path:
    path = root / "subset.yaml"
    path.write_text(
        "selected_problems:\n"
        "  - benchmark: RTLLM\n"
        "    problem: Prob004_adder_8bit\n",
        encoding="utf-8",
    )
    return path


def _write_manifest(root: Path) -> None:
    (root / "hard_iteration_manifest.txt").write_text(
        "\n".join(
            [
                "total_worker_slots=4",
                "max_active_problems=4",
                "max_workers_per_problem=4",
                "mode.grid_quantile_pareto_journal_eoh_thought_k4.representation.kind=thought_only",
                "mode.grid_quantile_pareto_journal_eoh_thought_k4.representation.code_samples_per_thought=4",
                "mode.grid_quantile_pareto_journal_thought_k4.representation.kind=thought_only",
                "mode.grid_quantile_pareto_journal_thought_k4.representation.code_samples_per_thought=4",
            ]
        ),
        encoding="utf-8",
    )


def _write_mode(
    root: Path,
    mode: str,
    *,
    k: int = 4,
    collapsed: bool = False,
    generation_details_only: bool = False,
) -> None:
    problem_root = root / mode / "RTLLM" / "Prob004_adder_8bit"
    thought_root = problem_root / "Gen0" / "g000_thought_0001"
    thought_root.mkdir(parents=True)
    ppa_detail = {
        "id": "thought",
        "score": 0.4,
        "ppa_metrics": {"area": 90.0, "power": 0.9},
    }
    summary = {
        "backend_details": {
            "qd_config": {
                "representation": {
                    "kind": "thought_only",
                    "code_samples_per_thought": 4,
                    "representative_sample": "best_successful_quality",
                },
                "repair": {
                    "kind": "none",
                    "max_attempts_per_sample": 0,
                    "max_attempts_per_thought": 0,
                    "evidence": "stage_scoped_logs",
                },
            }
        },
        "accumulated_success_rates": {
            "functionality": 0.0 if collapsed else 0.5,
            "synthesis_ppa": 0.0 if collapsed else 0.25,
        },
        "final_population_ppa": {
            "average_score": None if collapsed or generation_details_only else 0.4,
            "best_metrics": (
                {}
                if collapsed or generation_details_only
                else {"area": 90.0, "power": 0.9}
            ),
        },
        "final_population_ppa_details": (
            [] if collapsed or generation_details_only else [ppa_detail]
        ),
        "ref_ppa_metric": {"area": 100.0, "power": 1.0},
    }
    (problem_root / "Prob004_adder_8bit_summary.json").write_text(
        json.dumps(summary),
        encoding="utf-8",
    )
    if generation_details_only:
        (problem_root / "generation_log.jsonl").write_text(
            json.dumps({"population_ppa_details": [ppa_detail]}) + "\n",
            encoding="utf-8",
        )
    evaluation = {
        "thought_id": "g000_thought_0001",
        "code_samples_per_thought": k,
        "sample_ids": [f"s{i}" for i in range(k)],
        "sample_records": [
            {
                "thought_id": "g000_thought_0001",
                "sample_index": i,
                "candidate_id": f"s{i}",
                "status": "success" if i == 0 else "failed_functionality",
                "code_file_path": f"/tmp/s{i}.sv",
                "quality_score": 0.5 if i == 0 else None,
                "ppa_success": i == 0,
                "ppa_metrics": {},
                "descriptor_values": {},
                "repair_attempts": 0,
            }
            for i in range(k)
        ],
        "success_count": 1,
        "success_rate": 1 / k,
        "aggregate_status": "partial_success",
        "representative_sample_id": "s0",
    }
    (thought_root / "thought_evaluation.json").write_text(
        json.dumps(evaluation),
        encoding="utf-8",
    )


def _write_control_mode(root: Path, mode: str, *, sample_count: int = 1) -> None:
    problem_root = root / mode / "RTLLM" / "Prob004_adder_8bit"
    problem_root.mkdir(parents=True)
    summary = {
        "accumulated_success_rates": {
            "functionality": 0.5,
            "synthesis_ppa": 0.25,
        },
        "final_population_ppa": {
            "average_score": 0.4,
            "best_metrics": {"area": 90.0, "power": 0.9},
        },
        "final_population_ppa_details": [
            {"id": f"control_{index}"}
            for index in range(sample_count)
        ],
        "ref_ppa_metric": {"area": 100.0, "power": 1.0},
    }
    (problem_root / "Prob004_adder_8bit_summary.json").write_text(
        json.dumps(summary),
        encoding="utf-8",
    )


def _args(root: Path, subset: Path) -> list[str]:
    return [
        "--run-root",
        str(root),
        "--subset-config",
        str(subset),
        "--classic-mode",
        "classic",
        "--eoh-control-mode",
        "grid_quantile_pareto_journal_bd_eoh",
        "--unified-control-mode",
        "grid_quantile_pareto_journal_bd_unified",
        "--eoh-thought-only-mode",
        "grid_quantile_pareto_journal_eoh_thought_k4",
        "--thought-only-mode",
        "grid_quantile_pareto_journal_thought_k4",
        "--require-full-subset",
        "--acceptance-hard-subset",
    ]


def test_validate_thought_only_k_code_run_accepts_valid_artifacts(tmp_path):
    subset = _subset_config(tmp_path)
    _write_manifest(tmp_path)
    _write_control_mode(tmp_path, "classic")
    _write_control_mode(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_control_mode(tmp_path, "grid_quantile_pareto_journal_bd_unified")
    _write_mode(tmp_path, "grid_quantile_pareto_journal_eoh_thought_k4")
    _write_mode(
        tmp_path,
        "grid_quantile_pareto_journal_thought_k4",
        generation_details_only=True,
    )

    assert validate_main(_args(tmp_path, subset)) == 0
    payload = json.loads(
        (tmp_path / "thought_only_k_code_validation.json").read_text(encoding="utf-8")
    )
    assert payload["thought_evaluation_count"] == 2
    assert payload["errors"] == []


def test_validate_thought_only_k_code_run_rejects_wrong_k(tmp_path):
    subset = _subset_config(tmp_path)
    _write_manifest(tmp_path)
    _write_control_mode(tmp_path, "classic")
    _write_control_mode(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_control_mode(tmp_path, "grid_quantile_pareto_journal_bd_unified")
    _write_mode(tmp_path, "grid_quantile_pareto_journal_eoh_thought_k4")
    _write_mode(tmp_path, "grid_quantile_pareto_journal_thought_k4", k=3)

    assert validate_main(_args(tmp_path, subset)) == 1
    payload = json.loads(
        (tmp_path / "thought_only_k_code_validation.json").read_text(encoding="utf-8")
    )
    assert any("expected 4" in error for error in payload["errors"])


def test_validate_thought_only_k_code_run_accepts_lower_representative_count(
    tmp_path,
):
    subset = _subset_config(tmp_path)
    _write_manifest(tmp_path)
    _write_control_mode(tmp_path, "classic")
    _write_control_mode(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_control_mode(
        tmp_path,
        "grid_quantile_pareto_journal_bd_unified",
        sample_count=4,
    )
    _write_mode(tmp_path, "grid_quantile_pareto_journal_eoh_thought_k4")
    _write_mode(tmp_path, "grid_quantile_pareto_journal_thought_k4")

    assert validate_main(_args(tmp_path, subset)) == 0


def test_validate_thought_only_k_code_run_rejects_target_collapse(tmp_path):
    subset = _subset_config(tmp_path)
    _write_manifest(tmp_path)
    _write_control_mode(tmp_path, "classic")
    _write_control_mode(tmp_path, "grid_quantile_pareto_journal_bd_eoh")
    _write_control_mode(tmp_path, "grid_quantile_pareto_journal_bd_unified")
    _write_mode(tmp_path, "grid_quantile_pareto_journal_eoh_thought_k4")
    _write_mode(tmp_path, "grid_quantile_pareto_journal_thought_k4", collapsed=True)

    assert validate_main(_args(tmp_path, subset)) == 1
    payload = json.loads(
        (tmp_path / "thought_only_k_code_validation.json").read_text(encoding="utf-8")
    )
    assert any(
        "collapsed to zero functional pass rate" in error
        for error in payload["errors"]
    )
