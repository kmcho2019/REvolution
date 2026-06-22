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
| `classic` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 407556.67 ± 31532.30 | 96.00 | 96.00 |
| `classic` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 407556.67 ± 31532.30 | 96.00 | 96.00 |
| `t11_runtime_pca4_graph_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 410574.67 ± 34318.76 | 96.00 | 96.00 |
| `t11_runtime_pca4_graph_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 410574.67 ± 34318.76 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (31.2%) | ✅ Pass (31.2%) | 15 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 663.88 | 96 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (29.2%) | ✅ Pass (27.1%) | 13 | +5.36% ✅ | -16.53% ❌ / +4.57% ✅ / +28.05% ✅ | +5.36% ✅ | 674.51 | 96 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (33.3%) | ✅ Pass (33.3%) | 16 | +42.48% ✅ | +28.24% ✅ / +99.20% ✅ / N/A | +63.72% ✅ | 611.98 | 96 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (25.0%) | ✅ Pass (18.8%) | 9 | +37.74% ✅ | +14.12% ✅ / +99.09% ✅ / N/A | +56.61% ✅ | 740.03 | 96 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (47.9%) | ✅ Pass (47.9%) | 23 | +39.66% ✅ | +19.78% ✅ / +99.19% ✅ / N/A | +59.48% ✅ | 532.79 | 96 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob045_alu | ✅ Pass (33.3%) | ✅ Pass (31.2%) | 15 | +39.94% ✅ | +20.63% ✅ / +99.20% ✅ / N/A | +59.91% ✅ | 743.82 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 37.5% ± 10.3% | 37.5% ± 10.3% | 3/3 | +29.14% ± 23.44% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (54 samples) | +42.83% ± 36.88% ✅ | +28.93% ± 10.77% ✅ / +67.02% ± 63.06% ✅ / -25.61% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ✅ 0/3 / T ❌ 1/1 | 602.88 ± 74.70 | 96.00 ± 0.00 |
| `t11_runtime_pca4_graph_qd` | RTLLM | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 29.2% ± 4.7% | 25.7% ± 7.2% | 3/3 | +27.68% ± 21.91% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (37 samples) | +40.63% ± 34.61% ✅ | +6.07% ± 22.45% ✅ / +67.62% ± 61.79% ✅ / +28.05% ± 0.00% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ✅ 0/1 | 719.45 ± 44.10 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 37.5% ± 10.3% | 37.5% ± 10.3% | 3/3 | +29.14% ± 23.44% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (54 samples) | +42.83% ± 36.88% ✅ | +28.93% ± 10.77% ✅ / +67.02% ± 63.06% ✅ / -25.61% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ✅ 0/3 / T ❌ 1/1 | 602.88 ± 74.70 | 96.00 ± 0.00 |
| `t11_runtime_pca4_graph_qd` | ALL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 29.2% ± 4.7% | 25.7% ± 7.2% | 3/3 | +27.68% ± 21.91% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (37 samples) | +40.63% ± 34.61% ✅ | +6.07% ± 22.45% ✅ / +67.62% ± 61.79% ✅ / +28.05% ± 0.00% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ✅ 0/1 | 719.45 ± 44.10 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 12 | 6 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / +36.59% ✅ |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 6 | 0.0000 | 0 | +38.78% ✅ / +4.57% ✅ / +36.59% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 13 | 1 | 0.2801 | 12 | +28.24% ✅ / +99.20% ✅ / N/A |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob041_traffic_light | 2 | 8 | 2 | 0.1419 | 6 | +14.71% ✅ / +99.09% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 21 | 1 | 0.1962 | 21 | +19.78% ✅ / +99.19% ✅ / N/A |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob045_alu | 2 | 15 | 1 | 0.2046 | 15 | +20.63% ✅ / +99.20% ✅ / N/A |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 3 | 3 | 0.1588 ± 0.1627 | 2.67 ± 3.27 | 11.00 ± 11.92 | 2 |
| `t11_runtime_pca4_graph_qd` | RTLLM | 3 | 3 | 0.1155 ± 0.1186 | 3.00 ± 2.99 | 7.00 ± 8.54 | 1 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 3 | 3 | 0.1588 ± 0.1627 | 2.67 ± 3.27 | 11.00 ± 11.92 | 2 |
| `t11_runtime_pca4_graph_qd` | ALL | 3 | 3 | 0.1155 ± 0.1186 | 3.00 ± 2.99 | 7.00 ± 8.54 | 1 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 2.7% | -0.0651 | 0.0536 | 7/256 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 2.3% | 0.9878 | 0.3774 | 6/256 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob045_alu | grid_quantile | 3.9% | 3.8638 | 0.3994 | 10/256 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob015_multi_pipe_8bit | t11_runtime_pca4_graph | t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3 | 13 | 8 | init=warmup_complete, shape=4x4x4x4 | none | live crowding_evicted=4, filled_empty=3, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob041_traffic_light | t11_runtime_pca4_graph | t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3 | 9 | 8 | init=warmup_complete, shape=4x4x4x4 | none | live duplicate_objectives=1, filled_empty=2, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_pca4_graph_qd` | RTLLM | Prob045_alu | t11_runtime_pca4_graph | t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3 | 15 | 15 | init=warmup_complete, shape=4x4x4x4 | none | live filled_empty=6, pareto_inserted=2, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
