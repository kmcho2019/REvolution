from __future__ import annotations

import hashlib
import random
from pathlib import Path
from types import SimpleNamespace

import pytest

from revolution.algorithm import Heuristic
from revolution.pareto_revolution.engine import ParetoEoHEngine
from revolution.pareto_revolution.selection import (
    REFERENCE_INCOMPLETE_CIRCUIT_TYPES,
    candidate_objectives,
    rank_successes,
    resolve_circuit_type,
    select_success_parents,
    select_survivors,
)
from revolution.runtime.problem_spec import CircuitType, ProblemSpec


CLASSIC_ENGINE_SHA256 = (
    "78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655"
)


def _problem_spec(
    problem_name: str,
    circuit_type: CircuitType,
    *,
    supports_reference_ppa: bool,
) -> ProblemSpec:
    return ProblemSpec(
        benchmark_name="RTLLM",
        problem_name=problem_name,
        prompt_text="design",
        top_module="TopModule",
        benchmark_root=Path("data/bench/RTLLM"),
        supports_reference_ppa=supports_reference_ppa,
        quality_mode="ppa",
        circuit_type=circuit_type,
    )


def _success(
    candidate_id: str,
    *,
    power: float,
    area: float,
    timing: float,
    score: float = 0.0,
) -> Heuristic:
    candidate = Heuristic("thought", "module TopModule; endmodule", "", score=score)
    candidate.id = candidate_id
    candidate.status = "success"
    candidate.synthesis_success = True
    candidate.synthesis_functionality = True
    candidate.ppa_success = True
    candidate.ppa_metrics = {
        "power": power,
        "area": area,
        "eff_clk_period": timing,
    }
    return candidate


def _failure(candidate_id: str, score: float) -> Heuristic:
    candidate = Heuristic("thought", "bad", "", score=score)
    candidate.id = candidate_id
    candidate.status = "failed_functionality"
    return candidate


def test_reference_incomplete_mapping_is_exact_and_sequential():
    assert REFERENCE_INCOMPLETE_CIRCUIT_TYPES == {
        "Prob006_adder_pipe_64bit": "sequential",
        "Prob013_multi_booth_8bit": "sequential",
        "Prob018_float_multi": "sequential",
        "Prob040_synchronizer": "sequential",
    }
    spec = _problem_spec(
        "Prob006_adder_pipe_64bit",
        "unknown",
        supports_reference_ppa=False,
    )
    assert resolve_circuit_type(spec) == "sequential"


def test_unknown_problem_outside_frozen_mapping_fails():
    spec = _problem_spec("Prob999_unknown", "unknown", supports_reference_ppa=False)
    with pytest.raises(AssertionError):
        resolve_circuit_type(spec)


def test_normalized_combinational_objectives_use_two_axes():
    spec = _problem_spec(
        "Prob003_adder_32bit",
        "combinational",
        supports_reference_ppa=True,
    )
    candidate = _success("candidate", power=8.0, area=10.0, timing=0.0)
    objectives = candidate_objectives(
        candidate,
        spec,
        {"power": 10.0, "area": 20.0, "eff_clk_period": 0.0},
    )
    assert objectives == pytest.approx({"g_P": 0.2, "g_A": 0.5})


def test_reference_incomplete_objectives_use_negative_raw_three_axes():
    spec = _problem_spec(
        "Prob006_adder_pipe_64bit",
        "unknown",
        supports_reference_ppa=False,
    )
    candidate = _success("candidate", power=2.0, area=3.0, timing=4.0)
    assert candidate_objectives(candidate, spec, {}) == {
        "g_P": -2.0,
        "g_A": -3.0,
        "g_T": -4.0,
    }


def test_normalized_sequential_objectives_use_three_axes():
    spec = _problem_spec(
        "Prob025_sequence_detector",
        "sequential",
        supports_reference_ppa=True,
    )
    candidate = _success("candidate", power=8.0, area=10.0, timing=4.0)
    objectives = candidate_objectives(
        candidate,
        spec,
        {"power": 10.0, "area": 20.0, "eff_clk_period": 5.0},
    )
    assert objectives == pytest.approx({"g_P": 0.2, "g_A": 0.5, "g_T": 0.2})


def test_success_requires_complete_post_synthesis_ppa():
    spec = _problem_spec(
        "Prob025_sequence_detector",
        "sequential",
        supports_reference_ppa=True,
    )
    candidate = _success("candidate", power=2.0, area=3.0, timing=4.0)
    candidate.synthesis_functionality = False
    with pytest.raises(AssertionError):
        candidate_objectives(
            candidate,
            spec,
            {"power": 4.0, "area": 6.0, "eff_clk_period": 8.0},
        )


def test_success_selection_is_invariant_to_scalar_score():
    spec = _problem_spec(
        "Prob003_adder_32bit",
        "combinational",
        supports_reference_ppa=True,
    )
    candidates = [
        _success("power", power=5.0, area=9.0, timing=0.0, score=-100.0),
        _success("area", power=9.0, area=5.0, timing=0.0, score=100.0),
        _success("dominated", power=9.0, area=9.0, timing=0.0, score=1000.0),
    ]
    reference = {"power": 10.0, "area": 10.0, "eff_clk_period": 0.0}
    random.seed(17)
    first = select_success_parents(rank_successes(candidates, spec, reference), 1)
    for candidate in candidates:
        candidate.score *= -1000.0
    random.seed(17)
    second = select_success_parents(rank_successes(candidates, spec, reference), 1)
    assert [candidate.id for candidate in first] == [
        candidate.id for candidate in second
    ]


def test_crossover_parents_are_distinct():
    spec = _problem_spec(
        "Prob003_adder_32bit",
        "combinational",
        supports_reference_ppa=True,
    )
    candidates = [
        _success("one", power=5.0, area=9.0, timing=0.0),
        _success("two", power=9.0, area=5.0, timing=0.0),
        _success("three", power=8.0, area=8.0, timing=0.0),
    ]
    ranked = rank_successes(
        candidates,
        spec,
        {"power": 10.0, "area": 10.0, "eff_clk_period": 0.0},
    )
    random.seed(23)
    parents = select_success_parents(ranked, 2)
    assert len({parent.id for parent in parents}) == 2


def test_environmental_selection_uses_successes_then_new_failures():
    spec = _problem_spec(
        "Prob003_adder_32bit",
        "combinational",
        supports_reference_ppa=True,
    )
    previous = [_success("old", power=7.0, area=7.0, timing=0.0)]
    offspring = [
        _success("new", power=5.0, area=9.0, timing=0.0),
        _failure("low_fail", 1.0),
        _failure("high_fail", 2.0),
    ]
    survivors = select_survivors(
        previous,
        offspring,
        3,
        spec,
        {"power": 10.0, "area": 10.0, "eff_clk_period": 0.0},
    )
    assert {candidate.id for candidate in survivors[:2]} == {"old", "new"}
    assert survivors[2].id == "high_fail"


def test_engine_generation_uses_distinct_eoh_crossover_parents():
    spec = _problem_spec(
        "Prob003_adder_32bit",
        "combinational",
        supports_reference_ppa=True,
    )
    reference = {"power": 10.0, "area": 10.0, "eff_clk_period": 0.0}
    previous = [
        _success("parent_one", power=5.0, area=9.0, timing=0.0, score=0.1),
        _success("parent_two", power=9.0, area=5.0, timing=0.0, score=0.2),
    ]
    offspring = [
        _success("child_one", power=4.0, area=9.0, timing=0.0, score=0.3),
        _success("child_two", power=9.0, area=4.0, timing=0.0, score=0.4),
    ]
    captured: dict[str, object] = {}

    async def generate(requests, *_args):
        return [(None, None, {}) for _ in requests]

    def materialize(_results, metadata):
        captured["metadata"] = metadata
        return offspring

    engine = object.__new__(ParetoEoHEngine)
    engine.current_generation = 0
    engine.num_offspring_lambda = 2
    engine.population_size = 2
    engine.population_pool_mode = "dual"
    engine.fail_pool = []
    engine.success_pool = previous
    engine.pareto_problem_spec = spec
    engine.ref_ppa_metrics = reference
    engine.fail_strats = ["M-F"]
    engine.success_strats = ["C-F"]
    engine.fail_strategy_stats = {"M-F": {"count": 0, "value": 0.0}}
    engine.success_strategy_stats = {"C-F": {"count": 0, "value": 0.0}}
    engine.generation_mode = "whole"
    engine.default_llm_temp = 1.0
    engine.default_llm_top_p = 1.0
    engine.default_llm_max_tokens = 128000
    engine.llm = SimpleNamespace(generate_batch_responses=generate)
    engine._select_strategy = lambda *_args: ("C-F", {"C-F": 1.0})
    engine._create_prompt_C_F = lambda _parents: "prompt"
    engine._with_mode = lambda _mode, prompt_fn, parents: prompt_fn(parents)
    engine._get_generation_system_prompt = lambda _mode: "system"
    engine._build_prompt_request = lambda **kwargs: kwargs
    engine._materialize_offspring_batch = materialize
    engine._evaluate_candidates = lambda _candidates: None
    engine._log_generation_stats = lambda *_args: None

    random.seed(29)
    assert engine.evolve_one_generation() is None
    metadata = captured["metadata"]
    assert isinstance(metadata, list)
    assert len(metadata) == 2
    assert all(row["strategy"] == "C-F" for row in metadata)
    assert all(len({parent.id for parent in row["parents"]}) == 2 for row in metadata)
    assert len(engine.success_pool) == 2


def test_classic_engine_hash_is_unchanged():
    path = Path("src/revolution/algorithm.py")
    assert hashlib.sha256(path.read_bytes()).hexdigest() == CLASSIC_ENGINE_SHA256
