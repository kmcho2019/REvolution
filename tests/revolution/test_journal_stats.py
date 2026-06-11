from revolution.journal_stats import (
    PairedSample,
    bootstrap_mean_ci,
    cluster_bootstrap_mean_ci,
    equivalence_within_margin,
    evaluate_equivalence_gate,
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
    # A single value cannot support an interval; no degenerate zero-width CI.
    assert bootstrap_mean_ci([0.5]) == (0.5, None, None)


def test_cluster_bootstrap_keeps_seed_replicates_together():
    # Two clusters with internally consistent values: cluster bootstrap CI
    # must span the between-cluster spread, wider than a flat bootstrap that
    # treats all six values as independent.
    by_cluster = {
        "p1": [0.30, 0.31, 0.29],
        "p2": [-0.10, -0.11, -0.09],
    }
    flat = [v for values in by_cluster.values() for v in values]
    c_mean, c_low, c_high = cluster_bootstrap_mean_ci(
        by_cluster, seed=42, n_resamples=2000
    )
    f_mean, f_low, f_high = bootstrap_mean_ci(flat, seed=42, n_resamples=2000)

    assert c_mean is not None and f_mean is not None
    assert abs(c_mean - f_mean) < 1e-9
    assert c_low is not None and c_high is not None
    assert f_low is not None and f_high is not None
    assert (c_high - c_low) > (f_high - f_low)


def test_cluster_bootstrap_single_cluster_has_no_interval():
    mean, low, high = cluster_bootstrap_mean_ci({"p1": [0.1, 0.2]}, seed=42)
    assert mean is not None
    assert low is None and high is None


def test_sign_test_p_value_exact():
    assert sign_test_p_value(0, 0) is None
    p = sign_test_p_value(5, 0)
    assert p is not None
    assert abs(p - 0.0625) < 1e-12
    balanced = sign_test_p_value(3, 3)
    assert balanced is not None
    assert balanced == 1.0


def test_equivalence_requires_full_ci_containment():
    assert equivalence_within_margin(-0.01, 0.02, margin=0.03) is True
    assert equivalence_within_margin(-0.05, 0.02, margin=0.03) is False
    assert equivalence_within_margin(None, 0.02, margin=0.03) is False


def _samples_for_seeds(values: dict[str, list[tuple[float | None, float | None]]]):
    samples = []
    for problem, pairs in values.items():
        for seed_index, (baseline, treatment) in enumerate(pairs):
            samples.append(
                PairedSample(
                    unit_id=f"s{seed_index}/RTLLM/{problem}",
                    baseline=baseline,
                    treatment=treatment,
                )
            )
    return samples


def test_summarize_paired_metric_counts_missing_treatment_as_loss():
    samples = [
        PairedSample("s0/RTLLM/p1", baseline=0.1, treatment=0.3),
        PairedSample("s0/RTLLM/p2", baseline=0.2, treatment=0.2),
        PairedSample("s0/RTLLM/p3", baseline=0.4, treatment=None),
        PairedSample("s0/RTLLM/p4", baseline=None, treatment=0.5),
        PairedSample("s0/RTLLM/p5", baseline=0.0, treatment=0.2),
    ]
    summary = summarize_paired_metric("best_quality", samples, seed=42)

    assert summary.unit_count == 5
    assert summary.paired_count == 3
    assert summary.missing_treatment_count == 1
    assert summary.missing_baseline_count == 1
    assert summary.wins == 2
    assert summary.losses == 1  # the missing-treatment unit
    assert summary.ties == 1
    # No floor given: gate stats are complete-case.
    assert summary.imputed_loss_count == 0
    assert summary.ci_method == "cluster_bootstrap"
    assert summary.mean_delta is not None
    assert abs(summary.mean_delta - (0.2 + 0.0 + 0.2) / 3) < 1e-12
    assert summary.win_rate_non_tied == 2 / 3


def test_summarize_paired_metric_penalizes_missing_with_floor():
    samples = [
        PairedSample("s0/RTLLM/p1", baseline=0.1, treatment=0.3),
        PairedSample("s0/RTLLM/p2", baseline=0.4, treatment=None),
    ]
    summary = summarize_paired_metric(
        "best_quality", samples, seed=42, missing_treatment_floor=0.0
    )

    assert summary.imputed_loss_count == 1
    assert summary.ci_method == "cluster_bootstrap_penalized"
    # Penalized deltas: +0.2 and (0.0 - 0.4) = -0.4 -> mean -0.1.
    assert summary.mean_delta is not None
    assert abs(summary.mean_delta - (-0.1)) < 1e-12
    # Complete-case mean reported separately.
    assert summary.complete_case_mean_delta is not None
    assert abs(summary.complete_case_mean_delta - 0.2) < 1e-12
    assert summary.losses == 1


def test_reference_ppa_gates_pass_and_fail():
    good_values = {
        f"p{i}": [(0.0, 0.1), (0.0, 0.11), (0.0, 0.09)] for i in range(6)
    }
    good = summarize_paired_metric(
        "best_quality", _samples_for_seeds(good_values), seed=42
    )
    gates = evaluate_reference_ppa_gates(
        best_quality=good,
        avg_ppa_improvement=good,
        hypervolume_log_ratio_mean=0.10,
        hypervolume_log_ratio_ci_low=0.02,
        treatment_valid_ppa_any_pass=9,
        baseline_valid_ppa_any_pass=8,
    )
    assert all(check.passed for check in gates)

    bad_values = {
        f"p{i}": [(0.2, 0.1), (0.2, 0.12), (0.2, 0.09)] for i in range(6)
    }
    bad = summarize_paired_metric(
        "best_quality", _samples_for_seeds(bad_values), seed=42
    )
    gates = evaluate_reference_ppa_gates(
        best_quality=bad,
        avg_ppa_improvement=bad,
        hypervolume_log_ratio_mean=-0.02,
        hypervolume_log_ratio_ci_low=-0.05,
        treatment_valid_ppa_any_pass=5,
        baseline_valid_ppa_any_pass=8,
    )
    failing = {check.name for check in gates if not check.passed}
    assert "mean_paired_best_quality_delta" in failing
    assert "best_quality_cluster_ci_low" in failing
    assert "hypervolume_log_ratio_mean" in failing
    assert "win_rate_non_tied" in failing
    assert "valid_ppa_any_pass_count" in failing


def test_equivalence_gate_requires_containment_and_pairs():
    parity_values = {
        f"p{i}": [(0.10, 0.105), (0.10, 0.095), (0.10, 0.102)] for i in range(6)
    }
    parity = summarize_paired_metric(
        "best_quality", _samples_for_seeds(parity_values), seed=42
    )
    gates = evaluate_equivalence_gate(parity, margin=0.03)
    assert all(check.passed for check in gates)

    sparse = summarize_paired_metric(
        "best_quality",
        [PairedSample("s0/RTLLM/p1", 0.1, 0.101)],
        seed=42,
    )
    gates = evaluate_equivalence_gate(sparse, margin=0.03)
    assert not all(check.passed for check in gates)


def test_functional_gates_threshold():
    gates = evaluate_functional_gates(
        pass_rate_delta_points=6.0, pass_rate_ci_low_points=0.5
    )
    assert all(check.passed for check in gates)
    gates = evaluate_functional_gates(
        pass_rate_delta_points=4.0, pass_rate_ci_low_points=-0.5
    )
    assert not any(check.passed for check in gates)
