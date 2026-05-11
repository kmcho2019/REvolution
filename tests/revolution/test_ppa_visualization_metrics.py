from __future__ import annotations

import math

from revolution.qd.ppa_visualization_metrics import (
    active_objective_keys,
    dominates_values,
    hypervolume_payload,
    pareto_ranks,
)


def test_active_objectives_follow_circuit_type() -> None:
    assert active_objective_keys("combinational") == ("g_P", "g_A")
    assert active_objective_keys("sequential") == ("g_P", "g_A", "g_T")


def test_pareto_ranks_are_contiguous_for_2d_fronts() -> None:
    samples = [
        {"sample_id": "a", "g_P": 0.3, "g_A": 0.2},
        {"sample_id": "b", "g_P": 0.2, "g_A": 0.3},
        {"sample_id": "c", "g_P": 0.1, "g_A": 0.1},
    ]

    ranks = pareto_ranks(samples, ("g_P", "g_A"))

    assert ranks == {"a": 1, "b": 1, "c": 2}
    assert sorted(set(ranks.values())) == [1, 2]


def test_pareto_ranks_use_3d_sequential_objectives() -> None:
    samples = [
        {"sample_id": "a", "g_P": 0.3, "g_A": 0.2, "g_T": 0.0},
        {"sample_id": "b", "g_P": 0.3, "g_A": 0.2, "g_T": 0.2},
        {"sample_id": "c", "g_P": 0.2, "g_A": 0.2, "g_T": 0.1},
    ]

    ranks = pareto_ranks(samples, ("g_P", "g_A", "g_T"))

    assert ranks["b"] == 1
    assert ranks["a"] == 2
    assert ranks["c"] == 2


def test_dominance_requires_strict_improvement() -> None:
    left = {"g_P": 1.0, "g_A": 1.0}
    same = {"g_P": 1.0, "g_A": 1.0}
    worse = {"g_P": 0.9, "g_A": 1.0}

    assert not dominates_values(left, same, ("g_P", "g_A"))
    assert dominates_values(left, worse, ("g_P", "g_A"))


def test_hypervolume_payload_is_finite_and_deterministic() -> None:
    payload = hypervolume_payload(
        [(0.2, 0.3), (0.3, 0.2)],
        ("g_P", "g_A"),
    )

    assert payload["method"] == "exact_recursive"
    assert payload["reference_point"] == {"g_P": 0.0, "g_A": 0.0}
    assert math.isfinite(payload["value"])
    assert payload["value"] > 0.0


def test_3d_hypervolume_uses_deterministic_monte_carlo_metadata() -> None:
    payload = hypervolume_payload(
        [(0.2, 0.3, 0.4), (0.3, 0.2, 0.4)],
        ("g_P", "g_A", "g_T"),
    )

    assert payload["method"] == "deterministic_monte_carlo"
    assert payload["seed"] == 20260506
    assert payload["sample_count"] == 4096
    assert math.isfinite(payload["value"])
