# Useful BD Push Local Index

This directory is the local control center for the 20260622 useful-BD push.
Start here when resuming the active goal.

## Current State

- Active branch: `feat/journal-useful-bd-exp-20260622`.
- Goal contract: `useful_bd_push_plan.md`.
- Short operational technique ranking: `best_current_techniques.md`.
- Consolidated research interpretation:
  `research_strategy_recommendations.md` (why classic is strong, how to frame
  QD, budget-shape ablation, discriminative design set, and MasterRTL/RTLTimer
  pretrained verification gate).
- Living checklist: `useful_bd_push_implementation_todo.md`.
- Append-only evidence log: `useful_bd_push_implementation_history.md`.
- Current priority milestone:
  `presentations/20260623_report/` (presentation, report, and broad RTLLM
  classic-vs-T26-family comparison plan).
- Current preliminary planning package:
  `preliminary_planning/20260625_encoder_config_screening/` (pretrained
  encoder, encoder-like, RTL-native, and custom-BD candidate ranking plus the
  completed eight-design screening matrix and result package).
- Current pretrained-encoder bridge package:
  `preliminary_planning/20260625_pretrained_encoder_bridge_validation/`
  (Qwen3 model smoke passes and is the next live-hook candidate; DeepGate and
  MasterRTL pretrained generated-candidate bridges remain blocked).
- Current generated-candidate Qwen probe:
  `preliminary_planning/20260625_qwen_live_screen_probe/` (Qwen3 canonical
  RTL embeddings are nonconstant on `540` valid-PPA candidates, but nearest
  neighbors are `99.26%` same-problem; the live descriptor hook now passes a
  bounded archive-insertion smoke and needs a matched screen before any full
  RTLLM spend).
- Most recent presentation supplement:
  `presentations/20260623_report/full_rtllm/final_analysis/`
  (`report_final_analysis_bundle.py` output on the 46-problem
  reference-complete subset; reinforces diagnostic status because the formal
  bundle recommends classic overall/Pareto while preserving T26 archive-QD
  signal).
- Frozen screening subset: `tables/frozen_screening_subset.csv`.
- Holdout subset: `tables/holdout_screening_subset.csv`.
- First completed method package: `techniques/T01_simple_yosys_stat_bd/`
  (`T0 diagnostic`).
- Most recent completed package:
  `techniques/T82_masterrtl_rf_timing_runtime_hook/`
  (`T0_live_smoke_positive_not_screened`; MasterRTL RF timing model-state
  metrics resolve through the live descriptor registry and one live smoke, but
  this is not a screened QD/PPA result).
- Most recent preliminary planning package:
  `preliminary_planning/20260626_masterrtl_rf_timing_live_smoke/`
  (records the first live smoke for the RF timing descriptor and the next
  frozen `8x5` screen requirement).
- Most recent live ablation:
  `techniques/T64_fused_operator_timing_live_screen/` (direct T63
  `operator_timing` ablation; completed seed `1001`).
- Next direction:
  no QD configuration is promoted for full RTLLM spend yet.
  `source_aligned_rf_timing_state_3d` passed a one-problem live smoke, so the
  next gate is the frozen eight-design `8x5` screen with reference-complete
  accounting.
- Most recent cross-cutting visualization:
  `visualization_audits/20260621_direct_ppa_fronts/` (corrected conventional
  lower-left-better raw area-power Pareto fronts plus active-objective front
  counts for T24/T25/T26 live methods).
- Prior per-technique direct PPA visualization:
  `techniques/T40_sparse_warmup_control_matrix/figures/t40_raw_area_power_fronts.png`
  (raw area-power front panels for the T40 control matrix).
- Most recent per-technique direct PPA visualization:
  `techniques/T75_shape_density_front_pressure_qd/matched_classic_comparison/figures/t75_hv_delta_by_problem.png`
  (13-problem matched classic-vs-T75 HV-delta summary).
- Most recent direct PPA HTML viewer:
  `techniques/T72_source_aligned_rtl_cell_qd/visualizations/direct_ppa_pareto/index.html`
  (filesystem-openable raw area-power Pareto supplement with summary cards and
  screenshot; not the full Phase 03.1 viewer).
- Most recent full Phase 03.1 viewer:
  `techniques/T75_shape_density_front_pressure_qd/matched_classic_comparison/visualizations/qd_ppa_viewer/index.html`
  (linked archive/PPA timeline viewer with compare mode, archive projection,
  raw/improvement/normalized PPA modes, raw A-P front mode, and screenshot).
- Current Phase 03.1 visualization contract:
  `phase_03_1_visualization_contract.md` (every completed live QD technique
  with archive artifacts needs the full `qd_ppa_viewer/` bundle plus the
  `direct_ppa_pareto/` supplement).
- Most recent live technique:
  `techniques/T75_shape_density_front_pressure_qd/` (seed-1001 hard/tuning
  source-aligned shape-density front-pressure screen with direct PPA panels,
  Phase 03.1 viewer, and matched comparison package).
- Active RTL-native descriptor packages:
  `techniques/T15_masterrtl_sog_bd/` (`T0 structural_proxy_not_promoted`
  Yosys-SOG proxy with zero lowering failures) and
  `techniques/T61_rtl_timer_problem_local_bd/` (`T0
  positive_proxy_not_promoted` problem-local timing-risk proxy) and
  `techniques/T62_fused_rtl_native_bd/` (`T0
  positive_proxy_not_promoted` fused structural/timing proxy). T63, T64, T66,
  T67, and T72 are reference-complete live archive tests, and T65 is a
  secondary-cell audit over T51/T63/T64. Use them as mechanism evidence only:
  none beats classic headline PPA-front metrics. T68/T69/T70/T71 are the
  source-verification and descriptor-design bridge; T72 is the first live
  source-aligned comparison, but exact T72 remains not promoted. T73 improves
  valid-PPA yield but not front breadth, T74 regresses, T75 is a positive
  diagnostic that improves over T73/T74 without beating classic, and T76
  verifies MasterRTL pretrained model artifacts. T77 then blocks the direct
  pretrained Area-head leaf BD because generated candidates collapse to one
  prediction and one leaf row. T80 and T81 reopen the lane through
  noncollapsed raw structural and RF timing model-state signals, and T82
  exposes the RF timing state as a live descriptor hook. T78 moves the
  budget-shape concern from discussion into a reproducible diagnostic audit,
  but leaves the live equal-candidate ablation open.
- Ignored local run outputs: `exp/useful_bd_push/`.

## Top-Level Docs

| File | Purpose |
| --- | --- |
| `README.md` | This local navigation guide. |
| `best_current_techniques.md` | Short current-best operational ranking and update rules. |
| `research_strategy_recommendations.md` | Consolidated strategic recommendations from the classic-vs-QD, budget-shape, design-set, and MasterRTL/RTLTimer discussions. |
| `goal_template.md` | Compact goal body that fits the goal-tool limit. |
| `useful_bd_push_plan.md` | Main contract: outcome, constraints, method families, gates, and completion criteria. |
| `technique_lineage_ledger.md` | Skim-first lane/category map with result lineage, branch policy, and Mermaid process graph. |
| `technique_lanes.md` | Lane-based process map with method families, lineage graph, decision ledger, branch guidance, and next actions. |
| `useful_bd_push_implementation_todo.md` | Short checklist to keep the goal moving. |
| `useful_bd_push_implementation_history.md` | Chronological evidence log for decisions, commands, runs, failures, and commits. |
| `current_results_matrix.md` | Interim cross-method matrix after ten real packages; compares current leads, controls, and next actions. |
| `common_evaluation_contract.md` | Shared baseline set, method-result schema, passive-archive contract, and required reporting bundle for future screens. |
| `useful_bd_push_adversarial_prompt.md` | Independent validation prompt for final sign-off. |
| `useful_bd_push_subagent_validation_report.md` | Placeholder for the final adversarial validation report. |
| `metrics_and_acceptance.md` | Glossary, primary QD metrics, tier definitions, validity gates, and anti-loophole rules. |
| `anti_reward_hacking_policy.md` | Persistence, no-premature-stop, anti-gaming, and dependency-escalation rules. |
| `experimental_setup.md` | Branch, output-root, replay-source, dependency, and reproducibility setup. |
| `screening_subset_selection.md` | Subset scoring rule, frozen screening set, holdout set, and replacement rule. |
| `vllm_runtime_guide.md` | Known vLLM endpoints, preflight commands, token policy, and live-run command shape. |
| `code_organization_policy.md` | Where code should live and how to keep experiments modular. |
| `phase_03_1_visualization_contract.md` | Mandatory full linked archive/PPA viewer and direct PPA supplement contract for new live QD techniques. |
| `visualization_reporting_policy.md` | Required figures, visual inspection checklist, and reporting standards. |
| `literature_method_search.md` | Method search notes and mapping from literature to candidate packages. |
| `idea_backlog.md` | Follow-up ideas, especially those generated by `T0` results. |
| `presentations/20260623_report/` | Current milestone package: report, slides, RTLLM protocol, commands, data manifest, and review rubrics. |
| `preliminary_planning/` | Pre-run candidate-selection packages before expensive live screens or full RTLLM spends. |

## Nested Directories

| Directory | Contents |
| --- | --- |
| `tables/` | Small committed setup tables: replay source inventory, scored screening candidates, frozen screening subset, and holdout subset. |
| `techniques/` | One numbered subdirectory per attempted or planned BD/QD technique. The visible `T##_` prefix is chronological. |
| `visualization_audits/` | Cross-method figure bundles when a visualization compares several technique packages rather than one method. |
| `presentations/` | Milestone presentation/report packages and broad experiment summaries. |
| `preliminary_planning/` | Shortlisting, preflight, descriptor-probe, and screening-matrix packages. |
| `techniques/technique_registry.csv` | Stable chronological index for all technique packages. |
| `techniques/T##_slug/figures/` | Generated or copied PNG figures plus visual inspection notes for that method. |
| `techniques/T##_slug/tables/` | Raw or summarized CSV tables needed to regenerate method claims. |
| `techniques/T##_slug/visualizations/` | HTML viewers, screenshots, and source CSVs when a method has interactive visualization artifacts. |
| `techniques/T##_slug/visualizations/qd_ppa_viewer/` | Mandatory full Phase 03.1 viewer for live QD methods with archive artifacts. |
| `techniques/T##_slug/visualizations/direct_ppa_pareto/` | Mandatory paper-readable raw PPA-front supplement for live PPA methods. |

## Process Tracking

- `technique_lineage_ledger.md` is the fast orientation document: use it to
  see category, result, lineage, and branch direction.
- `technique_lanes.md` is the detailed research log: use it for rationale,
  decision tags, and the longer lane notes.
- `techniques/technique_registry.csv` is the chronological package index.
- `visualization_audits/20260621_direct_ppa_fronts/` is the fast way to inspect
  direct PPA Pareto/front geometry across the completed live methods.
- For the holdout lineage, open the per-technique primary figures first:
  `T30_t26_holdout_front_audit/figures/t30_holdout_ppa_pareto_area_power_candidate_zoom.png`
  and
  `T31_sr_raw_fail_feedback_repair_qd/figures/t31_holdout_ppa_pareto_area_power_candidate_zoom.png`.

## Technique Package States

| ID | Package | State |
| --- | --- | --- |
| `T01` | `T01_simple_yosys_stat_bd` | Replay result, `T0 diagnostic`; simple CAD-native lower bound. |
| `T02` | `T02_motif_pathlet_bd` | Replay result, `T0 diagnostic`; partial motif-occupancy member of the motif/pathlet family. |
| `T03` | `T03_synthesis_delta_stnod_bd` | Replay result, `T0 diagnostic`; prioritized near-miss for synthesis-response descriptors. |
| `T04` | `T04_autoqd_mmd_synthesis_bd` | Replay result, `T1 near_classic`; strongest current automatic-descriptor lead. |
| `T05` | `T05_vq_elites_codebook_bd` | Replay result, `T0 diagnostic`; fixed codebook descriptor loses quality and passive-QD score. |
| `T06` | `T06_qwen_projection_bd` | Diagnostic result, `T0 diagnostic`; raw/identifier Qwen has HV signal but nuisance-axis clustering. |
| `T07` | `T07_deepgate_family_bd` | Completed replay diagnostic, `T1 near_classic_replay_lead`; graph WL/combo barely beat lexical HV but do not beat lexical direct front hits. |
| `T08` | `T08_sequential_deepseq_bd` | Retrospective sequential proxy, `T0 retrospective_sequential_proxy_not_promoted`; state/pipeline evidence is yield/near-classic useful but not a true DeepSeq pretrained reproduction or PPA-front win. |
| `T09` | `T09_nettag_text_graph_bd` | Scaffolded. |
| `T10` | `T10_circuitfusion_multimodal_bd` | Scaffolded. |
| `T11` | `T11_mgvga_contrastive_bd` | Completed replay diagnostic, `T1 near_classic_replay_lead`; top-64/weighted structural contrastive descriptors improve HV by +1.82% but still trail lexical direct front hits. |
| `T12` | `T12_lineage_repair_bd` | Retrospective synthesis, `T0 retrospective_direct_repair_retired`; T31/T49/T51/T59 evidence retires direct repair and short feedback while keeping T51 as recovery context. |
| `T13` | `T13_aurora_incremental_autoencoder_bd` | Completed replay diagnostic; raw implementation features are `T1 near_classic_replay_lead`, but PCA/RFF/incremental bottlenecks are `T0 diagnostic`. |
| `T14` | `T14_dehnn_hypergraph_bd` | Completed replay diagnostic; hypergraph plus implementation features are `T1 near_classic_replay_lead`, but hypergraph-only descriptors are `T0 diagnostic`. |
| `T15` | `T15_masterrtl_sog_bd` | Completed `T0 structural_proxy_not_promoted` Yosys-SOG proxy audit; zero lowering failures, slightly negative front-cell delta, weaker occupied-cell breadth. |
| `T16` | `T16_deepcell_multiview_bd` | Scaffolded. |
| `T17` | `T17_mome_pareto_archive_bd` | Passive local-Pareto audit, `T0 diagnostic`; strong front-diversity signal but no decisive HV gain. |
| `T18` | `T18_adaptive_emitter_cvt_bd` | Retrospective synthesis, `T0 retrospective_retired`; T57 archive adaptation and T32 front-emitter evidence block a fresh exact T18 spend. |
| `T19` | `T19_sr_relu_pca_bd` | Replay result, `T0 diagnostic`; strong SR ReLU HV/AUC lead but quality and coverage tradeoffs. |
| `T20` | `T20_sr_raw_pca_bd` | Replay result, `T0 diagnostic`; raw synthesis-response PCA ablation with front-diversity signal. |
| `T21` | `T21_stnod_motif_hybrid_bd` | Replay result, `T0 diagnostic`; ST-NOD+motif expands archive coverage but loses quality. |
| `T22` | `T22_random_descriptor_control` | Replay result, `T0 control`; random archive partitioning is a strong required comparator. |
| `T23` | `T23_sr_pareto_validation_matrix` | Passive validation matrix, `T0 diagnostic`; compares T04/T19 against classic, manual BD, and T22. |
| `T24` | `T24_sr_pareto_live_validation` | Complete six-arm live development-screen result, `T0 diagnostic`; all QD arms preserve covered designs but lose too much multi-pipe best quality. |
| `T25` | `T25_guarded_sr_raw_pareto_qd` | Live result, `T0 diagnostic`; preserves all classic-covered designs but worsens multi-pipe best quality versus SR raw and fails traffic-light valid-PPA gate. |
| `T26` | `T26_sr_raw_conservative_exploit_qd` | Live result; preserves covered designs and has local best-score signals, but the reference-complete RTLLM comparison downgrades it to mechanism context. |
| `T27` | `T27_t26_live_qd_audit` | Live audit package; early HV/HV-AUC support is now treated as fragile after the missing-reference correction, not as `T1` proof. |
| `T28` | `T28_t26_family_audit` | Canonical/family audit package with direct PPA-front figures and scoped HTML viewer; T26 valid candidates are mostly distinct, but front-family count remains below classic and SR raw. |
| `T29` | `T29_sr_raw_front_recovery_qd` | Completed front-recovery live variant, `T0 diagnostic`; direct PPA-front plots show only two multi-pipe front points and no final multi-pipe best PPA. |
| `T30` | `T30_t26_holdout_front_audit` | Completed holdout audit; `T1 near-classic` support with a P098 yield warning, direct raw PPA Pareto figures, and no front-breadth win. |
| `T31` | `T31_sr_raw_fail_feedback_repair_qd` | Completed holdout live arm, `T0 diagnostic`; preserves final-best coverage but loses yield, P135 HV/quality, and unique PPA breadth. |
| `T32` | `T32_sr_raw_front_preserving_emitter_qd` | Completed holdout live arm, `T0 diagnostic`; repairs some P098 yield and unique PPA breadth versus T31 but loses T26's P135 HV/quality signal. |
| `T33` | `T33_qwen3_preprocessing_ladder_bd` | Completed replay diagnostic, `T0 diagnostic`; canonical RTL/identifier-role RTL modestly beat lexical HV, but canonical Yosys netlist's collapse improvement does not transfer to HV/PPA-front metrics. |
| `T34` | `T34_qwen_pca_residual_bd` | Completed replay diagnostic, `T0 diagnostic`; PCA residuals preserve T33 RTL HV signal but do not align HV, front hits, and collapse reduction. |
| `T35` | `T35_t11_pareto_coupling_bd` | Completed replay diagnostic, mixed `T0/T1 diagnostic`; T11 cell-local Pareto retention improves direct front hits but loses HV, while front-seeded retention is only an upper-bound diagnostic. |
| `T36` | `T36_t11_bounded_front_lane_bd` | Completed replay diagnostic, `T2 replay_candidate`; one local-front slot improves HV by +4.04% over lexical and recovers direct front hits to 126. |
| `T37` | `T37_t36_slot_count_ablation` | Completed replay diagnostic, `T2 replay_candidate`; confirms one local-front slot is the useful boundary and rejects two-plus slots. |
| `T38` | `T38_elite_pareto_slot_live_qd` | Completed bounded live arm, `T0 diagnostic`; ALU/traffic-light retain front material, but multi-pipe has zero active archive members under warmup 8. |
| `T39` | `T39_sparse_yield_warmup_qd` | Completed sparse-yield warmup live ablation, `T0 positive_ablation`; fixes the T38 multi-pipe archive gap. |
| `T40` | `T40_sparse_warmup_control_matrix` | Completed control matrix, `T0 mixed_control`; classic wins ALU/traffic pooled fronts while T39 wins multi-pipe. |
| `T41` | `T41_adaptive_sparse_yield_gate_qd` | Completed adaptive sparse-yield gate, `T0 mixed_diagnostic`; traffic-light win, but ALU and multi-pipe block promotion. |
| `T42` | `T42_initial_sparse_yield_gate_qd` | Completed initial sparse-yield gate, `T0 mixed_diagnostic`; direct PPA front shows ALU/multi-pipe pooled hits but traffic-light regression. |
| `T43` | `T43_staged_sparse_yield_gate_qd` | Completed staged sparse-yield gate, `T0 mixed_diagnostic`; strict warmup path prevented staged activation and T43 contributes zero pooled raw-front hits. |
| `T44` | `T44_t11_runtime_graph_bridge` | Completed live result, `T0 mixed_diagnostic`; T11 graph axes show HV/front signal but top-8 archive sparsity and yield loss block promotion. |
| `T45` | `T45_t11_runtime_top4_graph` | Completed live result, `T0 mixed_diagnostic`; compact graph axes preserve coverage but lose classic on HV, Pareto points, valid-PPA count, and best score. |
| `T46` | `T46_t11_runtime_pca4_graph` | Completed live result, `T0 mixed_diagnostic`; frozen PCA4 graph projection preserves coverage and wins ALU HV but loses classic on mean HV, reference-beating count, valid-PPA samples, and traffic-light quality. |
| `T47` | `T47_t26_contract_probe` | Completed hard/tuning result, `T0 diagnostic`; exact T26 keeps positive best-score movement but loses HV, HV-AUC, valid-PPA count, and aggregate front points versus classic. |
| `T48` | `T48_t26_gated_near_front_fusion_qd` | Completed hard/tuning result, `T0 diagnostic after review`; gated near-front fusion reduces some T47 damage but still loses the primary QD metrics versus classic. |
| `T49` | `T49_thought_k_role_separated_repair_qd` | Completed hard/tuning result, `T0 mixed_diagnostic`; preserves classic-covered valid-PPA coverage and improves best score, but loses mean HV, valid-PPA count, and front coverage. |
| `T50` | `T50_candidate_matched_thought_front_qd` | Partial hard/tuning result, `T0 diagnostic`; best-score gain, but HV, HV-AUC, valid-PPA, unique PPA, and front coverage lose. |
| `T51` | `T51_code_thought_front_slot_qd` | Completed hard/tuning result, `T0 positive_ablation_not_promoted`; restores T50 yield/HV-AUC but classic still wins front breadth. |
| `T52` | `T52_code_thought_full_pareto_qd` | Completed hard/tuning result, `T0 diagnostic_retired_full_pareto`; adds a few front points versus T51 but loses yield, HV-AUC, and best-score recovery. |
| `T53` | `T53_sparse_front_trigger_qd` | Completed hard/tuning result, `T0 diagnostic_not_promoted`; trigger fires, but HV, HV-AUC, valid-PPA, and front breadth still lose to classic. |
| `T54` | `T54_front_slot_lane_qd` | Completed hard/tuning result, `T0 diagnostic_not_promoted`; fixed front-slot lane is active but loses classic on HV, HV-AUC, valid-PPA count, unique PPA breadth, and front points. |
| `T55` | `T55_coarse_sr2_front_slot_qd` | Completed hard/tuning result, `T0 positive_mechanism_ablation_not_promoted`; improves T54 slot hits but still loses classic and T51 on primary promotion metrics. |
| `T56` | `T56_coarse_sr2_t51_control_qd` | Completed hard/tuning result, `T0 diagnostic_retire_coarse_sr2_geometry`; preserves coverage but loses classic/T51 on HV, HV-AUC, yield, and front evidence. |
| `T57` | `T57_t51_adaptive_rebin_qd` | Completed hard/tuning result, `T0 diagnostic_no_rebin_signal`; emits 26 rebin checks but 0 rebin events, loses classic/T51 on HV/HV-AUC, and has one classic-covered valid-PPA loss. |
| `T58` | `T58_t51_t11_pca4_front_slot_qd` | Completed hard/tuning result, `T0 diagnostic_no_promotion`; preserves valid-PPA coverage and improves best score/yield, but loses classic and T51 on HV/HV-AUC/front evidence. |
| `T59` | `T59_t51_feedback_front_slot_qd` | Completed hard/tuning result, `T0 diagnostic_no_promotion`; improves mean best score but loses HV, HV-AUC, valid PPA, front breadth, unique PPA, and reference-beating count versus classic. |
| `T60` | `T60_rtl_timer_timing_risk_bd` | Completed first `T0 diagnostic_proxy` timing-risk audit; interpretable RTL-native geometry, but no front-cell advantage over classic. |
| `T61` | `T61_rtl_timer_problem_local_bd` | Completed `T0 positive_proxy_not_promoted` problem-local timing-risk audit; small front-cell signal, but no live QD claim. |
| `T62` | `T62_fused_rtl_native_bd` | Completed `T0 positive_proxy_not_promoted` fused RTL-native audit; front-cell proxy improves, but occupied-cell breadth is still negative. |
| `T63` | `T63_fused_rtl_native_live_screen` | Completed `T0 positive_mechanism_ablation_not_promoted` live screen; improves T51 front-material measures but loses classic on HV, HV-AUC, and front points. |
| `T64` | `T64_fused_operator_timing_live_screen` | Completed `T0 diagnostic_yield_archive_ablation_not_promoted`; valid-PPA yield improves, but classic wins HV, HV-AUC, front, unique-PPA, and reference-beating metrics. |
| `T65` | `T65_rtl_native_secondary_cells` | Completed `T0 diagnostic_secondary_cell_not_promoted`; source-level RTLTimer secondary cells around T51/T63/T64 do not beat Classic on problem-paired front-cell coverage. |
| `T66` | `T66_rtl_native_front_guarded_parent_qd` | Completed `T0 diagnostic_yield_positive_front_negative_not_promoted`; yield and best score improve, but classic wins HV, HV-AUC, and front points. |
| `T67` | `T67_rtl_native_seeded_thought_qd` | Completed `T0 diagnostic_yield_positive_front_negative_blocked`; aggregate valid-PPA improves, but front breadth and `Prob153_gshare` coverage block promotion. |
| `T68` | `T68_source_verified_rtl_native_extractors` | Completed `T0 verification_gate`; upstream MasterRTL/RTL-Timer examples are partly verified, but fresh conversion needs Verific or a source-aligned preprocessing adaptation. |
| `T69` | `T69_open_yosys_rtl_native_preprocessing` | Completed `T0 preprocessing_unblocker`; TinyRocket open-Yosys SOG/BOG preprocessing is source-aligned enough for a generated-candidate extractor smoke, but not a live QD result. |
| `T70` | `T70_generated_rtl_extractor_smoke` | Completed `T0 extractor_smoke_unblocker`; 19 generated T67 RTL candidates pass both source-aligned extraction paths. |
| `T71` | `T71_source_aligned_rtl_native_feature_map` | Completed `T0 descriptor_design_unblocker`; 19 candidates occupy 9/16 source-aligned RTL-native cells without PPA leakage. |
| `T72` | `T72_source_aligned_rtl_cell_qd` | Completed `T1 near_classic_not_promoted`; fixed live run preserves coverage and trails classic mean HV by about `0.65%`, but classic wins HV wins, Pareto points, and reference-beating candidates. |
| `T73` | `T73_source_aligned_shape_density_qd` | Completed `T0 positive_diagnostic_not_promoted`; preserves matched coverage and improves valid-PPA yield, but classic wins mean HV and Pareto breadth. |
| `T74` | `T74_shape_density_front_slot_hybrid_qd` | Completed `T0 diagnostic_regression_not_promoted`; preserves reference-complete coverage, but loses classic/T73 on headline HV and valid-PPA evidence. |
| `T75` | `T75_shape_density_front_pressure_qd` | Completed `T0 positive_diagnostic_not_promoted`; improves valid-PPA yield and beats T73/T74 mean HV, but classic still wins mean HV and Pareto breadth. |
| `T76` | `T76_masterrtl_pretrained_model_gate` | Completed `T0 verification_gate_partial`; MasterRTL XGBoost/RF assets load, but generated-candidate variation is still required before a live pretrained-model BD. |
| `T77` | `T77_masterrtl_area_leaf_variation_gate` | Completed `T0_variation_gate_negative`; Area features vary, but pretrained Area predictions and leaf rows collapse across generated candidates. |

## Validity-Gate Note

This push uses a PPA-first acceptance policy. Functionality and synthesis yield
still matter for interpretation, but they are not the primary optimization
target once both methods can produce at least one valid PPA point for the same
design.

The hard validity gate is design-level coverage retention: if classic has at
least one valid functional PPA result for a design, a promoted QD method must
also have at least one valid functional PPA result for that design. A 50
percent or larger functionality, synthesis-valid, or valid-PPA yield drop is a
visible warning when classic has at least 10 passing samples, not automatic
rejection. Below 10 classic passing samples, report raw counts and mark the
rate as small-n/noisy; do not promote or reject a method from that rate alone.

Headline direct classic-vs-QD claims also require a reference-complete paired
subset. Missing candidate PPA is a method invalid/non-PPA count. Missing
reference PPA makes the design `diagnostic_only` for normalized improvement,
HV, and HV-AUC aggregates.
