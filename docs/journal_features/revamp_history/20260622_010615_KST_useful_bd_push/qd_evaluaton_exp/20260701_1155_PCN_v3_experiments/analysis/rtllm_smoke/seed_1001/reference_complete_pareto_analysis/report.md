# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/tables/rtllm_smoke_manifest.yaml`
- backend_count: `4`
- overall_multi_objective_winner: `pcn_v3_cf_restored_memory_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_no_cf_8x5` | ALL | 3 | 3 | 0.3395 | 1.00 | 9.67 | 0 |
| `classic_no_cf_8x5` | RTLLM | 3 | 3 | 0.3395 | 1.00 | 9.67 | 0 |
| `classic_revolution_8x5` | ALL | 3 | 3 | 0.3340 | 1.00 | 12.33 | 0 |
| `classic_revolution_8x5` | RTLLM | 3 | 3 | 0.3340 | 1.00 | 12.33 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | ALL | 3 | 3 | 0.5169 | 1.33 | 12.67 | 1 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | 3 | 3 | 0.5169 | 1.33 | 12.67 | 1 |
| `pcn_v3_no_cf_memory_8x5` | ALL | 3 | 3 | 0.3465 | 1.33 | 12.67 | 2 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | 3 | 3 | 0.3465 | 1.33 | 12.67 | 2 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob019_sub_64bit | 2 | 7 | 1 | 0.4499 | 3 |
| `classic_no_cf_8x5` | RTLLM | Prob019_sub_64bit | 2 | 10 | 1 | 0.4499 | 4 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 10 | 1 | 0.4499 | 5 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 10 | 1 | 0.4499 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob036_edge_detect | 3 | 5 | 1 | 0.3559 | 2 |
| `classic_no_cf_8x5` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.3559 | 2 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 7 | 1 | 0.3559 | 1 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 7 | 1 | 0.8947 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 32 | 1 | 0.1962 | 32 |
| `classic_no_cf_8x5` | RTLLM | Prob045_alu | 2 | 23 | 1 | 0.2126 | 23 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob045_alu | 2 | 32 | 2 | 0.2336 | 32 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob045_alu | 2 | 31 | 2 | 0.2059 | 31 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob019_sub_64bit | [pairwise_fronts.png](problems/RTLLM/Prob019_sub_64bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob036_edge_detect | [pairwise_fronts.png](problems/RTLLM/Prob036_edge_detect/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob036_edge_detect/front_3d.png) |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
