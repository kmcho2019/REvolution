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
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 853839.77 ± 99500.34 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 802758.00 ± 153436.68 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 913435.17 ± 115991.31 | 240.00 | 240.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (62.5%) | ✅ Pass (60.8%) | 73 | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 1352.96 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob004_adder_8bit | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 100 | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 841.20 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob004_adder_8bit | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 100 | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 706.36 | 240 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (43.3%) | ✅ Pass (41.7%) | 50 | +16.85% ✅ | +12.35% ✅ / +40.65% ✅ / -2.44% ❌ | +16.85% ✅ | 2140.87 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (33.3%) | ✅ Pass (32.5%) | 39 | +7.17% ✅ | +38.78% ✅ / +5.90% ✅ / -23.17% ❌ | +7.17% ✅ | 1968.26 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (11.7%) | ✅ Pass (10.0%) | 12 | +9.22% ✅ | +42.45% ✅ / +13.25% ✅ / -28.05% ❌ | +9.22% ✅ | 1430.63 | 240 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (25.0%) | ✅ Pass (23.3%) | 28 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 1165.97 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob024_fsm | ✅ Pass (54.2%) | ✅ Pass (48.3%) | 58 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1339.57 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob024_fsm | ✅ Pass (55.0%) | ✅ Pass (53.3%) | 64 | +53.85% ✅ | +34.78% ✅ / +47.77% ✅ / N/A | +41.28% ✅ | 1107.43 | 240 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (31.7%) | ✅ Pass (28.3%) | 34 | +48.57% ✅ | +60.00% ✅ / +56.07% ✅ / +29.63% ✅ | +48.57% ✅ | 1642.43 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob037_parallel2serial | ✅ Pass (22.5%) | ✅ Pass (22.5%) | 27 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1719.98 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob037_parallel2serial | ✅ Pass (34.2%) | ✅ Pass (33.3%) | 40 | +44.14% ✅ | +48.00% ✅ / +58.50% ✅ / +25.93% ✅ | +44.14% ✅ | 1572.68 | 240 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (51.7%) | ✅ Pass (50.8%) | 61 | +42.09% ✅ | +27.06% ✅ / +99.20% ✅ / N/A | +63.13% ✅ | 1784.54 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob041_traffic_light | ✅ Pass (53.3%) | ✅ Pass (53.3%) | 64 | +40.62% ✅ | +22.94% ✅ / +98.93% ✅ / N/A | +60.93% ✅ | 2096.46 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob041_traffic_light | ✅ Pass (39.2%) | ✅ Pass (39.2%) | 47 | +39.87% ✅ | +20.59% ✅ / +99.03% ✅ / N/A | +59.81% ✅ | 2180.08 | 240 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (60.8%) | ✅ Pass (60.8%) | 73 | +40.73% ✅ | +23.06% ✅ / +99.13% ✅ / N/A | +61.09% ✅ | 1646.21 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob045_alu | ✅ Pass (27.5%) | ✅ Pass (25.8%) | 31 | +15.88% ✅ | +25.44% ✅ / +22.19% ✅ / N/A | +23.82% ✅ | 1692.81 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob045_alu | ✅ Pass (36.7%) | ✅ Pass (36.7%) | 44 | +13.85% ✅ | +23.06% ✅ / +18.51% ✅ / N/A | +20.78% ✅ | 1683.45 | 240 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (51.7%) | ✅ Pass (51.7%) | 62 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 992.84 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob049_signal_generator | ✅ Pass (80.8%) | ✅ Pass (80.8%) | 97 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 1000.49 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob049_signal_generator | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 100 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 827.09 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (65.8%) | ✅ Pass (64.2%) | 77 | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 1809.79 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (49.2%) | ✅ Pass (49.2%) | 59 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 2254.39 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (44.2%) | ✅ Pass (44.2%) | 53 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 2024.26 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 75 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 2102.42 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (51.7%) | ✅ Pass (51.7%) | 62 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 2228.72 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (50.8%) | ✅ Pass (50.8%) | 61 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 2287.12 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (86.7%) | ✅ Pass (86.7%) | 104 | +12.26% ✅ | +0.00% ➖ / +36.77% ✅ / N/A | +18.39% ✅ | 1703.35 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (95.0%) | ✅ Pass (95.0%) | 114 | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 1540.40 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (79.2%) | ✅ Pass (79.2%) | 95 | +3.50% ✅ | -20.00% ❌ / +30.49% ✅ / N/A | +5.25% ✅ | 1845.13 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (46.7%) | ✅ Pass (46.7%) | 56 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1408.21 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (22.5%) | ✅ Pass (22.5%) | 27 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1272.07 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (26.7%) | ✅ Pass (26.7%) | 32 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1347.11 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (14.2%) | ✅ Pass (14.2%) | 17 | -10.71% ❌ | -4.55% ❌ / -63.31% ❌ / +35.71% ✅ | -10.71% ❌ | 1963.67 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (10.8%) | ✅ Pass (10.8%) | 13 | -21.67% ❌ | -16.67% ❌ / -51.90% ❌ / +3.57% ✅ | -21.67% ❌ | 1997.12 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (11.7%) | ✅ Pass (11.7%) | 14 | -19.29% ❌ | -30.30% ❌ / -52.57% ❌ / +25.00% ✅ | -19.29% ❌ | 1621.61 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (27.5%) | ✅ Pass (25.0%) | 30 | +13.55% ✅ | +8.30% ✅ / +35.01% ✅ / -2.67% ❌ | +13.55% ✅ | 1980.50 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (47.5%) | ✅ Pass (47.5%) | 57 | +17.96% ✅ | +9.36% ✅ / +33.87% ✅ / +10.67% ✅ | +17.96% ✅ | 3487.94 | 240 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (45.8%) | ✅ Pass (45.8%) | 55 | +14.31% ✅ | +7.47% ✅ / +27.46% ✅ / +8.00% ✅ | +14.31% ✅ | 2368.98 | 240 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 46.7% ± 10.5% | 45.4% ± 11.1% | 7/7 | +39.42% ± 12.29% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (381 samples) | +46.43% ± 13.38% ✅ | +27.06% ± 15.25% ✅ / +73.04% ± 19.38% ✅ / +13.71% ± 18.15% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1532.26 ± 289.53 | 240.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 50.6% ± 21.3% | 49.9% ± 21.5% | 6/6 | +13.84% ± 14.35% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | 6/6 (359 samples) | +20.52% ± 20.57% ✅ | +7.29% ± 13.25% ✅ / +28.71% ± 44.83% ✅ / +16.52% ± 37.61% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ❌ 1/2 | 1827.99 ± 198.94 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 50.7% ± 18.2% | 49.5% ± 18.4% | 7/7 | +21.60% ± 13.31% ✅ | ✅ 6 / ➖ 1 / ❌ 0 | 7/7 (416 samples) | +24.36% ± 14.61% ✅ | +19.55% ± 8.91% ✅ / +35.19% ± 24.64% ✅ / -3.85% ± 20.05% ❌ | ✅ 6 / ➖ 1 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1522.68 ± 353.51 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.1% ± 23.3% | 46.1% ± 23.3% | 6/6 | +8.48% ± 15.64% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (332 samples) | +13.03% ± 20.44% ✅ | +8.78% ± 15.61% ✅ / +14.30% ± 32.04% ✅ / +7.12% ± 6.95% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 2130.11 ± 616.76 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 49.0% ± 19.7% | 48.5% ± 20.0% | 7/7 | +28.77% ± 12.89% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (407 samples) | +31.81% ± 12.84% ✅ | +29.03% ± 9.41% ✅ / +44.29% ± 21.69% ✅ / +3.94% ± 32.08% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1358.24 ± 382.84 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 43.1% ± 18.3% | 43.1% ± 18.3% | 6/6 | +5.75% ± 14.29% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (310 samples) | +9.04% ± 19.02% ✅ | -0.47% ± 19.51% ❌ / +12.22% ± 31.33% ✅ / +16.50% ± 16.66% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 1915.70 ± 314.00 | 240.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 48.5% ± 10.9% | 47.4% ± 11.1% | 13/13 | +27.61% ± 11.50% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (740 samples) | +34.47% ± 13.53% ✅ | +17.94% ± 11.29% ✅ / +52.58% ± 25.38% ✅ / +14.84% ± 15.56% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 2/5 | 1668.75 ± 192.71 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 48.6% ± 14.0% | 47.9% ± 14.0% | 13/13 | +15.55% ± 10.42% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (748 samples) | +19.13% ± 12.16% ✅ | +14.58% ± 8.80% ✅ / +25.54% ± 19.89% ✅ / +0.54% ± 12.37% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 1803.03 ± 368.99 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 46.3% ± 13.1% | 46.0% ± 13.2% | 13/13 | +18.14% ± 11.23% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (717 samples) | +21.30% ± 12.46% ✅ | +15.42% ± 12.90% ✅ / +29.49% ± 19.93% ✅ / +8.97% ± 19.31% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 1/5 | 1615.53 ± 288.35 | 240.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 12 | 2 | 0.0410 | 2 | +15.22% ✅ / +98.97% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.0410 | 1 | +15.22% ✅ / +26.91% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.0410 | 1 | +15.22% ✅ / +26.91% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 37 | 15 | 0.0000 | 0 | +38.78% ✅ / +40.65% ✅ / +40.24% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob015_multi_pipe_8bit | 3 | 16 | 3 | 0.0000 | 0 | +38.78% ✅ / +5.90% ✅ / +7.32% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 5 | 0.0000 | 0 | +42.45% ✅ / +13.25% ✅ / +34.15% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 18 | 1 | 0.3406 | 12 | +47.83% ✅ / +71.22% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob024_fsm | 2 | 10 | 2 | 0.1459 | 7 | +36.96% ✅ / +46.76% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob024_fsm | 2 | 12 | 2 | 0.1724 | 9 | +36.96% ✅ / +47.77% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 15 | 2 | 0.1011 | 6 | +60.00% ✅ / +56.95% ✅ / +29.63% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob037_parallel2serial | 3 | 5 | 3 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +3.70% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob037_parallel2serial | 3 | 11 | 1 | 0.0728 | 3 | +48.00% ✅ / +58.50% ✅ / +25.93% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 40 | 3 | 0.3621 | 36 | +40.00% ✅ / +99.20% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob041_traffic_light | 2 | 39 | 3 | 0.2273 | 23 | +22.94% ✅ / +99.09% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob041_traffic_light | 2 | 34 | 2 | 0.2040 | 21 | +20.59% ✅ / +99.09% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 69 | 2 | 0.2287 | 68 | +23.06% ✅ / +99.21% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob045_alu | 2 | 29 | 1 | 0.0565 | 29 | +25.44% ✅ / +22.19% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob045_alu | 2 | 43 | 2 | 0.0481 | 43 | +23.06% ✅ / +21.40% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 12 | 3 | 0.0203 | 8 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob049_signal_generator | 3 | 4 | 2 | 0.0129 | 4 | +20.21% ✅ / +46.04% ✅ / +13.95% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 4 | 1 | 0.0000 | 3 | +0.00% ➖ / +99.75% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 10 | 1 | 0.2562 | 10 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 7 | 1 | 0.2562 | 7 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 9 | 1 | 0.2562 | 8 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 6 | 1 | 0.0000 | 1 | +0.00% ➖ / +36.77% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0717 | 1 | +20.00% ✅ / +35.87% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 6 | 1 | 0.0000 | 0 | -20.00% ❌ / +30.49% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 4 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 11 | 3 | 0.0000 | 0 | -4.55% ❌ / -48.10% ❌ / +35.71% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 13 | 3 | 0.0000 | 0 | -16.67% ❌ / -47.43% ❌ / +10.71% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 11 | 2 | 0.0000 | 0 | -25.76% ❌ / -45.64% ❌ / +25.00% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 14 | 6 | 0.0000 | 0 | +8.30% ✅ / +35.01% ✅ / +16.00% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 28 | 3 | 0.0034 | 9 | +9.75% ✅ / +36.84% ✅ / +10.67% ✅ |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 37 | 10 | 0.0018 | 9 | +10.51% ✅ / +34.78% ✅ / +13.33% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1563 ± 0.1135 | 4.00 ± 3.63 | 18.86 ± 18.34 | 7 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0427 ± 0.0837 | 2.17 ± 1.63 | 2.33 ± 3.15 | 3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | 7 | 7 | 0.0686 ± 0.0641 | 2.14 ± 0.67 | 8.86 ± 8.95 | 0 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0552 ± 0.0820 | 1.67 ± 0.83 | 3.17 ± 3.05 | 3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | 7 | 7 | 0.0787 ± 0.0585 | 2.14 ± 1.00 | 11.57 ± 11.55 | 0 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0430 ± 0.0836 | 2.67 ± 2.89 | 3.17 ± 3.33 | 0 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.1038 ± 0.0764 | 3.15 ± 2.08 | 11.23 ± 10.69 | 10 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | ALL | 13 | 13 | 0.0625 ± 0.0491 | 1.92 ± 0.52 | 6.23 ± 5.09 | 3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | ALL | 13 | 13 | 0.0622 ± 0.0486 | 2.38 ± 1.38 | 7.69 ± 6.61 | 0 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob004_adder_8bit | grid_quantile | 50.0% | 0.2809 | 0.1404 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob004_adder_8bit | grid_quantile | 50.0% | 0.2809 | 0.1404 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 18.8% | 0.2567 | 0.0717 | 6/32 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 18.8% | -1.2086 | 0.0922 | 9/48 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob024_fsm | grid_quantile | 50.0% | 1.4917 | 0.5002 | 3/6 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob024_fsm | grid_quantile | 50.0% | 1.4521 | 0.5385 | 3/6 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob037_parallel2serial | grid_quantile | 50.0% | 0.0000 | -0.0000 | 1/2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob037_parallel2serial | grid_quantile | 55.6% | 0.6420 | 0.4414 | 5/9 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob041_traffic_light | grid_quantile | 50.0% | 2.0351 | 0.4062 | 8/16 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob041_traffic_light | grid_quantile | 17.2% | 3.7144 | 0.3987 | 11/64 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob045_alu | grid_quantile | 83.3% | 1.0800 | 0.1588 | 10/12 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob045_alu | grid_quantile | 81.2% | 1.3504 | 0.1385 | 13/16 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob049_signal_generator | grid_quantile | 66.7% | 0.4695 | 0.2348 | 2/3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob049_signal_generator | grid_quantile | 33.3% | 0.4986 | 0.2638 | 2/6 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 44.4% | 0.9278 | 0.3468 | 4/9 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 33.3% | 1.1461 | 0.3468 | 4/12 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 50.0% | 0.1734 | 0.1862 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 33.3% | -0.2188 | 0.0350 | 3/9 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 50.0% | 0.0010 | 0.0010 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 50.0% | 0.0010 | 0.0010 | 2/4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 14.6% | -3.0218 | -0.2167 | 7/48 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 25.0% | -1.0715 | -0.1929 | 4/16 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 50.0% | 0.5412 | 0.1796 | 6/12 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 50.0% | -0.2519 | 0.1431 | 6/12 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 100 | 2 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=83, warmup_buffered=17; replay duplicate_objectives=15, filled_empty=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 100 | 2 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=80, warmup_buffered=20; replay duplicate_objectives=18, filled_empty=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 39 | 18 | init=warmup_complete, shape=4x2x4 | none | live crowding_evicted=8, duplicate_objectives=13, filled_empty=1, pareto_inserted=9, warmup_buffered=8; replay filled_empty=5, pareto_inserted=3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 12 | 10 | init=warmup_complete, shape=4x3x4 | none | live duplicate_objectives=2, filled_empty=2, warmup_buffered=8; replay filled_empty=7, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 58 | 11 | init=warmup_complete, shape=2x1x3 | ff_depth | live crowding_evicted=6, duplicate_objectives=36, filled_empty=1, pareto_inserted=1, warmup_buffered=14; replay crowding_evicted=1, duplicate_objectives=4, filled_empty=2, pareto_inserted=7 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 64 | 11 | init=warmup_complete, shape=2x1x3 | ff_depth | live crowding_evicted=6, duplicate_objectives=41, pareto_inserted=3, warmup_buffered=14; replay duplicate_objectives=6, filled_empty=3, pareto_inserted=5 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 27 | 5 | init=run_finalization_fallback, shape=1x1x2 | logic_depth, ff_depth | live warmup_buffered=27; replay duplicate_objectives=22, filled_empty=1, pareto_inserted=4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 40 | 11 | init=warmup_complete, shape=1x3x3 | logic_depth | live crowding_evicted=2, duplicate_objectives=21, filled_empty=3, pareto_inserted=6, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 64 | 25 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=16, duplicate_objectives=23, filled_empty=2, pareto_inserted=15, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 47 | 34 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=2, duplicate_objectives=10, filled_empty=5, pareto_inserted=22, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=6, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 31 | 23 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=7, duplicate_objectives=1, filled_empty=4, pareto_inserted=11, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 44 | 34 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=9, duplicate_objectives=1, filled_empty=6, pareto_inserted=20, warmup_buffered=8; replay filled_empty=7, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 97 | 3 | init=run_finalization_fallback, shape=1x1x3 | logic_depth, ff_depth | live warmup_buffered=97; replay duplicate_objectives=94, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 100 | 5 | init=warmup_complete, shape=2x1x3 | ff_depth | live duplicate_objectives=37, pareto_inserted=1, warmup_buffered=62; replay duplicate_objectives=58, filled_empty=2, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 59 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=59; replay duplicate_objectives=57, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 53 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=53; replay duplicate_objectives=51, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 62 | 8 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=49, filled_empty=1, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 61 | 9 | init=warmup_complete, shape=3x1x4 | ff_depth | live duplicate_objectives=49, filled_empty=1, pareto_inserted=3, warmup_buffered=8; replay duplicate_objectives=3, filled_empty=3, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 114 | 5 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=104, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 95 | 8 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=82, filled_empty=1, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 27 | 4 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=18, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 32 | 3 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=17, warmup_buffered=15; replay duplicate_objectives=12, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 13 | 13 | init=warmup_complete, shape=3x4x4 | none | live filled_empty=1, pareto_inserted=4, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 14 | 11 | init=warmup_complete, shape=2x2x4 | none | live duplicate_objectives=2, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=4, pareto_inserted=3 |
| `grid_quantile_pareto_journal_bd_unified_rebin_off` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 57 | 25 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=6, duplicate_objectives=26, filled_empty=2, pareto_inserted=15, warmup_buffered=8; replay filled_empty=4, pareto_inserted=4 |
| `grid_quantile_pareto_journal_bd_unified_rebin_on` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 55 | 20 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=21, duplicate_objectives=13, filled_empty=2, pareto_inserted=11, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=4, pareto_inserted=3 |

