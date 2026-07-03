# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- backend_count: `3`
- overall_multi_objective_winner: `smooth_qd_v2_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 8 | 8 | 0.1325 | 2.88 | 7.12 | 4 |
| `classic_revolution_8x5` | RTLLM | 5 | 5 | 0.1320 | 3.80 | 10.00 | 2 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1334 | 1.33 | 2.33 | 2 |
| `front_slot_lane_030` | ALL | 8 | 8 | 0.1370 | 3.12 | 6.88 | 1 |
| `front_slot_lane_030` | RTLLM | 5 | 5 | 0.1396 | 3.80 | 9.60 | 1 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1328 | 2.00 | 2.33 | 0 |
| `smooth_qd_v2_8x5` | ALL | 8 | 8 | 0.1429 | 3.12 | 8.12 | 3 |
| `smooth_qd_v2_8x5` | RTLLM | 5 | 5 | 0.1489 | 3.20 | 11.00 | 2 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1331 | 3.00 | 3.33 | 1 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 8 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 7 | 5 | 0.0000 | 0 |
| `front_slot_lane_030` | RTLLM | Prob015_multi_pipe_8bit | 3 | 14 | 8 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.2652 | 5 |
| `smooth_qd_v2_8x5` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1459 | 5 |
| `front_slot_lane_030` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1447 | 2 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 23 | 5 | 0.1850 | 19 |
| `smooth_qd_v2_8x5` | RTLLM | Prob041_traffic_light | 2 | 17 | 3 | 0.3661 | 14 |
| `front_slot_lane_030` | RTLLM | Prob041_traffic_light | 2 | 26 | 2 | 0.3034 | 19 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 24 | 2 | 0.1998 | 24 |
| `smooth_qd_v2_8x5` | RTLLM | Prob045_alu | 2 | 33 | 2 | 0.2153 | 33 |
| `front_slot_lane_030` | RTLLM | Prob045_alu | 2 | 23 | 2 | 0.2372 | 23 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 3 | 3 | 0.0100 | 2 |
| `smooth_qd_v2_8x5` | RTLLM | Prob049_signal_generator | 3 | 4 | 4 | 0.0170 | 3 |
| `front_slot_lane_030` | RTLLM | Prob049_signal_generator | 3 | 8 | 5 | 0.0126 | 4 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 1 | 0.0000 | 1 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 13 | 2 | 0.0018 | 1 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 15 | 7 | 0.0008 | 5 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 7 | 4 | 0.0000 | 1 |

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

