# Hard Iteration Subset Analysis

- Subset: `hard_iteration_subset`
- Problems: `46`
- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.

## Summary Table

| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |
|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|
| `classic_revolution` | 53.4% | 45.3% | 31/46 | 0.2857 | 1633.07 | N/A | N/A | 0.1026 | 1.33 |
| `sr_raw_conservative_exploit_qd` | 54.6% | 37.8% | 34/46 | 0.2524 | 1749.44 | 18.5% | 0.5304 | 0.0926 | 1.37 |

## Recommendations

- Overall: `classic_revolution`
- Score-oriented QD: `sr_raw_conservative_exploit_qd`
- Archive-health QD: `sr_raw_conservative_exploit_qd`
- Multi-objective: `classic_revolution`

## Per-Problem Winners

| Benchmark | Problem | Winner | Synthesis Rate | Best Score |
|:---|:---|:---|:---|:---|
| RTLLM | Prob001_accu | `classic_revolution` | 87.5% | 0.0758 |
| RTLLM | Prob002_adder_16bit | `classic_revolution` | 100.0% | 0.3999 |
| RTLLM | Prob003_adder_32bit | `classic_revolution` | 91.7% | 0.5579 |
| RTLLM | Prob004_adder_8bit | `classic_revolution` | 60.4% | 0.3815 |
| RTLLM | Prob005_adder_bcd | `classic_revolution` | 95.8% | 0.3970 |
| RTLLM | Prob007_comparator_3bit | `classic_revolution` | 97.9% | 0.3501 |
| RTLLM | Prob008_comparator_4bit | `sr_raw_conservative_exploit_qd` | 95.8% | 0.4527 |
| RTLLM | Prob009_div_16bit | `classic_revolution` | 75.0% | 0.5591 |
| RTLLM | Prob010_radix2_div | `sr_raw_conservative_exploit_qd` | 8.3% | N/A |
| RTLLM | Prob011_multi_16bit | `sr_raw_conservative_exploit_qd` | 62.5% | 0.3053 |
| RTLLM | Prob012_multi_8bit | `classic_revolution` | 77.1% | 0.4608 |
| RTLLM | Prob014_multi_pipe_4bit | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob015_multi_pipe_8bit | `classic_revolution` | 29.2% | 0.0682 |
| RTLLM | Prob016_fixed_point_adder | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob017_fixed_point_substractor | `sr_raw_conservative_exploit_qd` | 0.0% | N/A |
| RTLLM | Prob019_sub_64bit | `sr_raw_conservative_exploit_qd` | 95.8% | 0.4823 |
| RTLLM | Prob020_JC_counter | `classic_revolution` | 87.5% | -0.0000 |
| RTLLM | Prob021_counter_12 | `classic_revolution` | 95.8% | 0.3306 |
| RTLLM | Prob022_ring_counter | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob023_up_down_counter | `classic_revolution` | 75.0% | 0.2158 |
| RTLLM | Prob024_fsm | `classic_revolution` | 25.0% | 0.6316 |
| RTLLM | Prob025_sequence_detector | `sr_raw_conservative_exploit_qd` | 14.6% | N/A |
| RTLLM | Prob026_asyn_fifo | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob027_LIFObuffer | `sr_raw_conservative_exploit_qd` | 85.4% | 0.1825 |
| RTLLM | Prob028_LFSR | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob029_barrel_shifter | `sr_raw_conservative_exploit_qd` | 2.1% | N/A |
| RTLLM | Prob030_right_shifter | `classic_revolution` | 68.8% | -0.0000 |
| RTLLM | Prob031_freq_div | `classic_revolution` | 50.0% | 0.2091 |
| RTLLM | Prob032_freq_divbyeven | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob033_freq_divbyfrac | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob034_freq_divbyodd | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob035_calendar | `classic_revolution` | 45.8% | 0.0234 |
| RTLLM | Prob036_edge_detect | `classic_revolution` | 60.4% | 0.0389 |
| RTLLM | Prob037_parallel2serial | `classic_revolution` | 35.4% | 0.2283 |
| RTLLM | Prob038_pulse_detect | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob039_serial2parallel | `sr_raw_conservative_exploit_qd` | 4.2% | N/A |
| RTLLM | Prob041_traffic_light | `classic_revolution` | 45.8% | 0.4246 |
| RTLLM | Prob042_width_8to16 | `classic_revolution` | 0.0% | N/A |
| RTLLM | Prob043_RAM | `classic_revolution` | 85.4% | 0.4445 |
| RTLLM | Prob044_ROM | `classic_revolution` | 62.5% | 0.3294 |
| RTLLM | Prob045_alu | `classic_revolution` | 64.6% | 0.4170 |
| RTLLM | Prob046_clkgenerator | `sr_raw_conservative_exploit_qd` | 0.0% | N/A |
| RTLLM | Prob047_instr_reg | `classic_revolution` | 70.8% | -0.0028 |
| RTLLM | Prob048_pe | `classic_revolution` | 45.8% | 0.0150 |
| RTLLM | Prob049_signal_generator | `classic_revolution` | 58.3% | 0.2638 |
| RTLLM | Prob050_square_wave | `classic_revolution` | 93.8% | 0.2779 |
