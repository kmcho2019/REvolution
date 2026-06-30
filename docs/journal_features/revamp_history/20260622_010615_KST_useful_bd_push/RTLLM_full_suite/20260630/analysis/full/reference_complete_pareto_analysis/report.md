# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml`
- backend_count: `5`
- overall_multi_objective_winner: `pcn_v3_rf_stagnation_memory_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 46 | 33 | 0.0997 | 1.74 | 4.13 | 20 |
| `classic_revolution_8x5` | RTLLM | 46 | 33 | 0.0997 | 1.74 | 4.13 | 20 |
| `deepgate_high_exploit_eoh_8x5` | ALL | 46 | 25 | 0.0933 | 0.85 | 2.28 | 3 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | 46 | 25 | 0.0933 | 0.85 | 2.28 | 3 |
| `masterrtl_archive_activation_eoh_8x5` | ALL | 46 | 33 | 0.0914 | 1.24 | 1.91 | 1 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | 46 | 33 | 0.0914 | 1.24 | 1.91 | 1 |
| `pcn_v3_rf_stagnation_memory_8x5` | ALL | 46 | 33 | 0.1031 | 1.61 | 4.48 | 9 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | 46 | 33 | 0.1031 | 1.61 | 4.48 | 9 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | ALL | 46 | 31 | 0.0892 | 1.22 | 1.98 | 1 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | 46 | 31 | 0.0892 | 1.22 | 1.98 | 1 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob001_accu | 3 | 9 | 2 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob001_accu | 3 | 4 | 1 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob001_accu | 3 | 9 | 3 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob001_accu | 3 | 9 | 1 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob001_accu | 3 | 9 | 2 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob002_adder_16bit | 2 | 11 | 1 | 0.2051 | 2 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob002_adder_16bit | 2 | 6 | 1 | 0.2051 | 2 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob002_adder_16bit | 2 | 13 | 1 | 0.2051 | 2 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob002_adder_16bit | 2 | 6 | 1 | 0.2051 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob002_adder_16bit | 2 | 8 | 1 | 0.2051 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob003_adder_32bit | 2 | 23 | 1 | 0.6745 | 22 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob003_adder_32bit | 2 | 8 | 1 | 0.6745 | 8 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob003_adder_32bit | 2 | 20 | 1 | 0.6745 | 20 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob003_adder_32bit | 2 | 10 | 1 | 0.6745 | 10 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob003_adder_32bit | 2 | 14 | 1 | 0.6745 | 14 |
| `classic_revolution_8x5` | RTLLM | Prob004_adder_8bit | 2 | 6 | 1 | 0.1510 | 2 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob004_adder_8bit | 2 | 5 | 1 | 0.1510 | 2 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob004_adder_8bit | 2 | 6 | 1 | 0.1510 | 2 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob004_adder_8bit | 2 | 5 | 1 | 0.1510 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob004_adder_8bit | 2 | 6 | 1 | 0.1510 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob005_adder_bcd | 2 | 11 | 2 | 0.1100 | 6 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob005_adder_bcd | 2 | 9 | 1 | 0.1982 | 7 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob005_adder_bcd | 2 | 14 | 1 | 0.1982 | 8 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob005_adder_bcd | 2 | 8 | 1 | 0.1982 | 5 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob005_adder_bcd | 2 | 7 | 1 | 0.1982 | 6 |
| `classic_revolution_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 15 | 1 | 0.0583 | 3 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 6 | 1 | 0.0583 | 2 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 15 | 1 | 0.0583 | 3 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 9 | 1 | 0.0000 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 5 | 1 | 0.0583 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 15 | 1 | 0.3616 | 12 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 9 | 1 | 0.3312 | 9 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 17 | 1 | 0.3616 | 14 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 9 | 1 | 0.3008 | 6 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 8 | 1 | 0.3312 | 7 |
| `classic_revolution_8x5` | RTLLM | Prob009_div_16bit | 2 | 32 | 5 | 0.7166 | 32 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob009_div_16bit | 2 | 18 | 5 | 0.7203 | 18 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob009_div_16bit | 2 | 26 | 4 | 0.7138 | 26 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob009_div_16bit | 2 | 8 | 3 | 0.6955 | 8 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob009_div_16bit | 2 | 18 | 5 | 0.7131 | 18 |
| `classic_revolution_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob011_multi_16bit | 3 | 13 | 7 | 0.0021 | 2 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob011_multi_16bit | 3 | 6 | 3 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob011_multi_16bit | 3 | 17 | 5 | 0.0142 | 6 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob011_multi_16bit | 3 | 9 | 4 | 0.0110 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob011_multi_16bit | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob012_multi_8bit | 2 | 6 | 1 | 0.3866 | 4 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 3 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob012_multi_8bit | 2 | 4 | 1 | 0.3866 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 8 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 4 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 6 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 14 | 7 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 4 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob019_sub_64bit | 2 | 11 | 1 | 0.4499 | 5 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob019_sub_64bit | 2 | 3 | 1 | 0.0000 | 1 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 9 | 1 | 0.4499 | 3 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob019_sub_64bit | 2 | 4 | 1 | 0.4467 | 3 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob019_sub_64bit | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob020_JC_counter | 3 | 4 | 1 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob020_JC_counter | 3 | 3 | 1 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob020_JC_counter | 3 | 5 | 1 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob020_JC_counter | 3 | 4 | 2 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob020_JC_counter | 3 | 3 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob021_counter_12 | 3 | 8 | 4 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob021_counter_12 | 3 | 5 | 3 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob021_counter_12 | 3 | 10 | 5 | 0.0017 | 3 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob021_counter_12 | 3 | 5 | 2 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob021_counter_12 | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob023_up_down_counter | 3 | 3 | 2 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob023_up_down_counter | 3 | 4 | 2 | 0.0087 | 1 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 13 | 1 | 0.3406 | 7 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob024_fsm | 2 | 7 | 1 | 0.3406 | 3 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob024_fsm | 2 | 5 | 1 | 0.3406 | 3 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob024_fsm | 2 | 5 | 1 | 0.2716 | 5 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.3406 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob025_sequence_detector | 3 | 6 | 1 | 0.0434 | 4 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob025_sequence_detector | 3 | 3 | 1 | 0.0000 | 1 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob025_sequence_detector | 3 | 3 | 1 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob025_sequence_detector | 3 | 3 | 1 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob025_sequence_detector | 3 | 3 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 28 | 5 | 0.0142 | 12 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 16 | 4 | 0.0029 | 2 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 30 | 8 | 0.0101 | 12 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 11 | 3 | 0.0096 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 1 | 1 | 0.0171 | 1 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 1 | 1 | 0.0171 | 1 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob030_right_shifter | 3 | 2 | 1 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob030_right_shifter | 3 | 2 | 1 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob030_right_shifter | 3 | 2 | 1 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob031_freq_div | 2 | 1 | 1 | 0.0179 | 1 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob031_freq_div | 2 | 4 | 1 | 0.0471 | 3 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob031_freq_div | 2 | 7 | 1 | 0.0836 | 6 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob031_freq_div | 2 | 4 | 1 | 0.0836 | 3 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob031_freq_div | 2 | 6 | 1 | 0.1706 | 6 |
| `classic_revolution_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob035_calendar | 3 | 6 | 2 | 0.0000 | 1 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 1 | 0.0000 | 1 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 2 | 0.0000 | 1 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 2 | 0.0000 | 1 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob035_calendar | 3 | 4 | 2 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob036_edge_detect | 3 | 10 | 1 | 0.3559 | 5 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob036_edge_detect | 3 | 5 | 1 | 0.3559 | 2 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 6 | 1 | 0.3559 | 2 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob036_edge_detect | 3 | 5 | 1 | 0.3559 | 1 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob036_edge_detect | 3 | 3 | 2 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob037_parallel2serial | 3 | 5 | 3 | 0.0002 | 1 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob037_parallel2serial | 3 | 6 | 2 | 0.0002 | 2 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob037_parallel2serial | 3 | 4 | 1 | 0.0615 | 1 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob037_parallel2serial | 3 | 4 | 2 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob037_parallel2serial | 3 | 7 | 2 | 0.0003 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob038_pulse_detect | 3 | 1 | 1 | 0.0210 | 1 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob039_serial2parallel | 3 | 1 | 1 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob039_serial2parallel | 3 | 1 | 1 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob039_serial2parallel | 3 | 1 | 1 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 22 | 3 | 0.3627 | 19 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob041_traffic_light | 2 | 9 | 1 | 0.3501 | 5 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob041_traffic_light | 2 | 26 | 2 | 0.2924 | 24 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob041_traffic_light | 2 | 5 | 3 | 0.1215 | 4 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob041_traffic_light | 2 | 15 | 3 | 0.3360 | 15 |
| `classic_revolution_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob043_RAM | 3 | 8 | 4 | 0.0864 | 8 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob043_RAM | 3 | 6 | 3 | 0.0734 | 6 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob043_RAM | 3 | 16 | 6 | 0.0842 | 14 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob043_RAM | 3 | 5 | 1 | 0.0774 | 5 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob043_RAM | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob044_ROM | 2 | 4 | 2 | 0.0000 | 1 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob044_ROM | 2 | 2 | 2 | 0.0000 | 1 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob044_ROM | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 27 | 4 | 0.2072 | 27 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob045_alu | 2 | 9 | 3 | 0.1975 | 9 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob045_alu | 2 | 34 | 2 | 0.2465 | 34 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1774 | 9 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob045_alu | 2 | 15 | 1 | 0.2358 | 15 |
| `classic_revolution_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob047_instr_reg | 3 | 6 | 1 | 0.0047 | 1 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob047_instr_reg | 3 | 3 | 1 | 0.0000 | 0 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob047_instr_reg | 3 | 6 | 2 | 0.0000 | 1 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob047_instr_reg | 3 | 5 | 1 | 0.0000 | 0 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob047_instr_reg | 3 | 4 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob048_pe | 3 | 5 | 3 | 0.0000 | 1 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob048_pe | 3 | 5 | 3 | 0.0000 | 1 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob048_pe | 3 | 5 | 2 | 0.0000 | 1 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob048_pe | 3 | 9 | 2 | 0.0000 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob048_pe | 3 | 2 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 6 | 3 | 0.0181 | 4 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0123 | 2 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob049_signal_generator | 3 | 6 | 3 | 0.0170 | 5 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob049_signal_generator | 3 | 4 | 2 | 0.0146 | 2 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob049_signal_generator | 3 | 3 | 2 | 0.0068 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob050_square_wave | 3 | 27 | 5 | 0.0043 | 7 |
| `qwen_canonical_rtl_pca3_eoh_8x5` | RTLLM | Prob050_square_wave | 3 | 15 | 3 | 0.0000 | 1 |
| `pcn_v3_rf_stagnation_memory_8x5` | RTLLM | Prob050_square_wave | 3 | 31 | 3 | 0.0061 | 8 |
| `masterrtl_archive_activation_eoh_8x5` | RTLLM | Prob050_square_wave | 3 | 25 | 3 | 0.0067 | 10 |
| `deepgate_high_exploit_eoh_8x5` | RTLLM | Prob050_square_wave | 3 | 14 | 1 | 0.4828 | 4 |

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
