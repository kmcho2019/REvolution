# Diversity Necessity Report

Final verdict: **B illumination_only**.

This report is generated from post-hoc local artifacts only. No live evolutionary run was launched.

## Preliminary Negative Result And Plan Pivot

- Restarted WP0-WP2 evidence still does not justify an active diversity method or Auto-BD promotion.
- The quality-gated novelty replay preserves best fitness and modestly increases unique structural coverage, but it remains replay-only diagnostic evidence.
- Qwen3 is no longer dependency-blocked and should be treated as a diagnostic-only encoder after the larger common-audit replay, while the bounded DeepGate3 tokenizer probe is no-proceed in its current collapsed form.
- Recommendation: keep the current claim at diagnostic-only / no-proceed for method promotion; escalate to a Qwen projection-head diagnostic, stronger graph encoders, or bounded live sampling only if the next pass targets a concrete D1/D3/D4/D5 utility gate.
- A bounded AURORA-style learned-encoder replay was attempted after WP0-WP2, but it did not improve meaningfully over the common-audit control and remains no-proceed for method promotion.

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
| exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/deepseek_clean_results | aspdac2026_release | partially_paired | 1 | 1 | 206 | 43260 | 43281 | 26250 | 24664 | ASP-DAC 2026 release source archive; RTLLM, VerilogEval-Spec-to-RTL |
| exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/gpt-4.1-mini_clean_results | aspdac2026_release | partially_paired | 1 | 1 | 206 | 43160 | 43191 | 29806 | 28328 | ASP-DAC 2026 release source archive; RTLLM, VerilogEval-Spec-to-RTL |
| exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results | aspdac2026_release | partially_paired | 1 | 1 | 206 | 40379 | 40380 | 16077 | 15154 | ASP-DAC 2026 release source archive; RTLLM, VerilogEval-Spec-to-RTL |
| exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_clean_results | aspdac2026_release | partially_paired | 1 | 1 | 206 | 43258 | 43279 | 23194 | 21912 | ASP-DAC 2026 release source archive; RTLLM, VerilogEval-Spec-to-RTL |

## Candidate Audit

- Candidate audit CSV: `exp/diversity_check/restarted_report_20260621_075346_UTC/candidate_audit.csv`
- Candidate audit Parquet: `exp/diversity_check/restarted_report_20260621_075346_UTC/candidate_audit.parquet`
- Legacy broad RTLLM candidates: 10413
- ASP-DAC release candidates: 170131
- Evolution-analysis candidates: 180544
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

## Restart WP0/WP2 Replay Evidence

- Status: `loaded`
- Source artifact directory: `exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC`
- Summary CSV: `exp/diversity_check/restarted_report_20260621_075346_UTC/wp0_replay_summary.csv`
- Quality gate: valid-PPA candidates at or above the prefix median valid fitness.
- Novelty metric: nearest-selected Euclidean distance over the artifact's existing four-axis `common_audit_descriptor_vector`; the replay does not fit a new scaler or use PPA-derived normalization.

| evidence | method_name | variant | valid_ppa_count | selected_count | unique_canonical_netlists | unique_motif_signatures | occupied_common_audit_cells | pareto_size | baseline_pareto_size | best_fitness | note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| duplicate_suppression_full_budget | sr_random_relu_pca_qd | canonical_netlist | 1906 | 900 |  |  |  | 174 | 496 |  | suppressed 1006 duplicate hits |
| duplicate_suppression_full_budget | sr_random_relu_pca_qd | exact_motif_signature | 1906 | 653 |  |  |  | 116 | 496 |  | suppressed 1253 duplicate hits |
| duplicate_suppression_full_budget | synthesis_trajectory_nod | canonical_netlist | 1896 | 852 |  |  |  | 176 | 558 |  | suppressed 1044 duplicate hits |
| duplicate_suppression_full_budget | synthesis_trajectory_nod | exact_motif_signature | 1896 | 604 |  |  |  | 112 | 558 |  | suppressed 1292 duplicate hits |
| quality_gated_novelty_full_budget | sr_random_relu_pca_qd | 0 | 1906 | 492 | 228 | 172 | 70 | 304 | 496 | 0.6835 | prefix median valid-fitness quality floor |
| quality_gated_novelty_full_budget | sr_random_relu_pca_qd | 0.1 | 1906 | 492 | 233 | 176 | 74 | 300 | 496 | 0.6835 | prefix median valid-fitness quality floor |
| quality_gated_novelty_full_budget | sr_random_relu_pca_qd | 0.25 | 1906 | 492 | 241 | 188 | 80 | 299 | 496 | 0.6835 | prefix median valid-fitness quality floor |
| quality_gated_novelty_full_budget | sr_random_relu_pca_qd | 0.5 | 1906 | 492 | 248 | 201 | 82 | 294 | 496 | 0.6835 | prefix median valid-fitness quality floor |
| quality_gated_novelty_full_budget | synthesis_trajectory_nod | 0 | 1896 | 490 | 211 | 157 | 71 | 336 | 558 | 0.6835 | prefix median valid-fitness quality floor |
| quality_gated_novelty_full_budget | synthesis_trajectory_nod | 0.1 | 1896 | 490 | 216 | 163 | 77 | 328 | 558 | 0.6835 | prefix median valid-fitness quality floor |
| quality_gated_novelty_full_budget | synthesis_trajectory_nod | 0.25 | 1896 | 490 | 217 | 169 | 81 | 327 | 558 | 0.6835 | prefix median valid-fitness quality floor |
| quality_gated_novelty_full_budget | synthesis_trajectory_nod | 0.5 | 1896 | 490 | 224 | 183 | 83 | 327 | 558 | 0.6835 | prefix median valid-fitness quality floor |

## WP1 Qwen Common-Audit Diagnostic

- Status: `diagnostic_only_no_proceed`
- Evidence: 768 candidates, 127 problems, raw Qwen HV delta vs lexical -0.0125, identifier-normalized Qwen HV delta vs lexical 0.0335
- Policy: frozen Qwen embeddings; PPA fields are used only after selection for replay evaluation.

| baseline_best_fitness | baseline_hypervolume | baseline_pareto_size | problem_group_count | representation | selected_best_fitness | selected_count | selected_hypervolume | selected_pareto_size | unique_canonical_netlists | unique_motif_signatures | valid_ppa_count | vs_lexical_hv_gain_fraction | vs_lexical_pareto_gain_fraction |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0.7498 | 3.864 | 553 | 114 | fitness_top | 0.7498 | 341 | 3.823 | 300 | 52 | 44 | 682 | 0.0328 | 0.06007 |
| 0.7498 | 3.864 | 553 | 114 | generation_prefix | 0.6951 | 341 | 3.155 | 303 | 50 | 45 | 682 | -0.1477 | 0.07067 |
| 0.7498 | 3.864 | 553 | 114 | lexical_farthest | 0.6881 | 341 | 3.702 | 283 | 60 | 54 | 682 | 0 | 0 |
| 0.7498 | 3.864 | 553 | 114 | qwen_identifier_farthest | 0.7498 | 341 | 3.826 | 289 | 59 | 51 | 682 | 0.0335 | 0.0212 |
| 0.7498 | 3.864 | 553 | 114 | qwen_raw_farthest | 0.6951 | 341 | 3.656 | 294 | 57 | 50 | 682 | -0.0125 | 0.03887 |
| 0.7498 | 3.864 | 553 | 114 | random | 0.6951 | 341 | 3.074 | 303 | 59 | 50 | 682 | -0.1696 | 0.07067 |

## WP3 Learned Encoder Diagnostics

- Status: `loaded`
- Policy: frozen problem-split linear bottlenecks over non-PPA common-audit implementation vectors.

| family | stability | non_collapse | replay_signal | cost | verdict | artifact |
| --- | --- | --- | --- | --- | --- | --- |
| aurora_linear_ae2 | problem split; train=2120, holdout=1682 | latent std=[1.19, 0.873]; holdout MSE=0.01827 | holdout d_canon=0, d_pareto=1, gain=0.0036 | NumPy SVD over common-audit vectors | diagnostic_only_no_proceed | exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim2_fixed |
| aurora_linear_ae3 | problem split; train=2120, holdout=1682 | latent std=[1.19, 0.873, 1.59]; holdout MSE=0.009623 | holdout d_canon=0, d_pareto=0, gain=0.0000 | NumPy SVD over common-audit vectors | diagnostic_only_no_proceed | exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim3_fixed |
| rich_ae8 | problem split; train=134643, holdout=69301, input_dim=37 | latent std=[2.58, 2.04, 1.64, 1.63, 1.41, 1.36, 1.25, 1.21]; pairwise cosine mean=0.4589; holdout MSE=2.371 | holdout d_hv=0, d_pareto=-0.001087, d_best=0 | NumPy SVD over implementation-only audit features | diagnostic_only_no_proceed | exp/diversity_check/wp3_rich_encoder_20260621_070533_UTC |
| rich_ae16 | problem split; train=134643, holdout=69301, input_dim=37 | latent std=[2.58, 2.04, 1.64, 1.63, 1.41, 1.36, 1.25, 1.21, 1.17, 1.14, 1.05, 1, 0.962, 0.942, 0.877, 0.868]; pairwise cosine mean=0.3879; holdout MSE=1.184 | holdout d_hv=-7.1e-05, d_pareto=-0.0003623, d_best=0 | NumPy SVD over implementation-only audit features | diagnostic_only_no_proceed | exp/diversity_check/wp3_rich_encoder_20260621_070533_UTC |

## WP0 Lineage Diagnostics

- Status: `loaded`
- Evidence: lineage audit found 271 files with 3358 parent/lineage edges; descendant-yield analysis recovered 3358 edges and 779 positive child-quality deltas, but 0/8 method/table groups have positive mean quality delta

| best_quality_delta | edge_count | mean_quality_delta | method_name | new_cell_edges | parent_found_edges | parent_found_rate | positive_quality_delta_edges | source_table | unique_parent_count |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1.223 | 672 | -0.0365 | landing_smooth_qd_manual_bd | 391 | 499 | 0.7426 | 157 | archive_cells.csv | 362 |
| 0.8472 | 950 | -0.03151 | random_descriptor_qd | 718 | 754 | 0.7937 | 248 | archive_cells.csv | 502 |
| 0.5759 | 636 | -0.05823 | sr_random_relu_pca_qd | 408 | 469 | 0.7374 | 176 | archive_cells.csv | 379 |
| 0.4567 | 597 | -0.03567 | synthesis_trajectory_nod | 312 | 373 | 0.6248 | 147 | archive_cells.csv | 407 |
| 0.1898 | 120 | -0.04769 | landing_smooth_qd_manual_bd | 0 | 28 | 0.2333 | 9 | global_pareto_archive.csv | 100 |
| 0.5226 | 131 | -0.06027 | random_descriptor_qd | 0 | 43 | 0.3282 | 12 | global_pareto_archive.csv | 102 |
| 0.2855 | 128 | -0.03012 | sr_random_relu_pca_qd | 0 | 35 | 0.2734 | 15 | global_pareto_archive.csv | 105 |
| 0.26 | 124 | -0.01302 | synthesis_trajectory_nod | 0 | 32 | 0.2581 | 15 | global_pareto_archive.csv | 106 |

## WP0 Budget/Funnel Curves

- Status: `loaded`
- Evidence: budget curves cover 203944 candidates, 1069 problem groups, 21380 curve rows, and funnels generated, functional, synthesis_valid, valid_ppa, pareto_front

| budget_fraction | corpus | descriptor_family | funnel | mean_best_fitness | mean_candidate_count | mean_canonical_netlists | mean_motif_signatures | mean_pareto_members | mean_style_clusters | method | problem_group_count | total_candidate_count |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aspdac2026_release | lexical_structural_posthoc | valid_ppa | 0.2069 | 109.3 | 0 | 0 | 50.5 | 2.2 | classic_revolution | 824 | 90058 |
| 1 | auto_bd_standard_results | classic_revolution | valid_ppa | 0.2776 | 56.54 | 24.9 | 18.41 | 56.54 | 1 | classic_revolution | 39 | 2205 |
| 1 | auto_bd_standard_results | landing_smooth_qd_manual_bd | valid_ppa | 0.2887 | 61.31 | 26.13 | 19.33 | 61.31 | 1 | landing_smooth_qd_manual_bd | 39 | 2391 |
| 1 | auto_bd_standard_results | random_descriptor_qd | valid_ppa | 0.2764 | 49.87 | 22.54 | 15.15 | 49.87 | 1 | random_descriptor_qd | 39 | 1945 |
| 1 | auto_bd_standard_results | sr_random_relu_pca_qd | valid_ppa | 0.2691 | 48.87 | 23.08 | 16.74 | 48.87 | 1 | sr_random_relu_pca_qd | 39 | 1906 |
| 1 | auto_bd_standard_results | synthesis_trajectory_nod | valid_ppa | 0.2832 | 48.62 | 21.85 | 15.49 | 48.62 | 1 | synthesis_trajectory_nod | 39 | 1896 |
| 1 | rtllm_gen20 | lexical_structural_posthoc | valid_ppa | 0.212 | 46.7 | 8.1 | 5.02 | 15.86 | 1.06 | classic_revolution | 50 | 2335 |

## WP2 Near-Motif Suppression

- Status: `loaded`
- Evidence: near-motif suppression covers 2335 valid-PPA rows across 29 problem groups; distance-based near-motif suppression only covers rows with stored motif_vector JSON; ASP-DAC and Auto-BD imported rows lack distance-bearing motif vectors in this audit

| corpus | descriptor_family | method | motif_distance_threshold | problem_group_count | valid_ppa_count | retained_count | suppressed_near_motif_count | mean_retained_fraction | retained_pareto_size | baseline_pareto_size | retained_hypervolume | baseline_hypervolume | retained_best_fitness | baseline_best_fitness | hypervolume_gain_fraction | pareto_gain_fraction |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| rtllm_gen20 | lexical_structural_posthoc | classic_revolution | 0 | 29 | 2335 | 246 | 2089 | 0.1698 | 63 | 793 | 3.151 | 3.184 | 0.6835 | 0.6835 | -0.01034 | -0.9206 |
| rtllm_gen20 | lexical_structural_posthoc | classic_revolution | 0.01 | 29 | 2335 | 203 | 2132 | 0.1531 | 61 | 793 | 3.138 | 3.184 | 0.6835 | 0.6835 | -0.01419 | -0.9231 |
| rtllm_gen20 | lexical_structural_posthoc | classic_revolution | 0.025 | 29 | 2335 | 166 | 2169 | 0.1369 | 53 | 793 | 3.127 | 3.184 | 0.6835 | 0.6835 | -0.01791 | -0.9332 |
| rtllm_gen20 | lexical_structural_posthoc | classic_revolution | 0.05 | 29 | 2335 | 124 | 2211 | 0.1172 | 50 | 793 | 2.951 | 3.184 | 0.6835 | 0.6835 | -0.07308 | -0.9369 |

## Encoder Leaderboard

| family | stability | non_collapse | predictive_signal | pareto_cluster_signal | replay_signal | cost | verdict |
| --- | --- | --- | --- | --- | --- | --- | --- |
| lexical_structural_baseline | measured | measured by style/motif cluster counts | not supported | descriptive | FAIL | local text/netlist parsing | diagnostic only |
| qwen3_embedding_0p6b | variant stability mean=0.748, raw-to-Yosys mean=0.862; common raw/comment=0.949, raw/id=0.639 | 45 embedded texts, shape=[45, 1024]; Yosys conversions=15/15; common-audit candidates=768 | not tested without real embeddings | not promoted | qwen_raw d_hv_vs_lexical=-0.0125; qwen_id d_hv_vs_lexical=0.0335; diagnostic_only_no_proceed | artifact loaded; model load 24.673s, encode 0.816s; common-audit artifact loaded | diagnostic only; common-audit no-proceed |
| deepgate3_aig | combinational AIG-only; latch-bearing AIGER rejected; no cone splitting in this probe | 9 AIG exports, 6 latch-free parses, 3 embeddings; pairwise cosine mean=0.999971 | not tested | not tested | not tested | artifact loaded; graph export 0.612s, model load 0.248s, encode 0.381s | diagnostic-only no-proceed in current form; tokenizer embeddings collapsed and sequential policy remains limited |
| aurora_linear_ae2 | problem split; train=2120, holdout=1682 | latent std=[1.19, 0.873]; holdout MSE=0.01827 | not tested | not promoted | holdout d_canon=0, d_pareto=1, gain=0.0036 | NumPy SVD over common-audit vectors | diagnostic_only_no_proceed |
| aurora_linear_ae3 | problem split; train=2120, holdout=1682 | latent std=[1.19, 0.873, 1.59]; holdout MSE=0.009623 | not tested | not promoted | holdout d_canon=0, d_pareto=0, gain=0.0000 | NumPy SVD over common-audit vectors | diagnostic_only_no_proceed |
| rich_ae8 | problem split; train=134643, holdout=69301, input_dim=37 | latent std=[2.58, 2.04, 1.64, 1.63, 1.41, 1.36, 1.25, 1.21]; pairwise cosine mean=0.4589; holdout MSE=2.371 | not tested | not promoted | holdout d_hv=0, d_pareto=-0.001087, d_best=0 | NumPy SVD over implementation-only audit features | diagnostic_only_no_proceed |
| rich_ae16 | problem split; train=134643, holdout=69301, input_dim=37 | latent std=[2.58, 2.04, 1.64, 1.63, 1.41, 1.36, 1.25, 1.21, 1.17, 1.14, 1.05, 1, 0.962, 0.942, 0.877, 0.868]; pairwise cosine mean=0.3879; holdout MSE=1.184 | not tested | not promoted | holdout d_hv=-7.1e-05, d_pareto=-0.0003623, d_best=0 | NumPy SVD over implementation-only audit features | diagnostic_only_no_proceed |

## D1-D6 Gate Matrix

| gate | status | evidence | claim_level | problem_count |
| --- | --- | --- | --- | --- |
| D1 early_predictive | FAIL | rho early lexical distance vs final HV=0.300; single historical run per problem lacks seed/model/budget controls | inconclusive | 874 |
| D2 multi_cluster_front | FAIL | 48.8% of analyzable valid-PPA problems have >=2 style clusters on the Pareto front; shuffled-label rate=56.0% | L0 descriptive | 697 |
| D3 replay_retention | FAIL | best diversity oracle HV gain over best-fitness retention=1.4%; 10% threshold required | not supported | 697 |
| D4 prospective_moderate_diversity | NOT_RUN | no live diversity intervention was launched in this post-hoc goal | not applicable | 0 |
| D5 real_beats_random | FAIL | 20260618 Auto-BD controls did not show robust PPA uplift over classic/manual baselines; no new in-loop descriptor is promoted | negative/control | 874 |
| D6 interpretable_regions | PASS | style clusters: arithmetic_additive, arithmetic_multiply, control_case, control_if, mux_ternary, other_structural, register_sequential, wire_assign | L0 descriptive | 697 |

## Claim Levels

| level | status | evidence |
| --- | --- | --- |
| L0 descriptive | SUPPORTED | style clusters: arithmetic_additive, arithmetic_multiply, control_case, control_if, mux_ternary, other_structural, register_sequential, wire_assign; D2 status=FAIL |
| L1 reconstructive | NOT_SUPPORTED | requires diversity-aware retention to beat best-fitness controls |
| L2 predictive | NOT_SUPPORTED | single-run problem-level correlations lack required controls |
| L3 mechanistic | NOT_SUPPORTED | lineage audit found 271 files with 3358 parent/lineage edges; descendant-yield analysis recovered 3358 edges and 779 positive child-quality deltas, but 0/8 method/table groups have positive mean quality delta |
| L4 active | NOT_RUN | no prospective intervention was run |
| L5 method | NOT_SUPPORTED | Auto-BD candidate requires utility and meaning gates |

## Diversity vs PPA Regressions

| early_style_vs_hv | early_distance_vs_hv | early_valid_vs_hv |
| --- | --- | --- |
| 0.1843 | 0.2996 | 0.005038 |

## Cluster Summary

| problem_id | cluster | candidate_count | valid_ppa_count | pareto_count | cluster_hypervolume | front_hypervolume | total_problem_hypervolume | front_hv_share | best_fitness | best_area | best_power | best_eff_clk_period | representative_rtl_path | representative_netlist_path | shuffled_multi_cluster_front_rate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| aspdac2026/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob019_m2014_q4f | wire_assign | 199 | 199 | 199 | 0 | 0 | 0 | 0 | -0 | 2 | 5.64e-05 | 0 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob019_m2014_q4f/Gen0/Prob019_m2014_q4f_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob019_m2014_q4f/Gen0/Prob019_m2014_q4f_initial_sample1.syn.v | 0 |
| aspdac2026/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob002_m2014_q4i | wire_assign | 198 | 198 | 198 | 0 | 0 | 0 | 0 | -0 | 1 | 2.36e-08 | 0 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob002_m2014_q4i/Gen0/Prob002_m2014_q4i_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob002_m2014_q4i/Gen0/Prob002_m2014_q4i_initial_sample1.syn.v | 0 |
| aspdac2026/gpt-4.1-mini_clean_results/VerilogEval-Spec-to-RTL/Prob061_2014_q4a | register_sequential | 196 | 196 | 196 | 0 | 0 | 0 | 0 | -0 | 9 | 0.000774 | 0.23 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/gpt-4.1-mini_clean_results/VerilogEval-Spec-to-RTL/Prob061_2014_q4a/Gen0/Prob061_2014_q4a_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/gpt-4.1-mini_clean_results/VerilogEval-Spec-to-RTL/Prob061_2014_q4a/Gen0/Prob061_2014_q4a_initial_sample1.syn.v | 1 |
| aspdac2026/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob024_hadd | wire_assign | 196 | 196 | 196 | 0 | 0 | 0 | 0 | -0 | 3 | 8.66e-05 | 0 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob024_hadd/Gen0/Prob024_hadd_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob024_hadd/Gen0/Prob024_hadd_initial_sample1.syn.v | 0 |
| aspdac2026/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob059_wire4 | wire_assign | 196 | 196 | 196 | 0 | 0 | 0 | 0 | -0 | 3 | 8.44e-05 | 0 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob059_wire4/Gen0/Prob059_wire4_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob059_wire4/Gen0/Prob059_wire4_initial_sample1.syn.v | 0 |
| aspdac2026/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob022_mux2to1 | mux_ternary | 195 | 195 | 195 | 0 | 0 | 0 | 0 | -0 | 2 | 4.65e-05 | 0 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob022_mux2to1/Gen0/Prob022_mux2to1_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob022_mux2to1/Gen0/Prob022_mux2to1_initial_sample1.syn.v | 0 |
| aspdac2026/gpt-4.1-mini_clean_results/RTLLM/Prob023_up_down_counter | register_sequential | 195 | 195 | 194 | 0.0009267 | 0.0009267 | 0.0009267 | 1 | 0.09926 | 230 | 0.0318 | 0.5 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/gpt-4.1-mini_clean_results/RTLLM/Prob023_up_down_counter/Gen18/Prob023_up_down_counter_M-E_sample4.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/gpt-4.1-mini_clean_results/RTLLM/Prob023_up_down_counter/Gen18/Prob023_up_down_counter_M-E_sample4.syn.v | 1 |
| aspdac2026/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob065_7420 | wire_assign | 194 | 194 | 194 | 0 | 0 | 0 | 0 | -0 | 5 | 5.04e-05 | 0 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob065_7420/Gen0/Prob065_7420_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob065_7420/Gen0/Prob065_7420_initial_sample1.syn.v | 0 |
| aspdac2026/gpt-4.1-mini_clean_results/VerilogEval-Spec-to-RTL/Prob073_dff16e | register_sequential | 193 | 193 | 193 | 0 | 0 | 0 | 0 | -0 | 129 | 0.0126 | 0.2 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/gpt-4.1-mini_clean_results/VerilogEval-Spec-to-RTL/Prob073_dff16e/Gen0/Prob073_dff16e_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/gpt-4.1-mini_clean_results/VerilogEval-Spec-to-RTL/Prob073_dff16e/Gen0/Prob073_dff16e_initial_sample1.syn.v | 0 |
| aspdac2026/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob008_m2014_q4h | wire_assign | 193 | 193 | 193 | 0 | 0 | 0 | 0 | -0 | 1 | 2.11e-05 | 0 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob008_m2014_q4h/Gen0/Prob008_m2014_q4h_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob008_m2014_q4h/Gen0/Prob008_m2014_q4h_initial_sample1.syn.v | 0 |
| aspdac2026/gpt-4.1-mini_clean_results/VerilogEval-Spec-to-RTL/Prob026_alwaysblock1 | arithmetic_multiply | 191 | 191 | 191 | 0 | 0 | 0 | 0 | -0 | 2 | 7.33e-05 | 0 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/gpt-4.1-mini_clean_results/VerilogEval-Spec-to-RTL/Prob026_alwaysblock1/Gen0/Prob026_alwaysblock1_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/gpt-4.1-mini_clean_results/VerilogEval-Spec-to-RTL/Prob026_alwaysblock1/Gen0/Prob026_alwaysblock1_initial_sample1.syn.v | 1 |
| aspdac2026/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob025_reduction | wire_assign | 191 | 191 | 191 | 0 | 0 | 0 | 0 | -0 | 11 | 0.000941 | 0 | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob025_reduction/Gen0/Prob025_reduction_initial_sample1.sv | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_baseline_clean_results/VerilogEval-Spec-to-RTL/Prob025_reduction/Gen0/Prob025_reduction_initial_sample1.syn.v | 0 |

## Counterfactual Replay

| policy | mean_hypervolume | mean_best_fitness | mean_style_clusters | rows |
| --- | --- | --- | --- | --- |
| oracle_motif_diversity | 0.04287 | 0.2071 | 1.472 | 697 |
| oracle_style_diversity | 0.04243 | 0.2071 | 2.677 | 697 |
| online_style_diversity | 0.0424 | 0.2071 | 2.677 | 697 |
| oracle_lexical_diversity | 0.0423 | 0.2071 | 2.545 | 697 |
| oracle_best_fitness | 0.04229 | 0.2071 | 1.462 | 697 |
| online_best_fitness | 0.04226 | 0.2071 | 1.432 | 697 |
| random_seed_15 | 0.03239 | 0.1455 | 1.736 | 697 |
| random_seed_05 | 0.03226 | 0.1414 | 1.72 | 697 |
| random_seed_07 | 0.03147 | 0.1378 | 1.737 | 697 |
| random_seed_10 | 0.03146 | 0.1491 | 1.703 | 697 |
| random_seed_19 | 0.03129 | 0.1462 | 1.714 | 697 |
| random_seed_17 | 0.03124 | 0.1456 | 1.703 | 697 |
| random_seed_16 | 0.03122 | 0.1433 | 1.693 | 697 |
| random_seed_14 | 0.0311 | 0.137 | 1.714 | 697 |
| random_seed_01 | 0.03098 | 0.1441 | 1.76 | 697 |
| random_seed_03 | 0.03093 | 0.1472 | 1.735 | 697 |
| random_seed_06 | 0.03082 | 0.144 | 1.709 | 697 |
| random_seed_02 | 0.03055 | 0.1419 | 1.669 | 697 |
| random_seed_09 | 0.03043 | 0.1459 | 1.737 | 697 |
| random_seed_04 | 0.02976 | 0.1322 | 1.753 | 697 |
| random_seed_13 | 0.02972 | 0.1422 | 1.717 | 697 |
| random_seed_11 | 0.02928 | 0.1303 | 1.716 | 697 |
| random_seed_08 | 0.02918 | 0.1393 | 1.712 | 697 |
| random_seed_12 | 0.02912 | 0.1389 | 1.722 | 697 |
| random_seed_18 | 0.02905 | 0.1505 | 1.7 | 697 |
| random_seed_00 | 0.0283 | 0.1392 | 1.694 | 697 |

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

- embedding_scatter: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/embedding_scatter.png`
- ppa_front_by_cluster: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/ppa_front_by_cluster.png`
- diversity_efficiency_frontier: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/diversity_efficiency_frontier.png`
- diversity_over_time: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/diversity_over_time_vs_quality.png`
- early_diversity_final_hv: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/early_diversity_vs_final_hv.png`
- replay_bars: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/counterfactual_replay_bars.png`
- stability_boxplots: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/descriptor_stability_boxplots.png`
- correlation_heatmap: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/correlation_heatmap.png`
- common_audit_heatmap: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/common_audit_heatmap.png`
- validity_funnel: `exp/diversity_check/restarted_report_20260621_075346_UTC/figures/validity_funnel.png`

## Representative Implementation Gallery

Case-study slots were selected before narrative interpretation: largest style-diversity HV, median Pareto cluster count, lowest valid-PPA rate, and the 20260618 Auto-BD negative-control case.

Gallery artifact: `exp/diversity_check/restarted_report_20260621_075346_UTC/implementation_gallery.md`

| case_type | problem_id | selection_rule | representative_path | cluster |
| --- | --- | --- | --- | --- |
| best_supported | aspdac2026/llama3_clean_results/RTLLM/Prob050_square_wave | largest style-diversity HV | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_clean_results/RTLLM/Prob050_square_wave/Gen20/Prob050_square_wave_M-E_sample9.sv | register_sequential |
| null_or_median | aspdac2026/llama3_clean_results/VerilogEval-Spec-to-RTL/Prob130_circuit5 | median Pareto cluster count | exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/llama3_clean_results/VerilogEval-Spec-to-RTL/Prob130_circuit5/Gen14/Prob130_circuit5_C-F_sample8.sv | control_case |
| negative_funnel | aspdac2026/deepseek_clean_results/VerilogEval-Spec-to-RTL/Prob113_2012_q1g | lowest valid-PPA rate |  |  |
| auto_bd_control | 20260618 ST-NOD/VQ | predeclared negative-control evidence | /workspace/docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_final_negative_decision.md | negative_control |

## Limits

- Parent-child lineage was recovered in Auto-BD archive tables, but method-level descendant-yield quality deltas remain negative on average, so L3 mechanistic utility is not supported.
- Qwen3 real embeddings were extracted and a larger common-audit replay was run. The result remains diagnostic-only because Qwen did not clear the replay utility threshold over lexical controls.
- DeepGate3 AIG export and checkpoint-compatible tokenizer embeddings were attempted, but the bounded embeddings collapsed and the graph-state policy remains combinational-only.
- D6 supports illumination only; D1/D2/D3/D5 failed and D4 was not run, so the evidence does not justify reconstructive, predictive, active, or Auto-BD method claims.
