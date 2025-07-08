# 📊 BENCHMARK REPORT: RTLLM

## 📈 Overall Summary
- **Total Problems Analyzed:** 50
- **Generations per Problem:** 1

### Pass@1 Rates (Average success rate across all problems)
- **Syntax Pass@1 Rate:** 50.00%
- **Functionality Pass@1 Rate:** 34.00%
- **Synthesis Pass@1 Rate:** 34.00%

### Problems with at Least One Passing Generation
- **Syntax:** 50.00% (25/50)
- **Functionality:** 34.00% (17/50)
- **Synthesis:** 34.00% (17/50)

## 📋 Detailed Problem Results
| Problem | Syntax | Functionality | Synthesis | Best Score | Best PPA Metrics | Reference PPA Metrics |
|:---|:---|:---|:---|:---|:---|:---|
| Prob001_accu | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.1152 | `Area: 245.0, Power: 0.057, Eff_clk_period: 0.49, Wns: -0.48, Tns: -9.01` | `Area: 191.0, Power: 0.0468, Eff_clk_period: 0.58, Wns: -0.57, Tns: -5.02` |
| Prob002_adder_16bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 0.2314 | `Area: 63.0, Power: 0.0039, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` | `Area: 92.0, Power: 0.00628, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob003_adder_32bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 0.3833 | `Area: 182.0, Power: 0.0136, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` | `Area: 423.0, Power: 0.0324, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob004_adder_8bit | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 46.0, Power: 0.00301, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob005_adder_bcd | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 45.0, Power: 0.00453, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob006_adder_pipe_64bit | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 2607.0, Power: 0.291, Eff_clk_period: 0.59, Wns: -0.58, Tns: -50.66` |
| Prob007_comparator_3bit | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 17.0, Power: 0.000981, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob008_comparator_4bit | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 33.0, Power: 0.002, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob009_div_16bit | ✅ Pass (100.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 6390.0, Power: 1.05, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob010_radix2_div | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 495.0, Power: 0.0487, Eff_clk_period: 0.54, Wns: -0.53, Tns: -11.7` |
| Prob011_multi_16bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 0.1246 | `Area: 1137.0, Power: 0.105, Eff_clk_period: 1.1300000000000001, Wns: -1.12, Tns: -43.73` | `Area: 1064.0, Power: 0.18, Eff_clk_period: 1.16, Wns: -1.15, Tns: -44.96` |
| Prob012_multi_8bit | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 596.0, Power: 0.0886, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob013_multi_booth_8bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 0.0010 | `Area: 341.0, Power: 0.0535, Eff_clk_period: 0.6, Wns: -0.59, Tns: -9.71` | `Area: 342.0, Power: 0.0535, Eff_clk_period: 0.6, Wns: -0.59, Tns: -9.78` |
| Prob014_multi_pipe_4bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.0000 | `Area: 190.0, Power: 0.0198, Eff_clk_period: 0.38, Wns: -0.37, Tns: -2.14` | `Area: 190.0, Power: 0.0198, Eff_clk_period: 0.38, Wns: -0.37, Tns: -2.14` |
| Prob015_multi_pipe_8bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.2236 | `Area: 1062.0, Power: 0.171, Eff_clk_period: 0.56, Wns: -0.55, Tns: -33.36` | `Area: 980.0, Power: 0.0898, Eff_clk_period: 0.8200000000000001, Wns: -0.81, Tns: -30.15` |
| Prob016_fixed_point_adder | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 981.0, Power: 0.0725, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob017_fixed_point_substractor | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 694.0, Power: 0.0524, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob018_float_multi | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 1000000.0, Power: 1.0, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob019_sub_64bit | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 621.0, Power: 0.0412, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob020_JC_counter | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.0000 | `Area: 340.0, Power: 0.0351, Eff_clk_period: 0.13, Wns: -0.12, Tns: -7.7` | `Area: 340.0, Power: 0.0351, Eff_clk_period: 0.13, Wns: -0.12, Tns: -7.7` |
| Prob021_counter_12 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.0000 | `Area: 44.0, Power: 0.00963, Eff_clk_period: 0.28, Wns: -0.27, Tns: -1.02` | `Area: 44.0, Power: 0.00963, Eff_clk_period: 0.28, Wns: -0.27, Tns: -1.02` |
| Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 43.0, Power: 0.00548, Eff_clk_period: 0.13, Wns: -0.12, Tns: -0.95` |
| Prob023_up_down_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 259.0, Power: 0.0358, Eff_clk_period: 0.54, Wns: -0.53, Tns: -7.33` |
| Prob024_fsm | ✅ Pass (100.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 46.0, Power: 0.00695, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob025_sequence_detector | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 38.0, Power: 0.00388, Eff_clk_period: 0.19, Wns: -0.18, Tns: -0.85` |
| Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 1163.0, Power: 0.142, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob027_LIFObuffer | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 299.0, Power: 0.0419, Eff_clk_period: 0.39, Wns: -0.38, Tns: -8.84` |
| Prob028_LFSR | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 23.0, Power: 0.00295, Eff_clk_period: 0.18000000000000002, Wns: -0.17, Tns: -0.54` |
| Prob029_barrel_shifter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 58.0, Power: 0.0027, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob030_right_shifter | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.0000 | `Area: 36.0, Power: 0.00369, Eff_clk_period: 0.12, Wns: -0.11, Tns: -0.75` | `Area: 36.0, Power: 0.00369, Eff_clk_period: 0.12, Wns: -0.11, Tns: -0.75` |
| Prob031_freq_div | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 125.0, Power: 0.000671, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob032_freq_divbyeven | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.0015 | `Area: 45.0, Power: 0.00396, Eff_clk_period: 0.26, Wns: -0.25, Tns: -1.16` | `Area: 43.0, Power: 0.00398, Eff_clk_period: 0.27, Wns: -0.26, Tns: -1.15` |
| Prob033_freq_divbyfrac | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 59.0, Power: 0.00609, Eff_clk_period: 0.29000000000000004, Wns: -0.28, Tns: -1.42` |
| Prob034_freq_divbyodd | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 57.0, Power: 0.0058, Eff_clk_period: 0.22, Wns: -0.21, Tns: -1.38` |
| Prob035_calendar | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.0000 | `Area: 196.0, Power: 0.0124, Eff_clk_period: 0.38, Wns: -0.37, Tns: -6.23` | `Area: 196.0, Power: 0.0124, Eff_clk_period: 0.38, Wns: -0.37, Tns: -6.23` |
| Prob036_edge_detect | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | -0.0000 | `Area: 19.0, Power: 0.00189, Eff_clk_period: 0.17, Wns: -0.16, Tns: -0.3` | `Area: 19.0, Power: 0.00189, Eff_clk_period: 0.17, Wns: -0.16, Tns: -0.3` |
| Prob037_parallel2serial | ✅ Pass (100.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 50.0, Power: 0.00453, Eff_clk_period: 0.27, Wns: -0.26, Tns: -1.59` |
| Prob038_pulse_detect | ✅ Pass (100.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 17.0, Power: 0.00138, Eff_clk_period: 0.21000000000000002, Wns: -0.2, Tns: -0.2` |
| Prob039_serial2parallel | ✅ Pass (100.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 168.0, Power: 0.0238, Eff_clk_period: 0.3, Wns: -0.29, Tns: -5.46` |
| Prob040_synchronizer | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 0.6661 | `Area: 68.0, Power: 0.00178, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` | `Area: 1000000.0, Power: 1.0, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob041_traffic_light | ✅ Pass (100.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 170.0, Power: 0.0324, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob042_width_8to16 | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 0.0649 | `Area: 195.0, Power: 0.0419, Eff_clk_period: 0.26, Wns: -0.25, Tns: -6.05` | `Area: 196.0, Power: 0.0517, Eff_clk_period: 0.26, Wns: -0.25, Tns: -6.22` |
| Prob043_RAM | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 0.2366 | `Area: 506.0, Power: 0.069, Eff_clk_period: 0.3, Wns: -0.29, Tns: -9.91` | `Area: 734.0, Power: 0.109, Eff_clk_period: 0.31, Wns: -0.3, Tns: -13.95` |
| Prob044_ROM | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 14.0, Power: 0.000205, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob045_alu | ✅ Pass (100.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 2225.0, Power: 0.114, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob046_clkgenerator | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 1.0, Power: 2.36e-08, Eff_clk_period: 0.01, Wns: 0.0, Tns: 0.0` |
| Prob047_instr_reg | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 119.0, Power: 0.0129, Eff_clk_period: 0.18000000000000002, Wns: -0.17, Tns: -2.69` |
| Prob048_pe | ✅ Pass (100.0%) | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 0.0008 | `Area: 3450.0, Power: 0.45, Eff_clk_period: 1.57, Wns: -1.56, Tns: -31.89` | `Area: 3451.0, Power: 0.451, Eff_clk_period: 1.57, Wns: -1.56, Tns: -32.01` |
| Prob049_signal_generator | ✅ Pass (100.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 94.0, Power: 0.00467, Eff_clk_period: 0.43, Wns: -0.42, Tns: -2.58` |
| Prob050_square_wave | ❌ Fail (0.0%) | ❌ Fail (0.0%) | ❌ Fail (0.0%) | N/A | `N/A` | `Area: 119.0, Power: 0.0247, Eff_clk_period: 0.38, Wns: -0.37, Tns: -3.2` |