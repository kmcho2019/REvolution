# PPA Distribution Analysis

- candidate_count: `2973`
- reference_problem_count: `46`
- best_backend_problem_count: `102`
- figure_count: `150`

## Outputs

- candidates: [ppa_candidates.csv](data/ppa_candidates.csv)
- best candidates: [best_candidate_by_backend_problem.csv](data/best_candidate_by_backend_problem.csv)
- references: [reference_ppa_metrics.csv](data/reference_ppa_metrics.csv)
- all-backend figures: [figures/all_backends](figures/all_backends)
- classic-vs figures: [figures/classic_vs](figures/classic_vs)

Figures use filled score contours when enough non-collinear candidates are available, white contour lines for local score levels, subtle projected Pareto-front lines, and a red star for the reference design.

## Problems

| Benchmark | Problem | Circuit | Candidates | Figure Root |
| --- | --- | --- | ---: | --- |
| `RTLLM` | `Prob001_accu` | `sequential` | 121 | [figures/all_backends/RTLLM/Prob001_accu](figures/all_backends/RTLLM/Prob001_accu) |
| `RTLLM` | `Prob002_adder_16bit` | `combinational` | 135 | [figures/all_backends/RTLLM/Prob002_adder_16bit](figures/all_backends/RTLLM/Prob002_adder_16bit) |
| `RTLLM` | `Prob003_adder_32bit` | `combinational` | 130 | [figures/all_backends/RTLLM/Prob003_adder_32bit](figures/all_backends/RTLLM/Prob003_adder_32bit) |
| `RTLLM` | `Prob004_adder_8bit` | `combinational` | 85 | [figures/all_backends/RTLLM/Prob004_adder_8bit](figures/all_backends/RTLLM/Prob004_adder_8bit) |
| `RTLLM` | `Prob005_adder_bcd` | `combinational` | 136 | [figures/all_backends/RTLLM/Prob005_adder_bcd](figures/all_backends/RTLLM/Prob005_adder_bcd) |
| `RTLLM` | `Prob007_comparator_3bit` | `combinational` | 140 | [figures/all_backends/RTLLM/Prob007_comparator_3bit](figures/all_backends/RTLLM/Prob007_comparator_3bit) |
| `RTLLM` | `Prob008_comparator_4bit` | `combinational` | 134 | [figures/all_backends/RTLLM/Prob008_comparator_4bit](figures/all_backends/RTLLM/Prob008_comparator_4bit) |
| `RTLLM` | `Prob009_div_16bit` | `combinational` | 114 | [figures/all_backends/RTLLM/Prob009_div_16bit](figures/all_backends/RTLLM/Prob009_div_16bit) |
| `RTLLM` | `Prob010_radix2_div` | `sequential` | 2 | [figures/all_backends/RTLLM/Prob010_radix2_div](figures/all_backends/RTLLM/Prob010_radix2_div) |
| `RTLLM` | `Prob011_multi_16bit` | `sequential` | 63 | [figures/all_backends/RTLLM/Prob011_multi_16bit](figures/all_backends/RTLLM/Prob011_multi_16bit) |
| `RTLLM` | `Prob012_multi_8bit` | `combinational` | 110 | [figures/all_backends/RTLLM/Prob012_multi_8bit](figures/all_backends/RTLLM/Prob012_multi_8bit) |
| `RTLLM` | `Prob015_multi_pipe_8bit` | `sequential` | 42 | [figures/all_backends/RTLLM/Prob015_multi_pipe_8bit](figures/all_backends/RTLLM/Prob015_multi_pipe_8bit) |
| `RTLLM` | `Prob019_sub_64bit` | `combinational` | 136 | [figures/all_backends/RTLLM/Prob019_sub_64bit](figures/all_backends/RTLLM/Prob019_sub_64bit) |
| `RTLLM` | `Prob020_JC_counter` | `sequential` | 132 | [figures/all_backends/RTLLM/Prob020_JC_counter](figures/all_backends/RTLLM/Prob020_JC_counter) |
| `RTLLM` | `Prob021_counter_12` | `sequential` | 143 | [figures/all_backends/RTLLM/Prob021_counter_12](figures/all_backends/RTLLM/Prob021_counter_12) |
| `RTLLM` | `Prob023_up_down_counter` | `sequential` | 111 | [figures/all_backends/RTLLM/Prob023_up_down_counter](figures/all_backends/RTLLM/Prob023_up_down_counter) |
| `RTLLM` | `Prob024_fsm` | `combinational` | 37 | [figures/all_backends/RTLLM/Prob024_fsm](figures/all_backends/RTLLM/Prob024_fsm) |
| `RTLLM` | `Prob025_sequence_detector` | `sequential` | 19 | [figures/all_backends/RTLLM/Prob025_sequence_detector](figures/all_backends/RTLLM/Prob025_sequence_detector) |
| `RTLLM` | `Prob027_LIFObuffer` | `sequential` | 110 | [figures/all_backends/RTLLM/Prob027_LIFObuffer](figures/all_backends/RTLLM/Prob027_LIFObuffer) |
| `RTLLM` | `Prob029_barrel_shifter` | `combinational` | 8 | [figures/all_backends/RTLLM/Prob029_barrel_shifter](figures/all_backends/RTLLM/Prob029_barrel_shifter) |
| `RTLLM` | `Prob030_right_shifter` | `sequential` | 102 | [figures/all_backends/RTLLM/Prob030_right_shifter](figures/all_backends/RTLLM/Prob030_right_shifter) |
| `RTLLM` | `Prob031_freq_div` | `combinational` | 54 | [figures/all_backends/RTLLM/Prob031_freq_div](figures/all_backends/RTLLM/Prob031_freq_div) |
| `RTLLM` | `Prob035_calendar` | `sequential` | 63 | [figures/all_backends/RTLLM/Prob035_calendar](figures/all_backends/RTLLM/Prob035_calendar) |
| `RTLLM` | `Prob036_edge_detect` | `sequential` | 85 | [figures/all_backends/RTLLM/Prob036_edge_detect](figures/all_backends/RTLLM/Prob036_edge_detect) |
| `RTLLM` | `Prob037_parallel2serial` | `sequential` | 34 | [figures/all_backends/RTLLM/Prob037_parallel2serial](figures/all_backends/RTLLM/Prob037_parallel2serial) |
| `RTLLM` | `Prob038_pulse_detect` | `sequential` | 3 | [figures/all_backends/RTLLM/Prob038_pulse_detect](figures/all_backends/RTLLM/Prob038_pulse_detect) |
| `RTLLM` | `Prob039_serial2parallel` | `sequential` | 4 | [figures/all_backends/RTLLM/Prob039_serial2parallel](figures/all_backends/RTLLM/Prob039_serial2parallel) |
| `RTLLM` | `Prob041_traffic_light` | `combinational` | 72 | [figures/all_backends/RTLLM/Prob041_traffic_light](figures/all_backends/RTLLM/Prob041_traffic_light) |
| `RTLLM` | `Prob043_RAM` | `sequential` | 107 | [figures/all_backends/RTLLM/Prob043_RAM](figures/all_backends/RTLLM/Prob043_RAM) |
| `RTLLM` | `Prob044_ROM` | `combinational` | 75 | [figures/all_backends/RTLLM/Prob044_ROM](figures/all_backends/RTLLM/Prob044_ROM) |
| `RTLLM` | `Prob045_alu` | `combinational` | 96 | [figures/all_backends/RTLLM/Prob045_alu](figures/all_backends/RTLLM/Prob045_alu) |
| `RTLLM` | `Prob047_instr_reg` | `sequential` | 104 | [figures/all_backends/RTLLM/Prob047_instr_reg](figures/all_backends/RTLLM/Prob047_instr_reg) |
| `RTLLM` | `Prob048_pe` | `sequential` | 63 | [figures/all_backends/RTLLM/Prob048_pe](figures/all_backends/RTLLM/Prob048_pe) |
| `RTLLM` | `Prob049_signal_generator` | `sequential` | 60 | [figures/all_backends/RTLLM/Prob049_signal_generator](figures/all_backends/RTLLM/Prob049_signal_generator) |
| `RTLLM` | `Prob050_square_wave` | `sequential` | 143 | [figures/all_backends/RTLLM/Prob050_square_wave](figures/all_backends/RTLLM/Prob050_square_wave) |
