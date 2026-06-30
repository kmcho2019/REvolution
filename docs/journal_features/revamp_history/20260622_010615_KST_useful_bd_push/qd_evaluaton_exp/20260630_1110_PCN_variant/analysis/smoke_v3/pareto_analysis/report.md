# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/tables/smoke_subset.yaml`
- backend_count: `4`
- overall_multi_objective_winner: `classic_revolution_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 3 | 3 | 0.3471 | 1.00 | 12.67 | 1 |
| `classic_revolution_8x5` | RTLLM | 3 | 3 | 0.3471 | 1.00 | 12.67 | 1 |
| `pcn_v2_passive_eoh_archive_8x5` | ALL | 3 | 3 | 0.3416 | 1.33 | 15.33 | 0 |
| `pcn_v2_passive_eoh_archive_8x5` | RTLLM | 3 | 3 | 0.3416 | 1.33 | 15.33 | 0 |
| `pcn_v3_random_stagnation_memory_8x5` | ALL | 3 | 3 | 0.3378 | 1.67 | 11.33 | 1 |
| `pcn_v3_random_stagnation_memory_8x5` | RTLLM | 3 | 3 | 0.3378 | 1.67 | 11.33 | 1 |
| `pcn_v3_rf_stagnation_memory_8x5` | ALL | 3 | 3 | 0.3432 | 1.67 | 11.67 | 1 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | 3 | 3 | 0.3432 | 1.67 | 11.67 | 1 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob019_sub_64bit | 2 | 5 | 1 | 0.4499 | 4 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 11 | 1 | 0.4500 | 2 |
| `pcn_v3_random_stagnation_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 9 | 1 | 0.4499 | 3 |
| `pcn_v2_passive_eoh_archive_8x5` | RTLLM | Prob019_sub_64bit | 2 | 13 | 1 | 0.4499 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.3559 | 2 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 7 | 1 | 0.3559 | 2 |
| `pcn_v3_random_stagnation_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.3559 | 3 |
| `pcn_v2_passive_eoh_archive_8x5` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.3559 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 32 | 1 | 0.2354 | 32 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob045_alu | 2 | 31 | 3 | 0.2238 | 31 |
| `pcn_v3_random_stagnation_memory_8x5` | RTLLM | Prob045_alu | 2 | 28 | 3 | 0.2077 | 28 |
| `pcn_v2_passive_eoh_archive_8x5` | RTLLM | Prob045_alu | 2 | 39 | 2 | 0.2189 | 39 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob019_sub_64bit | [pairwise_fronts.png](problems/RTLLM/Prob019_sub_64bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob036_edge_detect | [pairwise_fronts.png](problems/RTLLM/Prob036_edge_detect/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob036_edge_detect/front_3d.png) |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
