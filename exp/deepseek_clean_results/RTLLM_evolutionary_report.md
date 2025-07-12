# 🧬 BENCHMARK EVOLUTION REPORT: RTLLM

## 📈 Summary
- **Total Problems Analyzed:** 50
- **Average Runtime per Problem:** 1990.43s
- **Average LLM API Calls per Problem:** 430.0

### ✅ Pass Rate Analysis
| Metric | Initial Any Passing Gen | Any Passing Gen | Initial Pass@1 | Final Pass@1 | Change |
|:---|:---|:---|:---|:---|:---|
| **Syntax** | 84.0% (42/50) | 92.0% (46/50) | 80.2% | 80.2% | **-0.0%** |
| **Functionality** | 64.0% (32/50) | 88.0% (44/50) | 52.8% | 44.7% | **-8.1%** |
| **Synthesis** | 56.0% (28/50) | 74.0% (37/50) | 43.6% | 36.6% | **-7.0%** |

### ⚡ PPA Optimization Summary
- **Problems with PPA Improvement (Best Solution Compared to Reference):** 30 / 50 (60.0%)

| PPA Metric | Average Improvement |
|:-----------|:--------------------|
| **Area** | +25.92% |
| **Power** | +45.81% |
| **Performance (Period)** | +26.95% |

## 🧬 Strategy Analysis
Shows how often each strategy was used and its success rate (rewarded).
| Strategy | Times Used | Success Count | Success Rate |
|:---------|:-----------|:--------------|:-------------|
| `M-R` | 2036 (19.4%) | 68 | 3.3% |
| `M-S` | 2031 (19.3%) | 67 | 3.3% |
| `M-I` | 2027 (19.3%) | 67 | 3.3% |
| `M-E` | 1916 (18.2%) | 67 | 3.5% |
| `C-F` | 1238 (11.8%) | 35 | 2.8% |
| `M-F` | 752 (7.2%) | 34 | 4.5% |
| `initial` | 500 (4.8%) | 0 | 0.0% |

## 📋 Detailed Problem-by-Problem Analysis
| Problem | Initial Status | Final Status | Best Score | Reference PPA | Best Evo. PPA | PPA % Improv. (A/P/T) | Runtime (s) | API Calls |
|:---|:---|:---|:---:|:---|:---|:---|:---:|:---:|
| Prob001_accu | ✅ (Func: 100%) | ✅ (Func: 37%) | 0.1890 | `Area: 191.00, Power: 0.0468, Period: 0.58` | `Area: 194.00, Power: 0.0163, Period: 0.62` | -1.57% ❌ / +65.17% ✅ / -6.90% ❌ | 1440.3 | 430 |
| Prob002_adder_16bit | ✅ (Func: 100%) | ✅ (Func: 86%) | 0.6274 | `Area: 92.00, Power: 0.0063, Period: 0.00` | `Area: 68.00, Power: 0.0000, Period: 0.00` | +26.09% ✅ / +99.39% ✅ / N/A | 2272.3 | 430 |
| Prob003_adder_32bit | ✅ (Func: 90%) | ✅ (Func: 60%) | 0.8368 | `Area: 423.00, Power: 0.0324, Period: 0.00` | `Area: 137.00, Power: 0.0001, Period: 0.00` | +67.61% ✅ / +99.75% ✅ / N/A | 2487.3 | 430 |
| Prob004_adder_8bit | ❌ (Func: 0%) | ✅ (Func: 76%) | 0.3314 | `Area: 46.00, Power: 0.0030, Period: 0.00` | `Area: 34.00, Power: 0.0018, Period: 0.00` | +26.09% ✅ / +40.20% ✅ / N/A | 1947.6 | 430 |
| Prob005_adder_bcd | ✅ (Func: 100%) | ✅ (Func: 74%) | 0.2127 | `Area: 45.00, Power: 0.0045, Period: 0.00` | `Area: 35.00, Power: 0.0036, Period: 0.00` | +22.22% ✅ / +20.31% ✅ / N/A | 1588.0 | 430 |
| Prob006_adder_pipe_64bit | ❌ (Func: 0%) | ✅ (Func: 1%) | N/A | `N/A` | `N/A` | N/A / N/A / N/A | 2057.2 | 430 |
| Prob007_comparator_3bit | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.1526 | `Area: 17.00, Power: 0.0010, Period: 0.00` | `Area: 15.00, Power: 0.0008, Period: 0.00` | +11.76% ✅ / +18.76% ✅ / N/A | 1450.9 | 430 |
| Prob008_comparator_4bit | ✅ (Func: 90%) | ✅ (Func: 92%) | 0.5886 | `Area: 33.00, Power: 0.0020, Period: 0.00` | `Area: 16.00, Power: 0.0007, Period: 0.00` | +51.52% ✅ / +66.20% ✅ / N/A | 1579.1 | 430 |
| Prob009_div_16bit | ✅ (Func: 40%) | ✅ (Func: 50%) | 0.7836 | `Area: 6390.00, Power: 1.0500, Period: 0.00` | `Area: 1384.00, Power: 0.2270, Period: 0.00` | +78.34% ✅ / +78.38% ✅ / N/A | 2482.9 | 430 |
| Prob010_radix2_div | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 495.00, Power: 0.0487, Period: 0.54` | `N/A` | N/A / N/A / N/A | 1830.6 | 430 |
| Prob011_multi_16bit | ✅ (Func: 70%) | ✅ (Func: 36%) | 0.2756 | `Area: 1064.00, Power: 0.1800, Period: 1.16` | `Area: 1041.00, Power: 0.1080, Period: 0.69` | +2.16% ✅ / +40.00% ✅ / +40.52% ✅ | 2087.1 | 430 |
| Prob012_multi_8bit | ✅ (Func: 30%) | ✅ (Func: 50%) | 0.5062 | `Area: 596.00, Power: 0.0886, Period: 0.00` | `Area: 368.00, Power: 0.0328, Period: 0.00` | +38.26% ✅ / +62.98% ✅ / N/A | 2426.8 | 430 |
| Prob013_multi_booth_8bit | ❌ (Func: 0%) | ✅ (Func: 16%) | 0.0000 | `N/A` | `Area: 732.00, Power: 0.1330, Period: 0.93` | N/A / N/A / N/A | 2557.4 | 430 |
| Prob014_multi_pipe_4bit | ✅ (Func: 90%) | ✅ (Func: 52%) | N/A | `Area: 190.00, Power: 0.0198, Period: 0.38` | `N/A` | N/A / N/A / N/A | 1685.2 | 430 |
| Prob015_multi_pipe_8bit | ✅ (Func: 10%) | ✅ (Func: 40%) | 0.2636 | `Area: 980.00, Power: 0.0898, Period: 0.82` | `Area: 1022.00, Power: 0.0456, Period: 0.54` | -4.29% ❌ / +49.22% ✅ / +34.15% ✅ | 2274.1 | 430 |
| Prob016_fixed_point_adder | ✅ (Func: 90%) | ✅ (Func: 83%) | N/A | `Area: 981.00, Power: 0.0725, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1647.7 | 430 |
| Prob017_fixed_point_substractor | ✅ (Func: 100%) | ✅ (Func: 89%) | N/A | `Area: 694.00, Power: 0.0524, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1695.4 | 430 |
| Prob018_float_multi | ✅ (Func: 30%) | ✅ (Func: 34%) | 0.0000 | `N/A` | `Area: 3957.00, Power: 0.5050, Period: 0.00` | N/A / N/A / N/A | 3034.2 | 430 |
| Prob019_sub_64bit | ✅ (Func: 60%) | ✅ (Func: 68%) | 0.4532 | `Area: 621.00, Power: 0.0412, Period: 0.00` | `Area: 340.00, Power: 0.0225, Period: 0.00` | +45.25% ✅ / +45.39% ✅ / N/A | 2170.0 | 430 |
| Prob020_JC_counter | ✅ (Func: 100%) | ✅ (Func: 65%) | -0.0000 | `Area: 340.00, Power: 0.0351, Period: 0.13` | `Area: 340.00, Power: 0.0351, Period: 0.13` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1474.0 | 430 |
| Prob021_counter_12 | ✅ (Func: 100%) | ✅ (Func: 91%) | 0.3327 | `Area: 44.00, Power: 0.0096, Period: 0.28` | `Area: 36.00, Power: 0.0018, Period: 0.28` | +18.18% ✅ / +81.62% ✅ / +0.00% ➖ | 1660.3 | 430 |
| Prob022_ring_counter | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 43.00, Power: 0.0055, Period: 0.13` | `N/A` | N/A / N/A / N/A | 942.5 | 430 |
| Prob023_up_down_counter | ✅ (Func: 100%) | ✅ (Func: 68%) | 0.2532 | `Area: 259.00, Power: 0.0358, Period: 0.54` | `Area: 203.00, Power: 0.0243, Period: 0.42` | +21.62% ✅ / +32.12% ✅ / +22.22% ✅ | 1714.5 | 430 |
| Prob024_fsm | ✅ (Func: 30%) | ✅ (Func: 30%) | 0.6452 | `Area: 46.00, Power: 0.0069, Period: 0.00` | `Area: 20.00, Power: 0.0019, Period: 0.18` | +56.52% ✅ / +72.52% ✅ / N/A | 1530.4 | 430 |
| Prob025_sequence_detector | ❌ (Func: 0%) | ✅ (Func: 14%) | 0.3624 | `Area: 38.00, Power: 0.0039, Period: 0.19` | `Area: 25.00, Power: 0.0020, Period: 0.14` | +34.21% ✅ / +48.20% ✅ / +26.32% ✅ | 1308.5 | 430 |
| Prob026_asyn_fifo | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 1163.00, Power: 0.1420, Period: 0.00` | `N/A` | N/A / N/A / N/A | 2737.1 | 430 |
| Prob027_LIFObuffer | ✅ (Func: 70%) | ✅ (Func: 38%) | 0.2851 | `Area: 299.00, Power: 0.0419, Period: 0.39` | `Area: 242.00, Power: 0.0205, Period: 0.33` | +19.06% ✅ / +51.07% ✅ / +15.38% ✅ | 1756.7 | 430 |
| Prob028_LFSR | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 23.00, Power: 0.0029, Period: 0.18` | `N/A` | N/A / N/A / N/A | 1197.6 | 430 |
| Prob029_barrel_shifter | ❌ (Func: 0%) | ✅ (Func: 1%) | 0.1196 | `Area: 58.00, Power: 0.0027, Period: 0.00` | `Area: 51.00, Power: 0.0024, Period: 0.00` | +12.07% ✅ / +11.85% ✅ / N/A | 1437.9 | 430 |
| Prob030_right_shifter | ✅ (Func: 100%) | ✅ (Func: 63%) | 0.0239 | `Area: 36.00, Power: 0.0037, Period: 0.12` | `Area: 38.00, Power: 0.0032, Period: 0.12` | -5.56% ❌ / +12.74% ✅ / +0.00% ➖ | 1377.4 | 430 |
| Prob031_freq_div | ✅ (Func: 100%) | ✅ (Func: 42%) | 0.2310 | `Area: 125.00, Power: 0.0007, Period: 0.00` | `Area: 106.00, Power: 0.0005, Period: 0.00` | +15.20% ✅ / +31.00% ✅ / N/A | 1766.8 | 430 |
| Prob032_freq_divbyeven | ❌ (Func: 0%) | ✅ (Func: 4%) | N/A | `Area: 43.00, Power: 0.0040, Period: 0.27` | `N/A` | N/A / N/A / N/A | 1108.4 | 430 |
| Prob033_freq_divbyfrac | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 59.00, Power: 0.0061, Period: 0.29` | `N/A` | N/A / N/A / N/A | 1500.4 | 430 |
| Prob034_freq_divbyodd | ❌ (Func: 0%) | ✅ (Func: 2%) | -0.2085 | `Area: 57.00, Power: 0.0058, Period: 0.22` | `Area: 78.00, Power: 0.0065, Period: 0.25` | -36.84% ❌ / -12.07% ❌ / -13.64% ❌ | 1421.8 | 430 |
| Prob035_calendar | ✅ (Func: 100%) | ✅ (Func: 78%) | 0.0463 | `Area: 196.00, Power: 0.0124, Period: 0.38` | `Area: 185.00, Power: 0.0117, Period: 0.37` | +5.61% ✅ / +5.65% ✅ / +2.63% ✅ | 1950.3 | 430 |
| Prob036_edge_detect | ✅ (Func: 100%) | ✅ (Func: 81%) | 0.9612 | `Area: 19.00, Power: 0.0019, Period: 0.17` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +89.47% ✅ / +98.88% ✅ / +100.00% ✅ | 1487.1 | 430 |
| Prob037_parallel2serial | ✅ (Func: 40%) | ✅ (Func: 44%) | 0.2181 | `Area: 50.00, Power: 0.0045, Period: 0.27` | `Area: 37.00, Power: 0.0031, Period: 0.25` | +26.00% ✅ / +32.01% ✅ / +7.41% ✅ | 2114.4 | 430 |
| Prob038_pulse_detect | ❌ (Func: 0%) | ✅ (Func: 2%) | 0.2789 | `Area: 17.00, Power: 0.0014, Period: 0.21` | `Area: 13.00, Power: 0.0010, Period: 0.14` | +23.53% ✅ / +26.81% ✅ / +33.33% ✅ | 1323.4 | 430 |
| Prob039_serial2parallel | ❌ (Func: 0%) | ✅ (Func: 3%) | -0.1456 | `Area: 168.00, Power: 0.0238, Period: 0.30` | `Area: 165.00, Power: 0.0370, Period: 0.27` | +1.79% ✅ / -55.46% ❌ / +10.00% ✅ | 12606.5 | 430 |
| Prob040_synchronizer | ✅ (Func: 100%) | ✅ (Func: 85%) | 0.0000 | `N/A` | `Area: 78.00, Power: 0.0022, Period: 0.00` | N/A / N/A / N/A | 1730.5 | 430 |
| Prob041_traffic_light | ❌ (Func: 0%) | ✅ (Func: 46%) | 0.6813 | `Area: 170.00, Power: 0.0324, Period: 0.00` | `Area: 107.00, Power: 0.0003, Period: 0.00` | +37.06% ✅ / +99.21% ✅ / N/A | 1801.6 | 430 |
| Prob042_width_8to16 | ✅ (Func: 100%) | ✅ (Func: 69%) | N/A | `Area: 196.00, Power: 0.0517, Period: 0.26` | `N/A` | N/A / N/A / N/A | 1447.7 | 430 |
| Prob043_RAM | ✅ (Func: 100%) | ✅ (Func: 44%) | 0.4884 | `Area: 734.00, Power: 0.1090, Period: 0.31` | `Area: 466.00, Power: 0.0348, Period: 0.18` | +36.51% ✅ / +68.07% ✅ / +41.94% ✅ | 1554.9 | 430 |
| Prob044_ROM | ✅ (Func: 100%) | ✅ (Func: 60%) | -0.0000 | `Area: 14.00, Power: 0.0002, Period: 0.00` | `Area: 14.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1583.5 | 430 |
| Prob045_alu | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 2225.00, Power: 0.1140, Period: 0.00` | `N/A` | N/A / N/A / N/A | 2566.4 | 430 |
| Prob046_clkgenerator | ❌ (Func: 0%) | ✅ (Func: 13%) | N/A | `Area: 1.00, Power: 0.0000, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1272.5 | 430 |
| Prob047_instr_reg | ✅ (Func: 100%) | ✅ (Func: 91%) | 0.8060 | `Area: 119.00, Power: 0.0129, Period: 0.18` | `Area: 57.00, Power: 0.0013, Period: 0.00` | +52.10% ✅ / +89.69% ✅ / +100.00% ✅ | 1554.7 | 430 |
| Prob048_pe | ✅ (Func: 100%) | ✅ (Func: 53%) | 0.1119 | `Area: 3451.00, Power: 0.4510, Period: 1.57` | `Area: 3394.00, Power: 0.3070, Period: 1.57` | +1.65% ✅ / +31.93% ✅ / +0.00% ➖ | 2073.9 | 430 |
| Prob049_signal_generator | ❌ (Func: 0%) | ✅ (Func: 17%) | 0.2742 | `Area: 94.00, Power: 0.0047, Period: 0.43` | `Area: 84.00, Power: 0.0025, Period: 0.32` | +10.64% ✅ / +46.04% ✅ / +25.58% ✅ | 1329.1 | 430 |
| Prob050_square_wave | ✅ (Func: 100%) | ✅ (Func: 89%) | 0.9972 | `Area: 119.00, Power: 0.0247, Period: 0.38` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +99.16% ✅ / +100.00% ✅ / +100.00% ✅ | 1476.8 | 430 |