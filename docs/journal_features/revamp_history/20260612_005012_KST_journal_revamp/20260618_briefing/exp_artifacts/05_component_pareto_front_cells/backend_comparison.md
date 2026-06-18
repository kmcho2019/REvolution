# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 851249.15 ± 103388.12 | 240.00 | 240.00 |
| `classic` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 838941.86 ± 158125.08 | 240.00 | 240.00 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 865607.67 ± 142422.63 | 240.00 | 240.00 |
| `grid_quantile_journal_bd` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 848997.08 ± 97243.78 | 240.00 | 240.00 |
| `grid_quantile_journal_bd` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 841220.71 ± 157834.97 | 240.00 | 240.00 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 858069.50 ± 119075.45 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 874422.69 ± 98291.54 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 885722.43 ± 163884.46 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 861239.67 ± 111306.03 | 240.00 | 240.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (68.3%) | ✅ Pass (68.3%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 893.72 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob004_adder_8bit | ✅ Pass (65.0%) | ✅ Pass (65.0%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 1014.30 | 240 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob004_adder_8bit | ✅ Pass (45.8%) | ✅ Pass (45.8%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 904.11 | 240 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (44.2%) | ✅ Pass (41.7%) | +25.40% ✅ | +39.69% ✅ / +59.69% ✅ / -23.17% ❌ | +25.40% ✅ | 1900.32 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (32.5%) | ✅ Pass (25.8%) | +8.84% ✅ | +35.71% ✅ / +26.17% ✅ / -35.37% ❌ | +8.84% ✅ | 1914.96 | 240 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (56.7%) | ✅ Pass (55.8%) | +5.72% ✅ | -16.02% ❌ / +5.12% ✅ / +28.05% ✅ | +5.72% ✅ | 1692.86 | 240 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (27.5%) | ✅ Pass (24.2%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 955.49 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob024_fsm | ✅ Pass (25.8%) | ✅ Pass (20.8%) | +58.45% ✅ | +34.78% ✅ / +60.58% ✅ / N/A | +47.68% ✅ | 953.70 | 240 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob024_fsm | ✅ Pass (40.8%) | ✅ Pass (35.8%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 819.63 | 240 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (25.8%) | ✅ Pass (23.3%) | +11.38% ✅ | +4.00% ✅ / +22.74% ✅ / +7.41% ✅ | +11.38% ✅ | 1259.25 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob037_parallel2serial | ✅ Pass (31.7%) | ✅ Pass (28.3%) | +46.86% ✅ | +54.00% ✅ / +56.95% ✅ / +29.63% ✅ | +46.86% ✅ | 1270.62 | 240 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob037_parallel2serial | ✅ Pass (34.2%) | ✅ Pass (25.8%) | +6.33% ✅ | +6.00% ✅ / +9.27% ✅ / +3.70% ✅ | +6.33% ✅ | 1231.82 | 240 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (60.8%) | ✅ Pass (60.8%) | +44.83% ✅ | +35.29% ✅ / +99.20% ✅ / N/A | +67.25% ✅ | 1389.82 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob041_traffic_light | ✅ Pass (46.7%) | ✅ Pass (45.8%) | +47.36% ✅ | +42.94% ✅ / +99.15% ✅ / N/A | +71.04% ✅ | 1780.24 | 240 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob041_traffic_light | ✅ Pass (43.3%) | ✅ Pass (42.5%) | +41.87% ✅ | +26.47% ✅ / +99.15% ✅ / N/A | +62.81% ✅ | 1738.85 | 240 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (64.2%) | ✅ Pass (64.2%) | +40.77% ✅ | +23.15% ✅ / +99.16% ✅ / N/A | +61.16% ✅ | 1605.90 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob045_alu | ✅ Pass (67.5%) | ✅ Pass (67.5%) | +14.57% ✅ | +21.44% ✅ / +22.28% ✅ / N/A | +21.86% ✅ | 1660.75 | 240 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob045_alu | ✅ Pass (68.3%) | ✅ Pass (68.3%) | +38.37% ✅ | +16.00% ✅ / +99.10% ✅ / N/A | +57.55% ✅ | 1550.57 | 240 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (51.7%) | ✅ Pass (51.7%) | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 832.31 | 240 |
| `grid_quantile_journal_bd` | RTLLM | Prob049_signal_generator | ✅ Pass (50.0%) | ✅ Pass (50.0%) | +27.42% ✅ | +10.64% ✅ / +46.04% ✅ / +25.58% ✅ | +27.42% ✅ | 828.13 | 240 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob049_signal_generator | ✅ Pass (61.7%) | ✅ Pass (61.7%) | +27.38% ✅ | +24.47% ✅ / +46.04% ✅ / +11.63% ✅ | +27.38% ✅ | 861.31 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (65.8%) | ✅ Pass (65.0%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1277.08 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (44.2%) | ✅ Pass (44.2%) | +33.24% ✅ | +0.00% ➖ / +99.71% ✅ / N/A | +49.86% ✅ | 1377.62 | 240 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (44.2%) | ✅ Pass (44.2%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1371.99 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (55.8%) | ✅ Pass (55.8%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1815.68 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (68.3%) | ✅ Pass (68.3%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1793.91 | 240 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (75.8%) | ✅ Pass (75.8%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1939.16 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (82.5%) | ✅ Pass (82.5%) | +12.26% ✅ | +0.00% ➖ / +36.77% ✅ / N/A | +18.39% ✅ | 1437.92 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (80.8%) | ✅ Pass (80.8%) | +33.10% ✅ | +0.00% ➖ / +99.31% ✅ / N/A | +49.66% ✅ | 1432.88 | 240 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (90.0%) | ✅ Pass (90.0%) | +12.26% ✅ | +0.00% ➖ / +36.77% ✅ / N/A | +18.39% ✅ | 1381.12 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (45.8%) | ✅ Pass (45.8%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1432.37 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (50.8%) | ✅ Pass (50.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1234.54 | 240 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (47.5%) | ✅ Pass (47.5%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1334.33 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (13.3%) | ✅ Pass (12.5%) | -29.01% ❌ | -39.39% ❌ / -47.65% ❌ / +0.00% ➖ | -29.01% ❌ | 1399.67 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (22.5%) | ✅ Pass (20.0%) | -19.46% ❌ | -21.21% ❌ / -51.45% ❌ / +14.29% ✅ | -19.46% ❌ | 1489.69 | 240 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (31.7%) | ✅ Pass (31.7%) | -14.22% ❌ | -16.67% ❌ / -47.43% ❌ / +21.43% ✅ | -14.22% ❌ | 1364.28 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (32.5%) | ✅ Pass (32.5%) | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1328.20 | 240 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (57.5%) | ✅ Pass (54.2%) | +15.56% ✅ | +8.07% ✅ / +29.29% ✅ / +9.33% ✅ | +15.56% ✅ | 1677.46 | 240 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (57.5%) | ✅ Pass (53.3%) | +16.71% ✅ | +8.76% ✅ / +32.04% ✅ / +9.33% ✅ | +16.71% ✅ | 2183.83 | 240 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 48.9% ± 12.7% | 47.7% ± 13.8% | 7/7 | +35.73% ± 13.41% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 | +42.94% ± 16.06% ✅ | +24.16% ± 13.33% ✅ / +71.00% ± 22.33% ✅ / -0.60% ± 22.42% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1262.40 ± 295.75 | 240.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 49.3% ± 19.6% | 49.0% ± 19.7% | 6/6 | +5.46% ± 16.79% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 | +9.48% ± 21.27% ✅ | +1.40% ± 20.24% ✅ / +14.77% ± 30.83% ✅ / +0.67% ± 1.31% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1448.49 ± 152.43 | 240.00 ± 0.00 |
| `grid_quantile_journal_bd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 45.6% ± 12.2% | 43.3% ± 14.0% | 7/7 | +33.79% ± 13.51% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 | +39.03% ± 15.46% ✅ | +28.50% ± 13.96% ✅ / +58.59% ± 23.05% ✅ / +6.62% ± 41.21% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1346.10 ± 324.20 | 240.00 ± 0.00 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 54.0% ± 16.1% | 53.1% ± 16.7% | 6/6 | +16.19% ± 17.72% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | 6/6 | +24.61% ± 24.39% ✅ | +4.48% ± 15.98% ✅ / +40.15% ± 47.66% ✅ / +11.81% ± 4.85% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1501.02 ± 163.17 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 50.1% ± 9.1% | 48.0% ± 11.1% | 7/7 | +31.57% ± 16.09% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 | +38.40% ± 18.52% ✅ | +14.96% ± 15.33% ✅ / +61.27% ± 30.95% ✅ / +14.46% ± 14.05% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ❌ 1/7 / P ✅ 0/7 / T ✅ 0/3 | 1257.02 ± 299.60 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 57.8% ± 17.3% | 57.1% ± 17.4% | 6/6 | +8.45% ± 13.42% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 | +12.47% ± 18.23% ✅ | +5.35% ± 15.11% ✅ / +14.89% ± 30.81% ✅ / +15.38% ± 11.85% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1595.79 ± 295.48 | 240.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 49.1% ± 10.8% | 48.3% ± 11.2% | 13/13 | +21.76% ± 13.25% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 | +27.50% ± 15.67% ✅ | +13.65% ± 12.96% ✅ / +45.05% ± 23.85% ✅ / -0.10% ± 12.30% ❌ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 1348.29 ± 175.42 | 240.00 ± 0.00 |
| `grid_quantile_journal_bd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 49.5% ± 9.8% | 47.8% ± 10.7% | 13/13 | +25.66% ± 11.58% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 | +32.37% ± 13.97% ✅ | +17.41% ± 12.15% ✅ / +50.08% ± 24.64% ✅ / +8.69% ± 22.76% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 1417.60 ± 187.96 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 53.7% ± 9.2% | 52.2% ± 9.9% | 13/13 | +20.90% ± 12.12% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 | +26.43% ± 14.48% ✅ | +10.53% ± 10.70% ✅ / +39.86% ± 24.73% ✅ / +14.83% ± 8.57% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ✅ 0/5 | 1413.38 ± 223.80 | 240.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 10 | 2 | 0.0410 | 2 | +15.22% ✅ / +98.97% ✅ / N/A |
| `grid_quantile_journal_bd` | RTLLM | Prob004_adder_8bit | 2 | 11 | 2 | 0.0410 | 2 | +15.22% ✅ / +98.97% ✅ / N/A |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob004_adder_8bit | 2 | 7 | 2 | 0.0410 | 2 | +15.22% ✅ / +98.97% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 37 | 11 | 0.0000 | 0 | +39.69% ✅ / +59.69% ✅ / +41.46% ✅ |
| `grid_quantile_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 28 | 13 | 0.0000 | 1 | +38.78% ✅ / +26.17% ✅ / +39.02% ✅ |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 46 | 12 | 0.0000 | 0 | +39.39% ✅ / +8.24% ✅ / +39.02% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 22 | 1 | 0.3406 | 10 | +47.83% ✅ / +71.22% ✅ / N/A |
| `grid_quantile_journal_bd` | RTLLM | Prob024_fsm | 2 | 18 | 2 | 0.2170 | 10 | +36.96% ✅ / +60.58% ✅ / N/A |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob024_fsm | 2 | 15 | 1 | 0.3406 | 7 | +47.83% ✅ / +71.22% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 11 | 2 | 0.0007 | 2 | +6.00% ✅ / +22.74% ✅ / +7.41% ✅ |
| `grid_quantile_journal_bd` | RTLLM | Prob037_parallel2serial | 3 | 14 | 1 | 0.0911 | 4 | +54.00% ✅ / +56.95% ✅ / +29.63% ✅ |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob037_parallel2serial | 3 | 13 | 2 | 0.0002 | 2 | +6.00% ✅ / +12.36% ✅ / +3.70% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 56 | 3 | 0.3611 | 47 | +38.24% ✅ / +99.21% ✅ / N/A |
| `grid_quantile_journal_bd` | RTLLM | Prob041_traffic_light | 2 | 39 | 3 | 0.4259 | 31 | +42.94% ✅ / +99.20% ✅ / N/A |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob041_traffic_light | 2 | 40 | 6 | 0.2900 | 31 | +32.94% ✅ / +99.21% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 68 | 3 | 0.2366 | 68 | +26.16% ✅ / +99.16% ✅ / N/A |
| `grid_quantile_journal_bd` | RTLLM | Prob045_alu | 2 | 70 | 7 | 0.0521 | 69 | +23.06% ✅ / +22.89% ✅ / N/A |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob045_alu | 2 | 63 | 2 | 0.1782 | 63 | +24.27% ✅ / +99.10% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 12 | 3 | 0.0216 | 6 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `grid_quantile_journal_bd` | RTLLM | Prob049_signal_generator | 3 | 13 | 4 | 0.0263 | 10 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob049_signal_generator | 3 | 11 | 4 | 0.0228 | 8 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.71% ✅ / N/A |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 10 | 1 | 0.2562 | 10 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 9 | 1 | 0.2562 | 9 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 8 | 1 | 0.2562 | 8 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 1 | +0.00% ➖ / +36.77% ✅ / N/A |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 9 | 1 | 0.0000 | 1 | +0.00% ➖ / +99.31% ✅ / N/A |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 1 | 0.0000 | 1 | +0.00% ➖ / +36.77% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 5 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 4 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 8 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 13 | 3 | 0.0000 | 0 | -25.76% ❌ / -45.19% ❌ / +0.00% ➖ |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 20 | 4 | 0.0000 | 0 | -21.21% ❌ / -45.19% ❌ / +17.86% ✅ |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 33 | 8 | 0.0000 | 0 | -9.09% ❌ / -43.85% ❌ / +25.00% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 14 | 5 | 0.0003 | 2 | +7.77% ✅ / +31.58% ✅ / +12.00% ✅ |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 46 | 11 | 0.0025 | 13 | +9.06% ✅ / +36.61% ✅ / +12.00% ✅ |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 37 | 4 | 0.0027 | 9 | +10.48% ✅ / +36.16% ✅ / +9.33% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1431 ± 0.1214 | 3.57 ± 2.49 | 19.29 ± 20.00 | 3 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0428 ± 0.0837 | 2.00 ± 1.34 | 2.50 ± 2.98 | 3 |
| `grid_quantile_journal_bd` | RTLLM | 7 | 7 | 0.1219 ± 0.1123 | 4.57 ± 3.11 | 18.14 ± 18.24 | 4 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0431 ± 0.0835 | 3.17 ± 3.22 | 4.17 ± 4.39 | 1 |
| `grid_quantile_pareto_journal_bd` | RTLLM | 7 | 7 | 0.1247 ± 0.1070 | 4.14 ± 2.85 | 16.14 ± 17.18 | 0 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0431 ± 0.0835 | 2.67 ± 2.30 | 3.33 ± 3.23 | 2 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.0968 ± 0.0782 | 2.85 ± 1.49 | 11.54 ± 11.48 | 6 |
| `grid_quantile_journal_bd` | ALL | 13 | 13 | 0.0855 ± 0.0723 | 3.92 ± 2.18 | 11.69 ± 10.43 | 5 |
| `grid_quantile_pareto_journal_bd` | ALL | 13 | 13 | 0.0870 ± 0.0704 | 3.46 ± 1.84 | 10.23 ± 9.72 | 2 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `grid_quantile_journal_bd` | RTLLM | Prob004_adder_8bit | grid_quantile | 87.5% | 0.5951 | 0.3299 | 7/8 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob004_adder_8bit | grid_quantile | 50.0% | 0.9636 | 0.3299 | 6/12 |
| `grid_quantile_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 17.2% | -0.0865 | 0.0884 | 11/64 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 33.3% | -0.0354 | 0.0572 | 9/27 |
| `grid_quantile_journal_bd` | RTLLM | Prob024_fsm | grid_quantile | 62.5% | 2.4958 | 0.5845 | 5/8 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob024_fsm | grid_quantile | 31.2% | 2.8071 | 0.6835 | 5/16 |
| `grid_quantile_journal_bd` | RTLLM | Prob037_parallel2serial | grid_quantile | 50.0% | 0.6970 | 0.4686 | 2/4 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob037_parallel2serial | grid_quantile | 33.3% | 0.1176 | 0.0633 | 3/9 |
| `grid_quantile_journal_bd` | RTLLM | Prob041_traffic_light | grid_quantile | 29.2% | 4.0504 | 0.4736 | 14/48 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob041_traffic_light | grid_quantile | 20.8% | 3.3535 | 0.4187 | 10/48 |
| `grid_quantile_journal_bd` | RTLLM | Prob045_alu | grid_quantile | 56.2% | 1.0969 | 0.1457 | 9/16 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob045_alu | grid_quantile | 56.2% | 1.2101 | 0.3837 | 9/16 |
| `grid_quantile_journal_bd` | RTLLM | Prob049_signal_generator | grid_quantile | 75.0% | 0.7943 | 0.2742 | 3/4 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob049_signal_generator | grid_quantile | 75.0% | 0.7939 | 0.2738 | 3/4 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 50.0% | 0.3324 | 0.3324 | 1/2 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 50.0% | 0.0120 | 0.0120 | 1/2 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 50.0% | 1.7658 | 0.3468 | 6/12 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 31.2% | 1.5105 | 0.3468 | 5/16 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 75.0% | 0.5818 | 0.3310 | 3/4 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 66.7% | -0.0846 | 0.1226 | 6/9 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 55.6% | 0.0000 | -0.0000 | 5/9 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 33.3% | -1.5380 | 0.0010 | 3/9 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 25.0% | -4.4542 | -0.1946 | 9/36 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 31.2% | -4.7558 | -0.1422 | 15/48 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 50.0% | 0.4617 | 0.1556 | 6/12 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 50.0% | 0.2904 | 0.1671 | 8/16 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|
| `grid_quantile_journal_bd` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 78 | 7 | ff_depth | filled_empty=3, not_inserted=67, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 55 | 11 | ff_depth | duplicate_objectives=39, filled_empty=3, pareto_inserted=5, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 31 | 11 | none | filled_empty=4, not_inserted=15, replaced_elite=4, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 67 | 27 | none | crowding_evicted=25, duplicate_objectives=15, filled_empty=3, pareto_inserted=16, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 25 | 5 | none | filled_empty=1, not_inserted=12, replaced_elite=4, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 43 | 17 | none | crowding_evicted=1, duplicate_objectives=23, filled_empty=2, pareto_inserted=9, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 34 | 2 | logic_depth, comb_width_log | filled_empty=1, not_inserted=23, replaced_elite=2, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 31 | 13 | none | crowding_evicted=2, duplicate_objectives=10, filled_empty=1, pareto_inserted=10, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 55 | 14 | none | filled_empty=7, not_inserted=34, replaced_elite=6, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 51 | 33 | none | crowding_evicted=7, duplicate_objectives=11, filled_empty=4, pareto_inserted=21, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 81 | 9 | ff_depth | filled_empty=4, not_inserted=55, replaced_elite=14, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 82 | 37 | ff_depth | crowding_evicted=31, duplicate_objectives=14, filled_empty=2, pareto_inserted=27, warmup_buffered=8 |
| `grid_quantile_journal_bd` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 60 | 3 | ff_depth | filled_empty=1, not_inserted=37, replaced_elite=2, warmup_buffered=20 |
| `grid_quantile_pareto_journal_bd` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 74 | 12 | ff_depth | crowding_evicted=1, duplicate_objectives=48, filled_empty=1, pareto_inserted=8, warmup_buffered=16 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 53 | 1 | none | warmup_buffered=53 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 53 | 2 | logic_depth, ff_depth, comb_width_log | warmup_buffered=53 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 82 | 6 | ff_depth | filled_empty=2, not_inserted=69, replaced_elite=3, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 91 | 9 | ff_depth | duplicate_objectives=77, filled_empty=2, pareto_inserted=4, warmup_buffered=8 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 97 | 3 | ff_depth | filled_empty=2, not_inserted=83, replaced_elite=3, warmup_buffered=9 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 108 | 12 | ff_depth | duplicate_objectives=91, filled_empty=4, pareto_inserted=5, warmup_buffered=8 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 61 | 5 | ff_depth | filled_empty=3, not_inserted=50, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 57 | 10 | ff_depth | duplicate_objectives=44, filled_empty=1, pareto_inserted=4, warmup_buffered=8 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 24 | 9 | none | filled_empty=3, not_inserted=11, replaced_elite=2, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 38 | 32 | none | crowding_evicted=1, duplicate_objectives=5, filled_empty=8, pareto_inserted=16, warmup_buffered=8 |
| `grid_quantile_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 65 | 6 | ff_depth | filled_empty=1, not_inserted=49, replaced_elite=7, warmup_buffered=8 |
| `grid_quantile_pareto_journal_bd` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 64 | 33 | ff_depth | crowding_evicted=15, duplicate_objectives=16, filled_empty=2, pareto_inserted=23, warmup_buffered=8 |

