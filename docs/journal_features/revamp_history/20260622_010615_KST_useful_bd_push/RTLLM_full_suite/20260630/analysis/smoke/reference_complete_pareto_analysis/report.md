# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_smoke_manifest.yaml`
- backend_count: `8`
- overall_multi_objective_winner: `classic_revolution_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `aurora_raw_impl_compact_eoh_8x5` | ALL | 3 | 3 | 0.2102 | 1.67 | 5.33 | 0 |
| `aurora_raw_impl_compact_eoh_8x5` | RTLLM | 3 | 3 | 0.2102 | 1.67 | 5.33 | 0 |
| `classic_revolution_8x5` | ALL | 3 | 3 | 0.3509 | 1.00 | 12.00 | 0 |
| `classic_revolution_8x5` | RTLLM | 3 | 3 | 0.3509 | 1.00 | 12.00 | 0 |
| `deepgate_high_exploit_eoh_8x5` | ALL | 3 | 3 | 0.2326 | 1.33 | 6.67 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | 3 | 3 | 0.2326 | 1.33 | 6.67 | 2 |
| `masterrtl_archive_activation_eoh_8x5` | ALL | 3 | 3 | 0.3335 | 1.00 | 5.67 | 1 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | 3 | 3 | 0.3335 | 1.00 | 5.67 | 1 |
| `masterrtl_rf_leafid_structural_eoh_8x5` | ALL | 3 | 3 | 0.1716 | 1.33 | 4.00 | 0 |
| `masterrtl_rf_leafid_structural_eoh_8x5` | RTLLM | 3 | 3 | 0.1716 | 1.33 | 4.00 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | ALL | 3 | 3 | 0.3486 | 1.67 | 13.67 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | 3 | 3 | 0.3486 | 1.67 | 13.67 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | ALL | 3 | 0 | 0.0000 | 0.00 | 0.00 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | 3 | 0 | 0.0000 | 0.00 | 0.00 | 0 |
| `rf_deepgate_hybrid_eoh_8x5` | ALL | 3 | 3 | 0.1862 | 1.33 | 5.67 | 0 |
| `rf_deepgate_hybrid_eoh_8x5` | RTLLM | 3 | 3 | 0.1862 | 1.33 | 5.67 | 0 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob019_sub_64bit | 2 | 5 | 1 | 0.4499 | 2 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob019_sub_64bit | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_eoh_8x5` | RTLLM | Prob019_sub_64bit | 2 | 4 | 1 | 0.0207 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob019_sub_64bit | 2 | 6 | 1 | 0.4499 | 3 |
| `rf_deepgate_hybrid_eoh_8x5` | RTLLM | Prob019_sub_64bit | 2 | 7 | 1 | 0.0080 | 2 |
| `aurora_raw_impl_compact_eoh_8x5` | RTLLM | Prob019_sub_64bit | 2 | 4 | 1 | 0.4499 | 2 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob019_sub_64bit | 2 | 8 | 1 | 0.4499 | 3 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 9 | 1 | 0.4499 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.3559 | 2 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob036_edge_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_eoh_8x5` | RTLLM | Prob036_edge_detect | 3 | 3 | 1 | 0.3261 | 1 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob036_edge_detect | 3 | 2 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_eoh_8x5` | RTLLM | Prob036_edge_detect | 3 | 5 | 1 | 0.3559 | 1 |
| `aurora_raw_impl_compact_eoh_8x5` | RTLLM | Prob036_edge_detect | 3 | 3 | 2 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob036_edge_detect | 3 | 7 | 1 | 0.3559 | 4 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 5 | 1 | 0.3559 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 32 | 1 | 0.2470 | 32 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob045_alu | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_eoh_8x5` | RTLLM | Prob045_alu | 2 | 9 | 2 | 0.1679 | 9 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob045_alu | 2 | 17 | 2 | 0.2479 | 17 |
| `rf_deepgate_hybrid_eoh_8x5` | RTLLM | Prob045_alu | 2 | 14 | 2 | 0.1948 | 14 |
| `aurora_raw_impl_compact_eoh_8x5` | RTLLM | Prob045_alu | 2 | 14 | 2 | 0.1805 | 14 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob045_alu | 2 | 10 | 1 | 0.1947 | 10 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob045_alu | 2 | 35 | 3 | 0.2399 | 35 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob019_sub_64bit | [pairwise_fronts.png](problems/RTLLM/Prob019_sub_64bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob036_edge_detect | [pairwise_fronts.png](problems/RTLLM/Prob036_edge_detect/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob036_edge_detect/front_3d.png) |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
