# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | unspecified | 120 | N/A | 240.08 ± 0.15 | 862167.92 ± 103246.56 | 240.08 | 240.08 |
| `classic` | RTLLM | unspecified | 120 | N/A | 240.14 ± 0.28 | 863141.43 ± 162897.46 | 240.14 | 240.14 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 861032.17 ± 135201.99 | 240.00 | 240.00 |
| `cvt_implemented_structural_fixed_5d` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 922662.85 ± 109204.02 | 240.00 | 240.00 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 911801.57 ± 178383.98 | 240.00 | 240.00 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 935334.33 ± 131279.85 | 240.00 | 240.00 |
| `cvt_large_struct10d` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 920035.85 ± 99729.62 | 240.00 | 240.00 |
| `cvt_large_struct10d` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 914413.86 ± 166161.64 | 240.00 | 240.00 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 926594.83 ± 114036.11 | 240.00 | 240.00 |
| `cvt_large_struct_size_control_13d` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 931592.38 ± 97379.86 | 240.00 | 240.00 |
| `cvt_large_struct_size_control_13d` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 908052.14 ± 153538.68 | 240.00 | 240.00 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 959056.00 ± 123412.93 | 240.00 | 240.00 |
| `cvt_size_control_3d` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 934433.15 ± 96440.39 | 240.00 | 240.00 |
| `cvt_size_control_3d` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 929341.43 ± 154380.72 | 240.00 | 240.00 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 940373.50 ± 122256.98 | 240.00 | 240.00 |
| `cvt_theory_grounded` | ALL | unspecified | 120 | N/A | 240.00 ± 0.00 | 904706.62 ± 88903.02 | 240.00 | 240.00 |
| `cvt_theory_grounded` | RTLLM | unspecified | 120 | N/A | 240.00 ± 0.00 | 896813.57 ± 144172.09 | 240.00 | 240.00 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 240.00 ± 0.00 | 913915.17 ± 108989.26 | 240.00 | 240.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (67.5%) | ✅ Pass (67.5%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 2649.59 | 240 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob004_adder_8bit | ✅ Pass (55.0%) | ✅ Pass (49.2%) | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 3317.40 | 240 |
| `cvt_large_struct10d` | RTLLM | Prob004_adder_8bit | ✅ Pass (72.5%) | ✅ Pass (62.5%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 2854.54 | 240 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob004_adder_8bit | ✅ Pass (69.2%) | ✅ Pass (50.8%) | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 3249.72 | 240 |
| `cvt_size_control_3d` | RTLLM | Prob004_adder_8bit | ✅ Pass (69.2%) | ✅ Pass (55.0%) | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 3192.98 | 240 |
| `cvt_theory_grounded` | RTLLM | Prob004_adder_8bit | ✅ Pass (66.7%) | ✅ Pass (51.7%) | +33.73% ✅ | +2.17% ✅ / +99.03% ✅ / N/A | +50.60% ✅ | 3033.09 | 240 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (35.8%) | ✅ Pass (34.2%) | +6.11% ✅ | +37.14% ✅ / +4.34% ✅ / -23.17% ❌ | +6.11% ✅ | 3106.77 | 241 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (40.8%) | ✅ Pass (35.0%) | +6.11% ✅ | +37.14% ✅ / +4.34% ✅ / -23.17% ❌ | +6.11% ✅ | 3741.61 | 240 |
| `cvt_large_struct10d` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (40.8%) | ✅ Pass (25.0%) | +11.68% ✅ | +31.94% ✅ / +23.83% ✅ / -20.73% ❌ | +11.68% ✅ | 3411.58 | 240 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (36.7%) | ✅ Pass (30.8%) | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 3140.12 | 240 |
| `cvt_size_control_3d` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (40.8%) | ✅ Pass (34.2%) | +7.17% ✅ | +38.78% ✅ / +5.90% ✅ / -23.17% ❌ | +7.17% ✅ | 3704.20 | 240 |
| `cvt_theory_grounded` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (38.3%) | ✅ Pass (29.2%) | +2.72% ✅ | +36.43% ✅ / -1.45% ❌ / -26.83% ❌ | +2.72% ✅ | 3526.61 | 240 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (39.2%) | ✅ Pass (35.8%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 2645.83 | 240 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob024_fsm | ✅ Pass (37.5%) | ✅ Pass (24.2%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 3055.19 | 240 |
| `cvt_large_struct10d` | RTLLM | Prob024_fsm | ✅ Pass (30.8%) | ✅ Pass (21.7%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 3148.30 | 240 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob024_fsm | ✅ Pass (46.7%) | ✅ Pass (30.8%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 3212.58 | 240 |
| `cvt_size_control_3d` | RTLLM | Prob024_fsm | ✅ Pass (54.2%) | ✅ Pass (31.7%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 3223.00 | 240 |
| `cvt_theory_grounded` | RTLLM | Prob024_fsm | ✅ Pass (43.3%) | ✅ Pass (25.8%) | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 3072.22 | 240 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (53.3%) | ✅ Pass (41.7%) | +17.70% ✅ | +14.00% ✅ / +24.28% ✅ / +14.81% ✅ | +17.70% ✅ | 2770.09 | 240 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob037_parallel2serial | ✅ Pass (11.7%) | ✅ Pass (11.7%) | N/A | N/A / N/A / N/A | N/A | 3458.37 | 240 |
| `cvt_large_struct10d` | RTLLM | Prob037_parallel2serial | ✅ Pass (10.0%) | ✅ Pass (10.0%) | N/A | N/A / N/A / N/A | N/A | 3424.02 | 240 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob037_parallel2serial | ✅ Pass (11.7%) | ✅ Pass (11.7%) | N/A | N/A / N/A / N/A | N/A | 3598.64 | 240 |
| `cvt_size_control_3d` | RTLLM | Prob037_parallel2serial | ✅ Pass (12.5%) | ✅ Pass (12.5%) | N/A | N/A / N/A / N/A | N/A | 3301.66 | 240 |
| `cvt_theory_grounded` | RTLLM | Prob037_parallel2serial | ✅ Pass (9.2%) | ✅ Pass (9.2%) | N/A | N/A / N/A / N/A | N/A | 3511.80 | 240 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (55.8%) | ✅ Pass (55.8%) | +46.67% ✅ | +41.18% ✅ / +98.84% ✅ / N/A | +70.01% ✅ | 3125.32 | 240 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob041_traffic_light | ✅ Pass (39.2%) | ✅ Pass (31.7%) | +40.38% ✅ | +22.35% ✅ / +98.79% ✅ / N/A | +60.57% ✅ | 3423.63 | 240 |
| `cvt_large_struct10d` | RTLLM | Prob041_traffic_light | ✅ Pass (60.0%) | ✅ Pass (50.8%) | +43.25% ✅ | +30.59% ✅ / +99.15% ✅ / N/A | +64.87% ✅ | 3394.02 | 240 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob041_traffic_light | ✅ Pass (54.2%) | ✅ Pass (41.7%) | +42.09% ✅ | +27.06% ✅ / +99.20% ✅ / N/A | +63.13% ✅ | 3533.65 | 240 |
| `cvt_size_control_3d` | RTLLM | Prob041_traffic_light | ✅ Pass (35.0%) | ✅ Pass (25.8%) | +45.21% ✅ | +36.47% ✅ / +99.15% ✅ / N/A | +67.81% ✅ | 3707.38 | 240 |
| `cvt_theory_grounded` | RTLLM | Prob041_traffic_light | ✅ Pass (46.7%) | ✅ Pass (38.3%) | +46.22% ✅ | +39.41% ✅ / +99.26% ✅ / N/A | +69.34% ✅ | 3457.29 | 240 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (55.8%) | ✅ Pass (55.8%) | +39.79% ✅ | +20.22% ✅ / +99.15% ✅ / N/A | +59.69% ✅ | 2954.87 | 240 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob045_alu | ✅ Pass (7.5%) | ✅ Pass (7.5%) | N/A | N/A / N/A / N/A | N/A | 3184.03 | 240 |
| `cvt_large_struct10d` | RTLLM | Prob045_alu | ✅ Pass (38.3%) | ✅ Pass (35.0%) | +13.47% ✅ | +18.65% ✅ / +21.75% ✅ / N/A | +20.20% ✅ | 3292.30 | 240 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob045_alu | ✅ Pass (12.5%) | ✅ Pass (12.5%) | N/A | N/A / N/A / N/A | N/A | 3226.31 | 240 |
| `cvt_size_control_3d` | RTLLM | Prob045_alu | ✅ Pass (15.0%) | ✅ Pass (14.2%) | +14.25% ✅ | +19.78% ✅ / +22.98% ✅ / N/A | +21.38% ✅ | 3280.88 | 240 |
| `cvt_theory_grounded` | RTLLM | Prob045_alu | ✅ Pass (13.3%) | ✅ Pass (13.3%) | +14.89% ✅ | +21.26% ✅ / +23.42% ✅ / N/A | +22.34% ✅ | 3183.32 | 240 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (54.2%) | ✅ Pass (54.2%) | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 2616.99 | 240 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob049_signal_generator | ✅ Pass (45.8%) | ✅ Pass (45.8%) | +26.03% ✅ | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ | +26.03% ✅ | 3334.81 | 240 |
| `cvt_large_struct10d` | RTLLM | Prob049_signal_generator | ✅ Pass (56.7%) | ✅ Pass (56.7%) | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 3642.42 | 240 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob049_signal_generator | ✅ Pass (37.5%) | ✅ Pass (37.5%) | +25.98% ✅ | +42.55% ✅ / +7.49% ✅ / +27.91% ✅ | +25.98% ✅ | 3671.01 | 240 |
| `cvt_size_control_3d` | RTLLM | Prob049_signal_generator | ✅ Pass (58.3%) | ✅ Pass (52.5%) | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 2832.57 | 240 |
| `cvt_theory_grounded` | RTLLM | Prob049_signal_generator | ✅ Pass (46.7%) | ✅ Pass (38.3%) | +25.98% ✅ | +42.55% ✅ / +7.49% ✅ / +27.91% ✅ | +25.98% ✅ | 3059.47 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (64.2%) | ✅ Pass (64.2%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 3100.81 | 240 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (37.5%) | ✅ Pass (37.5%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 3820.64 | 240 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (30.8%) | ✅ Pass (30.8%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 3728.42 | 240 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (13.3%) | ✅ Pass (13.3%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 3692.40 | 240 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (50.8%) | ✅ Pass (44.2%) | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 3701.70 | 240 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (18.3%) | ✅ Pass (18.3%) | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 3465.43 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (77.5%) | ✅ Pass (77.5%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 3198.98 | 240 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (19.2%) | ✅ Pass (19.2%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 3786.15 | 240 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (58.3%) | ✅ Pass (50.8%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 3555.39 | 240 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (68.3%) | ✅ Pass (60.8%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 3692.32 | 240 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (38.3%) | ✅ Pass (35.8%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 3888.71 | 240 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (45.0%) | ✅ Pass (40.0%) | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 3455.66 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (87.5%) | ✅ Pass (87.5%) | +3.50% ✅ | -20.00% ❌ / +30.49% ✅ / N/A | +5.25% ✅ | 2963.11 | 240 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (65.8%) | ✅ Pass (65.8%) | +33.10% ✅ | +0.00% ➖ / +99.31% ✅ / N/A | +49.66% ✅ | 3776.36 | 240 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (83.3%) | ✅ Pass (70.0%) | +19.61% ✅ | -40.00% ❌ / +98.84% ✅ / N/A | +29.42% ✅ | 3509.89 | 240 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (75.0%) | ✅ Pass (68.3%) | +3.50% ✅ | -20.00% ❌ / +30.49% ✅ / N/A | +5.25% ✅ | 3544.13 | 240 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (77.5%) | ✅ Pass (70.8%) | +3.50% ✅ | -20.00% ❌ / +30.49% ✅ / N/A | +5.25% ✅ | 3697.63 | 240 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (85.0%) | ✅ Pass (71.7%) | +12.26% ✅ | +0.00% ➖ / +36.77% ✅ / N/A | +18.39% ✅ | 3229.31 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (50.8%) | ✅ Pass (50.8%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 3045.93 | 240 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (41.7%) | ✅ Pass (41.7%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 3657.17 | 240 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (42.5%) | ✅ Pass (42.5%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 3682.59 | 240 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (55.0%) | ✅ Pass (42.5%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3498.24 | 240 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (58.3%) | ✅ Pass (40.0%) | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 3549.52 | 240 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (53.3%) | ✅ Pass (36.7%) | +0.10% ✅ | +0.00% ➖ / +0.29% ✅ / N/A | +0.15% ✅ | 3435.00 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (19.2%) | ✅ Pass (18.3%) | -12.94% ❌ | -10.61% ❌ / -46.09% ❌ / +17.86% ✅ | -12.94% ❌ | 3175.95 | 240 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (3.3%) | ✅ Pass (3.3%) | N/A | N/A / N/A / N/A | N/A | 3555.14 | 240 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (5.0%) | ✅ Pass (5.0%) | N/A | N/A / N/A / N/A | N/A | 3489.86 | 240 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (5.8%) | ✅ Pass (5.0%) | N/A | N/A / N/A / N/A | N/A | 3652.34 | 240 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (5.0%) | ✅ Pass (5.0%) | N/A | N/A / N/A / N/A | N/A | 3440.99 | 240 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (3.3%) | ✅ Pass (3.3%) | N/A | N/A / N/A / N/A | N/A | 3271.41 | 240 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (49.2%) | ✅ Pass (47.5%) | +14.92% ✅ | +10.05% ✅ / +32.04% ✅ / +2.67% ✅ | +14.92% ✅ | 3143.03 | 240 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (6.7%) | ✅ Pass (6.7%) | N/A | N/A / N/A / N/A | N/A | 3543.97 | 240 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (9.2%) | ✅ Pass (9.2%) | N/A | N/A / N/A / N/A | N/A | 3764.91 | 240 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (6.7%) | ✅ Pass (6.7%) | N/A | N/A / N/A / N/A | N/A | 3678.09 | 240 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (2.5%) | ✅ Pass (0.8%) | N/A | N/A / N/A / N/A | N/A | 3598.34 | 240 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (6.7%) | ✅ Pass (6.7%) | N/A | N/A / N/A / N/A | N/A | 3540.54 | 240 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 51.7% ± 8.0% | 49.3% ± 9.1% | 7/7 | +34.00% ± 15.05% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 | +41.27% ± 18.09% ✅ | +25.65% ± 12.58% ✅ / +63.26% ± 28.98% ✅ / +1.87% ± 24.54% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 2838.49 ± 164.08 | 240.14 ± 0.28 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 58.1% ± 19.4% | 57.6% ± 19.7% | 6/6 | +6.91% ± 13.00% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 | +10.20% ± 17.90% ✅ | +3.24% ± 16.59% ✅ / +14.06% ± 29.96% ✅ / +10.26% ± 14.89% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 3104.63 ± 70.63 | 240.00 ± 0.00 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 33.9% ± 13.1% | 29.3% ± 11.8% | 5/7 | +35.80% ± 19.91% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/7 | +41.89% ± 21.59% ✅ | +28.12% ± 12.16% ✅ / +63.93% ± 35.02% ✅ / -4.61% ± 36.38% ❌ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 3359.29 ± 161.65 | 240.00 ± 0.00 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 29.0% ± 19.1% | 29.0% ± 19.1% | 4/6 | +25.28% ± 16.47% ✅ | ✅ 4 / ➖ 0 / ❌ 0 | 4/6 | +37.92% ± 24.70% ✅ | +10.00% ± 19.60% ✅ / +65.85% ± 45.86% ✅ / N/A | ✅ 4 / ➖ 0 / ❌ 0 | A ✅ 0/4 / P ✅ 0/4 / T N/A | 3689.90 ± 97.58 | 240.00 ± 0.00 |
| `cvt_large_struct10d` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 44.2% ± 15.4% | 37.4% ± 14.6% | 6/7 | +32.69% ± 16.91% ✅ | ✅ 6 / ➖ 0 / ❌ 0 | 6/7 | +38.69% ± 17.74% ✅ | +24.69% ± 12.90% ✅ / +60.16% ± 28.05% ✅ / -3.39% ± 33.99% ❌ | ✅ 6 / ➖ 0 / ❌ 0 | A ✅ 0/6 / P ✅ 0/6 / T ❌ 1/2 | 3309.60 ± 185.15 | 240.00 ± 0.00 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 38.2% ± 23.9% | 34.7% ± 20.0% | 4/6 | +21.91% ± 15.73% ✅ | ✅ 4 / ➖ 0 / ❌ 0 | 4/6 | +32.87% ± 23.59% ✅ | +0.00% ± 32.01% ➖ / +65.73% ± 45.75% ✅ / N/A | ✅ 4 / ➖ 0 / ❌ 0 | A ❌ 1/4 / P ✅ 0/4 / T N/A | 3621.84 ± 94.60 | 240.00 ± 0.00 |
| `cvt_large_struct_size_control_13d` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 38.3% ± 15.6% | 30.8% ± 10.8% | 5/7 | +35.97% ± 20.24% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | 5/7 | +42.23% ± 22.31% ✅ | +34.29% ± 11.49% ✅ / +55.97% ± 41.96% ✅ / +1.15% ± 52.45% ✅ | ✅ 5 / ➖ 0 / ❌ 0 | A ✅ 0/5 / P ✅ 0/5 / T ❌ 1/2 | 3376.00 ± 160.65 | 240.00 ± 0.00 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 37.4% ± 25.8% | 32.8% ± 22.6% | 4/6 | +9.84% ± 16.29% ✅ | ✅ 3 / ➖ 1 / ❌ 0 | 4/6 | +14.77% ± 24.43% ✅ | +5.00% ± 24.66% ✅ / +24.53% ± 29.05% ✅ / N/A | ✅ 3 / ➖ 1 / ❌ 0 | A ❌ 1/4 / P ✅ 0/4 / T N/A | 3626.25 ± 67.18 | 240.00 ± 0.00 |
| `cvt_size_control_3d` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 40.7% ± 16.0% | 32.3% ± 12.4% | 6/7 | +32.39% ± 17.74% ✅ | ✅ 6 / ➖ 0 / ❌ 0 | 6/7 | +38.62% ± 19.08% ✅ | +27.00% ± 13.88% ✅ / +57.38% ± 31.25% ✅ / -4.61% ± 36.38% ❌ | ✅ 6 / ➖ 0 / ❌ 0 | A ✅ 0/6 / P ✅ 0/6 / T ❌ 1/2 | 3320.38 ± 226.86 | 240.00 ± 0.00 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 38.7% ± 24.0% | 32.8% ± 21.0% | 4/6 | +17.86% ± 18.29% ✅ | ✅ 3 / ➖ 1 / ❌ 0 | 4/6 | +26.79% ± 27.44% ✅ | +5.00% ± 24.66% ✅ / +48.57% ± 42.13% ✅ / N/A | ✅ 3 / ➖ 1 / ❌ 0 | A ❌ 1/4 / P ✅ 0/4 / T N/A | 3646.15 ± 123.07 | 240.00 ± 0.00 |
| `cvt_theory_grounded` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 37.7% ± 14.9% | 29.4% ± 11.1% | 6/7 | +31.98% ± 18.64% ✅ | ✅ 6 / ➖ 0 / ❌ 0 | 6/7 | +38.42% ± 20.36% ✅ | +31.61% ± 13.58% ✅ / +49.83% ± 36.56% ✅ / +0.54% ± 53.64% ✅ | ✅ 6 / ➖ 0 / ❌ 0 | A ✅ 0/6 / P ❌ 1/6 / T ❌ 1/2 | 3263.40 ± 167.34 | 240.00 ± 0.00 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 35.3% ± 25.4% | 29.4% ± 20.5% | 4/6 | +12.06% ± 15.73% ✅ | ✅ 4 / ➖ 0 / ❌ 0 | 4/6 | +18.09% ± 23.59% ✅ | +10.00% ± 19.60% ✅ / +26.18% ± 29.54% ✅ / N/A | ✅ 4 / ➖ 0 / ❌ 0 | A ✅ 0/4 / P ✅ 0/4 / T N/A | 3399.56 ± 97.36 | 240.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 54.6% ± 9.6% | 53.1% ± 10.1% | 13/13 | +21.50% ± 12.32% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 | +26.93% ± 15.05% ✅ | +15.30% ± 11.64% ✅ / +40.56% ± 24.31% ✅ / +5.22% ± 14.80% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 1/5 | 2961.33 ± 117.65 | 240.08 ± 0.15 |
| `cvt_implemented_structural_fixed_5d` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 31.7% ± 10.9% | 29.2% ± 10.4% | 9/13 | +31.13% ± 12.98% ✅ | ✅ 9 / ➖ 0 / ❌ 0 | 9/13 | +40.13% ± 15.27% ✅ | +20.07% ± 12.00% ✅ / +64.78% ± 26.30% ✅ / -4.61% ± 36.38% ❌ | ✅ 9 / ➖ 0 / ❌ 0 | A ✅ 0/9 / P ✅ 0/9 / T ❌ 1/2 | 3511.88 ± 132.52 | 240.00 ± 0.00 |
| `cvt_large_struct10d` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 41.4% ± 13.3% | 36.2% ± 11.6% | 10/13 | +28.38% ± 11.84% ✅ | ✅ 10 / ➖ 0 / ❌ 0 | 10/13 | +36.36% ± 13.51% ✅ | +14.82% ± 15.95% ✅ / +62.39% ± 23.33% ✅ / -3.39% ± 33.99% ❌ | ✅ 10 / ➖ 0 / ❌ 0 | A ❌ 1/10 / P ✅ 0/10 / T ❌ 1/2 | 3453.71 ± 136.77 | 240.00 ± 0.00 |
| `cvt_large_struct_size_control_13d` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 37.9% ± 13.9% | 31.7% ± 11.4% | 9/13 | +24.36% ± 15.46% ✅ | ✅ 8 / ➖ 1 / ❌ 0 | 9/13 | +30.02% ± 18.09% ✅ | +21.27% ± 15.48% ✅ / +42.00% ± 27.33% ✅ / +1.15% ± 52.45% ✅ | ✅ 8 / ➖ 1 / ❌ 0 | A ❌ 1/9 / P ✅ 0/9 / T ❌ 1/2 | 3491.50 ± 113.13 | 240.00 ± 0.00 |
| `cvt_size_control_3d` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 39.8% ± 13.4% | 32.5% ± 11.2% | 10/13 | +26.58% ± 13.08% ✅ | ✅ 9 / ➖ 1 / ❌ 0 | 10/13 | +33.89% ± 15.37% ✅ | +18.20% ± 13.96% ✅ / +53.85% ± 23.88% ✅ / -4.61% ± 36.38% ❌ | ✅ 9 / ➖ 1 / ❌ 0 | A ❌ 1/10 / P ✅ 0/10 / T ❌ 1/2 | 3470.73 ± 158.78 | 240.00 ± 0.00 |
| `cvt_theory_grounded` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 36.6% ± 13.6% | 29.4% ± 10.7% | 10/13 | +24.01% ± 13.76% ✅ | ✅ 10 / ➖ 0 / ❌ 0 | 10/13 | +30.29% ± 15.96% ✅ | +22.97% ± 12.67% ✅ / +40.37% ± 24.89% ✅ / +0.54% ± 53.64% ✅ | ✅ 10 / ➖ 0 / ❌ 0 | A ✅ 0/10 / P ❌ 1/10 / T ❌ 1/2 | 3326.24 ± 104.10 | 240.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 81 | 40 | 0.0410 | 40 | +15.22% ✅ / +98.97% ✅ / N/A |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob004_adder_8bit | 2 | 59 | 3 | 0.1510 | 36 | +15.22% ✅ / +99.25% ✅ / N/A |
| `cvt_large_struct10d` | RTLLM | Prob004_adder_8bit | 2 | 75 | 37 | 0.0410 | 38 | +15.22% ✅ / +98.97% ✅ / N/A |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob004_adder_8bit | 2 | 61 | 3 | 0.1510 | 36 | +15.22% ✅ / +99.25% ✅ / N/A |
| `cvt_size_control_3d` | RTLLM | Prob004_adder_8bit | 2 | 66 | 32 | 0.0410 | 33 | +15.22% ✅ / +98.97% ✅ / N/A |
| `cvt_theory_grounded` | RTLLM | Prob004_adder_8bit | 2 | 14 | 2 | 0.0566 | 3 | +15.22% ✅ / +99.03% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 41 | 16 | 0.0000 | 0 | +38.78% ✅ / +4.34% ✅ / +40.24% ✅ |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob015_multi_pipe_8bit | 3 | 42 | 11 | 0.0000 | 0 | +38.27% ✅ / +4.34% ✅ / +40.24% ✅ |
| `cvt_large_struct10d` | RTLLM | Prob015_multi_pipe_8bit | 3 | 30 | 10 | 0.0000 | 0 | +36.43% ✅ / +25.95% ✅ / +36.59% ✅ |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob015_multi_pipe_8bit | 3 | 37 | 12 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / +39.02% ✅ |
| `cvt_size_control_3d` | RTLLM | Prob015_multi_pipe_8bit | 3 | 41 | 9 | 0.0000 | 0 | +38.78% ✅ / +14.03% ✅ / +31.71% ✅ |
| `cvt_theory_grounded` | RTLLM | Prob015_multi_pipe_8bit | 3 | 25 | 9 | 0.0000 | 0 | +36.43% ✅ / -1.45% ❌ / +41.46% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 43 | 2 | 0.3406 | 31 | +47.83% ✅ / +71.22% ✅ / N/A |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob024_fsm | 2 | 29 | 2 | 0.3406 | 14 | +47.83% ✅ / +71.22% ✅ / N/A |
| `cvt_large_struct10d` | RTLLM | Prob024_fsm | 2 | 26 | 1 | 0.3406 | 18 | +47.83% ✅ / +71.22% ✅ / N/A |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob024_fsm | 2 | 37 | 2 | 0.3406 | 19 | +47.83% ✅ / +71.22% ✅ / N/A |
| `cvt_size_control_3d` | RTLLM | Prob024_fsm | 2 | 38 | 1 | 0.3406 | 23 | +47.83% ✅ / +71.22% ✅ / N/A |
| `cvt_theory_grounded` | RTLLM | Prob024_fsm | 2 | 15 | 1 | 0.3406 | 8 | +47.83% ✅ / +71.22% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 50 | 1 | 0.0050 | 14 | +14.00% ✅ / +24.28% ✅ / +14.81% ✅ |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob037_parallel2serial | 3 | 14 | 1 | 0.0003 | 1 | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `cvt_large_struct10d` | RTLLM | Prob037_parallel2serial | 3 | 12 | 11 | 0.0000 | 0 | +0.00% ➖ / +22.30% ✅ / +3.70% ✅ |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob037_parallel2serial | 3 | 14 | 14 | 0.0000 | 0 | +0.00% ➖ / +11.92% ✅ / +3.70% ✅ |
| `cvt_size_control_3d` | RTLLM | Prob037_parallel2serial | 3 | 15 | 14 | 0.0000 | 0 | +0.00% ➖ / +12.36% ✅ / +11.11% ✅ |
| `cvt_theory_grounded` | RTLLM | Prob037_parallel2serial | 3 | 2 | 2 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +3.70% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 67 | 13 | 0.4130 | 61 | +42.35% ✅ / +99.20% ✅ / N/A |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob041_traffic_light | 2 | 38 | 4 | 0.2963 | 28 | +32.94% ✅ / +99.09% ✅ / N/A |
| `cvt_large_struct10d` | RTLLM | Prob041_traffic_light | 2 | 61 | 4 | 0.3553 | 49 | +37.65% ✅ / +99.20% ✅ / N/A |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob041_traffic_light | 2 | 50 | 6 | 0.2925 | 42 | +32.94% ✅ / +99.20% ✅ / N/A |
| `cvt_size_control_3d` | RTLLM | Prob041_traffic_light | 2 | 31 | 1 | 0.3616 | 24 | +36.47% ✅ / +99.15% ✅ / N/A |
| `cvt_theory_grounded` | RTLLM | Prob041_traffic_light | 2 | 38 | 1 | 0.3912 | 27 | +39.41% ✅ / +99.26% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 67 | 4 | 0.2080 | 67 | +23.33% ✅ / +99.15% ✅ / N/A |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.0453 | 9 | +19.96% ✅ / +22.72% ✅ / N/A |
| `cvt_large_struct10d` | RTLLM | Prob045_alu | 2 | 42 | 2 | 0.0417 | 42 | +19.42% ✅ / +21.75% ✅ / N/A |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob045_alu | 2 | 15 | 2 | 0.0408 | 15 | +18.97% ✅ / +21.67% ✅ / N/A |
| `cvt_size_control_3d` | RTLLM | Prob045_alu | 2 | 17 | 2 | 0.0485 | 17 | +21.30% ✅ / +22.98% ✅ / N/A |
| `cvt_theory_grounded` | RTLLM | Prob045_alu | 2 | 15 | 1 | 0.0498 | 15 | +21.26% ✅ / +23.42% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 65 | 8 | 0.0217 | 59 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob049_signal_generator | 3 | 55 | 9 | 0.0186 | 54 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `cvt_large_struct10d` | RTLLM | Prob049_signal_generator | 3 | 68 | 7 | 0.0192 | 66 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob049_signal_generator | 3 | 45 | 41 | 0.0170 | 43 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `cvt_size_control_3d` | RTLLM | Prob049_signal_generator | 3 | 63 | 4 | 0.0192 | 55 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `cvt_theory_grounded` | RTLLM | Prob049_signal_generator | 3 | 8 | 3 | 0.0170 | 4 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 77 | 32 | 0.0000 | 32 | +0.00% ➖ / +3.60% ✅ / N/A |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 45 | 1 | 0.0000 | 18 | +0.00% ➖ / +99.75% ✅ / N/A |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 37 | 3 | 0.0000 | 22 | +0.00% ➖ / +99.75% ✅ / N/A |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 16 | 7 | 0.0000 | 7 | +0.00% ➖ / +3.60% ✅ / N/A |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 53 | 3 | 0.0000 | 22 | +0.00% ➖ / +99.75% ✅ / N/A |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 93 | 52 | 0.2562 | 93 | +40.00% ✅ / +64.04% ✅ / N/A |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 23 | 5 | 0.2562 | 23 | +40.00% ✅ / +64.04% ✅ / N/A |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 61 | 18 | 0.2562 | 60 | +40.00% ✅ / +64.04% ✅ / N/A |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 73 | 21 | 0.2562 | 72 | +40.00% ✅ / +64.04% ✅ / N/A |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 43 | 3 | 0.2562 | 39 | +40.00% ✅ / +99.16% ✅ / N/A |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 11 | 1 | 0.2562 | 11 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 105 | 2 | 0.0000 | 0 | -20.00% ❌ / +30.49% ✅ / N/A |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 79 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.31% ✅ / N/A |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 84 | 24 | 0.0717 | 21 | +20.00% ✅ / +98.84% ✅ / N/A |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 82 | 4 | 0.0000 | 0 | -20.00% ❌ / +30.49% ✅ / N/A |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 85 | 6 | 0.0000 | 0 | -20.00% ❌ / +30.49% ✅ / N/A |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 4 | 1 | 0.0000 | 1 | +0.00% ➖ / +36.77% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 61 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 50 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 51 | 2 | 0.0000 | 2 | +0.00% ➖ / +0.29% ✅ / N/A |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 51 | 43 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 48 | 44 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 5 | 1 | 0.0000 | 1 | +0.00% ➖ / +0.29% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 22 | 6 | 0.0000 | 0 | -10.61% ❌ / -45.19% ❌ / +25.00% ✅ |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 4 | 2 | 0.0000 | 0 | -25.76% ❌ / -47.20% ❌ / +14.29% ✅ |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 6 | 3 | 0.0000 | 0 | -22.73% ❌ / -44.74% ❌ / +25.00% ✅ |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 6 | 2 | 0.0000 | 0 | -4.55% ❌ / -50.11% ❌ / +35.71% ✅ |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 6 | 2 | 0.0000 | 0 | -21.21% ❌ / -47.43% ❌ / +14.29% ✅ |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 4 | 2 | 0.0000 | 0 | -4.55% ❌ / -53.69% ❌ / +35.71% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 57 | 5 | 0.0009 | 4 | +10.05% ✅ / +32.27% ✅ / +12.00% ✅ |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 3 | 0.0019 | 4 | +7.77% ✅ / +31.58% ✅ / +13.33% ✅ |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 2 | 0.0017 | 5 | +8.93% ✅ / +32.72% ✅ / +6.67% ✅ |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 5 | 0.0003 | 4 | +7.77% ✅ / +31.58% ✅ / +4.00% ✅ |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 1 | 1 | 0.0000 | 1 | +10.48% ✅ / +35.24% ✅ / +0.00% ➖ |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 6 | 1 | 0.0034 | 2 | +9.36% ✅ / +33.64% ✅ / +10.67% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1470 ± 0.1285 | 12.00 ± 10.04 | 38.86 ± 18.84 | 6 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0428 ± 0.0836 | 16.33 ± 16.76 | 21.67 ± 29.67 | 3 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | 7 | 7 | 0.1218 ± 0.1070 | 4.43 ± 2.96 | 20.29 ± 14.80 | 1 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0430 ± 0.0836 | 2.17 ± 1.28 | 8.00 ± 7.92 | 0 |
| `cvt_large_struct10d` | RTLLM | 7 | 7 | 0.1140 ± 0.1191 | 10.29 ± 9.17 | 30.43 ± 18.66 | 0 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0549 ± 0.0821 | 8.67 ± 7.80 | 18.33 ± 18.03 | 1 |
| `cvt_large_struct_size_control_13d` | RTLLM | 7 | 7 | 0.1203 ± 0.1070 | 11.43 ± 10.30 | 22.14 ± 13.74 | 0 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0427 ± 0.0837 | 13.67 ± 12.72 | 13.83 ± 22.92 | 0 |
| `cvt_size_control_3d` | RTLLM | 7 | 7 | 0.1158 ± 0.1199 | 9.00 ± 8.32 | 21.71 ± 14.21 | 0 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0427 ± 0.0837 | 9.83 ± 13.46 | 10.33 ± 13.22 | 1 |
| `cvt_theory_grounded` | RTLLM | 7 | 7 | 0.1222 ± 0.1249 | 2.71 ± 2.13 | 8.14 ± 7.28 | 0 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0433 ± 0.0835 | 1.17 ± 0.33 | 2.67 ± 3.31 | 1 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.0989 ± 0.0816 | 14.00 ± 9.09 | 30.92 ± 16.98 | 9 |
| `cvt_implemented_structural_fixed_5d` | ALL | 13 | 13 | 0.0854 ± 0.0702 | 3.38 ± 1.76 | 14.62 ± 9.11 | 1 |
| `cvt_large_struct10d` | ALL | 13 | 13 | 0.0867 ± 0.0734 | 9.54 ± 5.88 | 24.85 ± 12.96 | 1 |
| `cvt_large_struct_size_control_13d` | ALL | 13 | 13 | 0.0845 ± 0.0700 | 12.46 ± 7.75 | 18.31 ± 12.54 | 0 |
| `cvt_size_control_3d` | ALL | 13 | 13 | 0.0821 ± 0.0751 | 9.38 ± 7.32 | 16.46 ± 9.91 | 1 |
| `cvt_theory_grounded` | ALL | 13 | 13 | 0.0858 ± 0.0777 | 2.00 ± 1.20 | 5.62 ± 4.33 | 1 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob004_adder_8bit | cvt | 31.2% | 0.7747 | 0.3815 | 5/16 |
| `cvt_large_struct10d` | RTLLM | Prob004_adder_8bit | cvt | 37.5% | 0.3249 | 0.3299 | 6/16 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob004_adder_8bit | cvt | 68.8% | 1.9583 | 0.3815 | 11/16 |
| `cvt_size_control_3d` | RTLLM | Prob004_adder_8bit | cvt | 50.0% | 1.7994 | 0.3299 | 8/16 |
| `cvt_theory_grounded` | RTLLM | Prob004_adder_8bit | cvt | 56.2% | 2.2169 | 0.3373 | 9/16 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob015_multi_pipe_8bit | cvt | 50.0% | -1.7876 | 0.0611 | 8/16 |
| `cvt_large_struct10d` | RTLLM | Prob015_multi_pipe_8bit | cvt | 50.0% | -0.0946 | 0.1168 | 8/16 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob015_multi_pipe_8bit | cvt | 68.8% | -1.5636 | 0.0528 | 11/16 |
| `cvt_size_control_3d` | RTLLM | Prob015_multi_pipe_8bit | cvt | 62.5% | -0.9419 | 0.0717 | 10/16 |
| `cvt_theory_grounded` | RTLLM | Prob015_multi_pipe_8bit | cvt | 75.0% | -0.6936 | 0.0272 | 12/16 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob024_fsm | cvt | 50.0% | 3.2913 | 0.6835 | 8/16 |
| `cvt_large_struct10d` | RTLLM | Prob024_fsm | cvt | 50.0% | 3.3089 | 0.6835 | 8/16 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob024_fsm | cvt | 56.2% | 3.7432 | 0.6835 | 9/16 |
| `cvt_size_control_3d` | RTLLM | Prob024_fsm | cvt | 50.0% | 3.9024 | 0.6835 | 8/16 |
| `cvt_theory_grounded` | RTLLM | Prob024_fsm | cvt | 37.5% | 3.0311 | 0.6835 | 6/16 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob037_parallel2serial | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_large_struct10d` | RTLLM | Prob037_parallel2serial | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob037_parallel2serial | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_size_control_3d` | RTLLM | Prob037_parallel2serial | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_theory_grounded` | RTLLM | Prob037_parallel2serial | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob041_traffic_light | cvt | 68.8% | 2.4316 | 0.4038 | 11/16 |
| `cvt_large_struct10d` | RTLLM | Prob041_traffic_light | cvt | 62.5% | 2.6021 | 0.4325 | 10/16 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob041_traffic_light | cvt | 75.0% | 3.1372 | 0.4209 | 12/16 |
| `cvt_size_control_3d` | RTLLM | Prob041_traffic_light | cvt | 43.8% | 1.7246 | 0.4521 | 7/16 |
| `cvt_theory_grounded` | RTLLM | Prob041_traffic_light | cvt | 75.0% | 3.1375 | 0.4622 | 12/16 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob045_alu | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_large_struct10d` | RTLLM | Prob045_alu | cvt | 62.5% | 1.0723 | 0.1347 | 10/16 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob045_alu | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_size_control_3d` | RTLLM | Prob045_alu | cvt | 37.5% | 0.6417 | 0.1425 | 6/16 |
| `cvt_theory_grounded` | RTLLM | Prob045_alu | cvt | 81.2% | 1.2795 | 0.1489 | 13/16 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob049_signal_generator | cvt | 25.0% | 0.4136 | 0.2603 | 4/16 |
| `cvt_large_struct10d` | RTLLM | Prob049_signal_generator | cvt | 25.0% | 0.7296 | 0.2638 | 4/16 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob049_signal_generator | cvt | 18.8% | 0.7021 | 0.2598 | 3/16 |
| `cvt_size_control_3d` | RTLLM | Prob049_signal_generator | cvt | 31.2% | 1.2010 | 0.2638 | 5/16 |
| `cvt_theory_grounded` | RTLLM | Prob049_signal_generator | cvt | 43.8% | 1.0146 | 0.2598 | 7/16 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | cvt | 12.5% | 0.3325 | 0.3325 | 2/16 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | cvt | 18.8% | 0.3445 | 0.3325 | 3/16 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | cvt | 12.5% | 0.0120 | 0.0120 | 2/16 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | cvt | 25.0% | 0.9974 | 0.3325 | 4/16 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | cvt | 31.2% | -0.0660 | 0.0120 | 5/16 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | cvt | 12.5% | 0.4601 | 0.3468 | 2/16 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | cvt | 25.0% | 0.4428 | 0.3468 | 4/16 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | cvt | 37.5% | 1.3558 | 0.3468 | 6/16 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | cvt | 43.8% | 1.2241 | 0.3468 | 7/16 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | cvt | 37.5% | 1.6014 | 0.3468 | 6/16 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | cvt | 12.5% | 0.5947 | 0.3310 | 2/16 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | cvt | 25.0% | 0.1645 | 0.1961 | 4/16 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | cvt | 31.2% | -0.3022 | 0.0350 | 5/16 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | cvt | 25.0% | -0.0036 | 0.0350 | 4/16 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | cvt | 56.2% | -0.4583 | 0.1226 | 9/16 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | cvt | 18.8% | -3.1333 | 0.0010 | 3/16 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | cvt | 18.8% | -2.9545 | 0.0010 | 3/16 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | cvt | 31.2% | -1.5710 | -0.0000 | 5/16 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | cvt | 31.2% | -1.0263 | -0.0000 | 5/16 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | cvt | 37.5% | -1.6235 | 0.0010 | 6/16 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob153_gshare | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob153_gshare | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob153_gshare | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob153_gshare | cvt | 0.0% | 0.0000 | N/A | 0/16 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob153_gshare | cvt | 0.0% | 0.0000 | N/A | 0/16 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob004_adder_8bit | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 59 | 5 | seq_ratio, comb_ratio | filled_empty=2, not_inserted=41, replaced_elite=1, warmup_buffered=15 |
| `cvt_large_struct10d` | RTLLM | Prob004_adder_8bit | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A | 75 | 6 | sequential_cells, seq_ratio | filled_empty=2, not_inserted=57, replaced_elite=1, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob004_adder_8bit | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A | 61 | 11 | sequential_cells, mux_ratio, mux_cells, seq_ratio | filled_empty=3, not_inserted=39, replaced_elite=4, warmup_buffered=15 |
| `cvt_size_control_3d` | RTLLM | Prob004_adder_8bit | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 66 | 8 | none | filled_empty=3, not_inserted=43, replaced_elite=5, warmup_buffered=15 |
| `cvt_theory_grounded` | RTLLM | Prob004_adder_8bit | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 62 | 9 | none | filled_empty=3, not_inserted=42, replaced_elite=2, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob015_multi_pipe_8bit | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 42 | 8 | none | filled_empty=2, not_inserted=18, replaced_elite=7, warmup_buffered=15 |
| `cvt_large_struct10d` | RTLLM | Prob015_multi_pipe_8bit | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A, g_T | 30 | 8 | none | filled_empty=3, not_inserted=8, replaced_elite=4, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob015_multi_pipe_8bit | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A, g_T | 37 | 11 | none | filled_empty=3, not_inserted=11, replaced_elite=8, warmup_buffered=15 |
| `cvt_size_control_3d` | RTLLM | Prob015_multi_pipe_8bit | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 41 | 10 | none | filled_empty=3, not_inserted=16, replaced_elite=7, warmup_buffered=15 |
| `cvt_theory_grounded` | RTLLM | Prob015_multi_pipe_8bit | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 35 | 12 | scoap_cc0_bin_2_pct, scoap_co_bin_2_pct | filled_empty=1, not_inserted=14, replaced_elite=5, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob024_fsm | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 29 | 8 | adder_ratio | filled_empty=2, not_inserted=8, replaced_elite=4, warmup_buffered=15 |
| `cvt_large_struct10d` | RTLLM | Prob024_fsm | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A | 26 | 8 | adder_ratio, arithmetic_cells | filled_empty=2, not_inserted=9, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob024_fsm | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A | 37 | 9 | adder_ratio, arithmetic_cells | filled_empty=2, not_inserted=17, replaced_elite=3, warmup_buffered=15 |
| `cvt_size_control_3d` | RTLLM | Prob024_fsm | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 38 | 8 | none | filled_empty=3, not_inserted=16, replaced_elite=4, warmup_buffered=15 |
| `cvt_theory_grounded` | RTLLM | Prob024_fsm | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 31 | 6 | scoap_cc0_bin_3_pct | not_inserted=14, replaced_elite=2, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob037_parallel2serial | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 14 | 0 | none | warmup_buffered=14 |
| `cvt_large_struct10d` | RTLLM | Prob037_parallel2serial | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A, g_T | 12 | 0 | none | warmup_buffered=12 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob037_parallel2serial | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A, g_T | 14 | 0 | none | warmup_buffered=14 |
| `cvt_size_control_3d` | RTLLM | Prob037_parallel2serial | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 15 | 0 | none | warmup_buffered=15 |
| `cvt_theory_grounded` | RTLLM | Prob037_parallel2serial | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 11 | 0 | none | warmup_buffered=11 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob041_traffic_light | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 38 | 11 | none | filled_empty=4, not_inserted=12, replaced_elite=7, warmup_buffered=15 |
| `cvt_large_struct10d` | RTLLM | Prob041_traffic_light | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A | 61 | 10 | none | filled_empty=3, not_inserted=33, replaced_elite=10, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob041_traffic_light | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A | 50 | 12 | none | filled_empty=3, not_inserted=24, replaced_elite=8, warmup_buffered=15 |
| `cvt_size_control_3d` | RTLLM | Prob041_traffic_light | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 31 | 7 | none | filled_empty=2, not_inserted=8, replaced_elite=6, warmup_buffered=15 |
| `cvt_theory_grounded` | RTLLM | Prob041_traffic_light | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 46 | 12 | reconv_sink_ratio | filled_empty=3, not_inserted=20, replaced_elite=8, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob045_alu | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 9 | 0 | none | warmup_buffered=9 |
| `cvt_large_struct10d` | RTLLM | Prob045_alu | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A | 42 | 10 | sequential_cells, seq_ratio | filled_empty=2, not_inserted=18, replaced_elite=7, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob045_alu | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A | 15 | 0 | none | warmup_buffered=15 |
| `cvt_size_control_3d` | RTLLM | Prob045_alu | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 17 | 6 | ctrl_depth_est | replaced_elite=2, warmup_buffered=15 |
| `cvt_theory_grounded` | RTLLM | Prob045_alu | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 16 | 13 | none | not_inserted=1, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | RTLLM | Prob049_signal_generator | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 55 | 4 | none | filled_empty=3, not_inserted=36, replaced_elite=1, warmup_buffered=15 |
| `cvt_large_struct10d` | RTLLM | Prob049_signal_generator | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A, g_T | 68 | 4 | mux_ratio, mux_cells | filled_empty=3, not_inserted=49, replaced_elite=1, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | RTLLM | Prob049_signal_generator | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A, g_T | 45 | 3 | sequential_cells, mux_ratio, mux_cells | filled_empty=2, not_inserted=28, warmup_buffered=15 |
| `cvt_size_control_3d` | RTLLM | Prob049_signal_generator | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 63 | 5 | none | filled_empty=3, not_inserted=42, replaced_elite=3, warmup_buffered=15 |
| `cvt_theory_grounded` | RTLLM | Prob049_signal_generator | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 46 | 7 | none | filled_empty=4, not_inserted=27, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 45 | 2 | mux_ratio, adder_ratio | not_inserted=29, replaced_elite=1, warmup_buffered=15 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A | 37 | 3 | sequential_cells, mux_ratio, mux_cells, adder_ratio, arithmetic_cells, g_A | not_inserted=22, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A | 16 | 2 | sequential_cells, mux_ratio, mux_cells, adder_ratio, arithmetic_cells, ctrl_depth_est, g_A | not_inserted=1, warmup_buffered=15 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 53 | 4 | none | filled_empty=2, not_inserted=34, replaced_elite=2, warmup_buffered=15 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 22 | 5 | rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct | filled_empty=2, not_inserted=5, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 23 | 2 | seq_ratio, comb_ratio, adder_ratio, cell_count_log | not_inserted=8, warmup_buffered=15 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A | 61 | 4 | sequential_cells, adder_ratio, seq_ratio, arithmetic_cells | not_inserted=45, replaced_elite=1, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A | 73 | 6 | sequential_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est | filled_empty=1, not_inserted=55, replaced_elite=2, warmup_buffered=15 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 43 | 7 | none | filled_empty=4, not_inserted=21, replaced_elite=3, warmup_buffered=15 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 48 | 6 | reconv_source_ratio, reconv_sink_ratio | filled_empty=1, not_inserted=30, replaced_elite=2, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 79 | 2 | seq_ratio, comb_ratio, mux_ratio, adder_ratio | filled_empty=1, not_inserted=60, replaced_elite=3, warmup_buffered=15 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A | 84 | 4 | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells | filled_empty=1, not_inserted=68, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A | 82 | 5 | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells | filled_empty=1, not_inserted=66, warmup_buffered=15 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 85 | 4 | none | filled_empty=2, not_inserted=66, replaced_elite=2, warmup_buffered=15 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 86 | 9 | none | filled_empty=5, not_inserted=64, replaced_elite=2, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 50 | 3 | seq_ratio, comb_ratio, mux_ratio, adder_ratio | filled_empty=1, not_inserted=33, replaced_elite=1, warmup_buffered=15 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A | 51 | 3 | sequential_cells, adder_ratio, seq_ratio, arithmetic_cells | filled_empty=1, not_inserted=35, warmup_buffered=15 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A | 51 | 5 | sequential_cells, adder_ratio, seq_ratio, arithmetic_cells | filled_empty=1, not_inserted=33, replaced_elite=2, warmup_buffered=15 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 48 | 5 | none | filled_empty=1, not_inserted=31, replaced_elite=1, warmup_buffered=15 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 44 | 6 | scoap_cc1_bin_3_pct, laplacian_lambda2 | filled_empty=3, not_inserted=25, replaced_elite=1, warmup_buffered=15 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 4 | 0 | none | warmup_buffered=4 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A, g_T | 6 | 0 | none | warmup_buffered=6 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A, g_T | 6 | 0 | none | warmup_buffered=6 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 6 | 0 | none | warmup_buffered=6 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 4 | 0 | none | warmup_buffered=4 |
| `cvt_implemented_structural_fixed_5d` | VerilogEval-Spec-to-RTL | Prob153_gshare | implemented_structural_fixed_5d | seq_ratio, comb_ratio, mux_ratio, adder_ratio, cell_count_log | 8 | 0 | none | warmup_buffered=8 |
| `cvt_large_struct10d` | VerilogEval-Spec-to-RTL | Prob153_gshare | large_struct10d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, g_P, g_A, g_T | 11 | 0 | none | warmup_buffered=11 |
| `cvt_large_struct_size_control_13d` | VerilogEval-Spec-to-RTL | Prob153_gshare | large_struct_size_control_13d | sequential_cells, mux_ratio, mux_cells, adder_ratio, seq_ratio, arithmetic_cells, total_cells, wire_count_log_est, assign_count, ctrl_depth_est, g_P, g_A, g_T | 8 | 0 | none | warmup_buffered=8 |
| `cvt_size_control_3d` | VerilogEval-Spec-to-RTL | Prob153_gshare | size_control_3d | wire_count_log_est, assign_count, ctrl_depth_est | 1 | 0 | none | warmup_buffered=1 |
| `cvt_theory_grounded` | VerilogEval-Spec-to-RTL | Prob153_gshare | theory_grounded_full_20d | rtl_cyclomatic_total_log, rtl_cyclomatic_max_log, rent_exponent, reconv_source_ratio, reconv_sink_ratio, scoap_cc0_bin_0_pct, scoap_cc0_bin_1_pct, scoap_cc0_bin_2_pct, scoap_cc0_bin_3_pct, scoap_cc1_bin_0_pct, scoap_cc1_bin_1_pct, scoap_cc1_bin_2_pct, scoap_cc1_bin_3_pct, scoap_co_bin_0_pct, scoap_co_bin_1_pct, scoap_co_bin_2_pct, scoap_co_bin_3_pct, laplacian_lambda2, laplacian_spectral_entropy, scoap_signal_smoothness | 8 | 0 | none | warmup_buffered=8 |

