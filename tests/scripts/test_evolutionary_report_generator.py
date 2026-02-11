import json
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from scripts.evolutionary_report_generator import analyze_experiments  # noqa: E402


def _write_problem(
    root: Path,
    benchmark: str,
    problem: str,
    summary_payload: dict,
    generation_payload: dict,
) -> None:
    problem_dir = root / benchmark / problem
    problem_dir.mkdir(parents=True, exist_ok=True)
    (problem_dir / f"{problem}_summary.json").write_text(
        json.dumps(summary_payload, indent=2),
        encoding="utf-8",
    )
    (problem_dir / "generation_log.jsonl").write_text(
        json.dumps(generation_payload) + "\n",
        encoding="utf-8",
    )


def test_report_generator_handles_legacy_and_new_schema(tmp_path):
    model_root = tmp_path / "model-x"
    legacy_summary = {
        "problem_name": "ProbLegacy",
        "benchmark_name": "BenchA",
        "backend_name": "revolution",
        "accumulated_success_rates": {
            "syntax": 1.0,
            "functionality": 0.5,
            "synthesis_ppa": 0.5,
        },
        "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
        "final_population_ppa": {
            "best_score": 0.1,
            "best_metrics": {"area": 90.0, "power": 0.9, "eff_clk_period": 0.9},
        },
        "accumulated_strategy_counts:": {"M-I": 4},
        "accumulated_strategy_rewards": {"success_pool": {"M-I": 2}},
        "total_runtime_seconds": 1.0,
        "total_llm_api_calls": 2,
        "total_llm_prompt_tokens": 10,
        "total_llm_completion_tokens": 20,
    }
    new_summary = {
        "problem_name": "ProbNew",
        "benchmark_name": "BenchA",
        "backend_name": "funsearch",
        "stage_success_rates": {
            "syntax": 1.0,
            "functionality": 1.0,
            "synthesis": 1.0,
        },
        "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
        "final_population_ppa": {
            "best_score": 0.2,
            "best_metrics": {"area": 80.0, "power": 0.8, "eff_clk_period": 0.8},
        },
        "accumulated_strategy_counts": {},
        "accumulated_strategy_rewards": {},
        "total_runtime_seconds": 2.0,
        "total_llm_api_calls": 3,
        "total_llm_prompt_tokens": 30,
        "total_llm_completion_tokens": 40,
    }
    gen_payload = {
        "generation": 0,
        "success_rates": {
            "total_syntax": 1.0,
            "total_functionality": 1.0,
            "total_synthesis_ppa": 1.0,
        },
    }
    _write_problem(model_root, "BenchA", "ProbLegacy", legacy_summary, gen_payload)
    _write_problem(model_root, "BenchA", "ProbNew", new_summary, gen_payload)

    analyze_experiments(model_root, save_markdown=True)
    report_path = model_root / "BenchA_evolutionary_report.md"
    assert report_path.exists()
    content = report_path.read_text(encoding="utf-8")
    assert "Backend Mix" in content
    assert "`revolution`" in content
    assert "`funsearch`" in content
