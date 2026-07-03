# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml`
- backend_count: `2`
- overall_multi_objective_winner: `classic_revolution`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | ALL | 13 | 13 | 0.0926 | 2.31 | 3.54 | 9 |
| `classic_revolution` | RTLLM | 7 | 7 | 0.1152 | 2.71 | 5.29 | 5 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0663 | 1.83 | 1.50 | 4 |
| `source_aligned_rtl_cell_qd` | ALL | 13 | 13 | 0.0920 | 1.31 | 2.85 | 4 |
| `source_aligned_rtl_cell_qd` | RTLLM | 7 | 7 | 0.1139 | 1.14 | 4.14 | 2 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0665 | 1.50 | 1.33 | 2 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 9 | 0.0000 | 0 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 7 | 1 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob024_fsm | 2 | 11 | 2 | 0.1449 | 8 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.1797 | 6 |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0003 | 1 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob037_parallel2serial | 3 | 3 | 2 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3067 | 14 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob041_traffic_light | 2 | 12 | 1 | 0.2043 | 10 |
| `classic_revolution` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1904 | 9 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob045_alu | 2 | 11 | 1 | 0.2554 | 11 |
| `classic_revolution` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0128 | 3 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.3975 | 5 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 2 | 1 | 0.3984 | 2 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 2 | 0.0000 | 0 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 1 | 0.0000 | 0 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0002 | 1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 4 | 0.0003 | 3 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob004_adder_8bit | [pairwise_fronts.png](problems/RTLLM/Prob004_adder_8bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob015_multi_pipe_8bit | [pairwise_fronts.png](problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png) |
| RTLLM | Prob024_fsm | [pairwise_fronts.png](problems/RTLLM/Prob024_fsm/pairwise_fronts.png) | n/a |
| RTLLM | Prob037_parallel2serial | [pairwise_fronts.png](problems/RTLLM/Prob037_parallel2serial/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob037_parallel2serial/front_3d.png) |
| RTLLM | Prob041_traffic_light | [pairwise_fronts.png](problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png) | n/a |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
| RTLLM | Prob049_signal_generator | [pairwise_fronts.png](problems/RTLLM/Prob049_signal_generator/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob049_signal_generator/front_3d.png) |
| VerilogEval-Spec-to-RTL | Prob098_circuit7 | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob098_circuit7/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob151_review2015_fsm/pairwise_fronts.png) | [front_3d.png](problems/VerilogEval-Spec-to-RTL/Prob151_review2015_fsm/front_3d.png) |
| VerilogEval-Spec-to-RTL | Prob153_gshare | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob153_gshare/pairwise_fronts.png) | [front_3d.png](problems/VerilogEval-Spec-to-RTL/Prob153_gshare/front_3d.png) |
