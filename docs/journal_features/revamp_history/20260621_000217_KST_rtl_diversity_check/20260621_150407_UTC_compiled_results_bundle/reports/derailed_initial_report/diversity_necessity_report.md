# Diversity Necessity Report

Final verdict: **C reconstructive**.

This report is generated from post-hoc local artifacts only. No live evolutionary run was launched.

## Corpus Coverage

| root | corpus | stratum | method_count | seed_count | problem_count | candidate_count | code_artifacts | netlist_artifacts | ppa_artifacts | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM | rtllm_gen20 | partially_paired | 1 | 1 | 50 | 10413 | 10413 | 2600 | 2335 | broad historical RTLLM 20-generation REvolution corpus |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 740 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 735 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 730 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 785 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 807 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1003/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 799 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/random_descriptor_qd/seed_1001/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 614 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/random_descriptor_qd/seed_1002/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 696 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/random_descriptor_qd/seed_1003/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 635 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/sr_random_relu_pca_qd/seed_1001/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 616 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/sr_random_relu_pca_qd/seed_1002/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 638 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/sr_random_relu_pca_qd/seed_1003/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 652 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1001/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 652 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1002/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 600 | 20260618 Auto-BD negative/control evidence |
| /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1003/standard_results | auto_bd_standard_results | fully_paired_within_seed | 1 | 1 | 13 | 1560 | indexed in standard results | indexed in standard results | 644 | 20260618 Auto-BD negative/control evidence |

## Candidate Audit

- Candidate audit CSV: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/candidate_audit.csv`
- Candidate audit Parquet: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/candidate_audit.parquet`
- Legacy broad RTLLM candidates: 10413
- ASP-DAC release candidates: 0
- Evolution-analysis candidates: 10413
- Auto-BD control candidates: 23400

## 20260618 Auto-BD Negative Controls

Yosys-stat, motif histogram, ST-NOD, projected synthesis-response, VQ/codebook, and random descriptor arms are treated as prior negative/control evidence. The final 20260618 decision rejected promotion because descriptor/archive organization did not preserve robust valid-PPA uplift.

| report | method | valid_ppa_candidate_count | mean_hypervolume | mean_best_fitness | common_audit_qd_score |
| --- | --- | --- | --- | --- | --- |
| auto_bd_seed1_centralized_report.json | classic_revolution | 209 | 0.1245 | 0.2671 | 2.316 |
| auto_bd_seed1_centralized_report.json | landing_smooth_qd_manual_bd | 219 | 0.1059 | 0.2271 | 1.853 |
| auto_bd_seed1_centralized_report.json | random_descriptor_qd | 213 | 0.1175 | 0.2645 | 1.701 |
| auto_bd_seed1_centralized_report.json | simple_yosys_stat_bd | 201 | 0.1242 | 0.2512 | 2.078 |
| auto_bd_seed1_centralized_report.json | netlist_motif_occupancy | 192 | 0.06056 | 0.235 | -3.027 |
| auto_bd_seed1_centralized_report.json | synthesis_trajectory_nod | 205 | 0.1208 | 0.2511 | -2.064 |
| auto_bd_seed1_centralized_report.json | synthesis_trajectory_motif_nod | 198 | 0.1204 | 0.238 | 1.714 |
| auto_bd_seed1_centralized_report.json | sr_raw_pca_qd | 209 | 0.1208 | 0.2404 | 1.966 |
| auto_bd_seed1_centralized_report.json | sr_random_relu_pca_qd | 197 | 0.1454 | 0.2536 | 2.377 |
| auto_bd_seed1_centralized_report.json | sr_rff_pca_qd | 197 | 0.1229 | 0.263 | 2.811 |
| auto_bd_seed1_centralized_report.json | sr_vq_codebook_qd | 174 | 0.111 | 0.2105 | 0.8485 |
| auto_bd_seed3_seed1001_centralized_report.json | classic_revolution | 740 | 0.1292 | 0.2787 | 8.553 |

## Encoder Leaderboard

| family | stability | non_collapse | predictive_signal | pareto_cluster_signal | replay_signal | cost | verdict |
| --- | --- | --- | --- | --- | --- | --- | --- |
| lexical_structural_baseline | measured | measured by style/motif cluster counts | not supported | descriptive | PASS | local text/netlist parsing | diagnostic only |
| qwen3_embedding_0p6b | median comment distance=0.018; median identifier distance=0.018 | 64 RTL candidates inspected; 0 truncated at 4000 chars | not tested without real embeddings | not promoted | not promoted | blocked_missing_dependency | diagnostic only; real embeddings unavailable |
| deepgate3_aig | deferred; must record whether sequential cells are kept, cone-split, or dropped before any DeepGate3 comparison | 0 embeddings extracted | not tested | not tested | not tested | blocked_missing_deepgate3 | deferred with setup evidence |

## D1-D6 Gate Matrix

| gate | status | evidence | claim_level | problem_count |
| --- | --- | --- | --- | --- |
| D1 early_predictive | FAIL | rho early lexical distance vs final HV=0.441; single historical run per problem lacks seed/model/budget controls | inconclusive | 50 |
| D2 multi_cluster_front | FAIL | 13.8% of analyzable valid-PPA problems have >=2 style clusters on the Pareto front; shuffled-label rate=20.8% | L0 descriptive | 29 |
| D3 replay_retention | PASS | best diversity oracle HV gain over best-fitness retention=14.7%; 10% threshold required | L1 reconstructive | 29 |
| D4 prospective_moderate_diversity | NOT_RUN | no live diversity intervention was launched in this post-hoc goal | not applicable | 0 |
| D5 real_beats_random | FAIL | 20260618 Auto-BD controls did not show robust PPA uplift over classic/manual baselines; no new in-loop descriptor is promoted | negative/control | 50 |
| D6 interpretable_regions | PASS | style clusters: arithmetic_additive, arithmetic_multiply, control_case, control_if, mux_ternary, other_structural, register_sequential, wire_assign | L0 descriptive | 29 |

## Claim Levels

| level | status | evidence |
| --- | --- | --- |
| L0 descriptive | SUPPORTED | style clusters: arithmetic_additive, arithmetic_multiply, control_case, control_if, mux_ternary, other_structural, register_sequential, wire_assign; D2 status=FAIL |
| L1 reconstructive | SUPPORTED | best diversity oracle HV gain over best-fitness retention=14.7%; 10% threshold required; oracle/post-hoc evidence only |
| L2 predictive | NOT_SUPPORTED | single-run problem-level correlations lack required controls |
| L3 mechanistic | NOT_SUPPORTED | parent-child lineage was not recoverable in the selected corpus |
| L4 active | NOT_RUN | no prospective intervention was run |
| L5 method | NOT_SUPPORTED | Auto-BD candidate requires utility and meaning gates |

## Diversity vs PPA Regressions

| early_style_vs_hv | early_distance_vs_hv | early_valid_vs_hv |
| --- | --- | --- |
| 0.4534 | 0.4415 | 0.3897 |

## Cluster Summary

| problem_id | cluster | candidate_count | valid_ppa_count | pareto_count | cluster_hypervolume | front_hypervolume | total_problem_hypervolume | front_hv_share | best_fitness | best_area | best_power | best_eff_clk_period | representative_rtl_path | representative_netlist_path | shuffled_multi_cluster_front_rate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| RTLLM/Prob030_right_shifter | register_sequential | 133 | 133 | 128 | 0 | 0 | 0 | 0 | -0 | 36 | 0.00369 | 0.12 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob030_right_shifter/Gen0/Prob030_right_shifter_sample10_initial/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob030_right_shifter/Gen0/Prob030_right_shifter_sample10_initial/code.syn.v | 0 |
| RTLLM/Prob023_up_down_counter | register_sequential | 123 | 123 | 123 | 0 | 0 | 0 | 0 | 0.03117 | 216 | 0.0258 | 0.73 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob023_up_down_counter/Gen9/Prob023_up_down_counter_sample8_M-E/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob023_up_down_counter/Gen9/Prob023_up_down_counter_sample8_M-E/code.syn.v | 0 |
| RTLLM/Prob020_JC_counter | register_sequential | 147 | 147 | 122 | 0 | 0 | 0 | 0 | -0 | 340 | 0.0351 | 0.13 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob020_JC_counter/Gen0/Prob020_JC_counter_sample10_initial/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob020_JC_counter/Gen0/Prob020_JC_counter_sample10_initial/code.syn.v | 0 |
| RTLLM/Prob004_adder_8bit | wire_assign | 93 | 93 | 50 | 0.04095 | 0.04095 | 0.04095 | 1 | 0.3299 | 46 | 3.1e-05 | 0 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob004_adder_8bit/Gen10/Prob004_adder_8bit_sample8_M-R/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob004_adder_8bit/Gen10/Prob004_adder_8bit_sample8_M-R/code.syn.v | 1 |
| RTLLM/Prob001_accu | register_sequential | 62 | 62 | 40 | 0 | 0 | 0 | 0 | 0.07583 | 251 | 0.0271 | 0.51 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob001_accu/Gen10/Prob001_accu_sample4_M-S/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob001_accu/Gen10/Prob001_accu_sample4_M-S/code.syn.v | 0 |
| RTLLM/Prob043_RAM | register_sequential | 70 | 70 | 38 | 0.09969 | 0.09969 | 0.09969 | 1 | 0.4445 | 481 | 0.0399 | 0.2 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob043_RAM/Gen17/Prob043_RAM_sample5_M-R/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob043_RAM/Gen17/Prob043_RAM_sample5_M-R/code.syn.v | 0 |
| RTLLM/Prob044_ROM | arithmetic_multiply | 36 | 36 | 34 | 0 | 0 | 0 | 0 | -0 | 14 | 0.000205 | 0 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob044_ROM/Gen0/Prob044_ROM_sample10_initial/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob044_ROM/Gen0/Prob044_ROM_sample10_initial/code.syn.v | 1 |
| RTLLM/Prob035_calendar | register_sequential | 40 | 40 | 33 | 0 | 0 | 0 | 0 | 0.02338 | 183 | 0.0117 | 0.4 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob035_calendar/Gen20/Prob035_calendar_sample6_M-R/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob035_calendar/Gen20/Prob035_calendar_sample6_M-R/code.syn.v | 0 |
| RTLLM/Prob003_adder_32bit | wire_assign | 45 | 45 | 28 | 0.6745 | 0.6745 | 0.6745 | 1 | 0.5579 | 137 | 7.97e-05 | 0 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob003_adder_32bit/Gen0/Prob003_adder_32bit_sample1_initial/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob003_adder_32bit/Gen0/Prob003_adder_32bit_sample1_initial/code.syn.v | 0 |
| RTLLM/Prob012_multi_8bit | arithmetic_multiply | 132 | 132 | 25 | 0.2197 | 0.2197 | 0.2197 | 1 | 0.3179 | 364 | 0.0386 | 0 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob012_multi_8bit/Gen10/Prob012_multi_8bit_sample6_M-S/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob012_multi_8bit/Gen10/Prob012_multi_8bit_sample6_M-S/code.syn.v | 0.97 |
| RTLLM/Prob049_signal_generator | register_sequential | 63 | 63 | 23 | 0.02015 | 0.02015 | 0.02015 | 1 | 0.2603 | 77 | 0.00252 | 0.37 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob049_signal_generator/Gen17/Prob049_signal_generator_sample10_M-S/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob049_signal_generator/Gen17/Prob049_signal_generator_sample10_M-S/code.syn.v | 0.98 |
| RTLLM/Prob040_synchronizer | register_sequential | 23 | 23 | 23 | 0.02778 | 0.02778 | 0.02778 | 1 | 0 | 68 | 0.00178 | 0 | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob040_synchronizer/Gen0/Prob040_synchronizer_sample10_initial/code.sv | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob040_synchronizer/Gen0/Prob040_synchronizer_sample10_initial/code.syn.v | 0 |

## Counterfactual Replay

| policy | mean_hypervolume | mean_best_fitness | mean_style_clusters | rows |
| --- | --- | --- | --- | --- |
| oracle_motif_diversity | 0.1072 | 0.212 | 1.517 | 29 |
| random_seed_19 | 0.09836 | 0.1686 | 1.345 | 29 |
| random_seed_10 | 0.09742 | 0.1792 | 1.414 | 29 |
| random_seed_05 | 0.09727 | 0.1797 | 1.31 | 29 |
| oracle_style_diversity | 0.09494 | 0.212 | 1.828 | 29 |
| online_style_diversity | 0.09494 | 0.212 | 1.828 | 29 |
| oracle_lexical_diversity | 0.09443 | 0.212 | 1.828 | 29 |
| online_best_fitness | 0.0935 | 0.212 | 1.276 | 29 |
| oracle_best_fitness | 0.0935 | 0.212 | 1.276 | 29 |
| random_seed_14 | 0.09116 | 0.1648 | 1.31 | 29 |
| random_seed_16 | 0.09063 | 0.1662 | 1.379 | 29 |
| random_seed_18 | 0.09007 | 0.1778 | 1.379 | 29 |
| random_seed_02 | 0.08922 | 0.1695 | 1.379 | 29 |
| random_seed_07 | 0.089 | 0.1737 | 1.379 | 29 |
| random_seed_13 | 0.08866 | 0.1768 | 1.379 | 29 |
| random_seed_01 | 0.08816 | 0.1633 | 1.448 | 29 |
| random_seed_04 | 0.08806 | 0.1647 | 1.448 | 29 |
| random_seed_06 | 0.0878 | 0.1745 | 1.379 | 29 |
| random_seed_12 | 0.08484 | 0.1602 | 1.31 | 29 |
| random_seed_08 | 0.07878 | 0.1716 | 1.414 | 29 |
| random_seed_09 | 0.07728 | 0.1612 | 1.345 | 29 |
| random_seed_11 | 0.077 | 0.1667 | 1.345 | 29 |
| random_seed_15 | 0.0766 | 0.1702 | 1.414 | 29 |
| random_seed_00 | 0.07632 | 0.1684 | 1.379 | 29 |
| random_seed_03 | 0.07562 | 0.1613 | 1.345 | 29 |
| random_seed_17 | 0.07387 | 0.1633 | 1.31 | 29 |

## Validity-Normalized Common Audit Metrics

| problem_id | all_generated | syntax_valid | functionally_valid | synthesis_valid | valid_ppa | pareto_front | valid_ppa_per_occupied_style_cluster | hv_per_valid_ppa_candidate | front_members_per_valid_ppa_candidate | unique_motif_signatures_per_valid_ppa_candidate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| RTLLM/Prob001_accu | 210 | 67 | 62 | 62 | 62 | 40 | 62 | 0 | 0.6452 | 0.129 |
| RTLLM/Prob002_adder_16bit | 209 | 87 | 84 | 84 | 84 | 1 | 28 | 0.002442 | 0.0119 | 0.04762 |
| RTLLM/Prob003_adder_32bit | 208 | 46 | 45 | 45 | 45 | 28 | 45 | 0.01499 | 0.6222 | 0.02222 |
| RTLLM/Prob004_adder_8bit | 210 | 117 | 104 | 104 | 104 | 61 | 26 | 0.0003938 | 0.5865 | 0.02885 |
| RTLLM/Prob005_adder_bcd | 209 | 91 | 90 | 90 | 90 | 9 | 45 | 0.0002453 | 0.1 | 0.1111 |
| RTLLM/Prob006_adder_pipe_64bit | 203 | 14 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| RTLLM/Prob007_comparator_3bit | 210 | 156 | 154 | 154 | 154 | 4 | 51.33 | 6.697e-05 | 0.02597 | 0.1623 |
| RTLLM/Prob008_comparator_4bit | 210 | 109 | 101 | 101 | 101 | 2 | 33.67 | 0.001692 | 0.0198 | 0.1881 |
| RTLLM/Prob009_div_16bit | 209 | 70 | 68 | 68 | 68 | 6 | 22.67 | 0.008669 | 0.08824 | 0.3824 |
| RTLLM/Prob010_radix2_div | 201 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| RTLLM/Prob011_multi_16bit | 206 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| RTLLM/Prob012_multi_8bit | 210 | 153 | 152 | 152 | 152 | 25 | 50.67 | 0.001445 | 0.1645 | 0.03947 |
| RTLLM/Prob013_multi_booth_8bit | 208 | 21 | 21 | 18 | 18 | 17 | 18 | 0.001543 | 0.9444 | 0.1111 |
| RTLLM/Prob014_multi_pipe_4bit | 209 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| RTLLM/Prob015_multi_pipe_8bit | 206 | 15 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| RTLLM/Prob016_fixed_point_adder | 207 | 77 | 64 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

## Visualizations

- embedding_scatter: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/embedding_scatter.png`
- ppa_front_by_cluster: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/ppa_front_by_cluster.png`
- diversity_efficiency_frontier: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/diversity_efficiency_frontier.png`
- diversity_over_time: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/diversity_over_time_vs_quality.png`
- early_diversity_final_hv: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/early_diversity_vs_final_hv.png`
- replay_bars: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/counterfactual_replay_bars.png`
- stability_boxplots: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/descriptor_stability_boxplots.png`
- correlation_heatmap: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/correlation_heatmap.png`
- common_audit_heatmap: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/common_audit_heatmap.png`
- validity_funnel: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/figures/validity_funnel.png`

## Representative Implementation Gallery

Case-study slots were selected before narrative interpretation: largest style-diversity HV, median Pareto cluster count, lowest valid-PPA rate, and the 20260618 Auto-BD negative-control case.

Gallery artifact: `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/implementation_gallery.md`

| case_type | problem_id | selection_rule | representative_path | cluster |
| --- | --- | --- | --- | --- |
| best_supported | RTLLM/Prob003_adder_32bit | largest style-diversity HV | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob003_adder_32bit/Gen0/Prob003_adder_32bit_sample1_initial/code.sv | wire_assign |
| null_or_median | RTLLM/Prob048_pe | median Pareto cluster count | /aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM/Prob048_pe/Gen20/Prob048_pe_sample5_M-R/code.sv | register_sequential |
| negative_funnel | RTLLM/Prob006_adder_pipe_64bit | lowest valid-PPA rate |  |  |
| auto_bd_control | 20260618 ST-NOD/VQ | predeclared negative-control evidence | /workspace/docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_final_negative_decision.md | negative_control |

## Limits

- Parent-child lineage was not recoverable from the selected broad RTLLM artifacts, so D3 descendants and L3 mechanistic claims are not supported.
- Qwen3 real embeddings were not extracted unless the optional smoke succeeds; dry-run coverage and lexical perturbation checks are diagnostic only.
- DeepGate3 is deferred because the package/checkpoint is absent; Yosys is available for future AIG/JSON export.
- D3 plus D6 justify reconstructive/offline diversity follow-up, not an in-loop Auto-BD default. D4 and D5 did not pass.
