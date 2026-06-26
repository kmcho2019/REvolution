# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/tables/smoke_subset.yaml`
- backend_count: `2`
- overall_multi_objective_winner: `classic`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic` | ALL | 3 | 3 | 0.1903 | 3.00 | 17.33 | 3 |
| `classic` | RTLLM | 3 | 3 | 0.1903 | 3.00 | 17.33 | 3 |
| `fg_qdm_sr_memory_warmup4_12x3` | ALL | 3 | 3 | 0.1375 | 2.00 | 9.00 | 0 |
| `fg_qdm_sr_memory_warmup4_12x3` | RTLLM | 3 | 3 | 0.1375 | 2.00 | 9.00 | 0 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 5 | 0.0000 | 0 |
| `fg_qdm_sr_memory_warmup4_12x3` | RTLLM | Prob015_multi_pipe_8bit | 3 | 5 | 1 | 0.0000 | 0 |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 27 | 3 | 0.3155 | 22 |
| `fg_qdm_sr_memory_warmup4_12x3` | RTLLM | Prob041_traffic_light | 2 | 13 | 2 | 0.2273 | 10 |
| `classic` | RTLLM | Prob045_alu | 2 | 30 | 1 | 0.2555 | 30 |
| `fg_qdm_sr_memory_warmup4_12x3` | RTLLM | Prob045_alu | 2 | 19 | 3 | 0.1853 | 17 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob015_multi_pipe_8bit | [pairwise_fronts.png](problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png) |
| RTLLM | Prob041_traffic_light | [pairwise_fronts.png](problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png) | n/a |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
