# Hard Iteration Subset Analysis

- Subset: `hard_iteration_subset`
- Problems: `3`
- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.

## Summary Table

| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |
|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|
| `classic` | 43.8% | 42.4% | 3/3 | 0.3346 | 579.94 | N/A | N/A | 0.2043 | 3.67 |
| `t11_runtime_top4_graph_qd` | 33.3% | 28.5% | 3/3 | 0.2995 | 689.29 | 3.1% | 1.3933 | 0.1775 | 3.33 |

## Recommendations

- Overall: `classic`
- Score-oriented QD: `t11_runtime_top4_graph_qd`
- Archive-health QD: `t11_runtime_top4_graph_qd`
- Multi-objective: `classic`

## Per-Problem Winners

| Benchmark | Problem | Winner | Synthesis Rate | Best Score |
|:---|:---|:---|:---|:---|
| RTLLM | Prob045_alu | `classic` | 37.5% | 0.4074 |
| RTLLM | Prob041_traffic_light | `classic` | 50.0% | 0.4508 |
| RTLLM | Prob015_multi_pipe_8bit | `classic` | 39.6% | 0.1455 |
