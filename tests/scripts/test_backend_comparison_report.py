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


def _write_generation_log(root: Path, benchmark: str, problem: str, payloads: list[dict]) -> None:
    problem_dir = root / "model-x" / benchmark / problem
    problem_dir.mkdir(parents=True, exist_ok=True)
    (problem_dir / "generation_log.jsonl").write_text(
        "\n".join(json.dumps(payload) for payload in payloads) + "\n",
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


def test_backend_comparison_report_accepts_codeevolve_label(tmp_path):
    codeevolve_root = tmp_path / "codeevolve"
    _write_summary(
        codeevolve_root,
        "Bench",
        "Prob001",
        {
            "benchmark_name": "Bench",
            "problem_name": "Prob001",
            "stage_success_rates": {"functionality": 1.0, "synthesis": 1.0},
            "final_population_ppa": {
                "best_score": 0.3,
                "best_metrics": {"area": 70.0, "power": 0.7, "eff_clk_period": 0.7},
            },
            "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
            "total_runtime_seconds": 1.5,
            "total_llm_api_calls": 4,
            "total_llm_prompt_tokens": 40,
            "total_llm_completion_tokens": 12,
            "run_budget": {
                "primary_budget_axis": "candidate_evaluations",
                "max_evaluations": 12,
                "max_llm_calls": 12,
            },
        },
    )

    output_path = tmp_path / "comparison.md"
    cmd = [
        sys.executable,
        "scripts/backend_comparison_report.py",
        "--backend_run",
        f"codeevolve={codeevolve_root}",
        "--output",
        str(output_path),
    ]
    subprocess.run(cmd, check=True, cwd=Path(__file__).resolve().parents[2])
    text = output_path.read_text(encoding="utf-8")
    assert "`codeevolve`" in text
    assert "Prob001" in text


def test_backend_comparison_report_ignores_qd_sidecar_summary_and_renders_qd_section(tmp_path):
    qd_root = tmp_path / "revolution_qd"
    problem_dir = qd_root / "model-x" / "Bench" / "Prob001"
    problem_dir.mkdir(parents=True, exist_ok=True)
    (problem_dir / "Prob001_summary.json").write_text(
        json.dumps(
            {
                "benchmark_name": "Bench",
                "problem_name": "Prob001",
                "backend_details": {
                    "search_mode": "revolution_qd",
                    "qd_config": {"archive_type": "cvt"},
                },
                "accumulated_success_rates": {"functionality": 1.0, "synthesis_ppa": 1.0},
                "final_population_ppa": {
                    "best_score": 0.25,
                    "best_metrics": {"area": 75.0, "power": 0.8, "eff_clk_period": 0.85},
                },
                "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
                "total_runtime_seconds": 4.0,
                "total_llm_api_calls": 5,
                "total_llm_prompt_tokens": 50,
                "total_llm_completion_tokens": 25,
                "run_budget": {
                    "primary_budget_axis": "candidate_evaluations",
                    "max_evaluations": 8,
                    "max_llm_calls": 8,
                },
            },
            indent=2,
        ),
        encoding="utf-8",
    )
    (problem_dir / "archive_summary.json").write_text(
        json.dumps(
            {
                "archive_type": "cvt",
                "num_cells": 8,
                "occupied_cells": 3,
                "coverage": 0.375,
                "qd_score": 1.75,
                "best_quality": 0.4,
                "mean_quality": 0.2,
                "descriptor_profile": "wire_ctrl_assign_3d",
                "descriptor_axes": [
                    "wire_count_log_est",
                    "ctrl_depth_est",
                    "assign_count",
                ],
            },
            indent=2,
        ),
        encoding="utf-8",
    )
    (problem_dir / "descriptor_health.json").write_text(
        json.dumps(
            {
                "archive_type": "cvt",
                "descriptor_profile": "wire_ctrl_assign_3d",
                "descriptor_axes": [
                    "wire_count_log_est",
                    "ctrl_depth_est",
                    "assign_count",
                ],
                "observation_count": 6,
                "archive_entry_count": 3,
                "collapsed_axes": ["ctrl_depth_est"],
                "decision_counts": {
                    "filled_empty": 2,
                    "replaced_elite": 1,
                    "not_inserted": 3,
                },
            },
            indent=2,
        ),
        encoding="utf-8",
    )

    output_path = tmp_path / "comparison.md"
    cmd = [
        sys.executable,
        "scripts/backend_comparison_report.py",
        "--backend_run",
        f"revolution={qd_root}",
        "--output",
        str(output_path),
    ]
    subprocess.run(cmd, check=True, cwd=Path(__file__).resolve().parents[2])
    text = output_path.read_text(encoding="utf-8")

    assert text.count("Prob001 |") == 4
    assert "## QD Archive Metrics" in text
    assert "| `revolution` | Bench | Prob001 | cvt | 37.5% | 1.7500 | 0.4000 | 3/8 |" in text
    assert "## QD Descriptor Health" in text
    assert "wire_ctrl_assign_3d" in text
    assert "ctrl_depth_est" in text
    assert "filled_empty=2, not_inserted=3, replaced_elite=1" in text


def test_backend_comparison_report_renders_pareto_sections(tmp_path):
    classic_root = tmp_path / "classic"
    qd_root = tmp_path / "cvt_struct"
    _write_summary(
        classic_root,
        "Bench",
        "Prob001",
        {
            "benchmark_name": "Bench",
            "problem_name": "Prob001",
            "accumulated_success_rates": {"functionality": 1.0, "synthesis_ppa": 1.0},
            "final_population_ppa": {
                "best_score": 0.1,
                "best_metrics": {"area": 95.0, "power": 0.95, "eff_clk_period": 0.95},
            },
            "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
        },
    )
    _write_generation_log(
        classic_root,
        "Bench",
        "Prob001",
        [
            {
                "generation": 0,
                "population_ppa_details": [
                    {
                        "id": "classic_a",
                        "strategy": "seed",
                        "score": 0.1,
                        "ppa_metrics": {
                            "area": 95.0,
                            "power": 0.95,
                            "eff_clk_period": 0.95,
                            "report_path": "/tmp/classic_a.rpt",
                        },
                    }
                ],
            }
        ],
    )
    _write_summary(
        qd_root,
        "Bench",
        "Prob001",
        {
            "benchmark_name": "Bench",
            "problem_name": "Prob001",
            "accumulated_success_rates": {"functionality": 1.0, "synthesis_ppa": 1.0},
            "final_population_ppa": {
                "best_score": 0.2,
                "best_metrics": {"area": 88.0, "power": 0.9, "eff_clk_period": 0.9},
            },
            "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
        },
    )
    _write_generation_log(
        qd_root,
        "Bench",
        "Prob001",
        [
            {
                "generation": 0,
                "population_ppa_details": [
                    {
                        "id": "qd_a",
                        "strategy": "seed",
                        "score": 0.2,
                        "ppa_metrics": {
                            "area": 90.0,
                            "power": 0.92,
                            "eff_clk_period": 0.91,
                            "report_path": "/tmp/qd_a.rpt",
                        },
                    },
                    {
                        "id": "qd_b",
                        "strategy": "mutate",
                        "score": 0.22,
                        "ppa_metrics": {
                            "area": 88.0,
                            "power": 0.9,
                            "eff_clk_period": 0.9,
                            "report_path": "/tmp/qd_b.rpt",
                        },
                    },
                ],
            }
        ],
    )

    output_path = tmp_path / "comparison.md"
    cmd = [
        sys.executable,
        "scripts/backend_comparison_report.py",
        "--backend_run",
        f"classic={classic_root}",
        "--backend_run",
        f"cvt_struct={qd_root}",
        "--output",
        str(output_path),
    ]
    subprocess.run(cmd, check=True, cwd=Path(__file__).resolve().parents[2])
    text = output_path.read_text(encoding="utf-8")

    assert "## Pareto / Multi-Objective Metrics" in text
    assert "## Aggregate Pareto Metrics (All Benchmarks)" in text
    assert "Multi-objective winner: `cvt_struct`" in text
