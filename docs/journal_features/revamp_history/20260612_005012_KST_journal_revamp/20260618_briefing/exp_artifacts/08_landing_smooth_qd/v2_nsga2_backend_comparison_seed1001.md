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
| `classic` | ALL | unspecified | 120 | N/A | 259.54 ± 0.36 | 832898.23 ± 99076.40 | 259.54 | 259.54 |
| `classic` | RTLLM | unspecified | 120 | N/A | 259.57 ± 0.40 | 830898.14 ± 157763.59 | 259.57 | 259.57 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 259.50 ± 0.67 | 835231.67 ± 127244.00 | 259.50 | 259.50 |
| `smooth_qd_v2_nsga2` | ALL | unspecified | 120 | N/A | 261.15 ± 2.09 | 882781.92 ± 108892.11 | 261.15 | 261.15 |
| `smooth_qd_v2_nsga2` | RTLLM | unspecified | 120 | N/A | 262.43 ± 3.65 | 870359.71 ± 169336.78 | 262.43 | 262.43 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 259.67 ± 0.97 | 897274.50 ± 145651.44 | 259.67 | 259.67 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (70.0%) | ✅ Pass (70.0%) | 84 | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 823.03 | 259 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob004_adder_8bit | ✅ Pass (60.8%) | ✅ Pass (60.8%) | 73 | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 713.96 | 260 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (43.3%) | ✅ Pass (41.7%) | 50 | +23.61% ✅ | +40.00% ✅ / +54.01% ✅ / -23.17% ❌ | +23.61% ✅ | 1195.21 | 260 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 45 | +23.25% ✅ | +38.47% ✅ / +54.45% ✅ / -23.17% ❌ | +23.25% ✅ | 1026.01 | 259 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (34.2%) | ✅ Pass (27.5%) | 33 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 836.87 | 259 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob024_fsm | ✅ Pass (24.2%) | ✅ Pass (19.2%) | 23 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 755.79 | 268 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (30.8%) | ✅ Pass (30.0%) | 36 | +22.83% ✅ | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ | +22.83% ✅ | 956.00 | 260 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob037_parallel2serial | ✅ Pass (23.3%) | ✅ Pass (20.8%) | 25 | +0.89% ✅ | -6.00% ❌ / +12.36% ✅ / -3.70% ❌ | +0.89% ✅ | 839.27 | 259 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (68.3%) | ✅ Pass (68.3%) | 82 | +44.23% ✅ | +33.53% ✅ / +99.15% ✅ / N/A | +66.34% ✅ | 917.13 | 259 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob041_traffic_light | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 50 | +43.44% ✅ | +31.18% ✅ / +99.15% ✅ / N/A | +65.16% ✅ | 1003.21 | 271 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 85 | +42.14% ✅ | +27.19% ✅ / +99.24% ✅ / N/A | +63.22% ✅ | 1276.83 | 260 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob045_alu | ✅ Pass (72.5%) | ✅ Pass (72.5%) | 87 | +40.40% ✅ | +22.07% ✅ / +99.14% ✅ / N/A | +60.60% ✅ | 1524.14 | 260 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (54.2%) | ✅ Pass (54.2%) | 65 | +25.98% ✅ | +42.55% ✅ / +7.49% ✅ / +27.91% ✅ | +25.98% ✅ | 843.64 | 260 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob049_signal_generator | ✅ Pass (56.7%) | ✅ Pass (56.7%) | 68 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 806.54 | 260 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (65.0%) | ✅ Pass (65.0%) | 78 | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 1192.47 | 259 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (50.8%) | ✅ Pass (50.8%) | 61 | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 1177.10 | 259 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (69.2%) | ✅ Pass (69.2%) | 83 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1391.33 | 261 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (63.3%) | ✅ Pass (63.3%) | 76 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1873.03 | 259 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (91.7%) | ✅ Pass (91.7%) | 110 | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 1369.85 | 259 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 100 | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 1421.71 | 259 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (46.7%) | ✅ Pass (46.7%) | 56 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1126.79 | 259 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (56.7%) | ✅ Pass (56.7%) | 68 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1056.49 | 259 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (19.2%) | ✅ Pass (18.3%) | 22 | -20.87% ❌ | -28.79% ❌ / -51.68% ❌ / +17.86% ✅ | -20.87% ❌ | 1305.65 | 259 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (25.8%) | ✅ Pass (25.8%) | 31 | -11.25% ❌ | -13.64% ❌ / -16.55% ❌ / -3.57% ❌ | -11.25% ❌ | 1303.35 | 262 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (45.0%) | ✅ Pass (43.3%) | 52 | +14.59% ✅ | +7.97% ✅ / +31.81% ✅ / +4.00% ✅ | +14.59% ✅ | 1751.34 | 260 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (60.8%) | ✅ Pass (55.8%) | 67 | +15.25% ✅ | +8.93% ✅ / +28.83% ✅ / +8.00% ✅ | +15.25% ✅ | 3652.97 | 260 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 53.1% ± 12.8% | 51.8% ± 14.0% | 7/7 | +37.16% ± 12.02% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (435 samples) | +44.43% ± 14.59% ✅ | +30.44% ± 11.94% ✅ / +64.91% ± 28.07% ✅ / +8.99% ± 31.68% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 978.39 ± 136.15 | 259.57 ± 0.40 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 56.1% ± 19.9% | 55.7% ± 20.2% | 6/6 | +13.38% ± 16.90% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | 6/6 (401 samples) | +20.59% ± 22.85% ✅ | +6.53% ± 18.37% ✅ / +29.97% ± 41.78% ✅ / +10.93% ± 13.58% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1356.24 ± 175.14 | 259.50 ± 0.67 |
| `smooth_qd_v2_nsga2` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 45.2% ± 13.9% | 44.2% ± 15.0% | 7/7 | +33.67% ± 15.36% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (371 samples) | +40.76% ± 17.95% ✅ | +21.81% ± 14.50% ✅ / +68.76% ± 24.69% ✅ / -4.31% ± 21.01% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ❌ 1/7 / P ✅ 0/7 / T ❌ 2/3 | 952.70 ± 206.11 | 262.43 ± 3.65 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 56.8% ± 15.0% | 56.0% ± 14.9% | 6/6 | +15.09% ± 14.53% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | 6/6 (403 samples) | +22.31% ± 20.71% ✅ | +9.21% ± 15.00% ✅ / +35.32% ± 33.87% ✅ / +2.21% ± 11.34% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ❌ 1/2 | 1747.44 ± 780.14 | 259.67 ± 0.97 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 54.5% ± 11.0% | 53.6% ± 11.5% | 13/13 | +26.19% ± 11.78% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (836 samples) | +33.43% ± 14.24% ✅ | +19.41% ± 12.20% ✅ / +48.78% ± 25.40% ✅ / +9.76% ± 17.90% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 1152.78 ± 149.16 | 259.54 ± 0.36 |
| `smooth_qd_v2_nsga2` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 50.6% ± 10.3% | 49.6% ± 10.7% | 13/13 | +25.10% ± 11.47% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (774 samples) | +32.24% ± 14.01% ✅ | +16.00% ± 10.61% ✅ / +53.33% ± 21.76% ✅ / -1.70% ± 12.46% ❌ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 3/5 | 1319.51 ± 422.76 | 261.15 ± 2.09 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 13 | 2 | 0.0410 | 3 | +15.22% ✅ / +98.97% ✅ / N/A |
| `smooth_qd_v2_nsga2` | RTLLM | Prob004_adder_8bit | 2 | 8 | 2 | 0.0410 | 2 | +15.22% ✅ / +98.97% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 43 | 11 | 0.0012 | 3 | +40.00% ✅ / +54.01% ✅ / +41.46% ✅ |
| `smooth_qd_v2_nsga2` | RTLLM | Prob015_multi_pipe_8bit | 3 | 34 | 8 | 0.0000 | 0 | +38.78% ✅ / +54.45% ✅ / +41.46% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 18 | 1 | 0.3406 | 11 | +47.83% ✅ / +71.22% ✅ / N/A |
| `smooth_qd_v2_nsga2` | RTLLM | Prob024_fsm | 2 | 13 | 1 | 0.3406 | 6 | +47.83% ✅ / +71.22% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 12 | 1 | 0.0119 | 3 | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ |
| `smooth_qd_v2_nsga2` | RTLLM | Prob037_parallel2serial | 3 | 8 | 4 | 0.0000 | 0 | +0.00% ➖ / +12.36% ✅ / +3.70% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 51 | 4 | 0.3539 | 46 | +39.41% ✅ / +99.21% ✅ / N/A |
| `smooth_qd_v2_nsga2` | RTLLM | Prob041_traffic_light | 2 | 38 | 5 | 0.3582 | 28 | +42.35% ✅ / +99.20% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 78 | 1 | 0.2698 | 78 | +27.19% ✅ / +99.24% ✅ / N/A |
| `smooth_qd_v2_nsga2` | RTLLM | Prob045_alu | 2 | 78 | 2 | 0.2302 | 78 | +26.29% ✅ / +99.14% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 8 | 4 | 0.0173 | 4 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `smooth_qd_v2_nsga2` | RTLLM | Prob049_signal_generator | 3 | 8 | 2 | 0.0192 | 6 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.75% ✅ / N/A |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 4 | 1 | 0.0000 | 3 | +0.00% ➖ / +99.75% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 9 | 1 | 0.2562 | 9 | +40.00% ✅ / +64.04% ✅ / N/A |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 8 | 1 | 0.2562 | 8 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 8 | 2 | 0.0717 | 2 | +20.00% ✅ / +36.77% ✅ / N/A |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 6 | 1 | 0.0717 | 1 | +20.00% ✅ / +35.87% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 4 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 21 | 5 | 0.0000 | 0 | -16.67% ❌ / -42.51% ❌ / +21.43% ✅ |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 30 | 6 | 0.0000 | 0 | -3.03% ❌ / -16.55% ❌ / +25.00% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 29 | 6 | 0.0010 | 8 | +9.45% ✅ / +36.16% ✅ / +14.67% ✅ |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 33 | 7 | 0.0021 | 5 | +9.75% ✅ / +35.01% ✅ / +18.67% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1479 ± 0.1221 | 3.43 ± 2.67 | 21.14 ± 21.88 | 5 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0548 ± 0.0822 | 2.67 ± 1.80 | 3.50 ± 3.19 | 3 |
| `smooth_qd_v2_nsga2` | RTLLM | 7 | 7 | 0.1413 ± 0.1208 | 3.43 ± 1.81 | 17.14 ± 21.14 | 2 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0550 ± 0.0821 | 2.83 ± 2.29 | 2.83 ± 2.55 | 3 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.1050 ± 0.0775 | 3.08 ± 1.61 | 13.00 ± 12.48 | 8 |
| `smooth_qd_v2_nsga2` | ALL | 13 | 13 | 0.1015 ± 0.0763 | 3.15 ± 1.38 | 10.54 ± 11.74 | 5 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `smooth_qd_v2_nsga2` | RTLLM | Prob004_adder_8bit | grid_quantile | 43.8% | 1.0859 | 0.3299 | 7/16 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 31.2% | -2.0874 | 0.2325 | 15/48 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob024_fsm | grid_quantile | 22.2% | 1.1837 | 0.6835 | 2/9 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob037_parallel2serial | grid_quantile | 25.0% | 0.0089 | 0.0089 | 3/12 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob041_traffic_light | grid_quantile | 19.4% | 1.9560 | 0.4344 | 7/36 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob045_alu | grid_quantile | 62.5% | 1.4614 | 0.4040 | 10/16 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob049_signal_generator | grid_quantile | 75.0% | 0.7584 | 0.2638 | 3/4 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 50.0% | 0.3325 | 0.3325 | 1/2 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 41.7% | 1.2642 | 0.3468 | 5/12 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 77.8% | 0.5552 | 0.1862 | 7/9 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 75.0% | 0.0000 | -0.0000 | 3/4 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 33.3% | -3.8887 | -0.1125 | 16/48 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 33.3% | 0.1889 | 0.1525 | 4/12 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `smooth_qd_v2_nsga2` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 73 | 11 | init=warmup_complete, shape=4x1x4 | ff_depth | live duplicate_objectives=60, filled_empty=2, pareto_inserted=3, warmup_buffered=8; replay duplicate_objectives=2, filled_empty=5, pareto_inserted=1 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 45 | 33 | init=warmup_complete, shape=4x4x3 | none | live crowding_evicted=2, duplicate_objectives=10, filled_empty=7, pareto_inserted=18, warmup_buffered=8; replay filled_empty=8 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 23 | 7 | init=warmup_complete, shape=3x1x3 | ff_depth | live crowding_evicted=6, duplicate_objectives=7, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=3, filled_empty=2, pareto_inserted=3 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 25 | 9 | init=warmup_complete, shape=1x3x4 | logic_depth | live duplicate_objectives=11, pareto_inserted=6, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 50 | 20 | init=warmup_complete, shape=3x3x4 | none | live crowding_evicted=21, duplicate_objectives=9, filled_empty=2, pareto_inserted=10, warmup_buffered=8; replay filled_empty=5, pareto_inserted=3 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 87 | 32 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=48, duplicate_objectives=7, filled_empty=3, pareto_inserted=21, warmup_buffered=8; replay filled_empty=7, pareto_inserted=1 |
| `smooth_qd_v2_nsga2` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 68 | 9 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=43, pareto_inserted=5, warmup_buffered=20; replay duplicate_objectives=16, filled_empty=3, pareto_inserted=1 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 61 | 4 | init=run_finalization_fallback, shape=1x1x2 | logic_depth, ff_depth | live warmup_buffered=61; replay duplicate_objectives=57, filled_empty=1, pareto_inserted=3 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 76 | 11 | init=warmup_complete, shape=3x1x4 | ff_depth | live duplicate_objectives=61, filled_empty=2, pareto_inserted=5, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=3, pareto_inserted=1 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 100 | 12 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=83, filled_empty=4, pareto_inserted=5, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 68 | 5 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=52, filled_empty=1, pareto_inserted=2, warmup_buffered=13; replay duplicate_objectives=11, filled_empty=2 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 31 | 30 | init=warmup_complete, shape=4x3x4 | none | live duplicate_objectives=1, filled_empty=9, pareto_inserted=13, warmup_buffered=8; replay filled_empty=7, pareto_inserted=1 |
| `smooth_qd_v2_nsga2` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 67 | 18 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=18, duplicate_objectives=31, pareto_inserted=10, warmup_buffered=8; replay filled_empty=4, pareto_inserted=4 |

