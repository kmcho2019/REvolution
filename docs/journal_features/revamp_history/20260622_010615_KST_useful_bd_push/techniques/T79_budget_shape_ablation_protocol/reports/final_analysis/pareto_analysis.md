# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T79_budget_shape_ablation_protocol/tables/budget_shape_subset.yaml`
- backend_count: `6`
- overall_multi_objective_winner: `classic_revolution_12x3`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_12x3` | ALL | 8 | 8 | 0.1864 | 2.25 | 8.38 | 1 |
| `classic_revolution_12x3` | RTLLM | 5 | 5 | 0.1788 | 2.60 | 12.20 | 0 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1990 | 1.67 | 2.00 | 1 |
| `classic_revolution_6x7` | ALL | 8 | 8 | 0.1701 | 2.62 | 8.38 | 4 |
| `classic_revolution_6x7` | RTLLM | 5 | 5 | 0.1924 | 2.60 | 12.20 | 4 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.67 | 2.00 | 0 |
| `classic_revolution_8x5` | ALL | 8 | 8 | 0.1414 | 2.62 | 7.88 | 1 |
| `classic_revolution_8x5` | RTLLM | 5 | 5 | 0.1464 | 3.00 | 10.60 | 0 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1330 | 2.00 | 3.33 | 1 |
| `shape_density_front_pressure_qd_12x3` | ALL | 8 | 8 | 0.1060 | 2.25 | 5.12 | 0 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | 5 | 5 | 0.0898 | 2.20 | 7.00 | 0 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.33 | 2.00 | 0 |
| `shape_density_front_pressure_qd_6x7` | ALL | 8 | 8 | 0.1194 | 2.00 | 5.38 | 0 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | 5 | 5 | 0.1114 | 2.00 | 7.60 | 0 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1328 | 2.00 | 1.67 | 0 |
| `shape_density_front_pressure_qd_8x5` | ALL | 8 | 8 | 0.1231 | 1.62 | 5.62 | 2 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | 5 | 5 | 0.1170 | 1.60 | 7.20 | 1 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1332 | 1.67 | 3.00 | 1 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_12x3` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 5 | 0.0000 | 0 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob015_multi_pipe_8bit | 3 | 4 | 2 | 0.0000 | 0 |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 6 | 0.0000 | 0 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 3 | 0.0000 | 0 |
| `classic_revolution_6x7` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 7 | 0.0000 | 0 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob015_multi_pipe_8bit | 3 | 5 | 2 | 0.0000 | 0 |
| `classic_revolution_12x3` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.3059 | 6 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1459 | 5 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.3406 | 4 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1449 | 4 |
| `classic_revolution_6x7` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.3406 | 7 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1459 | 5 |
| `classic_revolution_12x3` | RTLLM | Prob041_traffic_light | 2 | 27 | 3 | 0.3155 | 22 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob041_traffic_light | 2 | 12 | 3 | 0.1153 | 7 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 17 | 4 | 0.1405 | 12 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob041_traffic_light | 2 | 14 | 1 | 0.1749 | 10 |
| `classic_revolution_6x7` | RTLLM | Prob041_traffic_light | 2 | 26 | 2 | 0.3501 | 24 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.2330 | 12 |
| `classic_revolution_12x3` | RTLLM | Prob045_alu | 2 | 30 | 1 | 0.2555 | 30 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob045_alu | 2 | 22 | 3 | 0.1809 | 22 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 32 | 1 | 0.2341 | 32 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob045_alu | 2 | 21 | 1 | 0.2586 | 21 |
| `classic_revolution_6x7` | RTLLM | Prob045_alu | 2 | 25 | 1 | 0.2523 | 25 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob045_alu | 2 | 19 | 2 | 0.1683 | 19 |
| `classic_revolution_12x3` | RTLLM | Prob049_signal_generator | 3 | 4 | 3 | 0.0170 | 3 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 8 | 3 | 0.0170 | 5 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `classic_revolution_6x7` | RTLLM | Prob049_signal_generator | 3 | 7 | 2 | 0.0192 | 5 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 8 | 1 | 0.3984 | 8 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.1986 | 1 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 0 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 3 | 3 | 0.0000 | 0 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 5 | 0.0003 | 1 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 12 | 4 | 0.0004 | 2 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 9 | 3 | 0.0011 | 3 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 14 | 6 | 0.0001 | 1 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0000 | 1 |

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
