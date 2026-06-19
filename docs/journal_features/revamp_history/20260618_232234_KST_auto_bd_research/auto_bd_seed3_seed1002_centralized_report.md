# Auto-BD Centralized Report

Phase: `main_screening`

Seed: `1002`

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
| `classic_revolution` | PASS | 13 | 13 | - |
| `landing_smooth_qd_manual_bd` | PASS | 13 | 13 | - |
| `random_descriptor_qd` | PASS | 13 | 13 | - |
| `synthesis_trajectory_nod` | PASS | 13 | 13 | - |
| `sr_random_relu_pca_qd` | PASS | 13 | 13 | - |

## Leaderboard

| Method | Valid PPA | Mean Fitness | Fitness W/T/L | Mean HV | HV W/T/L | Unique Netlists | Dup Netlists | Unique Motifs | PPA-Front Netlists | Audit Cells | Audit QD | Runtime s | LLM Calls |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 735 | 0.2714 | 0/13/0 | 0.1148 | 0/13/0 | 329 | 406 | 250 | 53 | 41 | 7.4138 | 21742.7283 | 3120 |
| `landing_smooth_qd_manual_bd` | 807 | 0.3027 | 3/9/1 | 0.1296 | 3/7/3 | 342 | 465 | 253 | 57 | 41 | 9.7885 | 21917.1870 | 3120 |
| `random_descriptor_qd` | 696 | 0.2831 | 2/10/1 | 0.1111 | 2/7/4 | 295 | 401 | 196 | 54 | 38 | 8.3432 | 23875.0822 | 3120 |
| `synthesis_trajectory_nod` | 600 | 0.2599 | 2/9/2 | 0.1110 | 0/7/6 | 290 | 310 | 197 | 63 | 37 | 8.1541 | 23879.4614 | 3120 |
| `sr_random_relu_pca_qd` | 638 | 0.2730 | 2/10/1 | 0.1331 | 3/6/4 | 299 | 339 | 217 | 57 | 40 | 8.1673 | 22730.4771 | 3120 |

## QD Archive Metrics

Coverage and entropy are reported in the fixed common-audit space so methods with different internal BDs remain comparable.

| Method | Archive | Internal Cells | Internal QD | Internal Entropy | Audit Cells | Audit Coverage | Audit QD | Audit Entropy | Audit Entropy Norm |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `none` | - | - | - | 41 | 0.0123 | 7.4138 | 4.5261 | 0.3868 |
| `landing_smooth_qd_manual_bd` | `grid_quantile` | 80 | 14.9662 | 5.9618 | 41 | 0.0123 | 9.7885 | 4.4497 | 0.3803 |
| `random_descriptor_qd` | `grid_quantile` | 176 | 27.8344 | 6.8259 | 38 | 0.0114 | 8.3432 | 4.4068 | 0.3766 |
| `synthesis_trajectory_nod` | `grid_quantile` | 118 | 9.1115 | 6.4046 | 37 | 0.0111 | 8.1541 | 4.6269 | 0.3954 |
| `sr_random_relu_pca_qd` | `grid_quantile` | 102 | 12.7465 | 6.5906 | 40 | 0.0120 | 8.1673 | 4.6072 | 0.3938 |

## Descriptor/PPA Correlations

The JSON report includes Pearson correlations between descriptor axes and PPA/fitness metrics for internal and common-audit descriptor spaces.

## Representative Elite Examples

This compact table shows each method's best-fitness representative elite. The JSON report also includes per-problem best-fitness elite rows with RTL, netlist, and log paths.

| Method | Problem | Gen | Op | Fitness | Area | Power | Timing | Archive Cell | Audit Cell | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob024_fsm` | 1 | `C-F` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `-` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen1/Prob024_fsm_sample16_C-F/code.sv` | `.../RTLLM/Prob024_fsm/Gen1/Prob024_fsm_sample16_C-F/code.syn.v` |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob024_fsm` | 1 | `M-E` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `warmup:6` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen1/Prob024_fsm_sample16_M-E/code.sv` | `.../RTLLM/Prob024_fsm/Gen1/Prob024_fsm_sample16_M-E/code.syn.v` |
| `random_descriptor_qd` | `RTLLM/Prob024_fsm` | 2 | `M-E` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `0,3,3` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample10_M-E/code.sv` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample10_M-E/code.syn.v` |
| `synthesis_trajectory_nod` | `RTLLM/Prob024_fsm` | 2 | `M-E` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `warmup:6` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample1_M-E/code.sv` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample1_M-E/code.syn.v` |
| `sr_random_relu_pca_qd` | `RTLLM/Prob024_fsm` | 2 | `C-D` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `0,1,0` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample11_C-D/code.sv` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample11_C-D/code.syn.v` |

## Robustness Funnel

| Method | Total | Syntax | Functionality | Synthesis | OpenROAD | Valid PPA |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 1560 | 1451 (93.0%) | 735 (47.1%) | 735 (47.1%) | 735 (47.1%) | 735 (47.1%) |
| `landing_smooth_qd_manual_bd` | 1560 | 1488 (95.4%) | 807 (51.7%) | 807 (51.7%) | 807 (51.7%) | 807 (51.7%) |
| `random_descriptor_qd` | 1560 | 1385 (88.8%) | 696 (44.6%) | 696 (44.6%) | 696 (44.6%) | 696 (44.6%) |
| `synthesis_trajectory_nod` | 1560 | 1378 (88.3%) | 600 (38.5%) | 600 (38.5%) | 600 (38.5%) | 600 (38.5%) |
| `sr_random_relu_pca_qd` | 1560 | 1352 (86.7%) | 638 (40.9%) | 638 (40.9%) | 638 (40.9%) | 638 (40.9%) |

## Failure Breakdown

| Method | Failure Reason | Count |
| --- | --- | --- |
| `classic_revolution` | `failed_functionality` | 699 |
| `classic_revolution` | `failed_syntax` | 107 |
| `classic_revolution` | `failed_synthesis_functionality` | 16 |
| `classic_revolution` | `failed_format` | 2 |
| `classic_revolution` | `failed_synthesis` | 1 |
| `landing_smooth_qd_manual_bd` | `failed_functionality` | 670 |
| `landing_smooth_qd_manual_bd` | `failed_syntax` | 72 |
| `landing_smooth_qd_manual_bd` | `failed_synthesis_functionality` | 9 |
| `landing_smooth_qd_manual_bd` | `failed_synthesis` | 2 |
| `random_descriptor_qd` | `failed_functionality` | 681 |
| `random_descriptor_qd` | `failed_syntax` | 87 |
| `random_descriptor_qd` | `failed_diff` | 84 |
| `random_descriptor_qd` | `failed_synthesis_functionality` | 8 |
| `random_descriptor_qd` | `failed_format` | 4 |
| `synthesis_trajectory_nod` | `failed_functionality` | 762 |
| `synthesis_trajectory_nod` | `failed_syntax` | 101 |
| `synthesis_trajectory_nod` | `failed_diff` | 77 |
| `synthesis_trajectory_nod` | `failed_synthesis_functionality` | 13 |
| `synthesis_trajectory_nod` | `failed_format` | 4 |
| `synthesis_trajectory_nod` | `failed_synthesis` | 3 |
| `sr_random_relu_pca_qd` | `failed_functionality` | 698 |
| `sr_random_relu_pca_qd` | `failed_syntax` | 108 |
| `sr_random_relu_pca_qd` | `failed_diff` | 97 |
| `sr_random_relu_pca_qd` | `failed_synthesis_functionality` | 14 |
| `sr_random_relu_pca_qd` | `failed_format` | 3 |
| `sr_random_relu_pca_qd` | `failed_synthesis` | 2 |

## Anytime Summary

| Method | Final Gen | Final Covered | Final Fitness | Final HV | Fitness AUC | HV AUC |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 5 | 13 | 0.2714 | 0.1148 | 0.2575 | 0.1022 |
| `landing_smooth_qd_manual_bd` | 5 | 13 | 0.3027 | 0.1296 | 0.2678 | 0.1093 |
| `random_descriptor_qd` | 5 | 13 | 0.2831 | 0.1111 | 0.2619 | 0.1014 |
| `synthesis_trajectory_nod` | 5 | 13 | 0.2599 | 0.1110 | 0.2321 | 0.0934 |
| `sr_random_relu_pca_qd` | 5 | 13 | 0.2730 | 0.1331 | 0.2545 | 0.1080 |

The JSON report includes per-generation anytime rows for each method.

## Figures

- `anytime_mean_best_fitness`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1002/anytime_mean_best_fitness.png`
- `anytime_mean_hypervolume`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1002/anytime_mean_hypervolume.png`
- `descriptor_common_audit_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1002/descriptor_common_audit_ppa_correlation.png`
- `descriptor_internal_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1002/descriptor_internal_ppa_correlation.png`
- `manual_bd_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1002/manual_bd_ppa_correlation.png`
- `qd_common_audit_cells_heatmap`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1002/qd_common_audit_cells_heatmap.png`
- `qd_common_audit_coverage`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1002/qd_common_audit_coverage.png`
- `qd_common_audit_entropy`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1002/qd_common_audit_entropy.png`

## Per-Problem Win/Loss Matrix

| Method | Problem | Fitness Delta | Fitness | HV Delta | HV |
| --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob015_multi_pipe_8bit` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob037_parallel2serial` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob041_traffic_light` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob045_alu` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob049_signal_generator` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob015_multi_pipe_8bit` | -0.0913 | L | -0.0000 | L |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob037_parallel2serial` | 0.3840 | W | 0.0908 | W |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob041_traffic_light` | 0.0392 | W | 0.0935 | W |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob045_alu` | 0.0038 | T | 0.0112 | W |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob049_signal_generator` | 0.0000 | T | -0.0034 | L |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | -0.0005 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0858 | W | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | -0.0138 | T | -0.0002 | L |
| `random_descriptor_qd` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `RTLLM/Prob015_multi_pipe_8bit` | -0.0093 | T | -0.0000 | L |
| `random_descriptor_qd` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `RTLLM/Prob037_parallel2serial` | 0.0071 | T | -0.0002 | L |
| `random_descriptor_qd` | `RTLLM/Prob041_traffic_light` | -0.0351 | L | -0.0665 | L |
| `random_descriptor_qd` | `RTLLM/Prob045_alu` | 0.0061 | T | 0.0183 | W |
| `random_descriptor_qd` | `RTLLM/Prob049_signal_generator` | 0.0263 | T | -0.0009 | L |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 0.0669 | W | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0826 | W | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 0.0073 | T | 0.0004 | W |
| `synthesis_trajectory_nod` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob015_multi_pipe_8bit` | -0.1797 | L | -0.0000 | L |
| `synthesis_trajectory_nod` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob037_parallel2serial` | -0.0213 | T | -0.0001 | L |
| `synthesis_trajectory_nod` | `RTLLM/Prob041_traffic_light` | -0.0135 | T | -0.0189 | L |
| `synthesis_trajectory_nod` | `RTLLM/Prob045_alu` | -0.0080 | T | -0.0237 | L |
| `synthesis_trajectory_nod` | `RTLLM/Prob049_signal_generator` | -0.0034 | T | -0.0062 | L |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 0.0669 | W | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0670 | W | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | -0.0573 | L | -0.0015 | L |
| `sr_random_relu_pca_qd` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `RTLLM/Prob015_multi_pipe_8bit` | -0.1715 | L | -0.0000 | L |
| `sr_random_relu_pca_qd` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `RTLLM/Prob037_parallel2serial` | 0.0254 | T | -0.0001 | L |
| `sr_random_relu_pca_qd` | `RTLLM/Prob041_traffic_light` | -0.0267 | T | 0.0173 | W |
| `sr_random_relu_pca_qd` | `RTLLM/Prob045_alu` | 0.0085 | T | 0.0250 | W |
| `sr_random_relu_pca_qd` | `RTLLM/Prob049_signal_generator` | 0.0000 | T | -0.0030 | L |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 0.1336 | W | 0.1986 | W |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0758 | W | 0.0000 | T |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | -0.0241 | T | -0.0009 | L |

## Per-Problem PPA And Diversity

| Method | Problem | Valid PPA | Best Fitness | HV | Pareto Points | Ref-Beating | Unique Netlists | Dup Netlists | PPA-Front Netlists | Objectives |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob004_adder_8bit` | 82 | 0.3815 | 0.1510 | 14 | 37 | 24 | 58 | 1 | area/power |
| `classic_revolution` | `RTLLM/Prob015_multi_pipe_8bit` | 34 | 0.2325 | 0.0000 | 11 | 1 | 33 | 1 | 11 | area/power/eff_clk_period |
| `classic_revolution` | `RTLLM/Prob024_fsm` | 32 | 0.6835 | 0.3406 | 3 | 19 | 21 | 11 | 2 | area/power |
| `classic_revolution` | `RTLLM/Prob037_parallel2serial` | 33 | 0.0846 | 0.0003 | 2 | 5 | 22 | 11 | 2 | area/power/eff_clk_period |
| `classic_revolution` | `RTLLM/Prob041_traffic_light` | 69 | 0.4344 | 0.3324 | 5 | 65 | 53 | 16 | 4 | area/power |
| `classic_revolution` | `RTLLM/Prob045_alu` | 74 | 0.4132 | 0.2457 | 3 | 74 | 67 | 7 | 3 | area/power |
| `classic_revolution` | `RTLLM/Prob049_signal_generator` | 51 | 0.2598 | 0.0225 | 34 | 44 | 21 | 30 | 11 | area/power/eff_clk_period |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 74 | 0.0120 | 0.0000 | 25 | 26 | 8 | 66 | 2 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 65 | 0.4654 | 0.3984 | 5 | 65 | 16 | 49 | 2 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 101 | 0.2641 | 0.0000 | 1 | 0 | 12 | 89 | 1 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 50 | 0.3297 | 0.0000 | 26 | 47 | 8 | 42 | 3 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 16 | -0.1929 | 0.0000 | 8 | 0 | 16 | 0 | 8 | area/power/eff_clk_period |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 54 | 0.1597 | 0.0018 | 3 | 23 | 28 | 26 | 3 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob004_adder_8bit` | 86 | 0.3815 | 0.1510 | 14 | 50 | 31 | 55 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob015_multi_pipe_8bit` | 38 | 0.1413 | 0.0000 | 8 | 0 | 33 | 5 | 7 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob024_fsm` | 20 | 0.6835 | 0.3406 | 1 | 16 | 18 | 2 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob037_parallel2serial` | 35 | 0.4686 | 0.0911 | 2 | 9 | 25 | 10 | 1 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob041_traffic_light` | 50 | 0.4736 | 0.4259 | 5 | 46 | 36 | 14 | 4 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob045_alu` | 98 | 0.4170 | 0.2569 | 2 | 98 | 83 | 15 | 2 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob049_signal_generator` | 48 | 0.2598 | 0.0191 | 36 | 46 | 15 | 33 | 10 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 72 | 0.0120 | 0.0000 | 35 | 35 | 13 | 59 | 8 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 92 | 0.4654 | 0.3984 | 40 | 92 | 12 | 80 | 3 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 104 | 0.2636 | 0.0000 | 7 | 0 | 9 | 95 | 2 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 82 | 0.3297 | 0.0000 | 20 | 78 | 9 | 73 | 2 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 17 | -0.1071 | 0.0000 | 8 | 0 | 17 | 0 | 8 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 65 | 0.1459 | 0.0017 | 11 | 22 | 41 | 24 | 8 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob004_adder_8bit` | 75 | 0.3815 | 0.1510 | 23 | 55 | 37 | 38 | 1 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob015_multi_pipe_8bit` | 56 | 0.2232 | 0.0000 | 16 | 0 | 51 | 5 | 15 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob024_fsm` | 28 | 0.6835 | 0.3406 | 2 | 19 | 17 | 11 | 2 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob037_parallel2serial` | 28 | 0.0917 | 0.0001 | 3 | 1 | 15 | 13 | 3 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob041_traffic_light` | 50 | 0.3993 | 0.2659 | 6 | 34 | 39 | 11 | 4 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob045_alu` | 51 | 0.4194 | 0.2640 | 4 | 51 | 47 | 4 | 3 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob049_signal_generator` | 68 | 0.2862 | 0.0217 | 61 | 61 | 10 | 58 | 8 | area/power/eff_clk_period |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 66 | 0.0120 | 0.0000 | 39 | 39 | 5 | 61 | 1 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 52 | 0.4654 | 0.3984 | 23 | 50 | 15 | 37 | 4 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 99 | 0.3310 | 0.0000 | 1 | 1 | 11 | 88 | 1 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 68 | 0.3297 | 0.0000 | 32 | 62 | 13 | 55 | 6 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 14 | -0.1103 | 0.0000 | 4 | 0 | 12 | 2 | 4 | area/power/eff_clk_period |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 41 | 0.1670 | 0.0022 | 7 | 12 | 23 | 18 | 2 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob004_adder_8bit` | 61 | 0.3815 | 0.1510 | 14 | 43 | 33 | 28 | 1 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob015_multi_pipe_8bit` | 45 | 0.0528 | 0.0000 | 16 | 0 | 44 | 1 | 16 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob024_fsm` | 26 | 0.6835 | 0.3406 | 2 | 13 | 14 | 12 | 2 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob037_parallel2serial` | 49 | 0.0633 | 0.0002 | 24 | 5 | 21 | 28 | 6 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob041_traffic_light` | 40 | 0.4209 | 0.3135 | 3 | 30 | 39 | 1 | 3 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob045_alu` | 47 | 0.4052 | 0.2220 | 1 | 47 | 42 | 5 | 1 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob049_signal_generator` | 67 | 0.2565 | 0.0164 | 52 | 62 | 20 | 47 | 16 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 39 | 0.0120 | 0.0000 | 18 | 18 | 5 | 34 | 3 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 50 | 0.4654 | 0.3984 | 16 | 50 | 15 | 35 | 3 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 86 | 0.3310 | 0.0000 | 5 | 5 | 11 | 75 | 2 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 51 | 0.3297 | 0.0000 | 30 | 41 | 12 | 39 | 3 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 21 | -0.1259 | 0.0000 | 4 | 0 | 18 | 3 | 3 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 18 | 0.1025 | 0.0003 | 4 | 3 | 16 | 2 | 4 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `RTLLM/Prob004_adder_8bit` | 65 | 0.3815 | 0.1510 | 14 | 37 | 37 | 28 | 1 | area/power |
| `sr_random_relu_pca_qd` | `RTLLM/Prob015_multi_pipe_8bit` | 36 | 0.0611 | 0.0000 | 12 | 1 | 33 | 3 | 12 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `RTLLM/Prob024_fsm` | 36 | 0.6835 | 0.3406 | 4 | 21 | 23 | 13 | 3 | area/power |
| `sr_random_relu_pca_qd` | `RTLLM/Prob037_parallel2serial` | 26 | 0.1100 | 0.0002 | 2 | 1 | 18 | 8 | 2 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `RTLLM/Prob041_traffic_light` | 45 | 0.4077 | 0.3496 | 5 | 41 | 37 | 8 | 4 | area/power |
| `sr_random_relu_pca_qd` | `RTLLM/Prob045_alu` | 53 | 0.4217 | 0.2708 | 2 | 53 | 52 | 1 | 2 | area/power |
| `sr_random_relu_pca_qd` | `RTLLM/Prob049_signal_generator` | 55 | 0.2598 | 0.0196 | 37 | 38 | 23 | 32 | 13 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 75 | 0.0120 | 0.0000 | 40 | 41 | 7 | 68 | 3 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 41 | 0.4654 | 0.3984 | 13 | 40 | 11 | 30 | 2 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 75 | 0.3977 | 0.1986 | 9 | 9 | 10 | 65 | 2 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 81 | 0.3297 | 0.0000 | 10 | 76 | 12 | 69 | 3 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 10 | -0.1171 | 0.0000 | 5 | 0 | 8 | 2 | 3 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 40 | 0.1356 | 0.0009 | 12 | 10 | 28 | 12 | 7 | area/power/eff_clk_period |

## Artifact Roots

- `classic_revolution`: `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/standard_results`
- `landing_smooth_qd_manual_bd`: `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/standard_results`
- `random_descriptor_qd`: `exp/auto_bd_research/main_screening_screening_seed3/random_descriptor_qd/seed_1002/standard_results`
- `synthesis_trajectory_nod`: `exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1002/standard_results`
- `sr_random_relu_pca_qd`: `exp/auto_bd_research/main_screening_screening_seed3/sr_random_relu_pca_qd/seed_1002/standard_results`
