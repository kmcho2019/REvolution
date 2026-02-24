import json
import sys
from pathlib import Path
import pytest


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from scripts.run_diff_mode_benchmark import (  # noqa: E402
    build_diff_failure_catalog,
    compare_mode_summaries,
    main as run_diff_mode_benchmark_main,
    parse_baseline_functionality_rates,
    select_cvdp_medium_long_prompt_ids,
    select_cvdp_ids,
    select_hard_problems,
    summarize_problem_summaries,
)


def test_parse_baseline_functionality_rates_filters_backend(tmp_path):
    report = tmp_path / "report.md"
    report.write_text(
        "\n".join(
            [
                "| Backend | Benchmark | Problem | Functionality |",
                "|:---|:---|:---|:---|",
                "| `revolution` | RTLLM | ProbA | ✅ Pass (12.5%) |",
                "| `funsearch` | RTLLM | ProbB | ✅ Pass (50.0%) |",
                "| `revolution` | VerilogEval-Spec-to-RTL | ProbC | ❌ Fail (0.0%) |",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    out = parse_baseline_functionality_rates(report, backend="revolution")
    assert out["RTLLM"] == [("ProbA", 12.5)]
    assert out["VerilogEval-Spec-to-RTL"] == [("ProbC", 0.0)]


def test_select_hard_problems_prefers_low_baseline_rates():
    rows = {
        "RTLLM": [
            ("p_high", 95.0),
            ("p_mid", 50.0),
            ("p_low", 10.0),
        ]
    }
    chosen = select_hard_problems(
        "RTLLM",
        2,
        baseline_rows=rows,
        max_baseline_functionality=70.0,
    )
    assert chosen == ["p_low", "p_mid"]


def test_select_cvdp_ids_prioritizes_requested_categories(tmp_path):
    dataset = tmp_path / "cvdp.jsonl"
    dataset.write_text(
        "\n".join(
            [
                json.dumps({"id": "a", "categories": ["easy"]}),
                json.dumps({"id": "b", "categories": ["hard"]}),
                json.dumps({"id": "c", "categories": ["medium"]}),
                json.dumps({"id": "d", "categories": ["hard", "medium"]}),
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    chosen = select_cvdp_ids(dataset, 3, preferred_categories=["hard", "medium"])
    assert chosen == ["b", "d", "c"]


def test_select_cvdp_medium_long_prompt_ids_prefers_larger_inputs(tmp_path):
    dataset = tmp_path / "cvdp.jsonl"
    dataset.write_text(
        "\n".join(
            [
                json.dumps({"id": "x1", "categories": ["cid002", "medium"], "input": "a" * 10}),
                json.dumps({"id": "x2", "categories": ["cid003", "medium"], "input": "a" * 200}),
                json.dumps({"id": "x3", "categories": ["cid003", "hard"], "input": "a" * 300}),
                json.dumps({"id": "x4", "categories": ["cid004", "medium"], "input": "a" * 400}),
                json.dumps({"id": "x5", "categories": ["cid002", "medium"], "input": "a" * 100}),
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    out = select_cvdp_medium_long_prompt_ids(dataset, 3, required_categories=("cid002", "cid003"))
    assert out == ["x2", "x5", "x1"]


def test_summarize_problem_summaries_aggregates_metrics(tmp_path):
    root = tmp_path / "run"
    p1 = root / "m" / "RTLLM" / "Prob001" / "Prob001_summary.json"
    p1.parent.mkdir(parents=True, exist_ok=True)
    p1.write_text(
        json.dumps(
            {
                "benchmark_name": "RTLLM",
                "total_llm_prompt_tokens": 100,
                "total_llm_completion_tokens": 50,
                "total_runtime_seconds": 10.0,
                "total_llm_api_calls": 4,
                "accumulated_diff_stats": {"attempts": 2, "failed": 1},
                "accumulated_success_rates": {"functionality": 0.5, "synthesis_ppa": 0.25},
            }
        ),
        encoding="utf-8",
    )
    p2 = root / "m" / "VerilogEval-Spec-to-RTL" / "Prob002" / "Prob002_summary.json"
    p2.parent.mkdir(parents=True, exist_ok=True)
    p2.write_text(
        json.dumps(
            {
                "benchmark_name": "VerilogEval-Spec-to-RTL",
                "total_llm_prompt_tokens": 40,
                "total_llm_completion_tokens": 10,
                "total_runtime_seconds": 5.0,
                "total_llm_api_calls": 2,
                "accumulated_diff_stats": {"attempts": 0, "failed": 0},
                "accumulated_success_rates": {"functionality": 1.0, "synthesis_ppa": 0.5},
            }
        ),
        encoding="utf-8",
    )

    out = summarize_problem_summaries(root)
    assert out["problem_count"] == 2
    assert out["total_tokens"] == 200
    assert out["total_runtime_seconds"] == 15.0
    assert out["total_llm_api_calls"] == 6
    assert out["diff_attempts"] == 2
    assert out["diff_failed"] == 1
    assert out["avg_functionality_rate"] == 0.75
    assert out["avg_synthesis_rate"] == 0.375


def test_build_diff_failure_catalog_groups_reason_codes(tmp_path):
    root = tmp_path / "run"
    a = root / "x_diff_apply_error.json"
    b = root / "nested" / "y_diff_apply_error.json"
    b.parent.mkdir(parents=True, exist_ok=True)
    a.write_text(
        json.dumps(
            {
                "reason_code": "ambiguous_fuzzy_match",
                "reason": "x",
                "diagnostics": {"phase": "legacy"},
            }
        ),
        encoding="utf-8",
    )
    b.write_text(
        json.dumps(
            {
                "reason_code": "ambiguous_fuzzy_match",
                "reason": "y",
                "diagnostics": {"phase": "json"},
            }
        ),
        encoding="utf-8",
    )
    out = build_diff_failure_catalog(root, max_examples_per_reason=1)
    assert out["counts"]["ambiguous_fuzzy_match"] == 2
    assert len(out["examples"]["ambiguous_fuzzy_match"]) == 1


def test_compare_mode_summaries_reports_token_and_runtime_deltas():
    whole = {
        "total_tokens": 1000,
        "total_runtime_seconds": 100.0,
        "avg_functionality_rate": 0.9,
        "avg_synthesis_rate": 0.8,
    }
    diff = {
        "total_tokens": 800,
        "total_runtime_seconds": 90.0,
        "avg_functionality_rate": 0.88,
        "avg_synthesis_rate": 0.78,
    }
    out = compare_mode_summaries(whole, diff)
    assert out["token_savings_vs_whole"] == 200
    assert out["runtime_speedup_vs_whole_seconds"] == 10.0
    assert out["avg_functionality_delta"] == pytest.approx(-0.02)


def test_main_command_builder_includes_matched_seed(monkeypatch, tmp_path):
    recorded_cmds = []

    monkeypatch.setattr(
        "scripts.run_diff_mode_benchmark.preflight_vllm_model",
        lambda **_kwargs: {
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": "m",
            "max_model_len": 131072,
            "warning": None,
        },
    )
    monkeypatch.setattr(
        "scripts.run_diff_mode_benchmark.parse_baseline_functionality_rates",
        lambda *_args, **_kwargs: {"RTLLM": [("Prob001_accu", 1.0)]},
    )
    monkeypatch.setattr(
        "scripts.run_diff_mode_benchmark._run_command",
        lambda cmd, _log, dry_run=False: recorded_cmds.append(cmd) or 0,
    )
    monkeypatch.setattr(
        "scripts.run_diff_mode_benchmark.summarize_problem_summaries",
        lambda *_args, **_kwargs: {
            "problem_count": 0,
            "total_tokens": 0,
            "total_prompt_tokens": 0,
            "total_completion_tokens": 0,
            "total_runtime_seconds": 0.0,
            "total_llm_api_calls": 0,
            "avg_functionality_rate": None,
            "avg_synthesis_rate": None,
            "diff_attempts": 0,
            "diff_failed": 0,
            "diff_pass_rate": None,
            "by_benchmark": {},
        },
    )
    monkeypatch.setattr(
        "scripts.run_diff_mode_benchmark.build_diff_failure_catalog",
        lambda *_args, **_kwargs: {"counts": {}, "examples": {}},
    )

    rc = run_diff_mode_benchmark_main(
        [
            "--benchmarks",
            "RTLLM",
            "--model_name",
            "m",
            "--api_backend",
            "vllm",
            "--vllm_host",
            "vllm",
            "--vllm_port",
            "8888",
            "--save_root",
            str(tmp_path / "out"),
            "--rtllm_count",
            "1",
            "--seeds",
            "17",
            "--num_generations",
            "1",
            "--population_size",
            "1",
        ]
    )
    assert rc == 0
    assert recorded_cmds
    assert len(recorded_cmds) == 2  # whole + diff for one benchmark, one seed
    for cmd in recorded_cmds:
        assert "--candidate_workers" not in cmd
        assert "--seed" in cmd
        seed_idx = cmd.index("--seed")
        assert cmd[seed_idx + 1] == "17"


def test_main_plan_default_rtllm_selection_uses_fixed_matrix(monkeypatch, tmp_path):
    recorded_cmds = []

    monkeypatch.setattr(
        "scripts.run_diff_mode_benchmark.preflight_vllm_model",
        lambda **_kwargs: {
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": "m",
            "max_model_len": 131072,
            "warning": None,
        },
    )
    monkeypatch.setattr(
        "scripts.run_diff_mode_benchmark._run_command",
        lambda cmd, _log, dry_run=False: recorded_cmds.append(cmd) or 0,
    )
    monkeypatch.setattr(
        "scripts.run_diff_mode_benchmark.summarize_problem_summaries",
        lambda *_args, **_kwargs: {
            "problem_count": 0,
            "total_tokens": 0,
            "total_prompt_tokens": 0,
            "total_completion_tokens": 0,
            "total_runtime_seconds": 0.0,
            "total_llm_api_calls": 0,
            "avg_functionality_rate": None,
            "avg_synthesis_rate": None,
            "diff_attempts": 0,
            "diff_failed": 0,
            "diff_pass_rate": None,
            "by_benchmark": {},
        },
    )
    monkeypatch.setattr(
        "scripts.run_diff_mode_benchmark.build_diff_failure_catalog",
        lambda *_args, **_kwargs: {"counts": {}, "examples": {}},
    )
    rc = run_diff_mode_benchmark_main(
        [
            "--benchmarks",
            "RTLLM",
            "--model_name",
            "m",
            "--save_root",
            str(tmp_path / "out"),
            "--rtllm_count",
            "2",
            "--seeds",
            "5",
        ]
    )
    assert rc == 0
    assert recorded_cmds
    first = recorded_cmds[0]
    assert "--problems" in first
    idx = first.index("--problems")
    assert first[idx + 1 : idx + 3] == ["Prob026_asyn_fifo", "Prob033_freq_divbyfrac"]
