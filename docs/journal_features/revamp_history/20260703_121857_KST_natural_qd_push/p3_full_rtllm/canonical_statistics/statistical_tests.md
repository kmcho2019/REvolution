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
