# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/rtllm_reference_complete_subset.yaml`
- backend_count: `2`
- overall_multi_objective_winner: `classic_revolution`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | ALL | 46 | 31 | 0.1026 | 1.33 | 3.96 | 27 |
| `classic_revolution` | RTLLM | 46 | 31 | 0.1026 | 1.33 | 3.96 | 27 |
| `sr_raw_conservative_exploit_qd` | ALL | 46 | 34 | 0.0926 | 1.37 | 2.59 | 7 |
| `sr_raw_conservative_exploit_qd` | RTLLM | 46 | 34 | 0.0926 | 1.37 | 2.59 | 7 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | RTLLM | Prob001_accu | 3 | 11 | 3 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob001_accu | 3 | 13 | 2 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob002_adder_16bit | 2 | 11 | 1 | 0.2051 | 3 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob002_adder_16bit | 2 | 11 | 1 | 0.2051 | 3 |
| `classic_revolution` | RTLLM | Prob003_adder_32bit | 2 | 17 | 1 | 0.6745 | 16 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob003_adder_32bit | 2 | 10 | 1 | 0.6745 | 10 |
| `classic_revolution` | RTLLM | Prob004_adder_8bit | 2 | 8 | 1 | 0.1510 | 2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob004_adder_8bit | 2 | 11 | 1 | 0.1510 | 2 |
| `classic_revolution` | RTLLM | Prob005_adder_bcd | 2 | 15 | 1 | 0.1982 | 7 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob005_adder_bcd | 2 | 17 | 1 | 0.1982 | 11 |
| `classic_revolution` | RTLLM | Prob007_comparator_3bit | 2 | 16 | 1 | 0.0583 | 2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob007_comparator_3bit | 2 | 8 | 1 | 0.0000 | 1 |
| `classic_revolution` | RTLLM | Prob008_comparator_4bit | 2 | 18 | 1 | 0.3616 | 15 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob008_comparator_4bit | 2 | 20 | 1 | 0.3616 | 14 |
| `classic_revolution` | RTLLM | Prob009_div_16bit | 2 | 25 | 5 | 0.7159 | 25 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob009_div_16bit | 2 | 16 | 4 | 0.7128 | 16 |
| `classic_revolution` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob010_radix2_div | 3 | 3 | 2 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob011_multi_16bit | 3 | 14 | 3 | 0.0056 | 4 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob011_multi_16bit | 3 | 19 | 3 | 0.0075 | 2 |
| `classic_revolution` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 |
| `classic_revolution` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | 3 | 12 | 5 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 4 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob019_sub_64bit | 2 | 9 | 1 | 0.4499 | 3 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob019_sub_64bit | 2 | 12 | 1 | 0.4500 | 6 |
| `classic_revolution` | RTLLM | Prob020_JC_counter | 3 | 4 | 1 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob020_JC_counter | 3 | 4 | 1 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob021_counter_12 | 3 | 8 | 3 | 0.0026 | 3 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob021_counter_12 | 3 | 6 | 2 | 0.0000 | 2 |
| `classic_revolution` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob023_up_down_counter | 3 | 3 | 1 | 0.0094 | 1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.2652 | 4 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob024_fsm | 2 | 8 | 3 | 0.1460 | 5 |
| `classic_revolution` | RTLLM | Prob025_sequence_detector | 3 | 3 | 1 | 0.0202 | 2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob025_sequence_detector | 3 | 7 | 2 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob027_LIFObuffer | 3 | 32 | 6 | 0.0079 | 7 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob027_LIFObuffer | 3 | 26 | 8 | 0.0067 | 6 |
| `classic_revolution` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob029_barrel_shifter | 2 | 1 | 1 | 0.0854 | 1 |
| `classic_revolution` | RTLLM | Prob030_right_shifter | 3 | 3 | 1 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob030_right_shifter | 3 | 3 | 1 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob031_freq_div | 2 | 5 | 1 | 0.0836 | 5 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob031_freq_div | 2 | 3 | 1 | 0.0471 | 2 |
| `classic_revolution` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob035_calendar | 3 | 5 | 2 | 0.0000 | 1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob035_calendar | 3 | 6 | 3 | 0.0000 | 1 |
| `classic_revolution` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.4327 | 4 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob036_edge_detect | 3 | 4 | 1 | 0.3261 | 1 |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | 3 | 8 | 1 | 0.0119 | 3 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob037_parallel2serial | 3 | 3 | 2 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob039_serial2parallel | 3 | 2 | 1 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob041_traffic_light | 2 | 17 | 3 | 0.2965 | 16 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob041_traffic_light | 2 | 10 | 2 | 0.1786 | 6 |
| `classic_revolution` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob043_RAM | 3 | 11 | 2 | 0.1018 | 11 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob043_RAM | 3 | 4 | 1 | 0.0774 | 4 |
| `classic_revolution` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 |
| `classic_revolution` | RTLLM | Prob045_alu | 2 | 28 | 1 | 0.2568 | 28 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob045_alu | 2 | 12 | 1 | 0.2295 | 12 |
| `classic_revolution` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob047_instr_reg | 3 | 4 | 1 | 0.0000 | 0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob047_instr_reg | 3 | 3 | 1 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob048_pe | 3 | 5 | 3 | 0.0000 | 1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob048_pe | 3 | 4 | 1 | 0.0000 | 2 |
| `classic_revolution` | RTLLM | Prob049_signal_generator | 3 | 11 | 4 | 0.0223 | 8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0109 | 2 |
| `classic_revolution` | RTLLM | Prob050_square_wave | 3 | 25 | 2 | 0.0041 | 6 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob050_square_wave | 3 | 28 | 3 | 0.0031 | 5 |

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
