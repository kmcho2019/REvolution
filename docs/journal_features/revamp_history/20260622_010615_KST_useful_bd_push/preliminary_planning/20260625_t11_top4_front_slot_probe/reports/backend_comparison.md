# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Valid PPA samples count generated samples with PPA metrics even when QD warmup or archive insertion later drops them.
When the final population has no retained PPA aggregate, Score/PPA deltas use the best generated valid PPA sample.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic_revolution_8x5` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution_8x5` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 355221.62 ± 58819.31 | 96.00 | 96.00 |
| `classic_revolution_8x5` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 357530.40 ± 86054.11 | 96.00 | 96.00 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 351373.67 ± 86952.69 | 96.00 | 96.00 |
| `code_thought_sr_front_slot_8x5` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 353705.75 ± 54108.97 | 96.00 | 96.00 |
| `code_thought_sr_front_slot_8x5` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 335892.60 ± 70279.36 | 96.00 | 96.00 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 383394.33 ± 90294.86 | 96.00 | 96.00 |
| `masterrtl_structural_front_slot_8x5` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 345103.38 ± 53227.68 | 96.00 | 96.00 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 333073.40 ± 72953.31 | 96.00 | 96.00 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 365153.33 ± 86411.72 | 96.00 | 96.00 |
| `masterrtl_structural_mix_8x5` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 351905.75 ± 51481.40 | 96.00 | 96.00 |
| `masterrtl_structural_mix_8x5` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 340715.00 ± 68364.78 | 96.00 | 96.00 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 370557.00 ± 89934.49 | 96.00 | 96.00 |
| `qwen_canonical_rtl_pca3_8x5` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 348046.00 ± 56040.98 | 96.00 | 96.00 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 333352.00 ± 67528.69 | 96.00 | 96.00 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 372536.00 ± 110763.44 | 96.00 | 96.00 |
| `t11_runtime_top4_front_slot_8x5` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 351796.12 ± 50535.37 | 96.00 | 96.00 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 333327.00 ± 64052.91 | 96.00 | 96.00 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 382578.00 ± 85133.81 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (50.0%) | ✅ Pass (50.0%) | 24 | -1.48% ❌ | +26.12% ✅ / -14.70% ❌ / -15.85% ❌ | -1.48% ❌ | 989.74 | 96 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (29.2%) | ✅ Pass (27.1%) | 13 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 1360.25 | 96 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (8.3%) | ✅ Pass (8.3%) | 4 | +24.85% ✅ | +39.80% ✅ / +60.36% ✅ / -25.61% ❌ | +24.85% ✅ | 932.91 | 96 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (8.3%) | ✅ Pass (8.3%) | 4 | +2.31% ✅ | +36.43% ✅ / -1.45% ❌ / -28.05% ❌ | +2.31% ✅ | 1058.98 | 96 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (14.6%) | ✅ Pass (14.6%) | 7 | +5.52% ✅ | +33.37% ✅ / +8.80% ✅ / -25.61% ❌ | +5.52% ✅ | 730.74 | 96 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (10.4%) | ✅ Pass (10.4%) | 5 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 1046.88 | 96 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | ✅ Pass (27.1%) | ✅ Pass (20.8%) | 10 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 771.96 | 96 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob024_fsm | ✅ Pass (50.0%) | ✅ Pass (43.8%) | 21 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1035.93 | 96 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob024_fsm | ✅ Pass (64.6%) | ✅ Pass (52.1%) | 25 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1190.06 | 96 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob024_fsm | ✅ Pass (54.2%) | ✅ Pass (50.0%) | 24 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1018.06 | 96 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob024_fsm | ✅ Pass (60.4%) | ✅ Pass (56.2%) | 27 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 842.57 | 96 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob024_fsm | ✅ Pass (50.0%) | ✅ Pass (45.8%) | 22 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1054.93 | 96 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 20 | +42.09% ✅ | +27.06% ✅ / +99.20% ✅ / N/A | +63.13% ✅ | 1161.89 | 96 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob041_traffic_light | ✅ Pass (45.8%) | ✅ Pass (45.8%) | 22 | +38.91% ✅ | +17.65% ✅ / +99.09% ✅ / N/A | +58.37% ✅ | 1426.79 | 96 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob041_traffic_light | ✅ Pass (45.8%) | ✅ Pass (45.8%) | 22 | +40.63% ✅ | +22.94% ✅ / +98.96% ✅ / N/A | +60.95% ✅ | 1394.62 | 96 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob041_traffic_light | ✅ Pass (43.8%) | ✅ Pass (41.7%) | 20 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 1483.69 | 96 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob041_traffic_light | ✅ Pass (52.1%) | ✅ Pass (52.1%) | 25 | +36.27% ✅ | +10.00% ✅ / +98.81% ✅ / N/A | +54.41% ✅ | 1143.50 | 96 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob041_traffic_light | ✅ Pass (45.8%) | ✅ Pass (45.8%) | 22 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 1372.27 | 96 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +41.54% ✅ | +25.44% ✅ / +99.19% ✅ / N/A | +62.31% ✅ | 1112.35 | 96 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob045_alu | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +39.20% ✅ | +18.47% ✅ / +99.14% ✅ / N/A | +58.80% ✅ | 1460.27 | 96 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob045_alu | ✅ Pass (56.2%) | ✅ Pass (56.2%) | 27 | +39.88% ✅ | +20.49% ✅ / +99.13% ✅ / N/A | +59.81% ✅ | 1245.00 | 96 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob045_alu | ✅ Pass (47.9%) | ✅ Pass (47.9%) | 23 | +39.42% ✅ | +19.15% ✅ / +99.11% ✅ / N/A | +59.13% ✅ | 1365.36 | 96 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob045_alu | ✅ Pass (31.2%) | ✅ Pass (31.2%) | 15 | +40.68% ✅ | +22.92% ✅ / +99.12% ✅ / N/A | +61.02% ✅ | 1026.52 | 96 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob045_alu | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +39.19% ✅ | +18.43% ✅ / +99.15% ✅ / N/A | +58.79% ✅ | 1483.89 | 96 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | ✅ Pass (33.3%) | ✅ Pass (33.3%) | 16 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 605.03 | 96 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob049_signal_generator | ✅ Pass (66.7%) | ✅ Pass (66.7%) | 32 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 633.04 | 96 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob049_signal_generator | ✅ Pass (77.1%) | ✅ Pass (77.1%) | 37 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 845.07 | 96 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob049_signal_generator | ✅ Pass (85.4%) | ✅ Pass (85.4%) | 41 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 858.45 | 96 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob049_signal_generator | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 40 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 573.38 | 96 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob049_signal_generator | ✅ Pass (81.2%) | ✅ Pass (81.2%) | 39 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 788.23 | 96 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (64.6%) | ✅ Pass (64.6%) | 31 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1280.69 | 96 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (45.8%) | ✅ Pass (45.8%) | 22 | +46.44% ✅ | +40.00% ✅ / +99.31% ✅ / N/A | +69.66% ✅ | 1770.64 | 96 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (39.6%) | ✅ Pass (39.6%) | 19 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1412.49 | 96 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (22.9%) | ✅ Pass (22.9%) | 11 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1484.54 | 96 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (60.4%) | ✅ Pass (60.4%) | 29 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1217.88 | 96 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (29.2%) | ✅ Pass (29.2%) | 14 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1691.40 | 96 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (85.4%) | ✅ Pass (85.4%) | 41 | +33.10% ✅ | +0.00% ➖ / +99.31% ✅ / N/A | +49.66% ✅ | 1190.10 | 96 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 30 | +26.41% ✅ | -20.00% ❌ / +99.24% ✅ / N/A | +39.62% ✅ | 1102.97 | 96 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1173.53 | 96 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (91.7%) | ✅ Pass (91.7%) | 44 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1083.90 | 96 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (85.4%) | ✅ Pass (85.4%) | 41 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 866.70 | 96 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 30 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1465.61 | 96 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (31.2%) | ✅ Pass (27.1%) | 13 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1249.40 | 96 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (31.2%) | ✅ Pass (31.2%) | 15 | +3.60% ✅ | -1.39% ❌ / +6.86% ✅ / +5.33% ✅ | +3.60% ✅ | 1777.51 | 96 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (25.0%) | ✅ Pass (25.0%) | 12 | +15.24% ✅ | +10.48% ✅ / +35.24% ✅ / +0.00% ➖ | +15.24% ✅ | 1520.32 | 96 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (31.2%) | ✅ Pass (29.2%) | 14 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1635.29 | 96 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (16.7%) | ✅ Pass (16.7%) | 8 | +13.09% ✅ | +6.21% ✅ / +29.06% ✅ / +4.00% ✅ | +13.09% ✅ | 1120.02 | 96 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (14.6%) | ✅ Pass (14.6%) | 7 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1661.92 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution_8x5` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 45.4% ± 16.4% | 44.2% ± 17.8% | 5/5 | +31.71% ± 17.91% ✅ | ✅ 4 / ➖ 0 / ❌ 1 | 5/5 (106 samples) | +36.88% ± 23.71% ✅ | +23.90% ± 2.92% ✅ / +55.21% ± 41.39% ✅ / -0.95% ± 29.21% ❌ | ✅ 4 / ➖ 0 / ❌ 1 | A ✅ 0/5 / P ❌ 1/5 / T ❌ 1/2 | 928.19 ± 206.11 | 96.00 ± 0.00 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 60.4% ± 30.9% | 59.0% ± 33.5% | 3/3 | +31.07% ± 18.76% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (85 samples) | +44.34% ± 32.25% ✅ | +15.92% ± 24.00% ✅ / +76.83% ± 44.35% ✅ / +1.33% ± 0.00% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | A ✅ 0/3 / P ✅ 0/3 / T ✅ 0/1 | 1240.06 ± 52.06 | 96.00 ± 0.00 |
| `code_thought_sr_front_slot_8x5` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 43.8% ± 14.3% | 42.1% ± 14.3% | 5/5 | +31.38% ± 15.24% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (101 samples) | +35.99% ± 20.20% ✅ | +21.88% ± 8.74% ✅ / +58.65% ± 35.92% ✅ / -6.99% ± 36.49% ❌ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 1183.26 ± 307.35 | 96.00 ± 0.00 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 46.5% ± 17.7% | 46.5% ± 17.7% | 3/3 | +25.48% ± 24.25% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (67 samples) | +37.63% ± 37.42% ✅ | +6.20% ± 34.75% ✅ / +68.47% ± 60.38% ✅ / +5.33% ± 0.00% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 2/3 / P ✅ 0/3 / T ✅ 0/1 | 1550.37 ± 438.47 | 96.00 ± 0.00 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 50.4% ± 22.9% | 47.9% ± 22.0% | 5/5 | +35.77% ± 9.94% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (115 samples) | +40.63% ± 16.21% ✅ | +23.55% ± 8.69% ✅ / +70.16% ± 23.66% ✅ / -6.99% ± 36.49% ❌ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 1121.53 ± 199.17 | 96.00 ± 0.00 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 46.5% ± 29.1% | 46.5% ± 29.1% | 3/3 | +29.38% ± 17.95% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (67 samples) | +41.53% ± 30.93% ✅ | +10.16% ± 33.95% ✅ / +77.98% ± 41.88% ✅ / +0.00% ± 0.00% ➖ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ✅ 0/1 | 1368.78 ± 200.84 | 96.00 ± 0.00 |
| `masterrtl_structural_mix_8x5` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 47.9% ± 24.1% | 46.7% ± 24.0% | 5/5 | +31.20% ± 16.44% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (112 samples) | +36.02% ± 21.75% ✅ | +22.72% ± 7.61% ✅ / +57.76% ± 37.10% ✅ / -8.21% ± 38.88% ❌ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ❌ 1/5 / T ❌ 1/2 | 1156.91 ± 226.96 | 96.00 ± 0.00 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 48.6% ± 42.5% | 47.9% ± 43.0% | 3/3 | +28.82% ± 18.81% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (69 samples) | +40.97% ± 31.85% ✅ | +9.26% ± 33.98% ✅ / +76.76% ± 44.28% ✅ / +1.33% ± 0.00% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ✅ 0/1 | 1401.24 ± 322.48 | 96.00 ± 0.00 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 48.3% ± 23.3% | 47.5% ± 22.9% | 5/5 | +31.19% ± 15.11% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (114 samples) | +35.69% ± 19.86% ✅ | +20.16% ± 8.11% ✅ / +59.82% ± 34.06% ✅ / -6.99% ± 36.49% ❌ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 863.34 ± 199.50 | 96.00 ± 0.00 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 54.2% ± 39.4% | 54.2% ± 39.4% | 3/3 | +28.66% ± 19.06% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (78 samples) | +40.81% ± 32.11% ✅ | +8.74% ± 34.04% ✅ / +75.92% ± 45.92% ✅ / +4.00% ± 0.00% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ✅ 0/1 | 1068.20 ± 205.09 | 96.00 ± 0.00 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 46.2% ± 22.0% | 45.4% ± 22.0% | 5/5 | +31.75% ± 15.43% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (109 samples) | +36.55% ± 20.81% ✅ | +23.05% ± 8.50% ✅ / +58.60% ± 35.86% ✅ / -6.99% ± 36.49% ❌ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 1149.24 ± 244.58 | 96.00 ± 0.00 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 35.4% ± 27.8% | 35.4% ± 27.8% | 3/3 | +28.82% ± 18.81% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (51 samples) | +40.97% ± 31.85% ✅ | +9.26% ± 33.98% ✅ / +76.76% ± 44.28% ✅ / +1.33% ± 0.00% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ✅ 0/1 | 1606.31 ± 138.89 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution_8x5` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 51.0% ± 15.1% | 49.7% ± 16.2% | 8/8 | +31.47% ± 12.34% ✅ | ✅ 7 / ➖ 0 / ❌ 1 | 8/8 (191 samples) | +39.68% ± 17.87% ✅ | +20.91% ± 8.54% ✅ / +63.32% ± 29.71% ✅ / -0.19% ± 16.93% ❌ | ✅ 7 / ➖ 0 / ❌ 1 | A ✅ 0/8 / P ❌ 1/8 / T ❌ 1/3 | 1045.14 ± 167.25 | 96.00 ± 0.00 |
| `code_thought_sr_front_slot_8x5` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 44.8% ± 10.4% | 43.8% ± 10.5% | 8/8 | +29.17% ± 12.27% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | 8/8 (168 samples) | +36.61% ± 17.21% ✅ | +16.00% ± 13.72% ✅ / +62.34% ± 29.39% ✅ / -2.88% ± 22.56% ❌ | ✅ 8 / ➖ 0 / ❌ 0 | A ❌ 2/8 / P ✅ 0/8 / T ❌ 1/3 | 1320.92 ± 267.72 | 96.00 ± 0.00 |
| `masterrtl_structural_front_slot_8x5` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 49.0% ± 16.7% | 47.4% ± 16.2% | 8/8 | +33.37% ± 8.66% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | 8/8 (182 samples) | +40.96% ± 14.02% ✅ | +18.53% ± 13.17% ✅ / +73.09% ± 19.89% ✅ / -4.66% ± 21.56% ❌ | ✅ 8 / ➖ 0 / ❌ 0 | A ❌ 1/8 / P ✅ 0/8 / T ❌ 1/3 | 1214.25 ± 162.33 | 96.00 ± 0.00 |
| `masterrtl_structural_mix_8x5` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 48.2% ± 20.0% | 47.1% ± 20.1% | 8/8 | +30.31% ± 11.63% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | 8/8 (181 samples) | +37.88% ± 16.76% ✅ | +17.67% ± 12.95% ✅ / +64.89% ± 27.35% ✅ / -5.03% ± 23.30% ❌ | ✅ 8 / ➖ 0 / ❌ 0 | A ❌ 1/8 / P ❌ 1/8 / T ❌ 1/3 | 1248.53 ± 192.92 | 96.00 ± 0.00 |
| `qwen_canonical_rtl_pca3_8x5` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 50.5% ± 19.1% | 50.0% ± 18.9% | 8/8 | +30.25% ± 11.01% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | 8/8 (192 samples) | +37.61% ± 15.96% ✅ | +15.88% ± 12.82% ✅ / +65.86% ± 25.95% ✅ / -3.33% ± 22.26% ❌ | ✅ 8 / ➖ 0 / ❌ 0 | A ❌ 1/8 / P ✅ 0/8 / T ❌ 1/3 | 940.16 ± 155.30 | 96.00 ± 0.00 |
| `t11_runtime_top4_front_slot_8x5` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 42.2% ± 16.5% | 41.7% ± 16.4% | 8/8 | +30.65% ± 11.14% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | 8/8 (160 samples) | +38.21% ± 16.31% ✅ | +17.88% ± 13.19% ✅ / +65.41% ± 26.68% ✅ / -4.22% ± 21.76% ❌ | ✅ 8 / ➖ 0 / ❌ 0 | A ❌ 1/8 / P ✅ 0/8 / T ❌ 1/3 | 1320.64 ± 224.28 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 17 | 8 | 0.0000 | 0 | +35.10% ✅ / -14.70% ❌ / +40.24% ✅ |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 2 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / -23.17% ❌ |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 3 | 2 | 0.0000 | 0 | +39.80% ✅ / +60.36% ✅ / +31.71% ✅ |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 4 | 3 | 0.0000 | 0 | +36.43% ✅ / -1.45% ❌ / -1.22% ❌ |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 3 | 2 | 0.0000 | 0 | +38.78% ✅ / +8.80% ✅ / -25.61% ❌ |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 5 | 2 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / -21.95% ❌ |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1447 | 3 | +36.96% ✅ / +46.33% ✅ / N/A |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1449 | 4 | +36.96% ✅ / +46.33% ✅ / N/A |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob024_fsm | 2 | 6 | 2 | 0.1449 | 3 | +36.96% ✅ / +46.33% ✅ / N/A |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1459 | 5 | +36.96% ✅ / +46.76% ✅ / N/A |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1459 | 5 | +36.96% ✅ / +46.76% ✅ / N/A |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1449 | 4 | +36.96% ✅ / +46.33% ✅ / N/A |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 13 | 2 | 0.3101 | 12 | +32.94% ✅ / +99.20% ✅ / N/A |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob041_traffic_light | 2 | 14 | 3 | 0.1805 | 11 | +18.82% ✅ / +99.21% ✅ / N/A |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob041_traffic_light | 2 | 19 | 2 | 0.2272 | 17 | +22.94% ✅ / +99.09% ✅ / N/A |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob041_traffic_light | 2 | 19 | 2 | 0.2330 | 11 | +23.53% ✅ / +99.09% ✅ / N/A |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob041_traffic_light | 2 | 19 | 2 | 0.1073 | 7 | +12.94% ✅ / +98.81% ✅ / N/A |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob041_traffic_light | 2 | 16 | 3 | 0.2331 | 14 | +23.53% ✅ / +99.09% ✅ / N/A |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 34 | 4 | 0.2524 | 34 | +25.44% ✅ / +99.21% ✅ / N/A |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob045_alu | 2 | 13 | 1 | 0.1831 | 13 | +18.47% ✅ / +99.14% ✅ / N/A |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob045_alu | 2 | 25 | 1 | 0.2032 | 24 | +20.49% ✅ / +99.13% ✅ / N/A |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob045_alu | 2 | 21 | 2 | 0.1898 | 21 | +19.15% ✅ / +99.14% ✅ / N/A |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob045_alu | 2 | 15 | 1 | 0.2272 | 15 | +22.92% ✅ / +99.12% ✅ / N/A |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob045_alu | 2 | 20 | 1 | 0.1827 | 20 | +18.43% ✅ / +99.15% ✅ / N/A |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0192 | 4 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 | +40.00% ✅ / +99.61% ✅ / N/A |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 2 | 0.3973 | 4 | +40.00% ✅ / +99.36% ✅ / N/A |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 | +40.00% ✅ / +99.61% ✅ / N/A |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 3 | 1 | 0.3984 | 3 | +40.00% ✅ / +99.61% ✅ / N/A |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 | +40.00% ✅ / +99.61% ✅ / N/A |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 3 | 1 | 0.3984 | 3 | +40.00% ✅ / +99.61% ✅ / N/A |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 1 | +0.00% ➖ / +99.31% ✅ / N/A |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.24% ✅ / N/A |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 6 | 0.0004 | 4 | +8.99% ✅ / +35.93% ✅ / +12.00% ✅ |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 9 | 3 | 0.0000 | 0 | -1.39% ❌ / +6.86% ✅ / +14.67% ✅ |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 4 | 0.0008 | 3 | +10.48% ✅ / +35.24% ✅ / +5.33% ✅ |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 4 | 0.0003 | 3 | +8.30% ✅ / +35.01% ✅ / +9.33% ✅ |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 7 | 3 | 0.0007 | 1 | +6.21% ✅ / +29.06% ✅ / +13.33% ✅ |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 6 | 4 | 0.0003 | 1 | +10.51% ✅ / +35.01% ✅ / +2.67% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution_8x5` | RTLLM | 5 | 5 | 0.1453 ± 0.1205 | 3.60 ± 2.29 | 10.60 ± 12.11 | 4 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 ± 0.2602 | 2.67 ± 3.27 | 3.67 ± 2.85 | 2 |
| `code_thought_sr_front_slot_8x5` | RTLLM | 5 | 5 | 0.1031 ± 0.0809 | 1.80 ± 0.73 | 5.80 ± 5.16 | 0 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1324 ± 0.2596 | 2.00 ± 1.13 | 1.33 ± 2.61 | 0 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | 5 | 5 | 0.1164 ± 0.0942 | 1.60 ± 0.48 | 9.00 ± 9.50 | 0 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1331 ± 0.2600 | 2.00 ± 1.96 | 2.67 ± 2.85 | 1 |
| `masterrtl_structural_mix_8x5` | RTLLM | 5 | 5 | 0.1151 ± 0.0934 | 2.00 ± 0.62 | 7.60 ± 7.58 | 1 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 ± 0.2602 | 2.00 ± 1.96 | 2.00 ± 1.96 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | 5 | 5 | 0.0975 ± 0.0843 | 1.60 ± 0.48 | 5.60 ± 5.24 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1330 ± 0.2601 | 1.67 ± 1.31 | 2.33 ± 3.64 | 0 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | 5 | 5 | 0.1135 ± 0.0923 | 1.80 ± 0.73 | 7.80 ± 7.70 | 0 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 ± 0.2602 | 2.00 ± 1.96 | 1.33 ± 1.73 | 0 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution_8x5` | ALL | 8 | 8 | 0.1406 ± 0.1116 | 3.25 ± 1.77 | 8.00 ± 7.71 | 6 |
| `code_thought_sr_front_slot_8x5` | ALL | 8 | 8 | 0.1141 ± 0.0983 | 1.88 ± 0.58 | 4.12 ± 3.58 | 0 |
| `masterrtl_structural_front_slot_8x5` | ALL | 8 | 8 | 0.1227 ± 0.1022 | 1.75 ± 0.72 | 6.62 ± 6.19 | 1 |
| `masterrtl_structural_mix_8x5` | ALL | 8 | 8 | 0.1218 ± 0.1020 | 2.00 ± 0.74 | 5.50 ± 5.00 | 1 |
| `qwen_canonical_rtl_pca3_8x5` | ALL | 8 | 8 | 0.1108 ± 0.0997 | 1.62 ± 0.52 | 4.38 ± 3.55 | 0 |
| `t11_runtime_top4_front_slot_8x5` | ALL | 8 | 8 | 0.1208 ± 0.1017 | 1.88 ± 0.78 | 5.38 ± 5.18 | 0 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 6.2% | -0.5671 | 0.0528 | 4/64 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 6.2% | -0.0432 | 0.2485 | 4/64 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 6.2% | -0.4841 | 0.0231 | 4/64 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 10.9% | 0.1909 | 0.0552 | 7/64 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 2.0% | -0.0243 | 0.0528 | 5/256 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob024_fsm | grid_quantile | 7.8% | 1.8182 | 0.5002 | 5/64 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob024_fsm | grid_quantile | 18.8% | 1.4399 | 0.5002 | 3/16 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob024_fsm | grid_quantile | 50.0% | 1.4399 | 0.5002 | 3/6 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob024_fsm | grid_quantile | 26.6% | 5.6820 | 0.5002 | 17/64 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob024_fsm | grid_quantile | 3.7% | 1.3624 | 0.5002 | 3/81 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob041_traffic_light | grid_quantile | 18.8% | 2.9973 | 0.3891 | 12/64 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob041_traffic_light | grid_quantile | 17.2% | 2.8140 | 0.4063 | 11/64 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob041_traffic_light | grid_quantile | 14.1% | 2.8004 | 0.4077 | 9/64 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob041_traffic_light | grid_quantile | 25.0% | 2.9467 | 0.3627 | 16/64 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob041_traffic_light | grid_quantile | 3.9% | 2.6447 | 0.4077 | 10/256 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob045_alu | grid_quantile | 15.6% | 3.8067 | 0.3920 | 10/64 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob045_alu | grid_quantile | 56.2% | 3.3949 | 0.3988 | 9/16 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob045_alu | grid_quantile | 37.5% | 2.2992 | 0.3942 | 6/16 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob045_alu | grid_quantile | 15.6% | 3.8465 | 0.4068 | 10/64 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob045_alu | grid_quantile | 3.5% | 3.4169 | 0.3919 | 9/256 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob049_signal_generator | grid_quantile | 100.0% | 0.2348 | 0.2348 | 1/1 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob049_signal_generator | grid_quantile | 12.5% | 0.2348 | 0.2348 | 1/8 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob049_signal_generator | grid_quantile | 7.4% | 0.4695 | 0.2348 | 2/27 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob049_signal_generator | grid_quantile | 23.4% | 3.5216 | 0.2348 | 15/64 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob049_signal_generator | grid_quantile | 12.5% | 0.4695 | 0.2348 | 2/16 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 3.1% | 0.8613 | 0.4644 | 2/64 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 100.0% | 0.4654 | 0.4654 | 1/1 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 100.0% | 0.4654 | 0.4654 | 1/1 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 21.9% | 6.0361 | 0.4654 | 14/64 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 1.2% | 1.3266 | 0.4654 | 3/256 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 25.0% | 0.5278 | 0.2641 | 2/8 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 25.0% | 0.6559 | 0.2636 | 3/12 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 33.3% | 0.9195 | 0.2636 | 4/12 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 15.6% | 2.1634 | 0.2636 | 10/64 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 2.5% | 0.4598 | 0.2636 | 2/81 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 12.5% | -0.3304 | 0.0360 | 8/64 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 7.8% | 0.4647 | 0.1524 | 5/64 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 10.9% | 0.1071 | 0.1356 | 7/64 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 12.5% | -0.2484 | 0.1309 | 8/64 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 1.6% | 0.3579 | 0.1356 | 4/256 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 13 | 5 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=4, duplicate_objectives=2, filled_empty=1, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 4 | 4 | init=warmup_complete, shape=4x4x4 | none | live warmup_buffered=4; replay filled_empty=4 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 4 | 4 | init=warmup_complete, shape=4x4x4 | none | live warmup_buffered=4; replay filled_empty=4 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob015_multi_pipe_8bit | qwen_canonical_rtl_pca3 | qwen_pc0, qwen_pc1, qwen_pc2 | 7 | 7 | init=warmup_complete, shape=4x4x4 | none | live filled_empty=3, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob015_multi_pipe_8bit | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 5 | 5 | init=warmup_complete, shape=4x4x4x4 | none | live filled_empty=1, warmup_buffered=4; replay filled_empty=4 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob024_fsm | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 21 | 7 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=13, filled_empty=2, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob024_fsm | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 25 | 5 | init=warmup_complete, shape=4x4x1 | source_aligned_masterrtl_xor_fraction | live crowding_evicted=3, duplicate_objectives=15, pareto_inserted=2, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob024_fsm | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 24 | 6 | init=warmup_complete, shape=2x3x1 | source_aligned_masterrtl_xor_fraction | live crowding_evicted=2, duplicate_objectives=12, pareto_inserted=3, warmup_buffered=7; replay duplicate_objectives=2, filled_empty=3, pareto_inserted=1, replaced_elite=1 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob024_fsm | qwen_canonical_rtl_pca3 | qwen_pc0, qwen_pc1, qwen_pc2 | 27 | 21 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=2, duplicate_objectives=4, filled_empty=13, pareto_inserted=1, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob024_fsm | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 22 | 5 | init=warmup_complete, shape=3x3x3x3 | none | live crowding_evicted=8, duplicate_objectives=7, filled_empty=1, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=2, pareto_inserted=1 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob041_traffic_light | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 22 | 14 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=8, filled_empty=8, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob041_traffic_light | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 22 | 16 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=2, duplicate_objectives=2, filled_empty=7, pareto_inserted=4, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob041_traffic_light | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 20 | 13 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=2, duplicate_objectives=1, filled_empty=5, pareto_inserted=3, replaced_elite=5, warmup_buffered=4; replay filled_empty=4 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob041_traffic_light | qwen_canonical_rtl_pca3 | qwen_pc0, qwen_pc1, qwen_pc2 | 25 | 23 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=1, filled_empty=12, pareto_inserted=5, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob041_traffic_light | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 22 | 16 | init=warmup_complete, shape=4x4x4x4 | none | live crowding_evicted=1, duplicate_objectives=5, filled_empty=6, pareto_inserted=1, replaced_elite=5, warmup_buffered=4; replay filled_empty=4 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob045_alu | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 13 | 11 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=1, filled_empty=6, pareto_inserted=2, warmup_buffered=4; replay filled_empty=4 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob045_alu | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 27 | 13 | init=warmup_complete, shape=1x4x4 | source_aligned_masterrtl_seq_fraction | live crowding_evicted=4, duplicate_objectives=2, filled_empty=5, pareto_inserted=3, replaced_elite=9, warmup_buffered=4; replay filled_empty=4 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob045_alu | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 23 | 10 | init=warmup_complete, shape=1x4x4 | source_aligned_masterrtl_seq_fraction | live crowding_evicted=6, duplicate_objectives=1, filled_empty=3, pareto_inserted=3, replaced_elite=6, warmup_buffered=4; replay filled_empty=3, pareto_inserted=1 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob045_alu | qwen_canonical_rtl_pca3 | qwen_pc0, qwen_pc1, qwen_pc2 | 15 | 14 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=1, filled_empty=6, pareto_inserted=2, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob045_alu | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 21 | 14 | init=warmup_complete, shape=4x4x4x4 | none | live crowding_evicted=5, filled_empty=5, pareto_inserted=3, replaced_elite=4, warmup_buffered=4; replay filled_empty=4 |
| `code_thought_sr_front_slot_8x5` | RTLLM | Prob049_signal_generator | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 32 | 1 | init=run_finalization_fallback, shape=1x1x1 | sr_pca_0, sr_pca_1, sr_pca_2 | live warmup_buffered=32; replay duplicate_objectives=31, filled_empty=1 |
| `masterrtl_structural_front_slot_8x5` | RTLLM | Prob049_signal_generator | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 37 | 1 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=28, warmup_buffered=9; replay duplicate_objectives=8, filled_empty=1 |
| `masterrtl_structural_mix_8x5` | RTLLM | Prob049_signal_generator | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 41 | 2 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=37, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `qwen_canonical_rtl_pca3_8x5` | RTLLM | Prob049_signal_generator | qwen_canonical_rtl_pca3 | qwen_pc0, qwen_pc1, qwen_pc2 | 40 | 15 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=25, filled_empty=11, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top4_front_slot_8x5` | RTLLM | Prob049_signal_generator | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 39 | 2 | init=warmup_complete, shape=2x2x2x2 | none | live duplicate_objectives=32, warmup_buffered=7; replay duplicate_objectives=5, filled_empty=2 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 22 | 4 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=18, warmup_buffered=4; replay filled_empty=2, pareto_inserted=2 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 19 | 2 | init=run_finalization_fallback, shape=1x1x1 | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | live warmup_buffered=19; replay crowding_evicted=7, duplicate_objectives=9, filled_empty=1, pareto_inserted=2 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 11 | 2 | init=run_finalization_fallback, shape=1x1x1 | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | live warmup_buffered=11; replay crowding_evicted=2, duplicate_objectives=7, filled_empty=1, pareto_inserted=1 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | qwen_canonical_rtl_pca3 | qwen_pc0, qwen_pc1, qwen_pc2 | 29 | 17 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=1, duplicate_objectives=11, filled_empty=10, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 14 | 3 | init=warmup_complete, shape=4x4x4x4 | none | live duplicate_objectives=10, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 30 | 3 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=20, warmup_buffered=10; replay duplicate_objectives=7, filled_empty=2, replaced_elite=1 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 36 | 3 | init=warmup_complete, shape=1x3x4 | source_aligned_masterrtl_seq_fraction | live duplicate_objectives=32, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 44 | 5 | init=warmup_complete, shape=1x3x4 | source_aligned_masterrtl_seq_fraction | live crowding_evicted=4, duplicate_objectives=33, filled_empty=1, pareto_inserted=2, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | qwen_canonical_rtl_pca3 | qwen_pc0, qwen_pc1, qwen_pc2 | 41 | 10 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=31, filled_empty=6, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 30 | 2 | init=warmup_complete, shape=3x3x3x3 | none | live duplicate_objectives=26, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `code_thought_sr_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 15 | 9 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=5, filled_empty=5, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `masterrtl_structural_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 12 | 8 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=1, filled_empty=2, pareto_inserted=2, replaced_elite=3, warmup_buffered=4; replay filled_empty=3, replaced_elite=1 |
| `masterrtl_structural_mix_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_masterrtl_structural_mix_3d | source_aligned_masterrtl_seq_fraction, source_aligned_masterrtl_mux_fraction, source_aligned_masterrtl_xor_fraction | 14 | 10 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=2, duplicate_objectives=1, filled_empty=3, pareto_inserted=2, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `qwen_canonical_rtl_pca3_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | qwen_canonical_rtl_pca3 | qwen_pc0, qwen_pc1, qwen_pc2 | 8 | 8 | init=warmup_complete, shape=4x4x4 | none | live filled_empty=4, warmup_buffered=4; replay filled_empty=4 |
| `t11_runtime_top4_front_slot_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | t11_runtime_top4_graph | hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count | 7 | 6 | init=warmup_complete, shape=4x4x4x4 | none | live duplicate_objectives=1, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
