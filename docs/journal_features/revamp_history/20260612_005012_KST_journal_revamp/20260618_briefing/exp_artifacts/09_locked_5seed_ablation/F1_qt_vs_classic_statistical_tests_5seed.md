# Journal Statistical Tests

Baseline: `classic` | Treatment: `qd` | Seed pairs: 5

Deltas are treatment minus baseline on problem-seed units. `avg_ppa_improvement` and pass metrics use fraction scale.

| Metric | Units | Paired | Missing-T (loss) | Imputed | Mean Δ (gate) | 95% cluster CI | Complete-case Δ | Win rate (non-tied) | Sign-test p |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| best_quality | 65 | 65 | 0 | 0 | -0.0927 | [-0.1491, -0.0357] | -0.0927 | 21% (12W/45L/8T) | 0.0000 |
| avg_ppa_improvement | 65 | 65 | 0 | 0 | -0.1340 | [-0.2133, -0.0569] | -0.1340 | 21% (12W/45L/8T) | 0.0000 |
| hypervolume | 65 | 65 | 0 | 0 | -0.0518 | [-0.0909, -0.0164] | -0.0518 | 11% (4W/33L/28T) | 0.0000 |
| functional_any_pass | 65 | 65 | 0 | 0 | +0.0000 | [+0.0000, +0.0000] | +0.0000 | n/a | n/a |
| valid_ppa_any_pass | 65 | 65 | 0 | 0 | +0.0000 | [+0.0000, +0.0000] | +0.0000 | n/a | n/a |
