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
| `classic` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 846796.92 ± 103522.03 | 240.00 | 240.00 |
| `classic` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 841917.00 ± 163661.77 | 240.00 | 240.00 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 852490.17 ± 134840.36 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_eoh` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 888930.85 ± 94346.41 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 876743.00 ± 151226.29 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 903150.00 ± 118240.58 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 854471.23 ± 96969.55 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 807733.43 ± 155498.62 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 908998.67 ± 103932.06 | 240.00 | 240.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (64.2%) | ✅ Pass (62.5%) | 75 | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 592.89 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob004_adder_8bit | ✅ Pass (55.8%) | ✅ Pass (55.0%) | 66 | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 731.93 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob004_adder_8bit | ✅ Pass (69.2%) | ✅ Pass (69.2%) | 83 | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 1251.00 | 240 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (48.3%) | ✅ Pass (45.0%) | 54 | +12.17% ✅ | +20.92% ✅ / +15.59% ✅ / +0.00% ➖ | +12.17% ✅ | 1513.23 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (29.2%) | ✅ Pass (29.2%) | 35 | +9.14% ✅ | +26.33% ✅ / -5.01% ❌ / +6.10% ✅ | +9.14% ✅ | 1098.75 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (30.0%) | ✅ Pass (28.3%) | 34 | +15.71% ✅ | +31.33% ✅ / +38.98% ✅ / -23.17% ❌ | +15.71% ✅ | 2232.19 | 240 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (25.0%) | ✅ Pass (19.2%) | 23 | +63.16% ✅ | +43.48% ✅ / +61.01% ✅ / N/A | +52.24% ✅ | 500.69 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob024_fsm | ✅ Pass (30.0%) | ✅ Pass (25.0%) | 30 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 630.21 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob024_fsm | ✅ Pass (67.5%) | ✅ Pass (58.3%) | 70 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1586.96 | 240 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (31.7%) | ✅ Pass (23.3%) | 28 | +9.38% ✅ | -2.00% ❌ / +22.74% ✅ / +7.41% ✅ | +9.38% ✅ | 810.20 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob037_parallel2serial | ✅ Pass (42.5%) | ✅ Pass (30.0%) | 36 | +6.24% ✅ | +0.00% ➖ / +15.01% ✅ / +3.70% ✅ | +6.24% ✅ | 883.14 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob037_parallel2serial | ✅ Pass (25.0%) | ✅ Pass (25.0%) | 30 | +16.18% ✅ | +10.00% ✅ / +31.13% ✅ / +7.41% ✅ | +16.18% ✅ | 1979.55 | 240 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (60.0%) | ✅ Pass (59.2%) | 71 | +44.23% ✅ | +33.53% ✅ / +99.15% ✅ / N/A | +66.34% ✅ | 983.90 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob041_traffic_light | ✅ Pass (52.5%) | ✅ Pass (51.7%) | 62 | +42.48% ✅ | +28.24% ✅ / +99.20% ✅ / N/A | +63.72% ✅ | 1076.50 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob041_traffic_light | ✅ Pass (47.5%) | ✅ Pass (46.7%) | 56 | +41.44% ✅ | +25.29% ✅ / +99.04% ✅ / N/A | +62.17% ✅ | 2533.31 | 240 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (49.2%) | ✅ Pass (49.2%) | 59 | +15.89% ✅ | +24.00% ✅ / +23.68% ✅ / N/A | +23.84% ✅ | 1037.53 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob045_alu | ✅ Pass (75.8%) | ✅ Pass (75.8%) | 91 | +16.14% ✅ | +25.44% ✅ / +22.98% ✅ / N/A | +24.21% ✅ | 987.96 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob045_alu | ✅ Pass (23.3%) | ✅ Pass (23.3%) | 28 | +11.69% ✅ | +19.46% ✅ / +15.61% ✅ / N/A | +17.54% ✅ | 2049.22 | 240 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (44.2%) | ✅ Pass (44.2%) | 53 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 565.05 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob049_signal_generator | ✅ Pass (54.2%) | ✅ Pass (54.2%) | 65 | +27.38% ✅ | +24.47% ✅ / +46.04% ✅ / +11.63% ✅ | +27.38% ✅ | 611.07 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob049_signal_generator | ✅ Pass (75.8%) | ✅ Pass (75.8%) | 91 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 1228.00 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 70 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 952.72 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (39.2%) | ✅ Pass (38.3%) | 46 | +33.24% ✅ | +0.00% ➖ / +99.71% ✅ / N/A | +49.86% ✅ | 1101.13 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (39.2%) | ✅ Pass (39.2%) | 47 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 2595.53 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (65.0%) | ✅ Pass (65.0%) | 78 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1064.31 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (65.8%) | ✅ Pass (65.8%) | 79 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1253.71 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 75 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 3032.84 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (85.0%) | ✅ Pass (85.0%) | 102 | +12.26% ✅ | +0.00% ➖ / +36.77% ✅ / N/A | +18.39% ✅ | 874.97 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (93.3%) | ✅ Pass (93.3%) | 112 | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 948.11 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (85.0%) | ✅ Pass (85.0%) | 102 | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 2584.38 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (44.2%) | ✅ Pass (43.3%) | 52 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 936.24 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (44.2%) | ✅ Pass (44.2%) | 53 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 938.82 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 50 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 2073.87 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (8.3%) | ✅ Pass (8.3%) | 10 | -14.22% ❌ | -16.67% ❌ / -47.43% ❌ / +21.43% ✅ | -14.22% ❌ | 1108.22 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (22.5%) | ✅ Pass (21.7%) | 26 | -10.71% ❌ | -4.55% ❌ / -63.31% ❌ / +35.71% ✅ | -10.71% ❌ | 1067.44 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (5.0%) | ✅ Pass (4.2%) | 5 | -16.81% ❌ | -18.18% ❌ / -46.53% ❌ / +14.29% ✅ | -16.81% ❌ | 2394.44 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (28.3%) | ✅ Pass (24.2%) | 29 | +15.50% ✅ | +8.40% ✅ / +34.10% ✅ / +4.00% ✅ | +15.50% ✅ | 1118.09 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (21.7%) | ✅ Pass (20.0%) | 24 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1552.54 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (26.7%) | ✅ Pass (25.8%) | 31 | +15.47% ✅ | +7.93% ✅ / +31.81% ✅ / +6.67% ✅ | +15.47% ✅ | 2921.91 | 240 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 46.1% ± 10.4% | 43.2% ± 12.2% | 7/7 | +29.17% ± 14.38% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (363 samples) | +34.26% ± 16.18% ✅ | +19.87% ± 12.23% ✅ / +52.45% ± 26.24% ✅ / +7.12% ± 7.90% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ❌ 1/7 / P ✅ 0/7 / T ✅ 0/3 | 857.64 ± 264.26 | 240.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 48.2% ± 21.9% | 47.4% ± 22.4% | 6/6 | +8.25% ± 13.33% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (341 samples) | +12.27% ± 18.20% ✅ | +5.29% ± 15.10% ✅ / +15.23% ± 30.96% ✅ / +12.71% ± 17.08% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1009.09 ± 81.00 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 48.6% ± 12.1% | 45.8% ± 13.7% | 7/7 | +26.34% ± 12.36% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (385 samples) | +30.60% ± 15.33% ✅ | +18.03% ± 9.24% ✅ / +46.22% ± 29.83% ✅ / +7.14% ± 4.60% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ❌ 1/7 / T ✅ 0/3 | 859.94 ± 151.81 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 47.8% ± 22.1% | 47.2% ± 22.5% | 6/6 | +14.91% ± 14.40% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (340 samples) | +22.13% ± 20.65% ✅ | +10.54% ± 13.46% ✅ / +28.03% ± 44.73% ✅ / +18.52% ± 33.69% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1143.63 ± 184.94 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 48.3% ± 16.7% | 46.7% ± 16.1% | 7/7 | +24.65% ± 11.15% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (392 samples) | +27.17% ± 12.35% ✅ | +19.40% ± 5.51% ✅ / +43.43% ± 19.89% ✅ / -1.38% ± 21.49% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1837.18 ± 368.32 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 43.3% ± 22.3% | 43.1% ± 22.5% | 6/6 | +8.88% ± 14.31% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (310 samples) | +13.43% ± 19.37% ✅ | +8.29% ± 15.93% ✅ / +14.85% ± 30.48% ✅ / +10.48% ± 7.47% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 2600.49 ± 279.56 | 240.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 47.1% ± 11.0% | 45.1% ± 11.8% | 13/13 | +19.52% ± 11.17% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (704 samples) | +24.11% ± 13.14% ✅ | +13.14% ± 10.05% ✅ / +35.27% ± 21.91% ✅ / +9.36% ± 7.42% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ✅ 0/5 | 927.54 ± 147.94 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_eoh` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 48.2% ± 11.5% | 46.5% ± 12.2% | 13/13 | +21.07% ± 9.56% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (725 samples) | +26.69% ± 12.29% ✅ | +14.57% ± 7.89% ✅ / +37.82% ± 25.51% ✅ / +11.70% ± 12.24% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 1/13 / P ❌ 2/13 / T ✅ 0/5 | 990.87 ± 138.51 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 46.0% ± 13.1% | 45.0% ± 13.0% | 13/13 | +17.37% ± 9.63% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (702 samples) | +20.83% ± 11.32% ✅ | +14.27% ± 8.17% ✅ / +30.24% ± 18.71% ✅ / +3.36% ± 13.29% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 2189.48 ± 312.90 | 240.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 10 | 3 | 0.0410 | 2 | +15.22% ✅ / +99.00% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob004_adder_8bit | 2 | 14 | 2 | 0.0410 | 3 | +15.22% ✅ / +98.97% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.0410 | 1 | +15.22% ✅ / +26.91% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 39 | 11 | 0.0000 | 1 | +38.78% ✅ / +26.17% ✅ / +41.46% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob015_multi_pipe_8bit | 3 | 28 | 11 | 0.0000 | 0 | +35.71% ✅ / +0.22% ✅ / +32.93% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob015_multi_pipe_8bit | 3 | 19 | 7 | 0.0000 | 0 | +42.45% ✅ / +38.98% ✅ / -20.73% ❌ |
| `classic` | RTLLM | Prob024_fsm | 2 | 14 | 1 | 0.2652 | 10 | +43.48% ✅ / +61.01% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob024_fsm | 2 | 15 | 3 | 0.1458 | 6 | +36.96% ✅ / +46.91% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob024_fsm | 2 | 10 | 2 | 0.1459 | 7 | +36.96% ✅ / +46.76% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 14 | 3 | 0.0003 | 3 | +6.00% ✅ / +22.74% ✅ / +14.81% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob037_parallel2serial | 3 | 15 | 2 | 0.0000 | 1 | +0.00% ➖ / +15.01% ✅ / +14.81% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob037_parallel2serial | 3 | 5 | 2 | 0.0039 | 3 | +12.00% ✅ / +31.13% ✅ / +14.81% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 40 | 5 | 0.3709 | 36 | +42.35% ✅ / +99.20% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob041_traffic_light | 2 | 52 | 2 | 0.3338 | 46 | +37.06% ✅ / +99.20% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob041_traffic_light | 2 | 39 | 2 | 0.2509 | 25 | +25.29% ✅ / +99.21% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 48 | 2 | 0.0575 | 48 | +24.27% ✅ / +23.68% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob045_alu | 2 | 77 | 2 | 0.0592 | 77 | +25.44% ✅ / +23.33% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob045_alu | 2 | 25 | 1 | 0.0304 | 25 | +19.46% ✅ / +15.61% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 10 | 3 | 0.0210 | 7 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob049_signal_generator | 3 | 14 | 4 | 0.0239 | 9 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.71% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 9 | 1 | 0.2562 | 8 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 11 | 1 | 0.2562 | 11 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.2562 | 6 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 6 | 1 | 0.0000 | 1 | +0.00% ➖ / +36.77% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 8 | 2 | 0.0717 | 2 | +20.00% ✅ / +36.77% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0717 | 1 | +20.00% ✅ / +35.87% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 6 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 5 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 4 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 10 | 2 | 0.0000 | 0 | -16.67% ❌ / -45.19% ❌ / +21.43% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 20 | 6 | 0.0000 | 0 | -4.55% ❌ / -45.86% ❌ / +35.71% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 4 | 1 | 0.0000 | 0 | -18.18% ❌ / -46.53% ❌ / +14.29% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 16 | 2 | 0.0011 | 4 | +10.48% ✅ / +35.24% ✅ / +4.00% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 18 | 6 | 0.0008 | 4 | +8.07% ✅ / +33.18% ✅ / +12.00% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 25 | 3 | 0.0017 | 3 | +9.75% ✅ / +36.84% ✅ / +12.00% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1080 ± 0.1098 | 4.00 ± 2.46 | 15.29 ± 13.95 | 4 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0429 ± 0.0836 | 1.33 ± 0.41 | 2.50 ± 2.41 | 1 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | 7 | 7 | 0.0862 ± 0.0889 | 3.71 ± 2.45 | 20.29 ± 22.00 | 2 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0548 ± 0.0822 | 2.83 ± 1.99 | 3.33 ± 3.19 | 4 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | 7 | 7 | 0.0689 ± 0.0701 | 2.43 ± 1.53 | 9.00 ± 8.26 | 1 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0549 ± 0.0821 | 1.33 ± 0.65 | 2.00 ± 1.75 | 1 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.0779 ± 0.0702 | 2.77 ± 1.49 | 9.38 ± 8.16 | 5 |
| `grid_quantile_pareto_journal_bd_eoh` | ALL | 13 | 13 | 0.0717 ± 0.0592 | 3.31 ± 1.56 | 12.46 ± 12.45 | 6 |
| `grid_quantile_pareto_journal_bd_unified` | ALL | 13 | 13 | 0.0624 ± 0.0513 | 1.92 ± 0.90 | 5.77 ± 4.78 | 2 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob004_adder_8bit | grid_quantile | 62.5% | 0.3183 | 0.3299 | 10/16 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob004_adder_8bit | grid_quantile | 22.2% | 0.2809 | 0.1404 | 2/9 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 18.8% | -0.7616 | 0.0914 | 9/48 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 18.8% | -0.8026 | 0.1571 | 9/48 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob024_fsm | grid_quantile | 62.5% | 2.0476 | 0.5002 | 5/8 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob024_fsm | grid_quantile | 50.0% | 1.4917 | 0.5002 | 3/6 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob037_parallel2serial | grid_quantile | 33.3% | 0.0624 | 0.0624 | 3/9 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob037_parallel2serial | grid_quantile | 66.7% | 0.2928 | 0.1618 | 6/9 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob041_traffic_light | grid_quantile | 27.1% | 3.9363 | 0.4248 | 13/48 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob041_traffic_light | grid_quantile | 29.2% | 3.9177 | 0.4144 | 14/48 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob045_alu | grid_quantile | 75.0% | 1.4605 | 0.1614 | 12/16 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob045_alu | grid_quantile | 66.7% | 0.7145 | 0.1169 | 8/12 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob049_signal_generator | grid_quantile | 75.0% | 0.7939 | 0.2738 | 3/4 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob049_signal_generator | grid_quantile | 66.7% | 0.4695 | 0.2348 | 2/3 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 50.0% | 0.3324 | 0.3324 | 1/2 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 50.0% | 1.4674 | 0.3468 | 6/12 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 25.0% | 0.8674 | 0.3468 | 4/16 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 100.0% | 0.2975 | 0.1862 | 4/4 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 18.8% | 0.3596 | 0.1862 | 3/16 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 75.0% | 0.0010 | 0.0010 | 3/4 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 44.4% | -0.5471 | 0.0010 | 4/9 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 29.2% | -3.8706 | -0.1071 | 14/48 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 12.5% | -0.2364 | 0.1356 | 6/48 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 25.0% | 0.4152 | 0.1547 | 4/16 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 66 | 18 | init=warmup_complete, shape=4x1x4 | ff_depth | live duplicate_objectives=45, filled_empty=6, pareto_inserted=7, warmup_buffered=8; replay duplicate_objectives=3, filled_empty=4, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 83 | 2 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=75, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 35 | 27 | init=warmup_complete, shape=4x3x4 | none | live crowding_evicted=1, duplicate_objectives=6, filled_empty=5, pareto_inserted=15, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=4, pareto_inserted=3 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 34 | 15 | init=warmup_complete, shape=4x4x3 | none | live crowding_evicted=8, duplicate_objectives=11, filled_empty=2, pareto_inserted=5, warmup_buffered=8; replay filled_empty=7, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 30 | 13 | init=warmup_complete, shape=2x1x4 | ff_depth | live crowding_evicted=3, duplicate_objectives=12, filled_empty=1, pareto_inserted=6, warmup_buffered=8; replay duplicate_objectives=2, filled_empty=4, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 70 | 11 | init=warmup_complete, shape=2x1x3 | ff_depth | live crowding_evicted=16, duplicate_objectives=42, pareto_inserted=3, warmup_buffered=9; replay duplicate_objectives=1, filled_empty=3, pareto_inserted=5 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 36 | 12 | init=warmup_complete, shape=1x3x3 | logic_depth | live crowding_evicted=8, duplicate_objectives=11, filled_empty=1, pareto_inserted=8, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 30 | 8 | init=warmup_complete, shape=1x3x3 | logic_depth | live duplicate_objectives=16, filled_empty=4, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 62 | 40 | init=warmup_complete, shape=3x4x4 | none | live crowding_evicted=14, duplicate_objectives=8, filled_empty=6, pareto_inserted=26, warmup_buffered=8; replay filled_empty=7, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 56 | 36 | init=warmup_complete, shape=3x4x4 | none | live crowding_evicted=3, duplicate_objectives=17, filled_empty=7, pareto_inserted=21, warmup_buffered=8; replay filled_empty=7, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 91 | 40 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=39, duplicate_objectives=12, filled_empty=5, pareto_inserted=27, warmup_buffered=8; replay filled_empty=7, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 28 | 20 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=5, duplicate_objectives=3, filled_empty=3, pareto_inserted=9, warmup_buffered=8; replay filled_empty=5, pareto_inserted=3 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 65 | 13 | init=warmup_complete, shape=2x1x2 | ff_depth | live crowding_evicted=4, duplicate_objectives=33, pareto_inserted=9, warmup_buffered=19; replay duplicate_objectives=15, filled_empty=3, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 91 | 4 | init=run_finalization_fallback, shape=1x1x3 | logic_depth, ff_depth | live warmup_buffered=91; replay duplicate_objectives=87, filled_empty=2, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 46 | 3 | init=run_finalization_fallback, shape=1x1x2 | logic_depth, ff_depth | live warmup_buffered=46; replay duplicate_objectives=43, filled_empty=1, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 47 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=47; replay duplicate_objectives=45, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 79 | 13 | init=warmup_complete, shape=3x1x4 | ff_depth | live duplicate_objectives=62, filled_empty=3, pareto_inserted=6, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=3, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 75 | 7 | init=warmup_complete, shape=4x1x4 | ff_depth | live duplicate_objectives=65, filled_empty=1, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=3, filled_empty=3, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 112 | 10 | init=warmup_complete, shape=2x1x2 | ff_depth | live crowding_evicted=42, duplicate_objectives=54, filled_empty=3, pareto_inserted=5, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 102 | 7 | init=warmup_complete, shape=4x1x4 | ff_depth | live duplicate_objectives=93, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=2, filled_empty=3, pareto_inserted=3 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 53 | 7 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=41, filled_empty=2, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=1, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 50 | 6 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=39, filled_empty=2, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 26 | 24 | init=warmup_complete, shape=4x3x4 | none | live duplicate_objectives=1, filled_empty=8, pareto_inserted=9, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=6, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 5 | 0 | init=pending | none | live warmup_buffered=5 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 24 | 15 | init=warmup_complete, shape=4x3x4 | none | live crowding_evicted=3, duplicate_objectives=5, filled_empty=1, pareto_inserted=7, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=5, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 31 | 18 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=9, duplicate_objectives=3, filled_empty=1, pareto_inserted=10, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=3, pareto_inserted=4 |

