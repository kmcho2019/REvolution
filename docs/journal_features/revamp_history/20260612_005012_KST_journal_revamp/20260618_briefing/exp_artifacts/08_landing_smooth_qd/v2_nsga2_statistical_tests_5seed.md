# Journal Statistical Tests

Baseline: `classic` | Treatment: `qd` | Seed pairs: 5

Deltas are treatment minus baseline on problem-seed units. `avg_ppa_improvement` and pass metrics use fraction scale.

| Metric | Units | Paired | Missing-T (loss) | Imputed | Mean Δ (gate) | 95% cluster CI | Complete-case Δ | Win rate (non-tied) | Sign-test p |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| best_quality | 65 | 65 | 0 | 0 | -0.0161 | [-0.0448, +0.0071] | -0.0161 | 39% (17W/27L/21T) | 0.1742 |
| avg_ppa_improvement | 65 | 65 | 0 | 0 | -0.0232 | [-0.0640, +0.0081] | -0.0232 | 39% (17W/27L/21T) | 0.1742 |
| hypervolume | 65 | 65 | 0 | 0 | -0.0189 | [-0.0387, -0.0023] | -0.0189 | 41% (13W/19L/33T) | 0.3771 |
| functional_any_pass | 65 | 65 | 0 | 0 | +0.0000 | [+0.0000, +0.0000] | +0.0000 | n/a | n/a |
| valid_ppa_any_pass | 65 | 65 | 0 | 0 | +0.0000 | [+0.0000, +0.0000] | +0.0000 | n/a | n/a |
