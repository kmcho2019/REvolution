# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml`
- backend_count: `3`
- overall_multi_objective_winner: `classic_revolution_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 46 | 33 | 0.1114 | 1.52 | 3.85 | 18 |
| `classic_revolution_8x5` | RTLLM | 46 | 33 | 0.1114 | 1.52 | 3.85 | 18 |
| `s01_capacity7` | ALL | 46 | 34 | 0.0896 | 1.39 | 3.13 | 9 |
| `s01_capacity7` | RTLLM | 46 | 34 | 0.0896 | 1.39 | 3.13 | 9 |
| `smooth_qd_v2_8x5` | ALL | 46 | 32 | 0.0968 | 1.37 | 3.83 | 7 |
| `smooth_qd_v2_8x5` | RTLLM | 46 | 32 | 0.0968 | 1.37 | 3.83 | 7 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob001_accu | 3 | 12 | 1 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob001_accu | 3 | 16 | 1 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob001_accu | 3 | 10 | 2 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob002_adder_16bit | 2 | 14 | 1 | 0.0646 | 1 |
| `smooth_qd_v2_8x5` | RTLLM | Prob002_adder_16bit | 2 | 8 | 1 | 0.0646 | 2 |
| `s01_capacity7` | RTLLM | Prob002_adder_16bit | 2 | 12 | 1 | 0.2051 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob003_adder_32bit | 2 | 12 | 1 | 0.6745 | 11 |
| `smooth_qd_v2_8x5` | RTLLM | Prob003_adder_32bit | 2 | 19 | 1 | 0.6745 | 19 |
| `s01_capacity7` | RTLLM | Prob003_adder_32bit | 2 | 23 | 1 | 0.6745 | 23 |
| `classic_revolution_8x5` | RTLLM | Prob004_adder_8bit | 2 | 8 | 1 | 0.1510 | 2 |
| `smooth_qd_v2_8x5` | RTLLM | Prob004_adder_8bit | 2 | 6 | 1 | 0.1510 | 3 |
| `s01_capacity7` | RTLLM | Prob004_adder_8bit | 2 | 6 | 1 | 0.1510 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob005_adder_bcd | 2 | 13 | 1 | 0.1982 | 7 |
| `smooth_qd_v2_8x5` | RTLLM | Prob005_adder_bcd | 2 | 11 | 1 | 0.1982 | 8 |
| `s01_capacity7` | RTLLM | Prob005_adder_bcd | 2 | 11 | 1 | 0.1321 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 14 | 1 | 0.0583 | 3 |
| `smooth_qd_v2_8x5` | RTLLM | Prob007_comparator_3bit | 2 | 10 | 1 | 0.0583 | 2 |
| `s01_capacity7` | RTLLM | Prob007_comparator_3bit | 2 | 11 | 1 | 0.0000 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 16 | 1 | 0.3312 | 11 |
| `smooth_qd_v2_8x5` | RTLLM | Prob008_comparator_4bit | 2 | 21 | 1 | 0.3315 | 16 |
| `s01_capacity7` | RTLLM | Prob008_comparator_4bit | 2 | 16 | 1 | 0.3616 | 15 |
| `classic_revolution_8x5` | RTLLM | Prob009_div_16bit | 2 | 25 | 3 | 0.7102 | 25 |
| `smooth_qd_v2_8x5` | RTLLM | Prob009_div_16bit | 2 | 20 | 3 | 0.7199 | 20 |
| `s01_capacity7` | RTLLM | Prob009_div_16bit | 2 | 23 | 5 | 0.7206 | 23 |
| `classic_revolution_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob011_multi_16bit | 3 | 15 | 4 | 0.0086 | 3 |
| `smooth_qd_v2_8x5` | RTLLM | Prob011_multi_16bit | 3 | 21 | 7 | 0.0299 | 11 |
| `s01_capacity7` | RTLLM | Prob011_multi_16bit | 3 | 18 | 5 | 0.0005 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob012_multi_8bit | 2 | 4 | 1 | 0.3866 | 3 |
| `smooth_qd_v2_8x5` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 |
| `s01_capacity7` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 20 | 6 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 5 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 3 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob019_sub_64bit | 2 | 9 | 1 | 0.4500 | 5 |
| `smooth_qd_v2_8x5` | RTLLM | Prob019_sub_64bit | 2 | 4 | 1 | 0.3628 | 2 |
| `s01_capacity7` | RTLLM | Prob019_sub_64bit | 2 | 4 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob020_JC_counter | 3 | 3 | 1 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob020_JC_counter | 3 | 4 | 1 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob020_JC_counter | 3 | 5 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob021_counter_12 | 3 | 6 | 5 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob021_counter_12 | 3 | 8 | 4 | 0.0010 | 2 |
| `s01_capacity7` | RTLLM | Prob021_counter_12 | 3 | 7 | 2 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob023_up_down_counter | 3 | 3 | 2 | 0.0098 | 2 |
| `smooth_qd_v2_8x5` | RTLLM | Prob023_up_down_counter | 3 | 2 | 2 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 7 | 1 | 0.3406 | 5 |
| `smooth_qd_v2_8x5` | RTLLM | Prob024_fsm | 2 | 11 | 1 | 0.3406 | 8 |
| `s01_capacity7` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.3406 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob025_sequence_detector | 3 | 5 | 1 | 0.0434 | 2 |
| `smooth_qd_v2_8x5` | RTLLM | Prob025_sequence_detector | 3 | 8 | 3 | 0.0141 | 2 |
| `s01_capacity7` | RTLLM | Prob025_sequence_detector | 3 | 4 | 1 | 0.0434 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 31 | 4 | 0.0160 | 14 |
| `smooth_qd_v2_8x5` | RTLLM | Prob027_LIFObuffer | 3 | 28 | 3 | 0.0087 | 6 |
| `s01_capacity7` | RTLLM | Prob027_LIFObuffer | 3 | 24 | 6 | 0.0066 | 5 |
| `classic_revolution_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob029_barrel_shifter | 2 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob030_right_shifter | 3 | 2 | 1 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob030_right_shifter | 3 | 2 | 1 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob030_right_shifter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob031_freq_div | 2 | 5 | 1 | 0.0836 | 5 |
| `smooth_qd_v2_8x5` | RTLLM | Prob031_freq_div | 2 | 5 | 1 | 0.0836 | 5 |
| `s01_capacity7` | RTLLM | Prob031_freq_div | 2 | 2 | 1 | 0.0644 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob035_calendar | 3 | 10 | 3 | 0.0001 | 2 |
| `smooth_qd_v2_8x5` | RTLLM | Prob035_calendar | 3 | 5 | 2 | 0.0000 | 1 |
| `s01_capacity7` | RTLLM | Prob035_calendar | 3 | 4 | 2 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.8947 | 4 |
| `smooth_qd_v2_8x5` | RTLLM | Prob036_edge_detect | 3 | 9 | 1 | 0.3559 | 4 |
| `s01_capacity7` | RTLLM | Prob036_edge_detect | 3 | 6 | 1 | 0.3559 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob037_parallel2serial | 3 | 4 | 1 | 0.0002 | 2 |
| `smooth_qd_v2_8x5` | RTLLM | Prob037_parallel2serial | 3 | 8 | 1 | 0.0003 | 2 |
| `s01_capacity7` | RTLLM | Prob037_parallel2serial | 3 | 7 | 1 | 0.0003 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob038_pulse_detect | 3 | 1 | 1 | 0.0210 | 1 |
| `smooth_qd_v2_8x5` | RTLLM | Prob038_pulse_detect | 3 | 1 | 1 | 0.0210 | 1 |
| `s01_capacity7` | RTLLM | Prob038_pulse_detect | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob039_serial2parallel | 3 | 1 | 1 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob039_serial2parallel | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 12 | 3 | 0.3365 | 11 |
| `smooth_qd_v2_8x5` | RTLLM | Prob041_traffic_light | 2 | 21 | 2 | 0.3612 | 15 |
| `s01_capacity7` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3618 | 12 |
| `classic_revolution_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob043_RAM | 3 | 12 | 5 | 0.0912 | 11 |
| `smooth_qd_v2_8x5` | RTLLM | Prob043_RAM | 3 | 13 | 1 | 0.0775 | 11 |
| `s01_capacity7` | RTLLM | Prob043_RAM | 3 | 9 | 2 | 0.0888 | 9 |
| `classic_revolution_8x5` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `smooth_qd_v2_8x5` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `s01_capacity7` | RTLLM | Prob044_ROM | 2 | 4 | 2 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 35 | 3 | 0.2332 | 35 |
| `smooth_qd_v2_8x5` | RTLLM | Prob045_alu | 2 | 21 | 2 | 0.1912 | 21 |
| `s01_capacity7` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.2109 | 9 |
| `classic_revolution_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob047_instr_reg | 3 | 5 | 3 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob047_instr_reg | 3 | 6 | 1 | 0.0000 | 0 |
| `s01_capacity7` | RTLLM | Prob047_instr_reg | 3 | 7 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob048_pe | 3 | 4 | 3 | 0.0000 | 1 |
| `smooth_qd_v2_8x5` | RTLLM | Prob048_pe | 3 | 5 | 2 | 0.0000 | 1 |
| `s01_capacity7` | RTLLM | Prob048_pe | 3 | 5 | 3 | 0.0000 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 7 | 3 | 0.0170 | 3 |
| `smooth_qd_v2_8x5` | RTLLM | Prob049_signal_generator | 3 | 4 | 3 | 0.0170 | 3 |
| `s01_capacity7` | RTLLM | Prob049_signal_generator | 3 | 7 | 4 | 0.0116 | 3 |
| `classic_revolution_8x5` | RTLLM | Prob050_square_wave | 3 | 28 | 3 | 0.0040 | 7 |
| `smooth_qd_v2_8x5` | RTLLM | Prob050_square_wave | 3 | 21 | 5 | 0.0019 | 6 |
| `s01_capacity7` | RTLLM | Prob050_square_wave | 3 | 25 | 5 | 0.0056 | 8 |

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
