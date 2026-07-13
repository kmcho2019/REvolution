"""NSGA-II selection primitives for descriptor-free Pareto REvolution."""

from __future__ import annotations

import math
import random
from typing import Literal, cast

from revolution.algorithm import Heuristic
from revolution.qd.archive import active_ppa_objectives, ranked_front
from revolution.qd.scoring import compute_ppa_gains
from revolution.qd.types import ArchiveMember, RankedArchiveMember
from revolution.runtime.problem_spec import CircuitType, ProblemSpec


REFERENCE_INCOMPLETE_CIRCUIT_TYPES: dict[str, Literal["sequential"]] = {
    "Prob006_adder_pipe_64bit": "sequential",
    "Prob013_multi_booth_8bit": "sequential",
    "Prob018_float_multi": "sequential",
    "Prob040_synchronizer": "sequential",
}


def resolve_circuit_type(problem_spec: ProblemSpec) -> CircuitType:
    """Resolve the active RTLLM objective set from the frozen contract."""

    if problem_spec.circuit_type == "combinational":
        return "combinational"
    if problem_spec.circuit_type == "sequential":
        return "sequential"
    if problem_spec.circuit_type == "unknown":
        assert problem_spec.benchmark_name == "RTLLM"
        assert not problem_spec.supports_reference_ppa
        assert problem_spec.problem_name in REFERENCE_INCOMPLETE_CIRCUIT_TYPES
        return REFERENCE_INCOMPLETE_CIRCUIT_TYPES[problem_spec.problem_name]
    raise AssertionError(f"unknown circuit type: {problem_spec.circuit_type}")


def candidate_objectives(
    candidate: Heuristic,
    problem_spec: ProblemSpec,
    ref_ppa_metrics: dict[str, float],
) -> dict[str, float]:
    """Return maximize-form active PPA objectives for one valid success."""

    assert candidate.status == "success"
    assert candidate.synthesis_success
    assert candidate.synthesis_functionality
    assert candidate.ppa_success

    circuit_type = resolve_circuit_type(problem_spec)
    objective_names = active_ppa_objectives(circuit_type)
    raw_metrics = {
        "g_P": "power",
        "g_A": "area",
        "g_T": "eff_clk_period",
    }
    for objective_name in objective_names:
        metric_name = raw_metrics[objective_name]
        assert metric_name in candidate.ppa_metrics
        assert math.isfinite(candidate.ppa_metrics[metric_name])

    if problem_spec.supports_reference_ppa:
        gains = compute_ppa_gains(candidate.ppa_metrics, ref_ppa_metrics)
        assert all(
            name in gains and math.isfinite(gains[name]) for name in objective_names
        )
        return {name: gains[name] for name in objective_names}

    assert problem_spec.circuit_type == "unknown"
    assert problem_spec.problem_name in REFERENCE_INCOMPLETE_CIRCUIT_TYPES
    return {name: -candidate.ppa_metrics[raw_metrics[name]] for name in objective_names}


def rank_successes(
    candidates: list[Heuristic],
    problem_spec: ProblemSpec,
    ref_ppa_metrics: dict[str, float],
) -> list[RankedArchiveMember]:
    """Rank a stable success list by Pareto rank and crowding distance."""

    assert len({candidate.id for candidate in candidates}) == len(candidates)
    circuit_type = resolve_circuit_type(problem_spec)
    members = [
        ArchiveMember(
            candidate_id=candidate.id,
            descriptors=(),
            quality_score=candidate.score,
            objectives=candidate_objectives(
                candidate,
                problem_spec,
                ref_ppa_metrics,
            ),
            payload=candidate,
            insertion_index=index,
        )
        for index, candidate in enumerate(candidates)
    ]
    return ranked_front(members, active_ppa_objectives(circuit_type))


def _selection_key(ranked: RankedArchiveMember) -> tuple[int, float, int]:
    return (
        ranked.pareto_rank,
        -ranked.crowding_distance,
        ranked.member.insertion_index,
    )


def binary_tournament(ranked: list[RankedArchiveMember]) -> Heuristic:
    """Select one parent by a uniform, seeded two-contestant tournament."""

    assert ranked
    contestants = ranked if len(ranked) == 1 else random.sample(ranked, 2)
    winner = min(contestants, key=_selection_key)
    return cast(Heuristic, winner.member.payload)


def select_success_parents(
    ranked: list[RankedArchiveMember],
    arity: int,
) -> list[Heuristic]:
    """Select one parent or two distinct C-F parents from one fixed ranking."""

    if arity == 1:
        return [binary_tournament(ranked)]
    if arity == 2:
        first = binary_tournament(ranked)
        remaining = [row for row in ranked if row.member.candidate_id != first.id]
        assert remaining
        return [first, binary_tournament(remaining)]
    raise AssertionError(f"unsupported parent arity: {arity}")


def select_survivors(
    previous_successes: list[Heuristic],
    new_offspring: list[Heuristic],
    population_size: int,
    problem_spec: ProblemSpec,
    ref_ppa_metrics: dict[str, float],
) -> list[Heuristic]:
    """Apply NSGA-II environmental selection, then classic failed-child fill."""

    assert population_size > 0
    all_candidates = [*previous_successes, *new_offspring]
    assert len({candidate.id for candidate in all_candidates}) == len(all_candidates)
    successes = [
        *previous_successes,
        *(candidate for candidate in new_offspring if candidate.status == "success"),
    ]
    ranked = rank_successes(successes, problem_spec, ref_ppa_metrics)
    ranked.sort(key=_selection_key)
    survivors = [
        cast(Heuristic, row.member.payload) for row in ranked[:population_size]
    ]
    if len(survivors) == population_size:
        return survivors

    failed_offspring = [
        candidate for candidate in new_offspring if candidate.status != "success"
    ]
    random.shuffle(failed_offspring)
    failed_offspring.sort(key=lambda candidate: candidate.score, reverse=True)
    survivors.extend(failed_offspring[: population_size - len(survivors)])
    return survivors
