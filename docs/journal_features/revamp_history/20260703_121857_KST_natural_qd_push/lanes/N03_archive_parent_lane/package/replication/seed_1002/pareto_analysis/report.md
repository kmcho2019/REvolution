# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- backend_count: `3`
- overall_multi_objective_winner: `smooth_qd_v2_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 8 | 8 | 0.1594 | 2.12 | 6.62 | 2 |
| `classic_revolution_8x5` | RTLLM | 5 | 5 | 0.1753 | 2.40 | 9.20 | 1 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1328 | 1.67 | 2.33 | 1 |
| `front_slot_lane_030` | ALL | 8 | 8 | 0.1613 | 3.00 | 8.50 | 2 |
| `front_slot_lane_030` | RTLLM | 5 | 5 | 0.1783 | 3.20 | 12.00 | 1 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.67 | 2.67 | 1 |
| `smooth_qd_v2_8x5` | ALL | 8 | 8 | 0.1718 | 2.00 | 8.75 | 4 |
| `smooth_qd_v2_8x5` | RTLLM | 5 | 5 | 0.1950 | 2.40 | 12.60 | 3 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1331 | 1.33 | 2.33 | 1 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 4 | 0.0000 | 0 |
| `smooth_qd_v2_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 13 | 5 | 0.0000 | 0 |
| `front_slot_lane_030` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 5 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.2652 | 4 |
| `smooth_qd_v2_8x5` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.3406 | 5 |
| `front_slot_lane_030` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.3406 | 4 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 16 | 3 | 0.3234 | 12 |
| `smooth_qd_v2_8x5` | RTLLM | Prob041_traffic_light | 2 | 18 | 2 | 0.3623 | 18 |
| `front_slot_lane_030` | RTLLM | Prob041_traffic_light | 2 | 27 | 5 | 0.3279 | 24 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 24 | 1 | 0.2675 | 24 |
| `smooth_qd_v2_8x5` | RTLLM | Prob045_alu | 2 | 38 | 1 | 0.2613 | 38 |
| `front_slot_lane_030` | RTLLM | Prob045_alu | 2 | 26 | 2 | 0.2019 | 26 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 6 | 3 | 0.0203 | 6 |
| `smooth_qd_v2_8x5` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0109 | 2 |
| `front_slot_lane_030` | RTLLM | Prob049_signal_generator | 3 | 7 | 3 | 0.0210 | 6 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 7 | 1 | 0.3984 | 6 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 2 | 0.0000 | 1 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 0 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 1 | 0.0000 | 1 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 9 | 2 | 0.0000 | 1 |
| `smooth_qd_v2_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 2 | 0.0008 | 3 |
| `front_slot_lane_030` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 6 | 0.0003 | 1 |

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

