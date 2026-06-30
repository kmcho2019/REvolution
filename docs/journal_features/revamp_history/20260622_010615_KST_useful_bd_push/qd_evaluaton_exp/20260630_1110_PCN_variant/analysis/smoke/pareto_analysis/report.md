# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/tables/smoke_subset.yaml`
- backend_count: `5`
- overall_multi_objective_winner: `classic_revolution_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 3 | 3 | 0.3508 | 1.00 | 11.00 | 3 |
| `classic_revolution_8x5` | RTLLM | 3 | 3 | 0.3508 | 1.00 | 11.00 | 3 |
| `pcn_passive_archive_8x5` | ALL | 3 | 3 | 0.0619 | 1.33 | 5.67 | 0 |
| `pcn_passive_archive_8x5` | RTLLM | 3 | 3 | 0.0619 | 1.33 | 5.67 | 0 |
| `pcn_random_quality_memory_8x5` | ALL | 3 | 3 | 0.0771 | 1.33 | 5.00 | 0 |
| `pcn_random_quality_memory_8x5` | RTLLM | 3 | 3 | 0.0771 | 1.33 | 5.00 | 0 |
| `pcn_rf_leafid_quality_memory_8x5` | ALL | 3 | 3 | 0.1758 | 1.33 | 3.67 | 0 |
| `pcn_rf_leafid_quality_memory_8x5` | RTLLM | 3 | 3 | 0.1758 | 1.33 | 3.67 | 0 |
| `pcn_sr_quality_memory_8x5` | ALL | 3 | 3 | 0.0566 | 1.33 | 2.67 | 0 |
| `pcn_sr_quality_memory_8x5` | RTLLM | 3 | 3 | 0.0566 | 1.33 | 2.67 | 0 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob019_sub_64bit | 2 | 12 | 1 | 0.4499 | 5 |
| `pcn_passive_archive_8x5` | RTLLM | Prob019_sub_64bit | 2 | 3 | 1 | 0.0000 | 1 |
| `pcn_rf_leafid_quality_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 4 | 1 | 0.0000 | 1 |
| `pcn_random_quality_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 3 | 1 | 0.0000 | 1 |
| `pcn_sr_quality_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 3 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob036_edge_detect | 3 | 7 | 1 | 0.3559 | 1 |
| `pcn_passive_archive_8x5` | RTLLM | Prob036_edge_detect | 3 | 3 | 1 | 0.0000 | 0 |
| `pcn_rf_leafid_quality_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 3 | 1 | 0.3559 | 1 |
| `pcn_random_quality_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 2 | 1 | 0.0000 | 0 |
| `pcn_sr_quality_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 27 | 1 | 0.2466 | 27 |
| `pcn_passive_archive_8x5` | RTLLM | Prob045_alu | 2 | 16 | 2 | 0.1857 | 16 |
| `pcn_rf_leafid_quality_memory_8x5` | RTLLM | Prob045_alu | 2 | 9 | 2 | 0.1715 | 9 |
| `pcn_random_quality_memory_8x5` | RTLLM | Prob045_alu | 2 | 14 | 2 | 0.2312 | 14 |
| `pcn_sr_quality_memory_8x5` | RTLLM | Prob045_alu | 2 | 7 | 2 | 0.1698 | 7 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob019_sub_64bit | [pairwise_fronts.png](problems/RTLLM/Prob019_sub_64bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob036_edge_detect | [pairwise_fronts.png](problems/RTLLM/Prob036_edge_detect/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob036_edge_detect/front_3d.png) |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
