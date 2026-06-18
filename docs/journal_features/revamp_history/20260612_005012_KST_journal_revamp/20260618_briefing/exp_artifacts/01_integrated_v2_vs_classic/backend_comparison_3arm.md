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
| `classic` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 858445.62 ± 98766.74 | 240.00 | 240.00 |
| `classic` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 848293.71 ± 160329.06 | 240.00 | 240.00 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 870289.50 ± 120571.93 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 842184.77 ± 97518.01 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 795423.14 ± 155008.45 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 896740.00 ± 107542.14 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 846374.54 ± 98042.89 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 801269.14 ± 157650.94 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 898997.50 ± 106008.93 | 240.00 | 240.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (62.5%) | ✅ Pass (60.8%) | 73 | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 1352.96 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob004_adder_8bit | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 100 | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 841.20 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob004_adder_8bit | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 100 | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 842.95 | 240 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (43.3%) | ✅ Pass (41.7%) | 50 | +16.85% ✅ | +12.35% ✅ / +40.65% ✅ / -2.44% ❌ | +16.85% ✅ | 2140.87 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (33.3%) | ✅ Pass (32.5%) | 39 | +7.17% ✅ | +38.78% ✅ / +5.90% ✅ / -23.17% ❌ | +7.17% ✅ | 1968.26 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (21.7%) | ✅ Pass (21.7%) | 26 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 1714.86 | 240 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (25.0%) | ✅ Pass (23.3%) | 28 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 1165.97 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob024_fsm | ✅ Pass (54.2%) | ✅ Pass (48.3%) | 58 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1339.57 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob024_fsm | ✅ Pass (55.0%) | ✅ Pass (50.0%) | 60 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1288.44 | 240 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (31.7%) | ✅ Pass (28.3%) | 34 | +48.57% ✅ | +60.00% ✅ / +56.07% ✅ / +29.63% ✅ | +48.57% ✅ | 1642.43 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob037_parallel2serial | ✅ Pass (22.5%) | ✅ Pass (22.5%) | 27 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1719.98 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob037_parallel2serial | ✅ Pass (26.7%) | ✅ Pass (26.7%) | 32 | +44.14% ✅ | +48.00% ✅ / +58.50% ✅ / +25.93% ✅ | +44.14% ✅ | 1672.89 | 240 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (51.7%) | ✅ Pass (50.8%) | 61 | +42.09% ✅ | +27.06% ✅ / +99.20% ✅ / N/A | +63.13% ✅ | 1784.54 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob041_traffic_light | ✅ Pass (53.3%) | ✅ Pass (53.3%) | 64 | +40.62% ✅ | +22.94% ✅ / +98.93% ✅ / N/A | +60.93% ✅ | 2096.46 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob041_traffic_light | ✅ Pass (45.0%) | ✅ Pass (45.0%) | 54 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 1962.90 | 240 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (60.8%) | ✅ Pass (60.8%) | 73 | +40.73% ✅ | +23.06% ✅ / +99.13% ✅ / N/A | +61.09% ✅ | 1646.21 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob045_alu | ✅ Pass (27.5%) | ✅ Pass (25.8%) | 31 | +15.88% ✅ | +25.44% ✅ / +22.19% ✅ / N/A | +23.82% ✅ | 1692.81 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob045_alu | ✅ Pass (27.5%) | ✅ Pass (27.5%) | 33 | +12.46% ✅ | +22.74% ✅ / +14.65% ✅ / N/A | +18.70% ✅ | 1774.60 | 240 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (51.7%) | ✅ Pass (51.7%) | 62 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 992.84 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob049_signal_generator | ✅ Pass (80.8%) | ✅ Pass (80.8%) | 97 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 1000.49 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob049_signal_generator | ✅ Pass (78.3%) | ✅ Pass (78.3%) | 94 | +25.65% ✅ | +5.32% ✅ / +46.04% ✅ / +25.58% ✅ | +25.65% ✅ | 1000.35 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (65.8%) | ✅ Pass (64.2%) | 77 | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 1809.79 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (49.2%) | ✅ Pass (49.2%) | 59 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 2254.39 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (45.0%) | ✅ Pass (45.0%) | 54 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 2185.06 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 75 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 2102.42 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (51.7%) | ✅ Pass (51.7%) | 62 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 2228.72 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (70.0%) | ✅ Pass (70.0%) | 84 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 2347.33 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (86.7%) | ✅ Pass (86.7%) | 104 | +12.26% ✅ | +0.00% ➖ / +36.77% ✅ / N/A | +18.39% ✅ | 1703.35 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (95.0%) | ✅ Pass (95.0%) | 114 | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 1540.40 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (78.3%) | ✅ Pass (78.3%) | 94 | -1.29% ❌ | -20.00% ❌ / +16.14% ✅ / N/A | -1.93% ❌ | 1503.46 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (46.7%) | ✅ Pass (46.7%) | 56 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1408.21 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (22.5%) | ✅ Pass (22.5%) | 27 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1272.07 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (28.3%) | ✅ Pass (28.3%) | 34 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1202.63 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (14.2%) | ✅ Pass (14.2%) | 17 | -10.71% ❌ | -4.55% ❌ / -63.31% ❌ / +35.71% ✅ | -10.71% ❌ | 1963.67 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (10.8%) | ✅ Pass (10.8%) | 13 | -21.67% ❌ | -16.67% ❌ / -51.90% ❌ / +3.57% ✅ | -21.67% ❌ | 1997.12 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (11.7%) | ✅ Pass (10.8%) | 13 | -30.10% ❌ | -34.85% ❌ / -48.32% ❌ / -7.14% ❌ | -30.10% ❌ | 1573.08 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (27.5%) | ✅ Pass (25.0%) | 30 | +13.55% ✅ | +8.30% ✅ / +35.01% ✅ / -2.67% ❌ | +13.55% ✅ | 1980.50 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (47.5%) | ✅ Pass (47.5%) | 57 | +17.96% ✅ | +9.36% ✅ / +33.87% ✅ / +10.67% ✅ | +17.96% ✅ | 3487.94 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (43.3%) | ✅ Pass (40.0%) | 48 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 2373.51 | 240 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 46.7% ± 10.5% | 45.4% ± 11.1% | 7/7 | +39.42% ± 12.29% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (381 samples) | +46.43% ± 13.38% ✅ | +27.06% ± 15.25% ✅ / +73.04% ± 19.38% ✅ / +13.71% ± 18.15% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1532.26 ± 289.53 | 240.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 50.6% ± 21.3% | 49.9% ± 21.5% | 6/6 | +13.84% ± 14.35% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | 6/6 (359 samples) | +20.52% ± 20.57% ✅ | +7.29% ± 13.25% ✅ / +28.71% ± 44.83% ✅ / +16.52% ± 37.61% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ❌ 1/2 | 1827.99 ± 198.94 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 50.7% ± 18.2% | 49.5% ± 18.4% | 7/7 | +21.60% ± 13.31% ✅ | ✅ 6 / ➖ 1 / ❌ 0 | 7/7 (416 samples) | +24.36% ± 14.61% ✅ | +19.55% ± 8.91% ✅ / +35.19% ± 24.64% ✅ / -3.85% ± 20.05% ❌ | ✅ 6 / ➖ 1 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1522.68 ± 353.51 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.1% ± 23.3% | 46.1% ± 23.3% | 6/6 | +8.48% ± 15.64% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (332 samples) | +13.03% ± 20.44% ✅ | +8.78% ± 15.61% ✅ / +14.30% ± 32.04% ✅ / +7.12% ± 6.95% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 2130.11 ± 616.76 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 48.2% ± 18.6% | 47.5% ± 18.5% | 7/7 | +27.48% ± 13.06% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (399 samples) | +30.00% ± 13.61% ✅ | +25.05% ± 10.56% ✅ / +41.98% ± 23.53% ✅ / +8.63% ± 33.56% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1465.29 ± 314.80 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.1% ± 20.0% | 45.4% ± 20.3% | 6/6 | +3.02% ± 16.94% ✅ | ✅ 4 / ➖ 0 / ❌ 2 | 6/6 (327 samples) | +5.92% ± 21.45% ✅ | -1.18% ± 20.45% ❌ / +11.22% ± 29.84% ✅ / -2.90% ± 8.31% ❌ | ✅ 4 / ➖ 0 / ❌ 2 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 1/2 | 1864.18 ± 399.82 | 240.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 48.5% ± 10.9% | 47.4% ± 11.1% | 13/13 | +27.61% ± 11.50% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (740 samples) | +34.47% ± 13.53% ✅ | +17.94% ± 11.29% ✅ / +52.58% ± 25.38% ✅ / +14.84% ± 15.56% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 2/5 | 1668.75 ± 192.71 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 48.6% ± 14.0% | 47.9% ± 14.0% | 13/13 | +15.55% ± 10.42% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (748 samples) | +19.13% ± 12.16% ✅ | +14.58% ± 8.80% ✅ / +25.54% ± 19.89% ✅ / +0.54% ± 12.37% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 1803.03 ± 368.99 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 47.2% ± 13.1% | 46.5% ± 13.1% | 13/13 | +16.19% ± 12.19% ✅ | ✅ 11 / ➖ 0 / ❌ 2 | 13/13 (726 samples) | +18.89% ± 13.58% ✅ | +12.94% ± 12.85% ✅ / +27.79% ± 19.89% ✅ / +4.02% ± 19.38% ✅ | ✅ 11 / ➖ 0 / ❌ 2 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 2/5 | 1649.39 ± 264.73 | 240.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 12 | 2 | 0.0410 | 2 | +15.22% ✅ / +98.97% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.0410 | 1 | +15.22% ✅ / +26.91% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.0410 | 1 | +15.22% ✅ / +26.91% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 37 | 15 | 0.0000 | 0 | +38.78% ✅ / +40.65% ✅ / +40.24% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob015_multi_pipe_8bit | 3 | 16 | 3 | 0.0000 | 0 | +38.78% ✅ / +5.90% ✅ / +7.32% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob015_multi_pipe_8bit | 3 | 14 | 6 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / -18.29% ❌ |
| `classic` | RTLLM | Prob024_fsm | 2 | 18 | 1 | 0.3406 | 12 | +47.83% ✅ / +71.22% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob024_fsm | 2 | 10 | 2 | 0.1459 | 7 | +36.96% ✅ / +46.76% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob024_fsm | 2 | 9 | 2 | 0.1459 | 6 | +36.96% ✅ / +46.76% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 15 | 2 | 0.1011 | 6 | +60.00% ✅ / +56.95% ✅ / +29.63% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob037_parallel2serial | 3 | 5 | 3 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +3.70% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob037_parallel2serial | 3 | 8 | 1 | 0.0728 | 2 | +48.00% ✅ / +58.50% ✅ / +25.93% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 40 | 3 | 0.3621 | 36 | +40.00% ✅ / +99.20% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob041_traffic_light | 2 | 39 | 3 | 0.2273 | 23 | +22.94% ✅ / +99.09% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob041_traffic_light | 2 | 31 | 2 | 0.2333 | 21 | +23.53% ✅ / +99.21% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 69 | 2 | 0.2287 | 68 | +23.06% ✅ / +99.21% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob045_alu | 2 | 29 | 1 | 0.0565 | 29 | +25.44% ✅ / +22.19% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob045_alu | 2 | 32 | 4 | 0.0395 | 32 | +22.74% ✅ / +17.81% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 12 | 3 | 0.0203 | 8 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob049_signal_generator | 3 | 3 | 3 | 0.0130 | 3 | +18.09% ✅ / +46.04% ✅ / +25.58% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 4 | 1 | 0.0000 | 3 | +0.00% ➖ / +99.75% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 10 | 1 | 0.2562 | 10 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 7 | 1 | 0.2562 | 7 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 7 | 1 | 0.2562 | 7 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 6 | 1 | 0.0000 | 1 | +0.00% ➖ / +36.77% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0717 | 1 | +20.00% ✅ / +35.87% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 0 | -20.00% ❌ / +16.14% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 4 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 11 | 3 | 0.0000 | 0 | -4.55% ❌ / -48.10% ❌ / +35.71% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 13 | 3 | 0.0000 | 0 | -16.67% ❌ / -47.43% ❌ / +10.71% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 9 | 4 | 0.0000 | 0 | -34.85% ❌ / -47.43% ❌ / +10.71% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 14 | 6 | 0.0000 | 0 | +8.30% ✅ / +35.01% ✅ / +16.00% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 28 | 3 | 0.0034 | 9 | +9.75% ✅ / +36.84% ✅ / +10.67% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 23 | 5 | 0.0008 | 5 | +8.07% ✅ / +33.18% ✅ / +9.33% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1563 ± 0.1135 | 4.00 ± 3.63 | 18.86 ± 18.34 | 7 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0427 ± 0.0837 | 2.17 ± 1.63 | 2.33 ± 3.15 | 2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | 7 | 7 | 0.0686 ± 0.0641 | 2.14 ± 0.67 | 8.86 ± 8.95 | 0 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0552 ± 0.0820 | 1.67 ± 0.83 | 3.17 ± 3.05 | 3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | 7 | 7 | 0.0779 ± 0.0619 | 2.71 ± 1.33 | 9.29 ± 9.13 | 0 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0428 ± 0.0836 | 2.17 ± 1.47 | 2.33 ± 2.36 | 1 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.1038 ± 0.0764 | 3.15 ± 2.08 | 11.23 ± 10.69 | 9 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | ALL | 13 | 13 | 0.0625 ± 0.0491 | 1.92 ± 0.52 | 6.23 ± 5.09 | 3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | ALL | 13 | 13 | 0.0617 ± 0.0498 | 2.46 ± 0.96 | 6.08 ± 5.23 | 1 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob004_adder_8bit | grid_quantile | 50.0% | 0.2809 | 0.1404 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob004_adder_8bit | grid_quantile | 50.0% | 0.2809 | 0.1404 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 18.8% | 0.2567 | 0.0717 | 6/32 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 18.8% | -0.2341 | 0.0528 | 6/32 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob024_fsm | grid_quantile | 50.0% | 1.4917 | 0.5002 | 3/6 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob024_fsm | grid_quantile | 50.0% | 1.4139 | 0.5002 | 3/6 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob037_parallel2serial | grid_quantile | 50.0% | 0.0000 | -0.0000 | 1/2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob037_parallel2serial | grid_quantile | 75.0% | 0.5440 | 0.4414 | 3/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob041_traffic_light | grid_quantile | 50.0% | 2.0351 | 0.4062 | 8/16 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob041_traffic_light | grid_quantile | 27.8% | 3.5075 | 0.4077 | 10/36 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob045_alu | grid_quantile | 83.3% | 1.0800 | 0.1588 | 10/12 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob045_alu | grid_quantile | 83.3% | 1.0657 | 0.1246 | 10/12 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob049_signal_generator | grid_quantile | 66.7% | 0.4695 | 0.2348 | 2/3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob049_signal_generator | grid_quantile | 100.0% | 0.7260 | 0.2565 | 3/3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 44.4% | 0.9278 | 0.3468 | 4/9 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 44.4% | 0.8922 | 0.3468 | 4/9 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 50.0% | 0.1734 | 0.1862 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 25.0% | -0.0129 | -0.0129 | 1/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 50.0% | 0.0010 | 0.0010 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 50.0% | 0.0010 | 0.0010 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 14.6% | -3.0218 | -0.2167 | 7/48 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 62.5% | -1.5423 | -0.3010 | 5/8 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 50.0% | 0.5412 | 0.1796 | 6/12 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 41.7% | -0.2367 | 0.1356 | 5/12 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 100 | 2 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=83, warmup_buffered=17; replay duplicate_objectives=15, filled_empty=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 100 | 2 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=92, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 39 | 18 | init=warmup_complete, shape=4x2x4 | none | live crowding_evicted=8, duplicate_objectives=13, filled_empty=1, pareto_inserted=9, warmup_buffered=8; replay filled_empty=5, pareto_inserted=3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 26 | 13 | init=warmup_complete, shape=4x2x4 | none | live crowding_evicted=7, duplicate_objectives=6, filled_empty=1, pareto_inserted=4, warmup_buffered=8; replay filled_empty=5, pareto_inserted=3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 58 | 11 | init=warmup_complete, shape=2x1x3 | ff_depth | live crowding_evicted=6, duplicate_objectives=36, filled_empty=1, pareto_inserted=1, warmup_buffered=14; replay crowding_evicted=1, duplicate_objectives=4, filled_empty=2, pareto_inserted=7 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 60 | 11 | init=warmup_complete, shape=2x1x3 | ff_depth | live crowding_evicted=1, duplicate_objectives=35, pareto_inserted=3, warmup_buffered=21; replay duplicate_objectives=13, filled_empty=3, pareto_inserted=5 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 27 | 5 | init=run_finalization_fallback, shape=1x1x2 | logic_depth, ff_depth | live warmup_buffered=27; replay duplicate_objectives=22, filled_empty=1, pareto_inserted=4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 32 | 7 | init=warmup_complete, shape=1x2x2 | logic_depth | live crowding_evicted=2, duplicate_objectives=16, filled_empty=2, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=7, filled_empty=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 64 | 25 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=16, duplicate_objectives=23, filled_empty=2, pareto_inserted=15, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 54 | 31 | init=warmup_complete, shape=3x3x4 | none | live duplicate_objectives=23, filled_empty=4, pareto_inserted=19, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 31 | 23 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=7, duplicate_objectives=1, filled_empty=4, pareto_inserted=11, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 33 | 31 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=2, filled_empty=4, pareto_inserted=19, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 97 | 3 | init=run_finalization_fallback, shape=1x1x3 | logic_depth, ff_depth | live warmup_buffered=97; replay duplicate_objectives=94, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 94 | 4 | init=run_finalization_fallback, shape=1x1x3 | logic_depth, ff_depth | live warmup_buffered=94; replay duplicate_objectives=90, filled_empty=3, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 59 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=59; replay duplicate_objectives=57, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 54 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=54; replay duplicate_objectives=52, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 62 | 8 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=49, filled_empty=1, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 84 | 7 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=73, filled_empty=1, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=3, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 114 | 5 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=104, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 94 | 4 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=84, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 27 | 4 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=18, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 34 | 4 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=15, pareto_inserted=1, warmup_buffered=18; replay duplicate_objectives=15, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 13 | 13 | init=warmup_complete, shape=3x4x4 | none | live filled_empty=1, pareto_inserted=4, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 13 | 11 | init=warmup_complete, shape=1x2x4 | logic_depth | live duplicate_objectives=2, pareto_inserted=3, warmup_buffered=8; replay filled_empty=5, pareto_inserted=3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 57 | 25 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=6, duplicate_objectives=26, filled_empty=2, pareto_inserted=15, warmup_buffered=8; replay filled_empty=4, pareto_inserted=4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 48 | 17 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=10, duplicate_objectives=20, filled_empty=2, pareto_inserted=8, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=3, pareto_inserted=4 |

