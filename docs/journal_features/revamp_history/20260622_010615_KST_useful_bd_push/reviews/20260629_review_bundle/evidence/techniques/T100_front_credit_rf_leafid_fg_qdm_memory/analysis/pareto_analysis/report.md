# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/tables/smoke_subset.yaml`
- backend_count: `4`
- overall_multi_objective_winner: `classic_revolution_12x3`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_12x3` | ALL | 3 | 3 | 0.1903 | 3.00 | 17.33 | 3 |
| `classic_revolution_12x3` | RTLLM | 3 | 3 | 0.1903 | 3.00 | 17.33 | 3 |
| `fg_qdm_random_front_credit_12x3` | ALL | 3 | 3 | 0.1048 | 2.67 | 7.00 | 0 |
| `fg_qdm_random_front_credit_12x3` | RTLLM | 3 | 3 | 0.1048 | 2.67 | 7.00 | 0 |
| `fg_qdm_rf_leafid_front_credit_12x3` | ALL | 3 | 3 | 0.1566 | 2.00 | 12.00 | 0 |
| `fg_qdm_rf_leafid_front_credit_12x3` | RTLLM | 3 | 3 | 0.1566 | 2.00 | 12.00 | 0 |
| `fg_qdm_sr_front_credit_12x3` | ALL | 3 | 3 | 0.1534 | 1.67 | 9.33 | 0 |
| `fg_qdm_sr_front_credit_12x3` | RTLLM | 3 | 3 | 0.1534 | 1.67 | 9.33 | 0 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_12x3` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 5 | 0.0000 | 0 |
| `fg_qdm_rf_leafid_front_credit_12x3` | RTLLM | Prob015_multi_pipe_8bit | 3 | 4 | 2 | 0.0000 | 0 |
| `fg_qdm_sr_front_credit_12x3` | RTLLM | Prob015_multi_pipe_8bit | 3 | 5 | 2 | 0.0000 | 0 |
| `fg_qdm_random_front_credit_12x3` | RTLLM | Prob015_multi_pipe_8bit | 3 | 8 | 2 | 0.0000 | 0 |
| `classic_revolution_12x3` | RTLLM | Prob041_traffic_light | 2 | 27 | 3 | 0.3155 | 22 |
| `fg_qdm_rf_leafid_front_credit_12x3` | RTLLM | Prob041_traffic_light | 2 | 19 | 3 | 0.2331 | 16 |
| `fg_qdm_sr_front_credit_12x3` | RTLLM | Prob041_traffic_light | 2 | 18 | 2 | 0.2330 | 10 |
| `fg_qdm_random_front_credit_12x3` | RTLLM | Prob041_traffic_light | 2 | 12 | 4 | 0.1384 | 7 |
| `classic_revolution_12x3` | RTLLM | Prob045_alu | 2 | 30 | 1 | 0.2555 | 30 |
| `fg_qdm_rf_leafid_front_credit_12x3` | RTLLM | Prob045_alu | 2 | 20 | 1 | 0.2366 | 20 |
| `fg_qdm_sr_front_credit_12x3` | RTLLM | Prob045_alu | 2 | 18 | 1 | 0.2272 | 18 |
| `fg_qdm_random_front_credit_12x3` | RTLLM | Prob045_alu | 2 | 14 | 2 | 0.1760 | 14 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob015_multi_pipe_8bit | [pairwise_fronts.png](problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png) |
| RTLLM | Prob041_traffic_light | [pairwise_fronts.png](problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png) | n/a |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
