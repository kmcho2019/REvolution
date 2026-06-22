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
| `classic` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 398516.33 ± 49475.45 | 96.00 | 96.00 |
| `classic` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 398516.33 ± 49475.45 | 96.00 | 96.00 |
| `t11_runtime_top4_graph_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 411168.00 ± 56983.73 | 96.00 | 96.00 |
| `t11_runtime_top4_graph_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 411168.00 ± 56983.73 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (39.6%) | ✅ Pass (39.6%) | 19 | +14.55% ✅ | +26.53% ✅ / +37.86% ✅ / -20.73% ❌ | +14.55% ✅ | 550.43 | 96 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (27.1%) | ✅ Pass (22.9%) | 11 | +7.10% ✅ | +35.10% ✅ / +9.35% ✅ / -23.17% ❌ | +7.10% ✅ | 648.21 | 96 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (54.2%) | ✅ Pass (50.0%) | 24 | +45.08% ✅ | +36.47% ✅ / +98.78% ✅ / N/A | +67.63% ✅ | 595.05 | 96 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (45.8%) | ✅ Pass (35.4%) | 17 | +42.09% ✅ | +27.06% ✅ / +99.20% ✅ / N/A | +63.13% ✅ | 701.68 | 96 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 18 | +40.74% ✅ | +23.06% ✅ / +99.17% ✅ / N/A | +61.11% ✅ | 594.33 | 96 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob045_alu | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +40.66% ✅ | +22.83% ✅ / +99.16% ✅ / N/A | +60.99% ✅ | 717.97 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 43.8% ± 10.3% | 42.4% ± 7.6% | 3/3 | +33.46% ± 18.69% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (61 samples) | +47.76% ± 32.75% ✅ | +28.69% ± 7.88% ✅ / +78.61% ± 39.93% ✅ / -20.73% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ✅ 0/3 / T ❌ 1/1 | 579.94 ± 28.92 | 96.00 ± 0.00 |
| `t11_runtime_top4_graph_qd` | RTLLM | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 33.3% ± 12.2% | 28.5% ± 7.2% | 3/3 | +29.95% ± 22.41% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (41 samples) | +43.74% ± 35.93% ✅ | +28.33% ± 7.05% ✅ / +69.24% ± 58.69% ✅ / -23.17% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ✅ 0/3 / T ❌ 1/1 | 689.29 ± 41.30 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 43.8% ± 10.3% | 42.4% ± 7.6% | 3/3 | +33.46% ± 18.69% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (61 samples) | +47.76% ± 32.75% ✅ | +28.69% ± 7.88% ✅ / +78.61% ± 39.93% ✅ / -20.73% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ✅ 0/3 / T ❌ 1/1 | 579.94 ± 28.92 | 96.00 ± 0.00 |
| `t11_runtime_top4_graph_qd` | ALL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 33.3% ± 12.2% | 28.5% ± 7.2% | 3/3 | +29.95% ± 22.41% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (41 samples) | +43.74% ± 35.93% ✅ | +28.33% ± 7.05% ✅ / +69.24% ± 58.69% ✅ / -23.17% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ✅ 0/3 / T ❌ 1/1 | 689.29 ± 41.30 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 6 | 0.0000 | 0 | +38.78% ✅ / +37.86% ✅ / +40.24% ✅ |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 6 | 0.0000 | 0 | +35.82% ✅ / +9.35% ✅ / +36.59% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 23 | 3 | 0.3843 | 12 | +40.00% ✅ / +98.79% ✅ / N/A |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3062 | 13 | +32.94% ✅ / +99.20% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 18 | 2 | 0.2287 | 18 | +23.06% ✅ / +99.20% ✅ / N/A |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob045_alu | 2 | 13 | 2 | 0.2264 | 13 | +22.83% ✅ / +99.17% ✅ / N/A |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 3 | 3 | 0.2043 ± 0.2187 | 3.67 ± 2.36 | 10.00 ± 10.37 | 3 |
| `t11_runtime_top4_graph_qd` | RTLLM | 3 | 3 | 0.1775 ± 0.1797 | 3.33 ± 2.61 | 8.67 ± 8.49 | 0 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 3 | 3 | 0.2043 ± 0.2187 | 3.67 ± 2.36 | 10.00 ± 10.37 | 3 |
| `t11_runtime_top4_graph_qd` | ALL | 3 | 3 | 0.1775 ± 0.1797 | 3.33 ± 2.61 | 8.67 ± 8.49 | 0 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `t11_runtime_top4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 3.5% | -0.7058 | 0.0710 | 9/256 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 3.1% | 2.1931 | 0.4209 | 8/256 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob045_alu | grid_quantile | 2.7% | 2.6927 | 0.4066 | 7/256 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `t11_runtime_top4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 11 | 10 | init=warmup_complete, shape=4x4x4x4 | none | live duplicate_objectives=1, filled_empty=5, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob041_traffic_light | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 17 | 10 | init=warmup_complete, shape=4x4x4x4 | none | live crowding_evicted=1, duplicate_objectives=2, filled_empty=5, pareto_inserted=4, replaced_elite=1, warmup_buffered=4; replay filled_empty=3, pareto_inserted=1 |
| `t11_runtime_top4_graph_qd` | RTLLM | Prob045_alu | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 13 | 12 | init=warmup_complete, shape=4x4x4x4 | none | live crowding_evicted=1, filled_empty=4, replaced_elite=4, warmup_buffered=4; replay filled_empty=3, pareto_inserted=1 |
