# PPA Distribution Analysis

- candidate_count: `1930`
- reference_problem_count: `13`
- best_backend_problem_count: `94`
- figure_count: `46`

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
| `RTLLM` | `Prob004_adder_8bit` | `combinational` | 243 | [figures/all_backends/RTLLM/Prob004_adder_8bit](figures/all_backends/RTLLM/Prob004_adder_8bit) |
| `RTLLM` | `Prob015_multi_pipe_8bit` | `sequential` | 113 | [figures/all_backends/RTLLM/Prob015_multi_pipe_8bit](figures/all_backends/RTLLM/Prob015_multi_pipe_8bit) |
| `RTLLM` | `Prob024_fsm` | `combinational` | 133 | [figures/all_backends/RTLLM/Prob024_fsm](figures/all_backends/RTLLM/Prob024_fsm) |
| `RTLLM` | `Prob037_parallel2serial` | `sequential` | 124 | [figures/all_backends/RTLLM/Prob037_parallel2serial](figures/all_backends/RTLLM/Prob037_parallel2serial) |
| `RTLLM` | `Prob041_traffic_light` | `combinational` | 149 | [figures/all_backends/RTLLM/Prob041_traffic_light](figures/all_backends/RTLLM/Prob041_traffic_light) |
| `RTLLM` | `Prob045_alu` | `combinational` | 122 | [figures/all_backends/RTLLM/Prob045_alu](figures/all_backends/RTLLM/Prob045_alu) |
| `RTLLM` | `Prob049_signal_generator` | `sequential` | 251 | [figures/all_backends/RTLLM/Prob049_signal_generator](figures/all_backends/RTLLM/Prob049_signal_generator) |
| `VerilogEval-Spec-to-RTL` | `Prob098_circuit7` | `combinational` | 162 | [figures/all_backends/VerilogEval-Spec-to-RTL/Prob098_circuit7](figures/all_backends/VerilogEval-Spec-to-RTL/Prob098_circuit7) |
| `VerilogEval-Spec-to-RTL` | `Prob116_m2014_q3` | `combinational` | 154 | [figures/all_backends/VerilogEval-Spec-to-RTL/Prob116_m2014_q3](figures/all_backends/VerilogEval-Spec-to-RTL/Prob116_m2014_q3) |
| `VerilogEval-Spec-to-RTL` | `Prob135_m2014_q6b` | `combinational` | 237 | [figures/all_backends/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b](figures/all_backends/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b) |
| `VerilogEval-Spec-to-RTL` | `Prob150_review2015_fsmonehot` | `combinational` | 117 | [figures/all_backends/VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot](figures/all_backends/VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot) |
| `VerilogEval-Spec-to-RTL` | `Prob151_review2015_fsm` | `sequential` | 26 | [figures/all_backends/VerilogEval-Spec-to-RTL/Prob151_review2015_fsm](figures/all_backends/VerilogEval-Spec-to-RTL/Prob151_review2015_fsm) |
| `VerilogEval-Spec-to-RTL` | `Prob153_gshare` | `sequential` | 99 | [figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare](figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare) |
