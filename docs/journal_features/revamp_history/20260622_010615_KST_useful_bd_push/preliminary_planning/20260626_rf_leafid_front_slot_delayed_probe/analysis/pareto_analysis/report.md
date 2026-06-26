# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- backend_count: `3`
- overall_multi_objective_winner: `classic_revolution_8x5`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | ALL | 8 | 8 | 0.1406 | 3.25 | 8.00 | 5 |
| `classic_revolution_8x5` | RTLLM | 5 | 5 | 0.1453 | 3.60 | 10.60 | 4 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.67 | 3.67 | 1 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | ALL | 8 | 8 | 0.1162 | 1.88 | 3.75 | 0 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | RTLLM | 5 | 5 | 0.1062 | 1.80 | 4.80 | 0 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1328 | 2.00 | 2.00 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | ALL | 8 | 8 | 0.1369 | 2.00 | 4.50 | 3 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | 5 | 5 | 0.0995 | 1.60 | 5.40 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1993 | 2.67 | 3.00 | 2 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 8 | 0.0000 | 0 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 7 | 3 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 4 | 3 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1447 | 3 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | RTLLM | Prob024_fsm | 2 | 5 | 1 | 0.1074 | 2 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob024_fsm | 2 | 9 | 2 | 0.1456 | 5 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 13 | 2 | 0.3101 | 12 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | RTLLM | Prob041_traffic_light | 2 | 16 | 2 | 0.2215 | 8 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob041_traffic_light | 2 | 12 | 1 | 0.0988 | 5 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 34 | 4 | 0.2524 | 34 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | RTLLM | Prob045_alu | 2 | 11 | 2 | 0.1897 | 11 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob045_alu | 2 | 16 | 1 | 0.2465 | 16 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0192 | 4 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | RTLLM | Prob049_signal_generator | 3 | 3 | 1 | 0.0123 | 3 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 3 | 1 | 0.3984 | 3 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 1 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 2 | 0.1986 | 3 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 6 | 0.0004 | 4 |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0001 | 1 |
| `masterrtl_rf_leafid_structural_delayed_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 5 | 0.0008 | 3 |

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
