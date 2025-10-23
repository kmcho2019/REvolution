# 🧬 BENCHMARK EVOLUTION REPORT: RTLLM

## 📈 Summary
- **Total Problems Analyzed:** 50
- **Average Runtime per Problem:** 1165.04s
- **Average LLM API Calls per Problem:** 420.0

### ✅ Pass Rate Analysis
| Metric | Initial Any Passing Gen | Any Passing Gen | Initial Pass@1 | Final Pass@1 | Change |
|:---|:---|:---|:---|:---|:---|
| **Syntax** | 84.0% (42/50) | 94.0% (47/50) | 78.8% | 82.6% | **+3.8%** |
| **Functionality** | 70.0% (35/50) | 86.0% (43/50) | 53.6% | 55.9% | **+2.3%** |
| **Synthesis** | 58.0% (29/50) | 72.0% (36/50) | 44.2% | 48.1% | **+3.9%** |

### ⚡ PPA Optimization Summary
- **Problems with PPA Improvement (Best Solution Compared to Reference):** 30 / 50 (60.0%)

| PPA Metric | Average Improvement |
|:-----------|:--------------------|
| **Area** | +26.37% |
| **Power** | +42.86% |
| **Performance (Period)** | +20.29% |

## 🧬 Strategy Analysis
Shows how often each strategy was used and its success rate (rewarded).
| Strategy | Times Used | Success Count | Success Rate |
|:---------|:-----------|:--------------|:-------------|
| `M-S` | 2035 (19.4%) | 66 | 3.2% |
| `M-E` | 2025 (19.3%) | 68 | 3.4% |
| `M-R` | 2025 (19.3%) | 67 | 3.3% |
| `M-I` | 1989 (18.9%) | 65 | 3.3% |
| `C-F` | 1231 (11.7%) | 36 | 2.9% |
| `M-F` | 695 (6.6%) | 31 | 4.5% |
| `initial` | 500 (4.8%) | 0 | 0.0% |

## 📋 Detailed Problem-by-Problem Analysis
| Problem | Initial Status | Final Status | Best Score | Reference PPA | Best Evo. PPA | PPA % Improv. (A/P/T) | Runtime (s) | API Calls |
|:---|:---|:---|:---:|:---|:---|:---|:---:|:---:|
| Prob001_accu | ✅ (Func: 100%) | ✅ (Func: 70%) | 0.0758 | `Area: 191.00, Power: 0.0468, Period: 0.58` | `Area: 251.00, Power: 0.0271, Period: 0.51` | -31.41% ❌ / +42.09% ✅ / +12.07% ✅ | 714.0 | 420 |
| Prob002_adder_16bit | ✅ (Func: 90%) | ✅ (Func: 95%) | 0.5999 | `Area: 92.00, Power: 0.0063, Period: 0.00` | `Area: 73.00, Power: 0.0000, Period: 0.00` | +20.65% ✅ / +99.32% ✅ / N/A | 1042.8 | 420 |
| Prob003_adder_32bit | ✅ (Func: 80%) | ✅ (Func: 79%) | 0.8368 | `Area: 423.00, Power: 0.0324, Period: 0.00` | `Area: 137.00, Power: 0.0001, Period: 0.00` | +67.61% ✅ / +99.75% ✅ / N/A | 1787.8 | 420 |
| Prob004_adder_8bit | ✅ (Func: 10%) | ✅ (Func: 75%) | 0.5723 | `Area: 46.00, Power: 0.0030, Period: 0.00` | `Area: 39.00, Power: 0.0000, Period: 0.00` | +15.22% ✅ / +99.25% ✅ / N/A | 923.1 | 420 |
| Prob005_adder_bcd | ✅ (Func: 100%) | ✅ (Func: 82%) | 0.1552 | `Area: 45.00, Power: 0.0045, Period: 0.00` | `Area: 36.00, Power: 0.0040, Period: 0.00` | +20.00% ✅ / +11.04% ✅ / N/A | 799.2 | 420 |
| Prob006_adder_pipe_64bit | ❌ (Func: 0%) | ✅ (Func: 8%) | N/A | `N/A` | `N/A` | N/A / N/A / N/A | 1199.4 | 420 |
| Prob007_comparator_3bit | ✅ (Func: 100%) | ✅ (Func: 99%) | 0.1171 | `Area: 17.00, Power: 0.0010, Period: 0.00` | `Area: 16.00, Power: 0.0008, Period: 0.00` | +5.88% ✅ / +17.53% ✅ / N/A | 617.3 | 420 |
| Prob008_comparator_4bit | ✅ (Func: 80%) | ✅ (Func: 94%) | 0.4168 | `Area: 33.00, Power: 0.0020, Period: 0.00` | `Area: 21.00, Power: 0.0011, Period: 0.00` | +36.36% ✅ / +47.00% ✅ / N/A | 764.0 | 420 |
| Prob009_div_16bit | ❌ (Func: 0%) | ✅ (Func: 50%) | 0.7846 | `Area: 6390.00, Power: 1.0500, Period: 0.00` | `Area: 1408.00, Power: 0.2210, Period: 0.00` | +77.97% ✅ / +78.95% ✅ / N/A | 987.4 | 420 |
| Prob010_radix2_div | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 495.00, Power: 0.0487, Period: 0.54` | `N/A` | N/A / N/A / N/A | 1636.0 | 420 |
| Prob011_multi_16bit | ✅ (Func: 80%) | ✅ (Func: 60%) | 0.4191 | `Area: 1064.00, Power: 0.1800, Period: 1.16` | `Area: 555.00, Power: 0.1360, Period: 0.54` | +47.84% ✅ / +24.44% ✅ / +53.45% ✅ | 1165.1 | 420 |
| Prob012_multi_8bit | ✅ (Func: 100%) | ✅ (Func: 77%) | 0.4487 | `Area: 596.00, Power: 0.0886, Period: 0.00` | `Area: 384.00, Power: 0.0406, Period: 0.00` | +35.57% ✅ / +54.18% ✅ / N/A | 830.1 | 420 |
| Prob013_multi_booth_8bit | ✅ (Func: 80%) | ✅ (Func: 34%) | 0.0000 | `N/A` | `Area: 837.00, Power: 0.0674, Period: 0.69` | N/A / N/A / N/A | 1449.9 | 420 |
| Prob014_multi_pipe_4bit | ✅ (Func: 100%) | ✅ (Func: 67%) | N/A | `Area: 190.00, Power: 0.0198, Period: 0.38` | `N/A` | N/A / N/A / N/A | 988.6 | 420 |
| Prob015_multi_pipe_8bit | ✅ (Func: 60%) | ✅ (Func: 63%) | 0.0379 | `Area: 980.00, Power: 0.0898, Period: 0.82` | `Area: 649.00, Power: 0.0913, Period: 0.99` | +33.78% ✅ / -1.67% ❌ / -20.73% ❌ | 1358.6 | 420 |
| Prob016_fixed_point_adder | ✅ (Func: 80%) | ✅ (Func: 96%) | N/A | `Area: 981.00, Power: 0.0725, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1015.5 | 420 |
| Prob017_fixed_point_substractor | ✅ (Func: 80%) | ✅ (Func: 91%) | N/A | `Area: 694.00, Power: 0.0524, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1350.4 | 420 |
| Prob018_float_multi | ✅ (Func: 10%) | ✅ (Func: 35%) | 0.0000 | `N/A` | `Area: 5454.00, Power: 0.6190, Period: 1.11` | N/A / N/A / N/A | 2302.8 | 420 |
| Prob019_sub_64bit | ✅ (Func: 100%) | ✅ (Func: 88%) | 0.4512 | `Area: 621.00, Power: 0.0412, Period: 0.00` | `Area: 341.00, Power: 0.0226, Period: 0.00` | +45.09% ✅ / +45.15% ✅ / N/A | 1347.2 | 420 |
| Prob020_JC_counter | ✅ (Func: 100%) | ✅ (Func: 81%) | -0.0000 | `Area: 340.00, Power: 0.0351, Period: 0.13` | `Area: 340.00, Power: 0.0351, Period: 0.13` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 583.8 | 420 |
| Prob021_counter_12 | ✅ (Func: 100%) | ✅ (Func: 97%) | 0.3306 | `Area: 44.00, Power: 0.0096, Period: 0.28` | `Area: 35.00, Power: 0.0021, Period: 0.28` | +20.45% ✅ / +78.71% ✅ / +0.00% ➖ | 641.2 | 420 |
| Prob022_ring_counter | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 43.00, Power: 0.0055, Period: 0.13` | `N/A` | N/A / N/A / N/A | 424.7 | 420 |
| Prob023_up_down_counter | ✅ (Func: 100%) | ✅ (Func: 94%) | 0.0993 | `Area: 259.00, Power: 0.0358, Period: 0.54` | `Area: 230.00, Power: 0.0318, Period: 0.50` | +11.20% ✅ / +11.17% ✅ / +7.41% ✅ | 631.6 | 420 |
| Prob024_fsm | ✅ (Func: 70%) | ✅ (Func: 60%) | 0.5101 | `Area: 46.00, Power: 0.0069, Period: 0.00` | `Area: 27.00, Power: 0.0027, Period: 0.17` | +41.30% ✅ / +60.72% ✅ / N/A | 838.6 | 420 |
| Prob025_sequence_detector | ❌ (Func: 0%) | ✅ (Func: 10%) | 0.2524 | `Area: 38.00, Power: 0.0039, Period: 0.19` | `Area: 26.00, Power: 0.0028, Period: 0.16` | +31.58% ✅ / +28.35% ✅ / +15.79% ✅ | 693.7 | 420 |
| Prob026_asyn_fifo | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 1163.00, Power: 0.1420, Period: 0.00` | `N/A` | N/A / N/A / N/A | 1378.5 | 420 |
| Prob027_LIFObuffer | ✅ (Func: 40%) | ✅ (Func: 83%) | 0.2656 | `Area: 299.00, Power: 0.0419, Period: 0.39` | `Area: 234.00, Power: 0.0230, Period: 0.34` | +21.74% ✅ / +45.11% ✅ / +12.82% ✅ | 941.7 | 420 |
| Prob028_LFSR | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 23.00, Power: 0.0029, Period: 0.18` | `N/A` | N/A / N/A / N/A | 648.6 | 420 |
| Prob029_barrel_shifter | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 58.00, Power: 0.0027, Period: 0.00` | `N/A` | N/A / N/A / N/A | 708.0 | 420 |
| Prob030_right_shifter | ✅ (Func: 100%) | ✅ (Func: 92%) | -0.0000 | `Area: 36.00, Power: 0.0037, Period: 0.12` | `Area: 36.00, Power: 0.0037, Period: 0.12` | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | 516.7 | 420 |
| Prob031_freq_div | ✅ (Func: 100%) | ✅ (Func: 72%) | 0.1340 | `Area: 125.00, Power: 0.0007, Period: 0.00` | `Area: 109.00, Power: 0.0006, Period: 0.00` | +12.80% ✅ / +14.01% ✅ / N/A | 834.8 | 420 |
| Prob032_freq_divbyeven | ❌ (Func: 0%) | ✅ (Func: 1%) | N/A | `Area: 43.00, Power: 0.0040, Period: 0.27` | `N/A` | N/A / N/A / N/A | 504.7 | 420 |
| Prob033_freq_divbyfrac | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 59.00, Power: 0.0061, Period: 0.29` | `N/A` | N/A / N/A / N/A | 840.9 | 420 |
| Prob034_freq_divbyodd | ❌ (Func: 0%) | ✅ (Func: 7%) | 0.0680 | `Area: 57.00, Power: 0.0058, Period: 0.22` | `Area: 53.00, Power: 0.0040, Period: 0.26` | +7.02% ✅ / +31.55% ✅ / -18.18% ❌ | 706.8 | 420 |
| Prob035_calendar | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.0319 | `Area: 196.00, Power: 0.0124, Period: 0.38` | `Area: 178.00, Power: 0.0117, Period: 0.40` | +9.18% ✅ / +5.65% ✅ / -5.26% ❌ | 824.6 | 420 |
| Prob036_edge_detect | ✅ (Func: 80%) | ✅ (Func: 89%) | 0.7526 | `Area: 19.00, Power: 0.0019, Period: 0.17` | `Area: 8.00, Power: 0.0006, Period: 0.00` | +57.89% ✅ / +67.88% ✅ / +100.00% ✅ | 655.7 | 420 |
| Prob037_parallel2serial | ✅ (Func: 10%) | ✅ (Func: 51%) | 0.4098 | `Area: 50.00, Power: 0.0045, Period: 0.27` | `Area: 26.00, Power: 0.0023, Period: 0.20` | +48.00% ✅ / +49.01% ✅ / +25.93% ✅ | 743.8 | 420 |
| Prob038_pulse_detect | ❌ (Func: 0%) | ✅ (Func: 9%) | 0.7357 | `Area: 17.00, Power: 0.0014, Period: 0.21` | `Area: 7.00, Power: 0.0005, Period: 0.00` | +58.82% ✅ / +61.88% ✅ / +100.00% ✅ | 601.0 | 420 |
| Prob039_serial2parallel | ❌ (Func: 0%) | ❌ (Func: 0%) | N/A | `Area: 168.00, Power: 0.0238, Period: 0.30` | `N/A` | N/A / N/A / N/A | 12798.6 | 420 |
| Prob040_synchronizer | ✅ (Func: 100%) | ✅ (Func: 89%) | 0.0000 | `N/A` | `Area: 79.00, Power: 0.0024, Period: 0.00` | N/A / N/A / N/A | 854.8 | 420 |
| Prob041_traffic_light | ✅ (Func: 10%) | ✅ (Func: 56%) | 0.6405 | `Area: 170.00, Power: 0.0324, Period: 0.00` | `Area: 120.00, Power: 0.0004, Period: 0.00` | +29.41% ✅ / +98.69% ✅ / N/A | 1057.1 | 420 |
| Prob042_width_8to16 | ✅ (Func: 60%) | ✅ (Func: 27%) | N/A | `Area: 196.00, Power: 0.0517, Period: 0.26` | `N/A` | N/A / N/A / N/A | 767.3 | 420 |
| Prob043_RAM | ✅ (Func: 100%) | ✅ (Func: 85%) | 0.4445 | `Area: 734.00, Power: 0.1090, Period: 0.31` | `Area: 481.00, Power: 0.0399, Period: 0.20` | +34.47% ✅ / +63.39% ✅ / +35.48% ✅ | 834.5 | 420 |
| Prob044_ROM | ✅ (Func: 80%) | ✅ (Func: 81%) | -0.0000 | `Area: 14.00, Power: 0.0002, Period: 0.00` | `Area: 14.00, Power: 0.0002, Period: 0.00` | +0.00% ➖ / +0.00% ➖ / N/A | 558.3 | 420 |
| Prob045_alu | ✅ (Func: 10%) | ✅ (Func: 50%) | 0.2271 | `Area: 2225.00, Power: 0.1140, Period: 0.00` | `Area: 1708.00, Power: 0.0887, Period: 0.00` | +23.24% ✅ / +22.19% ✅ / N/A | 1942.5 | 420 |
| Prob046_clkgenerator | ❌ (Func: 0%) | ✅ (Func: 15%) | N/A | `Area: 1.00, Power: 0.0000, Period: 0.00` | `N/A` | N/A / N/A / N/A | 588.2 | 420 |
| Prob047_instr_reg | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.3093 | `Area: 119.00, Power: 0.0129, Period: 0.18` | `Area: 68.00, Power: 0.0065, Period: 0.18` | +42.86% ✅ / +49.92% ✅ / +0.00% ➖ | 668.3 | 420 |
| Prob048_pe | ✅ (Func: 70%) | ✅ (Func: 61%) | 0.1453 | `Area: 3451.00, Power: 0.4510, Period: 1.57` | `Area: 3546.00, Power: 0.4890, Period: 0.71` | -2.75% ❌ / -8.43% ❌ / +54.78% ✅ | 910.2 | 420 |
| Prob049_signal_generator | ❌ (Func: 0%) | ✅ (Func: 33%) | 0.2589 | `Area: 94.00, Power: 0.0047, Period: 0.43` | `Area: 73.00, Power: 0.0025, Period: 0.39` | +22.34% ✅ / +46.04% ✅ / +9.30% ✅ | 583.6 | 420 |
| Prob050_square_wave | ✅ (Func: 100%) | ✅ (Func: 98%) | 0.3342 | `Area: 119.00, Power: 0.0247, Period: 0.38` | `Area: 88.00, Power: 0.0070, Period: 0.37` | +26.05% ✅ / +71.58% ✅ / +2.63% ✅ | 690.0 | 420 |