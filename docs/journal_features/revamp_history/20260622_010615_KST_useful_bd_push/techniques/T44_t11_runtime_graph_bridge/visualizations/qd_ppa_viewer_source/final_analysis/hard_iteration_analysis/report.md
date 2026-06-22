# Hard Iteration Subset Analysis

- Subset: `hard_iteration_subset`
- Problems: `3`
- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.

## Summary Table

| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |
|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|
| `classic` | 52.8% | 52.8% | 3/3 | 0.2823 | 614.78 | N/A | N/A | 0.1638 | 3.33 |
| `t11_runtime_top8_graph_qd` | 34.7% | 25.0% | 3/3 | 0.3033 | 685.72 | 0.0% | 0.9351 | 0.1542 | 3.67 |

## Recommendations

- Overall: `classic`
- Score-oriented QD: `t11_runtime_top8_graph_qd`
- Archive-health QD: `t11_runtime_top8_graph_qd`
- Multi-objective: `classic`

## Per-Problem Winners

| Benchmark | Problem | Winner | Synthesis Rate | Best Score |
|:---|:---|:---|:---|:---|
| RTLLM | Prob045_alu | `classic` | 72.9% | 0.4198 |
| RTLLM | Prob041_traffic_light | `classic` | 52.1% | 0.3891 |
| RTLLM | Prob015_multi_pipe_8bit | `classic` | 33.3% | 0.0379 |
