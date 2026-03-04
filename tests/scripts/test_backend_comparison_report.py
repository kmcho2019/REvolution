import json
import subprocess
import sys
from unittest import mock
from pathlib import Path

import pytest


@pytest.fixture
def mocker(request):
    """Local fallback for environments without pytest-mock."""

    patchers = []

    class _Mocker:
        def patch(self, target: str, *args, **kwargs):
            patcher = mock.patch(target, *args, **kwargs)
            patchers.append(patcher)
            return patcher.start()

    instance = _Mocker()
    request.addfinalizer(lambda: [patcher.stop() for patcher in reversed(patchers)])
    return instance


def _write_summary(root: Path, benchmark: str, problem: str, payload: dict) -> None:
    problem_dir = root / "model-x" / benchmark / problem
    problem_dir.mkdir(parents=True, exist_ok=True)
    (problem_dir / f"{problem}_summary.json").write_text(
        json.dumps(payload, indent=2),
        encoding="utf-8",
    )


def test_backend_comparison_report_generates_markdown(tmp_path):
    rev_root = tmp_path / "revolution"
    fs_root = tmp_path / "funsearch"
    _write_summary(
        rev_root,
        "Bench",
        "Prob001",
        {
            "benchmark_name": "Bench",
            "problem_name": "Prob001",
            "accumulated_success_rates": {"functionality": 1.0, "synthesis_ppa": 0.5},
            "final_population_ppa": {
                "best_score": 0.1,
                "best_metrics": {"area": 90.0, "power": 0.9, "eff_clk_period": 0.9},
            },
            "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
            "total_runtime_seconds": 2.0,
            "total_llm_api_calls": 3,
            "total_llm_prompt_tokens": 30,
            "total_llm_completion_tokens": 10,
            "run_budget": {
                "primary_budget_axis": "candidate_evaluations",
                "max_evaluations": 10,
                "max_llm_calls": 10,
            },
        },
    )
    _write_summary(
        fs_root,
        "Bench",
        "Prob001",
        {
            "benchmark_name": "Bench",
            "problem_name": "Prob001",
            "stage_success_rates": {"functionality": 1.0, "synthesis": 1.0},
            "final_population_ppa": {
                "best_score": 0.2,
                "best_metrics": {"area": 80.0, "power": 0.8, "eff_clk_period": 0.8},
            },
            "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
            "total_runtime_seconds": 1.0,
            "total_llm_api_calls": 2,
            "total_llm_prompt_tokens": 20,
            "total_llm_completion_tokens": 10,
            "run_budget": {
                "primary_budget_axis": "candidate_evaluations",
                "max_evaluations": 10,
                "max_llm_calls": 10,
            },
        },
    )

    output_path = tmp_path / "comparison.md"
    cmd = [
        sys.executable,
        "scripts/backend_comparison_report.py",
        "--backend_run",
        f"revolution={rev_root}",
        "--backend_run",
        f"funsearch={fs_root}",
        "--output",
        str(output_path),
    ]
    subprocess.run(cmd, check=True, cwd=Path(__file__).resolve().parents[2])
    text = output_path.read_text(encoding="utf-8")
    assert "`revolution`" in text
    assert "`funsearch`" in text
    assert "Prob001" in text
    assert "Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral." in text
    assert "Budget and Fairness Diagnostics" in text
    assert "candidate_evaluations" in text
    assert "Aggregate Backend Metrics by Benchmark" in text
    assert "Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌)" in text
    assert "✅ Pass (100.0%)" in text
    assert "Score/PPA aggregate metrics exclude failed designs" in text


def test_backend_comparison_report_excludes_failed_designs_from_aggregates(tmp_path):
    fs_root = tmp_path / "funsearch"
    _write_summary(
        fs_root,
        "Bench",
        "ProbPass",
        {
            "benchmark_name": "Bench",
            "problem_name": "ProbPass",
            "accumulated_success_rates": {"functionality": 1.0, "synthesis_ppa": 1.0},
            "final_population_ppa": {
                "best_score": 0.2,
                "best_metrics": {"area": 90.0, "power": 1.8, "eff_clk_period": 0.9},
            },
            "ref_ppa_metric": {"area": 100.0, "power": 2.0, "eff_clk_period": 1.0},
            "total_runtime_seconds": 2.0,
            "total_llm_api_calls": 3,
            "total_llm_prompt_tokens": 15,
            "total_llm_completion_tokens": 5,
            "run_budget": {
                "primary_budget_axis": "candidate_evaluations",
                "max_evaluations": 2,
            },
        },
    )
    _write_summary(
        fs_root,
        "Bench",
        "ProbFail",
        {
            "benchmark_name": "Bench",
            "problem_name": "ProbFail",
            "accumulated_success_rates": {"functionality": 0.5, "synthesis_ppa": 0.0},
            "final_population_ppa": {"best_score": float("-inf"), "best_metrics": {}},
            "ref_ppa_metric": {"area": 100.0, "power": 2.0, "eff_clk_period": 1.0},
            "total_runtime_seconds": 5.0,
            "total_llm_api_calls": 7,
            "total_llm_prompt_tokens": 70,
            "total_llm_completion_tokens": 20,
            "run_budget": {
                "primary_budget_axis": "candidate_evaluations",
                "max_evaluations": 2,
            },
        },
    )

    output_path = tmp_path / "comparison.md"
    cmd = [
        sys.executable,
        "scripts/backend_comparison_report.py",
        "--backend_run",
        f"funsearch={fs_root}",
        "--output",
        str(output_path),
    ]
    subprocess.run(cmd, check=True, cwd=Path(__file__).resolve().parents[2])
    text = output_path.read_text(encoding="utf-8")
    assert "-inf" not in text
    assert "❌ Fail (0.0%)" in text

    agg_row = next(
        line
        for line in text.splitlines()
        if line.startswith("| `funsearch` | Bench | 2 |")
    )
    assert "| 1/2 | +20.00% ± 0.00% ✅ | ✅ 1 / ➖ 0 / ❌ 0 |" in agg_row
    assert (
        "| +10.00% ± 0.00% ✅ / +10.00% ± 0.00% ✅ / +10.00% ± 0.00% ✅ |" in agg_row
    )
    assert (
        "| 1/2 | +10.00% ± 0.00% ✅ | +10.00% ± 0.00% ✅ / +10.00% ± 0.00% ✅ / "
        "+10.00% ± 0.00% ✅ | ✅ 1 / ➖ 0 / ❌ 0 |" in agg_row
    )
