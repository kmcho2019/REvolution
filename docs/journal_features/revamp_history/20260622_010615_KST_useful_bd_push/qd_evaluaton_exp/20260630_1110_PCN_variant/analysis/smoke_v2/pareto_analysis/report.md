# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/tables/smoke_subset.yaml`
- backend_count: `4`
- overall_multi_objective_winner: `pcn_v2_passive_eoh_archive_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 3 | 3 | 0.3518 | 1.33 | 11.00 | 0 |
| `classic_revolution_8x5` | RTLLM | 3 | 3 | 0.3518 | 1.33 | 11.00 | 0 |
| `pcn_v2_passive_eoh_archive_8x5` | ALL | 3 | 3 | 0.3530 | 1.00 | 13.33 | 1 |
| `pcn_v2_passive_eoh_archive_8x5` | RTLLM | 3 | 3 | 0.3530 | 1.00 | 13.33 | 1 |
| `pcn_v2_random_eoh_memory_8x5` | ALL | 3 | 3 | 0.3100 | 1.00 | 13.00 | 0 |
| `pcn_v2_random_eoh_memory_8x5` | RTLLM | 3 | 3 | 0.3100 | 1.00 | 13.00 | 0 |
| `pcn_v2_rf_eoh_memory_8x5` | ALL | 3 | 3 | 0.3422 | 1.67 | 13.67 | 2 |
| `pcn_v2_rf_eoh_memory_8x5` | RTLLM | 3 | 3 | 0.3422 | 1.67 | 13.67 | 2 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob019_sub_64bit | 2 | 8 | 1 | 0.4499 | 2 |
| `pcn_v2_rf_eoh_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 8 | 1 | 0.4499 | 3 |
| `pcn_v2_random_eoh_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 10 | 1 | 0.3628 | 3 |
| `pcn_v2_passive_eoh_archive_8x5` | RTLLM | Prob019_sub_64bit | 2 | 9 | 1 | 0.4499 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob036_edge_detect | 3 | 6 | 1 | 0.3559 | 2 |
| `pcn_v2_rf_eoh_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 13 | 1 | 0.3559 | 6 |
| `pcn_v2_random_eoh_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 7 | 1 | 0.3261 | 2 |
| `pcn_v2_passive_eoh_archive_8x5` | RTLLM | Prob036_edge_detect | 3 | 7 | 1 | 0.3559 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 29 | 2 | 0.2497 | 29 |
| `pcn_v2_rf_eoh_memory_8x5` | RTLLM | Prob045_alu | 2 | 32 | 3 | 0.2207 | 32 |
| `pcn_v2_random_eoh_memory_8x5` | RTLLM | Prob045_alu | 2 | 34 | 1 | 0.2412 | 34 |
| `pcn_v2_passive_eoh_archive_8x5` | RTLLM | Prob045_alu | 2 | 35 | 1 | 0.2533 | 35 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob019_sub_64bit | [pairwise_fronts.png](problems/RTLLM/Prob019_sub_64bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob036_edge_detect | [pairwise_fronts.png](problems/RTLLM/Prob036_edge_detect/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob036_edge_detect/front_3d.png) |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
