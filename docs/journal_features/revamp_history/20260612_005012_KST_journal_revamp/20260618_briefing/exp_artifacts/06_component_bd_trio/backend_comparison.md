# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 851107.31 ± 100178.45 | 240.00 | 240.00 |
| `classic` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 839675.00 ± 154195.76 | 240.00 | 240.00 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 864445.00 ± 136546.88 | 240.00 | 240.00 |
| `cvt_journal_bd` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 853635.38 ± 96315.69 | 240.00 | 240.00 |
| `cvt_journal_bd` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 840007.57 ± 162494.88 | 240.00 | 240.00 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 869534.50 ± 104459.53 | 240.00 | 240.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (65.8%) | ✅ Pass (65.8%) | +41.82% ✅ | +26.09% ✅ / +99.38% ✅ / N/A | +62.73% ✅ | 580.51 | 240 |
| `cvt_journal_bd` | RTLLM | Prob004_adder_8bit | ✅ Pass (66.7%) | ✅ Pass (65.0%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 652.04 | 240 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (37.5%) | ✅ Pass (35.8%) | +8.84% ✅ | +35.71% ✅ / +26.17% ✅ / -35.37% ❌ | +8.84% ✅ | 986.95 | 240 |
| `cvt_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (24.2%) | ✅ Pass (23.3%) | +17.57% ✅ | +15.82% ✅ / +41.76% ✅ / -4.88% ❌ | +17.57% ✅ | 997.77 | 240 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (26.7%) | ✅ Pass (23.3%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 597.88 | 240 |
| `cvt_journal_bd` | RTLLM | Prob024_fsm | ✅ Pass (41.7%) | ✅ Pass (35.8%) | +63.16% ✅ | +43.48% ✅ / +61.01% ✅ / N/A | +52.24% ✅ | 581.51 | 240 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (25.8%) | ✅ Pass (20.8%) | +46.86% ✅ | +54.00% ✅ / +56.95% ✅ / +29.63% ✅ | +46.86% ✅ | 856.58 | 240 |
| `cvt_journal_bd` | RTLLM | Prob037_parallel2serial | ✅ Pass (30.8%) | ✅ Pass (22.5%) | +6.33% ✅ | +6.00% ✅ / +9.27% ✅ / +3.70% ✅ | +6.33% ✅ | 857.16 | 240 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (60.0%) | ✅ Pass (60.0%) | +42.09% ✅ | +27.06% ✅ / +99.21% ✅ / N/A | +63.13% ✅ | 937.54 | 240 |
| `cvt_journal_bd` | RTLLM | Prob041_traffic_light | ✅ Pass (53.3%) | ✅ Pass (52.5%) | +44.23% ✅ | +33.53% ✅ / +99.15% ✅ / N/A | +66.34% ✅ | 902.52 | 240 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (61.7%) | ✅ Pass (61.7%) | +17.34% ✅ | +25.89% ✅ / +26.14% ✅ / N/A | +26.01% ✅ | 1179.86 | 240 |
| `cvt_journal_bd` | RTLLM | Prob045_alu | ✅ Pass (82.5%) | ✅ Pass (82.5%) | +37.73% ✅ | +14.16% ✅ / +99.04% ✅ / N/A | +56.60% ✅ | 1166.10 | 240 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (55.8%) | ✅ Pass (55.8%) | +26.03% ✅ | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ | +26.03% ✅ | 585.69 | 240 |
| `cvt_journal_bd` | RTLLM | Prob049_signal_generator | ✅ Pass (59.2%) | ✅ Pass (59.2%) | +26.71% ✅ | +8.51% ✅ / +46.04% ✅ / +25.58% ✅ | +26.71% ✅ | 595.86 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (66.7%) | ✅ Pass (66.7%) | +33.24% ✅ | +0.00% ➖ / +99.71% ✅ / N/A | +49.86% ✅ | 972.32 | 240 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (25.8%) | ✅ Pass (25.0%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1238.26 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (65.0%) | ✅ Pass (65.0%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1036.95 | 240 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (65.8%) | ✅ Pass (65.8%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1171.29 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (85.8%) | ✅ Pass (85.8%) | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 1091.77 | 240 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (86.7%) | ✅ Pass (86.7%) | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 939.49 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (45.0%) | ✅ Pass (45.0%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 796.47 | 240 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (44.2%) | ✅ Pass (44.2%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 856.03 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (19.2%) | ✅ Pass (19.2%) | -10.71% ❌ | -4.55% ❌ / -63.31% ❌ / +35.71% ✅ | -10.71% ❌ | 1023.45 | 240 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (25.8%) | ✅ Pass (24.2%) | -12.59% ❌ | -9.09% ❌ / -50.11% ❌ / +21.43% ✅ | -12.59% ❌ | 886.13 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (46.7%) | ✅ Pass (44.2%) | +17.07% ✅ | +8.23% ✅ / +33.64% ✅ / +9.33% ✅ | +17.07% ✅ | 1502.15 | 240 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (54.2%) | ✅ Pass (50.8%) | +15.11% ✅ | +7.97% ✅ / +32.04% ✅ / +5.33% ✅ | +15.11% ✅ | 2477.68 | 240 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 47.6% ± 12.7% | 46.2% ± 14.1% | 7/7 | +35.90% ± 14.88% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 | +41.88% ± 16.05% ✅ | +33.52% ± 9.67% ✅ / +60.73% ± 22.84% ✅ / +2.74% ± 38.38% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 817.86 ± 174.81 | 240.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 54.7% ± 18.4% | 54.3% ± 18.5% | 6/6 | +15.50% ± 14.40% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 | +22.72% ± 20.50% ✅ | +10.61% ± 13.45% ✅ / +28.37% ± 44.75% ✅ / +22.52% ± 25.85% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1070.52 ± 187.60 | 240.00 ± 0.00 |
| `cvt_journal_bd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 51.2% ± 15.2% | 48.7% ± 16.6% | 7/7 | +32.67% ± 13.68% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 | +39.32% ± 16.62% ✅ | +17.36% ± 11.58% ✅ / +65.03% ± 26.19% ✅ / +8.14% ± 17.77% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 821.85 ± 164.23 | 240.00 ± 0.00 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 50.4% ± 19.0% | 49.4% ± 19.3% | 6/6 | +10.81% ± 14.25% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 | +16.01% ± 20.00% ✅ | +3.15% ± 16.35% ✅ / +24.82% ± 42.00% ✅ / +13.38% ± 15.77% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 1261.48 ± 492.84 | 240.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 50.9% ± 10.6% | 49.9% ± 11.2% | 13/13 | +26.49% ± 11.52% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 | +33.03% ± 13.39% ✅ | +22.95% ± 10.09% ✅ / +45.80% ± 24.68% ✅ / +10.65% ± 24.47% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 934.47 ± 141.68 | 240.00 ± 0.00 |
| `cvt_journal_bd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 50.8% ± 11.5% | 49.0% ± 12.1% | 13/13 | +22.58% ± 11.29% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 | +28.56% ± 13.95% ✅ | +10.80% ± 10.17% ✅ / +46.48% ± 25.54% ✅ / +10.23% ± 11.22% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 1/5 | 1024.76 ± 263.34 | 240.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 15 | 1 | 0.2593 | 4 | +26.09% ✅ / +99.38% ✅ / N/A |
| `cvt_journal_bd` | RTLLM | Prob004_adder_8bit | 2 | 13 | 2 | 0.0410 | 3 | +15.22% ✅ / +98.97% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 26 | 9 | 0.0000 | 0 | +38.78% ✅ / +26.17% ✅ / +41.46% ✅ |
| `cvt_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 19 | 7 | 0.0000 | 0 | +38.78% ✅ / +41.76% ✅ / +31.71% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 13 | 1 | 0.3406 | 8 | +47.83% ✅ / +71.22% ✅ / N/A |
| `cvt_journal_bd` | RTLLM | Prob024_fsm | 2 | 20 | 1 | 0.2652 | 9 | +43.48% ✅ / +61.01% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 12 | 1 | 0.0911 | 3 | +54.00% ✅ / +56.95% ✅ / +29.63% ✅ |
| `cvt_journal_bd` | RTLLM | Prob037_parallel2serial | 3 | 9 | 3 | 0.0002 | 2 | +6.00% ✅ / +24.06% ✅ / +3.70% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 48 | 3 | 0.3503 | 38 | +38.24% ✅ / +99.21% ✅ / N/A |
| `cvt_journal_bd` | RTLLM | Prob041_traffic_light | 2 | 38 | 3 | 0.3765 | 34 | +40.00% ✅ / +99.20% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 62 | 1 | 0.0677 | 62 | +25.89% ✅ / +26.14% ✅ / N/A |
| `cvt_journal_bd` | RTLLM | Prob045_alu | 2 | 82 | 2 | 0.1635 | 81 | +24.27% ✅ / +99.04% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 9 | 2 | 0.0186 | 5 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `cvt_journal_bd` | RTLLM | Prob049_signal_generator | 3 | 10 | 4 | 0.0241 | 7 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.71% ✅ / N/A |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 10 | 1 | 0.2562 | 10 | +40.00% ✅ / +64.04% ✅ / N/A |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.2562 | 6 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 7 | 1 | 0.0717 | 1 | +20.00% ✅ / +35.87% ✅ / N/A |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 6 | 2 | 0.0000 | 1 | +0.00% ➖ / +99.09% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 4 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 8 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 19 | 4 | 0.0000 | 0 | -4.55% ❌ / -17.23% ❌ / +35.71% ✅ |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 27 | 4 | 0.0000 | 0 | -9.09% ❌ / -44.74% ❌ / +32.14% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 34 | 6 | 0.0027 | 10 | +8.93% ✅ / +33.64% ✅ / +16.00% ✅ |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 37 | 6 | 0.0019 | 12 | +9.72% ✅ / +35.93% ✅ / +13.33% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1611 ± 0.1122 | 2.57 ± 2.17 | 17.14 ± 17.49 | 4 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0551 ± 0.0820 | 2.33 ± 1.73 | 4.00 ± 3.75 | 6 |
| `cvt_journal_bd` | RTLLM | 7 | 7 | 0.1244 ± 0.1102 | 3.14 ± 1.45 | 19.43 ± 21.85 | 3 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0430 ± 0.0836 | 2.50 ± 1.66 | 3.50 ± 3.74 | 0 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.1122 ± 0.0747 | 2.46 ± 1.36 | 11.08 ± 9.94 | 10 |
| `cvt_journal_bd` | ALL | 13 | 13 | 0.0868 ± 0.0717 | 2.85 ± 1.06 | 12.08 ± 12.30 | 3 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `cvt_journal_bd` | RTLLM | Prob004_adder_8bit | cvt | 43.8% | 1.6528 | 0.3299 | 7/16 |
| `cvt_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | cvt | 31.2% | 0.2574 | 0.1757 | 5/16 |
| `cvt_journal_bd` | RTLLM | Prob024_fsm | cvt | 43.8% | 3.5908 | 0.6316 | 7/16 |
| `cvt_journal_bd` | RTLLM | Prob037_parallel2serial | cvt | 25.0% | 0.1735 | 0.0633 | 4/16 |
| `cvt_journal_bd` | RTLLM | Prob041_traffic_light | cvt | 37.5% | 1.3410 | 0.4423 | 6/16 |
| `cvt_journal_bd` | RTLLM | Prob045_alu | cvt | 62.5% | 1.3427 | 0.3773 | 10/16 |
| `cvt_journal_bd` | RTLLM | Prob049_signal_generator | cvt | 25.0% | 0.9965 | 0.2671 | 4/16 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | cvt | 6.2% | 0.0120 | 0.0120 | 1/16 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | cvt | 25.0% | 1.2946 | 0.3468 | 4/16 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | cvt | 37.5% | 0.1425 | 0.2636 | 6/16 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | cvt | 31.2% | -2.8110 | 0.0010 | 5/16 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | cvt | 50.0% | -1.6232 | -0.1259 | 8/16 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | cvt | 31.2% | 0.4461 | 0.1511 | 5/16 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|
| `cvt_journal_bd` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 78 | 7 | ff_depth | filled_empty=5, not_inserted=65, replaced_elite=5, warmup_buffered=3 |
| `cvt_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 28 | 5 | none | filled_empty=2, not_inserted=18, replaced_elite=5, warmup_buffered=3 |
| `cvt_journal_bd` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 43 | 7 | none | filled_empty=5, not_inserted=31, replaced_elite=4, warmup_buffered=3 |
| `cvt_journal_bd` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 27 | 4 | none | filled_empty=3, not_inserted=17, replaced_elite=4, warmup_buffered=3 |
| `cvt_journal_bd` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 63 | 6 | none | filled_empty=3, not_inserted=50, replaced_elite=7, warmup_buffered=3 |
| `cvt_journal_bd` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 99 | 10 | ff_depth | filled_empty=7, not_inserted=81, replaced_elite=8, warmup_buffered=3 |
| `cvt_journal_bd` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 71 | 4 | ff_depth | filled_empty=3, not_inserted=63, replaced_elite=2, warmup_buffered=3 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 30 | 1 | none | not_inserted=27, warmup_buffered=3 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 79 | 4 | ff_depth | filled_empty=3, not_inserted=70, replaced_elite=3, warmup_buffered=3 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 104 | 6 | ff_depth | filled_empty=5, not_inserted=92, replaced_elite=4, warmup_buffered=3 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 53 | 5 | ff_depth | filled_empty=4, not_inserted=43, replaced_elite=3, warmup_buffered=3 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 29 | 8 | none | filled_empty=6, not_inserted=17, replaced_elite=3, warmup_buffered=3 |
| `cvt_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 61 | 5 | ff_depth | filled_empty=2, not_inserted=48, replaced_elite=8, warmup_buffered=3 |

