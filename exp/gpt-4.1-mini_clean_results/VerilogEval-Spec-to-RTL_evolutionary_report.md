# 🧬 BENCHMARK EVOLUTION REPORT: VerilogEval-Spec-to-RTL

## 📈 Summary
- **Total Problems Analyzed:** 156
- **Average Runtime per Problem:** 785.37s
- **Average LLM API Calls per Problem:** 418.7

### ✅ Pass Rate Analysis
| Metric | Initial Any Passing Gen | Any Passing Gen | Initial Pass@1 | Final Pass@1 | Change |
|:---|:---|:---|:---|:---|:---|
| **Syntax** | 98.7% (154/156) | 99.4% (155/156) | 94.1% | 96.0% | **+1.9%** |
| **Functionality** | 82.1% (128/156) | 94.2% (147/156) | 69.2% | 73.6% | **+4.4%** |
| **Synthesis** | 80.1% (125/156) | 89.7% (140/156) | 66.7% | 71.2% | **+4.5%** |

### ⚡ PPA Optimization Summary
- **Problems with PPA Improvement (Best Solution Compared to Reference):** 107 / 156 (68.6%)

| PPA Metric | Average Improvement |
|:-----------|:--------------------|
| **Area** | +5.30% |
| **Power** | +44.99% |
| **Performance (Period)** | +11.54% |

## 🧬 Strategy Analysis
Shows how often each strategy was used and its success rate (rewarded).
| Strategy | Times Used | Success Count | Success Rate |
|:---------|:-----------|:--------------|:-------------|
| `M-E` | 6316 (19.3%) | 204 | 3.2% |
| `M-R` | 6273 (19.2%) | 201 | 3.2% |
| `M-S` | 6240 (19.1%) | 201 | 3.2% |
| `M-I` | 6159 (18.9%) | 208 | 3.4% |
| `C-F` | 5255 (16.1%) | 139 | 2.6% |
| `initial` | 1560 (4.8%) | 0 | 0.0% |
| `M-F` | 857 (2.6%) | 66 | 7.7% |

## 📋 Detailed Problem-by-Problem Analysis
| Problem | Initial Status | Final Status | Best Score | Reference PPA | Best Evo. PPA | PPA % Improv. (A/P/T) | Runtime (s) | API Calls |
|:---|:---|:---|:---:|:---|:---|:---|:---:|:---:|
| Prob001_zero | ✅ (Func: 100%) | ✅ (Func: 78%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 369.8 | 420 |
| Prob002_m2014_q4i | ✅ (Func: 100%) | ✅ (Func: 73%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 369.0 | 420 |
| Prob003_step_one | ✅ (Func: 100%) | ✅ (Func: 73%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 383.6 | 420 |
| Prob004_vector2 | ✅ (Func: 100%) | ✅ (Func: 90%) | -0.0000 | `Area: 26.00, Power: 0.0007, Period: 0.00` | `Area: 26.00, Power: 0.0007, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 613.1 | 420 |
| Prob005_notgate | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4942 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.84% ✅ / N/A | 460.1 | 420 |
| Prob006_vectorr | ✅ (Func: 100%) | ✅ (Func: 94%) | 0.4945 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 603.9 | 420 |
| Prob007_wire | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 409.3 | 420 |
| Prob008_m2014_q4h | ✅ (Func: 100%) | ✅ (Func: 66%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 375.0 | 420 |
| Prob009_popcount3 | ✅ (Func: 100%) | ✅ (Func: 95%) | -0.0000 | `Area: 4.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 582.6 | 420 |
| Prob010_mt2015_q4a | ✅ (Func: 100%) | ✅ (Func: 100%) | 0.4945 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 539.5 | 420 |
| Prob011_norgate | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.4942 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.84% ✅ / N/A | 471.3 | 420 |
| Prob012_xnorgate | ✅ (Func: 100%) | ✅ (Func: 96%) | 0.4947 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.94% ✅ / N/A | 467.9 | 420 |
| Prob013_m2014_q4e | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.4942 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.84% ✅ / N/A | 491.4 | 420 |
| Prob014_andgate | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.89% ✅ / N/A | 438.7 | 420 |
| Prob015_vector1 | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4945 | `Area: 13.00, Power: 0.0003, Period: 0.00` | `Area: 13.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 544.9 | 420 |
| Prob016_m2014_q4j | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.6364 | `Area: 25.00, Power: 0.0013, Period: 0.00` | `Area: 18.00, Power: 0.0000, Period: 0.00` | +28.00% ✅ / +99.29% ✅ / N/A | 726.0 | 420 |
| Prob017_mux2to1v | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.4947 | `Area: 208.00, Power: 0.0071, Period: 0.00` | `Area: 208.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +98.93% ✅ / N/A | 711.9 | 420 |
| Prob018_mux256to1 | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.6134 | `Area: 522.00, Power: 0.0237, Period: 0.00` | `Area: 400.00, Power: 0.0002, Period: 0.00` | +23.37% ✅ / +99.30% ✅ / N/A | 1430.4 | 420 |
| Prob019_m2014_q4f | ✅ (Func: 100%) | ✅ (Func: 92%) | 0.4945 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 565.3 | 420 |
| Prob020_mt2015_eq2 | ✅ (Func: 100%) | ✅ (Func: 94%) | -0.0000 | `Area: 5.00, Power: 0.0003, Period: 0.00` | `Area: 5.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 548.0 | 420 |
| Prob021_mux256to1v | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.6304 | `Area: 2040.00, Power: 0.0942, Period: 0.00` | `Area: 1495.00, Power: 0.0006, Period: 0.00` | +26.72% ✅ / +99.37% ✅ / N/A | 1824.1 | 420 |
| Prob022_mux2to1 | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4946 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.92% ✅ / N/A | 463.1 | 420 |
| Prob023_vector100r | ✅ (Func: 100%) | ✅ (Func: 84%) | 0.4945 | `Area: 80.00, Power: 0.0021, Period: 0.00` | `Area: 80.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 902.0 | 420 |
| Prob024_hadd | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4946 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.93% ✅ / N/A | 461.7 | 420 |
| Prob025_reduction | ✅ (Func: 100%) | ✅ (Func: 96%) | 0.4949 | `Area: 11.00, Power: 0.0009, Period: 0.00` | `Area: 11.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.97% ✅ / N/A | 605.3 | 420 |
| Prob026_alwaysblock1 | ✅ (Func: 100%) | ✅ (Func: 99%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 499.5 | 420 |
| Prob027_fadd | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.4948 | `Area: 4.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.96% ✅ / N/A | 526.4 | 420 |
| Prob028_m2014_q4a | ✅ (Func: 100%) | ✅ (Func: 94%) | 0.3121 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +33.33% ✅ / +29.09% ✅ / N/A | 517.3 | 420 |
| Prob029_m2014_q4g | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.4948 | `Area: 5.00, Power: 0.0004, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.96% ✅ / N/A | 493.2 | 420 |
| Prob030_popcount255 | ✅ (Func: 70%) | ✅ (Func: 59%) | 0.4339 | `Area: 1339.00, Power: 0.2150, Period: 0.00` | `Area: 1333.00, Power: 0.0294, Period: 0.00` | +0.45% ✅ / +86.33% ✅ / N/A | 1530.3 | 420 |
| Prob031_dff | ✅ (Func: 100%) | ✅ (Func: 91%) | 0.4987 | `Area: 5.00, Power: 0.0005, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.74% ✅ / N/A | 525.4 | 420 |
| Prob032_vector0 | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.4945 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 469.5 | 420 |
| Prob033_ece241_2014_q1c | ✅ (Func: 100%) | ✅ (Func: 89%) | 0.6701 | `Area: 52.00, Power: 0.0032, Period: 0.00` | `Area: 34.00, Power: 0.0000, Period: 0.00` | +34.62% ✅ / +99.40% ✅ / N/A | 801.3 | 420 |
| Prob034_dff8 | ❌ (Func: 0%) | ✅ (Func: 12%) | N/A | `Area: 36.00, Power: 0.0036, Period: 0.00` | `N/A` | N/A / N/A / N/A | 476.5 | 420 |
| Prob035_count1to10 | ✅ (Func: 100%) | ✅ (Func: 94%) | 0.0591 | `Area: 41.00, Power: 0.0044, Period: 0.26` | `Area: 34.00, Power: 0.0041, Period: 0.28` | +17.07% ✅ / +8.35% ✅ / -7.69% ❌ | 656.8 | 420 |
| Prob036_ringer | ✅ (Func: 100%) | ✅ (Func: 98%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 530.1 | 420 |
| Prob037_review2015_count1k | ✅ (Func: 100%) | ✅ (Func: 90%) | 0.0175 | `Area: 93.00, Power: 0.0077, Period: 0.38` | `Area: 93.00, Power: 0.0077, Period: 0.36` | +0.00% ➖ / +0.00% ➖ / +5.26% ✅ | 743.2 | 420 |
| Prob038_count15 | ✅ (Func: 100%) | ✅ (Func: 96%) | 0.0277 | `Area: 30.00, Power: 0.0033, Period: 0.25` | `Area: 30.00, Power: 0.0033, Period: 0.23` | +0.00% ➖ / +0.30% ✅ / +8.00% ✅ | 582.5 | 420 |
| Prob039_always_if | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4947 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.94% ✅ / N/A | 565.4 | 420 |
| Prob040_count10 | ✅ (Func: 100%) | ✅ (Func: 95%) | 0.0250 | `Area: 39.00, Power: 0.0037, Period: 0.26` | `Area: 35.00, Power: 0.0032, Period: 0.30` | +10.26% ✅ / +12.63% ✅ / -15.38% ❌ | 588.0 | 420 |
| Prob041_dff8r | ✅ (Func: 100%) | ✅ (Func: 100%) | 0.4981 | `Area: 57.00, Power: 0.0053, Period: 0.00` | `Area: 57.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.61% ✅ / N/A | 606.0 | 420 |
| Prob042_vector4 | ✅ (Func: 100%) | ✅ (Func: 98%) | -0.0000 | `Area: 26.00, Power: 0.0007, Period: 0.00` | `Area: 26.00, Power: 0.0007, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 505.2 | 420 |
| Prob043_vector5 | ✅ (Func: 10%) | ✅ (Func: 51%) | -0.0000 | `Area: 39.00, Power: 0.0019, Period: 0.00` | `Area: 39.00, Power: 0.0019, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 882.0 | 420 |
| Prob044_vectorgates | ✅ (Func: 100%) | ✅ (Func: 100%) | 0.4944 | `Area: 10.00, Power: 0.0003, Period: 0.00` | `Area: 10.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.88% ✅ / N/A | 585.6 | 420 |
| Prob045_edgedetect2 | ✅ (Func: 50%) | ✅ (Func: 61%) | 0.6378 | `Area: 85.00, Power: 0.0087, Period: 0.17` | `Area: 92.00, Power: 0.0000, Period: 0.00` | -8.24% ❌ / +99.56% ✅ / +100.00% ✅ | 542.8 | 420 |
| Prob046_dff8p | ✅ (Func: 100%) | ✅ (Func: 88%) | 0.4985 | `Area: 52.00, Power: 0.0061, Period: 0.00` | `Area: 52.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.71% ✅ / N/A | 718.5 | 420 |
| Prob047_dff8ar | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.4989 | `Area: 43.00, Power: 0.0038, Period: 0.00` | `Area: 43.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.77% ✅ / N/A | 596.6 | 420 |
| Prob048_m2014_q4c | ✅ (Func: 100%) | ✅ (Func: 94%) | 0.4984 | `Area: 6.00, Power: 0.0006, Period: 0.00` | `Area: 6.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.68% ✅ / N/A | 468.7 | 420 |
| Prob049_m2014_q4b | ✅ (Func: 100%) | ✅ (Func: 84%) | 0.4988 | `Area: 6.00, Power: 0.0005, Period: 0.00` | `Area: 6.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.75% ✅ / N/A | 564.5 | 420 |
| Prob050_kmap1 | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4944 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.87% ✅ / N/A | 547.6 | 420 |
| Prob051_gates4 | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.4947 | `Area: 16.00, Power: 0.0007, Period: 0.00` | `Area: 16.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.95% ✅ / N/A | 607.0 | 420 |
| Prob052_gates100 | ✅ (Func: 100%) | ✅ (Func: 91%) | 0.3684 | `Area: 443.00, Power: 0.0274, Period: 0.00` | `Area: 254.00, Power: 0.0189, Period: 0.00` | +42.66% ✅ / +31.02% ✅ / N/A | 901.9 | 420 |
| Prob053_m2014_q4d | ❌ (Func: 0%) | ✅ (Func: 18%) | N/A | `Area: 6.00, Power: 0.0017, Period: 0.17` | `N/A` | N/A / N/A / N/A | 453.3 | 420 |
| Prob054_edgedetect | ✅ (Func: 30%) | ✅ (Func: 65%) | 0.0708 | `Area: 87.00, Power: 0.0086, Period: 0.14` | `Area: 87.00, Power: 0.0080, Period: 0.12` | +0.00% ➖ / +6.94% ✅ / +14.29% ✅ | 583.8 | 420 |
| Prob055_conditional | ✅ (Func: 100%) | ✅ (Func: 96%) | 0.5682 | `Area: 243.00, Power: 0.0290, Period: 0.00` | `Area: 208.00, Power: 0.0002, Period: 0.00` | +14.40% ✅ / +99.24% ✅ / N/A | 732.4 | 420 |
| Prob056_ece241_2013_q7 | ✅ (Func: 100%) | ✅ (Func: 95%) | -0.0000 | `Area: 7.00, Power: 0.0007, Period: 0.18` | `Area: 7.00, Power: 0.0007, Period: 0.18` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 635.9 | 420 |
| Prob057_kmap2 | ✅ (Func: 50%) | ✅ (Func: 65%) | 0.6635 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0000, Period: 0.00` | +33.33% ✅ / +99.38% ✅ / N/A | 902.2 | 420 |
| Prob058_alwaysblock2 | ✅ (Func: 100%) | ✅ (Func: 89%) | 0.4974 | `Area: 7.00, Power: 0.0007, Period: 0.00` | `Area: 7.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.49% ✅ / N/A | 529.8 | 420 |
| Prob059_wire4 | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4945 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 418.0 | 420 |
| Prob060_m2014_q4k | ✅ (Func: 90%) | ✅ (Func: 95%) | 0.6660 | `Area: 22.00, Power: 0.0026, Period: 0.14` | `Area: 22.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.81% ✅ / +100.00% ✅ | 585.7 | 420 |
| Prob061_2014_q4a | ✅ (Func: 90%) | ✅ (Func: 94%) | -0.0000 | `Area: 9.00, Power: 0.0008, Period: 0.23` | `Area: 9.00, Power: 0.0008, Period: 0.23` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 533.5 | 420 |
| Prob062_bugs_mux2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 17.00, Power: 0.0006, Period: 0.00` | `N/A` | N/A / N/A / N/A | 477.7 | 420 |
| Prob063_review2015_shiftcount | ❌ (Func: 0%) | ✅ (Func: 49%) | 0.1258 | `Area: 43.00, Power: 0.0067, Period: 0.29` | `Area: 52.00, Power: 0.0032, Period: 0.27` | -20.93% ❌ / +51.78% ✅ / +6.90% ✅ | 761.1 | 420 |
| Prob064_vector3 | ✅ (Func: 100%) | ✅ (Func: 82%) | 0.4945 | `Area: 26.00, Power: 0.0006, Period: 0.00` | `Area: 26.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.89% ✅ / N/A | 635.8 | 420 |
| Prob065_7420 | ✅ (Func: 100%) | ✅ (Func: 87%) | 0.4943 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.86% ✅ / N/A | 622.2 | 420 |
| Prob066_edgecapture | ❌ (Func: 0%) | ✅ (Func: 11%) | N/A | `Area: 437.00, Power: 0.0442, Period: 0.19` | `N/A` | N/A / N/A / N/A | 554.2 | 420 |
| Prob067_countslow | ✅ (Func: 100%) | ✅ (Func: 94%) | 0.0568 | `Area: 47.00, Power: 0.0037, Period: 0.30` | `Area: 40.00, Power: 0.0037, Period: 0.30` | +14.89% ✅ / +2.14% ✅ / +0.00% ➖ | 580.2 | 420 |
| Prob068_countbcd | ❌ (Func: 0%) | ✅ (Func: 55%) | 0.0892 | `Area: 180.00, Power: 0.0146, Period: 0.41` | `Area: 179.00, Power: 0.0122, Period: 0.37` | +0.56% ✅ / +16.44% ✅ / +9.76% ✅ | 931.4 | 420 |
| Prob069_truthtable1 | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.4946 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.92% ✅ / N/A | 558.3 | 420 |
| Prob070_ece241_2013_q2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 871.2 | 420 |
| Prob071_always_casez | ✅ (Func: 80%) | ✅ (Func: 67%) | 0.1524 | `Area: 17.00, Power: 0.0006, Period: 0.00` | `Area: 16.00, Power: 0.0004, Period: 0.00` | +5.88% ✅ / +24.59% ✅ / N/A | 618.1 | 420 |
| Prob072_thermostat | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.0032 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 5.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.65% ✅ / N/A | 544.1 | 420 |
| Prob073_dff16e | ✅ (Func: 100%) | ✅ (Func: 92%) | -0.0000 | `Area: 129.00, Power: 0.0126, Period: 0.20` | `Area: 129.00, Power: 0.0126, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 577.9 | 420 |
| Prob074_ece241_2014_q4 | ✅ (Func: 90%) | ✅ (Func: 47%) | N/A | `Area: 20.00, Power: 0.0031, Period: 0.18` | `N/A` | N/A / N/A / N/A | 694.8 | 420 |
| Prob075_counter_2bc | ✅ (Func: 100%) | ✅ (Func: 94%) | 0.3608 | `Area: 30.00, Power: 0.0059, Period: 0.25` | `Area: 20.00, Power: 0.0027, Period: 0.20` | +33.33% ✅ / +54.90% ✅ / +20.00% ✅ | 664.5 | 420 |
| Prob076_always_case | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.0233 | `Area: 44.00, Power: 0.0019, Period: 0.00` | `Area: 41.00, Power: 0.0019, Period: 0.00` | +6.82% ✅ / -2.16% ❌ / N/A | 586.8 | 420 |
| Prob077_wire_decl | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4947 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.93% ✅ / N/A | 555.1 | 420 |
| Prob078_dualedge | ✅ (Func: 90%) | ✅ (Func: 52%) | 0.4990 | `Area: 11.00, Power: 0.0016, Period: 0.00` | `Area: 11.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.80% ✅ / N/A | 640.5 | 420 |
| Prob079_fsm3onehot | ✅ (Func: 100%) | ✅ (Func: 98%) | -0.0000 | `Area: 8.00, Power: 0.0003, Period: 0.00` | `Area: 8.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 664.3 | 420 |
| Prob080_timer | ✅ (Func: 80%) | ✅ (Func: 84%) | 0.0364 | `Area: 104.00, Power: 0.0121, Period: 0.35` | `Area: 107.00, Power: 0.0097, Period: 0.37` | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | 730.9 | 420 |
| Prob081_7458 | ✅ (Func: 100%) | ✅ (Func: 100%) | 0.4946 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 651.7 | 420 |
| Prob082_lfsr32 | ❌ (Func: 0%) | ✅ (Func: 49%) | 0.0400 | `Area: 221.00, Power: 0.0252, Period: 0.24` | `Area: 198.00, Power: 0.0248, Period: 0.24` | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | 1427.0 | 420 |
| Prob083_mt2015_q4b | ✅ (Func: 100%) | ✅ (Func: 97%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 555.3 | 420 |
| Prob084_ece241_2013_q12 | ✅ (Func: 100%) | ✅ (Func: 80%) | 0.6641 | `Area: 67.00, Power: 0.0113, Period: 0.18` | `Area: 67.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +99.23% ✅ / +100.00% ✅ | 631.8 | 420 |
| Prob085_shift4 | ✅ (Func: 100%) | ✅ (Func: 96%) | -0.0000 | `Area: 39.00, Power: 0.0036, Period: 0.24` | `Area: 39.00, Power: 0.0036, Period: 0.24` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 611.7 | 420 |
| Prob086_lfsr5 | ✅ (Func: 10%) | ✅ (Func: 41%) | 0.0528 | `Area: 37.00, Power: 0.0038, Period: 0.18` | `Area: 33.00, Power: 0.0036, Period: 0.18` | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | 634.7 | 420 |
| Prob087_gates | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.4947 | `Area: 16.00, Power: 0.0006, Period: 0.00` | `Area: 16.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.94% ✅ / N/A | 735.2 | 420 |
| Prob088_ece241_2014_q5b | ✅ (Func: 100%) | ✅ (Func: 92%) | 0.0265 | `Area: 10.00, Power: 0.0004, Period: 0.15` | `Area: 9.00, Power: 0.0004, Period: 0.15` | +10.00% ✅ / -2.06% ❌ / +0.00% ➖ | 619.7 | 420 |
| Prob089_ece241_2014_q5a | ✅ (Func: 30%) | ✅ (Func: 48%) | 0.4593 | `Area: 23.00, Power: 0.0027, Period: 0.22` | `Area: 14.00, Power: 0.0009, Period: 0.15` | +39.13% ✅ / +66.83% ✅ / +31.82% ✅ | 721.9 | 420 |
| Prob090_circuit1 | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.89% ✅ / N/A | 449.0 | 420 |
| Prob091_2012_q2b | ✅ (Func: 90%) | ✅ (Func: 91%) | 0.6206 | `Area: 4.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +25.00% ✅ / +99.12% ✅ / N/A | 713.7 | 420 |
| Prob092_gatesv100 | ✅ (Func: 90%) | ✅ (Func: 55%) | -0.0000 | `Area: 637.00, Power: 0.0240, Period: 0.00` | `Area: 637.00, Power: 0.0240, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 787.0 | 420 |
| Prob093_ece241_2014_q3 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 4.00, Power: 0.0001, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1119.8 | 420 |
| Prob094_gatesv | ✅ (Func: 80%) | ✅ (Func: 48%) | -0.0000 | `Area: 24.00, Power: 0.0009, Period: 0.00` | `Area: 24.00, Power: 0.0009, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 685.1 | 420 |
| Prob095_review2015_fsmshift | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 24.00, Power: 0.0025, Period: 0.15` | `N/A` | N/A / N/A / N/A | 608.3 | 420 |
| Prob096_review2015_fsmseq | ✅ (Func: 30%) | ✅ (Func: 76%) | -0.0000 | `Area: 33.00, Power: 0.0036, Period: 0.19` | `Area: 33.00, Power: 0.0036, Period: 0.19` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 696.7 | 420 |
| Prob097_mux9to1v | ✅ (Func: 100%) | ✅ (Func: 86%) | 0.1537 | `Area: 269.00, Power: 0.0122, Period: 0.00` | `Area: 226.00, Power: 0.0104, Period: 0.00` | +15.99% ✅ / +14.75% ✅ / N/A | 868.0 | 420 |
| Prob098_circuit7 | ✅ (Func: 60%) | ✅ (Func: 87%) | 0.4986 | `Area: 5.00, Power: 0.0005, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.71% ✅ / N/A | 492.3 | 420 |
| Prob099_m2014_q6c | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0001, Period: 0.00` | `N/A` | N/A / N/A / N/A | 534.6 | 420 |
| Prob100_fsm3comb | ✅ (Func: 100%) | ✅ (Func: 91%) | -0.0000 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 695.0 | 420 |
| Prob101_circuit4 | ✅ (Func: 100%) | ✅ (Func: 96%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 537.0 | 420 |
| Prob102_circuit3 | ✅ (Func: 90%) | ✅ (Func: 92%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 513.0 | 420 |
| Prob103_circuit2 | ✅ (Func: 100%) | ✅ (Func: 95%) | -0.0000 | `Area: 8.00, Power: 0.0006, Period: 0.00` | `Area: 8.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 532.0 | 420 |
| Prob104_mt2015_muxdff | ❌ (Func: 0%) | ✅ (Func: 10%) | N/A | `Area: 6.00, Power: 0.0006, Period: 0.00` | `N/A` | N/A / N/A / N/A | 520.3 | 420 |
| Prob105_rotate100 | ✅ (Func: 100%) | ✅ (Func: 89%) | 0.0513 | `Area: 1033.00, Power: 0.1020, Period: 0.22` | `Area: 948.00, Power: 0.0947, Period: 0.22` | +8.23% ✅ / +7.16% ✅ / +0.00% ➖ | 1436.5 | 420 |
| Prob106_always_nolatches | ✅ (Func: 100%) | ✅ (Func: 100%) | 0.3879 | `Area: 30.00, Power: 0.0006, Period: 0.00` | `Area: 20.00, Power: 0.0003, Period: 0.00` | +33.33% ✅ / +44.24% ✅ / N/A | 608.9 | 420 |
| Prob107_fsm1s | ✅ (Func: 60%) | ✅ (Func: 78%) | 0.0178 | `Area: 7.00, Power: 0.0009, Period: 0.20` | `Area: 7.00, Power: 0.0009, Period: 0.19` | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | 611.1 | 420 |
| Prob108_rule90 | ✅ (Func: 80%) | ✅ (Func: 81%) | 0.5826 | `Area: 4198.00, Power: 0.8200, Period: 0.23` | `Area: 4607.00, Power: 0.1270, Period: 0.00` | -9.74% ❌ / +84.51% ✅ / +100.00% ✅ | 7030.9 | 420 |
| Prob109_fsm1 | ✅ (Func: 90%) | ✅ (Func: 87%) | -0.0000 | `Area: 7.00, Power: 0.0018, Period: 0.16` | `Area: 7.00, Power: 0.0018, Period: 0.16` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 651.4 | 420 |
| Prob110_fsm2 | ✅ (Func: 70%) | ✅ (Func: 75%) | 0.0372 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.18` | +0.00% ➖ / +1.15% ✅ / +10.00% ✅ | 569.8 | 420 |
| Prob111_fsm2s | ✅ (Func: 50%) | ✅ (Func: 79%) | -0.0000 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 736.2 | 420 |
| Prob112_always_case2 | ❌ (Func: 0%) | ✅ (Func: 69%) | 0.0026 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.52% ✅ / N/A | 528.4 | 420 |
| Prob113_2012_q1g | ❌ (Func: 0%) | ✅ (Func: 37%) | 0.0023 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 5.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.47% ✅ / N/A | 951.6 | 420 |
| Prob114_bugs_case | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.2889 | `Area: 53.00, Power: 0.0021, Period: 0.00` | `Area: 38.00, Power: 0.0015, Period: 0.00` | +28.30% ✅ / +29.47% ✅ / N/A | 631.5 | 420 |
| Prob115_shift18 | ✅ (Func: 100%) | ✅ (Func: 88%) | 0.2546 | `Area: 950.00, Power: 0.0963, Period: 0.37` | `Area: 796.00, Power: 0.0696, Period: 0.25` | +16.21% ✅ / +27.73% ✅ / +32.43% ✅ | 1046.6 | 420 |
| Prob116_m2014_q3 | ❌ (Func: 0%) | ✅ (Func: 14%) | 0.3306 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0001, Period: 0.00` | +20.00% ✅ / +46.11% ✅ / N/A | 831.3 | 420 |
| Prob117_circuit9 | ✅ (Func: 40%) | ✅ (Func: 80%) | 0.2025 | `Area: 26.00, Power: 0.0047, Period: 0.24` | `Area: 23.00, Power: 0.0026, Period: 0.23` | +11.54% ✅ / +45.05% ✅ / +4.17% ✅ | 626.1 | 420 |
| Prob118_history_shift | ✅ (Func: 70%) | ✅ (Func: 86%) | -0.0000 | `Area: 322.00, Power: 0.0312, Period: 0.24` | `Area: 322.00, Power: 0.0312, Period: 0.24` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 667.3 | 420 |
| Prob119_fsm3 | ✅ (Func: 30%) | ✅ (Func: 74%) | -0.0000 | `Area: 17.00, Power: 0.0014, Period: 0.19` | `Area: 17.00, Power: 0.0014, Period: 0.19` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 641.2 | 420 |
| Prob120_fsm3s | ✅ (Func: 30%) | ✅ (Func: 77%) | 0.2913 | `Area: 27.00, Power: 0.0029, Period: 0.18` | `Area: 17.00, Power: 0.0014, Period: 0.18` | +37.04% ✅ / +50.35% ✅ / +0.00% ➖ | 648.5 | 420 |
| Prob121_2014_q3bfsm | ✅ (Func: 100%) | ✅ (Func: 78%) | 0.0035 | `Area: 39.00, Power: 0.0039, Period: 0.21` | `Area: 39.00, Power: 0.0038, Period: 0.21` | +0.00% ➖ / +1.04% ✅ / +0.00% ➖ | 712.5 | 420 |
| Prob122_kmap4 | ✅ (Func: 90%) | ✅ (Func: 94%) | -0.0000 | `Area: 5.00, Power: 0.0003, Period: 0.00` | `Area: 5.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 543.8 | 420 |
| Prob123_bugs_addsubz | ✅ (Func: 90%) | ✅ (Func: 97%) | 0.5947 | `Area: 90.00, Power: 0.0073, Period: 0.00` | `Area: 72.00, Power: 0.0001, Period: 0.00` | +20.00% ✅ / +98.94% ✅ / N/A | 783.3 | 420 |
| Prob124_rule110 | ✅ (Func: 60%) | ✅ (Func: 57%) | 0.6170 | `Area: 5000.00, Power: 0.5580, Period: 0.22` | `Area: 5671.00, Power: 0.0083, Period: 0.00` | -13.42% ❌ / +98.51% ✅ / +100.00% ✅ | 4025.3 | 420 |
| Prob125_kmap3 | ✅ (Func: 50%) | ✅ (Func: 71%) | 0.0091 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +1.82% ✅ / N/A | 704.1 | 420 |
| Prob126_circuit6 | ✅ (Func: 100%) | ✅ (Func: 81%) | 0.3524 | `Area: 60.00, Power: 0.0028, Period: 0.00` | `Area: 37.00, Power: 0.0019, Period: 0.00` | +38.33% ✅ / +32.16% ✅ / N/A | 614.2 | 420 |
| Prob127_lemmings1 | ✅ (Func: 10%) | ✅ (Func: 38%) | -0.0000 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 588.5 | 420 |
| Prob128_fsm_ps2 | ✅ (Func: 50%) | ✅ (Func: 49%) | 0.1276 | `Area: 26.00, Power: 0.0028, Period: 0.17` | `Area: 20.00, Power: 0.0022, Period: 0.18` | +23.08% ✅ / +21.07% ✅ / -5.88% ❌ | 577.1 | 420 |
| Prob129_ece241_2013_q8 | ✅ (Func: 100%) | ✅ (Func: 75%) | 0.0854 | `Area: 15.00, Power: 0.0013, Period: 0.17` | `Area: 13.00, Power: 0.0012, Period: 0.16` | +13.33% ✅ / +6.40% ✅ / +5.88% ✅ | 684.2 | 420 |
| Prob130_circuit5 | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.1301 | `Area: 34.00, Power: 0.0015, Period: 0.00` | `Area: 32.00, Power: 0.0012, Period: 0.00` | +5.88% ✅ / +20.13% ✅ / N/A | 643.6 | 420 |
| Prob131_mt2015_q4 | ❌ (Func: 0%) | ✅ (Func: 87%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 745.9 | 420 |
| Prob132_always_if2 | ✅ (Func: 100%) | ✅ (Func: 100%) | -0.0000 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 495.2 | 420 |
| Prob133_2014_q3fsm | ✅ (Func: 20%) | ✅ (Func: 52%) | 0.0722 | `Area: 56.00, Power: 0.0060, Period: 0.25` | `Area: 48.00, Power: 0.0046, Period: 0.29` | +14.29% ✅ / +23.36% ✅ / -16.00% ❌ | 910.4 | 420 |
| Prob134_2014_q3c | ✅ (Func: 70%) | ✅ (Func: 82%) | 0.0440 | `Area: 7.00, Power: 0.0003, Period: 0.00` | `Area: 7.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +8.80% ✅ / N/A | 720.7 | 420 |
| Prob135_m2014_q6b | ❌ (Func: 0%) | ✅ (Func: 65%) | 0.2794 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0001, Period: 0.00` | +20.00% ✅ / +35.87% ✅ / N/A | 788.7 | 420 |
| Prob136_m2014_q6 | ✅ (Func: 50%) | ✅ (Func: 70%) | 0.0120 | `Area: 43.00, Power: 0.0044, Period: 0.20` | `Area: 44.00, Power: 0.0046, Period: 0.18` | -2.33% ❌ / -4.06% ❌ / +10.00% ✅ | 673.9 | 420 |
| Prob137_fsm_serial | ❌ (Func: 0%) | ✅ (Func: 50%) | 0.1244 | `Area: 99.00, Power: 0.0098, Period: 0.18` | `Area: 64.00, Power: 0.0052, Period: 0.26` | +35.35% ✅ / +46.41% ✅ / -44.44% ❌ | 846.2 | 420 |
| Prob138_2012_q2fsm | ✅ (Func: 20%) | ✅ (Func: 75%) | 0.1110 | `Area: 46.00, Power: 0.0046, Period: 0.23` | `Area: 42.00, Power: 0.0044, Period: 0.18` | +8.70% ✅ / +2.86% ✅ / +21.74% ✅ | 612.6 | 420 |
| Prob139_2013_q2bfsm | ❌ (Func: 0%) | ✅ (Func: 0%) | N/A | `Area: 52.00, Power: 0.0055, Period: 0.20` | `N/A` | N/A / N/A / N/A | 1215.8 | 420 |
| Prob140_fsm_hdlc | ✅ (Func: 10%) | ✅ (Func: 31%) | 0.3206 | `Area: 68.00, Power: 0.0075, Period: 0.29` | `Area: 48.00, Power: 0.0046, Period: 0.21` | +29.41% ✅ / +39.18% ✅ / +27.59% ✅ | 900.6 | 420 |
| Prob141_count_clock | ✅ (Func: 10%) | ✅ (Func: 44%) | 0.1652 | `Area: 308.00, Power: 0.0190, Period: 0.47` | `Area: 268.00, Power: 0.0165, Period: 0.36` | +12.99% ✅ / +13.16% ✅ / +23.40% ✅ | 1626.4 | 420 |
| Prob142_lemmings2 | ❌ (Func: 0%) | ✅ (Func: 40%) | 0.0786 | `Area: 20.00, Power: 0.0024, Period: 0.21` | `Area: 19.00, Power: 0.0019, Period: 0.21` | +5.00% ✅ / +18.57% ✅ / +0.00% ➖ | 751.4 | 420 |
| Prob143_fsm_onehot | ✅ (Func: 60%) | ✅ (Func: 74%) | 0.1922 | `Area: 26.00, Power: 0.0006, Period: 0.00` | `Area: 20.00, Power: 0.0005, Period: 0.00` | +23.08% ✅ / +15.37% ✅ / N/A | 1111.1 | 420 |
| Prob144_conwaylife | ✅ (Func: 70%) | ✅ (Func: 50%) | 0.0695 | `Area: 9113.00, Power: 1.9500, Period: 0.74` | `Area: 8909.00, Power: 1.6400, Period: 0.72` | +2.24% ✅ / +15.90% ✅ / +2.70% ✅ | 5571.8 | 220 |
| Prob145_circuit8 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 8.00, Power: 0.0011, Period: 0.00` | `N/A` | N/A / N/A / N/A | 591.2 | 420 |
| Prob146_fsm_serialdata | ✅ (Func: 20%) | ✅ (Func: 50%) | -0.3526 | `Area: 146.00, Power: 0.0141, Period: 0.18` | `Area: 190.00, Power: 0.0185, Period: 0.26` | -30.14% ❌ / -31.21% ❌ / -44.44% ❌ | 866.5 | 420 |
| Prob147_circuit10 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 9.00, Power: 0.0008, Period: 0.19` | `N/A` | N/A / N/A / N/A | 678.8 | 420 |
| Prob148_2013_q2afsm | ✅ (Func: 90%) | ✅ (Func: 83%) | 0.1754 | `Area: 35.00, Power: 0.0033, Period: 0.22` | `Area: 26.00, Power: 0.0024, Period: 0.22` | +25.71% ✅ / +26.91% ✅ / +0.00% ➖ | 787.6 | 420 |
| Prob149_ece241_2013_q4 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 52.00, Power: 0.0049, Period: 0.23` | `N/A` | N/A / N/A / N/A | 983.7 | 420 |
| Prob150_review2015_fsmonehot | ✅ (Func: 40%) | ✅ (Func: 87%) | 0.0015 | `Area: 13.00, Power: 0.0003, Period: 0.00` | `Area: 13.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.29% ✅ / N/A | 813.1 | 420 |
| Prob151_review2015_fsm | ❌ (Func: 0%) | ✅ (Func: 27%) | -0.1052 | `Area: 66.00, Power: 0.0045, Period: 0.28` | `Area: 71.00, Power: 0.0067, Period: 0.21` | -7.58% ❌ / -48.99% ❌ / +25.00% ✅ | 881.9 | 420 |
| Prob152_lemmings3 | ❌ (Func: 0%) | ✅ (Func: 50%) | 0.2420 | `Area: 50.00, Power: 0.0054, Period: 0.23` | `Area: 30.00, Power: 0.0034, Period: 0.24` | +40.00% ✅ / +36.95% ✅ / -4.35% ❌ | 1037.8 | 420 |
| Prob153_gshare | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 3025.00, Power: 0.4370, Period: 0.75` | `N/A` | N/A / N/A / N/A | 1117.4 | 420 |
| Prob154_fsm_ps2data | ✅ (Func: 50%) | ✅ (Func: 43%) | -0.5515 | `Area: 134.00, Power: 0.0138, Period: 0.17` | `Area: 230.00, Power: 0.0235, Period: 0.21` | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | 668.2 | 420 |
| Prob155_lemmings4 | ❌ (Func: 0%) | ✅ (Func: 50%) | 0.2368 | `Area: 102.00, Power: 0.0177, Period: 0.28` | `Area: 102.00, Power: 0.0058, Period: 0.27` | +0.00% ➖ / +67.46% ✅ / +3.57% ✅ | 1183.7 | 420 |
| Prob156_review2015_fancytimer | ❌ (Func: 0%) | ✅ (Func: 0%) | N/A | `Area: 187.00, Power: 0.0219, Period: 0.46` | `N/A` | N/A / N/A / N/A | 1468.4 | 420 |