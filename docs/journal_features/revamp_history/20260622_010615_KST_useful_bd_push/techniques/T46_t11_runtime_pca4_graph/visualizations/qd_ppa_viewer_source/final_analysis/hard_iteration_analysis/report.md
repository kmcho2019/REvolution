# Hard Iteration Subset Analysis

- Subset: `hard_iteration_subset`
- Problems: `3`
- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.

## Summary Table

| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |
|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|
| `classic` | 37.5% | 37.5% | 3/3 | 0.2914 | 602.88 | N/A | N/A | 0.1588 | 2.67 |
| `t11_runtime_pca4_graph_qd` | 29.2% | 25.7% | 3/3 | 0.2768 | 719.45 | 3.0% | 1.5955 | 0.1155 | 3.00 |

## Recommendations

- Overall: `classic`
- Score-oriented QD: `t11_runtime_pca4_graph_qd`
- Archive-health QD: `t11_runtime_pca4_graph_qd`
- Multi-objective: `classic`

## Per-Problem Winners

| Benchmark | Problem | Winner | Synthesis Rate | Best Score |
|:---|:---|:---|:---|:---|
| RTLLM | Prob045_alu | `classic` | 47.9% | 0.3966 |
| RTLLM | Prob041_traffic_light | `classic` | 33.3% | 0.4248 |
| RTLLM | Prob015_multi_pipe_8bit | `classic` | 31.2% | 0.0528 |
