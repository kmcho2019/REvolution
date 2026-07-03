# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- backend_count: `5`
- overall_multi_objective_winner: `front_slot_lane_030`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 8 | 8 | 0.1406 | 3.25 | 8.00 | 2 |
| `classic_revolution_8x5` | RTLLM | 5 | 5 | 0.1453 | 3.60 | 10.60 | 2 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.67 | 3.67 | 0 |
| `elite_pareto_slot_2` | ALL | 8 | 8 | 0.1571 | 3.12 | 8.25 | 2 |
| `elite_pareto_slot_2` | RTLLM | 5 | 5 | 0.1715 | 3.80 | 11.80 | 1 |
| `elite_pareto_slot_2` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1331 | 2.00 | 2.33 | 1 |
| `front_slot_lane_010` | ALL | 8 | 8 | 0.1416 | 3.12 | 6.62 | 0 |
| `front_slot_lane_010` | RTLLM | 5 | 5 | 0.1468 | 3.20 | 8.80 | 0 |
| `front_slot_lane_010` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 3.00 | 3.00 | 0 |
| `front_slot_lane_030` | ALL | 8 | 8 | 0.1849 | 2.88 | 6.88 | 2 |
| `front_slot_lane_030` | RTLLM | 5 | 5 | 0.1764 | 3.20 | 9.40 | 1 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1990 | 2.33 | 2.67 | 1 |
| `smooth_qd_v2_8x5` | ALL | 8 | 8 | 0.1738 | 2.62 | 7.88 | 2 |
| `smooth_qd_v2_8x5` | RTLLM | 5 | 5 | 0.1982 | 3.00 | 10.20 | 1 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1331 | 2.00 | 4.00 | 1 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 8 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 9 | 0.0000 | 0 |
| `elite_pareto_slot_2` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 6 | 0.0010 | 1 |
| `front_slot_lane_010` | RTLLM | Prob015_multi_pipe_8bit | 3 | 16 | 8 | 0.0000 | 0 |
| `front_slot_lane_030` | RTLLM | Prob015_multi_pipe_8bit | 3 | 13 | 7 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1447 | 3 |
| `smooth_qd_v2_8x5` | RTLLM | Prob024_fsm | 2 | 10 | 1 | 0.3406 | 6 |
| `elite_pareto_slot_2` | RTLLM | Prob024_fsm | 2 | 10 | 1 | 0.3406 | 5 |
| `front_slot_lane_010` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1459 | 4 |
| `front_slot_lane_030` | RTLLM | Prob024_fsm | 2 | 10 | 1 | 0.3406 | 7 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 13 | 2 | 0.3101 | 12 |
| `smooth_qd_v2_8x5` | RTLLM | Prob041_traffic_light | 2 | 18 | 2 | 0.4084 | 14 |
| `elite_pareto_slot_2` | RTLLM | Prob041_traffic_light | 2 | 22 | 6 | 0.2907 | 20 |
| `front_slot_lane_010` | RTLLM | Prob041_traffic_light | 2 | 18 | 2 | 0.3268 | 16 |
| `front_slot_lane_030` | RTLLM | Prob041_traffic_light | 2 | 20 | 3 | 0.2993 | 16 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 34 | 4 | 0.2524 | 34 |
| `smooth_qd_v2_8x5` | RTLLM | Prob045_alu | 2 | 29 | 1 | 0.2318 | 29 |
| `elite_pareto_slot_2` | RTLLM | Prob045_alu | 2 | 29 | 3 | 0.2060 | 29 |
| `front_slot_lane_010` | RTLLM | Prob045_alu | 2 | 21 | 2 | 0.2421 | 21 |
| `front_slot_lane_030` | RTLLM | Prob045_alu | 2 | 22 | 3 | 0.2273 | 22 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0192 | 4 |
| `smooth_qd_v2_8x5` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 |
| `elite_pareto_slot_2` | RTLLM | Prob049_signal_generator | 3 | 7 | 3 | 0.0191 | 4 |
| `front_slot_lane_010` | RTLLM | Prob049_signal_generator | 3 | 3 | 2 | 0.0192 | 3 |
| `front_slot_lane_030` | RTLLM | Prob049_signal_generator | 3 | 3 | 2 | 0.0146 | 2 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 8 | 1 | 0.3984 | 8 |
| `elite_pareto_slot_2` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `front_slot_lane_010` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 1 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 0 |
| `elite_pareto_slot_2` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `front_slot_lane_010` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 1 | 0.1986 | 2 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 6 | 0.0004 | 4 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 6 | 4 | 0.0008 | 4 |
| `elite_pareto_slot_2` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 15 | 4 | 0.0010 | 3 |
| `front_slot_lane_010` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 12 | 7 | 0.0004 | 3 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 5 | 0.0000 | 0 |

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

