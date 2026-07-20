from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

import pytest

_REPO_ROOT = Path(__file__).resolve().parent.parent.parent
_SCRIPT_PATH = _REPO_ROOT / "scripts" / "report_revolution_operator_evidence.py"
_SPEC = importlib.util.spec_from_file_location(
    "report_revolution_operator_evidence", _SCRIPT_PATH
)
assert _SPEC is not None and _SPEC.loader is not None
report = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_revolution_operator_evidence", report)
_SPEC.loader.exec_module(report)


def _write_log(root: Path, status: str = "success") -> None:
    path = root / "seed_1001" / "model" / "RTLLM" / "Prob001" / "generation_log.jsonl"
    path.parent.mkdir(parents=True)
    rows = [
        {
            "generation": 0,
            "generated_candidates": [
                {
                    "status": "failed_functionality",
                    "origin_pool": "initial",
                    "strategy": "initial",
                },
                {"status": "success", "origin_pool": "initial", "strategy": "initial"},
            ],
            "strategy_rewards_this_generation": {"fail_pool": {}, "success_pool": {}},
            "strategy_counts_for_each_origin_pool": {
                "fail_pool": {},
                "success_pool": {},
                "initial_pool": {"initial": 2},
            },
            "average_strategy_probabilities": {"fail_pool": {}, "success_pool": {}},
            "llm_api_calls": 2,
            "llm_prompt_tokens": 20,
            "llm_completion_tokens": 10,
            "runtime_seconds": 3.0,
        },
        {
            "generation": 1,
            "generated_candidates": [
                {"status": status, "origin_pool": "fail_pool", "strategy": "M-F"},
                {
                    "status": "failed_syntax",
                    "origin_pool": "fail_pool",
                    "strategy": "M-F",
                },
                {"status": "success", "origin_pool": "success_pool", "strategy": "M-S"},
            ],
            "strategy_rewards_this_generation": {
                "fail_pool": {"M-F": 1},
                "success_pool": {"M-S": 1},
            },
            "strategy_counts_for_each_origin_pool": {
                "fail_pool": {"M-F": 2},
                "success_pool": {"M-S": 1},
                "initial_pool": {},
            },
            "average_strategy_probabilities": {
                "fail_pool": {"M-F": 1.0},
                "success_pool": {"M-S": 1.0},
            },
            "llm_api_calls": 3,
            "llm_prompt_tokens": 30,
            "llm_completion_tokens": 15,
            "runtime_seconds": 4.0,
        },
    ]
    path.write_text("\n".join(json.dumps(row) for row in rows) + "\n")


def test_report_operator_yields(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    _write_log(run_root)
    output = tmp_path / "report"
    assert (
        report.main(["--run", f"classic={run_root}", "--output-dir", str(output)]) == 0
    )

    with (output / "operator_yield.csv").open(newline="", encoding="utf-8") as handle:
        rows = {
            (row["origin_pool"], row["strategy"]): row for row in csv.DictReader(handle)
        }
    fail = rows[("fail_pool", "M-F")]
    assert fail["candidate_count"] == "2"
    assert float(fail["syntax_pass_rate"]) == pytest.approx(0.5)
    assert float(fail["pre_synthesis_functional_pass_rate"]) == pytest.approx(0.5)
    assert float(fail["valid_ppa_success_rate"]) == pytest.approx(0.5)
    assert float(fail["rewarded_child_rate"]) == pytest.approx(0.5)
    assert (output / "status_distribution.csv").is_file()
    with (output / "fail_policy_by_generation.csv").open(
        newline="", encoding="utf-8"
    ) as handle:
        policy = list(csv.DictReader(handle))
    assert len(policy) == 1
    assert policy[0]["fail_parent_requests"] == "2"
    assert policy[0]["m_f_request_fraction"] == "1"
    assert policy[0]["mean_total_variation_from_uniform"] == "0"
    assert (output / "fail_policy_units.csv").is_file()
    summary = json.loads((output / "summary.json").read_text())
    assert summary["arms"][0]["llm_api_calls"] == 5
    assert summary["arms"][0]["llm_prompt_tokens"] == 50
    assert summary["arms"][0]["llm_completion_tokens"] == 25
    assert summary["arms"][0]["runtime_seconds"] == 7.0
    assert "adaptive policy" in (output / "report.md").read_text()


def test_report_rejects_unknown_status(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    _write_log(run_root, status="unknown")
    with pytest.raises(AssertionError):
        report.generate_operator_evidence_report(
            [("classic", run_root)], tmp_path / "report"
        )
