from __future__ import annotations

import pytest

from scripts.tcad_extension_gate_contract import (
    COVERAGE_SURFACES,
    CoverageSurface,
    evaluate_per_seed_coverage,
    loss_only_coverage_deficit,
)


def _counts(seed_1001: int, seed_1002: int) -> dict[CoverageSurface, dict[int, int]]:
    return {
        surface: {1001: seed_1001, 1002: seed_1002}
        for surface in COVERAGE_SURFACES
    }


def test_cross_seed_gain_does_not_offset_two_design_loss() -> None:
    classic = _counts(40, 40)
    treatment = _counts(38, 41)
    assert evaluate_per_seed_coverage(classic, treatment) == {
        surface: False for surface in COVERAGE_SURFACES
    }


def test_one_design_loss_in_each_seed_passes() -> None:
    classic = _counts(40, 40)
    treatment = _counts(39, 39)
    assert evaluate_per_seed_coverage(classic, treatment) == {
        surface: True for surface in COVERAGE_SURFACES
    }


def test_missing_or_mismatched_seed_sets_fail() -> None:
    classic = _counts(40, 40)
    treatment = _counts(40, 40)
    del classic["valid_ppa46"][1002]

    with pytest.raises(AssertionError):
        evaluate_per_seed_coverage(classic, treatment)

    classic = _counts(40, 40)
    treatment["rtl_functionality50"] = {1001: 40, 1003: 40}
    with pytest.raises(AssertionError):
        evaluate_per_seed_coverage(classic, treatment)


def test_catastrophic_deficit_does_not_net_cross_seed_gain() -> None:
    classic = _counts(40, 40)
    treatment = _counts(38, 41)

    assert loss_only_coverage_deficit(classic, treatment) == {
        surface: 2 for surface in COVERAGE_SURFACES
    }
