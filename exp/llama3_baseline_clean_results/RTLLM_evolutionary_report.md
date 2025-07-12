# 🧬 BENCHMARK EVOLUTION REPORT: RTLLM

## 📈 Summary
- **Total Problems Analyzed:** 50
- **Average Runtime per Problem:** 386.09s
- **Average LLM API Calls per Problem:** 598.7

### ✅ Pass Rate Analysis
| Metric | Initial Any Passing Gen | Any Passing Gen | Initial Pass@1 | Final Pass@1 | Change |
|:---|:---|:---|:---|:---|:---|
| **Syntax** | 86.0% (43/50) | 86.0% (43/50) | 55.7% | 55.7% | **+0.0%** |
| **Functionality** | 70.0% (35/50) | 70.0% (35/50) | 31.2% | 31.2% | **+0.0%** |
| **Synthesis** | 58.0% (29/50) | 58.0% (29/50) | 26.6% | 26.6% | **+0.0%** |

### ⚡ PPA Optimization Summary
- **Problems with PPA Improvement (Best Solution Compared to Reference):** 22 / 50 (44.0%)

| PPA Metric | Average Improvement |
|:-----------|:--------------------|
| **Area** | +13.38% |
| **Power** | +31.11% |
| **Performance (Period)** | +9.11% |

## 🧬 Strategy Analysis
Shows how often each strategy was used and its success rate (rewarded).
| Strategy | Times Used | Success Count | Success Rate |
|:---------|:-----------|:--------------|:-------------|
| `initial` | 9986 (100.0%) | 0 | 0.0% |

## 📋 Detailed Problem-by-Problem Analysis
| Problem | Initial Status | Final Status | Best Score | Reference PPA | Best Evo. PPA | PPA % Improv. (A/P/T) | Runtime (s) | API Calls |
|:---|:---|:---|:---:|:---|:---|:---|:---:|:---:|
| Prob001_accu | ✅ (Func: 12%) | ✅ (Func: 12%) | 0.0880 | `Area: 191.00, Power: 0.0468, Period: 0.58` | `Area: 178.00, Power: 0.0344, Period: 0.62` | +6.81% ✅ / +26.50% ✅ / -6.90% ❌ | 218.4 | 596 |
| Prob002_adder_16bit | ✅ (Func: 51%) | ✅ (Func: 51%) | 0.5999 | `Area: 92.00, Power: 0.0063, Period: 0.00` | `Area: 73.00, Power: 0.0000, Period: 0.00` | +20.65% ✅ / +99.32% ✅ / N/A | 282.4 | 598 |
| Prob003_adder_32bit | ✅ (Func: 10%) | ✅ (Func: 10%) | 0.8368 | `Area: 423.00, Power: 0.0324, Period: 0.00` | `Area: 137.00, Power: 0.0001, Period: 0.00` | +67.61% ✅ / +99.75% ✅ / N/A | 406.8 | 598 |
| Prob004_adder_8bit | ✅ (Func: 1%) | ✅ (Func: 1%) | 0.2106 | `Area: 46.00, Power: 0.0030, Period: 0.00` | `Area: 39.00, Power: 0.0022, Period: 0.00` | +15.22% ✅ / +26.91% ✅ / N/A | 125.9 | 598 |
| Prob005_adder_bcd | ✅ (Func: 34%) | ✅ (Func: 34%) | 0.0011 | `Area: 45.00, Power: 0.0045, Period: 0.00` | `Area: 45.00, Power: 0.0045, Period: 0.00` | +0.00% ➖ / +0.22% ✅ / N/A | 171.4 | 599 |
| Prob006_adder_pipe_64bit | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `N/A` | `N/A` | N/A / N/A / N/A | 365.9 | 599 |
| Prob007_comparator_3bit | ✅ (Func: 67%) | ✅ (Func: 67%) | -0.0000 | `Area: 17.00, Power: 0.0010, Period: 0.00` | `Area: 17.00, Power: 0.0010, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 294.7 | 599 |
| Prob008_comparator_4bit | ✅ (Func: 39%) | ✅ (Func: 39%) | 0.3667 | `Area: 33.00, Power: 0.0020, Period: 0.00` | `Area: 22.00, Power: 0.0012, Period: 0.00` | +33.33% ✅ / +40.00% ✅ / N/A | 1021.0 | 599 |
| Prob009_div_16bit | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 6390.00, Power: 1.0500, Period: 0.00` | `N/A` | N/A / N/A / N/A | 210.5 | 599 |
| Prob010_radix2_div | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 495.00, Power: 0.0487, Period: 0.54` | `N/A` | N/A / N/A / N/A | 169.0 | 599 |
| Prob011_multi_16bit | ✅ (Func: 48%) | ✅ (Func: 48%) | 0.1569 | `Area: 1064.00, Power: 0.1800, Period: 1.16` | `Area: 1130.00, Power: 0.0981, Period: 1.07` | -6.20% ❌ / +45.50% ✅ / +7.76% ✅ | 350.0 | 599 |
| Prob012_multi_8bit | ✅ (Func: 30%) | ✅ (Func: 30%) | 0.4768 | `Area: 596.00, Power: 0.0886, Period: 0.00` | `Area: 364.00, Power: 0.0386, Period: 0.00` | +38.93% ✅ / +56.43% ✅ / N/A | 173.0 | 599 |
| Prob013_multi_booth_8bit | ✅ (Func: 46%) | ✅ (Func: 46%) | N/A | `N/A` | `N/A` | N/A / N/A / N/A | 2868.6 | 599 |
| Prob014_multi_pipe_4bit | ✅ (Func: 6%) | ✅ (Func: 6%) | N/A | `Area: 190.00, Power: 0.0198, Period: 0.38` | `N/A` | N/A / N/A / N/A | 157.9 | 599 |
| Prob015_multi_pipe_8bit | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 980.00, Power: 0.0898, Period: 0.82` | `N/A` | N/A / N/A / N/A | 922.1 | 598 |
| Prob016_fixed_point_adder | ✅ (Func: 46%) | ✅ (Func: 46%) | N/A | `Area: 981.00, Power: 0.0725, Period: 0.00` | `N/A` | N/A / N/A / N/A | 222.7 | 599 |
| Prob017_fixed_point_substractor | ✅ (Func: 36%) | ✅ (Func: 36%) | N/A | `Area: 694.00, Power: 0.0524, Period: 0.00` | `N/A` | N/A / N/A / N/A | 251.1 | 599 |
| Prob018_float_multi | ✅ (Func: 0%) | ✅ (Func: 0%) | N/A | `N/A` | `N/A` | N/A / N/A / N/A | 291.8 | 599 |
| Prob019_sub_64bit | ✅ (Func: 88%) | ✅ (Func: 88%) | 0.0020 | `Area: 621.00, Power: 0.0412, Period: 0.00` | `Area: 620.00, Power: 0.0411, Period: 0.00` | +0.16% ✅ / +0.24% ✅ / N/A | 314.9 | 599 |
| Prob020_JC_counter | ✅ (Func: 83%) | ✅ (Func: 83%) | -0.0000 | `Area: 340.00, Power: 0.0351, Period: 0.13` | `Area: 340.00, Power: 0.0351, Period: 0.13` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 213.3 | 599 |
| Prob021_counter_12 | ✅ (Func: 78%) | ✅ (Func: 78%) | 0.1490 | `Area: 44.00, Power: 0.0096, Period: 0.28` | `Area: 46.00, Power: 0.0042, Period: 0.30` | -4.55% ❌ / +56.39% ✅ / -7.14% ❌ | 220.3 | 599 |
| Prob022_ring_counter | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 43.00, Power: 0.0055, Period: 0.13` | `N/A` | N/A / N/A / N/A | 126.9 | 599 |
| Prob023_up_down_counter | ✅ (Func: 94%) | ✅ (Func: 94%) | 0.1538 | `Area: 259.00, Power: 0.0358, Period: 0.54` | `Area: 212.00, Power: 0.0271, Period: 0.52` | +18.15% ✅ / +24.30% ✅ / +3.70% ✅ | 245.3 | 599 |
| Prob024_fsm | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 46.00, Power: 0.0069, Period: 0.00` | `N/A` | N/A / N/A / N/A | 132.2 | 598 |
| Prob025_sequence_detector | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 38.00, Power: 0.0039, Period: 0.19` | `N/A` | N/A / N/A / N/A | 148.7 | 598 |
| Prob026_asyn_fifo | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 1163.00, Power: 0.1420, Period: 0.00` | `N/A` | N/A / N/A / N/A | 224.2 | 597 |
| Prob027_LIFObuffer | ✅ (Func: 3%) | ✅ (Func: 3%) | 0.1925 | `Area: 299.00, Power: 0.0419, Period: 0.39` | `Area: 251.00, Power: 0.0255, Period: 0.38` | +16.05% ✅ / +39.14% ✅ / +2.56% ✅ | 177.0 | 599 |
| Prob028_LFSR | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 23.00, Power: 0.0029, Period: 0.18` | `N/A` | N/A / N/A / N/A | 100.5 | 598 |
| Prob029_barrel_shifter | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 58.00, Power: 0.0027, Period: 0.00` | `N/A` | N/A / N/A / N/A | 225.9 | 598 |
| Prob030_right_shifter | ✅ (Func: 32%) | ✅ (Func: 32%) | -0.0000 | `Area: 36.00, Power: 0.0037, Period: 0.12` | `Area: 36.00, Power: 0.0037, Period: 0.12` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 153.7 | 599 |
| Prob031_freq_div | ✅ (Func: 10%) | ✅ (Func: 10%) | 0.1720 | `Area: 125.00, Power: 0.0007, Period: 0.00` | `Area: 109.00, Power: 0.0005, Period: 0.00` | +12.80% ✅ / +21.61% ✅ / N/A | 199.2 | 599 |
| Prob032_freq_divbyeven | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 43.00, Power: 0.0040, Period: 0.27` | `N/A` | N/A / N/A / N/A | 89.0 | 599 |
| Prob033_freq_divbyfrac | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 59.00, Power: 0.0061, Period: 0.29` | `N/A` | N/A / N/A / N/A | 179.0 | 599 |
| Prob034_freq_divbyodd | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 57.00, Power: 0.0058, Period: 0.22` | `N/A` | N/A / N/A / N/A | 315.6 | 599 |
| Prob035_calendar | ✅ (Func: 92%) | ✅ (Func: 92%) | 0.0256 | `Area: 196.00, Power: 0.0124, Period: 0.38` | `Area: 192.00, Power: 0.0117, Period: 0.38` | +2.04% ✅ / +5.65% ✅ / +0.00% ➖ | 254.3 | 599 |
| Prob036_edge_detect | ✅ (Func: 78%) | ✅ (Func: 78%) | 0.7342 | `Area: 19.00, Power: 0.0019, Period: 0.17` | `Area: 9.00, Power: 0.0006, Period: 0.00` | +52.63% ✅ / +67.62% ✅ / +100.00% ✅ | 260.3 | 599 |
| Prob037_parallel2serial | ✅ (Func: 56%) | ✅ (Func: 56%) | 0.0846 | `Area: 50.00, Power: 0.0045, Period: 0.27` | `Area: 47.00, Power: 0.0038, Period: 0.26` | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ | 323.7 | 599 |
| Prob038_pulse_detect | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 17.00, Power: 0.0014, Period: 0.21` | `N/A` | N/A / N/A / N/A | 83.8 | 599 |
| Prob039_serial2parallel | ✅ (Func: 11%) | ✅ (Func: 11%) | 0.3472 | `Area: 168.00, Power: 0.0238, Period: 0.30` | `Area: 110.00, Power: 0.0104, Period: 0.26` | +34.52% ✅ / +56.30% ✅ / +13.33% ✅ | 4416.6 | 598 |
| Prob040_synchronizer | ✅ (Func: 62%) | ✅ (Func: 62%) | 0.0000 | `N/A` | `Area: 68.00, Power: 0.0018, Period: 0.00` | N/A / N/A / N/A | 210.6 | 599 |
| Prob041_traffic_light | ✅ (Func: 1%) | ✅ (Func: 1%) | 0.4956 | `Area: 170.00, Power: 0.0324, Period: 0.00` | `Area: 159.00, Power: 0.0024, Period: 0.00` | +6.47% ✅ / +92.65% ✅ / N/A | 167.5 | 599 |
| Prob042_width_8to16 | ✅ (Func: 68%) | ✅ (Func: 68%) | N/A | `Area: 196.00, Power: 0.0517, Period: 0.26` | `N/A` | N/A / N/A / N/A | 200.4 | 599 |
| Prob043_RAM | ✅ (Func: 90%) | ✅ (Func: 90%) | 0.2366 | `Area: 734.00, Power: 0.1090, Period: 0.31` | `Area: 506.00, Power: 0.0690, Period: 0.30` | +31.06% ✅ / +36.70% ✅ / +3.23% ✅ | 291.5 | 599 |
| Prob044_ROM | ✅ (Func: 36%) | ✅ (Func: 36%) | -0.0000 | `Area: 14.00, Power: 0.0002, Period: 0.00` | `Area: 14.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 118.4 | 599 |
| Prob045_alu | ✅ (Func: 0%) | ✅ (Func: 0%) | 0.1576 | `Area: 2225.00, Power: 0.1140, Period: 0.00` | `Area: 1832.00, Power: 0.0982, Period: 0.00` | +17.66% ✅ / +13.86% ✅ / N/A | 261.0 | 599 |
| Prob046_clkgenerator | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 1.00, Power: 0.0000, Period: 0.00` | `N/A` | N/A / N/A / N/A | 74.6 | 599 |
| Prob047_instr_reg | ✅ (Func: 78%) | ✅ (Func: 78%) | -0.0000 | `Area: 119.00, Power: 0.0129, Period: 0.18` | `Area: 119.00, Power: 0.0129, Period: 0.18` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 244.2 | 599 |
| Prob048_pe | ✅ (Func: 68%) | ✅ (Func: 68%) | 0.0008 | `Area: 3451.00, Power: 0.4510, Period: 1.57` | `Area: 3450.00, Power: 0.4500, Period: 1.57` | +0.03% ✅ / +0.22% ✅ / +0.00% ➖ | 495.2 | 599 |
| Prob049_signal_generator | ✅ (Func: 10%) | ✅ (Func: 10%) | 0.2565 | `Area: 94.00, Power: 0.0047, Period: 0.43` | `Area: 89.00, Power: 0.0025, Period: 0.32` | +5.32% ✅ / +46.04% ✅ / +25.58% ✅ | 137.4 | 599 |
| Prob050_square_wave | ✅ (Func: 91%) | ✅ (Func: 91%) | -0.0000 | `Area: 119.00, Power: 0.0247, Period: 0.38` | `Area: 119.00, Power: 0.0247, Period: 0.38` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 195.8 | 599 |