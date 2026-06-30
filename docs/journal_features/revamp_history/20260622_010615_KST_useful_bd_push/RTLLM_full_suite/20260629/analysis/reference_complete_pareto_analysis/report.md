# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260629/tables/rtllm_reference_complete_manifest.yaml`
- backend_count: `8`
- overall_multi_objective_winner: `classic_revolution_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `aurora_raw_impl_compact_delayed_8x5` | ALL | 46 | 31 | 0.0600 | 1.15 | 2.15 | 2 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | 46 | 31 | 0.0600 | 1.15 | 2.15 | 2 |
| `classic_revolution_8x5` | ALL | 46 | 33 | 0.1002 | 1.70 | 4.11 | 25 |
| `classic_revolution_8x5` | RTLLM | 46 | 33 | 0.1002 | 1.70 | 4.11 | 25 |
| `deepgate_delayed_high_exploit_8x5` | ALL | 46 | 27 | 0.0576 | 0.74 | 2.26 | 1 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | 46 | 27 | 0.0576 | 0.74 | 2.26 | 1 |
| `fg_qdm_rf_leafid_front_credit_8x5` | ALL | 46 | 30 | 0.0614 | 1.04 | 2.09 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | 46 | 30 | 0.0614 | 1.04 | 2.09 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | ALL | 46 | 31 | 0.0625 | 1.22 | 2.15 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | 46 | 31 | 0.0625 | 1.22 | 2.15 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | ALL | 46 | 31 | 0.0713 | 1.22 | 2.00 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | 46 | 31 | 0.0713 | 1.22 | 2.00 | 1 |
| `qwen_canonical_rtl_pca3_8x5` | ALL | 46 | 28 | 0.0432 | 1.11 | 1.57 | 1 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | 46 | 28 | 0.0432 | 1.11 | 1.57 | 1 |
| `rf_deepgate_hybrid_delayed_8x5` | ALL | 46 | 27 | 0.0735 | 0.83 | 1.52 | 2 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | 46 | 27 | 0.0735 | 0.83 | 1.52 | 2 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob001_accu | 3 | 12 | 2 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob001_accu | 3 | 3 | 1 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob001_accu | 3 | 6 | 1 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob001_accu | 3 | 4 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob001_accu | 3 | 7 | 1 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob001_accu | 3 | 5 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob001_accu | 3 | 6 | 1 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob001_accu | 3 | 6 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob002_adder_16bit | 2 | 12 | 1 | 0.2051 | 3 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob002_adder_16bit | 2 | 3 | 1 | 0.0646 | 2 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob002_adder_16bit | 2 | 3 | 1 | 0.2051 | 2 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob002_adder_16bit | 2 | 3 | 1 | 0.0646 | 2 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob002_adder_16bit | 2 | 4 | 1 | 0.2051 | 3 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob002_adder_16bit | 2 | 3 | 1 | 0.2051 | 2 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob002_adder_16bit | 2 | 3 | 1 | 0.2051 | 2 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob002_adder_16bit | 2 | 4 | 1 | 0.2051 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob003_adder_32bit | 2 | 19 | 1 | 0.6745 | 18 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob003_adder_32bit | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob003_adder_32bit | 2 | 4 | 1 | 0.6745 | 4 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob003_adder_32bit | 2 | 7 | 1 | 0.6745 | 7 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob003_adder_32bit | 2 | 3 | 1 | 0.6745 | 3 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob003_adder_32bit | 2 | 20 | 1 | 0.6745 | 20 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob003_adder_32bit | 2 | 4 | 1 | 0.6745 | 4 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob003_adder_32bit | 2 | 5 | 1 | 0.6745 | 5 |
| `classic_revolution_8x5` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob004_adder_8bit | 2 | 2 | 1 | 0.1510 | 2 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob005_adder_bcd | 2 | 13 | 1 | 0.1982 | 7 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob005_adder_bcd | 2 | 3 | 1 | 0.1982 | 2 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob005_adder_bcd | 2 | 4 | 1 | 0.1982 | 3 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob005_adder_bcd | 2 | 4 | 1 | 0.1982 | 3 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob005_adder_bcd | 2 | 6 | 1 | 0.1982 | 3 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob005_adder_bcd | 2 | 9 | 1 | 0.1982 | 5 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob005_adder_bcd | 2 | 4 | 1 | 0.1982 | 3 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob005_adder_bcd | 2 | 6 | 1 | 0.1982 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 15 | 1 | 0.0583 | 3 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 1 | 1 | 0.0000 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 1 | 1 | 0.0000 | 1 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 1 | 1 | 0.0000 | 1 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 3 | 1 | 0.0000 | 1 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 1 | 1 | 0.0000 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 1 | 1 | 0.0000 | 1 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 1 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 17 | 1 | 0.3616 | 14 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 6 | 1 | 0.3008 | 6 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 11 | 2 | 0.3310 | 11 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 4 | 1 | 0.3008 | 4 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 5 | 1 | 0.3309 | 5 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 6 | 1 | 0.3009 | 6 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 16 | 1 | 0.3312 | 16 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 13 | 1 | 0.3312 | 12 |
| `classic_revolution_8x5` | RTLLM | Prob009_div_16bit | 2 | 30 | 4 | 0.7129 | 30 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob009_div_16bit | 2 | 26 | 6 | 0.7071 | 26 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob009_div_16bit | 2 | 20 | 5 | 0.7132 | 20 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob009_div_16bit | 2 | 35 | 5 | 0.7212 | 35 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob009_div_16bit | 2 | 30 | 8 | 0.7098 | 30 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob009_div_16bit | 2 | 26 | 3 | 0.6187 | 26 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob009_div_16bit | 2 | 23 | 5 | 0.7123 | 23 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob009_div_16bit | 2 | 26 | 5 | 0.7156 | 26 |
| `classic_revolution_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob011_multi_16bit | 3 | 13 | 5 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob011_multi_16bit | 3 | 24 | 8 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob011_multi_16bit | 3 | 23 | 9 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob011_multi_16bit | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob011_multi_16bit | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob011_multi_16bit | 3 | 28 | 8 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob011_multi_16bit | 3 | 28 | 10 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob011_multi_16bit | 3 | 16 | 6 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob012_multi_8bit | 2 | 4 | 1 | 0.3866 | 3 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob012_multi_8bit | 2 | 2 | 1 | 0.0264 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob012_multi_8bit | 2 | 2 | 1 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob012_multi_8bit | 2 | 1 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob012_multi_8bit | 2 | 2 | 1 | 0.3531 | 1 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob012_multi_8bit | 2 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob012_multi_8bit | 2 | 1 | 1 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob012_multi_8bit | 2 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 21 | 9 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 8 | 1 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 4 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 5 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 6 | 1 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 4 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 4 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 7 | 4 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob019_sub_64bit | 2 | 13 | 1 | 0.4499 | 5 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob019_sub_64bit | 2 | 3 | 1 | 0.0000 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob019_sub_64bit | 2 | 4 | 1 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob019_sub_64bit | 2 | 3 | 1 | 0.0000 | 1 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob019_sub_64bit | 2 | 3 | 1 | 0.0000 | 1 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob019_sub_64bit | 2 | 3 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob019_sub_64bit | 2 | 3 | 1 | 0.0000 | 1 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob019_sub_64bit | 2 | 4 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob020_JC_counter | 3 | 5 | 1 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob020_JC_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob020_JC_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob020_JC_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob020_JC_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob020_JC_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob020_JC_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob020_JC_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob021_counter_12 | 3 | 7 | 4 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob021_counter_12 | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob021_counter_12 | 3 | 2 | 2 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob021_counter_12 | 3 | 1 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob021_counter_12 | 3 | 1 | 1 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob021_counter_12 | 3 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob021_counter_12 | 3 | 2 | 2 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob021_counter_12 | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob023_up_down_counter | 3 | 3 | 3 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 10 | 2 | 0.1457 | 6 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob024_fsm | 2 | 9 | 3 | 0.1458 | 6 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob024_fsm | 2 | 7 | 1 | 0.1074 | 4 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.1074 | 3 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob024_fsm | 2 | 9 | 2 | 0.1459 | 6 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob024_fsm | 2 | 5 | 2 | 0.1449 | 3 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1447 | 3 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1449 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob025_sequence_detector | 3 | 8 | 2 | 0.0434 | 1 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob025_sequence_detector | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob025_sequence_detector | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob025_sequence_detector | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob025_sequence_detector | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob025_sequence_detector | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob025_sequence_detector | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob025_sequence_detector | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 22 | 8 | 0.0060 | 5 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 10 | 4 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 13 | 5 | 0.0000 | 1 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 13 | 4 | 0.0065 | 2 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 15 | 3 | 0.0064 | 3 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 8 | 2 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob030_right_shifter | 3 | 3 | 1 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob031_freq_div | 2 | 6 | 1 | 0.0836 | 5 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob031_freq_div | 2 | 1 | 1 | 0.0179 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob031_freq_div | 2 | 2 | 1 | 0.0179 | 2 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob031_freq_div | 2 | 2 | 1 | 0.0179 | 2 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob031_freq_div | 2 | 2 | 1 | 0.0179 | 2 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob031_freq_div | 2 | 2 | 1 | 0.0179 | 2 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob031_freq_div | 2 | 2 | 1 | 0.0179 | 2 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob031_freq_div | 2 | 2 | 1 | 0.0179 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob035_calendar | 3 | 4 | 2 | 0.0000 | 1 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 1 | 0.0000 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 1 | 0.0000 | 1 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 1 | 0.0000 | 1 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 1 | 0.0000 | 1 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob035_calendar | 3 | 4 | 2 | 0.0000 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 1 | 0.0000 | 1 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.3559 | 4 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob036_edge_detect | 3 | 2 | 1 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob036_edge_detect | 3 | 3 | 1 | 0.3559 | 1 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob036_edge_detect | 3 | 2 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob036_edge_detect | 3 | 2 | 1 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob036_edge_detect | 3 | 2 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob036_edge_detect | 3 | 2 | 1 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob036_edge_detect | 3 | 2 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob037_parallel2serial | 3 | 11 | 1 | 0.1047 | 3 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob037_parallel2serial | 3 | 2 | 2 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob037_parallel2serial | 3 | 1 | 1 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob037_parallel2serial | 3 | 4 | 1 | 0.0006 | 1 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob037_parallel2serial | 3 | 2 | 2 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0119 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob037_parallel2serial | 3 | 2 | 1 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob037_parallel2serial | 3 | 7 | 2 | 0.0041 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob038_pulse_detect | 3 | 1 | 1 | 0.0210 | 1 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob038_pulse_detect | 3 | 1 | 1 | 0.3640 | 1 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob039_serial2parallel | 3 | 2 | 1 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob039_serial2parallel | 3 | 1 | 1 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob039_serial2parallel | 3 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob039_serial2parallel | 3 | 1 | 1 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 29 | 3 | 0.2987 | 26 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob041_traffic_light | 2 | 11 | 2 | 0.2097 | 6 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob041_traffic_light | 2 | 12 | 2 | 0.2213 | 9 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob041_traffic_light | 2 | 18 | 1 | 0.2043 | 12 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob041_traffic_light | 2 | 13 | 2 | 0.2214 | 7 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob041_traffic_light | 2 | 15 | 3 | 0.2330 | 13 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob041_traffic_light | 2 | 16 | 3 | 0.2152 | 14 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob041_traffic_light | 2 | 19 | 1 | 0.1983 | 15 |
| `classic_revolution_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob043_RAM | 3 | 9 | 4 | 0.0972 | 9 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob043_RAM | 3 | 1 | 1 | 0.0037 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob043_RAM | 3 | 1 | 1 | 0.0037 | 1 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob043_RAM | 3 | 1 | 1 | 0.0037 | 1 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob043_RAM | 3 | 1 | 1 | 0.0037 | 1 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob043_RAM | 3 | 1 | 1 | 0.0037 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob043_RAM | 3 | 1 | 1 | 0.0037 | 1 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob043_RAM | 3 | 1 | 1 | 0.0037 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob044_ROM | 2 | 2 | 2 | 0.0000 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob044_ROM | 2 | 2 | 2 | 0.0000 | 1 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob044_ROM | 2 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob044_ROM | 2 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob044_ROM | 2 | 2 | 2 | 0.0000 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob044_ROM | 2 | 2 | 2 | 0.0000 | 1 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob044_ROM | 2 | 2 | 2 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 27 | 2 | 0.2318 | 27 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob045_alu | 2 | 11 | 2 | 0.1568 | 11 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob045_alu | 2 | 24 | 1 | 0.2867 | 24 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob045_alu | 2 | 23 | 2 | 0.1930 | 23 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob045_alu | 2 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob045_alu | 2 | 11 | 1 | 0.1871 | 11 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob045_alu | 2 | 18 | 1 | 0.2058 | 18 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob045_alu | 2 | 12 | 2 | 0.1729 | 12 |
| `classic_revolution_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob047_instr_reg | 3 | 5 | 2 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob047_instr_reg | 3 | 4 | 1 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob047_instr_reg | 3 | 4 | 1 | 0.0000 | 0 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob047_instr_reg | 3 | 2 | 1 | 0.0000 | 0 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob047_instr_reg | 3 | 3 | 1 | 0.0000 | 0 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob047_instr_reg | 3 | 3 | 1 | 0.0000 | 0 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob047_instr_reg | 3 | 3 | 1 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob047_instr_reg | 3 | 3 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob048_pe | 3 | 3 | 2 | 0.0000 | 1 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob048_pe | 3 | 4 | 2 | 0.0000 | 2 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob048_pe | 3 | 4 | 2 | 0.0000 | 2 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob048_pe | 3 | 2 | 1 | 0.0000 | 1 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob048_pe | 3 | 2 | 1 | 0.0000 | 1 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob048_pe | 3 | 3 | 2 | 0.0000 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob048_pe | 3 | 5 | 2 | 0.0000 | 2 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob048_pe | 3 | 2 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0192 | 4 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob049_signal_generator | 3 | 2 | 1 | 0.0123 | 2 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob049_signal_generator | 3 | 4 | 2 | 0.0147 | 4 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob050_square_wave | 3 | 31 | 5 | 0.0043 | 10 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob050_square_wave | 3 | 10 | 2 | 0.0000 | 2 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob050_square_wave | 3 | 7 | 2 | 0.0000 | 1 |
| `deepgate_delayed_high_exploit_8x5` | RTLLM | Prob050_square_wave | 3 | 9 | 2 | 0.0000 | 2 |
| `rf_deepgate_hybrid_delayed_8x5` | RTLLM | Prob050_square_wave | 3 | 8 | 2 | 0.0000 | 2 |
| `aurora_raw_impl_compact_delayed_8x5` | RTLLM | Prob050_square_wave | 3 | 5 | 2 | 0.0000 | 1 |
| `masterrtl_delayed_archive_activation_8x5` | RTLLM | Prob050_square_wave | 3 | 10 | 2 | 0.0000 | 2 |
| `fg_qdm_rf_leafid_front_credit_8x5` | RTLLM | Prob050_square_wave | 3 | 10 | 2 | 0.0000 | 2 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob001_accu | [pairwise_fronts.png](problems/RTLLM/Prob001_accu/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob001_accu/front_3d.png) |
| RTLLM | Prob002_adder_16bit | [pairwise_fronts.png](problems/RTLLM/Prob002_adder_16bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob003_adder_32bit | [pairwise_fronts.png](problems/RTLLM/Prob003_adder_32bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob004_adder_8bit | [pairwise_fronts.png](problems/RTLLM/Prob004_adder_8bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob005_adder_bcd | [pairwise_fronts.png](problems/RTLLM/Prob005_adder_bcd/pairwise_fronts.png) | n/a |
| RTLLM | Prob007_comparator_3bit | [pairwise_fronts.png](problems/RTLLM/Prob007_comparator_3bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob008_comparator_4bit | [pairwise_fronts.png](problems/RTLLM/Prob008_comparator_4bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob009_div_16bit | [pairwise_fronts.png](problems/RTLLM/Prob009_div_16bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob010_radix2_div | [pairwise_fronts.png](problems/RTLLM/Prob010_radix2_div/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob010_radix2_div/front_3d.png) |
| RTLLM | Prob011_multi_16bit | [pairwise_fronts.png](problems/RTLLM/Prob011_multi_16bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob011_multi_16bit/front_3d.png) |
| RTLLM | Prob012_multi_8bit | [pairwise_fronts.png](problems/RTLLM/Prob012_multi_8bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob014_multi_pipe_4bit | [pairwise_fronts.png](problems/RTLLM/Prob014_multi_pipe_4bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob014_multi_pipe_4bit/front_3d.png) |
| RTLLM | Prob015_multi_pipe_8bit | [pairwise_fronts.png](problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png) |
| RTLLM | Prob016_fixed_point_adder | [pairwise_fronts.png](problems/RTLLM/Prob016_fixed_point_adder/pairwise_fronts.png) | n/a |
| RTLLM | Prob017_fixed_point_substractor | [pairwise_fronts.png](problems/RTLLM/Prob017_fixed_point_substractor/pairwise_fronts.png) | n/a |
| RTLLM | Prob019_sub_64bit | [pairwise_fronts.png](problems/RTLLM/Prob019_sub_64bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob020_JC_counter | [pairwise_fronts.png](problems/RTLLM/Prob020_JC_counter/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob020_JC_counter/front_3d.png) |
| RTLLM | Prob021_counter_12 | [pairwise_fronts.png](problems/RTLLM/Prob021_counter_12/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob021_counter_12/front_3d.png) |
| RTLLM | Prob022_ring_counter | [pairwise_fronts.png](problems/RTLLM/Prob022_ring_counter/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob022_ring_counter/front_3d.png) |
| RTLLM | Prob023_up_down_counter | [pairwise_fronts.png](problems/RTLLM/Prob023_up_down_counter/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob023_up_down_counter/front_3d.png) |
| RTLLM | Prob024_fsm | [pairwise_fronts.png](problems/RTLLM/Prob024_fsm/pairwise_fronts.png) | n/a |
| RTLLM | Prob025_sequence_detector | [pairwise_fronts.png](problems/RTLLM/Prob025_sequence_detector/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob025_sequence_detector/front_3d.png) |
| RTLLM | Prob026_asyn_fifo | [pairwise_fronts.png](problems/RTLLM/Prob026_asyn_fifo/pairwise_fronts.png) | n/a |
| RTLLM | Prob027_LIFObuffer | [pairwise_fronts.png](problems/RTLLM/Prob027_LIFObuffer/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob027_LIFObuffer/front_3d.png) |
| RTLLM | Prob028_LFSR | [pairwise_fronts.png](problems/RTLLM/Prob028_LFSR/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob028_LFSR/front_3d.png) |
| RTLLM | Prob029_barrel_shifter | [pairwise_fronts.png](problems/RTLLM/Prob029_barrel_shifter/pairwise_fronts.png) | n/a |
| RTLLM | Prob030_right_shifter | [pairwise_fronts.png](problems/RTLLM/Prob030_right_shifter/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob030_right_shifter/front_3d.png) |
| RTLLM | Prob031_freq_div | [pairwise_fronts.png](problems/RTLLM/Prob031_freq_div/pairwise_fronts.png) | n/a |
| RTLLM | Prob032_freq_divbyeven | [pairwise_fronts.png](problems/RTLLM/Prob032_freq_divbyeven/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob032_freq_divbyeven/front_3d.png) |
| RTLLM | Prob033_freq_divbyfrac | [pairwise_fronts.png](problems/RTLLM/Prob033_freq_divbyfrac/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob033_freq_divbyfrac/front_3d.png) |
| RTLLM | Prob034_freq_divbyodd | [pairwise_fronts.png](problems/RTLLM/Prob034_freq_divbyodd/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob034_freq_divbyodd/front_3d.png) |
| RTLLM | Prob035_calendar | [pairwise_fronts.png](problems/RTLLM/Prob035_calendar/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob035_calendar/front_3d.png) |
| RTLLM | Prob036_edge_detect | [pairwise_fronts.png](problems/RTLLM/Prob036_edge_detect/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob036_edge_detect/front_3d.png) |
| RTLLM | Prob037_parallel2serial | [pairwise_fronts.png](problems/RTLLM/Prob037_parallel2serial/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob037_parallel2serial/front_3d.png) |
| RTLLM | Prob038_pulse_detect | [pairwise_fronts.png](problems/RTLLM/Prob038_pulse_detect/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob038_pulse_detect/front_3d.png) |
| RTLLM | Prob039_serial2parallel | [pairwise_fronts.png](problems/RTLLM/Prob039_serial2parallel/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob039_serial2parallel/front_3d.png) |
| RTLLM | Prob041_traffic_light | [pairwise_fronts.png](problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png) | n/a |
| RTLLM | Prob042_width_8to16 | [pairwise_fronts.png](problems/RTLLM/Prob042_width_8to16/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob042_width_8to16/front_3d.png) |
| RTLLM | Prob043_RAM | [pairwise_fronts.png](problems/RTLLM/Prob043_RAM/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob043_RAM/front_3d.png) |
| RTLLM | Prob044_ROM | [pairwise_fronts.png](problems/RTLLM/Prob044_ROM/pairwise_fronts.png) | n/a |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
| RTLLM | Prob046_clkgenerator | [pairwise_fronts.png](problems/RTLLM/Prob046_clkgenerator/pairwise_fronts.png) | n/a |
| RTLLM | Prob047_instr_reg | [pairwise_fronts.png](problems/RTLLM/Prob047_instr_reg/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob047_instr_reg/front_3d.png) |
| RTLLM | Prob048_pe | [pairwise_fronts.png](problems/RTLLM/Prob048_pe/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob048_pe/front_3d.png) |
| RTLLM | Prob049_signal_generator | [pairwise_fronts.png](problems/RTLLM/Prob049_signal_generator/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob049_signal_generator/front_3d.png) |
| RTLLM | Prob050_square_wave | [pairwise_fronts.png](problems/RTLLM/Prob050_square_wave/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob050_square_wave/front_3d.png) |
