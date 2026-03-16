# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Provenance note: see `backend_comparison_4way_provenance.txt` in this directory for the backend-to-baseline archive mapping used for this report.

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `codeevolve` | ALL | candidate_evaluations | 210 | N/A | 290.92 ± 1.05 | 2705471.10 ± 177139.86 | 307.33 | 334.80 |
| `codeevolve` | RTLLM | candidate_evaluations | 210 | N/A | 288.94 ± 2.31 | 3512718.84 ± 449427.56 | 328.34 | 424.91 |
| `codeevolve` | VerilogEval-Spec-to-RTL | candidate_evaluations | 210 | N/A | 291.56 ± 1.16 | 2446737.85 ± 165833.08 | 301.21 | 313.68 |
| `eoh` | ALL | candidate_evaluations | 210 | N/A | 210.02 ± 0.02 | 577444.72 ± 29155.93 | 226.51 | 243.06 |
| `eoh` | RTLLM | candidate_evaluations | 210 | N/A | 210.00 ± 0.00 | 657078.66 ± 61675.69 | 262.50 | 318.18 |
| `eoh` | VerilogEval-Spec-to-RTL | candidate_evaluations | 210 | N/A | 210.03 ± 0.02 | 551921.03 ± 32135.44 | 216.98 | 225.96 |
| `funsearch` | ALL | candidate_evaluations | 210 | N/A | 210.01 ± 0.01 | 607452.60 ± 51196.89 | 236.40 | 250.07 |
| `funsearch` | RTLLM | candidate_evaluations | 210 | N/A | 210.02 ± 0.04 | 804990.88 ± 106598.67 | 291.69 | 338.74 |
| `funsearch` | VerilogEval-Spec-to-RTL | candidate_evaluations | 210 | N/A | 210.01 ± 0.01 | 544139.04 ± 54927.72 | 222.86 | 230.71 |
| `revolution` | ALL | candidate_evaluations | 210 | N/A | 420.00 ± 0.04 | 1211922.16 ± 47209.82 | 441.43 | 472.79 |
| `revolution` | RTLLM | candidate_evaluations | 210 | N/A | 420.04 ± 0.05 | 1401507.38 ± 101124.00 | 477.32 | 567.62 |
| `revolution` | VerilogEval-Spec-to-RTL | candidate_evaluations | 210 | N/A | 419.99 ± 0.05 | 1151157.67 ± 49792.93 | 431.05 | 448.76 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|
| `codeevolve` | RTLLM | Prob001_accu | ✅ Pass (47.6%) | ✅ Pass (47.6%) | +14.41% ✅ | -17.80% ❌ / +43.80% ✅ / +17.24% ✅ | +14.41% ✅ | 78534.67 | 280 |
| `eoh` | RTLLM | Prob001_accu | ✅ Pass (57.1%) | ✅ Pass (57.1%) | +14.41% ✅ | -17.80% ❌ / +43.80% ✅ / +17.24% ✅ | +14.41% ✅ | 6132.67 | 210 |
| `funsearch` | RTLLM | Prob001_accu | ✅ Pass (91.4%) | ✅ Pass (91.4%) | +14.41% ✅ | -17.80% ❌ / +43.80% ✅ / +17.24% ✅ | +14.41% ✅ | 10288.87 | 210 |
| `revolution` | RTLLM | Prob001_accu | ✅ Pass (81.9%) | ✅ Pass (81.9%) | +14.41% ✅ | -17.80% ❌ / +43.80% ✅ / +17.24% ✅ | +14.41% ✅ | 12014.59 | 420 |
| `codeevolve` | RTLLM | Prob002_adder_16bit | ✅ Pass (94.8%) | ✅ Pass (94.3%) | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 74021.72 | 286 |
| `eoh` | RTLLM | Prob002_adder_16bit | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 5574.72 | 210 |
| `funsearch` | RTLLM | Prob002_adder_16bit | ✅ Pass (91.9%) | ✅ Pass (91.9%) | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 10173.74 | 210 |
| `revolution` | RTLLM | Prob002_adder_16bit | ✅ Pass (91.9%) | ✅ Pass (91.9%) | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 11639.88 | 420 |
| `codeevolve` | RTLLM | Prob003_adder_32bit | ✅ Pass (75.7%) | ✅ Pass (74.3%) | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 91402.32 | 293 |
| `eoh` | RTLLM | Prob003_adder_32bit | ✅ Pass (93.3%) | ✅ Pass (92.9%) | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 6859.69 | 210 |
| `funsearch` | RTLLM | Prob003_adder_32bit | ✅ Pass (87.6%) | ✅ Pass (87.6%) | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 20688.27 | 210 |
| `revolution` | RTLLM | Prob003_adder_32bit | ✅ Pass (91.9%) | ✅ Pass (90.5%) | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 15278.94 | 420 |
| `codeevolve` | RTLLM | Prob004_adder_8bit | ✅ Pass (83.3%) | ✅ Pass (81.4%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 62892.38 | 282 |
| `eoh` | RTLLM | Prob004_adder_8bit | ✅ Pass (85.2%) | ✅ Pass (85.2%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 5463.10 | 210 |
| `funsearch` | RTLLM | Prob004_adder_8bit | ✅ Pass (60.0%) | ✅ Pass (52.4%) | +20.57% ✅ | -36.96% ❌ / +98.66% ✅ / N/A | +30.85% ✅ | 9316.62 | 210 |
| `revolution` | RTLLM | Prob004_adder_8bit | ✅ Pass (72.9%) | ✅ Pass (72.9%) | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 11361.09 | 420 |
| `codeevolve` | RTLLM | Prob005_adder_bcd | ✅ Pass (96.7%) | ✅ Pass (95.2%) | +37.42% ✅ | +13.33% ✅ / +98.93% ✅ / N/A | +56.13% ✅ | 70204.30 | 285 |
| `eoh` | RTLLM | Prob005_adder_bcd | ✅ Pass (90.5%) | ✅ Pass (90.0%) | +10.35% ✅ | +20.00% ✅ / +11.04% ✅ / N/A | +15.52% ✅ | 6372.84 | 210 |
| `funsearch` | RTLLM | Prob005_adder_bcd | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +10.35% ✅ | +20.00% ✅ / +11.04% ✅ / N/A | +15.52% ✅ | 9446.23 | 210 |
| `revolution` | RTLLM | Prob005_adder_bcd | ✅ Pass (88.6%) | ✅ Pass (88.6%) | +10.35% ✅ | +20.00% ✅ / +11.04% ✅ / N/A | +15.52% ✅ | 12028.65 | 420 |
| `codeevolve` | RTLLM | Prob006_adder_pipe_64bit | ✅ Pass (61.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 101641.48 | 293 |
| `eoh` | RTLLM | Prob006_adder_pipe_64bit | ✅ Pass (61.4%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7642.59 | 210 |
| `funsearch` | RTLLM | Prob006_adder_pipe_64bit | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 14875.35 | 210 |
| `revolution` | RTLLM | Prob006_adder_pipe_64bit | ✅ Pass (24.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 16078.10 | 420 |
| `codeevolve` | RTLLM | Prob007_comparator_3bit | ✅ Pass (98.1%) | ✅ Pass (97.1%) | +35.01% ✅ | +5.88% ✅ / +99.14% ✅ / N/A | +52.51% ✅ | 66779.33 | 303 |
| `eoh` | RTLLM | Prob007_comparator_3bit | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +7.81% ✅ | +5.88% ✅ / +17.53% ✅ / N/A | +11.71% ✅ | 5312.38 | 210 |
| `funsearch` | RTLLM | Prob007_comparator_3bit | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +7.81% ✅ | +5.88% ✅ / +17.53% ✅ / N/A | +11.71% ✅ | 6181.28 | 210 |
| `revolution` | RTLLM | Prob007_comparator_3bit | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +7.94% ✅ | +5.88% ✅ / +17.94% ✅ / N/A | +11.91% ✅ | 9407.82 | 421 |
| `codeevolve` | RTLLM | Prob008_comparator_4bit | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +44.26% ✅ | +33.33% ✅ / +99.44% ✅ / N/A | +66.39% ✅ | 75792.38 | 299 |
| `eoh` | RTLLM | Prob008_comparator_4bit | ✅ Pass (94.8%) | ✅ Pass (94.3%) | +27.79% ✅ | +36.36% ✅ / +47.00% ✅ / N/A | +41.68% ✅ | 5814.31 | 210 |
| `funsearch` | RTLLM | Prob008_comparator_4bit | ✅ Pass (93.8%) | ✅ Pass (93.8%) | +32.05% ✅ | -3.03% ❌ / +99.17% ✅ / N/A | +48.07% ✅ | 6987.68 | 210 |
| `revolution` | RTLLM | Prob008_comparator_4bit | ✅ Pass (91.9%) | ✅ Pass (91.9%) | +44.20% ✅ | +33.33% ✅ / +99.28% ✅ / N/A | +66.31% ✅ | 10801.19 | 420 |
| `codeevolve` | RTLLM | Prob009_div_16bit | ✅ Pass (75.2%) | ✅ Pass (68.6%) | +52.11% ✅ | +77.48% ✅ / +78.86% ✅ / N/A | +78.17% ✅ | 74757.21 | 281 |
| `eoh` | RTLLM | Prob009_div_16bit | ✅ Pass (91.9%) | ✅ Pass (88.1%) | +52.02% ✅ | +77.68% ✅ / +78.38% ✅ / N/A | +78.03% ✅ | 6590.39 | 210 |
| `funsearch` | RTLLM | Prob009_div_16bit | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +52.33% ✅ | +77.86% ✅ / +79.14% ✅ / N/A | +78.50% ✅ | 10284.07 | 210 |
| `revolution` | RTLLM | Prob009_div_16bit | ✅ Pass (91.9%) | ✅ Pass (91.9%) | +56.05% ✅ | +77.04% ✅ / +91.10% ✅ / N/A | +84.07% ✅ | 12181.83 | 420 |
| `codeevolve` | RTLLM | Prob010_radix2_div | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 123562.03 | 295 |
| `eoh` | RTLLM | Prob010_radix2_div | ✅ Pass (1.9%) | ✅ Pass (1.9%) | -79.81% ❌ | -25.66% ❌ / -210.06% ❌ / -3.70% ❌ | -79.81% ❌ | 8696.37 | 210 |
| `funsearch` | RTLLM | Prob010_radix2_div | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 25831.97 | 210 |
| `revolution` | RTLLM | Prob010_radix2_div | ✅ Pass (0.5%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 17039.99 | 420 |
| `codeevolve` | RTLLM | Prob011_multi_16bit | ✅ Pass (45.7%) | ✅ Pass (45.2%) | +36.33% ✅ | +10.71% ✅ / +55.17% ✅ / +43.10% ✅ | +36.33% ✅ | 87335.20 | 269 |
| `eoh` | RTLLM | Prob011_multi_16bit | ✅ Pass (35.7%) | ✅ Pass (35.7%) | +38.13% ✅ | +10.15% ✅ / +60.28% ✅ / +43.97% ✅ | +38.13% ✅ | 7406.51 | 210 |
| `funsearch` | RTLLM | Prob011_multi_16bit | ✅ Pass (58.6%) | ✅ Pass (58.1%) | +36.05% ✅ | +11.56% ✅ / +52.61% ✅ / +43.97% ✅ | +36.05% ✅ | 15974.20 | 210 |
| `revolution` | RTLLM | Prob011_multi_16bit | ✅ Pass (54.3%) | ✅ Pass (52.4%) | +19.76% ✅ | -14.00% ❌ / +32.78% ✅ / +40.52% ✅ | +19.76% ✅ | 14375.67 | 420 |
| `codeevolve` | RTLLM | Prob012_multi_8bit | ✅ Pass (93.3%) | ✅ Pass (89.0%) | +31.79% ✅ | +38.93% ✅ / +56.43% ✅ / N/A | +47.68% ✅ | 59135.48 | 278 |
| `eoh` | RTLLM | Prob012_multi_8bit | ✅ Pass (77.1%) | ✅ Pass (77.1%) | +31.79% ✅ | +38.93% ✅ / +56.43% ✅ / N/A | +47.68% ✅ | 5640.31 | 210 |
| `funsearch` | RTLLM | Prob012_multi_8bit | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +31.79% ✅ | +38.93% ✅ / +56.43% ✅ / N/A | +47.68% ✅ | 8646.98 | 210 |
| `revolution` | RTLLM | Prob012_multi_8bit | ✅ Pass (73.8%) | ✅ Pass (73.8%) | +31.79% ✅ | +38.93% ✅ / +56.43% ✅ / N/A | +47.68% ✅ | 10997.99 | 420 |
| `codeevolve` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (91.4%) | ✅ Pass (43.8%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 97650.98 | 297 |
| `eoh` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (96.2%) | ✅ Pass (47.6%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 8271.84 | 210 |
| `funsearch` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (96.7%) | ✅ Pass (45.2%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 18876.30 | 210 |
| `revolution` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (38.1%) | ✅ Pass (20.0%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 16505.27 | 420 |
| `codeevolve` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (78.1%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 91451.62 | 291 |
| `eoh` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (54.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6525.96 | 210 |
| `funsearch` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (24.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13546.17 | 210 |
| `revolution` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (55.2%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12291.02 | 420 |
| `codeevolve` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (40.5%) | ✅ Pass (36.7%) | +50.46% ✅ | +43.06% ✅ / +25.39% ✅ / +82.93% ✅ | +50.46% ✅ | 92839.06 | 293 |
| `eoh` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (9.0%) | ✅ Pass (9.0%) | +16.81% ✅ | +38.78% ✅ / +53.12% ✅ / -41.46% ❌ | +16.81% ✅ | 6692.39 | 210 |
| `funsearch` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (50.5%) | ✅ Pass (45.7%) | +35.24% ✅ | +30.10% ✅ / +97.57% ✅ / +100.00% ✅ | +75.89% ✅ | 12677.73 | 210 |
| `revolution` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (44.8%) | ✅ Pass (43.3%) | +24.34% ✅ | +37.96% ✅ / +59.47% ✅ / -24.39% ❌ | +24.34% ✅ | 16193.47 | 420 |
| `codeevolve` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (92.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 84256.58 | 290 |
| `eoh` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (51.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6272.87 | 210 |
| `funsearch` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (90.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 10821.17 | 210 |
| `revolution` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (83.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 11439.01 | 420 |
| `codeevolve` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (94.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 77020.05 | 292 |
| `eoh` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (93.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5902.29 | 210 |
| `funsearch` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (93.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8955.54 | 210 |
| `revolution` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (93.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 11550.70 | 421 |
| `codeevolve` | RTLLM | Prob018_float_multi | ✅ Pass (40.0%) | ✅ Pass (28.6%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 130835.61 | 288 |
| `eoh` | RTLLM | Prob018_float_multi | ✅ Pass (47.6%) | ✅ Pass (38.6%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 8485.50 | 210 |
| `funsearch` | RTLLM | Prob018_float_multi | ✅ Pass (66.7%) | ✅ Pass (58.1%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 26979.19 | 210 |
| `revolution` | RTLLM | Prob018_float_multi | ✅ Pass (37.1%) | ✅ Pass (31.9%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 19588.47 | 420 |
| `codeevolve` | RTLLM | Prob019_sub_64bit | ✅ Pass (99.0%) | ✅ Pass (98.6%) | +30.21% ✅ | +45.25% ✅ / +45.39% ✅ / N/A | +45.32% ✅ | 63054.28 | 288 |
| `eoh` | RTLLM | Prob019_sub_64bit | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +30.21% ✅ | +45.25% ✅ / +45.39% ✅ / N/A | +45.32% ✅ | 5364.68 | 210 |
| `funsearch` | RTLLM | Prob019_sub_64bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 6401.96 | 210 |
| `revolution` | RTLLM | Prob019_sub_64bit | ✅ Pass (93.8%) | ✅ Pass (93.8%) | +48.23% ✅ | +45.25% ✅ / +99.44% ✅ / N/A | +72.34% ✅ | 12710.03 | 420 |
| `codeevolve` | RTLLM | Prob020_JC_counter | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 58106.36 | 281 |
| `eoh` | RTLLM | Prob020_JC_counter | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5421.87 | 210 |
| `funsearch` | RTLLM | Prob020_JC_counter | ✅ Pass (98.6%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5411.62 | 210 |
| `revolution` | RTLLM | Prob020_JC_counter | ✅ Pass (83.3%) | ✅ Pass (81.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 9946.87 | 420 |
| `codeevolve` | RTLLM | Prob021_counter_12 | ✅ Pass (99.0%) | ✅ Pass (98.1%) | +18.44% ✅ | +2.27% ✅ / +63.76% ✅ / -10.71% ❌ | +18.44% ✅ | 61259.99 | 282 |
| `eoh` | RTLLM | Prob021_counter_12 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +33.06% ✅ | +20.45% ✅ / +78.71% ✅ / +0.00% ➖ | +33.06% ✅ | 5345.25 | 210 |
| `funsearch` | RTLLM | Prob021_counter_12 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +21.38% ✅ | +15.91% ✅ / +62.51% ✅ / -14.29% ❌ | +21.38% ✅ | 6385.68 | 210 |
| `revolution` | RTLLM | Prob021_counter_12 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +33.06% ✅ | +20.45% ✅ / +78.71% ✅ / +0.00% ➖ | +33.06% ✅ | 9590.56 | 420 |
| `codeevolve` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 86512.19 | 305 |
| `eoh` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5427.28 | 210 |
| `funsearch` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5315.27 | 210 |
| `revolution` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8820.00 | 420 |
| `codeevolve` | RTLLM | Prob023_up_down_counter | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +8.20% ✅ | +13.13% ✅ / +96.65% ✅ / +100.00% ✅ | +69.93% ✅ | 63909.15 | 296 |
| `eoh` | RTLLM | Prob023_up_down_counter | ✅ Pass (91.4%) | ✅ Pass (91.4%) | -4.83% ❌ | +13.13% ✅ / -22.07% ❌ / -5.56% ❌ | -4.83% ❌ | 5566.17 | 210 |
| `funsearch` | RTLLM | Prob023_up_down_counter | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -4.83% ❌ | +13.13% ✅ / -22.07% ❌ / -5.56% ❌ | -4.83% ❌ | 5897.60 | 210 |
| `revolution` | RTLLM | Prob023_up_down_counter | ✅ Pass (88.6%) | ✅ Pass (88.6%) | +25.30% ✅ | +16.99% ✅ / +38.55% ✅ / +20.37% ✅ | +25.30% ✅ | 11165.32 | 420 |
| `codeevolve` | RTLLM | Prob024_fsm | ✅ Pass (60.0%) | ✅ Pass (59.0%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 77879.22 | 292 |
| `eoh` | RTLLM | Prob024_fsm | ✅ Pass (51.4%) | ✅ Pass (47.1%) | +66.61% ✅ | +43.48% ✅ / +70.36% ✅ / N/A | +56.92% ✅ | 6399.36 | 210 |
| `funsearch` | RTLLM | Prob024_fsm | ✅ Pass (44.0%) | ✅ Pass (41.1%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 10543.16 | 210 |
| `revolution` | RTLLM | Prob024_fsm | ✅ Pass (44.8%) | ✅ Pass (43.3%) | +66.61% ✅ | +43.48% ✅ / +70.36% ✅ / N/A | +56.92% ✅ | 11862.70 | 420 |
| `codeevolve` | RTLLM | Prob025_sequence_detector | ✅ Pass (27.6%) | ✅ Pass (27.6%) | +36.24% ✅ | +34.21% ✅ / +48.20% ✅ / +26.32% ✅ | +36.24% ✅ | 77466.21 | 289 |
| `eoh` | RTLLM | Prob025_sequence_detector | ✅ Pass (15.2%) | ✅ Pass (15.2%) | +22.25% ✅ | +42.11% ✅ / +29.90% ✅ / -5.26% ❌ | +22.25% ✅ | 5846.14 | 210 |
| `funsearch` | RTLLM | Prob025_sequence_detector | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 9915.18 | 210 |
| `revolution` | RTLLM | Prob025_sequence_detector | ✅ Pass (9.0%) | ✅ Pass (9.0%) | +25.24% ✅ | +31.58% ✅ / +28.35% ✅ / +15.79% ✅ | +25.24% ✅ | 10188.07 | 420 |
| `codeevolve` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 104310.47 | 293 |
| `eoh` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7166.62 | 210 |
| `funsearch` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 21106.70 | 210 |
| `revolution` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 15355.14 | 420 |
| `codeevolve` | RTLLM | Prob027_LIFObuffer | ✅ Pass (85.7%) | ✅ Pass (85.7%) | +23.57% ✅ | +17.73% ✅ / +42.72% ✅ / +10.26% ✅ | +23.57% ✅ | 82796.91 | 288 |
| `eoh` | RTLLM | Prob027_LIFObuffer | ✅ Pass (89.0%) | ✅ Pass (88.1%) | +20.86% ✅ | +22.07% ✅ / +37.95% ✅ / +2.56% ✅ | +20.86% ✅ | 6387.22 | 210 |
| `funsearch` | RTLLM | Prob027_LIFObuffer | ✅ Pass (93.3%) | ✅ Pass (92.3%) | +23.10% ✅ | +21.74% ✅ / +39.86% ✅ / +7.69% ✅ | +23.10% ✅ | 12003.82 | 210 |
| `revolution` | RTLLM | Prob027_LIFObuffer | ✅ Pass (89.0%) | ✅ Pass (88.6%) | +26.10% ✅ | +17.39% ✅ / +42.96% ✅ / +17.95% ✅ | +26.10% ✅ | 11590.63 | 420 |
| `codeevolve` | RTLLM | Prob028_LFSR | ✅ Pass (12.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 67887.88 | 285 |
| `eoh` | RTLLM | Prob028_LFSR | ✅ Pass (5.7%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5261.30 | 210 |
| `funsearch` | RTLLM | Prob028_LFSR | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4995.28 | 210 |
| `revolution` | RTLLM | Prob028_LFSR | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 10764.59 | 420 |
| `codeevolve` | RTLLM | Prob029_barrel_shifter | ✅ Pass (20.0%) | ✅ Pass (19.0%) | +17.02% ✅ | +25.86% ✅ / +25.19% ✅ / N/A | +25.52% ✅ | 81617.60 | 301 |
| `eoh` | RTLLM | Prob029_barrel_shifter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5625.28 | 210 |
| `funsearch` | RTLLM | Prob029_barrel_shifter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 9699.83 | 210 |
| `revolution` | RTLLM | Prob029_barrel_shifter | ✅ Pass (2.9%) | ✅ Pass (2.9%) | +33.55% ✅ | +1.72% ✅ / +98.93% ✅ / N/A | +50.33% ✅ | 11730.72 | 420 |
| `codeevolve` | RTLLM | Prob030_right_shifter | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 59830.81 | 293 |
| `eoh` | RTLLM | Prob030_right_shifter | ✅ Pass (98.6%) | ✅ Pass (91.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5249.33 | 210 |
| `funsearch` | RTLLM | Prob030_right_shifter | ✅ Pass (99.0%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4115.35 | 210 |
| `revolution` | RTLLM | Prob030_right_shifter | ✅ Pass (77.1%) | ✅ Pass (62.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 9161.22 | 420 |
| `codeevolve` | RTLLM | Prob031_freq_div | ✅ Pass (91.0%) | ✅ Pass (82.4%) | +39.99% ✅ | +20.80% ✅ / +99.16% ✅ / N/A | +59.98% ✅ | 82655.67 | 280 |
| `eoh` | RTLLM | Prob031_freq_div | ✅ Pass (84.8%) | ✅ Pass (62.9%) | +28.27% ✅ | +32.80% ✅ / +52.01% ✅ / N/A | +42.41% ✅ | 6964.59 | 210 |
| `funsearch` | RTLLM | Prob031_freq_div | ✅ Pass (83.3%) | ✅ Pass (53.3%) | +37.21% ✅ | +12.80% ✅ / +98.82% ✅ / N/A | +55.81% ✅ | 13957.34 | 210 |
| `revolution` | RTLLM | Prob031_freq_div | ✅ Pass (71.9%) | ✅ Pass (33.3%) | +32.89% ✅ | +0.00% ➖ / +98.68% ✅ / N/A | +49.34% ✅ | 12748.47 | 420 |
| `codeevolve` | RTLLM | Prob032_freq_divbyeven | ✅ Pass (1.4%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 92035.67 | 282 |
| `eoh` | RTLLM | Prob032_freq_divbyeven | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5387.90 | 210 |
| `funsearch` | RTLLM | Prob032_freq_divbyeven | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7845.42 | 210 |
| `revolution` | RTLLM | Prob032_freq_divbyeven | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13635.66 | 420 |
| `codeevolve` | RTLLM | Prob033_freq_divbyfrac | ✅ Pass (2.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 126572.65 | 292 |
| `eoh` | RTLLM | Prob033_freq_divbyfrac | ✅ Pass (1.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8056.31 | 210 |
| `funsearch` | RTLLM | Prob033_freq_divbyfrac | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 19481.96 | 210 |
| `revolution` | RTLLM | Prob033_freq_divbyfrac | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 14957.87 | 420 |
| `codeevolve` | RTLLM | Prob034_freq_divbyodd | ✅ Pass (0.5%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 119697.47 | 296 |
| `eoh` | RTLLM | Prob034_freq_divbyodd | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6812.16 | 210 |
| `funsearch` | RTLLM | Prob034_freq_divbyodd | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13514.08 | 210 |
| `revolution` | RTLLM | Prob034_freq_divbyodd | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13120.14 | 420 |
| `codeevolve` | RTLLM | Prob035_calendar | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 84959.71 | 289 |
| `eoh` | RTLLM | Prob035_calendar | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5015.88 | 210 |
| `funsearch` | RTLLM | Prob035_calendar | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8041.52 | 210 |
| `revolution` | RTLLM | Prob035_calendar | ✅ Pass (90.5%) | ✅ Pass (20.0%) | +4.46% ✅ | +5.10% ✅ / +5.65% ✅ / +2.63% ✅ | +4.46% ✅ | 11208.48 | 420 |
| `codeevolve` | RTLLM | Prob036_edge_detect | ✅ Pass (92.9%) | ✅ Pass (92.4%) | +28.59% ✅ | +26.32% ✅ / +41.80% ✅ / +17.65% ✅ | +28.59% ✅ | 70915.36 | 290 |
| `eoh` | RTLLM | Prob036_edge_detect | ✅ Pass (93.3%) | ✅ Pass (92.9%) | +28.59% ✅ | +26.32% ✅ / +41.80% ✅ / +17.65% ✅ | +28.59% ✅ | 4972.56 | 210 |
| `funsearch` | RTLLM | Prob036_edge_detect | ✅ Pass (80.0%) | ✅ Pass (78.1%) | +20.11% ✅ | +21.05% ✅ / +27.51% ✅ / +11.76% ✅ | +20.11% ✅ | 7963.90 | 210 |
| `revolution` | RTLLM | Prob036_edge_detect | ✅ Pass (61.0%) | ✅ Pass (59.5%) | +28.59% ✅ | +26.32% ✅ / +41.80% ✅ / +17.65% ✅ | +28.59% ✅ | 9129.91 | 420 |
| `codeevolve` | RTLLM | Prob037_parallel2serial | ✅ Pass (32.9%) | ✅ Pass (30.0%) | +52.00% ✅ | +62.00% ✅ / +56.95% ✅ / +37.04% ✅ | +52.00% ✅ | 81664.62 | 288 |
| `eoh` | RTLLM | Prob037_parallel2serial | ✅ Pass (52.9%) | ✅ Pass (46.7%) | +52.00% ✅ | +62.00% ✅ / +56.95% ✅ / +37.04% ✅ | +52.00% ✅ | 5824.22 | 210 |
| `funsearch` | RTLLM | Prob037_parallel2serial | ✅ Pass (24.8%) | ✅ Pass (21.0%) | +22.83% ✅ | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ | +22.83% ✅ | 14771.20 | 210 |
| `revolution` | RTLLM | Prob037_parallel2serial | ✅ Pass (35.7%) | ✅ Pass (24.3%) | +46.86% ✅ | +54.00% ✅ / +56.95% ✅ / +29.63% ✅ | +46.86% ✅ | 13318.72 | 420 |
| `codeevolve` | RTLLM | Prob038_pulse_detect | ✅ Pass (26.7%) | ✅ Pass (26.2%) | +27.89% ✅ | +23.53% ✅ / +26.81% ✅ / +33.33% ✅ | +27.89% ✅ | 75270.48 | 290 |
| `eoh` | RTLLM | Prob038_pulse_detect | ✅ Pass (14.8%) | ✅ Pass (14.8%) | +27.89% ✅ | +23.53% ✅ / +26.81% ✅ / +33.33% ✅ | +27.89% ✅ | 5235.23 | 210 |
| `funsearch` | RTLLM | Prob038_pulse_detect | ✅ Pass (3.8%) | ✅ Pass (3.8%) | +27.89% ✅ | +23.53% ✅ / +26.81% ✅ / +33.33% ✅ | +27.89% ✅ | 9544.29 | 210 |
| `revolution` | RTLLM | Prob038_pulse_detect | ✅ Pass (2.4%) | ✅ Pass (1.9%) | +27.89% ✅ | +23.53% ✅ / +26.81% ✅ / +33.33% ✅ | +27.89% ✅ | 10008.34 | 420 |
| `codeevolve` | RTLLM | Prob039_serial2parallel | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 86089.40 | 284 |
| `eoh` | RTLLM | Prob039_serial2parallel | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 17685.18 | 210 |
| `funsearch` | RTLLM | Prob039_serial2parallel | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 25112.02 | 210 |
| `revolution` | RTLLM | Prob039_serial2parallel | ✅ Pass (1.0%) | ✅ Pass (1.0%) | -13.63% ❌ | -20.24% ❌ / +22.69% ✅ / -43.33% ❌ | -13.63% ❌ | 23251.09 | 420 |
| `codeevolve` | RTLLM | Prob040_synchronizer | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 78688.27 | 300 |
| `eoh` | RTLLM | Prob040_synchronizer | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 5340.39 | 210 |
| `funsearch` | RTLLM | Prob040_synchronizer | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 10082.27 | 210 |
| `revolution` | RTLLM | Prob040_synchronizer | ✅ Pass (87.6%) | ✅ Pass (85.7%) | +0.00% ➖ | N/A / N/A / N/A | N/A | 11310.97 | 420 |
| `codeevolve` | RTLLM | Prob041_traffic_light | ✅ Pass (62.9%) | ✅ Pass (62.9%) | +43.71% ✅ | +32.35% ✅ / +98.78% ✅ / N/A | +65.57% ✅ | 80069.28 | 278 |
| `eoh` | RTLLM | Prob041_traffic_light | ✅ Pass (80.0%) | ✅ Pass (79.5%) | +47.36% ✅ | +42.94% ✅ / +99.15% ✅ / N/A | +71.04% ✅ | 5444.04 | 210 |
| `funsearch` | RTLLM | Prob041_traffic_light | ✅ Pass (85.7%) | ✅ Pass (85.7%) | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 12344.26 | 210 |
| `revolution` | RTLLM | Prob041_traffic_light | ✅ Pass (67.6%) | ✅ Pass (67.1%) | +44.83% ✅ | +35.29% ✅ / +99.20% ✅ / N/A | +67.25% ✅ | 13132.79 | 420 |
| `codeevolve` | RTLLM | Prob042_width_8to16 | ✅ Pass (10.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 87192.86 | 288 |
| `eoh` | RTLLM | Prob042_width_8to16 | ✅ Pass (3.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5742.63 | 210 |
| `funsearch` | RTLLM | Prob042_width_8to16 | ✅ Pass (12.4%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 15340.49 | 210 |
| `revolution` | RTLLM | Prob042_width_8to16 | ✅ Pass (16.7%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 14581.02 | 420 |
| `codeevolve` | RTLLM | Prob043_RAM | ✅ Pass (82.4%) | ✅ Pass (80.5%) | +44.45% ✅ | +34.47% ✅ / +63.39% ✅ / +35.48% ✅ | +44.45% ✅ | 68379.70 | 275 |
| `eoh` | RTLLM | Prob043_RAM | ✅ Pass (91.9%) | ✅ Pass (90.5%) | +44.45% ✅ | +34.47% ✅ / +63.39% ✅ / +35.48% ✅ | +44.45% ✅ | 5269.20 | 210 |
| `funsearch` | RTLLM | Prob043_RAM | ✅ Pass (99.0%) | ✅ Pass (95.2%) | +44.45% ✅ | +34.47% ✅ / +63.39% ✅ / +35.48% ✅ | +44.45% ✅ | 10019.03 | 210 |
| `revolution` | RTLLM | Prob043_RAM | ✅ Pass (93.3%) | ✅ Pass (90.5%) | +45.43% ✅ | +40.60% ✅ / +53.76% ✅ / +41.94% ✅ | +45.43% ✅ | 9228.78 | 420 |
| `codeevolve` | RTLLM | Prob044_ROM | ✅ Pass (76.2%) | ✅ Pass (76.2%) | +32.94% ✅ | +0.00% ➖ / +98.83% ✅ / N/A | +49.41% ✅ | 60307.43 | 278 |
| `eoh` | RTLLM | Prob044_ROM | ✅ Pass (76.2%) | ✅ Pass (76.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4653.03 | 210 |
| `funsearch` | RTLLM | Prob044_ROM | ✅ Pass (77.5%) | ✅ Pass (76.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 7186.04 | 210 |
| `revolution` | RTLLM | Prob044_ROM | ✅ Pass (56.7%) | ✅ Pass (50.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 8426.07 | 420 |
| `codeevolve` | RTLLM | Prob045_alu | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 101253.68 | 290 |
| `eoh` | RTLLM | Prob045_alu | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6009.30 | 210 |
| `funsearch` | RTLLM | Prob045_alu | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 18327.91 | 211 |
| `revolution` | RTLLM | Prob045_alu | ✅ Pass (71.9%) | ✅ Pass (71.9%) | +42.73% ✅ | +28.94% ✅ / +99.26% ✅ / N/A | +64.10% ✅ | 14098.12 | 420 |
| `codeevolve` | RTLLM | Prob046_clkgenerator | ✅ Pass (3.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 74719.49 | 312 |
| `eoh` | RTLLM | Prob046_clkgenerator | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4394.31 | 210 |
| `funsearch` | RTLLM | Prob046_clkgenerator | ✅ Pass (4.8%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 9578.26 | 210 |
| `revolution` | RTLLM | Prob046_clkgenerator | ✅ Pass (8.1%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 9591.66 | 420 |
| `codeevolve` | RTLLM | Prob047_instr_reg | ✅ Pass (98.6%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 63782.04 | 275 |
| `eoh` | RTLLM | Prob047_instr_reg | ✅ Pass (82.4%) | ✅ Pass (82.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4802.89 | 210 |
| `funsearch` | RTLLM | Prob047_instr_reg | ✅ Pass (96.7%) | ✅ Pass (94.8%) | +5.68% ✅ | +0.00% ➖ / +17.05% ✅ / +0.00% ➖ | +5.68% ✅ | 8236.94 | 210 |
| `revolution` | RTLLM | Prob047_instr_reg | ✅ Pass (62.9%) | ✅ Pass (55.7%) | +5.68% ✅ | +0.00% ➖ / +17.05% ✅ / +0.00% ➖ | +5.68% ✅ | 9182.36 | 420 |
| `codeevolve` | RTLLM | Prob048_pe | ✅ Pass (82.4%) | ✅ Pass (82.4%) | +28.74% ✅ | +0.03% ✅ / +49.89% ✅ / +100.00% ✅ | +49.97% ✅ | 62982.10 | 285 |
| `eoh` | RTLLM | Prob048_pe | ✅ Pass (81.9%) | ✅ Pass (81.9%) | +14.74% ✅ | -3.16% ❌ / +0.89% ✅ / +46.50% ✅ | +14.74% ✅ | 5046.91 | 210 |
| `funsearch` | RTLLM | Prob048_pe | ✅ Pass (72.4%) | ✅ Pass (72.4%) | +33.02% ✅ | +1.56% ✅ / +61.20% ✅ / +100.00% ✅ | +54.25% ✅ | 8430.95 | 210 |
| `revolution` | RTLLM | Prob048_pe | ✅ Pass (41.4%) | ✅ Pass (41.4%) | +1.51% ✅ | +1.51% ✅ / +6.21% ✅ / -3.18% ❌ | +1.51% ✅ | 8346.07 | 420 |
| `codeevolve` | RTLLM | Prob049_signal_generator | ✅ Pass (42.9%) | ✅ Pass (41.9%) | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 72183.26 | 290 |
| `eoh` | RTLLM | Prob049_signal_generator | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4679.99 | 210 |
| `funsearch` | RTLLM | Prob049_signal_generator | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8776.76 | 210 |
| `revolution` | RTLLM | Prob049_signal_generator | ✅ Pass (46.7%) | ✅ Pass (46.7%) | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 9399.07 | 420 |
| `codeevolve` | RTLLM | Prob050_square_wave | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +80.75% ✅ | +91.60% ✅ / +95.38% ✅ / +55.26% ✅ | +80.75% ✅ | 67047.78 | 297 |
| `eoh` | RTLLM | Prob050_square_wave | ✅ Pass (97.1%) | ✅ Pass (96.7%) | +30.46% ✅ | +22.69% ✅ / +68.70% ✅ / +0.00% ➖ | +30.46% ✅ | 4559.58 | 210 |
| `funsearch` | RTLLM | Prob050_square_wave | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +31.14% ✅ | +9.24% ✅ / +71.01% ✅ / +13.16% ✅ | +31.14% ✅ | 7663.92 | 210 |
| `revolution` | RTLLM | Prob050_square_wave | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +27.79% ✅ | +11.76% ✅ / +66.36% ✅ / +5.26% ✅ | +27.79% ✅ | 8422.40 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob001_zero | ✅ Pass (91.9%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 54256.61 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob001_zero | ✅ Pass (74.8%) | ✅ Pass (72.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3975.44 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob001_zero | ✅ Pass (81.4%) | ✅ Pass (81.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4248.97 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob001_zero | ✅ Pass (84.3%) | ✅ Pass (81.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5911.55 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob002_m2014_q4i | ✅ Pass (90.5%) | ✅ Pass (89.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 55838.03 | 300 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob002_m2014_q4i | ✅ Pass (87.6%) | ✅ Pass (83.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4105.87 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob002_m2014_q4i | ✅ Pass (83.3%) | ✅ Pass (81.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4023.50 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob002_m2014_q4i | ✅ Pass (84.3%) | ✅ Pass (80.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 6117.80 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob003_step_one | ✅ Pass (89.5%) | ✅ Pass (89.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 53307.02 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob003_step_one | ✅ Pass (75.2%) | ✅ Pass (73.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3936.79 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob003_step_one | ✅ Pass (75.7%) | ✅ Pass (75.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4079.19 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob003_step_one | ✅ Pass (79.0%) | ✅ Pass (74.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5931.57 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob004_vector2 | ✅ Pass (97.1%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 54427.63 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob004_vector2 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4142.89 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob004_vector2 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4105.67 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob004_vector2 | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 7623.11 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob005_notgate | ✅ Pass (96.2%) | ✅ Pass (95.7%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 51654.23 | 285 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob005_notgate | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3857.04 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob005_notgate | ✅ Pass (90.0%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2948.87 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob005_notgate | ✅ Pass (92.4%) | ✅ Pass (91.0%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 5777.84 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob006_vectorr | ✅ Pass (92.9%) | ✅ Pass (90.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 53217.41 | 290 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob006_vectorr | ✅ Pass (73.8%) | ✅ Pass (73.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4140.37 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob006_vectorr | ✅ Pass (81.9%) | ✅ Pass (81.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4941.49 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob006_vectorr | ✅ Pass (92.9%) | ✅ Pass (92.9%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 7468.53 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob007_wire | ✅ Pass (95.7%) | ✅ Pass (95.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 49947.93 | 293 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob007_wire | ✅ Pass (90.0%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3839.35 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob007_wire | ✅ Pass (91.0%) | ✅ Pass (91.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3640.70 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob007_wire | ✅ Pass (94.8%) | ✅ Pass (90.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 5968.39 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob008_m2014_q4h | ✅ Pass (97.6%) | ✅ Pass (97.1%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 50156.48 | 290 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob008_m2014_q4h | ✅ Pass (92.9%) | ✅ Pass (92.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3799.51 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob008_m2014_q4h | ✅ Pass (86.7%) | ✅ Pass (86.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3353.71 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob008_m2014_q4h | ✅ Pass (93.3%) | ✅ Pass (92.4%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 5636.66 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob009_popcount3 | ✅ Pass (94.3%) | ✅ Pass (92.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 53656.77 | 304 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob009_popcount3 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3955.26 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob009_popcount3 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5480.53 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob009_popcount3 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 6240.66 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob010_mt2015_q4a | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 48349.70 | 291 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob010_mt2015_q4a | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3687.34 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob010_mt2015_q4a | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3373.90 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob010_mt2015_q4a | ✅ Pass (95.2%) | ✅ Pass (94.3%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 6661.26 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob011_norgate | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 46002.27 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob011_norgate | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3567.38 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob011_norgate | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2901.11 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob011_norgate | ✅ Pass (95.7%) | ✅ Pass (95.2%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 5282.93 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob012_xnorgate | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 45162.27 | 299 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob012_xnorgate | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3532.88 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob012_xnorgate | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3104.83 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob012_xnorgate | ✅ Pass (92.9%) | ✅ Pass (91.9%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 5752.71 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob013_m2014_q4e | ✅ Pass (97.6%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 35690.67 | 285 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob013_m2014_q4e | ✅ Pass (98.1%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3473.25 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob013_m2014_q4e | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3057.51 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob013_m2014_q4e | ✅ Pass (91.0%) | ✅ Pass (91.0%) | +32.95% ✅ | +0.00% ➖ / +98.84% ✅ / N/A | +49.42% ✅ | 4939.70 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob014_andgate | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.96% ✅ | +0.00% ➖ / +98.89% ✅ / N/A | +49.45% ✅ | 33453.98 | 284 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob014_andgate | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3432.56 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob014_andgate | ✅ Pass (98.1%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2969.07 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob014_andgate | ✅ Pass (94.3%) | ✅ Pass (94.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4223.45 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob015_vector1 | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 37546.57 | 291 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob015_vector1 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3261.21 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob015_vector1 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3376.24 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob015_vector1 | ✅ Pass (94.3%) | ✅ Pass (92.4%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 5463.79 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob016_m2014_q4j | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +42.43% ✅ | +28.00% ✅ / +99.29% ✅ / N/A | +63.65% ✅ | 48816.38 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob016_m2014_q4j | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +37.00% ✅ | +12.00% ✅ / +98.99% ✅ / N/A | +55.50% ✅ | 3563.30 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob016_m2014_q4j | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +37.00% ✅ | +12.00% ✅ / +98.99% ✅ / N/A | +55.50% ✅ | 5620.35 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob016_m2014_q4j | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +42.48% ✅ | +28.00% ✅ / +99.44% ✅ / N/A | +63.72% ✅ | 7489.56 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob017_mux2to1v | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 36229.09 | 282 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob017_mux2to1v | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 3497.76 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob017_mux2to1v | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3749.31 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob017_mux2to1v | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 5331.53 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob018_mux256to1 | ✅ Pass (92.9%) | ✅ Pass (92.4%) | +32.98% ✅ | +0.00% ➖ / +98.95% ✅ / N/A | +49.47% ✅ | 72292.28 | 291 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob018_mux256to1 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +19.40% ✅ | +16.86% ✅ / +41.35% ✅ / N/A | +29.10% ✅ | 4507.07 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob018_mux256to1 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +19.40% ✅ | +16.86% ✅ / +41.35% ✅ / N/A | +29.10% ✅ | 3662.65 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob018_mux256to1 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +40.06% ✅ | +20.88% ✅ / +99.31% ✅ / N/A | +60.10% ✅ | 7990.17 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob019_m2014_q4f | ✅ Pass (93.3%) | ✅ Pass (92.9%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 38650.26 | 298 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob019_m2014_q4f | ✅ Pass (79.0%) | ✅ Pass (79.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3392.76 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob019_m2014_q4f | ✅ Pass (81.9%) | ✅ Pass (81.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4042.93 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob019_m2014_q4f | ✅ Pass (91.4%) | ✅ Pass (91.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 5059.50 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob020_mt2015_eq2 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 41330.20 | 303 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob020_mt2015_eq2 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3408.35 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob020_mt2015_eq2 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3729.70 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob020_mt2015_eq2 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 5266.16 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob021_mux256to1v | ✅ Pass (75.7%) | ✅ Pass (75.7%) | +42.32% ✅ | +27.35% ✅ / +99.60% ✅ / N/A | +63.48% ✅ | 55031.07 | 286 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob021_mux256to1v | ✅ Pass (65.7%) | ✅ Pass (65.2%) | +30.49% ✅ | +27.35% ✅ / +64.12% ✅ / N/A | +45.74% ✅ | 4464.55 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob021_mux256to1v | ✅ Pass (46.7%) | ✅ Pass (46.7%) | +30.49% ✅ | +27.35% ✅ / +64.12% ✅ / N/A | +45.74% ✅ | 4990.05 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob021_mux256to1v | ✅ Pass (68.6%) | ✅ Pass (68.6%) | +39.07% ✅ | +17.99% ✅ / +99.23% ✅ / N/A | +58.61% ✅ | 9017.52 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob022_mux2to1 | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 37138.36 | 285 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob022_mux2to1 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3386.46 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob022_mux2to1 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3487.54 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob022_mux2to1 | ✅ Pass (91.9%) | ✅ Pass (91.9%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 4491.07 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob023_vector100r | ✅ Pass (84.3%) | ✅ Pass (78.6%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 45268.33 | 308 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob023_vector100r | ✅ Pass (86.7%) | ✅ Pass (86.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4053.03 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob023_vector100r | ✅ Pass (82.9%) | ✅ Pass (82.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5954.57 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob023_vector100r | ✅ Pass (80.5%) | ✅ Pass (80.5%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 6460.35 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob024_hadd | ✅ Pass (96.2%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.46% ✅ | 37791.88 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob024_hadd | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3334.65 | 211 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob024_hadd | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3143.73 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob024_hadd | ✅ Pass (94.8%) | ✅ Pass (94.3%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.46% ✅ | 4672.44 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob025_reduction | ✅ Pass (98.6%) | ✅ Pass (94.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 39987.29 | 298 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob025_reduction | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 3394.57 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob025_reduction | ✅ Pass (94.3%) | ✅ Pass (94.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3893.93 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob025_reduction | ✅ Pass (91.4%) | ✅ Pass (91.4%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 6835.39 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob026_alwaysblock1 | ✅ Pass (94.8%) | ✅ Pass (94.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 40107.67 | 289 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob026_alwaysblock1 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3324.87 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob026_alwaysblock1 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4023.21 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob026_alwaysblock1 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 4441.06 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob027_fadd | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 38209.99 | 287 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob027_fadd | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 3435.88 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob027_fadd | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3411.79 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob027_fadd | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 5075.54 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob028_m2014_q4a | ✅ Pass (87.6%) | ✅ Pass (32.9%) | +44.19% ✅ | +33.33% ✅ / +99.22% ✅ / N/A | +66.28% ✅ | 54774.86 | 285 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob028_m2014_q4a | ✅ Pass (95.7%) | ✅ Pass (6.2%) | +20.81% ✅ | +33.33% ✅ / +29.09% ✅ / N/A | +31.21% ✅ | 3498.83 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob028_m2014_q4a | ✅ Pass (98.6%) | ✅ Pass (0.5%) | +20.81% ✅ | +33.33% ✅ / +29.09% ✅ / N/A | +31.21% ✅ | 4472.96 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob028_m2014_q4a | ✅ Pass (89.0%) | ✅ Pass (3.3%) | +20.81% ✅ | +33.33% ✅ / +29.09% ✅ / N/A | +31.21% ✅ | 5962.45 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob029_m2014_q4g | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 40186.23 | 287 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob029_m2014_q4g | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3524.96 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob029_m2014_q4g | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5519.78 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob029_m2014_q4g | ✅ Pass (96.2%) | ✅ Pass (95.2%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 6881.01 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob030_popcount255 | ✅ Pass (90.0%) | ✅ Pass (87.1%) | +29.04% ✅ | -0.45% ❌ / +87.58% ✅ / N/A | +43.57% ✅ | 63593.13 | 291 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob030_popcount255 | ✅ Pass (90.0%) | ✅ Pass (89.5%) | +1.56% ✅ | +3.29% ✅ / +1.40% ✅ / N/A | +2.34% ✅ | 5745.82 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob030_popcount255 | ✅ Pass (80.4%) | ✅ Pass (80.4%) | +0.46% ✅ | +0.45% ✅ / +0.93% ✅ / N/A | +0.69% ✅ | 12369.70 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob030_popcount255 | ✅ Pass (87.1%) | ✅ Pass (87.1%) | +28.50% ✅ | +0.00% ➖ / +85.49% ✅ / N/A | +42.74% ✅ | 13241.29 | 418 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob031_dff | ✅ Pass (96.7%) | ✅ Pass (96.2%) | +33.25% ✅ | +0.00% ➖ / +99.74% ✅ / N/A | +49.87% ✅ | 41154.48 | 296 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob031_dff | ✅ Pass (93.3%) | ✅ Pass (93.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3245.98 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob031_dff | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3608.85 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob031_dff | ✅ Pass (88.6%) | ✅ Pass (85.7%) | +33.25% ✅ | +0.00% ➖ / +99.74% ✅ / N/A | +49.87% ✅ | 4898.99 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob032_vector0 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 43411.43 | 299 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob032_vector0 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3286.79 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob032_vector0 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3721.23 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob032_vector0 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 5261.72 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob033_ece241_2014_q1c | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +40.74% ✅ | +23.08% ✅ / +99.16% ✅ / N/A | +61.12% ✅ | 46869.16 | 287 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob033_ece241_2014_q1c | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +21.85% ✅ | +28.85% ✅ / +36.71% ✅ / N/A | +32.78% ✅ | 3802.07 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob033_ece241_2014_q1c | ✅ Pass (88.6%) | ✅ Pass (88.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 7274.93 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob033_ece241_2014_q1c | ✅ Pass (91.4%) | ✅ Pass (91.4%) | +42.07% ✅ | +26.92% ✅ / +99.29% ✅ / N/A | +63.11% ✅ | 7631.06 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob034_dff8 | ✅ Pass (35.7%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 78798.80 | 298 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob034_dff8 | ✅ Pass (64.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 3560.31 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob034_dff8 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4345.25 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob034_dff8 | ✅ Pass (39.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5743.21 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob035_count1to10 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +4.67% ✅ | +0.00% ➖ / +14.00% ✅ / +0.00% ➖ | +4.67% ✅ | 48085.81 | 299 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob035_count1to10 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +5.91% ✅ | +17.07% ✅ / +8.35% ✅ / -7.69% ❌ | +5.91% ✅ | 3695.58 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob035_count1to10 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +5.91% ✅ | +17.07% ✅ / +8.35% ✅ / -7.69% ❌ | +5.91% ✅ | 6311.68 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob035_count1to10 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +10.42% ✅ | +17.07% ✅ / +25.73% ✅ / -11.54% ❌ | +10.42% ✅ | 6599.52 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob036_ringer | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 43938.30 | 301 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob036_ringer | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3693.11 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob036_ringer | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3721.51 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob036_ringer | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 5122.14 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob037_review2015_count1k | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 48186.44 | 300 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob037_review2015_count1k | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +0.94% ✅ | -8.60% ❌ / +0.91% ✅ / +10.53% ✅ | +0.94% ✅ | 3748.29 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob037_review2015_count1k | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5175.29 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob037_review2015_count1k | ✅ Pass (93.3%) | ✅ Pass (93.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 7568.90 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob038_count15 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +1.15% ✅ | -3.33% ❌ / -1.20% ❌ / +8.00% ✅ | +1.15% ✅ | 44129.83 | 298 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob038_count15 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +1.15% ✅ | -3.33% ❌ / -1.20% ❌ / +8.00% ✅ | +1.15% ✅ | 3561.59 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob038_count15 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +0.72% ✅ | -6.67% ❌ / +4.82% ✅ / +4.00% ✅ | +0.72% ✅ | 4302.85 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob038_count15 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +1.15% ✅ | -3.33% ❌ / -1.20% ❌ / +8.00% ✅ | +1.15% ✅ | 6284.55 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob039_always_if | ✅ Pass (93.8%) | ✅ Pass (92.9%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 41479.78 | 286 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob039_always_if | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3498.31 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob039_always_if | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4206.71 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob039_always_if | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 5388.75 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob040_count10 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +1.45% ✅ | +2.56% ✅ / -5.91% ❌ / +7.69% ✅ | +1.45% ✅ | 45850.02 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob040_count10 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +7.36% ✅ | +17.95% ✅ / +11.83% ✅ / -7.69% ❌ | +7.36% ✅ | 3659.60 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob040_count10 | ✅ Pass (99.0%) | ✅ Pass (98.6%) | +7.36% ✅ | +17.95% ✅ / +11.83% ✅ / -7.69% ❌ | +7.36% ✅ | 5802.04 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob040_count10 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +7.36% ✅ | +17.95% ✅ / +11.83% ✅ / -7.69% ❌ | +7.36% ✅ | 6045.36 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob041_dff8r | ✅ Pass (97.6%) | ✅ Pass (96.2%) | +38.51% ✅ | +15.79% ✅ / +99.74% ✅ / N/A | +57.76% ✅ | 40023.56 | 280 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob041_dff8r | ✅ Pass (100.0%) | ✅ Pass (100.0%) | +29.68% ✅ | -10.53% ❌ / +99.57% ✅ / N/A | +44.52% ✅ | 3393.40 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob041_dff8r | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +29.68% ✅ | -10.53% ❌ / +99.57% ✅ / N/A | +44.52% ✅ | 4406.74 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob041_dff8r | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +33.20% ✅ | +0.00% ➖ / +99.61% ✅ / N/A | +49.81% ✅ | 5211.15 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob042_vector4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 36799.29 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob042_vector4 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 3293.54 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob042_vector4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3801.63 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob042_vector4 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 4470.59 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob043_vector5 | ✅ Pass (84.3%) | ✅ Pass (83.3%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 57739.30 | 289 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob043_vector5 | ✅ Pass (85.7%) | ✅ Pass (85.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4766.65 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob043_vector5 | ✅ Pass (81.9%) | ✅ Pass (81.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 9574.16 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob043_vector5 | ✅ Pass (81.4%) | ✅ Pass (81.4%) | +26.04% ✅ | -20.51% ❌ / +98.64% ✅ / N/A | +39.06% ✅ | 8734.72 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob044_vectorgates | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +32.96% ✅ | +0.00% ➖ / +98.88% ✅ / N/A | +49.44% ✅ | 40122.45 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob044_vectorgates | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3678.43 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob044_vectorgates | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4053.26 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob044_vectorgates | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.96% ✅ | +0.00% ➖ / +98.88% ✅ / N/A | +49.44% ✅ | 5330.56 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob045_edgedetect2 | ✅ Pass (64.3%) | ✅ Pass (64.3%) | +12.40% ✅ | +0.00% ➖ / +7.80% ✅ / +29.41% ✅ | +12.40% ✅ | 50830.54 | 300 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob045_edgedetect2 | ✅ Pass (34.3%) | ✅ Pass (31.9%) | +12.40% ✅ | +0.00% ➖ / +7.80% ✅ / +29.41% ✅ | +12.40% ✅ | 4004.96 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob045_edgedetect2 | ✅ Pass (61.5%) | ✅ Pass (56.2%) | +12.40% ✅ | +0.00% ➖ / +7.80% ✅ / +29.41% ✅ | +12.40% ✅ | 6826.60 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob045_edgedetect2 | ✅ Pass (45.2%) | ✅ Pass (44.3%) | +12.40% ✅ | +0.00% ➖ / +7.80% ✅ / +29.41% ✅ | +12.40% ✅ | 6395.07 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob046_dff8p | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +33.24% ✅ | +0.00% ➖ / +99.71% ✅ / N/A | +49.85% ✅ | 39318.71 | 297 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob046_dff8p | ✅ Pass (96.2%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3708.62 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob046_dff8p | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4197.43 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob046_dff8p | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +33.24% ✅ | +0.00% ➖ / +99.71% ✅ / N/A | +49.85% ✅ | 5409.75 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob047_dff8ar | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +30.15% ✅ | -9.30% ❌ / +99.75% ✅ / N/A | +45.22% ✅ | 37035.92 | 285 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob047_dff8ar | ✅ Pass (98.1%) | ✅ Pass (97.6%) | +33.26% ✅ | +0.00% ➖ / +99.77% ✅ / N/A | +49.89% ✅ | 3689.97 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob047_dff8ar | ✅ Pass (98.6%) | ✅ Pass (97.6%) | +28.58% ✅ | -13.95% ❌ / +99.71% ✅ / N/A | +42.88% ✅ | 4611.91 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob047_dff8ar | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +33.26% ✅ | +0.00% ➖ / +99.77% ✅ / N/A | +49.89% ✅ | 5036.69 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob048_m2014_q4c | ✅ Pass (97.6%) | ✅ Pass (96.7%) | +33.23% ✅ | +0.00% ➖ / +99.68% ✅ / N/A | +49.84% ✅ | 36598.10 | 297 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob048_m2014_q4c | ✅ Pass (91.9%) | ✅ Pass (91.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3571.89 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob048_m2014_q4c | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3509.59 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob048_m2014_q4c | ✅ Pass (90.5%) | ✅ Pass (90.0%) | +33.23% ✅ | +0.00% ➖ / +99.68% ✅ / N/A | +49.84% ✅ | 5286.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob049_m2014_q4b | ✅ Pass (91.0%) | ✅ Pass (88.1%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.88% ✅ | 39287.77 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob049_m2014_q4b | ✅ Pass (91.4%) | ✅ Pass (88.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3694.42 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob049_m2014_q4b | ✅ Pass (97.6%) | ✅ Pass (93.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4289.33 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob049_m2014_q4b | ✅ Pass (88.1%) | ✅ Pass (85.7%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.88% ✅ | 5341.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob050_kmap1 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.96% ✅ | +0.00% ➖ / +98.87% ✅ / N/A | +49.44% ✅ | 34536.71 | 296 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob050_kmap1 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3749.62 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob050_kmap1 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4132.98 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob050_kmap1 | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +32.96% ✅ | +0.00% ➖ / +98.87% ✅ / N/A | +49.44% ✅ | 5147.61 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob051_gates4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +34.99% ✅ | +6.25% ✅ / +98.73% ✅ / N/A | +52.49% ✅ | 36197.84 | 293 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob051_gates4 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3835.13 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob051_gates4 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4560.34 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob051_gates4 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +33.65% ✅ | +50.00% ✅ / +50.94% ✅ / N/A | +50.47% ✅ | 5934.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob052_gates100 | ✅ Pass (93.8%) | ✅ Pass (86.7%) | +24.56% ✅ | +42.66% ✅ / +31.02% ✅ / N/A | +36.84% ✅ | 43772.53 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob052_gates100 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +24.56% ✅ | +42.66% ✅ / +31.02% ✅ / N/A | +36.84% ✅ | 4255.29 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob052_gates100 | ✅ Pass (96.7%) | ✅ Pass (96.2%) | +24.36% ✅ | +42.44% ✅ / +30.66% ✅ / N/A | +36.55% ✅ | 4683.45 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob052_gates100 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +36.80% ✅ | +11.74% ✅ / +98.67% ✅ / N/A | +55.20% ✅ | 7443.46 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob053_m2014_q4d | ✅ Pass (51.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 71968.26 | 307 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob053_m2014_q4d | ✅ Pass (89.5%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 3510.26 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob053_m2014_q4d | ✅ Pass (18.6%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5193.41 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob053_m2014_q4d | ✅ Pass (51.4%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5065.47 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob054_edgedetect | ✅ Pass (67.1%) | ✅ Pass (67.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 47586.62 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob054_edgedetect | ✅ Pass (60.5%) | ✅ Pass (56.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4436.29 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob054_edgedetect | ✅ Pass (71.9%) | ✅ Pass (65.2%) | +7.08% ✅ | +0.00% ➖ / +6.94% ✅ / +14.29% ✅ | +7.08% ✅ | 7103.00 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob054_edgedetect | ✅ Pass (51.4%) | ✅ Pass (51.0%) | +7.08% ✅ | +0.00% ➖ / +6.94% ✅ / +14.29% ✅ | +7.08% ✅ | 7112.14 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob055_conditional | ✅ Pass (97.6%) | ✅ Pass (96.7%) | +37.88% ✅ | +14.40% ✅ / +99.24% ✅ / N/A | +56.82% ✅ | 38180.62 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob055_conditional | ✅ Pass (99.5%) | ✅ Pass (99.0%) | +18.19% ✅ | +19.75% ✅ / +34.83% ✅ / N/A | +27.29% ✅ | 4073.39 | 211 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob055_conditional | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +23.31% ✅ | +25.10% ✅ / +44.83% ✅ / N/A | +34.97% ✅ | 5977.37 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob055_conditional | ✅ Pass (97.6%) | ✅ Pass (96.7%) | +41.49% ✅ | +25.10% ✅ / +99.38% ✅ / N/A | +62.24% ✅ | 6191.01 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob056_ece241_2013_q7 | ✅ Pass (100.0%) | ✅ Pass (47.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 49916.58 | 301 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob056_ece241_2013_q7 | ✅ Pass (98.6%) | ✅ Pass (49.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4461.04 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob056_ece241_2013_q7 | ✅ Pass (95.7%) | ✅ Pass (53.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6852.51 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob056_ece241_2013_q7 | ✅ Pass (97.1%) | ✅ Pass (43.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6505.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob057_kmap2 | ✅ Pass (85.7%) | ✅ Pass (85.7%) | +44.24% ✅ | +33.33% ✅ / +99.38% ✅ / N/A | +66.35% ✅ | 70365.36 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob057_kmap2 | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +25.20% ✅ | +33.33% ✅ / +42.26% ✅ / N/A | +37.80% ✅ | 8413.21 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob057_kmap2 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +25.20% ✅ | +33.33% ✅ / +42.26% ✅ / N/A | +37.80% ✅ | 19637.37 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob057_kmap2 | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +25.20% ✅ | +33.33% ✅ / +42.26% ✅ / N/A | +37.80% ✅ | 13586.49 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob058_alwaysblock2 | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +33.16% ✅ | +0.00% ➖ / +99.49% ✅ / N/A | +49.74% ✅ | 37353.62 | 301 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob058_alwaysblock2 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3902.17 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob058_alwaysblock2 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5289.92 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob058_alwaysblock2 | ✅ Pass (92.9%) | ✅ Pass (92.4%) | +33.16% ✅ | +0.00% ➖ / +99.49% ✅ / N/A | +49.74% ✅ | 5682.31 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob059_wire4 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 32855.86 | 289 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob059_wire4 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3614.86 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob059_wire4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3588.39 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob059_wire4 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 4582.48 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob060_m2014_q4k | ✅ Pass (95.2%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 38258.50 | 298 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob060_m2014_q4k | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 3977.04 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob060_m2014_q4k | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4961.09 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob060_m2014_q4k | ✅ Pass (91.4%) | ✅ Pass (91.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5317.43 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob061_2014_q4a | ✅ Pass (95.7%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 34180.19 | 289 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob061_2014_q4a | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 3747.79 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob061_2014_q4a | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4261.23 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob061_2014_q4a | ✅ Pass (91.9%) | ✅ Pass (91.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5222.43 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob062_bugs_mux2 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 57130.80 | 297 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob062_bugs_mux2 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4039.51 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob062_bugs_mux2 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 3694.60 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob062_bugs_mux2 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8021.59 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob063_review2015_shiftcount | ✅ Pass (64.8%) | ✅ Pass (64.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 39648.46 | 276 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob063_review2015_shiftcount | ✅ Pass (63.3%) | ✅ Pass (62.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4141.99 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob063_review2015_shiftcount | ✅ Pass (81.4%) | ✅ Pass (81.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6010.68 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob063_review2015_shiftcount | ✅ Pass (75.2%) | ✅ Pass (75.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 7314.03 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob064_vector3 | ✅ Pass (89.0%) | ✅ Pass (89.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 39177.30 | 286 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob064_vector3 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4241.18 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob064_vector3 | ✅ Pass (93.3%) | ✅ Pass (93.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5812.45 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob064_vector3 | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +32.96% ✅ | +0.00% ➖ / +98.89% ✅ / N/A | +49.45% ✅ | 6766.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob065_7420 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.95% ✅ | +0.00% ➖ / +98.86% ✅ / N/A | +49.43% ✅ | 34667.42 | 286 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob065_7420 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3801.86 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob065_7420 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +32.95% ✅ | +0.00% ➖ / +98.86% ✅ / N/A | +49.43% ✅ | 4789.47 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob065_7420 | ✅ Pass (91.9%) | ✅ Pass (91.4%) | +32.95% ✅ | +0.00% ➖ / +98.86% ✅ / N/A | +49.43% ✅ | 5817.46 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob066_edgecapture | ✅ Pass (25.2%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 63595.42 | 287 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob066_edgecapture | ✅ Pass (48.6%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4727.24 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob066_edgecapture | ✅ Pass (48.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8068.58 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob066_edgecapture | ✅ Pass (26.2%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8833.13 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob067_countslow | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +11.27% ✅ | +19.15% ✅ / +1.34% ✅ / +13.33% ✅ | +11.27% ✅ | 39509.63 | 302 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob067_countslow | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +10.67% ✅ | +12.77% ✅ / +5.90% ✅ / +13.33% ✅ | +10.67% ✅ | 4163.02 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob067_countslow | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +5.68% ✅ | +14.89% ✅ / +2.14% ✅ / +0.00% ➖ | +5.68% ✅ | 5683.31 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob067_countslow | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +4.25% ✅ | +0.00% ➖ / -7.24% ❌ / +20.00% ✅ | +4.25% ✅ | 6658.52 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob068_countbcd | ✅ Pass (78.6%) | ✅ Pass (75.2%) | +14.25% ✅ | +6.11% ✅ / +17.12% ✅ / +19.51% ✅ | +14.25% ✅ | 73674.57 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob068_countbcd | ✅ Pass (69.0%) | ✅ Pass (60.5%) | +8.92% ✅ | +0.56% ✅ / +16.44% ✅ / +9.76% ✅ | +8.92% ✅ | 5808.13 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob068_countbcd | ✅ Pass (80.5%) | ✅ Pass (75.7%) | +8.92% ✅ | +0.56% ✅ / +16.44% ✅ / +9.76% ✅ | +8.92% ✅ | 13582.56 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob068_countbcd | ✅ Pass (66.7%) | ✅ Pass (59.5%) | +8.92% ✅ | +0.56% ✅ / +16.44% ✅ / +9.76% ✅ | +8.92% ✅ | 12749.43 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob069_truthtable1 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 36580.83 | 293 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob069_truthtable1 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 4554.14 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob069_truthtable1 | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5725.96 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob069_truthtable1 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 6627.53 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob070_ece241_2013_q2 | ✅ Pass (75.2%) | ✅ Pass (75.2%) | +33.00% ✅ | +0.00% ➖ / +98.99% ✅ / N/A | +49.49% ✅ | 69417.17 | 285 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob070_ece241_2013_q2 | ✅ Pass (90.0%) | ✅ Pass (90.0%) | +2.06% ✅ | +0.00% ➖ / +6.19% ✅ / N/A | +3.09% ✅ | 5835.48 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob070_ece241_2013_q2 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +2.06% ✅ | +0.00% ➖ / +6.19% ✅ / N/A | +3.09% ✅ | 10688.26 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob070_ece241_2013_q2 | ✅ Pass (85.2%) | ✅ Pass (85.2%) | +33.00% ✅ | +0.00% ➖ / +98.99% ✅ / N/A | +49.49% ✅ | 14864.34 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob071_always_casez | ✅ Pass (78.6%) | ✅ Pass (68.6%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 45891.12 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob071_always_casez | ✅ Pass (90.5%) | ✅ Pass (83.3%) | +6.81% ✅ | +0.00% ➖ / +20.43% ✅ / N/A | +10.22% ✅ | 4563.76 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob071_always_casez | ✅ Pass (92.3%) | ✅ Pass (86.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 8798.70 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob071_always_casez | ✅ Pass (90.5%) | ✅ Pass (82.4%) | +33.04% ✅ | +0.00% ➖ / +99.13% ✅ / N/A | +49.56% ✅ | 7689.50 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob072_thermostat | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 39586.36 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob072_thermostat | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +0.22% ✅ | +0.00% ➖ / +0.65% ✅ / N/A | +0.32% ✅ | 4135.01 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob072_thermostat | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +0.22% ✅ | +0.00% ➖ / +0.65% ✅ / N/A | +0.32% ✅ | 5162.90 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob072_thermostat | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 5941.29 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob073_dff16e | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 41279.66 | 290 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob073_dff16e | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4187.76 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob073_dff16e | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5579.07 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob073_dff16e | ✅ Pass (98.1%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6047.17 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob074_ece241_2014_q4 | ✅ Pass (34.3%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 98717.00 | 297 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob074_ece241_2014_q4 | ✅ Pass (48.6%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6099.21 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob074_ece241_2014_q4 | ✅ Pass (53.1%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8697.62 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob074_ece241_2014_q4 | ✅ Pass (50.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 7700.44 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob075_counter_2bc | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +36.08% ✅ | +33.33% ✅ / +54.90% ✅ / +20.00% ✅ | +36.08% ✅ | 45001.19 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob075_counter_2bc | ✅ Pass (99.5%) | ✅ Pass (99.0%) | +36.08% ✅ | +33.33% ✅ / +54.90% ✅ / +20.00% ✅ | +36.08% ✅ | 4616.53 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob075_counter_2bc | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +36.08% ✅ | +33.33% ✅ / +54.90% ✅ / +20.00% ✅ | +36.08% ✅ | 6708.38 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob075_counter_2bc | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +36.08% ✅ | +33.33% ✅ / +54.90% ✅ / +20.00% ✅ | +36.08% ✅ | 7348.25 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob076_always_case | ✅ Pass (90.0%) | ✅ Pass (90.0%) | +3.14% ✅ | +4.55% ✅ / +4.86% ✅ / N/A | +4.71% ✅ | 43781.91 | 291 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob076_always_case | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +2.53% ✅ | +11.36% ✅ / -3.78% ❌ / N/A | +3.79% ✅ | 4496.21 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob076_always_case | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +2.53% ✅ | +11.36% ✅ / -3.78% ❌ / N/A | +3.79% ✅ | 6848.84 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob076_always_case | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +32.23% ✅ | -2.27% ❌ / +98.96% ✅ / N/A | +48.34% ✅ | 6466.90 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob077_wire_decl | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 32372.96 | 268 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob077_wire_decl | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4266.93 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob077_wire_decl | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4330.32 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob077_wire_decl | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.47% ✅ | 5180.18 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob078_dualedge | ✅ Pass (91.9%) | ✅ Pass (91.4%) | +33.27% ✅ | +0.00% ➖ / +99.80% ✅ / N/A | +49.90% ✅ | 44509.97 | 285 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob078_dualedge | ✅ Pass (80.5%) | ✅ Pass (72.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5305.42 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob078_dualedge | ✅ Pass (95.7%) | ✅ Pass (93.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 7737.09 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob078_dualedge | ✅ Pass (67.1%) | ✅ Pass (64.3%) | +33.27% ✅ | +0.00% ➖ / +99.80% ✅ / N/A | +49.90% ✅ | 10609.19 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob079_fsm3onehot | ✅ Pass (89.5%) | ✅ Pass (89.0%) | +17.03% ✅ | +12.50% ✅ / +38.59% ✅ / N/A | +25.55% ✅ | 50385.40 | 301 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob079_fsm3onehot | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +23.77% ✅ | +25.00% ✅ / +46.31% ✅ / N/A | +35.65% ✅ | 5427.51 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob079_fsm3onehot | ✅ Pass (92.9%) | ✅ Pass (92.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 9205.45 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob079_fsm3onehot | ✅ Pass (93.8%) | ✅ Pass (93.8%) | +17.03% ✅ | +12.50% ✅ / +38.59% ✅ / N/A | +25.55% ✅ | 7854.31 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob080_timer | ✅ Pass (92.4%) | ✅ Pass (92.4%) | +3.64% ✅ | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | +3.64% ✅ | 43734.63 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob080_timer | ✅ Pass (92.4%) | ✅ Pass (92.4%) | +3.64% ✅ | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | +3.64% ✅ | 4745.35 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob080_timer | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +3.64% ✅ | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | +3.64% ✅ | 6341.08 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob080_timer | ✅ Pass (68.1%) | ✅ Pass (68.1%) | +3.64% ✅ | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | +3.64% ✅ | 7396.71 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob081_7458 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.46% ✅ | 45929.71 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob081_7458 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4596.39 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob081_7458 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5090.02 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob081_7458 | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.46% ✅ | 6066.60 | 421 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob082_lfsr32 | ✅ Pass (82.9%) | ✅ Pass (80.5%) | +4.00% ✅ | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | +4.00% ✅ | 60987.62 | 298 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob082_lfsr32 | ✅ Pass (81.9%) | ✅ Pass (81.9%) | +4.00% ✅ | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | +4.00% ✅ | 7547.47 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob082_lfsr32 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +4.00% ✅ | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | +4.00% ✅ | 9458.05 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob082_lfsr32 | ✅ Pass (75.2%) | ✅ Pass (75.2%) | +4.00% ✅ | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | +4.00% ✅ | 10725.87 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob083_mt2015_q4b | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 34780.36 | 286 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob083_mt2015_q4b | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4160.65 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob083_mt2015_q4b | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3921.67 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob083_mt2015_q4b | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 4848.19 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob084_ece241_2013_q12 | ✅ Pass (85.2%) | ✅ Pass (85.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 52039.08 | 282 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob084_ece241_2013_q12 | ✅ Pass (90.5%) | ✅ Pass (88.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4974.12 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob084_ece241_2013_q12 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 7771.53 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob084_ece241_2013_q12 | ✅ Pass (82.9%) | ✅ Pass (82.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 7183.36 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob085_shift4 | ✅ Pass (94.3%) | ✅ Pass (92.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 43908.56 | 289 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob085_shift4 | ✅ Pass (99.5%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4482.55 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob085_shift4 | ✅ Pass (99.0%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5241.05 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob085_shift4 | ✅ Pass (93.8%) | ✅ Pass (93.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 7013.10 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob086_lfsr5 | ✅ Pass (85.7%) | ✅ Pass (83.8%) | +5.28% ✅ | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | +5.28% ✅ | 48781.01 | 284 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob086_lfsr5 | ✅ Pass (89.5%) | ✅ Pass (89.5%) | +5.28% ✅ | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | +5.28% ✅ | 5055.37 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob086_lfsr5 | ✅ Pass (93.3%) | ✅ Pass (93.3%) | +5.28% ✅ | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | +5.28% ✅ | 6917.02 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob086_lfsr5 | ✅ Pass (85.7%) | ✅ Pass (85.7%) | +5.28% ✅ | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | +5.28% ✅ | 8421.58 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob087_gates | ✅ Pass (95.7%) | ✅ Pass (95.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 45452.57 | 291 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob087_gates | ✅ Pass (96.7%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4786.32 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob087_gates | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5214.14 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob087_gates | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 6489.43 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob088_ece241_2014_q5b | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +2.79% ✅ | +10.00% ✅ / +5.03% ✅ / -6.67% ❌ | +2.79% ✅ | 48109.39 | 278 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob088_ece241_2014_q5b | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +4.94% ✅ | +10.00% ✅ / +4.81% ✅ / +0.00% ➖ | +4.94% ✅ | 5261.77 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob088_ece241_2014_q5b | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +2.65% ✅ | +10.00% ✅ / -2.06% ❌ / +0.00% ➖ | +2.65% ✅ | 7248.43 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob088_ece241_2014_q5b | ✅ Pass (92.4%) | ✅ Pass (92.4%) | +2.65% ✅ | +10.00% ✅ / -2.06% ❌ / +0.00% ➖ | +2.65% ✅ | 7104.08 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob089_ece241_2014_q5a | ✅ Pass (71.0%) | ✅ Pass (71.0%) | +41.25% ✅ | +34.78% ✅ / +66.24% ✅ / +22.73% ✅ | +41.25% ✅ | 58132.05 | 288 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob089_ece241_2014_q5a | ✅ Pass (52.4%) | ✅ Pass (52.4%) | +45.93% ✅ | +39.13% ✅ / +66.83% ✅ / +31.82% ✅ | +45.93% ✅ | 5522.03 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob089_ece241_2014_q5a | ✅ Pass (86.7%) | ✅ Pass (86.7%) | +41.25% ✅ | +34.78% ✅ / +66.24% ✅ / +22.73% ✅ | +41.25% ✅ | 10433.84 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob089_ece241_2014_q5a | ✅ Pass (73.8%) | ✅ Pass (73.8%) | +41.25% ✅ | +34.78% ✅ / +66.24% ✅ / +22.73% ✅ | +41.25% ✅ | 9101.69 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob090_circuit1 | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +32.96% ✅ | +0.00% ➖ / +98.89% ✅ / N/A | +49.45% ✅ | 37407.28 | 298 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob090_circuit1 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4304.67 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob090_circuit1 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 2847.21 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob090_circuit1 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +32.96% ✅ | +0.00% ➖ / +98.89% ✅ / N/A | +49.45% ✅ | 4371.46 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob091_2012_q2b | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +41.37% ✅ | +25.00% ✅ / +99.12% ✅ / N/A | +62.06% ✅ | 53466.01 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob091_2012_q2b | ✅ Pass (94.8%) | ✅ Pass (94.3%) | +16.19% ✅ | +25.00% ✅ / +23.56% ✅ / N/A | +24.28% ✅ | 5247.68 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob091_2012_q2b | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +16.19% ✅ | +25.00% ✅ / +23.56% ✅ / N/A | +24.28% ✅ | 8405.42 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob091_2012_q2b | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +41.37% ✅ | +25.00% ✅ / +99.12% ✅ / N/A | +62.06% ✅ | 8825.10 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob092_gatesv100 | ✅ Pass (79.5%) | ✅ Pass (79.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 56533.17 | 302 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob092_gatesv100 | ✅ Pass (55.7%) | ✅ Pass (55.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5446.85 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob092_gatesv100 | ✅ Pass (78.6%) | ✅ Pass (78.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 9684.72 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob092_gatesv100 | ✅ Pass (45.7%) | ✅ Pass (45.7%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 10081.33 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob093_ece241_2014_q3 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 85972.58 | 293 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob093_ece241_2014_q3 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6656.46 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob093_ece241_2014_q3 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12477.89 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob093_ece241_2014_q3 | ✅ Pass (5.2%) | ✅ Pass (5.2%) | +7.58% ✅ | -75.00% ❌ / +97.74% ✅ / N/A | +11.37% ✅ | 14295.45 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob094_gatesv | ✅ Pass (90.0%) | ✅ Pass (90.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 52762.80 | 296 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob094_gatesv | ✅ Pass (68.1%) | ✅ Pass (68.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5241.61 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob094_gatesv | ✅ Pass (86.2%) | ✅ Pass (86.2%) | +1.44% ✅ | +0.00% ➖ / +4.32% ✅ / N/A | +2.16% ✅ | 8261.76 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob094_gatesv | ✅ Pass (85.2%) | ✅ Pass (85.2%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 9230.33 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob095_review2015_fsmshift | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 66557.91 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob095_review2015_fsmshift | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6079.30 | 211 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob095_review2015_fsmshift | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 11014.37 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob095_review2015_fsmshift | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 9507.77 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob096_review2015_fsmseq | ✅ Pass (63.3%) | ✅ Pass (63.3%) | +15.82% ✅ | +18.18% ✅ / +24.02% ✅ / +5.26% ✅ | +15.82% ✅ | 56143.61 | 285 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob096_review2015_fsmseq | ✅ Pass (76.7%) | ✅ Pass (76.7%) | +15.82% ✅ | +18.18% ✅ / +24.02% ✅ / +5.26% ✅ | +15.82% ✅ | 5500.83 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob096_review2015_fsmseq | ✅ Pass (79.0%) | ✅ Pass (79.0%) | +15.82% ✅ | +18.18% ✅ / +24.02% ✅ / +5.26% ✅ | +15.82% ✅ | 10236.83 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob096_review2015_fsmseq | ✅ Pass (73.8%) | ✅ Pass (72.4%) | +15.82% ✅ | +18.18% ✅ / +24.02% ✅ / +5.26% ✅ | +15.82% ✅ | 9570.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob097_mux9to1v | ✅ Pass (90.5%) | ✅ Pass (89.5%) | +10.25% ✅ | +15.99% ✅ / +14.75% ✅ / N/A | +15.37% ✅ | 51026.59 | 293 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob097_mux9to1v | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +10.25% ✅ | +15.99% ✅ / +14.75% ✅ / N/A | +15.37% ✅ | 4895.59 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob097_mux9to1v | ✅ Pass (93.8%) | ✅ Pass (93.3%) | +10.25% ✅ | +15.99% ✅ / +14.75% ✅ / N/A | +15.37% ✅ | 7123.37 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob097_mux9to1v | ✅ Pass (97.6%) | ✅ Pass (97.6%) | +34.50% ✅ | +4.46% ✅ / +99.04% ✅ / N/A | +51.75% ✅ | 6742.64 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (68.1%) | ✅ Pass (68.1%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 65722.79 | 280 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (91.0%) | ✅ Pass (91.0%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 5682.58 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (56.7%) | ✅ Pass (55.2%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 12381.99 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (72.4%) | ✅ Pass (71.9%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 13531.64 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob099_m2014_q6c | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 45344.92 | 284 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob099_m2014_q6c | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 4943.94 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob099_m2014_q6c | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8952.70 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob099_m2014_q6c | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6533.83 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob100_fsm3comb | ✅ Pass (84.3%) | ✅ Pass (84.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 58774.40 | 306 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob100_fsm3comb | ✅ Pass (94.3%) | ✅ Pass (94.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5358.94 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob100_fsm3comb | ✅ Pass (92.8%) | ✅ Pass (92.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 10585.59 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob100_fsm3comb | ✅ Pass (88.1%) | ✅ Pass (86.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 8185.40 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob101_circuit4 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 41178.13 | 289 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob101_circuit4 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4479.12 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob101_circuit4 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4558.64 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob101_circuit4 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.97% ✅ | +0.00% ➖ / +98.90% ✅ / N/A | +49.45% ✅ | 5985.15 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob102_circuit3 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.46% ✅ | 47836.47 | 298 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob102_circuit3 | ✅ Pass (96.2%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4758.42 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob102_circuit3 | ✅ Pass (99.0%) | ✅ Pass (99.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 6188.30 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob102_circuit3 | ✅ Pass (96.7%) | ✅ Pass (96.7%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.46% ✅ | 8024.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob103_circuit2 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 47213.39 | 297 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob103_circuit2 | ✅ Pass (99.0%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4689.77 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob103_circuit2 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5263.93 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob103_circuit2 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 6718.95 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob104_mt2015_muxdff | ✅ Pass (22.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 84074.63 | 287 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob104_mt2015_muxdff | ✅ Pass (21.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 5148.27 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob104_mt2015_muxdff | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6571.61 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob104_mt2015_muxdff | ✅ Pass (16.7%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8512.81 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob105_rotate100 | ✅ Pass (95.7%) | ✅ Pass (92.9%) | +8.90% ✅ | +6.87% ✅ / +6.18% ✅ / +13.64% ✅ | +8.90% ✅ | 52439.46 | 296 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob105_rotate100 | ✅ Pass (98.6%) | ✅ Pass (97.6%) | +4.16% ✅ | +6.58% ✅ / +5.88% ✅ / +0.00% ➖ | +4.16% ✅ | 6846.78 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob105_rotate100 | ✅ Pass (88.5%) | ✅ Pass (88.5%) | +8.90% ✅ | +6.87% ✅ / +6.18% ✅ / +13.64% ✅ | +8.90% ✅ | 6942.85 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob105_rotate100 | ✅ Pass (81.0%) | ✅ Pass (81.0%) | +4.16% ✅ | +6.58% ✅ / +5.88% ✅ / +0.00% ➖ | +4.16% ✅ | 10209.12 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob106_always_nolatches | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +39.72% ✅ | +20.00% ✅ / +99.17% ✅ / N/A | +59.59% ✅ | 48051.11 | 288 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob106_always_nolatches | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +19.24% ✅ | +20.00% ✅ / +37.73% ✅ / N/A | +28.86% ✅ | 5253.51 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob106_always_nolatches | ✅ Pass (96.2%) | ✅ Pass (95.2%) | +16.29% ✅ | +20.00% ✅ / +28.88% ✅ / N/A | +24.44% ✅ | 6304.56 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob106_always_nolatches | ✅ Pass (96.2%) | ✅ Pass (96.2%) | +29.86% ✅ | +36.67% ✅ / +52.92% ✅ / N/A | +44.79% ✅ | 5642.21 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob107_fsm1s | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +1.78% ✅ | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | +1.78% ✅ | 46062.02 | 282 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob107_fsm1s | ✅ Pass (98.1%) | ✅ Pass (98.1%) | +1.78% ✅ | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | +1.78% ✅ | 4710.41 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob107_fsm1s | ✅ Pass (99.0%) | ✅ Pass (99.0%) | +1.78% ✅ | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | +1.78% ✅ | 6478.63 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob107_fsm1s | ✅ Pass (90.5%) | ✅ Pass (90.5%) | +1.78% ✅ | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | +1.78% ✅ | 6097.00 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob108_rule90 | ✅ Pass (89.0%) | ✅ Pass (4.3%) | -7.66% ❌ | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | -7.66% ❌ | 131431.35 | 289 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob108_rule90 | ✅ Pass (97.1%) | ✅ Pass (1.4%) | -7.66% ❌ | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | -7.66% ❌ | 62398.86 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob108_rule90 | ✅ Pass (97.1%) | ✅ Pass (1.0%) | -7.66% ❌ | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | -7.66% ❌ | 63572.36 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob108_rule90 | ✅ Pass (94.3%) | ✅ Pass (3.8%) | -7.66% ❌ | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | -7.66% ❌ | 61236.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob109_fsm1 | ✅ Pass (93.3%) | ✅ Pass (93.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 46279.82 | 280 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob109_fsm1 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4754.13 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob109_fsm1 | ✅ Pass (100.0%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5802.79 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob109_fsm1 | ✅ Pass (89.5%) | ✅ Pass (89.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5911.54 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob110_fsm2 | ✅ Pass (91.4%) | ✅ Pass (91.4%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 44468.19 | 283 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob110_fsm2 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4644.84 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob110_fsm2 | ✅ Pass (98.1%) | ✅ Pass (97.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5271.59 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob110_fsm2 | ✅ Pass (88.6%) | ✅ Pass (88.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5535.04 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob111_fsm2s | ✅ Pass (91.9%) | ✅ Pass (91.9%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 45734.28 | 288 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob111_fsm2s | ✅ Pass (98.6%) | ✅ Pass (98.6%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4715.83 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob111_fsm2s | ✅ Pass (94.8%) | ✅ Pass (94.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 5370.37 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob111_fsm2s | ✅ Pass (89.5%) | ✅ Pass (89.5%) | +0.40% ✅ | +0.00% ➖ / -3.79% ❌ / +5.00% ✅ | +0.40% ✅ | 5533.37 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob112_always_case2 | ✅ Pass (89.5%) | ✅ Pass (85.2%) | +0.17% ✅ | +0.00% ➖ / +0.52% ✅ / N/A | +0.26% ✅ | 48569.35 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob112_always_case2 | ✅ Pass (93.8%) | ✅ Pass (93.8%) | +0.17% ✅ | +0.00% ➖ / +0.52% ✅ / N/A | +0.26% ✅ | 5230.29 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob112_always_case2 | ✅ Pass (94.3%) | ✅ Pass (92.4%) | +0.17% ✅ | +0.00% ➖ / +0.52% ✅ / N/A | +0.26% ✅ | 7631.12 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob112_always_case2 | ✅ Pass (89.0%) | ✅ Pass (89.0%) | +32.97% ✅ | +0.00% ➖ / +98.92% ✅ / N/A | +49.46% ✅ | 6469.30 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob113_2012_q1g | ✅ Pass (81.9%) | ✅ Pass (81.9%) | +0.16% ✅ | +0.00% ➖ / +0.47% ✅ / N/A | +0.23% ✅ | 92259.65 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob113_2012_q1g | ✅ Pass (81.4%) | ✅ Pass (81.4%) | +0.16% ✅ | +0.00% ➖ / +0.47% ✅ / N/A | +0.23% ✅ | 10026.52 | 211 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob113_2012_q1g | ✅ Pass (89.5%) | ✅ Pass (89.5%) | +0.16% ✅ | +0.00% ➖ / +0.47% ✅ / N/A | +0.23% ✅ | 22471.53 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob113_2012_q1g | ✅ Pass (87.6%) | ✅ Pass (87.6%) | +32.98% ✅ | +0.00% ➖ / +98.93% ✅ / N/A | +49.46% ✅ | 17861.17 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob114_bugs_case | ✅ Pass (91.9%) | ✅ Pass (90.5%) | +12.65% ✅ | +9.43% ✅ / +28.50% ✅ / N/A | +18.97% ✅ | 55050.63 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob114_bugs_case | ✅ Pass (97.6%) | ✅ Pass (97.1%) | +9.41% ✅ | +11.32% ✅ / +16.91% ✅ / N/A | +14.11% ✅ | 4986.36 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob114_bugs_case | ✅ Pass (88.6%) | ✅ Pass (86.7%) | +8.14% ✅ | +9.43% ✅ / +14.98% ✅ / N/A | +12.20% ✅ | 8484.76 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob114_bugs_case | ✅ Pass (92.4%) | ✅ Pass (91.4%) | +9.70% ✅ | +15.09% ✅ / +14.01% ✅ / N/A | +14.55% ✅ | 6708.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob115_shift18 | ✅ Pass (91.0%) | ✅ Pass (90.0%) | +25.49% ✅ | +16.32% ✅ / +27.73% ✅ / +32.43% ✅ | +25.49% ✅ | 53551.04 | 283 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob115_shift18 | ✅ Pass (92.9%) | ✅ Pass (92.4%) | +25.49% ✅ | +16.32% ✅ / +27.73% ✅ / +32.43% ✅ | +25.49% ✅ | 5466.39 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob115_shift18 | ✅ Pass (84.8%) | ✅ Pass (84.8%) | +25.49% ✅ | +16.32% ✅ / +27.73% ✅ / +32.43% ✅ | +25.49% ✅ | 7312.46 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob115_shift18 | ✅ Pass (90.5%) | ✅ Pass (90.5%) | +21.71% ✅ | +16.11% ✅ / +27.41% ✅ / +21.62% ✅ | +21.71% ✅ | 8288.00 | 421 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (57.1%) | ✅ Pass (57.1%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 80199.41 | 286 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (75.2%) | ✅ Pass (74.3%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 7990.72 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (84.3%) | ✅ Pass (84.3%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 19200.41 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (69.5%) | ✅ Pass (69.5%) | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 15645.95 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob117_circuit9 | ✅ Pass (51.4%) | ✅ Pass (51.0%) | +13.77% ✅ | +3.85% ✅ / +37.47% ✅ / +0.00% ➖ | +13.77% ✅ | 70319.82 | 287 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob117_circuit9 | ✅ Pass (80.0%) | ✅ Pass (79.0%) | +14.19% ✅ | +0.00% ➖ / +46.74% ✅ / -4.17% ❌ | +14.19% ✅ | 5668.17 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob117_circuit9 | ✅ Pass (60.5%) | ✅ Pass (60.5%) | +13.77% ✅ | +3.85% ✅ / +37.47% ✅ / +0.00% ➖ | +13.77% ✅ | 9538.49 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob117_circuit9 | ✅ Pass (79.0%) | ✅ Pass (78.1%) | +14.55% ✅ | +3.85% ✅ / +39.79% ✅ / +0.00% ➖ | +14.55% ✅ | 11815.90 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob118_history_shift | ✅ Pass (92.4%) | ✅ Pass (89.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 58127.86 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob118_history_shift | ✅ Pass (97.1%) | ✅ Pass (96.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 4983.65 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob118_history_shift | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6203.71 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob118_history_shift | ✅ Pass (83.8%) | ✅ Pass (83.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 8400.23 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob119_fsm3 | ✅ Pass (78.1%) | ✅ Pass (78.1%) | +2.70% ✅ | +5.88% ✅ / +2.22% ✅ / +0.00% ➖ | +2.70% ✅ | 64818.21 | 284 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob119_fsm3 | ✅ Pass (81.4%) | ✅ Pass (81.4%) | +2.70% ✅ | +5.88% ✅ / +2.22% ✅ / +0.00% ➖ | +2.70% ✅ | 5865.48 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob119_fsm3 | ✅ Pass (79.5%) | ✅ Pass (79.5%) | +2.70% ✅ | +5.88% ✅ / +2.22% ✅ / +0.00% ➖ | +2.70% ✅ | 9185.56 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob119_fsm3 | ✅ Pass (73.3%) | ✅ Pass (73.3%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 7037.99 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob120_fsm3s | ✅ Pass (76.7%) | ✅ Pass (76.7%) | +30.98% ✅ | +37.04% ✅ / +50.35% ✅ / +5.56% ✅ | +30.98% ✅ | 70079.61 | 297 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob120_fsm3s | ✅ Pass (82.4%) | ✅ Pass (82.4%) | +32.68% ✅ | +40.74% ✅ / +51.74% ✅ / +5.56% ✅ | +32.68% ✅ | 6584.67 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob120_fsm3s | ✅ Pass (83.3%) | ✅ Pass (83.3%) | +32.68% ✅ | +40.74% ✅ / +51.74% ✅ / +5.56% ✅ | +32.68% ✅ | 11741.95 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob120_fsm3s | ✅ Pass (67.6%) | ✅ Pass (67.6%) | +32.68% ✅ | +40.74% ✅ / +51.74% ✅ / +5.56% ✅ | +32.68% ✅ | 7784.22 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob121_2014_q3bfsm | ✅ Pass (79.5%) | ✅ Pass (79.5%) | +8.93% ✅ | +23.08% ✅ / +27.53% ✅ / -23.81% ❌ | +8.93% ✅ | 73471.91 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob121_2014_q3bfsm | ✅ Pass (81.0%) | ✅ Pass (81.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 6514.56 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob121_2014_q3bfsm | ✅ Pass (88.1%) | ✅ Pass (88.1%) | +4.02% ✅ | +17.95% ✅ / +17.92% ✅ / -23.81% ❌ | +4.02% ✅ | 12887.83 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob121_2014_q3bfsm | ✅ Pass (61.0%) | ✅ Pass (60.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 10378.13 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob122_kmap4 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 52322.54 | 296 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob122_kmap4 | ✅ Pass (98.6%) | ✅ Pass (98.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 4601.48 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob122_kmap4 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5098.85 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob122_kmap4 | ✅ Pass (91.9%) | ✅ Pass (91.9%) | +32.99% ✅ | +0.00% ➖ / +98.96% ✅ / N/A | +49.48% ✅ | 8487.05 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob123_bugs_addsubz | ✅ Pass (86.2%) | ✅ Pass (85.7%) | +39.65% ✅ | +20.00% ✅ / +98.94% ✅ / N/A | +59.47% ✅ | 56917.13 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob123_bugs_addsubz | ✅ Pass (98.6%) | ✅ Pass (98.6%) | +10.87% ✅ | +23.33% ✅ / +9.26% ✅ / N/A | +16.30% ✅ | 4780.32 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob123_bugs_addsubz | ✅ Pass (99.5%) | ✅ Pass (99.5%) | +10.87% ✅ | +23.33% ✅ / +9.26% ✅ / N/A | +16.30% ✅ | 6004.04 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob123_bugs_addsubz | ✅ Pass (95.7%) | ✅ Pass (95.2%) | +45.32% ✅ | +36.67% ✅ / +99.28% ✅ / N/A | +67.98% ✅ | 6278.38 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob124_rule110 | ✅ Pass (71.4%) | ✅ Pass (12.4%) | -11.34% ❌ | -7.84% ❌ / -12.54% ❌ / -13.64% ❌ | -11.34% ❌ | 123549.90 | 288 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob124_rule110 | ✅ Pass (79.0%) | ✅ Pass (9.5%) | -4.82% ❌ | -8.18% ❌ / -6.27% ❌ / +0.00% ➖ | -4.82% ❌ | 46972.84 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob124_rule110 | ✅ Pass (86.7%) | ✅ Pass (5.7%) | -4.82% ❌ | -8.18% ❌ / -6.27% ❌ / +0.00% ➖ | -4.82% ❌ | 57042.87 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob124_rule110 | ✅ Pass (84.3%) | ✅ Pass (9.5%) | -11.34% ❌ | -7.84% ❌ / -12.54% ❌ / -13.64% ❌ | -11.34% ❌ | 53299.37 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob125_kmap3 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 59941.04 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob125_kmap3 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +0.61% ✅ | +0.00% ➖ / +1.82% ✅ / N/A | +0.91% ✅ | 6456.44 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob125_kmap3 | ✅ Pass (96.7%) | ✅ Pass (96.2%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 9596.92 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob125_kmap3 | ✅ Pass (95.7%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 11332.22 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob126_circuit6 | ✅ Pass (65.7%) | ✅ Pass (65.7%) | +23.50% ✅ | +38.33% ✅ / +32.16% ✅ / N/A | +35.24% ✅ | 52837.17 | 276 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob126_circuit6 | ✅ Pass (39.5%) | ✅ Pass (38.6%) | +23.50% ✅ | +38.33% ✅ / +32.16% ✅ / N/A | +35.24% ✅ | 5405.45 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob126_circuit6 | ✅ Pass (28.6%) | ✅ Pass (28.6%) | +21.12% ✅ | +33.33% ✅ / +30.04% ✅ / N/A | +31.68% ✅ | 6238.82 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob126_circuit6 | ✅ Pass (42.9%) | ✅ Pass (42.9%) | +21.12% ✅ | +33.33% ✅ / +30.04% ✅ / N/A | +31.68% ✅ | 5573.35 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob127_lemmings1 | ✅ Pass (57.1%) | ✅ Pass (57.1%) | -7.25% ❌ | -12.50% ❌ / -19.25% ❌ / +10.00% ✅ | -7.25% ❌ | 69031.96 | 303 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob127_lemmings1 | ✅ Pass (79.0%) | ✅ Pass (79.0%) | +3.72% ✅ | +0.00% ➖ / +1.15% ✅ / +10.00% ✅ | +3.72% ✅ | 5875.56 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob127_lemmings1 | ✅ Pass (88.1%) | ✅ Pass (88.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 8787.81 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob127_lemmings1 | ✅ Pass (45.7%) | ✅ Pass (45.7%) | +3.72% ✅ | +0.00% ➖ / +1.15% ✅ / +10.00% ✅ | +3.72% ✅ | 9340.99 | 421 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob128_fsm_ps2 | ✅ Pass (42.9%) | ✅ Pass (42.9%) | +1.25% ✅ | +0.00% ➖ / -2.14% ❌ / +5.88% ✅ | +1.25% ✅ | 73949.09 | 279 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob128_fsm_ps2 | ✅ Pass (44.8%) | ✅ Pass (44.8%) | +12.76% ✅ | +23.08% ✅ / +21.07% ✅ / -5.88% ❌ | +12.76% ✅ | 6414.42 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob128_fsm_ps2 | ✅ Pass (58.1%) | ✅ Pass (58.1%) | +12.64% ✅ | +23.08% ✅ / +20.71% ✅ / -5.88% ❌ | +12.64% ✅ | 11955.92 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob128_fsm_ps2 | ✅ Pass (50.5%) | ✅ Pass (50.5%) | +12.76% ✅ | +23.08% ✅ / +21.07% ✅ / -5.88% ❌ | +12.76% ✅ | 9857.26 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob129_ece241_2013_q8 | ✅ Pass (90.0%) | ✅ Pass (89.0%) | +16.99% ✅ | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | +16.99% ✅ | 67271.31 | 289 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob129_ece241_2013_q8 | ✅ Pass (92.4%) | ✅ Pass (90.5%) | +16.99% ✅ | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | +16.99% ✅ | 6003.72 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob129_ece241_2013_q8 | ✅ Pass (90.0%) | ✅ Pass (89.0%) | +16.99% ✅ | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | +16.99% ✅ | 8578.52 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob129_ece241_2013_q8 | ✅ Pass (85.2%) | ✅ Pass (84.3%) | +16.99% ✅ | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | +16.99% ✅ | 8484.61 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob130_circuit5 | ✅ Pass (90.5%) | ✅ Pass (90.5%) | +8.67% ✅ | +5.88% ✅ / +20.13% ✅ / N/A | +13.01% ✅ | 60758.54 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob130_circuit5 | ✅ Pass (95.2%) | ✅ Pass (95.2%) | +8.67% ✅ | +5.88% ✅ / +20.13% ✅ / N/A | +13.01% ✅ | 5640.09 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob130_circuit5 | ✅ Pass (96.2%) | ✅ Pass (95.7%) | +32.98% ✅ | +0.00% ➖ / +98.94% ✅ / N/A | +49.47% ✅ | 6632.31 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob130_circuit5 | ✅ Pass (89.5%) | ✅ Pass (89.5%) | +8.67% ✅ | +5.88% ✅ / +20.13% ✅ / N/A | +13.01% ✅ | 7141.67 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob131_mt2015_q4 | ✅ Pass (82.4%) | ✅ Pass (82.4%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 86157.41 | 304 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob131_mt2015_q4 | ✅ Pass (78.6%) | ✅ Pass (78.6%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 6580.26 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob131_mt2015_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12237.28 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob131_mt2015_q4 | ✅ Pass (71.0%) | ✅ Pass (71.0%) | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 10858.48 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob132_always_if2 | ✅ Pass (97.1%) | ✅ Pass (97.1%) | +32.96% ✅ | +0.00% ➖ / +98.87% ✅ / N/A | +49.43% ✅ | 60109.11 | 301 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob132_always_if2 | ✅ Pass (99.5%) | ✅ Pass (99.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 5125.99 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob132_always_if2 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 6005.02 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob132_always_if2 | ✅ Pass (94.8%) | ✅ Pass (94.8%) | +32.96% ✅ | +0.00% ➖ / +98.87% ✅ / N/A | +49.43% ✅ | 6562.00 | 421 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob133_2014_q3fsm | ✅ Pass (59.0%) | ✅ Pass (57.6%) | +21.40% ✅ | +26.79% ✅ / +29.41% ✅ / +8.00% ✅ | +21.40% ✅ | 98669.82 | 287 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob133_2014_q3fsm | ✅ Pass (55.7%) | ✅ Pass (55.7%) | +11.45% ✅ | +10.71% ✅ / +15.63% ✅ / +8.00% ✅ | +11.45% ✅ | 8015.30 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob133_2014_q3fsm | ✅ Pass (34.0%) | ✅ Pass (34.0%) | +10.37% ✅ | +23.21% ✅ / +27.90% ✅ / -20.00% ❌ | +10.37% ✅ | 16562.46 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob133_2014_q3fsm | ✅ Pass (45.2%) | ✅ Pass (45.2%) | +11.28% ✅ | +12.50% ✅ / +21.34% ✅ / +0.00% ➖ | +11.28% ✅ | 15147.07 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob134_2014_q3c | ✅ Pass (91.0%) | ✅ Pass (91.0%) | +17.39% ✅ | +28.57% ✅ / +23.60% ✅ / N/A | +26.09% ✅ | 80869.74 | 284 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob134_2014_q3c | ✅ Pass (90.5%) | ✅ Pass (90.5%) | +22.06% ✅ | +28.57% ✅ / +37.60% ✅ / N/A | +33.09% ✅ | 7118.30 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob134_2014_q3c | ✅ Pass (92.4%) | ✅ Pass (92.4%) | +22.06% ✅ | +28.57% ✅ / +37.60% ✅ / N/A | +33.09% ✅ | 11642.53 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob134_2014_q3c | ✅ Pass (73.3%) | ✅ Pass (72.9%) | +17.39% ✅ | +28.57% ✅ / +23.60% ✅ / N/A | +26.09% ✅ | 11585.46 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (87.6%) | ✅ Pass (87.6%) | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 96766.67 | 296 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (86.2%) | ✅ Pass (86.2%) | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 8672.33 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (94.3%) | ✅ Pass (94.3%) | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 16185.99 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (90.0%) | ✅ Pass (90.0%) | +12.26% ✅ | +0.00% ➖ / +36.77% ✅ / N/A | +18.39% ✅ | 13256.94 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob136_m2014_q6 | ✅ Pass (65.2%) | ✅ Pass (64.8%) | +23.87% ✅ | +34.88% ✅ / +46.73% ✅ / -10.00% ❌ | +23.87% ✅ | 87033.57 | 301 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob136_m2014_q6 | ✅ Pass (83.8%) | ✅ Pass (83.8%) | +25.38% ✅ | +44.19% ✅ / +46.95% ✅ / -15.00% ❌ | +25.38% ✅ | 7034.86 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob136_m2014_q6 | ✅ Pass (78.1%) | ✅ Pass (77.6%) | +1.28% ✅ | -2.33% ❌ / -3.84% ❌ / +10.00% ✅ | +1.28% ✅ | 11110.11 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob136_m2014_q6 | ✅ Pass (58.6%) | ✅ Pass (58.1%) | +23.87% ✅ | +34.88% ✅ / +46.73% ✅ / -10.00% ❌ | +23.87% ✅ | 11326.63 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob137_fsm_serial | ✅ Pass (45.7%) | ✅ Pass (45.7%) | +10.43% ✅ | +24.24% ✅ / +12.60% ✅ / -5.56% ❌ | +10.43% ✅ | 90164.73 | 285 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob137_fsm_serial | ✅ Pass (28.6%) | ✅ Pass (28.6%) | +11.32% ✅ | +36.36% ✅ / +36.48% ✅ / -38.89% ❌ | +11.32% ✅ | 7023.46 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob137_fsm_serial | ✅ Pass (48.1%) | ✅ Pass (48.1%) | +11.70% ✅ | +40.40% ✅ / +39.14% ✅ / -44.44% ❌ | +11.70% ✅ | 11674.26 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob137_fsm_serial | ✅ Pass (32.9%) | ✅ Pass (32.9%) | +11.70% ✅ | +40.40% ✅ / +39.14% ✅ / -44.44% ❌ | +11.70% ✅ | 12939.12 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob138_2012_q2fsm | ✅ Pass (71.9%) | ✅ Pass (68.1%) | +27.70% ✅ | +36.96% ✅ / +46.15% ✅ / +0.00% ➖ | +27.70% ✅ | 83431.25 | 293 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob138_2012_q2fsm | ✅ Pass (88.1%) | ✅ Pass (87.1%) | +30.46% ✅ | +41.30% ✅ / +45.71% ✅ / +4.35% ✅ | +30.46% ✅ | 6881.58 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob138_2012_q2fsm | ✅ Pass (83.3%) | ✅ Pass (82.8%) | +27.70% ✅ | +36.96% ✅ / +46.15% ✅ / +0.00% ➖ | +27.70% ✅ | 9572.28 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob138_2012_q2fsm | ✅ Pass (63.8%) | ✅ Pass (60.0%) | +27.70% ✅ | +36.96% ✅ / +46.15% ✅ / +0.00% ➖ | +27.70% ✅ | 9892.18 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob139_2013_q2bfsm | ✅ Pass (18.1%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 126473.95 | 305 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob139_2013_q2bfsm | ✅ Pass (2.9%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 8078.08 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob139_2013_q2bfsm | ✅ Pass (58.6%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 17200.44 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob139_2013_q2bfsm | ✅ Pass (21.4%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 16423.94 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob140_fsm_hdlc | ✅ Pass (47.1%) | ✅ Pass (47.1%) | +32.64% ✅ | +30.88% ✅ / +39.44% ✅ / +27.59% ✅ | +32.64% ✅ | 97819.09 | 291 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob140_fsm_hdlc | ✅ Pass (50.0%) | ✅ Pass (50.0%) | +37.57% ✅ | +39.71% ✅ / +48.87% ✅ / +24.14% ✅ | +37.57% ✅ | 7278.81 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob140_fsm_hdlc | ✅ Pass (63.8%) | ✅ Pass (63.8%) | +37.57% ✅ | +39.71% ✅ / +48.87% ✅ / +24.14% ✅ | +37.57% ✅ | 14466.49 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob140_fsm_hdlc | ✅ Pass (46.2%) | ✅ Pass (46.2%) | +32.06% ✅ | +29.41% ✅ / +39.18% ✅ / +27.59% ✅ | +32.06% ✅ | 13886.47 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob141_count_clock | ✅ Pass (64.3%) | ✅ Pass (64.3%) | +19.92% ✅ | +24.35% ✅ / +22.63% ✅ / +12.77% ✅ | +19.92% ✅ | 105035.47 | 276 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob141_count_clock | ✅ Pass (58.6%) | ✅ Pass (57.6%) | +20.13% ✅ | +25.00% ✅ / +22.63% ✅ / +12.77% ✅ | +20.13% ✅ | 8307.46 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob141_count_clock | ✅ Pass (79.5%) | ✅ Pass (79.5%) | +21.18% ✅ | +21.75% ✅ / +22.63% ✅ / +19.15% ✅ | +21.18% ✅ | 15940.24 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob141_count_clock | ✅ Pass (53.3%) | ✅ Pass (52.9%) | +18.15% ✅ | +22.73% ✅ / +18.95% ✅ / +12.77% ✅ | +18.15% ✅ | 15784.95 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob142_lemmings2 | ✅ Pass (58.1%) | ✅ Pass (58.1%) | +7.86% ✅ | +5.00% ✅ / +18.57% ✅ / +0.00% ➖ | +7.86% ✅ | 88712.83 | 282 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob142_lemmings2 | ✅ Pass (41.9%) | ✅ Pass (41.9%) | +7.86% ✅ | +5.00% ✅ / +18.57% ✅ / +0.00% ➖ | +7.86% ✅ | 6825.90 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob142_lemmings2 | ✅ Pass (35.7%) | ✅ Pass (35.7%) | +8.44% ✅ | +10.00% ✅ / +10.55% ✅ / +4.76% ✅ | +8.44% ✅ | 12673.56 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob142_lemmings2 | ✅ Pass (57.6%) | ✅ Pass (57.6%) | +8.00% ✅ | +5.00% ✅ / +18.99% ✅ / +0.00% ➖ | +8.00% ✅ | 11655.04 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob143_fsm_onehot | ✅ Pass (81.4%) | ✅ Pass (81.4%) | +12.82% ✅ | +23.08% ✅ / +15.37% ✅ / N/A | +19.22% ✅ | 94573.35 | 282 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob143_fsm_onehot | ✅ Pass (70.5%) | ✅ Pass (70.5%) | +12.82% ✅ | +23.08% ✅ / +15.37% ✅ / N/A | +19.22% ✅ | 7089.69 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob143_fsm_onehot | ✅ Pass (83.8%) | ✅ Pass (83.8%) | +12.82% ✅ | +23.08% ✅ / +15.37% ✅ / N/A | +19.22% ✅ | 14884.13 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob143_fsm_onehot | ✅ Pass (66.7%) | ✅ Pass (66.7%) | +12.82% ✅ | +23.08% ✅ / +15.37% ✅ / N/A | +19.22% ✅ | 13066.98 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob144_conwaylife | ✅ Pass (59.0%) | ✅ Pass (45.2%) | +6.95% ✅ | +2.24% ✅ / +15.90% ✅ / +2.70% ✅ | +6.95% ✅ | 277871.51 | 283 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob144_conwaylife | ✅ Pass (71.0%) | ✅ Pass (66.2%) | +20.46% ✅ | +15.57% ✅ / +17.44% ✅ / +28.38% ✅ | +20.46% ✅ | 11064.57 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob144_conwaylife | ✅ Pass (69.4%) | ✅ Pass (68.9%) | +6.95% ✅ | +2.24% ✅ / +15.90% ✅ / +2.70% ✅ | +6.95% ✅ | 15805.30 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob144_conwaylife | ✅ Pass (67.1%) | ✅ Pass (63.3%) | +6.95% ✅ | +2.24% ✅ / +15.90% ✅ / +2.70% ✅ | +6.95% ✅ | 17423.57 | 417 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob145_circuit8 | ✅ Pass (83.8%) | ✅ Pass (59.0%) | +37.44% ✅ | +12.50% ✅ / +99.82% ✅ / N/A | +56.16% ✅ | 102976.77 | 295 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob145_circuit8 | ✅ Pass (85.7%) | ✅ Pass (29.0%) | +49.98% ✅ | +50.00% ✅ / +99.93% ✅ / N/A | +74.96% ✅ | 7164.47 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob145_circuit8 | ✅ Pass (95.2%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13803.63 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob145_circuit8 | ✅ Pass (80.5%) | ✅ Pass (44.8%) | +37.44% ✅ | +12.50% ✅ / +99.82% ✅ / N/A | +56.16% ✅ | 12619.71 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob146_fsm_serialdata | ✅ Pass (34.3%) | ✅ Pass (34.3%) | -17.74% ❌ | +0.68% ✅ / +12.77% ✅ / -66.67% ❌ | -17.74% ❌ | 103010.34 | 293 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob146_fsm_serialdata | ✅ Pass (34.3%) | ✅ Pass (34.3%) | -9.32% ❌ | +4.79% ✅ / -4.96% ❌ / -27.78% ❌ | -9.32% ❌ | 6612.65 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob146_fsm_serialdata | ✅ Pass (18.1%) | ✅ Pass (17.6%) | -39.44% ❌ | -36.99% ❌ / -36.88% ❌ / -44.44% ❌ | -39.44% ❌ | 15160.11 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob146_fsm_serialdata | ✅ Pass (30.0%) | ✅ Pass (29.5%) | -22.84% ❌ | -7.53% ❌ / +5.67% ✅ / -66.67% ❌ | -22.84% ❌ | 12599.41 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob147_circuit10 | ✅ Pass (66.7%) | ✅ Pass (66.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 105498.19 | 292 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob147_circuit10 | ✅ Pass (53.8%) | ✅ Pass (53.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 8306.41 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob147_circuit10 | ✅ Pass (77.6%) | ✅ Pass (77.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 15529.67 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob147_circuit10 | ✅ Pass (55.7%) | ✅ Pass (53.8%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 16709.95 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob148_2013_q2afsm | ✅ Pass (77.6%) | ✅ Pass (77.6%) | +21.52% ✅ | +28.57% ✅ / +26.91% ✅ / +9.09% ✅ | +21.52% ✅ | 82548.67 | 269 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob148_2013_q2afsm | ✅ Pass (86.7%) | ✅ Pass (86.7%) | +21.52% ✅ | +28.57% ✅ / +26.91% ✅ / +9.09% ✅ | +21.52% ✅ | 6248.15 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob148_2013_q2afsm | ✅ Pass (87.1%) | ✅ Pass (87.1%) | +21.52% ✅ | +28.57% ✅ / +26.91% ✅ / +9.09% ✅ | +21.52% ✅ | 9931.01 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob148_2013_q2afsm | ✅ Pass (78.6%) | ✅ Pass (78.6%) | +18.17% ✅ | +25.71% ✅ / +33.33% ✅ / -4.55% ❌ | +18.17% ✅ | 9554.44 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob149_ece241_2013_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 107946.24 | 313 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob149_ece241_2013_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 6614.89 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob149_ece241_2013_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 14050.04 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob149_ece241_2013_q4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 12356.67 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (77.6%) | ✅ Pass (77.1%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 97309.64 | 296 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (61.0%) | ✅ Pass (61.0%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 6114.10 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (85.7%) | ✅ Pass (85.7%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 9437.66 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (55.2%) | ✅ Pass (55.2%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 11085.68 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (35.2%) | ✅ Pass (35.2%) | -12.28% ❌ | -10.61% ❌ / -47.65% ❌ / +21.43% ✅ | -12.28% ❌ | 103641.34 | 299 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (31.9%) | ✅ Pass (31.9%) | -10.71% ❌ | -4.55% ❌ / -63.31% ❌ / +35.71% ✅ | -10.71% ❌ | 6063.35 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (71.8%) | ✅ Pass (71.3%) | -6.11% ❌ | -7.58% ❌ / -21.48% ❌ / +10.71% ✅ | -6.11% ❌ | 12533.51 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (17.6%) | ✅ Pass (17.6%) | -12.44% ❌ | -3.03% ❌ / -59.28% ❌ / +25.00% ✅ | -12.44% ❌ | 12122.14 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob152_lemmings3 | ✅ Pass (55.2%) | ✅ Pass (54.8%) | +24.45% ✅ | +40.00% ✅ / +37.68% ✅ / -4.35% ❌ | +24.45% ✅ | 96324.66 | 283 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob152_lemmings3 | ✅ Pass (57.6%) | ✅ Pass (57.6%) | +23.13% ✅ | +38.00% ✅ / +40.07% ✅ / -8.70% ❌ | +23.13% ✅ | 5594.00 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob152_lemmings3 | ✅ Pass (80.9%) | ✅ Pass (80.9%) | +24.36% ✅ | +36.00% ✅ / +58.82% ✅ / -21.74% ❌ | +24.36% ✅ | 12481.83 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob152_lemmings3 | ✅ Pass (46.7%) | ✅ Pass (46.7%) | +21.55% ✅ | +28.00% ✅ / +27.94% ✅ / +8.70% ✅ | +21.55% ✅ | 11807.89 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (50.5%) | ✅ Pass (50.5%) | +15.30% ✅ | +9.12% ✅ / +34.10% ✅ / +2.67% ✅ | +15.30% ✅ | 96380.62 | 294 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (56.7%) | ✅ Pass (54.8%) | +16.33% ✅ | +10.02% ✅ / +33.64% ✅ / +5.33% ✅ | +16.33% ✅ | 5766.82 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (86.2%) | ✅ Pass (85.2%) | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 12563.94 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (57.1%) | ✅ Pass (54.3%) | +25.14% ✅ | +9.19% ✅ / +99.57% ✅ / +100.00% ✅ | +69.59% ✅ | 12377.56 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob154_fsm_ps2data | ✅ Pass (27.6%) | ✅ Pass (27.1%) | -55.15% ❌ | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | -55.15% ❌ | 95109.86 | 291 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob154_fsm_ps2data | ✅ Pass (40.0%) | ✅ Pass (40.0%) | -55.15% ❌ | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | -55.15% ❌ | 5159.56 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob154_fsm_ps2data | ✅ Pass (56.7%) | ✅ Pass (56.7%) | -55.15% ❌ | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | -55.15% ❌ | 9463.37 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob154_fsm_ps2data | ✅ Pass (39.5%) | ✅ Pass (39.5%) | -55.15% ❌ | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | -55.15% ❌ | 10297.00 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob155_lemmings4 | ✅ Pass (42.4%) | ✅ Pass (42.4%) | +19.55% ✅ | +9.80% ✅ / +70.28% ✅ / -21.43% ❌ | +19.55% ✅ | 97427.82 | 290 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob155_lemmings4 | ✅ Pass (16.7%) | ✅ Pass (16.7%) | +2.40% ✅ | -21.57% ❌ / +71.64% ✅ / -42.86% ❌ | +2.40% ✅ | 5929.07 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob155_lemmings4 | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | N/A / N/A / N/A | N/A | 13283.94 | 211 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob155_lemmings4 | ✅ Pass (17.1%) | ✅ Pass (17.1%) | +20.24% ✅ | -1.96% ❌ / +69.83% ✅ / -7.14% ❌ | +20.24% ✅ | 11454.31 | 420 |
| `codeevolve` | VerilogEval-Spec-to-RTL | Prob156_review2015_fancytimer | ✅ Pass (24.3%) | ✅ Pass (24.3%) | +3.81% ✅ | -20.32% ❌ / +27.40% ✅ / +4.35% ✅ | +3.81% ✅ | 102267.37 | 281 |
| `eoh` | VerilogEval-Spec-to-RTL | Prob156_review2015_fancytimer | ✅ Pass (40.0%) | ✅ Pass (40.0%) | +8.22% ✅ | -10.16% ❌ / +36.99% ✅ / -2.17% ❌ | +8.22% ✅ | 5754.52 | 210 |
| `funsearch` | VerilogEval-Spec-to-RTL | Prob156_review2015_fancytimer | ✅ Pass (25.2%) | ✅ Pass (23.8%) | +0.78% ✅ | -27.81% ❌ / +30.14% ✅ / +0.00% ➖ | +0.78% ✅ | 13436.84 | 210 |
| `revolution` | VerilogEval-Spec-to-RTL | Prob156_review2015_fancytimer | ✅ Pass (41.0%) | ✅ Pass (40.0%) | -0.62% ❌ | -39.57% ❌ / +24.66% ✅ / +13.04% ✅ | -0.62% ❌ | 11466.85 | 420 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `codeevolve` | RTLLM | 50 | ➖ 44/50 (88.0%) | ➖ 34/50 (68.0%) | 58.1% ± 10.6% | 49.0% ± 11.2% | 34/50 | +30.53% ± 6.81% ✅ | ✅ 28 / ➖ 6 / ❌ 0 | 31/50 | +43.83% ± 8.11% ✅ | +25.47% ± 8.90% ✅ / +62.11% ± 11.61% ✅ / +33.05% ± 16.24% ✅ | ✅ 28 / ➖ 3 / ❌ 0 | A ❌ 1/31 / P ✅ 0/31 / T ❌ 1/17 | 81224.21 ± 4892.22 | 288.94 ± 2.31 |
| `codeevolve` | VerilogEval-Spec-to-RTL | 156 | ➖ 151/156 (96.8%) | ➖ 145/156 (92.9%) | 80.5% ± 3.8% | 76.9% ± 4.5% | 145/156 | +18.39% ± 2.79% ✅ | ✅ 109 / ➖ 30 / ❌ 6 | 145/156 | +26.24% ± 4.00% ✅ | +6.05% ± 2.28% ✅ / +48.30% ± 7.55% ✅ / +2.16% ± 3.94% ✅ | ✅ 109 / ➖ 30 / ❌ 6 | A ❌ 10/145 / P ❌ 8/145 / T ❌ 11/55 | 60226.45 ± 4454.46 | 291.56 ± 1.16 |
| `eoh` | RTLLM | 50 | ➖ 40/50 (80.0%) | ➖ 33/50 (66.0%) | 54.8% ± 11.3% | 47.3% ± 11.6% | 33/50 | +20.91% ± 8.99% ✅ | ✅ 24 / ➖ 7 / ❌ 2 | 30/50 | +28.75% ± 11.25% ✅ | +23.36% ± 8.67% ✅ / +36.85% ± 20.63% ✅ / +10.46% ± 10.88% ✅ | ✅ 24 / ➖ 4 / ❌ 2 | A ❌ 3/30 / P ❌ 2/30 / T ❌ 4/17 | 6212.27 ± 540.22 | 210.00 ± 0.00 |
| `eoh` | VerilogEval-Spec-to-RTL | 156 | ➖ 151/156 (96.8%) | ➖ 145/156 (92.9%) | 81.6% ± 4.0% | 77.1% ± 4.8% | 145/156 | +8.00% ± 2.22% ✅ | ✅ 75 / ➖ 65 / ❌ 5 | 145/156 | +10.53% ± 2.90% ✅ | +6.76% ± 2.45% ✅ / +16.33% ± 4.88% ✅ / +2.40% ± 3.97% ✅ | ✅ 75 / ➖ 65 / ❌ 5 | A ❌ 10/145 / P ❌ 7/145 / T ❌ 13/55 | 5627.97 ± 919.49 | 210.03 ± 0.02 |
| `funsearch` | RTLLM | 50 | ➖ 36/50 (72.0%) | ➖ 31/50 (62.0%) | 55.2% ± 11.9% | 48.2% ± 12.0% | 31/50 | +22.82% ± 6.80% ✅ | ✅ 23 / ➖ 7 / ❌ 1 | 28/50 | +33.03% ± 9.68% ✅ | +16.49% ± 8.67% ✅ / +49.84% ± 14.20% ✅ / +24.33% ± 17.54% ✅ | ✅ 23 / ➖ 4 / ❌ 1 | A ❌ 3/28 / P ❌ 1/28 / T ❌ 2/15 | 11571.23 ± 1531.13 | 210.02 ± 0.04 |
| `funsearch` | VerilogEval-Spec-to-RTL | 156 | ➖ 147/156 (94.2%) | ➖ 142/156 (91.0%) | 82.6% ± 4.2% | 78.5% ± 5.0% | 142/156 | +5.86% ± 2.08% ✅ | ✅ 64 / ➖ 73 / ❌ 5 | 142/156 | +7.56% ± 2.57% ✅ | +5.53% ± 2.42% ✅ / +11.68% ± 4.08% ✅ / +0.97% ± 3.86% ✅ | ✅ 64 / ➖ 73 / ❌ 5 | A ❌ 11/142 / P ❌ 8/142 / T ❌ 11/54 | 8262.48 ± 1128.11 | 210.01 ± 0.01 |
| `revolution` | RTLLM | 50 | ➖ 44/50 (88.0%) | ➖ 37/50 (74.0%) | 54.1% ± 9.9% | 44.8% ± 10.4% | 37/50 | +24.93% ± 6.37% ✅ | ✅ 30 / ➖ 6 / ❌ 1 | 34/50 | +34.00% ± 8.79% ✅ | +20.23% ± 7.64% ✅ / +53.17% ± 12.02% ✅ / +9.76% ± 9.41% ✅ | ✅ 30 / ➖ 3 / ❌ 1 | A ❌ 3/34 / P ✅ 0/34 / T ❌ 3/19 | 12215.15 ± 832.46 | 420.04 ± 0.05 |
| `revolution` | VerilogEval-Spec-to-RTL | 156 | ➖ 152/156 (97.4%) | ➖ 146/156 (93.6%) | 78.1% ± 3.9% | 74.2% ± 4.6% | 146/156 | +21.11% ± 2.68% ✅ | ✅ 121 / ➖ 19 / ❌ 6 | 146/156 | +30.65% ± 3.90% ✅ | +5.34% ± 2.63% ✅ / +57.67% ± 7.40% ✅ / +3.25% ± 5.38% ✅ | ✅ 121 / ➖ 19 / ❌ 6 | A ❌ 12/146 / P ❌ 8/146 / T ❌ 12/55 | 8771.39 ± 1001.41 | 419.99 ± 0.05 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `codeevolve` | ALL | 206 | ➖ 195/206 (94.7%) | ➖ 179/206 (86.9%) | 75.1% ± 4.1% | 70.1% ± 4.6% | 179/206 | +20.70% ± 2.69% ✅ | ✅ 137 / ➖ 36 / ❌ 6 | 176/206 | +29.34% ± 3.72% ✅ | +9.47% ± 2.67% ✅ / +50.74% ± 6.58% ✅ / +9.46% ± 5.69% ✅ | ✅ 137 / ➖ 33 / ❌ 6 | A ❌ 11/176 / P ❌ 8/176 / T ❌ 12/72 | 65322.99 ± 3777.36 | 290.92 ± 1.05 |
| `eoh` | ALL | 206 | ➖ 191/206 (92.7%) | ➖ 178/206 (86.4%) | 75.1% ± 4.3% | 69.9% ± 4.9% | 178/206 | +10.39% ± 2.55% ✅ | ✅ 99 / ➖ 72 / ❌ 7 | 175/206 | +13.65% ± 3.23% ✅ | +9.60% ± 2.67% ✅ / +19.85% ± 5.46% ✅ / +4.30% ± 4.01% ✅ | ✅ 99 / ➖ 69 / ❌ 7 | A ❌ 13/175 / P ❌ 9/175 / T ❌ 17/72 | 5769.79 ± 708.66 | 210.02 ± 0.02 |
| `funsearch` | ALL | 206 | ➖ 183/206 (88.8%) | ➖ 173/206 (84.0%) | 75.9% ± 4.6% | 71.1% ± 5.1% | 173/206 | +8.90% ± 2.30% ✅ | ✅ 87 / ➖ 80 / ❌ 6 | 170/206 | +11.76% ± 3.02% ✅ | +7.33% ± 2.54% ✅ / +17.96% ± 4.63% ✅ / +6.05% ± 5.30% ✅ | ✅ 87 / ➖ 77 / ❌ 6 | A ❌ 14/170 / P ❌ 9/170 / T ❌ 13/69 | 9065.58 ± 949.95 | 210.01 ± 0.01 |
| `revolution` | ALL | 206 | ➖ 196/206 (95.1%) | ➖ 183/206 (88.8%) | 72.3% ± 4.0% | 67.0% ± 4.6% | 183/206 | +21.88% ± 2.50% ✅ | ✅ 151 / ➖ 25 / ❌ 7 | 180/206 | +31.28% ± 3.57% ✅ | +8.15% ± 2.70% ✅ / +56.82% ± 6.41% ✅ / +4.92% ± 4.68% ✅ | ✅ 151 / ➖ 22 / ❌ 7 | A ❌ 15/180 / P ❌ 8/180 / T ❌ 15/74 | 9607.25 ± 809.48 | 420.00 ± 0.04 |
