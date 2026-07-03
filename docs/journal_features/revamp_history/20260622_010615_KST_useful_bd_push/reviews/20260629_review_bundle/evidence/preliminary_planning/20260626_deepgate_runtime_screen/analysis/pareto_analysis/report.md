# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- backend_count: `2`
- overall_multi_objective_winner: `classic_revolution_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 8 | 8 | 0.1406 | 3.25 | 8.00 | 6 |
| `classic_revolution_8x5` | RTLLM | 5 | 5 | 0.1453 | 3.60 | 10.60 | 4 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.67 | 3.67 | 2 |
| `deepgate_pooled_pc3_8x5` | ALL | 8 | 8 | 0.1040 | 1.75 | 4.50 | 2 |
| `deepgate_pooled_pc3_8x5` | RTLLM | 5 | 5 | 0.0866 | 1.60 | 6.00 | 1 |
| `deepgate_pooled_pc3_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1330 | 2.00 | 2.00 | 1 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 8 | 0.0000 | 0 |
| `deepgate_pooled_pc3_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 6 | 2 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1447 | 3 |
| `deepgate_pooled_pc3_8x5` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1454 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 13 | 2 | 0.3101 | 12 |
| `deepgate_pooled_pc3_8x5` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.0997 | 9 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 34 | 4 | 0.2524 | 34 |
| `deepgate_pooled_pc3_8x5` | RTLLM | Prob045_alu | 2 | 16 | 1 | 0.1813 | 16 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0192 | 4 |
| `deepgate_pooled_pc3_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `deepgate_pooled_pc3_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 1 |
| `deepgate_pooled_pc3_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 6 | 0.0004 | 4 |
| `deepgate_pooled_pc3_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 4 | 0.0007 | 2 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob015_multi_pipe_8bit | [pairwise_fronts.png](problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png) |
| RTLLM | Prob024_fsm | [pairwise_fronts.png](problems/RTLLM/Prob024_fsm/pairwise_fronts.png) | n/a |
| RTLLM | Prob041_traffic_light | [pairwise_fronts.png](problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png) | n/a |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
| RTLLM | Prob049_signal_generator | [pairwise_fronts.png](problems/RTLLM/Prob049_signal_generator/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob049_signal_generator/front_3d.png) |
| VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob153_gshare | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob153_gshare/pairwise_fronts.png) | [front_3d.png](problems/VerilogEval-Spec-to-RTL/Prob153_gshare/front_3d.png) |
