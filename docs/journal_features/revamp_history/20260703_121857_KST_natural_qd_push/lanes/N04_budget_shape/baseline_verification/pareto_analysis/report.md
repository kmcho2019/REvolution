# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T79_budget_shape_ablation_protocol/tables/budget_shape_subset.yaml`
- backend_count: `1`
- overall_multi_objective_winner: `classic_revolution_6x7`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_6x7` | ALL | 8 | 8 | 0.1701 | 2.62 | 8.38 | 8 |
| `classic_revolution_6x7` | RTLLM | 5 | 5 | 0.1924 | 2.60 | 12.20 | 5 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 | 2.67 | 2.00 | 3 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_6x7` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 7 | 0.0000 | 0 |
| `classic_revolution_6x7` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.3406 | 7 |
| `classic_revolution_6x7` | RTLLM | Prob041_traffic_light | 2 | 26 | 2 | 0.3501 | 24 |
| `classic_revolution_6x7` | RTLLM | Prob045_alu | 2 | 25 | 1 | 0.2523 | 25 |
| `classic_revolution_6x7` | RTLLM | Prob049_signal_generator | 3 | 7 | 2 | 0.0192 | 5 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 14 | 6 | 0.0001 | 1 |

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

