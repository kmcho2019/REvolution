import pytest

from revolution.qd.scoring import (
    compute_partial_pass_fraction,
    compute_quality_score,
    compute_repair_score,
    default_ppa_weights,
    normalize_code_hash,
)


def test_default_ppa_weights_follow_circuit_type():
    assert default_ppa_weights("sequential") == pytest.approx((1 / 3, 1 / 3, 1 / 3))
    assert default_ppa_weights("combinational") == pytest.approx((0.5, 0.5, 0.0))


def test_compute_quality_score_matches_revolution_equation():
    score, components = compute_quality_score(
        {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8},
        {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        circuit_type="sequential",
    )
    assert components["g_P"] == pytest.approx(0.1)
    assert components["g_A"] == pytest.approx(0.1)
    assert components["g_T"] == pytest.approx(0.2)
    assert score == pytest.approx((0.1 + 0.1 + 0.2) / 3)


def test_compute_partial_pass_fraction_counts_true_stage_flags():
    fraction = compute_partial_pass_fraction(
        {"format": True, "diff": True, "syntax": False, "functionality": False}
    )
    assert fraction == pytest.approx(0.5)


def test_compute_repair_score_increases_with_stage_rank_and_partial_pass():
    low = compute_repair_score(
        "failed_syntax",
        stage_statuses={"format": True, "diff": True, "syntax": False},
    )
    high = compute_repair_score(
        "failed_functionality",
        stage_statuses={"format": True, "diff": True, "syntax": True, "functionality": False},
    )
    assert high > low


def test_normalize_code_hash_ignores_line_ending_differences():
    a = normalize_code_hash("module m;\r\nendmodule\r\n")
    b = normalize_code_hash("module m;\nendmodule\n")
    assert a == b
