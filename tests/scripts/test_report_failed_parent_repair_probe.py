from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

import pytest
import yaml


_ROOT = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(_ROOT / "scripts"))
_PATH = _ROOT / "scripts" / "report_failed_parent_repair_probe.py"
_SPEC = importlib.util.spec_from_file_location(
    "report_failed_parent_repair_probe", _PATH
)
assert _SPEC is not None and _SPEC.loader is not None
report = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_failed_parent_repair_probe", report)
_SPEC.loader.exec_module(report)


def _candidate(candidate_id: str, generation: int) -> dict[str, object]:
    return {
        "id": candidate_id,
        "parent_ids": [] if generation == 0 else ["initial"],
        "origin_pool": "initial" if generation == 0 else "success_pool",
        "strategy": "initial" if generation == 0 else "M-S",
        "status": "success",
        "rtl_simulation_success": True,
        "synthesis_success": True,
        "post_synthesis_functionality_success": True,
        "ppa_success": True,
        "code_file_path": f"/tmp/{candidate_id}/code.sv",
        "generated_mode": "whole",
    }


def _write_arm(root: Path, *, calls: int = 4) -> None:
    problem = root / "model" / "RTLLM" / "Prob001"
    problem.mkdir(parents=True, exist_ok=True)
    records = [
        {"generation": 0, "generated_candidates": [_candidate("initial", 0)]},
        {"generation": 1, "generated_candidates": [_candidate("child", 1)]},
    ]
    (problem / "generation_log.jsonl").write_text(
        "".join(json.dumps(row) + "\n" for row in records), encoding="utf-8"
    )
    (problem / "Prob001_summary.json").write_text(
        json.dumps(
            {
                "total_candidates_generated": 2,
                "total_llm_api_calls": calls,
                "total_llm_prompt_tokens": 50,
                "total_llm_completion_tokens": 50,
                "final_population_ppa": {"best_score": 0.2},
                "total_runtime_seconds": 10.0,
            }
        ),
        encoding="utf-8",
    )


def _full_gate_inputs() -> tuple[
    list[dict[str, object]],
    list[dict[str, object]],
    dict[str, dict[str, float]],
    dict[str, float | int],
]:
    seeds = (1001, 1002)
    seed_metrics: list[dict[str, object]] = []
    for seed in seeds:
        for metric, classic, treatment in (
            ("unconditional_valid_ppa_repair_rate_all_50", 0.1, 0.11),
            ("final_hypervolume", 0.1, 0.11),
            ("hypervolume_auc", 0.08, 0.09),
            ("rtl_simulation_functionality_46", 1.0, 1.0),
            ("verification_complete_valid_ppa", 1.0, 1.0),
        ):
            seed_metrics.append(
                {
                    "seed": seed,
                    "metric": metric,
                    "classic_mean": classic,
                    "treatment_mean": treatment,
                    "mean_delta": treatment - classic,
                }
            )
    resources: list[dict[str, object]] = [
        {
            "seed": seed,
            "arm": arm,
            "candidate_count": 4,
            "llm_calls": 100,
            "llm_tokens": 1000,
            "run_wall_seconds": 10.0,
        }
        for seed in seeds
        for arm in report.ARMS
    ]
    statistics = {
        "final_hypervolume": {"mean_delta": 0.01},
        "hypervolume_auc": {"mean_delta": 0.01},
    }
    gates = {
        "final_hv_noninferiority": -0.005,
        "hv_auc_noninferiority": -0.0036,
        "maximum_coverage_deficit": 2,
        "maximum_auxiliary_resource_relative_skew": 0.1,
        "catastrophic_minimum_hv_ratio": 0.9,
        "catastrophic_maximum_coverage_deficit": 3,
    }
    return seed_metrics, resources, statistics, gates


def test_read_arm_enforces_resource_ceilings(tmp_path: Path) -> None:
    root = tmp_path / "run"
    _write_arm(root)
    rows = report._read_arm(root, ["Prob001"], 1, 1, 4, 100, 2, "forbid")
    assert rows["Prob001"]["candidate_count"] == 2
    assert rows["Prob001"]["synthesis_evaluations"] == 2

    _write_arm(root, calls=5)
    with pytest.raises(AssertionError):
        report._read_arm(root, ["Prob001"], 1, 1, 4, 100, 2, "forbid")


def test_read_arm_zero_fills_registered_missing_treatment(tmp_path: Path) -> None:
    root = tmp_path / "run"
    _write_arm(root)

    rows = report._read_arm(
        root, ["Prob001", "Prob002"], 1, 1, 4, 100, 2, "zero"
    )
    assert rows["Prob002"] == {
        "unit_status": "missing_method_failure",
        "candidate_count": 0,
        "llm_calls": 0,
        "llm_tokens": 0,
        "synthesis_evaluations": 0,
        "rtl_simulation_functionality": 0.0,
        "verification_complete_valid_ppa": 0.0,
        "valid_ppa_sample_count": 0,
        "valid_ppa_sample_yield": 0.0,
        "best_normalized_ppa": None,
        "runtime_seconds": 0.0,
    }


def test_read_run_wall_requires_one_scheduler_record(tmp_path: Path) -> None:
    telemetry = tmp_path / "run_scheduler_telemetry.json"
    telemetry.write_text(json.dumps({"run_wall_seconds": 12.5}), encoding="utf-8")

    assert report._read_run_wall(tmp_path) == 12.5


def test_full_suite_gate_enforces_boundaries_and_failures() -> None:
    seed_metrics, resources, statistics, gates = _full_gate_inputs()
    result = report._full_suite_gate(
        seed_metrics, resources, statistics, [1001, 1002], 1, 4, gates
    )
    assert result["performance_gate"] == "VIABLE"

    statistics["final_hypervolume"]["mean_delta"] = -0.005
    statistics["hypervolume_auc"]["mean_delta"] = -0.0036
    for row in resources:
        if row["arm"] == "treatment":
            row["run_wall_seconds"] = 11.0
    boundary = report._full_suite_gate(
        seed_metrics, resources, statistics, [1001, 1002], 1, 4, gates
    )
    assert boundary["gate_results"]["final_hv_noninferiority"] is True
    assert boundary["gate_results"]["hv_auc_noninferiority"] is True
    assert boundary["gate_results"]["auxiliary_resource_parity"] is True

    statistics["final_hypervolume"]["mean_delta"] = -0.00501
    regressed = report._full_suite_gate(
        seed_metrics, resources, statistics, [1001, 1002], 1, 4, gates
    )
    assert regressed["gate_results"]["final_hv_noninferiority"] is False
    assert regressed["performance_gate"] == "RETIRED"
    statistics["final_hypervolume"]["mean_delta"] = -0.005

    for row in seed_metrics:
        if row["metric"] == "verification_complete_valid_ppa":
            row["treatment_mean"] = 0.0
            row["mean_delta"] = -1.0
    coverage_boundary = report._full_suite_gate(
        seed_metrics, resources, statistics, [1001, 1002], 1, 4, gates
    )
    assert coverage_boundary["valid_ppa_coverage_deficit_46"] == 2
    assert coverage_boundary["gate_results"]["valid_ppa_noninferiority"] is True
    assert coverage_boundary["gate_results"]["catastrophic_valid_ppa"] is False

    catastrophic_coverage = report._full_suite_gate(
        seed_metrics, resources, statistics, [1001, 1002], 2, 4, gates
    )
    assert catastrophic_coverage["valid_ppa_coverage_deficit_46"] == 4
    assert catastrophic_coverage["gate_results"]["catastrophic_valid_ppa"] is True

    resources[-1]["candidate_count"] = 3
    missing = report._full_suite_gate(
        seed_metrics, resources, statistics, [1001, 1002], 1, 4, gates
    )
    assert missing["gate_results"]["candidate_budget_equality"] is False
    assert missing["gate_results"]["catastrophic_candidate_budget"] is True
    assert missing["performance_gate"] == "RETIRED"

    resources[-1]["candidate_count"] = 4
    resources[-1]["run_wall_seconds"] = 11.01
    skewed = report._full_suite_gate(
        seed_metrics, resources, statistics, [1001, 1002], 1, 4, gates
    )
    assert skewed["gate_results"]["auxiliary_resource_parity"] is False
    assert skewed["performance_gate"] == "RETIRED"

    resources[-1]["run_wall_seconds"] = 11.0
    for row in seed_metrics:
        if row["metric"] == "final_hypervolume":
            row["treatment_mean"] = 0.08
    catastrophic = report._full_suite_gate(
        seed_metrics, resources, statistics, [1001, 1002], 1, 4, gates
    )
    assert catastrophic["gate_results"]["catastrophic_hv"] is True


def test_generate_report_accounts_for_every_unit_and_zero_ppa(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    problems = ["ProbA", "ProbB"]
    subset = tmp_path / "subset.yaml"
    subset.write_text(
        yaml.safe_dump(
            {
                "selected_problems": [
                    {
                        "benchmark": "RTLLM",
                        "problem": "ProbA",
                        "circuit_type": "combinational",
                    },
                    {
                        "benchmark": "RTLLM",
                        "problem": "ProbB",
                        "circuit_type": "sequential",
                    },
                ]
            }
        ),
        encoding="utf-8",
    )
    raw_root = tmp_path / "raw"
    package_root = tmp_path / "packages"
    manifest = tmp_path / "manifest.yaml"
    manifest.write_text(
        yaml.safe_dump(
            {
                "candidate_id": "H5",
                "stage": "representative_probe",
                "budget": {
                    "population_size": 1,
                    "generations": 1,
                    "max_llm_calls_per_problem": 4,
                    "max_total_tokens_per_problem": 100,
                    "max_synthesis_calls_per_problem": 2,
                    "max_wall_seconds_per_problem": 20,
                },
                "benchmarks": {"manifest_path": str(subset)},
                "seeds": {"values": [1001, 1002]},
                "statistics": {
                    "tie_tolerance": 1.0e-9,
                    "bootstrap_replicates": 100,
                    "bootstrap_seed": 7,
                },
                "artifacts": {
                    "raw_root": str(raw_root),
                    "report_root": str(package_root),
                },
            }
        ),
        encoding="utf-8",
    )

    def fake_arm(root: Path, *_args: object) -> dict[str, dict[str, object]]:
        treatment = root.name == "treatment"
        return {
            "ProbA": {
                "unit_status": "complete",
                "candidate_count": 2,
                "llm_calls": 4,
                "llm_tokens": 80,
                "synthesis_evaluations": 2,
                "rtl_simulation_functionality": 1.0,
                "verification_complete_valid_ppa": 1.0,
                "valid_ppa_sample_count": 2,
                "valid_ppa_sample_yield": 1.0,
                "best_normalized_ppa": 0.05 if treatment else 0.2,
                "runtime_seconds": 10.0,
            },
            "ProbB": {
                "unit_status": "complete",
                "candidate_count": 2,
                "llm_calls": 4,
                "llm_tokens": 80,
                "synthesis_evaluations": 0 if treatment else 1,
                "rtl_simulation_functionality": 0.0 if treatment else 1.0,
                "verification_complete_valid_ppa": 0.0 if treatment else 1.0,
                "valid_ppa_sample_count": 0 if treatment else 1,
                "valid_ppa_sample_yield": 0.0 if treatment else 0.5,
                "best_normalized_ppa": None if treatment else 0.1,
                "runtime_seconds": 12.0,
            },
        }

    def fake_package(
        _package: Path,
        _seed: int,
        _problems: list[str],
        _headline_problems: list[str],
        _missing_treatment: set[str],
    ) -> tuple[
        dict[tuple[str, str], dict[str, str]],
        dict[tuple[str, str], float],
        dict[tuple[str, str], tuple[float, float]],
    ]:
        mechanism = {
            (arm, problem): {
                "initial_fail_pool_size": "1",
                "initial_success_pool_size": "0",
                "unconditional_valid_ppa_repair_rate": (
                    "0.5" if arm == "treatment" and problem == "ProbA" else "0.0"
                ),
                "direct_rtl_repairs": (
                    "1" if arm == "treatment" and problem == "ProbA" else "0"
                ),
                "direct_valid_ppa_repairs": (
                    "1" if arm == "treatment" and problem == "ProbA" else "0"
                ),
                "fail_parent_requests": "1",
                "conditional_rtl_simulation_repair_yield": "1.0",
                "conditional_valid_ppa_repair_yield": "1.0",
                "first_direct_valid_ppa_generation": "1",
                "recovered_design": "1",
                "direct_repair_stage_transitions": "{}",
            }
            for arm in report.ARMS
            for problem in problems
        }
        pareto = {
            (label, problem): (
                0.2
                if label == "h5" and problem == "ProbA"
                else 0.1
                if label == "classic"
                else 0.0
            )
            for label in report.REPORT_LABELS.values()
            for problem in problems
        }
        hv_auc = {
            ("classic", "ProbA"): (0.1, 0.08),
            ("classic", "ProbB"): (0.1, 0.07),
            ("h5", "ProbA"): (0.2, 0.15),
        }
        return mechanism, pareto, hv_auc

    monkeypatch.setattr(report, "_read_arm", fake_arm)
    monkeypatch.setattr(report, "_read_seed_package", fake_package)
    monkeypatch.setattr(report, "_read_run_wall", lambda _root: 10.0)
    for seed in (1001, 1002):
        for problem in problems:
            problem_dir = raw_root / f"seed_{seed}" / "treatment" / problem
            problem_dir.mkdir(parents=True)
            (problem_dir / "failed_parent_repair_pool_telemetry.jsonl").write_text(
                json.dumps(
                    {
                        "generation": 1,
                        "pre_selection_fail_pool_size": 1,
                        "pre_selection_success_pool_size": 0,
                        "post_selection_fail_pool_size": 0,
                        "post_selection_success_pool_size": 1,
                        "generation_outcome": "completed",
                    }
                )
                + "\n",
                encoding="utf-8",
            )
    output = tmp_path / "output"
    summary = report.generate_report(manifest, output)
    assert summary["expected_problem_seed_units"] == 4
    assert summary["validated_arm_units"] == 8
    assert summary["statistics"]["hypervolume_auc"]["unit_count"] == 4
    assert summary["statistics"]["best_normalized_ppa"]["imputed_loss_count"] == 2
    assert summary["statistics"]["best_normalized_ppa"]["mean_delta"] == pytest.approx(
        -0.075
    )
    assert summary["metric_aliases"] == {
        "unconditional_fail_origin_valid_ppa_repairs_per_48_candidates": (
            "unconditional_valid_ppa_repair_rate"
        )
    }
    assert summary["protocol_deviations"][0]["metric"] == (
        "llm_calls_to_first_improvement"
    )

    with (output / "seed_metrics.csv").open(newline="", encoding="utf-8") as handle:
        seed_metrics = list(csv.DictReader(handle))
    assert len(seed_metrics) == 14
    assert {
        (row["seed"], row["metric"])
        for row in seed_metrics
        if row["metric"] == "final_hypervolume"
    } == {("1001", "final_hypervolume"), ("1002", "final_hypervolume")}

    with (output / "leave_one_seed_out.csv").open(
        newline="", encoding="utf-8"
    ) as handle:
        sensitivity = list(csv.DictReader(handle))
    assert len(sensitivity) == 14

    with (output / "resource_totals.csv").open(
        newline="", encoding="utf-8"
    ) as handle:
        totals = list(csv.DictReader(handle))
    assert len(totals) == 4
    assert {row["summed_problem_runtime_seconds"] for row in totals} == {"22.0"}

    with (output / "treatment_pool_trajectory.csv").open(
        newline="", encoding="utf-8"
    ) as handle:
        trajectories = list(csv.DictReader(handle))
    assert len(trajectories) == 4
    assert {row["generation_outcome"] for row in trajectories} == {"completed"}

    with (output / "resource_by_unit.csv").open(newline="", encoding="utf-8") as handle:
        resources = list(csv.DictReader(handle))
    missing_ppa = [
        row
        for row in resources
        if row["arm"] == "treatment" and row["problem"] == "ProbB"
    ]
    assert len(missing_ppa) == 2
    assert {row["hypervolume_auc"] for row in missing_ppa} == {"0.0"}


def test_full_suite_gate_separates_run_and_headline_units(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    run_manifest = tmp_path / "run.yaml"
    run_manifest.write_text(
        yaml.safe_dump(
            {
                "selected_problems": [
                    {
                        "benchmark": "RTLLM",
                        "problem": "ProbA",
                        "circuit_type": "combinational",
                    },
                    {
                        "benchmark": "RTLLM",
                        "problem": "ProbB",
                        "circuit_type": "sequential",
                    },
                ]
            }
        ),
        encoding="utf-8",
    )
    headline_manifest = tmp_path / "headline.yaml"
    headline_manifest.write_text(
        yaml.safe_dump(
            {"selected_problems": [{"benchmark": "RTLLM", "problem": "ProbA"}]}
        ),
        encoding="utf-8",
    )
    raw_root = tmp_path / "raw"
    manifest = tmp_path / "manifest.yaml"
    manifest.write_text(
        yaml.safe_dump(
            {
                "candidate_id": "H5",
                "stage": "full_suite_probe",
                "budget": {
                    "population_size": 1,
                    "generations": 1,
                    "max_llm_calls_per_problem": 4,
                    "max_total_tokens_per_problem": 100,
                    "max_synthesis_calls_per_problem": 2,
                    "max_wall_seconds_per_problem": 20,
                },
                "benchmarks": {
                    "run_manifest_path": str(run_manifest),
                    "headline_manifest_path": str(headline_manifest),
                },
                "seeds": {"values": [1001, 1002]},
                "statistics": {
                    "tie_tolerance": 1.0e-9,
                    "bootstrap_replicates": 100,
                    "bootstrap_seed": 7,
                },
                "frozen_gates": {
                    "final_hv_noninferiority": -0.005,
                    "hv_auc_noninferiority": -0.0036,
                    "maximum_coverage_deficit": 2,
                    "maximum_auxiliary_resource_relative_skew": 0.1,
                    "catastrophic_minimum_hv_ratio": 0.9,
                    "catastrophic_maximum_coverage_deficit": 3,
                },
                "artifacts": {
                    "raw_root": str(raw_root),
                    "report_root": str(tmp_path / "packages"),
                },
            }
        ),
        encoding="utf-8",
    )

    def fake_arm(root: Path, *_args: object) -> dict[str, dict[str, object]]:
        treatment = root.name == "treatment"
        return {
            problem: {
                "unit_status": (
                    "missing_method_failure"
                    if treatment and problem == "ProbB"
                    else "complete"
                ),
                "candidate_count": 0 if treatment and problem == "ProbB" else 2,
                "llm_calls": 0 if treatment and problem == "ProbB" else 4,
                "llm_tokens": 0 if treatment and problem == "ProbB" else 80,
                "synthesis_evaluations": 0 if treatment and problem == "ProbB" else 2,
                "rtl_simulation_functionality": (
                    0.0 if treatment and problem == "ProbB" else 1.0
                ),
                "verification_complete_valid_ppa": (
                    0.0 if treatment and problem == "ProbB" else 1.0
                ),
                "valid_ppa_sample_count": 0 if treatment and problem == "ProbB" else 2,
                "valid_ppa_sample_yield": (
                    0.0 if treatment and problem == "ProbB" else 1.0
                ),
                "best_normalized_ppa": (
                    None
                    if treatment and problem == "ProbB"
                    else 0.3
                    if treatment
                    else 0.2
                ),
                "runtime_seconds": 0.0 if treatment and problem == "ProbB" else 10.0,
            }
            for problem in ("ProbA", "ProbB")
        }

    def fake_package(
        _package: Path,
        _seed: int,
        problems: list[str],
        headline_problems: list[str],
        missing_treatment: set[str],
    ) -> tuple[
        dict[tuple[str, str], dict[str, str]],
        dict[tuple[str, str], float],
        dict[tuple[str, str], tuple[float, float]],
    ]:
        assert headline_problems == ["ProbA"]
        assert missing_treatment == {"ProbB"}
        mechanism = {
            (arm, problem): {
                "initial_fail_pool_size": "1",
                "initial_success_pool_size": "0",
                "unconditional_valid_ppa_repair_rate": (
                    "0.5"
                    if arm == "treatment" and problem == "ProbA"
                    else "0.0"
                ),
                "direct_rtl_repairs": (
                    "1" if arm == "treatment" and problem == "ProbA" else "0"
                ),
                "direct_valid_ppa_repairs": (
                    "1" if arm == "treatment" and problem == "ProbA" else "0"
                ),
                "fail_parent_requests": "1",
                "conditional_rtl_simulation_repair_yield": "1.0",
                "conditional_valid_ppa_repair_yield": "1.0",
                "first_direct_valid_ppa_generation": "1",
                "recovered_design": "1",
                "direct_repair_stage_transitions": "{}",
            }
            for arm in report.ARMS
            for problem in problems
        }
        return (
            mechanism,
            {("classic", "ProbA"): 0.1, ("h5", "ProbA"): 0.12},
            {("classic", "ProbA"): (0.1, 0.08), ("h5", "ProbA"): (0.12, 0.1)},
        )

    monkeypatch.setattr(report, "_read_arm", fake_arm)
    monkeypatch.setattr(report, "_read_seed_package", fake_package)
    monkeypatch.setattr(report, "_read_run_wall", lambda _root: 10.0)
    for seed in (1001, 1002):
        for problem in ("ProbA",):
            problem_dir = raw_root / f"seed_{seed}" / "treatment" / problem
            problem_dir.mkdir(parents=True)
            (problem_dir / "failed_parent_repair_pool_telemetry.jsonl").write_text(
                json.dumps(
                    {
                        "generation": 1,
                        "pre_selection_fail_pool_size": 1,
                        "pre_selection_success_pool_size": 0,
                        "post_selection_fail_pool_size": 0,
                        "post_selection_success_pool_size": 1,
                        "generation_outcome": "completed",
                    }
                )
                + "\n",
                encoding="utf-8",
            )

    summary = report.generate_report(manifest, tmp_path / "output")
    assert summary["expected_problem_seed_units"] == 4
    assert summary["expected_headline_problem_seed_units"] == 2
    assert summary["statistics"]["rtl_simulation_functionality_50"]["unit_count"] == 4
    assert summary["statistics"]["rtl_simulation_functionality_46"]["unit_count"] == 2
    assert summary["metric_aliases"] == {
        "unconditional_fail_origin_valid_ppa_repairs_per_48_candidates_all_50": (
            "unconditional_valid_ppa_repair_rate_all_50"
        )
    }
    assert summary["gate_results"]["repair_benefit_each_seed"] is True
    assert summary["gate_results"]["candidate_budget_equality"] is False
    assert summary["performance_gate"] == "RETIRED"
    treatment_resources = [
        row for row in summary["resource_totals"] if row["arm"] == "treatment"
    ]
    assert {row["missing_unit_count"] for row in treatment_resources} == {1}
    assert {row["candidate_count"] for row in treatment_resources} == {2}
