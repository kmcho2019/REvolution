# Useful BD Push Local Index

This directory is the local control center for the 20260622 useful-BD push.
Start here when resuming the active goal.

## Current State

- Active branch: `feat/journal-useful-bd-exp-20260622`.
- Goal contract: `useful_bd_push_plan.md`.
- Short operational technique ranking: `best_current_techniques.md`.
- Living checklist: `useful_bd_push_implementation_todo.md`.
- Append-only evidence log: `useful_bd_push_implementation_history.md`.
- Current priority milestone:
  `presentations/20260623_report/` (presentation, report, and broad RTLLM
  classic-vs-T26-family comparison plan).
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
  `techniques/T66_rtl_native_front_guarded_parent_qd/`
  (`T0 diagnostic_yield_positive_front_negative_not_promoted`; improves total
  valid-PPA and mean best score, but classic still wins HV, HV-AUC, and front
  points on the 13-problem reference-complete hard/tuning screen).
- Most recent pre-registered package:
  `techniques/T67_rtl_native_seeded_thought_qd/` (RTL-native state/pipeline
  cells plus source-preserving seeded thought-code realization; seed `1001`
  pending).
- Most recent live ablation:
  `techniques/T64_fused_operator_timing_live_screen/` (direct T63
  `operator_timing` ablation; completed seed `1001`).
- Next direction:
  do not spend seed `1002` on exact T66. Run T67 seed `1001` before any
  broader RTL-native spend; it tests source-preserving realization rather than
  another parent-pressure tweak.
- Most recent cross-cutting visualization:
  `visualization_audits/20260621_direct_ppa_fronts/` (corrected conventional
  lower-left-better raw area-power Pareto fronts plus active-objective front
  counts for T24/T25/T26 live methods).
- Prior per-technique direct PPA visualization:
  `techniques/T40_sparse_warmup_control_matrix/figures/t40_raw_area_power_fronts.png`
  (raw area-power front panels for the T40 control matrix).
- Most recent per-technique direct PPA visualization:
  `techniques/T66_rtl_native_front_guarded_parent_qd/visualizations/direct_ppa_pareto/t66_raw_area_power_fronts_seed1001.png`
  (13-problem seed-1001 raw area-power fronts for the T66 hard/tuning
  package).
- Most recent direct PPA HTML viewer:
  `techniques/T66_rtl_native_front_guarded_parent_qd/visualizations/direct_ppa_pareto/index.html`
  (filesystem-openable raw area-power Pareto supplement with summary cards and
  Playwright screenshot; not the full Phase 03.1 viewer).
- Most recent full Phase 03.1 viewer:
  `techniques/T66_rtl_native_front_guarded_parent_qd/visualizations/qd_ppa_viewer/index.html`
  (linked archive/PPA timeline viewer with compare mode, archive projection,
  raw/improvement/normalized PPA modes, raw A-P front mode, screenshot, and a
  documented Playwright compare-guide caveat).
- Current Phase 03.1 visualization contract:
  `phase_03_1_visualization_contract.md` (every completed live QD technique
  with archive artifacts needs the full `qd_ppa_viewer/` bundle plus the
  `direct_ppa_pareto/` supplement).
- Most recent live technique:
  `techniques/T66_rtl_native_front_guarded_parent_qd/` (seed-1001 hard/tuning
  RTL-native guarded-parent diagnostic with direct PPA supplement and
  Phase 03.1 viewer).
- Active RTL-native descriptor packages:
  `techniques/T15_masterrtl_sog_bd/` (`T0 structural_proxy_not_promoted`
  Yosys-SOG proxy with zero lowering failures) and
  `techniques/T61_rtl_timer_problem_local_bd/` (`T0
  positive_proxy_not_promoted` problem-local timing-risk proxy) and
  `techniques/T62_fused_rtl_native_bd/` (`T0
  positive_proxy_not_promoted` fused structural/timing proxy). T63, T64, and
  T66 are reference-complete live archive tests, and T65 is a secondary-cell
  audit over T51/T63/T64. Use them as mechanism evidence only: none beats
  classic headline PPA-front metrics.
- Ignored local run outputs: `exp/useful_bd_push/`.

## Top-Level Docs

| File | Purpose |
| --- | --- |
| `README.md` | This local navigation guide. |
| `best_current_techniques.md` | Short current-best operational ranking and update rules. |
| `goal_template.md` | Compact goal body that fits the goal-tool limit. |
| `useful_bd_push_plan.md` | Main contract: outcome, constraints, method families, gates, and completion criteria. |
| `technique_lineage_ledger.md` | Skim-first lane/category map with result lineage, branch policy, and Mermaid process graph. |
| `technique_lanes.md` | Lane-based process map with method families, lineage graph, decision ledger, branch guidance, and next actions. |
| `useful_bd_push_implementation_todo.md` | Short checklist to keep the goal moving. |
| `useful_bd_push_implementation_history.md` | Chronological evidence log for decisions, commands, runs, failures, and commits. |
| `current_results_matrix.md` | Interim cross-method matrix after ten real packages; compares current leads, controls, and next actions. |
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

## Nested Directories

| Directory | Contents |
| --- | --- |
| `tables/` | Small committed setup tables: replay source inventory, scored screening candidates, frozen screening subset, and holdout subset. |
| `techniques/` | One numbered subdirectory per attempted or planned BD/QD technique. The visible `T##_` prefix is chronological. |
| `visualization_audits/` | Cross-method figure bundles when a visualization compares several technique packages rather than one method. |
| `presentations/` | Milestone presentation/report packages and broad experiment summaries. |
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
| `T08` | `T08_sequential_deepseq_bd` | Scaffolded. |
| `T09` | `T09_nettag_text_graph_bd` | Scaffolded. |
| `T10` | `T10_circuitfusion_multimodal_bd` | Scaffolded. |
| `T11` | `T11_mgvga_contrastive_bd` | Completed replay diagnostic, `T1 near_classic_replay_lead`; top-64/weighted structural contrastive descriptors improve HV by +1.82% but still trail lexical direct front hits. |
| `T12` | `T12_lineage_repair_bd` | Scaffolded. |
| `T13` | `T13_aurora_incremental_autoencoder_bd` | Completed replay diagnostic; raw implementation features are `T1 near_classic_replay_lead`, but PCA/RFF/incremental bottlenecks are `T0 diagnostic`. |
| `T14` | `T14_dehnn_hypergraph_bd` | Completed replay diagnostic; hypergraph plus implementation features are `T1 near_classic_replay_lead`, but hypergraph-only descriptors are `T0 diagnostic`. |
| `T15` | `T15_masterrtl_sog_bd` | Completed `T0 structural_proxy_not_promoted` Yosys-SOG proxy audit; zero lowering failures, slightly negative front-cell delta, weaker occupied-cell breadth. |
| `T16` | `T16_deepcell_multiview_bd` | Scaffolded. |
| `T17` | `T17_mome_pareto_archive_bd` | Passive local-Pareto audit, `T0 diagnostic`; strong front-diversity signal but no decisive HV gain. |
| `T18` | `T18_adaptive_emitter_cvt_bd` | Scaffolded. |
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
| `T67` | `T67_rtl_native_seeded_thought_qd` | Pre-registered; RTL-native state/pipeline cells with seeded thought-code realization. |

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
