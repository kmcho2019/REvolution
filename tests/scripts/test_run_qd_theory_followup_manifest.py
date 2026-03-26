from __future__ import annotations

import importlib
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

FOLLOWUP_MANIFEST = importlib.import_module("scripts.run_qd_theory_followup_manifest")


def test_build_run_plan_applies_smoke_budget_and_filters(tmp_path, monkeypatch):
    manifest_path = tmp_path / "manifest.json"
    manifest_path.write_text(
        json.dumps(
            {
                "save_root": "runs",
                "min_model_len": 128000,
                "defaults": {
                    "qd_num_cells": 16,
                    "qd_cvt_warmup_successes": 4,
                    "population_size": 4,
                    "num_generations": 2,
                    "total_worker_slots": 2,
                    "max_workers_per_problem": 1,
                    "evaluation_mode": "strict_ablation",
                    "temperature": 0.3,
                    "top_p": 0.95,
                    "max_tokens": 128000,
                    "diff_max_tokens": 128000,
                    "seed": 42,
                },
                "profiles": [
                    {
                        "name": "implemented_structural_fixed_5d",
                        "label": "cvt_structural_fixed",
                    },
                    {
                        "name": "theory_grounded_full_20d",
                        "label": "cvt_theory_grounded",
                    },
                ],
                "cases": [
                    {
                        "name": "rtllm_core_pair",
                        "benchmark": "RTLLM",
                        "problems": ["Prob001_accu", "Prob002_adder_16bit"],
                    },
                    {
                        "name": "verilogeval_core_pair",
                        "benchmark": "VerilogEval-Spec-to-RTL",
                        "problems": ["Prob001_zero", "Prob017_mux2to1v"],
                    },
                ],
            }
        ),
        encoding="utf-8",
    )

    monkeypatch.setattr(
        FOLLOWUP_MANIFEST,
        "fetch_model_info",
        lambda **kwargs: FOLLOWUP_MANIFEST.ModelInfo(
            name="stub-model",
            max_model_len=131072,
        ),
    )

    plan = FOLLOWUP_MANIFEST.build_run_plan(
        FOLLOWUP_MANIFEST.load_manifest(manifest_path),
        case_filters=["rtllm_core_pair"],
        profile_filters=["theory_grounded_full_20d"],
        smoke_budget=True,
        run_tag="stage5-smoke",
    )

    assert plan["run_root"] == str(tmp_path / "runs" / "stage5-smoke")
    assert plan["model_info"]["name"] == "stub-model"
    assert len(plan["commands"]) == 1

    command = plan["commands"][0]["command"]
    normalized = " ".join(command)
    assert "--qd_descriptor_profile theory_grounded_full_20d" in normalized
    assert "--population_size 1" in normalized
    assert "--num_generations 0" in normalized
    assert "--total_worker_slots 1" in normalized
    assert "--max_workers_per_problem 1" in normalized
    assert "--benchmarks RTLLM" in normalized
    assert "--problems Prob001_accu Prob002_adder_16bit" in normalized

    rendered = FOLLOWUP_MANIFEST.render_plan(plan)
    assert "stub-model" in rendered
    assert "[rtllm_core_pair/cvt_theory_grounded]" in rendered
