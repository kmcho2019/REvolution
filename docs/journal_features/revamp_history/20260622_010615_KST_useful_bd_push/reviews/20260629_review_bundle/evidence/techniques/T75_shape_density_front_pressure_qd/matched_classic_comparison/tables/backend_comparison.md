# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Valid PPA samples count generated samples with PPA metrics even when QD warmup or archive insertion later drops them.
When the final population has no retained PPA aggregate, Score/PPA deltas use the best generated valid PPA sample.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic_revolution` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 326234.92 ± 36801.68 | 96.00 | 96.00 |
| `classic_revolution` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 319848.86 ± 59618.09 | 96.00 | 96.00 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 333685.33 ± 44580.75 | 96.00 | 96.00 |
| `code_thought_front_slot_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 323657.23 ± 36383.52 | 96.00 | 96.00 |
| `code_thought_front_slot_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 304448.71 ± 58628.71 | 96.00 | 96.00 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 346067.17 ± 36806.43 | 96.00 | 96.00 |
| `rtl_native_front_guarded_parent_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 332907.85 ± 38699.56 | 96.00 | 96.00 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 311332.86 ± 63062.93 | 96.00 | 96.00 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 358078.67 ± 36277.78 | 96.00 | 96.00 |
| `rtl_native_seeded_thought_qd` | ALL | unspecified | 48 | N/A | 112.15 ± 0.20 | 349596.00 ± 38134.80 | 121.50 | 121.50 |
| `rtl_native_seeded_thought_qd` | RTLLM | unspecified | 48 | N/A | 112.00 ± 0.00 | 345382.57 ± 64120.42 | 112.00 | 112.00 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 112.33 ± 0.41 | 354511.67 ± 42091.45 | 134.80 | 134.80 |
| `shape_density_front_pressure_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 337013.08 ± 38912.68 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 318426.86 ± 64444.29 | 96.00 | 96.00 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 358697.00 ± 37264.23 | 96.00 | 96.00 |
| `shape_density_front_slot_hybrid_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 339330.15 ± 39619.93 | 96.00 | 96.00 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 319422.71 ± 64294.14 | 96.00 | 96.00 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 362555.50 ± 40071.53 | 96.00 | 96.00 |
| `source_aligned_rtl_cell_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 361420.75 ± 58099.59 | 96.00 | 96.00 |
| `source_aligned_rtl_cell_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 316527.00 ± 0.00 | 96.00 | 96.00 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 376385.33 ± 70926.43 | 96.00 | 96.00 |
| `source_aligned_shape_density_qd` | ALL | unspecified | 48 | N/A | 96.00 ± 0.00 | 330297.62 ± 40916.78 | 96.00 | 96.00 |
| `source_aligned_shape_density_qd` | RTLLM | unspecified | 48 | N/A | 96.00 ± 0.00 | 308883.00 ± 64982.77 | 96.00 | 96.00 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | unspecified | 48 | N/A | 96.00 ± 0.00 | 355281.33 ± 43626.22 | 96.00 | 96.00 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic_revolution` | RTLLM | Prob004_adder_8bit | ✅ Pass (60.4%) | ✅ Pass (58.3%) | 28 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 716.70 | 96 |
| `code_thought_front_slot_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 485.18 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (72.9%) | ✅ Pass (72.9%) | 35 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 535.21 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 1788.75 | 112 |
| `shape_density_front_pressure_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 563.63 | 96 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 543.56 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob004_adder_8bit | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +38.15% ✅ | +15.22% ✅ / +99.25% ✅ / N/A | +57.23% ✅ | 522.87 | 96 |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +13.52% ✅ | +28.98% ✅ / +38.42% ✅ / -26.83% ❌ | +13.52% ✅ | 1055.42 | 96 |
| `code_thought_front_slot_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (16.7%) | ✅ Pass (16.7%) | 8 | +16.91% ✅ | +30.00% ✅ / +46.33% ✅ / -25.61% ❌ | +16.91% ✅ | 1076.43 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (43.8%) | ✅ Pass (41.7%) | 20 | +24.34% ✅ | +37.96% ✅ / +59.47% ✅ / -24.39% ❌ | +24.34% ✅ | 937.84 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (68.8%) | ✅ Pass (68.8%) | 33 | +5.28% ✅ | +38.78% ✅ / +2.67% ✅ / -25.61% ❌ | +5.28% ✅ | 2740.65 | 112 |
| `shape_density_front_pressure_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (20.8%) | ✅ Pass (20.8%) | 10 | +7.17% ✅ | +38.78% ✅ / +5.90% ✅ / -23.17% ❌ | +7.17% ✅ | 1155.26 | 96 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (33.3%) | ✅ Pass (31.2%) | 15 | +7.17% ✅ | +38.78% ✅ / +5.90% ✅ / -23.17% ❌ | +7.17% ✅ | 1439.90 | 96 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (14.6%) | ✅ Pass (8.3%) | 4 | -2.02% ❌ | +28.47% ✅ / -11.36% ❌ / -23.17% ❌ | -2.02% ❌ | 1218.12 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (22.9%) | ✅ Pass (20.8%) | 10 | +2.31% ✅ | +36.43% ✅ / -1.45% ❌ / -28.05% ❌ | +2.31% ✅ | 1099.35 | 96 |
| `classic_revolution` | RTLLM | Prob024_fsm | ✅ Pass (39.6%) | ✅ Pass (33.3%) | 16 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 793.04 | 96 |
| `code_thought_front_slot_qd` | RTLLM | Prob024_fsm | ✅ Pass (47.9%) | ✅ Pass (35.4%) | 17 | +46.96% ✅ | +36.96% ✅ / +28.92% ✅ / N/A | +32.94% ✅ | 1033.15 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob024_fsm | ✅ Pass (47.9%) | ✅ Pass (39.6%) | 19 | +47.01% ✅ | +36.96% ✅ / +29.06% ✅ / N/A | +33.01% ✅ | 887.52 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob024_fsm | ✅ Pass (47.9%) | ✅ Pass (45.8%) | 22 | +49.17% ✅ | +21.74% ✅ / +46.76% ✅ / N/A | +34.25% ✅ | 2100.10 | 112 |
| `shape_density_front_pressure_qd` | RTLLM | Prob024_fsm | ✅ Pass (41.7%) | ✅ Pass (35.4%) | 17 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1125.00 | 96 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob024_fsm | ✅ Pass (54.2%) | ✅ Pass (41.7%) | 20 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1169.51 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob024_fsm | ✅ Pass (52.1%) | ✅ Pass (45.8%) | 22 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 993.94 | 96 |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | ✅ Pass (43.8%) | ✅ Pass (37.5%) | 18 | +8.46% ✅ | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ | +8.46% ✅ | 973.47 | 96 |
| `code_thought_front_slot_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 18 | +22.83% ✅ | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ | +22.83% ✅ | 1246.70 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (45.8%) | ✅ Pass (43.8%) | 21 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1010.87 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (37.5%) | ✅ Pass (37.5%) | 18 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 2249.26 | 112 |
| `shape_density_front_pressure_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ | +0.00% ➖ | 1313.37 | 96 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (25.0%) | ✅ Pass (25.0%) | 12 | +3.09% ✅ | +2.00% ✅ / +22.08% ✅ / -14.81% ❌ | +3.09% ✅ | 1183.39 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob037_parallel2serial | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 20 | +9.79% ✅ | +10.00% ✅ / +15.67% ✅ / +3.70% ✅ | +9.79% ✅ | 1291.84 | 96 |
| `classic_revolution` | RTLLM | Prob041_traffic_light | ✅ Pass (43.8%) | ✅ Pass (41.7%) | 20 | +41.68% ✅ | +25.88% ✅ / +99.15% ✅ / N/A | +62.52% ✅ | 1073.82 | 96 |
| `code_thought_front_slot_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (33.3%) | ✅ Pass (33.3%) | 16 | +41.99% ✅ | +27.06% ✅ / +98.91% ✅ / N/A | +62.98% ✅ | 1320.33 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (52.1%) | ✅ Pass (50.0%) | 24 | +39.93% ✅ | +20.59% ✅ / +99.21% ✅ / N/A | +59.90% ✅ | 1270.30 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (75.0%) | ✅ Pass (75.0%) | 36 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 2688.96 | 112 |
| `shape_density_front_pressure_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (31.2%) | ✅ Pass (31.2%) | 15 | +40.77% ✅ | +23.53% ✅ / +98.79% ✅ / N/A | +61.16% ✅ | 1425.41 | 96 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (37.5%) | ✅ Pass (35.4%) | 17 | +40.38% ✅ | +22.35% ✅ / +98.79% ✅ / N/A | +60.57% ✅ | 1484.05 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob041_traffic_light | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +40.38% ✅ | +22.35% ✅ / +98.79% ✅ / N/A | +60.57% ✅ | 1437.87 | 96 |
| `classic_revolution` | RTLLM | Prob045_alu | ✅ Pass (22.9%) | ✅ Pass (20.8%) | 10 | +39.46% ✅ | +19.19% ✅ / +99.19% ✅ / N/A | +59.19% ✅ | 1086.16 | 96 |
| `code_thought_front_slot_qd` | RTLLM | Prob045_alu | ✅ Pass (39.6%) | ✅ Pass (39.6%) | 19 | +40.20% ✅ | +21.48% ✅ / +99.11% ✅ / N/A | +60.30% ✅ | 1402.06 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob045_alu | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 20 | +39.33% ✅ | +18.88% ✅ / +99.11% ✅ / N/A | +59.00% ✅ | 1152.70 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob045_alu | ✅ Pass (39.6%) | ✅ Pass (39.6%) | 19 | +41.53% ✅ | +25.39% ✅ / +99.19% ✅ / N/A | +62.29% ✅ | 2927.67 | 112 |
| `shape_density_front_pressure_qd` | RTLLM | Prob045_alu | ✅ Pass (33.3%) | ✅ Pass (33.3%) | 16 | +40.86% ✅ | +23.46% ✅ / +99.11% ✅ / N/A | +61.29% ✅ | 1255.14 | 96 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob045_alu | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | +39.23% ✅ | +18.52% ✅ / +99.17% ✅ / N/A | +58.84% ✅ | 1166.69 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob045_alu | ✅ Pass (45.8%) | ✅ Pass (43.8%) | 21 | +40.70% ✅ | +22.97% ✅ / +99.14% ✅ / N/A | +61.05% ✅ | 1207.72 | 96 |
| `classic_revolution` | RTLLM | Prob049_signal_generator | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 623.45 | 96 |
| `code_thought_front_slot_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 591.74 | 96 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 672.94 | 96 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 1959.38 | 112 |
| `shape_density_front_pressure_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (89.6%) | ✅ Pass (89.6%) | 43 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 785.78 | 96 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (95.8%) | ✅ Pass (95.8%) | 46 | +23.48% ✅ | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ | +23.48% ✅ | 613.23 | 96 |
| `source_aligned_shape_density_qd` | RTLLM | Prob049_signal_generator | ✅ Pass (89.6%) | ✅ Pass (89.6%) | 43 | +26.38% ✅ | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ | +26.38% ✅ | 635.88 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 34 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1094.59 | 96 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (52.1%) | ✅ Pass (52.1%) | 25 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1478.50 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (18.8%) | ✅ Pass (18.8%) | 9 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1460.95 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (68.8%) | ✅ Pass (68.8%) | 33 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 2199.28 | 113 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (50.0%) | ✅ Pass (50.0%) | 24 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1546.05 | 96 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (35.4%) | ✅ Pass (35.4%) | 17 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1486.32 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (41.7%) | ✅ Pass (41.7%) | 20 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 1427.82 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +46.44% ✅ | +40.00% ✅ / +99.32% ✅ / N/A | +69.66% ✅ | 1336.20 | 96 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (72.9%) | ✅ Pass (72.9%) | 35 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1599.38 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (25.0%) | ✅ Pass (25.0%) | 12 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1398.58 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | +46.53% ✅ | +40.00% ✅ / +99.60% ✅ / N/A | +69.80% ✅ | 3148.31 | 112 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (64.6%) | ✅ Pass (64.6%) | 31 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1665.73 | 96 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (31.2%) | ✅ Pass (31.2%) | 15 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1697.81 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (64.6%) | ✅ Pass (64.6%) | 31 | +46.54% ✅ | +40.00% ✅ / +99.61% ✅ / N/A | +69.80% ✅ | 1413.47 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (77.1%) | ✅ Pass (77.1%) | 37 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1119.47 | 96 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (47.9%) | ✅ Pass (47.9%) | 23 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1144.38 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (66.7%) | ✅ Pass (66.7%) | 32 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1186.78 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (58.3%) | ✅ Pass (58.3%) | 28 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 2777.10 | 112 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 40 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1066.56 | 96 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (33.3%) | ✅ Pass (33.3%) | 16 | +19.61% ✅ | -40.00% ❌ / +98.84% ✅ / N/A | +29.42% ✅ | 1330.73 | 96 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1191.51 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (83.3%) | ✅ Pass (83.3%) | 40 | +26.36% ✅ | -20.00% ❌ / +99.09% ✅ / N/A | +39.54% ✅ | 1199.26 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1038.77 | 96 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (22.9%) | ✅ Pass (22.9%) | 11 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1060.36 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (29.2%) | ✅ Pass (29.2%) | 14 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1106.04 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (60.4%) | ✅ Pass (60.4%) | 29 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 2517.87 | 112 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1152.82 | 96 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (31.2%) | ✅ Pass (31.2%) | 15 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 1105.93 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (29.2%) | ✅ Pass (29.2%) | 14 | +32.97% ✅ | +0.00% ➖ / +98.91% ✅ / N/A | +49.45% ✅ | 943.82 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (4.2%) | ✅ Pass (4.2%) | 2 | -36.30% ❌ | -46.97% ❌ / -51.23% ❌ / -10.71% ❌ | -36.30% ❌ | 1216.90 | 96 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (6.2%) | ✅ Pass (6.2%) | 3 | -28.84% ❌ | -34.85% ❌ / -48.10% ❌ / -3.57% ❌ | -28.84% ❌ | 1233.81 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (4.2%) | ✅ Pass (2.1%) | 1 | -37.20% ❌ | -46.97% ❌ / -50.34% ❌ / -14.29% ❌ | -37.20% ❌ | 1280.67 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (31.2%) | ✅ Pass (29.2%) | 14 | -12.59% ❌ | -9.09% ❌ / -50.11% ❌ / +21.43% ✅ | -12.59% ❌ | 2709.50 | 112 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (2.1%) | ✅ Pass (2.1%) | 1 | -47.91% ❌ | -56.06% ❌ / -80.54% ❌ / -7.14% ❌ | -47.91% ❌ | 1295.21 | 96 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (2.1%) | ✅ Pass (2.1%) | 1 | -35.03% ❌ | -40.91% ❌ / -49.89% ❌ / -14.29% ❌ | -35.03% ❌ | 1308.17 | 96 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (2.1%) | ✅ Pass (2.1%) | 1 | -30.43% ❌ | -31.82% ❌ / -45.19% ❌ / -14.29% ❌ | -30.43% ❌ | 1204.69 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (8.3%) | ✅ Pass (6.2%) | 3 | -12.62% ❌ | -13.64% ❌ / -49.22% ❌ / +25.00% ✅ | -12.62% ❌ | 1277.56 | 96 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (27.1%) | ✅ Pass (27.1%) | 13 | +10.86% ✅ | +5.85% ✅ / +33.41% ✅ / -6.67% ❌ | +10.86% ✅ | 762.36 | 96 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (43.8%) | ✅ Pass (43.8%) | 21 | +14.59% ✅ | +7.97% ✅ / +31.81% ✅ / +4.00% ✅ | +14.59% ✅ | 1179.36 | 96 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (39.6%) | ✅ Pass (39.6%) | 19 | +14.31% ✅ | +7.47% ✅ / +27.46% ✅ / +8.00% ✅ | +14.31% ✅ | 1152.40 | 96 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ❌ Fail (0.0%) | ❌ Fail (0.0%) | 0 | N/A | N/A / N/A / N/A | N/A | 1545.98 | 113 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (25.0%) | ✅ Pass (22.9%) | 11 | +17.34% ✅ | +9.52% ✅ / +33.18% ✅ / +9.33% ✅ | +17.34% ✅ | 1132.49 | 96 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (22.9%) | ✅ Pass (20.8%) | 10 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1119.71 | 96 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (25.0%) | ✅ Pass (25.0%) | 12 | +15.09% ✅ | +9.75% ✅ / +36.84% ✅ / -1.33% ❌ | +15.09% ✅ | 1268.35 | 96 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (31.2%) | ✅ Pass (27.1%) | 13 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 1182.93 | 96 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 39.0% ± 9.2% | 36.3% ± 8.8% | 7/7 | +30.68% ± 11.59% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (122 samples) | +36.92% ± 16.87% ✅ | +18.54% ± 5.86% ✅ / +63.44% ± 25.91% ✅ / -3.83% ± 22.98% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 903.15 ± 140.52 | 96.00 ± 0.00 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 46.9% ± 22.2% | 46.9% ± 22.2% | 6/6 | +13.59% ± 23.38% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (135 samples) | +22.50% ± 30.50% ✅ | -3.52% ± 23.10% ❌ / +47.18% ± 50.43% ✅ / -8.69% ± 3.97% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 2/2 | 1094.72 ± 154.93 | 96.00 ± 0.00 |
| `code_thought_front_slot_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 45.8% ± 15.4% | 44.0% ± 15.6% | 7/7 | +32.93% ± 8.59% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (148 samples) | +39.52% ± 14.77% ✅ | +23.64% ± 6.24% ✅ / +63.26% ± 25.54% ✅ / +2.75% ± 28.43% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1022.23 ± 263.71 | 96.00 ± 0.00 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 41.0% ± 18.7% | 41.0% ± 18.7% | 6/6 | +15.47% ± 21.34% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (118 samples) | +24.39% ± 28.54% ✅ | -1.15% ± 20.46% ❌ / +47.48% ± 49.75% ✅ / +0.21% ± 7.42% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 1/2 | 1282.63 ± 167.94 | 96.00 ± 0.00 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 53.6% ± 9.6% | 51.5% ± 10.6% | 7/7 | +30.32% ± 11.77% ✅ | ✅ 6 / ➖ 1 / ❌ 0 | 7/7 (173 samples) | +36.71% ± 16.96% ✅ | +20.34% ± 9.97% ✅ / +61.73% ± 29.23% ✅ / -4.25% ± 20.80% ❌ | ✅ 6 / ➖ 1 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 923.91 ± 190.19 | 96.00 ± 0.00 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 30.6% ± 17.0% | 30.2% ± 17.4% | 6/6 | +14.03% ± 23.62% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (87 samples) | +22.95% ± 30.60% ✅ | -3.25% ± 23.19% ❌ / +46.39% ± 50.50% ✅ / -3.14% ± 21.84% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 1/2 | 1264.24 ± 113.47 | 96.00 ± 0.00 |
| `rtl_native_seeded_thought_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 59.2% ± 12.5% | 58.9% ± 12.7% | 7/7 | +28.75% ± 14.17% ✅ | ✅ 6 / ➖ 1 / ❌ 0 | 7/7 (198 samples) | +35.23% ± 19.38% ✅ | +20.54% ± 8.65% ✅ / +56.10% ± 32.76% ✅ / -3.89% ± 22.71% ❌ | ✅ 6 / ➖ 1 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 2350.68 ± 323.11 | 112.00 ± 0.00 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | 6 | ➖ 5/6 (83.3%) | ➖ 5/6 (83.3%) | 37.2% ± 24.0% | 36.8% ± 24.1% | 5/6 | +18.89% ± 21.12% ✅ | ✅ 4 / ➖ 0 / ❌ 1 | 5/6 (106 samples) | +29.60% ± 29.92% ✅ | +2.18% ± 19.89% ✅ / +50.22% ± 61.10% ✅ / +21.43% ± 0.00% ✅ | ✅ 4 / ➖ 0 / ❌ 1 | A ❌ 2/5 / P ❌ 1/5 / T ✅ 0/1 | 2483.01 ± 444.10 | 112.33 ± 0.41 |
| `shape_density_front_pressure_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 46.7% ± 18.8% | 45.8% ± 19.1% | 7/7 | +28.64% ± 14.03% ✅ | ✅ 6 / ➖ 1 / ❌ 0 | 7/7 (154 samples) | +34.91% ± 19.13% ✅ | +19.36% ± 8.83% ✅ / +56.49% ± 32.29% ✅ / -3.85% ± 20.05% ❌ | ✅ 6 / ➖ 1 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 1089.09 ± 227.28 | 96.00 ± 0.00 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 42.0% ± 23.7% | 41.7% ± 23.9% | 6/6 | +12.75% ± 26.71% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (120 samples) | +21.67% ± 33.31% ✅ | -4.42% ± 25.60% ❌ / +42.31% ± 58.12% ✅ / +1.10% ± 16.15% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 1/2 | 1309.81 ± 195.33 | 96.00 ± 0.00 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 50.9% ± 19.1% | 48.5% ± 19.6% | 7/7 | +28.79% ± 13.31% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (163 samples) | +34.92% ± 18.25% ✅ | +18.77% ± 8.29% ✅ / +59.65% ± 29.20% ✅ / -8.79% ± 20.56% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 2/3 | 1085.76 ± 274.60 | 96.00 ± 0.00 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 26.0% ± 10.0% | 25.7% ± 10.1% | 6/6 | +13.14% ± 22.67% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (74 samples) | +21.50% ± 29.56% ✅ | -5.52% ± 24.67% ❌ / +47.11% ± 50.17% ✅ / -6.48% ± 15.31% ❌ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ❌ 1/2 | 1341.45 ± 180.29 | 96.00 ± 0.00 |
| `source_aligned_rtl_cell_qd` | RTLLM | 1 | ✅ 1/1 (100.0%) | ✅ 1/1 (100.0%) | 14.6% ± 0.0% | 8.3% ± 0.0% | 1/1 | -2.02% ± 0.00% ❌ | ✅ 0 / ➖ 0 / ❌ 1 | 1/1 (4 samples) | -2.02% ± 0.00% ❌ | +28.47% ± 0.00% ✅ / -11.36% ± 0.00% ❌ / -23.17% ± 0.00% ❌ | ✅ 0 / ➖ 0 / ❌ 1 | A ✅ 0/1 / P ❌ 1/1 / T ❌ 1/1 | 1218.12 ± 0.00 | 96.00 ± 0.00 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | 3 | ✅ 3/3 (100.0%) | ✅ 3/3 (100.0%) | 23.6% ± 23.6% | 23.6% ± 23.6% | 3/3 | +3.67% ± 34.03% ✅ | ✅ 2 / ➖ 0 / ❌ 1 | 3/3 (34 samples) | +8.07% ± 40.18% ✅ | -14.02% ± 24.24% ❌ / +30.25% ± 81.89% ✅ / -7.81% ± 12.69% ❌ | ✅ 2 / ➖ 0 / ❌ 1 | A ❌ 2/3 / P ❌ 1/3 / T ❌ 2/2 | 1221.51 ± 46.50 | 96.00 ± 0.00 |
| `source_aligned_shape_density_qd` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 53.0% ± 16.5% | 51.5% ± 17.1% | 7/7 | +29.68% ± 13.10% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (173 samples) | +35.91% ± 18.15% ✅ | +21.12% ± 6.06% ✅ / +57.68% ± 31.23% ✅ / -3.46% ± 24.78% ❌ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ❌ 1/7 / T ❌ 1/3 | 1027.07 ± 250.32 | 96.00 ± 0.00 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 43.1% ± 21.5% | 42.0% ± 22.3% | 6/6 | +18.00% ± 17.34% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | 6/6 (121 samples) | +26.92% ± 24.99% ✅ | +2.36% ± 16.83% ✅ / +47.26% ± 50.04% ✅ / +13.17% ± 23.19% ✅ | ✅ 5 / ➖ 0 / ❌ 1 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 1240.81 ± 142.88 | 96.00 ± 0.00 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic_revolution` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 42.6% ± 11.1% | 41.2% ± 11.2% | 13/13 | +22.79% ± 12.83% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (257 samples) | +30.27% ± 16.49% ✅ | +8.36% ± 12.27% ✅ / +55.93% ± 26.28% ✅ / -5.78% ± 12.86% ❌ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 3/5 | 991.57 ± 113.36 | 96.00 ± 0.00 |
| `code_thought_front_slot_qd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 43.6% ± 11.5% | 42.6% ± 11.6% | 13/13 | +24.87% ± 11.48% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (266 samples) | +32.54% ± 15.28% ✅ | +12.20% ± 11.83% ✅ / +55.98% ± 25.91% ✅ / +1.73% ± 15.79% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 2/5 | 1142.41 ± 171.88 | 96.00 ± 0.00 |
| `rtl_native_front_guarded_parent_qd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 42.9% ± 11.1% | 41.7% ± 11.2% | 13/13 | +22.80% ± 12.87% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (260 samples) | +30.36% ± 16.51% ✅ | +9.45% ± 13.21% ✅ / +54.65% ± 27.19% ✅ / -3.81% ± 13.33% ❌ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 2/5 | 1080.98 ± 146.39 | 96.00 ± 0.00 |
| `rtl_native_seeded_thought_qd` | ALL | 13 | ➖ 12/13 (92.3%) | ➖ 12/13 (92.3%) | 49.0% ± 13.8% | 48.7% ± 13.9% | 12/13 | +24.65% ± 11.82% ✅ | ✅ 10 / ➖ 1 / ❌ 1 | 12/13 (304 samples) | +32.88% ± 16.06% ✅ | +12.89% ± 10.60% ✅ / +53.65% ± 30.17% ✅ / +2.44% ± 20.29% ✅ | ✅ 10 / ➖ 1 / ❌ 1 | A ❌ 2/12 / P ❌ 1/12 / T ❌ 1/4 | 2411.75 ± 259.67 | 112.15 ± 0.20 |
| `shape_density_front_pressure_qd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 44.6% ± 14.3% | 43.9% ± 14.5% | 13/13 | +21.30% ± 14.50% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (274 samples) | +28.80% ± 18.05% ✅ | +8.38% ± 13.85% ✅ / +49.94% ± 30.76% ✅ / -1.87% ± 12.34% ❌ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 2/5 | 1190.96 ± 158.50 | 96.00 ± 0.00 |
| `shape_density_front_slot_hybrid_qd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 39.4% ± 12.9% | 38.0% ± 12.8% | 13/13 | +21.57% ± 12.89% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (237 samples) | +28.72% ± 16.49% ✅ | +7.56% ± 13.51% ✅ / +53.86% ± 26.95% ✅ / -7.86% ± 12.31% ❌ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 1/13 / T ❌ 3/5 | 1203.77 ± 178.20 | 96.00 ± 0.00 |
| `source_aligned_rtl_cell_qd` | ALL | 4 | ✅ 4/4 (100.0%) | ✅ 4/4 (100.0%) | 21.4% ± 17.3% | 19.8% ± 18.3% | 4/4 | +2.25% ± 24.22% ✅ | ✅ 2 / ➖ 0 / ❌ 2 | 4/4 (38 samples) | +5.54% ± 28.84% ✅ | -3.40% ± 26.97% ❌ / +19.84% ± 61.39% ✅ / -12.93% ± 12.43% ❌ | ✅ 2 / ➖ 0 / ❌ 2 | A ❌ 2/4 / P ❌ 2/4 / T ❌ 3/3 | 1220.67 ± 32.92 | 96.00 ± 0.00 |
| `source_aligned_shape_density_qd` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 48.4% ± 13.1% | 47.1% ± 13.5% | 13/13 | +24.29% ± 10.72% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | 13/13 (294 samples) | +31.76% ± 14.67% ✅ | +12.46% ± 9.61% ✅ / +52.87% ± 27.44% ✅ / +3.19% ± 17.37% ✅ | ✅ 12 / ➖ 0 / ❌ 1 | A ❌ 2/13 / P ❌ 2/13 / T ❌ 1/5 | 1125.72 ± 156.30 | 96.00 ± 0.00 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic_revolution` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 | +15.22% ✅ / +99.25% ✅ / N/A |
| `code_thought_front_slot_qd` | RTLLM | Prob004_adder_8bit | 2 | 2 | 1 | 0.1510 | 2 | +15.22% ✅ / +99.25% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `shape_density_front_pressure_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `source_aligned_shape_density_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 | +15.22% ✅ / +99.25% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 9 | 0.0000 | 0 | +38.78% ✅ / +38.42% ✅ / +39.02% ✅ |
| `code_thought_front_slot_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 6 | 2 | 0.0000 | 0 | +38.78% ✅ / +46.33% ✅ / -23.17% ❌ |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 3 | 0.0000 | 0 | +38.78% ✅ / +59.47% ✅ / -21.95% ❌ |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 13 | 3 | 0.0000 | 0 | +38.78% ✅ / +2.67% ✅ / -10.98% ❌ |
| `shape_density_front_pressure_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 4 | 0.0000 | 0 | +38.78% ✅ / +5.90% ✅ / +30.49% ✅ |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 2 | 0.0000 | 0 | +38.78% ✅ / +5.90% ✅ / +7.32% ✅ |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 4 | 3 | 0.0000 | 0 | +31.94% ✅ / -11.36% ❌ / +30.49% ✅ |
| `source_aligned_shape_density_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 8 | 3 | 0.0000 | 0 | +36.43% ✅ / -1.45% ❌ / -23.17% ❌ |
| `classic_revolution` | RTLLM | Prob024_fsm | 2 | 11 | 2 | 0.1449 | 8 | +36.96% ✅ / +46.33% ✅ / N/A |
| `code_thought_front_slot_qd` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.1069 | 2 | +36.96% ✅ / +28.92% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.1074 | 2 | +36.96% ✅ / +29.06% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1457 | 4 | +36.96% ✅ / +46.76% ✅ / N/A |
| `shape_density_front_pressure_qd` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1456 | 4 | +36.96% ✅ / +46.62% ✅ / N/A |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1456 | 5 | +36.96% ✅ / +46.62% ✅ / N/A |
| `source_aligned_shape_density_qd` | RTLLM | Prob024_fsm | 2 | 9 | 2 | 0.1456 | 6 | +36.96% ✅ / +46.62% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0003 | 1 | +6.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `code_thought_front_slot_qd` | RTLLM | Prob037_parallel2serial | 3 | 5 | 1 | 0.0119 | 2 | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 3 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +3.70% ✅ |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob037_parallel2serial | 3 | 2 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `shape_density_front_pressure_qd` | RTLLM | Prob037_parallel2serial | 3 | 2 | 2 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +3.70% ✅ |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 4 | 0.0000 | 0 | +2.00% ✅ / +22.08% ✅ / +3.70% ✅ |
| `source_aligned_shape_density_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 1 | 0.0006 | 1 | +10.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `classic_revolution` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3067 | 14 | +32.94% ✅ / +99.15% ✅ / N/A |
| `code_thought_front_slot_qd` | RTLLM | Prob041_traffic_light | 2 | 8 | 2 | 0.2680 | 7 | +27.06% ✅ / +99.09% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob041_traffic_light | 2 | 22 | 1 | 0.2043 | 13 | +20.59% ✅ / +99.21% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob041_traffic_light | 2 | 23 | 3 | 0.2334 | 19 | +23.53% ✅ / +99.21% ✅ / N/A |
| `shape_density_front_pressure_qd` | RTLLM | Prob041_traffic_light | 2 | 11 | 2 | 0.2325 | 6 | +23.53% ✅ / +98.81% ✅ / N/A |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.2217 | 9 | +22.35% ✅ / +99.21% ✅ / N/A |
| `source_aligned_shape_density_qd` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.2214 | 8 | +22.35% ✅ / +99.09% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1904 | 9 | +19.19% ✅ / +99.19% ✅ / N/A |
| `code_thought_front_slot_qd` | RTLLM | Prob045_alu | 2 | 17 | 1 | 0.2129 | 17 | +21.48% ✅ / +99.11% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob045_alu | 2 | 19 | 2 | 0.1871 | 19 | +18.88% ✅ / +99.14% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob045_alu | 2 | 11 | 1 | 0.2519 | 11 | +25.39% ✅ / +99.19% ✅ / N/A |
| `shape_density_front_pressure_qd` | RTLLM | Prob045_alu | 2 | 16 | 2 | 0.2326 | 16 | +23.46% ✅ / +99.14% ✅ / N/A |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob045_alu | 2 | 16 | 1 | 0.1836 | 16 | +18.52% ✅ / +99.17% ✅ / N/A |
| `source_aligned_shape_density_qd` | RTLLM | Prob045_alu | 2 | 21 | 1 | 0.2277 | 21 | +22.97% ✅ / +99.14% ✅ / N/A |
| `classic_revolution` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0128 | 3 | +22.34% ✅ / +46.04% ✅ / +16.28% ✅ |
| `code_thought_front_slot_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 | +18.09% ✅ / +46.04% ✅ / +13.95% ✅ |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 1 | 0.0123 | 2 | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ |
| `shape_density_front_pressure_qd` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 | +12.77% ✅ / +46.04% ✅ / +11.63% ✅ |
| `source_aligned_shape_density_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 1 | 0.0123 | 2 | +19.15% ✅ / +46.04% ✅ / +13.95% ✅ |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.3975 | 5 | +40.00% ✅ / +99.41% ✅ / N/A |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 | +40.00% ✅ / +99.61% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 | +40.00% ✅ / +99.61% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 2 | 1 | 0.3984 | 2 | +40.00% ✅ / +99.60% ✅ / N/A |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 | +40.00% ✅ / +99.61% ✅ / N/A |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 | +40.00% ✅ / +99.61% ✅ / N/A |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 | +40.00% ✅ / +99.61% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 1 | 1 | 0.0000 | 0 | -40.00% ❌ / +98.84% ✅ / N/A |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 | -20.00% ❌ / +99.09% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +98.91% ✅ / N/A |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +98.91% ✅ / N/A |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 | +0.00% ➖ / +98.91% ✅ / N/A |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 | +0.00% ➖ / +98.91% ✅ / N/A |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +98.91% ✅ / N/A |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 | +0.00% ➖ / +98.91% ✅ / N/A |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 | +0.00% ➖ / +98.91% ✅ / N/A |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 2 | 0.0000 | 0 | -46.97% ❌ / -51.23% ❌ / -3.57% ❌ |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 3 | 2 | 0.0000 | 0 | -34.85% ❌ / -47.65% ❌ / -3.57% ❌ |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 1 | 1 | 0.0000 | 0 | -46.97% ❌ / -50.34% ❌ / -14.29% ❌ |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 3 | 2 | 0.0000 | 0 | -9.09% ❌ / -49.89% ❌ / +21.43% ✅ |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 1 | 1 | 0.0000 | 0 | -56.06% ❌ / -80.54% ❌ / -7.14% ❌ |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 1 | 1 | 0.0000 | 0 | -40.91% ❌ / -49.89% ❌ / -14.29% ❌ |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 1 | 1 | 0.0000 | 0 | -31.82% ❌ / -45.19% ❌ / -14.29% ❌ |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 3 | 1 | 0.0000 | 0 | -13.64% ❌ / -49.22% ❌ / +25.00% ✅ |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0002 | 1 | +5.85% ✅ / +33.41% ✅ / +9.33% ✅ |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 15 | 5 | 0.0012 | 4 | +9.79% ✅ / +37.30% ✅ / +10.67% ✅ |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 16 | 3 | 0.0017 | 6 | +7.77% ✅ / +31.58% ✅ / +8.00% ✅ |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 0 | 0 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / +0.00% ➖ |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 2 | 0.0031 | 5 | +9.52% ✅ / +33.18% ✅ / +10.67% ✅ |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 7 | 3 | 0.0003 | 1 | +7.77% ✅ / +31.58% ✅ / +10.67% ✅ |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 6 | 0.0003 | 1 | +9.75% ✅ / +36.84% ✅ / +10.67% ✅ |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 3 | 0.0003 | 3 | +8.96% ✅ / +31.58% ✅ / +6.67% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution` | RTLLM | 7 | 7 | 0.1152 ± 0.0863 | 2.71 ± 2.13 | 5.29 ± 3.82 | 4 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0663 ± 0.1298 | 1.83 ± 0.94 | 1.50 ± 1.50 | 4 |
| `code_thought_front_slot_qd` | RTLLM | 7 | 7 | 0.1087 ± 0.0794 | 1.43 ± 0.40 | 4.57 ± 4.36 | 1 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0666 ± 0.1301 | 1.83 ± 1.28 | 1.83 ± 1.47 | 0 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | 7 | 7 | 0.0938 ± 0.0673 | 1.71 ± 0.70 | 5.14 ± 5.66 | 0 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0667 ± 0.1300 | 1.33 ± 0.65 | 2.00 ± 1.96 | 0 |
| `rtl_native_seeded_thought_qd` | RTLLM | 7 | 7 | 0.1135 ± 0.0811 | 1.71 ± 0.70 | 5.29 ± 5.30 | 2 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | 6 | 5 | 0.0664 ± 0.1301 | 1.00 ± 0.51 | 0.67 ± 0.65 | 0 |
| `shape_density_front_pressure_qd` | RTLLM | 7 | 7 | 0.1098 ± 0.0788 | 2.00 ± 0.74 | 4.00 ± 4.26 | 0 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0669 ± 0.1300 | 1.17 ± 0.33 | 2.00 ± 1.68 | 1 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | 7 | 7 | 0.1013 ± 0.0710 | 1.86 ± 0.79 | 4.57 ± 4.46 | 0 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0665 ± 0.1301 | 1.33 ± 0.65 | 1.50 ± 1.81 | 1 |
| `source_aligned_rtl_cell_qd` | RTLLM | 1 | 1 | 0.0000 ± 0.0000 | 3.00 ± 0.00 | 0.00 ± 0.00 | 0 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | 3 | 3 | 0.0001 ± 0.0002 | 2.67 ± 3.27 | 0.33 ± 0.65 | 0 |
| `source_aligned_shape_density_qd` | RTLLM | 7 | 7 | 0.1084 ± 0.0758 | 1.57 ± 0.58 | 5.57 ± 5.49 | 0 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0665 ± 0.1301 | 1.33 ± 0.65 | 1.50 ± 1.31 | 0 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic_revolution` | ALL | 13 | 13 | 0.0926 ± 0.0737 | 2.31 ± 1.20 | 3.54 ± 2.34 | 8 |
| `code_thought_front_slot_qd` | ALL | 13 | 13 | 0.0893 ± 0.0714 | 1.62 ± 0.61 | 3.31 ± 2.48 | 1 |
| `rtl_native_front_guarded_parent_qd` | ALL | 13 | 13 | 0.0813 ± 0.0673 | 1.54 ± 0.48 | 3.69 ± 3.19 | 0 |
| `rtl_native_seeded_thought_qd` | ALL | 13 | 12 | 0.0917 ± 0.0721 | 1.38 ± 0.47 | 3.15 ± 3.06 | 2 |
| `shape_density_front_pressure_qd` | ALL | 13 | 13 | 0.0900 ± 0.0712 | 1.62 ± 0.47 | 3.08 ± 2.39 | 1 |
| `shape_density_front_slot_hybrid_qd` | ALL | 13 | 13 | 0.0852 ± 0.0686 | 1.62 ± 0.52 | 3.15 ± 2.60 | 1 |
| `source_aligned_rtl_cell_qd` | ALL | 4 | 4 | 0.0001 ± 0.0002 | 2.75 ± 2.32 | 0.25 ± 0.49 | 0 |
| `source_aligned_shape_density_qd` | ALL | 13 | 13 | 0.0890 ± 0.0703 | 1.46 ± 0.42 | 3.69 ± 3.13 | 0 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `code_thought_front_slot_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 25.0% | 0.7629 | 0.3815 | 2/8 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 100.0% | 0.3815 | 0.3815 | 1/1 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 100.0% | 0.3815 | 0.3815 | 1/1 |
| `shape_density_front_pressure_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 25.0% | 1.1446 | 0.3815 | 3/12 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 66.7% | 0.7631 | 0.3815 | 2/3 |
| `source_aligned_shape_density_qd` | RTLLM | Prob004_adder_8bit | grid_quantile | 100.0% | 0.7631 | 0.3815 | 2/2 |
| `code_thought_front_slot_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 7.8% | 0.2822 | 0.1691 | 5/64 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 50.0% | 0.1335 | 0.2434 | 8/16 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 37.5% | -0.0022 | 0.0528 | 6/16 |
| `shape_density_front_pressure_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 12.5% | -0.2956 | 0.0717 | 8/64 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 12.5% | -0.0471 | 0.0717 | 8/64 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | grid | 6.2% | -0.0202 | -0.0202 | 1/16 |
| `source_aligned_shape_density_qd` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 10.9% | -0.9802 | 0.0231 | 7/64 |
| `code_thought_front_slot_qd` | RTLLM | Prob024_fsm | grid_quantile | 7.8% | 1.4574 | 0.4696 | 5/64 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob024_fsm | grid_quantile | 50.0% | 1.2052 | 0.4701 | 3/6 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob024_fsm | grid_quantile | 31.2% | 2.4281 | 0.4917 | 5/16 |
| `shape_density_front_pressure_qd` | RTLLM | Prob024_fsm | grid_quantile | 16.7% | 2.0231 | 0.5002 | 6/36 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob024_fsm | grid_quantile | 13.9% | 1.5535 | 0.5002 | 5/36 |
| `source_aligned_shape_density_qd` | RTLLM | Prob024_fsm | grid_quantile | 16.7% | 2.5421 | 0.5002 | 6/36 |
| `code_thought_front_slot_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 18.5% | 0.3059 | 0.2283 | 5/27 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 33.3% | -0.0106 | -0.0000 | 3/9 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 18.8% | -0.3285 | -0.0000 | 3/16 |
| `shape_density_front_pressure_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 8.3% | 0.0000 | -0.0000 | 4/48 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 50.0% | 0.0155 | 0.0309 | 4/8 |
| `source_aligned_shape_density_qd` | RTLLM | Prob037_parallel2serial | grid_quantile | 18.5% | 0.0979 | 0.0979 | 5/27 |
| `code_thought_front_slot_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 12.5% | 2.2303 | 0.4199 | 8/64 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 68.8% | 2.3404 | 0.3993 | 11/16 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 37.5% | 2.0298 | 0.4077 | 6/16 |
| `shape_density_front_pressure_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 15.6% | 1.8103 | 0.4077 | 10/64 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 15.6% | 1.9340 | 0.4038 | 10/64 |
| `source_aligned_shape_density_qd` | RTLLM | Prob041_traffic_light | grid_quantile | 20.3% | 2.7015 | 0.4038 | 13/64 |
| `code_thought_front_slot_qd` | RTLLM | Prob045_alu | grid_quantile | 20.3% | 4.9853 | 0.4020 | 13/64 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob045_alu | grid_quantile | 66.7% | 3.0760 | 0.3933 | 8/12 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob045_alu | grid_quantile | 33.3% | 1.2023 | 0.4153 | 3/9 |
| `shape_density_front_pressure_qd` | RTLLM | Prob045_alu | grid_quantile | 56.2% | 3.4748 | 0.4086 | 9/16 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob045_alu | grid_quantile | 50.0% | 3.0822 | 0.3923 | 8/16 |
| `source_aligned_shape_density_qd` | RTLLM | Prob045_alu | grid_quantile | 56.2% | 3.4604 | 0.4070 | 9/16 |
| `code_thought_front_slot_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 25.0% | 0.4422 | 0.2348 | 2/8 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 100.0% | 0.7043 | 0.2348 | 3/3 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 33.3% | 0.9681 | 0.2638 | 4/12 |
| `shape_density_front_pressure_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 14.8% | 0.9391 | 0.2348 | 4/27 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 25.0% | 0.4695 | 0.2348 | 2/8 |
| `source_aligned_shape_density_qd` | RTLLM | Prob049_signal_generator | grid_quantile | 25.0% | 0.4986 | 0.2638 | 2/8 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 7.4% | 0.0120 | 0.0120 | 2/27 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 25.0% | 0.0120 | 0.0120 | 1/4 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 22.2% | 0.0120 | 0.0120 | 2/9 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 50.0% | 0.0120 | 0.0120 | 2/4 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 7.4% | 0.8623 | 0.4654 | 2/27 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 100.0% | 0.4654 | 0.4654 | 1/1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 31.2% | 2.0532 | 0.4654 | 5/16 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 25.0% | 1.7914 | 0.4654 | 4/16 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 37.5% | 2.3846 | 0.4654 | 6/16 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 100.0% | 0.2636 | 0.2636 | 1/1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 25.0% | 1.0540 | 0.2636 | 4/16 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 33.3% | 0.7229 | 0.2636 | 3/9 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 33.3% | 0.7234 | 0.2636 | 3/9 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 66.7% | 0.3923 | 0.1961 | 2/3 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid | 6.2% | 0.2636 | 0.2636 | 1/16 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 50.0% | 0.4598 | 0.2636 | 2/4 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 8.3% | 0.1050 | 0.3297 | 3/36 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 100.0% | 0.3297 | 0.3297 | 1/1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 100.0% | 0.3297 | 0.3297 | 1/1 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 41.7% | 1.3126 | 0.3297 | 5/12 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 50.0% | 0.9891 | 0.3297 | 3/6 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 66.7% | 0.6594 | 0.3297 | 2/3 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 33.3% | -0.8482 | -0.1259 | 3/9 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid | 6.2% | -0.3043 | -0.3043 | 1/16 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 10.9% | -0.0390 | 0.1459 | 7/64 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 37.5% | 0.4752 | 0.1431 | 6/16 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 14.1% | 0.2014 | 0.1734 | 9/64 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 9.4% | -0.3302 | 0.1356 | 6/64 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid | 6.2% | 0.1509 | 0.1509 | 1/16 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 12.5% | 0.2645 | 0.1356 | 8/64 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `code_thought_front_slot_qd` | RTLLM | Prob004_adder_8bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 36 | 2 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=11, warmup_buffered=25; replay duplicate_objectives=23, filled_empty=2 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob004_adder_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 35 | 1 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=35; replay duplicate_objectives=34, filled_empty=1 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob004_adder_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 12 | 1 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=12; replay duplicate_objectives=11, filled_empty=1 |
| `shape_density_front_pressure_qd` | RTLLM | Prob004_adder_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 36 | 3 | init=warmup_complete, shape=3x4x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=32, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob004_adder_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 36 | 2 | init=run_finalization_fallback, shape=1x3x1 | source_aligned_masterrtl_branching, source_aligned_rtltimer_dff_density | live warmup_buffered=36; replay duplicate_objectives=34, filled_empty=2 |
| `source_aligned_shape_density_qd` | RTLLM | Prob004_adder_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 36 | 2 | init=run_finalization_fallback, shape=1x2x1 | source_aligned_masterrtl_branching, source_aligned_rtltimer_dff_density | live warmup_buffered=36; replay duplicate_objectives=34, filled_empty=2 |
| `code_thought_front_slot_qd` | RTLLM | Prob015_multi_pipe_8bit | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 8 | 6 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=1, filled_empty=2, pareto_inserted=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob015_multi_pipe_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 20 | 10 | init=warmup_complete, shape=4x4 | none | live crowding_evicted=2, duplicate_objectives=6, filled_empty=4, replaced_elite=4, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob015_multi_pipe_8bit | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 13 | 8 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=5, filled_empty=2, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 10 | 10 | init=warmup_complete, shape=4x4x4 | none | live filled_empty=4, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 15 | 9 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=1, duplicate_objectives=3, filled_empty=4, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 4 | 2 | N/A | rtltimer_state_timing_class | live crowding_evicted=2, filled_empty=1, replaced_elite=1 |
| `source_aligned_shape_density_qd` | RTLLM | Prob015_multi_pipe_8bit | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 10 | 9 | init=warmup_complete, shape=4x4x4 | none | live filled_empty=3, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `code_thought_front_slot_qd` | RTLLM | Prob024_fsm | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 17 | 6 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=10, filled_empty=2, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob024_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 19 | 5 | init=warmup_complete, shape=3x2 | none | live crowding_evicted=1, duplicate_objectives=8, pareto_inserted=2, warmup_buffered=8; replay crowding_evicted=1, duplicate_objectives=1, filled_empty=3, pareto_inserted=2, replaced_elite=1 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob024_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 12 | 5 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=5, filled_empty=3, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `shape_density_front_pressure_qd` | RTLLM | Prob024_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 17 | 7 | init=warmup_complete, shape=4x3x3 | none | live duplicate_objectives=9, filled_empty=3, pareto_inserted=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob024_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 20 | 7 | init=warmup_complete, shape=4x3x3 | none | live duplicate_objectives=11, filled_empty=2, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `source_aligned_shape_density_qd` | RTLLM | Prob024_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 22 | 8 | init=warmup_complete, shape=4x3x3 | none | live duplicate_objectives=11, filled_empty=3, pareto_inserted=2, replaced_elite=2, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `code_thought_front_slot_qd` | RTLLM | Prob037_parallel2serial | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 18 | 5 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=11, filled_empty=3, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob037_parallel2serial | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 21 | 5 | init=warmup_complete, shape=3x3 | none | live duplicate_objectives=14, filled_empty=1, pareto_inserted=2, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob037_parallel2serial | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 11 | 3 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=6, filled_empty=1, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `shape_density_front_pressure_qd` | RTLLM | Prob037_parallel2serial | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 17 | 5 | init=warmup_complete, shape=3x4x4 | none | live duplicate_objectives=11, filled_empty=1, pareto_inserted=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob037_parallel2serial | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 12 | 5 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=2, filled_empty=1, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=3 |
| `source_aligned_shape_density_qd` | RTLLM | Prob037_parallel2serial | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 20 | 7 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=12, filled_empty=2, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `code_thought_front_slot_qd` | RTLLM | Prob041_traffic_light | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 16 | 8 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=8, filled_empty=4, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob041_traffic_light | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 24 | 16 | init=warmup_complete, shape=4x4 | none | live crowding_evicted=4, duplicate_objectives=1, filled_empty=7, pareto_inserted=3, replaced_elite=5, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob041_traffic_light | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 15 | 8 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=6, filled_empty=2, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd` | RTLLM | Prob041_traffic_light | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 15 | 11 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=4, filled_empty=6, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob041_traffic_light | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 17 | 11 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=3, duplicate_objectives=2, filled_empty=6, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `source_aligned_shape_density_qd` | RTLLM | Prob041_traffic_light | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 21 | 15 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=5, filled_empty=9, pareto_inserted=2, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `code_thought_front_slot_qd` | RTLLM | Prob045_alu | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 19 | 17 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=2, filled_empty=9, pareto_inserted=1, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob045_alu | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 20 | 13 | init=warmup_complete, shape=4x3 | none | live crowding_evicted=5, filled_empty=5, pareto_inserted=3, replaced_elite=3, warmup_buffered=4; replay filled_empty=3, pareto_inserted=1 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob045_alu | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 11 | 5 | init=warmup_complete, shape=3x3 | none | live crowding_evicted=1, duplicate_objectives=2, filled_empty=1, pareto_inserted=1, replaced_elite=2, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `shape_density_front_pressure_qd` | RTLLM | Prob045_alu | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 16 | 13 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live filled_empty=5, pareto_inserted=2, replaced_elite=5, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob045_alu | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 17 | 12 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live crowding_evicted=3, duplicate_objectives=1, filled_empty=4, pareto_inserted=1, replaced_elite=4, warmup_buffered=4; replay filled_empty=4 |
| `source_aligned_shape_density_qd` | RTLLM | Prob045_alu | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 21 | 15 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live crowding_evicted=2, filled_empty=5, pareto_inserted=5, replaced_elite=5, warmup_buffered=4; replay filled_empty=4 |
| `code_thought_front_slot_qd` | RTLLM | Prob049_signal_generator | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 34 | 2 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=9, warmup_buffered=25; replay duplicate_objectives=23, filled_empty=2 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob049_signal_generator | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 34 | 3 | init=run_finalization_fallback, shape=1x3 | state_control_ratio | live warmup_buffered=34; replay duplicate_objectives=31, filled_empty=3 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob049_signal_generator | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 16 | 4 | init=warmup_complete, shape=3x4 | none | live duplicate_objectives=12, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_pressure_qd` | RTLLM | Prob049_signal_generator | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 43 | 4 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=37, filled_empty=2, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob049_signal_generator | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 46 | 2 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=34, warmup_buffered=12; replay duplicate_objectives=10, filled_empty=2 |
| `source_aligned_shape_density_qd` | RTLLM | Prob049_signal_generator | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 43 | 3 | init=warmup_complete, shape=2x2x2 | none | live duplicate_objectives=31, replaced_elite=1, warmup_buffered=11; replay duplicate_objectives=9, filled_empty=2 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 25 | 2 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=21, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 9 | 2 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=9; replay duplicate_objectives=7, filled_empty=1, replaced_elite=1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 12 | 2 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=12; replay duplicate_objectives=10, filled_empty=1, pareto_inserted=1 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 24 | 2 | init=warmup_complete, shape=1x2x2 | source_aligned_masterrtl_branching | live duplicate_objectives=14, warmup_buffered=10; replay duplicate_objectives=8, filled_empty=1, replaced_elite=1 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 17 | 2 | init=warmup_complete, shape=1x3x3 | source_aligned_masterrtl_branching | live duplicate_objectives=13, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 20 | 2 | init=warmup_complete, shape=1x2x2 | source_aligned_masterrtl_branching | live duplicate_objectives=15, warmup_buffered=5; replay duplicate_objectives=3, filled_empty=2 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 35 | 4 | init=warmup_complete, shape=3x3x3 | none | live duplicate_objectives=30, pareto_inserted=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=2, pareto_inserted=1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 12 | 2 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=12; replay crowding_evicted=8, duplicate_objectives=2, filled_empty=1, pareto_inserted=1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 2 | 0 | init=pending | none | live warmup_buffered=2 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 31 | 5 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=25, filled_empty=2, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 15 | 6 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=8, filled_empty=1, replaced_elite=2, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 31 | 6 | init=warmup_complete, shape=4x4x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=25, filled_empty=2, warmup_buffered=4; replay filled_empty=4 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 23 | 2 | init=run_finalization_fallback, shape=1x1x1 | sr_pca_0, sr_pca_1, sr_pca_2 | live warmup_buffered=23; replay duplicate_objectives=21, filled_empty=1, pareto_inserted=1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 32 | 6 | init=warmup_complete, shape=4x4 | none | live duplicate_objectives=26, filled_empty=1, pareto_inserted=1, warmup_buffered=4; replay filled_empty=3, pareto_inserted=1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 14 | 4 | init=warmup_complete, shape=3x3 | none | live duplicate_objectives=8, filled_empty=1, pareto_inserted=1, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 40 | 4 | init=warmup_complete, shape=3x3x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=35, replaced_elite=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 16 | 2 | init=run_finalization_fallback, shape=1x3x1 | source_aligned_masterrtl_branching, source_aligned_rtltimer_dff_density | live warmup_buffered=16; replay duplicate_objectives=14, filled_empty=2 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 21 | 2 | N/A | rtltimer_state_timing_class | live crowding_evicted=17, duplicate_objectives=2, filled_empty=1, pareto_inserted=1 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 40 | 3 | init=warmup_complete, shape=2x2x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=33, filled_empty=1, warmup_buffered=6; replay duplicate_objectives=4, filled_empty=1, pareto_inserted=1 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 11 | 3 | init=warmup_complete, shape=3x3x4 | none | live duplicate_objectives=7, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 14 | 1 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=14; replay duplicate_objectives=13, filled_empty=1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 13 | 1 | init=run_finalization_fallback, shape=1x1 | state_control_ratio, control_pipeline_ratio | live warmup_buffered=13; replay duplicate_objectives=12, filled_empty=1 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 13 | 6 | init=warmup_complete, shape=3x4x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=6, filled_empty=2, pareto_inserted=1, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 15 | 3 | init=warmup_complete, shape=2x3x1 | source_aligned_rtltimer_dff_density | live duplicate_objectives=9, warmup_buffered=6; replay duplicate_objectives=3, filled_empty=3 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 14 | 2 | init=run_finalization_fallback, shape=1x3x1 | source_aligned_masterrtl_branching, source_aligned_rtltimer_dff_density | live warmup_buffered=14; replay duplicate_objectives=12, filled_empty=2 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 3 | 0 | init=pending | none | live warmup_buffered=3 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 1 | 0 | init=pending | none | live warmup_buffered=1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 10 | 3 | init=warmup_complete, shape=3x3 | none | live duplicate_objectives=5, filled_empty=1, warmup_buffered=4; replay duplicate_objectives=2, filled_empty=2 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 1 | 0 | init=pending | none | live warmup_buffered=1 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 1 | 0 | init=pending | none | live warmup_buffered=1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 1 | 1 | N/A | none | live filled_empty=1 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 3 | 0 | init=pending | none | live warmup_buffered=3 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | sr_pca_3d | sr_pca_0, sr_pca_1, sr_pca_2 | 21 | 10 | init=warmup_complete, shape=4x4x4 | none | live crowding_evicted=5, duplicate_objectives=4, filled_empty=4, replaced_elite=4, warmup_buffered=4; replay duplicate_objectives=1, filled_empty=3 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 19 | 8 | init=warmup_complete, shape=4x4 | none | live crowding_evicted=9, duplicate_objectives=1, filled_empty=2, pareto_inserted=2, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | fused_rtl_state_pipeline_2d | state_control_ratio, control_pipeline_ratio | 0 | 0 | init=pending | none | live N/A |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 11 | 11 | init=warmup_complete, shape=4x4x4 | none | live filled_empty=5, pareto_inserted=1, replaced_elite=1, warmup_buffered=4; replay filled_empty=4 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 10 | 8 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=2, filled_empty=3, replaced_elite=1, warmup_buffered=4; replay filled_empty=3, replaced_elite=1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_masterrtl_rtltimer_cell_2d | masterrtl_operator_log_edges, rtltimer_state_timing_class | 12 | 2 | N/A | rtltimer_state_timing_class | live crowding_evicted=7, filled_empty=1, pareto_inserted=1, replaced_elite=3 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | source_aligned_shape_density_3d | source_aligned_masterrtl_branching, source_aligned_rtltimer_wire_density, source_aligned_rtltimer_dff_density | 13 | 13 | init=warmup_complete, shape=4x4x4 | none | live filled_empty=4, pareto_inserted=2, replaced_elite=3, warmup_buffered=4; replay filled_empty=4 |
