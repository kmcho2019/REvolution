# 🧬 BENCHMARK EVOLUTION REPORT: RTLLM

## 📈 Summary
- **Total Problems Analyzed:** 50
- **Average Runtime per Problem:** 1605.01s
- **Average LLM API Calls per Problem:** 429.0

### ✅ Pass Rate Analysis
| Metric | Initial Any Passing Gen | Any Passing Gen | Initial Pass@1 | Final Pass@1 | Change |
|:---|:---|:---|:---|:---|:---|
| **Syntax** | 86.0% (43/50) | 94.0% (47/50) | 56.2% | 72.5% | **+16.3%** |
| **Functionality** | 60.0% (30/50) | 84.0% (42/50) | 33.6% | 41.5% | **+7.9%** |
| **Synthesis** | 48.0% (24/50) | 72.0% (36/50) | 29.0% | 35.4% | **+6.4%** |

### ⚡ PPA Optimization Summary
- **Problems with PPA Improvement (Best Solution Compared to Reference):** 28 / 50 (56.0%)

| PPA Metric | Average Improvement |
|:-----------|:--------------------|
| **Area** | +27.98% |
| **Power** | +60.72% |
| **Performance (Period)** | +28.42% |

## 🧬 Strategy Analysis
Shows how often each strategy was used and its success rate (rewarded).
| Strategy | Times Used | Success Count | Success Rate |
|:---------|:-----------|:--------------|:-------------|
| `M-R` | 2036 (19.4%) | 78 | 3.8% |
| `M-I` | 2015 (19.2%) | 76 | 3.8% |
| `M-E` | 2007 (19.1%) | 76 | 3.8% |
| `M-S` | 1978 (18.8%) | 77 | 3.9% |
| `C-F` | 1136 (10.8%) | 35 | 3.1% |
| `M-F` | 828 (7.9%) | 41 | 5.0% |
| `initial` | 500 (4.8%) | 0 | 0.0% |

## 📋 Detailed Problem-by-Problem Analysis
| Problem | Initial Status | Final Status | Best Score | Reference PPA | Best Evo. PPA | PPA % Improv. (A/P/T) | Runtime (s) | API Calls |
|:---|:---|:---|:---:|:---|:---|:---|:---:|:---:|
| Prob001_accu | ✅ (Func: 10%) | ✅ (Func: 28%) | 0.2674 | `Area: 191.00, Power: 0.0468, Period: 0.58` | `Area: 167.00, Power: 0.0232, Period: 0.48` | +12.57% ✅ / +50.43% ✅ / +17.24% ✅ | 1227.8 | 429 |
| Prob002_adder_16bit | ✅ (Func: 70%) | ✅ (Func: 67%) | 0.5999 | `Area: 92.00, Power: 0.0063, Period: 0.00` | `Area: 73.00, Power: 0.0000, Period: 0.00` | +20.65% ✅ / +99.32% ✅ / N/A | 1660.9 | 429 |
| Prob003_adder_32bit | ✅ (Func: 40%) | ✅ (Func: 64%) | 0.8368 | `Area: 423.00, Power: 0.0324, Period: 0.00` | `Area: 137.00, Power: 0.0001, Period: 0.00` | +67.61% ✅ / +99.75% ✅ / N/A | 2106.4 | 429 |
| Prob004_adder_8bit | ✅ (Func: 10%) | ✅ (Func: 47%) | 0.5723 | `Area: 46.00, Power: 0.0030, Period: 0.00` | `Area: 39.00, Power: 0.0000, Period: 0.00` | +15.22% ✅ / +99.25% ✅ / N/A | 1482.5 | 429 |
| Prob005_adder_bcd | ✅ (Func: 30%) | ✅ (Func: 56%) | 0.5735 | `Area: 45.00, Power: 0.0045, Period: 0.00` | `Area: 38.00, Power: 0.0000, Period: 0.00` | +15.56% ✅ / +99.15% ✅ / N/A | 1309.3 | 429 |
| Prob006_adder_pipe_64bit | ❌ (Func: 0%) | ✅ (Func: 1%) | N/A | `N/A` | `N/A` | N/A / N/A / N/A | 1886.5 | 429 |
| Prob007_comparator_3bit | ✅ (Func: 90%) | ✅ (Func: 86%) | -0.0000 | `Area: 17.00, Power: 0.0010, Period: 0.00` | `Area: 17.00, Power: 0.0010, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1433.2 | 429 |
| Prob008_comparator_4bit | ✅ (Func: 50%) | ✅ (Func: 76%) | 0.6019 | `Area: 33.00, Power: 0.0020, Period: 0.00` | `Area: 26.00, Power: 0.0000, Period: 0.00` | +21.21% ✅ / +99.17% ✅ / N/A | 1528.8 | 429 |
| Prob009_div_16bit | ❌ (Func: 0%) | ✅ (Func: 7%) | 0.7812 | `Area: 6390.00, Power: 1.0500, Period: 0.00` | `Area: 1433.00, Power: 0.2240, Period: 0.00` | +77.57% ✅ / +78.67% ✅ / N/A | 1792.1 | 429 |
| Prob010_radix2_div | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 495.00, Power: 0.0487, Period: 0.54` | `N/A` | N/A / N/A / N/A | 1381.4 | 429 |
| Prob011_multi_16bit | ✅ (Func: 80%) | ✅ (Func: 54%) | 0.3567 | `Area: 1064.00, Power: 0.1800, Period: 1.16` | `Area: 864.00, Power: 0.0445, Period: 1.01` | +18.80% ✅ / +75.28% ✅ / +12.93% ✅ | 1719.4 | 429 |
| Prob012_multi_8bit | ✅ (Func: 50%) | ✅ (Func: 57%) | 0.4768 | `Area: 596.00, Power: 0.0886, Period: 0.00` | `Area: 364.00, Power: 0.0386, Period: 0.00` | +38.93% ✅ / +56.43% ✅ / N/A | 1381.6 | 429 |
| Prob013_multi_booth_8bit | ✅ (Func: 40%) | ✅ (Func: 43%) | 0.0000 | `N/A` | `Area: 501.00, Power: 0.0730, Period: 0.66` | N/A / N/A / N/A | 3249.9 | 429 |
| Prob014_multi_pipe_4bit | ✅ (Func: 10%) | ✅ (Func: 23%) | N/A | `Area: 190.00, Power: 0.0198, Period: 0.38` | `N/A` | N/A / N/A / N/A | 1551.7 | 429 |
| Prob015_multi_pipe_8bit | ❌ (Func: 0%) | ✅ (Func: 2%) | -0.6417 | `Area: 980.00, Power: 0.0898, Period: 0.82` | `Area: 963.00, Power: 0.0704, Period: 2.59` | +1.73% ✅ / +21.60% ✅ / -215.85% ❌ | 2422.5 | 429 |
| Prob016_fixed_point_adder | ✅ (Func: 40%) | ✅ (Func: 80%) | N/A | `Area: 981.00, Power: 0.0725, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1489.7 | 429 |
| Prob017_fixed_point_substractor | ✅ (Func: 40%) | ✅ (Func: 72%) | N/A | `Area: 694.00, Power: 0.0524, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1419.9 | 429 |
| Prob018_float_multi | ❌ (Func: 0%) | ✅ (Func: 2%) | 0.0000 | `N/A` | `Area: 4677.00, Power: 0.5860, Period: 1.92` | N/A / N/A / N/A | 2052.1 | 429 |
| Prob019_sub_64bit | ✅ (Func: 80%) | ✅ (Func: 88%) | 0.3237 | `Area: 621.00, Power: 0.0412, Period: 0.00` | `Area: 830.00, Power: 0.0007, Period: 0.00` | -33.66% ❌ / +98.40% ✅ / N/A | 1413.2 | 429 |
| Prob020_JC_counter | ✅ (Func: 90%) | ✅ (Func: 74%) | -0.0000 | `Area: 340.00, Power: 0.0351, Period: 0.13` | `Area: 340.00, Power: 0.0351, Period: 0.13` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1434.9 | 429 |
| Prob021_counter_12 | ✅ (Func: 50%) | ✅ (Func: 78%) | 0.4124 | `Area: 44.00, Power: 0.0096, Period: 0.28` | `Area: 29.00, Power: 0.0020, Period: 0.25` | +34.09% ✅ / +78.92% ✅ / +10.71% ✅ | 1344.6 | 429 |
| Prob022_ring_counter | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 43.00, Power: 0.0055, Period: 0.13` | `N/A` | N/A / N/A / N/A | 1233.9 | 429 |
| Prob023_up_down_counter | ✅ (Func: 100%) | ✅ (Func: 79%) | 0.7337 | `Area: 259.00, Power: 0.0358, Period: 0.54` | `Area: 205.00, Power: 0.0003, Period: 0.00` | +20.85% ✅ / +99.25% ✅ / +100.00% ✅ | 1398.1 | 429 |
| Prob024_fsm | ❌ (Func: 0%) | ✅ (Func: 7%) | 0.4955 | `Area: 46.00, Power: 0.0069, Period: 0.00` | `Area: 30.00, Power: 0.0025, Period: 0.14` | +34.78% ✅ / +64.32% ✅ / N/A | 1329.3 | 429 |
| Prob025_sequence_detector | ❌ (Func: 0%) | ✅ (Func: 10%) | 0.3624 | `Area: 38.00, Power: 0.0039, Period: 0.19` | `Area: 25.00, Power: 0.0020, Period: 0.14` | +34.21% ✅ / +48.20% ✅ / +26.32% ✅ | 1213.8 | 429 |
| Prob026_asyn_fifo | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 1163.00, Power: 0.1420, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1758.6 | 429 |
| Prob027_LIFObuffer | ❌ (Func: 0%) | ✅ (Func: 29%) | 0.2762 | `Area: 299.00, Power: 0.0419, Period: 0.39` | `Area: 260.00, Power: 0.0105, Period: 0.41` | +13.04% ✅ / +74.94% ✅ / -5.13% ❌ | 1463.0 | 429 |
| Prob028_LFSR | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 23.00, Power: 0.0029, Period: 0.18` | `N/A` | N/A / N/A / N/A | 1053.3 | 429 |
| Prob029_barrel_shifter | ❌ (Func: 0%) | ✅ (Func: 15%) | 0.1196 | `Area: 58.00, Power: 0.0027, Period: 0.00` | `Area: 51.00, Power: 0.0024, Period: 0.00` | +12.07% ✅ / +11.85% ✅ / N/A | 1568.1 | 429 |
| Prob030_right_shifter | ✅ (Func: 70%) | ✅ (Func: 82%) | -0.0000 | `Area: 36.00, Power: 0.0037, Period: 0.12` | `Area: 36.00, Power: 0.0037, Period: 0.12` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 1268.6 | 429 |
| Prob031_freq_div | ✅ (Func: 10%) | ✅ (Func: 26%) | 0.1660 | `Area: 125.00, Power: 0.0007, Period: 0.00` | `Area: 101.00, Power: 0.0006, Period: 0.00` | +19.20% ✅ / +14.01% ✅ / N/A | 1481.9 | 429 |
| Prob032_freq_divbyeven | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 43.00, Power: 0.0040, Period: 0.27` | `N/A` | N/A / N/A / N/A | 1033.1 | 429 |
| Prob033_freq_divbyfrac | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 59.00, Power: 0.0061, Period: 0.29` | `N/A` | N/A / N/A / N/A | 1448.1 | 429 |
| Prob034_freq_divbyodd | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 57.00, Power: 0.0058, Period: 0.22` | `N/A` | N/A / N/A / N/A | 1303.6 | 429 |
| Prob035_calendar | ✅ (Func: 100%) | ✅ (Func: 61%) | 0.0426 | `Area: 196.00, Power: 0.0124, Period: 0.38` | `Area: 182.00, Power: 0.0117, Period: 0.38` | +7.14% ✅ / +5.65% ✅ / +0.00% ➖ | 1593.0 | 429 |
| Prob036_edge_detect | ✅ (Func: 70%) | ✅ (Func: 83%) | 0.9649 | `Area: 19.00, Power: 0.0019, Period: 0.17` | `Area: 2.00, Power: 0.0000, Period: 0.00` | +89.47% ✅ / +100.00% ✅ / +100.00% ✅ | 1327.2 | 429 |
| Prob037_parallel2serial | ✅ (Func: 30%) | ✅ (Func: 52%) | 0.4686 | `Area: 50.00, Power: 0.0045, Period: 0.27` | `Area: 23.00, Power: 0.0019, Period: 0.19` | +54.00% ✅ / +56.95% ✅ / +29.63% ✅ | 2110.7 | 429 |
| Prob038_pulse_detect | ❌ (Func: 0%) | ✅ (Func: 5%) | 0.7357 | `Area: 17.00, Power: 0.0014, Period: 0.21` | `Area: 7.00, Power: 0.0005, Period: 0.00` | +58.82% ✅ / +61.88% ✅ / +100.00% ✅ | 1269.8 | 429 |
| Prob039_serial2parallel | ✅ (Func: 20%) | ✅ (Func: 27%) | 0.3472 | `Area: 168.00, Power: 0.0238, Period: 0.30` | `Area: 110.00, Power: 0.0104, Period: 0.26` | +34.52% ✅ / +56.30% ✅ / +13.33% ✅ | 4569.5 | 429 |
| Prob040_synchronizer | ✅ (Func: 80%) | ✅ (Func: 87%) | 0.0000 | `N/A` | `Area: 63.00, Power: 0.0017, Period: 0.00` | N/A / N/A / N/A | 1458.4 | 429 |
| Prob041_traffic_light | ❌ (Func: 0%) | ✅ (Func: 40%) | 0.6225 | `Area: 170.00, Power: 0.0324, Period: 0.00` | `Area: 127.00, Power: 0.0003, Period: 0.00` | +25.29% ✅ / +99.21% ✅ / N/A | 1620.1 | 429 |
| Prob042_width_8to16 | ✅ (Func: 40%) | ✅ (Func: 36%) | N/A | `Area: 196.00, Power: 0.0517, Period: 0.26` | `N/A` | N/A / N/A / N/A | 1280.9 | 429 |
| Prob043_RAM | ✅ (Func: 100%) | ✅ (Func: 71%) | 0.7484 | `Area: 734.00, Power: 0.1090, Period: 0.31` | `Area: 426.00, Power: 0.0190, Period: 0.00` | +41.96% ✅ / +82.57% ✅ / +100.00% ✅ | 1432.7 | 429 |
| Prob044_ROM | ✅ (Func: 60%) | ✅ (Func: 72%) | -0.0000 | `Area: 14.00, Power: 0.0002, Period: 0.00` | `Area: 14.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 1269.3 | 429 |
| Prob045_alu | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 2225.00, Power: 0.1140, Period: 0.00` | `N/A` | N/A / N/A / N/A | 2195.8 | 429 |
| Prob046_clkgenerator | ❌ (Func: 0%) | ✅ (Func: 12%) | N/A | `Area: 1.00, Power: 0.0000, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1646.4 | 429 |
| Prob047_instr_reg | ✅ (Func: 50%) | ✅ (Func: 67%) | 0.7332 | `Area: 119.00, Power: 0.0129, Period: 0.18` | `Area: 77.00, Power: 0.0020, Period: 0.00` | +35.29% ✅ / +84.65% ✅ / +100.00% ✅ | 1339.0 | 429 |
| Prob048_pe | ✅ (Func: 90%) | ✅ (Func: 60%) | 0.3535 | `Area: 3451.00, Power: 0.4510, Period: 1.57` | `Area: 2013.00, Power: 0.2640, Period: 1.21` | +41.67% ✅ / +41.46% ✅ / +22.93% ✅ | 1706.0 | 429 |
| Prob049_signal_generator | ❌ (Func: 0%) | ✅ (Func: 54%) | 0.2855 | `Area: 94.00, Power: 0.0047, Period: 0.43` | `Area: 83.00, Power: 0.0025, Period: 0.31` | +11.70% ✅ / +46.04% ✅ / +27.91% ✅ | 1276.4 | 429 |
| Prob050_square_wave | ✅ (Func: 80%) | ✅ (Func: 92%) | 0.9972 | `Area: 119.00, Power: 0.0247, Period: 0.38` | `Area: 1.00, Power: 0.0000, Period: 0.00` | +99.16% ✅ / +100.00% ✅ / +100.00% ✅ | 1313.1 | 429 |