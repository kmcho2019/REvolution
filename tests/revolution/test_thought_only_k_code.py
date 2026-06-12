import json
from pathlib import Path

import pytest

from revolution.algorithm import Heuristic
from revolution.qd.engine import QDEngine
from revolution.qd.thought_only import parse_thought_spec


def _thought_json(summary: str = "counter architecture") -> str:
    return json.dumps(
        {
            "format": "thought_spec_v1",
            "summary": summary,
            "interface_contract": "Implement the DUT ports exactly as specified.",
            "timing_and_protocol": "not specified by problem; assume combinational behavior",
            "state_and_datapath_plan": "Use direct combinational assignments.",
            "edge_cases": "Handle all input combinations without latches.",
            "ppa_intent": "Prefer simple gates after correctness is satisfied.",
            "implementation_constraints": "Use one DUT module and inline logic only.",
        }
    )


class _ThoughtOnlyLLM:
    model_name = "stub-model"

    def __init__(
        self,
        *,
        thought_payloads: list[str],
        code_payloads: list[list[str]],
        repair_payloads: list[str] | None = None,
    ) -> None:
        self.thought_payloads = list(thought_payloads)
        self.code_payloads = list(code_payloads)
        self.repair_payloads = list(repair_payloads or [])
        self.thought_prompts: list[str] = []
        self.code_prompts: list[str] = []
        self.repair_prompts: list[str] = []

    async def generate_batch_responses(self, prompts, *args, **kwargs):
        self.thought_prompts.extend(request["prompt"] for request in prompts)
        out = []
        for raw in self.thought_payloads[: len(prompts)]:
            out.append((None, None, {"format_ok": False, "raw": raw, "error": None}))
        return out

    async def generate_n_responses(self, *, prompt, n, **kwargs):
        self.code_prompts.append(prompt)
        payloads = self.code_payloads.pop(0)
        return [
            (
                "sample rationale",
                code,
                {
                    "format_ok": True,
                    "raw": json.dumps(
                        {
                            "format": "eoh_v1",
                            "mode": "whole",
                            "thought": "sample rationale",
                            "code": code,
                        }
                    ),
                    "parsed_mode": "whole",
                    "error": None,
                },
            )
            for code in payloads[:n]
        ]

    async def generate_response(self, prompt, *args, **kwargs):
        self.repair_prompts.append(prompt)
        code = self.repair_payloads.pop(0)
        return (
            "repair rationale",
            code,
            {
                "format_ok": True,
                "raw": json.dumps(
                    {
                        "format": "eoh_v1",
                        "mode": "whole",
                        "thought": "repair rationale",
                        "code": code,
                    }
                ),
                "parsed_mode": "whole",
                "error": None,
            },
        )

    async def get_and_reset_usage_stats(self):
        return {}


class _DummySynth:
    clk_period = 1.0


class _DummyEval:
    pass


def _engine(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    llm: _ThoughtOnlyLLM,
    **kwargs,
) -> QDEngine:
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "Build the requested circuit.",
    )
    engine_kwargs = {
        "benchmark_name": "Bench",
        "problem_name": "Prob",
        "llm_interface": llm,
        "verilog_evaluator": _DummyEval(),
        "synthesis_evaluator": _DummySynth(),
        "population_size": 4,
        "num_generations": 0,
        "base_save_path": str(tmp_path / "exp"),
        "qd_archive_type": "grid",
        "qd_grid_axes": ("g_A",),
        "qd_cell_mode": "pareto_front",
        "qd_max_elites_per_cell": 5,
        "representation_kind": "thought_only",
        "code_samples_per_thought": 2,
        "qd_operator_kind": "single_thought_operator",
    }
    engine_kwargs.update(kwargs)
    engine = QDEngine(**engine_kwargs)
    engine.ref_ppa_metrics = {"area": 100.0, "power": 1.0}
    monkeypatch.setattr(engine, "_copy_misc_files", lambda _path: None)
    return engine


def _evaluate_by_code(candidates: list[Heuristic]) -> None:
    for cand in candidates:
        if cand.status == "failed_format":
            continue
        if "success" in cand.code or "repair" in cand.code:
            cand.status = "success"
            cand.ppa_success = True
            cand.quality_score = 0.2 if "low" in cand.code else 0.8
            cand.score = cand.quality_score
            cand.ppa_metrics = {
                "area": 80.0 if cand.quality_score > 0.5 else 95.0,
                "power": 0.9,
            }
            cand.descriptor_values = {"g_A": 0.2 if cand.quality_score > 0.5 else 0.05}
        else:
            cand.status = "failed_functionality"
            cand.feedback = "sample-local simulation failure"


def test_parse_thought_spec_rejects_empty_and_code_fields():
    parsed, errors = parse_thought_spec('{"format":"thought_spec_v1","code":"bad"}')

    assert parsed is None
    assert 'thought_spec_v1 must not contain "code"' in errors
    assert any("summary" in error for error in errors)


def test_thought_only_config_requires_divisible_budget(tmp_path, monkeypatch):
    llm = _ThoughtOnlyLLM(thought_payloads=[], code_payloads=[])

    with pytest.raises(
        ValueError,
        match="population_size must be divisible by code_samples_per_thought",
    ):
        _engine(
            tmp_path,
            monkeypatch,
            llm,
            population_size=5,
            code_samples_per_thought=2,
        )


def test_gen0_generates_thought_population_and_k_samples(tmp_path, monkeypatch):
    llm = _ThoughtOnlyLLM(
        thought_payloads=[_thought_json("thought 0"), _thought_json("thought 1")],
        code_payloads=[
            ["module low_success; endmodule", "module high_success; endmodule"],
            ["module fail; endmodule", "module high_success; endmodule"],
        ],
    )
    engine = _engine(tmp_path, monkeypatch, llm)
    monkeypatch.setattr(engine, "_evaluate_candidates", _evaluate_by_code)

    engine.initialize_population()

    assert engine.thought_population_size == 2
    assert len(llm.thought_prompts) == 2
    assert len(llm.code_prompts) == 2
    assert len(engine.thought_evaluations) == 2
    assert [item.success_rate for item in engine.thought_evaluations] == [1.0, 0.5]
    assert [item.representative_sample_id is not None for item in engine.thought_evaluations] == [
        True,
        True,
    ]
    assert 0 < len(engine.success_pool) <= 2
    assert all(getattr(parent, "thought_success_rate") in {1.0, 0.5} for parent in engine.success_pool)
    assert engine.fail_pool == []


def test_thought_only_generation_runs_adaptive_rebin_hook(tmp_path, monkeypatch):
    llm = _ThoughtOnlyLLM(
        thought_payloads=[
            _thought_json("initial 0"),
            _thought_json("initial 1"),
            _thought_json("next 0"),
            _thought_json("next 1"),
        ],
        code_payloads=[
            ["module high_success; endmodule", "module low_success; endmodule"],
            ["module high_success; endmodule", "module low_success; endmodule"],
            ["module high_success; endmodule", "module low_success; endmodule"],
            ["module high_success; endmodule", "module low_success; endmodule"],
        ],
    )
    engine = _engine(
        tmp_path,
        monkeypatch,
        llm,
        qd_rebinning_kind="ks_triggered",
        qd_rebinning_min_archive_members=1,
    )
    monkeypatch.setattr(engine, "_evaluate_candidates", _evaluate_by_code)
    engine.initialize_population()
    calls: list[int] = []
    monkeypatch.setattr(engine, "_maybe_adaptive_rebin", lambda: calls.append(engine.current_generation))

    engine.evolve_one_generation()

    assert calls == [1]


def test_invalid_thought_consumes_slot_without_parent_selection(tmp_path, monkeypatch):
    llm = _ThoughtOnlyLLM(
        thought_payloads=["not json", _thought_json("valid thought")],
        code_payloads=[["module high_success; endmodule", "module fail; endmodule"]],
    )
    engine = _engine(tmp_path, monkeypatch, llm)
    monkeypatch.setattr(engine, "_evaluate_candidates", _evaluate_by_code)

    engine.initialize_population()

    assert len(engine.thought_evaluations) == 2
    assert engine.thought_evaluations[0].aggregate_status == "invalid_thought"
    assert len(llm.code_prompts) == 1
    assert all(getattr(parent, "thought_id", "") != engine.thought_evaluations[0].thought_id for parent in engine.fail_pool)
    assert all(getattr(parent, "thought_id", "") != engine.thought_evaluations[0].thought_id for parent in engine.success_pool)


def test_all_fail_thought_enters_fail_pool_as_thought_parent(tmp_path, monkeypatch):
    llm = _ThoughtOnlyLLM(
        thought_payloads=[_thought_json("all fail"), _thought_json("partial")],
        code_payloads=[
            ["module fail_a; endmodule", "module fail_b; endmodule"],
            ["module high_success; endmodule", "module fail; endmodule"],
        ],
    )
    engine = _engine(tmp_path, monkeypatch, llm)
    monkeypatch.setattr(engine, "_evaluate_candidates", _evaluate_by_code)

    engine.initialize_population()

    assert len(engine.fail_pool) == 1
    assert engine.fail_pool[0].id == engine.thought_evaluations[0].thought_id
    assert engine.fail_pool[0].code == ""
    # Sample-level feedback is propagated so fail-parent payloads can
    # carry failure_feedback when the flag enables it.
    assert engine.fail_pool[0].feedback == "sample-local simulation failure"
    assert engine.thought_evaluations[0].aggregate_status == "all_failed"


def test_parent_prompt_excludes_success_rate_code_and_feedback(tmp_path, monkeypatch):
    llm = _ThoughtOnlyLLM(
        thought_payloads=[_thought_json("partial"), _thought_json("all fail")],
        code_payloads=[
            ["module high_success; endmodule", "module fail; endmodule"],
            ["module fail_a; endmodule", "module fail_b; endmodule"],
        ],
    )
    engine = _engine(tmp_path, monkeypatch, llm)
    monkeypatch.setattr(engine, "_evaluate_candidates", _evaluate_by_code)
    engine.initialize_population()

    prompt = engine._create_prompt_single_thought_operator_thought_only(
        [engine.success_pool[0]]
    )
    fail_prompt = engine._create_prompt_single_thought_operator_thought_only(
        [engine.fail_pool[0]],
        archive_context=[],
    )

    assert "success_rate" not in prompt
    assert "module high_success" not in prompt
    assert "sample-local simulation failure" not in prompt
    assert '"evaluation_status": "succeeded"' in prompt
    assert '"evaluation_status": "failed"' in fail_prompt
    assert "sample-local simulation failure" not in fail_prompt


def test_eoh_thought_only_adapter_excludes_parent_code_and_feedback(tmp_path, monkeypatch):
    llm = _ThoughtOnlyLLM(thought_payloads=[], code_payloads=[])
    engine = _engine(tmp_path, monkeypatch, llm, qd_operator_kind="eoh_strategies")
    parent = Heuristic(
        "parent thought",
        "module forbidden; endmodule",
        "forbidden feedback",
        status="success",
    )
    parent.ppa_success = True
    parent.ppa_metrics = {"area": 90.0, "power": 0.9}

    prompt = engine._create_prompt_eoh_thought_only("M-S", [parent])

    assert "eoh_thought_only_adapter" in prompt
    assert "parent thought" in prompt
    assert "module forbidden" not in prompt
    assert "forbidden feedback" not in prompt


def test_bounded_repair_uses_separate_cap_and_keeps_k(tmp_path, monkeypatch):
    llm = _ThoughtOnlyLLM(
        thought_payloads=[_thought_json("repair thought")],
        code_payloads=[["module fail_a; endmodule", "module fail_b; endmodule"]],
        repair_payloads=["module repair_success; endmodule"],
    )
    engine = _engine(
        tmp_path,
        monkeypatch,
        llm,
        population_size=2,
        code_samples_per_thought=2,
        repair_kind="bounded_local_repair",
        repair_max_attempts_per_sample=1,
        repair_max_attempts_per_thought=1,
    )
    monkeypatch.setattr(engine, "_evaluate_candidates", _evaluate_by_code)

    engine.initialize_population()

    assert len(llm.code_prompts) == 1
    assert len(llm.repair_prompts) == 1
    assert engine.thought_evaluations[0].repair_attempts_used == 1
    assert engine.thought_evaluations[0].success_count == 1
    assert engine.thought_evaluations[0].success_rate == 0.5


def test_generation_log_records_all_evaluated_samples(tmp_path, monkeypatch):
    """Gate-bearing pools need the FULL evaluated history of both arms.

    Thought-only mode previously logged only per-thought representatives
    plus fail parents, omitting the other k-1 evaluated samples; the
    narrative names this as a pre-finals engine obligation.
    """
    llm = _ThoughtOnlyLLM(
        thought_payloads=[_thought_json("thought 0"), _thought_json("thought 1")],
        code_payloads=[
            ["module low_success; endmodule", "module high_success; endmodule"],
            ["module fail; endmodule", "module high_success; endmodule"],
        ],
    )
    engine = _engine(tmp_path, monkeypatch, llm)
    monkeypatch.setattr(engine, "_evaluate_candidates", _evaluate_by_code)
    logged: list[list] = []
    monkeypatch.setattr(
        engine,
        "_log_generation_stats",
        lambda population, *args, **kwargs: logged.append(list(population)),
    )
    engine.logger = object()  # truthy: enable the logging branch

    engine.initialize_population()

    assert len(logged) == 1
    # 2 thoughts x k=2 code samples: every evaluated sample is logged,
    # not just the 2 representatives.
    assert len(logged[0]) == 4
    statuses = {cand.status for cand in logged[0]}
    assert "failed_functionality" in statuses  # non-representatives included
