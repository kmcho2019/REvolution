from revolution.journal_stats import (
    PairedSample,
    bootstrap_mean_ci,
    evaluate_functional_gates,
    evaluate_reference_ppa_gates,
    sign_test_p_value,
    summarize_paired_metric,
)


def test_bootstrap_mean_ci_is_seed_deterministic():
    values = [0.1, 0.2, -0.05, 0.3, 0.15]
    first = bootstrap_mean_ci(values, seed=42, n_resamples=2000)
    second = bootstrap_mean_ci(values, seed=42, n_resamples=2000)
    third = bootstrap_mean_ci(values, seed=7, n_resamples=2000)

    assert first == second
    assert first != third
    mean, low, high = first
    assert mean is not None and low is not None and high is not None
    assert low <= mean <= high


def test_bootstrap_mean_ci_edge_cases():
    assert bootstrap_mean_ci([]) == (None, None, None)
    assert bootstrap_mean_ci([0.5]) == (0.5, 0.5, 0.5)


def test_sign_test_p_value_exact():
    assert sign_test_p_value(0, 0) is None
    # 5 wins / 0 losses: p = 2 * (1/32) = 0.0625
    p = sign_test_p_value(5, 0)
    assert p is not None
    assert abs(p - 0.0625) < 1e-12
    balanced = sign_test_p_value(3, 3)
    assert balanced is not None
    assert balanced == 1.0


def test_summarize_paired_metric_counts_missing_treatment_as_loss():
    samples = [
        PairedSample("u1", baseline=0.1, treatment=0.3),
        PairedSample("u2", baseline=0.2, treatment=0.2),
        PairedSample("u3", baseline=0.4, treatment=None),
        PairedSample("u4", baseline=None, treatment=0.5),
        PairedSample("u5", baseline=0.0, treatment=0.2),
    ]
    summary = summarize_paired_metric("best_quality", samples, seed=42)

    assert summary.unit_count == 5
    assert summary.paired_count == 3
    assert summary.missing_treatment_count == 1
    assert summary.missing_baseline_count == 1
    assert summary.wins == 2
    assert summary.losses == 1  # the missing-treatment unit
    assert summary.ties == 1
    assert summary.mean_delta is not None
    assert abs(summary.mean_delta - (0.2 + 0.0 + 0.2) / 3) < 1e-12
    assert summary.win_rate_non_tied == 2 / 3


def test_reference_ppa_gates_pass_and_fail():
    good = summarize_paired_metric(
        "best_quality",
        [PairedSample(f"u{i}", 0.0, 0.1) for i in range(10)],
        seed=42,
    )
    gates = evaluate_reference_ppa_gates(
        best_quality=good,
        avg_ppa_improvement=good,
        hypervolume_relative_improvement=0.10,
        hypervolume_ci_low=0.02,
        treatment_valid_ppa_any_pass=9,
        baseline_valid_ppa_any_pass=8,
    )
    assert all(check.passed for check in gates)

    bad = summarize_paired_metric(
        "best_quality",
        [PairedSample(f"u{i}", 0.2, 0.1) for i in range(10)],
        seed=42,
    )
    gates = evaluate_reference_ppa_gates(
        best_quality=bad,
        avg_ppa_improvement=bad,
        hypervolume_relative_improvement=-0.02,
        hypervolume_ci_low=-0.05,
        treatment_valid_ppa_any_pass=5,
        baseline_valid_ppa_any_pass=8,
    )
    assert not any(check.passed for check in gates)


def test_functional_gates_threshold():
    gates = evaluate_functional_gates(
        pass_rate_delta_points=6.0, pass_rate_ci_low_points=0.5
    )
    assert all(check.passed for check in gates)
    gates = evaluate_functional_gates(
        pass_rate_delta_points=4.0, pass_rate_ci_low_points=-0.5
    )
    assert not any(check.passed for check in gates)
