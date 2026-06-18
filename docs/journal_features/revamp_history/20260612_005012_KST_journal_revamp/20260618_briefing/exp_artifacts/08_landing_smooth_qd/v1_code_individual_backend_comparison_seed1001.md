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
| `smooth_qd_v1_code` | ALL | unspecified | 120 | N/A | 260.92 ± 1.75 | 869037.77 ± 105989.65 | 260.92 | 260.92 |
| `smooth_qd_v1_code` | RTLLM | unspecified | 120 | N/A | 261.29 ± 3.16 | 855442.86 ± 169267.83 | 261.29 | 261.29 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 260.50 ± 1.31 | 884898.50 ± 133957.46 | 260.50 | 260.50 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (70.0%) | ✅ Pass (70.0%) | 84 | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 823.03 | 259 |
| `smooth_qd_v1_code` | RTLLM | Prob004_adder_8bit | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 75 | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 736.05 | 259 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (43.3%) | ✅ Pass (41.7%) | 50 | +23.61% ✅ | +40.00% ✅ / +54.01% ✅ / -23.17% ❌ | +23.61% ✅ | 1195.21 | 260 |
| `smooth_qd_v1_code` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (25.8%) | ✅ Pass (25.8%) | 31 | +18.44% ✅ | +47.55% ✅ / -20.27% ❌ / +28.05% ✅ | +18.44% ✅ | 1109.54 | 264 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (34.2%) | ✅ Pass (27.5%) | 33 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 836.87 | 259 |
| `smooth_qd_v1_code` | RTLLM | Prob024_fsm | ✅ Pass (30.0%) | ✅ Pass (24.2%) | 29 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 529.89 | 259 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (30.8%) | ✅ Pass (30.0%) | 36 | +22.83% ✅ | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ | +22.83% ✅ | 956.00 | 260 |
| `smooth_qd_v1_code` | RTLLM | Prob037_parallel2serial | ✅ Pass (54.2%) | ✅ Pass (35.8%) | 43 | +7.79% ✅ | +4.00% ✅ / +15.67% ✅ / +3.70% ✅ | +7.79% ✅ | 859.68 | 259 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (68.3%) | ✅ Pass (68.3%) | 82 | +44.23% ✅ | +33.53% ✅ / +99.15% ✅ / N/A | +66.34% ✅ | 917.13 | 259 |
| `smooth_qd_v1_code` | RTLLM | Prob041_traffic_light | ✅ Pass (37.5%) | ✅ Pass (36.7%) | 44 | +44.83% ✅ | +35.29% ✅ / +99.20% ✅ / N/A | +67.25% ✅ | 799.38 | 270 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 85 | +42.14% ✅ | +27.19% ✅ / +99.24% ✅ / N/A | +63.22% ✅ | 1276.83 | 260 |
| `smooth_qd_v1_code` | RTLLM | Prob045_alu | ✅ Pass (80.8%) | ✅ Pass (80.8%) | 97 | +16.58% ✅ | +25.35% ✅ / +24.39% ✅ / N/A | +24.87% ✅ | 1341.09 | 259 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (54.2%) | ✅ Pass (54.2%) | 65 | +25.98% ✅ | +42.55% ✅ / +7.49% ✅ / +27.91% ✅ | +25.98% ✅ | 843.64 | 260 |
| `smooth_qd_v1_code` | RTLLM | Prob049_signal_generator | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 45 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 784.98 | 259 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (65.0%) | ✅ Pass (65.0%) | 78 | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 1192.47 | 259 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (54.2%) | ✅ Pass (53.3%) | 64 | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 909.24 | 259 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (69.2%) | ✅ Pass (69.2%) | 83 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1391.33 | 261 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (56.7%) | ✅ Pass (56.7%) | 68 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1124.56 | 259 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (91.7%) | ✅ Pass (91.7%) | 110 | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 1369.85 | 259 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (75.8%) | ✅ Pass (75.8%) | 91 | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 854.37 | 260 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (46.7%) | ✅ Pass (46.7%) | 56 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1126.79 | 259 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (74.2%) | ✅ Pass (74.2%) | 89 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1153.15 | 260 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (19.2%) | ✅ Pass (18.3%) | 22 | -20.87% ❌ | -28.79% ❌ / -51.68% ❌ / +17.86% ✅ | -20.87% ❌ | 1305.65 | 259 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (12.5%) | ✅ Pass (12.5%) | 15 | -20.82% ❌ | -19.70% ❌ / -64.21% ❌ / +21.43% ✅ | -20.82% ❌ | 1014.39 | 263 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (45.0%) | ✅ Pass (43.3%) | 52 | +14.59% ✅ | +7.97% ✅ / +31.81% ✅ / +4.00% ✅ | +14.59% ✅ | 1751.34 | 260 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (65.0%) | ✅ Pass (62.5%) | 75 | +16.18% ✅ | +9.69% ✅ / +29.52% ✅ / +9.33% ✅ | +16.18% ✅ | 3211.32 | 262 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 53.1% ± 12.8% | 51.8% ± 14.0% | 7/7 | +37.16% ± 12.02% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (435 samples) | +44.43% ± 14.59% ✅ | +30.44% ± 11.94% ✅ / +64.91% ± 28.07% ✅ / +8.99% ± 31.68% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 978.39 ± 136.15 | 259.57 ± 0.40 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 56.1% ± 19.9% | 55.7% ± 20.2% | 6/6 | +13.38% ± 16.90% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | 6/6 (401 samples) | +20.59% ± 22.85% ✅ | +6.53% ± 18.37% ✅ / +29.97% ± 41.78% ✅ / +10.93% ± 13.58% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1356.24 ± 175.14 | 259.50 ± 0.67 |
| `smooth_qd_v1_code` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 46.9% ± 14.7% | 43.3% ± 15.4% | 7/7 | +30.77% ± 15.17% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (364 samples) | +36.25% ± 16.65% ✅ | +25.60% ± 14.29% ✅ / +47.89% ± 33.17% ✅ / +15.24% ± 13.83% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ❌ 1/7 / T ✅ 0/3 | 880.09 ± 197.05 | 261.29 ± 3.16 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 56.4% ± 18.6% | 55.8% ± 18.5% | 6/6 | +13.65% ± 16.91% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | 6/6 (402 samples) | +20.86% ± 22.79% ✅ | +8.33% ± 16.26% ✅ / +27.50% ± 44.97% ✅ / +15.38% ± 11.85% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1377.84 ± 724.76 | 260.50 ± 1.31 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 54.5% ± 11.0% | 53.6% ± 11.5% | 13/13 | +26.19% ± 11.78% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (836 samples) | +33.43% ± 14.24% ✅ | +19.41% ± 12.20% ✅ / +48.78% ± 25.40% ✅ / +9.76% ± 17.90% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 1152.78 ± 149.16 | 259.54 ± 0.36 |
| `smooth_qd_v1_code` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 51.3% ± 11.5% | 49.1% ± 11.9% | 13/13 | +22.87% ± 11.84% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (766 samples) | +29.15% ± 13.91% ✅ | +17.63% ± 11.38% ✅ / +38.48% ± 26.80% ✅ / +15.29% ± 8.45% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 2/13 / T ✅ 0/5 | 1109.82 ± 362.19 | 260.92 ± 1.75 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 13 | 2 | 0.0410 | 3 | +15.22% ✅ / +98.97% ✅ / N/A |
| `smooth_qd_v1_code` | RTLLM | Prob004_adder_8bit | 2 | 10 | 2 | 0.0410 | 2 | +15.22% ✅ / +98.97% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 43 | 11 | 0.0012 | 3 | +40.00% ✅ / +54.01% ✅ / +41.46% ✅ |
| `smooth_qd_v1_code` | RTLLM | Prob015_multi_pipe_8bit | 3 | 26 | 8 | 0.0000 | 0 | +47.55% ✅ / +11.69% ✅ / +41.46% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 18 | 1 | 0.3406 | 11 | +47.83% ✅ / +71.22% ✅ / N/A |
| `smooth_qd_v1_code` | RTLLM | Prob024_fsm | 2 | 18 | 1 | 0.3406 | 12 | +47.83% ✅ / +71.22% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 12 | 1 | 0.0119 | 3 | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ |
| `smooth_qd_v1_code` | RTLLM | Prob037_parallel2serial | 3 | 14 | 3 | 0.0003 | 2 | +6.00% ✅ / +15.67% ✅ / +14.81% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 51 | 4 | 0.3539 | 46 | +39.41% ✅ / +99.21% ✅ / N/A |
| `smooth_qd_v1_code` | RTLLM | Prob041_traffic_light | 2 | 36 | 2 | 0.3674 | 29 | +37.65% ✅ / +99.20% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 78 | 1 | 0.2698 | 78 | +27.19% ✅ / +99.24% ✅ / N/A |
| `smooth_qd_v1_code` | RTLLM | Prob045_alu | 2 | 79 | 1 | 0.0618 | 79 | +25.35% ✅ / +24.39% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 8 | 4 | 0.0173 | 4 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `smooth_qd_v1_code` | RTLLM | Prob049_signal_generator | 3 | 8 | 3 | 0.0210 | 6 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.75% ✅ / N/A |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.75% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 9 | 1 | 0.2562 | 9 | +40.00% ✅ / +64.04% ✅ / N/A |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 12 | 1 | 0.2562 | 9 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 8 | 2 | 0.0717 | 2 | +20.00% ✅ / +36.77% ✅ / N/A |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 1 | 0.0717 | 1 | +20.00% ✅ / +35.87% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 4 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 21 | 5 | 0.0000 | 0 | -16.67% ❌ / -42.51% ❌ / +21.43% ✅ |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 13 | 4 | 0.0000 | 0 | -15.15% ❌ / -46.09% ❌ / +21.43% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 29 | 6 | 0.0010 | 8 | +9.45% ✅ / +36.16% ✅ / +14.67% ✅ |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 47 | 9 | 0.0035 | 14 | +10.48% ✅ / +36.84% ✅ / +20.00% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1479 ± 0.1221 | 3.43 ± 2.67 | 21.14 ± 21.88 | 4 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0548 ± 0.0822 | 2.67 ± 1.80 | 3.50 ± 3.19 | 5 |
| `smooth_qd_v1_code` | RTLLM | 7 | 7 | 0.1189 ± 0.1202 | 2.86 ± 1.79 | 18.57 ± 21.07 | 3 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0552 ± 0.0820 | 2.83 ± 2.60 | 4.33 ± 4.66 | 1 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.1050 ± 0.0775 | 3.08 ± 1.61 | 13.00 ± 12.48 | 9 |
| `smooth_qd_v1_code` | ALL | 13 | 13 | 0.0895 ± 0.0742 | 2.85 ± 1.47 | 12.00 ± 11.83 | 4 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `smooth_qd_v1_code` | RTLLM | Prob004_adder_8bit | grid_quantile | 58.3% | 0.9972 | 0.3299 | 7/12 |
| `smooth_qd_v1_code` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 25.0% | -1.6795 | 0.1844 | 12/48 |
| `smooth_qd_v1_code` | RTLLM | Prob024_fsm | grid_quantile | 62.5% | 2.8169 | 0.6835 | 5/8 |
| `smooth_qd_v1_code` | RTLLM | Prob037_parallel2serial | grid_quantile | 50.0% | 0.0307 | 0.0779 | 2/4 |
| `smooth_qd_v1_code` | RTLLM | Prob041_traffic_light | grid_quantile | 21.9% | 4.0669 | 0.4483 | 14/64 |
| `smooth_qd_v1_code` | RTLLM | Prob045_alu | grid_quantile | 62.5% | 1.1644 | 0.1658 | 10/16 |
| `smooth_qd_v1_code` | RTLLM | Prob049_signal_generator | grid_quantile | 50.0% | 0.7875 | 0.2638 | 3/6 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 50.0% | 0.3325 | 0.3325 | 1/2 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 58.3% | 1.7268 | 0.3468 | 7/12 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 75.0% | 0.3596 | 0.1862 | 3/4 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 75.0% | 0.0000 | -0.0000 | 3/4 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 18.8% | -3.8160 | -0.2082 | 9/48 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 37.5% | 0.4671 | 0.1618 | 6/16 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `smooth_qd_v1_code` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 75 | 13 | init=warmup_complete, shape=3x1x4 | ff_depth | live duplicate_objectives=58, filled_empty=3, pareto_inserted=6, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=4 |
| `smooth_qd_v1_code` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 31 | 25 | init=warmup_complete, shape=4x4x3 | none | live crowding_evicted=1, duplicate_objectives=4, filled_empty=8, pareto_inserted=10, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=4, pareto_inserted=3 |
| `smooth_qd_v1_code` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 29 | 17 | init=warmup_complete, shape=2x1x4 | ff_depth | live crowding_evicted=4, duplicate_objectives=7, filled_empty=2, pareto_inserted=8, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=3, pareto_inserted=4 |
| `smooth_qd_v1_code` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 43 | 6 | init=warmup_complete, shape=1x2x2 | logic_depth | live crowding_evicted=18, duplicate_objectives=12, filled_empty=1, pareto_inserted=3, warmup_buffered=9; replay duplicate_objectives=7, filled_empty=1, pareto_inserted=1 |
| `smooth_qd_v1_code` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 44 | 36 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=8, filled_empty=6, pareto_inserted=22, warmup_buffered=8; replay filled_empty=8 |
| `smooth_qd_v1_code` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 97 | 39 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=48, duplicate_objectives=10, filled_empty=4, pareto_inserted=27, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `smooth_qd_v1_code` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 45 | 10 | init=warmup_complete, shape=2x1x3 | ff_depth | live duplicate_objectives=17, pareto_inserted=4, warmup_buffered=24; replay duplicate_objectives=18, filled_empty=3, pareto_inserted=3 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 64 | 3 | init=run_finalization_fallback, shape=1x1x2 | logic_depth, ff_depth | live warmup_buffered=64; replay duplicate_objectives=61, filled_empty=1, pareto_inserted=2 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 68 | 17 | init=warmup_complete, shape=3x1x4 | ff_depth | live duplicate_objectives=47, filled_empty=4, pareto_inserted=9, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=3, pareto_inserted=1 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 91 | 8 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=78, filled_empty=1, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 89 | 5 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=73, filled_empty=1, pareto_inserted=2, warmup_buffered=13; replay duplicate_objectives=11, filled_empty=2 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 15 | 13 | init=warmup_complete, shape=4x3x4 | none | live duplicate_objectives=1, filled_empty=2, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=7 |
| `smooth_qd_v1_code` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 75 | 24 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=26, duplicate_objectives=25, filled_empty=2, pareto_inserted=14, warmup_buffered=8; replay filled_empty=4, pareto_inserted=4 |

