# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/tables/rtllm_reference_complete_manifest.yaml`
- backend_count: `4`
- overall_multi_objective_winner: `classic_no_cf_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_no_cf_8x5` | ALL | 46 | 32 | 0.1218 | 1.63 | 4.30 | 12 |
| `classic_no_cf_8x5` | RTLLM | 46 | 32 | 0.1218 | 1.63 | 4.30 | 12 |
| `classic_revolution_8x5` | ALL | 46 | 33 | 0.1044 | 1.59 | 3.93 | 12 |
| `classic_revolution_8x5` | RTLLM | 46 | 33 | 0.1044 | 1.59 | 3.93 | 12 |
| `pcn_v3_cf_restored_memory_8x5` | ALL | 46 | 33 | 0.1007 | 1.48 | 4.07 | 6 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | 46 | 33 | 0.1007 | 1.48 | 4.07 | 6 |
| `pcn_v3_no_cf_memory_8x5` | ALL | 46 | 34 | 0.1001 | 1.65 | 4.07 | 5 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | 46 | 34 | 0.1001 | 1.65 | 4.07 | 5 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob001_accu | 3 | 13 | 4 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob001_accu | 3 | 14 | 4 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob001_accu | 3 | 10 | 3 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob001_accu | 3 | 9 | 2 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob002_adder_16bit | 2 | 12 | 1 | 0.2051 | 5 |
| `classic_no_cf_8x5` | RTLLM | Prob002_adder_16bit | 2 | 11 | 1 | 0.2051 | 2 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob002_adder_16bit | 2 | 8 | 1 | 0.0646 | 2 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob002_adder_16bit | 2 | 12 | 1 | 0.2051 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob003_adder_32bit | 2 | 18 | 1 | 0.6745 | 18 |
| `classic_no_cf_8x5` | RTLLM | Prob003_adder_32bit | 2 | 21 | 1 | 0.6745 | 20 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob003_adder_32bit | 2 | 17 | 1 | 0.6745 | 16 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob003_adder_32bit | 2 | 27 | 1 | 0.6745 | 26 |
| `classic_revolution_8x5` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 |
| `classic_no_cf_8x5` | RTLLM | Prob004_adder_8bit | 2 | 8 | 1 | 0.1510 | 2 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob004_adder_8bit | 2 | 5 | 1 | 0.1510 | 2 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob004_adder_8bit | 2 | 5 | 1 | 0.1510 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob005_adder_bcd | 2 | 12 | 2 | 0.1983 | 8 |
| `classic_no_cf_8x5` | RTLLM | Prob005_adder_bcd | 2 | 13 | 1 | 0.1982 | 8 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob005_adder_bcd | 2 | 12 | 1 | 0.1982 | 8 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob005_adder_bcd | 2 | 10 | 1 | 0.1982 | 7 |
| `classic_revolution_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 16 | 1 | 0.0583 | 3 |
| `classic_no_cf_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 14 | 1 | 0.0583 | 4 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 14 | 1 | 0.0583 | 3 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 13 | 1 | 0.0583 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 19 | 1 | 0.3616 | 17 |
| `classic_no_cf_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 18 | 1 | 0.3315 | 14 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 20 | 1 | 0.3616 | 16 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 18 | 1 | 0.3616 | 15 |
| `classic_revolution_8x5` | RTLLM | Prob009_div_16bit | 2 | 20 | 2 | 0.7140 | 20 |
| `classic_no_cf_8x5` | RTLLM | Prob009_div_16bit | 2 | 27 | 6 | 0.7176 | 27 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob009_div_16bit | 2 | 24 | 4 | 0.7086 | 24 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob009_div_16bit | 2 | 30 | 7 | 0.7113 | 30 |
| `classic_revolution_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob010_radix2_div | 3 | 1 | 1 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob010_radix2_div | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob011_multi_16bit | 3 | 11 | 5 | 0.0033 | 4 |
| `classic_no_cf_8x5` | RTLLM | Prob011_multi_16bit | 3 | 16 | 6 | 0.0009 | 1 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob011_multi_16bit | 3 | 13 | 5 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob011_multi_16bit | 3 | 13 | 2 | 0.0072 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 |
| `classic_no_cf_8x5` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob012_multi_8bit | 2 | 6 | 1 | 0.3866 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 12 | 7 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 16 | 8 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 4 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 4 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob019_sub_64bit | 2 | 11 | 1 | 0.4499 | 3 |
| `classic_no_cf_8x5` | RTLLM | Prob019_sub_64bit | 2 | 9 | 1 | 0.4499 | 4 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 9 | 1 | 0.4499 | 2 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob019_sub_64bit | 2 | 11 | 1 | 0.4499 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob020_JC_counter | 3 | 4 | 1 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob020_JC_counter | 3 | 5 | 2 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob020_JC_counter | 3 | 4 | 1 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob020_JC_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob021_counter_12 | 3 | 9 | 4 | 0.0010 | 1 |
| `classic_no_cf_8x5` | RTLLM | Prob021_counter_12 | 3 | 11 | 3 | 0.0000 | 1 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob021_counter_12 | 3 | 6 | 3 | 0.0000 | 1 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob021_counter_12 | 3 | 2 | 2 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob023_up_down_counter | 3 | 2 | 2 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob023_up_down_counter | 3 | 3 | 2 | 0.0096 | 1 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob023_up_down_counter | 3 | 2 | 2 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob023_up_down_counter | 3 | 3 | 2 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.3406 | 6 |
| `classic_no_cf_8x5` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.2652 | 5 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.3406 | 5 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob024_fsm | 2 | 5 | 1 | 0.2514 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob025_sequence_detector | 3 | 7 | 1 | 0.0434 | 1 |
| `classic_no_cf_8x5` | RTLLM | Prob025_sequence_detector | 3 | 5 | 2 | 0.0434 | 1 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob025_sequence_detector | 3 | 5 | 2 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob025_sequence_detector | 3 | 1 | 1 | 0.0141 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 31 | 9 | 0.0086 | 7 |
| `classic_no_cf_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 25 | 7 | 0.0100 | 10 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 31 | 7 | 0.0109 | 13 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 26 | 8 | 0.0066 | 7 |
| `classic_revolution_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 2 | 2 | 0.0341 | 2 |
| `classic_no_cf_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 1 | 1 | 0.0854 | 1 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob030_right_shifter | 3 | 2 | 1 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob030_right_shifter | 3 | 3 | 1 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob031_freq_div | 2 | 4 | 1 | 0.0905 | 3 |
| `classic_no_cf_8x5` | RTLLM | Prob031_freq_div | 2 | 8 | 1 | 0.0836 | 8 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob031_freq_div | 2 | 4 | 1 | 0.0836 | 4 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob031_freq_div | 2 | 1 | 1 | 0.0179 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob035_calendar | 3 | 2 | 1 | 0.0000 | 1 |
| `classic_no_cf_8x5` | RTLLM | Prob035_calendar | 3 | 5 | 2 | 0.0000 | 1 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob035_calendar | 3 | 5 | 2 | 0.0000 | 1 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob035_calendar | 3 | 3 | 2 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob036_edge_detect | 3 | 6 | 1 | 0.3559 | 1 |
| `classic_no_cf_8x5` | RTLLM | Prob036_edge_detect | 3 | 7 | 1 | 0.3559 | 2 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 7 | 1 | 0.3559 | 3 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.3559 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob037_parallel2serial | 3 | 8 | 1 | 0.0002 | 1 |
| `classic_no_cf_8x5` | RTLLM | Prob037_parallel2serial | 3 | 6 | 2 | 0.0002 | 1 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob037_parallel2serial | 3 | 5 | 3 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob037_parallel2serial | 3 | 7 | 2 | 0.0002 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob038_pulse_detect | 3 | 4 | 2 | 0.0210 | 1 |
| `classic_no_cf_8x5` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob038_pulse_detect | 3 | 1 | 1 | 0.0210 | 1 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob038_pulse_detect | 3 | 1 | 1 | 0.0210 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob039_serial2parallel | 3 | 2 | 1 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 21 | 3 | 0.3541 | 20 |
| `classic_no_cf_8x5` | RTLLM | Prob041_traffic_light | 2 | 22 | 1 | 0.3674 | 20 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob041_traffic_light | 2 | 27 | 2 | 0.3102 | 24 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob041_traffic_light | 2 | 20 | 4 | 0.4167 | 17 |
| `classic_revolution_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob043_RAM | 3 | 12 | 2 | 0.0888 | 12 |
| `classic_no_cf_8x5` | RTLLM | Prob043_RAM | 3 | 7 | 3 | 0.0714 | 7 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob043_RAM | 3 | 12 | 5 | 0.0913 | 12 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob043_RAM | 3 | 8 | 4 | 0.0839 | 8 |
| `classic_revolution_8x5` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `classic_no_cf_8x5` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 27 | 1 | 0.2416 | 27 |
| `classic_no_cf_8x5` | RTLLM | Prob045_alu | 2 | 37 | 2 | 0.2113 | 37 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob045_alu | 2 | 36 | 2 | 0.2421 | 36 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob045_alu | 2 | 38 | 1 | 0.2439 | 38 |
| `classic_revolution_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob047_instr_reg | 3 | 6 | 1 | 0.0000 | 0 |
| `classic_no_cf_8x5` | RTLLM | Prob047_instr_reg | 3 | 4 | 1 | 0.0000 | 0 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob047_instr_reg | 3 | 5 | 1 | 0.0000 | 0 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob047_instr_reg | 3 | 7 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob048_pe | 3 | 10 | 2 | 0.0000 | 2 |
| `classic_no_cf_8x5` | RTLLM | Prob048_pe | 3 | 7 | 4 | 0.0000 | 1 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob048_pe | 3 | 5 | 3 | 0.0000 | 1 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob048_pe | 3 | 3 | 2 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 4 | 2 | 0.0186 | 3 |
| `classic_no_cf_8x5` | RTLLM | Prob049_signal_generator | 3 | 6 | 4 | 0.0193 | 4 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0116 | 4 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob049_signal_generator | 3 | 4 | 2 | 0.0146 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob050_square_wave | 3 | 27 | 6 | 0.0014 | 8 |
| `classic_no_cf_8x5` | RTLLM | Prob050_square_wave | 3 | 28 | 1 | 0.9916 | 12 |
| `pcn_v3_no_cf_memory_8x5` | RTLLM | Prob050_square_wave | 3 | 25 | 8 | 0.0009 | 3 |
| `pcn_v3_cf_restored_memory_8x5` | RTLLM | Prob050_square_wave | 3 | 21 | 5 | 0.0014 | 6 |

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
