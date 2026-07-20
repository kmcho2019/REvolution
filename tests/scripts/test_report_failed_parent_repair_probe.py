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
            }
        ),
        encoding="utf-8",
    )


def test_read_arm_enforces_resource_ceilings(tmp_path: Path) -> None:
    root = tmp_path / "run"
    _write_arm(root)
    rows = report._read_arm(root, ["Prob001"], 1, 1, 4, 100, 2)
    assert rows["Prob001"]["candidate_count"] == 2
    assert rows["Prob001"]["synthesis_evaluations"] == 2

    _write_arm(root, calls=5)
    with pytest.raises(AssertionError):
        report._read_arm(root, ["Prob001"], 1, 1, 4, 100, 2)


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
                "candidate_count": 2,
                "llm_calls": 4,
                "llm_tokens": 80,
                "synthesis_evaluations": 2,
                "rtl_simulation_functionality": 1.0,
                "verification_complete_valid_ppa": 1.0,
                "valid_ppa_sample_count": 2,
                "valid_ppa_sample_yield": 1.0,
                "best_normalized_ppa": 0.05 if treatment else 0.2,
            },
            "ProbB": {
                "candidate_count": 2,
                "llm_calls": 4,
                "llm_tokens": 80,
                "synthesis_evaluations": 0 if treatment else 1,
                "rtl_simulation_functionality": 0.0 if treatment else 1.0,
                "verification_complete_valid_ppa": 0.0 if treatment else 1.0,
                "valid_ppa_sample_count": 0 if treatment else 1,
                "valid_ppa_sample_yield": 0.0 if treatment else 0.5,
                "best_normalized_ppa": None if treatment else 0.1,
            },
        }

    def fake_package(
        _package: Path, _seed: int, _problems: list[str]
    ) -> tuple[
        dict[tuple[str, str], dict[str, str]],
        dict[tuple[str, str], float],
        dict[tuple[str, str], tuple[float, float]],
    ]:
        mechanism = {
            (arm, problem): {
                "unconditional_valid_ppa_repair_rate": (
                    "0.5" if arm == "treatment" and problem == "ProbA" else "0.0"
                ),
                "direct_valid_ppa_repairs": (
                    "1" if arm == "treatment" and problem == "ProbA" else "0"
                ),
                "fail_parent_requests": "1",
            }
            for arm in report.ARMS
            for problem in problems
        }
        pareto = {
            (label, problem): (
                0.2 if label == "h5" and problem == "ProbA" else
                0.1 if label == "classic" else 0.0
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
    output = tmp_path / "output"
    summary = report.generate_report(manifest, output)
    assert summary["expected_problem_seed_units"] == 4
    assert summary["validated_arm_units"] == 8
    assert summary["statistics"]["hypervolume_auc"]["unit_count"] == 4
    assert summary["statistics"]["best_normalized_ppa"]["imputed_loss_count"] == 2
    assert summary["statistics"]["best_normalized_ppa"]["mean_delta"] == pytest.approx(
        -0.075
    )

    with (output / "resource_by_unit.csv").open(newline="", encoding="utf-8") as handle:
        resources = list(csv.DictReader(handle))
    missing_ppa = [
        row
        for row in resources
        if row["arm"] == "treatment" and row["problem"] == "ProbB"
    ]
    assert len(missing_ppa) == 2
    assert {row["hypervolume_auc"] for row in missing_ppa} == {"0.0"}
