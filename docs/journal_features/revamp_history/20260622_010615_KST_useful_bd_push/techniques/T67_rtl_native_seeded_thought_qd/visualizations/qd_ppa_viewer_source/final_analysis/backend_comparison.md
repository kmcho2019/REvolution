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
| `classic` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 326234.92 ± 36801.68 | 96.00 | 96.00 |
| `classic` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 319848.86 ± 59618.09 | 96.00 | 96.00 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 333685.33 ± 44580.75 | 96.00 | 96.00 |
| `rtl_native_seeded_thought_qd` | ALL | unspecified | 48 | N/A | 112.15 ± 0.20 | 349596.00 ± 38134.80 | 121.50 | 121.50 |
| `rtl_native_seeded_thought_qd` | RTLLM | unspecified | 48 | N/A | 112.00 ± 0.00 | 345382.57 ± 64120.42 | 112.00 | 112.00 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 112.33 ± 0.41 | 354511.67 ± 42091.45 | 134.80 | 134.80 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (60.4%) | ✅ Pass (58.3%) | 28 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 716.70 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 1788.75 | 112 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +13.52% ✅ | +28.98% ✅ / +38.42% ✅ / -26.83% ❌ | +13.52% ✅ | 1055.42 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (68.8%) | ✅ Pass (68.8%) | 33 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 2740.65 | 112 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (39.6%) | ✅ Pass (33.3%) | 16 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 793.04 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob024_fsm | ✅ Pass (47.9%) | ✅ Pass (45.8%) | 22 | +49.17% ✅ | +21.74% ✅ / +46.76% ✅ / N/A | +34.25% ✅ | 2100.10 | 112 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (43.8%) | ✅ Pass (37.5%) | 18 | +8.46% ✅ | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ | +8.46% ✅ | 973.47 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 18 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 2249.26 | 112 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (43.8%) | ✅ Pass (41.7%) | 20 | +41.68% ✅ | +25.88% ✅ / +99.15% ✅ / N/A | +62.52% ✅ | 1073.82 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 2688.96 | 112 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (22.9%) | ✅ Pass (20.8%) | 10 | +39.46% ✅ | +19.19% ✅ / +99.19% ✅ / N/A | +59.19% ✅ | 1086.16 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob045_alu | ✅ Pass (39.6%) | ✅ Pass (39.6%) | 19 | +41.53% ✅ | +25.39% ✅ / +99.19% ✅ / N/A | +62.29% ✅ | 2927.67 | 112 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 623.45 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 1959.38 | 112 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1094.59 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (68.8%) | ✅ Pass (68.8%) | 33 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 2199.28 | 113 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +46.44% ✅ | +40.00% ✅ / +99.32% ✅ / N/A | +69.66% ✅ | 1336.20 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | +46.53% ✅ | +40.00% ✅ / +99.60% ✅ / N/A | +69.80% ✅ | 3148.31 | 112 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (77.1%) | ✅ Pass (77.1%) | 37 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1119.47 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 2777.10 | 112 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1038.77 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (60.4%) | ✅ Pass (60.4%) | 29 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 2517.87 | 112 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | -36.30% ❌ | -46.97% ❌ / -51.23% ❌ / -10.71% ❌ | -36.30% ❌ | 1216.90 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (31.2%) | ✅ Pass (29.2%) | 14 | -12.59% ❌ | -9.09% ❌ / -50.11% ❌ / +21.43% ✅ | -12.59% ❌ | 2709.50 | 112 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +10.86% ✅ | +5.85% ✅ / +33.41% ✅ / -6.67% ❌ | +10.86% ✅ | 762.36 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1545.98 | 113 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 39.0% ± 9.2% | 36.3% ± 8.8% | 7/7 | +30.68% ± 11.59% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (122 samples) | +36.92% ± 16.87% ✅ | +18.54% ± 5.86% ✅ / +63.44% ± 25.91% ✅ / -3.83% ± 22.98% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 903.15 ± 140.52 | 96.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.9% ± 22.2% | 46.9% ± 22.2% | 6/6 | +13.59% ± 23.38% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (135 samples) | +22.50% ± 30.50% ✅ | -3.52% ± 23.10% ❌ / +47.18% ± 50.43% ✅ / -8.69% ± 3.97% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 2/2 | 1094.72 ± 154.93 | 96.00 ± 0.00 |
| `rtl_native_seeded_thought_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 59.2% ± 12.5% | 58.9% ± 12.7% | 7/7 | +28.75% ± 14.17% ✅ | ✅ 6 / ➖ 1 / ❌ 0 | 7/7 (198 samples) | +35.23% ± 19.38% ✅ | +20.54% ± 8.65% ✅ / +56.10% ± 32.76% ✅ / -3.89% ± 22.71% ❌ | ✅ 6 / ➖ 1 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 2350.68 ± 323.11 | 112.00 ± 0.00 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | 6 | ➖ 5/6 (83.3%) | ➖ 5/6 (83.3%) | 37.2% ± 24.0% | 36.8% ± 24.1% | 5/6 | +18.89% ± 21.12% ✅ | ✅ 4 / ➖ 0 / ❌ 1 | 5/6 (106 samples) | +29.60% ± 29.92% ✅ | +2.18% ± 19.89% ✅ / +50.22% ± 61.10% ✅ / +21.43% ± 0.00% ✅ | ✅ 4 / ➖ 0 / ❌ 1 | A ❌ 2/5 / P ❌ 1/5 / T ✅ 0/1 | 2483.01 ± 444.10 | 112.33 ± 0.41 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 42.6% ± 11.1% | 41.2% ± 11.2% | 13/13 | +22.79% ± 12.83% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (257 samples) | +30.27% ± 16.49% ✅ | +8.36% ± 12.27% ✅ / +55.93% ± 26.28% ✅ / -5.78% ± 12.86% ❌ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 3/5 | 991.57 ± 113.36 | 96.00 ± 0.00 |
| `rtl_native_seeded_thought_qd` | ALL | 13 | ➖ 12/13 (92.3%) | ➖ 12/13 (92.3%) | 49.0% ± 13.8% | 48.7% ± 13.9% | 12/13 | +24.65% ± 11.82% ✅ | ✅ 10 / ➖ 1 / ❌ 1 | 12/13 (304 samples) | +32.88% ± 16.06% ✅ | +12.89% ± 10.60% ✅ / +53.65% ± 30.17% ✅ / +2.44% ± 20.29% ✅ | ✅ 10 / ➖ 1 / ❌ 1 | A ❌ 2/12 / P ❌ 1/12 / T ❌ 1/4 | 2411.75 ± 259.67 | 112.15 ± 0.20 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 | +15.22% ✅ / +99.25% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 9 | 0.0000 | 0 | +38.78% ✅ / +38.42% ✅ / +39.02% ✅ |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 13 | 3 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / -10.98% ❌ |
| `classic` | RTLLM | Prob024_fsm | 2 | 11 | 2 | 0.1449 | 8 | +36.96% ✅ / +46.33% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1457 | 4 | +36.96% ✅ / +46.76% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0003 | 1 | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob037_parallel2serial | 3 | 2 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3067 | 14 | +32.94% ✅ / +99.15% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob041_traffic_light | 2 | 23 | 3 | 0.2334 | 19 | +23.53% ✅ / +99.21% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1904 | 9 | +19.19% ✅ / +99.19% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob045_alu | 2 | 11 | 1 | 0.2519 | 11 | +25.39% ✅ / +99.19% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0128 | 3 | +22.34% ✅ / +46.04% ✅ / +16.28% ✅ |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 1 | 0.0123 | 2 | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.3975 | 5 | +40.00% ✅ / +99.41% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 2 | 1 | 0.3984 | 2 | +40.00% ✅ / +99.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +98.91% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 | +0.00% ➖ / +98.91% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 2 | 0.0000 | 0 | -46.97% ❌ / -51.23% ❌ / -3.57% ❌ |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 3 | 2 | 0.0000 | 0 | -9.09% ❌ / -49.89% ❌ / +21.43% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0002 | 1 | +5.85% ✅ / +33.41% ✅ / +9.33% ✅ |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1152 ± 0.0863 | 2.71 ± 2.13 | 5.29 ± 3.82 | 5 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0663 ± 0.1298 | 1.83 ± 0.94 | 1.50 ± 1.50 | 5 |
| `rtl_native_seeded_thought_qd` | RTLLM | 7 | 7 | 0.1135 ± 0.0811 | 1.71 ± 0.70 | 5.29 ± 5.30 | 2 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | 6 | 5 | 0.0664 ± 0.1301 | 1.00 ± 0.51 | 0.67 ± 0.65 | 1 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.0926 ± 0.0737 | 2.31 ± 1.20 | 3.54 ± 2.34 | 10 |
| `rtl_native_seeded_thought_qd` | ALL | 13 | 12 | 0.0917 ± 0.0721 | 1.38 ± 0.47 | 3.15 ± 3.06 | 3 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `rtl_native_seeded_thought_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 100.0% | 0.3815 | 0.3815 | 1/1 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 37.5% | -0.0022 | 0.0528 | 6/16 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob024_fsm | grid_quantile | 31.2% | 2.4281 | 0.4917 | 5/16 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 18.8% | -0.3285 | -0.0000 | 3/16 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 37.5% | 2.0298 | 0.4077 | 6/16 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob045_alu | grid_quantile | 33.3% | 1.2023 | 0.4153 | 3/9 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 33.3% | 0.9681 | 0.2638 | 4/12 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 33.3% | 0.7229 | 0.2636 | 3/9 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 100.0% | 0.3297 | 0.3297 | 1/1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 33.3% | -0.8482 | -0.1259 | 3/9 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `rtl_native_seeded_thought_qd` | RTLLM | Prob004_adder_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 12 | 1 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=12; replay duplicate_objectives=11, filled_empty=1 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob015_multi_pipe_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 13 | 8 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=5, filled_empty=2, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob024_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 12 | 5 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=5, filled_empty=3, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob037_parallel2serial | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 11 | 3 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=6, filled_empty=1, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob041_traffic_light | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 15 | 8 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=6, filled_empty=2, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob045_alu | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 11 | 5 | init=warmup_complete, shape=3x3 | none | live crowding_evicted=1, duplicate_objectives=2, filled_empty=1, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob049_signal_generator | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 16 | 4 | init=warmup_complete, shape=3x4 | none | live duplicate_objectives=12, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 12 | 2 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=12; replay duplicate_objectives=10, filled_empty=1, pareto_inserted=1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 2 | 0 | init=pending | none | live warmup_buffered=2 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 14 | 4 | init=warmup_complete, shape=3x3 | none | live duplicate_objectives=8, filled_empty=1, pareto_inserted=1, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 13 | 1 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=13; replay duplicate_objectives=12, filled_empty=1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 10 | 3 | init=warmup_complete, shape=3x3 | none | live duplicate_objectives=5, filled_empty=1, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 0 | 0 | init=pending | none | live N/A |
