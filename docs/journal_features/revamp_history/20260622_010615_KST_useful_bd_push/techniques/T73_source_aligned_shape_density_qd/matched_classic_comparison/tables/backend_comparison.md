# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Valid PPA samples count generated samples with PPA metrics even when QD warmup or archive insertion later drops them.
When the final population has no retained PPA aggregate, Score/PPA deltas use the best generated valid PPA sample.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic_revolution` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 326234.92 ± 36801.68 | 96.00 | 96.00 |
| `classic_revolution` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 319848.86 ± 59618.09 | 96.00 | 96.00 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 333685.33 ± 44580.75 | 96.00 | 96.00 |
| `source_aligned_shape_density_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 330297.62 ± 40916.78 | 96.00 | 96.00 |
| `source_aligned_shape_density_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 308883.00 ± 64982.77 | 96.00 | 96.00 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 355281.33 ± 43626.22 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic_revolution` | RTLLM | Prob004_adder_8bit | ✅ Pass (60.4%) | ✅ Pass (58.3%) | 28 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 716.70 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 522.87 | 96 |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +13.52% ✅ | +28.98% ✅ / +38.42% ✅ / -26.83% ❌ | +13.52% ✅ | 1055.42 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (22.9%) | ✅ Pass (20.8%) | 10 | +2.31% ✅ | +36.43% ✅ / -1.45% ❌ / -28.05% ❌ | +2.31% ✅ | 1099.35 | 96 |
| `classic_revolution` | RTLLM | Prob024_fsm | ✅ Pass (39.6%) | ✅ Pass (33.3%) | 16 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 793.04 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob024_fsm | ✅ Pass (52.1%) | ✅ Pass (45.8%) | 22 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 993.94 | 96 |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | ✅ Pass (43.8%) | ✅ Pass (37.5%) | 18 | +8.46% ✅ | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ | +8.46% ✅ | 973.47 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 20 | +9.79% ✅ | +10.00% ✅ / +15.67% ✅ / +3.70% ✅ | +9.79% ✅ | 1291.84 | 96 |
| `classic_revolution` | RTLLM | Prob041_traffic_light | ✅ Pass (43.8%) | ✅ Pass (41.7%) | 20 | +41.68% ✅ | +25.88% ✅ / +99.15% ✅ / N/A | +62.52% ✅ | 1073.82 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +40.38% ✅ | +22.35% ✅ / +98.79% ✅ / N/A | +60.57% ✅ | 1437.87 | 96 |
| `classic_revolution` | RTLLM | Prob045_alu | ✅ Pass (22.9%) | ✅ Pass (20.8%) | 10 | +39.46% ✅ | +19.19% ✅ / +99.19% ✅ / N/A | +59.19% ✅ | 1086.16 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob045_alu | ✅ Pass (45.8%) | ✅ Pass (43.8%) | 21 | +40.70% ✅ | +22.97% ✅ / +99.14% ✅ / N/A | +61.05% ✅ | 1207.72 | 96 |
| `classic_revolution` | RTLLM | Prob049_signal_generator | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 623.45 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (89.6%) | ✅ Pass (89.6%) | 43 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 635.88 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1094.59 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 20 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1427.82 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +46.44% ✅ | +40.00% ✅ / +99.32% ✅ / N/A | +69.66% ✅ | 1336.20 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (64.6%) | ✅ Pass (64.6%) | 31 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1413.47 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (77.1%) | ✅ Pass (77.1%) | 37 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1119.47 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 40 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1199.26 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1038.77 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (29.2%) | ✅ Pass (29.2%) | 14 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 943.82 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | -36.30% ❌ | -46.97% ❌ / -51.23% ❌ / -10.71% ❌ | -36.30% ❌ | 1216.90 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (8.3%) | ✅ Pass (6.2%) | 3 | -12.62% ❌ | -13.64% ❌ / -49.22% ❌ / +25.00% ✅ | -12.62% ❌ | 1277.56 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +10.86% ✅ | +5.85% ✅ / +33.41% ✅ / -6.67% ❌ | +10.86% ✅ | 762.36 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (31.2%) | ✅ Pass (27.1%) | 13 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1182.93 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 39.0% ± 9.2% | 36.3% ± 8.8% | 7/7 | +30.68% ± 11.59% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (122 samples) | +36.92% ± 16.87% ✅ | +18.54% ± 5.86% ✅ / +63.44% ± 25.91% ✅ / -3.83% ± 22.98% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 903.15 ± 140.52 | 96.00 ± 0.00 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.9% ± 22.2% | 46.9% ± 22.2% | 6/6 | +13.59% ± 23.38% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (135 samples) | +22.50% ± 30.50% ✅ | -3.52% ± 23.10% ❌ / +47.18% ± 50.43% ✅ / -8.69% ± 3.97% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 2/2 | 1094.72 ± 154.93 | 96.00 ± 0.00 |
| `source_aligned_shape_density_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 53.0% ± 16.5% | 51.5% ± 17.1% | 7/7 | +29.68% ± 13.10% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (173 samples) | +35.91% ± 18.15% ✅ | +21.12% ± 6.06% ✅ / +57.68% ± 31.23% ✅ / -3.46% ± 24.78% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ❌ 1/7 / T ❌ 1/3 | 1027.07 ± 250.32 | 96.00 ± 0.00 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 43.1% ± 21.5% | 42.0% ± 22.3% | 6/6 | +18.00% ± 17.34% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (121 samples) | +26.92% ± 24.99% ✅ | +2.36% ± 16.83% ✅ / +47.26% ± 50.04% ✅ / +13.17% ± 23.19% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 1240.81 ± 142.88 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 42.6% ± 11.1% | 41.2% ± 11.2% | 13/13 | +22.79% ± 12.83% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (257 samples) | +30.27% ± 16.49% ✅ | +8.36% ± 12.27% ✅ / +55.93% ± 26.28% ✅ / -5.78% ± 12.86% ❌ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 3/5 | 991.57 ± 113.36 | 96.00 ± 0.00 |
| `source_aligned_shape_density_qd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 48.4% ± 13.1% | 47.1% ± 13.5% | 13/13 | +24.29% ± 10.72% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (294 samples) | +31.76% ± 14.67% ✅ | +12.46% ± 9.61% ✅ / +52.87% ± 27.44% ✅ / +3.19% ± 17.37% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 2/13 / T ❌ 1/5 | 1125.72 ± 156.30 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic_revolution` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 | +15.22% ✅ / +99.25% ✅ / N/A |
| `source_aligned_shape_density_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 9 | 0.0000 | 0 | +38.78% ✅ / +38.42% ✅ / +39.02% ✅ |
| `source_aligned_shape_density_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 8 | 3 | 0.0000 | 0 | +36.43% ✅ / -1.45% ❌ / -23.17% ❌ |
| `classic_revolution` | RTLLM | Prob024_fsm | 2 | 11 | 2 | 0.1449 | 8 | +36.96% ✅ / +46.33% ✅ / N/A |
| `source_aligned_shape_density_qd` | RTLLM | Prob024_fsm | 2 | 9 | 2 | 0.1456 | 6 | +36.96% ✅ / +46.62% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0003 | 1 | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `source_aligned_shape_density_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 1 | 0.0006 | 1 | +10.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `classic_revolution` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3067 | 14 | +32.94% ✅ / +99.15% ✅ / N/A |
| `source_aligned_shape_density_qd` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.2214 | 8 | +22.35% ✅ / +99.09% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1904 | 9 | +19.19% ✅ / +99.19% ✅ / N/A |
| `source_aligned_shape_density_qd` | RTLLM | Prob045_alu | 2 | 21 | 1 | 0.2277 | 21 | +22.97% ✅ / +99.14% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0128 | 3 | +22.34% ✅ / +46.04% ✅ / +16.28% ✅ |
| `source_aligned_shape_density_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 1 | 0.0123 | 2 | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.3975 | 5 | +40.00% ✅ / +99.41% ✅ / N/A |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 | +40.00% ✅ / +99.61% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +98.91% ✅ / N/A |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 | +0.00% ➖ / +98.91% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 2 | 0.0000 | 0 | -46.97% ❌ / -51.23% ❌ / -3.57% ❌ |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 3 | 1 | 0.0000 | 0 | -13.64% ❌ / -49.22% ❌ / +25.00% ✅ |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0002 | 1 | +5.85% ✅ / +33.41% ✅ / +9.33% ✅ |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 3 | 0.0003 | 3 | +8.96% ✅ / +31.58% ✅ / +6.67% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution` | RTLLM | 7 | 7 | 0.1152 ± 0.0863 | 2.71 ± 2.13 | 5.29 ± 3.82 | 4 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0663 ± 0.1298 | 1.83 ± 0.94 | 1.50 ± 1.50 | 4 |
| `source_aligned_shape_density_qd` | RTLLM | 7 | 7 | 0.1084 ± 0.0758 | 1.57 ± 0.58 | 5.57 ± 5.49 | 3 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0665 ± 0.1301 | 1.33 ± 0.65 | 1.50 ± 1.31 | 2 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution` | ALL | 13 | 13 | 0.0926 ± 0.0737 | 2.31 ± 1.20 | 3.54 ± 2.34 | 8 |
| `source_aligned_shape_density_qd` | ALL | 13 | 13 | 0.0890 ± 0.0703 | 1.46 ± 0.42 | 3.69 ± 3.13 | 5 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `source_aligned_shape_density_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 100.0% | 0.7631 | 0.3815 | 2/2 |
| `source_aligned_shape_density_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 10.9% | -0.9802 | 0.0231 | 7/64 |
| `source_aligned_shape_density_qd` | RTLLM | Prob024_fsm | grid_quantile | 16.7% | 2.5421 | 0.5002 | 6/36 |
| `source_aligned_shape_density_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 18.5% | 0.0979 | 0.0979 | 5/27 |
| `source_aligned_shape_density_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 20.3% | 2.7015 | 0.4038 | 13/64 |
| `source_aligned_shape_density_qd` | RTLLM | Prob045_alu | grid_quantile | 56.2% | 3.4604 | 0.4070 | 9/16 |
| `source_aligned_shape_density_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 25.0% | 0.4986 | 0.2638 | 2/8 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 50.0% | 0.0120 | 0.0120 | 2/4 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 37.5% | 2.3846 | 0.4654 | 6/16 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 50.0% | 0.4598 | 0.2636 | 2/4 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 66.7% | 0.6594 | 0.3297 | 2/3 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 12.5% | 0.2645 | 0.1356 | 8/64 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `source_aligned_shape_density_qd` | RTLLM | Prob004_adder_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 36 | 2 | init=run_finalization_fallback, shape=1x2x1 | source_aligned_masterrtl_branching, source_aligned_rtltimer_dff_density | live warmup_buffered=36; replay duplicate_objectives=34, filled_empty=2 |
| `source_aligned_shape_density_qd` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 10 | 9 | init=warmup_complete, shape=4x4x4 | none | live filled_empty=3, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `source_aligned_shape_density_qd` | RTLLM | Prob024_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 22 | 8 | init=warmup_complete, shape=4x3x3 | none | live duplicate_objectives=11, filled_empty=3, pareto_inserted=2, replaced_elite=2, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `source_aligned_shape_density_qd` | RTLLM | Prob037_parallel2serial | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 20 | 7 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=12, filled_empty=2, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `source_aligned_shape_density_qd` | RTLLM | Prob041_traffic_light | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 21 | 15 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=5, filled_empty=9, pareto_inserted=2, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `source_aligned_shape_density_qd` | RTLLM | Prob045_alu | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 21 | 15 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live crowding_evicted=2, filled_empty=5, pareto_inserted=5, replaced_elite=5, warmup_buffered=4; replay filled_empty=4 |
| `source_aligned_shape_density_qd` | RTLLM | Prob049_signal_generator | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 43 | 3 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=31, replaced_elite=1, warmup_buffered=11; replay duplicate_objectives=9, filled_empty=2 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 20 | 2 | init=warmup_complete, shape=1x2x2 | source_aligned_masterrtl_branching | live duplicate_objectives=15, warmup_buffered=5; replay duplicate_objectives=3, filled_empty=2 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 31 | 6 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=25, filled_empty=2, warmup_buffered=4; replay filled_empty=4 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 40 | 3 | init=warmup_complete, shape=2x2x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=33, filled_empty=1, warmup_buffered=6; replay duplicate_objectives=4, filled_empty=1, pareto_inserted=1 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 14 | 2 | init=run_finalization_fallback, shape=1x3x1 | source_aligned_masterrtl_branching, source_aligned_rtltimer_dff_density | live warmup_buffered=14; replay duplicate_objectives=12, filled_empty=2 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 3 | 0 | init=pending | none | live warmup_buffered=3 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 13 | 13 | init=warmup_complete, shape=4x4x4 | none | live filled_empty=4, pareto_inserted=2, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
