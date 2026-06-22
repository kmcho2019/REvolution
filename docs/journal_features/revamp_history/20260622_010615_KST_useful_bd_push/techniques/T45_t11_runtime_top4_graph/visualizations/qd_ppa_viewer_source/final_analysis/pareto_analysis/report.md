# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph/tables/live_screen_v0_subset.yaml`
- backend_count: `2`
- overall_multi_objective_winner: `classic`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic` | ALL | 3 | 3 | 0.2043 | 3.67 | 10.00 | 3 |
| `classic` | RTLLM | 3 | 3 | 0.2043 | 3.67 | 10.00 | 3 |
| `t11_runtime_top4_graph_qd` | ALL | 3 | 3 | 0.1775 | 3.33 | 8.67 | 0 |
| `t11_runtime_top4_graph_qd` | RTLLM | 3 | 3 | 0.1775 | 3.33 | 8.67 | 0 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic` | RTLLM | Prob045_alu | 2 | 18 | 2 | 0.2287 | 18 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob045_alu | 2 | 13 | 2 | 0.2264 | 13 |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 23 | 3 | 0.3843 | 12 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3062 | 13 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 6 | 0.0000 | 0 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 6 | 0.0000 | 0 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
| RTLLM | Prob041_traffic_light | [pairwise_fronts.png](problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png) | n/a |
| RTLLM | Prob015_multi_pipe_8bit | [pairwise_fronts.png](problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png) |
