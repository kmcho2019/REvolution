# Auto-BD Centralized Report

Phase: `development_preliminary_seed1`

Seed: `1001`

Status: generated from standardized result artifacts.

## Normalization

- Objective directions: minimize area, power, and effective clock.
- Improvement: `(reference - candidate) / max(abs(reference), 1e-12)`.
- Combinational tasks use area/power; sequential tasks also use effective clock.
- Hypervolume uses normalized improvement space against the zero-improvement reference point.
- Negative objective improvements are clipped to zero inside the hypervolume computation.
- Invalid candidates remain in generated/robustness counts but are excluded from valid-only PPA/HV.

## Gate Matrix

| Method | Gate 0 | Covered | Classic Covered | Missing Classic |
| --- | --- | --- | --- | --- |
| `classic_revolution` | PASS | 6 | 6 | - |
| `landing_smooth_qd_manual_bd` | PASS | 6 | 6 | - |
| `random_descriptor_qd` | PASS | 6 | 6 | - |
| `simple_yosys_stat_bd` | PASS | 6 | 6 | - |
| `netlist_motif_occupancy` | PASS | 6 | 6 | - |
| `synthesis_trajectory_nod` | PASS | 6 | 6 | - |
| `synthesis_trajectory_motif_nod` | PASS | 6 | 6 | - |
| `sr_raw_pca_qd` | PASS | 6 | 6 | - |
| `sr_random_relu_pca_qd` | PASS | 6 | 6 | - |
| `sr_rff_pca_qd` | PASS | 6 | 6 | - |

## Leaderboard

| Method | Valid PPA | Mean Fitness | Fitness W/T/L | Mean HV | HV W/T/L | PPA Grid Cells | PPA Grid Cov | Unique Netlists | Dup Netlists | Unique Motifs | PPA-Front Netlists | Audit Cells | Audit QD | Runtime s | LLM Calls |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 209 | 0.2671 | 0/6/0 | 0.1245 | 0/6/0 | 12 | 0.0703 | 70 | 139 | 43 | 12 | 12 | 2.3163 | 2472.4182 | 576 |
| `landing_smooth_qd_manual_bd` | 219 | 0.2271 | 0/5/1 | 0.1059 | 0/4/2 | 11 | 0.0755 | 61 | 158 | 33 | 18 | 9 | 1.8526 | 2634.4162 | 576 |
| `random_descriptor_qd` | 213 | 0.2645 | 0/6/0 | 0.1175 | 2/3/1 | 12 | 0.0703 | 64 | 149 | 41 | 21 | 8 | 1.7008 | 2836.8772 | 576 |
| `simple_yosys_stat_bd` | 201 | 0.2512 | 0/5/1 | 0.1242 | 1/3/2 | 12 | 0.0781 | 62 | 139 | 45 | 16 | 11 | 2.0779 | 2488.3132 | 576 |
| `netlist_motif_occupancy` | 192 | 0.2350 | 0/4/2 | 0.0606 | 1/3/2 | 11 | 0.0677 | 64 | 128 | 37 | 13 | 8 | -3.0274 | 2818.0163 | 576 |
| `synthesis_trajectory_nod` | 205 | 0.2511 | 0/5/1 | 0.1208 | 2/3/1 | 12 | 0.0781 | 72 | 133 | 52 | 13 | 11 | -2.0643 | 2732.1768 | 576 |
| `synthesis_trajectory_motif_nod` | 198 | 0.2380 | 0/5/1 | 0.1204 | 0/5/1 | 13 | 0.0807 | 77 | 121 | 45 | 20 | 16 | 1.7144 | 3322.3451 | 576 |
| `sr_raw_pca_qd` | 209 | 0.2404 | 0/5/1 | 0.1208 | 1/4/1 | 12 | 0.0703 | 74 | 135 | 48 | 14 | 12 | 1.9663 | 2588.9913 | 576 |
| `sr_random_relu_pca_qd` | 197 | 0.2536 | 1/4/1 | 0.1454 | 2/3/1 | 12 | 0.0781 | 68 | 129 | 44 | 11 | 10 | 2.3765 | 2647.4207 | 576 |
| `sr_rff_pca_qd` | 197 | 0.2630 | 0/6/0 | 0.1229 | 0/5/1 | 12 | 0.0703 | 63 | 134 | 43 | 20 | 10 | 2.8111 | 2343.7925 | 576 |

## QD Archive Metrics

Coverage and entropy are reported in the fixed common-audit space so methods with different internal BDs remain comparable.

| Method | Archive | Internal Cells | Internal QD | Internal Entropy | Audit Cells | Audit Coverage | Audit QD | Audit Entropy | Audit Entropy Norm |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `none` | - | - | - | 12 | 0.0078 | 2.3163 | 2.8589 | 0.2701 |
| `landing_smooth_qd_manual_bd` | `grid_quantile` | 15 | 2.5282 | 5.1224 | 9 | 0.0059 | 1.8526 | 2.6377 | 0.2492 |
| `random_descriptor_qd` | `grid_quantile` | 39 | 6.1505 | 5.5345 | 8 | 0.0052 | 1.7008 | 2.6551 | 0.2508 |
| `simple_yosys_stat_bd` | `grid_quantile` | 23 | 3.6027 | 5.4489 | 11 | 0.0072 | 2.0779 | 2.8840 | 0.2725 |
| `netlist_motif_occupancy` | `grid_quantile` | 26 | 3.8403 | 5.4977 | 8 | 0.0052 | -3.0274 | 2.6138 | 0.2469 |
| `synthesis_trajectory_nod` | `grid_quantile` | 31 | 4.0109 | 5.7798 | 11 | 0.0072 | -2.0643 | 2.8120 | 0.2657 |
| `synthesis_trajectory_motif_nod` | `grid_quantile` | 36 | 3.5386 | 5.5253 | 16 | 0.0104 | 1.7144 | 2.9868 | 0.2822 |
| `sr_raw_pca_qd` | `grid_quantile` | 27 | 4.7046 | 5.4744 | 12 | 0.0078 | 1.9663 | 2.8654 | 0.2707 |
| `sr_random_relu_pca_qd` | `grid_quantile` | 25 | 5.2658 | 5.1562 | 10 | 0.0065 | 2.3765 | 2.7269 | 0.2576 |
| `sr_rff_pca_qd` | `grid_quantile` | 19 | 4.1810 | 5.2490 | 10 | 0.0065 | 2.8111 | 2.6807 | 0.2533 |

## Descriptor/PPA Correlations

The JSON report includes Pearson correlations between descriptor axes and PPA/fitness metrics for internal and common-audit descriptor spaces.

## Representative Elite Examples

This compact table shows each method's best-fitness representative elite. The JSON report also includes per-problem best-fitness elite rows with RTL, netlist, and log paths.

| Method | Problem | Gen | Op | Fitness | Area | Power | Timing | Archive Cell | Audit Cell | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob019_sub_64bit` | 2 | `M-E` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `-` | `audit_motif4:2,0,1,0` | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample2_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample2_M-E/code.syn.v` |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob019_sub_64bit` | 2 | `M-E` | 0.4527 | 394.0000 | 0.0003 | 0.0000 | `2,0,2` | `audit_motif4:3,0,0,0` | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample2_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample2_M-E/code.syn.v` |
| `random_descriptor_qd` | `RTLLM/Prob019_sub_64bit` | 1 | `M-E` | 0.4527 | 394.0000 | 0.0003 | 0.0000 | `0,0,0` | `audit_motif4:3,0,0,0` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.syn.v` |
| `simple_yosys_stat_bd` | `RTLLM/Prob019_sub_64bit` | 1 | `M-E` | 0.4807 | 343.0000 | 0.0002 | 0.0000 | `0,0,3` | `audit_motif4:2,0,1,0` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample7_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample7_M-E/code.syn.v` |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 2 | `C-D` | 0.4370 | 1394.0000 | 0.0005 | 0.0000 | `1,0,0,1` | `audit_motif4:3,0,0,1` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample2_C-D/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample2_C-D/code.syn.v` |
| `synthesis_trajectory_nod` | `RTLLM/Prob019_sub_64bit` | 3 | `M-E` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `0,0,1,0,0` | `audit_motif4:2,0,1,0` | `.../RTLLM/Prob019_sub_64bit/Gen3/Prob019_sub_64bit_sample3_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen3/Prob019_sub_64bit_sample3_M-E/code.syn.v` |
| `synthesis_trajectory_motif_nod` | `RTLLM/Prob019_sub_64bit` | 1 | `M-E` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `0,1,3,0,0,0,1,0,0` | `audit_motif4:2,0,1,0` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.syn.v` |
| `sr_raw_pca_qd` | `RTLLM/Prob019_sub_64bit` | 1 | `M-E` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `0,2,0` | `audit_motif4:2,0,1,0` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.syn.v` |
| `sr_random_relu_pca_qd` | `RTLLM/Prob019_sub_64bit` | 1 | `M-E` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `0,2,0` | `audit_motif4:2,0,1,0` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.syn.v` |
| `sr_rff_pca_qd` | `RTLLM/Prob019_sub_64bit` | 1 | `M-E` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `2,2,0` | `audit_motif4:2,0,1,0` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.syn.v` |

## Robustness Funnel

| Method | Total | Syntax | Functionality | Synthesis | OpenROAD | Valid PPA |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 288 | 275 (95.5%) | 209 (72.6%) | 209 (72.6%) | 209 (72.6%) | 209 (72.6%) |
| `landing_smooth_qd_manual_bd` | 288 | 275 (95.5%) | 219 (76.0%) | 219 (76.0%) | 219 (76.0%) | 219 (76.0%) |
| `random_descriptor_qd` | 288 | 248 (86.1%) | 213 (74.0%) | 213 (74.0%) | 213 (74.0%) | 213 (74.0%) |
| `simple_yosys_stat_bd` | 288 | 257 (89.2%) | 201 (69.8%) | 201 (69.8%) | 201 (69.8%) | 201 (69.8%) |
| `netlist_motif_occupancy` | 288 | 251 (87.2%) | 192 (66.7%) | 192 (66.7%) | 192 (66.7%) | 192 (66.7%) |
| `synthesis_trajectory_nod` | 288 | 259 (89.9%) | 205 (71.2%) | 205 (71.2%) | 205 (71.2%) | 205 (71.2%) |
| `synthesis_trajectory_motif_nod` | 288 | 259 (89.9%) | 198 (68.8%) | 198 (68.8%) | 198 (68.8%) | 198 (68.8%) |
| `sr_raw_pca_qd` | 288 | 261 (90.6%) | 209 (72.6%) | 209 (72.6%) | 209 (72.6%) | 209 (72.6%) |
| `sr_random_relu_pca_qd` | 288 | 240 (83.3%) | 197 (68.4%) | 197 (68.4%) | 197 (68.4%) | 197 (68.4%) |
| `sr_rff_pca_qd` | 288 | 246 (85.4%) | 197 (68.4%) | 197 (68.4%) | 197 (68.4%) | 197 (68.4%) |

## Failure Breakdown

| Method | Failure Reason | Count |
| --- | --- | --- |
| `classic_revolution` | `failed_functionality` | 66 |
| `classic_revolution` | `failed_syntax` | 13 |
| `landing_smooth_qd_manual_bd` | `failed_functionality` | 56 |
| `landing_smooth_qd_manual_bd` | `failed_syntax` | 13 |
| `random_descriptor_qd` | `failed_functionality` | 35 |
| `random_descriptor_qd` | `failed_syntax` | 22 |
| `random_descriptor_qd` | `failed_diff` | 17 |
| `random_descriptor_qd` | `failed_synthesis` | 1 |
| `simple_yosys_stat_bd` | `failed_functionality` | 56 |
| `simple_yosys_stat_bd` | `failed_diff` | 22 |
| `simple_yosys_stat_bd` | `failed_syntax` | 9 |
| `netlist_motif_occupancy` | `failed_functionality` | 59 |
| `netlist_motif_occupancy` | `failed_syntax` | 18 |
| `netlist_motif_occupancy` | `failed_diff` | 18 |
| `netlist_motif_occupancy` | `failed_format` | 1 |
| `synthesis_trajectory_nod` | `failed_functionality` | 53 |
| `synthesis_trajectory_nod` | `failed_syntax` | 15 |
| `synthesis_trajectory_nod` | `failed_diff` | 14 |
| `synthesis_trajectory_nod` | `failed_synthesis_functionality` | 1 |
| `synthesis_trajectory_motif_nod` | `failed_functionality` | 59 |
| `synthesis_trajectory_motif_nod` | `failed_syntax` | 18 |
| `synthesis_trajectory_motif_nod` | `failed_diff` | 11 |
| `synthesis_trajectory_motif_nod` | `failed_synthesis_functionality` | 2 |
| `sr_raw_pca_qd` | `failed_functionality` | 48 |
| `sr_raw_pca_qd` | `failed_diff` | 17 |
| `sr_raw_pca_qd` | `failed_syntax` | 10 |
| `sr_raw_pca_qd` | `failed_synthesis_functionality` | 2 |
| `sr_raw_pca_qd` | `failed_synthesis` | 2 |
| `sr_random_relu_pca_qd` | `failed_functionality` | 43 |
| `sr_random_relu_pca_qd` | `failed_diff` | 36 |
| `sr_random_relu_pca_qd` | `failed_syntax` | 12 |
| `sr_rff_pca_qd` | `failed_functionality` | 49 |
| `sr_rff_pca_qd` | `failed_diff` | 21 |
| `sr_rff_pca_qd` | `failed_syntax` | 20 |
| `sr_rff_pca_qd` | `failed_format` | 1 |

## Anytime Summary

| Method | Final Gen | Final Covered | Final Fitness | Final HV | Fitness AUC | HV AUC |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 3 | 6 | 0.2671 | 0.1245 | 0.2327 | 0.0728 |
| `landing_smooth_qd_manual_bd` | 3 | 6 | 0.2271 | 0.1059 | 0.2095 | 0.0643 |
| `random_descriptor_qd` | 3 | 6 | 0.2645 | 0.1175 | 0.2451 | 0.0987 |
| `simple_yosys_stat_bd` | 3 | 6 | 0.2512 | 0.1242 | 0.2262 | 0.0919 |
| `netlist_motif_occupancy` | 3 | 6 | 0.2350 | 0.0606 | 0.2087 | 0.0416 |
| `synthesis_trajectory_nod` | 3 | 6 | 0.2511 | 0.1208 | 0.2214 | 0.0789 |
| `synthesis_trajectory_motif_nod` | 3 | 6 | 0.2380 | 0.1204 | 0.2221 | 0.0903 |
| `sr_raw_pca_qd` | 3 | 6 | 0.2404 | 0.1208 | 0.2206 | 0.0904 |
| `sr_random_relu_pca_qd` | 3 | 6 | 0.2536 | 0.1454 | 0.2369 | 0.1202 |
| `sr_rff_pca_qd` | 3 | 6 | 0.2630 | 0.1229 | 0.2340 | 0.0801 |

The JSON report includes per-generation anytime rows for each method.

## Figures

- `anytime_mean_best_fitness`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/anytime_mean_best_fitness.png`
- `anytime_mean_hypervolume`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/anytime_mean_hypervolume.png`
- `descriptor_common_audit_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/descriptor_common_audit_ppa_correlation.png`
- `descriptor_internal_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/descriptor_internal_ppa_correlation.png`
- `manual_bd_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/manual_bd_ppa_correlation.png`
- `ppa_grid_coverage`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/ppa_grid_coverage.png`
- `qd_common_audit_cells_heatmap`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/qd_common_audit_cells_heatmap.png`
- `qd_common_audit_coverage`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/qd_common_audit_coverage.png`
- `qd_common_audit_entropy`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/qd_common_audit_entropy.png`

## Per-Problem Win/Loss Matrix

| Method | Problem | Fitness Delta | Fitness | HV Delta | HV |
| --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob011_multi_16bit` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob019_sub_64bit` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob048_pe` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob011_multi_16bit` | -0.2114 | L | -0.0245 | L |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob019_sub_64bit` | -0.0296 | T | -0.0871 | L |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob048_pe` | 0.0010 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `RTLLM/Prob011_multi_16bit` | -0.0004 | T | 0.0023 | W |
| `random_descriptor_qd` | `RTLLM/Prob019_sub_64bit` | -0.0296 | T | -0.0871 | L |
| `random_descriptor_qd` | `RTLLM/Prob048_pe` | 0.0010 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0138 | T | 0.0429 | W |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | -0.0002 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `simple_yosys_stat_bd` | `RTLLM/Prob011_multi_16bit` | -0.1111 | L | -0.0245 | L |
| `simple_yosys_stat_bd` | `RTLLM/Prob019_sub_64bit` | -0.0016 | T | -0.0048 | L |
| `simple_yosys_stat_bd` | `RTLLM/Prob048_pe` | 0.0063 | T | 0.0000 | T |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0115 | T | 0.0275 | W |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `netlist_motif_occupancy` | `RTLLM/Prob011_multi_16bit` | -0.0681 | L | -0.0227 | L |
| `netlist_motif_occupancy` | `RTLLM/Prob019_sub_64bit` | -0.1368 | L | -0.4037 | L |
| `netlist_motif_occupancy` | `RTLLM/Prob048_pe` | -0.0029 | T | 0.0000 | T |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0138 | T | 0.0429 | W |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0000 | T | 0.0000 | T |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0016 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob011_multi_16bit` | -0.1008 | L | -0.0245 | L |
| `synthesis_trajectory_nod` | `RTLLM/Prob019_sub_64bit` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob048_pe` | 0.0013 | T | 0.0000 | W |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0036 | T | 0.0026 | W |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_motif_nod` | `RTLLM/Prob011_multi_16bit` | -0.1717 | L | -0.0245 | L |
| `synthesis_trajectory_motif_nod` | `RTLLM/Prob019_sub_64bit` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_motif_nod` | `RTLLM/Prob048_pe` | -0.0029 | T | 0.0000 | T |
| `synthesis_trajectory_motif_nod` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_motif_nod` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_motif_nod` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `sr_raw_pca_qd` | `RTLLM/Prob011_multi_16bit` | -0.1582 | L | -0.0245 | L |
| `sr_raw_pca_qd` | `RTLLM/Prob019_sub_64bit` | 0.0000 | T | 0.0000 | T |
| `sr_raw_pca_qd` | `RTLLM/Prob048_pe` | -0.0047 | T | 0.0000 | T |
| `sr_raw_pca_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `sr_raw_pca_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0032 | T | 0.0026 | W |
| `sr_raw_pca_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `RTLLM/Prob011_multi_16bit` | -0.1425 | L | -0.0229 | L |
| `sr_random_relu_pca_qd` | `RTLLM/Prob019_sub_64bit` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `RTLLM/Prob048_pe` | 0.0095 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0488 | W | 0.1460 | W |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0035 | T | 0.0026 | W |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `sr_rff_pca_qd` | `RTLLM/Prob011_multi_16bit` | -0.0214 | T | -0.0093 | L |
| `sr_rff_pca_qd` | `RTLLM/Prob019_sub_64bit` | 0.0000 | T | 0.0000 | T |
| `sr_rff_pca_qd` | `RTLLM/Prob048_pe` | -0.0029 | T | 0.0000 | T |
| `sr_rff_pca_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `sr_rff_pca_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | -0.0002 | T | 0.0000 | T |
| `sr_rff_pca_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |

## Per-Problem PPA And Diversity

| Method | Problem | Valid PPA | Best Fitness | HV | PPA Grid Cells | PPA Grid Cov | Pareto Points | Ref-Beating | Unique Netlists | Dup Netlists | PPA-Front Netlists | Objectives |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob011_multi_16bit` | 16 | 0.3647 | 0.0245 | 5 | 0.0781 | 1 | 3 | 12 | 4 | 1 | area/power/eff_clk_period |
| `classic_revolution` | `RTLLM/Prob019_sub_64bit` | 43 | 0.4823 | 0.4499 | 2 | 0.1250 | 3 | 6 | 12 | 31 | 3 | area/power |
| `classic_revolution` | `RTLLM/Prob048_pe` | 27 | 0.0056 | 0.0000 | 1 | 0.0156 | 8 | 11 | 4 | 23 | 2 | area/power/eff_clk_period |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 31 | 0.4232 | 0.2724 | 2 | 0.1250 | 5 | 31 | 4 | 27 | 1 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 48 | 0.2851 | 0.0000 | 1 | 0.0625 | 1 | 22 | 19 | 29 | 1 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 44 | 0.0416 | 0.0000 | 1 | 0.0156 | 15 | 15 | 19 | 25 | 4 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob011_multi_16bit` | 27 | 0.1533 | 0.0000 | 3 | 0.0469 | 14 | 0 | 18 | 9 | 7 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob019_sub_64bit` | 45 | 0.4527 | 0.3628 | 3 | 0.1875 | 1 | 5 | 8 | 37 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob048_pe` | 24 | 0.0066 | 0.0000 | 1 | 0.0156 | 13 | 12 | 5 | 19 | 2 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 38 | 0.4232 | 0.2724 | 2 | 0.1250 | 8 | 38 | 3 | 35 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 45 | 0.2851 | 0.0000 | 1 | 0.0625 | 1 | 23 | 17 | 28 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 40 | 0.0416 | 0.0000 | 1 | 0.0156 | 24 | 24 | 10 | 30 | 6 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob011_multi_16bit` | 33 | 0.3643 | 0.0268 | 5 | 0.0781 | 1 | 4 | 20 | 13 | 1 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob019_sub_64bit` | 36 | 0.4527 | 0.3628 | 2 | 0.1250 | 1 | 2 | 6 | 30 | 1 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob048_pe` | 26 | 0.0066 | 0.0000 | 1 | 0.0156 | 6 | 9 | 7 | 19 | 4 | area/power/eff_clk_period |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 40 | 0.4370 | 0.3153 | 2 | 0.1250 | 5 | 40 | 4 | 36 | 2 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 37 | 0.2850 | 0.0000 | 1 | 0.0625 | 15 | 14 | 13 | 24 | 7 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 41 | 0.0416 | 0.0000 | 1 | 0.0156 | 26 | 26 | 14 | 27 | 6 | area/power/eff_clk_period |
| `simple_yosys_stat_bd` | `RTLLM/Prob011_multi_16bit` | 26 | 0.2536 | 0.0000 | 4 | 0.0625 | 14 | 0 | 17 | 9 | 6 | area/power/eff_clk_period |
| `simple_yosys_stat_bd` | `RTLLM/Prob019_sub_64bit` | 40 | 0.4807 | 0.4451 | 3 | 0.1875 | 1 | 3 | 6 | 34 | 1 | area/power |
| `simple_yosys_stat_bd` | `RTLLM/Prob048_pe` | 23 | 0.0119 | 0.0000 | 1 | 0.0156 | 6 | 9 | 6 | 17 | 3 | area/power/eff_clk_period |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 28 | 0.4232 | 0.2724 | 2 | 0.1250 | 1 | 28 | 4 | 24 | 1 | area/power |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 42 | 0.2966 | 0.0275 | 1 | 0.0625 | 5 | 15 | 13 | 29 | 3 | area/power |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 42 | 0.0416 | 0.0000 | 1 | 0.0156 | 16 | 16 | 16 | 26 | 2 | area/power/eff_clk_period |
| `netlist_motif_occupancy` | `RTLLM/Prob011_multi_16bit` | 22 | 0.2966 | 0.0018 | 4 | 0.0625 | 10 | 3 | 17 | 5 | 6 | area/power/eff_clk_period |
| `netlist_motif_occupancy` | `RTLLM/Prob019_sub_64bit` | 40 | 0.3455 | 0.0462 | 2 | 0.1250 | 2 | 4 | 8 | 32 | 1 | area/power |
| `netlist_motif_occupancy` | `RTLLM/Prob048_pe` | 22 | 0.0026 | 0.0000 | 1 | 0.0156 | 3 | 10 | 5 | 17 | 2 | area/power/eff_clk_period |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 34 | 0.4370 | 0.3153 | 2 | 0.1250 | 5 | 34 | 4 | 30 | 2 | area/power |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 38 | 0.2851 | 0.0000 | 1 | 0.0625 | 1 | 22 | 14 | 24 | 1 | area/power |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 36 | 0.0432 | 0.0000 | 1 | 0.0156 | 1 | 25 | 16 | 20 | 1 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob011_multi_16bit` | 31 | 0.2639 | 0.0000 | 4 | 0.0625 | 5 | 0 | 24 | 7 | 5 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob019_sub_64bit` | 41 | 0.4823 | 0.4499 | 3 | 0.1875 | 1 | 5 | 10 | 31 | 1 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob048_pe` | 26 | 0.0069 | 0.0000 | 1 | 0.0156 | 4 | 10 | 6 | 20 | 2 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 31 | 0.4232 | 0.2724 | 2 | 0.1250 | 4 | 31 | 3 | 28 | 1 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 36 | 0.2887 | 0.0026 | 1 | 0.0625 | 2 | 18 | 14 | 22 | 2 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 40 | 0.0416 | 0.0000 | 1 | 0.0156 | 20 | 21 | 15 | 25 | 2 | area/power/eff_clk_period |
| `synthesis_trajectory_motif_nod` | `RTLLM/Prob011_multi_16bit` | 27 | 0.1930 | 0.0000 | 5 | 0.0781 | 13 | 0 | 22 | 5 | 10 | area/power/eff_clk_period |
| `synthesis_trajectory_motif_nod` | `RTLLM/Prob019_sub_64bit` | 41 | 0.4823 | 0.4499 | 3 | 0.1875 | 2 | 12 | 13 | 28 | 2 | area/power |
| `synthesis_trajectory_motif_nod` | `RTLLM/Prob048_pe` | 23 | 0.0026 | 0.0000 | 1 | 0.0156 | 1 | 9 | 3 | 20 | 1 | area/power/eff_clk_period |
| `synthesis_trajectory_motif_nod` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 27 | 0.4232 | 0.2724 | 2 | 0.1250 | 9 | 27 | 3 | 24 | 1 | area/power |
| `synthesis_trajectory_motif_nod` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 41 | 0.2851 | 0.0000 | 1 | 0.0625 | 3 | 30 | 21 | 20 | 3 | area/power |
| `synthesis_trajectory_motif_nod` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 39 | 0.0416 | 0.0000 | 1 | 0.0156 | 14 | 14 | 15 | 24 | 3 | area/power/eff_clk_period |
| `sr_raw_pca_qd` | `RTLLM/Prob011_multi_16bit` | 34 | 0.2065 | 0.0000 | 5 | 0.0781 | 12 | 0 | 22 | 12 | 5 | area/power/eff_clk_period |
| `sr_raw_pca_qd` | `RTLLM/Prob019_sub_64bit` | 47 | 0.4823 | 0.4499 | 2 | 0.1250 | 2 | 9 | 15 | 32 | 1 | area/power |
| `sr_raw_pca_qd` | `RTLLM/Prob048_pe` | 15 | 0.0008 | 0.0000 | 1 | 0.0156 | 10 | 10 | 2 | 13 | 1 | area/power/eff_clk_period |
| `sr_raw_pca_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 35 | 0.4232 | 0.2724 | 2 | 0.1250 | 4 | 35 | 4 | 31 | 1 | area/power |
| `sr_raw_pca_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 36 | 0.2883 | 0.0026 | 1 | 0.0625 | 1 | 18 | 12 | 24 | 1 | area/power |
| `sr_raw_pca_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 42 | 0.0416 | 0.0000 | 1 | 0.0156 | 20 | 20 | 19 | 23 | 5 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `RTLLM/Prob011_multi_16bit` | 31 | 0.2222 | 0.0016 | 4 | 0.0625 | 4 | 3 | 22 | 9 | 4 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `RTLLM/Prob019_sub_64bit` | 44 | 0.4823 | 0.4499 | 3 | 0.1875 | 2 | 6 | 12 | 32 | 1 | area/power |
| `sr_random_relu_pca_qd` | `RTLLM/Prob048_pe` | 15 | 0.0150 | 0.0000 | 1 | 0.0156 | 3 | 8 | 4 | 11 | 2 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 35 | 0.4720 | 0.4184 | 2 | 0.1250 | 3 | 35 | 7 | 28 | 2 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 31 | 0.2886 | 0.0026 | 1 | 0.0625 | 1 | 14 | 12 | 19 | 1 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 41 | 0.0416 | 0.0000 | 1 | 0.0156 | 15 | 15 | 11 | 30 | 1 | area/power/eff_clk_period |
| `sr_rff_pca_qd` | `RTLLM/Prob011_multi_16bit` | 33 | 0.3433 | 0.0153 | 5 | 0.0781 | 5 | 6 | 21 | 12 | 5 | area/power/eff_clk_period |
| `sr_rff_pca_qd` | `RTLLM/Prob019_sub_64bit` | 45 | 0.4823 | 0.4499 | 2 | 0.1250 | 2 | 7 | 12 | 33 | 1 | area/power |
| `sr_rff_pca_qd` | `RTLLM/Prob048_pe` | 20 | 0.0026 | 0.0000 | 1 | 0.0156 | 4 | 8 | 4 | 16 | 2 | area/power/eff_clk_period |
| `sr_rff_pca_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 20 | 0.4232 | 0.2724 | 2 | 0.1250 | 1 | 20 | 4 | 16 | 1 | area/power |
| `sr_rff_pca_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 42 | 0.2850 | 0.0000 | 1 | 0.0625 | 18 | 14 | 10 | 32 | 8 | area/power |
| `sr_rff_pca_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 37 | 0.0416 | 0.0000 | 1 | 0.0156 | 16 | 16 | 12 | 25 | 3 | area/power/eff_clk_period |

## Artifact Roots

- `classic_revolution`: `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/standard_results`
- `landing_smooth_qd_manual_bd`: `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/standard_results`
- `random_descriptor_qd`: `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/standard_results`
- `simple_yosys_stat_bd`: `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/standard_results`
- `netlist_motif_occupancy`: `exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/standard_results`
- `synthesis_trajectory_nod`: `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`
- `synthesis_trajectory_motif_nod`: `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001/standard_results`
- `sr_raw_pca_qd`: `exp/auto_bd_research/development_preliminary_seed1/sr_raw_pca_qd/seed_1001/standard_results`
- `sr_random_relu_pca_qd`: `exp/auto_bd_research/development_preliminary_seed1/sr_random_relu_pca_qd/seed_1001/standard_results`
- `sr_rff_pca_qd`: `exp/auto_bd_research/development_preliminary_seed1/sr_rff_pca_qd/seed_1001/standard_results`
