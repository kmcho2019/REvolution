# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/tables/hard_tuning_subset.yaml`
- backend_count: `2`
- overall_multi_objective_winner: `classic`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic` | ALL | 13 | 13 | 0.0926 | 2.31 | 3.54 | 9 |
| `classic` | RTLLM | 7 | 7 | 0.1152 | 2.71 | 5.29 | 5 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0663 | 1.83 | 1.50 | 4 |
| `fused_rtl_state_pipeline_qd` | ALL | 13 | 13 | 0.0896 | 1.92 | 3.85 | 4 |
| `fused_rtl_state_pipeline_qd` | RTLLM | 7 | 7 | 0.1093 | 2.00 | 5.86 | 2 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0665 | 1.83 | 1.50 | 2 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 9 | 0.0000 | 0 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 6 | 2 | 0.0000 | 0 |
| `classic` | RTLLM | Prob024_fsm | 2 | 11 | 2 | 0.1449 | 8 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1457 | 4 |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0003 | 1 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 2 | 0.0000 | 1 |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3067 | 14 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob041_traffic_light | 2 | 18 | 4 | 0.2427 | 14 |
| `classic` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1904 | 9 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob045_alu | 2 | 19 | 1 | 0.2161 | 19 |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0128 | 3 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.3975 | 5 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 1 | 0.0000 | 0 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 2 | 0.0000 | 0 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 1 | 0.0000 | 0 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0002 | 1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 13 | 6 | 0.0003 | 2 |

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
