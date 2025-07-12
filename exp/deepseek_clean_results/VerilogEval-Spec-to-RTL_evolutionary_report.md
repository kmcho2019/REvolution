# 🧬 BENCHMARK EVOLUTION REPORT: VerilogEval-Spec-to-RTL

## 📈 Summary
- **Total Problems Analyzed:** 156
- **Average Runtime per Problem:** 1515.80s
- **Average LLM API Calls per Problem:** 430.0

### ✅ Pass Rate Analysis
| Metric | Initial Any Passing Gen | Any Passing Gen | Initial Pass@1 | Final Pass@1 | Change |
|:---|:---|:---|:---|:---|:---|
| **Syntax** | 98.1% (153/156) | 99.4% (155/156) | 94.2% | 94.7% | **+0.5%** |
| **Functionality** | 83.3% (130/156) | 95.5% (149/156) | 69.7% | 66.2% | **-3.5%** |
| **Synthesis** | 80.1% (125/156) | 90.4% (141/156) | 67.4% | 63.6% | **-3.8%** |

### ⚡ PPA Optimization Summary
- **Problems with PPA Improvement (Best Solution Compared to Reference):** 86 / 156 (55.1%)

| PPA Metric | Average Improvement |
|:-----------|:--------------------|
| **Area** | +6.51% |
| **Power** | +30.61% |
| **Performance (Period)** | +7.65% |

## 🧬 Strategy Analysis
Shows how often each strategy was used and its success rate (rewarded).
| Strategy | Times Used | Success Count | Success Rate |
|:---------|:-----------|:--------------|:-------------|
| `M-R` | 6276 (19.2%) | 204 | 3.3% |
| `M-S` | 6245 (19.1%) | 204 | 3.3% |
| `M-I` | 6243 (19.1%) | 203 | 3.3% |
| `M-E` | 6229 (19.0%) | 205 | 3.3% |
| `C-F` | 5282 (16.1%) | 140 | 2.7% |
| `initial` | 1560 (4.8%) | 0 | 0.0% |
| `M-F` | 925 (2.8%) | 62 | 6.7% |

## 📋 Detailed Problem-by-Problem Analysis
| Problem | Initial Status | Final Status | Best Score | Reference PPA | Best Evo. PPA | PPA % Improv. (A/P/T) | Runtime (s) | API Calls |
|:---|:---|:---|:---:|:---|:---|:---|:---:|:---:|
| Prob001_zero | ✅ (Func: 100%) | ✅ (Func: 86%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1055.3 | 430 |
| Prob002_m2014_q4i | ✅ (Func: 100%) | ✅ (Func: 84%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1054.6 | 430 |
| Prob003_step_one | ✅ (Func: 100%) | ✅ (Func: 80%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1022.3 | 430 |
| Prob004_vector2 | ✅ (Func: 100%) | ✅ (Func: 91%) | 0.4945 | `Area: 26.00, Power: 0.0007, Period: 0.00` | `Area: 26.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1239.8 | 430 |
| Prob005_notgate | ✅ (Func: 100%) | ✅ (Func: 93%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1130.4 | 430 |
| Prob006_vectorr | ✅ (Func: 100%) | ✅ (Func: 90%) | 0.4945 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1304.2 | 430 |
| Prob007_wire | ✅ (Func: 100%) | ✅ (Func: 90%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1111.1 | 430 |
| Prob008_m2014_q4h | ✅ (Func: 100%) | ✅ (Func: 78%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1021.6 | 430 |
| Prob009_popcount3 | ✅ (Func: 100%) | ✅ (Func: 88%) | -0.0000 | `Area: 4.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1225.0 | 430 |
| Prob010_mt2015_q4a | ✅ (Func: 100%) | ✅ (Func: 97%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1161.6 | 430 |
| Prob011_norgate | ✅ (Func: 100%) | ✅ (Func: 88%) | 0.4942 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.84% ✅ / N/A | 1294.1 | 430 |
| Prob012_xnorgate | ✅ (Func: 100%) | ✅ (Func: 90%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1161.9 | 430 |
| Prob013_m2014_q4e | ✅ (Func: 100%) | ✅ (Func: 90%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1178.6 | 430 |
| Prob014_andgate | ✅ (Func: 100%) | ✅ (Func: 94%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1193.2 | 430 |
| Prob015_vector1 | ✅ (Func: 100%) | ✅ (Func: 94%) | -0.0000 | `Area: 13.00, Power: 0.0003, Period: 0.00` | `Area: 13.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1195.8 | 430 |
| Prob016_m2014_q4j | ✅ (Func: 100%) | ✅ (Func: 92%) | 0.6365 | `Area: 25.00, Power: 0.0013, Period: 0.00` | `Area: 18.00, Power: 0.0000, Period: 0.00` | +28.00% ✅ / +99.29% ✅ / N/A | 1589.3 | 430 |
| Prob017_mux2to1v | ✅ (Func: 100%) | ✅ (Func: 89%) | -0.0000 | `Area: 208.00, Power: 0.0071, Period: 0.00` | `Area: 208.00, Power: 0.0071, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1364.8 | 430 |
| Prob018_mux256to1 | ✅ (Func: 100%) | ✅ (Func: 79%) | 0.5364 | `Area: 522.00, Power: 0.0237, Period: 0.00` | `Area: 479.00, Power: 0.0002, Period: 0.00` | +8.24% ✅ / +99.05% ✅ / N/A | 1803.8 | 430 |
| Prob019_m2014_q4f | ✅ (Func: 100%) | ✅ (Func: 94%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1143.2 | 430 |
| Prob020_mt2015_eq2 | ✅ (Func: 100%) | ✅ (Func: 99%) | -0.0000 | `Area: 5.00, Power: 0.0003, Period: 0.00` | `Area: 5.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1251.1 | 430 |
| Prob021_mux256to1v | ✅ (Func: 100%) | ✅ (Func: 80%) | 0.3605 | `Area: 2040.00, Power: 0.0942, Period: 0.00` | `Area: 1550.00, Power: 0.0489, Period: 0.00` | +24.02% ✅ / +48.09% ✅ / N/A | 2350.4 | 430 |
| Prob022_mux2to1 | ✅ (Func: 100%) | ✅ (Func: 95%) | -0.0000 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1197.9 | 430 |
| Prob023_vector100r | ✅ (Func: 100%) | ✅ (Func: 83%) | -0.0000 | `Area: 80.00, Power: 0.0021, Period: 0.00` | `Area: 80.00, Power: 0.0021, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1562.0 | 430 |
| Prob024_hadd | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.4946 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.93% ✅ / N/A | 1114.0 | 430 |
| Prob025_reduction | ✅ (Func: 100%) | ✅ (Func: 92%) | -0.0000 | `Area: 11.00, Power: 0.0009, Period: 0.00` | `Area: 11.00, Power: 0.0009, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1350.9 | 430 |
| Prob026_alwaysblock1 | ✅ (Func: 30%) | ✅ (Func: 60%) | 0.4945 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1157.9 | 430 |
| Prob027_fadd | ✅ (Func: 100%) | ✅ (Func: 94%) | -0.0000 | `Area: 4.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1311.3 | 430 |
| Prob028_m2014_q4a | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.3121 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +33.33% ✅ / +29.09% ✅ / N/A | 1098.5 | 430 |
| Prob029_m2014_q4g | ✅ (Func: 100%) | ✅ (Func: 96%) | 0.4948 | `Area: 5.00, Power: 0.0004, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.96% ✅ / N/A | 1197.4 | 430 |
| Prob030_popcount255 | ✅ (Func: 60%) | ✅ (Func: 65%) | 0.0658 | `Area: 1339.00, Power: 0.2150, Period: 0.00` | `Area: 1306.00, Power: 0.1920, Period: 0.00` | +2.46% ✅ / +10.70% ✅ / N/A | 2687.8 | 430 |
| Prob031_dff | ✅ (Func: 100%) | ✅ (Func: 83%) | 0.4987 | `Area: 5.00, Power: 0.0005, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.74% ✅ / N/A | 1184.8 | 430 |
| Prob032_vector0 | ✅ (Func: 100%) | ✅ (Func: 95%) | 0.4945 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 1108.8 | 430 |
| Prob033_ece241_2014_q1c | ✅ (Func: 100%) | ✅ (Func: 79%) | 0.3835 | `Area: 52.00, Power: 0.0032, Period: 0.00` | `Area: 34.00, Power: 0.0018, Period: 0.00` | +34.62% ✅ / +42.09% ✅ / N/A | 1654.9 | 430 |
| Prob034_dff8 | ❌ (Func: 0%) | ✅ (Func: 15%) | N/A | `Area: 36.00, Power: 0.0036, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1069.6 | 430 |
| Prob035_count1to10 | ✅ (Func: 100%) | ✅ (Func: 85%) | 0.0778 | `Area: 41.00, Power: 0.0044, Period: 0.26` | `Area: 33.00, Power: 0.0039, Period: 0.28` | +19.51% ✅ / +11.51% ✅ / -7.69% ❌ | 1370.0 | 430 |
| Prob036_ringer | ✅ (Func: 100%) | ✅ (Func: 94%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1213.4 | 430 |
| Prob037_review2015_count1k | ✅ (Func: 100%) | ✅ (Func: 74%) | 0.0175 | `Area: 93.00, Power: 0.0077, Period: 0.38` | `Area: 93.00, Power: 0.0077, Period: 0.36` | +0.00% ➖ / +0.00% ➖ / +5.26% ✅ | 1326.3 | 430 |
| Prob038_count15 | ✅ (Func: 100%) | ✅ (Func: 79%) | 0.0409 | `Area: 30.00, Power: 0.0033, Period: 0.25` | `Area: 31.00, Power: 0.0032, Period: 0.22` | -3.33% ❌ / +3.61% ✅ / +12.00% ✅ | 1223.0 | 430 |
| Prob039_always_if | ✅ (Func: 20%) | ✅ (Func: 66%) | 0.4947 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.94% ✅ / N/A | 1216.9 | 430 |
| Prob040_count10 | ✅ (Func: 100%) | ✅ (Func: 87%) | 0.0736 | `Area: 39.00, Power: 0.0037, Period: 0.26` | `Area: 32.00, Power: 0.0033, Period: 0.28` | +17.95% ✅ / +11.83% ✅ / -7.69% ❌ | 1358.5 | 430 |
| Prob041_dff8r | ✅ (Func: 90%) | ✅ (Func: 76%) | 0.4981 | `Area: 57.00, Power: 0.0053, Period: 0.00` | `Area: 57.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.61% ✅ / N/A | 1613.8 | 430 |
| Prob042_vector4 | ✅ (Func: 100%) | ✅ (Func: 92%) | -0.0000 | `Area: 26.00, Power: 0.0007, Period: 0.00` | `Area: 26.00, Power: 0.0007, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1138.5 | 430 |
| Prob043_vector5 | ✅ (Func: 90%) | ✅ (Func: 72%) | -0.0000 | `Area: 39.00, Power: 0.0019, Period: 0.00` | `Area: 39.00, Power: 0.0019, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1622.3 | 430 |
| Prob044_vectorgates | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.4944 | `Area: 10.00, Power: 0.0003, Period: 0.00` | `Area: 10.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.88% ✅ / N/A | 1339.0 | 430 |
| Prob045_edgedetect2 | ✅ (Func: 10%) | ✅ (Func: 44%) | -0.0000 | `Area: 85.00, Power: 0.0087, Period: 0.17` | `Area: 85.00, Power: 0.0087, Period: 0.17` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1267.1 | 430 |
| Prob046_dff8p | ✅ (Func: 100%) | ✅ (Func: 90%) | 0.4310 | `Area: 52.00, Power: 0.0061, Period: 0.00` | `Area: 59.00, Power: 0.0000, Period: 0.00` | -13.46% ❌ / +99.67% ✅ / N/A | 1343.6 | 430 |
| Prob047_dff8ar | ✅ (Func: 100%) | ✅ (Func: 91%) | 0.4989 | `Area: 43.00, Power: 0.0038, Period: 0.00` | `Area: 43.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.77% ✅ / N/A | 1412.7 | 430 |
| Prob048_m2014_q4c | ✅ (Func: 100%) | ✅ (Func: 90%) | 0.4984 | `Area: 6.00, Power: 0.0006, Period: 0.00` | `Area: 6.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.68% ✅ / N/A | 1225.8 | 430 |
| Prob049_m2014_q4b | ✅ (Func: 100%) | ✅ (Func: 70%) | -0.0000 | `Area: 6.00, Power: 0.0005, Period: 0.00` | `Area: 6.00, Power: 0.0005, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1321.4 | 430 |
| Prob050_kmap1 | ✅ (Func: 100%) | ✅ (Func: 95%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1185.9 | 430 |
| Prob051_gates4 | ✅ (Func: 100%) | ✅ (Func: 93%) | 0.4947 | `Area: 16.00, Power: 0.0007, Period: 0.00` | `Area: 16.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.95% ✅ / N/A | 1380.3 | 430 |
| Prob052_gates100 | ✅ (Func: 100%) | ✅ (Func: 80%) | 0.3684 | `Area: 443.00, Power: 0.0274, Period: 0.00` | `Area: 254.00, Power: 0.0189, Period: 0.00` | +42.66% ✅ / +31.02% ✅ / N/A | 1966.3 | 430 |
| Prob053_m2014_q4d | ❌ (Func: 0%) | ✅ (Func: 20%) | N/A | `Area: 6.00, Power: 0.0017, Period: 0.17` | `N/A` | N/A / N/A / N/A | 945.1 | 430 |
| Prob054_edgedetect | ✅ (Func: 80%) | ✅ (Func: 42%) | 0.0708 | `Area: 87.00, Power: 0.0086, Period: 0.14` | `Area: 87.00, Power: 0.0080, Period: 0.12` | +0.00% ➖ / +6.94% ✅ / +14.29% ✅ | 1218.4 | 430 |
| Prob055_conditional | ✅ (Func: 100%) | ✅ (Func: 93%) | 0.5682 | `Area: 243.00, Power: 0.0290, Period: 0.00` | `Area: 208.00, Power: 0.0002, Period: 0.00` | +14.40% ✅ / +99.24% ✅ / N/A | 1429.0 | 430 |
| Prob056_ece241_2013_q7 | ✅ (Func: 100%) | ✅ (Func: 91%) | -0.0000 | `Area: 7.00, Power: 0.0007, Period: 0.18` | `Area: 7.00, Power: 0.0007, Period: 0.18` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1353.0 | 430 |
| Prob057_kmap2 | ❌ (Func: 0%) | ✅ (Func: 32%) | 0.3780 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0001, Period: 0.00` | +33.33% ✅ / +42.26% ✅ / N/A | 1313.0 | 430 |
| Prob058_alwaysblock2 | ❌ (Func: 0%) | ✅ (Func: 64%) | 0.4974 | `Area: 7.00, Power: 0.0007, Period: 0.00` | `Area: 7.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.49% ✅ / N/A | 1283.8 | 430 |
| Prob059_wire4 | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.4945 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1122.1 | 430 |
| Prob060_m2014_q4k | ✅ (Func: 100%) | ✅ (Func: 84%) | 0.6660 | `Area: 22.00, Power: 0.0026, Period: 0.14` | `Area: 22.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.81% ✅ / +100.00% ✅ | 1199.3 | 430 |
| Prob061_2014_q4a | ✅ (Func: 90%) | ✅ (Func: 75%) | -0.0000 | `Area: 9.00, Power: 0.0008, Period: 0.23` | `Area: 9.00, Power: 0.0008, Period: 0.23` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1296.4 | 430 |
| Prob062_bugs_mux2 | ❌ (Func: 0%) | ✅ (Func: 17%) | -0.0000 | `Area: 17.00, Power: 0.0006, Period: 0.00` | `Area: 17.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1111.3 | 430 |
| Prob063_review2015_shiftcount | ✅ (Func: 60%) | ✅ (Func: 79%) | -0.0000 | `Area: 43.00, Power: 0.0067, Period: 0.29` | `Area: 43.00, Power: 0.0067, Period: 0.29` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1323.3 | 430 |
| Prob064_vector3 | ✅ (Func: 100%) | ✅ (Func: 77%) | -0.0000 | `Area: 26.00, Power: 0.0006, Period: 0.00` | `Area: 26.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1325.6 | 430 |
| Prob065_7420 | ✅ (Func: 100%) | ✅ (Func: 85%) | 0.4943 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.86% ✅ / N/A | 1387.5 | 430 |
| Prob066_edgecapture | ❌ (Func: 0%) | ✅ (Func: 2%) | N/A | `Area: 437.00, Power: 0.0442, Period: 0.19` | `N/A` | N/A / N/A / N/A | 1080.2 | 430 |
| Prob067_countslow | ✅ (Func: 100%) | ✅ (Func: 87%) | 0.1127 | `Area: 47.00, Power: 0.0037, Period: 0.30` | `Area: 38.00, Power: 0.0037, Period: 0.26` | +19.15% ✅ / +1.34% ✅ / +13.33% ✅ | 1412.3 | 430 |
| Prob068_countbcd | ✅ (Func: 70%) | ✅ (Func: 52%) | 0.6624 | `Area: 180.00, Power: 0.0146, Period: 0.41` | `Area: 182.00, Power: 0.0000, Period: 0.00` | -1.11% ❌ / +99.82% ✅ / +100.00% ✅ | 1716.6 | 430 |
| Prob069_truthtable1 | ✅ (Func: 100%) | ✅ (Func: 97%) | -0.0000 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1335.6 | 430 |
| Prob070_ece241_2013_q2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1422.8 | 430 |
| Prob071_always_casez | ✅ (Func: 60%) | ✅ (Func: 86%) | 0.1524 | `Area: 17.00, Power: 0.0006, Period: 0.00` | `Area: 16.00, Power: 0.0004, Period: 0.00` | +5.88% ✅ / +24.59% ✅ / N/A | 1412.2 | 430 |
| Prob072_thermostat | ✅ (Func: 100%) | ✅ (Func: 86%) | 0.0032 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 5.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.65% ✅ / N/A | 1540.8 | 430 |
| Prob073_dff16e | ✅ (Func: 100%) | ✅ (Func: 87%) | 0.6653 | `Area: 129.00, Power: 0.0126, Period: 0.20` | `Area: 129.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +99.59% ✅ / +100.00% ✅ | 1406.0 | 430 |
| Prob074_ece241_2014_q4 | ✅ (Func: 20%) | ✅ (Func: 52%) | N/A | `Area: 20.00, Power: 0.0031, Period: 0.18` | `N/A` | N/A / N/A / N/A | 1257.6 | 430 |
| Prob075_counter_2bc | ✅ (Func: 90%) | ✅ (Func: 84%) | 0.3701 | `Area: 30.00, Power: 0.0059, Period: 0.25` | `Area: 21.00, Power: 0.0021, Period: 0.21` | +30.00% ✅ / +65.03% ✅ / +16.00% ✅ | 1395.9 | 430 |
| Prob076_always_case | ✅ (Func: 100%) | ✅ (Func: 91%) | 0.0379 | `Area: 44.00, Power: 0.0019, Period: 0.00` | `Area: 39.00, Power: 0.0019, Period: 0.00` | +11.36% ✅ / -3.78% ❌ / N/A | 1419.0 | 430 |
| Prob077_wire_decl | ✅ (Func: 100%) | ✅ (Func: 90%) | 0.4947 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.93% ✅ / N/A | 1239.3 | 430 |
| Prob078_dualedge | ✅ (Func: 50%) | ✅ (Func: 42%) | -0.0000 | `Area: 11.00, Power: 0.0016, Period: 0.00` | `Area: 11.00, Power: 0.0016, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1294.4 | 430 |
| Prob079_fsm3onehot | ✅ (Func: 90%) | ✅ (Func: 88%) | 0.3565 | `Area: 8.00, Power: 0.0003, Period: 0.00` | `Area: 6.00, Power: 0.0002, Period: 0.00` | +25.00% ✅ / +46.31% ✅ / N/A | 1471.3 | 430 |
| Prob080_timer | ✅ (Func: 90%) | ✅ (Func: 69%) | 0.0364 | `Area: 104.00, Power: 0.0121, Period: 0.35` | `Area: 107.00, Power: 0.0097, Period: 0.37` | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | 1274.4 | 430 |
| Prob081_7458 | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.4946 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 1356.6 | 430 |
| Prob082_lfsr32 | ✅ (Func: 10%) | ✅ (Func: 45%) | 0.0400 | `Area: 221.00, Power: 0.0252, Period: 0.24` | `Area: 198.00, Power: 0.0248, Period: 0.24` | +10.41% ✅ / +1.59% ✅ / +0.00% ➖ | 2149.9 | 430 |
| Prob083_mt2015_q4b | ✅ (Func: 100%) | ✅ (Func: 90%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1380.8 | 430 |
| Prob084_ece241_2013_q12 | ✅ (Func: 90%) | ✅ (Func: 73%) | 0.6641 | `Area: 67.00, Power: 0.0113, Period: 0.18` | `Area: 67.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +99.23% ✅ / +100.00% ✅ | 1511.8 | 430 |
| Prob085_shift4 | ✅ (Func: 100%) | ✅ (Func: 71%) | -0.0000 | `Area: 39.00, Power: 0.0036, Period: 0.24` | `Area: 39.00, Power: 0.0036, Period: 0.24` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1387.5 | 430 |
| Prob086_lfsr5 | ❌ (Func: 0%) | ✅ (Func: 59%) | 0.0528 | `Area: 37.00, Power: 0.0038, Period: 0.18` | `Area: 33.00, Power: 0.0036, Period: 0.18` | +10.81% ✅ / +5.04% ✅ / +0.00% ➖ | 1365.8 | 430 |
| Prob087_gates | ✅ (Func: 100%) | ✅ (Func: 88%) | -0.0000 | `Area: 16.00, Power: 0.0006, Period: 0.00` | `Area: 16.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1400.7 | 430 |
| Prob088_ece241_2014_q5b | ✅ (Func: 90%) | ✅ (Func: 70%) | 0.0265 | `Area: 10.00, Power: 0.0004, Period: 0.15` | `Area: 9.00, Power: 0.0004, Period: 0.15` | +10.00% ✅ / -2.06% ❌ / +0.00% ➖ | 1339.5 | 430 |
| Prob089_ece241_2014_q5a | ✅ (Func: 40%) | ✅ (Func: 40%) | 0.4125 | `Area: 23.00, Power: 0.0027, Period: 0.22` | `Area: 15.00, Power: 0.0009, Period: 0.17` | +34.78% ✅ / +66.24% ✅ / +22.73% ✅ | 1216.0 | 430 |
| Prob090_circuit1 | ✅ (Func: 100%) | ✅ (Func: 96%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1227.0 | 430 |
| Prob091_2012_q2b | ✅ (Func: 90%) | ✅ (Func: 75%) | 0.2428 | `Area: 4.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +25.00% ✅ / +23.56% ✅ / N/A | 1541.6 | 430 |
| Prob092_gatesv100 | ✅ (Func: 50%) | ✅ (Func: 69%) | -0.0000 | `Area: 637.00, Power: 0.0240, Period: 0.00` | `Area: 637.00, Power: 0.0240, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1512.7 | 430 |
| Prob093_ece241_2014_q3 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 4.00, Power: 0.0001, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1409.0 | 430 |
| Prob094_gatesv | ✅ (Func: 80%) | ✅ (Func: 75%) | -0.0000 | `Area: 24.00, Power: 0.0009, Period: 0.00` | `Area: 24.00, Power: 0.0009, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1418.6 | 430 |
| Prob095_review2015_fsmshift | ✅ (Func: 30%) | ✅ (Func: 2%) | N/A | `Area: 24.00, Power: 0.0025, Period: 0.15` | `N/A` | N/A / N/A / N/A | 1094.9 | 430 |
| Prob096_review2015_fsmseq | ✅ (Func: 80%) | ✅ (Func: 51%) | 0.1582 | `Area: 33.00, Power: 0.0036, Period: 0.19` | `Area: 27.00, Power: 0.0027, Period: 0.18` | +18.18% ✅ / +24.02% ✅ / +5.26% ✅ | 1370.0 | 430 |
| Prob097_mux9to1v | ✅ (Func: 100%) | ✅ (Func: 75%) | 0.1336 | `Area: 269.00, Power: 0.0122, Period: 0.00` | `Area: 239.00, Power: 0.0103, Period: 0.00` | +11.15% ✅ / +15.57% ✅ / N/A | 1699.2 | 430 |
| Prob098_circuit7 | ✅ (Func: 60%) | ✅ (Func: 67%) | 0.4986 | `Area: 5.00, Power: 0.0005, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.71% ✅ / N/A | 1239.7 | 430 |
| Prob099_m2014_q6c | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0001, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1222.4 | 430 |
| Prob100_fsm3comb | ✅ (Func: 100%) | ✅ (Func: 71%) | -0.0000 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1464.9 | 430 |
| Prob101_circuit4 | ✅ (Func: 30%) | ✅ (Func: 77%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1306.5 | 430 |
| Prob102_circuit3 | ✅ (Func: 90%) | ✅ (Func: 85%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1340.9 | 430 |
| Prob103_circuit2 | ✅ (Func: 70%) | ✅ (Func: 91%) | -0.0000 | `Area: 8.00, Power: 0.0006, Period: 0.00` | `Area: 8.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1420.8 | 430 |
| Prob104_mt2015_muxdff | ❌ (Func: 0%) | ✅ (Func: 3%) | N/A | `Area: 6.00, Power: 0.0006, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1139.3 | 430 |
| Prob105_rotate100 | ✅ (Func: 100%) | ✅ (Func: 80%) | 0.0458 | `Area: 1033.00, Power: 0.1020, Period: 0.22` | `Area: 958.00, Power: 0.0954, Period: 0.22` | +7.26% ✅ / +6.47% ✅ / +0.00% ➖ | 3384.4 | 430 |
| Prob106_always_nolatches | ✅ (Func: 60%) | ✅ (Func: 86%) | 0.4379 | `Area: 30.00, Power: 0.0006, Period: 0.00` | `Area: 18.00, Power: 0.0003, Period: 0.00` | +40.00% ✅ / +47.58% ✅ / N/A | 4801.7 | 430 |
| Prob107_fsm1s | ✅ (Func: 100%) | ✅ (Func: 83%) | 0.0178 | `Area: 7.00, Power: 0.0009, Period: 0.20` | `Area: 7.00, Power: 0.0009, Period: 0.19` | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | 1336.9 | 430 |
| Prob108_rule90 | ✅ (Func: 100%) | ✅ (Func: 58%) | -0.0766 | `Area: 4198.00, Power: 0.8200, Period: 0.23` | `Area: 4607.00, Power: 0.8930, Period: 0.24` | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | 8290.8 | 430 |
| Prob109_fsm1 | ✅ (Func: 100%) | ✅ (Func: 76%) | 0.0492 | `Area: 7.00, Power: 0.0018, Period: 0.16` | `Area: 8.00, Power: 0.0009, Period: 0.19` | -14.29% ❌ / +47.79% ✅ / -18.75% ❌ | 1295.2 | 430 |
| Prob110_fsm2 | ✅ (Func: 100%) | ✅ (Func: 88%) | -0.0000 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1271.5 | 430 |
| Prob111_fsm2s | ✅ (Func: 100%) | ✅ (Func: 78%) | -0.0000 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1379.4 | 430 |
| Prob112_always_case2 | ❌ (Func: 0%) | ✅ (Func: 44%) | 0.0026 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.52% ✅ / N/A | 1235.2 | 430 |
| Prob113_2012_q1g | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1399.5 | 430 |
| Prob114_bugs_case | ✅ (Func: 100%) | ✅ (Func: 88%) | 0.2889 | `Area: 53.00, Power: 0.0021, Period: 0.00` | `Area: 38.00, Power: 0.0015, Period: 0.00` | +28.30% ✅ / +29.47% ✅ / N/A | 1592.9 | 430 |
| Prob115_shift18 | ✅ (Func: 100%) | ✅ (Func: 66%) | 0.2549 | `Area: 950.00, Power: 0.0963, Period: 0.37` | `Area: 795.00, Power: 0.0696, Period: 0.25` | +16.32% ✅ / +27.73% ✅ / +32.43% ✅ | 1855.5 | 430 |
| Prob116_m2014_q3 | ❌ (Func: 0%) | ✅ (Func: 33%) | 0.5202 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +40.00% ✅ / +64.04% ✅ / N/A | 1418.7 | 430 |
| Prob117_circuit9 | ❌ (Func: 0%) | ✅ (Func: 51%) | 0.1377 | `Area: 26.00, Power: 0.0047, Period: 0.24` | `Area: 25.00, Power: 0.0030, Period: 0.24` | +3.85% ✅ / +37.47% ✅ / +0.00% ➖ | 1286.6 | 430 |
| Prob118_history_shift | ✅ (Func: 100%) | ✅ (Func: 68%) | 0.0073 | `Area: 322.00, Power: 0.0312, Period: 0.24` | `Area: 348.00, Power: 0.0319, Period: 0.21` | -8.07% ❌ / -2.24% ❌ / +12.50% ✅ | 1552.2 | 430 |
| Prob119_fsm3 | ✅ (Func: 100%) | ✅ (Func: 74%) | -0.0000 | `Area: 17.00, Power: 0.0014, Period: 0.19` | `Area: 17.00, Power: 0.0014, Period: 0.19` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1396.6 | 430 |
| Prob120_fsm3s | ✅ (Func: 100%) | ✅ (Func: 83%) | 0.3256 | `Area: 27.00, Power: 0.0029, Period: 0.18` | `Area: 16.00, Power: 0.0014, Period: 0.17` | +40.74% ✅ / +51.39% ✅ / +5.56% ✅ | 1451.6 | 430 |
| Prob121_2014_q3bfsm | ✅ (Func: 80%) | ✅ (Func: 68%) | -0.0000 | `Area: 39.00, Power: 0.0039, Period: 0.21` | `Area: 39.00, Power: 0.0039, Period: 0.21` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1518.1 | 430 |
| Prob122_kmap4 | ✅ (Func: 80%) | ✅ (Func: 80%) | -0.0000 | `Area: 5.00, Power: 0.0003, Period: 0.00` | `Area: 5.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1288.7 | 430 |
| Prob123_bugs_addsubz | ✅ (Func: 50%) | ✅ (Func: 90%) | 0.1391 | `Area: 90.00, Power: 0.0073, Period: 0.00` | `Area: 69.00, Power: 0.0070, Period: 0.00` | +23.33% ✅ / +4.50% ✅ / N/A | 1442.2 | 430 |
| Prob124_rule110 | ✅ (Func: 10%) | ✅ (Func: 29%) | -0.0482 | `Area: 5000.00, Power: 0.5580, Period: 0.22` | `Area: 5409.00, Power: 0.5930, Period: 0.22` | -8.18% ❌ / -6.27% ❌ / +0.00% ➖ | 3314.6 | 430 |
| Prob125_kmap3 | ❌ (Func: 0%) | ✅ (Func: 62%) | 0.0091 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +1.82% ✅ / N/A | 1318.1 | 430 |
| Prob126_circuit6 | ✅ (Func: 100%) | ✅ (Func: 82%) | 0.3524 | `Area: 60.00, Power: 0.0028, Period: 0.00` | `Area: 37.00, Power: 0.0019, Period: 0.00` | +38.33% ✅ / +32.16% ✅ / N/A | 1666.7 | 430 |
| Prob127_lemmings1 | ✅ (Func: 100%) | ✅ (Func: 68%) | -0.0000 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1441.2 | 430 |
| Prob128_fsm_ps2 | ✅ (Func: 10%) | ✅ (Func: 38%) | 0.1624 | `Area: 26.00, Power: 0.0028, Period: 0.17` | `Area: 19.00, Power: 0.0022, Period: 0.17` | +26.92% ✅ / +21.79% ✅ / +0.00% ➖ | 1326.5 | 430 |
| Prob129_ece241_2013_q8 | ✅ (Func: 100%) | ✅ (Func: 66%) | 0.1699 | `Area: 15.00, Power: 0.0013, Period: 0.17` | `Area: 13.00, Power: 0.0010, Period: 0.14` | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | 1450.6 | 430 |
| Prob130_circuit5 | ✅ (Func: 40%) | ✅ (Func: 82%) | 0.1301 | `Area: 34.00, Power: 0.0015, Period: 0.00` | `Area: 32.00, Power: 0.0012, Period: 0.00` | +5.88% ✅ / +20.13% ✅ / N/A | 1535.0 | 430 |
| Prob131_mt2015_q4 | ✅ (Func: 100%) | ✅ (Func: 70%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 1547.0 | 430 |
| Prob132_always_if2 | ✅ (Func: 100%) | ✅ (Func: 89%) | -0.0000 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1488.2 | 430 |
| Prob133_2014_q3fsm | ✅ (Func: 10%) | ✅ (Func: 26%) | 0.1565 | `Area: 56.00, Power: 0.0060, Period: 0.25` | `Area: 51.00, Power: 0.0046, Period: 0.21` | +8.93% ✅ / +22.02% ✅ / +16.00% ✅ | 1495.4 | 430 |
| Prob134_2014_q3c | ✅ (Func: 80%) | ✅ (Func: 67%) | 0.3449 | `Area: 7.00, Power: 0.0003, Period: 0.00` | `Area: 5.00, Power: 0.0001, Period: 0.00` | +28.57% ✅ / +40.40% ✅ / N/A | 1551.3 | 430 |
| Prob135_m2014_q6b | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1546.9 | 430 |
| Prob136_m2014_q6 | ✅ (Func: 80%) | ✅ (Func: 68%) | 0.3624 | `Area: 43.00, Power: 0.0044, Period: 0.20` | `Area: 22.00, Power: 0.0022, Period: 0.18` | +48.84% ✅ / +49.89% ✅ / +10.00% ✅ | 1649.4 | 430 |
| Prob137_fsm_serial | ✅ (Func: 60%) | ✅ (Func: 29%) | 0.1132 | `Area: 99.00, Power: 0.0098, Period: 0.18` | `Area: 63.00, Power: 0.0062, Period: 0.25` | +36.36% ✅ / +36.48% ✅ / -38.89% ❌ | 1659.7 | 430 |
| Prob138_2012_q2fsm | ✅ (Func: 100%) | ✅ (Func: 70%) | 0.3700 | `Area: 46.00, Power: 0.0046, Period: 0.23` | `Area: 21.00, Power: 0.0022, Period: 0.22` | +54.35% ✅ / +52.31% ✅ / +4.35% ✅ | 1631.6 | 430 |
| Prob139_2013_q2bfsm | ❌ (Func: 0%) | ✅ (Func: 1%) | N/A | `Area: 52.00, Power: 0.0055, Period: 0.20` | `N/A` | N/A / N/A / N/A | 1616.8 | 430 |
| Prob140_fsm_hdlc | ❌ (Func: 0%) | ✅ (Func: 16%) | 0.1407 | `Area: 68.00, Power: 0.0075, Period: 0.29` | `Area: 57.00, Power: 0.0048, Period: 0.32` | +16.18% ✅ / +36.39% ✅ / -10.34% ❌ | 1548.9 | 430 |
| Prob141_count_clock | ✅ (Func: 50%) | ✅ (Func: 37%) | 0.1923 | `Area: 308.00, Power: 0.0190, Period: 0.47` | `Area: 228.00, Power: 0.0154, Period: 0.41` | +25.97% ✅ / +18.95% ✅ / +12.77% ✅ | 2630.1 | 430 |
| Prob142_lemmings2 | ✅ (Func: 100%) | ✅ (Func: 60%) | 0.1099 | `Area: 20.00, Power: 0.0024, Period: 0.21` | `Area: 19.00, Power: 0.0018, Period: 0.20` | +5.00% ✅ / +23.21% ✅ / +4.76% ✅ | 1466.4 | 430 |
| Prob143_fsm_onehot | ✅ (Func: 50%) | ✅ (Func: 48%) | 0.1922 | `Area: 26.00, Power: 0.0006, Period: 0.00` | `Area: 20.00, Power: 0.0005, Period: 0.00` | +23.08% ✅ / +15.37% ✅ / N/A | 1828.4 | 430 |
| Prob144_conwaylife | ✅ (Func: 30%) | ✅ (Func: 40%) | 0.2267 | `Area: 9113.00, Power: 1.9500, Period: 0.74` | `Area: 7116.00, Power: 1.4200, Period: 0.60` | +21.91% ✅ / +27.18% ✅ / +18.92% ✅ | 4010.3 | 430 |
| Prob145_circuit8 | ❌ (Func: 0%) | ✅ (Func: 0%) | N/A | `Area: 8.00, Power: 0.0011, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1196.2 | 430 |
| Prob146_fsm_serialdata | ✅ (Func: 40%) | ✅ (Func: 11%) | -0.3988 | `Area: 146.00, Power: 0.0141, Period: 0.18` | `Area: 199.00, Power: 0.0188, Period: 0.27` | -36.30% ❌ / -33.33% ❌ / -50.00% ❌ | 1617.0 | 430 |
| Prob147_circuit10 | ❌ (Func: 0%) | ✅ (Func: 13%) | -0.0000 | `Area: 9.00, Power: 0.0008, Period: 0.19` | `Area: 9.00, Power: 0.0008, Period: 0.19` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1389.6 | 430 |
| Prob148_2013_q2afsm | ✅ (Func: 50%) | ✅ (Func: 61%) | 0.1331 | `Area: 35.00, Power: 0.0033, Period: 0.22` | `Area: 28.00, Power: 0.0025, Period: 0.23` | +20.00% ✅ / +24.46% ✅ / -4.55% ❌ | 1575.0 | 430 |
| Prob149_ece241_2013_q4 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 52.00, Power: 0.0049, Period: 0.23` | `N/A` | N/A / N/A / N/A | 1620.4 | 430 |
| Prob150_review2015_fsmonehot | ❌ (Func: 0%) | ✅ (Func: 40%) | -0.0000 | `Area: 13.00, Power: 0.0003, Period: 0.00` | `Area: 13.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1656.8 | 430 |
| Prob151_review2015_fsm | ❌ (Func: 0%) | ✅ (Func: 3%) | -0.1830 | `Area: 66.00, Power: 0.0045, Period: 0.28` | `Area: 77.00, Power: 0.0057, Period: 0.31` | -16.67% ❌ / -27.52% ❌ / -10.71% ❌ | 1488.2 | 430 |
| Prob152_lemmings3 | ✅ (Func: 30%) | ✅ (Func: 39%) | 0.2796 | `Area: 50.00, Power: 0.0054, Period: 0.23` | `Area: 31.00, Power: 0.0032, Period: 0.22` | +38.00% ✅ / +41.54% ✅ / +4.35% ✅ | 1687.0 | 430 |
| Prob153_gshare | ✅ (Func: 10%) | ✅ (Func: 35%) | 0.2638 | `Area: 3025.00, Power: 0.4370, Period: 0.75` | `Area: 3018.00, Power: 0.1970, Period: 0.57` | +0.23% ✅ / +54.92% ✅ / +24.00% ✅ | 2441.6 | 430 |
| Prob154_fsm_ps2data | ✅ (Func: 50%) | ✅ (Func: 50%) | -0.3603 | `Area: 134.00, Power: 0.0138, Period: 0.17` | `Area: 183.00, Power: 0.0188, Period: 0.23` | -36.57% ❌ / -36.23% ❌ / -35.29% ❌ | 1509.0 | 430 |
| Prob155_lemmings4 | ❌ (Func: 0%) | ✅ (Func: 0%) | -0.2990 | `Area: 102.00, Power: 0.0177, Period: 0.28` | `Area: 116.00, Power: 0.0223, Period: 0.42` | -13.73% ❌ / -25.99% ❌ / -50.00% ❌ | 1707.6 | 430 |
| Prob156_review2015_fancytimer | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 187.00, Power: 0.0219, Period: 0.46` | `N/A` | N/A / N/A / N/A | 2081.1 | 430 |