import json
from pathlib import Path

import pytest

from revolution.algorithm import Heuristic
from revolution.qd.engine import QDEngine
from revolution.qd.scheduler import QDBudgetSplit


class _DummyLLM:
    model_name = "stub-model"

    async def generate_n_responses(self, *args, **kwargs):
        return []

    async def generate_batch_responses(self, *args, **kwargs):
        return []

    async def get_and_reset_usage_stats(self):
        return {}


class _DummySynth:
    clk_period = 1.0


class _DummyEval:
    pass


def _engine(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, **kwargs) -> QDEngine:
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "build the circuit",
    )
    engine_kwargs = {
        "benchmark_name": "Bench",
        "problem_name": "Prob",
        "llm_interface": _DummyLLM(),
        "verilog_evaluator": _DummyEval(),
        "synthesis_evaluator": _DummySynth(),
        "population_size": 2,
        "num_generations": 0,
        "base_save_path": str(tmp_path / "exp"),
        "qd_archive_type": "grid",
        "qd_num_cells": 4,
        "qd_grid_axes": ("g_A",),
        "qd_cell_mode": "pareto_front",
        "qd_max_elites_per_cell": 5,
        "qd_objectives": "ppa",
    }
    engine_kwargs.update(kwargs)
    engine = QDEngine(**engine_kwargs)
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0}
    monkeypatch.setattr(
        engine,
        "_save_result_to_file",
        lambda _code, _thought, generation, index, strategy, _diff=None: (
            str(tmp_path / f"{generation}_{index}_{strategy}.sv"),
            None,
        ),
    )
    return engine


def _success_parent(
    thought: str,
    *,
    candidate_id: str,
    area: float,
    power: float = 0.9,
) -> Heuristic:
    parent = Heuristic(
        thought,
        f"module {candidate_id}; endmodule // parent code sentinel",
        f"{candidate_id} feedback sentinel",
        score=0.5,
        generation=0,
        status="success",
    )
    parent.id = candidate_id
    parent.ppa_success = True
    parent.quality_score = 0.5
    parent.ppa_metrics = {"power": power, "area": area}
    return parent


def _context_from_prompt(prompt: str) -> dict:
    _, tail = prompt.split("CONTEXT_JSON:\n", 1)
    context_text, _ = tail.split("\n\nReturn exactly ONE JSON object", 1)
    return json.loads(context_text)


def test_single_thought_prompt_success_parent_excludes_code_and_feedback(
    tmp_path,
    monkeypatch,
):
    engine = _engine(tmp_path, monkeypatch)
    parent = _success_parent("carry-save tree", candidate_id="parent_success", area=90.0)

    prompt = engine._create_prompt_single_thought_operator([parent], archive_context=[])
    context = _context_from_prompt(prompt)

    assert context["task"] == "single_thought_operator"
    assert context["parent_count"] == 1
    assert context["parent"]["evaluation_status"] == "succeeded"
    assert context["parent"]["ppa_summary"]["quality_score"] == pytest.approx(0.5)
    assert "code" not in context["parent"]
    assert "feedback" not in context["parent"]
    assert "module parent_success" not in prompt
    assert "parent_success feedback sentinel" not in prompt


def test_single_thought_prompt_failed_parent_excludes_feedback_logs_and_code(
    tmp_path,
    monkeypatch,
):
    engine = _engine(tmp_path, monkeypatch)
    parent = Heuristic(
        "failed idea",
        "module failed_parent; endmodule // forbidden code",
        "IVERILOG ERROR forbidden feedback log",
        generation=0,
        status="failed_syntax",
    )
    parent.id = "failed_parent"

    prompt = engine._create_prompt_single_thought_operator([parent], archive_context=[])
    context = _context_from_prompt(prompt)

    assert context["parent"]["evaluation_status"] == "failed"
    assert "ppa_summary" not in context["parent"]
    assert "feedback" not in context["parent"]
    assert "code" not in context["parent"]
    assert "module failed_parent" not in prompt
    assert "IVERILOG ERROR forbidden feedback log" not in prompt


def test_single_thought_archive_context_is_compact_and_excludes_parents(
    tmp_path,
    monkeypatch,
):
    engine = _engine(
        tmp_path,
        monkeypatch,
        qd_operator_archive_context_size=1,
    )
    parent = _success_parent("parent thought", candidate_id="parent", area=90.0)
    context_parent = _success_parent("archive thought", candidate_id="archive", area=80.0)
    engine._insert_successes([parent, context_parent])

    prompt = engine._create_prompt_single_thought_operator([parent])
    context = _context_from_prompt(prompt)

    assert len(context["archive_context"]) == 1
    assert context["archive_context"][0]["thought"] == "archive thought"
    assert set(context["archive_context"][0]) == {
        "thought",
        "evaluation_status",
        "quality_score",
    }
    assert "archive feedback sentinel" not in prompt
    assert "module archive" not in prompt


def test_single_thought_operator_bypasses_strategy_selection(
    tmp_path,
    monkeypatch,
):
    engine = _engine(
        tmp_path,
        monkeypatch,
        qd_operator_kind="single_thought_operator",
        qd_operator_one_parent_fraction=1.0,
    )
    parent = _success_parent("parent thought", candidate_id="parent", area=90.0)
    engine._insert_successes([parent])
    engine.num_offspring_lambda = 1
    captured_requests = []

    def _raise_select_strategy(*args, **kwargs):
        raise AssertionError("_select_strategy must not run for single_thought_operator")

    async def _generate_batch_responses(llm_requests, *args, **kwargs):
        captured_requests.extend(llm_requests)
        return [
            (
                "new thought",
                "module generated; endmodule",
                {"format_ok": True, "parsed_mode": "whole"},
            )
        ]

    monkeypatch.setattr(engine, "_select_strategy", _raise_select_strategy)
    monkeypatch.setattr(
        engine,
        "_split_generation_budget",
        lambda: QDBudgetSplit(
            total_budget=1,
            target_cells=1,
            occupied_cells=1,
            fail_share=0.0,
            coverage_fail_share=0.0,
            fail_share_cap=0.0,
            fail_budget=0,
            success_budget=1,
            phase="improve",
            seed_budget=0,
            backfill_budget=0,
            refine_budget=1,
        ),
    )
    monkeypatch.setattr(engine.llm, "generate_batch_responses", _generate_batch_responses)
    monkeypatch.setattr(engine, "_evaluate_candidates", lambda candidates: None)

    result = engine.evolve_one_generation()

    assert result is None
    assert captured_requests
    assert "single_thought_operator" in captured_requests[0]["prompt"]


def test_single_thought_fail_pool_prompt_can_use_archive_context(
    tmp_path,
    monkeypatch,
):
    engine = _engine(
        tmp_path,
        monkeypatch,
        qd_operator_kind="single_thought_operator",
        qd_operator_archive_context_size=1,
    )
    archive_parent = _success_parent("archive thought", candidate_id="archive", area=90.0)
    failed_parent = Heuristic(
        "failed idea",
        "module failed_parent; endmodule",
        "failed parent feedback",
        generation=0,
        status="failed_syntax",
        origin_pool="fail_pool",
    )
    failed_parent.id = "failed_parent"
    engine._insert_successes([archive_parent])
    engine.fail_pool = [failed_parent]
    captured_requests = []

    async def _generate_batch_responses(llm_requests, *args, **kwargs):
        captured_requests.extend(llm_requests)
        return [
            (
                "new thought",
                "module generated; endmodule",
                {"format_ok": True, "parsed_mode": "whole"},
            )
        ]

    monkeypatch.setattr(
        engine,
        "_split_generation_budget",
        lambda: QDBudgetSplit(
            total_budget=1,
            target_cells=1,
            occupied_cells=1,
            fail_share=1.0,
            coverage_fail_share=1.0,
            fail_share_cap=1.0,
            fail_budget=1,
            success_budget=0,
            phase="improve",
            seed_budget=0,
            backfill_budget=0,
            refine_budget=0,
        ),
    )
    monkeypatch.setattr(engine.llm, "generate_batch_responses", _generate_batch_responses)
    monkeypatch.setattr(engine, "_evaluate_candidates", lambda candidates: None)

    engine.evolve_one_generation()

    assert captured_requests
    context = _context_from_prompt(captured_requests[0]["prompt"])
    assert context["parent"]["thought"] == "failed idea"
    assert context["archive_context"][0]["thought"] == "archive thought"
    assert "module failed_parent" not in captured_requests[0]["prompt"]
    assert "failed parent feedback" not in captured_requests[0]["prompt"]


def test_single_thought_two_parent_sampling_allows_intra_bin(
    tmp_path,
    monkeypatch,
):
    engine = _engine(tmp_path, monkeypatch, qd_num_cells=1)
    power_parent = _success_parent(
        "power",
        candidate_id="power",
        area=95.0,
        power=0.8,
    )
    area_parent = _success_parent(
        "area",
        candidate_id="area",
        area=80.0,
        power=0.95,
    )
    engine._insert_successes([power_parent, area_parent])

    parents = engine._sample_two_success_parents(allow_intra_bin=True)

    assert len(parents) == 2
    assert {parent.id for parent in parents} == {"power", "area"}


def test_materialized_single_thought_offspring_records_parent_count(
    tmp_path,
    monkeypatch,
):
    engine = _engine(tmp_path, monkeypatch)
    parent_a = _success_parent("a", candidate_id="a", area=90.0)
    parent_b = _success_parent("b", candidate_id="b", area=80.0)

    [candidate] = engine._materialize_offspring(
        [
            (
                "new thought",
                "module generated; endmodule",
                {"format_ok": True, "parsed_mode": "whole"},
            )
        ],
        [
            {
                "strategy": "single_thought_operator",
                "parents": [parent_a, parent_b],
                "parent_count": 2,
                "requested_parent_count": 2,
                "origin_pool": "success_pool",
                "resolved_mode": "whole",
                "prompt_text": "CONTEXT_JSON:\n{}",
            }
        ],
    )

    assert candidate.strategy == "single_thought_operator"
    assert candidate.parent_ids == ["a", "b"]
    assert candidate.parent_count == 2
    assert candidate.requested_parent_count == 2
    snapshot_path = tmp_path / "prompt_snapshot.txt"
    snapshot_meta_path = tmp_path / "prompt_snapshot.json"
    assert snapshot_path.read_text(encoding="utf-8") == "CONTEXT_JSON:\n{}"
    snapshot_meta = json.loads(snapshot_meta_path.read_text(encoding="utf-8"))
    assert snapshot_meta["strategy"] == "single_thought_operator"
    assert snapshot_meta["parent_count"] == 2
    assert snapshot_meta["requested_parent_count"] == 2
    assert snapshot_meta["parent_ids"] == ["a", "b"]


def test_single_thought_operator_validation_rejects_unknown_kind(
    tmp_path,
    monkeypatch,
):
    with pytest.raises(ValueError, match="Unsupported qd_operator_kind"):
        _engine(tmp_path, monkeypatch, qd_operator_kind="mystery")


def test_eoh_operator_kind_keeps_strategy_selection_path(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch, qd_operator_kind="eoh_strategies")
    parent = _success_parent("parent thought", candidate_id="parent", area=90.0)
    engine._insert_successes([parent])
    selected = []

    def _select_strategy(pool_type, available_strategies, selected_this_gen=None):
        selected.append((pool_type, tuple(available_strategies)))
        return "M-S", {"M-S": 1.0}

    monkeypatch.setattr(engine, "_select_strategy", _select_strategy)
    monkeypatch.setattr(
        engine,
        "_split_generation_budget",
        lambda: QDBudgetSplit(
            total_budget=1,
            target_cells=1,
            occupied_cells=1,
            fail_share=0.0,
            coverage_fail_share=0.0,
            fail_share_cap=0.0,
            fail_budget=0,
            success_budget=1,
            phase="improve",
            seed_budget=0,
            backfill_budget=0,
            refine_budget=1,
        ),
    )
    monkeypatch.setattr(engine, "_materialize_offspring", lambda *_args: [])

    result = engine.evolve_one_generation()

    assert result == "STOP"
    assert selected
    assert selected[0][0] == "success"


def test_single_thought_failed_parent_feedback_opt_in_truncates(
    tmp_path,
    monkeypatch,
):
    engine = _engine(tmp_path, monkeypatch, qd_operator_fail_feedback_chars=24)
    parent = Heuristic(
        "failed idea",
        "module failed_parent; endmodule",
        "Mismatch on f: K-map row bits swapped relative to spec",
        generation=0,
        status="failed_functionality",
    )
    parent.id = "failed_parent"

    prompt = engine._create_prompt_single_thought_operator([parent], archive_context=[])
    context = _context_from_prompt(prompt)

    assert context["parent"]["evaluation_status"] == "failed"
    assert context["parent"]["failure_stage"] == "failed_functionality"
    assert context["parent"]["failure_feedback"] == "Mismatch on f: K-map row"
    assert "code" not in context["parent"]
    assert "module failed_parent" not in prompt


def test_single_thought_fail_feedback_rejects_negative_budget(tmp_path, monkeypatch):
    with pytest.raises(ValueError, match="qd_operator_fail_feedback_chars"):
        _engine(tmp_path, monkeypatch, qd_operator_fail_feedback_chars=-1)


def test_all_fail_parent_carries_sample_feedback(tmp_path, monkeypatch):
    from revolution.qd.thought_only import ThoughtEvaluation, ThoughtIndividual

    engine = _engine(tmp_path, monkeypatch)
    thought = ThoughtIndividual(
        thought_id="g000_thought_0001",
        generation=0,
        thought_spec={
            "format": "thought_spec_v1",
            "summary": "plan",
            "interface_contract": "i",
            "timing_and_protocol": "t",
            "state_and_datapath_plan": "s",
            "edge_cases": "e",
            "ppa_intent": "p",
            "implementation_constraints": "c",
        },
        raw_response="{}",
        parent_ids=[],
        parent_count=0,
        parent_source="seed",
        qd_operator_kind="single_thought_operator",
        strategy="single_thought_operator",
        prompt_text="p",
    )
    evaluation = ThoughtEvaluation(
        thought_id="g000_thought_0001",
        generation=0,
        code_samples_per_thought=2,
        sample_ids=["s0", "s1"],
        sample_statuses=["failed_functionality", "failed_functionality"],
        success_count=0,
        success_rate=0.0,
        aggregate_status="all_failed",
        repair_kind="none",
        repair_attempts_used=0,
        representative_sample_id=None,
        representative_quality_score=None,
        representative_ppa_metrics={},
        representative_descriptor_values={},
        parent_ids=[],
        parent_source="seed",
        strategy="single_thought_operator",
        qd_operator_kind="single_thought_operator",
        prompt_profile="journal_thought_only",
        representation_kind="thought_only",
        population_size=2,
        thought_population_size=1,
        sample_records=[],
        repair_config={},
    )
    sample_a = Heuristic("t", "code", "", generation=0, status="failed_functionality")
    sample_b = Heuristic(
        "t", "code", "K-map row bits swapped vs spec", generation=0,
        status="failed_functionality",
    )

    parent = engine._build_all_fail_parent(thought, evaluation, [sample_a, sample_b])

    assert parent.feedback == "K-map row bits swapped vs spec"
    assert parent.id == "g000_thought_0001"


def test_best_parent_code_picks_highest_quality_successful(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    lo = _success_parent("plan-lo", candidate_id="p_lo", area=90.0)
    lo.code = "module lo; endmodule"
    lo.quality_score = 0.2
    hi = _success_parent("plan-hi", candidate_id="p_hi", area=80.0)
    hi.code = "module hi; endmodule"
    hi.quality_score = 0.9
    failed = Heuristic("bad", "module bad; endmodule", "", generation=0, status="failed_syntax")

    assert engine._best_parent_code([lo, hi, failed]) == "module hi; endmodule"
    assert engine._best_parent_code([failed]) == ""  # no successful coded parent


def test_seeded_realization_prompt_carries_parent_code(tmp_path, monkeypatch):
    from revolution.qd.thought_only import ThoughtIndividual

    engine = _engine(tmp_path, monkeypatch, qd_thought_code_seeded=True)
    spec = {
        "format": "thought_spec_v1", "summary": "s", "interface_contract": "i",
        "timing_and_protocol": "t", "state_and_datapath_plan": "d",
        "edge_cases": "e", "ppa_intent": "p", "implementation_constraints": "c",
    }
    thought = ThoughtIndividual(
        thought_id="g001_thought_0001", generation=1, thought_spec=spec,
        raw_response="{}", parent_ids=["p_hi"], parent_count=1,
        parent_source="archive", qd_operator_kind="single_thought_operator",
        strategy="single_thought_operator", prompt_text="p",
        parent_code="module hi; assign y = a & b; endmodule",
    )
    prompt = engine._create_prompt_thought_only_code_seeded(thought)
    assert "assign y = a & b" in prompt          # parent code seeded
    assert "code_from_thought_seeded" in prompt
