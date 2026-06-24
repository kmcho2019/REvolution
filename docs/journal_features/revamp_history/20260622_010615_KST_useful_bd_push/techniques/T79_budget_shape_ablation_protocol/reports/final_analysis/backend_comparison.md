# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Valid PPA samples count generated samples with PPA metrics even when QD warmup or archive insertion later drops them.
When the final population has no retained PPA aggregate, Score/PPA deltas use the best generated valid PPA sample.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic_revolution_12x3` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution_12x3` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 353201.38 ± 52982.64 | 96.00 | 96.00 |
| `classic_revolution_12x3` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 351991.20 ± 73125.04 | 96.00 | 96.00 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 355218.33 ± 91451.72 | 96.00 | 96.00 |
| `classic_revolution_6x7` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 363870.88 ± 56790.52 | 96.00 | 96.00 |
| `classic_revolution_6x7` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 370659.80 ± 83027.88 | 96.00 | 96.00 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 352556.00 ± 82032.27 | 96.00 | 96.00 |
| `classic_revolution_8x5` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 360897.75 ± 55532.26 | 96.00 | 96.00 |
| `classic_revolution_8x5` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 365426.80 ± 83727.18 | 96.00 | 96.00 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 353349.33 ± 72386.82 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd_12x3` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 341835.88 ± 54016.31 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 334717.60 ± 74785.55 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 353699.67 ± 90315.81 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd_6x7` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 362660.62 ± 57128.57 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 347816.40 ± 75223.00 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 387401.00 ± 98580.81 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd_8x5` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 359591.00 ± 51261.62 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 345518.40 ± 70444.22 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 383045.33 ± 79333.34 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic_revolution_12x3` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (25.0%) | ✅ Pass (22.9%) | 11 | +6.11% ✅ | +37.14% ✅ / +4.34% ✅ / -23.17% ❌ | +6.11% ✅ | 1250.29 | 96 |
| `classic_revolution_6x7` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (41.7%) | ✅ Pass (39.6%) | 19 | +24.34% ✅ | +37.96% ✅ / +59.47% ✅ / -24.39% ❌ | +24.34% ✅ | 1366.84 | 96 |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (33.3%) | ✅ Pass (31.2%) | 15 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 1162.01 | 96 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (10.4%) | ✅ Pass (10.4%) | 5 | -3.40% ❌ | +30.10% ✅ / -14.70% ❌ / -25.61% ❌ | -3.40% ❌ | 840.16 | 96 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (12.5%) | ✅ Pass (12.5%) | 6 | +7.17% ✅ | +38.78% ✅ / +5.90% ✅ / -23.17% ❌ | +7.17% ✅ | 1247.35 | 96 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 1281.69 | 96 |
| `classic_revolution_12x3` | RTLLM | Prob024_fsm | ✅ Pass (20.8%) | ✅ Pass (20.8%) | 10 | +66.61% ✅ | +43.48% ✅ / +70.36% ✅ / N/A | +56.92% ✅ | 672.20 | 96 |
| `classic_revolution_6x7` | RTLLM | Prob024_fsm | ✅ Pass (41.7%) | ✅ Pass (29.2%) | 14 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 1097.18 | 96 |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | ✅ Pass (35.4%) | ✅ Pass (33.3%) | 16 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 865.32 | 96 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob024_fsm | ✅ Pass (68.8%) | ✅ Pass (54.2%) | 26 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 848.61 | 96 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob024_fsm | ✅ Pass (60.4%) | ✅ Pass (52.1%) | 25 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1400.41 | 96 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob024_fsm | ✅ Pass (54.2%) | ✅ Pass (50.0%) | 24 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1136.59 | 96 |
| `classic_revolution_12x3` | RTLLM | Prob041_traffic_light | ✅ Pass (62.5%) | ✅ Pass (60.4%) | 29 | +42.09% ✅ | +27.06% ✅ / +99.20% ✅ / N/A | +63.13% ✅ | 990.89 | 96 |
| `classic_revolution_6x7` | RTLLM | Prob041_traffic_light | ✅ Pass (66.7%) | ✅ Pass (66.7%) | 32 | +44.82% ✅ | +35.29% ✅ / +99.15% ✅ / N/A | +67.22% ✅ | 1294.94 | 96 |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | ✅ Pass (54.2%) | ✅ Pass (54.2%) | 26 | +34.23% ✅ | +3.53% ✅ / +99.15% ✅ / N/A | +51.34% ✅ | 1144.50 | 96 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob041_traffic_light | ✅ Pass (50.0%) | ✅ Pass (47.9%) | 23 | +36.27% ✅ | +10.00% ✅ / +98.81% ✅ / N/A | +54.41% ✅ | 1158.90 | 96 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob041_traffic_light | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 18 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 1758.82 | 96 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob041_traffic_light | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 20 | +38.91% ✅ | +17.65% ✅ / +99.09% ✅ / N/A | +58.37% ✅ | 1453.39 | 96 |
| `classic_revolution_12x3` | RTLLM | Prob045_alu | ✅ Pass (64.6%) | ✅ Pass (64.6%) | 31 | +41.66% ✅ | +25.75% ✅ / +99.21% ✅ / N/A | +62.48% ✅ | 937.79 | 96 |
| `classic_revolution_6x7` | RTLLM | Prob045_alu | ✅ Pass (66.7%) | ✅ Pass (66.7%) | 32 | +41.54% ✅ | +25.44% ✅ / +99.19% ✅ / N/A | +62.31% ✅ | 1325.12 | 96 |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | ✅ Pass (77.1%) | ✅ Pass (77.1%) | 37 | +40.93% ✅ | +23.60% ✅ / +99.20% ✅ / N/A | +61.40% ✅ | 1170.26 | 96 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob045_alu | ✅ Pass (50.0%) | ✅ Pass (47.9%) | 23 | +39.11% ✅ | +18.25% ✅ / +99.10% ✅ / N/A | +58.67% ✅ | 991.13 | 96 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob045_alu | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +38.68% ✅ | +16.99% ✅ / +99.06% ✅ / N/A | +58.03% ✅ | 1497.57 | 96 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob045_alu | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +41.75% ✅ | +26.07% ✅ / +99.20% ✅ / N/A | +62.63% ✅ | 1326.56 | 96 |
| `classic_revolution_12x3` | RTLLM | Prob049_signal_generator | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +25.98% ✅ | +42.55% ✅ / +7.49% ✅ / +27.91% ✅ | +25.98% ✅ | 553.22 | 96 |
| `classic_revolution_6x7` | RTLLM | Prob049_signal_generator | ✅ Pass (52.1%) | ✅ Pass (52.1%) | 25 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 828.50 | 96 |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | ✅ Pass (52.1%) | ✅ Pass (52.1%) | 25 | +25.98% ✅ | +42.55% ✅ / +7.49% ✅ / +27.91% ✅ | +25.98% ✅ | 682.13 | 96 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob049_signal_generator | ✅ Pass (87.5%) | ✅ Pass (87.5%) | 42 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 549.81 | 96 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob049_signal_generator | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 40 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 824.01 | 96 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob049_signal_generator | ✅ Pass (91.7%) | ✅ Pass (91.7%) | 44 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 670.07 | 96 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 30 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1154.55 | 96 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (68.8%) | ✅ Pass (68.8%) | 33 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1472.94 | 96 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (56.2%) | ✅ Pass (56.2%) | 27 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1377.47 | 96 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 40 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1047.81 | 96 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (50.0%) | ✅ Pass (50.0%) | 24 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1919.36 | 96 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (56.2%) | ✅ Pass (56.2%) | 27 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1589.09 | 96 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (81.2%) | ✅ Pass (81.2%) | 39 | +39.77% ✅ | +20.00% ✅ / +99.31% ✅ / N/A | +59.65% ✅ | 971.33 | 96 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (87.5%) | ✅ Pass (87.5%) | 42 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1367.93 | 96 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (89.6%) | ✅ Pass (89.6%) | 43 | +26.41% ✅ | -20.00% ❌ / +99.24% ✅ / N/A | +39.62% ✅ | 1142.80 | 96 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 911.32 | 96 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (93.8%) | ✅ Pass (93.8%) | 45 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1440.15 | 96 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (89.6%) | ✅ Pass (89.6%) | 43 | +26.41% ✅ | -20.00% ❌ / +99.24% ✅ / N/A | +39.62% ✅ | 1159.63 | 96 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (12.5%) | ✅ Pass (12.5%) | 6 | -1.77% ❌ | -1.82% ❌ / +1.83% ✅ / -5.33% ❌ | -1.77% ❌ | 1112.90 | 96 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (54.2%) | ✅ Pass (52.1%) | 25 | +14.43% ✅ | +10.48% ✅ / +35.47% ✅ / -2.67% ❌ | +14.43% ✅ | 1480.90 | 96 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (56.2%) | ✅ Pass (52.1%) | 25 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1238.64 | 96 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (22.9%) | ✅ Pass (22.9%) | 11 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1216.82 | 96 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (18.8%) | ✅ Pass (18.8%) | 9 | +10.16% ✅ | +6.74% ✅ / +29.06% ✅ / -5.33% ❌ | +10.16% ✅ | 1963.78 | 96 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (20.8%) | ✅ Pass (20.8%) | 10 | +14.43% ✅ | +10.48% ✅ / +35.47% ✅ / -2.67% ❌ | +14.43% ✅ | 1577.04 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution_12x3` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 46.2% ± 18.8% | 45.4% ± 19.0% | 5/5 | +36.49% ± 19.60% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (109 samples) | +42.92% ± 22.47% ✅ | +35.20% ± 7.36% ✅ / +56.12% ± 41.49% ✅ / +2.37% ± 50.06% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 880.88 ± 241.13 | 96.00 ± 0.00 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 52.1% ± 40.2% | 52.1% ± 40.2% | 3/3 | +28.18% ± 29.60% ✅ | ✅ 2 / ➖ 0 / ❌ 1 | 3/3 (75 samples) | +42.56% ± 43.83% ✅ | +19.39% ± 23.67% ✅ / +66.92% ± 63.78% ✅ / -5.33% ± 0.00% ❌ | ✅ 2 / ➖ 0 / ❌ 1 | A ❌ 1/3 / P ✅ 0/3 / T ❌ 1/1 | 1079.59 ± 108.68 | 96.00 ± 0.00 |
| `classic_revolution_6x7` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 53.8% ± 11.0% | 50.8% ± 14.5% | 5/5 | +41.09% ± 15.52% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (122 samples) | +47.96% ± 18.25% ✅ | +33.13% ± 9.79% ✅ / +75.01% ± 20.85% ✅ / -5.22% ± 37.58% ❌ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 1182.52 ± 195.79 | 96.00 ± 0.00 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 70.1% ± 18.9% | 69.4% ± 20.1% | 3/3 | +29.11% ± 18.37% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (100 samples) | +41.26% ± 31.38% ✅ | +10.16% ± 33.95% ✅ / +78.05% ± 41.73% ✅ / -2.67% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ❌ 1/1 | 1440.59 ± 71.35 | 96.00 ± 0.00 |
| `classic_revolution_8x5` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 50.4% ± 15.5% | 49.6% ± 16.3% | 5/5 | +34.95% ± 20.14% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (119 samples) | +40.71% ± 21.32% ✅ | +31.26% ± 15.72% ✅ / +55.95% ± 41.94% ✅ / +1.15% ± 52.45% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 1004.84 ± 193.62 | 96.00 ± 0.00 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 67.4% ± 21.8% | 66.0% ± 23.3% | 3/3 | +28.84% ± 18.81% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (95 samples) | +40.99% ± 31.85% ✅ | +9.26% ± 33.98% ✅ / +76.81% ± 44.33% ✅ / +1.33% ± 0.00% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ✅ 0/1 | 1252.97 ± 133.52 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 53.3% ± 25.1% | 49.6% ± 24.0% | 5/5 | +29.10% ± 17.95% ✅ | ✅ 4 / ➖ 0 / ❌ 1 | 5/5 (119 samples) | +33.44% ± 22.06% ✅ | +18.57% ± 6.93% ✅ / +55.12% ± 41.29% ✅ / -6.99% ± 36.49% ❌ | ✅ 4 / ➖ 0 / ❌ 1 | A ✅ 0/5 / P ❌ 1/5 / T ❌ 1/2 | 877.72 ± 196.83 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 59.0% ± 36.1% | 59.0% ± 36.1% | 3/3 | +28.82% ± 18.81% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (85 samples) | +40.97% ± 31.85% ✅ | +9.26% ± 33.98% ✅ / +76.76% ± 44.28% ✅ / +1.33% ± 0.00% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ✅ 0/1 | 1058.65 ± 173.18 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 47.5% ± 23.1% | 45.8% ± 22.5% | 5/5 | +32.03% ± 14.77% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (110 samples) | +36.77% ± 20.12% ✅ | +22.76% ± 8.67% ✅ / +59.23% ± 34.89% ✅ / -5.77% ± 34.10% ❌ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 1345.63 ± 303.19 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 54.2% ± 42.6% | 54.2% ± 42.6% | 3/3 | +27.68% ± 20.62% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (78 samples) | +39.83% ± 33.75% ✅ | +8.91% ± 34.01% ✅ / +75.92% ± 45.92% ✅ / -5.33% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ❌ 1/1 | 1774.43 ± 328.56 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | 5 | ✅ 5/5 (100.0%) | ✅ 5/5 (100.0%) | 51.7% ± 21.4% | 50.8% ± 21.3% | 5/5 | +31.89% ± 15.52% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/5 (122 samples) | +36.76% ± 21.07% ✅ | +23.40% ± 8.68% ✅ / +58.67% ± 35.94% ✅ / -6.99% ± 36.49% ❌ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 1173.66 ± 265.97 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 55.6% ± 38.9% | 55.6% ± 38.9% | 3/3 | +29.13% ± 18.36% ✅ | ✅ 3 / ➖ 0 / ❌ 0 | 3/3 (80 samples) | +41.28% ± 31.37% ✅ | +10.16% ± 33.95% ✅ / +78.11% ± 41.78% ✅ / -2.67% ± 0.00% ❌ | ✅ 3 / ➖ 0 / ❌ 0 | A ❌ 1/3 / P ✅ 0/3 / T ❌ 1/1 | 1441.92 ± 276.73 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution_12x3` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 48.4% ± 17.4% | 47.9% ± 17.5% | 8/8 | +33.37% ± 15.49% ✅ | ✅ 7 / ➖ 0 / ❌ 1 | 8/8 (184 samples) | +42.79% ± 19.65% ✅ | +29.27% ± 10.56% ✅ / +60.17% ± 32.64% ✅ / -0.20% ± 29.33% ❌ | ✅ 7 / ➖ 0 / ❌ 1 | A ❌ 1/8 / P ✅ 0/8 / T ❌ 2/3 | 955.40 ± 164.65 | 96.00 ± 0.00 |
| `classic_revolution_6x7` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 59.9% ± 10.8% | 57.8% ± 12.8% | 8/8 | +36.59% ± 11.86% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | 8/8 (222 samples) | +45.44% ± 15.17% ✅ | +24.52% ± 15.02% ✅ / +76.15% ± 18.52% ✅ / -4.37% ± 21.76% ❌ | ✅ 8 / ➖ 0 / ❌ 0 | A ❌ 1/8 / P ✅ 0/8 / T ❌ 2/3 | 1279.29 ± 151.00 | 96.00 ± 0.00 |
| `classic_revolution_8x5` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 56.8% ± 13.2% | 55.7% ± 13.7% | 8/8 | +32.66% ± 13.70% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | 8/8 (214 samples) | +40.81% ± 16.46% ✅ | +23.01% ± 16.56% ✅ / +63.77% ± 29.91% ✅ / +1.21% ± 30.28% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | A ❌ 1/8 / P ✅ 0/8 / T ❌ 1/3 | 1097.89 ± 152.38 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd_12x3` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 55.5% ± 19.2% | 53.1% ± 18.9% | 8/8 | +28.99% ± 12.37% ✅ | ✅ 7 / ➖ 0 / ❌ 1 | 8/8 (204 samples) | +36.26% ± 17.02% ✅ | +15.08% ± 12.33% ✅ / +63.23% ± 29.65% ✅ / -4.22% ± 21.76% ❌ | ✅ 7 / ➖ 0 / ❌ 1 | A ❌ 1/8 / P ❌ 1/8 / T ❌ 1/3 | 945.57 ± 145.81 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd_6x7` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 50.0% ± 19.8% | 49.0% ± 19.6% | 8/8 | +30.40% ± 11.22% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | 8/8 (188 samples) | +37.92% ± 16.36% ✅ | +17.57% ± 13.25% ✅ / +65.48% ± 26.39% ✅ / -5.63% ± 19.69% ❌ | ✅ 8 / ➖ 0 / ❌ 0 | A ❌ 1/8 / P ✅ 0/8 / T ❌ 2/3 | 1506.43 ± 260.86 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd_8x5` | ALL | 8 | ✅ 8/8 (100.0%) | ✅ 8/8 (100.0%) | 53.1% ± 18.1% | 52.6% ± 18.1% | 8/8 | +30.85% ± 11.10% ✅ | ✅ 8 / ➖ 0 / ❌ 0 | 8/8 (202 samples) | +38.46% ± 16.33% ✅ | +18.43% ± 13.15% ✅ / +65.96% ± 26.40% ✅ / -5.55% ± 21.26% ❌ | ✅ 8 / ➖ 0 / ❌ 0 | A ❌ 1/8 / P ✅ 0/8 / T ❌ 2/3 | 1274.26 ± 206.70 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic_revolution_12x3` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 5 | 0.0000 | 0 | +37.14% ✅ / +4.34% ✅ / +30.49% ✅ |
| `classic_revolution_6x7` | RTLLM | Prob015_multi_pipe_8bit | 3 | 15 | 7 | 0.0000 | 0 | +38.78% ✅ / +59.47% ✅ / +35.37% ✅ |
| `classic_revolution_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 6 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / +40.24% ✅ |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob015_multi_pipe_8bit | 3 | 4 | 2 | 0.0000 | 0 | +30.10% ✅ / -12.47% ❌ / -25.61% ❌ |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob015_multi_pipe_8bit | 3 | 5 | 2 | 0.0000 | 0 | +38.78% ✅ / +5.90% ✅ / -21.95% ❌ |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 3 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / +30.49% ✅ |
| `classic_revolution_12x3` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.3059 | 6 | +43.48% ✅ / +70.36% ✅ / N/A |
| `classic_revolution_6x7` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.3406 | 7 | +47.83% ✅ / +71.22% ✅ / N/A |
| `classic_revolution_8x5` | RTLLM | Prob024_fsm | 2 | 9 | 1 | 0.3406 | 4 | +47.83% ✅ / +71.22% ✅ / N/A |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1459 | 5 | +36.96% ✅ / +46.76% ✅ / N/A |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1459 | 5 | +36.96% ✅ / +46.76% ✅ / N/A |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1449 | 4 | +36.96% ✅ / +46.33% ✅ / N/A |
| `classic_revolution_12x3` | RTLLM | Prob041_traffic_light | 2 | 27 | 3 | 0.3155 | 22 | +35.88% ✅ / +99.20% ✅ / N/A |
| `classic_revolution_6x7` | RTLLM | Prob041_traffic_light | 2 | 26 | 2 | 0.3501 | 24 | +35.29% ✅ / +99.20% ✅ / N/A |
| `classic_revolution_8x5` | RTLLM | Prob041_traffic_light | 2 | 17 | 4 | 0.1405 | 12 | +32.94% ✅ / +99.15% ✅ / N/A |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob041_traffic_light | 2 | 12 | 3 | 0.1153 | 7 | +13.53% ✅ / +98.81% ✅ / N/A |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.2330 | 12 | +23.53% ✅ / +99.09% ✅ / N/A |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob041_traffic_light | 2 | 14 | 1 | 0.1749 | 10 | +17.65% ✅ / +99.09% ✅ / N/A |
| `classic_revolution_12x3` | RTLLM | Prob045_alu | 2 | 30 | 1 | 0.2555 | 30 | +25.75% ✅ / +99.21% ✅ / N/A |
| `classic_revolution_6x7` | RTLLM | Prob045_alu | 2 | 25 | 1 | 0.2523 | 25 | +25.44% ✅ / +99.19% ✅ / N/A |
| `classic_revolution_8x5` | RTLLM | Prob045_alu | 2 | 32 | 1 | 0.2341 | 32 | +23.60% ✅ / +99.20% ✅ / N/A |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob045_alu | 2 | 22 | 3 | 0.1809 | 22 | +18.25% ✅ / +99.14% ✅ / N/A |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob045_alu | 2 | 19 | 2 | 0.1683 | 19 | +16.99% ✅ / +99.08% ✅ / N/A |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob045_alu | 2 | 21 | 1 | 0.2586 | 21 | +26.07% ✅ / +99.20% ✅ / N/A |
| `classic_revolution_12x3` | RTLLM | Prob049_signal_generator | 3 | 4 | 3 | 0.0170 | 3 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `classic_revolution_6x7` | RTLLM | Prob049_signal_generator | 3 | 7 | 2 | 0.0192 | 5 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `classic_revolution_8x5` | RTLLM | Prob049_signal_generator | 3 | 8 | 3 | 0.0170 | 5 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 | +40.00% ✅ / +99.61% ✅ / N/A |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 | +40.00% ✅ / +99.61% ✅ / N/A |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 8 | 1 | 0.3984 | 8 | +40.00% ✅ / +99.61% ✅ / N/A |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 | +40.00% ✅ / +99.61% ✅ / N/A |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 | +40.00% ✅ / +99.61% ✅ / N/A |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 | +40.00% ✅ / +99.61% ✅ / N/A |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.1986 | 1 | +20.00% ✅ / +99.31% ✅ / N/A |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.24% ✅ / N/A |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.24% ✅ / N/A |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 3 | 3 | 0.0000 | 0 | -1.62% ❌ / +1.83% ✅ / +4.00% ✅ |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 14 | 6 | 0.0001 | 1 | +10.48% ✅ / +35.47% ✅ / +9.33% ✅ |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 12 | 4 | 0.0004 | 2 | +7.77% ✅ / +31.58% ✅ / +10.67% ✅ |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 5 | 0.0003 | 1 | +8.40% ✅ / +32.95% ✅ / +9.33% ✅ |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0000 | 1 | +6.74% ✅ / +29.06% ✅ / +6.67% ✅ |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 9 | 3 | 0.0011 | 3 | +10.48% ✅ / +35.47% ✅ / +5.33% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution_12x3` | RTLLM | 5 | 5 | 0.1788 ± 0.1378 | 2.60 ± 1.47 | 12.20 ± 11.47 | 0 |
| `classic_revolution_12x3` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1990 ± 0.2254 | 1.67 ± 1.31 | 2.00 ± 2.99 | 1 |
| `classic_revolution_6x7` | RTLLM | 5 | 5 | 0.1924 ± 0.1502 | 2.60 ± 2.20 | 12.20 ± 10.10 | 4 |
| `classic_revolution_6x7` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 ± 0.2603 | 2.67 ± 3.27 | 2.00 ± 2.99 | 0 |
| `classic_revolution_8x5` | RTLLM | 5 | 5 | 0.1464 ± 0.1267 | 3.00 ± 1.86 | 10.60 ± 11.15 | 0 |
| `classic_revolution_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1330 ± 0.2602 | 2.00 ± 1.96 | 3.33 ± 4.71 | 1 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | 5 | 5 | 0.0898 ± 0.0721 | 2.20 ± 0.73 | 7.00 ± 7.77 | 0 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1329 ± 0.2602 | 2.33 ± 2.61 | 2.00 ± 2.99 | 0 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | 5 | 5 | 0.1114 ± 0.0897 | 2.00 ± 0.00 | 7.60 ± 6.86 | 0 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1328 ± 0.2603 | 2.00 ± 1.96 | 1.67 ± 2.36 | 0 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | 5 | 5 | 0.1170 ± 0.0980 | 1.60 ± 0.78 | 7.20 ± 7.58 | 1 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.1332 ± 0.2599 | 1.67 ± 1.31 | 3.00 ± 3.39 | 1 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution_12x3` | ALL | 8 | 8 | 0.1864 ± 0.1108 | 2.25 ± 1.03 | 8.38 ± 7.83 | 1 |
| `classic_revolution_6x7` | ALL | 8 | 8 | 0.1701 ± 0.1256 | 2.62 ± 1.69 | 8.38 ± 7.12 | 4 |
| `classic_revolution_8x5` | ALL | 8 | 8 | 0.1414 ± 0.1141 | 2.62 ± 1.33 | 7.88 ± 7.32 | 1 |
| `shape_density_front_pressure_qd_12x3` | ALL | 8 | 8 | 0.1060 ± 0.0967 | 2.25 ± 0.96 | 5.12 ± 5.07 | 0 |
| `shape_density_front_pressure_qd_6x7` | ALL | 8 | 8 | 0.1194 ± 0.1010 | 2.00 ± 0.64 | 5.38 ± 4.68 | 0 |
| `shape_density_front_pressure_qd_8x5` | ALL | 8 | 8 | 0.1231 ± 0.1035 | 1.62 ± 0.63 | 5.62 ± 4.90 | 2 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 6.2% | -1.0330 | -0.0340 | 4/64 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 6.2% | -0.1082 | 0.0717 | 4/64 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 10.9% | -0.2794 | 0.0528 | 7/64 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob024_fsm | grid_quantile | 16.7% | 2.0538 | 0.5002 | 6/36 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob024_fsm | grid_quantile | 10.9% | 2.5143 | 0.5002 | 7/64 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob024_fsm | grid_quantile | 12.5% | 2.6360 | 0.5002 | 8/64 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob041_traffic_light | grid_quantile | 14.1% | 1.4404 | 0.3627 | 9/64 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob041_traffic_light | grid_quantile | 18.8% | 2.8634 | 0.4077 | 12/64 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob041_traffic_light | grid_quantile | 21.9% | 2.5436 | 0.3891 | 14/64 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob045_alu | grid_quantile | 62.5% | 3.8411 | 0.3911 | 10/16 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob045_alu | grid_quantile | 56.2% | 3.4065 | 0.3868 | 9/16 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob045_alu | grid_quantile | 56.2% | 3.4760 | 0.4175 | 9/16 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob049_signal_generator | grid_quantile | 25.0% | 0.4695 | 0.2348 | 2/8 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob049_signal_generator | grid_quantile | 37.5% | 0.6770 | 0.2348 | 3/8 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob049_signal_generator | grid_quantile | 50.0% | 0.4695 | 0.2348 | 2/4 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 37.5% | 2.5194 | 0.4654 | 6/16 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 22.2% | 0.9297 | 0.4654 | 2/9 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 37.5% | 2.5213 | 0.4654 | 6/16 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 50.0% | 0.5272 | 0.2636 | 2/4 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 50.0% | 1.3118 | 0.2636 | 6/12 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 41.7% | 1.0487 | 0.2641 | 5/12 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 14.8% | 0.2199 | 0.1356 | 4/27 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 9.4% | -0.5169 | 0.1016 | 6/64 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 7.8% | 0.1124 | 0.1443 | 5/64 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 5 | 4 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 6 | 5 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 13 | 9 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=3, duplicate_objectives=1, filled_empty=3, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob024_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 26 | 8 | init=warmup_complete, shape=4x3x3 | none | live crowding_evicted=1, duplicate_objectives=16, filled_empty=3, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob024_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 25 | 8 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=17, filled_empty=3, pareto_inserted=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob024_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 24 | 10 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=13, filled_empty=5, replaced_elite=2, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob041_traffic_light | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 23 | 12 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=4, duplicate_objectives=7, filled_empty=5, pareto_inserted=2, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob041_traffic_light | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 18 | 14 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=2, duplicate_objectives=1, filled_empty=8, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob041_traffic_light | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 20 | 16 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=4, filled_empty=10, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob045_alu | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 23 | 14 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live crowding_evicted=6, duplicate_objectives=1, filled_empty=6, pareto_inserted=4, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob045_alu | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 21 | 12 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live crowding_evicted=5, duplicate_objectives=1, filled_empty=5, pareto_inserted=4, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob045_alu | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 21 | 16 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live crowding_evicted=1, filled_empty=5, pareto_inserted=6, replaced_elite=5, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_12x3` | RTLLM | Prob049_signal_generator | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 42 | 2 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=31, warmup_buffered=11; replay duplicate_objectives=9, filled_empty=2 |
| `shape_density_front_pressure_qd_6x7` | RTLLM | Prob049_signal_generator | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 40 | 3 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=31, filled_empty=1, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `shape_density_front_pressure_qd_8x5` | RTLLM | Prob049_signal_generator | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 44 | 2 | init=warmup_complete, shape=1x2x2 | source_aligned_masterrtl_branching | live duplicate_objectives=38, warmup_buffered=6; replay duplicate_objectives=4, filled_empty=2 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 40 | 6 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=34, filled_empty=2, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 24 | 3 | init=warmup_complete, shape=3x3x1 | source_aligned_rtltimer_dff_density | live crowding_evicted=1, duplicate_objectives=17, replaced_elite=2, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 27 | 8 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=17, filled_empty=2, pareto_inserted=1, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 34 | 4 | init=warmup_complete, shape=2x2x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=26, pareto_inserted=1, replaced_elite=1, warmup_buffered=6; replay duplicate_objectives=4, filled_empty=2 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 45 | 6 | init=warmup_complete, shape=4x3x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=38, filled_empty=3, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 43 | 6 | init=warmup_complete, shape=4x3x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=36, filled_empty=1, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_12x3` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 11 | 8 | init=warmup_complete, shape=3x3x3 | none | live crowding_evicted=2, filled_empty=2, pareto_inserted=2, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=2, pareto_inserted=1 |
| `shape_density_front_pressure_qd_6x7` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 9 | 7 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=1, duplicate_objectives=1, filled_empty=2, pareto_inserted=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd_8x5` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 10 | 6 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=2, filled_empty=1, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
