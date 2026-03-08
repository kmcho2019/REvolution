import json
from pathlib import Path
from unittest.mock import MagicMock

import pytest

from revolution.backends import (
    BackendExecutionContext,
    BackendServices,
    CodeEvolveBackend,
    CodeEvolveBackendConfig,
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

    async def generate_response(
        self,
        prompt,
        temperature=1.0,
        top_p=0.95,
        max_tokens=2048,
        generation_mode="whole",
        system_prompt_override=None,
    ):
        self.counter += 1
        self.pending["api_calls"] += 1
        self.pending["prompt_tokens"] += 9
        self.pending["completion_tokens"] += 13
        self.pending["code_prompt_tokens"] += 9
        self.pending["code_completion_tokens"] += 13
        if "evolving a CodeEvolve prompt" in prompt:
            return (
                f"prompt-thought-{self.counter}",
                f"Prompt variant {self.counter}",
                {"format_ok": True, "raw": "", "parsed_mode": "whole"},
            )
        if generation_mode == "diff":
            payload = {
                "edits": [
                    {
                        "file": "/tmp/code.sv",
                        "hunks": [
                            {
                                "search": "endmodule\n",
                                "replace": f"  wire ce_{self.counter};\nendmodule\n",
                            }
                        ],
                    }
                ]
            }
            code = json.dumps(payload)
        else:
            code = f"module m_{self.counter};\nendmodule\n"
        return (
            f"thought-{self.counter}",
            code,
            {"format_ok": True, "raw": code, "parsed_mode": generation_mode},
        )

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
                    ppa_metrics={
                        "area": 100.0 - self.calls,
                        "power": 0.1,
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
            )
        return out


def _make_problem_context(tmp_path: Path, *, prompt_text: str | None = None) -> ProblemContext:
    bench = tmp_path / "bench" / "Bench"
    bench.mkdir(parents=True, exist_ok=True)
    prompt = bench / "Prob001_prompt.txt"
    test_sv = bench / "Prob001_test.sv"
    ref_sv = bench / "Prob001_ref.sv"
    ppa = bench / "Prob001_ppa.txt"
    prompt_body = prompt_text or (
        "Please act as a professional verilog designer.\n\n"
        "Implement a module to achieve serial input data accumulation output.\n\n"
        "Module name:\n"
        "    accu\n"
        "Input ports:\n"
        "\tclk: Clock input for synchronization.\n"
        "\trst_n: Active-low reset signal.\n"
        "\tdata_in[7:0]: 8-bit input data for addition.\n"
        "\tvalid_in: Input signal indicating readiness for new data.\n"
        "Output ports:\n"
        "    valid_out: Output signal indicating when 4 input data accumulation is reached.\n"
        "\tdata_out[9:0]: 10-bit output data representing the accumulated sum.\n"
        "Implementation:\n"
        "Give me the complete code.\n"
    )
    prompt.write_text(prompt_body, encoding="utf-8")
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
        problem_description=prompt_body,
        test_sv_path=test_sv,
        ref_sv_path=ref_sv,
        top_module_names_path=bench / "synthesis_top_module_names.json",
    )


def _write_prompts(store: PromptStore, *, include_meta: bool = True):
    store.write("system/whole", "whole system")
    store.write("system/diff", "diff system")
    store.write("feedback/system", "feedback system")
    store.write("feedback/user", "{problem_def} {code} {simulation_log}")
    store.write("codeevolve/exploit", "exploit {context_json}")
    store.write("codeevolve/explore", "explore {context_json}")
    if include_meta:
        store.write(
            "codeevolve/meta_prompt",
            "You are evolving a CodeEvolve prompt.\n{context_json}",
        )


def _make_backend(
    tmp_path: Path,
    *,
    config_overrides: dict[str, object] | None = None,
    include_meta: bool = True,
    prompt_text: str | None = None,
):
    store = PromptStore(root_dir=str(tmp_path / "prompts"), profile="codeevolve")
    _write_prompts(store, include_meta=include_meta)
    context = _make_problem_context(tmp_path, prompt_text=prompt_text)
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
        candidate_evaluator=_FakeCandidateEvaluator(),
    )
    execution_context = BackendExecutionContext(
        backend_name="codeevolve",
        model_name="model/x",
        benchmark_name=context.benchmark_name,
        problem_name=context.problem_name,
        problem_context=context,
        generation_mode="whole",
        seed=11,
    )
    kwargs: dict[str, object] = {
        "num_islands": 2,
        "num_epochs": 3,
        "init_pop": 1,
        "exploration_rate": 1.0,
        "meta_prompting": True,
        "migration_interval": 2,
        "migration_rate": 1.0,
        "use_scheduler": False,
        "seed": 11,
    }
    if config_overrides:
        kwargs.update(config_overrides)
    cfg = CodeEvolveBackendConfig(**kwargs)
    return CodeEvolveBackend(execution_context, services, cfg), artifact_writer


def test_codeevolve_prompt_validation_fails_on_missing_meta_prompt(tmp_path):
    backend, _ = _make_backend(tmp_path, include_meta=False)
    with pytest.raises(FileNotFoundError, match="Missing keys"):
        backend.initialize()


def test_codeevolve_backend_run_writes_summary(tmp_path):
    backend, writer = _make_backend(tmp_path)
    result = backend.run()
    assert result.status == "success"
    summary = json.loads(writer.paths.summary_path.read_text(encoding="utf-8"))
    assert summary["backend_name"] == "codeevolve"
    assert summary["backend_details"]["num_islands"] == 2
    assert summary["run_budget"]["max_iterations"] == 3
    assert summary["best_candidate"]["score"] is not None
    assert summary["llm_usage"]["api_calls"] >= 1
    assert summary["backend_details"]["fidelity_deviations"]
    assert "accumulated_strategy_counts:" in summary


def test_codeevolve_seed_is_deterministic(tmp_path):
    backend_a, _ = _make_backend(tmp_path / "a", config_overrides={"seed": 7})
    backend_b, _ = _make_backend(tmp_path / "b", config_overrides={"seed": 7})
    backend_a.run()
    backend_b.run()
    payload_a = backend_a.get_result_summary()
    payload_b = backend_b.get_result_summary()
    assert payload_a["total_candidates_generated"] == payload_b["total_candidates_generated"]
    assert payload_a["backend_details"]["migration_topology"] == payload_b["backend_details"]["migration_topology"]
    stable_a = [
        {
            key: value
            for key, value in record.items()
            if key not in {"runtime_seconds"}
        }
        for record in payload_a["generation_statistics"]
    ]
    stable_b = [
        {
            key: value
            for key, value in record.items()
            if key not in {"runtime_seconds"}
        }
        for record in payload_b["generation_statistics"]
    ]
    assert stable_a == stable_b


def test_codeevolve_meta_prompting_updates_prompt_population(tmp_path):
    backend, _ = _make_backend(
        tmp_path,
        config_overrides={
            "num_islands": 1,
            "num_epochs": 2,
            "init_pop": 1,
            "exploration_rate": 1.0,
            "meta_prompting": True,
            "use_scheduler": False,
        },
    )
    backend.run()
    assert backend._islands[0].prompt_count() > 1


def test_codeevolve_seed_code_uses_rtllm_interface_stub(tmp_path):
    backend, _ = _make_backend(tmp_path)
    backend.initialize()
    seed = backend._task_adapter.initial_seed_code()
    assert "module accu" in seed
    assert "input clk;" in seed
    assert "input [7:0] data_in;" in seed
    assert "output [9:0] data_out;" in seed


def test_codeevolve_seed_code_uses_verilogeval_interface_stub(tmp_path):
    backend, _ = _make_backend(
        tmp_path,
        prompt_text=(
            "I would like you to implement a module named TopModule with the following\n"
            "interface. All input and output ports are one bit unless otherwise\n"
            "specified.\n\n"
            " - input clk\n"
            " - output [3:0] out\n"
        ),
    )
    backend.initialize()
    seed = backend._task_adapter.initial_seed_code()
    assert "module TopModule" in seed
    assert "input clk;" in seed
    assert "output [3:0] out;" in seed


def test_codeevolve_migration_creates_root_clones(tmp_path):
    backend, _ = _make_backend(
        tmp_path,
        config_overrides={
            "num_islands": 2,
            "num_epochs": 2,
            "init_pop": 1,
            "exploration_rate": 0.0,
            "meta_prompting": False,
            "migration_interval": 1,
            "migration_rate": 1.0,
            "use_scheduler": False,
        },
    )
    backend.run()
    assert backend._migration_events
    migrated = [
        program
        for island in backend._islands
        for program in island.programs.values()
        if program.migrated_from is not None
    ]
    assert migrated
    assert all(program.parent_id is None for program in migrated)


def test_codeevolve_meta_prompt_failures_only_count_attempts(tmp_path):
    backend, _ = _make_backend(
        tmp_path,
        config_overrides={
            "num_islands": 1,
            "num_epochs": 1,
            "init_pop": 1,
            "meta_prompting": True,
            "use_scheduler": False,
        },
    )
    backend.run()
    epoch_stats = backend.get_result_summary()["generation_statistics"][0]["epoch_statistics"]
    assert epoch_stats["meta_prompt_successes"] == 0
    assert epoch_stats["meta_prompt_failures"] == 0


def test_codeevolve_honors_max_evaluations(tmp_path):
    backend, _ = _make_backend(
        tmp_path,
        config_overrides={
            "num_islands": 2,
            "num_epochs": 5,
            "init_pop": 1,
            "meta_prompting": False,
            "max_evaluations": 2,
            "use_scheduler": False,
        },
    )
    backend.run()
    summary = backend.get_result_summary()
    assert summary["total_candidates_generated"] == 2
    assert summary["backend_details"]["termination_reason"] == "max_evaluations"


def test_codeevolve_honors_max_llm_calls(tmp_path):
    backend, _ = _make_backend(
        tmp_path,
        config_overrides={
            "num_islands": 1,
            "num_epochs": 5,
            "init_pop": 1,
            "meta_prompting": False,
            "max_llm_calls": 1,
            "use_scheduler": False,
        },
    )
    backend.run()
    summary = backend.get_result_summary()
    assert summary["total_candidates_generated"] == 1
    assert summary["backend_details"]["termination_reason"] == "max_llm_calls"
