# Technique Package Index

Each numbered subdirectory is a method package for the useful-BD push. The
visible `T##_` prefix is the chronological tracking index. A package is ready
to run when `methodology.md` fixes the algorithm, commands, descriptor inputs,
leakage exclusions, archive mapping, and expected artifacts. A package is
complete only after `results_report.md`, `artifacts_manifest.md`, `figures/`,
and `tables/` contain measured evidence.

At least 10 current packages must be attempted with real results before the
push can sign off a broad negative map.

The canonical machine-readable index is `technique_registry.csv`.

| ID | Directory | Family | State |
| --- | --- | --- | --- |
| `T01` | `T01_simple_yosys_stat_bd` | Simple control | `T0 diagnostic` |
| `T02` | `T02_motif_pathlet_bd` | Deterministic netlist descriptor | `T0 diagnostic` |
| `T03` | `T03_synthesis_delta_stnod_bd` | Synthesis/netlist descriptor | `T0 diagnostic`, near-miss |
| `T04` | `T04_autoqd_mmd_synthesis_bd` | Automatic QD descriptor | `T1 near_classic`, validation candidate |
| `T05` | `T05_vq_elites_codebook_bd` | Codebook/archive descriptor | `T0 diagnostic` |
| `T06` | `T06_qwen_projection_bd` | Learned/projection descriptor | `T0 diagnostic` |
| `T07` | `T07_deepgate_family_bd` | Circuit encoder descriptor | `T1 near_classic_replay_lead`; graph WL/combo tiny HV lead, front-hit blocker |
| `T08` | `T08_sequential_deepseq_bd` | Sequential encoder descriptor | Scaffolded |
| `T09` | `T09_nettag_text_graph_bd` | Text-attributed graph descriptor | Scaffolded |
| `T10` | `T10_circuitfusion_multimodal_bd` | Multimodal descriptor | Scaffolded |
| `T11` | `T11_mgvga_contrastive_bd` | Contrastive graph descriptor | `T1 near_classic_replay_lead`; +1.82% HV over lexical with front-hit blocker |
| `T12` | `T12_lineage_repair_bd` | Lineage/yield descriptor | Scaffolded |
| `T13` | `T13_aurora_incremental_autoencoder_bd` | Learned AURORA descriptor | mixed: raw implementation features `T1 near_classic_replay_lead`, compressed bottlenecks `T0 diagnostic` |
| `T14` | `T14_dehnn_hypergraph_bd` | Hypergraph descriptor | Completed replay diagnostic |
| `T15` | `T15_masterrtl_sog_bd` | RTL operator-graph descriptor | Scaffolded |
| `T16` | `T16_deepcell_multiview_bd` | Multiview circuit descriptor | Scaffolded |
| `T17` | `T17_mome_pareto_archive_bd` | Archive-coupling/Pareto variant | `T0 diagnostic`, passive live-candidate |
| `T18` | `T18_adaptive_emitter_cvt_bd` | Archive-coupling/emitter variant | Scaffolded |
| `T19` | `T19_sr_relu_pca_bd` | Automatic QD descriptor | `T0 diagnostic`, high-priority HV lead |
| `T20` | `T20_sr_raw_pca_bd` | Automatic QD descriptor | `T0 diagnostic`, projection ablation near-miss |
| `T21` | `T21_stnod_motif_hybrid_bd` | Deterministic netlist descriptor | `T0 diagnostic`, archive-coverage ablation |
| `T22` | `T22_random_descriptor_control` | Negative control | `T0 control`, required comparator |
| `T23` | `T23_sr_pareto_validation_matrix` | Archive-coupling validation | `T0 diagnostic`, passive live-candidate matrix |
| `T24` | `T24_sr_pareto_live_validation` | Archive-coupling live validation | `T0 diagnostic`, complete six-arm live matrix |
| `T25` | `T25_guarded_sr_raw_pareto_qd` | Archive-coupling guarded live variant | `T0 diagnostic` |
| `T26` | `T26_sr_raw_conservative_exploit_qd` | Archive-coupling parent-source variant | `T0 diagnostic`, active lead |
| `T27` | `T27_t26_live_qd_audit` | Live QD audit | `T1 near_classic` audit support for T26 |
| `T28` | `T28_t26_family_audit` | Canonical/family audit | `T1 near_classic` support with front-family blocker |
| `T29` | `T29_sr_raw_front_recovery_qd` | Archive-coupling front-recovery variant | `T0 diagnostic`; failed to recover multi-pipe front/final-PPA coverage |
| `T30` | `T30_t26_holdout_front_audit` | Archive-coupling holdout audit | `T1 near_classic` holdout support with P098 yield warning |
| `T31` | `T31_sr_raw_fail_feedback_repair_qd` | Archive-coupling failure-feedback repair variant | `T0 diagnostic`; no P098 repair or P135 HV retention |
| `T32` | `T32_sr_raw_front_preserving_emitter_qd` | Archive-coupling front-preserving emitter variant | `T0 diagnostic`; P098 yield hint but no P135 HV/quality retention |
| `T33` | `T33_qwen3_preprocessing_ladder_bd` | Learned/projection descriptor | `T0 diagnostic`; RTL views modestly beat lexical HV, netlist collapse fix does not transfer |
| `T34` | `T34_qwen_pca_residual_bd` | Learned/projection descriptor | `T0 diagnostic`; PCA residuals preserve RTL HV but do not reduce collapse enough |
| `T35` | `T35_t11_pareto_coupling_bd` | Archive-coupled contrastive descriptor | mixed `T0/T1 diagnostic`; cell-local Pareto improves front hits but loses HV, front-seeded is only an upper bound |
| `T36` | `T36_t11_bounded_front_lane_bd` | Archive-coupled contrastive descriptor | `T2 replay_candidate`; one local-front slot gives +4.04% HV and +4 front hits vs lexical |
| `T37` | `T37_t36_slot_count_ablation` | Archive-coupled contrastive descriptor | `T2 replay_candidate`; one-slot T37 matches T36, two-plus slots collapse HV |
| `T38` | `T38_elite_pareto_slot_live_qd` | Archive-coupling live validation | `T0 diagnostic`; runs end to end but multi-pipe active archive stays empty under warmup 8 |
| `T39` | `T39_sparse_yield_warmup_qd` | Archive-coupling warmup ablation | `T0 positive_ablation`; fixes T38 multi-pipe archive gap, but T40 blocks broad promotion |
| `T40` | `T40_sparse_warmup_control_matrix` | Archive-coupling control matrix | `T0 mixed_control`; classic wins ALU/traffic pooled fronts, T39 only wins multi-pipe |
| `T41` | `T41_adaptive_sparse_yield_gate_qd` | Archive-coupling adaptive warmup variant | `T0 mixed_diagnostic`; traffic-light win, but ALU and multi-pipe block promotion |
| `T42` | `T42_initial_sparse_yield_gate_qd` | Archive-coupling initial warmup variant | `T0 mixed_diagnostic`; generation-0 gate adds ALU/multi-pipe pooled hits but loses T41 traffic-light |
| `T43` | `T43_staged_sparse_yield_gate_qd` | Archive-coupling staged warmup variant | `T0 mixed_diagnostic`; staged branch did not activate and direct PPA front has zero pooled hits |
| `T44` | `T44_t11_runtime_graph_bridge` | Learned graph descriptor runtime bridge | `T0 mixed_diagnostic`; HV/front signal, yield-gate blocker |
| `T45` | `T45_t11_runtime_top4_graph` | Learned graph descriptor runtime bridge | `T0 mixed_diagnostic`; compact graph axes preserve coverage but lose mean HV, valid-PPA, and best score |
| `T46` | `T46_t11_runtime_pca4_graph` | Learned graph descriptor runtime projection | `T0 mixed_diagnostic`; ALU HV signal, but direct graph-axis primary lane retired |
| `T47` | `T47_t26_contract_probe` | Archive-coupling contract probe | `T0 diagnostic`; exact T26 has positive best-score delta but is not held-out-ready |
| `T48` | `T48_t26_gated_near_front_fusion_qd` | Archive-coupling parent gate | `T0 diagnostic after review`; gated near-front fusion reduces some exact-T26 damage but still loses primary QD metrics versus classic |
| `T49` | `T49_thought_k_role_separated_repair_qd` | Archive-coupling role-separated emitter | `T0 mixed_diagnostic`; preserves covered valid-PPA designs and improves best score, but loses mean HV, valid-PPA count, and front coverage |
| `T50` | `T50_candidate_matched_thought_front_qd` | Archive-coupling candidate/front control | `T0 diagnostic`; partial 12-problem screen improves best score but loses HV, HV-AUC, valid-PPA, and front material |
| `T51` | `T51_code_thought_front_slot_qd` | Archive-coupling code-level front-slot emitter | `T0 positive_ablation_not_promoted`; restores T50 yield/HV-AUC but still loses classic front breadth |
| `T52` | `T52_code_thought_full_pareto_qd` | Archive-coupling code-level full-Pareto emitter | `T0 diagnostic`; +3 front points versus T51, but loses HV-AUC/yield recovery and triggers Prob098 yield warning |
| `T53` | `T53_sparse_front_trigger_qd` | Archive-coupling sparse-front trigger | `T0 diagnostic_not_promoted`; trigger fires but classic still wins HV, HV-AUC, valid-PPA, unique PPA, and front points |
| `T54` | `T54_front_slot_lane_qd` | Archive-coupling front-slot parent lane | `T0 diagnostic_not_promoted`; lane has 12 requests and 4 hits but loses classic and T51 on primary front/HV evidence |
| `T55` | `T55_coarse_sr2_front_slot_qd` | Archive-coupling coarse descriptor geometry | `T0 positive_mechanism_ablation_not_promoted`; improves T54 slot hits but still loses classic/T51 on promotion metrics |
| `T56` | `T56_coarse_sr2_t51_control_qd` | Archive-coupling coarse descriptor geometry | Pre-registered T51-control ablation; isolates two-axis SR-PCA geometry without T55's fixed front-slot parent lane |

All methods must be scored with the same `T0` to `T3` tier definitions from
`../useful_bd_push_plan.md`. Near-classic behavior is a useful signal; the
former 10 percent threshold is only the `T3 strong_win` bar.

Completed packages must also satisfy `../visualization_reporting_policy.md`.
The first reader-facing plot should be a standalone raw area-power PPA Pareto
front PNG when PPA data exists. Use conventional non-inverted axes with
lower-left marked as better; BD-space, normalized, and HTML visualizations are
supporting artifacts. Figures should be manually inspected before a result is
accepted.
