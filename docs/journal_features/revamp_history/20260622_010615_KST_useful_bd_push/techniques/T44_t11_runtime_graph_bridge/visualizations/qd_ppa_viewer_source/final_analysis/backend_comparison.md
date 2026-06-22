# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Valid PPA samples count generated samples with PPA metrics even when QD warmup or archive insertion later drops them.
When the final population has no retained PPA aggregate, Score/PPA deltas use the best generated valid PPA sample.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 405414.67 ± 56780.53 | 96.00 | 96.00 |
| `classic` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 405414.67 ± 56780.53 | 96.00 | 96.00 |
| `t11_runtime_top8_graph_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 410681.33 ± 46291.05 | 96.00 | 96.00 |
| `t11_runtime_top8_graph_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 410681.33 ± 46291.05 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (33.3%) | ✅ Pass (33.3%) | 16 | +3.79% ✅ | +33.78% ✅ / -1.67% ❌ / -20.73% ❌ | +3.79% ✅ | 592.38 | 96 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (35.4%) | ✅ Pass (27.1%) | 13 | +11.64% ✅ | +39.69% ✅ / +23.27% ✅ / -28.05% ❌ | +11.64% ✅ | 659.77 | 96 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (52.1%) | ✅ Pass (52.1%) | 25 | +38.91% ✅ | +17.65% ✅ / +99.09% ✅ / N/A | +58.37% ✅ | 643.08 | 96 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (35.4%) | ✅ Pass (14.6%) | 7 | +38.91% ✅ | +17.65% ✅ / +99.09% ✅ / N/A | +58.37% ✅ | 695.84 | 96 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (72.9%) | ✅ Pass (72.9%) | 35 | +41.98% ✅ | +26.70% ✅ / +99.24% ✅ / N/A | +62.97% ✅ | 608.87 | 96 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob045_alu | ✅ Pass (33.3%) | ✅ Pass (33.3%) | 16 | +40.44% ✅ | +22.20% ✅ / +99.13% ✅ / N/A | +60.67% ✅ | 701.54 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 52.8% ± 22.4% | 52.8% ± 22.4% | 3/3 | +28.23% ± 24.01% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (76 samples) | +41.71% ± 37.25% ✅ | +26.04% ± 9.15% ✅ / +65.55% ± 65.88% ✅ / -20.73% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ❌ 1/3 / T ❌ 1/1 | 614.78 ± 29.27 | 96.00 ± 0.00 |
| `t11_runtime_top8_graph_qd` | RTLLM | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 34.7% ± 1.4% | 25.0% ± 10.8% | 3/3 | +30.33% ± 18.34% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (36 samples) | +43.56% ± 31.31% ✅ | +26.51% ± 13.17% ✅ / +73.83% ± 49.55% ✅ / -28.05% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ✅ 0/3 / T ❌ 1/1 | 685.72 ± 25.63 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 52.8% ± 22.4% | 52.8% ± 22.4% | 3/3 | +28.23% ± 24.01% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (76 samples) | +41.71% ± 37.25% ✅ | +26.04% ± 9.15% ✅ / +65.55% ± 65.88% ✅ / -20.73% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ❌ 1/3 / T ❌ 1/1 | 614.78 ± 29.27 | 96.00 ± 0.00 |
| `t11_runtime_top8_graph_qd` | ALL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 34.7% ± 1.4% | 25.0% ± 10.8% | 3/3 | +30.33% ± 18.34% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (36 samples) | +43.56% ± 31.31% ✅ | +26.51% ± 13.17% ✅ / +73.83% ± 49.55% ✅ / -28.05% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ✅ 0/3 / T ❌ 1/1 | 685.72 ± 25.63 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 14 | 6 | 0.0000 | 0 | +36.43% ✅ / -1.45% ❌ / +31.71% ✅ |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 13 | 7 | 0.0001 | 1 | +39.69% ✅ / +23.27% ✅ / +42.68% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 21 | 3 | 0.2264 | 17 | +32.94% ✅ / +99.09% ✅ / N/A |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob041_traffic_light | 2 | 7 | 2 | 0.2424 | 4 | +29.41% ✅ / +99.09% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 32 | 1 | 0.2649 | 32 | +26.70% ✅ / +99.24% ✅ / N/A |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob045_alu | 2 | 14 | 2 | 0.2201 | 14 | +22.20% ✅ / +99.14% ✅ / N/A |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 3 | 3 | 0.1638 ± 0.1620 | 3.33 ± 2.85 | 16.33 ± 18.12 | 1 |
| `t11_runtime_top8_graph_qd` | RTLLM | 3 | 3 | 0.1542 ± 0.1515 | 3.67 ± 3.27 | 6.33 ± 7.70 | 2 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 3 | 3 | 0.1638 ± 0.1620 | 3.33 ± 2.85 | 16.33 ± 18.12 | 1 |
| `t11_runtime_top8_graph_qd` | ALL | 3 | 3 | 0.1542 ± 0.1515 | 3.67 ± 3.27 | 6.33 ± 7.70 | 2 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `t11_runtime_top8_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 0.0% | -0.9638 | 0.1164 | 11/65536 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 0.0% | 0.7069 | 0.3891 | 7/65536 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob045_alu | grid_quantile | 0.0% | 3.0623 | 0.4044 | 8/65536 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `t11_runtime_top8_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | t11_runtime_top8_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count, hyper_fanout_entropy, hyper_driven_net_count, hyper_sink_net_count, log_net_count | 13 | 12 | init=warmup_complete, shape=4x4x4x4x4x4x4x4 | none | live filled_empty=7, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob041_traffic_light | t11_runtime_top8_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count, hyper_fanout_entropy, hyper_driven_net_count, hyper_sink_net_count, log_net_count | 7 | 7 | init=warmup_complete, shape=4x4x4x4x4x4x4x4 | none | live filled_empty=3, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top8_graph_qd` | RTLLM | Prob045_alu | t11_runtime_top8_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count, hyper_fanout_entropy, hyper_driven_net_count, hyper_sink_net_count, log_net_count | 16 | 11 | init=warmup_complete, shape=4x4x4x4x4x4x4x4 | none | live crowding_evicted=2, duplicate_objectives=2, filled_empty=4, pareto_inserted=4, warmup_buffered=4; replay filled_empty=4 |
