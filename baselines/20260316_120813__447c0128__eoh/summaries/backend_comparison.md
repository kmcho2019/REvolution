# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `eoh` | ALL | candidate_evaluations | 210 | N/A | 210.02 ± 0.02 | 577444.72 ± 29155.93 | 226.51 | 243.06 |
| `eoh` | RTLLM | candidate_evaluations | 210 | N/A | 210.00 ± 0.00 | 657078.66 ± 61675.69 | 262.50 | 318.18 |
| `eoh` | VerilogEval-Spec-to-RTL | candidate_evaluations | 210 | N/A | 210.03 ± 0.02 | 551921.03 ± 32135.44 | 216.98 | 225.96 |
| `funsearch` | ALL | candidate_evaluations | 210 | N/A | 210.00 ± 0.00 | 605185.46 ± 48382.26 | 235.11 | 245.80 |
| `funsearch` | RTLLM | candidate_evaluations | 210 | N/A | 210.00 ± 0.00 | 806243.86 ± 109737.73 | 291.67 | 328.12 |
| `funsearch` | VerilogEval-Spec-to-RTL | candidate_evaluations | 210 | N/A | 210.00 ± 0.00 | 540743.67 ± 49437.10 | 221.35 | 227.50 |
| `revolution` | ALL | candidate_evaluations | 210 | N/A | 420.00 ± 0.04 | 1212981.74 ± 47229.12 | 443.69 | 475.38 |
| `revolution` | RTLLM | candidate_evaluations | 210 | N/A | 420.00 ± 0.00 | 1390512.82 ± 101173.61 | 477.27 | 567.57 |
| `revolution` | VerilogEval-Spec-to-RTL | candidate_evaluations | 210 | N/A | 420.00 ± 0.06 | 1156080.75 ± 50278.46 | 433.91 | 451.86 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|
| `eoh` | RTLLM | Prob001_accu | ✅ Pass (57.1%) | ✅ Pass (57.1%) | +14.41% ✅ | -17.80% ❌ / +43.80% ✅ / +17.24% ✅ | +14.41% ✅ | 6132.67 | 210 |
| `funsearch` | RTLLM | Prob001_accu | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +16.60% ✅ | -13.61% ❌ / +42.74% ✅ / +20.69% ✅ | +16.60% ✅ | 9147.81 | 210 |
| `revolution` | RTLLM | Prob001_accu | ✅ Pass (75.2%) | ✅ Pass (74.8%) | +14.41% ✅ | -17.80% ❌ / +43.80% ✅ / +17.24% ✅ | +14.41% ✅ | 13121.41 | 420 |
| `eoh` | RTLLM | Prob002_adder_16bit | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 5574.72 | 210 |
| `funsearch` | RTLLM | Prob002_adder_16bit | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 9055.42 | 210 |
| `revolution` | RTLLM | Prob002_adder_16bit | ✅ Pass (89.0%) | ✅ Pass (88.6%) | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 13044.21 | 420 |
| `eoh` | RTLLM | Prob003_adder_32bit | ✅ Pass (93.3%) | ✅ Pass (92.9%) | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 6859.69 | 210 |
| `funsearch` | RTLLM | Prob003_adder_32bit | ✅ Pass (91.9%) | ✅ Pass (91.4%) | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 18679.33 | 210 |
| `revolution` | RTLLM | Prob003_adder_32bit | ✅ Pass (86.2%) | ✅ Pass (85.7%) | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 15036.64 | 420 |
| `eoh` | RTLLM | Prob004_adder_8bit | ✅ Pass (85.2%) | ✅ Pass (85.2%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 5463.10 | 210 |
| `funsearch` | RTLLM | Prob004_adder_8bit | ✅ Pass (51.4%) | ✅ Pass (47.1%) | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 8416.60 | 210 |
| `revolution` | RTLLM | Prob004_adder_8bit | ✅ Pass (84.3%) | ✅ Pass (84.3%) | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 13546.92 | 420 |
| `eoh` | RTLLM | Prob005_adder_bcd | ✅ Pass (90.5%) | ✅ Pass (90.0%) | +10.35% ✅ | +20.00% ✅ / +11.04% ✅ / N/A | +15.52% ✅ | 6372.84 | 210 |
| `funsearch` | RTLLM | Prob005_adder_bcd | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +35.97% ✅ | +8.89% ✅ / +99.02% ✅ / N/A | +53.95% ✅ | 8269.50 | 210 |
| `revolution` | RTLLM | Prob005_adder_bcd | ✅ Pass (80.5%) | ✅ Pass (80.5%) | +35.92% ✅ | +8.89% ✅ / +98.88% ✅ / N/A | +53.88% ✅ | 13344.55 | 420 |
| `eoh` | RTLLM | Prob006_adder_pipe_64bit | ✅ Pass (61.4%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7642.59 | 210 |
| `funsearch` | RTLLM | Prob006_adder_pipe_64bit | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 14101.36 | 210 |
| `revolution` | RTLLM | Prob006_adder_pipe_64bit | ✅ Pass (28.1%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 15304.73 | 420 |
| `eoh` | RTLLM | Prob007_comparator_3bit | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +7.81% ✅ | +5.88% ✅ / +17.53% ✅ / N/A | +11.71% ✅ | 5312.38 | 210 |
| `funsearch` | RTLLM | Prob007_comparator_3bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +7.94% ✅ | +5.88% ✅ / +17.94% ✅ / N/A | +11.91% ✅ | 5869.02 | 210 |
| `revolution` | RTLLM | Prob007_comparator_3bit | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +7.81% ✅ | +5.88% ✅ / +17.53% ✅ / N/A | +11.71% ✅ | 11918.40 | 420 |
| `eoh` | RTLLM | Prob008_comparator_4bit | ✅ Pass (94.8%) | ✅ Pass (94.3%) | +27.79% ✅ | +36.36% ✅ / +47.00% ✅ / N/A | +41.68% ✅ | 5814.31 | 210 |
| `funsearch` | RTLLM | Prob008_comparator_4bit | ✅ Pass (95.7%) | ✅ Pass (95.2%) | +32.05% ✅ | -3.03% ❌ / +99.17% ✅ / N/A | +48.07% ✅ | 6903.33 | 210 |
| `revolution` | RTLLM | Prob008_comparator_4bit | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +44.25% ✅ | +33.33% ✅ / +99.41% ✅ / N/A | +66.37% ✅ | 12826.60 | 420 |
| `eoh` | RTLLM | Prob009_div_16bit | ✅ Pass (91.9%) | ✅ Pass (88.1%) | +52.02% ✅ | +77.68% ✅ / +78.38% ✅ / N/A | +78.03% ✅ | 6590.39 | 210 |
| `funsearch` | RTLLM | Prob009_div_16bit | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +52.12% ✅ | +77.23% ✅ / +79.14% ✅ / N/A | +78.19% ✅ | 9391.91 | 210 |
| `revolution` | RTLLM | Prob009_div_16bit | ✅ Pass (87.1%) | ✅ Pass (86.7%) | +55.68% ✅ | +76.26% ✅ / +90.79% ✅ / N/A | +83.53% ✅ | 13484.95 | 420 |
| `eoh` | RTLLM | Prob010_radix2_div | ✅ Pass (1.9%) | ✅ Pass (1.9%) | -79.81% ❌ | -25.66% ❌ / -210.06% ❌ / -3.70% ❌ | -79.81% ❌ | 8696.37 | 210 |
| `funsearch` | RTLLM | Prob010_radix2_div | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 22488.85 | 210 |
| `revolution` | RTLLM | Prob010_radix2_div | ✅ Pass (1.9%) | ✅ Pass (1.9%) | -63.91% ❌ | -33.33% ❌ / -117.66% ❌ / -40.74% ❌ | -63.91% ❌ | 15786.25 | 420 |
| `eoh` | RTLLM | Prob011_multi_16bit | ✅ Pass (35.7%) | ✅ Pass (35.7%) | +38.13% ✅ | +10.15% ✅ / +60.28% ✅ / +43.97% ✅ | +38.13% ✅ | 7406.51 | 210 |
| `funsearch` | RTLLM | Prob011_multi_16bit | ✅ Pass (47.6%) | ✅ Pass (46.7%) | +36.26% ✅ | +9.40% ✅ / +59.72% ✅ / +39.66% ✅ | +36.26% ✅ | 13460.81 | 210 |
| `revolution` | RTLLM | Prob011_multi_16bit | ✅ Pass (51.0%) | ✅ Pass (49.5%) | +37.92% ✅ | +9.59% ✅ / +60.22% ✅ / +43.97% ✅ | +37.92% ✅ | 14209.87 | 420 |
| `eoh` | RTLLM | Prob012_multi_8bit | ✅ Pass (77.1%) | ✅ Pass (77.1%) | +31.79% ✅ | +38.93% ✅ / +56.43% ✅ / N/A | +47.68% ✅ | 5640.31 | 210 |
| `funsearch` | RTLLM | Prob012_multi_8bit | ✅ Pass (92.9%) | ✅ Pass (92.9%) | +31.79% ✅ | +38.93% ✅ / +56.43% ✅ / N/A | +47.68% ✅ | 7905.15 | 210 |
| `revolution` | RTLLM | Prob012_multi_8bit | ✅ Pass (77.6%) | ✅ Pass (77.1%) | +31.79% ✅ | +38.93% ✅ / +56.43% ✅ / N/A | +47.68% ✅ | 12954.62 | 420 |
| `eoh` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (96.2%) | ✅ Pass (47.6%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 8271.84 | 210 |
| `funsearch` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (91.4%) | ✅ Pass (48.1%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 15710.55 | 210 |
| `revolution` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (43.3%) | ✅ Pass (8.1%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 16080.84 | 420 |
| `eoh` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (54.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6525.96 | 210 |
| `funsearch` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (51.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 11793.74 | 210 |
| `revolution` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (54.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13581.68 | 420 |
| `eoh` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (9.0%) | ✅ Pass (9.0%) | +16.81% ✅ | +38.78% ✅ / +53.12% ✅ / -41.46% ❌ | +16.81% ✅ | 6692.39 | 210 |
| `funsearch` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (30.0%) | ✅ Pass (28.1%) | +24.34% ✅ | +37.96% ✅ / +59.47% ✅ / -24.39% ❌ | +24.34% ✅ | 11385.97 | 210 |
| `revolution` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (40.5%) | ✅ Pass (39.0%) | +26.49% ✅ | +25.51% ✅ / +45.43% ✅ / +8.54% ✅ | +26.49% ✅ | 14576.15 | 420 |
| `eoh` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (51.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6272.87 | 210 |
| `funsearch` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (93.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8720.26 | 210 |
| `revolution` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (81.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13319.01 | 420 |
| `eoh` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (93.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5902.29 | 210 |
| `funsearch` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (98.1%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7040.31 | 210 |
| `revolution` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (95.2%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13405.95 | 420 |
| `eoh` | RTLLM | Prob018_float_multi | ✅ Pass (47.6%) | ✅ Pass (38.6%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 8485.50 | 210 |
| `funsearch` | RTLLM | Prob018_float_multi | ✅ Pass (65.7%) | ✅ Pass (61.4%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 24397.78 | 210 |
| `revolution` | RTLLM | Prob018_float_multi | ✅ Pass (51.0%) | ✅ Pass (46.2%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 16702.85 | 420 |
| `eoh` | RTLLM | Prob019_sub_64bit | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +30.21% ✅ | +45.25% ✅ / +45.39% ✅ / N/A | +45.32% ✅ | 5364.68 | 210 |
| `funsearch` | RTLLM | Prob019_sub_64bit | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5888.24 | 210 |
| `revolution` | RTLLM | Prob019_sub_64bit | ✅ Pass (93.8%) | ✅ Pass (93.8%) | +48.23% ✅ | +45.25% ✅ / +99.44% ✅ / N/A | +72.34% ✅ | 13770.86 | 420 |
| `eoh` | RTLLM | Prob020_JC_counter | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5421.87 | 210 |
| `funsearch` | RTLLM | Prob020_JC_counter | ✅ Pass (100.0%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4719.72 | 210 |
| `revolution` | RTLLM | Prob020_JC_counter | ✅ Pass (83.3%) | ✅ Pass (82.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 12224.43 | 420 |
| `eoh` | RTLLM | Prob021_counter_12 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +33.06% ✅ | +20.45% ✅ / +78.71% ✅ / +0.00% ➖ | +33.06% ✅ | 5345.25 | 210 |
| `funsearch` | RTLLM | Prob021_counter_12 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +17.82% ✅ | +2.27% ✅ / +61.89% ✅ / -10.71% ❌ | +17.82% ✅ | 5702.70 | 210 |
| `revolution` | RTLLM | Prob021_counter_12 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +33.06% ✅ | +20.45% ✅ / +78.71% ✅ / +0.00% ➖ | +33.06% ✅ | 12347.12 | 420 |
| `eoh` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5427.28 | 210 |
| `funsearch` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4553.82 | 210 |
| `revolution` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 11887.29 | 420 |
| `eoh` | RTLLM | Prob023_up_down_counter | ✅ Pass (91.4%) | ✅ Pass (91.4%) | -4.83% ❌ | +13.13% ✅ / -22.07% ❌ / -5.56% ❌ | -4.83% ❌ | 5566.17 | 210 |
| `funsearch` | RTLLM | Prob023_up_down_counter | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +3.36% ✅ | +20.08% ✅ / -13.69% ❌ / +3.70% ✅ | +3.36% ✅ | 5353.80 | 210 |
| `revolution` | RTLLM | Prob023_up_down_counter | ✅ Pass (73.3%) | ✅ Pass (73.3%) | +21.71% ✅ | +23.55% ✅ / +15.64% ✅ / +25.93% ✅ | +21.71% ✅ | 12759.52 | 420 |
| `eoh` | RTLLM | Prob024_fsm | ✅ Pass (51.4%) | ✅ Pass (47.1%) | +66.61% ✅ | +43.48% ✅ / +70.36% ✅ / N/A | +56.92% ✅ | 6399.36 | 210 |
| `funsearch` | RTLLM | Prob024_fsm | ✅ Pass (51.9%) | ✅ Pass (50.0%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 8878.65 | 210 |
| `revolution` | RTLLM | Prob024_fsm | ✅ Pass (40.0%) | ✅ Pass (38.6%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 13513.66 | 420 |
| `eoh` | RTLLM | Prob025_sequence_detector | ✅ Pass (15.2%) | ✅ Pass (15.2%) | +22.25% ✅ | +42.11% ✅ / +29.90% ✅ / -5.26% ❌ | +22.25% ✅ | 5846.14 | 210 |
| `funsearch` | RTLLM | Prob025_sequence_detector | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 9177.93 | 210 |
| `revolution` | RTLLM | Prob025_sequence_detector | ✅ Pass (6.7%) | ✅ Pass (6.7%) | +25.24% ✅ | +31.58% ✅ / +28.35% ✅ / +15.79% ✅ | +25.24% ✅ | 12579.46 | 420 |
| `eoh` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7166.62 | 210 |
| `funsearch` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 17624.27 | 210 |
| `revolution` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 14349.08 | 420 |
| `eoh` | RTLLM | Prob027_LIFObuffer | ✅ Pass (89.0%) | ✅ Pass (88.1%) | +20.86% ✅ | +22.07% ✅ / +37.95% ✅ / +2.56% ✅ | +20.86% ✅ | 6387.22 | 210 |
| `funsearch` | RTLLM | Prob027_LIFObuffer | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +21.41% ✅ | +21.74% ✅ / +42.48% ✅ / +0.00% ➖ | +21.41% ✅ | 10389.90 | 210 |
| `revolution` | RTLLM | Prob027_LIFObuffer | ✅ Pass (90.0%) | ✅ Pass (89.0%) | +25.69% ✅ | +14.72% ✅ / +44.39% ✅ / +17.95% ✅ | +25.69% ✅ | 13208.60 | 420 |
| `eoh` | RTLLM | Prob028_LFSR | ✅ Pass (5.7%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5261.30 | 210 |
| `funsearch` | RTLLM | Prob028_LFSR | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4430.56 | 210 |
| `revolution` | RTLLM | Prob028_LFSR | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12775.47 | 420 |
| `eoh` | RTLLM | Prob029_barrel_shifter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5625.28 | 210 |
| `funsearch` | RTLLM | Prob029_barrel_shifter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8388.74 | 210 |
| `revolution` | RTLLM | Prob029_barrel_shifter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12984.46 | 420 |
| `eoh` | RTLLM | Prob030_right_shifter | ✅ Pass (98.6%) | ✅ Pass (91.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5249.33 | 210 |
| `funsearch` | RTLLM | Prob030_right_shifter | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 3530.55 | 210 |
| `revolution` | RTLLM | Prob030_right_shifter | ✅ Pass (80.5%) | ✅ Pass (62.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 11748.65 | 420 |
| `eoh` | RTLLM | Prob031_freq_div | ✅ Pass (84.8%) | ✅ Pass (62.9%) | +28.27% ✅ | +32.80% ✅ / +52.01% ✅ / N/A | +42.41% ✅ | 6964.59 | 210 |
| `funsearch` | RTLLM | Prob031_freq_div | ✅ Pass (89.5%) | ✅ Pass (40.5%) | +28.27% ✅ | +32.80% ✅ / +52.01% ✅ / N/A | +42.41% ✅ | 12113.02 | 210 |
| `revolution` | RTLLM | Prob031_freq_div | ✅ Pass (60.5%) | ✅ Pass (19.5%) | +37.21% ✅ | +12.80% ✅ / +98.82% ✅ / N/A | +55.81% ✅ | 13598.43 | 420 |
| `eoh` | RTLLM | Prob032_freq_divbyeven | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5387.90 | 210 |
| `funsearch` | RTLLM | Prob032_freq_divbyeven | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7177.06 | 210 |
| `revolution` | RTLLM | Prob032_freq_divbyeven | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 14142.79 | 420 |
| `eoh` | RTLLM | Prob033_freq_divbyfrac | ✅ Pass (1.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8056.31 | 210 |
| `funsearch` | RTLLM | Prob033_freq_divbyfrac | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 15011.03 | 210 |
| `revolution` | RTLLM | Prob033_freq_divbyfrac | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12846.90 | 420 |
| `eoh` | RTLLM | Prob034_freq_divbyodd | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6812.16 | 210 |
| `funsearch` | RTLLM | Prob034_freq_divbyodd | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 11656.73 | 210 |
| `revolution` | RTLLM | Prob034_freq_divbyodd | ✅ Pass (0.5%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12062.41 | 420 |
| `eoh` | RTLLM | Prob035_calendar | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5015.88 | 210 |
| `funsearch` | RTLLM | Prob035_calendar | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7219.42 | 210 |
| `revolution` | RTLLM | Prob035_calendar | ✅ Pass (89.5%) | ✅ Pass (31.0%) | +2.34% ✅ | +6.63% ✅ / +5.65% ✅ / -5.26% ❌ | +2.34% ✅ | 11136.60 | 420 |
| `eoh` | RTLLM | Prob036_edge_detect | ✅ Pass (93.3%) | ✅ Pass (92.9%) | +28.59% ✅ | +26.32% ✅ / +41.80% ✅ / +17.65% ✅ | +28.59% ✅ | 4972.56 | 210 |
| `funsearch` | RTLLM | Prob036_edge_detect | ✅ Pass (85.2%) | ✅ Pass (81.4%) | +28.59% ✅ | +26.32% ✅ / +41.80% ✅ / +17.65% ✅ | +28.59% ✅ | 7196.43 | 210 |
| `revolution` | RTLLM | Prob036_edge_detect | ✅ Pass (71.9%) | ✅ Pass (70.0%) | +28.59% ✅ | +26.32% ✅ / +41.80% ✅ / +17.65% ✅ | +28.59% ✅ | 10368.20 | 420 |
| `eoh` | RTLLM | Prob037_parallel2serial | ✅ Pass (52.9%) | ✅ Pass (46.7%) | +52.00% ✅ | +62.00% ✅ / +56.95% ✅ / +37.04% ✅ | +52.00% ✅ | 5824.22 | 210 |
| `funsearch` | RTLLM | Prob037_parallel2serial | ✅ Pass (38.1%) | ✅ Pass (31.4%) | +22.83% ✅ | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ | +22.83% ✅ | 11784.01 | 210 |
| `revolution` | RTLLM | Prob037_parallel2serial | ✅ Pass (30.0%) | ✅ Pass (23.8%) | +22.83% ✅ | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ | +22.83% ✅ | 12005.74 | 420 |
| `eoh` | RTLLM | Prob038_pulse_detect | ✅ Pass (14.8%) | ✅ Pass (14.8%) | +27.89% ✅ | +23.53% ✅ / +26.81% ✅ / +33.33% ✅ | +27.89% ✅ | 5235.23 | 210 |
| `funsearch` | RTLLM | Prob038_pulse_detect | ✅ Pass (3.8%) | ✅ Pass (3.3%) | +27.89% ✅ | +23.53% ✅ / +26.81% ✅ / +33.33% ✅ | +27.89% ✅ | 8439.59 | 210 |
| `revolution` | RTLLM | Prob038_pulse_detect | ✅ Pass (6.7%) | ✅ Pass (6.7%) | +30.82% ✅ | +23.53% ✅ / +26.09% ✅ / +42.86% ✅ | +30.82% ✅ | 10737.90 | 420 |
| `eoh` | RTLLM | Prob039_serial2parallel | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 17685.18 | 210 |
| `funsearch` | RTLLM | Prob039_serial2parallel | ✅ Pass (2.9%) | ✅ Pass (2.9%) | +8.00% ✅ | -8.33% ❌ / +28.99% ✅ / +3.33% ✅ | +8.00% ✅ | 22092.93 | 210 |
| `revolution` | RTLLM | Prob039_serial2parallel | ✅ Pass (0.5%) | ✅ Pass (0.5%) | +4.84% ✅ | +29.17% ✅ / -7.98% ❌ / -6.67% ❌ | +4.84% ✅ | 23155.47 | 420 |
| `eoh` | RTLLM | Prob040_synchronizer | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 5340.39 | 210 |
| `funsearch` | RTLLM | Prob040_synchronizer | ✅ Pass (99.5%) | ✅ Pass (98.6%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 8531.63 | 210 |
| `revolution` | RTLLM | Prob040_synchronizer | ✅ Pass (86.7%) | ✅ Pass (84.3%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 10984.63 | 420 |
| `eoh` | RTLLM | Prob041_traffic_light | ✅ Pass (80.0%) | ✅ Pass (79.5%) | +47.36% ✅ | +42.94% ✅ / +99.15% ✅ / N/A | +71.04% ✅ | 5444.04 | 210 |
| `funsearch` | RTLLM | Prob041_traffic_light | ✅ Pass (72.4%) | ✅ Pass (72.4%) | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 12049.41 | 210 |
| `revolution` | RTLLM | Prob041_traffic_light | ✅ Pass (80.5%) | ✅ Pass (80.0%) | +47.36% ✅ | +42.94% ✅ / +99.15% ✅ / N/A | +71.04% ✅ | 11417.87 | 420 |
| `eoh` | RTLLM | Prob042_width_8to16 | ✅ Pass (3.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5742.63 | 210 |
| `funsearch` | RTLLM | Prob042_width_8to16 | ✅ Pass (12.4%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12752.61 | 210 |
| `revolution` | RTLLM | Prob042_width_8to16 | ✅ Pass (16.2%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12583.07 | 420 |
| `eoh` | RTLLM | Prob043_RAM | ✅ Pass (91.9%) | ✅ Pass (90.5%) | +44.45% ✅ | +34.47% ✅ / +63.39% ✅ / +35.48% ✅ | +44.45% ✅ | 5269.20 | 210 |
| `funsearch` | RTLLM | Prob043_RAM | ✅ Pass (97.6%) | ✅ Pass (97.1%) | +44.45% ✅ | +34.47% ✅ / +63.39% ✅ / +35.48% ✅ | +44.45% ✅ | 8728.10 | 210 |
| `revolution` | RTLLM | Prob043_RAM | ✅ Pass (86.7%) | ✅ Pass (84.3%) | +44.45% ✅ | +34.47% ✅ / +63.39% ✅ / +35.48% ✅ | +44.45% ✅ | 10480.54 | 420 |
| `eoh` | RTLLM | Prob044_ROM | ✅ Pass (76.2%) | ✅ Pass (76.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4653.03 | 210 |
| `funsearch` | RTLLM | Prob044_ROM | ✅ Pass (76.2%) | ✅ Pass (75.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5948.79 | 210 |
| `revolution` | RTLLM | Prob044_ROM | ✅ Pass (54.8%) | ✅ Pass (52.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 9922.00 | 420 |
| `eoh` | RTLLM | Prob045_alu | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6009.30 | 210 |
| `funsearch` | RTLLM | Prob045_alu | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 15804.67 | 210 |
| `revolution` | RTLLM | Prob045_alu | ✅ Pass (78.6%) | ✅ Pass (78.6%) | +39.91% ✅ | +20.58% ✅ / +99.14% ✅ / N/A | +59.86% ✅ | 13085.86 | 420 |
| `eoh` | RTLLM | Prob046_clkgenerator | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4394.31 | 210 |
| `funsearch` | RTLLM | Prob046_clkgenerator | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7272.76 | 210 |
| `revolution` | RTLLM | Prob046_clkgenerator | ✅ Pass (5.7%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 10439.93 | 420 |
| `eoh` | RTLLM | Prob047_instr_reg | ✅ Pass (82.4%) | ✅ Pass (82.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4802.89 | 210 |
| `funsearch` | RTLLM | Prob047_instr_reg | ✅ Pass (96.2%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6605.27 | 210 |
| `revolution` | RTLLM | Prob047_instr_reg | ✅ Pass (59.0%) | ✅ Pass (59.0%) | +5.68% ✅ | +0.00% ➖ / +17.05% ✅ / +0.00% ➖ | +5.68% ✅ | 10045.77 | 420 |
| `eoh` | RTLLM | Prob048_pe | ✅ Pass (81.9%) | ✅ Pass (81.9%) | +14.74% ✅ | -3.16% ❌ / +0.89% ✅ / +46.50% ✅ | +14.74% ✅ | 5046.91 | 210 |
| `funsearch` | RTLLM | Prob048_pe | ✅ Pass (64.3%) | ✅ Pass (64.3%) | +32.56% ✅ | +0.84% ✅ / +60.53% ✅ / +100.00% ✅ | +53.79% ✅ | 7010.53 | 210 |
| `revolution` | RTLLM | Prob048_pe | ✅ Pass (40.5%) | ✅ Pass (40.5%) | +2.24% ✅ | +1.56% ✅ / +6.43% ✅ / -1.27% ❌ | +2.24% ✅ | 10154.40 | 420 |
| `eoh` | RTLLM | Prob049_signal_generator | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4679.99 | 210 |
| `funsearch` | RTLLM | Prob049_signal_generator | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7163.49 | 210 |
| `revolution` | RTLLM | Prob049_signal_generator | ✅ Pass (40.0%) | ✅ Pass (40.0%) | +26.03% ✅ | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ | +26.03% ✅ | 10178.51 | 420 |
| `eoh` | RTLLM | Prob050_square_wave | ✅ Pass (97.1%) | ✅ Pass (96.7%) | +30.46% ✅ | +22.69% ✅ / +68.70% ✅ / +0.00% ➖ | +30.46% ✅ | 4559.58 | 210 |
| `funsearch` | RTLLM | Prob050_square_wave | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +31.14% ✅ | +9.24% ✅ / +71.01% ✅ / +13.16% ✅ | +31.14% ✅ | 6601.08 | 210 |
| `revolution` | RTLLM | Prob050_square_wave | ✅ Pass (92.4%) | ✅ Pass (92.4%) | +23.24% ✅ | +7.56% ✅ / +64.78% ✅ / -2.63% ❌ | +23.24% ✅ | 10043.94 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob001_zero | ✅ Pass (74.8%) | ✅ Pass (72.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3975.44 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob001_zero | ✅ Pass (78.6%) | ✅ Pass (78.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3632.31 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob001_zero | ✅ Pass (79.5%) | ✅ Pass (77.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 8689.00 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob002_m2014_q4i | ✅ Pass (87.6%) | ✅ Pass (83.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4105.87 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob002_m2014_q4i | ✅ Pass (90.5%) | ✅ Pass (90.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3329.18 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob002_m2014_q4i | ✅ Pass (86.7%) | ✅ Pass (84.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 8729.31 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob003_step_one | ✅ Pass (75.2%) | ✅ Pass (73.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3936.79 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob003_step_one | ✅ Pass (79.0%) | ✅ Pass (77.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3459.99 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob003_step_one | ✅ Pass (78.6%) | ✅ Pass (74.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 8605.21 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob004_vector2 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4142.89 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob004_vector2 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3532.97 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob004_vector2 | ✅ Pass (91.0%) | ✅ Pass (91.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 9438.96 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob005_notgate | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3857.04 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob005_notgate | ✅ Pass (91.9%) | ✅ Pass (91.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2690.34 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob005_notgate | ✅ Pass (91.4%) | ✅ Pass (89.5%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 9437.92 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob006_vectorr | ✅ Pass (73.8%) | ✅ Pass (73.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4140.37 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob006_vectorr | ✅ Pass (79.5%) | ✅ Pass (79.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4239.18 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob006_vectorr | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 9600.91 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob007_wire | ✅ Pass (90.0%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3839.35 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob007_wire | ✅ Pass (87.1%) | ✅ Pass (87.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3019.09 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob007_wire | ✅ Pass (91.9%) | ✅ Pass (91.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 8591.99 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob008_m2014_q4h | ✅ Pass (92.9%) | ✅ Pass (92.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3799.51 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob008_m2014_q4h | ✅ Pass (97.1%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2627.18 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob008_m2014_q4h | ✅ Pass (94.3%) | ✅ Pass (92.4%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 8881.22 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob009_popcount3 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3955.26 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob009_popcount3 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4770.55 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob009_popcount3 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +24.48% ✅ | -25.00% ❌ / +98.43% ✅ / N/A | +36.71% ✅ | 9145.68 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob010_mt2015_q4a | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3687.34 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob010_mt2015_q4a | ✅ Pass (98.1%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2987.98 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob010_mt2015_q4a | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 9225.00 | 421 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob011_norgate | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3567.38 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob011_norgate | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2698.66 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob011_norgate | ✅ Pass (94.3%) | ✅ Pass (93.8%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 8602.48 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob012_xnorgate | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3532.88 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob012_xnorgate | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2671.94 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob012_xnorgate | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 8769.07 | 421 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob013_m2014_q4e | ✅ Pass (98.1%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3473.25 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob013_m2014_q4e | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2706.43 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob013_m2014_q4e | ✅ Pass (91.4%) | ✅ Pass (90.0%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 8698.13 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob014_andgate | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3432.56 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob014_andgate | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2690.22 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob014_andgate | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +32.96% ✅ | +0.00% ➖ / +98.89% ✅ / N/A | +49.45% ✅ | 8352.68 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob015_vector1 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3261.21 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob015_vector1 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2869.36 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob015_vector1 | ✅ Pass (96.7%) | ✅ Pass (95.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 8172.97 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob016_m2014_q4j | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +37.00% ✅ | +12.00% ✅ / +98.99% ✅ / N/A | +55.50% ✅ | 3563.30 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob016_m2014_q4j | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +37.00% ✅ | +12.00% ✅ / +98.99% ✅ / N/A | +55.50% ✅ | 5284.89 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob016_m2014_q4j | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +38.34% ✅ | +16.00% ✅ / +99.03% ✅ / N/A | +57.52% ✅ | 8876.78 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob017_mux2to1v | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 3497.76 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob017_mux2to1v | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3324.61 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob017_mux2to1v | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 8437.68 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob018_mux256to1 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +19.40% ✅ | +16.86% ✅ / +41.35% ✅ / N/A | +29.10% ✅ | 4507.07 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob018_mux256to1 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +19.40% ✅ | +16.86% ✅ / +41.35% ✅ / N/A | +29.10% ✅ | 4922.61 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob018_mux256to1 | ✅ Pass (95.2%) | ✅ Pass (94.8%) | +33.31% ✅ | +0.77% ✅ / +99.18% ✅ / N/A | +49.97% ✅ | 10170.83 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob019_m2014_q4f | ✅ Pass (79.0%) | ✅ Pass (79.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3392.76 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob019_m2014_q4f | ✅ Pass (80.5%) | ✅ Pass (80.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3487.93 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob019_m2014_q4f | ✅ Pass (88.1%) | ✅ Pass (87.6%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 8099.78 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob020_mt2015_eq2 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3408.35 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob020_mt2015_eq2 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3406.35 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob020_mt2015_eq2 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 8042.02 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob021_mux256to1v | ✅ Pass (65.7%) | ✅ Pass (65.2%) | +30.49% ✅ | +27.35% ✅ / +64.12% ✅ / N/A | +45.74% ✅ | 4464.55 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob021_mux256to1v | ✅ Pass (47.6%) | ✅ Pass (47.6%) | +30.49% ✅ | +27.35% ✅ / +64.12% ✅ / N/A | +45.74% ✅ | 4833.47 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob021_mux256to1v | ✅ Pass (75.2%) | ✅ Pass (75.2%) | +32.77% ✅ | +37.79% ✅ / +60.51% ✅ / N/A | +49.15% ✅ | 10283.20 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob022_mux2to1 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3386.46 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob022_mux2to1 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3044.15 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob022_mux2to1 | ✅ Pass (93.3%) | ✅ Pass (92.9%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 7919.78 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob023_vector100r | ✅ Pass (86.7%) | ✅ Pass (86.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4053.03 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob023_vector100r | ✅ Pass (81.0%) | ✅ Pass (81.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5756.69 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob023_vector100r | ✅ Pass (88.6%) | ✅ Pass (88.6%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 8613.88 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob024_hadd | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3334.65 | 211 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob024_hadd | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2906.07 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob024_hadd | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.46% ✅ | 7892.50 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob025_reduction | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 3394.57 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob025_reduction | ✅ Pass (94.8%) | ✅ Pass (94.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3544.72 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob025_reduction | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 8900.74 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob026_alwaysblock1 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3324.87 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob026_alwaysblock1 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4059.65 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob026_alwaysblock1 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 7994.31 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob027_fadd | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 3435.88 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob027_fadd | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3250.30 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob027_fadd | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 8242.48 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob028_m2014_q4a | ✅ Pass (95.7%) | ✅ Pass (6.2%) | +20.81% ✅ | +33.33% ✅ / +29.09% ✅ / N/A | +31.21% ✅ | 3498.83 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob028_m2014_q4a | ✅ Pass (99.0%) | ✅ Pass (1.0%) | +20.81% ✅ | +33.33% ✅ / +29.09% ✅ / N/A | +31.21% ✅ | 3911.31 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob028_m2014_q4a | ✅ Pass (89.0%) | ✅ Pass (3.3%) | +20.81% ✅ | +33.33% ✅ / +29.09% ✅ / N/A | +31.21% ✅ | 8471.16 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob029_m2014_q4g | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3524.96 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob029_m2014_q4g | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4860.78 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob029_m2014_q4g | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 8503.70 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob030_popcount255 | ✅ Pass (90.0%) | ✅ Pass (89.5%) | +1.56% ✅ | +3.29% ✅ / +1.40% ✅ / N/A | +2.34% ✅ | 5745.82 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob030_popcount255 | ✅ Pass (73.8%) | ✅ Pass (73.3%) | +1.56% ✅ | +3.29% ✅ / +1.40% ✅ / N/A | +2.34% ✅ | 9797.17 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob030_popcount255 | ✅ Pass (83.3%) | ✅ Pass (83.3%) | +28.51% ✅ | +0.00% ➖ / +85.53% ✅ / N/A | +42.77% ✅ | 11440.61 | 416 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob031_dff | ✅ Pass (93.3%) | ✅ Pass (93.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3245.98 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob031_dff | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3275.89 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob031_dff | ✅ Pass (91.9%) | ✅ Pass (87.6%) | +33.25% ✅ | +0.00% ➖ / +99.74% ✅ / N/A | +49.87% ✅ | 8028.18 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob032_vector0 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3286.79 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob032_vector0 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3480.94 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob032_vector0 | ✅ Pass (98.1%) | ✅ Pass (97.1%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 8229.57 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob033_ece241_2014_q1c | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +21.85% ✅ | +28.85% ✅ / +36.71% ✅ / N/A | +32.78% ✅ | 3802.07 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob033_ece241_2014_q1c | ✅ Pass (85.2%) | ✅ Pass (85.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 6394.30 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob033_ece241_2014_q1c | ✅ Pass (81.0%) | ✅ Pass (81.0%) | +38.80% ✅ | +17.31% ✅ / +99.10% ✅ / N/A | +58.20% ✅ | 9606.27 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob034_dff8 | ✅ Pass (64.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 3560.31 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob034_dff8 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4088.72 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob034_dff8 | ✅ Pass (34.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8075.77 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob035_count1to10 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +5.91% ✅ | +17.07% ✅ / +8.35% ✅ / -7.69% ❌ | +5.91% ✅ | 3695.58 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob035_count1to10 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +4.67% ✅ | +0.00% ➖ / +14.00% ✅ / +0.00% ➖ | +4.67% ✅ | 5709.22 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob035_count1to10 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +7.29% ✅ | +2.44% ✅ / +15.58% ✅ / +3.85% ✅ | +7.29% ✅ | 8934.75 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob036_ringer | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3693.11 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob036_ringer | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3421.05 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob036_ringer | ✅ Pass (97.1%) | ✅ Pass (96.7%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 8445.56 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob037_review2015_count1k | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +0.94% ✅ | -8.60% ❌ / +0.91% ✅ / +10.53% ✅ | +0.94% ✅ | 3748.29 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob037_review2015_count1k | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4544.52 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob037_review2015_count1k | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +0.94% ✅ | -8.60% ❌ / +0.91% ✅ / +10.53% ✅ | +0.94% ✅ | 9936.66 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob038_count15 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +1.15% ✅ | -3.33% ❌ / -1.20% ❌ / +8.00% ✅ | +1.15% ✅ | 3561.59 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob038_count15 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 3607.01 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob038_count15 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +1.15% ✅ | -3.33% ❌ / -1.20% ❌ / +8.00% ✅ | +1.15% ✅ | 8622.21 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob039_always_if | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3498.31 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob039_always_if | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3630.39 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob039_always_if | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 8201.05 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob040_count10 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +7.36% ✅ | +17.95% ✅ / +11.83% ✅ / -7.69% ❌ | +7.36% ✅ | 3659.60 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob040_count10 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +0.01% ✅ | +2.56% ✅ / -10.22% ❌ / +7.69% ✅ | +0.01% ✅ | 4617.09 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob040_count10 | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +7.36% ✅ | +17.95% ✅ / +11.83% ✅ / -7.69% ❌ | +7.36% ✅ | 8885.38 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob041_dff8r | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +29.68% ✅ | -10.53% ❌ / +99.57% ✅ / N/A | +44.52% ✅ | 3393.40 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob041_dff8r | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +33.20% ✅ | +0.00% ➖ / +99.61% ✅ / N/A | +49.81% ✅ | 3728.96 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob041_dff8r | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +33.20% ✅ | +0.00% ➖ / +99.61% ✅ / N/A | +49.81% ✅ | 8212.24 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob042_vector4 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 3293.54 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob042_vector4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3375.67 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob042_vector4 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 7902.12 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob043_vector5 | ✅ Pass (85.7%) | ✅ Pass (85.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4766.65 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob043_vector5 | ✅ Pass (83.8%) | ✅ Pass (83.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 8341.12 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob043_vector5 | ✅ Pass (82.9%) | ✅ Pass (82.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 9958.64 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob044_vectorgates | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3678.43 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob044_vectorgates | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3593.13 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob044_vectorgates | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.96% ✅ | +0.00% ➖ / +98.88% ✅ / N/A | +49.44% ✅ | 8406.27 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob045_edgedetect2 | ✅ Pass (34.3%) | ✅ Pass (31.9%) | +12.40% ✅ | +0.00% ➖ / +7.80% ✅ / +29.41% ✅ | +12.40% ✅ | 4004.96 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob045_edgedetect2 | ✅ Pass (72.4%) | ✅ Pass (65.7%) | +12.40% ✅ | +0.00% ➖ / +7.80% ✅ / +29.41% ✅ | +12.40% ✅ | 5716.46 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob045_edgedetect2 | ✅ Pass (37.6%) | ✅ Pass (35.7%) | +12.40% ✅ | +0.00% ➖ / +7.80% ✅ / +29.41% ✅ | +12.40% ✅ | 8952.68 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob046_dff8p | ✅ Pass (96.2%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3708.62 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob046_dff8p | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3733.91 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob046_dff8p | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +33.24% ✅ | +0.00% ➖ / +99.71% ✅ / N/A | +49.85% ✅ | 8550.71 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob047_dff8ar | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +33.26% ✅ | +0.00% ➖ / +99.77% ✅ / N/A | +49.89% ✅ | 3689.97 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob047_dff8ar | ✅ Pass (99.0%) | ✅ Pass (98.1%) | +28.58% ✅ | -13.95% ❌ / +99.71% ✅ / N/A | +42.88% ✅ | 4034.88 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob047_dff8ar | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +33.26% ✅ | +0.00% ➖ / +99.77% ✅ / N/A | +49.89% ✅ | 8340.31 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob048_m2014_q4c | ✅ Pass (91.9%) | ✅ Pass (91.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3571.89 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob048_m2014_q4c | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2915.08 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob048_m2014_q4c | ✅ Pass (88.6%) | ✅ Pass (88.6%) | +33.23% ✅ | +0.00% ➖ / +99.68% ✅ / N/A | +49.84% ✅ | 8517.67 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob049_m2014_q4b | ✅ Pass (91.4%) | ✅ Pass (88.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3694.42 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob049_m2014_q4b | ✅ Pass (98.6%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3586.24 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob049_m2014_q4b | ✅ Pass (85.2%) | ✅ Pass (84.3%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.88% ✅ | 8695.51 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob050_kmap1 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3749.62 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob050_kmap1 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3518.61 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob050_kmap1 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.96% ✅ | +0.00% ➖ / +98.87% ✅ / N/A | +49.44% ✅ | 8434.63 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob051_gates4 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3835.13 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob051_gates4 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3556.03 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob051_gates4 | ✅ Pass (97.6%) | ✅ Pass (96.7%) | +32.98% ✅ | +0.00% ➖ / +98.95% ✅ / N/A | +49.47% ✅ | 8763.08 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob052_gates100 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +24.56% ✅ | +42.66% ✅ / +31.02% ✅ / N/A | +36.84% ✅ | 4255.29 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob052_gates100 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +24.56% ✅ | +42.66% ✅ / +31.02% ✅ / N/A | +36.84% ✅ | 4030.17 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob052_gates100 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +42.10% ✅ | +27.54% ✅ / +98.77% ✅ / N/A | +63.15% ✅ | 9696.97 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob053_m2014_q4d | ✅ Pass (89.5%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 3510.26 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob053_m2014_q4d | ✅ Pass (11.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4044.70 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob053_m2014_q4d | ✅ Pass (48.6%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8375.18 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob054_edgedetect | ✅ Pass (60.5%) | ✅ Pass (56.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4436.29 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob054_edgedetect | ✅ Pass (78.6%) | ✅ Pass (69.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5504.10 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob054_edgedetect | ✅ Pass (64.3%) | ✅ Pass (58.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 8971.91 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob055_conditional | ✅ Pass (99.5%) | ✅ Pass (99.0%) | +18.19% ✅ | +19.75% ✅ / +34.83% ✅ / N/A | +27.29% ✅ | 4073.39 | 211 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob055_conditional | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +23.59% ✅ | +23.87% ✅ / +46.90% ✅ / N/A | +35.38% ✅ | 5181.52 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob055_conditional | ✅ Pass (96.7%) | ✅ Pass (96.2%) | +40.48% ✅ | +22.22% ✅ / +99.22% ✅ / N/A | +60.72% ✅ | 9077.45 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob056_ece241_2013_q7 | ✅ Pass (98.6%) | ✅ Pass (49.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4461.04 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob056_ece241_2013_q7 | ✅ Pass (99.0%) | ✅ Pass (41.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5622.56 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob056_ece241_2013_q7 | ✅ Pass (92.4%) | ✅ Pass (39.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 9344.16 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob057_kmap2 | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +25.20% ✅ | +33.33% ✅ / +42.26% ✅ / N/A | +37.80% ✅ | 8413.21 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob057_kmap2 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +25.20% ✅ | +33.33% ✅ / +42.26% ✅ / N/A | +37.80% ✅ | 16704.08 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob057_kmap2 | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +25.20% ✅ | +33.33% ✅ / +42.26% ✅ / N/A | +37.80% ✅ | 13232.20 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob058_alwaysblock2 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3902.17 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob058_alwaysblock2 | ✅ Pass (94.3%) | ✅ Pass (94.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4580.28 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob058_alwaysblock2 | ✅ Pass (79.5%) | ✅ Pass (79.5%) | +33.16% ✅ | +0.00% ➖ / +99.49% ✅ / N/A | +49.74% ✅ | 8552.78 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob059_wire4 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3614.86 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob059_wire4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3073.00 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob059_wire4 | ✅ Pass (90.0%) | ✅ Pass (89.5%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 8378.99 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob060_m2014_q4k | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 3977.04 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob060_m2014_q4k | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4078.08 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob060_m2014_q4k | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 8767.69 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob061_2014_q4a | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 3747.79 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob061_2014_q4a | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 3812.01 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob061_2014_q4a | ✅ Pass (88.6%) | ✅ Pass (88.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 8755.16 | 421 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob062_bugs_mux2 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4039.51 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob062_bugs_mux2 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 3089.81 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob062_bugs_mux2 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 9461.81 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob063_review2015_shiftcount | ✅ Pass (63.3%) | ✅ Pass (62.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4141.99 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob063_review2015_shiftcount | ✅ Pass (85.2%) | ✅ Pass (85.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4959.91 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob063_review2015_shiftcount | ✅ Pass (78.1%) | ✅ Pass (77.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 9322.29 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob064_vector3 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4241.18 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob064_vector3 | ✅ Pass (90.5%) | ✅ Pass (90.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4922.76 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob064_vector3 | ✅ Pass (89.0%) | ✅ Pass (89.0%) | +32.96% ✅ | +0.00% ➖ / +98.89% ✅ / N/A | +49.45% ✅ | 9332.94 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob065_7420 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3801.86 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob065_7420 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4123.29 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob065_7420 | ✅ Pass (89.5%) | ✅ Pass (89.5%) | +32.95% ✅ | +0.00% ➖ / +98.86% ✅ / N/A | +49.43% ✅ | 8928.10 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob066_edgecapture | ✅ Pass (48.6%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4727.24 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob066_edgecapture | ✅ Pass (28.6%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6056.34 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob066_edgecapture | ✅ Pass (17.1%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 9852.62 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob067_countslow | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +10.67% ✅ | +12.77% ✅ / +5.90% ✅ / +13.33% ✅ | +10.67% ✅ | 4163.02 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob067_countslow | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +4.25% ✅ | +0.00% ➖ / -7.24% ❌ / +20.00% ✅ | +4.25% ✅ | 4781.79 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob067_countslow | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +11.27% ✅ | +19.15% ✅ / +1.34% ✅ / +13.33% ✅ | +11.27% ✅ | 9085.37 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob068_countbcd | ✅ Pass (69.0%) | ✅ Pass (60.5%) | +8.92% ✅ | +0.56% ✅ / +16.44% ✅ / +9.76% ✅ | +8.92% ✅ | 5808.13 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob068_countbcd | ✅ Pass (86.7%) | ✅ Pass (80.0%) | +8.92% ✅ | +0.56% ✅ / +16.44% ✅ / +9.76% ✅ | +8.92% ✅ | 11540.48 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob068_countbcd | ✅ Pass (67.6%) | ✅ Pass (62.4%) | +8.79% ✅ | -3.33% ❌ / +15.07% ✅ / +14.63% ✅ | +8.79% ✅ | 12475.65 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob069_truthtable1 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 4554.14 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob069_truthtable1 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4739.48 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob069_truthtable1 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 9158.76 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob070_ece241_2013_q2 | ✅ Pass (90.0%) | ✅ Pass (90.0%) | +2.06% ✅ | +0.00% ➖ / +6.19% ✅ / N/A | +3.09% ✅ | 5835.48 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob070_ece241_2013_q2 | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +2.06% ✅ | +0.00% ➖ / +6.19% ✅ / N/A | +3.09% ✅ | 9401.24 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob070_ece241_2013_q2 | ✅ Pass (83.8%) | ✅ Pass (83.3%) | +33.00% ✅ | +0.00% ➖ / +98.99% ✅ / N/A | +49.49% ✅ | 12861.00 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob071_always_casez | ✅ Pass (90.5%) | ✅ Pass (83.3%) | +6.81% ✅ | +0.00% ➖ / +20.43% ✅ / N/A | +10.22% ✅ | 4563.76 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob071_always_casez | ✅ Pass (93.3%) | ✅ Pass (85.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 7659.98 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob071_always_casez | ✅ Pass (93.8%) | ✅ Pass (91.9%) | +35.02% ✅ | +5.88% ✅ / +99.17% ✅ / N/A | +52.53% ✅ | 9975.93 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob072_thermostat | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +0.22% ✅ | +0.00% ➖ / +0.65% ✅ / N/A | +0.32% ✅ | 4135.01 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob072_thermostat | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +0.22% ✅ | +0.00% ➖ / +0.65% ✅ / N/A | +0.32% ✅ | 4509.40 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob072_thermostat | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 9224.30 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob073_dff16e | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4187.76 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob073_dff16e | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4902.08 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob073_dff16e | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 9048.54 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob074_ece241_2014_q4 | ✅ Pass (48.6%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6099.21 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob074_ece241_2014_q4 | ✅ Pass (51.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7050.88 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob074_ece241_2014_q4 | ✅ Pass (52.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 10145.38 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob075_counter_2bc | ✅ Pass (99.5%) | ✅ Pass (99.0%) | +36.08% ✅ | +33.33% ✅ / +54.90% ✅ / +20.00% ✅ | +36.08% ✅ | 4616.53 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob075_counter_2bc | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +36.08% ✅ | +33.33% ✅ / +54.90% ✅ / +20.00% ✅ | +36.08% ✅ | 5743.21 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob075_counter_2bc | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +34.74% ✅ | +33.33% ✅ / +54.90% ✅ / +16.00% ✅ | +34.74% ✅ | 9584.84 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob076_always_case | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +2.53% ✅ | +11.36% ✅ / -3.78% ❌ / N/A | +3.79% ✅ | 4496.21 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob076_always_case | ✅ Pass (91.0%) | ✅ Pass (91.0%) | +2.53% ✅ | +11.36% ✅ / -3.78% ❌ / N/A | +3.79% ✅ | 6007.56 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob076_always_case | ✅ Pass (93.8%) | ✅ Pass (93.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 9397.83 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob077_wire_decl | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4266.93 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob077_wire_decl | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3735.43 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob077_wire_decl | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 8995.67 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob078_dualedge | ✅ Pass (80.5%) | ✅ Pass (72.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5305.42 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob078_dualedge | ✅ Pass (95.2%) | ✅ Pass (91.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 6773.36 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob078_dualedge | ✅ Pass (81.0%) | ✅ Pass (69.0%) | +33.27% ✅ | +0.00% ➖ / +99.80% ✅ / N/A | +49.90% ✅ | 10775.30 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob079_fsm3onehot | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +23.77% ✅ | +25.00% ✅ / +46.31% ✅ / N/A | +35.65% ✅ | 5427.51 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob079_fsm3onehot | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +23.77% ✅ | +25.00% ✅ / +46.31% ✅ / N/A | +35.65% ✅ | 7536.28 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob079_fsm3onehot | ✅ Pass (90.0%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 10304.23 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob080_timer | ✅ Pass (92.4%) | ✅ Pass (92.4%) | +3.64% ✅ | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | +3.64% ✅ | 4745.35 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob080_timer | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +3.64% ✅ | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | +3.64% ✅ | 5621.39 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob080_timer | ✅ Pass (61.9%) | ✅ Pass (61.9%) | +3.64% ✅ | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | +3.64% ✅ | 10432.29 | 421 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob081_7458 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4596.39 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob081_7458 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4494.72 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob081_7458 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.46% ✅ | 9711.99 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob082_lfsr32 | ✅ Pass (81.9%) | ✅ Pass (81.9%) | +4.00% ✅ | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | +4.00% ✅ | 7547.47 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob082_lfsr32 | ✅ Pass (92.4%) | ✅ Pass (92.4%) | +4.00% ✅ | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | +4.00% ✅ | 9099.32 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob082_lfsr32 | ✅ Pass (72.9%) | ✅ Pass (72.9%) | +4.00% ✅ | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | +4.00% ✅ | 13133.09 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob083_mt2015_q4b | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4160.65 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob083_mt2015_q4b | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3247.78 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob083_mt2015_q4b | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 9649.76 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob084_ece241_2013_q12 | ✅ Pass (90.5%) | ✅ Pass (88.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4974.12 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob084_ece241_2013_q12 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6718.18 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob084_ece241_2013_q12 | ✅ Pass (78.1%) | ✅ Pass (78.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 10419.32 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob085_shift4 | ✅ Pass (99.5%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4482.55 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob085_shift4 | ✅ Pass (97.1%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4473.30 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob085_shift4 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 10063.54 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob086_lfsr5 | ✅ Pass (89.5%) | ✅ Pass (89.5%) | +5.28% ✅ | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | +5.28% ✅ | 5055.37 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob086_lfsr5 | ✅ Pass (92.9%) | ✅ Pass (92.9%) | +5.28% ✅ | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | +5.28% ✅ | 6499.55 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob086_lfsr5 | ✅ Pass (85.2%) | ✅ Pass (85.2%) | +5.28% ✅ | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | +5.28% ✅ | 11320.12 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob087_gates | ✅ Pass (96.7%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4786.32 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob087_gates | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4674.27 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob087_gates | ✅ Pass (90.5%) | ✅ Pass (90.5%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 10068.45 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob088_ece241_2014_q5b | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +4.94% ✅ | +10.00% ✅ / +4.81% ✅ / +0.00% ➖ | +4.94% ✅ | 5261.77 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob088_ece241_2014_q5b | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +2.65% ✅ | +10.00% ✅ / -2.06% ❌ / +0.00% ➖ | +2.65% ✅ | 5926.28 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob088_ece241_2014_q5b | ✅ Pass (93.8%) | ✅ Pass (93.8%) | +2.65% ✅ | +10.00% ✅ / -2.06% ❌ / +0.00% ➖ | +2.65% ✅ | 10284.61 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob089_ece241_2014_q5a | ✅ Pass (52.4%) | ✅ Pass (52.4%) | +45.93% ✅ | +39.13% ✅ / +66.83% ✅ / +31.82% ✅ | +45.93% ✅ | 5522.03 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob089_ece241_2014_q5a | ✅ Pass (83.8%) | ✅ Pass (83.8%) | +41.25% ✅ | +34.78% ✅ / +66.24% ✅ / +22.73% ✅ | +41.25% ✅ | 8004.96 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob089_ece241_2014_q5a | ✅ Pass (85.7%) | ✅ Pass (85.7%) | +41.25% ✅ | +34.78% ✅ / +66.24% ✅ / +22.73% ✅ | +41.25% ✅ | 11099.25 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob090_circuit1 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4304.67 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob090_circuit1 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2425.87 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob090_circuit1 | ✅ Pass (96.2%) | ✅ Pass (95.7%) | +32.96% ✅ | +0.00% ➖ / +98.89% ✅ / N/A | +49.45% ✅ | 9248.41 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob091_2012_q2b | ✅ Pass (94.8%) | ✅ Pass (94.3%) | +16.19% ✅ | +25.00% ✅ / +23.56% ✅ / N/A | +24.28% ✅ | 5247.68 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob091_2012_q2b | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +16.19% ✅ | +25.00% ✅ / +23.56% ✅ / N/A | +24.28% ✅ | 7195.81 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob091_2012_q2b | ✅ Pass (91.4%) | ✅ Pass (91.4%) | +32.94% ✅ | +0.00% ➖ / +98.83% ✅ / N/A | +49.42% ✅ | 11181.14 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob092_gatesv100 | ✅ Pass (55.7%) | ✅ Pass (55.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5446.85 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob092_gatesv100 | ✅ Pass (71.4%) | ✅ Pass (71.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 7838.32 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob092_gatesv100 | ✅ Pass (61.9%) | ✅ Pass (61.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 11120.76 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob093_ece241_2014_q3 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6656.46 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob093_ece241_2014_q3 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 11232.32 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob093_ece241_2014_q3 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13384.00 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob094_gatesv | ✅ Pass (68.1%) | ✅ Pass (68.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5241.61 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob094_gatesv | ✅ Pass (85.7%) | ✅ Pass (85.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 7283.50 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob094_gatesv | ✅ Pass (80.5%) | ✅ Pass (80.5%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 11294.97 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob095_review2015_fsmshift | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6079.30 | 211 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob095_review2015_fsmshift | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 10070.57 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob095_review2015_fsmshift | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 11184.61 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob096_review2015_fsmseq | ✅ Pass (76.7%) | ✅ Pass (76.7%) | +15.82% ✅ | +18.18% ✅ / +24.02% ✅ / +5.26% ✅ | +15.82% ✅ | 5500.83 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob096_review2015_fsmseq | ✅ Pass (74.8%) | ✅ Pass (74.8%) | +15.82% ✅ | +18.18% ✅ / +24.02% ✅ / +5.26% ✅ | +15.82% ✅ | 8958.34 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob096_review2015_fsmseq | ✅ Pass (61.4%) | ✅ Pass (61.0%) | +15.82% ✅ | +18.18% ✅ / +24.02% ✅ / +5.26% ✅ | +15.82% ✅ | 11021.05 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob097_mux9to1v | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +10.25% ✅ | +15.99% ✅ / +14.75% ✅ / N/A | +15.37% ✅ | 4895.59 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob097_mux9to1v | ✅ Pass (91.0%) | ✅ Pass (90.5%) | +10.25% ✅ | +15.99% ✅ / +14.75% ✅ / N/A | +15.37% ✅ | 6053.26 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob097_mux9to1v | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +31.21% ✅ | -5.20% ❌ / +98.84% ✅ / N/A | +46.82% ✅ | 10315.10 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (91.0%) | ✅ Pass (91.0%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 5682.58 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (83.3%) | ✅ Pass (82.9%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 8043.48 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (74.3%) | ✅ Pass (74.3%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 12752.23 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob099_m2014_q6c | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4943.94 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob099_m2014_q6c | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7788.38 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob099_m2014_q6c | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 10237.15 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob100_fsm3comb | ✅ Pass (94.3%) | ✅ Pass (94.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5358.94 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob100_fsm3comb | ✅ Pass (94.3%) | ✅ Pass (94.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 8776.79 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob100_fsm3comb | ✅ Pass (90.0%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 10825.22 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob101_circuit4 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4479.12 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob101_circuit4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3946.68 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob101_circuit4 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 9740.14 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob102_circuit3 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4758.42 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob102_circuit3 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5196.07 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob102_circuit3 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.46% ✅ | 10825.33 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob103_circuit2 | ✅ Pass (99.0%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4689.77 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob103_circuit2 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4801.52 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob103_circuit2 | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 10084.67 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob104_mt2015_muxdff | ✅ Pass (21.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5148.27 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob104_mt2015_muxdff | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4988.41 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob104_mt2015_muxdff | ✅ Pass (12.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 10978.30 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob105_rotate100 | ✅ Pass (98.6%) | ✅ Pass (97.6%) | +4.16% ✅ | +6.58% ✅ / +5.88% ✅ / +0.00% ➖ | +4.16% ✅ | 6846.78 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob105_rotate100 | ✅ Pass (88.6%) | ✅ Pass (88.6%) | +8.90% ✅ | +6.87% ✅ / +6.18% ✅ / +13.64% ✅ | +8.90% ✅ | 6708.06 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob105_rotate100 | ✅ Pass (83.3%) | ✅ Pass (83.3%) | +8.90% ✅ | +6.87% ✅ / +6.18% ✅ / +13.64% ✅ | +8.90% ✅ | 13144.27 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob106_always_nolatches | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +19.24% ✅ | +20.00% ✅ / +37.73% ✅ / N/A | +28.86% ✅ | 5253.51 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob106_always_nolatches | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +21.91% ✅ | +30.00% ✅ / +35.73% ✅ / N/A | +32.86% ✅ | 5436.35 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob106_always_nolatches | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +29.86% ✅ | +36.67% ✅ / +52.92% ✅ / N/A | +44.79% ✅ | 9916.47 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob107_fsm1s | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +1.78% ✅ | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | +1.78% ✅ | 4710.41 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob107_fsm1s | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +1.78% ✅ | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | +1.78% ✅ | 5602.41 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob107_fsm1s | ✅ Pass (89.5%) | ✅ Pass (89.5%) | +1.78% ✅ | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | +1.78% ✅ | 9792.56 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob108_rule90 | ✅ Pass (97.1%) | ✅ Pass (1.4%) | -7.66% ❌ | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | -7.66% ❌ | 62398.86 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob108_rule90 | ✅ Pass (94.8%) | ✅ Pass (0.5%) | -7.66% ❌ | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | -7.66% ❌ | 62870.55 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob108_rule90 | ✅ Pass (92.4%) | ✅ Pass (5.2%) | -7.66% ❌ | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | -7.66% ❌ | 60959.69 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob109_fsm1 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4754.13 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob109_fsm1 | ✅ Pass (100.0%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5418.84 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob109_fsm1 | ✅ Pass (89.0%) | ✅ Pass (89.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 9701.33 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob110_fsm2 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4644.84 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob110_fsm2 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4753.94 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob110_fsm2 | ✅ Pass (87.1%) | ✅ Pass (86.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 9852.73 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob111_fsm2s | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4715.83 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob111_fsm2s | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4315.42 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob111_fsm2s | ✅ Pass (90.5%) | ✅ Pass (90.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 10095.51 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob112_always_case2 | ✅ Pass (93.8%) | ✅ Pass (93.8%) | +0.17% ✅ | +0.00% ➖ / +0.52% ✅ / N/A | +0.26% ✅ | 5230.29 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob112_always_case2 | ✅ Pass (93.3%) | ✅ Pass (92.9%) | +0.17% ✅ | +0.00% ➖ / +0.52% ✅ / N/A | +0.26% ✅ | 6694.15 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob112_always_case2 | ✅ Pass (92.9%) | ✅ Pass (92.4%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 10200.77 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob113_2012_q1g | ✅ Pass (81.4%) | ✅ Pass (81.4%) | +0.16% ✅ | +0.00% ➖ / +0.47% ✅ / N/A | +0.23% ✅ | 10026.52 | 211 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob113_2012_q1g | ✅ Pass (91.0%) | ✅ Pass (91.0%) | +0.16% ✅ | +0.00% ➖ / +0.47% ✅ / N/A | +0.23% ✅ | 20703.59 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob113_2012_q1g | ✅ Pass (86.2%) | ✅ Pass (86.2%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 15347.63 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob114_bugs_case | ✅ Pass (97.6%) | ✅ Pass (97.1%) | +9.41% ✅ | +11.32% ✅ / +16.91% ✅ / N/A | +14.11% ✅ | 4986.36 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob114_bugs_case | ✅ Pass (87.6%) | ✅ Pass (86.2%) | +19.26% ✅ | +28.30% ✅ / +29.47% ✅ / N/A | +28.89% ✅ | 7257.69 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob114_bugs_case | ✅ Pass (93.8%) | ✅ Pass (91.9%) | +8.96% ✅ | +7.55% ✅ / +19.32% ✅ / N/A | +13.44% ✅ | 10407.78 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob115_shift18 | ✅ Pass (92.9%) | ✅ Pass (92.4%) | +25.49% ✅ | +16.32% ✅ / +27.73% ✅ / +32.43% ✅ | +25.49% ✅ | 5466.39 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob115_shift18 | ✅ Pass (79.0%) | ✅ Pass (79.0%) | +25.49% ✅ | +16.32% ✅ / +27.73% ✅ / +32.43% ✅ | +25.49% ✅ | 6369.70 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob115_shift18 | ✅ Pass (88.6%) | ✅ Pass (88.6%) | +25.49% ✅ | +16.32% ✅ / +27.73% ✅ / +32.43% ✅ | +25.49% ✅ | 11917.28 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (75.2%) | ✅ Pass (74.3%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 7990.72 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 15706.92 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (76.2%) | ✅ Pass (76.2%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 14531.39 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob117_circuit9 | ✅ Pass (80.0%) | ✅ Pass (79.0%) | +14.19% ✅ | +0.00% ➖ / +46.74% ✅ / -4.17% ❌ | +14.19% ✅ | 5668.17 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob117_circuit9 | ✅ Pass (91.4%) | ✅ Pass (91.4%) | +13.77% ✅ | +3.85% ✅ / +37.47% ✅ / +0.00% ➖ | +13.77% ✅ | 5802.89 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob117_circuit9 | ✅ Pass (81.0%) | ✅ Pass (80.5%) | +20.25% ✅ | +11.54% ✅ / +45.05% ✅ / +4.17% ✅ | +20.25% ✅ | 11949.57 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob118_history_shift | ✅ Pass (97.1%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4983.65 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob118_history_shift | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5752.57 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob118_history_shift | ✅ Pass (84.3%) | ✅ Pass (84.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 11463.08 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob119_fsm3 | ✅ Pass (81.4%) | ✅ Pass (81.4%) | +2.70% ✅ | +5.88% ✅ / +2.22% ✅ / +0.00% ➖ | +2.70% ✅ | 5865.48 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob119_fsm3 | ✅ Pass (90.5%) | ✅ Pass (90.5%) | +2.70% ✅ | +5.88% ✅ / +2.22% ✅ / +0.00% ➖ | +2.70% ✅ | 8136.54 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob119_fsm3 | ✅ Pass (61.4%) | ✅ Pass (61.4%) | +2.70% ✅ | +5.88% ✅ / +2.22% ✅ / +0.00% ➖ | +2.70% ✅ | 11239.80 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob120_fsm3s | ✅ Pass (82.4%) | ✅ Pass (82.4%) | +32.68% ✅ | +40.74% ✅ / +51.74% ✅ / +5.56% ✅ | +32.68% ✅ | 6584.67 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob120_fsm3s | ✅ Pass (84.3%) | ✅ Pass (84.3%) | +32.56% ✅ | +40.74% ✅ / +51.39% ✅ / +5.56% ✅ | +32.56% ✅ | 10293.06 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob120_fsm3s | ✅ Pass (68.6%) | ✅ Pass (68.1%) | +30.98% ✅ | +37.04% ✅ / +50.35% ✅ / +5.56% ✅ | +30.98% ✅ | 11635.68 | 421 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob121_2014_q3bfsm | ✅ Pass (81.0%) | ✅ Pass (81.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6514.56 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob121_2014_q3bfsm | ✅ Pass (87.6%) | ✅ Pass (87.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 8100.10 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob121_2014_q3bfsm | ✅ Pass (50.0%) | ✅ Pass (49.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 12059.04 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob122_kmap4 | ✅ Pass (98.6%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4601.48 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob122_kmap4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3770.82 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob122_kmap4 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 10619.08 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob123_bugs_addsubz | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +10.87% ✅ | +23.33% ✅ / +9.26% ✅ / N/A | +16.30% ✅ | 4780.32 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob123_bugs_addsubz | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +39.65% ✅ | +20.00% ✅ / +98.94% ✅ / N/A | +59.47% ✅ | 5128.11 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob123_bugs_addsubz | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +22.30% ✅ | +36.67% ✅ / +30.25% ✅ / N/A | +33.46% ✅ | 10594.75 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob124_rule110 | ✅ Pass (79.0%) | ✅ Pass (9.5%) | -4.82% ❌ | -8.18% ❌ / -6.27% ❌ / +0.00% ➖ | -4.82% ❌ | 46972.84 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob124_rule110 | ✅ Pass (87.1%) | ✅ Pass (6.2%) | -11.34% ❌ | -7.84% ❌ / -12.54% ❌ / -13.64% ❌ | -11.34% ❌ | 57103.37 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob124_rule110 | ✅ Pass (77.1%) | ✅ Pass (7.1%) | -63.47% ❌ | -27.42% ❌ / -131.18% ❌ / -31.82% ❌ | -63.47% ❌ | 51113.79 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob125_kmap3 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +0.61% ✅ | +0.00% ➖ / +1.82% ✅ / N/A | +0.91% ✅ | 6456.44 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob125_kmap3 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +0.61% ✅ | +0.00% ➖ / +1.82% ✅ / N/A | +0.91% ✅ | 8331.00 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob125_kmap3 | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +32.98% ✅ | +0.00% ➖ / +98.95% ✅ / N/A | +49.47% ✅ | 12661.41 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob126_circuit6 | ✅ Pass (39.5%) | ✅ Pass (38.6%) | +23.50% ✅ | +38.33% ✅ / +32.16% ✅ / N/A | +35.24% ✅ | 5405.45 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob126_circuit6 | ✅ Pass (21.4%) | ✅ Pass (21.4%) | +2.44% ✅ | +1.67% ✅ / +5.65% ✅ / N/A | +3.66% ✅ | 5188.81 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob126_circuit6 | ✅ Pass (40.5%) | ✅ Pass (40.5%) | +23.50% ✅ | +38.33% ✅ / +32.16% ✅ / N/A | +35.24% ✅ | 10176.39 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob127_lemmings1 | ✅ Pass (79.0%) | ✅ Pass (79.0%) | +3.72% ✅ | +0.00% ➖ / +1.15% ✅ / +10.00% ✅ | +3.72% ✅ | 5875.56 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob127_lemmings1 | ✅ Pass (90.5%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6595.35 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob127_lemmings1 | ✅ Pass (61.9%) | ✅ Pass (61.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 11450.09 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob128_fsm_ps2 | ✅ Pass (44.8%) | ✅ Pass (44.8%) | +12.76% ✅ | +23.08% ✅ / +21.07% ✅ / -5.88% ❌ | +12.76% ✅ | 6414.42 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob128_fsm_ps2 | ✅ Pass (59.5%) | ✅ Pass (59.5%) | +16.47% ✅ | +26.92% ✅ / +22.50% ✅ / +0.00% ➖ | +16.47% ✅ | 9993.84 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob128_fsm_ps2 | ✅ Pass (58.1%) | ✅ Pass (58.1%) | +12.76% ✅ | +23.08% ✅ / +21.07% ✅ / -5.88% ❌ | +12.76% ✅ | 12696.63 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob129_ece241_2013_q8 | ✅ Pass (92.4%) | ✅ Pass (90.5%) | +16.99% ✅ | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | +16.99% ✅ | 6003.72 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob129_ece241_2013_q8 | ✅ Pass (87.1%) | ✅ Pass (85.7%) | +16.99% ✅ | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | +16.99% ✅ | 7589.21 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob129_ece241_2013_q8 | ✅ Pass (82.4%) | ✅ Pass (79.0%) | +16.99% ✅ | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | +16.99% ✅ | 11726.34 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob130_circuit5 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +8.67% ✅ | +5.88% ✅ / +20.13% ✅ / N/A | +13.01% ✅ | 5640.09 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob130_circuit5 | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +8.67% ✅ | +5.88% ✅ / +20.13% ✅ / N/A | +13.01% ✅ | 5600.82 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob130_circuit5 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +35.01% ✅ | +5.88% ✅ / +99.16% ✅ / N/A | +52.52% ✅ | 10623.99 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob131_mt2015_q4 | ✅ Pass (78.6%) | ✅ Pass (78.6%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 6580.26 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob131_mt2015_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 10472.89 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob131_mt2015_q4 | ✅ Pass (65.2%) | ✅ Pass (65.2%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 12772.89 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob132_always_if2 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5125.99 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob132_always_if2 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4889.62 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob132_always_if2 | ✅ Pass (96.7%) | ✅ Pass (95.7%) | +32.96% ✅ | +0.00% ➖ / +98.87% ✅ / N/A | +49.43% ✅ | 10646.31 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob133_2014_q3fsm | ✅ Pass (55.7%) | ✅ Pass (55.7%) | +11.45% ✅ | +10.71% ✅ / +15.63% ✅ / +8.00% ✅ | +11.45% ✅ | 8015.30 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob133_2014_q3fsm | ✅ Pass (66.7%) | ✅ Pass (66.2%) | +12.68% ✅ | +26.79% ✅ / +31.26% ✅ / -20.00% ❌ | +12.68% ✅ | 13534.81 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob133_2014_q3fsm | ✅ Pass (45.7%) | ✅ Pass (45.7%) | +16.17% ✅ | +19.64% ✅ / +24.87% ✅ / +4.00% ✅ | +16.17% ✅ | 14872.77 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob134_2014_q3c | ✅ Pass (90.5%) | ✅ Pass (90.5%) | +22.06% ✅ | +28.57% ✅ / +37.60% ✅ / N/A | +33.09% ✅ | 7118.30 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob134_2014_q3c | ✅ Pass (91.9%) | ✅ Pass (91.9%) | +22.06% ✅ | +28.57% ✅ / +37.60% ✅ / N/A | +33.09% ✅ | 10731.24 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob134_2014_q3c | ✅ Pass (75.2%) | ✅ Pass (74.8%) | +22.06% ✅ | +28.57% ✅ / +37.60% ✅ / N/A | +33.09% ✅ | 12658.48 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (86.2%) | ✅ Pass (86.2%) | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 8672.33 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 12370.96 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (90.0%) | ✅ Pass (90.0%) | +12.26% ✅ | +0.00% ➖ / +36.77% ✅ / N/A | +18.39% ✅ | 13517.55 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob136_m2014_q6 | ✅ Pass (83.8%) | ✅ Pass (83.8%) | +25.38% ✅ | +44.19% ✅ / +46.95% ✅ / -15.00% ❌ | +25.38% ✅ | 7034.86 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob136_m2014_q6 | ✅ Pass (76.7%) | ✅ Pass (76.7%) | +1.28% ✅ | -2.33% ❌ / -3.84% ❌ / +10.00% ✅ | +1.28% ✅ | 8788.95 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob136_m2014_q6 | ✅ Pass (61.4%) | ✅ Pass (61.0%) | +25.38% ✅ | +44.19% ✅ / +46.95% ✅ / -15.00% ❌ | +25.38% ✅ | 12798.58 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob137_fsm_serial | ✅ Pass (28.6%) | ✅ Pass (28.6%) | +11.32% ✅ | +36.36% ✅ / +36.48% ✅ / -38.89% ❌ | +11.32% ✅ | 7023.46 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob137_fsm_serial | ✅ Pass (56.7%) | ✅ Pass (56.2%) | +15.66% ✅ | +37.37% ✅ / +37.40% ✅ / -27.78% ❌ | +15.66% ✅ | 10328.36 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob137_fsm_serial | ✅ Pass (13.3%) | ✅ Pass (12.4%) | +11.40% ✅ | +28.28% ✅ / +33.71% ✅ / -27.78% ❌ | +11.40% ✅ | 13883.32 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob138_2012_q2fsm | ✅ Pass (88.1%) | ✅ Pass (87.1%) | +30.46% ✅ | +41.30% ✅ / +45.71% ✅ / +4.35% ✅ | +30.46% ✅ | 6881.58 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob138_2012_q2fsm | ✅ Pass (91.0%) | ✅ Pass (91.0%) | +27.70% ✅ | +36.96% ✅ / +46.15% ✅ / +0.00% ➖ | +27.70% ✅ | 7564.45 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob138_2012_q2fsm | ✅ Pass (71.4%) | ✅ Pass (71.0%) | +27.70% ✅ | +36.96% ✅ / +46.15% ✅ / +0.00% ➖ | +27.70% ✅ | 12333.18 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob139_2013_q2bfsm | ✅ Pass (2.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8078.08 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob139_2013_q2bfsm | ✅ Pass (40.5%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 15178.98 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob139_2013_q2bfsm | ✅ Pass (15.2%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 15855.15 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob140_fsm_hdlc | ✅ Pass (50.0%) | ✅ Pass (50.0%) | +37.57% ✅ | +39.71% ✅ / +48.87% ✅ / +24.14% ✅ | +37.57% ✅ | 7278.81 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob140_fsm_hdlc | ✅ Pass (52.9%) | ✅ Pass (52.9%) | +37.57% ✅ | +39.71% ✅ / +48.87% ✅ / +24.14% ✅ | +37.57% ✅ | 13253.42 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob140_fsm_hdlc | ✅ Pass (42.4%) | ✅ Pass (42.4%) | +30.22% ✅ | +35.29% ✅ / +48.47% ✅ / +6.90% ✅ | +30.22% ✅ | 13623.25 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob141_count_clock | ✅ Pass (58.6%) | ✅ Pass (57.6%) | +20.13% ✅ | +25.00% ✅ / +22.63% ✅ / +12.77% ✅ | +20.13% ✅ | 8307.46 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob141_count_clock | ✅ Pass (69.0%) | ✅ Pass (68.1%) | +14.67% ✅ | +11.69% ✅ / +13.16% ✅ / +19.15% ✅ | +14.67% ✅ | 13620.06 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob141_count_clock | ✅ Pass (44.3%) | ✅ Pass (44.3%) | +19.52% ✅ | +23.70% ✅ / +22.11% ✅ / +12.77% ✅ | +19.52% ✅ | 14644.11 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob142_lemmings2 | ✅ Pass (41.9%) | ✅ Pass (41.9%) | +7.86% ✅ | +5.00% ✅ / +18.57% ✅ / +0.00% ➖ | +7.86% ✅ | 6825.90 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob142_lemmings2 | ✅ Pass (65.7%) | ✅ Pass (65.7%) | +7.86% ✅ | +5.00% ✅ / +18.57% ✅ / +0.00% ➖ | +7.86% ✅ | 10272.03 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob142_lemmings2 | ✅ Pass (47.1%) | ✅ Pass (47.1%) | +8.44% ✅ | +10.00% ✅ / +10.55% ✅ / +4.76% ✅ | +8.44% ✅ | 12716.90 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob143_fsm_onehot | ✅ Pass (70.5%) | ✅ Pass (70.5%) | +12.82% ✅ | +23.08% ✅ / +15.37% ✅ / N/A | +19.22% ✅ | 7089.69 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob143_fsm_onehot | ✅ Pass (84.8%) | ✅ Pass (84.8%) | +12.82% ✅ | +23.08% ✅ / +15.37% ✅ / N/A | +19.22% ✅ | 11904.52 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob143_fsm_onehot | ✅ Pass (69.5%) | ✅ Pass (69.0%) | +12.82% ✅ | +23.08% ✅ / +15.37% ✅ / N/A | +19.22% ✅ | 12237.38 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob144_conwaylife | ✅ Pass (71.0%) | ✅ Pass (66.2%) | +20.46% ✅ | +15.57% ✅ / +17.44% ✅ / +28.38% ✅ | +20.46% ✅ | 11064.57 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob144_conwaylife | ✅ Pass (83.8%) | ✅ Pass (81.9%) | +6.95% ✅ | +2.24% ✅ / +15.90% ✅ / +2.70% ✅ | +6.95% ✅ | 16021.84 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob144_conwaylife | ✅ Pass (70.0%) | ✅ Pass (68.1%) | +10.84% ✅ | +5.44% ✅ / +18.97% ✅ / +8.11% ✅ | +10.84% ✅ | 16278.04 | 419 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob145_circuit8 | ✅ Pass (85.7%) | ✅ Pass (29.0%) | +49.98% ✅ | +50.00% ✅ / +99.93% ✅ / N/A | +74.96% ✅ | 7164.47 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob145_circuit8 | ✅ Pass (94.3%) | ✅ Pass (0.5%) | +20.62% ✅ | +50.00% ✅ / +11.87% ✅ / N/A | +30.93% ✅ | 11385.57 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob145_circuit8 | ✅ Pass (72.9%) | ✅ Pass (12.4%) | +49.98% ✅ | +50.00% ✅ / +99.93% ✅ / N/A | +74.96% ✅ | 10893.44 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob146_fsm_serialdata | ✅ Pass (34.3%) | ✅ Pass (34.3%) | -9.32% ❌ | +4.79% ✅ / -4.96% ❌ / -27.78% ❌ | -9.32% ❌ | 6612.65 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob146_fsm_serialdata | ✅ Pass (52.4%) | ✅ Pass (52.4%) | -9.32% ❌ | +4.79% ✅ / -4.96% ❌ / -27.78% ❌ | -9.32% ❌ | 11265.87 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob146_fsm_serialdata | ✅ Pass (18.1%) | ✅ Pass (17.6%) | -31.44% ❌ | -10.27% ❌ / -0.71% ❌ / -83.33% ❌ | -31.44% ❌ | 11626.37 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob147_circuit10 | ✅ Pass (53.8%) | ✅ Pass (53.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 8306.41 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob147_circuit10 | ✅ Pass (83.8%) | ✅ Pass (83.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 16640.84 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob147_circuit10 | ✅ Pass (52.9%) | ✅ Pass (52.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 13389.48 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob148_2013_q2afsm | ✅ Pass (86.7%) | ✅ Pass (86.7%) | +21.52% ✅ | +28.57% ✅ / +26.91% ✅ / +9.09% ✅ | +21.52% ✅ | 6248.15 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob148_2013_q2afsm | ✅ Pass (85.7%) | ✅ Pass (85.7%) | +17.54% ✅ | +25.71% ✅ / +26.91% ✅ / +0.00% ➖ | +17.54% ✅ | 8264.62 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob148_2013_q2afsm | ✅ Pass (85.2%) | ✅ Pass (84.8%) | +21.52% ✅ | +28.57% ✅ / +26.91% ✅ / +9.09% ✅ | +21.52% ✅ | 9961.48 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob149_ece241_2013_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6614.89 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob149_ece241_2013_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12360.67 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob149_ece241_2013_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 11064.77 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (61.0%) | ✅ Pass (61.0%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 6114.10 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (84.8%) | ✅ Pass (84.8%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 8264.87 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (57.6%) | ✅ Pass (57.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 10320.80 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (31.9%) | ✅ Pass (31.9%) | -10.71% ❌ | -4.55% ❌ / -63.31% ❌ / +35.71% ✅ | -10.71% ❌ | 6063.35 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (73.8%) | ✅ Pass (73.3%) | +2.68% ✅ | +7.58% ✅ / +7.61% ✅ / -7.14% ❌ | +2.68% ✅ | 10499.31 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (29.0%) | ✅ Pass (29.0%) | -8.76% ❌ | -4.55% ❌ / -43.18% ❌ / +21.43% ✅ | -8.76% ❌ | 11087.81 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob152_lemmings3 | ✅ Pass (57.6%) | ✅ Pass (57.6%) | +23.13% ✅ | +38.00% ✅ / +40.07% ✅ / -8.70% ❌ | +23.13% ✅ | 5594.00 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob152_lemmings3 | ✅ Pass (84.8%) | ✅ Pass (84.8%) | +22.56% ✅ | +36.00% ✅ / +36.03% ✅ / -4.35% ❌ | +22.56% ✅ | 10305.79 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob152_lemmings3 | ✅ Pass (58.1%) | ✅ Pass (58.1%) | +24.45% ✅ | +40.00% ✅ / +37.68% ✅ / -4.35% ❌ | +24.45% ✅ | 10750.02 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (56.7%) | ✅ Pass (54.8%) | +16.33% ✅ | +10.02% ✅ / +33.64% ✅ / +5.33% ✅ | +16.33% ✅ | 5766.82 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (81.9%) | ✅ Pass (80.5%) | +13.60% ✅ | +7.70% ✅ / +30.43% ✅ / +2.67% ✅ | +13.60% ✅ | 10720.21 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (66.2%) | ✅ Pass (63.8%) | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 10898.95 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob154_fsm_ps2data | ✅ Pass (40.0%) | ✅ Pass (40.0%) | -55.15% ❌ | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | -55.15% ❌ | 5159.56 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob154_fsm_ps2data | ✅ Pass (43.8%) | ✅ Pass (43.8%) | -55.15% ❌ | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | -55.15% ❌ | 8894.74 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob154_fsm_ps2data | ✅ Pass (44.8%) | ✅ Pass (44.8%) | -55.15% ❌ | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | -55.15% ❌ | 10060.33 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob155_lemmings4 | ✅ Pass (16.7%) | ✅ Pass (16.7%) | +2.40% ✅ | -21.57% ❌ / +71.64% ✅ / -42.86% ❌ | +2.40% ✅ | 5929.07 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob155_lemmings4 | ✅ Pass (18.1%) | ✅ Pass (18.1%) | +16.08% ✅ | +12.75% ✅ / +46.21% ✅ / -10.71% ❌ | +16.08% ✅ | 11964.93 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob155_lemmings4 | ✅ Pass (22.4%) | ✅ Pass (22.4%) | +12.63% ✅ | -16.67% ❌ / +61.69% ✅ / -7.14% ❌ | +12.63% ✅ | 10636.01 | 420 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob156_review2015_fancytimer | ✅ Pass (40.0%) | ✅ Pass (40.0%) | +8.22% ✅ | -10.16% ❌ / +36.99% ✅ / -2.17% ❌ | +8.22% ✅ | 5754.52 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob156_review2015_fancytimer | ✅ Pass (82.9%) | ✅ Pass (82.9%) | +4.19% ✅ | -35.29% ❌ / +28.31% ✅ / +19.57% ✅ | +4.19% ✅ | 10562.86 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob156_review2015_fancytimer | ✅ Pass (25.7%) | ✅ Pass (25.2%) | +2.74% ✅ | -25.13% ❌ / +24.66% ✅ / +8.70% ✅ | +2.74% ✅ | 10513.28 | 420 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `eoh` | RTLLM | 50 | ➖ 40/50 (80.0%) | ➖ 33/50 (66.0%) | 54.8% ± 11.3% | 47.3% ± 11.6% | 33/50 | +20.91% ± 8.99% ✅ | ✅ 24 / ➖ 7 / ❌ 2 | 30/50 | +28.75% ± 11.25% ✅ | +23.36% ± 8.67% ✅ / +36.85% ± 20.63% ✅ / +10.46% ± 10.88% ✅ | ✅ 24 / ➖ 4 / ❌ 2 | A ❌ 3/30 / P ❌ 2/30 / T ❌ 4/17 | 6212.27 ± 540.22 | 210.00 ± 0.00 |
| `eoh` | VerilogEval-Spec-to-RTL | 156 | ➖ 151/156 (96.8%) | ➖ 145/156 (92.9%) | 81.6% ± 4.0% | 77.1% ± 4.8% | 145/156 | +8.00% ± 2.22% ✅ | ✅ 75 / ➖ 65 / ❌ 5 | 145/156 | +10.53% ± 2.90% ✅ | +6.76% ± 2.45% ✅ / +16.33% ± 4.88% ✅ / +2.40% ± 3.97% ✅ | ✅ 75 / ➖ 65 / ❌ 5 | A ❌ 10/145 / P ❌ 7/145 / T ❌ 13/55 | 5627.97 ± 919.49 | 210.03 ± 0.02 |
| `funsearch` | RTLLM | 50 | ➖ 36/50 (72.0%) | ➖ 32/50 (64.0%) | 55.4% ± 11.9% | 47.9% ± 12.0% | 32/50 | +22.57% ± 6.53% ✅ | ✅ 24 / ➖ 8 / ❌ 0 | 29/50 | +31.18% ± 8.88% ✅ | +17.98% ± 7.86% ✅ / +47.21% ± 12.72% ✅ / +15.88% ± 13.89% ✅ | ✅ 24 / ➖ 5 / ❌ 0 | A ❌ 3/29 / P ❌ 1/29 / T ❌ 2/16 | 10050.70 ± 1328.17 | 210.00 ± 0.00 |
| `funsearch` | VerilogEval-Spec-to-RTL | 156 | ➖ 148/156 (94.9%) | ➖ 144/156 (92.3%) | 83.9% ± 4.0% | 79.9% ± 4.8% | 144/156 | +6.09% ± 1.99% ✅ | ✅ 65 / ➖ 75 / ❌ 4 | 144/156 | +7.84% ± 2.51% ✅ | +5.99% ± 2.38% ✅ / +11.44% ± 3.83% ✅ / +2.22% ± 3.23% ✅ | ✅ 65 / ➖ 75 / ❌ 4 | A ❌ 7/144 / P ❌ 9/144 / T ❌ 10/55 | 7179.45 ± 1092.53 | 210.00 ± 0.00 |
| `revolution` | RTLLM | 50 | ➖ 44/50 (88.0%) | ➖ 37/50 (74.0%) | 53.7% ± 9.8% | 44.4% ± 10.4% | 37/50 | +23.30% ± 7.70% ✅ | ✅ 30 / ➖ 6 / ❌ 1 | 34/50 | +32.19% ± 10.25% ✅ | +19.99% ± 7.29% ✅ / +47.52% ± 15.82% ✅ / +10.25% ± 8.58% ✅ | ✅ 30 / ➖ 3 / ❌ 1 | A ❌ 2/34 / P ❌ 2/34 / T ❌ 5/20 | 12915.70 ± 611.12 | 420.00 ± 0.00 |
| `revolution` | VerilogEval-Spec-to-RTL | 156 | ➖ 151/156 (96.8%) | ➖ 145/156 (92.9%) | 78.0% ± 4.0% | 74.1% ± 4.7% | 145/156 | +20.17% ± 2.89% ✅ | ✅ 116 / ➖ 24 / ❌ 5 | 145/156 | +29.10% ± 4.03% ✅ | +5.50% ± 2.49% ✅ / +54.57% ± 7.76% ✅ / +1.14% ± 4.32% ✅ | ✅ 116 / ➖ 24 / ❌ 5 | A ❌ 13/145 / P ❌ 7/145 / T ❌ 11/55 | 10858.37 ± 862.41 | 420.00 ± 0.06 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `eoh` | ALL | 206 | ➖ 191/206 (92.7%) | ➖ 178/206 (86.4%) | 75.1% ± 4.3% | 69.9% ± 4.9% | 178/206 | +10.39% ± 2.55% ✅ | ✅ 99 / ➖ 72 / ❌ 7 | 175/206 | +13.65% ± 3.23% ✅ | +9.60% ± 2.67% ✅ / +19.85% ± 5.46% ✅ / +4.30% ± 4.01% ✅ | ✅ 99 / ➖ 69 / ❌ 7 | A ❌ 13/175 / P ❌ 9/175 / T ❌ 17/72 | 5769.79 ± 708.66 | 210.02 ± 0.02 |
| `funsearch` | ALL | 206 | ➖ 184/206 (89.3%) | ➖ 176/206 (85.4%) | 77.0% ± 4.5% | 72.2% ± 5.0% | 176/206 | +9.09% ± 2.21% ✅ | ✅ 89 / ➖ 83 / ❌ 4 | 173/206 | +11.75% ± 2.87% ✅ | +8.00% ± 2.46% ✅ / +17.44% ± 4.31% ✅ / +5.30% ± 4.16% ✅ | ✅ 89 / ➖ 80 / ❌ 4 | A ❌ 10/173 / P ❌ 10/173 / T ❌ 12/71 | 7876.36 ± 902.32 | 210.00 ± 0.00 |
| `revolution` | ALL | 206 | ➖ 195/206 (94.7%) | ➖ 182/206 (88.3%) | 72.1% ± 4.1% | 66.9% ± 4.7% | 182/206 | +20.81% ± 2.78% ✅ | ✅ 146 / ➖ 30 / ❌ 6 | 179/206 | +29.69% ± 3.79% ✅ | +8.26% ± 2.58% ✅ / +53.23% ± 6.96% ✅ / +3.57% ± 3.99% ✅ | ✅ 146 / ➖ 27 / ❌ 6 | A ❌ 15/179 / P ❌ 9/179 / T ❌ 16/75 | 11357.72 ± 679.78 | 420.00 ± 0.04 |

