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
| `T15` | `T15_masterrtl_sog_bd` | RTL operator-graph descriptor | `T0 structural_proxy_not_promoted`; zero-failure Yosys-SOG lowering, but front-cell and occupied-cell evidence do not beat classic |
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
| `T26` | `T26_sr_raw_conservative_exploit_qd` | Archive-coupling parent-source variant | `T0 diagnostic`; broad RTLLM claim is negative after reference-complete correction |
| `T27` | `T27_t26_live_qd_audit` | Live QD audit | `T0 diagnostic`; early aggregate support is not claim-safe after missing-reference correction |
| `T28` | `T28_t26_family_audit` | Canonical/family audit | `T0 diagnostic`; valid candidates are mostly distinct, but front-family breadth trails classic |
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
| `T56` | `T56_coarse_sr2_t51_control_qd` | Archive-coupling coarse descriptor geometry | `T0 diagnostic_retire_coarse_sr2_geometry`; preserves coverage but loses classic/T51 on HV, HV-AUC, yield, and front evidence |
| `T57` | `T57_t51_adaptive_rebin_qd` | Archive-coupling adaptive rebinning | `T0 diagnostic_no_rebin_signal`; 26 checks, 0 rebins, worse than classic/T51 on HV/HV-AUC, and one classic-covered valid-PPA loss |
| `T58` | `T58_t51_t11_pca4_front_slot_qd` | Learned projection archive coupling | `T0 diagnostic_no_promotion`; valid-PPA and best-score gains, but classic/T51 still win HV/HV-AUC/front breadth |
| `T59` | `T59_t51_feedback_front_slot_qd` | Archive-coupling feedback front slot | `T0 diagnostic_no_promotion`; best score improves, but HV, HV-AUC, valid-PPA, and front breadth lose to classic |
| `T60` | `T60_rtl_timer_timing_risk_bd` | RTL-native timing descriptor | `T0 diagnostic_proxy`; pooled timing-risk cells do not separate classic from exact T26 |
| `T61` | `T61_rtl_timer_problem_local_bd` | RTL-native timing descriptor | `T0 positive_proxy_not_promoted`; problem-local timing-risk front-cell proxy improves, but occupied breadth loses |
| `T62` | `T62_fused_rtl_native_bd` | RTL-native fused descriptor | `T0 positive_proxy_not_promoted`; fused structural/timing front-cell proxy improves, but occupied breadth still loses |
| `T63` | `T63_fused_rtl_native_live_screen` | RTL-native fused descriptor | `T0 positive_mechanism_ablation_not_promoted`; front-material signal versus T51, but classic wins HV/HV-AUC/front points |
| `T64` | `T64_fused_operator_timing_live_screen` | RTL-native fused descriptor | `T0 diagnostic_yield_archive_ablation_not_promoted`; valid-PPA yield improves but classic wins the PPA-front metrics |
| `T65` | `T65_rtl_native_secondary_cells` | RTL-native secondary-cell audit | `T0 diagnostic_secondary_cell_not_promoted`; source-level RTLTimer cells around T51/T63/T64 do not beat Classic front-cell coverage |
| `T66` | `T66_rtl_native_front_guarded_parent_qd` | RTL-native archive coupling | Pre-registered; uses RTL state/pipeline cells for front-slot parent pressure and low-rate gated fusion |
| `T67` | `T67_rtl_native_seeded_thought_qd` | RTL-native source-preserving coupling | `T0 diagnostic_yield_positive_front_negative_blocked`; valid-PPA yield improves but front breadth and `Prob153_gshare` coverage fail |
| `T68` | `T68_source_verified_rtl_native_extractors` | RTL-native source verification | `T0 verification_gate`; upstream MasterRTL/RTL-Timer example artifacts are partly verified, but fresh conversion is blocked by Verific-dependent Yosys scripts |
| `T69` | `T69_open_yosys_rtl_native_preprocessing` | RTL-native source alignment | `T0 preprocessing_unblocker`; TinyRocket open-Yosys SOG/BOG preprocessing works after removing `read -verific` and applying upstream-style cleanup |
| `T70` | `T70_generated_rtl_extractor_smoke` | RTL-native source alignment | `T0 extractor_smoke_unblocker`; source-aligned MasterRTL/RTL-Timer extraction passes on 19 generated T67 RTL candidates |
| `T71` | `T71_source_aligned_rtl_native_feature_map` | RTL-native source alignment | `T0 descriptor_design_unblocker`; source-aligned extractor outputs cover 9/16 proposed RTL-native cells without PPA leakage |
| `T72` | `T72_source_aligned_rtl_cell_qd` | RTL-native archive coupling | `T1 near_classic_not_promoted`; preserves `13/13` covered designs and trails classic mean HV by about `0.65%`, but loses HV wins and front breadth |
| `T73` | `T73_source_aligned_shape_density_qd` | RTL-native archive coupling | Matched comparison packaged; preserves coverage and improves valid-PPA yield, but classic wins HV/front breadth |
| `T74` | `T74_shape_density_front_slot_hybrid_qd` | RTL-native archive coupling | `T0 diagnostic_regression_not_promoted`; preserves coverage but loses classic/T73 on headline HV/yield evidence |
| `T75` | `T75_shape_density_front_pressure_qd` | RTL-native archive coupling | Completed `T0 positive_diagnostic_not_promoted`; stronger front-slot pressure improves T73/T74 mean HV but not classic |
| `T76` | `T76_masterrtl_pretrained_model_gate` | RTL-native pretrained model verification | Completed `T0 verification_gate_partial`; MasterRTL tree artifacts load, but generated-candidate variation is still required before live pretrained-model BDs |
| `T77` | `T77_masterrtl_area_leaf_variation_gate` | RTL-native pretrained model verification | Completed `T0_variation_gate_negative`; source-faithful Area features vary, but pretrained Area predictions/leaves collapse |
| `T78` | `T78_budget_depth_maturation_audit` | Budget and benchmark shape | Completed `T0_budget_hypothesis_support_not_live_ablation`; T75 archives still mature late under `12 x 3`, but the equal-budget ablation remains required |
| `T79` | `T79_budget_shape_ablation_protocol` | Budget and benchmark shape | Pre-registered; freezes the eight-design subset and six-arm `12x3`/`8x5`/`6x7` classic-vs-T75-QD command matrix |
| `T80` | `T80_masterrtl_structural_mix_gate` | RTL-native pretrained model verification | Completed `T0_descriptor_gate_positive_not_live`; raw MasterRTL structural axes do not collapse on generated candidates |
| `T81` | `T81_masterrtl_rf_timing_state_gate` | RTL-native pretrained model verification | Completed `T0_model_state_gate_positive_not_live`; RF timing model states do not collapse on generated timing-path candidates |
| `T82` | `T82_masterrtl_rf_timing_runtime_hook` | RTL-native pretrained model runtime hook | Completed `T0_screened_negative_not_promoted`; RF timing model-state metrics resolve through the live descriptor registry, but the frozen `8x5` screen trails classic |

All methods must be scored with the same `T0` to `T3` tier definitions from
`../useful_bd_push_plan.md`. Near-classic behavior is a useful signal; the
former 10 percent threshold is only the `T3 strong_win` bar.

Completed packages must also satisfy `../visualization_reporting_policy.md`.
The first reader-facing plot should be a standalone raw area-power PPA Pareto
front PNG when PPA data exists. Use conventional non-inverted axes with
lower-left marked as better; BD-space, normalized, and HTML visualizations are
supporting artifacts. Figures should be manually inspected before a result is
accepted.
