# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `grid_quantile_journal_bd` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 834356.38 ± 95731.36 | 240.00 | 240.00 |
| `classic` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 827835.14 ± 147397.54 | 240.00 | 240.00 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 841964.50 ± 130982.16 | 240.00 | 240.00 |
| `grid_quantile_journal_bd` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 840113.46 ± 95913.38 | 240.00 | 240.00 |
| `grid_quantile_journal_bd` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 834791.43 ± 155985.18 | 240.00 | 240.00 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 846322.50 ± 117123.08 | 240.00 | 240.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (69.2%) | ✅ Pass (68.3%) | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 896.92 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob004_adder_8bit | ✅ Pass (65.8%) | ✅ Pass (65.8%) | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 940.19 | 240 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (35.8%) | ✅ Pass (35.0%) | +11.33% ✅ | +35.20% ✅ / +25.61% ✅ / -26.83% ❌ | +11.33% ✅ | 1433.88 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (38.3%) | ✅ Pass (35.8%) | +22.23% ✅ | +35.71% ✅ / +59.02% ✅ / -28.05% ❌ | +22.23% ✅ | 1757.92 | 240 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (30.8%) | ✅ Pass (22.5%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 904.86 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob024_fsm | ✅ Pass (27.5%) | ✅ Pass (22.5%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 822.51 | 240 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (35.0%) | ✅ Pass (30.8%) | +8.46% ✅ | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ | +8.46% ✅ | 1199.76 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob037_parallel2serial | ✅ Pass (43.3%) | ✅ Pass (29.2%) | +6.33% ✅ | +6.00% ✅ / +9.27% ✅ / +3.70% ✅ | +6.33% ✅ | 1150.10 | 240 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (60.0%) | ✅ Pass (58.3%) | +42.68% ✅ | +28.82% ✅ / +99.20% ✅ / N/A | +64.01% ✅ | 1310.58 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob041_traffic_light | ✅ Pass (37.5%) | ✅ Pass (37.5%) | +44.23% ✅ | +33.53% ✅ / +99.15% ✅ / N/A | +66.34% ✅ | 1554.06 | 240 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (55.0%) | ✅ Pass (55.0%) | +18.57% ✅ | +27.46% ✅ / +28.25% ✅ / N/A | +27.85% ✅ | 1523.84 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob045_alu | ✅ Pass (72.5%) | ✅ Pass (70.8%) | +37.72% ✅ | +14.07% ✅ / +99.08% ✅ / N/A | +56.57% ✅ | 1552.35 | 240 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (40.0%) | ✅ Pass (40.0%) | +27.38% ✅ | +24.47% ✅ / +46.04% ✅ / +11.63% ✅ | +27.38% ✅ | 801.78 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob049_signal_generator | ✅ Pass (45.8%) | ✅ Pass (45.8%) | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 810.25 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (64.2%) | ✅ Pass (64.2%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 1414.94 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (46.7%) | ✅ Pass (46.7%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 1359.24 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (71.7%) | ✅ Pass (71.7%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1388.19 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (75.8%) | ✅ Pass (75.8%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1638.02 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (80.8%) | ✅ Pass (80.8%) | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 1344.76 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (80.0%) | ✅ Pass (80.0%) | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 1315.74 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (37.5%) | ✅ Pass (37.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1295.51 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (51.7%) | ✅ Pass (51.7%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1261.28 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (11.7%) | ✅ Pass (10.0%) | -12.59% ❌ | -9.09% ❌ / -50.11% ❌ / +21.43% ✅ | -12.59% ❌ | 1311.66 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (23.3%) | ✅ Pass (22.5%) | -10.71% ❌ | -4.55% ❌ / -63.31% ❌ / +35.71% ✅ | -10.71% ❌ | 1296.36 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (10.8%) | ✅ Pass (10.8%) | +17.96% ✅ | +9.36% ✅ / +33.87% ✅ / +10.67% ✅ | +17.96% ✅ | 1119.59 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (49.2%) | ✅ Pass (46.7%) | +15.97% ✅ | +8.30% ✅ / +32.95% ✅ / +6.67% ✅ | +15.97% ✅ | 1489.16 | 240 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 46.5% ± 10.9% | 44.3% ± 12.3% | 7/7 | +30.70% ± 15.55% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 | +36.54% ± 17.36% ✅ | +26.43% ± 9.98% ✅ / +55.03% ± 25.98% ✅ / -3.83% ± 22.98% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1153.09 ± 212.55 | 240.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.1% ± 24.5% | 45.8% ± 24.8% | 6/6 | +15.32% ± 14.88% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | 6/6 | +22.53% ± 20.89% ✅ | +10.04% ± 14.16% ✅ / +30.57% ± 41.41% ✅ / +16.05% ± 10.55% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1312.44 ± 83.74 | 240.00 ± 0.00 |
| `grid_quantile_journal_bd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 47.3% ± 12.0% | 43.9% ± 13.5% | 7/7 | +34.77% ± 14.42% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 | +42.09% ± 17.25% ✅ | +24.50% ± 10.98% ✅ / +69.00% ± 25.17% ✅ / -3.46% ± 24.78% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1226.77 ± 290.11 | 240.00 ± 0.00 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 54.4% ± 16.7% | 53.9% ± 17.0% | 6/6 | +15.32% ± 14.39% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 | +22.54% ± 20.54% ✅ | +10.63% ± 13.45% ✅ / +28.27% ± 44.75% ✅ / +21.19% ± 28.47% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1393.30 ± 114.89 | 240.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 46.3% ± 12.1% | 45.0% ± 12.6% | 13/13 | +23.60% ± 11.25% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 | +30.08% ± 13.44% ✅ | +18.87% ± 9.31% ✅ / +43.74% ± 23.65% ✅ / +4.12% ± 16.14% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 1226.64 ± 124.63 | 240.00 ± 0.00 |
| `grid_quantile_journal_bd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 50.6% ± 9.8% | 48.5% ± 10.6% | 13/13 | +25.79% ± 11.22% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 | +33.06% ± 13.84% ✅ | +18.10% ± 9.08% ✅ / +50.20% ± 26.22% ✅ / +6.40% ± 20.13% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 1303.63 ± 165.54 | 240.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 16 | 1 | 0.1510 | 4 | +15.22% ✅ / +99.25% ✅ / N/A |
| `grid_quantile_journal_bd` | RTLLM | Prob004_adder_8bit | 2 | 13 | 1 | 0.1510 | 4 | +15.22% ✅ / +99.25% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 31 | 14 | 0.0000 | 0 | +38.78% ✅ / +26.17% ✅ / +41.46% ✅ |
| `grid_quantile_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 32 | 13 | 0.0000 | 1 | +36.53% ✅ / +59.02% ✅ / +40.24% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 14 | 1 | 0.3406 | 7 | +47.83% ✅ / +71.22% ✅ / N/A |
| `grid_quantile_journal_bd` | RTLLM | Prob024_fsm | 2 | 15 | 1 | 0.3406 | 9 | +47.83% ✅ / +71.22% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 12 | 3 | 0.0003 | 2 | +6.00% ✅ / +15.67% ✅ / +14.81% ✅ |
| `grid_quantile_journal_bd` | RTLLM | Prob037_parallel2serial | 3 | 12 | 3 | 0.0002 | 1 | +6.00% ✅ / +12.36% ✅ / +14.81% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 48 | 5 | 0.3824 | 45 | +42.35% ✅ / +99.21% ✅ / N/A |
| `grid_quantile_journal_bd` | RTLLM | Prob041_traffic_light | 2 | 32 | 4 | 0.3830 | 25 | +42.35% ✅ / +99.20% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 61 | 1 | 0.0776 | 61 | +27.46% ✅ / +28.25% ✅ / N/A |
| `grid_quantile_journal_bd` | RTLLM | Prob045_alu | 2 | 73 | 2 | 0.1682 | 73 | +25.30% ✅ / +99.08% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 10 | 4 | 0.0234 | 5 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `grid_quantile_journal_bd` | RTLLM | Prob049_signal_generator | 3 | 10 | 4 | 0.0235 | 7 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 4 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.75% ✅ / N/A |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 4 | 1 | 0.0000 | 3 | +0.00% ➖ / +99.75% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.2562 | 6 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 10 | 1 | 0.2562 | 10 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 7 | 1 | 0.0717 | 3 | +20.00% ✅ / +35.87% ✅ / N/A |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 7 | 2 | 0.0717 | 2 | +20.00% ✅ / +36.77% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 5 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 10 | 5 | 0.0000 | 0 | -9.09% ❌ / -43.85% ❌ / +25.00% ✅ |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 25 | 5 | 0.0000 | 0 | -4.55% ❌ / -45.41% ❌ / +35.71% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 6 | 1 | 0.0034 | 2 | +9.36% ✅ / +33.87% ✅ / +10.67% ✅ |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 24 | 9 | 0.0019 | 8 | +10.48% ✅ / +46.91% ✅ / +9.33% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1393 ± 0.1193 | 4.14 ± 3.43 | 17.71 ± 18.26 | 3 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0552 ± 0.0820 | 1.67 ± 1.31 | 2.17 ± 1.78 | 2 |
| `grid_quantile_journal_bd` | RTLLM | 7 | 7 | 0.1524 ± 0.1179 | 4.00 ± 3.08 | 17.14 ± 19.23 | 4 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0550 ± 0.0821 | 3.17 ± 2.60 | 4.00 ± 3.24 | 4 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.1005 ± 0.0754 | 3.00 ± 2.00 | 10.54 ± 10.47 | 5 |
| `grid_quantile_journal_bd` | ALL | 13 | 13 | 0.1074 ± 0.0761 | 3.62 ± 1.98 | 11.08 ± 10.74 | 8 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `grid_quantile_journal_bd` | RTLLM | Prob004_adder_8bit | grid_quantile | 50.0% | 1.1903 | 0.3815 | 8/16 |
| `grid_quantile_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 50.0% | 0.1028 | 0.2223 | 6/12 |
| `grid_quantile_journal_bd` | RTLLM | Prob024_fsm | grid_quantile | 62.5% | 2.4694 | 0.6835 | 5/8 |
| `grid_quantile_journal_bd` | RTLLM | Prob037_parallel2serial | grid_quantile | 50.0% | -0.0097 | 0.0633 | 2/4 |
| `grid_quantile_journal_bd` | RTLLM | Prob041_traffic_light | grid_quantile | 21.9% | 2.1641 | 0.4423 | 7/32 |
| `grid_quantile_journal_bd` | RTLLM | Prob045_alu | grid_quantile | 62.5% | 1.4405 | 0.3772 | 10/16 |
| `grid_quantile_journal_bd` | RTLLM | Prob049_signal_generator | grid_quantile | 75.0% | 0.7839 | 0.2638 | 3/4 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 50.0% | 0.3325 | 0.3325 | 1/2 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 41.7% | 1.5116 | 0.3468 | 5/12 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 75.0% | 0.3596 | 0.1862 | 3/4 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 75.0% | 0.0010 | 0.0010 | 3/4 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 23.4% | -7.1380 | -0.1071 | 15/64 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 31.2% | 0.4255 | 0.1597 | 5/16 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|
| `grid_quantile_journal_bd` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 79 | 8 | ff_depth | filled_empty=5, not_inserted=63, replaced_elite=3, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 43 | 6 | none | filled_empty=1, not_inserted=26, replaced_elite=8, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 27 | 5 | ff_depth | filled_empty=1, not_inserted=14, replaced_elite=4, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 35 | 2 | ff_depth | filled_empty=1, not_inserted=25, replaced_elite=1, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 45 | 7 | none | filled_empty=3, not_inserted=30, replaced_elite=4, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 85 | 10 | ff_depth | filled_empty=5, not_inserted=58, replaced_elite=14, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 55 | 3 | ff_depth | filled_empty=1, not_inserted=31, replaced_elite=2, warmup_buffered=21 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 56 | 1 | none | warmup_buffered=56 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 91 | 5 | ff_depth | filled_empty=2, not_inserted=76, replaced_elite=5, warmup_buffered=8 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 96 | 3 | ff_depth | filled_empty=1, not_inserted=83, replaced_elite=3, warmup_buffered=9 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 62 | 3 | ff_depth | filled_empty=1, not_inserted=46, replaced_elite=1, warmup_buffered=14 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 27 | 15 | none | filled_empty=7, not_inserted=6, replaced_elite=6, warmup_buffered=8 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 56 | 5 | ff_depth | filled_empty=2, not_inserted=40, replaced_elite=6, warmup_buffered=8 |

