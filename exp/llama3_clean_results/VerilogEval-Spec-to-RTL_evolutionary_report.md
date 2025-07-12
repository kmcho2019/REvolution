# 🧬 BENCHMARK EVOLUTION REPORT: VerilogEval-Spec-to-RTL

## 📈 Summary
- **Total Problems Analyzed:** 156
- **Average Runtime per Problem:** 1459.80s
- **Average LLM API Calls per Problem:** 429.0

### ✅ Pass Rate Analysis
| Metric | Initial Any Passing Gen | Any Passing Gen | Initial Pass@1 | Final Pass@1 | Change |
|:---|:---|:---|:---|:---|:---|
| **Syntax** | 94.2% (147/156) | 99.4% (155/156) | 65.4% | 86.1% | **+20.7%** |
| **Functionality** | 67.3% (105/156) | 88.5% (138/156) | 40.9% | 57.8% | **+16.9%** |
| **Synthesis** | 65.4% (102/156) | 84.0% (131/156) | 39.9% | 55.5% | **+15.7%** |

### ⚡ PPA Optimization Summary
- **Problems with PPA Improvement (Best Solution Compared to Reference):** 95 / 156 (60.9%)

| PPA Metric | Average Improvement |
|:-----------|:--------------------|
| **Area** | +3.56% |
| **Power** | +46.28% |
| **Performance (Period)** | +29.02% |

## 🧬 Strategy Analysis
Shows how often each strategy was used and its success rate (rewarded).
| Strategy | Times Used | Success Count | Success Rate |
|:---------|:-----------|:--------------|:-------------|
| `M-S` | 6321 (19.3%) | 249 | 3.9% |
| `M-R` | 6237 (19.0%) | 249 | 4.0% |
| `M-I` | 6232 (19.0%) | 241 | 3.9% |
| `M-E` | 6228 (19.0%) | 244 | 3.9% |
| `C-F` | 4641 (14.2%) | 130 | 2.8% |
| `initial` | 1560 (4.8%) | 0 | 0.0% |
| `M-F` | 1539 (4.7%) | 117 | 7.6% |

## 📋 Detailed Problem-by-Problem Analysis
| Problem | Initial Status | Final Status | Best Score | Reference PPA | Best Evo. PPA | PPA % Improv. (A/P/T) | Runtime (s) | API Calls |
|:---|:---|:---|:---:|:---|:---|:---|:---:|:---:|
| Prob001_zero | ✅ (Func: 90%) | ✅ (Func: 79%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1188.4 | 429 |
| Prob002_m2014_q4i | ✅ (Func: 100%) | ✅ (Func: 82%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1198.5 | 429 |
| Prob003_step_one | ✅ (Func: 90%) | ✅ (Func: 81%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1260.0 | 429 |
| Prob004_vector2 | ✅ (Func: 90%) | ✅ (Func: 72%) | 0.4945 | `Area: 26.00, Power: 0.0007, Period: 0.00` | `Area: 26.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1295.6 | 429 |
| Prob005_notgate | ✅ (Func: 80%) | ✅ (Func: 91%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1333.8 | 429 |
| Prob006_vectorr | ✅ (Func: 90%) | ✅ (Func: 42%) | -0.0000 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1389.5 | 429 |
| Prob007_wire | ✅ (Func: 100%) | ✅ (Func: 92%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1231.4 | 429 |
| Prob008_m2014_q4h | ✅ (Func: 90%) | ✅ (Func: 77%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1242.2 | 429 |
| Prob009_popcount3 | ✅ (Func: 90%) | ✅ (Func: 68%) | -0.0000 | `Area: 4.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1151.3 | 429 |
| Prob010_mt2015_q4a | ✅ (Func: 90%) | ✅ (Func: 91%) | 0.4945 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1739.4 | 429 |
| Prob011_norgate | ✅ (Func: 100%) | ✅ (Func: 90%) | 0.4942 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.84% ✅ / N/A | 1215.3 | 429 |
| Prob012_xnorgate | ✅ (Func: 100%) | ✅ (Func: 95%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 982.1 | 429 |
| Prob013_m2014_q4e | ✅ (Func: 100%) | ✅ (Func: 87%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 937.7 | 429 |
| Prob014_andgate | ✅ (Func: 60%) | ✅ (Func: 88%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.89% ✅ / N/A | 986.3 | 429 |
| Prob015_vector1 | ✅ (Func: 100%) | ✅ (Func: 92%) | 0.4945 | `Area: 13.00, Power: 0.0003, Period: 0.00` | `Area: 13.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1110.5 | 429 |
| Prob016_m2014_q4j | ✅ (Func: 60%) | ✅ (Func: 73%) | 0.6365 | `Area: 25.00, Power: 0.0013, Period: 0.00` | `Area: 18.00, Power: 0.0000, Period: 0.00` | +28.00% ✅ / +99.29% ✅ / N/A | 1792.4 | 429 |
| Prob017_mux2to1v | ✅ (Func: 100%) | ✅ (Func: 76%) | 0.4947 | `Area: 208.00, Power: 0.0071, Period: 0.00` | `Area: 208.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +98.93% ✅ / N/A | 1204.6 | 429 |
| Prob018_mux256to1 | ✅ (Func: 70%) | ✅ (Func: 82%) | 0.2910 | `Area: 522.00, Power: 0.0237, Period: 0.00` | `Area: 434.00, Power: 0.0139, Period: 0.00` | +16.86% ✅ / +41.35% ✅ / N/A | 1845.4 | 429 |
| Prob019_m2014_q4f | ✅ (Func: 100%) | ✅ (Func: 86%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1264.6 | 429 |
| Prob020_mt2015_eq2 | ✅ (Func: 90%) | ✅ (Func: 89%) | -0.0000 | `Area: 5.00, Power: 0.0003, Period: 0.00` | `Area: 5.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1073.4 | 429 |
| Prob021_mux256to1v | ✅ (Func: 50%) | ✅ (Func: 71%) | 0.4818 | `Area: 2040.00, Power: 0.0942, Period: 0.00` | `Area: 1404.00, Power: 0.0328, Period: 0.00` | +31.18% ✅ / +65.18% ✅ / N/A | 2289.4 | 429 |
| Prob022_mux2to1 | ✅ (Func: 90%) | ✅ (Func: 96%) | -0.0000 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1033.6 | 429 |
| Prob023_vector100r | ✅ (Func: 60%) | ✅ (Func: 43%) | -0.0000 | `Area: 80.00, Power: 0.0021, Period: 0.00` | `Area: 80.00, Power: 0.0021, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1600.5 | 429 |
| Prob024_hadd | ✅ (Func: 90%) | ✅ (Func: 92%) | 0.4946 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.93% ✅ / N/A | 1247.7 | 429 |
| Prob025_reduction | ✅ (Func: 100%) | ✅ (Func: 90%) | -0.0000 | `Area: 11.00, Power: 0.0009, Period: 0.00` | `Area: 11.00, Power: 0.0009, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1094.4 | 429 |
| Prob026_alwaysblock1 | ✅ (Func: 40%) | ✅ (Func: 79%) | 0.4945 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1258.1 | 429 |
| Prob027_fadd | ✅ (Func: 90%) | ✅ (Func: 90%) | 0.4948 | `Area: 4.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.96% ✅ / N/A | 1098.1 | 429 |
| Prob028_m2014_q4a | ✅ (Func: 90%) | ✅ (Func: 90%) | 0.3121 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +33.33% ✅ / +29.09% ✅ / N/A | 1201.3 | 429 |
| Prob029_m2014_q4g | ✅ (Func: 90%) | ✅ (Func: 87%) | 0.4948 | `Area: 5.00, Power: 0.0004, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.96% ✅ / N/A | 1344.9 | 429 |
| Prob030_popcount255 | ✅ (Func: 30%) | ✅ (Func: 53%) | 0.4480 | `Area: 1339.00, Power: 0.2150, Period: 0.00` | `Area: 1287.00, Power: 0.0307, Period: 0.00` | +3.88% ✅ / +85.72% ✅ / N/A | 12018.7 | 429 |
| Prob031_dff | ✅ (Func: 80%) | ✅ (Func: 83%) | -0.0000 | `Area: 5.00, Power: 0.0005, Period: 0.00` | `Area: 5.00, Power: 0.0005, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1344.4 | 429 |
| Prob032_vector0 | ✅ (Func: 100%) | ✅ (Func: 70%) | 0.4945 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 1355.5 | 429 |
| Prob033_ece241_2014_q1c | ✅ (Func: 80%) | ✅ (Func: 70%) | 0.6311 | `Area: 52.00, Power: 0.0032, Period: 0.00` | `Area: 38.00, Power: 0.0000, Period: 0.00` | +26.92% ✅ / +99.29% ✅ / N/A | 1441.1 | 429 |
| Prob034_dff8 | ❌ (Func: 0%) | ✅ (Func: 22%) | N/A | `Area: 36.00, Power: 0.0036, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1265.4 | 429 |
| Prob035_count1to10 | ✅ (Func: 70%) | ✅ (Func: 90%) | 0.0157 | `Area: 41.00, Power: 0.0044, Period: 0.26` | `Area: 40.00, Power: 0.0043, Period: 0.26` | +2.44% ✅ / +2.26% ✅ / +0.00% ➖ | 1547.5 | 429 |
| Prob036_ringer | ✅ (Func: 90%) | ✅ (Func: 89%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1098.2 | 429 |
| Prob037_review2015_count1k | ✅ (Func: 70%) | ✅ (Func: 76%) | 0.6659 | `Area: 93.00, Power: 0.0077, Period: 0.38` | `Area: 93.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.76% ✅ / +100.00% ✅ | 1720.6 | 429 |
| Prob038_count15 | ✅ (Func: 80%) | ✅ (Func: 85%) | 0.6654 | `Area: 30.00, Power: 0.0033, Period: 0.25` | `Area: 30.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.61% ✅ / +100.00% ✅ | 1520.6 | 429 |
| Prob039_always_if | ✅ (Func: 30%) | ✅ (Func: 85%) | 0.4947 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.94% ✅ / N/A | 1557.2 | 429 |
| Prob040_count10 | ✅ (Func: 80%) | ✅ (Func: 87%) | 0.0090 | `Area: 39.00, Power: 0.0037, Period: 0.26` | `Area: 37.00, Power: 0.0038, Period: 0.26` | +5.13% ✅ / -2.42% ❌ / +0.00% ➖ | 1172.9 | 429 |
| Prob041_dff8r | ✅ (Func: 10%) | ✅ (Func: 71%) | 0.4981 | `Area: 57.00, Power: 0.0053, Period: 0.00` | `Area: 57.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.61% ✅ / N/A | 1210.7 | 429 |
| Prob042_vector4 | ✅ (Func: 90%) | ✅ (Func: 58%) | 0.4945 | `Area: 26.00, Power: 0.0007, Period: 0.00` | `Area: 26.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1159.3 | 429 |
| Prob043_vector5 | ✅ (Func: 50%) | ✅ (Func: 56%) | 0.4947 | `Area: 39.00, Power: 0.0019, Period: 0.00` | `Area: 39.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.94% ✅ / N/A | 1644.2 | 429 |
| Prob044_vectorgates | ✅ (Func: 100%) | ✅ (Func: 95%) | 0.4944 | `Area: 10.00, Power: 0.0003, Period: 0.00` | `Area: 10.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.88% ✅ / N/A | 1384.0 | 429 |
| Prob045_edgedetect2 | ✅ (Func: 30%) | ✅ (Func: 55%) | 0.1240 | `Area: 85.00, Power: 0.0087, Period: 0.17` | `Area: 85.00, Power: 0.0080, Period: 0.12` | +0.00% ➖ / +7.80% ✅ / +29.41% ✅ | 1398.7 | 429 |
| Prob046_dff8p | ✅ (Func: 10%) | ✅ (Func: 68%) | 0.4985 | `Area: 52.00, Power: 0.0061, Period: 0.00` | `Area: 52.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.71% ✅ / N/A | 2105.6 | 429 |
| Prob047_dff8ar | ✅ (Func: 30%) | ✅ (Func: 77%) | 0.4989 | `Area: 43.00, Power: 0.0038, Period: 0.00` | `Area: 43.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.77% ✅ / N/A | 1577.6 | 429 |
| Prob048_m2014_q4c | ✅ (Func: 80%) | ✅ (Func: 91%) | -0.0000 | `Area: 6.00, Power: 0.0006, Period: 0.00` | `Area: 6.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1391.8 | 429 |
| Prob049_m2014_q4b | ✅ (Func: 40%) | ✅ (Func: 58%) | -0.0000 | `Area: 6.00, Power: 0.0005, Period: 0.00` | `Area: 6.00, Power: 0.0005, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1111.3 | 429 |
| Prob050_kmap1 | ✅ (Func: 30%) | ✅ (Func: 77%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1190.0 | 429 |
| Prob051_gates4 | ✅ (Func: 100%) | ✅ (Func: 87%) | 0.5579 | `Area: 16.00, Power: 0.0007, Period: 0.00` | `Area: 14.00, Power: 0.0000, Period: 0.00` | +12.50% ✅ / +99.09% ✅ / N/A | 1380.6 | 429 |
| Prob052_gates100 | ✅ (Func: 70%) | ✅ (Func: 82%) | 0.6954 | `Area: 443.00, Power: 0.0274, Period: 0.00` | `Area: 265.00, Power: 0.0003, Period: 0.00` | +40.18% ✅ / +98.89% ✅ / N/A | 2284.6 | 429 |
| Prob053_m2014_q4d | ❌ (Func: 0%) | ✅ (Func: 45%) | N/A | `Area: 6.00, Power: 0.0017, Period: 0.17` | `N/A` | N/A / N/A / N/A | 1089.3 | 429 |
| Prob054_edgedetect | ✅ (Func: 30%) | ✅ (Func: 49%) | 0.6387 | `Area: 87.00, Power: 0.0086, Period: 0.14` | `Area: 94.00, Power: 0.0000, Period: 0.00` | -8.05% ❌ / +99.66% ✅ / +100.00% ✅ | 1283.2 | 429 |
| Prob055_conditional | ✅ (Func: 40%) | ✅ (Func: 87%) | 0.5682 | `Area: 243.00, Power: 0.0290, Period: 0.00` | `Area: 208.00, Power: 0.0002, Period: 0.00` | +14.40% ✅ / +99.24% ✅ / N/A | 1222.9 | 429 |
| Prob056_ece241_2013_q7 | ✅ (Func: 80%) | ✅ (Func: 90%) | -0.0000 | `Area: 7.00, Power: 0.0007, Period: 0.18` | `Area: 7.00, Power: 0.0007, Period: 0.18` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1109.0 | 429 |
| Prob057_kmap2 | ❌ (Func: 0%) | ✅ (Func: 1%) | 0.3780 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0001, Period: 0.00` | +33.33% ✅ / +42.26% ✅ / N/A | 1187.4 | 429 |
| Prob058_alwaysblock2 | ❌ (Func: 0%) | ✅ (Func: 47%) | 0.4974 | `Area: 7.00, Power: 0.0007, Period: 0.00` | `Area: 7.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.49% ✅ / N/A | 1137.0 | 429 |
| Prob059_wire4 | ✅ (Func: 100%) | ✅ (Func: 92%) | 0.4945 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1024.3 | 429 |
| Prob060_m2014_q4k | ✅ (Func: 90%) | ✅ (Func: 79%) | 0.6660 | `Area: 22.00, Power: 0.0026, Period: 0.14` | `Area: 22.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.81% ✅ / +100.00% ✅ | 1283.4 | 429 |
| Prob061_2014_q4a | ✅ (Func: 90%) | ✅ (Func: 87%) | -0.0000 | `Area: 9.00, Power: 0.0008, Period: 0.23` | `Area: 9.00, Power: 0.0008, Period: 0.23` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1105.3 | 429 |
| Prob062_bugs_mux2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 17.00, Power: 0.0006, Period: 0.00` | `N/A` | N/A / N/A / N/A | 984.0 | 429 |
| Prob063_review2015_shiftcount | ❌ (Func: 0%) | ✅ (Func: 10%) | -0.0000 | `Area: 43.00, Power: 0.0067, Period: 0.29` | `Area: 43.00, Power: 0.0067, Period: 0.29` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1408.2 | 429 |
| Prob064_vector3 | ✅ (Func: 80%) | ✅ (Func: 76%) | 0.4945 | `Area: 26.00, Power: 0.0006, Period: 0.00` | `Area: 26.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.89% ✅ / N/A | 1245.1 | 429 |
| Prob065_7420 | ✅ (Func: 70%) | ✅ (Func: 86%) | 0.4943 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.86% ✅ / N/A | 1350.5 | 429 |
| Prob066_edgecapture | ❌ (Func: 0%) | ✅ (Func: 1%) | N/A | `Area: 437.00, Power: 0.0442, Period: 0.19` | `N/A` | N/A / N/A / N/A | 1405.8 | 429 |
| Prob067_countslow | ✅ (Func: 60%) | ✅ (Func: 90%) | 0.1127 | `Area: 47.00, Power: 0.0037, Period: 0.30` | `Area: 38.00, Power: 0.0037, Period: 0.26` | +19.15% ✅ / +1.34% ✅ / +13.33% ✅ | 1173.3 | 429 |
| Prob068_countbcd | ❌ (Func: 0%) | ✅ (Func: 54%) | 0.6679 | `Area: 180.00, Power: 0.0146, Period: 0.41` | `Area: 179.00, Power: 0.0000, Period: 0.00` | +0.56% ✅ / +99.82% ✅ / +100.00% ✅ | 1699.3 | 429 |
| Prob069_truthtable1 | ✅ (Func: 20%) | ✅ (Func: 78%) | -0.0000 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1278.7 | 428 |
| Prob070_ece241_2013_q2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1762.9 | 429 |
| Prob071_always_casez | ❌ (Func: 0%) | ✅ (Func: 20%) | 0.1143 | `Area: 17.00, Power: 0.0006, Period: 0.00` | `Area: 18.00, Power: 0.0004, Period: 0.00` | -5.88% ❌ / +28.75% ✅ / N/A | 1200.7 | 429 |
| Prob072_thermostat | ✅ (Func: 80%) | ✅ (Func: 82%) | 0.0032 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 5.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.65% ✅ / N/A | 1287.9 | 429 |
| Prob073_dff16e | ✅ (Func: 60%) | ✅ (Func: 90%) | 0.6653 | `Area: 129.00, Power: 0.0126, Period: 0.20` | `Area: 129.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +99.59% ✅ / +100.00% ✅ | 1267.3 | 429 |
| Prob074_ece241_2014_q4 | ✅ (Func: 10%) | ✅ (Func: 32%) | N/A | `Area: 20.00, Power: 0.0031, Period: 0.18` | `N/A` | N/A / N/A / N/A | 1328.7 | 429 |
| Prob075_counter_2bc | ✅ (Func: 90%) | ✅ (Func: 88%) | 0.3728 | `Area: 30.00, Power: 0.0059, Period: 0.25` | `Area: 19.00, Power: 0.0029, Period: 0.19` | +36.67% ✅ / +51.18% ✅ / +24.00% ✅ | 1319.2 | 429 |
| Prob076_always_case | ❌ (Func: 0%) | ✅ (Func: 88%) | 0.0287 | `Area: 44.00, Power: 0.0019, Period: 0.00` | `Area: 41.00, Power: 0.0019, Period: 0.00` | +6.82% ✅ / -1.08% ❌ / N/A | 1316.3 | 429 |
| Prob077_wire_decl | ✅ (Func: 60%) | ✅ (Func: 89%) | 0.4947 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.93% ✅ / N/A | 1102.3 | 429 |
| Prob078_dualedge | ✅ (Func: 40%) | ✅ (Func: 62%) | -0.0000 | `Area: 11.00, Power: 0.0016, Period: 0.00` | `Area: 11.00, Power: 0.0016, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1440.9 | 429 |
| Prob079_fsm3onehot | ✅ (Func: 30%) | ✅ (Func: 51%) | 0.2425 | `Area: 8.00, Power: 0.0003, Period: 0.00` | `Area: 12.00, Power: 0.0000, Period: 0.00` | -50.00% ❌ / +98.49% ✅ / N/A | 1239.9 | 429 |
| Prob080_timer | ✅ (Func: 40%) | ✅ (Func: 74%) | 0.6642 | `Area: 104.00, Power: 0.0121, Period: 0.35` | `Area: 104.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +99.27% ✅ / +100.00% ✅ | 1248.7 | 429 |
| Prob081_7458 | ✅ (Func: 70%) | ✅ (Func: 90%) | 0.4946 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 1319.6 | 429 |
| Prob082_lfsr32 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 221.00, Power: 0.0252, Period: 0.24` | `N/A` | N/A / N/A / N/A | 1725.7 | 429 |
| Prob083_mt2015_q4b | ✅ (Func: 80%) | ✅ (Func: 90%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1248.2 | 429 |
| Prob084_ece241_2013_q12 | ✅ (Func: 50%) | ✅ (Func: 74%) | 0.6641 | `Area: 67.00, Power: 0.0113, Period: 0.18` | `Area: 67.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +99.23% ✅ / +100.00% ✅ | 1305.6 | 429 |
| Prob085_shift4 | ✅ (Func: 70%) | ✅ (Func: 78%) | 0.6649 | `Area: 39.00, Power: 0.0036, Period: 0.24` | `Area: 39.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.47% ✅ / +100.00% ✅ | 1429.3 | 429 |
| Prob086_lfsr5 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 37.00, Power: 0.0038, Period: 0.18` | `N/A` | N/A / N/A / N/A | 1109.6 | 429 |
| Prob087_gates | ✅ (Func: 90%) | ✅ (Func: 83%) | 0.4947 | `Area: 16.00, Power: 0.0006, Period: 0.00` | `Area: 16.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.94% ✅ / N/A | 1334.4 | 429 |
| Prob088_ece241_2014_q5b | ✅ (Func: 20%) | ✅ (Func: 58%) | 0.0279 | `Area: 10.00, Power: 0.0004, Period: 0.15` | `Area: 9.00, Power: 0.0004, Period: 0.16` | +10.00% ✅ / +5.03% ✅ / -6.67% ❌ | 1196.2 | 429 |
| Prob089_ece241_2014_q5a | ❌ (Func: 0%) | ✅ (Func: 46%) | 0.4125 | `Area: 23.00, Power: 0.0027, Period: 0.22` | `Area: 15.00, Power: 0.0009, Period: 0.17` | +34.78% ✅ / +66.24% ✅ / +22.73% ✅ | 1264.8 | 429 |
| Prob090_circuit1 | ✅ (Func: 80%) | ✅ (Func: 92%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1216.3 | 429 |
| Prob091_2012_q2b | ❌ (Func: 0%) | ✅ (Func: 67%) | 0.4942 | `Area: 4.00, Power: 0.0001, Period: 0.00` | `Area: 4.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.83% ✅ / N/A | 1332.0 | 429 |
| Prob092_gatesv100 | ✅ (Func: 30%) | ✅ (Func: 50%) | 0.4947 | `Area: 637.00, Power: 0.0240, Period: 0.00` | `Area: 637.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +98.94% ✅ / N/A | 1242.2 | 429 |
| Prob093_ece241_2014_q3 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 4.00, Power: 0.0001, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1431.7 | 429 |
| Prob094_gatesv | ✅ (Func: 10%) | ✅ (Func: 41%) | 0.4945 | `Area: 24.00, Power: 0.0009, Period: 0.00` | `Area: 24.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 1233.0 | 429 |
| Prob095_review2015_fsmshift | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 24.00, Power: 0.0025, Period: 0.15` | `N/A` | N/A / N/A / N/A | 1244.6 | 429 |
| Prob096_review2015_fsmseq | ❌ (Func: 0%) | ✅ (Func: 13%) | 0.0143 | `Area: 33.00, Power: 0.0036, Period: 0.19` | `Area: 30.00, Power: 0.0028, Period: 0.24` | +9.09% ✅ / +21.51% ✅ / -26.32% ❌ | 1508.5 | 429 |
| Prob097_mux9to1v | ❌ (Func: 0%) | ✅ (Func: 58%) | 0.0674 | `Area: 269.00, Power: 0.0122, Period: 0.00` | `Area: 257.00, Power: 0.0111, Period: 0.00` | +4.46% ✅ / +9.02% ✅ / N/A | 1358.3 | 429 |
| Prob098_circuit7 | ✅ (Func: 40%) | ✅ (Func: 66%) | 0.0180 | `Area: 5.00, Power: 0.0005, Period: 0.00` | `Area: 5.00, Power: 0.0005, Period: 0.00` | +0.00% ➖ / +3.60% ✅ / N/A | 1270.0 | 429 |
| Prob099_m2014_q6c | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0001, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1079.7 | 429 |
| Prob100_fsm3comb | ✅ (Func: 10%) | ✅ (Func: 66%) | 0.4928 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.55% ✅ / N/A | 1249.2 | 429 |
| Prob101_circuit4 | ✅ (Func: 40%) | ✅ (Func: 69%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.90% ✅ / N/A | 1382.3 | 429 |
| Prob102_circuit3 | ✅ (Func: 20%) | ✅ (Func: 80%) | 0.4946 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.93% ✅ / N/A | 1305.6 | 429 |
| Prob103_circuit2 | ✅ (Func: 30%) | ✅ (Func: 78%) | -0.0000 | `Area: 8.00, Power: 0.0006, Period: 0.00` | `Area: 8.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1488.7 | 429 |
| Prob104_mt2015_muxdff | ❌ (Func: 0%) | ✅ (Func: 1%) | N/A | `Area: 6.00, Power: 0.0006, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1576.7 | 429 |
| Prob105_rotate100 | ✅ (Func: 90%) | ✅ (Func: 77%) | 0.0416 | `Area: 1033.00, Power: 0.1020, Period: 0.22` | `Area: 965.00, Power: 0.0960, Period: 0.22` | +6.58% ✅ / +5.88% ✅ / +0.00% ➖ | 2636.1 | 429 |
| Prob106_always_nolatches | ❌ (Func: 0%) | ✅ (Func: 72%) | 0.5117 | `Area: 30.00, Power: 0.0006, Period: 0.00` | `Area: 29.00, Power: 0.0000, Period: 0.00` | +3.33% ✅ / +99.01% ✅ / N/A | 2401.4 | 429 |
| Prob107_fsm1s | ✅ (Func: 40%) | ✅ (Func: 67%) | 0.0178 | `Area: 7.00, Power: 0.0009, Period: 0.20` | `Area: 7.00, Power: 0.0009, Period: 0.19` | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | 1250.5 | 429 |
| Prob108_rule90 | ✅ (Func: 30%) | ✅ (Func: 57%) | 0.5826 | `Area: 4198.00, Power: 0.8200, Period: 0.23` | `Area: 4607.00, Power: 0.1270, Period: 0.00` | -9.74% ❌ / +84.51% ✅ / +100.00% ✅ | 5850.4 | 429 |
| Prob109_fsm1 | ✅ (Func: 60%) | ✅ (Func: 82%) | -0.0000 | `Area: 7.00, Power: 0.0018, Period: 0.16` | `Area: 7.00, Power: 0.0018, Period: 0.16` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1305.6 | 429 |
| Prob110_fsm2 | ✅ (Func: 50%) | ✅ (Func: 80%) | 0.6652 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.55% ✅ / +100.00% ✅ | 1243.7 | 429 |
| Prob111_fsm2s | ❌ (Func: 0%) | ✅ (Func: 79%) | -0.0000 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1375.9 | 429 |
| Prob112_always_case2 | ❌ (Func: 0%) | ✅ (Func: 2%) | 0.0026 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.52% ✅ / N/A | 1209.1 | 429 |
| Prob113_2012_q1g | ✅ (Func: 20%) | ✅ (Func: 34%) | 0.0023 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 5.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.47% ✅ / N/A | 1249.0 | 429 |
| Prob114_bugs_case | ❌ (Func: 0%) | ✅ (Func: 73%) | 0.1559 | `Area: 53.00, Power: 0.0021, Period: 0.00` | `Area: 48.00, Power: 0.0016, Period: 0.00` | +9.43% ✅ / +21.74% ✅ / N/A | 1483.3 | 429 |
| Prob115_shift18 | ✅ (Func: 20%) | ✅ (Func: 67%) | 0.2178 | `Area: 950.00, Power: 0.0963, Period: 0.37` | `Area: 796.00, Power: 0.0698, Period: 0.29` | +16.21% ✅ / +27.52% ✅ / +21.62% ✅ | 1757.4 | 429 |
| Prob116_m2014_q3 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1220.8 | 429 |
| Prob117_circuit9 | ❌ (Func: 0%) | ✅ (Func: 58%) | 0.2157 | `Area: 26.00, Power: 0.0047, Period: 0.24` | `Area: 23.00, Power: 0.0026, Period: 0.22` | +11.54% ✅ / +44.84% ✅ / +8.33% ✅ | 1182.7 | 429 |
| Prob118_history_shift | ✅ (Func: 100%) | ✅ (Func: 80%) | -0.0000 | `Area: 322.00, Power: 0.0312, Period: 0.24` | `Area: 322.00, Power: 0.0312, Period: 0.24` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1313.0 | 429 |
| Prob119_fsm3 | ✅ (Func: 30%) | ✅ (Func: 67%) | 0.1462 | `Area: 17.00, Power: 0.0014, Period: 0.19` | `Area: 15.00, Power: 0.0011, Period: 0.16` | +11.76% ✅ / +16.30% ✅ / +15.79% ✅ | 1278.0 | 429 |
| Prob120_fsm3s | ✅ (Func: 10%) | ✅ (Func: 70%) | 0.3268 | `Area: 27.00, Power: 0.0029, Period: 0.18` | `Area: 16.00, Power: 0.0014, Period: 0.17` | +40.74% ✅ / +51.74% ✅ / +5.56% ✅ | 1308.3 | 429 |
| Prob121_2014_q3bfsm | ✅ (Func: 40%) | ✅ (Func: 67%) | 0.6824 | `Area: 39.00, Power: 0.0039, Period: 0.21` | `Area: 37.00, Power: 0.0000, Period: 0.00` | +5.13% ✅ / +99.60% ✅ / +100.00% ✅ | 1465.4 | 429 |
| Prob122_kmap4 | ✅ (Func: 30%) | ✅ (Func: 71%) | -0.0000 | `Area: 5.00, Power: 0.0003, Period: 0.00` | `Area: 5.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1190.7 | 429 |
| Prob123_bugs_addsubz | ✅ (Func: 50%) | ✅ (Func: 82%) | 0.6117 | `Area: 90.00, Power: 0.0073, Period: 0.00` | `Area: 69.00, Power: 0.0001, Period: 0.00` | +23.33% ✅ / +99.01% ✅ / N/A | 1388.6 | 429 |
| Prob124_rule110 | ❌ (Func: 0%) | ✅ (Func: 1%) | -1.2311 | `Area: 5000.00, Power: 0.5580, Period: 0.22` | `Area: 8548.00, Power: 2.0200, Period: 0.30` | -70.96% ❌ / -262.01% ❌ / -36.36% ❌ | 2200.4 | 429 |
| Prob125_kmap3 | ✅ (Func: 10%) | ✅ (Func: 62%) | 0.0091 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +1.82% ✅ / N/A | 1197.6 | 429 |
| Prob126_circuit6 | ✅ (Func: 10%) | ✅ (Func: 45%) | 0.6544 | `Area: 60.00, Power: 0.0028, Period: 0.00` | `Area: 41.00, Power: 0.0000, Period: 0.00` | +31.67% ✅ / +99.22% ✅ / N/A | 1221.2 | 429 |
| Prob127_lemmings1 | ✅ (Func: 20%) | ✅ (Func: 49%) | 0.0372 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.18` | +0.00% ➖ / +1.15% ✅ / +10.00% ✅ | 1329.6 | 429 |
| Prob128_fsm_ps2 | ❌ (Func: 0%) | ✅ (Func: 18%) | 0.1276 | `Area: 26.00, Power: 0.0028, Period: 0.17` | `Area: 20.00, Power: 0.0022, Period: 0.18` | +23.08% ✅ / +21.07% ✅ / -5.88% ❌ | 1211.3 | 429 |
| Prob129_ece241_2013_q8 | ✅ (Func: 50%) | ✅ (Func: 48%) | 0.1699 | `Area: 15.00, Power: 0.0013, Period: 0.17` | `Area: 13.00, Power: 0.0010, Period: 0.14` | +13.33% ✅ / +20.00% ✅ / +17.65% ✅ | 1235.2 | 429 |
| Prob130_circuit5 | ✅ (Func: 10%) | ✅ (Func: 67%) | 0.1301 | `Area: 34.00, Power: 0.0015, Period: 0.00` | `Area: 32.00, Power: 0.0012, Period: 0.00` | +5.88% ✅ / +20.13% ✅ / N/A | 1289.2 | 429 |
| Prob131_mt2015_q4 | ❌ (Func: 0%) | ✅ (Func: 69%) | 0.4945 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.91% ✅ / N/A | 1330.8 | 429 |
| Prob132_always_if2 | ✅ (Func: 90%) | ✅ (Func: 82%) | 0.4943 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.87% ✅ / N/A | 1144.0 | 429 |
| Prob133_2014_q3fsm | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 56.00, Power: 0.0060, Period: 0.25` | `N/A` | N/A / N/A / N/A | 1218.1 | 429 |
| Prob134_2014_q3c | ❌ (Func: 0%) | ✅ (Func: 52%) | -0.0560 | `Area: 7.00, Power: 0.0003, Period: 0.00` | `Area: 7.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / -11.20% ❌ / N/A | 1364.7 | 429 |
| Prob135_m2014_q6b | ❌ (Func: 0%) | ✅ (Func: 17%) | 0.1839 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 5.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +36.77% ✅ / N/A | 1147.9 | 429 |
| Prob136_m2014_q6 | ✅ (Func: 30%) | ✅ (Func: 58%) | 0.2387 | `Area: 43.00, Power: 0.0044, Period: 0.20` | `Area: 28.00, Power: 0.0024, Period: 0.22` | +34.88% ✅ / +46.73% ✅ / -10.00% ❌ | 1385.5 | 429 |
| Prob137_fsm_serial | ❌ (Func: 0%) | ✅ (Func: 27%) | -0.0200 | `Area: 99.00, Power: 0.0098, Period: 0.18` | `Area: 76.00, Power: 0.0066, Period: 0.29` | +23.23% ✅ / +31.86% ✅ / -61.11% ❌ | 1381.8 | 429 |
| Prob138_2012_q2fsm | ✅ (Func: 30%) | ✅ (Func: 73%) | 0.0754 | `Area: 46.00, Power: 0.0046, Period: 0.23` | `Area: 44.00, Power: 0.0045, Period: 0.19` | +4.35% ✅ / +0.88% ✅ / +17.39% ✅ | 1360.2 | 429 |
| Prob139_2013_q2bfsm | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 52.00, Power: 0.0055, Period: 0.20` | `N/A` | N/A / N/A / N/A | 1319.9 | 429 |
| Prob140_fsm_hdlc | ❌ (Func: 0%) | ✅ (Func: 20%) | 0.1154 | `Area: 68.00, Power: 0.0075, Period: 0.29` | `Area: 68.00, Power: 0.0078, Period: 0.18` | +0.00% ➖ / -3.32% ❌ / +37.93% ✅ | 1426.9 | 429 |
| Prob141_count_clock | ❌ (Func: 0%) | ✅ (Func: 0%) | N/A | `Area: 308.00, Power: 0.0190, Period: 0.47` | `N/A` | N/A / N/A / N/A | 1724.1 | 429 |
| Prob142_lemmings2 | ❌ (Func: 0%) | ✅ (Func: 18%) | 0.0749 | `Area: 20.00, Power: 0.0024, Period: 0.21` | `Area: 20.00, Power: 0.0019, Period: 0.20` | +0.00% ➖ / +17.72% ✅ / +4.76% ✅ | 1678.0 | 428 |
| Prob143_fsm_onehot | ❌ (Func: 0%) | ✅ (Func: 41%) | 0.1922 | `Area: 26.00, Power: 0.0006, Period: 0.00` | `Area: 20.00, Power: 0.0005, Period: 0.00` | +23.08% ✅ / +15.37% ✅ / N/A | 1646.8 | 429 |
| Prob144_conwaylife | ❌ (Func: 0%) | ✅ (Func: 0%) | N/A | `Area: 9113.00, Power: 1.9500, Period: 0.74` | `N/A` | N/A / N/A / N/A | 1842.1 | 429 |
| Prob145_circuit8 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 8.00, Power: 0.0011, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1354.5 | 429 |
| Prob146_fsm_serialdata | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 146.00, Power: 0.0141, Period: 0.18` | `N/A` | N/A / N/A / N/A | 1275.4 | 429 |
| Prob147_circuit10 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 9.00, Power: 0.0008, Period: 0.19` | `N/A` | N/A / N/A / N/A | 1129.1 | 429 |
| Prob148_2013_q2afsm | ✅ (Func: 10%) | ✅ (Func: 61%) | -0.0000 | `Area: 35.00, Power: 0.0033, Period: 0.22` | `Area: 35.00, Power: 0.0033, Period: 0.22` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1313.6 | 429 |
| Prob149_ece241_2013_q4 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 52.00, Power: 0.0049, Period: 0.23` | `N/A` | N/A / N/A / N/A | 1386.6 | 429 |
| Prob150_review2015_fsmonehot | ❌ (Func: 0%) | ✅ (Func: 42%) | 0.4946 | `Area: 13.00, Power: 0.0003, Period: 0.00` | `Area: 13.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +98.92% ✅ / N/A | 1691.2 | 429 |
| Prob151_review2015_fsm | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 66.00, Power: 0.0045, Period: 0.28` | `N/A` | N/A / N/A / N/A | 1458.3 | 429 |
| Prob152_lemmings3 | ❌ (Func: 0%) | ✅ (Func: 33%) | 0.2435 | `Area: 50.00, Power: 0.0054, Period: 0.23` | `Area: 37.00, Power: 0.0036, Period: 0.20` | +26.00% ✅ / +34.01% ✅ / +13.04% ✅ | 1523.9 | 429 |
| Prob153_gshare | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 3025.00, Power: 0.4370, Period: 0.75` | `N/A` | N/A / N/A / N/A | 1442.4 | 429 |
| Prob154_fsm_ps2data | ❌ (Func: 0%) | ✅ (Func: 40%) | -0.5515 | `Area: 134.00, Power: 0.0138, Period: 0.17` | `Area: 230.00, Power: 0.0235, Period: 0.21` | -71.64% ❌ / -70.29% ❌ / -23.53% ❌ | 1277.1 | 429 |
| Prob155_lemmings4 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 102.00, Power: 0.0177, Period: 0.28` | `N/A` | N/A / N/A / N/A | 1670.4 | 429 |
| Prob156_review2015_fancytimer | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 187.00, Power: 0.0219, Period: 0.46` | `N/A` | N/A / N/A / N/A | 1595.8 | 429 |