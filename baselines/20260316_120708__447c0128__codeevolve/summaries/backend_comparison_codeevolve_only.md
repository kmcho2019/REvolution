# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `codeevolve` | ALL | candidate_evaluations | 210 | N/A | 290.92 ± 1.05 | 2705471.10 ± 177139.86 | 307.33 | 334.80 |
| `codeevolve` | RTLLM | candidate_evaluations | 210 | N/A | 288.94 ± 2.31 | 3512718.84 ± 449427.56 | 328.34 | 424.91 |
| `codeevolve` | VerilogEval-Spec-to-RTL | candidate_evaluations | 210 | N/A | 291.56 ± 1.16 | 2446737.85 ± 165833.08 | 301.21 | 313.68 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|
| `codeevolve` | RTLLM | Prob001_accu | ✅ Pass (47.6%) | ✅ Pass (47.6%) | +14.41% ✅ | -17.80% ❌ / +43.80% ✅ / +17.24% ✅ | +14.41% ✅ | 78534.67 | 280 |
| `codeevolve` | RTLLM | Prob002_adder_16bit | ✅ Pass (94.8%) | ✅ Pass (94.3%) | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 74021.72 | 286 |
| `codeevolve` | RTLLM | Prob003_adder_32bit | ✅ Pass (75.7%) | ✅ Pass (74.3%) | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 91402.32 | 293 |
| `codeevolve` | RTLLM | Prob004_adder_8bit | ✅ Pass (83.3%) | ✅ Pass (81.4%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 62892.38 | 282 |
| `codeevolve` | RTLLM | Prob005_adder_bcd | ✅ Pass (96.7%) | ✅ Pass (95.2%) | +37.42% ✅ | +13.33% ✅ / +98.93% ✅ / N/A | +56.13% ✅ | 70204.30 | 285 |
| `codeevolve` | RTLLM | Prob006_adder_pipe_64bit | ✅ Pass (61.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 101641.48 | 293 |
| `codeevolve` | RTLLM | Prob007_comparator_3bit | ✅ Pass (98.1%) | ✅ Pass (97.1%) | +35.01% ✅ | +5.88% ✅ / +99.14% ✅ / N/A | +52.51% ✅ | 66779.33 | 303 |
| `codeevolve` | RTLLM | Prob008_comparator_4bit | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +44.26% ✅ | +33.33% ✅ / +99.44% ✅ / N/A | +66.39% ✅ | 75792.38 | 299 |
| `codeevolve` | RTLLM | Prob009_div_16bit | ✅ Pass (75.2%) | ✅ Pass (68.6%) | +52.11% ✅ | +77.48% ✅ / +78.86% ✅ / N/A | +78.17% ✅ | 74757.21 | 281 |
| `codeevolve` | RTLLM | Prob010_radix2_div | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 123562.03 | 295 |
| `codeevolve` | RTLLM | Prob011_multi_16bit | ✅ Pass (45.7%) | ✅ Pass (45.2%) | +36.33% ✅ | +10.71% ✅ / +55.17% ✅ / +43.10% ✅ | +36.33% ✅ | 87335.20 | 269 |
| `codeevolve` | RTLLM | Prob012_multi_8bit | ✅ Pass (93.3%) | ✅ Pass (89.0%) | +31.79% ✅ | +38.93% ✅ / +56.43% ✅ / N/A | +47.68% ✅ | 59135.48 | 278 |
| `codeevolve` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (91.4%) | ✅ Pass (43.8%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 97650.98 | 297 |
| `codeevolve` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (78.1%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 91451.62 | 291 |
| `codeevolve` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (40.5%) | ✅ Pass (36.7%) | +50.46% ✅ | +43.06% ✅ / +25.39% ✅ / +82.93% ✅ | +50.46% ✅ | 92839.06 | 293 |
| `codeevolve` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (92.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 84256.58 | 290 |
| `codeevolve` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (94.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 77020.05 | 292 |
| `codeevolve` | RTLLM | Prob018_float_multi | ✅ Pass (40.0%) | ✅ Pass (28.6%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 130835.61 | 288 |
| `codeevolve` | RTLLM | Prob019_sub_64bit | ✅ Pass (99.0%) | ✅ Pass (98.6%) | +30.21% ✅ | +45.25% ✅ / +45.39% ✅ / N/A | +45.32% ✅ | 63054.28 | 288 |
| `codeevolve` | RTLLM | Prob020_JC_counter | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 58106.36 | 281 |
| `codeevolve` | RTLLM | Prob021_counter_12 | ✅ Pass (99.0%) | ✅ Pass (98.1%) | +18.44% ✅ | +2.27% ✅ / +63.76% ✅ / -10.71% ❌ | +18.44% ✅ | 61259.99 | 282 |
| `codeevolve` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 86512.19 | 305 |
| `codeevolve` | RTLLM | Prob023_up_down_counter | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +8.20% ✅ | +13.13% ✅ / +96.65% ✅ / +100.00% ✅ | +69.93% ✅ | 63909.15 | 296 |
| `codeevolve` | RTLLM | Prob024_fsm | ✅ Pass (60.0%) | ✅ Pass (59.0%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 77879.22 | 292 |
| `codeevolve` | RTLLM | Prob025_sequence_detector | ✅ Pass (27.6%) | ✅ Pass (27.6%) | +36.24% ✅ | +34.21% ✅ / +48.20% ✅ / +26.32% ✅ | +36.24% ✅ | 77466.21 | 289 |
| `codeevolve` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 104310.47 | 293 |
| `codeevolve` | RTLLM | Prob027_LIFObuffer | ✅ Pass (85.7%) | ✅ Pass (85.7%) | +23.57% ✅ | +17.73% ✅ / +42.72% ✅ / +10.26% ✅ | +23.57% ✅ | 82796.91 | 288 |
| `codeevolve` | RTLLM | Prob028_LFSR | ✅ Pass (12.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 67887.88 | 285 |
| `codeevolve` | RTLLM | Prob029_barrel_shifter | ✅ Pass (20.0%) | ✅ Pass (19.0%) | +17.02% ✅ | +25.86% ✅ / +25.19% ✅ / N/A | +25.52% ✅ | 81617.60 | 301 |
| `codeevolve` | RTLLM | Prob030_right_shifter | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 59830.81 | 293 |
| `codeevolve` | RTLLM | Prob031_freq_div | ✅ Pass (91.0%) | ✅ Pass (82.4%) | +39.99% ✅ | +20.80% ✅ / +99.16% ✅ / N/A | +59.98% ✅ | 82655.67 | 280 |
| `codeevolve` | RTLLM | Prob032_freq_divbyeven | ✅ Pass (1.4%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 92035.67 | 282 |
| `codeevolve` | RTLLM | Prob033_freq_divbyfrac | ✅ Pass (2.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 126572.65 | 292 |
| `codeevolve` | RTLLM | Prob034_freq_divbyodd | ✅ Pass (0.5%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 119697.47 | 296 |
| `codeevolve` | RTLLM | Prob035_calendar | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 84959.71 | 289 |
| `codeevolve` | RTLLM | Prob036_edge_detect | ✅ Pass (92.9%) | ✅ Pass (92.4%) | +28.59% ✅ | +26.32% ✅ / +41.80% ✅ / +17.65% ✅ | +28.59% ✅ | 70915.36 | 290 |
| `codeevolve` | RTLLM | Prob037_parallel2serial | ✅ Pass (32.9%) | ✅ Pass (30.0%) | +52.00% ✅ | +62.00% ✅ / +56.95% ✅ / +37.04% ✅ | +52.00% ✅ | 81664.62 | 288 |
| `codeevolve` | RTLLM | Prob038_pulse_detect | ✅ Pass (26.7%) | ✅ Pass (26.2%) | +27.89% ✅ | +23.53% ✅ / +26.81% ✅ / +33.33% ✅ | +27.89% ✅ | 75270.48 | 290 |
| `codeevolve` | RTLLM | Prob039_serial2parallel | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 86089.40 | 284 |
| `codeevolve` | RTLLM | Prob040_synchronizer | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 78688.27 | 300 |
| `codeevolve` | RTLLM | Prob041_traffic_light | ✅ Pass (62.9%) | ✅ Pass (62.9%) | +43.71% ✅ | +32.35% ✅ / +98.78% ✅ / N/A | +65.57% ✅ | 80069.28 | 278 |
| `codeevolve` | RTLLM | Prob042_width_8to16 | ✅ Pass (10.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 87192.86 | 288 |
| `codeevolve` | RTLLM | Prob043_RAM | ✅ Pass (82.4%) | ✅ Pass (80.5%) | +44.45% ✅ | +34.47% ✅ / +63.39% ✅ / +35.48% ✅ | +44.45% ✅ | 68379.70 | 275 |
| `codeevolve` | RTLLM | Prob044_ROM | ✅ Pass (76.2%) | ✅ Pass (76.2%) | +32.94% ✅ | +0.00% ➖ / +98.83% ✅ / N/A | +49.41% ✅ | 60307.43 | 278 |
| `codeevolve` | RTLLM | Prob045_alu | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 101253.68 | 290 |
| `codeevolve` | RTLLM | Prob046_clkgenerator | ✅ Pass (3.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 74719.49 | 312 |
| `codeevolve` | RTLLM | Prob047_instr_reg | ✅ Pass (98.6%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 63782.04 | 275 |
| `codeevolve` | RTLLM | Prob048_pe | ✅ Pass (82.4%) | ✅ Pass (82.4%) | +28.74% ✅ | +0.03% ✅ / +49.89% ✅ / +100.00% ✅ | +49.97% ✅ | 62982.10 | 285 |
| `codeevolve` | RTLLM | Prob049_signal_generator | ✅ Pass (42.9%) | ✅ Pass (41.9%) | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 72183.26 | 290 |
| `codeevolve` | RTLLM | Prob050_square_wave | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +80.75% ✅ | +91.60% ✅ / +95.38% ✅ / +55.26% ✅ | +80.75% ✅ | 67047.78 | 297 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob001_zero | ✅ Pass (91.9%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 54256.61 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob002_m2014_q4i | ✅ Pass (90.5%) | ✅ Pass (89.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 55838.03 | 300 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob003_step_one | ✅ Pass (89.5%) | ✅ Pass (89.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 53307.02 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob004_vector2 | ✅ Pass (97.1%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 54427.63 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob005_notgate | ✅ Pass (96.2%) | ✅ Pass (95.7%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 51654.23 | 285 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob006_vectorr | ✅ Pass (92.9%) | ✅ Pass (90.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 53217.41 | 290 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob007_wire | ✅ Pass (95.7%) | ✅ Pass (95.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 49947.93 | 293 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob008_m2014_q4h | ✅ Pass (97.6%) | ✅ Pass (97.1%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 50156.48 | 290 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob009_popcount3 | ✅ Pass (94.3%) | ✅ Pass (92.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 53656.77 | 304 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob010_mt2015_q4a | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 48349.70 | 291 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob011_norgate | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 46002.27 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob012_xnorgate | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 45162.27 | 299 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob013_m2014_q4e | ✅ Pass (97.6%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 35690.67 | 285 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob014_andgate | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.96% ✅ | +0.00% ➖ / +98.89% ✅ / N/A | +49.45% ✅ | 33453.98 | 284 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob015_vector1 | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 37546.57 | 291 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob016_m2014_q4j | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +42.43% ✅ | +28.00% ✅ / +99.29% ✅ / N/A | +63.65% ✅ | 48816.38 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob017_mux2to1v | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 36229.09 | 282 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob018_mux256to1 | ✅ Pass (92.9%) | ✅ Pass (92.4%) | +32.98% ✅ | +0.00% ➖ / +98.95% ✅ / N/A | +49.47% ✅ | 72292.28 | 291 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob019_m2014_q4f | ✅ Pass (93.3%) | ✅ Pass (92.9%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 38650.26 | 298 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob020_mt2015_eq2 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 41330.20 | 303 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob021_mux256to1v | ✅ Pass (75.7%) | ✅ Pass (75.7%) | +42.32% ✅ | +27.35% ✅ / +99.60% ✅ / N/A | +63.48% ✅ | 55031.07 | 286 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob022_mux2to1 | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 37138.36 | 285 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob023_vector100r | ✅ Pass (84.3%) | ✅ Pass (78.6%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 45268.33 | 308 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob024_hadd | ✅ Pass (96.2%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.46% ✅ | 37791.88 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob025_reduction | ✅ Pass (98.6%) | ✅ Pass (94.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 39987.29 | 298 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob026_alwaysblock1 | ✅ Pass (94.8%) | ✅ Pass (94.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 40107.67 | 289 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob027_fadd | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 38209.99 | 287 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob028_m2014_q4a | ✅ Pass (87.6%) | ✅ Pass (32.9%) | +44.19% ✅ | +33.33% ✅ / +99.22% ✅ / N/A | +66.28% ✅ | 54774.86 | 285 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob029_m2014_q4g | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 40186.23 | 287 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob030_popcount255 | ✅ Pass (90.0%) | ✅ Pass (87.1%) | +29.04% ✅ | -0.45% ❌ / +87.58% ✅ / N/A | +43.57% ✅ | 63593.13 | 291 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob031_dff | ✅ Pass (96.7%) | ✅ Pass (96.2%) | +33.25% ✅ | +0.00% ➖ / +99.74% ✅ / N/A | +49.87% ✅ | 41154.48 | 296 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob032_vector0 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 43411.43 | 299 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob033_ece241_2014_q1c | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +40.74% ✅ | +23.08% ✅ / +99.16% ✅ / N/A | +61.12% ✅ | 46869.16 | 287 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob034_dff8 | ✅ Pass (35.7%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 78798.80 | 298 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob035_count1to10 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +4.67% ✅ | +0.00% ➖ / +14.00% ✅ / +0.00% ➖ | +4.67% ✅ | 48085.81 | 299 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob036_ringer | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 43938.30 | 301 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob037_review2015_count1k | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 48186.44 | 300 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob038_count15 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +1.15% ✅ | -3.33% ❌ / -1.20% ❌ / +8.00% ✅ | +1.15% ✅ | 44129.83 | 298 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob039_always_if | ✅ Pass (93.8%) | ✅ Pass (92.9%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 41479.78 | 286 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob040_count10 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +1.45% ✅ | +2.56% ✅ / -5.91% ❌ / +7.69% ✅ | +1.45% ✅ | 45850.02 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob041_dff8r | ✅ Pass (97.6%) | ✅ Pass (96.2%) | +38.51% ✅ | +15.79% ✅ / +99.74% ✅ / N/A | +57.76% ✅ | 40023.56 | 280 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob042_vector4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 36799.29 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob043_vector5 | ✅ Pass (84.3%) | ✅ Pass (83.3%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 57739.30 | 289 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob044_vectorgates | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +32.96% ✅ | +0.00% ➖ / +98.88% ✅ / N/A | +49.44% ✅ | 40122.45 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob045_edgedetect2 | ✅ Pass (64.3%) | ✅ Pass (64.3%) | +12.40% ✅ | +0.00% ➖ / +7.80% ✅ / +29.41% ✅ | +12.40% ✅ | 50830.54 | 300 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob046_dff8p | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +33.24% ✅ | +0.00% ➖ / +99.71% ✅ / N/A | +49.85% ✅ | 39318.71 | 297 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob047_dff8ar | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +30.15% ✅ | -9.30% ❌ / +99.75% ✅ / N/A | +45.22% ✅ | 37035.92 | 285 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob048_m2014_q4c | ✅ Pass (97.6%) | ✅ Pass (96.7%) | +33.23% ✅ | +0.00% ➖ / +99.68% ✅ / N/A | +49.84% ✅ | 36598.10 | 297 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob049_m2014_q4b | ✅ Pass (91.0%) | ✅ Pass (88.1%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.88% ✅ | 39287.77 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob050_kmap1 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.96% ✅ | +0.00% ➖ / +98.87% ✅ / N/A | +49.44% ✅ | 34536.71 | 296 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob051_gates4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +34.99% ✅ | +6.25% ✅ / +98.73% ✅ / N/A | +52.49% ✅ | 36197.84 | 293 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob052_gates100 | ✅ Pass (93.8%) | ✅ Pass (86.7%) | +24.56% ✅ | +42.66% ✅ / +31.02% ✅ / N/A | +36.84% ✅ | 43772.53 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob053_m2014_q4d | ✅ Pass (51.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 71968.26 | 307 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob054_edgedetect | ✅ Pass (67.1%) | ✅ Pass (67.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 47586.62 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob055_conditional | ✅ Pass (97.6%) | ✅ Pass (96.7%) | +37.88% ✅ | +14.40% ✅ / +99.24% ✅ / N/A | +56.82% ✅ | 38180.62 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob056_ece241_2013_q7 | ✅ Pass (100.0%) | ✅ Pass (47.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 49916.58 | 301 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob057_kmap2 | ✅ Pass (85.7%) | ✅ Pass (85.7%) | +44.24% ✅ | +33.33% ✅ / +99.38% ✅ / N/A | +66.35% ✅ | 70365.36 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob058_alwaysblock2 | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +33.16% ✅ | +0.00% ➖ / +99.49% ✅ / N/A | +49.74% ✅ | 37353.62 | 301 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob059_wire4 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 32855.86 | 289 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob060_m2014_q4k | ✅ Pass (95.2%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 38258.50 | 298 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob061_2014_q4a | ✅ Pass (95.7%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 34180.19 | 289 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob062_bugs_mux2 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 57130.80 | 297 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob063_review2015_shiftcount | ✅ Pass (64.8%) | ✅ Pass (64.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 39648.46 | 276 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob064_vector3 | ✅ Pass (89.0%) | ✅ Pass (89.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 39177.30 | 286 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob065_7420 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.95% ✅ | +0.00% ➖ / +98.86% ✅ / N/A | +49.43% ✅ | 34667.42 | 286 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob066_edgecapture | ✅ Pass (25.2%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 63595.42 | 287 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob067_countslow | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +11.27% ✅ | +19.15% ✅ / +1.34% ✅ / +13.33% ✅ | +11.27% ✅ | 39509.63 | 302 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob068_countbcd | ✅ Pass (78.6%) | ✅ Pass (75.2%) | +14.25% ✅ | +6.11% ✅ / +17.12% ✅ / +19.51% ✅ | +14.25% ✅ | 73674.57 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob069_truthtable1 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 36580.83 | 293 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob070_ece241_2013_q2 | ✅ Pass (75.2%) | ✅ Pass (75.2%) | +33.00% ✅ | +0.00% ➖ / +98.99% ✅ / N/A | +49.49% ✅ | 69417.17 | 285 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob071_always_casez | ✅ Pass (78.6%) | ✅ Pass (68.6%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 45891.12 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob072_thermostat | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 39586.36 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob073_dff16e | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 41279.66 | 290 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob074_ece241_2014_q4 | ✅ Pass (34.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 98717.00 | 297 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob075_counter_2bc | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +36.08% ✅ | +33.33% ✅ / +54.90% ✅ / +20.00% ✅ | +36.08% ✅ | 45001.19 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob076_always_case | ✅ Pass (90.0%) | ✅ Pass (90.0%) | +3.14% ✅ | +4.55% ✅ / +4.86% ✅ / N/A | +4.71% ✅ | 43781.91 | 291 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob077_wire_decl | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 32372.96 | 268 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob078_dualedge | ✅ Pass (91.9%) | ✅ Pass (91.4%) | +33.27% ✅ | +0.00% ➖ / +99.80% ✅ / N/A | +49.90% ✅ | 44509.97 | 285 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob079_fsm3onehot | ✅ Pass (89.5%) | ✅ Pass (89.0%) | +17.03% ✅ | +12.50% ✅ / +38.59% ✅ / N/A | +25.55% ✅ | 50385.40 | 301 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob080_timer | ✅ Pass (92.4%) | ✅ Pass (92.4%) | +3.64% ✅ | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | +3.64% ✅ | 43734.63 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob081_7458 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.46% ✅ | 45929.71 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob082_lfsr32 | ✅ Pass (82.9%) | ✅ Pass (80.5%) | +4.00% ✅ | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | +4.00% ✅ | 60987.62 | 298 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob083_mt2015_q4b | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 34780.36 | 286 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob084_ece241_2013_q12 | ✅ Pass (85.2%) | ✅ Pass (85.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 52039.08 | 282 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob085_shift4 | ✅ Pass (94.3%) | ✅ Pass (92.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 43908.56 | 289 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob086_lfsr5 | ✅ Pass (85.7%) | ✅ Pass (83.8%) | +5.28% ✅ | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | +5.28% ✅ | 48781.01 | 284 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob087_gates | ✅ Pass (95.7%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 45452.57 | 291 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob088_ece241_2014_q5b | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +2.79% ✅ | +10.00% ✅ / +5.03% ✅ / -6.67% ❌ | +2.79% ✅ | 48109.39 | 278 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob089_ece241_2014_q5a | ✅ Pass (71.0%) | ✅ Pass (71.0%) | +41.25% ✅ | +34.78% ✅ / +66.24% ✅ / +22.73% ✅ | +41.25% ✅ | 58132.05 | 288 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob090_circuit1 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.96% ✅ | +0.00% ➖ / +98.89% ✅ / N/A | +49.45% ✅ | 37407.28 | 298 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob091_2012_q2b | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +41.37% ✅ | +25.00% ✅ / +99.12% ✅ / N/A | +62.06% ✅ | 53466.01 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob092_gatesv100 | ✅ Pass (79.5%) | ✅ Pass (79.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 56533.17 | 302 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob093_ece241_2014_q3 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 85972.58 | 293 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob094_gatesv | ✅ Pass (90.0%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 52762.80 | 296 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob095_review2015_fsmshift | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 66557.91 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob096_review2015_fsmseq | ✅ Pass (63.3%) | ✅ Pass (63.3%) | +15.82% ✅ | +18.18% ✅ / +24.02% ✅ / +5.26% ✅ | +15.82% ✅ | 56143.61 | 285 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob097_mux9to1v | ✅ Pass (90.5%) | ✅ Pass (89.5%) | +10.25% ✅ | +15.99% ✅ / +14.75% ✅ / N/A | +15.37% ✅ | 51026.59 | 293 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (68.1%) | ✅ Pass (68.1%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 65722.79 | 280 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob099_m2014_q6c | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 45344.92 | 284 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob100_fsm3comb | ✅ Pass (84.3%) | ✅ Pass (84.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 58774.40 | 306 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob101_circuit4 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 41178.13 | 289 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob102_circuit3 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.46% ✅ | 47836.47 | 298 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob103_circuit2 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 47213.39 | 297 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob104_mt2015_muxdff | ✅ Pass (22.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 84074.63 | 287 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob105_rotate100 | ✅ Pass (95.7%) | ✅ Pass (92.9%) | +8.90% ✅ | +6.87% ✅ / +6.18% ✅ / +13.64% ✅ | +8.90% ✅ | 52439.46 | 296 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob106_always_nolatches | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +39.72% ✅ | +20.00% ✅ / +99.17% ✅ / N/A | +59.59% ✅ | 48051.11 | 288 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob107_fsm1s | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +1.78% ✅ | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | +1.78% ✅ | 46062.02 | 282 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob108_rule90 | ✅ Pass (89.0%) | ✅ Pass (4.3%) | -7.66% ❌ | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | -7.66% ❌ | 131431.35 | 289 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob109_fsm1 | ✅ Pass (93.3%) | ✅ Pass (93.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 46279.82 | 280 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob110_fsm2 | ✅ Pass (91.4%) | ✅ Pass (91.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 44468.19 | 283 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob111_fsm2s | ✅ Pass (91.9%) | ✅ Pass (91.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 45734.28 | 288 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob112_always_case2 | ✅ Pass (89.5%) | ✅ Pass (85.2%) | +0.17% ✅ | +0.00% ➖ / +0.52% ✅ / N/A | +0.26% ✅ | 48569.35 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob113_2012_q1g | ✅ Pass (81.9%) | ✅ Pass (81.9%) | +0.16% ✅ | +0.00% ➖ / +0.47% ✅ / N/A | +0.23% ✅ | 92259.65 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob114_bugs_case | ✅ Pass (91.9%) | ✅ Pass (90.5%) | +12.65% ✅ | +9.43% ✅ / +28.50% ✅ / N/A | +18.97% ✅ | 55050.63 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob115_shift18 | ✅ Pass (91.0%) | ✅ Pass (90.0%) | +25.49% ✅ | +16.32% ✅ / +27.73% ✅ / +32.43% ✅ | +25.49% ✅ | 53551.04 | 283 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (57.1%) | ✅ Pass (57.1%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 80199.41 | 286 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob117_circuit9 | ✅ Pass (51.4%) | ✅ Pass (51.0%) | +13.77% ✅ | +3.85% ✅ / +37.47% ✅ / +0.00% ➖ | +13.77% ✅ | 70319.82 | 287 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob118_history_shift | ✅ Pass (92.4%) | ✅ Pass (89.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 58127.86 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob119_fsm3 | ✅ Pass (78.1%) | ✅ Pass (78.1%) | +2.70% ✅ | +5.88% ✅ / +2.22% ✅ / +0.00% ➖ | +2.70% ✅ | 64818.21 | 284 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob120_fsm3s | ✅ Pass (76.7%) | ✅ Pass (76.7%) | +30.98% ✅ | +37.04% ✅ / +50.35% ✅ / +5.56% ✅ | +30.98% ✅ | 70079.61 | 297 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob121_2014_q3bfsm | ✅ Pass (79.5%) | ✅ Pass (79.5%) | +8.93% ✅ | +23.08% ✅ / +27.53% ✅ / -23.81% ❌ | +8.93% ✅ | 73471.91 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob122_kmap4 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 52322.54 | 296 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob123_bugs_addsubz | ✅ Pass (86.2%) | ✅ Pass (85.7%) | +39.65% ✅ | +20.00% ✅ / +98.94% ✅ / N/A | +59.47% ✅ | 56917.13 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob124_rule110 | ✅ Pass (71.4%) | ✅ Pass (12.4%) | -11.34% ❌ | -7.84% ❌ / -12.54% ❌ / -13.64% ❌ | -11.34% ❌ | 123549.90 | 288 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob125_kmap3 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 59941.04 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob126_circuit6 | ✅ Pass (65.7%) | ✅ Pass (65.7%) | +23.50% ✅ | +38.33% ✅ / +32.16% ✅ / N/A | +35.24% ✅ | 52837.17 | 276 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob127_lemmings1 | ✅ Pass (57.1%) | ✅ Pass (57.1%) | -7.25% ❌ | -12.50% ❌ / -19.25% ❌ / +10.00% ✅ | -7.25% ❌ | 69031.96 | 303 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob128_fsm_ps2 | ✅ Pass (42.9%) | ✅ Pass (42.9%) | +1.25% ✅ | +0.00% ➖ / -2.14% ❌ / +5.88% ✅ | +1.25% ✅ | 73949.09 | 279 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob129_ece241_2013_q8 | ✅ Pass (90.0%) | ✅ Pass (89.0%) | +16.99% ✅ | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | +16.99% ✅ | 67271.31 | 289 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob130_circuit5 | ✅ Pass (90.5%) | ✅ Pass (90.5%) | +8.67% ✅ | +5.88% ✅ / +20.13% ✅ / N/A | +13.01% ✅ | 60758.54 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob131_mt2015_q4 | ✅ Pass (82.4%) | ✅ Pass (82.4%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 86157.41 | 304 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob132_always_if2 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.96% ✅ | +0.00% ➖ / +98.87% ✅ / N/A | +49.43% ✅ | 60109.11 | 301 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob133_2014_q3fsm | ✅ Pass (59.0%) | ✅ Pass (57.6%) | +21.40% ✅ | +26.79% ✅ / +29.41% ✅ / +8.00% ✅ | +21.40% ✅ | 98669.82 | 287 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob134_2014_q3c | ✅ Pass (91.0%) | ✅ Pass (91.0%) | +17.39% ✅ | +28.57% ✅ / +23.60% ✅ / N/A | +26.09% ✅ | 80869.74 | 284 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (87.6%) | ✅ Pass (87.6%) | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 96766.67 | 296 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob136_m2014_q6 | ✅ Pass (65.2%) | ✅ Pass (64.8%) | +23.87% ✅ | +34.88% ✅ / +46.73% ✅ / -10.00% ❌ | +23.87% ✅ | 87033.57 | 301 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob137_fsm_serial | ✅ Pass (45.7%) | ✅ Pass (45.7%) | +10.43% ✅ | +24.24% ✅ / +12.60% ✅ / -5.56% ❌ | +10.43% ✅ | 90164.73 | 285 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob138_2012_q2fsm | ✅ Pass (71.9%) | ✅ Pass (68.1%) | +27.70% ✅ | +36.96% ✅ / +46.15% ✅ / +0.00% ➖ | +27.70% ✅ | 83431.25 | 293 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob139_2013_q2bfsm | ✅ Pass (18.1%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 126473.95 | 305 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob140_fsm_hdlc | ✅ Pass (47.1%) | ✅ Pass (47.1%) | +32.64% ✅ | +30.88% ✅ / +39.44% ✅ / +27.59% ✅ | +32.64% ✅ | 97819.09 | 291 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob141_count_clock | ✅ Pass (64.3%) | ✅ Pass (64.3%) | +19.92% ✅ | +24.35% ✅ / +22.63% ✅ / +12.77% ✅ | +19.92% ✅ | 105035.47 | 276 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob142_lemmings2 | ✅ Pass (58.1%) | ✅ Pass (58.1%) | +7.86% ✅ | +5.00% ✅ / +18.57% ✅ / +0.00% ➖ | +7.86% ✅ | 88712.83 | 282 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob143_fsm_onehot | ✅ Pass (81.4%) | ✅ Pass (81.4%) | +12.82% ✅ | +23.08% ✅ / +15.37% ✅ / N/A | +19.22% ✅ | 94573.35 | 282 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob144_conwaylife | ✅ Pass (59.0%) | ✅ Pass (45.2%) | +6.95% ✅ | +2.24% ✅ / +15.90% ✅ / +2.70% ✅ | +6.95% ✅ | 277871.51 | 283 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob145_circuit8 | ✅ Pass (83.8%) | ✅ Pass (59.0%) | +37.44% ✅ | +12.50% ✅ / +99.82% ✅ / N/A | +56.16% ✅ | 102976.77 | 295 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob146_fsm_serialdata | ✅ Pass (34.3%) | ✅ Pass (34.3%) | -17.74% ❌ | +0.68% ✅ / +12.77% ✅ / -66.67% ❌ | -17.74% ❌ | 103010.34 | 293 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob147_circuit10 | ✅ Pass (66.7%) | ✅ Pass (66.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 105498.19 | 292 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob148_2013_q2afsm | ✅ Pass (77.6%) | ✅ Pass (77.6%) | +21.52% ✅ | +28.57% ✅ / +26.91% ✅ / +9.09% ✅ | +21.52% ✅ | 82548.67 | 269 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob149_ece241_2013_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 107946.24 | 313 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (77.6%) | ✅ Pass (77.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 97309.64 | 296 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (35.2%) | ✅ Pass (35.2%) | -12.28% ❌ | -10.61% ❌ / -47.65% ❌ / +21.43% ✅ | -12.28% ❌ | 103641.34 | 299 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob152_lemmings3 | ✅ Pass (55.2%) | ✅ Pass (54.8%) | +24.45% ✅ | +40.00% ✅ / +37.68% ✅ / -4.35% ❌ | +24.45% ✅ | 96324.66 | 283 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (50.5%) | ✅ Pass (50.5%) | +15.30% ✅ | +9.12% ✅ / +34.10% ✅ / +2.67% ✅ | +15.30% ✅ | 96380.62 | 294 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob154_fsm_ps2data | ✅ Pass (27.6%) | ✅ Pass (27.1%) | -55.15% ❌ | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | -55.15% ❌ | 95109.86 | 291 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob155_lemmings4 | ✅ Pass (42.4%) | ✅ Pass (42.4%) | +19.55% ✅ | +9.80% ✅ / +70.28% ✅ / -21.43% ❌ | +19.55% ✅ | 97427.82 | 290 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob156_review2015_fancytimer | ✅ Pass (24.3%) | ✅ Pass (24.3%) | +3.81% ✅ | -20.32% ❌ / +27.40% ✅ / +4.35% ✅ | +3.81% ✅ | 102267.37 | 281 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `codeevolve` | RTLLM | 50 | ➖ 44/50 (88.0%) | ➖ 34/50 (68.0%) | 58.1% ± 10.6% | 49.0% ± 11.2% | 34/50 | +30.53% ± 6.81% ✅ | ✅ 28 / ➖ 6 / ❌ 0 | 31/50 | +43.83% ± 8.11% ✅ | +25.47% ± 8.90% ✅ / +62.11% ± 11.61% ✅ / +33.05% ± 16.24% ✅ | ✅ 28 / ➖ 3 / ❌ 0 | A ❌ 1/31 / P ✅ 0/31 / T ❌ 1/17 | 81224.21 ± 4892.22 | 288.94 ± 2.31 |
| `codeevolve` | VerilogEval-Spec-to-RTL | 156 | ➖ 151/156 (96.8%) | ➖ 145/156 (92.9%) | 80.5% ± 3.8% | 76.9% ± 4.5% | 145/156 | +18.39% ± 2.79% ✅ | ✅ 109 / ➖ 30 / ❌ 6 | 145/156 | +26.24% ± 4.00% ✅ | +6.05% ± 2.28% ✅ / +48.30% ± 7.55% ✅ / +2.16% ± 3.94% ✅ | ✅ 109 / ➖ 30 / ❌ 6 | A ❌ 10/145 / P ❌ 8/145 / T ❌ 11/55 | 60226.45 ± 4454.46 | 291.56 ± 1.16 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `codeevolve` | ALL | 206 | ➖ 195/206 (94.7%) | ➖ 179/206 (86.9%) | 75.1% ± 4.1% | 70.1% ± 4.6% | 179/206 | +20.70% ± 2.69% ✅ | ✅ 137 / ➖ 36 / ❌ 6 | 176/206 | +29.34% ± 3.72% ✅ | +9.47% ± 2.67% ✅ / +50.74% ± 6.58% ✅ / +9.46% ± 5.69% ✅ | ✅ 137 / ➖ 33 / ❌ 6 | A ❌ 11/176 / P ❌ 8/176 / T ❌ 12/72 | 65322.99 ± 3777.36 | 290.92 ± 1.05 |

