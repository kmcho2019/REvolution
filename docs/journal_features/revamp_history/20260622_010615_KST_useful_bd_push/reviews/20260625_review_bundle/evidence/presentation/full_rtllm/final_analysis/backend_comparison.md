# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Valid PPA samples count generated samples with PPA metrics even when QD warmup or archive insertion later drops them.
When the final population has no retained PPA aggregate, Score/PPA deltas use the best generated valid PPA sample.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `sr_raw_conservative_exploit_qd` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | ALL | unspecified | 48 | N/A | 96.02 ± 0.04 | 284450.52 ± 21783.83 | 120.03 | 141.21 |
| `classic_revolution` | RTLLM | unspecified | 48 | N/A | 96.02 ± 0.04 | 284450.52 ± 21783.83 | 120.03 | 141.21 |
| `sr_raw_conservative_exploit_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 293910.78 ± 21641.27 | 111.63 | 129.73 |
| `sr_raw_conservative_exploit_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 293910.78 ± 21641.27 | 111.63 | 129.73 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic_revolution` | RTLLM | Prob001_accu | ✅ Pass (87.5%) | ✅ Pass (87.5%) | 42 | +7.58% ✅ | -31.41% ❌ / +42.09% ✅ / +12.07% ✅ | +7.58% ✅ | 1587.56 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob001_accu | ✅ Pass (83.3%) | ✅ Pass (66.7%) | 32 | +11.53% ✅ | -28.80% ❌ / +46.15% ✅ / +17.24% ✅ | +11.53% ✅ | 1900.34 | 96 |
| `classic_revolution` | RTLLM | Prob002_adder_16bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 48 | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 1675.71 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob002_adder_16bit | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 48 | +39.99% ✅ | +20.65% ✅ / +99.32% ✅ / N/A | +59.99% ✅ | 1960.12 | 96 |
| `classic_revolution` | RTLLM | Prob003_adder_32bit | ✅ Pass (91.7%) | ✅ Pass (91.7%) | 44 | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 2034.83 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob003_adder_32bit | ✅ Pass (91.7%) | ✅ Pass (62.5%) | 30 | +55.79% ✅ | +67.61% ✅ / +99.75% ✅ / N/A | +83.68% ✅ | 1946.83 | 96 |
| `classic_revolution` | RTLLM | Prob004_adder_8bit | ✅ Pass (60.4%) | ✅ Pass (60.4%) | 29 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 1597.32 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (58.3%) | ✅ Pass (56.2%) | 27 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 1676.40 | 96 |
| `classic_revolution` | RTLLM | Prob005_adder_bcd | ✅ Pass (95.8%) | ✅ Pass (95.8%) | 46 | +39.70% ✅ | +20.00% ✅ / +99.09% ✅ / N/A | +59.55% ✅ | 1551.85 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob005_adder_bcd | ✅ Pass (93.8%) | ✅ Pass (93.8%) | 45 | +39.70% ✅ | +20.00% ✅ / +99.09% ✅ / N/A | +59.55% ✅ | 1776.82 | 96 |
| `classic_revolution` | RTLLM | Prob006_adder_pipe_64bit | ✅ Pass (22.9%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 2038.83 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob006_adder_pipe_64bit | ✅ Pass (18.8%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 2018.00 | 96 |
| `classic_revolution` | RTLLM | Prob007_comparator_3bit | ✅ Pass (97.9%) | ✅ Pass (97.9%) | 47 | +35.01% ✅ | +5.88% ✅ / +99.14% ✅ / N/A | +52.51% ✅ | 1189.61 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob007_comparator_3bit | ✅ Pass (95.8%) | ✅ Pass (62.5%) | 30 | +32.98% ✅ | +0.00% ➖ / +98.95% ✅ / N/A | +49.48% ✅ | 1159.77 | 96 |
| `classic_revolution` | RTLLM | Prob008_comparator_4bit | ✅ Pass (91.7%) | ✅ Pass (91.7%) | 44 | +45.27% ✅ | +36.36% ✅ / +99.45% ✅ / N/A | +67.90% ✅ | 1494.11 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob008_comparator_4bit | ✅ Pass (95.8%) | ✅ Pass (95.8%) | 46 | +45.27% ✅ | +36.36% ✅ / +99.45% ✅ / N/A | +67.90% ✅ | 1595.63 | 96 |
| `classic_revolution` | RTLLM | Prob009_div_16bit | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +55.91% ✅ | +77.23% ✅ / +90.51% ✅ / N/A | +83.87% ✅ | 1728.67 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob009_div_16bit | ✅ Pass (45.8%) | ✅ Pass (39.6%) | 19 | +55.89% ✅ | +76.93% ✅ / +90.74% ✅ / N/A | +83.84% ✅ | 2020.33 | 96 |
| `classic_revolution` | RTLLM | Prob010_radix2_div | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 2408.19 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob010_radix2_div | ✅ Pass (25.0%) | ✅ Pass (8.3%) | 4 | -84.23% ❌ | -41.82% ❌ / -218.28% ❌ / +7.41% ✅ | -84.23% ❌ | 2331.88 | 96 |
| `classic_revolution` | RTLLM | Prob011_multi_16bit | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +31.67% ✅ | +2.44% ✅ / +48.61% ✅ / +43.97% ✅ | +31.67% ✅ | 1953.31 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob011_multi_16bit | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 30 | +30.53% ✅ | +1.69% ✅ / +47.67% ✅ / +42.24% ✅ | +30.53% ✅ | 2176.02 | 96 |
| `classic_revolution` | RTLLM | Prob012_multi_8bit | ✅ Pass (77.1%) | ✅ Pass (77.1%) | 37 | +46.08% ✅ | +38.93% ✅ / +99.31% ✅ / N/A | +69.12% ✅ | 1393.86 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob012_multi_8bit | ✅ Pass (85.4%) | ✅ Pass (58.3%) | 28 | +46.08% ✅ | +38.93% ✅ / +99.31% ✅ / N/A | +69.12% ✅ | 1454.24 | 96 |
| `classic_revolution` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (43.8%) | ✅ Pass (6.2%) | 3 | +0.00% ➖ | N/A / N/A / N/A | N/A | 2156.04 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob013_multi_booth_8bit | ✅ Pass (58.3%) | ✅ Pass (12.5%) | 6 | -1837.25% ❌ | +95.02% ✅ / +93.24% ✅ / -5700.00% ❌ | -1837.25% ❌ | 666.12 | 96 |
| `classic_revolution` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (66.7%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1810.16 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob014_multi_pipe_4bit | ✅ Pass (58.3%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1647.49 | 96 |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (31.2%) | ✅ Pass (29.2%) | 14 | +6.82% ✅ | +40.61% ✅ / +5.46% ✅ / -25.61% ❌ | +6.82% ✅ | 2206.49 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (45.8%) | ✅ Pass (20.8%) | 10 | +6.07% ✅ | +8.37% ✅ / +20.82% ✅ / -10.98% ❌ | +6.07% ✅ | 2302.47 | 96 |
| `classic_revolution` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (85.4%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1605.74 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob016_fixed_point_adder | ✅ Pass (75.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1524.61 | 96 |
| `classic_revolution` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (93.8%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1586.86 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob017_fixed_point_substractor | ✅ Pass (95.8%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1541.69 | 96 |
| `classic_revolution` | RTLLM | Prob018_float_multi | ✅ Pass (31.2%) | ✅ Pass (8.3%) | 4 | +0.00% ➖ | N/A / N/A / N/A | N/A | 2403.36 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob018_float_multi | ✅ Pass (25.0%) | ✅ Pass (12.5%) | 6 | -5022.19% ❌ | +43.42% ✅ / -10.00% ❌ / -15100.00% ❌ | -5022.19% ❌ | 781.12 | 96 |
| `classic_revolution` | RTLLM | Prob019_sub_64bit | ✅ Pass (87.5%) | ✅ Pass (87.5%) | 42 | +48.23% ✅ | +45.25% ✅ / +99.43% ✅ / N/A | +72.34% ✅ | 1574.86 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob019_sub_64bit | ✅ Pass (95.8%) | ✅ Pass (95.8%) | 46 | +48.23% ✅ | +45.25% ✅ / +99.44% ✅ / N/A | +72.34% ✅ | 1948.06 | 96 |
| `classic_revolution` | RTLLM | Prob020_JC_counter | ✅ Pass (87.5%) | ✅ Pass (87.5%) | 42 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1468.33 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob020_JC_counter | ✅ Pass (100.0%) | ✅ Pass (66.7%) | 32 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1363.02 | 96 |
| `classic_revolution` | RTLLM | Prob021_counter_12 | ✅ Pass (95.8%) | ✅ Pass (95.8%) | 46 | +33.06% ✅ | +20.45% ✅ / +78.71% ✅ / +0.00% ➖ | +33.06% ✅ | 1224.33 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob021_counter_12 | ✅ Pass (100.0%) | ✅ Pass (81.2%) | 39 | +33.06% ✅ | +20.45% ✅ / +78.71% ✅ / +0.00% ➖ | +33.06% ✅ | 1246.54 | 96 |
| `classic_revolution` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1089.87 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob022_ring_counter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1161.45 | 96 |
| `classic_revolution` | RTLLM | Prob023_up_down_counter | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +21.58% ✅ | +23.17% ✅ / +15.64% ✅ / +25.93% ✅ | +21.58% ✅ | 1304.95 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob023_up_down_counter | ✅ Pass (77.1%) | ✅ Pass (60.4%) | 29 | -4.83% ❌ | +13.13% ✅ / -22.07% ❌ / -5.56% ❌ | -4.83% ❌ | 1322.40 | 96 |
| `classic_revolution` | RTLLM | Prob024_fsm | ✅ Pass (29.2%) | ✅ Pass (25.0%) | 12 | +63.16% ✅ | +43.48% ✅ / +61.01% ✅ / N/A | +52.24% ✅ | 1647.82 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob024_fsm | ✅ Pass (43.8%) | ✅ Pass (20.8%) | 10 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1927.40 | 96 |
| `classic_revolution` | RTLLM | Prob025_sequence_detector | ✅ Pass (6.2%) | ✅ Pass (6.2%) | 3 | +27.68% ✅ | +31.58% ✅ / +30.41% ✅ / +21.05% ✅ | +27.68% ✅ | 1568.51 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob025_sequence_detector | ✅ Pass (20.8%) | ✅ Pass (14.6%) | 7 | +4.26% ✅ | +15.79% ✅ / +18.04% ✅ / -21.05% ❌ | +4.26% ✅ | 1652.80 | 96 |
| `classic_revolution` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 2051.32 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob026_asyn_fifo | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1997.06 | 96 |
| `classic_revolution` | RTLLM | Prob027_LIFObuffer | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +22.95% ✅ | +17.06% ✅ / +41.53% ✅ / +10.26% ✅ | +22.95% ✅ | 1632.12 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob027_LIFObuffer | ✅ Pass (89.6%) | ✅ Pass (85.4%) | 41 | +18.25% ✅ | +22.41% ✅ / +27.21% ✅ / +5.13% ✅ | +18.25% ✅ | 1955.94 | 96 |
| `classic_revolution` | RTLLM | Prob028_LFSR | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1103.12 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob028_LFSR | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1289.69 | 96 |
| `classic_revolution` | RTLLM | Prob029_barrel_shifter | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1516.48 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob029_barrel_shifter | ✅ Pass (2.1%) | ✅ Pass (2.1%) | 1 | +35.89% ✅ | +8.62% ✅ / +99.04% ✅ / N/A | +53.83% ✅ | 1350.46 | 96 |
| `classic_revolution` | RTLLM | Prob030_right_shifter | ✅ Pass (89.6%) | ✅ Pass (68.8%) | 33 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1114.05 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob030_right_shifter | ✅ Pass (100.0%) | ✅ Pass (62.5%) | 30 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1273.26 | 96 |
| `classic_revolution` | RTLLM | Prob031_freq_div | ✅ Pass (62.5%) | ✅ Pass (50.0%) | 24 | +20.91% ✅ | +19.20% ✅ / +43.52% ✅ / N/A | +31.36% ✅ | 1790.32 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob031_freq_div | ✅ Pass (81.2%) | ✅ Pass (33.3%) | 16 | +15.40% ✅ | +15.20% ✅ / +31.00% ✅ / N/A | +23.10% ✅ | 1921.68 | 96 |
| `classic_revolution` | RTLLM | Prob032_freq_divbyeven | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1648.00 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob032_freq_divbyeven | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1657.36 | 96 |
| `classic_revolution` | RTLLM | Prob033_freq_divbyfrac | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1967.39 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob033_freq_divbyfrac | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 2279.23 | 96 |
| `classic_revolution` | RTLLM | Prob034_freq_divbyodd | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1880.90 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob034_freq_divbyodd | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1753.33 | 96 |
| `classic_revolution` | RTLLM | Prob035_calendar | ✅ Pass (93.8%) | ✅ Pass (45.8%) | 22 | +2.34% ✅ | +6.63% ✅ / +5.65% ✅ / -5.26% ❌ | +2.34% ✅ | 1548.08 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob035_calendar | ✅ Pass (81.2%) | ✅ Pass (45.8%) | 22 | +2.34% ✅ | +6.63% ✅ / +5.65% ✅ / -5.26% ❌ | +2.34% ✅ | 1892.46 | 96 |
| `classic_revolution` | RTLLM | Prob036_edge_detect | ✅ Pass (66.7%) | ✅ Pass (60.4%) | 29 | +3.89% ✅ | +5.26% ✅ / +0.53% ✅ / +5.88% ✅ | +3.89% ✅ | 1403.79 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob036_edge_detect | ✅ Pass (70.8%) | ✅ Pass (60.4%) | 29 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1524.61 | 96 |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | ✅ Pass (37.5%) | ✅ Pass (35.4%) | 17 | +22.83% ✅ | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ | +22.83% ✅ | 1838.17 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (20.8%) | ✅ Pass (20.8%) | 10 | +0.89% ✅ | -6.00% ❌ / +12.36% ✅ / -3.70% ❌ | +0.89% ✅ | 2064.40 | 96 |
| `classic_revolution` | RTLLM | Prob038_pulse_detect | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1557.75 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob038_pulse_detect | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1748.78 | 96 |
| `classic_revolution` | RTLLM | Prob039_serial2parallel | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 2613.56 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob039_serial2parallel | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | +8.00% ✅ | -8.33% ❌ / +28.99% ✅ / +3.33% ✅ | +8.00% ✅ | 2744.48 | 96 |
| `classic_revolution` | RTLLM | Prob040_synchronizer | ✅ Pass (100.0%) | ✅ Pass (100.0%) | 48 | +0.00% ➖ | N/A / N/A / N/A | N/A | 1608.78 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob040_synchronizer | ✅ Pass (91.7%) | ✅ Pass (66.7%) | 32 | -3233.60% ❌ | +99.34% ✅ / +99.85% ✅ / +100.00% ✅ | +99.73% ✅ | 576.86 | 96 |
| `classic_revolution` | RTLLM | Prob041_traffic_light | ✅ Pass (47.9%) | ✅ Pass (45.8%) | 22 | +42.46% ✅ | +28.24% ✅ / +99.15% ✅ / N/A | +63.69% ✅ | 2042.12 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (41.7%) | ✅ Pass (22.9%) | 11 | +36.27% ✅ | +10.00% ✅ / +98.81% ✅ / N/A | +54.41% ✅ | 2244.77 | 96 |
| `classic_revolution` | RTLLM | Prob042_width_8to16 | ✅ Pass (18.8%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 2048.77 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob042_width_8to16 | ✅ Pass (12.5%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 2020.53 | 96 |
| `classic_revolution` | RTLLM | Prob043_RAM | ✅ Pass (85.4%) | ✅ Pass (85.4%) | 41 | +44.45% ✅ | +34.47% ✅ / +63.39% ✅ / +35.48% ✅ | +44.45% ✅ | 1517.78 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob043_RAM | ✅ Pass (62.5%) | ✅ Pass (37.5%) | 18 | +42.61% ✅ | +42.51% ✅ / +43.39% ✅ / +41.94% ✅ | +42.61% ✅ | 1612.86 | 96 |
| `classic_revolution` | RTLLM | Prob044_ROM | ✅ Pass (62.5%) | ✅ Pass (62.5%) | 30 | +32.94% ✅ | +0.00% ➖ / +98.83% ✅ / N/A | +49.41% ✅ | 1197.83 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob044_ROM | ✅ Pass (68.8%) | ✅ Pass (29.2%) | 14 | +32.94% ✅ | +0.00% ➖ / +98.83% ✅ / N/A | +49.41% ✅ | 1466.34 | 96 |
| `classic_revolution` | RTLLM | Prob045_alu | ✅ Pass (64.6%) | ✅ Pass (64.6%) | 31 | +41.70% ✅ | +25.89% ✅ / +99.20% ✅ / N/A | +62.55% ✅ | 1954.14 | 97 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob045_alu | ✅ Pass (37.5%) | ✅ Pass (27.1%) | 13 | +40.77% ✅ | +23.15% ✅ / +99.17% ✅ / N/A | +61.16% ✅ | 2272.68 | 96 |
| `classic_revolution` | RTLLM | Prob046_clkgenerator | ✅ Pass (2.1%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1490.65 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob046_clkgenerator | ✅ Pass (8.3%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1390.68 | 96 |
| `classic_revolution` | RTLLM | Prob047_instr_reg | ✅ Pass (75.0%) | ✅ Pass (70.8%) | 34 | -0.28% ❌ | -0.84% ❌ / +0.00% ➖ / +0.00% ➖ | -0.28% ❌ | 1434.95 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob047_instr_reg | ✅ Pass (77.1%) | ✅ Pass (58.3%) | 28 | -1.64% ❌ | -3.36% ❌ / -1.55% ❌ / +0.00% ➖ | -1.64% ❌ | 1726.04 | 96 |
| `classic_revolution` | RTLLM | Prob048_pe | ✅ Pass (45.8%) | ✅ Pass (45.8%) | 22 | +1.50% ✅ | +1.48% ✅ / +6.21% ✅ / -3.18% ❌ | +1.50% ✅ | 1258.26 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob048_pe | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +0.26% ✅ | +0.35% ✅ / +0.44% ✅ / +0.00% ➖ | +0.26% ✅ | 1509.57 | 96 |
| `classic_revolution` | RTLLM | Prob049_signal_generator | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 1466.87 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (68.8%) | ✅ Pass (47.9%) | 23 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 1721.19 | 96 |
| `classic_revolution` | RTLLM | Prob050_square_wave | ✅ Pass (93.8%) | ✅ Pass (93.8%) | 45 | +27.79% ✅ | +11.76% ✅ / +66.36% ✅ / +5.26% ✅ | +27.79% ✅ | 1341.74 | 96 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob050_square_wave | ✅ Pass (91.7%) | ✅ Pass (91.7%) | 44 | +17.21% ✅ | +27.73% ✅ / +18.62% ✅ / +5.26% ✅ | +17.21% ✅ | 1420.40 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | RTLLM | 50 | ➖ 40/50 (80.0%) | ➖ 34/50 (68.0%) | 53.0% ± 10.1% | 44.0% ± 10.6% | 34/50 | +26.05% ± 6.55% ✅ | ✅ 28 / ➖ 5 / ❌ 1 | 34/50 (1056 samples) | +36.96% ± 9.44% ✅ | +20.90% ± 7.56% ✅ / +56.83% ± 13.86% ✅ / +9.53% ± 7.94% ✅ | ✅ 28 / ➖ 2 / ❌ 1 | A ❌ 2/31 / P ✅ 0/31 / T ❌ 3/17 | 1666.56 ± 97.53 | 96.02 ± 0.04 |
| `sr_raw_conservative_exploit_qd` | RTLLM | 50 | ➖ 43/50 (86.0%) | ➖ 37/50 (74.0%) | 54.1% ± 10.0% | 36.6% ± 9.1% | 37/50 | -253.29% ± 325.42% ❌ | ✅ 28 / ➖ 3 / ❌ 6 | 37/50 (879 samples) | -156.02% ± 283.03% ❌ | +19.49% ± 9.53% ✅ / +45.78% ± 19.82% ✅ / -936.93% ± 1416.20% ❌ | ✅ 29 / ➖ 3 / ❌ 5 | A ❌ 5/37 / P ❌ 4/37 / T ❌ 7/22 | 1690.32 ± 119.70 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | ALL | 50 | ➖ 40/50 (80.0%) | ➖ 34/50 (68.0%) | 53.0% ± 10.1% | 44.0% ± 10.6% | 34/50 | +26.05% ± 6.55% ✅ | ✅ 28 / ➖ 5 / ❌ 1 | 34/50 (1056 samples) | +36.96% ± 9.44% ✅ | +20.90% ± 7.56% ✅ / +56.83% ± 13.86% ✅ / +9.53% ± 7.94% ✅ | ✅ 28 / ➖ 2 / ❌ 1 | A ❌ 2/31 / P ✅ 0/31 / T ❌ 3/17 | 1666.56 ± 97.53 | 96.02 ± 0.04 |
| `sr_raw_conservative_exploit_qd` | ALL | 50 | ➖ 43/50 (86.0%) | ➖ 37/50 (74.0%) | 54.1% ± 10.0% | 36.6% ± 9.1% | 37/50 | -253.29% ± 325.42% ❌ | ✅ 28 / ➖ 3 / ❌ 6 | 37/50 (879 samples) | -156.02% ± 283.03% ❌ | +19.49% ± 9.53% ✅ / +45.78% ± 19.82% ✅ / -936.93% ± 1416.20% ❌ | ✅ 29 / ➖ 3 / ❌ 5 | A ❌ 5/37 / P ❌ 4/37 / T ❌ 7/22 | 1690.32 ± 119.70 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic_revolution` | RTLLM | Prob001_accu | 3 | 11 | 3 | 0.0000 | 0 | -26.70% ❌ / +42.09% ✅ / +15.52% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob001_accu | 3 | 13 | 2 | 0.0000 | 0 | -26.70% ❌ / +46.15% ✅ / +17.24% ✅ |
| `classic_revolution` | RTLLM | Prob002_adder_16bit | 2 | 11 | 1 | 0.2051 | 3 | +20.65% ✅ / +99.32% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob002_adder_16bit | 2 | 11 | 1 | 0.2051 | 3 | +20.65% ✅ / +99.32% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob003_adder_32bit | 2 | 17 | 1 | 0.6745 | 16 | +67.61% ✅ / +99.75% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob003_adder_32bit | 2 | 10 | 1 | 0.6745 | 10 | +67.61% ✅ / +99.75% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob004_adder_8bit | 2 | 8 | 1 | 0.1510 | 2 | +15.22% ✅ / +99.25% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob004_adder_8bit | 2 | 11 | 1 | 0.1510 | 2 | +15.22% ✅ / +99.25% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob005_adder_bcd | 2 | 15 | 1 | 0.1982 | 7 | +20.00% ✅ / +99.09% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob005_adder_bcd | 2 | 17 | 1 | 0.1982 | 11 | +20.00% ✅ / +99.09% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob006_adder_pipe_64bit | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob006_adder_pipe_64bit | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `classic_revolution` | RTLLM | Prob007_comparator_3bit | 2 | 16 | 1 | 0.0583 | 2 | +5.88% ✅ / +99.14% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob007_comparator_3bit | 2 | 8 | 1 | 0.0000 | 1 | +0.00% ➖ / +98.95% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob008_comparator_4bit | 2 | 18 | 1 | 0.3616 | 15 | +36.36% ✅ / +99.45% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob008_comparator_4bit | 2 | 20 | 1 | 0.3616 | 14 | +36.36% ✅ / +99.45% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob009_div_16bit | 2 | 25 | 5 | 0.7159 | 25 | +77.29% ✅ / +92.75% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob009_div_16bit | 2 | 16 | 4 | 0.7128 | 16 | +76.95% ✅ / +92.75% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob010_radix2_div | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob010_radix2_div | 3 | 3 | 2 | 0.0000 | 0 | -39.39% ❌ / -218.28% ❌ / +7.41% ✅ |
| `classic_revolution` | RTLLM | Prob011_multi_16bit | 3 | 14 | 3 | 0.0056 | 4 | +3.01% ✅ / +48.61% ✅ / +43.97% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob011_multi_16bit | 3 | 19 | 3 | 0.0075 | 2 | +3.85% ✅ / +64.44% ✅ / +43.10% ✅ |
| `classic_revolution` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 | +38.93% ✅ / +99.31% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob012_multi_8bit | 2 | 5 | 1 | 0.3866 | 4 | +38.93% ✅ / +99.31% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob013_multi_booth_8bit | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob013_multi_booth_8bit | 3 | 3 | 1 | 0.0000 | 0 | +95.02% ✅ / +93.24% ✅ / -5700.00% ❌ |
| `classic_revolution` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob014_multi_pipe_4bit | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | 3 | 12 | 5 | 0.0000 | 0 | +40.61% ✅ / +5.46% ✅ / +15.85% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 4 | 0.0000 | 0 | +36.43% ✅ / +20.82% ✅ / +7.32% ✅ |
| `classic_revolution` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob016_fixed_point_adder | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `classic_revolution` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob017_fixed_point_substractor | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `classic_revolution` | RTLLM | Prob018_float_multi | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob018_float_multi | 3 | 6 | 4 | 0.0000 | 0 | +46.06% ✅ / +1.50% ✅ / -15100.00% ❌ |
| `classic_revolution` | RTLLM | Prob019_sub_64bit | 2 | 9 | 1 | 0.4499 | 3 | +45.25% ✅ / +99.43% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob019_sub_64bit | 2 | 12 | 1 | 0.4500 | 6 | +45.25% ✅ / +99.44% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob020_JC_counter | 3 | 4 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob020_JC_counter | 3 | 4 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob021_counter_12 | 3 | 8 | 3 | 0.0026 | 3 | +20.45% ✅ / +78.71% ✅ / +10.71% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob021_counter_12 | 3 | 6 | 2 | 0.0000 | 2 | +20.45% ✅ / +78.71% ✅ / +21.43% ✅ |
| `classic_revolution` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob022_ring_counter | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob023_up_down_counter | 3 | 3 | 1 | 0.0094 | 1 | +23.17% ✅ / +15.64% ✅ / +25.93% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob023_up_down_counter | 3 | 1 | 1 | 0.0000 | 0 | +13.13% ✅ / -22.07% ❌ / -5.56% ❌ |
| `classic_revolution` | RTLLM | Prob024_fsm | 2 | 8 | 1 | 0.2652 | 4 | +43.48% ✅ / +61.01% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob024_fsm | 2 | 8 | 3 | 0.1460 | 5 | +36.96% ✅ / +46.91% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob025_sequence_detector | 3 | 3 | 1 | 0.0202 | 2 | +31.58% ✅ / +30.41% ✅ / +21.05% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob025_sequence_detector | 3 | 7 | 2 | 0.0000 | 0 | +15.79% ✅ / +18.04% ✅ / -10.53% ❌ |
| `classic_revolution` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob026_asyn_fifo | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `classic_revolution` | RTLLM | Prob027_LIFObuffer | 3 | 32 | 6 | 0.0079 | 7 | +27.09% ✅ / +41.53% ✅ / +10.26% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob027_LIFObuffer | 3 | 26 | 8 | 0.0067 | 6 | +27.09% ✅ / +38.19% ✅ / +15.38% ✅ |
| `classic_revolution` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob028_LFSR | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob029_barrel_shifter | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob029_barrel_shifter | 2 | 1 | 1 | 0.0854 | 1 | +8.62% ✅ / +99.04% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob030_right_shifter | 3 | 3 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob030_right_shifter | 3 | 3 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob031_freq_div | 2 | 5 | 1 | 0.0836 | 5 | +19.20% ✅ / +43.52% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob031_freq_div | 2 | 3 | 1 | 0.0471 | 2 | +15.20% ✅ / +31.00% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob032_freq_divbyeven | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob033_freq_divbyfrac | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob034_freq_divbyodd | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob035_calendar | 3 | 5 | 2 | 0.0000 | 1 | +6.63% ✅ / +5.65% ✅ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob035_calendar | 3 | 6 | 3 | 0.0000 | 1 | +6.63% ✅ / +5.65% ✅ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob036_edge_detect | 3 | 8 | 1 | 0.4327 | 4 | +63.16% ✅ / +68.52% ✅ / +100.00% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob036_edge_detect | 3 | 4 | 1 | 0.3261 | 1 | +52.63% ✅ / +61.96% ✅ / +100.00% ✅ |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | 3 | 8 | 1 | 0.0119 | 3 | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob037_parallel2serial | 3 | 3 | 2 | 0.0000 | 0 | +0.00% ➖ / +12.36% ✅ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob038_pulse_detect | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob039_serial2parallel | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob039_serial2parallel | 3 | 2 | 1 | 0.0000 | 0 | -8.33% ❌ / +28.99% ✅ / +3.33% ✅ |
| `classic_revolution` | RTLLM | Prob040_synchronizer | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob040_synchronizer | 3 | 12 | 1 | 0.9919 | 12 | +99.34% ✅ / +99.85% ✅ / +100.00% ✅ |
| `classic_revolution` | RTLLM | Prob041_traffic_light | 2 | 17 | 3 | 0.2965 | 16 | +32.94% ✅ / +99.15% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob041_traffic_light | 2 | 10 | 2 | 0.1786 | 6 | +26.47% ✅ / +98.81% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob042_width_8to16 | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob043_RAM | 3 | 11 | 2 | 0.1018 | 11 | +42.51% ✅ / +63.39% ✅ / +41.94% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob043_RAM | 3 | 4 | 1 | 0.0774 | 4 | +42.51% ✅ / +43.39% ✅ / +41.94% ✅ |
| `classic_revolution` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 | +0.00% ➖ / +98.97% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob044_ROM | 2 | 3 | 2 | 0.0000 | 1 | +0.00% ➖ / +98.97% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob045_alu | 2 | 28 | 1 | 0.2568 | 28 | +25.89% ✅ / +99.20% ✅ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob045_alu | 2 | 12 | 1 | 0.2295 | 12 | +23.15% ✅ / +99.17% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob046_clkgenerator | 2 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `classic_revolution` | RTLLM | Prob047_instr_reg | 3 | 4 | 1 | 0.0000 | 0 | -0.84% ❌ / +0.00% ➖ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob047_instr_reg | 3 | 3 | 1 | 0.0000 | 0 | -3.36% ❌ / -1.55% ❌ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob048_pe | 3 | 5 | 3 | 0.0000 | 1 | +1.48% ✅ / +6.21% ✅ / +0.00% ➖ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob048_pe | 3 | 4 | 1 | 0.0000 | 2 | +0.35% ✅ / +0.44% ✅ / +0.00% ➖ |
| `classic_revolution` | RTLLM | Prob049_signal_generator | 3 | 11 | 4 | 0.0223 | 8 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob049_signal_generator | 3 | 5 | 2 | 0.0109 | 2 | +37.23% ✅ / +46.04% ✅ / +18.60% ✅ |
| `classic_revolution` | RTLLM | Prob050_square_wave | 3 | 25 | 2 | 0.0041 | 6 | +13.45% ✅ / +66.36% ✅ / +5.26% ✅ |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob050_square_wave | 3 | 28 | 3 | 0.0031 | 5 | +27.73% ✅ / +59.51% ✅ / +5.26% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution` | RTLLM | 50 | 31 | 0.0944 ± 0.0492 | 1.22 ± 0.41 | 3.64 ± 1.75 | 40 |
| `sr_raw_conservative_exploit_qd` | RTLLM | 50 | 37 | 0.1050 ± 0.0589 | 1.38 ± 0.41 | 2.62 ± 1.15 | 10 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution` | ALL | 50 | 31 | 0.0944 ± 0.0492 | 1.22 ± 0.41 | 3.64 ± 1.75 | 40 |
| `sr_raw_conservative_exploit_qd` | ALL | 50 | 37 | 0.1050 ± 0.0589 | 1.38 ± 0.41 | 2.62 ± 1.15 | 10 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob001_accu | grid_quantile | 29.6% | -1.7644 | 0.1153 | 8/27 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob002_adder_16bit | grid_quantile | 18.5% | 1.4970 | 0.3999 | 5/27 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob003_adder_32bit | grid_quantile | 25.0% | 1.0206 | 0.5579 | 2/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 10.9% | 1.3819 | 0.3815 | 7/64 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob005_adder_bcd | grid_quantile | 19.4% | 2.4937 | 0.3970 | 7/36 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob006_adder_pipe_64bit | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob007_comparator_3bit | grid_quantile | 50.0% | 1.1011 | 0.3298 | 4/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob008_comparator_4bit | grid_quantile | 18.8% | 4.6424 | 0.4527 | 12/64 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob009_div_16bit | grid_quantile | 7.8% | 2.6437 | 0.5589 | 5/64 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob010_radix2_div | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob011_multi_16bit | grid_quantile | 22.9% | 0.6965 | 0.3053 | 11/48 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob012_multi_8bit | grid_quantile | 37.5% | 1.1056 | 0.4608 | 3/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob013_multi_booth_8bit | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob014_multi_pipe_4bit | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 14.1% | -0.6957 | 0.0607 | 9/64 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob016_fixed_point_adder | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob017_fixed_point_substractor | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob018_float_multi | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob019_sub_64bit | grid_quantile | 25.9% | 2.4208 | 0.4823 | 7/27 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob020_JC_counter | grid_quantile | 37.5% | -0.7113 | -0.0000 | 3/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob021_counter_12 | grid_quantile | 62.5% | 0.0794 | 0.3306 | 5/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob022_ring_counter | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob023_up_down_counter | grid_quantile | 100.0% | -0.0483 | -0.0483 | 1/1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob024_fsm | grid_quantile | 10.9% | 2.8782 | 0.5002 | 7/64 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob025_sequence_detector | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob026_asyn_fifo | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob027_LIFObuffer | grid_quantile | 15.6% | 0.8934 | 0.1825 | 10/64 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob028_LFSR | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob029_barrel_shifter | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob030_right_shifter | grid_quantile | 25.0% | -0.0847 | -0.0000 | 2/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob031_freq_div | grid_quantile | 37.5% | 0.2434 | 0.1540 | 3/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob032_freq_divbyeven | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob033_freq_divbyfrac | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob034_freq_divbyodd | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob035_calendar | grid_quantile | 50.0% | 0.0504 | 0.0234 | 4/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob036_edge_detect | grid_quantile | 50.0% | -1.8288 | -0.0000 | 4/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 7.4% | -0.1148 | 0.0089 | 2/27 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob038_pulse_detect | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob039_serial2parallel | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob040_synchronizer | grid_quantile | 62.5% | -161.6852 | -32.3360 | 5/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 14.1% | 1.1803 | 0.3627 | 9/64 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob042_width_8to16 | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob043_RAM | grid_quantile | 37.5% | 1.0532 | 0.4261 | 3/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob044_ROM | grid_quantile | 25.0% | 0.5165 | 0.3294 | 2/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob045_alu | grid_quantile | 18.8% | 4.6037 | 0.4077 | 12/64 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob046_clkgenerator | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob047_instr_reg | grid_quantile | 11.1% | -0.4504 | -0.0164 | 3/27 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob048_pe | grid_quantile | 11.1% | -1.0279 | 0.0026 | 4/36 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 37.5% | 0.4976 | 0.2348 | 3/8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob050_square_wave | grid_quantile | 20.3% | 0.1270 | 0.1721 | 13/64 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob001_accu | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 32 | 13 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=13, filled_empty=6, pareto_inserted=5, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob002_adder_16bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 48 | 11 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=33, filled_empty=2, pareto_inserted=5, warmup_buffered=8; replay duplicate_objectives=4, filled_empty=3, pareto_inserted=1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob003_adder_32bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 30 | 6 | init=warmup_complete, shape=2x2x2 | none | live crowding_evicted=6, duplicate_objectives=10, pareto_inserted=4, warmup_buffered=10; replay duplicate_objectives=8, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob004_adder_8bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 27 | 11 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=13, filled_empty=2, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=3, filled_empty=5 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob005_adder_bcd | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 45 | 12 | init=warmup_complete, shape=4x3x3 | none | live crowding_evicted=7, duplicate_objectives=21, filled_empty=4, pareto_inserted=5, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob006_adder_pipe_64bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob007_comparator_3bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 30 | 8 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=11, filled_empty=2, pareto_inserted=4, warmup_buffered=13; replay duplicate_objectives=11, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob008_comparator_4bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 46 | 20 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=25, filled_empty=5, pareto_inserted=8, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=7 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob009_div_16bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 19 | 10 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=6, duplicate_objectives=1, pareto_inserted=4, warmup_buffered=8; replay duplicate_objectives=2, filled_empty=5, pareto_inserted=1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob010_radix2_div | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 4 | 0 | init=pending | none | live warmup_buffered=4 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob011_multi_16bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 30 | 19 | init=warmup_complete, shape=4x3x4 | none | live duplicate_objectives=8, filled_empty=6, pareto_inserted=8, warmup_buffered=8; replay duplicate_objectives=3, filled_empty=5 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob012_multi_8bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 28 | 5 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=17, filled_empty=1, pareto_inserted=2, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob013_multi_booth_8bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 6 | 0 | init=pending | none | live warmup_buffered=6 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob014_multi_pipe_4bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob015_multi_pipe_8bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 10 | 9 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=1, filled_empty=1, warmup_buffered=8; replay filled_empty=8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob016_fixed_point_adder | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob017_fixed_point_substractor | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob018_float_multi | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 6 | 0 | init=pending | none | live warmup_buffered=6 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob019_sub_64bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 46 | 12 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=28, filled_empty=5, pareto_inserted=5, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob020_JC_counter | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 32 | 4 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=17, filled_empty=1, pareto_inserted=1, warmup_buffered=13; replay duplicate_objectives=11, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob021_counter_12 | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 39 | 6 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=22, filled_empty=3, pareto_inserted=1, warmup_buffered=13; replay duplicate_objectives=11, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob022_ring_counter | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob023_up_down_counter | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 29 | 1 | init=run_finalization_fallback, shape=1x1x1 | sr_pca_0, sr_pca_1, sr_pca_2 | live warmup_buffered=29; replay duplicate_objectives=28, filled_empty=1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob024_fsm | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 10 | 8 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=1, filled_empty=1, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=6, pareto_inserted=1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob025_sequence_detector | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 7 | 0 | init=pending | none | live warmup_buffered=7 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob026_asyn_fifo | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob027_LIFObuffer | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 41 | 21 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=11, duplicate_objectives=7, filled_empty=5, pareto_inserted=10, warmup_buffered=8; replay duplicate_objectives=2, filled_empty=5, pareto_inserted=1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob028_LFSR | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob029_barrel_shifter | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 1 | 0 | init=pending | none | live warmup_buffered=1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob030_right_shifter | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 30 | 3 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=6, warmup_buffered=24; replay duplicate_objectives=21, filled_empty=2, pareto_inserted=1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob031_freq_div | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 16 | 3 | init=warmup_complete, shape=2x2x2 | none | live filled_empty=1, warmup_buffered=15; replay duplicate_objectives=13, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob032_freq_divbyeven | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob033_freq_divbyfrac | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob034_freq_divbyodd | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob035_calendar | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 22 | 6 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=8, filled_empty=3, pareto_inserted=1, warmup_buffered=10; replay duplicate_objectives=8, filled_empty=1, pareto_inserted=1 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob036_edge_detect | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 29 | 4 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=15, filled_empty=2, warmup_buffered=12; replay duplicate_objectives=10, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob037_parallel2serial | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 10 | 3 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=1, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob038_pulse_detect | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob039_serial2parallel | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 2 | 0 | init=pending | none | live warmup_buffered=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob040_synchronizer | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 32 | 12 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=9, filled_empty=3, pareto_inserted=7, warmup_buffered=13; replay duplicate_objectives=11, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob041_traffic_light | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 11 | 10 | init=warmup_complete, shape=4x4x4 | none | live filled_empty=2, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=7 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob042_width_8to16 | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob043_RAM | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 18 | 5 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=2, filled_empty=1, pareto_inserted=2, warmup_buffered=13; replay duplicate_objectives=11, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob044_ROM | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 14 | 3 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=2, pareto_inserted=1, warmup_buffered=11; replay duplicate_objectives=9, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob045_alu | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 13 | 12 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=1, filled_empty=4, warmup_buffered=8; replay filled_empty=8 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob046_clkgenerator | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 0 | 0 | init=pending | none | live N/A |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob047_instr_reg | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 28 | 3 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=19, filled_empty=1, warmup_buffered=8; replay duplicate_objectives=6, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob048_pe | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 21 | 4 | init=warmup_complete, shape=3x4x3 | none | live duplicate_objectives=12, filled_empty=1, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob049_signal_generator | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 23 | 5 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=11, filled_empty=1, pareto_inserted=2, warmup_buffered=9; replay duplicate_objectives=7, filled_empty=2 |
| `sr_raw_conservative_exploit_qd` | RTLLM | Prob050_square_wave | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 44 | 26 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=2, duplicate_objectives=13, filled_empty=8, pareto_inserted=13, warmup_buffered=8; replay duplicate_objectives=3, filled_empty=5 |
