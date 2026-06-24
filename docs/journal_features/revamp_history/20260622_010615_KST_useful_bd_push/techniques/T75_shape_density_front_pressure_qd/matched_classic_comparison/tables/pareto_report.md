# Pareto Analysis

- subset_config: `/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml`
- backend_count: `8`
- overall_multi_objective_winner: `classic_revolution`

## Aggregate Backend Metrics

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | ALL | 13 | 13 | 0.0926 | 2.31 | 3.54 | 8 |
| `classic_revolution` | RTLLM | 7 | 7 | 0.1152 | 2.71 | 5.29 | 4 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0663 | 1.83 | 1.50 | 4 |
| `code_thought_front_slot_qd` | ALL | 13 | 13 | 0.0893 | 1.62 | 3.31 | 1 |
| `code_thought_front_slot_qd` | RTLLM | 7 | 7 | 0.1087 | 1.43 | 4.57 | 1 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0666 | 1.83 | 1.83 | 0 |
| `rtl_native_front_guarded_parent_qd` | ALL | 13 | 13 | 0.0813 | 1.54 | 3.69 | 0 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | 7 | 7 | 0.0938 | 1.71 | 5.14 | 0 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0667 | 1.33 | 2.00 | 0 |
| `rtl_native_seeded_thought_qd` | ALL | 13 | 12 | 0.0917 | 1.38 | 3.15 | 2 |
| `rtl_native_seeded_thought_qd` | RTLLM | 7 | 7 | 0.1135 | 1.71 | 5.29 | 2 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | 6 | 5 | 0.0664 | 1.00 | 0.67 | 0 |
| `shape_density_front_pressure_qd` | ALL | 13 | 13 | 0.0900 | 1.62 | 3.08 | 1 |
| `shape_density_front_pressure_qd` | RTLLM | 7 | 7 | 0.1098 | 2.00 | 4.00 | 0 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0669 | 1.17 | 2.00 | 1 |
| `shape_density_front_slot_hybrid_qd` | ALL | 13 | 13 | 0.0852 | 1.62 | 3.15 | 1 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | 7 | 7 | 0.1013 | 1.86 | 4.57 | 0 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0665 | 1.33 | 1.50 | 1 |
| `source_aligned_rtl_cell_qd` | ALL | 13 | 4 | 0.0000 | 0.85 | 0.08 | 0 |
| `source_aligned_rtl_cell_qd` | RTLLM | 7 | 1 | 0.0000 | 0.43 | 0.00 | 0 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | 6 | 3 | 0.0001 | 1.33 | 0.17 | 0 |
| `source_aligned_shape_density_qd` | ALL | 13 | 13 | 0.0890 | 1.46 | 3.69 | 0 |
| `source_aligned_shape_density_qd` | RTLLM | 7 | 7 | 0.1084 | 1.57 | 5.57 | 0 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0665 | 1.33 | 1.50 | 0 |

## Backend / Problem Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | RTLLM | Prob004_adder_8bit | 2 | 7 | 1 | 0.1510 | 2 |
| `code_thought_front_slot_qd` | RTLLM | Prob004_adder_8bit | 2 | 2 | 1 | 0.1510 | 2 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob004_adder_8bit | 2 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `shape_density_front_pressure_qd` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.1510 | 1 |
| `classic_revolution` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 9 | 0.0000 | 0 |
| `code_thought_front_slot_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 6 | 2 | 0.0000 | 0 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 10 | 3 | 0.0000 | 0 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 13 | 3 | 0.0000 | 0 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 4 | 3 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 8 | 3 | 0.0000 | 0 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 11 | 2 | 0.0000 | 0 |
| `shape_density_front_pressure_qd` | RTLLM | Prob015_multi_pipe_8bit | 3 | 9 | 4 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob024_fsm | 2 | 11 | 2 | 0.1449 | 8 |
| `code_thought_front_slot_qd` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.1069 | 2 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob024_fsm | 2 | 6 | 1 | 0.1074 | 2 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob024_fsm | 2 | 4 | 2 | 0.1457 | 4 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob024_fsm | 2 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | RTLLM | Prob024_fsm | 2 | 9 | 2 | 0.1456 | 6 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob024_fsm | 2 | 8 | 2 | 0.1456 | 5 |
| `shape_density_front_pressure_qd` | RTLLM | Prob024_fsm | 2 | 7 | 2 | 0.1456 | 4 |
| `classic_revolution` | RTLLM | Prob037_parallel2serial | 3 | 6 | 1 | 0.0003 | 1 |
| `code_thought_front_slot_qd` | RTLLM | Prob037_parallel2serial | 3 | 5 | 1 | 0.0119 | 2 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 3 | 0.0000 | 0 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob037_parallel2serial | 3 | 2 | 1 | 0.0000 | 0 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob037_parallel2serial | 3 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 1 | 0.0006 | 1 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob037_parallel2serial | 3 | 4 | 4 | 0.0000 | 0 |
| `shape_density_front_pressure_qd` | RTLLM | Prob037_parallel2serial | 3 | 2 | 2 | 0.0000 | 0 |
| `classic_revolution` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.3067 | 14 |
| `code_thought_front_slot_qd` | RTLLM | Prob041_traffic_light | 2 | 8 | 2 | 0.2680 | 7 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob041_traffic_light | 2 | 22 | 1 | 0.2043 | 13 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob041_traffic_light | 2 | 23 | 3 | 0.2334 | 19 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob041_traffic_light | 2 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.2214 | 8 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob041_traffic_light | 2 | 15 | 2 | 0.2217 | 9 |
| `shape_density_front_pressure_qd` | RTLLM | Prob041_traffic_light | 2 | 11 | 2 | 0.2325 | 6 |
| `classic_revolution` | RTLLM | Prob045_alu | 2 | 9 | 1 | 0.1904 | 9 |
| `code_thought_front_slot_qd` | RTLLM | Prob045_alu | 2 | 17 | 1 | 0.2129 | 17 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob045_alu | 2 | 19 | 2 | 0.1871 | 19 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob045_alu | 2 | 11 | 1 | 0.2519 | 11 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob045_alu | 2 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | RTLLM | Prob045_alu | 2 | 21 | 1 | 0.2277 | 21 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob045_alu | 2 | 16 | 1 | 0.1836 | 16 |
| `shape_density_front_pressure_qd` | RTLLM | Prob045_alu | 2 | 16 | 2 | 0.2326 | 16 |
| `classic_revolution` | RTLLM | Prob049_signal_generator | 3 | 5 | 3 | 0.0128 | 3 |
| `code_thought_front_slot_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 2 | 0.0100 | 2 |
| `rtl_native_front_guarded_parent_qd` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `rtl_native_seeded_thought_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 1 | 0.0123 | 2 |
| `source_aligned_rtl_cell_qd` | RTLLM | Prob049_signal_generator | 3 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | RTLLM | Prob049_signal_generator | 3 | 2 | 1 | 0.0123 | 2 |
| `shape_density_front_slot_hybrid_qd` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `shape_density_front_pressure_qd` | RTLLM | Prob049_signal_generator | 3 | 1 | 1 | 0.0068 | 1 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 2 | 0.3975 | 5 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 2 | 1 | 0.3984 | 2 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 6 | 1 | 0.3984 | 6 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 4 | 1 | 0.3984 | 4 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 1 | 1 | 0.0000 | 0 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 2 | 1 | 0.0000 | 0 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 1 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 3 | 1 | 0.0000 | 2 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 2 | 2 | 0.0000 | 0 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 3 | 2 | 0.0000 | 0 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 1 | 1 | 0.0000 | 0 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 3 | 2 | 0.0000 | 0 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 1 | 1 | 0.0000 | 0 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 3 | 1 | 0.0000 | 0 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 1 | 1 | 0.0000 | 0 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 1 | 1 | 0.0000 | 0 |
| `classic_revolution` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 4 | 0.0002 | 1 |
| `code_thought_front_slot_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 15 | 5 | 0.0012 | 4 |
| `rtl_native_front_guarded_parent_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 16 | 3 | 0.0017 | 6 |
| `rtl_native_seeded_thought_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 0 | 0 | 0.0000 | 0 |
| `source_aligned_rtl_cell_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 10 | 6 | 0.0003 | 1 |
| `source_aligned_shape_density_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 8 | 3 | 0.0003 | 3 |
| `shape_density_front_slot_hybrid_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 7 | 3 | 0.0003 | 1 |
| `shape_density_front_pressure_qd` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 11 | 2 | 0.0031 | 5 |

## Problem Figures

| Benchmark | Problem | Pairwise | 3D |
| --- | --- | --- | --- |
| RTLLM | Prob004_adder_8bit | [pairwise_fronts.png](problems/RTLLM/Prob004_adder_8bit/pairwise_fronts.png) | n/a |
| RTLLM | Prob015_multi_pipe_8bit | [pairwise_fronts.png](problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png) |
| RTLLM | Prob024_fsm | [pairwise_fronts.png](problems/RTLLM/Prob024_fsm/pairwise_fronts.png) | n/a |
| RTLLM | Prob037_parallel2serial | [pairwise_fronts.png](problems/RTLLM/Prob037_parallel2serial/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob037_parallel2serial/front_3d.png) |
| RTLLM | Prob041_traffic_light | [pairwise_fronts.png](problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png) | n/a |
| RTLLM | Prob045_alu | [pairwise_fronts.png](problems/RTLLM/Prob045_alu/pairwise_fronts.png) | n/a |
| RTLLM | Prob049_signal_generator | [pairwise_fronts.png](problems/RTLLM/Prob049_signal_generator/pairwise_fronts.png) | [front_3d.png](problems/RTLLM/Prob049_signal_generator/front_3d.png) |
| VerilogEval-Spec-to-RTL | Prob098_circuit7 | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob098_circuit7/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot/pairwise_fronts.png) | n/a |
| VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob151_review2015_fsm/pairwise_fronts.png) | [front_3d.png](problems/VerilogEval-Spec-to-RTL/Prob151_review2015_fsm/front_3d.png) |
| VerilogEval-Spec-to-RTL | Prob153_gshare | [pairwise_fronts.png](problems/VerilogEval-Spec-to-RTL/Prob153_gshare/pairwise_fronts.png) | [front_3d.png](problems/VerilogEval-Spec-to-RTL/Prob153_gshare/front_3d.png) |
