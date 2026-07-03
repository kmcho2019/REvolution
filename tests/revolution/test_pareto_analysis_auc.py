from __future__ import annotations

import pytest

from revolution.qd.pareto_analysis import (
    cumulative_hypervolume_curve,
    hypervolume_auc,
)


def test_curve_empty_generations_are_zero() -> None:
    curve = cumulative_hypervolume_curve({}, 3)
    assert curve == [0.0, 0.0, 0.0, 0.0]


def test_curve_is_cumulative_and_monotone() -> None:
    points = {
        1: [(0.5, 0.2)],
        3: [(0.2, 0.6)],
    }
    curve = cumulative_hypervolume_curve(points, 3)
    assert len(curve) == 4
    assert curve[0] == 0.0
    assert curve[1] == pytest.approx(0.10)
    assert curve[2] == pytest.approx(0.10)
    # (0.5, 0.2) and (0.2, 0.6): union area = 0.5*0.2 + 0.2*(0.6-0.2)
    assert curve[3] == pytest.approx(0.18)
    assert curve == sorted(curve)


def test_curve_rejects_out_of_range_generation() -> None:
    with pytest.raises(AssertionError):
        cumulative_hypervolume_curve({4: [(1.0,)]}, 3)


def test_auc_matches_trapezoid_mean() -> None:
    assert hypervolume_auc([0.0, 0.1, 0.1, 0.3]) == pytest.approx(
        ((0.0 + 0.1) / 2 + (0.1 + 0.1) / 2 + (0.1 + 0.3) / 2) / 3
    )


def test_auc_of_flat_curve_is_its_value() -> None:
    assert hypervolume_auc([0.2, 0.2, 0.2]) == pytest.approx(0.2)


def test_auc_requires_two_steps() -> None:
    with pytest.raises(AssertionError):
        hypervolume_auc([0.5])
