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
| `source_aligned_rtl_cell_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 323363.85 ± 37723.88 | 96.00 | 96.00 |
| `source_aligned_rtl_cell_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 300495.14 ± 59187.31 | 96.00 | 96.00 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 350044.00 ± 38470.54 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic_revolution` | RTLLM | Prob004_adder_8bit | ✅ Pass (60.4%) | ✅ Pass (58.3%) | 28 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 716.70 | 96 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (68.8%) | ✅ Pass (68.8%) | 33 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 536.06 | 96 |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +13.52% ✅ | +28.98% ✅ / +38.42% ✅ / -26.83% ❌ | +13.52% ✅ | 1055.42 | 96 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (16.7%) | ✅ Pass (16.7%) | 8 | +23.58% ✅ | +39.90% ✅ / +54.01% ✅ / -23.17% ❌ | +23.58% ✅ | 1174.49 | 96 |
| `classic_revolution` | RTLLM | Prob024_fsm | ✅ Pass (39.6%) | ✅ Pass (33.3%) | 16 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 793.04 | 96 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob024_fsm | ✅ Pass (47.9%) | ✅ Pass (41.7%) | 20 | +54.86% ✅ | +36.96% ✅ / +48.63% ✅ / N/A | +42.79% ✅ | 920.67 | 96 |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | ✅ Pass (43.8%) | ✅ Pass (37.5%) | 18 | +8.46% ✅ | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ | +8.46% ✅ | 973.47 | 96 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (39.6%) | ✅ Pass (39.6%) | 19 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1195.73 | 96 |
| `classic_revolution` | RTLLM | Prob041_traffic_light | ✅ Pass (43.8%) | ✅ Pass (41.7%) | 20 | +41.68% ✅ | +25.88% ✅ / +99.15% ✅ / N/A | +62.52% ✅ | 1073.82 | 96 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 18 | +39.93% ✅ | +20.59% ✅ / +99.21% ✅ / N/A | +59.90% ✅ | 1415.66 | 96 |
| `classic_revolution` | RTLLM | Prob045_alu | ✅ Pass (22.9%) | ✅ Pass (20.8%) | 10 | +39.46% ✅ | +19.19% ✅ / +99.19% ✅ / N/A | +59.19% ✅ | 1086.16 | 96 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob045_alu | ✅ Pass (25.0%) | ✅ Pass (22.9%) | 11 | +41.65% ✅ | +25.75% ✅ / +99.19% ✅ / N/A | +62.47% ✅ | 1284.98 | 96 |
| `classic_revolution` | RTLLM | Prob049_signal_generator | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 623.45 | 96 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 770.32 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1094.59 | 96 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (47.9%) | ✅ Pass (47.9%) | 23 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1542.49 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +46.44% ✅ | +40.00% ✅ / +99.32% ✅ / N/A | +69.66% ✅ | 1336.20 | 96 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 18 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1621.75 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (77.1%) | ✅ Pass (77.1%) | 37 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1119.47 | 96 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (54.2%) | ✅ Pass (54.2%) | 26 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1452.61 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1038.77 | 96 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (20.8%) | ✅ Pass (20.8%) | 10 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1298.57 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | -36.30% ❌ | -46.97% ❌ / -51.23% ❌ / -10.71% ❌ | -36.30% ❌ | 1216.90 | 96 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | -19.56% ❌ | -18.18% ❌ / -44.07% ❌ / +3.57% ✅ | -19.56% ❌ | 1268.98 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +10.86% ✅ | +5.85% ✅ / +33.41% ✅ / -6.67% ❌ | +10.86% ✅ | 762.36 | 96 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (25.0%) | ✅ Pass (22.9%) | 11 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1438.20 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 39.0% ± 9.2% | 36.3% ± 8.8% | 7/7 | +30.68% ± 11.59% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (122 samples) | +36.92% ± 16.87% ✅ | +18.54% ± 5.86% ✅ / +63.44% ± 25.91% ✅ / -3.83% ± 22.98% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 903.15 ± 140.52 | 96.00 ± 0.00 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.9% ± 22.2% | 46.9% ± 22.2% | 6/6 | +13.59% ± 23.38% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (135 samples) | +22.50% ± 30.50% ✅ | -3.52% ± 23.10% ❌ / +47.18% ± 50.43% ✅ / -8.69% ± 3.97% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 2/2 | 1094.72 ± 154.93 | 96.00 ± 0.00 |
| `source_aligned_rtl_cell_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 43.8% ± 15.2% | 42.6% ± 15.4% | 7/7 | +31.66% ± 13.12% ✅ | ✅ 6 / ➖ 1 / ❌ 0 | 7/7 (143 samples) | +38.49% ± 17.46% ✅ | +21.60% ± 10.36% ✅ / +63.76% ± 27.84% ✅ / -3.85% ± 20.05% ❌ | ✅ 6 / ➖ 1 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1042.56 ± 231.19 | 96.00 ± 0.00 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 31.6% ± 14.9% | 31.3% ± 15.0% | 6/6 | +16.84% ± 18.98% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (90 samples) | +25.77% ± 26.46% ✅ | +1.60% ± 17.44% ✅ / +48.12% ± 48.78% ✅ / +2.45% ± 2.19% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 1437.10 ± 109.07 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 42.6% ± 11.1% | 41.2% ± 11.2% | 13/13 | +22.79% ± 12.83% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (257 samples) | +30.27% ± 16.49% ✅ | +8.36% ± 12.27% ✅ / +55.93% ± 26.28% ✅ / -5.78% ± 12.86% ❌ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 3/5 | 991.57 ± 113.36 | 96.00 ± 0.00 |
| `source_aligned_rtl_cell_qd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 38.1% ± 10.8% | 37.3% ± 10.8% | 13/13 | +24.82% ± 11.54% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (233 samples) | +32.62% ± 15.15% ✅ | +12.37% ± 10.92% ✅ / +56.54% ± 26.19% ✅ / -1.33% ± 11.41% ❌ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 1/5 | 1224.65 ± 170.48 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic_revolution` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 | +15.22% ✅ / +99.25% ✅ / N/A |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 9 | 0.0000 | 0 | +38.78% ✅ / +38.42% ✅ / +39.02% ✅ |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 7 | 1 | 0.0000 | 0 | +39.90% ✅ / +54.01% ✅ / -23.17% ❌ |
| `classic_revolution` | RTLLM | Prob024_fsm | 2 | 11 | 2 | 0.1449 | 8 | +36.96% ✅ / +46.33% ✅ / N/A |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.1797 | 6 | +36.96% ✅ / +48.63% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0003 | 1 | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob037_parallel2serial | 3 | 3 | 2 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +3.70% ✅ |
| `classic_revolution` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3067 | 14 | +32.94% ✅ / +99.15% ✅ / N/A |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob041_traffic_light | 2 | 12 | 1 | 0.2043 | 10 | +20.59% ✅ / +99.21% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1904 | 9 | +19.19% ✅ / +99.19% ✅ / N/A |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob045_alu | 2 | 11 | 1 | 0.2554 | 11 | +25.75% ✅ / +99.19% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0128 | 3 | +22.34% ✅ / +46.04% ✅ / +16.28% ✅ |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.3975 | 5 | +40.00% ✅ / +99.41% ✅ / N/A |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 2 | 1 | 0.3984 | 2 | +40.00% ✅ / +99.61% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +98.91% ✅ / N/A |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +98.91% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 2 | 0.0000 | 0 | -46.97% ❌ / -51.23% ❌ / -3.57% ❌ |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 1 | 0.0000 | 0 | -18.18% ❌ / -44.07% ❌ / +3.57% ✅ |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0002 | 1 | +5.85% ✅ / +33.41% ✅ / +9.33% ✅ |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 4 | 0.0003 | 3 | +9.75% ✅ / +34.32% ✅ / +10.67% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution` | RTLLM | 7 | 7 | 0.1152 ± 0.0863 | 2.71 ± 2.13 | 5.29 ± 3.82 | 5 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0663 ± 0.1298 | 1.83 ± 0.94 | 1.50 ± 1.50 | 4 |
| `source_aligned_rtl_cell_qd` | RTLLM | 7 | 7 | 0.1139 ± 0.0808 | 1.14 ± 0.28 | 4.14 ± 3.56 | 2 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0665 ± 0.1301 | 1.50 ± 0.98 | 1.33 ± 0.97 | 2 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution` | ALL | 13 | 13 | 0.0926 ± 0.0737 | 2.31 ± 1.20 | 3.54 ± 2.34 | 9 |
| `source_aligned_rtl_cell_qd` | ALL | 13 | 13 | 0.0920 ± 0.0721 | 1.31 ± 0.46 | 2.85 ± 2.06 | 4 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `source_aligned_rtl_cell_qd` | RTLLM | Prob004_adder_8bit | grid | 6.2% | 0.3815 | 0.3815 | 1/16 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | grid | 6.2% | 0.2358 | 0.2358 | 1/16 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob024_fsm | grid | 6.2% | 0.5486 | 0.5486 | 1/16 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob037_parallel2serial | grid | 6.2% | 0.0000 | -0.0000 | 1/16 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob041_traffic_light | grid | 6.2% | 0.3993 | 0.3993 | 1/16 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob045_alu | grid | 6.2% | 0.4165 | 0.4165 | 1/16 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob049_signal_generator | grid | 12.5% | 0.4695 | 0.2348 | 2/16 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid | 6.2% | 0.0120 | 0.0120 | 1/16 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid | 6.2% | 0.4654 | 0.4654 | 1/16 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid | 6.2% | 0.2636 | 0.2636 | 1/16 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid | 6.2% | 0.3297 | 0.3297 | 1/16 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid | 6.2% | -0.1956 | -0.1956 | 1/16 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid | 6.2% | 0.1356 | 0.1356 | 1/16 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `source_aligned_rtl_cell_qd` | RTLLM | Prob004_adder_8bit | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 33 | 1 | N/A | rtltimer_state_timing_class | live duplicate_objectives=32, filled_empty=1 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 8 | 2 | N/A | rtltimer_state_timing_class | live crowding_evicted=3, filled_empty=1, pareto_inserted=2, replaced_elite=2 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob024_fsm | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 20 | 2 | N/A | rtltimer_state_timing_class | live crowding_evicted=11, duplicate_objectives=4, filled_empty=1, pareto_inserted=1, replaced_elite=3 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob037_parallel2serial | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 19 | 2 | N/A | rtltimer_state_timing_class | live crowding_evicted=1, duplicate_objectives=16, filled_empty=1, pareto_inserted=1 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob041_traffic_light | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 18 | 2 | N/A | rtltimer_state_timing_class | live crowding_evicted=9, duplicate_objectives=3, filled_empty=1, pareto_inserted=2, replaced_elite=3 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob045_alu | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 11 | 2 | N/A | rtltimer_state_timing_class | live crowding_evicted=6, filled_empty=1, pareto_inserted=2, replaced_elite=2 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob049_signal_generator | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 34 | 2 | N/A | rtltimer_state_timing_class | live duplicate_objectives=32, filled_empty=2 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 23 | 2 | N/A | masterrtl_operator_log_edges, rtltimer_state_timing_class | live duplicate_objectives=21, filled_empty=1, pareto_inserted=1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 18 | 2 | N/A | rtltimer_state_timing_class | live duplicate_objectives=16, filled_empty=1, pareto_inserted=1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 26 | 2 | N/A | rtltimer_state_timing_class | live duplicate_objectives=24, filled_empty=1, replaced_elite=1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 10 | 2 | N/A | masterrtl_operator_log_edges, rtltimer_state_timing_class | live duplicate_objectives=7, filled_empty=1, pareto_inserted=2 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 2 | 2 | N/A | rtltimer_state_timing_class | live filled_empty=1, pareto_inserted=1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 11 | 2 | N/A | rtltimer_state_timing_class | live crowding_evicted=7, duplicate_objectives=1, filled_empty=1, pareto_inserted=1, replaced_elite=1 |
