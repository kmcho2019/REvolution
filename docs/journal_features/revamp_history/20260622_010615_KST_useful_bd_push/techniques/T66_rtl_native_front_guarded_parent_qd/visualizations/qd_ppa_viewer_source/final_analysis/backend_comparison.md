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
| `rtl_native_front_guarded_parent_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 332907.85 ± 38699.56 | 96.00 | 96.00 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 311332.86 ± 63062.93 | 96.00 | 96.00 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 358078.67 ± 36277.78 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (60.4%) | ✅ Pass (58.3%) | 28 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 716.70 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (72.9%) | ✅ Pass (72.9%) | 35 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 535.21 | 96 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +13.52% ✅ | +28.98% ✅ / +38.42% ✅ / -26.83% ❌ | +13.52% ✅ | 1055.42 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (43.8%) | ✅ Pass (41.7%) | 20 | +24.34% ✅ | +37.96% ✅ / +59.47% ✅ / -24.39% ❌ | +24.34% ✅ | 937.84 | 96 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (39.6%) | ✅ Pass (33.3%) | 16 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 793.04 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob024_fsm | ✅ Pass (47.9%) | ✅ Pass (39.6%) | 19 | +47.01% ✅ | +36.96% ✅ / +29.06% ✅ / N/A | +33.01% ✅ | 887.52 | 96 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (43.8%) | ✅ Pass (37.5%) | 18 | +8.46% ✅ | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ | +8.46% ✅ | 973.47 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (45.8%) | ✅ Pass (43.8%) | 21 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1010.87 | 96 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (43.8%) | ✅ Pass (41.7%) | 20 | +41.68% ✅ | +25.88% ✅ / +99.15% ✅ / N/A | +62.52% ✅ | 1073.82 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (52.1%) | ✅ Pass (50.0%) | 24 | +39.93% ✅ | +20.59% ✅ / +99.21% ✅ / N/A | +59.90% ✅ | 1270.30 | 96 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (22.9%) | ✅ Pass (20.8%) | 10 | +39.46% ✅ | +19.19% ✅ / +99.19% ✅ / N/A | +59.19% ✅ | 1086.16 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob045_alu | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 20 | +39.33% ✅ | +18.88% ✅ / +99.11% ✅ / N/A | +59.00% ✅ | 1152.70 | 96 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 623.45 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 672.94 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1094.59 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (18.8%) | ✅ Pass (18.8%) | 9 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1460.95 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +46.44% ✅ | +40.00% ✅ / +99.32% ✅ / N/A | +69.66% ✅ | 1336.20 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (25.0%) | ✅ Pass (25.0%) | 12 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1398.58 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (77.1%) | ✅ Pass (77.1%) | 37 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1119.47 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (66.7%) | ✅ Pass (66.7%) | 32 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1186.78 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1038.77 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (29.2%) | ✅ Pass (29.2%) | 14 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1106.04 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | -36.30% ❌ | -46.97% ❌ / -51.23% ❌ / -10.71% ❌ | -36.30% ❌ | 1216.90 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (4.2%) | ✅ Pass (2.1%) | 1 | -37.20% ❌ | -46.97% ❌ / -50.34% ❌ / -14.29% ❌ | -37.20% ❌ | 1280.67 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +10.86% ✅ | +5.85% ✅ / +33.41% ✅ / -6.67% ❌ | +10.86% ✅ | 762.36 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (39.6%) | ✅ Pass (39.6%) | 19 | +14.31% ✅ | +7.47% ✅ / +27.46% ✅ / +8.00% ✅ | +14.31% ✅ | 1152.40 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 39.0% ± 9.2% | 36.3% ± 8.8% | 7/7 | +30.68% ± 11.59% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (122 samples) | +36.92% ± 16.87% ✅ | +18.54% ± 5.86% ✅ / +63.44% ± 25.91% ✅ / -3.83% ± 22.98% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 903.15 ± 140.52 | 96.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.9% ± 22.2% | 46.9% ± 22.2% | 6/6 | +13.59% ± 23.38% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (135 samples) | +22.50% ± 30.50% ✅ | -3.52% ± 23.10% ❌ / +47.18% ± 50.43% ✅ / -8.69% ± 3.97% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 2/2 | 1094.72 ± 154.93 | 96.00 ± 0.00 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 53.6% ± 9.6% | 51.5% ± 10.6% | 7/7 | +30.32% ± 11.77% ✅ | ✅ 6 / ➖ 1 / ❌ 0 | 7/7 (173 samples) | +36.71% ± 16.96% ✅ | +20.34% ± 9.97% ✅ / +61.73% ± 29.23% ✅ / -4.25% ± 20.80% ❌ | ✅ 6 / ➖ 1 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 923.91 ± 190.19 | 96.00 ± 0.00 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 30.6% ± 17.0% | 30.2% ± 17.4% | 6/6 | +14.03% ± 23.62% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (87 samples) | +22.95% ± 30.60% ✅ | -3.25% ± 23.19% ❌ / +46.39% ± 50.50% ✅ / -3.14% ± 21.84% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 1/2 | 1264.24 ± 113.47 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 42.6% ± 11.1% | 41.2% ± 11.2% | 13/13 | +22.79% ± 12.83% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (257 samples) | +30.27% ± 16.49% ✅ | +8.36% ± 12.27% ✅ / +55.93% ± 26.28% ✅ / -5.78% ± 12.86% ❌ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 3/5 | 991.57 ± 113.36 | 96.00 ± 0.00 |
| `rtl_native_front_guarded_parent_qd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 42.9% ± 11.1% | 41.7% ± 11.2% | 13/13 | +22.80% ± 12.87% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (260 samples) | +30.36% ± 16.51% ✅ | +9.45% ± 13.21% ✅ / +54.65% ± 27.19% ✅ / -3.81% ± 13.33% ❌ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 2/5 | 1080.98 ± 146.39 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 | +15.22% ✅ / +99.25% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 9 | 0.0000 | 0 | +38.78% ✅ / +38.42% ✅ / +39.02% ✅ |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 3 | 0.0000 | 0 | +38.78% ✅ / +59.47% ✅ / -21.95% ❌ |
| `classic` | RTLLM | Prob024_fsm | 2 | 11 | 2 | 0.1449 | 8 | +36.96% ✅ / +46.33% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.1074 | 2 | +36.96% ✅ / +29.06% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0003 | 1 | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 3 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +3.70% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3067 | 14 | +32.94% ✅ / +99.15% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob041_traffic_light | 2 | 22 | 1 | 0.2043 | 13 | +20.59% ✅ / +99.21% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1904 | 9 | +19.19% ✅ / +99.19% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob045_alu | 2 | 19 | 2 | 0.1871 | 19 | +18.88% ✅ / +99.14% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0128 | 3 | +22.34% ✅ / +46.04% ✅ / +16.28% ✅ |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.3975 | 5 | +40.00% ✅ / +99.41% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 | +40.00% ✅ / +99.61% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +98.91% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 | +0.00% ➖ / +98.91% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 2 | 0.0000 | 0 | -46.97% ❌ / -51.23% ❌ / -3.57% ❌ |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 1 | 1 | 0.0000 | 0 | -46.97% ❌ / -50.34% ❌ / -14.29% ❌ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0002 | 1 | +5.85% ✅ / +33.41% ✅ / +9.33% ✅ |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 16 | 3 | 0.0017 | 6 | +7.77% ✅ / +31.58% ✅ / +8.00% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1152 ± 0.0863 | 2.71 ± 2.13 | 5.29 ± 3.82 | 7 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0663 ± 0.1298 | 1.83 ± 0.94 | 1.50 ± 1.50 | 4 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | 7 | 7 | 0.0938 ± 0.0673 | 1.71 ± 0.70 | 5.14 ± 5.66 | 0 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0667 ± 0.1300 | 1.33 ± 0.65 | 2.00 ± 1.96 | 2 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.0926 ± 0.0737 | 2.31 ± 1.20 | 3.54 ± 2.34 | 11 |
| `rtl_native_front_guarded_parent_qd` | ALL | 13 | 13 | 0.0813 ± 0.0673 | 1.54 ± 0.48 | 3.69 ± 3.19 | 2 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 100.0% | 0.3815 | 0.3815 | 1/1 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 50.0% | 0.1335 | 0.2434 | 8/16 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob024_fsm | grid_quantile | 50.0% | 1.2052 | 0.4701 | 3/6 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 33.3% | -0.0106 | -0.0000 | 3/9 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 68.8% | 2.3404 | 0.3993 | 11/16 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob045_alu | grid_quantile | 66.7% | 3.0760 | 0.3933 | 8/12 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 100.0% | 0.7043 | 0.2348 | 3/3 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 100.0% | 0.4654 | 0.4654 | 1/1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 25.0% | 1.0540 | 0.2636 | 4/16 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 100.0% | 0.3297 | 0.3297 | 1/1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 37.5% | 0.4752 | 0.1431 | 6/16 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob004_adder_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 35 | 1 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=35; replay duplicate_objectives=34, filled_empty=1 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob015_multi_pipe_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 20 | 10 | init=warmup_complete, shape=4x4 | none | live crowding_evicted=2, duplicate_objectives=6, filled_empty=4, replaced_elite=4, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob024_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 19 | 5 | init=warmup_complete, shape=3x2 | none | live crowding_evicted=1, duplicate_objectives=8, pareto_inserted=2, warmup_buffered=8; replay crowding_evicted=1, duplicate_objectives=1, filled_empty=3, pareto_inserted=2, replaced_elite=1 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob037_parallel2serial | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 21 | 5 | init=warmup_complete, shape=3x3 | none | live duplicate_objectives=14, filled_empty=1, pareto_inserted=2, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob041_traffic_light | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 24 | 16 | init=warmup_complete, shape=4x4 | none | live crowding_evicted=4, duplicate_objectives=1, filled_empty=7, pareto_inserted=3, replaced_elite=5, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob045_alu | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 20 | 13 | init=warmup_complete, shape=4x3 | none | live crowding_evicted=5, filled_empty=5, pareto_inserted=3, replaced_elite=3, warmup_buffered=4; replay filled_empty=3, pareto_inserted=1 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob049_signal_generator | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 34 | 3 | init=run_finalization_fallback, shape=1x3 | state_control_ratio | live warmup_buffered=34; replay duplicate_objectives=31, filled_empty=3 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 9 | 2 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=9; replay duplicate_objectives=7, filled_empty=1, replaced_elite=1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 12 | 2 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=12; replay crowding_evicted=8, duplicate_objectives=2, filled_empty=1, pareto_inserted=1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 32 | 6 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=26, filled_empty=1, pareto_inserted=1, warmup_buffered=4; replay filled_empty=3, pareto_inserted=1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 14 | 1 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=14; replay duplicate_objectives=13, filled_empty=1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 1 | 0 | init=pending | none | live warmup_buffered=1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 19 | 8 | init=warmup_complete, shape=4x4 | none | live crowding_evicted=9, duplicate_objectives=1, filled_empty=2, pareto_inserted=2, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
