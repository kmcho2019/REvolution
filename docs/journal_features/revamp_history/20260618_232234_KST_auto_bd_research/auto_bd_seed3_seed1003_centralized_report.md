# Auto-BD Centralized Report

Phase: `main_screening`

Seed: `1003`

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

## Leaderboard

| Method | Valid PPA | Mean Fitness | Fitness W/T/L | Mean HV | HV W/T/L | Unique Netlists | Dup Netlists | Unique Motifs | PPA-Front Netlists | Audit Cells | Audit QD | Runtime s | LLM Calls |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 730 | 0.2826 | 0/13/0 | 0.1166 | 0/13/0 | 301 | 429 | 220 | 52 | 36 | 8.1817 | 22108.9745 | 3120 |
| `landing_smooth_qd_manual_bd` | 799 | 0.2934 | 2/10/1 | 0.1244 | 4/8/1 | 320 | 479 | 226 | 59 | 40 | 8.4343 | 20690.8142 | 3120 |
| `random_descriptor_qd` | 635 | 0.2772 | 2/10/1 | 0.1202 | 3/8/2 | 315 | 320 | 213 | 66 | 37 | 7.6486 | 23597.8466 | 3120 |
| `synthesis_trajectory_nod` | 644 | 0.2857 | 1/10/2 | 0.1164 | 3/7/3 | 282 | 362 | 207 | 64 | 41 | 9.5132 | 23383.4313 | 3120 |

## QD Archive Metrics

Coverage and entropy are reported in the fixed common-audit space so methods with different internal BDs remain comparable.

| Method | Archive | Internal Cells | Internal QD | Internal Entropy | Audit Cells | Audit Coverage | Audit QD | Audit Entropy | Audit Entropy Norm |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `none` | - | - | - | 36 | 0.0108 | 8.1817 | 4.4473 | 0.3801 |
| `landing_smooth_qd_manual_bd` | `grid_quantile` | 65 | 14.9228 | 6.3449 | 40 | 0.0120 | 8.4343 | 4.4786 | 0.3828 |
| `random_descriptor_qd` | `grid_quantile` | 206 | 42.5121 | 7.2577 | 37 | 0.0111 | 7.6486 | 4.3645 | 0.3730 |
| `synthesis_trajectory_nod` | `grid_quantile` | 124 | 16.2522 | 6.4233 | 41 | 0.0123 | 9.5132 | 4.5676 | 0.3904 |

## Descriptor/PPA Correlations

The JSON report includes Pearson correlations between descriptor axes and PPA/fitness metrics for internal and common-audit descriptor spaces.

## Representative Elite Examples

This compact table shows each method's best-fitness representative elite. The JSON report also includes per-problem best-fitness elite rows with RTL, netlist, and log paths.

| Method | Problem | Gen | Op | Fitness | Area | Power | Timing | Archive Cell | Audit Cell | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob024_fsm` | 2 | `M-R` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `-` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample16_M-R/code.sv` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample16_M-R/code.syn.v` |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob024_fsm` | 5 | `C-F` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `0,0,0` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen5/Prob024_fsm_sample4_C-F/code.sv` | `.../RTLLM/Prob024_fsm/Gen5/Prob024_fsm_sample4_C-F/code.syn.v` |
| `random_descriptor_qd` | `RTLLM/Prob024_fsm` | 2 | `M-E` | 0.6835 | 24.0000 | 0.0020 | 0.1400 | `warmup:8` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample10_M-E/code.sv` | `.../RTLLM/Prob024_fsm/Gen2/Prob024_fsm_sample10_M-E/code.syn.v` |
| `synthesis_trajectory_nod` | `RTLLM/Prob024_fsm` | 4 | `M-E` | 0.5845 | 30.0000 | 0.0027 | 0.2000 | `warmup:8` | `audit_motif4:1,0,0,2` | `.../RTLLM/Prob024_fsm/Gen4/Prob024_fsm_sample5_M-E/code.sv` | `.../RTLLM/Prob024_fsm/Gen4/Prob024_fsm_sample5_M-E/code.syn.v` |

## Robustness Funnel

| Method | Total | Syntax | Functionality | Synthesis | OpenROAD | Valid PPA |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 1560 | 1456 (93.3%) | 730 (46.8%) | 730 (46.8%) | 730 (46.8%) | 730 (46.8%) |
| `landing_smooth_qd_manual_bd` | 1560 | 1462 (93.7%) | 799 (51.2%) | 799 (51.2%) | 799 (51.2%) | 799 (51.2%) |
| `random_descriptor_qd` | 1560 | 1351 (86.6%) | 635 (40.7%) | 635 (40.7%) | 635 (40.7%) | 635 (40.7%) |
| `synthesis_trajectory_nod` | 1560 | 1350 (86.5%) | 644 (41.3%) | 644 (41.3%) | 644 (41.3%) | 644 (41.3%) |

## Failure Breakdown

| Method | Failure Reason | Count |
| --- | --- | --- |
| `classic_revolution` | `failed_functionality` | 697 |
| `classic_revolution` | `failed_syntax` | 103 |
| `classic_revolution` | `failed_synthesis_functionality` | 29 |
| `classic_revolution` | `failed_format` | 1 |
| `landing_smooth_qd_manual_bd` | `failed_functionality` | 630 |
| `landing_smooth_qd_manual_bd` | `failed_syntax` | 95 |
| `landing_smooth_qd_manual_bd` | `failed_synthesis_functionality` | 32 |
| `landing_smooth_qd_manual_bd` | `failed_format` | 3 |
| `landing_smooth_qd_manual_bd` | `failed_synthesis` | 1 |
| `random_descriptor_qd` | `failed_functionality` | 704 |
| `random_descriptor_qd` | `failed_syntax` | 110 |
| `random_descriptor_qd` | `failed_diff` | 94 |
| `random_descriptor_qd` | `failed_synthesis_functionality` | 12 |
| `random_descriptor_qd` | `failed_format` | 5 |
| `synthesis_trajectory_nod` | `failed_functionality` | 682 |
| `synthesis_trajectory_nod` | `failed_diff` | 126 |
| `synthesis_trajectory_nod` | `failed_syntax` | 82 |
| `synthesis_trajectory_nod` | `failed_synthesis_functionality` | 19 |
| `synthesis_trajectory_nod` | `failed_synthesis` | 5 |
| `synthesis_trajectory_nod` | `failed_format` | 2 |

## Anytime Summary

| Method | Final Gen | Final Covered | Final Fitness | Final HV | Fitness AUC | HV AUC |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 5 | 13 | 0.2826 | 0.1166 | 0.2592 | 0.1033 |
| `landing_smooth_qd_manual_bd` | 5 | 13 | 0.2934 | 0.1244 | 0.2620 | 0.1002 |
| `random_descriptor_qd` | 5 | 13 | 0.2772 | 0.1202 | 0.2670 | 0.0990 |
| `synthesis_trajectory_nod` | 5 | 13 | 0.2857 | 0.1164 | 0.2539 | 0.0951 |

The JSON report includes per-generation anytime rows for each method.

## Figures

- `anytime_mean_best_fitness`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1003/anytime_mean_best_fitness.png`
- `anytime_mean_hypervolume`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1003/anytime_mean_hypervolume.png`
- `descriptor_common_audit_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1003/descriptor_common_audit_ppa_correlation.png`
- `descriptor_internal_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1003/descriptor_internal_ppa_correlation.png`
- `manual_bd_ppa_correlation`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1003/manual_bd_ppa_correlation.png`
- `qd_common_audit_cells_heatmap`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1003/qd_common_audit_cells_heatmap.png`
- `qd_common_audit_coverage`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1003/qd_common_audit_coverage.png`
- `qd_common_audit_entropy`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed3_seed1003/qd_common_audit_entropy.png`

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
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob015_multi_pipe_8bit` | -0.1633 | L | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob037_parallel2serial` | 0.2403 | W | 0.0793 | W |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob041_traffic_light` | 0.0137 | T | 0.0164 | W |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob045_alu` | 0.0021 | T | 0.0063 | W |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob049_signal_generator` | -0.0004 | T | -0.0038 | L |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 0.0005 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | -0.0012 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 0.0487 | W | 0.0027 | W |
| `random_descriptor_qd` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `RTLLM/Prob015_multi_pipe_8bit` | 0.0169 | T | 0.0000 | T |
| `random_descriptor_qd` | `RTLLM/Prob024_fsm` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `RTLLM/Prob037_parallel2serial` | -0.2195 | L | -0.0119 | L |
| `random_descriptor_qd` | `RTLLM/Prob041_traffic_light` | 0.0471 | W | 0.0752 | W |
| `random_descriptor_qd` | `RTLLM/Prob045_alu` | -0.0058 | T | -0.0174 | L |
| `random_descriptor_qd` | `RTLLM/Prob049_signal_generator` | -0.0004 | T | 0.0002 | W |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 0.0674 | W | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0203 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 0.0028 | T | 0.0001 | W |
| `synthesis_trajectory_nod` | `RTLLM/Prob004_adder_8bit` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob015_multi_pipe_8bit` | -0.1940 | L | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob024_fsm` | -0.0990 | L | -0.1236 | L |
| `synthesis_trajectory_nod` | `RTLLM/Prob037_parallel2serial` | 0.2916 | W | 0.1208 | W |
| `synthesis_trajectory_nod` | `RTLLM/Prob041_traffic_light` | 0.0137 | T | -0.0120 | L |
| `synthesis_trajectory_nod` | `RTLLM/Prob045_alu` | 0.0045 | T | 0.0130 | W |
| `synthesis_trajectory_nod` | `RTLLM/Prob049_signal_generator` | -0.0004 | T | -0.0015 | L |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 0.0005 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 0.0176 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 0.0047 | T | 0.0003 | W |

## Per-Problem PPA And Diversity

| Method | Problem | Valid PPA | Best Fitness | HV | Pareto Points | Ref-Beating | Unique Netlists | Dup Netlists | PPA-Front Netlists | Objectives |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob004_adder_8bit` | 82 | 0.3815 | 0.1510 | 16 | 42 | 27 | 55 | 3 | area/power |
| `classic_revolution` | `RTLLM/Prob015_multi_pipe_8bit` | 34 | 0.2243 | 0.0000 | 12 | 0 | 32 | 2 | 12 | area/power/eff_clk_period |
| `classic_revolution` | `RTLLM/Prob024_fsm` | 35 | 0.6835 | 0.3406 | 4 | 25 | 20 | 15 | 3 | area/power |
| `classic_revolution` | `RTLLM/Prob037_parallel2serial` | 32 | 0.2283 | 0.0119 | 1 | 9 | 25 | 7 | 1 | area/power/eff_clk_period |
| `classic_revolution` | `RTLLM/Prob041_traffic_light` | 56 | 0.4266 | 0.3507 | 4 | 49 | 47 | 9 | 3 | area/power |
| `classic_revolution` | `RTLLM/Prob045_alu` | 81 | 0.4119 | 0.2421 | 4 | 81 | 69 | 12 | 4 | area/power |
| `classic_revolution` | `RTLLM/Prob049_signal_generator` | 54 | 0.2603 | 0.0208 | 9 | 50 | 12 | 42 | 4 | area/power/eff_clk_period |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 77 | 0.0120 | 0.0000 | 17 | 17 | 13 | 64 | 6 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 86 | 0.4654 | 0.3984 | 16 | 86 | 16 | 70 | 4 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 97 | 0.2636 | 0.0000 | 28 | 0 | 6 | 91 | 3 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 62 | 0.3297 | 0.0000 | 34 | 59 | 10 | 52 | 4 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 13 | -0.1438 | 0.0000 | 1 | 0 | 13 | 0 | 1 | area/power/eff_clk_period |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 21 | 0.1309 | 0.0007 | 6 | 2 | 11 | 10 | 4 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob004_adder_8bit` | 82 | 0.3815 | 0.1510 | 16 | 50 | 28 | 54 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob015_multi_pipe_8bit` | 31 | 0.0611 | 0.0000 | 14 | 0 | 30 | 1 | 13 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob024_fsm` | 29 | 0.6835 | 0.3406 | 1 | 21 | 20 | 9 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob037_parallel2serial` | 36 | 0.4686 | 0.0911 | 2 | 5 | 23 | 13 | 1 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob041_traffic_light` | 77 | 0.4403 | 0.3671 | 20 | 75 | 37 | 40 | 3 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob045_alu` | 85 | 0.4140 | 0.2483 | 4 | 85 | 76 | 9 | 3 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob049_signal_generator` | 67 | 0.2598 | 0.0170 | 53 | 53 | 19 | 48 | 13 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 48 | 0.0120 | 0.0000 | 16 | 16 | 10 | 38 | 4 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 98 | 0.4654 | 0.3984 | 58 | 98 | 19 | 79 | 4 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 106 | 0.2641 | 0.0000 | 2 | 0 | 8 | 98 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 66 | 0.3297 | 0.0000 | 27 | 64 | 11 | 55 | 5 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 7 | -0.1450 | 0.0000 | 4 | 0 | 7 | 0 | 4 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 67 | 0.1796 | 0.0034 | 18 | 44 | 32 | 35 | 6 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob004_adder_8bit` | 73 | 0.3815 | 0.1510 | 16 | 59 | 36 | 37 | 1 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob015_multi_pipe_8bit` | 74 | 0.2412 | 0.0000 | 17 | 0 | 67 | 7 | 13 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob024_fsm` | 25 | 0.6835 | 0.3406 | 1 | 14 | 19 | 6 | 1 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob037_parallel2serial` | 27 | 0.0089 | 0.0000 | 23 | 0 | 17 | 10 | 13 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob041_traffic_light` | 42 | 0.4736 | 0.4259 | 9 | 35 | 32 | 10 | 4 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob045_alu` | 55 | 0.4061 | 0.2247 | 3 | 55 | 49 | 6 | 2 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob049_signal_generator` | 53 | 0.2598 | 0.0209 | 45 | 45 | 19 | 34 | 13 | area/power/eff_clk_period |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 62 | 0.0120 | 0.0000 | 29 | 29 | 7 | 55 | 4 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 49 | 0.4654 | 0.3984 | 1 | 49 | 14 | 35 | 1 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 84 | 0.3310 | 0.0000 | 1 | 1 | 10 | 74 | 1 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 43 | 0.3297 | 0.0000 | 27 | 40 | 13 | 30 | 5 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 8 | -0.1235 | 0.0000 | 1 | 0 | 6 | 2 | 1 | area/power/eff_clk_period |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 40 | 0.1337 | 0.0008 | 14 | 7 | 26 | 14 | 7 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob004_adder_8bit` | 77 | 0.3815 | 0.1510 | 24 | 60 | 29 | 48 | 1 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob015_multi_pipe_8bit` | 42 | 0.0303 | 0.0000 | 21 | 0 | 41 | 1 | 20 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob024_fsm` | 16 | 0.5845 | 0.2170 | 3 | 7 | 13 | 3 | 3 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob037_parallel2serial` | 31 | 0.5200 | 0.1327 | 5 | 8 | 24 | 7 | 2 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob041_traffic_light` | 41 | 0.4403 | 0.3387 | 6 | 32 | 37 | 4 | 5 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob045_alu` | 52 | 0.4164 | 0.2550 | 1 | 52 | 49 | 3 | 1 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob049_signal_generator` | 61 | 0.2598 | 0.0193 | 53 | 58 | 19 | 42 | 14 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob098_circuit7` | 70 | 0.0120 | 0.0000 | 25 | 25 | 4 | 66 | 1 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | 79 | 0.4654 | 0.3984 | 27 | 79 | 12 | 67 | 2 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | 84 | 0.2641 | 0.0000 | 17 | 0 | 8 | 76 | 1 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot` | 52 | 0.3297 | 0.0000 | 30 | 42 | 13 | 39 | 3 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | 12 | -0.1262 | 0.0000 | 3 | 0 | 11 | 1 | 3 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob153_gshare` | 27 | 0.1356 | 0.0010 | 10 | 13 | 22 | 5 | 8 | area/power/eff_clk_period |

## Artifact Roots

- `classic_revolution`: `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/standard_results`
- `landing_smooth_qd_manual_bd`: `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1003/standard_results`
- `random_descriptor_qd`: `exp/auto_bd_research/main_screening_screening_seed3/random_descriptor_qd/seed_1003/standard_results`
- `synthesis_trajectory_nod`: `exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1003/standard_results`
