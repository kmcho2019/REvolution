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
| `classic` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 859089.08 ± 101764.76 | 240.00 | 240.00 |
| `classic` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 845226.71 ± 159555.06 | 240.00 | 240.00 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 875261.83 ± 133556.70 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_eoh` | ALL | unspecified | 120 | N/A | 240.08 ± 0.15 | 882890.46 ± 97166.48 | 240.08 | 240.08 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | unspecified | 120 | N/A | 240.14 ± 0.28 | 867452.57 ± 157162.72 | 240.14 | 240.14 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 900901.33 ± 118540.51 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 838659.69 ± 99138.56 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 785984.43 ± 160128.66 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 900114.17 ± 99103.35 | 240.00 | 240.00 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | ALL | unspecified | 120 | N/A | 229.23 ± 17.62 | 689281.62 ± 114743.22 | 229.23 | 229.23 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | unspecified | 120 | N/A | 223.71 ± 26.51 | 630859.86 ± 169092.06 | 223.71 | 223.71 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 235.67 ± 23.89 | 757440.33 ± 147666.96 | 235.67 | 235.67 |
| `grid_quantile_pareto_journal_thought_k4` | ALL | unspecified | 120 | N/A | 270.08 ± 0.15 | 803113.69 ± 91925.19 | 270.08 | 270.08 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | unspecified | 120 | N/A | 270.00 ± 0.00 | 780728.57 ± 162493.95 | 270.00 | 270.00 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 270.17 ± 0.33 | 829229.67 ± 77472.95 | 270.17 | 270.17 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (74.2%) | ✅ Pass (74.2%) | 89 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 1059.32 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob004_adder_8bit | ✅ Pass (75.8%) | ✅ Pass (74.2%) | 89 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 1049.99 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob004_adder_8bit | ✅ Pass (68.3%) | ✅ Pass (68.3%) | 82 | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 1016.66 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob004_adder_8bit | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 15 | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 1837.22 | 162 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob004_adder_8bit | ✅ Pass (96.7%) | ✅ Pass (93.3%) | 28 | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 1748.11 | 270 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (25.8%) | ✅ Pass (22.5%) | 27 | +17.67% ✅ | +47.45% ✅ / -22.49% ❌ / +28.05% ✅ | +17.67% ✅ | 1659.68 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (29.2%) | ✅ Pass (28.3%) | 34 | +2.31% ✅ | +36.43% ✅ / -1.45% ❌ / -28.05% ❌ | +2.31% ✅ | 2111.87 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (17.5%) | ✅ Pass (17.5%) | 21 | +23.58% ✅ | +39.90% ✅ / +54.01% ✅ / -23.17% ❌ | +23.58% ✅ | 1636.66 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (65.2%) | ✅ Pass (65.2%) | 15 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 3355.99 | 207 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (80.0%) | ✅ Pass (70.0%) | 21 | +45.96% ✅ | +45.31% ✅ / +26.73% ✅ / +65.85% ✅ | +45.96% ✅ | 3738.56 | 270 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (32.5%) | ✅ Pass (27.5%) | 33 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 849.45 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob024_fsm | ✅ Pass (47.5%) | ✅ Pass (43.3%) | 52 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 1301.63 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob024_fsm | ✅ Pass (45.8%) | ✅ Pass (42.5%) | 51 | +55.83% ✅ | +41.30% ✅ / +47.19% ✅ / N/A | +44.25% ✅ | 1227.64 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob024_fsm | ✅ Pass (44.4%) | ✅ Pass (40.7%) | 11 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 3138.68 | 243 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob024_fsm | ✅ Pass (86.7%) | ✅ Pass (86.7%) | 26 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 2739.38 | 270 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (32.5%) | ✅ Pass (25.8%) | 31 | +22.83% ✅ | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ | +22.83% ✅ | 1200.22 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob037_parallel2serial | ✅ Pass (25.0%) | ✅ Pass (24.2%) | 29 | +38.99% ✅ | +48.00% ✅ / +43.05% ✅ / +25.93% ✅ | +38.99% ✅ | 1511.69 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob037_parallel2serial | ✅ Pass (45.0%) | ✅ Pass (45.0%) | 54 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1758.06 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob037_parallel2serial | ✅ Pass (52.2%) | ✅ Pass (52.2%) | 12 | +9.79% ✅ | +10.00% ✅ / +15.67% ✅ / +3.70% ✅ | +9.79% ✅ | 2989.72 | 207 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob037_parallel2serial | ✅ Pass (80.0%) | ✅ Pass (80.0%) | 24 | +16.18% ✅ | +10.00% ✅ / +31.13% ✅ / +7.41% ✅ | +16.18% ✅ | 3519.73 | 270 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (51.7%) | ✅ Pass (51.7%) | 62 | +46.67% ✅ | +41.18% ✅ / +98.84% ✅ / N/A | +70.01% ✅ | 1332.92 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob041_traffic_light | ✅ Pass (66.7%) | ✅ Pass (66.7%) | 80 | +43.71% ✅ | +32.35% ✅ / +98.78% ✅ / N/A | +65.57% ✅ | 1595.05 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob041_traffic_light | ✅ Pass (54.2%) | ✅ Pass (50.8%) | 61 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 1666.85 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob041_traffic_light | ✅ Pass (86.7%) | ✅ Pass (86.7%) | 26 | +42.23% ✅ | +27.65% ✅ / +99.04% ✅ / N/A | +63.34% ✅ | 3916.20 | 270 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob041_traffic_light | ✅ Pass (96.7%) | ✅ Pass (96.7%) | 29 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 4652.19 | 270 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (64.2%) | ✅ Pass (64.2%) | 77 | +40.84% ✅ | +23.37% ✅ / +99.16% ✅ / N/A | +61.27% ✅ | 1830.27 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob045_alu | ✅ Pass (73.3%) | ✅ Pass (73.3%) | 88 | +40.77% ✅ | +23.15% ✅ / +99.17% ✅ / N/A | +61.16% ✅ | 1765.51 | 241 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob045_alu | ✅ Pass (28.3%) | ✅ Pass (28.3%) | 34 | +11.44% ✅ | +15.46% ✅ / +18.86% ✅ / N/A | +17.16% ✅ | 1590.09 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob045_alu | ✅ Pass (35.7%) | ✅ Pass (35.7%) | 10 | +13.56% ✅ | +23.33% ✅ / +17.37% ✅ / N/A | +20.35% ✅ | 3810.84 | 252 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob045_alu | ✅ Pass (50.0%) | ✅ Pass (50.0%) | 15 | +13.49% ✅ | +21.44% ✅ / +19.04% ✅ / N/A | +20.24% ✅ | 4840.04 | 270 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (42.5%) | ✅ Pass (42.5%) | 51 | +26.03% ✅ | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ | +26.03% ✅ | 837.35 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob049_signal_generator | ✅ Pass (55.8%) | ✅ Pass (55.8%) | 67 | +25.98% ✅ | +42.55% ✅ / +7.49% ✅ / +27.91% ✅ | +25.98% ✅ | 969.77 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob049_signal_generator | ✅ Pass (76.7%) | ✅ Pass (76.7%) | 92 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 892.38 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob049_signal_generator | ✅ Pass (72.0%) | ✅ Pass (72.0%) | 18 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 2011.99 | 225 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob049_signal_generator | ✅ Pass (93.3%) | ✅ Pass (93.3%) | 28 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 2581.38 | 270 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (63.3%) | ✅ Pass (61.7%) | 74 | +33.24% ✅ | +0.00% ➖ / +99.71% ✅ / N/A | +49.86% ✅ | 1668.45 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (57.5%) | ✅ Pass (55.8%) | 67 | +33.24% ✅ | +0.00% ➖ / +99.71% ✅ / N/A | +49.86% ✅ | 1868.05 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (38.3%) | ✅ Pass (38.3%) | 46 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 2075.57 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (57.7%) | ✅ Pass (57.7%) | 15 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 3371.16 | 234 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (40.0%) | ✅ Pass (40.0%) | 12 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 4117.50 | 270 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 75 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 2646.89 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (75.8%) | ✅ Pass (75.8%) | 91 | +39.69% ✅ | +20.00% ✅ / +99.07% ✅ / N/A | +59.54% ✅ | 2726.61 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (55.8%) | ✅ Pass (55.8%) | 67 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 2746.56 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (29.6%) | ✅ Pass (29.6%) | 8 | +25.42% ✅ | +40.00% ✅ / +36.27% ✅ / N/A | +38.13% ✅ | 4676.08 | 244 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (26.7%) | ✅ Pass (26.7%) | 8 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 4926.54 | 270 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (92.5%) | ✅ Pass (92.5%) | 111 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1730.02 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (80.8%) | ✅ Pass (80.8%) | 97 | +3.50% ✅ | -20.00% ❌ / +30.49% ✅ / N/A | +5.25% ✅ | 1988.69 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 85 | +3.50% ✅ | -20.00% ❌ / +30.49% ✅ / N/A | +5.25% ✅ | 2467.54 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (48.1%) | ✅ Pass (48.1%) | 13 | -1.29% ❌ | -20.00% ❌ / +16.14% ✅ / N/A | -1.93% ❌ | 3686.67 | 243 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (86.7%) | ✅ Pass (86.7%) | 26 | +3.50% ✅ | -20.00% ❌ / +30.49% ✅ / N/A | +5.25% ✅ | 3596.84 | 271 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (49.2%) | ✅ Pass (49.2%) | 59 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1753.76 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 75 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1586.42 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (30.8%) | ✅ Pass (30.8%) | 37 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1549.73 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (60.0%) | ✅ Pass (60.0%) | 12 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 1976.05 | 180 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (76.7%) | ✅ Pass (76.7%) | 23 | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 2923.43 | 270 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (11.7%) | ✅ Pass (11.7%) | 14 | -10.71% ❌ | -4.55% ❌ / -63.31% ❌ / +35.71% ✅ | -10.71% ❌ | 2013.35 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (8.3%) | ✅ Pass (8.3%) | 10 | -12.35% ❌ | -10.61% ❌ / -47.87% ❌ / +21.43% ✅ | -12.35% ❌ | 1923.78 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (11.7%) | ✅ Pass (11.7%) | 14 | -17.46% ❌ | -19.70% ❌ / -46.98% ❌ / +14.29% ✅ | -17.46% ❌ | 2171.45 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (48.1%) | ✅ Pass (48.1%) | 13 | -16.62% ❌ | -15.15% ❌ / -48.99% ❌ / +14.29% ✅ | -16.62% ❌ | 3360.53 | 243 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (50.0%) | ✅ Pass (50.0%) | 15 | -12.62% ❌ | -13.64% ❌ / -49.22% ❌ / +25.00% ✅ | -12.62% ❌ | 3616.90 | 270 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (44.2%) | ✅ Pass (43.3%) | 52 | +17.96% ✅ | +9.36% ✅ / +33.87% ✅ / +10.67% ✅ | +17.96% ✅ | 2052.57 | 240 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (57.5%) | ✅ Pass (55.0%) | 66 | +17.34% ✅ | +9.52% ✅ / +33.18% ✅ / +9.33% ✅ | +17.34% ✅ | 2450.41 | 240 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (41.7%) | ✅ Pass (40.0%) | 48 | +15.50% ✅ | +8.40% ✅ / +34.10% ✅ / +4.00% ✅ | +15.50% ✅ | 2589.48 | 240 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (13.3%) | ✅ Pass (13.3%) | 4 | +9.74% ✅ | +3.87% ✅ / +16.02% ✅ / +9.33% ✅ | +9.74% ✅ | 2671.11 | 270 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (20.0%) | ✅ Pass (20.0%) | 6 | +13.55% ✅ | +8.30% ✅ / +35.01% ✅ / -2.67% ❌ | +13.55% ✅ | 3010.95 | 270 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 46.2% ± 13.3% | 44.0% ± 14.9% | 7/7 | +37.22% ± 12.78% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (370 samples) | +44.94% ± 16.14% ✅ | +30.73% ± 10.53% ✅ / +59.47% ± 34.46% ✅ / +21.41% ± 8.01% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ❌ 1/7 / T ✅ 0/3 | 1252.74 ± 283.86 | 240.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 53.9% ± 21.3% | 53.5% ± 21.3% | 6/6 | +18.91% ± 17.00% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (385 samples) | +27.77% ± 24.62% ✅ | +4.13% ± 16.03% ✅ / +44.88% ± 53.98% ✅ / +23.19% ± 24.55% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 1977.51 ± 291.12 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 53.3% ± 15.2% | 52.3% ± 15.4% | 7/7 | +36.90% ± 14.73% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (439 samples) | +44.40% ± 17.27% ✅ | +35.07% ± 9.23% ✅ / +59.65% ± 32.47% ✅ / +8.59% ± 35.93% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ❌ 1/7 / T ❌ 1/3 | 1472.22 ± 298.12 | 240.14 ± 0.28 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 57.1% ± 20.6% | 56.4% ± 20.6% | 6/6 | +13.59% ± 16.16% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (406 samples) | +19.96% ± 22.97% ✅ | -0.18% ± 11.33% ❌ / +35.81% ± 45.81% ✅ / +15.38% ± 11.85% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 2090.66 ± 334.91 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 48.0% ± 15.4% | 47.0% ± 15.4% | 7/7 | +24.16% ± 13.95% ✅ | ✅ 6 / ➖ 1 / ❌ 0 | 7/7 (395 samples) | +27.24% ± 14.66% ✅ | +21.17% ± 11.11% ✅ / +41.69% ± 23.31% ✅ / -3.85% ± 20.05% ❌ | ✅ 6 / ➖ 1 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1398.33 ± 257.67 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 41.5% ± 16.3% | 41.2% ± 16.3% | 6/6 | +6.25% ± 13.98% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (297 samples) | +9.54% ± 18.72% ✅ | +1.45% ± 17.70% ✅ / +14.26% ± 30.35% ✅ / +9.14% ± 10.08% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 2266.72 ± 345.92 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 62.8% ± 14.4% | 62.3% ± 14.9% | 7/7 | +23.04% ± 12.72% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (107 samples) | +25.75% ± 14.21% ✅ | +22.26% ± 6.85% ✅ / +36.29% ± 23.69% ✅ / -2.65% ± 23.24% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 3008.66 ± 602.65 | 223.71 ± 26.51 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 42.8% ± 14.4% | 42.8% ± 14.4% | 6/6 | +3.09% ± 11.11% ✅ | ✅ 4 / ➖ 0 / ❌ 2 | 6/6 (65 samples) | +5.21% ± 14.62% ✅ | +1.45% ± 16.91% ✅ / +3.89% ± 23.07% ✅ / +11.81% ± 4.85% ✅ | ✅ 4 / ➖ 0 / ❌ 2 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 3290.27 ± 733.33 | 235.67 ± 23.89 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 83.3% ± 12.1% | 81.4% ± 12.3% | 7/7 | +29.55% ± 11.72% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (171 samples) | +32.15% ± 12.06% ✅ | +22.34% ± 8.24% ✅ / +42.14% ± 19.99% ✅ / +29.07% ± 36.24% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ✅ 0/3 | 3402.77 ± 834.08 | 270.00 ± 0.00 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 50.0% ± 21.5% | 50.0% ± 21.5% | 6/6 | +6.73% ± 12.84% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (90 samples) | +10.02% ± 17.81% ✅ | +2.44% ± 16.86% ✅ / +14.04% ± 31.01% ✅ / +11.17% ± 27.11% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 1/2 | 3698.69 ± 596.01 | 270.17 ± 0.33 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 49.7% ± 11.8% | 48.4% ± 12.4% | 13/13 | +28.77% ± 11.24% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (755 samples) | +37.01% ± 14.50% ✅ | +18.46% ± 11.64% ✅ / +52.74% ± 29.95% ✅ / +22.12% ± 8.96% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 2/13 / T ✅ 0/5 | 1587.25 ± 282.46 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_bd_eoh` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 55.1% ± 12.0% | 54.2% ± 12.1% | 13/13 | +26.14% ± 12.32% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (845 samples) | +33.12% ± 15.14% ✅ | +18.80% ± 12.10% ✅ / +48.65% ± 27.06% ✅ / +11.31% ± 20.30% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 2/13 / T ❌ 1/5 | 1757.65 ± 275.55 | 240.08 ± 0.15 |
| `grid_quantile_pareto_journal_bd_unified` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 45.0% ± 10.9% | 44.4% ± 10.9% | 13/13 | +15.90% ± 10.75% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (692 samples) | +19.07% ± 12.25% ✅ | +12.07% ± 11.15% ✅ / +29.03% ± 19.58% ✅ / +1.35% ± 13.02% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 1/5 | 1799.13 ± 317.62 | 240.00 ± 0.00 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 53.6% ± 11.3% | 53.3% ± 11.4% | 13/13 | +13.84% ± 9.95% ✅ | ✅ 11 / ➖ 0 / ❌ 2 | 13/13 (172 samples) | +16.27% ± 11.36% ✅ | +12.66% ± 10.10% ✅ / +21.34% ± 18.36% ✅ / +3.13% ± 14.58% ✅ | ✅ 11 / ➖ 0 / ❌ 2 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 1/5 | 3138.63 ± 455.53 | 229.23 ± 17.62 |
| `grid_quantile_pareto_journal_thought_k4` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 67.9% ± 14.7% | 66.9% ± 14.4% | 13/13 | +19.02% ± 10.49% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (261 samples) | +21.94% ± 11.79% ✅ | +13.16% ± 10.22% ✅ / +29.17% ± 18.85% ✅ / +21.91% ± 23.27% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 1/5 | 3539.35 ± 512.43 | 270.08 ± 0.15 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 15 | 1 | 0.1510 | 4 | +15.22% ✅ / +99.25% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob004_adder_8bit | 2 | 11 | 1 | 0.1510 | 3 | +15.22% ✅ / +99.25% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.0410 | 1 | +15.22% ✅ / +26.91% ✅ / N/A |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.0410 | 1 | +15.22% ✅ / +26.91% ✅ / N/A |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob004_adder_8bit | 2 | 2 | 1 | 0.0410 | 1 | +15.22% ✅ / +26.91% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 20 | 6 | 0.0000 | 0 | +47.45% ✅ / +96.01% ✅ / +100.00% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob015_multi_pipe_8bit | 3 | 26 | 10 | 0.0000 | 0 | +36.43% ✅ / -1.45% ❌ / +41.46% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob015_multi_pipe_8bit | 3 | 12 | 1 | 0.0000 | 0 | +39.90% ✅ / +54.01% ✅ / -23.17% ❌ |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 3 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / -19.51% ❌ |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 2 | 0.0797 | 1 | +45.31% ✅ / +59.13% ✅ / +65.85% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 18 | 1 | 0.3406 | 11 | +47.83% ✅ / +71.22% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob024_fsm | 2 | 21 | 1 | 0.3406 | 13 | +47.83% ✅ / +71.22% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.1949 | 6 | +41.30% ✅ / +47.19% ✅ / N/A |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1454 | 5 | +36.96% ✅ / +46.62% ✅ / N/A |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob024_fsm | 2 | 3 | 1 | 0.1017 | 3 | +21.74% ✅ / +46.76% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 13 | 1 | 0.0119 | 4 | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob037_parallel2serial | 3 | 16 | 1 | 0.0536 | 6 | +48.00% ✅ / +43.05% ✅ / +25.93% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob037_parallel2serial | 3 | 4 | 4 | 0.0000 | 0 | +2.00% ✅ / +0.00% ➖ / +3.70% ✅ |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob037_parallel2serial | 3 | 3 | 1 | 0.0006 | 2 | +10.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0023 | 3 | +10.00% ✅ / +31.13% ✅ / +7.41% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 49 | 3 | 0.4082 | 41 | +41.18% ✅ / +99.20% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob041_traffic_light | 2 | 63 | 4 | 0.3440 | 55 | +38.24% ✅ / +99.21% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob041_traffic_light | 2 | 39 | 2 | 0.2333 | 29 | +23.53% ✅ / +99.21% ✅ / N/A |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob041_traffic_light | 2 | 19 | 2 | 0.2739 | 14 | +27.65% ✅ / +99.09% ✅ / N/A |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob041_traffic_light | 2 | 21 | 4 | 0.2333 | 16 | +23.53% ✅ / +99.21% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 71 | 3 | 0.2348 | 71 | +24.63% ✅ / +99.16% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob045_alu | 2 | 69 | 3 | 0.2334 | 68 | +24.99% ✅ / +99.17% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob045_alu | 2 | 34 | 3 | 0.0356 | 34 | +20.00% ✅ / +18.86% ✅ / N/A |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob045_alu | 2 | 10 | 2 | 0.0433 | 10 | +25.21% ✅ / +17.37% ✅ / N/A |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob045_alu | 2 | 15 | 1 | 0.0408 | 15 | +21.44% ✅ / +19.04% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 7 | 2 | 0.0186 | 4 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob049_signal_generator | 3 | 9 | 5 | 0.0230 | 7 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob049_signal_generator | 3 | 3 | 2 | 0.0144 | 3 | +19.15% ✅ / +46.04% ✅ / +18.60% ✅ |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob049_signal_generator | 3 | 2 | 1 | 0.0123 | 2 | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.71% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.71% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 9 | 1 | 0.3984 | 9 | +40.00% ✅ / +99.61% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 10 | 2 | 0.3262 | 10 | +40.00% ✅ / +99.07% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 7 | 1 | 0.2562 | 7 | +40.00% ✅ / +64.04% ✅ / N/A |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.1627 | 5 | +40.00% ✅ / +45.08% ✅ / N/A |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 3 | 1 | 0.2562 | 3 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 6 | 2 | 0.0000 | 1 | +0.00% ➖ / +99.09% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 6 | 1 | 0.0000 | 0 | -20.00% ❌ / +30.49% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +30.49% ✅ / N/A |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +16.14% ✅ / N/A |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +30.49% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 4 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 6 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 12 | 5 | 0.0000 | 0 | -4.55% ❌ / -46.76% ❌ / +35.71% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 10 | 3 | 0.0000 | 0 | -9.09% ❌ / -47.65% ❌ / +21.43% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 12 | 4 | 0.0000 | 0 | -19.70% ❌ / -45.86% ❌ / +25.00% ✅ |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 11 | 4 | 0.0000 | 0 | -15.15% ❌ / -45.41% ❌ / +25.00% ✅ |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 13 | 7 | 0.0000 | 0 | -10.61% ❌ / -45.86% ❌ / +25.00% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 33 | 3 | 0.0034 | 8 | +9.72% ✅ / +33.87% ✅ / +16.00% ✅ |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 37 | 5 | 0.0031 | 7 | +10.48% ✅ / +35.47% ✅ / +10.67% ✅ |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 31 | 7 | 0.0022 | 7 | +10.12% ✅ / +38.22% ✅ / +13.33% ✅ |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 4 | 2 | 0.0006 | 1 | +3.87% ✅ / +19.22% ✅ / +9.33% ✅ |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 5 | 3 | 0.0000 | 0 | +8.93% ✅ / +35.01% ✅ / +4.00% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1664 ± 0.1236 | 2.43 ± 1.34 | 19.29 ± 19.80 | 3 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0670 ± 0.1299 | 2.17 ± 1.28 | 3.50 ± 3.15 | 5 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | 7 | 7 | 0.1637 ± 0.1080 | 3.57 ± 2.41 | 21.71 ± 20.54 | 3 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0549 ± 0.1064 | 2.17 ± 1.28 | 3.33 ± 3.34 | 0 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | 7 | 7 | 0.0735 ± 0.0726 | 2.00 ± 0.86 | 10.29 ± 10.89 | 0 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0431 ± 0.0835 | 2.50 ± 2.01 | 2.67 ± 2.71 | 0 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | 7 | 7 | 0.0741 ± 0.0750 | 1.86 ± 0.51 | 5.00 ± 3.83 | 0 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0272 ± 0.0531 | 1.83 ± 0.94 | 1.33 ± 1.49 | 0 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | 7 | 7 | 0.0730 ± 0.0584 | 1.57 ± 0.84 | 5.86 ± 4.92 | 1 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0427 ± 0.0837 | 2.33 ± 1.94 | 0.83 ± 0.94 | 1 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.1205 ± 0.0903 | 2.31 ± 0.90 | 12.00 ± 11.28 | 8 |
| `grid_quantile_pareto_journal_bd_eoh` | ALL | 13 | 13 | 0.1135 ± 0.0791 | 2.92 ± 1.43 | 13.23 ± 11.94 | 3 |
| `grid_quantile_pareto_journal_bd_unified` | ALL | 13 | 13 | 0.0595 ± 0.0532 | 2.23 ± 1.00 | 6.77 ± 6.16 | 0 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | ALL | 13 | 13 | 0.0524 ± 0.0472 | 1.85 ± 0.49 | 3.31 ± 2.33 | 0 |
| `grid_quantile_pareto_journal_thought_k4` | ALL | 13 | 13 | 0.0590 ± 0.0484 | 1.92 ± 0.98 | 3.54 ± 2.95 | 2 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob004_adder_8bit | grid_quantile | 50.0% | 0.9218 | 0.3815 | 6/12 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob004_adder_8bit | grid_quantile | 22.2% | 0.2809 | 0.1404 | 2/9 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob004_adder_8bit | grid_quantile | 100.0% | 0.1404 | 0.1404 | 1/1 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob004_adder_8bit | grid_quantile | 50.0% | 0.1404 | 0.1404 | 1/2 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 18.8% | -1.0691 | 0.0231 | 6/32 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 19.4% | 0.3183 | 0.2358 | 7/36 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 18.8% | -0.1085 | 0.0528 | 6/32 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 14.1% | 0.8428 | 0.4596 | 9/64 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob024_fsm | grid_quantile | 31.2% | 3.0872 | 0.6835 | 5/16 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob024_fsm | grid_quantile | 66.7% | 1.0279 | 0.5583 | 2/3 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob024_fsm | grid_quantile | 18.8% | 1.5007 | 0.5002 | 3/16 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob024_fsm | grid_quantile | 33.3% | 1.0005 | 0.5002 | 2/6 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob037_parallel2serial | grid_quantile | 75.0% | 0.7173 | 0.3899 | 3/4 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob037_parallel2serial | grid_quantile | 44.4% | -0.0260 | -0.0000 | 4/9 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob037_parallel2serial | grid_quantile | 100.0% | 0.1169 | 0.0979 | 2/2 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob037_parallel2serial | grid_quantile | 33.3% | 0.2556 | 0.1618 | 2/6 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob041_traffic_light | grid_quantile | 31.2% | 4.9576 | 0.4371 | 20/64 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob041_traffic_light | grid_quantile | 29.2% | 2.2596 | 0.4077 | 7/24 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob041_traffic_light | grid_quantile | 14.6% | 2.5588 | 0.4223 | 7/48 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob041_traffic_light | grid_quantile | 41.7% | 5.5048 | 0.4077 | 15/36 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob045_alu | grid_quantile | 75.0% | 1.9866 | 0.4077 | 12/16 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob045_alu | grid_quantile | 50.0% | 0.4103 | 0.1144 | 4/8 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob045_alu | grid_quantile | 50.0% | 0.5953 | 0.1356 | 6/12 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob045_alu | grid_quantile | 56.2% | 0.8087 | 0.1349 | 9/16 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob049_signal_generator | grid_quantile | 75.0% | 0.7511 | 0.2598 | 3/4 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob049_signal_generator | grid_quantile | 66.7% | 0.4695 | 0.2348 | 2/3 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob049_signal_generator | grid_quantile | 50.0% | 0.5112 | 0.2638 | 2/4 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob049_signal_generator | grid_quantile | 25.0% | 0.4986 | 0.2638 | 2/8 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 25.0% | 0.3324 | 0.3324 | 2/8 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 58.3% | 2.1116 | 0.3969 | 7/12 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 33.3% | 0.7506 | 0.3468 | 4/12 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 25.0% | 0.7851 | 0.2542 | 4/16 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 18.8% | 0.5734 | 0.3468 | 3/16 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 77.8% | -0.1387 | 0.0350 | 7/9 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 25.0% | -0.1465 | 0.0350 | 4/16 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 44.4% | -0.3372 | -0.0129 | 4/9 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 41.7% | -0.0164 | 0.0350 | 5/12 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 75.0% | 0.0020 | 0.0010 | 3/4 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 75.0% | -0.5490 | 0.0010 | 3/4 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 100.0% | 0.0010 | 0.0010 | 1/1 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 100.0% | 0.0010 | 0.0010 | 1/1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 14.6% | -1.8642 | -0.1235 | 7/48 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 16.7% | -2.0169 | -0.1746 | 6/36 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 25.0% | -1.7830 | -0.1662 | 6/24 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 66.7% | -0.8654 | -0.1262 | 4/6 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 43.8% | 0.2790 | 0.1734 | 7/16 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 50.0% | 0.2849 | 0.1550 | 8/16 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 89 | 15 | init=warmup_complete, shape=3x1x4 | ff_depth | live crowding_evicted=1, duplicate_objectives=68, filled_empty=3, pareto_inserted=9, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 82 | 2 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=74, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 15 | 1 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=15; replay duplicate_objectives=14, filled_empty=1 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 28 | 2 | init=run_finalization_fallback, shape=1x1x2 | logic_depth, ff_depth | live warmup_buffered=28; replay duplicate_objectives=26, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 34 | 19 | init=warmup_complete, shape=4x4x2 | none | live crowding_evicted=7, duplicate_objectives=7, filled_empty=4, pareto_inserted=8, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=2, pareto_inserted=5 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 21 | 14 | init=warmup_complete, shape=3x3x4 | none | live duplicate_objectives=6, filled_empty=2, pareto_inserted=5, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=5, pareto_inserted=2 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 15 | 11 | init=warmup_complete, shape=4x2x4 | none | live duplicate_objectives=4, filled_empty=1, pareto_inserted=2, warmup_buffered=8; replay filled_empty=5, pareto_inserted=3 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 21 | 17 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=3, filled_empty=3, pareto_inserted=7, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=6, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 52 | 15 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=6, duplicate_objectives=27, filled_empty=2, pareto_inserted=9, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=3, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 51 | 8 | init=run_finalization_fallback, shape=1x1x3 | logic_depth, ff_depth | live warmup_buffered=51; replay crowding_evicted=8, duplicate_objectives=35, filled_empty=2, pareto_inserted=6 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 11 | 10 | init=warmup_complete, shape=2x2x4 | none | live pareto_inserted=3, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=3, pareto_inserted=4 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 26 | 4 | init=warmup_complete, shape=2x1x3 | ff_depth | live duplicate_objectives=17, warmup_buffered=9; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 29 | 12 | init=warmup_complete, shape=1x2x2 | logic_depth | live crowding_evicted=6, duplicate_objectives=4, filled_empty=2, pareto_inserted=9, warmup_buffered=8; replay duplicate_objectives=7, filled_empty=1 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 54 | 6 | init=warmup_complete, shape=1x3x3 | logic_depth | live duplicate_objectives=42, filled_empty=2, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 12 | 3 | init=run_finalization_fallback, shape=1x1x2 | logic_depth, ff_depth | live warmup_buffered=12; replay duplicate_objectives=9, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 24 | 6 | init=warmup_complete, shape=2x1x3 | ff_depth | live duplicate_objectives=10, pareto_inserted=2, warmup_buffered=12; replay duplicate_objectives=8, filled_empty=2, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 80 | 57 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=9, duplicate_objectives=13, filled_empty=13, pareto_inserted=37, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=7 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 61 | 29 | init=warmup_complete, shape=2x3x4 | none | live crowding_evicted=12, duplicate_objectives=19, filled_empty=3, pareto_inserted=19, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=4, pareto_inserted=3 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 26 | 19 | init=warmup_complete, shape=4x3x4 | none | live duplicate_objectives=7, filled_empty=1, pareto_inserted=10, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 29 | 22 | init=warmup_complete, shape=4x3x3 | none | live duplicate_objectives=7, filled_empty=9, pareto_inserted=5, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 88 | 43 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=31, duplicate_objectives=14, filled_empty=6, pareto_inserted=29, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 34 | 18 | init=warmup_complete, shape=2x1x4 | ff_depth | live crowding_evicted=16, pareto_inserted=10, warmup_buffered=8; replay filled_empty=4, pareto_inserted=4 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 10 | 10 | init=warmup_complete, shape=3x1x4 | ff_depth | live filled_empty=1, pareto_inserted=1, warmup_buffered=8; replay filled_empty=5, pareto_inserted=3 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 15 | 15 | init=warmup_complete, shape=4x1x4 | ff_depth | live filled_empty=3, pareto_inserted=4, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_eoh` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 67 | 11 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=43, pareto_inserted=8, warmup_buffered=16; replay duplicate_objectives=13, filled_empty=3 |
| `grid_quantile_pareto_journal_bd_unified` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 92 | 3 | init=run_finalization_fallback, shape=1x1x3 | logic_depth, ff_depth | live warmup_buffered=92; replay duplicate_objectives=89, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 18 | 4 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=8, pareto_inserted=1, warmup_buffered=9; replay duplicate_objectives=6, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_thought_k4` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 28 | 3 | init=warmup_complete, shape=2x1x4 | ff_depth | live duplicate_objectives=12, warmup_buffered=16; replay duplicate_objectives=13, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 67 | 4 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=37, pareto_inserted=1, warmup_buffered=29; replay duplicate_objectives=26, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 46 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=46; replay duplicate_objectives=44, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 15 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=15; replay duplicate_objectives=13, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 12 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=12; replay duplicate_objectives=10, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 91 | 15 | init=warmup_complete, shape=3x1x4 | ff_depth | live duplicate_objectives=72, filled_empty=4, pareto_inserted=7, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=3, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 67 | 8 | init=warmup_complete, shape=3x1x4 | ff_depth | live duplicate_objectives=54, filled_empty=1, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 8 | 5 | init=warmup_complete, shape=4x1x4 | ff_depth | live warmup_buffered=8; replay duplicate_objectives=3, filled_empty=4, pareto_inserted=1 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 8 | 4 | init=warmup_complete, shape=4x1x4 | ff_depth | live warmup_buffered=8; replay duplicate_objectives=4, filled_empty=3, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 97 | 14 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=78, filled_empty=5, pareto_inserted=6, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 85 | 6 | init=warmup_complete, shape=4x1x4 | ff_depth | live duplicate_objectives=74, filled_empty=1, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 13 | 4 | init=warmup_complete, shape=3x1x3 | ff_depth | live duplicate_objectives=5, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=4 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 26 | 7 | init=warmup_complete, shape=4x1x3 | ff_depth | live duplicate_objectives=15, filled_empty=2, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=3, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 75 | 10 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=58, filled_empty=1, pareto_inserted=5, warmup_buffered=11; replay duplicate_objectives=7, filled_empty=2, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 37 | 4 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=24, filled_empty=1, pareto_inserted=1, warmup_buffered=11; replay duplicate_objectives=9, filled_empty=2 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 12 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=12; replay duplicate_objectives=10, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 23 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=23; replay duplicate_objectives=21, filled_empty=1, pareto_inserted=1 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 10 | 10 | init=warmup_complete, shape=3x4x4 | none | live filled_empty=1, pareto_inserted=1, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 14 | 13 | init=warmup_complete, shape=3x3x4 | none | live duplicate_objectives=1, filled_empty=1, pareto_inserted=4, warmup_buffered=8; replay filled_empty=5, pareto_inserted=3 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 13 | 11 | init=warmup_complete, shape=2x3x4 | none | live duplicate_objectives=1, filled_empty=1, pareto_inserted=3, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=5, pareto_inserted=2 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 15 | 13 | init=warmup_complete, shape=1x2x3 | logic_depth | live pareto_inserted=6, warmup_buffered=9; replay duplicate_objectives=2, filled_empty=4, pareto_inserted=3 |
| `grid_quantile_pareto_journal_bd_eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 66 | 27 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=13, duplicate_objectives=26, filled_empty=3, pareto_inserted=16, warmup_buffered=8; replay filled_empty=4, pareto_inserted=4 |
| `grid_quantile_pareto_journal_bd_unified` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 48 | 25 | init=warmup_complete, shape=4x1x4 | ff_depth | live crowding_evicted=8, duplicate_objectives=15, filled_empty=2, pareto_inserted=15, warmup_buffered=8; replay filled_empty=6, pareto_inserted=2 |
| `grid_quantile_pareto_journal_eoh_thought_k4` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 4 | 0 | init=pending | none | live warmup_buffered=4 |
| `grid_quantile_pareto_journal_thought_k4` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 6 | 0 | init=pending | none | live warmup_buffered=6 |

