# Auto-BD Centralized Report

Phase: `main_screening`

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
| `classic_revolution` | PASS | 13 | 13 | - |
| `landing_smooth_qd_manual_bd` | PASS | 13 | 13 | - |
| `random_descriptor_qd` | PASS | 13 | 13 | - |
| `synthesis_trajectory_nod` | PASS | 13 | 13 | - |
| `sr_random_relu_pca_qd` | PASS | 13 | 13 | - |

## Leaderboard

| Method | Valid PPA | Mean Fitness | Fitness W/T/L | Mean HV | HV W/T/L | PPA Grid Cells | PPA Grid Cov | Unique Netlists | Dup Netlists | Unique Motifs | PPA-Front Netlists | Audit Cells | Audit QD | Runtime s | LLM Calls |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 740 | 0.2787 | 0/13/0 | 0.1292 | 0/13/0 | 28 | 0.0986 | 341 | 399 | 248 | 57 | 41 | 8.5526 | 22786.3297 | 3120 |
| `landing_smooth_qd_manual_bd` | 785 | 0.2698 | 1/11/1 | 0.1313 | 2/7/4 | 31 | 0.1094 | 357 | 428 | 275 | 62 | 38 | 7.3203 | 22684.2360 | 3120 |
| `random_descriptor_qd` | 614 | 0.2690 | 2/8/3 | 0.1148 | 2/6/5 | 33 | 0.1118 | 269 | 345 | 182 | 48 | 39 | 7.6217 | 23801.8546 | 3120 |
| `synthesis_trajectory_nod` | 652 | 0.3039 | 2/11/0 | 0.1360 | 4/7/2 | 32 | 0.1106 | 280 | 372 | 200 | 48 | 39 | 8.6540 | 24112.2206 | 3120 |
| `sr_random_relu_pca_qd` | 616 | 0.2641 | 2/9/2 | 0.1160 | 2/7/4 | 29 | 0.1034 | 291 | 325 | 212 | 55 | 39 | 8.4443 | 23646.5607 | 3120 |

## QD Archive Metrics

Coverage and entropy are reported in the fixed common-audit space so methods with different internal BDs remain comparable.

| Method | Archive | Internal Cells | Internal QD | Internal Entropy | Audit Cells | Audit Coverage | Audit QD | Audit Entropy | Audit Entropy Norm |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `none` | - | - | - | 41 | 0.0123 | 8.5526 | 4.5048 | 0.3850 |
| `landing_smooth_qd_manual_bd` | `grid_quantile` | 77 | 10.8154 | 6.4044 | 38 | 0.0114 | 7.3203 | 4.4604 | 0.3812 |
| `random_descriptor_qd` | `grid_quantile` | 170 | 29.3093 | 6.9011 | 39 | 0.0117 | 7.6217 | 4.3433 | 0.3712 |
| `synthesis_trajectory_nod` | `grid_quantile` | 117 | 17.3897 | 6.1181 | 39 | 0.0117 | 8.6540 | 4.4327 | 0.3789 |
| `sr_random_relu_pca_qd` | `grid_quantile` | 105 | 16.6042 | 6.3414 | 39 | 0.0117 | 8.4443 | 4.4265 | 0.3783 |

## Descriptor/PPA Correlations

The JSON report includes Pearson correlations between descriptor axes and PPA/fitness metrics for internal and common-audit descriptor spaces.

## Representative Elite Examples

This compact table shows each method's best-fitness representative elite. The JSON report also includes per-problem best-fitness elite rows with RTL, netlist, and log paths.

| Method | Problem | Gen | Op | Fitness | Area | Power | Timing | Archive Cell | Audit Cell | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob024_fsm` | 3 | `M-R` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `-` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen3/Prob024_fsm_sample1_M-R/code.sv` | `.../RTLLM/Prob024_fsm/Gen3/Prob024_fsm_sample1_M-R/code.syn.v` |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob024_fsm` | 4 | `C-F` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `0,0,0` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen4/Prob024_fsm_sample11_C-F/code.sv` | `.../RTLLM/Prob024_fsm/Gen4/Prob024_fsm_sample11_C-F/code.syn.v` |
| `random_descriptor_qd` | `RTLLM/Prob024_fsm` | 5 | `C-D` | 0.6661 | 26.0000 | 0.0021 | 0.1400 | `0,0,3` | `audit_motif4:2,0,0,2` | `.../RTLLM/Prob024_fsm/Gen5/Prob024_fsm_sample15_C-D/code.sv` | `.../RTLLM/Prob024_fsm/Gen5/Prob024_fsm_sample15_C-D/code.syn.v` |
| `synthesis_trajectory_nod` | `RTLLM/Prob024_fsm` | 3 | `M-F` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `0,0,1,0,0` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen3/Prob024_fsm_sample10_M-F/code.sv` | `.../RTLLM/Prob024_fsm/Gen3/Prob024_fsm_sample10_M-F/code.syn.v` |
| `sr_random_relu_pca_qd` | `RTLLM/Prob024_fsm` | 5 | `M-E` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `0,2,0` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen5/Prob024_fsm_sample11_M-E/code.sv` | `.../RTLLM/Prob024_fsm/Gen5/Prob024_fsm_sample11_M-E/code.syn.v` |

## Robustness Funnel

| Method | Total | Syntax | Functionality | Synthesis | OpenROAD | Valid PPA |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 1560 | 1468 (94.1%) | 740 (47.4%) | 740 (47.4%) | 740 (47.4%) | 740 (47.4%) |
| `landing_smooth_qd_manual_bd` | 1560 | 1466 (94.0%) | 785 (50.3%) | 785 (50.3%) | 785 (50.3%) | 785 (50.3%) |
| `random_descriptor_qd` | 1560 | 1387 (88.9%) | 614 (39.4%) | 614 (39.4%) | 614 (39.4%) | 614 (39.4%) |
| `synthesis_trajectory_nod` | 1560 | 1349 (86.5%) | 652 (41.8%) | 652 (41.8%) | 652 (41.8%) | 652 (41.8%) |
| `sr_random_relu_pca_qd` | 1560 | 1383 (88.7%) | 616 (39.5%) | 616 (39.5%) | 616 (39.5%) | 616 (39.5%) |

## Failure Breakdown

| Method | Failure Reason | Count |
| --- | --- | --- |
| `classic_revolution` | `failed_functionality` | 713 |
| `classic_revolution` | `failed_syntax` | 91 |
| `classic_revolution` | `failed_synthesis_functionality` | 12 |
| `classic_revolution` | `failed_synthesis` | 3 |
| `classic_revolution` | `failed_format` | 1 |
| `landing_smooth_qd_manual_bd` | `failed_functionality` | 662 |
| `landing_smooth_qd_manual_bd` | `failed_syntax` | 94 |
| `landing_smooth_qd_manual_bd` | `failed_synthesis_functionality` | 17 |
| `landing_smooth_qd_manual_bd` | `failed_synthesis` | 2 |
| `random_descriptor_qd` | `failed_functionality` | 755 |
| `random_descriptor_qd` | `failed_diff` | 97 |
| `random_descriptor_qd` | `failed_syntax` | 73 |
| `random_descriptor_qd` | `failed_synthesis_functionality` | 18 |
| `random_descriptor_qd` | `failed_format` | 3 |
| `synthesis_trajectory_nod` | `failed_functionality` | 671 |
| `synthesis_trajectory_nod` | `failed_diff` | 107 |
| `synthesis_trajectory_nod` | `failed_syntax` | 102 |
| `synthesis_trajectory_nod` | `failed_synthesis_functionality` | 25 |
| `synthesis_trajectory_nod` | `failed_format` | 2 |
| `synthesis_trajectory_nod` | `failed_synthesis` | 1 |
| `sr_random_relu_pca_qd` | `failed_functionality` | 730 |
| `sr_random_relu_pca_qd` | `failed_syntax` | 105 |
| `sr_random_relu_pca_qd` | `failed_diff` | 67 |
| `sr_random_relu_pca_qd` | `failed_synthesis_functionality` | 34 |
| `sr_random_relu_pca_qd` | `failed_format` | 5 |
| `sr_random_relu_pca_qd` | `failed_synthesis` | 3 |

## Anytime Summary

| Method | Final Gen | Final Covered | Final Fitness | Final HV | Fitness AUC | HV AUC |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 5 | 13 | 0.2787 | 0.1292 | 0.2426 | 0.1080 |
| `landing_smooth_qd_manual_bd` | 5 | 13 | 0.2698 | 0.1313 | 0.2485 | 0.1093 |
| `random_descriptor_qd` | 5 | 13 | 0.2690 | 0.1148 | 0.2511 | 0.0984 |
| `synthesis_trajectory_nod` | 5 | 13 | 0.3039 | 0.1360 | 0.2727 | 0.1068 |
| `sr_random_relu_pca_qd` | 5 | 13 | 0.2641 | 0.1160 | 0.2328 | 0.0939 |

The JSON report includes per-generation anytime rows for each method.

## Figures

- `anytime_mean_best_fitness`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1001/anytime_mean_best_fitness.png`
- `anytime_mean_hypervolume`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1001/anytime_mean_hypervolume.png`
- `descriptor_common_audit_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1001/descriptor_common_audit_ppa_correlation.png`
- `descriptor_internal_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1001/descriptor_internal_ppa_correlation.png`
- `manual_bd_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1001/manual_bd_ppa_correlation.png`
- `ppa_grid_coverage`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1001/ppa_grid_coverage.png`
- `qd_common_audit_cells_heatmap`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1001/qd_common_audit_cells_heatmap.png`
- `qd_common_audit_coverage`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1001/qd_common_audit_coverage.png`
- `qd_common_audit_entropy`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1001/qd_common_audit_entropy.png`

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
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob015_multi_pipe_8bit` | -0.0071 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob037_parallel2serial` | -0.1651 | L | -0.0117 | L |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob041_traffic_light` | -0.0018 | T | 0.0408 | W |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob045_alu` | -0.0003 | T | -0.0008 | L |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob049_signal_generator` | -0.0040 | T | -0.0009 | L |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 0.0000 | T | 0.0000 | W |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0679 | W | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | -0.0047 | T | -0.0003 | L |
| `random_descriptor_qd` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `RTLLM/Prob015_multi_pipe_8bit` | 0.1562 | W | 0.0000 | T |
| `random_descriptor_qd` | `RTLLM/Prob024_fsm` | -0.0174 | T | -0.0347 | L |
| `random_descriptor_qd` | `RTLLM/Prob037_parallel2serial` | -0.1438 | L | -0.0115 | L |
| `random_descriptor_qd` | `RTLLM/Prob041_traffic_light` | 0.0137 | T | 0.0529 | W |
| `random_descriptor_qd` | `RTLLM/Prob045_alu` | -0.0019 | T | -0.0058 | L |
| `random_descriptor_qd` | `RTLLM/Prob049_signal_generator` | 0.0410 | W | 0.0113 | W |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | -0.1336 | L | -0.1986 | L |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | -0.0342 | L | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | -0.0060 | T | -0.0007 | L |
| `synthesis_trajectory_nod` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob015_multi_pipe_8bit` | 0.0172 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob037_parallel2serial` | 0.2403 | W | 0.0793 | W |
| `synthesis_trajectory_nod` | `RTLLM/Prob041_traffic_light` | 0.0086 | T | 0.0033 | W |
| `synthesis_trajectory_nod` | `RTLLM/Prob045_alu` | 0.0027 | T | 0.0077 | W |
| `synthesis_trajectory_nod` | `RTLLM/Prob049_signal_generator` | -0.0035 | T | -0.0012 | L |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 0.0000 | T | 0.0000 | W |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0679 | W | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | -0.0047 | T | -0.0007 | L |
| `sr_random_relu_pca_qd` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `RTLLM/Prob015_multi_pipe_8bit` | 0.0334 | W | 0.0000 | T |
| `sr_random_relu_pca_qd` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `RTLLM/Prob037_parallel2serial` | -0.1651 | L | -0.0117 | L |
| `sr_random_relu_pca_qd` | `RTLLM/Prob041_traffic_light` | 0.0223 | T | 0.0436 | W |
| `sr_random_relu_pca_qd` | `RTLLM/Prob045_alu` | -0.0008 | T | -0.0022 | L |
| `sr_random_relu_pca_qd` | `RTLLM/Prob049_signal_generator` | -0.0040 | T | -0.0046 | L |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | -0.1336 | L | -0.1986 | L |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0419 | W | 0.0000 | T |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 0.0165 | T | 0.0010 | W |

## Per-Problem PPA And Diversity

| Method | Problem | Valid PPA | Best Fitness | HV | PPA Grid Cells | PPA Grid Cov | Pareto Points | Ref-Beating | Unique Netlists | Dup Netlists | PPA-Front Netlists | Objectives |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob004_adder_8bit` | 81 | 0.3815 | 0.1510 | 1 | 0.0625 | 10 | 32 | 27 | 54 | 1 | area/power |
| `classic_revolution` | `RTLLM/Prob015_multi_pipe_8bit` | 42 | 0.0681 | 0.0000 | 3 | 0.0469 | 16 | 0 | 42 | 0 | 16 | area/power/eff_clk_period |
| `classic_revolution` | `RTLLM/Prob024_fsm` | 24 | 0.6835 | 0.3406 | 4 | 0.2500 | 1 | 15 | 18 | 6 | 1 | area/power |
| `classic_revolution` | `RTLLM/Prob037_parallel2serial` | 21 | 0.2283 | 0.0119 | 1 | 0.0156 | 2 | 5 | 17 | 4 | 2 | area/power/eff_clk_period |
| `classic_revolution` | `RTLLM/Prob041_traffic_light` | 59 | 0.4285 | 0.3175 | 7 | 0.4375 | 10 | 55 | 51 | 8 | 6 | area/power |
| `classic_revolution` | `RTLLM/Prob045_alu` | 78 | 0.4113 | 0.2403 | 1 | 0.0625 | 2 | 78 | 71 | 7 | 2 | area/power |
| `classic_revolution` | `RTLLM/Prob049_signal_generator` | 50 | 0.2638 | 0.0192 | 3 | 0.0469 | 4 | 41 | 14 | 36 | 2 | area/power/eff_clk_period |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 74 | 0.0120 | 0.0000 | 1 | 0.0625 | 23 | 23 | 12 | 62 | 6 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 82 | 0.4654 | 0.3984 | 2 | 0.1250 | 53 | 82 | 16 | 66 | 4 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 93 | 0.3977 | 0.1986 | 1 | 0.0625 | 16 | 16 | 12 | 81 | 2 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 54 | 0.3297 | 0.0000 | 1 | 0.0625 | 34 | 54 | 8 | 46 | 3 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 22 | -0.2101 | 0.0000 | 1 | 0.0156 | 6 | 0 | 20 | 2 | 6 | area/power/eff_clk_period |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 60 | 0.1631 | 0.0024 | 2 | 0.0312 | 7 | 33 | 33 | 27 | 6 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob004_adder_8bit` | 76 | 0.3815 | 0.1510 | 1 | 0.0625 | 24 | 42 | 25 | 51 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob015_multi_pipe_8bit` | 31 | 0.0611 | 0.0000 | 3 | 0.0469 | 14 | 0 | 31 | 0 | 14 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob024_fsm` | 30 | 0.6835 | 0.3406 | 5 | 0.3125 | 1 | 25 | 20 | 10 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob037_parallel2serial` | 28 | 0.0633 | 0.0002 | 1 | 0.0156 | 5 | 4 | 17 | 11 | 4 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob041_traffic_light` | 61 | 0.4268 | 0.3583 | 8 | 0.5000 | 6 | 55 | 43 | 18 | 4 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob045_alu` | 102 | 0.4110 | 0.2395 | 1 | 0.0625 | 5 | 102 | 92 | 10 | 3 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob049_signal_generator` | 48 | 0.2598 | 0.0183 | 3 | 0.0469 | 43 | 46 | 12 | 36 | 9 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 53 | 0.0120 | 0.0000 | 1 | 0.0625 | 15 | 15 | 7 | 46 | 3 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 77 | 0.4654 | 0.3984 | 2 | 0.1250 | 44 | 77 | 12 | 65 | 4 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 110 | 0.3977 | 0.1986 | 1 | 0.0625 | 3 | 24 | 13 | 97 | 2 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 60 | 0.3297 | 0.0000 | 1 | 0.0625 | 35 | 57 | 7 | 53 | 3 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 22 | -0.1422 | 0.0000 | 2 | 0.0312 | 5 | 0 | 22 | 0 | 5 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 87 | 0.1584 | 0.0021 | 2 | 0.0312 | 13 | 18 | 56 | 31 | 9 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob004_adder_8bit` | 71 | 0.3815 | 0.1510 | 1 | 0.0625 | 14 | 49 | 31 | 40 | 2 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob015_multi_pipe_8bit` | 50 | 0.2243 | 0.0000 | 4 | 0.0625 | 17 | 0 | 48 | 2 | 16 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob024_fsm` | 23 | 0.6661 | 0.3059 | 5 | 0.3125 | 1 | 18 | 14 | 9 | 1 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob037_parallel2serial` | 52 | 0.0846 | 0.0003 | 1 | 0.0156 | 9 | 10 | 24 | 28 | 4 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob041_traffic_light` | 48 | 0.4423 | 0.3704 | 8 | 0.5000 | 14 | 45 | 31 | 17 | 3 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob045_alu` | 52 | 0.4094 | 0.2345 | 1 | 0.0625 | 2 | 52 | 47 | 5 | 2 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob049_signal_generator` | 55 | 0.3048 | 0.0305 | 5 | 0.0781 | 7 | 39 | 20 | 35 | 5 | area/power/eff_clk_period |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 40 | 0.0120 | 0.0000 | 1 | 0.0625 | 17 | 17 | 5 | 35 | 3 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 27 | 0.4654 | 0.3984 | 2 | 0.1250 | 4 | 27 | 10 | 17 | 2 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 87 | 0.2641 | 0.0000 | 1 | 0.0625 | 1 | 0 | 9 | 78 | 1 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 86 | 0.3297 | 0.0000 | 1 | 0.0625 | 12 | 85 | 11 | 75 | 3 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 8 | -0.2444 | 0.0000 | 1 | 0.0156 | 4 | 0 | 7 | 1 | 4 | area/power/eff_clk_period |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 15 | 0.1571 | 0.0017 | 2 | 0.0312 | 2 | 5 | 12 | 3 | 2 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob004_adder_8bit` | 75 | 0.3815 | 0.1510 | 1 | 0.0625 | 14 | 60 | 37 | 38 | 3 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob015_multi_pipe_8bit` | 46 | 0.0853 | 0.0000 | 3 | 0.0469 | 20 | 0 | 42 | 4 | 17 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob024_fsm` | 23 | 0.6835 | 0.3406 | 5 | 0.3125 | 2 | 12 | 17 | 6 | 1 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob037_parallel2serial` | 30 | 0.4686 | 0.0911 | 2 | 0.0312 | 1 | 5 | 23 | 7 | 1 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob041_traffic_light` | 43 | 0.4371 | 0.3208 | 8 | 0.5000 | 5 | 37 | 35 | 8 | 2 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob045_alu` | 41 | 0.4141 | 0.2480 | 1 | 0.0625 | 1 | 41 | 37 | 4 | 1 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob049_signal_generator` | 77 | 0.2603 | 0.0180 | 4 | 0.0625 | 19 | 63 | 20 | 57 | 6 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 90 | 0.0120 | 0.0000 | 1 | 0.0625 | 35 | 35 | 4 | 86 | 3 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 55 | 0.4654 | 0.3984 | 2 | 0.1250 | 18 | 55 | 15 | 40 | 3 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 94 | 0.3977 | 0.1986 | 1 | 0.0625 | 2 | 2 | 9 | 85 | 1 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 38 | 0.3297 | 0.0000 | 1 | 0.0625 | 21 | 31 | 12 | 26 | 6 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 11 | -0.1422 | 0.0000 | 1 | 0.0156 | 2 | 0 | 11 | 0 | 2 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 29 | 0.1584 | 0.0018 | 2 | 0.0312 | 2 | 3 | 18 | 11 | 2 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `RTLLM/Prob004_adder_8bit` | 72 | 0.3815 | 0.1510 | 1 | 0.0625 | 20 | 58 | 32 | 40 | 2 | area/power |
| `sr_random_relu_pca_qd` | `RTLLM/Prob015_multi_pipe_8bit` | 44 | 0.1015 | 0.0000 | 3 | 0.0469 | 17 | 0 | 41 | 3 | 14 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `RTLLM/Prob024_fsm` | 18 | 0.6835 | 0.3406 | 5 | 0.3125 | 1 | 6 | 11 | 7 | 1 | area/power |
| `sr_random_relu_pca_qd` | `RTLLM/Prob037_parallel2serial` | 33 | 0.0633 | 0.0002 | 1 | 0.0156 | 5 | 4 | 19 | 14 | 3 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `RTLLM/Prob041_traffic_light` | 41 | 0.4508 | 0.3611 | 7 | 0.4375 | 5 | 38 | 37 | 4 | 4 | area/power |
| `sr_random_relu_pca_qd` | `RTLLM/Prob045_alu` | 68 | 0.4106 | 0.2381 | 1 | 0.0625 | 4 | 68 | 64 | 4 | 4 | area/power |
| `sr_random_relu_pca_qd` | `RTLLM/Prob049_signal_generator` | 53 | 0.2598 | 0.0146 | 3 | 0.0469 | 45 | 45 | 13 | 40 | 11 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 39 | 0.0120 | 0.0000 | 1 | 0.0625 | 13 | 13 | 5 | 34 | 2 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 43 | 0.4654 | 0.3984 | 2 | 0.1250 | 20 | 43 | 14 | 29 | 4 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 99 | 0.2641 | 0.0000 | 1 | 0.0625 | 1 | 0 | 8 | 91 | 1 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 57 | 0.3297 | 0.0000 | 1 | 0.0625 | 2 | 48 | 14 | 43 | 1 | area/power |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 17 | -0.1682 | 0.0000 | 1 | 0.0156 | 4 | 0 | 11 | 6 | 3 | area/power/eff_clk_period |
| `sr_random_relu_pca_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 32 | 0.1796 | 0.0034 | 2 | 0.0312 | 6 | 9 | 22 | 10 | 5 | area/power/eff_clk_period |

## Artifact Roots

- `classic_revolution`: `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/standard_results`
- `landing_smooth_qd_manual_bd`: `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/standard_results`
- `random_descriptor_qd`: `exp/auto_bd_research/main_screening_screening_seed3/random_descriptor_qd/seed_1001/standard_results`
- `synthesis_trajectory_nod`: `exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1001/standard_results`
- `sr_random_relu_pca_qd`: `exp/auto_bd_research/main_screening_screening_seed3/sr_random_relu_pca_qd/seed_1001/standard_results`
