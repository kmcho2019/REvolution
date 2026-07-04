# Journal Statistical Tests

Baseline: `classic` | Treatment: `smooth_qd_v2` | Seed pairs: 5

Deltas are treatment minus baseline on problem-seed units. `avg_ppa_improvement` and pass metrics use fraction scale.

| Metric | Units | Paired | Missing-T (loss) | Imputed | Mean Δ (gate) | 95% cluster CI | Complete-case Δ | Win rate (non-tied) | Sign-test p |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| best_quality | 250 | 176 | 2 | 2 | -0.5388 | [-1.5194, +0.1836] | +0.0375 | 47% (54W/62L/62T) | 0.5159 |
| avg_ppa_improvement | 250 | 176 | 2 | 2 | -0.3523 | [-1.3391, +0.3908] | +0.2262 | 47% (54W/62L/62T) | 0.5159 |
| hypervolume | 250 | 250 | 0 | 0 | +0.0035 | [-0.0089, +0.0210] | +0.0035 | 48% (45W/48L/157T) | 0.8358 |
| functional_any_pass | 250 | 250 | 0 | 0 | +0.0200 | [-0.0040, +0.0480] | +0.0200 | 73% (8W/3L/239T) | 0.2266 |
| valid_ppa_any_pass | 250 | 250 | 0 | 0 | +0.0120 | [-0.0040, +0.0360] | +0.0120 | 71% (5W/2L/243T) | 0.4531 |

## Gate checks (reference_ppa)

| Check | Required | Observed | Passed |
| --- | --- | --- | --- |
| mean_paired_best_quality_delta | >= +0.03 (penalized) | -0.5388 | ❌ |
| mean_paired_avg_ppa_improvement_delta | >= +0.05 (penalized) | -0.3523 | ❌ |
| best_quality_cluster_ci_low | > 0 | -1.5194 | ❌ |
| hypervolume_log_ratio_mean | >= log(1.05) (0.0488) | 0.2698 | ✅ |
| hypervolume_log_ratio_ci_low | > 0 | -0.4981 | ❌ |
| win_rate_non_tied | >= 60% | 0.4655 | ❌ |
| win_rate_non_tied_pair_count | >= 10 | 116.0000 | ✅ |
| win_rate_sign_test_p | < 0.05 | 0.5159 | ❌ |
| valid_ppa_any_pass_count | >= baseline | 181.0000 | ✅ |

**Overall gate: FAIL**
