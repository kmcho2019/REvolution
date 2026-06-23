# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Valid PPA samples count generated samples with PPA metrics even when QD warmup or archive insertion later drops them.
When the final population has no retained PPA aggregate, Score/PPA deltas use the best generated valid PPA sample.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 326234.92 ± 36801.68 | 96.00 | 96.00 |
| `classic` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 319848.86 ± 59618.09 | 96.00 | 96.00 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 333685.33 ± 44580.75 | 96.00 | 96.00 |
| `fused_rtl_state_pipeline_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 326764.38 ± 35755.70 | 96.00 | 96.00 |
| `fused_rtl_state_pipeline_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 307047.29 ± 58365.43 | 96.00 | 96.00 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 349767.67 ± 33524.27 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (60.4%) | ✅ Pass (58.3%) | 28 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 716.70 | 96 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 541.80 | 96 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +13.52% ✅ | +28.98% ✅ / +38.42% ✅ / -26.83% ❌ | +13.52% ✅ | 1055.42 | 96 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 1017.00 | 96 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (39.6%) | ✅ Pass (33.3%) | 16 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 793.04 | 96 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob024_fsm | ✅ Pass (56.2%) | ✅ Pass (52.1%) | 25 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 897.73 | 96 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (43.8%) | ✅ Pass (37.5%) | 18 | +8.46% ✅ | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ | +8.46% ✅ | 973.47 | 96 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | +3.26% ✅ | -10.00% ❌ / +12.36% ✅ / +7.41% ✅ | +3.26% ✅ | 1230.48 | 96 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (43.8%) | ✅ Pass (41.7%) | 20 | +41.68% ✅ | +25.88% ✅ / +99.15% ✅ / N/A | +62.52% ✅ | 1073.82 | 96 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (50.0%) | ✅ Pass (50.0%) | 24 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 1147.80 | 96 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (22.9%) | ✅ Pass (20.8%) | 10 | +39.46% ✅ | +19.19% ✅ / +99.19% ✅ / N/A | +59.19% ✅ | 1086.16 | 96 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob045_alu | ✅ Pass (39.6%) | ✅ Pass (39.6%) | 19 | +40.31% ✅ | +21.80% ✅ / +99.13% ✅ / N/A | +60.46% ✅ | 1149.20 | 96 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 623.45 | 96 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (79.2%) | ✅ Pass (79.2%) | 38 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 634.89 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1094.59 | 96 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (33.3%) | ✅ Pass (33.3%) | 16 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1367.41 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +46.44% ✅ | +40.00% ✅ / +99.32% ✅ / N/A | +69.66% ✅ | 1336.20 | 96 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 18 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1422.64 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (77.1%) | ✅ Pass (77.1%) | 37 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1119.47 | 96 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (52.1%) | ✅ Pass (52.1%) | 25 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1124.01 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1038.77 | 96 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (12.5%) | ✅ Pass (12.5%) | 6 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1182.21 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | -36.30% ❌ | -46.97% ❌ / -51.23% ❌ / -10.71% ❌ | -36.30% ❌ | 1216.90 | 96 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (6.2%) | ✅ Pass (6.2%) | 3 | -28.84% ❌ | -34.85% ❌ / -48.10% ❌ / -3.57% ❌ | -28.84% ❌ | 1226.29 | 96 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +10.86% ✅ | +5.85% ✅ / +33.41% ✅ / -6.67% ❌ | +10.86% ✅ | 762.36 | 96 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (41.7%) | ✅ Pass (39.6%) | 19 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1121.81 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 39.0% ± 9.2% | 36.3% ± 8.8% | 7/7 | +30.68% ± 11.59% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (122 samples) | +36.92% ± 16.87% ✅ | +18.54% ± 5.86% ✅ / +63.44% ± 25.91% ✅ / -3.83% ± 22.98% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 903.15 ± 140.52 | 96.00 ± 0.00 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.9% ± 22.2% | 46.9% ± 22.2% | 6/6 | +13.59% ± 23.38% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (135 samples) | +22.50% ± 30.50% ✅ | -3.52% ± 23.10% ❌ / +47.18% ± 50.43% ✅ / -8.69% ± 3.97% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 2/2 | 1094.72 ± 154.93 | 96.00 ± 0.00 |
| `fused_rtl_state_pipeline_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 51.2% ± 14.1% | 50.6% ± 14.0% | 7/7 | +28.75% ± 13.69% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (170 samples) | +34.99% ± 18.77% ✅ | +17.69% ± 10.94% ✅ / +57.80% ± 30.96% ✅ / -2.19% ± 23.07% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ❌ 1/7 / P ✅ 0/7 / T ❌ 1/3 | 945.56 ± 198.43 | 96.00 ± 0.00 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 30.6% ± 14.1% | 30.2% ± 13.9% | 6/6 | +15.30% ± 21.35% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (87 samples) | +24.22% ± 28.58% ✅ | -1.18% ± 20.45% ❌ / +47.45% ± 49.76% ✅ / -1.12% ± 4.81% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 1/2 | 1240.73 ± 101.55 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 42.6% ± 11.1% | 41.2% ± 11.2% | 13/13 | +22.79% ± 12.83% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (257 samples) | +30.27% ± 16.49% ✅ | +8.36% ± 12.27% ✅ / +55.93% ± 26.28% ✅ / -5.78% ± 12.86% ❌ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 3/5 | 991.57 ± 113.36 | 96.00 ± 0.00 |
| `fused_rtl_state_pipeline_qd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 41.7% ± 11.2% | 41.2% ± 11.1% | 13/13 | +22.54% ± 12.35% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (257 samples) | +30.02% ± 16.16% ✅ | +8.98% ± 11.87% ✅ / +53.02% ± 27.25% ✅ / -1.76% ± 12.74% ❌ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 3/13 / P ❌ 1/13 / T ❌ 2/5 | 1081.79 ± 139.70 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 | +15.22% ✅ / +99.25% ✅ / N/A |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 9 | 0.0000 | 0 | +38.78% ✅ / +38.42% ✅ / +39.02% ✅ |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 6 | 2 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / +3.66% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 11 | 2 | 0.1449 | 8 | +36.96% ✅ / +46.33% ✅ / N/A |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1457 | 4 | +36.96% ✅ / +46.76% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0003 | 1 | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 2 | 0.0000 | 1 | +2.00% ✅ / +12.36% ✅ / +7.41% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3067 | 14 | +32.94% ✅ / +99.15% ✅ / N/A |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob041_traffic_light | 2 | 18 | 4 | 0.2427 | 14 | +26.47% ✅ / +99.09% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1904 | 9 | +19.19% ✅ / +99.19% ✅ / N/A |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob045_alu | 2 | 19 | 1 | 0.2161 | 19 | +21.80% ✅ / +99.13% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0128 | 3 | +22.34% ✅ / +46.04% ✅ / +16.28% ✅ |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.3975 | 5 | +40.00% ✅ / +99.41% ✅ / N/A |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.3984 | 5 | +40.00% ✅ / +99.61% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 5 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +98.91% ✅ / N/A |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 | +0.00% ➖ / +98.91% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 2 | 0.0000 | 0 | -46.97% ❌ / -51.23% ❌ / -3.57% ❌ |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 1 | 0.0000 | 0 | -34.85% ❌ / -48.10% ❌ / -3.57% ❌ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0002 | 1 | +5.85% ✅ / +33.41% ✅ / +9.33% ✅ |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 13 | 6 | 0.0003 | 2 | +9.72% ✅ / +32.72% ✅ / +9.33% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1152 ± 0.0863 | 2.71 ± 2.13 | 5.29 ± 3.82 | 5 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0663 ± 0.1298 | 1.83 ± 0.94 | 1.50 ± 1.50 | 4 |
| `fused_rtl_state_pipeline_qd` | RTLLM | 7 | 7 | 0.1093 ± 0.0777 | 2.00 ± 0.74 | 5.86 ± 5.57 | 2 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0665 ± 0.1301 | 1.83 ± 1.63 | 1.50 ± 1.50 | 2 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.0926 ± 0.0737 | 2.31 ± 1.20 | 3.54 ± 2.34 | 9 |
| `fused_rtl_state_pipeline_qd` | ALL | 13 | 13 | 0.0896 ± 0.0709 | 1.92 ± 0.81 | 3.85 ± 3.21 | 4 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 50.0% | 0.3815 | 0.3815 | 1/2 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 31.2% | 0.0047 | 0.0528 | 5/16 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob024_fsm | grid_quantile | 37.5% | 2.2880 | 0.5002 | 6/16 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 25.0% | 0.0516 | 0.0326 | 4/16 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 50.0% | 1.9672 | 0.4077 | 8/16 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob045_alu | grid_quantile | 43.8% | 2.6968 | 0.4031 | 7/16 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 75.0% | 0.7043 | 0.2348 | 3/4 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 100.0% | 0.4654 | 0.4654 | 1/1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 100.0% | 0.2636 | 0.2636 | 1/1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 100.0% | 0.3297 | 0.3297 | 1/1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 50.0% | 0.3873 | 0.1356 | 8/16 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob004_adder_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 34 | 1 | init=run_finalization_fallback, shape=1x2 | state_control_ratio | live warmup_buffered=34; replay duplicate_objectives=33, filled_empty=1 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob015_multi_pipe_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 13 | 8 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=5, filled_empty=1, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob024_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 25 | 9 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=16, filled_empty=2, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob037_parallel2serial | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 17 | 5 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=10, filled_empty=2, pareto_inserted=1, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob041_traffic_light | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 24 | 13 | init=warmup_complete, shape=4x4 | none | live crowding_evicted=4, duplicate_objectives=4, filled_empty=4, pareto_inserted=2, replaced_elite=6, warmup_buffered=4; replay filled_empty=4 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob045_alu | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 19 | 10 | init=warmup_complete, shape=4x4 | none | live crowding_evicted=2, filled_empty=3, pareto_inserted=7, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
| `fused_rtl_state_pipeline_qd` | RTLLM | Prob049_signal_generator | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 38 | 4 | init=run_finalization_fallback, shape=1x4 | state_control_ratio | live warmup_buffered=38; replay duplicate_objectives=34, filled_empty=3, pareto_inserted=1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 16 | 2 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=16; replay duplicate_objectives=14, filled_empty=1, replaced_elite=1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 18 | 2 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=18; replay crowding_evicted=4, duplicate_objectives=12, filled_empty=1, pareto_inserted=1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 25 | 2 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=25; replay crowding_evicted=4, duplicate_objectives=19, filled_empty=1, pareto_inserted=1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 6 | 1 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=6; replay duplicate_objectives=5, filled_empty=1 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 3 | 0 | init=pending | none | live warmup_buffered=3 |
| `fused_rtl_state_pipeline_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 19 | 12 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=6, filled_empty=4, pareto_inserted=3, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
