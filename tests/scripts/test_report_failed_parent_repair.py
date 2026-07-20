from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

import pytest
import yaml

_ROOT = Path(__file__).resolve().parents[2]
_PATH = _ROOT / "scripts" / "report_failed_parent_repair.py"
_SPEC = importlib.util.spec_from_file_location("report_failed_parent_repair", _PATH)
assert _SPEC is not None and _SPEC.loader is not None
report = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_failed_parent_repair", report)
_SPEC.loader.exec_module(report)


def _candidate(
    candidate_id: str,
    origin_pool: str,
    strategy: str,
    status: str,
    parent_ids: list[str],
) -> dict[str, object]:
    rtl = status in {"success", "failed_synthesis", "failed_synthesis_functionality"}
    return {
        "id": candidate_id,
        "parent_ids": parent_ids,
        "origin_pool": origin_pool,
        "strategy": strategy,
        "status": status,
        "rtl_simulation_success": rtl,
        "synthesis_success": status == "success",
        "post_synthesis_functionality_success": status == "success",
        "ppa_success": status == "success",
        "code_file_path": f"/{candidate_id}.sv",
        "generated_mode": "whole",
    }


def _write_arm(root: Path, treatment: bool, problems: list[str]) -> None:
    fail_probabilities = {"M-F": 1.0}
    if not treatment:
        fail_probabilities = {operator: 0.2 for operator in report.FAIL_OPERATORS}
    rows = [
        {
            "generation": 0,
            "generated_candidates": [
                _candidate("initial-ok", "initial", "initial", "success", []),
                _candidate(
                    "initial-fail",
                    "initial",
                    "initial",
                    "failed_functionality",
                    [],
                ),
            ],
        },
        {
            "generation": 1,
            "generated_candidates": [
                _candidate("repair", "fail_pool", "M-F", "success", ["initial-fail"]),
                _candidate(
                    "improve",
                    "success_pool",
                    "M-S",
                    "failed_synthesis",
                    ["initial-ok"],
                ),
            ],
            "average_strategy_probabilities": {
                "fail_pool": fail_probabilities,
                "success_pool": {
                    operator: 0.2 for operator in report.SUCCESS_OPERATORS
                },
            },
        },
    ]
    for problem_name in problems:
        problem = root / "model" / "RTLLM" / problem_name
        problem.mkdir(parents=True)
        (problem / "generation_log.jsonl").write_text(
            "\n".join(json.dumps(row) for row in rows) + "\n", encoding="utf-8"
        )
        if treatment:
            pool = {
                "generation": 1,
                "pre_selection_fail_pool_size": 1,
                "pre_selection_success_pool_size": 1,
                "post_selection_fail_pool_size": 0,
                "post_selection_success_pool_size": 2,
                "generation_outcome": "completed",
            }
            (problem / "failed_parent_repair_pool_telemetry.jsonl").write_text(
                json.dumps(pool) + "\n", encoding="utf-8"
            )
    config = {
        "backend": "revolution",
        "benchmarks": ["RTLLM"],
        "api_backend": "vllm",
        "vllm_host": "20.0.0.103",
        "vllm_port": 8000,
        "vllm_min_model_len": 128000,
        "model_name": "openai/gpt-oss-120b",
        "temperature": 1.0,
        "top_p": 1.0,
        "max_tokens": 128000,
        "diff_max_tokens": 128000,
        "evaluation_mode": "strict_ablation",
        "generation_mode": "whole",
        "population_pool_mode": "dual",
        "classic_operator_kind": "eoh_strategies",
        "eoh_success_operator_set": "classic",
        "strategy_selection": "ucb",
        "representation_kind": "code_individual",
        "repair_kind": "none",
        "prompt_profile": "default",
        "prompt_root": None,
        "max_llm_calls_per_problem": 100,
        "seed": 42,
        "problems": problems,
        "population_size": 2,
        "num_generations": 1,
        "search_mode": (
            "revolution_failed_parent_repair" if treatment else "revolution"
        ),
        "save_path": str(root),
    }
    (root / "run_revolution_config.yaml").write_text(
        yaml.safe_dump(config), encoding="utf-8"
    )


def test_report_validates_and_pairs_fresh_arms(tmp_path: Path) -> None:
    classic = tmp_path / "classic"
    treatment = tmp_path / "treatment"
    output = tmp_path / "report"
    _write_arm(classic, False, ["Prob001"])
    _write_arm(treatment, True, ["Prob001"])

    summary = report.generate_report(
        classic, treatment, output, 42, ["Prob001"], 2, 1, "forbid"
    )

    assert summary["candidate_budget_per_problem"] == 4
    assert summary["mean_paired_unconditional_valid_ppa_repair_rate_delta"] == 0
    assert len(summary["classic_config_sha256"]) == 64
    assert len(summary["treatment_config_sha256"]) == 64
    with (output / "paired_repair_delta.csv").open(
        newline="", encoding="utf-8"
    ) as handle:
        paired = list(csv.DictReader(handle))
    assert paired[0]["direct_valid_ppa_repair_delta"] == "0"
    assert paired[0]["unconditional_valid_ppa_repair_rate_delta"] == "0.0"
    with (output / "mechanism_by_problem.csv").open(
        newline="", encoding="utf-8"
    ) as handle:
        mechanism = list(csv.DictReader(handle))
    assert mechanism[0]["conditional_rtl_simulation_repair_yield"] == "1.0"
    assert mechanism[0]["recovered_design"] == "0"
    assert mechanism[0]["direct_repair_stage_transitions"] == '{"syntax->valid_ppa":1}'


def test_report_zero_fills_registered_missing_treatment(tmp_path: Path) -> None:
    classic = tmp_path / "classic"
    treatment = tmp_path / "treatment"
    output = tmp_path / "report"
    problems = ["Prob001", "Prob002"]
    _write_arm(classic, False, problems)
    _write_arm(treatment, True, ["Prob001"])
    treatment_config = next(treatment.rglob("*_revolution_config.yaml"))
    config = yaml.safe_load(treatment_config.read_text(encoding="utf-8"))
    config["problems"] = problems
    treatment_config.write_text(yaml.safe_dump(config), encoding="utf-8")

    summary = report.generate_report(
        classic, treatment, output, 42, problems, 2, 1, "zero"
    )
    with (output / "mechanism_by_problem.csv").open(
        newline="", encoding="utf-8"
    ) as handle:
        rows = list(csv.DictReader(handle))
    by_problem = {row["problem"]: row for row in rows}
    assert by_problem["Prob001"]["unit_status"] == "complete"
    missing = [
        row
        for row in rows
        if row["arm"] == "treatment" and row["problem"] == "Prob002"
    ]
    assert len(missing) == 1
    assert missing[0]["unit_status"] == "missing_method_failure"
    assert missing[0]["candidate_count"] == "0"
    assert missing[0]["unconditional_valid_ppa_repair_rate"] == "0.0"
    assert summary["treatment_direct_valid_ppa_repairs"] == 1


def test_report_rejects_unknown_stage_combination() -> None:
    candidate = _candidate("bad", "fail_pool", "M-F", "failed_synthesis", ["p"])
    candidate["synthesis_success"] = True

    with pytest.raises(AssertionError):
        report._completed_stage(candidate)


def test_report_rejects_uninstrumented_classic(tmp_path: Path) -> None:
    classic = tmp_path / "classic"
    treatment = tmp_path / "treatment"
    _write_arm(classic, False, ["Prob001"])
    _write_arm(treatment, True, ["Prob001"])
    path = next(classic.rglob("generation_log.jsonl"))
    rows = [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()]
    del rows[0]["generated_candidates"][0]["parent_ids"]
    path.write_text("\n".join(json.dumps(row) for row in rows) + "\n", encoding="utf-8")

    with pytest.raises(AssertionError):
        report.generate_report(
            classic, treatment, tmp_path / "report", 42, ["Prob001"], 2, 1, "forbid"
        )


def test_report_rejects_success_parent_as_direct_repair(tmp_path: Path) -> None:
    classic = tmp_path / "classic"
    treatment = tmp_path / "treatment"
    _write_arm(classic, False, ["Prob001"])
    _write_arm(treatment, True, ["Prob001"])
    path = next(treatment.rglob("generation_log.jsonl"))
    rows = [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()]
    rows[1]["generated_candidates"][0]["parent_ids"] = ["initial-ok"]
    path.write_text("\n".join(json.dumps(row) for row in rows) + "\n", encoding="utf-8")

    with pytest.raises(AssertionError):
        report.generate_report(
            classic, treatment, tmp_path / "report", 42, ["Prob001"], 2, 1, "forbid"
        )


def test_report_rejects_mismatched_control_config(tmp_path: Path) -> None:
    classic = tmp_path / "classic"
    treatment = tmp_path / "treatment"
    _write_arm(classic, False, ["Prob001"])
    _write_arm(treatment, True, ["Prob001"])
    path = next(treatment.rglob("*_revolution_config.yaml"))
    config = yaml.safe_load(path.read_text(encoding="utf-8"))
    config["strategy_selection"] = "random"
    path.write_text(yaml.safe_dump(config), encoding="utf-8")

    with pytest.raises(AssertionError):
        report.generate_report(
            classic, treatment, tmp_path / "report", 42, ["Prob001"], 2, 1, "forbid"
        )


def test_report_rejects_jointly_wrong_model(tmp_path: Path) -> None:
    classic = tmp_path / "classic"
    treatment = tmp_path / "treatment"
    _write_arm(classic, False, ["Prob001"])
    _write_arm(treatment, True, ["Prob001"])
    for root in (classic, treatment):
        path = next(root.rglob("*_revolution_config.yaml"))
        config = yaml.safe_load(path.read_text(encoding="utf-8"))
        config["model_name"] = "wrong/model"
        path.write_text(yaml.safe_dump(config), encoding="utf-8")

    with pytest.raises(AssertionError):
        report.generate_report(
            classic, treatment, tmp_path / "report", 42, ["Prob001"], 2, 1, "forbid"
        )


def test_report_rejects_impossible_pool_transition(tmp_path: Path) -> None:
    classic = tmp_path / "classic"
    treatment = tmp_path / "treatment"
    _write_arm(classic, False, ["Prob001"])
    _write_arm(treatment, True, ["Prob001"])
    path = next(treatment.rglob("failed_parent_repair_pool_telemetry.jsonl"))
    record = json.loads(path.read_text(encoding="utf-8"))
    record["post_selection_fail_pool_size"] = 1
    record["post_selection_success_pool_size"] = 1
    path.write_text(json.dumps(record) + "\n", encoding="utf-8")

    with pytest.raises(AssertionError):
        report.generate_report(
            classic, treatment, tmp_path / "report", 42, ["Prob001"], 2, 1, "forbid"
        )
