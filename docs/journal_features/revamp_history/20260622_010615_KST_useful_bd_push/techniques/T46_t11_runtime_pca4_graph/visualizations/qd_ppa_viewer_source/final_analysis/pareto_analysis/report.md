# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/tables/live_screen_v0_subset.yaml`
- backend_count: `2`
- overall_multi_objective_winner: `classic`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic` | ALL | 3 | 3 | 0.1588 | 2.67 | 11.00 | 2 |
| `classic` | RTLLM | 3 | 3 | 0.1588 | 2.67 | 11.00 | 2 |
| `t11_runtime_pca4_graph_qd` | ALL | 3 | 3 | 0.1155 | 3.00 | 7.00 | 1 |
| `t11_runtime_pca4_graph_qd` | RTLLM | 3 | 3 | 0.1155 | 3.00 | 7.00 | 1 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic` | RTLLM | Prob045_alu | 2 | 21 | 1 | 0.1962 | 21 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob045_alu | 2 | 15 | 1 | 0.2046 | 15 |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 13 | 1 | 0.2801 | 12 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob041_traffic_light | 2 | 8 | 2 | 0.1419 | 6 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 12 | 6 | 0.0000 | 0 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 6 | 0.0000 | 0 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
| RTLLM | Prob041_traffic_light | [pairwise_fronts.png](problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png) | n/a |
| RTLLM | Prob015_multi_pipe_8bit | [pairwise_fronts.png](problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png) |
