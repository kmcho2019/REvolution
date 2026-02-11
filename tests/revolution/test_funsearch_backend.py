import json
from pathlib import Path
from unittest.mock import MagicMock

import pytest

from revolution.backends import (
    BackendExecutionContext,
    BackendServices,
    FunSearchBackend,
    FunSearchBackendConfig,
)
from revolution.prompt_store import PromptStore
from revolution.runtime import ArtifactWriter, CandidateEvaluation, ProblemContext


class _FakeLLM:
    def __init__(self):
        self.counter = 0
        self.pending = {
            "api_calls": 0,
            "prompt_tokens": 0,
            "completion_tokens": 0,
            "code_prompt_tokens": 0,
            "code_completion_tokens": 0,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }

    async def generate_n_responses(
        self,
        prompt: str,
        n: int,
        temperature: float = 1.0,
        top_p: float = 0.95,
        max_tokens: int = 2048,
        generation_mode: str = "whole",
        system_prompt_override: str | None = None,
    ):
        out = []
        for _ in range(n):
            self.counter += 1
            out.append(
                (
                    f"thought {self.counter}",
                    f"module m_{self.counter}; endmodule\n",
                    {"format_ok": True, "raw": "", "parsed_mode": generation_mode},
                )
            )
        self.pending["api_calls"] += n
        self.pending["prompt_tokens"] += 10 * n
        self.pending["completion_tokens"] += 20 * n
        self.pending["code_prompt_tokens"] += 10 * n
        self.pending["code_completion_tokens"] += 20 * n
        return out

    async def generate_batch_feedback(self, *args, **kwargs):
        self.pending["api_calls"] += 1
        self.pending["prompt_tokens"] += 5
        self.pending["completion_tokens"] += 5
        self.pending["feedback_prompt_tokens"] += 5
        self.pending["feedback_completion_tokens"] += 5
        return [{"score": 10, "justification": "ok", "analysis": "good"}]

    async def get_and_reset_usage_stats(self):
        snapshot = dict(self.pending)
        for key in self.pending:
            self.pending[key] = 0
        return snapshot


class _FakeCandidateEvaluator:
    def __init__(self):
        self.calls = 0
        self.evaluation_mode = "strict_ablation"
        self.accelerated_synthesis_top_k = 1
        self.ref_ppa_metrics = {
            "power": 1.0,
            "area": 100.0,
            "eff_clk_period": 1.0,
        }

    def evaluate_candidate(self, item):
        self.calls += 1
        score = float(self.calls)
        return CandidateEvaluation(
            status="success",
            score=score,
            stage_statuses={
                "format": True,
                "diff": True,
                "syntax": True,
                "functionality": True,
                "synthesis": True,
                "synthesis_functionality": True,
                "ppa": True,
            },
            ppa_metrics={
                "area": 100.0 - score,
                "power": 1.0,
                "eff_clk_period": 1.0,
            },
            synthesis_success=True,
            synthesis_functionality_success=True,
            ppa_success=True,
            feedback_payload={
                "problem_def": "desc",
                "code": item.code,
                "simulation_log": "ok",
            },
        )

    def evaluate_candidates(self, items, *, candidate_workers: int = 0):
        return [self.evaluate_candidate(item) for item in items]


class _FakeFailingCandidateEvaluator(_FakeCandidateEvaluator):
    def evaluate_candidate(self, item):
        self.calls += 1
        return CandidateEvaluation(
            status="failed_syntax",
            score=float("-inf"),
            stage_statuses={
                "format": True,
                "diff": True,
                "syntax": False,
                "functionality": False,
                "synthesis": False,
                "synthesis_functionality": False,
                "ppa": False,
            },
            feedback_payload={
                "problem_def": "desc",
                "code": item.code,
                "simulation_log": "compile error",
            },
        )


def _write_funsearch_prompts(store: PromptStore, *, include_suffix: bool = True) -> None:
    store.write("system/whole", "system whole")
    store.write("feedback/system", "feedback system")
    store.write("feedback/user", "{problem_def} {code} {simulation_log}")
    store.write(
        "funsearch/prompt_header",
        "HEADER {problem_description} {sampled_programs_json} {target_version} {format_contract}",
    )
    store.write(
        "funsearch/program_block",
        "BLOCK {version} {score} {status} {thought} {code}",
    )
    store.write("funsearch/prompt_footer", "FOOTER {target_version}")
    if include_suffix:
        store.write("funsearch/eval_feedback_suffix", "suffix")


def _make_problem_context(tmp_path: Path) -> ProblemContext:
    bench = tmp_path / "bench" / "Bench"
    bench.mkdir(parents=True, exist_ok=True)
    prompt = bench / "Prob001_prompt.txt"
    test_sv = bench / "Prob001_test.sv"
    ref_sv = bench / "Prob001_ref.sv"
    prompt.write_text("build a module", encoding="utf-8")
    test_sv.write_text("module tb; endmodule\n", encoding="utf-8")
    ref_sv.write_text("module ref; endmodule\n", encoding="utf-8")
    return ProblemContext(
        benchmark_name="Bench",
        problem_name="Prob001",
        benchmark_path=bench,
        prompt_path=prompt,
        problem_description="build a module",
        test_sv_path=test_sv,
        ref_sv_path=ref_sv,
        top_module_names_path=bench / "synthesis_top_module_names.json",
    )


def _make_backend(
    tmp_path: Path,
    seed: int,
    include_suffix: bool = True,
    evaluator: _FakeCandidateEvaluator | None = None,
):
    store = PromptStore(root_dir=str(tmp_path / "prompts"), profile="funsearch")
    _write_funsearch_prompts(store, include_suffix=include_suffix)
    context = _make_problem_context(tmp_path)
    artifact_writer = ArtifactWriter(
        save_path=tmp_path / "exp",
        model_name="model/x",
        benchmark_name=context.benchmark_name,
        problem_name=context.problem_name,
    )
    services = BackendServices(
        llm=_FakeLLM(),
        verilog_evaluator=MagicMock(),
        synthesis_evaluator=MagicMock(),
        prompt_store=store,
        artifact_writer=artifact_writer,
        candidate_evaluator=evaluator or _FakeCandidateEvaluator(),
    )
    execution_context = BackendExecutionContext(
        backend_name="funsearch",
        model_name="model/x",
        benchmark_name=context.benchmark_name,
        problem_name=context.problem_name,
        problem_context=context,
        generation_mode="whole",
        seed=seed,
    )
    cfg = FunSearchBackendConfig(
        initial_population_size=2,
        samples_per_prompt=1,
        num_islands=4,
        functions_per_prompt=2,
        max_iterations=2,
        max_evaluations=6,
        strict_prompt_keys=True,
        score_reducer="fitness",
        seed=seed,
    )
    return FunSearchBackend(execution_context, services, cfg), artifact_writer


def test_funsearch_prompt_validation_fails_on_missing_required_key(tmp_path):
    backend, _ = _make_backend(tmp_path, seed=1, include_suffix=False)
    with pytest.raises(FileNotFoundError, match="Missing keys"):
        backend.initialize()


def test_funsearch_backend_run_writes_summary(tmp_path):
    backend, writer = _make_backend(tmp_path, seed=7)
    result = backend.run()
    assert result.status == "success"
    assert result.best_code_path
    summary = json.loads(writer.paths.summary_path.read_text(encoding="utf-8"))
    assert summary["backend_name"] == "funsearch"
    assert summary["backend_details"]["score_reducer"] == "fitness"
    assert summary["backend_details"]["feedback_policy"] == "off"
    assert summary["backend_details"]["evaluation_mode"] == "strict_ablation"
    assert summary["best_candidate"]["score"] is not None
    assert summary["accumulated_strategy_counts"] == {}
    assert "accumulated_strategy_counts:" in summary


def test_funsearch_backend_reproducible_with_fixed_seed(tmp_path):
    backend1, writer1 = _make_backend(tmp_path / "run1", seed=11)
    backend2, writer2 = _make_backend(tmp_path / "run2", seed=11)

    result1 = backend1.run()
    result2 = backend2.run()
    assert result1.status == "success"
    assert result2.status == "success"

    summary1 = json.loads(writer1.paths.summary_path.read_text(encoding="utf-8"))
    summary2 = json.loads(writer2.paths.summary_path.read_text(encoding="utf-8"))
    assert summary1["best_candidate"]["score"] == summary2["best_candidate"]["score"]
    assert (
        summary1["backend_details"]["cluster_counts_per_island"]
        == summary2["backend_details"]["cluster_counts_per_island"]
    )
    assert summary1["generation_statistics"][0]["success_rates"] == summary2["generation_statistics"][0]["success_rates"]


def test_funsearch_backend_returns_failed_when_no_successful_candidate(tmp_path):
    backend, writer = _make_backend(
        tmp_path,
        seed=9,
        evaluator=_FakeFailingCandidateEvaluator(),
    )
    result = backend.run()
    assert result.status == "failed"
    summary = json.loads(writer.paths.summary_path.read_text(encoding="utf-8"))
    assert summary["best_candidate"]["status"] == "failed_syntax"
