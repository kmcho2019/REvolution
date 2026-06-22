# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T44_t11_runtime_graph_bridge/tables/live_screen_v0_subset.yaml`
- backend_count: `2`
- overall_multi_objective_winner: `classic`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic` | ALL | 3 | 3 | 0.1638 | 3.33 | 16.33 | 1 |
| `classic` | RTLLM | 3 | 3 | 0.1638 | 3.33 | 16.33 | 1 |
| `t11_runtime_top8_graph_qd` | ALL | 3 | 3 | 0.1542 | 3.67 | 6.33 | 2 |
| `t11_runtime_top8_graph_qd` | RTLLM | 3 | 3 | 0.1542 | 3.67 | 6.33 | 2 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic` | RTLLM | Prob045_alu | 2 | 32 | 1 | 0.2649 | 32 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob045_alu | 2 | 14 | 2 | 0.2201 | 14 |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 21 | 3 | 0.2264 | 17 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob041_traffic_light | 2 | 7 | 2 | 0.2424 | 4 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 14 | 6 | 0.0000 | 0 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 13 | 7 | 0.0001 | 1 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
| RTLLM | Prob041_traffic_light | [pairwise_fronts.png](problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png) | n/a |
| RTLLM | Prob015_multi_pipe_8bit | [pairwise_fronts.png](problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png) |
