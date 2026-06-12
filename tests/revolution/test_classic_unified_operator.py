import json

from unittest.mock import MagicMock

import pytest

from revolution.algorithm import EoHEngine, Heuristic


def _mk_engine(mocker, tmp_path, **kwargs):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="build the circuit")
    llm = MagicMock()
    llm.model_name = "test-model"
    synth = MagicMock()
    synth.clk_period = 2.0
    eng = EoHEngine(
        benchmark_name="bench",
        problem_name="prob",
        llm_interface=llm,
        verilog_evaluator=MagicMock(),
        synthesis_evaluator=synth,
        population_size=2,
        base_save_path=str(tmp_path),
        candidate_workers=0,
        **kwargs,
    )
    eng.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0}
    return eng, llm


def _success_parent(candidate_id: str) -> Heuristic:
    parent = Heuristic(
        "carry-save plan",
        f"module {candidate_id}; endmodule // code sentinel",
        f"{candidate_id} feedback sentinel",
        score=0.4,
        generation=0,
        status="success",
    )
    parent.id = candidate_id
    parent.ppa_success = True
    parent.quality_score = 0.4
    return parent


def _context_from_prompt(prompt: str) -> dict:
    _, tail = prompt.split("CONTEXT_JSON:\n", 1)
    context_text = tail.split("\n\nReturn", 1)[0]
    return json.loads(context_text)


def test_unified_classic_prompt_excludes_code_and_feedback(mocker, tmp_path):
    eng, _ = _mk_engine(mocker, tmp_path, classic_operator_kind="single_thought_operator")
    parent = _success_parent("parent_a")

    prompt = eng._create_prompt_unified_classic([parent])
    context = _context_from_prompt(prompt)

    assert context["task"] == "single_thought_operator"
    assert context["parent"]["evaluation_status"] == "succeeded"
    assert context["parent"]["quality_score"] == pytest.approx(0.4)
    assert "code" not in context["parent"]
    assert "module parent_a" not in prompt
    assert "feedback sentinel" not in prompt


def test_unified_classic_failed_parent_payload_is_minimal(mocker, tmp_path):
    eng, _ = _mk_engine(mocker, tmp_path, classic_operator_kind="single_thought_operator")
    parent = Heuristic(
        "broken idea", "module bad; endmodule", "IVERILOG ERROR log",
        generation=0, status="failed_syntax",
    )

    payload = eng._format_parent_for_unified_operator(parent, 1)

    assert payload == {
        "example": 1,
        "thought": "broken idea",
        "evaluation_status": "failed",
    }


def test_unified_classic_bypasses_strategy_selection(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, classic_operator_kind="single_thought_operator")
    eng.logger = MagicMock()
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)
    eng.success_pool = [_success_parent("parent_a"), _success_parent("parent_b")]
    eng.fail_pool = []
    select = mocker.patch.object(eng, "_select_strategy")
    llm.generate_batch_responses = mocker.AsyncMock(return_value=[])
    llm.generate_batch_feedback = mocker.AsyncMock(return_value=[])
    llm.get_and_reset_usage_stats = mocker.AsyncMock(return_value={})
    mocker.patch.object(eng, "_evaluate_candidates", side_effect=lambda c: None)

    eng.evolve_one_generation()

    select.assert_not_called()
    llm.generate_batch_responses.assert_awaited()
    requests = llm.generate_batch_responses.await_args.args[0]
    assert requests, "unified mode must still build offspring requests"
    for request in requests:
        context = _context_from_prompt(request["prompt"])
        assert context["task"] == "single_thought_operator"
        assert context["parent_count"] in (1, 2)
        assert "code sentinel" not in request["prompt"]


def test_unified_classic_validation(mocker):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="d")
    with pytest.raises(ValueError, match="classic_operator_kind"):
        EoHEngine(
            benchmark_name="b", problem_name="p",
            llm_interface=MagicMock(model_name="m"),
            verilog_evaluator=MagicMock(), synthesis_evaluator=MagicMock(),
            population_size=2, base_save_path="/tmp/x",
            classic_operator_kind="bogus",
        )
    with pytest.raises(ValueError, match="whole mode only"):
        EoHEngine(
            benchmark_name="b", problem_name="p",
            llm_interface=MagicMock(model_name="m"),
            verilog_evaluator=MagicMock(), synthesis_evaluator=MagicMock(),
            population_size=2, base_save_path="/tmp/x",
            generation_mode="diff",
            classic_operator_kind="single_thought_operator",
        )
