# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- backend_count: `4`
- overall_multi_objective_winner: `smooth_qd_v2_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 8 | 8 | 0.1406 | 3.25 | 8.00 | 3 |
| `classic_revolution_8x5` | RTLLM | 5 | 5 | 0.1453 | 3.60 | 10.60 | 2 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.67 | 3.67 | 1 |
| `smooth_qd_v2_8x5` | ALL | 8 | 8 | 0.1738 | 2.62 | 7.88 | 4 |
| `smooth_qd_v2_8x5` | RTLLM | 5 | 5 | 0.1982 | 3.00 | 10.20 | 2 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1331 | 2.00 | 4.00 | 2 |
| `warmup_16` | ALL | 8 | 8 | 0.1638 | 2.00 | 6.50 | 1 |
| `warmup_16` | RTLLM | 5 | 5 | 0.1826 | 2.20 | 9.40 | 1 |
| `warmup_16` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1326 | 1.67 | 1.67 | 0 |
| `warmup_4` | ALL | 8 | 8 | 0.1493 | 2.75 | 7.00 | 0 |
| `warmup_4` | RTLLM | 5 | 5 | 0.1591 | 3.00 | 10.00 | 0 |
| `warmup_4` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.33 | 2.00 | 0 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 8 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 9 | 0.0000 | 0 |
| `warmup_4` | RTLLM | Prob015_multi_pipe_8bit | 3 | 19 | 8 | 0.0000 | 0 |
| `warmup_16` | RTLLM | Prob015_multi_pipe_8bit | 3 | 8 | 4 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1447 | 3 |
| `smooth_qd_v2_8x5` | RTLLM | Prob024_fsm | 2 | 10 | 1 | 0.3406 | 6 |
| `warmup_4` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.2027 | 4 |
| `warmup_16` | RTLLM | Prob024_fsm | 2 | 13 | 1 | 0.3406 | 9 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 13 | 2 | 0.3101 | 12 |
| `smooth_qd_v2_8x5` | RTLLM | Prob041_traffic_light | 2 | 18 | 2 | 0.4084 | 14 |
| `warmup_4` | RTLLM | Prob041_traffic_light | 2 | 22 | 2 | 0.3563 | 19 |
| `warmup_16` | RTLLM | Prob041_traffic_light | 2 | 14 | 2 | 0.3326 | 14 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 34 | 4 | 0.2524 | 34 |
| `smooth_qd_v2_8x5` | RTLLM | Prob045_alu | 2 | 29 | 1 | 0.2318 | 29 |
| `warmup_4` | RTLLM | Prob045_alu | 2 | 24 | 1 | 0.2184 | 24 |
| `warmup_16` | RTLLM | Prob045_alu | 2 | 21 | 1 | 0.2251 | 21 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0192 | 4 |
| `smooth_qd_v2_8x5` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 |
| `warmup_4` | RTLLM | Prob049_signal_generator | 3 | 7 | 3 | 0.0181 | 3 |
| `warmup_16` | RTLLM | Prob049_signal_generator | 3 | 6 | 3 | 0.0146 | 3 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 8 | 1 | 0.3984 | 8 |
| `warmup_4` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `warmup_16` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 2 | 0.3973 | 4 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 1 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 0 |
| `warmup_4` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 0 |
| `warmup_16` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 6 | 0.0004 | 4 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 6 | 4 | 0.0008 | 4 |
| `warmup_4` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 9 | 5 | 0.0003 | 1 |
| `warmup_16` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 2 | 2 | 0.0003 | 1 |

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

