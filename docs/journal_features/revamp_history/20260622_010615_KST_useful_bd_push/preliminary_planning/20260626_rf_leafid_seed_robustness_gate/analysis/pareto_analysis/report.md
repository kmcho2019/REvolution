# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- backend_count: `6`
- overall_multi_objective_winner: `classic_s1002`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_s1001` | ALL | 8 | 8 | 0.1406 | 3.25 | 8.00 | 2 |
| `classic_s1001` | RTLLM | 5 | 5 | 0.1453 | 3.60 | 10.60 | 1 |
| `classic_s1001` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.67 | 3.67 | 1 |
| `classic_s1002` | ALL | 8 | 8 | 0.1594 | 2.12 | 6.62 | 3 |
| `classic_s1002` | RTLLM | 5 | 5 | 0.1753 | 2.40 | 9.20 | 3 |
| `classic_s1002` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1328 | 1.67 | 2.33 | 0 |
| `classic_s1003` | ALL | 8 | 8 | 0.1325 | 2.88 | 7.12 | 2 |
| `classic_s1003` | RTLLM | 5 | 5 | 0.1320 | 3.80 | 10.00 | 1 |
| `classic_s1003` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1334 | 1.33 | 2.33 | 1 |
| `t83_s1001` | ALL | 8 | 8 | 0.1369 | 2.00 | 4.50 | 1 |
| `t83_s1001` | RTLLM | 5 | 5 | 0.0995 | 1.60 | 5.40 | 0 |
| `t83_s1001` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1993 | 2.67 | 3.00 | 1 |
| `t83_s1002` | ALL | 8 | 8 | 0.1210 | 2.38 | 4.75 | 0 |
| `t83_s1002` | RTLLM | 5 | 5 | 0.1138 | 2.40 | 6.00 | 0 |
| `t83_s1002` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1331 | 2.33 | 2.67 | 0 |
| `t83_s1003` | ALL | 8 | 8 | 0.1200 | 2.25 | 5.50 | 0 |
| `t83_s1003` | RTLLM | 5 | 5 | 0.1122 | 1.80 | 7.20 | 0 |
| `t83_s1003` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 3.00 | 2.67 | 0 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_s1001` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 8 | 0.0000 | 0 |
| `t83_s1001` | RTLLM | Prob015_multi_pipe_8bit | 3 | 4 | 3 | 0.0000 | 0 |
| `classic_s1002` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 4 | 0.0000 | 0 |
| `t83_s1002` | RTLLM | Prob015_multi_pipe_8bit | 3 | 7 | 3 | 0.0000 | 0 |
| `classic_s1003` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 8 | 0.0000 | 0 |
| `t83_s1003` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 3 | 0.0000 | 0 |
| `classic_s1001` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1447 | 3 |
| `t83_s1001` | RTLLM | Prob024_fsm | 2 | 9 | 2 | 0.1456 | 5 |
| `classic_s1002` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.2652 | 4 |
| `t83_s1002` | RTLLM | Prob024_fsm | 2 | 6 | 2 | 0.1449 | 3 |
| `classic_s1003` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.2652 | 5 |
| `t83_s1003` | RTLLM | Prob024_fsm | 2 | 9 | 2 | 0.1459 | 6 |
| `classic_s1001` | RTLLM | Prob041_traffic_light | 2 | 13 | 2 | 0.3101 | 12 |
| `t83_s1001` | RTLLM | Prob041_traffic_light | 2 | 12 | 1 | 0.0988 | 5 |
| `classic_s1002` | RTLLM | Prob041_traffic_light | 2 | 16 | 3 | 0.3234 | 12 |
| `t83_s1002` | RTLLM | Prob041_traffic_light | 2 | 16 | 3 | 0.2214 | 14 |
| `classic_s1003` | RTLLM | Prob041_traffic_light | 2 | 23 | 5 | 0.1850 | 19 |
| `t83_s1003` | RTLLM | Prob041_traffic_light | 2 | 16 | 2 | 0.2042 | 11 |
| `classic_s1001` | RTLLM | Prob045_alu | 2 | 34 | 4 | 0.2524 | 34 |
| `t83_s1001` | RTLLM | Prob045_alu | 2 | 16 | 1 | 0.2465 | 16 |
| `classic_s1002` | RTLLM | Prob045_alu | 2 | 24 | 1 | 0.2675 | 24 |
| `t83_s1002` | RTLLM | Prob045_alu | 2 | 11 | 2 | 0.1925 | 11 |
| `classic_s1003` | RTLLM | Prob045_alu | 2 | 24 | 2 | 0.1998 | 24 |
| `t83_s1003` | RTLLM | Prob045_alu | 2 | 19 | 1 | 0.2041 | 18 |
| `classic_s1001` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0192 | 4 |
| `t83_s1001` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `classic_s1002` | RTLLM | Prob049_signal_generator | 3 | 6 | 3 | 0.0203 | 6 |
| `t83_s1002` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 |
| `classic_s1003` | RTLLM | Prob049_signal_generator | 3 | 3 | 3 | 0.0100 | 2 |
| `t83_s1003` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `classic_s1001` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `t83_s1001` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 3 | 1 | 0.3984 | 3 |
| `classic_s1002` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `t83_s1002` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `classic_s1003` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `t83_s1003` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `classic_s1001` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 1 |
| `t83_s1001` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 2 | 0.1986 | 3 |
| `classic_s1002` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 2 | 0.0000 | 1 |
| `t83_s1002` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 |
| `classic_s1003` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `t83_s1003` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 |
| `classic_s1001` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 6 | 0.0004 | 4 |
| `t83_s1001` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 5 | 0.0008 | 3 |
| `classic_s1002` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 9 | 2 | 0.0000 | 1 |
| `t83_s1002` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 16 | 5 | 0.0010 | 4 |
| `classic_s1003` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 13 | 2 | 0.0018 | 1 |
| `t83_s1003` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 19 | 7 | 0.0004 | 3 |

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
