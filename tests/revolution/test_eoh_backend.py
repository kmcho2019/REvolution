import contextlib
import json
from pathlib import Path
from unittest.mock import MagicMock

import pytest

from revolution.backends import (
    BackendExecutionContext,
    BackendServices,
    EoHBackend,
    EoHBackendConfig,
)
from revolution.prompt_store import PromptStore
from revolution.runtime import ArtifactWriter, CandidateEvaluation, ProblemContext


class _FakeLLM:
    def __init__(self):
        self.pending = {
            "api_calls": 0,
            "prompt_tokens": 0,
            "completion_tokens": 0,
            "code_prompt_tokens": 0,
            "code_completion_tokens": 0,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
        self.counter = 0

    async def generate_n_responses(
        self,
        prompt,
        n,
        temperature=1.0,
        top_p=0.95,
        max_tokens=2048,
        generation_mode="whole",
        system_prompt_override=None,
    ):
        out = []
        for _ in range(n):
            self.counter += 1
            out.append(
                (
                    f"thought-{self.counter}",
                    f"module m_{self.counter}; endmodule\n",
                    {
                        "format_ok": True,
                        "raw": "",
                        "parsed_mode": generation_mode,
                    },
                )
            )
        self.pending["api_calls"] += n
        self.pending["prompt_tokens"] += 8 * n
        self.pending["completion_tokens"] += 12 * n
        self.pending["code_prompt_tokens"] += 8 * n
        self.pending["code_completion_tokens"] += 12 * n
        return out

    async def generate_batch_responses(
        self,
        prompts,
        temperature=1.0,
        top_p=0.95,
        max_tokens=2048,
    ):
        out = []
        for req in prompts:
            self.counter += 1
            mode = req.get("generation_mode", "whole")
            if mode == "diff":
                payload = {
                    "edits": [
                        {
                            "file": "/tmp/non_matching_parent_path.sv",
                            "hunks": [
                                {
                                    "search": "module does_not_exist;\\n",
                                    "replace": "module replacement;\\n",
                                }
                            ],
                        }
                    ]
                }
                code = json.dumps(payload)
            else:
                code = f"module m_{self.counter}; endmodule\n"
            out.append(
                (
                    f"thought-{self.counter}",
                    code,
                    {"format_ok": True, "raw": code, "parsed_mode": mode},
                )
            )
        self.pending["api_calls"] += len(prompts)
        self.pending["prompt_tokens"] += 10 * len(prompts)
        self.pending["completion_tokens"] += 14 * len(prompts)
        self.pending["code_prompt_tokens"] += 10 * len(prompts)
        self.pending["code_completion_tokens"] += 14 * len(prompts)
        return out

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
            "power": 0.1,
            "area": 100.0,
            "eff_clk_period": 1.0,
        }

    def evaluate_candidates(self, items, *, candidate_workers=0):
        out = []
        for item in items:
            self.calls += 1
            if item.initial_status == "failed_format":
                out.append(
                    CandidateEvaluation(
                        status="failed_format",
                        score=float("-inf"),
                        stage_statuses={
                            "format": False,
                            "diff": False,
                            "syntax": False,
                            "functionality": False,
                            "synthesis": False,
                            "synthesis_functionality": False,
                            "ppa": False,
                        },
                    )
                )
                continue
            if item.initial_status == "failed_diff":
                out.append(
                    CandidateEvaluation(
                        status="failed_diff",
                        score=float("-inf"),
                        stage_statuses={
                            "format": True,
                            "diff": False,
                            "syntax": False,
                            "functionality": False,
                            "synthesis": False,
                            "synthesis_functionality": False,
                            "ppa": False,
                        },
                    )
                )
                continue

            out.append(
                CandidateEvaluation(
                    status="success",
                    score=float(self.calls),
                    stage_statuses={
                        "format": True,
                        "diff": True,
                        "syntax": True,
                        "functionality": True,
                        "synthesis": True,
                        "synthesis_functionality": True,
                        "ppa": True,
                    },
                    ppa_metrics={"area": 100.0 - self.calls, "power": 0.1},
                    synthesis_success=True,
                    synthesis_functionality_success=True,
                    ppa_success=True,
                    feedback_payload={
                        "problem_def": "desc",
                        "code": item.code,
                        "simulation_log": "ok",
                    },
                )
            )
        return out


def _make_problem_context(tmp_path: Path) -> ProblemContext:
    bench = tmp_path / "bench" / "Bench"
    bench.mkdir(parents=True, exist_ok=True)
    prompt = bench / "Prob001_prompt.txt"
    test_sv = bench / "Prob001_test.sv"
    ref_sv = bench / "Prob001_ref.sv"
    ppa = bench / "Prob001_ppa.txt"
    prompt.write_text("build a module", encoding="utf-8")
    test_sv.write_text("module tb; endmodule\n", encoding="utf-8")
    ref_sv.write_text("module ref; endmodule\n", encoding="utf-8")
    ppa.write_text(
        "tns,wns,eff_clk_period,power,area\n-5.0,-0.4,0.7,0.05,100.0\n",
        encoding="utf-8",
    )
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


def _write_eoh_prompts(store: PromptStore, *, include_operator: str | None = None):
    store.write("system/whole", "whole system")
    store.write("system/diff", "diff system")
    store.write("feedback/system", "feedback system")
    store.write("feedback/user", "{problem_def} {code} {simulation_log}")

    operators = ["i1", "e1", "e2", "m1", "m2", "m3"]
    if include_operator is not None:
        operators = [include_operator]

    for op in operators:
        store.write(
            f"eoh/{op}/whole",
            f"{op} whole {{context_json}}",
        )
        store.write(
            f"eoh/{op}/diff",
            f"{op} diff {{context_json}} {{file_to_edit}} {{original_file}}",
        )


def _make_backend(
    tmp_path: Path,
    *,
    config_overrides: dict[str, object] | None = None,
    evaluator: _FakeCandidateEvaluator | None = None,
    include_operator: str | None = None,
):
    store = PromptStore(root_dir=str(tmp_path / "prompts"), profile="eoh")
    _write_eoh_prompts(store, include_operator=include_operator)
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
        backend_name="eoh",
        model_name="model/x",
        benchmark_name=context.benchmark_name,
        problem_name=context.problem_name,
        problem_context=context,
        generation_mode="whole",
        seed=7,
    )
    cfg_kwargs: dict[str, object] = {
        "population_size": 2,
        "num_generations": 1,
        "operators": ("m1",),
        "seed": 7,
    }
    if config_overrides:
        cfg_kwargs.update(config_overrides)
    cfg = EoHBackendConfig(**cfg_kwargs)
    return EoHBackend(execution_context, services, cfg), artifact_writer


def test_eoh_prompt_validation_fails_on_missing_operator_prompt(tmp_path):
    backend, _ = _make_backend(
        tmp_path,
        config_overrides={"operators": ("e1",)},
        include_operator="i1",
    )
    with pytest.raises(FileNotFoundError, match="Missing keys"):
        backend.initialize()


def test_eoh_backend_run_writes_summary_and_maximizes_score(tmp_path):
    backend, writer = _make_backend(
        tmp_path,
        config_overrides={"operators": ("m1", "m2"), "num_generations": 1},
    )

    result = backend.run()

    assert result.status == "success"
    assert result.best_score is not None
    summary = json.loads(writer.paths.summary_path.read_text(encoding="utf-8"))
    assert summary["backend_name"] == "eoh"
    assert summary["backend_details"]["operators"] == ["m1", "m2"]
    assert summary["best_candidate"]["score"] == pytest.approx(result.best_score)


def test_eoh_backend_diff_mode_marks_failed_diff_candidates(tmp_path):
    backend, writer = _make_backend(
        tmp_path,
        config_overrides={
            "generation_mode": "diff",
            "operators": ("m1",),
            "num_generations": 1,
        },
    )
    backend.context.generation_mode = "diff"

    result = backend.run()

    summary = json.loads(writer.paths.summary_path.read_text(encoding="utf-8"))
    assert result.status in {"success", "failed"}
    assert summary["accumulated_success_rates"]["diff"] < 1.0


def test_eoh_backend_respects_max_evaluations_budget(tmp_path):
    backend, writer = _make_backend(
        tmp_path,
        config_overrides={
            "population_size": 2,
            "num_generations": 5,
            "operators": ("m1", "m2", "m3"),
            "max_evaluations": 2,
        },
    )

    backend.run()

    summary = json.loads(writer.paths.summary_path.read_text(encoding="utf-8"))
    assert summary["total_candidates_generated"] == 2
    assert summary["backend_details"]["termination_reason"] == "max_evaluations"


def test_eoh_backend_uses_problem_concurrency_leases(tmp_path):
    evaluator = _FakeCandidateEvaluator()
    leased_workers: list[int] = []
    batch_sizes: list[int] = []

    class _FakeController:
        @contextlib.contextmanager
        def lease_candidate_workers(self, batch_size: int):
            batch_sizes.append(batch_size)
            yield 3

    original_evaluate = evaluator.evaluate_candidates

    def _record_workers(items, *, candidate_workers=0):
        leased_workers.append(candidate_workers)
        return original_evaluate(items, candidate_workers=candidate_workers)

    evaluator.evaluate_candidates = _record_workers  # type: ignore[method-assign]
    backend, _writer = _make_backend(tmp_path, evaluator=evaluator)
    backend.services.problem_concurrency = _FakeController()

    backend.run()

    assert batch_sizes
    assert leased_workers
    assert all(worker_count == 3 for worker_count in leased_workers)
