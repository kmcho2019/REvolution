"""Shared gate logic for TCAD extension candidate reporters."""

from __future__ import annotations

from collections.abc import Mapping
from typing import Literal


CoverageSurface = Literal[
    "valid_ppa46",
    "rtl_functionality46",
    "rtl_functionality50",
]
COVERAGE_SURFACES: tuple[CoverageSurface, ...] = (
    "valid_ppa46",
    "rtl_functionality46",
    "rtl_functionality50",
)
DEVELOPMENT_SEEDS = frozenset({1001, 1002})
MAXIMUM_COVERAGE_DEFICIT = 1


def _validate_coverage(
    classic: Mapping[CoverageSurface, Mapping[int, int]],
    treatment: Mapping[CoverageSurface, Mapping[int, int]],
) -> None:
    expected = set(COVERAGE_SURFACES)
    assert set(classic) == expected
    assert set(treatment) == expected
    for surface in COVERAGE_SURFACES:
        assert set(classic[surface]) == DEVELOPMENT_SEEDS
        assert set(treatment[surface]) == DEVELOPMENT_SEEDS


def evaluate_per_seed_coverage(
    classic: Mapping[CoverageSurface, Mapping[int, int]],
    treatment: Mapping[CoverageSurface, Mapping[int, int]],
) -> dict[CoverageSurface, bool]:
    """Evaluate every coverage surface independently in every seed.

    Args:
        classic: Classic design counts by surface and seed.
        treatment: Treatment design counts by surface and seed.
    Returns:
        Whether all seeds pass for each coverage surface.
    """
    _validate_coverage(classic, treatment)

    results: dict[CoverageSurface, bool] = {}
    for surface in COVERAGE_SURFACES:
        results[surface] = all(
            classic[surface][seed] - treatment[surface][seed]
            <= MAXIMUM_COVERAGE_DEFICIT
            for seed in classic[surface]
        )
    return results


def loss_only_coverage_deficit(
    classic: Mapping[CoverageSurface, Mapping[int, int]],
    treatment: Mapping[CoverageSurface, Mapping[int, int]],
) -> dict[CoverageSurface, int]:
    """Sum per-seed losses without offsetting them against gains."""
    _validate_coverage(classic, treatment)
    return {
        surface: sum(
            max(0, classic[surface][seed] - treatment[surface][seed])
            for seed in DEVELOPMENT_SEEDS
        )
        for surface in COVERAGE_SURFACES
    }
