# 🧬 BENCHMARK EVOLUTION REPORT: VerilogEval-Spec-to-RTL

## 📈 Summary
- **Total Problems Analyzed:** 156
- **Average Runtime per Problem:** 677.11s
- **Average LLM API Calls per Problem:** 651.0

### ✅ Pass Rate Analysis
| Metric | Initial Any Passing Gen | Any Passing Gen | Initial Pass@1 | Final Pass@1 | Change |
|:---|:---|:---|:---|:---|:---|
| **Syntax** | 96.8% (151/156) | 96.8% (151/156) | 65.0% | 65.0% | **+0.0%** |
| **Functionality** | 79.5% (124/156) | 79.5% (124/156) | 41.7% | 41.7% | **+0.0%** |
| **Synthesis** | 75.6% (118/156) | 75.6% (118/156) | 40.1% | 40.1% | **+0.0%** |

### ⚡ PPA Optimization Summary
- **Problems with PPA Improvement (Best Solution Compared to Reference):** 22 / 156 (14.1%)

| PPA Metric | Average Improvement |
|:-----------|:--------------------|
| **Area** | +0.36% |
| **Power** | +1.87% |
| **Performance (Period)** | -1.24% |

## 🧬 Strategy Analysis
Shows how often each strategy was used and its success rate (rewarded).
| Strategy | Times Used | Success Count | Success Rate |
|:---------|:-----------|:--------------|:-------------|
| `initial` | 30393 (100.0%) | 0 | 0.0% |

## 📋 Detailed Problem-by-Problem Analysis
| Problem | Initial Status | Final Status | Best Score | Reference PPA | Best Evo. PPA | PPA % Improv. (A/P/T) | Runtime (s) | API Calls |
|:---|:---|:---|:---:|:---|:---|:---|:---:|:---:|
| Prob001_zero | ✅ (Func: 94%) | ✅ (Func: 94%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 873.7 | 616 |
| Prob002_m2014_q4i | ✅ (Func: 99%) | ✅ (Func: 99%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 689.4 | 677 |
| Prob003_step_one | ✅ (Func: 92%) | ✅ (Func: 92%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1548.4 | 766 |
| Prob004_vector2 | ✅ (Func: 84%) | ✅ (Func: 84%) | -0.0000 | `Area: 26.00, Power: 0.0007, Period: 0.00` | `Area: 26.00, Power: 0.0007, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 752.3 | 602 |
| Prob005_notgate | ✅ (Func: 87%) | ✅ (Func: 87%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 865.0 | 618 |
| Prob006_vectorr | ✅ (Func: 90%) | ✅ (Func: 90%) | -0.0000 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 697.2 | 679 |
| Prob007_wire | ✅ (Func: 94%) | ✅ (Func: 94%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1534.9 | 706 |
| Prob008_m2014_q4h | ✅ (Func: 96%) | ✅ (Func: 96%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 248.2 | 599 |
| Prob009_popcount3 | ✅ (Func: 72%) | ✅ (Func: 72%) | -0.0000 | `Area: 4.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1561.4 | 913 |
| Prob010_mt2015_q4a | ✅ (Func: 88%) | ✅ (Func: 88%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 492.8 | 599 |
| Prob011_norgate | ✅ (Func: 95%) | ✅ (Func: 95%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 927.1 | 716 |
| Prob012_xnorgate | ✅ (Func: 98%) | ✅ (Func: 98%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 592.1 | 599 |
| Prob013_m2014_q4e | ✅ (Func: 94%) | ✅ (Func: 94%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1561.4 | 827 |
| Prob014_andgate | ✅ (Func: 95%) | ✅ (Func: 95%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 488.2 | 599 |
| Prob015_vector1 | ✅ (Func: 90%) | ✅ (Func: 90%) | -0.0000 | `Area: 13.00, Power: 0.0003, Period: 0.00` | `Area: 13.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1548.4 | 852 |
| Prob016_m2014_q4j | ✅ (Func: 78%) | ✅ (Func: 78%) | 0.5550 | `Area: 25.00, Power: 0.0013, Period: 0.00` | `Area: 22.00, Power: 0.0000, Period: 0.00` | +12.00% ✅ / +98.99% ✅ / N/A | 958.8 | 690 |
| Prob017_mux2to1v | ✅ (Func: 93%) | ✅ (Func: 93%) | -0.0000 | `Area: 208.00, Power: 0.0071, Period: 0.00` | `Area: 208.00, Power: 0.0071, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1560.9 | 923 |
| Prob018_mux256to1 | ✅ (Func: 82%) | ✅ (Func: 82%) | -0.0000 | `Area: 522.00, Power: 0.0237, Period: 0.00` | `Area: 522.00, Power: 0.0237, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1201.7 | 799 |
| Prob019_m2014_q4f | ✅ (Func: 100%) | ✅ (Func: 100%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1205.2 | 708 |
| Prob020_mt2015_eq2 | ✅ (Func: 89%) | ✅ (Func: 89%) | -0.0000 | `Area: 5.00, Power: 0.0003, Period: 0.00` | `Area: 5.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 609.0 | 599 |
| Prob021_mux256to1v | ✅ (Func: 72%) | ✅ (Func: 72%) | -0.0000 | `Area: 2040.00, Power: 0.0942, Period: 0.00` | `Area: 2040.00, Power: 0.0942, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1785.7 | 685 |
| Prob022_mux2to1 | ✅ (Func: 98%) | ✅ (Func: 98%) | -0.0000 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 570.6 | 599 |
| Prob023_vector100r | ✅ (Func: 34%) | ✅ (Func: 34%) | -0.0000 | `Area: 80.00, Power: 0.0021, Period: 0.00` | `Area: 80.00, Power: 0.0021, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1207.9 | 799 |
| Prob024_hadd | ✅ (Func: 98%) | ✅ (Func: 98%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 590.1 | 599 |
| Prob025_reduction | ✅ (Func: 96%) | ✅ (Func: 96%) | -0.0000 | `Area: 11.00, Power: 0.0009, Period: 0.00` | `Area: 11.00, Power: 0.0009, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1563.0 | 911 |
| Prob026_alwaysblock1 | ✅ (Func: 14%) | ✅ (Func: 14%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 805.3 | 599 |
| Prob027_fadd | ✅ (Func: 92%) | ✅ (Func: 92%) | -0.0000 | `Area: 4.00, Power: 0.0002, Period: 0.00` | `Area: 4.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1550.9 | 987 |
| Prob028_m2014_q4a | ✅ (Func: 96%) | ✅ (Func: 96%) | N/A | `Area: 3.00, Power: 0.0001, Period: 0.00` | `N/A` | N/A / N/A / N/A | 369.2 | 599 |
| Prob029_m2014_q4g | ✅ (Func: 92%) | ✅ (Func: 92%) | -0.0000 | `Area: 5.00, Power: 0.0004, Period: 0.00` | `Area: 5.00, Power: 0.0004, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1321.5 | 838 |
| Prob030_popcount255 | ✅ (Func: 31%) | ✅ (Func: 31%) | 0.0284 | `Area: 1339.00, Power: 0.2150, Period: 0.00` | `Area: 1319.00, Power: 0.2060, Period: 0.00` | +1.49% ✅ / +4.19% ✅ / N/A | 2590.9 | 599 |
| Prob031_dff | ✅ (Func: 92%) | ✅ (Func: 92%) | -0.0000 | `Area: 5.00, Power: 0.0005, Period: 0.00` | `Area: 5.00, Power: 0.0005, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1546.4 | 927 |
| Prob032_vector0 | ✅ (Func: 95%) | ✅ (Func: 95%) | -0.0000 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 759.4 | 621 |
| Prob033_ece241_2014_q1c | ✅ (Func: 62%) | ✅ (Func: 62%) | -0.0000 | `Area: 52.00, Power: 0.0032, Period: 0.00` | `Area: 52.00, Power: 0.0032, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1553.7 | 866 |
| Prob034_dff8 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 36.00, Power: 0.0036, Period: 0.00` | `N/A` | N/A / N/A / N/A | 818.7 | 663 |
| Prob035_count1to10 | ✅ (Func: 80%) | ✅ (Func: 80%) | -0.0000 | `Area: 41.00, Power: 0.0044, Period: 0.26` | `Area: 41.00, Power: 0.0044, Period: 0.26` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1561.7 | 891 |
| Prob036_ringer | ✅ (Func: 80%) | ✅ (Func: 80%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 925.8 | 600 |
| Prob037_review2015_count1k | ✅ (Func: 76%) | ✅ (Func: 76%) | -0.0000 | `Area: 93.00, Power: 0.0077, Period: 0.38` | `Area: 93.00, Power: 0.0077, Period: 0.38` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1562.9 | 796 |
| Prob038_count15 | ✅ (Func: 82%) | ✅ (Func: 82%) | -0.0000 | `Area: 30.00, Power: 0.0033, Period: 0.25` | `Area: 30.00, Power: 0.0033, Period: 0.25` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 790.1 | 601 |
| Prob039_always_if | ✅ (Func: 66%) | ✅ (Func: 66%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1550.7 | 986 |
| Prob040_count10 | ✅ (Func: 73%) | ✅ (Func: 73%) | -0.0000 | `Area: 39.00, Power: 0.0037, Period: 0.26` | `Area: 39.00, Power: 0.0037, Period: 0.26` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 755.6 | 636 |
| Prob041_dff8r | ✅ (Func: 20%) | ✅ (Func: 20%) | -0.0000 | `Area: 57.00, Power: 0.0053, Period: 0.00` | `Area: 57.00, Power: 0.0053, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 855.9 | 603 |
| Prob042_vector4 | ✅ (Func: 70%) | ✅ (Func: 70%) | -0.0000 | `Area: 26.00, Power: 0.0007, Period: 0.00` | `Area: 26.00, Power: 0.0007, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 707.1 | 677 |
| Prob043_vector5 | ✅ (Func: 78%) | ✅ (Func: 78%) | -0.0000 | `Area: 39.00, Power: 0.0019, Period: 0.00` | `Area: 39.00, Power: 0.0019, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1560.9 | 888 |
| Prob044_vectorgates | ✅ (Func: 86%) | ✅ (Func: 86%) | -0.0000 | `Area: 10.00, Power: 0.0003, Period: 0.00` | `Area: 10.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 947.1 | 621 |
| Prob045_edgedetect2 | ✅ (Func: 30%) | ✅ (Func: 30%) | -0.0000 | `Area: 85.00, Power: 0.0087, Period: 0.17` | `Area: 85.00, Power: 0.0087, Period: 0.17` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 864.5 | 599 |
| Prob046_dff8p | ✅ (Func: 15%) | ✅ (Func: 15%) | 0.4985 | `Area: 52.00, Power: 0.0061, Period: 0.00` | `Area: 52.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +99.71% ✅ / N/A | 697.7 | 681 |
| Prob047_dff8ar | ✅ (Func: 38%) | ✅ (Func: 38%) | 0.4288 | `Area: 43.00, Power: 0.0038, Period: 0.00` | `Area: 49.00, Power: 0.0000, Period: 0.00` | -13.95% ❌ / +99.71% ✅ / N/A | 733.4 | 723 |
| Prob048_m2014_q4c | ✅ (Func: 96%) | ✅ (Func: 96%) | -0.0000 | `Area: 6.00, Power: 0.0006, Period: 0.00` | `Area: 6.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 189.8 | 599 |
| Prob049_m2014_q4b | ✅ (Func: 57%) | ✅ (Func: 57%) | -0.0000 | `Area: 6.00, Power: 0.0005, Period: 0.00` | `Area: 6.00, Power: 0.0005, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1546.8 | 909 |
| Prob050_kmap1 | ✅ (Func: 35%) | ✅ (Func: 35%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 642.2 | 627 |
| Prob051_gates4 | ✅ (Func: 94%) | ✅ (Func: 94%) | -0.0000 | `Area: 16.00, Power: 0.0007, Period: 0.00` | `Area: 16.00, Power: 0.0007, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1564.4 | 924 |
| Prob052_gates100 | ✅ (Func: 78%) | ✅ (Func: 78%) | 0.3684 | `Area: 443.00, Power: 0.0274, Period: 0.00` | `Area: 254.00, Power: 0.0189, Period: 0.00` | +42.66% ✅ / +31.02% ✅ / N/A | 1062.0 | 799 |
| Prob053_m2014_q4d | ✅ (Func: 3%) | ✅ (Func: 3%) | N/A | `Area: 6.00, Power: 0.0017, Period: 0.17` | `N/A` | N/A / N/A / N/A | 420.2 | 585 |
| Prob054_edgedetect | ✅ (Func: 36%) | ✅ (Func: 36%) | -0.0000 | `Area: 87.00, Power: 0.0086, Period: 0.14` | `Area: 87.00, Power: 0.0086, Period: 0.14` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 752.4 | 612 |
| Prob055_conditional | ✅ (Func: 60%) | ✅ (Func: 60%) | 0.2668 | `Area: 243.00, Power: 0.0290, Period: 0.00` | `Area: 208.00, Power: 0.0177, Period: 0.00` | +14.40% ✅ / +38.97% ✅ / N/A | 1673.5 | 988 |
| Prob056_ece241_2013_q7 | ✅ (Func: 99%) | ✅ (Func: 99%) | -0.0000 | `Area: 7.00, Power: 0.0007, Period: 0.18` | `Area: 7.00, Power: 0.0007, Period: 0.18` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 686.4 | 656 |
| Prob057_kmap2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 6.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 864.2 | 724 |
| Prob058_alwaysblock2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 7.00, Power: 0.0007, Period: 0.00` | `N/A` | N/A / N/A / N/A | 65.7 | 599 |
| Prob059_wire4 | ✅ (Func: 98%) | ✅ (Func: 98%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1547.8 | 993 |
| Prob060_m2014_q4k | ✅ (Func: 78%) | ✅ (Func: 78%) | -0.0000 | `Area: 22.00, Power: 0.0026, Period: 0.14` | `Area: 22.00, Power: 0.0026, Period: 0.14` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 766.0 | 638 |
| Prob061_2014_q4a | ✅ (Func: 80%) | ✅ (Func: 80%) | -0.0000 | `Area: 9.00, Power: 0.0008, Period: 0.23` | `Area: 9.00, Power: 0.0008, Period: 0.23` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 874.0 | 708 |
| Prob062_bugs_mux2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 17.00, Power: 0.0006, Period: 0.00` | `N/A` | N/A / N/A / N/A | 90.6 | 599 |
| Prob063_review2015_shiftcount | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 43.00, Power: 0.0067, Period: 0.29` | `N/A` | N/A / N/A / N/A | 897.7 | 786 |
| Prob064_vector3 | ✅ (Func: 96%) | ✅ (Func: 96%) | -0.0000 | `Area: 26.00, Power: 0.0006, Period: 0.00` | `Area: 26.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 646.9 | 600 |
| Prob065_7420 | ✅ (Func: 97%) | ✅ (Func: 97%) | -0.0000 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 641.0 | 601 |
| Prob066_edgecapture | ✅ (Func: 4%) | ✅ (Func: 4%) | N/A | `Area: 437.00, Power: 0.0442, Period: 0.19` | `N/A` | N/A / N/A / N/A | 852.8 | 652 |
| Prob067_countslow | ✅ (Func: 64%) | ✅ (Func: 64%) | -0.0000 | `Area: 47.00, Power: 0.0037, Period: 0.30` | `Area: 47.00, Power: 0.0037, Period: 0.30` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 737.4 | 639 |
| Prob068_countbcd | ✅ (Func: 10%) | ✅ (Func: 10%) | 0.0869 | `Area: 180.00, Power: 0.0146, Period: 0.41` | `Area: 179.00, Power: 0.0123, Period: 0.37` | +0.56% ✅ / +15.75% ✅ / +9.76% ✅ | 639.0 | 599 |
| Prob069_truthtable1 | ✅ (Func: 43%) | ✅ (Func: 43%) | -0.0000 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1341.2 | 800 |
| Prob070_ece241_2013_q2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 141.1 | 598 |
| Prob071_always_casez | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 17.00, Power: 0.0006, Period: 0.00` | `N/A` | N/A / N/A / N/A | 407.7 | 552 |
| Prob072_thermostat | ✅ (Func: 72%) | ✅ (Func: 72%) | 0.0032 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 5.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.65% ✅ / N/A | 200.5 | 599 |
| Prob073_dff16e | ✅ (Func: 45%) | ✅ (Func: 45%) | -0.0000 | `Area: 129.00, Power: 0.0126, Period: 0.20` | `Area: 129.00, Power: 0.0126, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 892.4 | 648 |
| Prob074_ece241_2014_q4 | ✅ (Func: 38%) | ✅ (Func: 38%) | N/A | `Area: 20.00, Power: 0.0031, Period: 0.18` | `N/A` | N/A / N/A / N/A | 174.9 | 599 |
| Prob075_counter_2bc | ✅ (Func: 64%) | ✅ (Func: 64%) | 0.3608 | `Area: 30.00, Power: 0.0059, Period: 0.25` | `Area: 20.00, Power: 0.0027, Period: 0.20` | +33.33% ✅ / +54.90% ✅ / +20.00% ✅ | 941.8 | 803 |
| Prob076_always_case | ✅ (Func: 2%) | ✅ (Func: 2%) | -0.0000 | `Area: 44.00, Power: 0.0019, Period: 0.00` | `Area: 44.00, Power: 0.0019, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 357.4 | 575 |
| Prob077_wire_decl | ✅ (Func: 66%) | ✅ (Func: 66%) | -0.0000 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 915.1 | 611 |
| Prob078_dualedge | ✅ (Func: 30%) | ✅ (Func: 30%) | -0.0000 | `Area: 11.00, Power: 0.0016, Period: 0.00` | `Area: 11.00, Power: 0.0016, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 281.2 | 599 |
| Prob079_fsm3onehot | ✅ (Func: 12%) | ✅ (Func: 12%) | -0.0000 | `Area: 8.00, Power: 0.0003, Period: 0.00` | `Area: 8.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 875.5 | 799 |
| Prob080_timer | ✅ (Func: 38%) | ✅ (Func: 38%) | 0.0364 | `Area: 104.00, Power: 0.0121, Period: 0.35` | `Area: 107.00, Power: 0.0097, Period: 0.37` | -2.88% ❌ / +19.50% ✅ / -5.71% ❌ | 179.3 | 598 |
| Prob081_7458 | ✅ (Func: 82%) | ✅ (Func: 82%) | -0.0000 | `Area: 5.00, Power: 0.0001, Period: 0.00` | `Area: 5.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1231.6 | 720 |
| Prob082_lfsr32 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 221.00, Power: 0.0252, Period: 0.24` | `N/A` | N/A / N/A / N/A | 477.6 | 577 |
| Prob083_mt2015_q4b | ✅ (Func: 84%) | ✅ (Func: 84%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 381.3 | 599 |
| Prob084_ece241_2013_q12 | ✅ (Func: 57%) | ✅ (Func: 57%) | -0.0000 | `Area: 67.00, Power: 0.0113, Period: 0.18` | `Area: 67.00, Power: 0.0113, Period: 0.18` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 466.2 | 599 |
| Prob085_shift4 | ✅ (Func: 78%) | ✅ (Func: 78%) | -0.0000 | `Area: 39.00, Power: 0.0036, Period: 0.24` | `Area: 39.00, Power: 0.0036, Period: 0.24` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 522.6 | 599 |
| Prob086_lfsr5 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 37.00, Power: 0.0038, Period: 0.18` | `N/A` | N/A / N/A / N/A | 107.0 | 600 |
| Prob087_gates | ✅ (Func: 86%) | ✅ (Func: 86%) | -0.0000 | `Area: 16.00, Power: 0.0006, Period: 0.00` | `Area: 16.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 711.7 | 615 |
| Prob088_ece241_2014_q5b | ✅ (Func: 12%) | ✅ (Func: 12%) | -0.9014 | `Area: 10.00, Power: 0.0004, Period: 0.15` | `Area: 16.00, Power: 0.0012, Period: 0.19` | -60.00% ❌ / -183.75% ❌ / -26.67% ❌ | 123.3 | 599 |
| Prob089_ece241_2014_q5a | ✅ (Func: 1%) | ✅ (Func: 1%) | 0.4125 | `Area: 23.00, Power: 0.0027, Period: 0.22` | `Area: 15.00, Power: 0.0009, Period: 0.17` | +34.78% ✅ / +66.24% ✅ / +22.73% ✅ | 559.3 | 575 |
| Prob090_circuit1 | ✅ (Func: 88%) | ✅ (Func: 88%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 197.4 | 599 |
| Prob091_2012_q2b | ✅ (Func: 6%) | ✅ (Func: 6%) | -0.0000 | `Area: 4.00, Power: 0.0001, Period: 0.00` | `Area: 4.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 720.5 | 599 |
| Prob092_gatesv100 | ✅ (Func: 34%) | ✅ (Func: 34%) | -0.0000 | `Area: 637.00, Power: 0.0240, Period: 0.00` | `Area: 637.00, Power: 0.0240, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 236.3 | 598 |
| Prob093_ece241_2014_q3 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 4.00, Power: 0.0001, Period: 0.00` | `N/A` | N/A / N/A / N/A | 391.5 | 599 |
| Prob094_gatesv | ✅ (Func: 1%) | ✅ (Func: 1%) | -0.0000 | `Area: 24.00, Power: 0.0009, Period: 0.00` | `Area: 24.00, Power: 0.0009, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 411.7 | 569 |
| Prob095_review2015_fsmshift | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 24.00, Power: 0.0025, Period: 0.15` | `N/A` | N/A / N/A / N/A | 361.2 | 600 |
| Prob096_review2015_fsmseq | ✅ (Func: 4%) | ✅ (Func: 4%) | 0.1138 | `Area: 33.00, Power: 0.0036, Period: 0.19` | `Area: 25.00, Power: 0.0027, Period: 0.22` | +24.24% ✅ / +25.70% ✅ / -15.79% ❌ | 169.3 | 599 |
| Prob097_mux9to1v | ✅ (Func: 1%) | ✅ (Func: 1%) | -0.0000 | `Area: 269.00, Power: 0.0122, Period: 0.00` | `Area: 269.00, Power: 0.0122, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 403.7 | 545 |
| Prob098_circuit7 | ✅ (Func: 24%) | ✅ (Func: 24%) | -0.0000 | `Area: 5.00, Power: 0.0005, Period: 0.00` | `Area: 5.00, Power: 0.0005, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 168.3 | 599 |
| Prob099_m2014_q6c | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0001, Period: 0.00` | `N/A` | N/A / N/A / N/A | 108.3 | 610 |
| Prob100_fsm3comb | ✅ (Func: 1%) | ✅ (Func: 1%) | -0.0000 | `Area: 6.00, Power: 0.0002, Period: 0.00` | `Area: 6.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 417.1 | 562 |
| Prob101_circuit4 | ✅ (Func: 24%) | ✅ (Func: 24%) | -0.0000 | `Area: 1.00, Power: 0.0000, Period: 0.00` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 196.8 | 601 |
| Prob102_circuit3 | ✅ (Func: 6%) | ✅ (Func: 6%) | -0.0000 | `Area: 2.00, Power: 0.0001, Period: 0.00` | `Area: 2.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 161.9 | 599 |
| Prob103_circuit2 | ✅ (Func: 23%) | ✅ (Func: 23%) | -0.0000 | `Area: 8.00, Power: 0.0006, Period: 0.00` | `Area: 8.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 141.3 | 599 |
| Prob104_mt2015_muxdff | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 6.00, Power: 0.0006, Period: 0.00` | `N/A` | N/A / N/A / N/A | 99.3 | 609 |
| Prob105_rotate100 | ✅ (Func: 87%) | ✅ (Func: 87%) | 0.0416 | `Area: 1033.00, Power: 0.1020, Period: 0.22` | `Area: 965.00, Power: 0.0960, Period: 0.22` | +6.58% ✅ / +5.88% ✅ / +0.00% ➖ | 1598.1 | 599 |
| Prob106_always_nolatches | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 30.00, Power: 0.0006, Period: 0.00` | `N/A` | N/A / N/A / N/A | 417.5 | 563 |
| Prob107_fsm1s | ✅ (Func: 25%) | ✅ (Func: 25%) | 0.0178 | `Area: 7.00, Power: 0.0009, Period: 0.20` | `Area: 7.00, Power: 0.0009, Period: 0.19` | +0.00% ➖ / +0.34% ✅ / +5.00% ✅ | 147.8 | 599 |
| Prob108_rule90 | ✅ (Func: 34%) | ✅ (Func: 34%) | -0.0766 | `Area: 4198.00, Power: 0.8200, Period: 0.23` | `Area: 4607.00, Power: 0.8930, Period: 0.24` | -9.74% ❌ / -8.90% ❌ / -4.35% ❌ | 4915.1 | 599 |
| Prob109_fsm1 | ✅ (Func: 47%) | ✅ (Func: 47%) | -0.0000 | `Area: 7.00, Power: 0.0018, Period: 0.16` | `Area: 7.00, Power: 0.0018, Period: 0.16` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 294.6 | 599 |
| Prob110_fsm2 | ✅ (Func: 47%) | ✅ (Func: 47%) | -0.0000 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 399.0 | 596 |
| Prob111_fsm2s | ✅ (Func: 43%) | ✅ (Func: 43%) | -0.0000 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 284.1 | 599 |
| Prob112_always_case2 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 6.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 172.5 | 599 |
| Prob113_2012_q1g | ✅ (Func: 4%) | ✅ (Func: 4%) | 0.0023 | `Area: 5.00, Power: 0.0002, Period: 0.00` | `Area: 5.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.47% ✅ / N/A | 508.4 | 613 |
| Prob114_bugs_case | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 53.00, Power: 0.0021, Period: 0.00` | `N/A` | N/A / N/A / N/A | 409.3 | 550 |
| Prob115_shift18 | ✅ (Func: 32%) | ✅ (Func: 32%) | 0.1350 | `Area: 950.00, Power: 0.0963, Period: 0.37` | `Area: 898.00, Power: 0.0782, Period: 0.31` | +5.47% ✅ / +18.80% ✅ / +16.22% ✅ | 320.6 | 599 |
| Prob116_m2014_q3 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 422.7 | 589 |
| Prob117_circuit9 | ✅ (Func: 6%) | ✅ (Func: 6%) | -0.0000 | `Area: 26.00, Power: 0.0047, Period: 0.24` | `Area: 26.00, Power: 0.0047, Period: 0.24` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 119.9 | 599 |
| Prob118_history_shift | ✅ (Func: 84%) | ✅ (Func: 84%) | -0.0000 | `Area: 322.00, Power: 0.0312, Period: 0.24` | `Area: 322.00, Power: 0.0312, Period: 0.24` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 278.4 | 599 |
| Prob119_fsm3 | ✅ (Func: 20%) | ✅ (Func: 20%) | -0.0000 | `Area: 17.00, Power: 0.0014, Period: 0.19` | `Area: 17.00, Power: 0.0014, Period: 0.19` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 166.5 | 599 |
| Prob120_fsm3s | ✅ (Func: 14%) | ✅ (Func: 14%) | 0.2913 | `Area: 27.00, Power: 0.0029, Period: 0.18` | `Area: 17.00, Power: 0.0014, Period: 0.18` | +37.04% ✅ / +50.35% ✅ / +0.00% ➖ | 162.9 | 599 |
| Prob121_2014_q3bfsm | ✅ (Func: 48%) | ✅ (Func: 48%) | -0.0000 | `Area: 39.00, Power: 0.0039, Period: 0.21` | `Area: 39.00, Power: 0.0039, Period: 0.21` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 205.3 | 599 |
| Prob122_kmap4 | ✅ (Func: 13%) | ✅ (Func: 13%) | -0.0000 | `Area: 5.00, Power: 0.0003, Period: 0.00` | `Area: 5.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 219.5 | 598 |
| Prob123_bugs_addsubz | ✅ (Func: 74%) | ✅ (Func: 74%) | 0.0007 | `Area: 90.00, Power: 0.0073, Period: 0.00` | `Area: 90.00, Power: 0.0073, Period: 0.00` | +0.00% ➖ / +0.14% ✅ / N/A | 220.1 | 599 |
| Prob124_rule110 | ✅ (Func: 1%) | ✅ (Func: 1%) | N/A | `Area: 5000.00, Power: 0.5580, Period: 0.22` | `N/A` | N/A / N/A / N/A | 758.2 | 555 |
| Prob125_kmap3 | ✅ (Func: 2%) | ✅ (Func: 2%) | 0.0091 | `Area: 3.00, Power: 0.0001, Period: 0.00` | `Area: 3.00, Power: 0.0001, Period: 0.00` | +0.00% ➖ / +1.82% ✅ / N/A | 448.3 | 571 |
| Prob126_circuit6 | ✅ (Func: 14%) | ✅ (Func: 14%) | -0.0000 | `Area: 60.00, Power: 0.0028, Period: 0.00` | `Area: 60.00, Power: 0.0028, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 166.1 | 599 |
| Prob127_lemmings1 | ✅ (Func: 30%) | ✅ (Func: 30%) | -0.0000 | `Area: 8.00, Power: 0.0007, Period: 0.20` | `Area: 8.00, Power: 0.0007, Period: 0.20` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 241.5 | 599 |
| Prob128_fsm_ps2 | ✅ (Func: 7%) | ✅ (Func: 7%) | -0.0000 | `Area: 26.00, Power: 0.0028, Period: 0.17` | `Area: 26.00, Power: 0.0028, Period: 0.17` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 155.7 | 598 |
| Prob129_ece241_2013_q8 | ✅ (Func: 26%) | ✅ (Func: 26%) | -0.1414 | `Area: 15.00, Power: 0.0013, Period: 0.17` | `Area: 17.00, Power: 0.0015, Period: 0.18` | -13.33% ❌ / -23.20% ❌ / -5.88% ❌ | 182.7 | 599 |
| Prob130_circuit5 | ✅ (Func: 1%) | ✅ (Func: 1%) | -0.0000 | `Area: 34.00, Power: 0.0015, Period: 0.00` | `Area: 34.00, Power: 0.0015, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 414.5 | 547 |
| Prob131_mt2015_q4 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 1.00, Power: 0.0000, Period: 0.00` | `N/A` | N/A / N/A / N/A | 118.2 | 599 |
| Prob132_always_if2 | ✅ (Func: 74%) | ✅ (Func: 74%) | -0.0000 | `Area: 2.00, Power: 0.0000, Period: 0.00` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 219.8 | 599 |
| Prob133_2014_q3fsm | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 56.00, Power: 0.0060, Period: 0.25` | `N/A` | N/A / N/A / N/A | 230.3 | 599 |
| Prob134_2014_q3c | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 7.00, Power: 0.0003, Period: 0.00` | `N/A` | N/A / N/A / N/A | 463.2 | 560 |
| Prob135_m2014_q6b | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 5.00, Power: 0.0002, Period: 0.00` | `N/A` | N/A / N/A / N/A | 215.8 | 599 |
| Prob136_m2014_q6 | ✅ (Func: 12%) | ✅ (Func: 12%) | 0.0197 | `Area: 43.00, Power: 0.0044, Period: 0.20` | `Area: 43.00, Power: 0.0044, Period: 0.19` | +0.00% ➖ / +0.90% ✅ / +5.00% ✅ | 208.3 | 599 |
| Prob137_fsm_serial | ✅ (Func: 1%) | ✅ (Func: 1%) | N/A | `Area: 99.00, Power: 0.0098, Period: 0.18` | `N/A` | N/A / N/A / N/A | 470.8 | 602 |
| Prob138_2012_q2fsm | ✅ (Func: 52%) | ✅ (Func: 52%) | -0.0000 | `Area: 46.00, Power: 0.0046, Period: 0.23` | `Area: 46.00, Power: 0.0046, Period: 0.23` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 210.4 | 598 |
| Prob139_2013_q2bfsm | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 52.00, Power: 0.0055, Period: 0.20` | `N/A` | N/A / N/A / N/A | 260.9 | 598 |
| Prob140_fsm_hdlc | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 68.00, Power: 0.0075, Period: 0.29` | `N/A` | N/A / N/A / N/A | 467.2 | 607 |
| Prob141_count_clock | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 308.00, Power: 0.0190, Period: 0.47` | `N/A` | N/A / N/A / N/A | 487.7 | 599 |
| Prob142_lemmings2 | ✅ (Func: 5%) | ✅ (Func: 5%) | -0.5408 | `Area: 20.00, Power: 0.0024, Period: 0.21` | `Area: 26.00, Power: 0.0049, Period: 0.26` | -30.00% ❌ / -108.44% ❌ / -23.81% ❌ | 238.0 | 598 |
| Prob143_fsm_onehot | ✅ (Func: 5%) | ✅ (Func: 5%) | -0.0157 | `Area: 26.00, Power: 0.0006, Period: 0.00` | `Area: 26.00, Power: 0.0006, Period: 0.00` | +0.00% ➖ / -3.14% ❌ / N/A | 192.2 | 598 |
| Prob144_conwaylife | ✅ (Func: 9%) | ✅ (Func: 9%) | 0.0649 | `Area: 9113.00, Power: 1.9500, Period: 0.74` | `Area: 8847.00, Power: 1.6800, Period: 0.72` | +2.92% ✅ / +13.85% ✅ / +2.70% ✅ | 2031.7 | 599 |
| Prob145_circuit8 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 8.00, Power: 0.0011, Period: 0.00` | `N/A` | N/A / N/A / N/A | 165.2 | 599 |
| Prob146_fsm_serialdata | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 146.00, Power: 0.0141, Period: 0.18` | `N/A` | N/A / N/A / N/A | 180.1 | 599 |
| Prob147_circuit10 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 9.00, Power: 0.0008, Period: 0.19` | `N/A` | N/A / N/A / N/A | 162.9 | 599 |
| Prob148_2013_q2afsm | ✅ (Func: 5%) | ✅ (Func: 5%) | -0.0000 | `Area: 35.00, Power: 0.0033, Period: 0.22` | `Area: 35.00, Power: 0.0033, Period: 0.22` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 192.1 | 599 |
| Prob149_ece241_2013_q4 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 52.00, Power: 0.0049, Period: 0.23` | `N/A` | N/A / N/A / N/A | 271.1 | 599 |
| Prob150_review2015_fsmonehot | ✅ (Func: 3%) | ✅ (Func: 3%) | 0.0059 | `Area: 13.00, Power: 0.0003, Period: 0.00` | `Area: 13.00, Power: 0.0003, Period: 0.00` | +0.00% ➖ / +1.18% ✅ / N/A | 570.4 | 586 |
| Prob151_review2015_fsm | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 66.00, Power: 0.0045, Period: 0.28` | `N/A` | N/A / N/A / N/A | 218.0 | 598 |
| Prob152_lemmings3 | ✅ (Func: 4%) | ✅ (Func: 4%) | -0.0715 | `Area: 50.00, Power: 0.0054, Period: 0.23` | `Area: 39.00, Power: 0.0073, Period: 0.25` | +22.00% ✅ / -34.74% ❌ / -8.70% ❌ | 200.2 | 599 |
| Prob153_gshare | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 3025.00, Power: 0.4370, Period: 0.75` | `N/A` | N/A / N/A / N/A | 329.1 | 597 |
| Prob154_fsm_ps2data | ✅ (Func: 5%) | ✅ (Func: 5%) | -0.5735 | `Area: 134.00, Power: 0.0138, Period: 0.17` | `Area: 221.00, Power: 0.0229, Period: 0.24` | -64.93% ❌ / -65.94% ❌ / -41.18% ❌ | 176.6 | 598 |
| Prob155_lemmings4 | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 102.00, Power: 0.0177, Period: 0.28` | `N/A` | N/A / N/A / N/A | 270.3 | 596 |
| Prob156_review2015_fancytimer | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 187.00, Power: 0.0219, Period: 0.46` | `N/A` | N/A / N/A / N/A | 352.9 | 596 |