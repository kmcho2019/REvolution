# Journal Statistical Tests

Baseline: `classic` | Treatment: `qd` | Seed pairs: 5

Deltas are treatment minus baseline on problem-seed units. `avg_ppa_improvement` and pass metrics use fraction scale.

| Metric | Units | Paired | Missing-T (loss) | Imputed | Mean Δ (gate) | 95% cluster CI | Complete-case Δ | Win rate (non-tied) | Sign-test p |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| best_quality | 65 | 65 | 0 | 0 | -0.0340 | [-0.0663, -0.0089] | -0.0340 | 34% (15W/29L/21T) | 0.0488 |
| avg_ppa_improvement | 65 | 65 | 0 | 0 | -0.0476 | [-0.0950, -0.0126] | -0.0476 | 34% (15W/29L/21T) | 0.0488 |
| hypervolume | 65 | 65 | 0 | 0 | -0.0216 | [-0.0455, -0.0050] | -0.0216 | 31% (10W/22L/33T) | 0.0501 |
| functional_any_pass | 65 | 65 | 0 | 0 | +0.0000 | [+0.0000, +0.0000] | +0.0000 | n/a | n/a |
| valid_ppa_any_pass | 65 | 65 | 0 | 0 | +0.0000 | [+0.0000, +0.0000] | +0.0000 | n/a | n/a |
