# Useful BD Push TODO

Skim rule: keep active unchecked work near the top and move details to
`useful_bd_push_implementation_history.md`.

Central plan: `useful_bd_push_plan.md`.
Adversarial rubric: `useful_bd_push_adversarial_prompt.md`.

## Setup

- [x] Create dated revamp-history scaffold on
      `feat/journal-useful-bd-exp-20260622`.
- [x] Add literature search, metrics, repeatability, subset, and anti-gaming
      policy docs.
- [x] Add code organization policy for clean experiment implementation.
- [x] Add visualization/reporting policy for figure inspection and conclusions.
- [x] Add local vLLM runtime guide for endpoint preflight and live commands.
- [x] Add Phase 03.1 live-technique visualization contract requiring both the
      full `qd_ppa_viewer/` bundle and the `direct_ppa_pareto/` supplement.
- [x] Add short `best_current_techniques.md` operational ranking and update
      rules.
- [x] Add `research_strategy_recommendations.md` consolidating the classic
      strength, QD framing, budget-shape, design-set, and MasterRTL/RTLTimer
      model-verification feedback.
- [x] Add reference-complete direct-comparison rule and per-run
      `ppa_completeness.csv` schema.
- [x] Elevate MasterRTL/RTLTimer-style RTL-native descriptors as the next
      high-priority BD lane.
- [x] Verify `http://20.0.0.103:8000/v1/models` returns live
      `openai/gpt-oss-120b` metadata.
- [x] Confirm branch, HEAD, dirty state, data mounts, GPU visibility, and
      output roots at goal start.
- [x] Read the 20260618 Auto-BD negative decision and the 20260621 compiled
      diversity conclusion before implementing methods.
- [x] Verify the copied ASP-DAC release source and any available
      `aspdac2026-paper` ref.
- [x] Create `exp/useful_bd_push/` output convention and central run ledger.
- [x] Re-preflight the selected vLLM endpoint and record `/v1/models` metadata
      before each live sampling batch.
- [x] Create `exp/useful_bd_push/envs/` and `exp/useful_bd_push/sources/`
      conventions for isolated dependencies and external method repos.

## Common Evaluation Surface

- [x] Create `presentations/20260623_report/` as the current priority
      milestone package for the two diversity questions and broad RTLLM
      classic-vs-T26-family comparison.
- [x] Freeze the RTLLM 50-problem manifest from `bench/RTLLM/*_prompt.txt`
      inside the milestone package.
- [x] Add pre-registered command templates for T26-family screening and the
      full RTLLM run.
- [x] Run and record initial sub-agent adversarial review for the milestone
      plan.
- [x] Run screening ladder for exact T26 and low-fusion T26.1; add gated
      T26.1 only after narrow implementation and focused tests.
- [x] Select the full RTLLM QD arm before seeing full RTLLM results.
- [x] Run full RTLLM classic versus selected QD arm with recorded vLLM
      preflight and 128k token budgets.
- [x] Treat the one-seed RTLLM run as the deadline package input; do not block
      plots, tables, report, or slides on multi-seed replication.
- [x] Package RTLLM-wide tables, figures, raw PPA data, and direct PPA plots
      for the one-seed milestone.
- [x] Add supplemental formal final-analysis bundle for the RTLLM
      reference-complete subset, with backend comparison, Pareto, PPA
      distribution, design-space, and feature-space sections.
- [x] Add Phase 03.1 viewer artifacts for the full RTLLM QD archive when the
      archive projection/export contract is ready.
- [x] Complete `presentations/20260623_report/report.md` and `slides.md` with
      precise answers to the two main questions.
- [x] Run sub-agent and `claude -p` adversarial reviews when available, and
      record outputs under `presentations/20260623_report/reviews/`.
- [x] Pass final presentation/report adversarial validation for diagnostic
      package status; do not treat it as positive `useful_qd` sign-off.
- [x] Map the one-seed RTLLM package to the accepted `journal_narrative.md`
      contract and mark it not final-gate eligible.
- [ ] Define shared classic/manual/random/simple-control baselines.
- [ ] Define central method result schema.
- [ ] Add or reuse validity funnel, PPA/HV, duplicate, archive, and runtime
      reporting.
- [ ] Add passive archive scoring for classic and every QD method.
- [ ] Add global PPA hypervolume, Pareto-cell count, Pareto spread, unique
      front family, QD-score AUC, coverage AUC, and HV AUC metrics.
- [x] Add a retrospective budget-depth maturation audit before live
      budget-shape spending (`T78_budget_depth_maturation_audit`).
- [x] Pre-register and run a fixed-total-budget shape ablation, comparing
      classic and exact T75 under `12 x 3`, `8 x 5`, and `6 x 7`
      (`T79_budget_shape_ablation_protocol`).
- [x] Finish the six T79 matched live arms before using budget shape as a
      classic-vs-QD explanatory claim. Outcome: diagnostic-negative; exact T75
      loses matched classic mean HV at all three tested shapes.
- [x] Create `preliminary_planning/20260625_encoder_config_screening/` to rank
      pretrained encoder, encoder-like, RTL-native, and custom-BD candidates
      before the next full RTLLM spend.
- [x] Run descriptor probes, vLLM preflight, matrix validation, and a tiny
      live `1x0` smoke for the spend-ready screening arms.
- [x] Run the registered eight-design `8x5` screen for
      `classic_revolution_8x5`, `code_thought_sr_front_slot_8x5`, and
      `masterrtl_structural_mix_8x5`. Outcome: classic remains the headline
      Pareto/HV winner; do not promote either QD arm to full RTLLM yet.
- [x] Add pretrained-encoder bridge validation after the first screen. Outcome:
      Qwen3 loads and is the next live-hook candidate; DeepGate and MasterRTL
      pretrained generated-candidate bridges remain blocked.
- [x] Probe Qwen3 canonical RTL on the completed live-screen candidate corpus.
      Outcome: generated-candidate embeddings are nonconstant, but nearest
      neighbors are strongly same-problem, so a live Qwen arm needs explicit
      collapse diagnostics.
- [x] Add a live runtime Qwen3 embedding bridge only after defining
      preprocessing, cache keys, and descriptor-collapse diagnostics.
- [x] Run the matched `qd_qwen3_canonical_rtl_8x5` screen with the same
      reference-complete subset and explicit same-problem/duplicate-collapse
      diagnostics before full RTLLM promotion. Outcome: coverage preserved,
      but aggregate HV/front breadth lost to classic; do not promote as-is.
- [x] Freeze a reference-complete, medium-validity budget-ablation subset with
      visible PPA-front variance before reading any budget-shape outcome.
- [x] Add direct PPA-front visualization audit for completed T24/T25/T26 live
      methods.
- [x] Add a raw area-power Pareto-front mode to the Phase 03.1 HTML viewer and
      regenerate the T28 scoped viewer package.
- [x] Maintain `technique_lanes.md` as the lane-level decision ledger and
      lineage map for method families.
- [x] Add `technique_lineage_ledger.md` as a skim-first lane/category,
      lineage, result, and branch tracking guide.
- [ ] Add readable figures for every completed result package and cross-method
      audit, including a standalone raw area-power PPA Pareto-front PNG before
      any BD-space, normalized, or HTML-only visualization is accepted.
- [x] Inspect generated figures with `view_image` or equivalent before marking
      any technique complete.
- [x] Add tests for any new report/packaging code.
- [ ] Keep new implementation code in shared descriptor/evaluator/reporting
      surfaces with method-specific extractors only.
- [ ] Add or update docstrings, comments, and docs for new code paths.

## Screening Subset

- [x] Generate subset selection table from replay data.
- [x] Freeze 8-12 screening problems before method outcomes are reviewed.
- [x] Freeze a holdout subset for any `T1` or `T2` candidate.
- [x] Record any replacement by the pre-registered rule.

## Technique Packages

- [x] `T01_simple_yosys_stat_bd` has methodology, results, figures, tables, and
      tier decision.
- [x] `T02_motif_pathlet_bd` has methodology, results, figures, tables, and tier
      decision.
- [x] `T03_synthesis_delta_stnod_bd` has methodology, results, figures, tables,
      and tier decision.
- [x] `T04_autoqd_mmd_synthesis_bd` has methodology, results, figures, tables,
      and tier decision.
- [x] `T05_vq_elites_codebook_bd` has methodology, results, figures, tables, and
      tier decision.
- [x] `T06_qwen_projection_bd` has methodology, results, figures, tables, and tier
      decision.
- [x] `T07_deepgate_family_bd` has methodology, results, figures, tables, and tier
      decision.
- [ ] `T08_sequential_deepseq_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T09_nettag_text_graph_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T10_circuitfusion_multimodal_bd` has methodology, results, figures, tables,
      and tier decision.
- [x] `T11_mgvga_contrastive_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T12_lineage_repair_bd` has methodology, results, figures, tables, and tier
      decision.
- [x] `T13_aurora_incremental_autoencoder_bd` has methodology, results, figures,
      tables, and tier decision.
- [x] `T14_dehnn_hypergraph_bd` has methodology, results, figures, tables, and tier
      decision.
- [x] `T15_masterrtl_sog_bd` has methodology, results, figures, tables, and tier
      decision for the Yosys-SOG structural proxy audit.
- [x] `T60_rtl_timer_timing_risk_bd` has methodology, results, figures, tables,
      and tier decision for the first diagnostic proxy audit.
- [x] `T61_rtl_timer_problem_local_bd` has methodology, results, figures,
      tables, and tier decision for the problem-local timing-risk proxy audit.
- [x] `T62_fused_rtl_native_bd` has methodology, results, figures, tables,
      completeness data, and tier decision for the fused RTL-native proxy
      audit.
- [x] `T63_fused_rtl_native_live_screen` is pre-registered with live
      fused RTL-native descriptor profiles, frozen hard/tuning subset, and
      reference-complete comparison requirements.
- [x] `T63_fused_rtl_native_live_screen` seed-1001 run is executed, validated,
      packaged, visually inspected, and assigned a tier decision.
- [x] `T64_fused_operator_timing_live_screen` is pre-registered as the narrow
      `fused_rtl_operator_timing_2d` ablation after T63.
- [x] `T64_fused_operator_timing_live_screen` seed-1001 run is executed,
      validated, packaged, visually inspected, and assigned a tier decision.
- [x] `T65_rtl_native_secondary_cells` is executed and packaged as a posthoc
      RTLTimer-style secondary-cell audit over T51/T63/T64.
- [x] `T66_rtl_native_front_guarded_parent_qd` is pre-registered as a coupled
      RTL-native parent-selection/fusion method after T65 retired pure
      secondary-cell overlays.
- [x] `T66_rtl_native_front_guarded_parent_qd` seed-1001 run is executed,
      validated, packaged, visually inspected, and assigned a tier decision.
- [x] `T67_rtl_native_seeded_thought_qd` is pre-registered as the next
      RTL-native source-preserving coupling method after T66 showed that
      parent pressure and gated fusion were not enough.
- [x] `T67_rtl_native_seeded_thought_qd` seed-1001 run is executed,
      validated, packaged, visually inspected, and assigned a tier decision.
- [x] `T68_source_verified_rtl_native_extractors` is executed and packaged as
      the upstream MasterRTL/RTL-Timer source-verification gate.
- [x] `T69_open_yosys_rtl_native_preprocessing` is executed and packaged as
      the open-Yosys TinyRocket preprocessing unblocker for MasterRTL and
      RTL-Timer source alignment.
- [x] Run a generated-RTL candidate extractor smoke using the T69 preprocessing
      path before spending another live RTL-native QD budget.
- [x] Build a source-aligned RTL-native feature table and archive-cell map
      from MasterRTL/RTL-Timer extractor outputs before the next live
      RTL-native QD spend.
- [x] Pre-register the next live source-aligned RTL-native QD variant using
      the T71 cells before spending live model budget.
- [x] Implement and probe the exact
      `source_aligned_masterrtl_rtltimer_cell_2d` runtime descriptor hook
      before launching T72.
- [x] Launch the bounded T72 hard/tuning live screen only after vLLM preflight,
      then package PPA completeness, direct PPA fronts, Phase 03.1 viewer, and
      tier decision.
- [x] Add a MasterRTL pretrained verification package before any live
      pretrained-model BD claim: model hashes, direct upstream Power smoke,
      internal loader checks, feature-schema assertions, and explicit remaining
      candidate-output variation blocker.
- [x] Run a generated-candidate MasterRTL tree-leaf or margin variation gate
      before any live pretrained-model BD spend.
- [x] Add a raw MasterRTL structural-mix descriptor gate after the direct
      pretrained Area-head leaf path collapsed (`T80_masterrtl_structural_mix_gate`).
- [ ] If continuing pretrained MasterRTL/RTLTimer, reproduce the timing/power
      feature flows or retrain a model; do not use direct Area-head leaves.
- [ ] `T16_deepcell_multiview_bd` has methodology, results, figures, tables, and
      tier decision.
- [x] `T17_mome_pareto_archive_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T18_adaptive_emitter_cvt_bd` has methodology, results, figures, tables, and
      tier decision.
- [x] `T19_sr_relu_pca_bd` has methodology, results, figures, tables, and tier
      decision.
- [x] `T20_sr_raw_pca_bd` has methodology, results, figures, tables, and tier
      decision.
- [x] `T21_stnod_motif_hybrid_bd` has methodology, results, figures, tables, and
      tier decision.
- [x] `T22_random_descriptor_control` has methodology, results, figures, tables,
      and tier decision.
- [x] `T23_sr_pareto_validation_matrix` has methodology, results, figures,
      tables, and tier decision.
- [x] `T24_sr_pareto_live_validation` full live matrix is executed and
      packaged; result is `T0 diagnostic`.
- [x] `T25_guarded_sr_raw_pareto_qd` guarded live variant is executed and
      packaged.
- [x] `T26_sr_raw_conservative_exploit_qd` parent-source variant is executed
      and packaged.
- [x] `T27_t26_live_qd_audit` is packaged with live HV/HV-AUC, front-spread,
      active archive, visual inspection, and lane-decision documentation.
- [x] `T28_t26_family_audit` is packaged with RTL/netlist/family duplicate
      accounting, direct PPA-front figures, scoped HTML viewer, visual
      inspection, and lane-decision documentation.
- [x] `T29_sr_raw_front_recovery_qd` is pre-registered, executed, packaged, and
      assigned a tier decision.
- [x] `T30_t26_holdout_front_audit` is pre-registered, executed, packaged, and
      assigned a tier decision.
- [x] `T31_sr_raw_fail_feedback_repair_qd` is pre-registered, executed,
      packaged, and assigned a tier decision.
- [x] `T32_sr_raw_front_preserving_emitter_qd` is executed, packaged with
      direct raw PPA Pareto figures and regeneration tables, and assigned a
      tier decision.
- [x] `T33_qwen3_preprocessing_ladder_bd` has source inventory,
      preprocessing/embedding caches, collapse diagnostics, replay scoring,
      direct PPA-front figures, visual inspection notes, and a tier decision.
- [x] `T34_qwen_pca_residual_bd` has replay, direct PPA-front figures,
      collapse diagnostics, visual inspection notes, and tier decision.
- [x] `T35_t11_pareto_coupling_bd` has replay, direct PPA-front figures,
      HTML viewer, visual inspection notes, and a mixed diagnostic tier
      decision.
- [x] `T36_t11_bounded_front_lane_bd` has replay, direct PPA-front figures,
      HTML viewer, visual inspection notes, and a `T2 replay_candidate` tier
      decision.
- [x] `T37_t36_slot_count_ablation` has replay, direct PPA-front figures,
      HTML viewer, visual inspection notes, and a `T2 replay_candidate` tier
      decision for the one-slot arm.
- [x] `T38_elite_pareto_slot_live_qd` is pre-registered with the live
      champion-plus-one-local-Pareto-slot archive rule and exact command card.
- [x] `T38_elite_pareto_slot_live_qd` bounded arm is executed, validated,
      packaged with direct raw PPA Pareto figures, and assigned `T0
      diagnostic`.
- [x] T39 sparse-yield warmup/fallback variant is specified before broad T38
      controls, because T38 multi-pipe has valid/front PPA but no active
      archive members.
- [x] `T39_sparse_yield_warmup_qd` bounded arm is executed, validated,
      packaged with direct raw PPA Pareto figures, and assigned a tier
      decision.
- [x] `T40_sparse_warmup_control_matrix` is pre-registered with matched
      classic/manual/random/full-Pareto controls and a mandatory conventional
      lower-left-better raw area-power PPA-front visual gate.
- [x] `T40_sparse_warmup_control_matrix` controls are executed, validated,
      packaged, visually inspected, and assigned a tier decision.
- [x] `T41_adaptive_sparse_yield_gate_qd` is pre-registered with an adaptive
      sparse-yield warmup fallback and mandatory direct raw PPA-front
      packaging.
- [x] `T41_adaptive_sparse_yield_gate_qd` is executed, validated, packaged,
      visually inspected, and assigned a tier decision.
- [x] `T42_initial_sparse_yield_gate_qd` is pre-registered with a generation-0
      sparse-yield fallback and mandatory direct raw PPA-front packaging.
- [x] `T42_initial_sparse_yield_gate_qd` is executed, validated, packaged,
      visually inspected, and assigned a tier decision.
- [x] `T43_staged_sparse_yield_gate_qd` is pre-registered with staged champion
      pressure after adaptive sparse archive initialization.
- [x] `T43_staged_sparse_yield_gate_qd` is executed, validated, packaged,
      visually inspected, and assigned a tier decision.
- [x] `T44_t11_runtime_graph_bridge` is pre-registered and smoke-tested with
      the live `t11_runtime_top8_graph` descriptor profile.
- [x] `T44_t11_runtime_graph_bridge` full three-problem live screen is
      executed, validated, packaged with Phase 03.1 `qd_ppa_viewer/` and
      `direct_ppa_pareto/`, visually inspected, and assigned a tier decision.
- [x] `T45_t11_runtime_top4_graph` is pre-registered with a compact
      `t11_runtime_top4_graph` descriptor profile and the same T44 live
      settings, direct-PPA supplement, and full Phase 03.1 viewer gate.
- [x] `T45_t11_runtime_top4_graph` full three-problem live screen is
      executed, validated, packaged with Phase 03.1 `qd_ppa_viewer/` and
      `direct_ppa_pareto/`, visually inspected, and assigned a tier decision.
- [x] `T46_t11_runtime_pca4_graph` is pre-registered with frozen non-PPA PCA
      axes over T44's top-8 graph features, the same T45 live settings, and
      mandatory direct-PPA plus Phase 03.1 viewer gates.
- [x] `T46_t11_runtime_pca4_graph` full three-problem live screen is executed,
      validated, packaged with Phase 03.1 `qd_ppa_viewer/` and
      `direct_ppa_pareto/`, visually inspected, and assigned a tier decision.
- [x] `T47_t26_contract_probe` is pre-registered as the contract-aligned
      T26-family follow-up gate after the one-seed RTLLM package was narrowed
      to diagnostic.
- [x] `T47_t26_contract_probe` is executed, packaged with direct raw PPA
      figures and contract-aligned metrics, visually inspected, and assigned a
      tier decision.
- [x] `T48_t26_gated_near_front_fusion_qd` is pre-registered as the next
      T26.1 follow-up after T47 showed positive best-score movement but
      negative HV, HV-AUC, valid-PPA, and aggregate front-count deltas.
- [x] `T48_t26_gated_near_front_fusion_qd` narrow parent gate implementation
      is added with focused QD engine and backend plumbing tests.
- [x] `T48_t26_gated_near_front_fusion_qd` is run on the T47 hard/tuning
      comparator surface, packaged, visually inspected, and assigned a tier
      decision.
- [x] `T49_thought_k_role_separated_repair_qd` is pre-registered as the next
      same-family role-separated thought-k and bounded-repair follow-up after
      T48 failed the hard/tuning primary metrics.
- [x] `T49_thought_k_role_separated_repair_qd` seed `1001` is run on the T47
      hard/tuning comparator surface, packaged, visually inspected, and
      assigned a tier decision before seed `1002` is considered.
- [x] `T50_candidate_matched_thought_front_qd` is pre-registered as the
      candidate-matched front-retention follow-up after T49 preserved coverage
      but lost mean HV and PPA-front material.
- [x] `T50_candidate_matched_thought_front_qd` seed `1001` is run on the T47
      hard/tuning comparator surface, packaged, visually inspected, and
      assigned a tier decision before seed `1002` or held-out spend. The
      package is partial because `Prob153_gshare` did not finish.
- [x] `T51_code_thought_front_slot_qd` is pre-registered as the next
      front/yield-preserving emitter after T50, using only existing runtime
      controls.
- [x] `T51_code_thought_front_slot_qd` seed `1001` is run on the T47
      hard/tuning comparator surface, packaged, visually inspected, and
      assigned a tier decision before seed `1002` or held-out spend.
- [x] The next T51 follow-up is specified with an explicit front-preserving
      mechanism before any seed `1002` or held-out spend.
- [x] `T52_code_thought_full_pareto_qd` seed `1001` is run on the T47/T51
      hard/tuning comparator surface, packaged, visually inspected, and
      assigned a tier decision before seed `1002` or held-out spend.

## Minimum Goal Completion

- [x] At least one simple control, one synthesis/netlist descriptor, one
      learned/projection descriptor, and one archive-coupling method are run.
- [x] At least 10 technique packages contain real results.
- [x] At least one method attempts a multi-objective/Pareto-front archive or
      passive Pareto audit.
- [ ] Every `T1` or higher method preserves every classic-covered design in the
      fixed compared subset.
- [ ] Any promoted method with a 50 percent or larger relative decline in
      functionality or synthesis-valid rate versus classic is labeled with a
      yield warning when the classic passing denominator is at least 10.
- [ ] Any `T1` or `T2` method gets deeper per-problem and per-seed analysis.
- [x] T26/T27 gets canonical duplicate/family validation before any `T2`
      useful-QD claim.
- [x] T26/T28 gets holdout or front-recovery validation before any `T2`
      useful-QD claim.
- [x] T31 repair/yield/front-preserving emitter is specified from T30's P098
      yield warning and front-breadth deficit before another live run.
- [x] T31 direct failure-feedback emitter is executed and retired as `T0`
      diagnostic before the next emitter/archive variant is specified.
- [x] T32 front-preserving emitter is specified from T31's failed repair result
      with `0.72` champion pressure, `0.08` two-parent success-parent sampling,
      and a mandatory raw area-power PPA Pareto figure gate.
- [ ] Central comparison report states whether QD/MAP-Elites is useful,
      near-classic, or still negative.
- [ ] Central and per-technique reports pass
      `visualization_reporting_policy.md`, including the direct raw PPA-front
      figure gate.
- [x] Visualization policy distinguishes the full Phase 03.1
      `qd_ppa_viewer/` from the simpler `direct_ppa_pareto/` supplement and
      makes both mandatory for live QD archive methods.
- [x] T43 has a full Phase 03.1 `qd_ppa_viewer/` bundle with strict
      validation, Playwright screenshot, and honest classic projection.
- [x] T44 has a full Phase 03.1 `qd_ppa_viewer/` bundle with strict
      validation, Playwright screenshot, honest classic projection, and a
      direct raw-PPA supplement.
- [x] Fix Phase 03.1 archive hover/rendering for high-dimensional occupied
      archive cells before accepting T44's full viewer.
- [x] T45 has a full Phase 03.1 `qd_ppa_viewer/` bundle with strict
      validation, Playwright screenshot, honest classic projection, and a
      direct raw-PPA supplement.
- [x] T46 has a full Phase 03.1 `qd_ppa_viewer/` bundle with strict
      validation, Playwright screenshot, honest classic projection, and a
      direct raw-PPA supplement.
- [x] T48 has a full Phase 03.1 `qd_ppa_viewer/` bundle with a documented
      non-strict classic-projection caveat and a direct raw-PPA supplement.
- [ ] Conclusions distinguish `T0`, `T1`, `T2`, and `T3`.
- [ ] Every `T0` result adds a follow-up idea, ablation, hybrid, or retirement
      rationale before the next method starts.
- [x] T36 bounded front lane gets a slot-count ablation before any final
      useful-BD claim.
- [x] T37 one-slot bounded front lane gets T38 same-budget live validation.
- [x] T38 warmup/archive gap is ablated before any final useful-BD claim.
- [x] T39 sparse-warmup result gets same-budget classic/manual/random/full-
      Pareto controls before any `T1` or `T2` useful-QD claim.
- [x] T42 initial sparse-yield gate gets a follow-up direction: per-design or
      staged sparse-yield activation instead of another global trigger shift.
- [x] T43 staged sparse-yield gate gets a follow-up direction: stop blind
      champion-lane tuning unless a run actually enters sparse fallback; next
      try a bounded sparse-trigger screen or exact T11 runtime projection.
- [x] T44 starts the exact-T11 follow-up by wiring T11-style graph features
      into the live descriptor registry without claiming the full T11 replay
      projection.
- [x] T44 gets a follow-up direction: compress or select fewer T11 runtime
      graph axes, such as a top-3/top-4 profile or frozen non-PPA projection,
      before trying top-16/top-64 fitted projection.
- [x] T48 gets a follow-up direction: stop direct T26.1 two-parent fusion
      escalation and specify a role-separated champion, local-rank-1, and
      bounded-repair emitter before spending held-out budget.
- [x] T51 gets a follow-up direction: keep direct code individuals and
      `single_thought_operator`, but widen the archive from one local front
      slot to full per-cell Pareto retention in T52.
- [x] T52 gets a follow-up direction: retire simple full-Pareto widening and
      keep T51's one-slot/yield behavior unless a bounded front-pressure
      trigger is specified without in-loop classic or final-front labels.
- [x] T53 bounded sparse-front trigger is specified as the next T51/T52
      follow-up before any new live run.
- [x] T53 bounded sparse-front trigger is executed, validated, packaged, and
      compared against T47 classic, T51, and T52.
- [x] T53 gets a follow-up direction: stop scalar champion-lane nudging and
      specify a role-separated front-family emitter if this lane continues.
- [x] T54 front-slot lane is pre-registered as the role-separated follow-up
      that keeps T51's one-slot archive and champion lane while sampling
      non-elite local-front slot members with a fixed 10 percent parent lane.
- [x] T54 front-slot lane seed `1001` is run on the T47/T51/T52/T53
      hard/tuning 13-problem surface after vLLM preflight.
- [x] T54 front-slot lane is validated, packaged, visualized, and compared
      against T47 classic, T51, T52, and T53.
- [x] T54 gets a follow-up direction or retirement rationale before any next
      emitter/archive variant starts.
- [x] T55 coarse SR2 front-slot geometry is pre-registered as a mechanism
      change after T54's sparse front-slot pool.
- [x] T55 coarse SR2 front-slot seed `1001` is run on the T47/T51/T52/T53/T54
      hard/tuning 13-problem surface after vLLM preflight.
- [x] T55 coarse SR2 front-slot is validated, packaged, visualized, and
      compared against T47 classic and T51 through T54.
- [x] T55 gets a follow-up direction or retirement rationale before any next
      descriptor/archive geometry variant starts.
- [x] T56 coarse SR2 T51-control is pre-registered as the geometry isolation
      ablation after T55.
- [x] T56 coarse SR2 T51-control seed `1001` is run on the T47/T51/T55
      hard/tuning 13-problem surface after vLLM preflight.
- [x] T56 coarse SR2 T51-control is validated, packaged, visualized, and
      compared against T47 classic, T51, and T55.
- [x] T56 gets a follow-up direction or retirement rationale before any next
      descriptor/archive geometry variant starts.
- [x] T57 T51 adaptive-rebin QD is pre-registered as the next archive-
      mechanics ablation after T56 retired coarse SR2 geometry.
- [x] T57 T51 adaptive-rebin seed `1001` is run on the T47/T51/T56
      hard/tuning 13-problem surface after vLLM preflight.
- [x] T57 T51 adaptive-rebin is validated, packaged, visualized, and compared
      against T47 classic, T51, and T56.
- [x] T57 gets a retirement rationale before any exact seed `1002` spend.
- [x] T58 T51 T11-PCA4 front-slot QD is pre-registered as the cross-lane
      follow-up after T57 retired archive-boundary tweaks.
- [x] T58 descriptor probe resolves `t11_runtime_pca_0..3` with
      `requires_ppa=false` before live spend.
- [x] T58 seed `1001` is run on the T47/T51/T46/T57 hard/tuning surface after
      vLLM preflight.
- [x] T58 is validated, packaged, visualized, and compared against T47
      classic, T51, T46, and T57.
- [x] T58 gets a promotion, ablation, or retirement rationale before any exact
      seed `1002` spend.
- [x] T59 T51 feedback front-slot QD is pre-registered as the front-yield
      protected emitter follow-up after T58 retired primary graph coordinates.
- [x] T59 seed `1001` is run on the T47/T51/T54/T58 hard/tuning surface after
      vLLM preflight.
- [x] T59 is validated, packaged, visualized, and compared against T47
      classic, T51, T54, and T58.
- [x] T59 gets a promotion, ablation, or retirement rationale before any exact
      seed `1002` spend.
- [x] T73 source-aligned shape-density QD is pre-registered as the
      less-collapsed successor to T72.
- [x] T73 descriptor probe resolves `source_aligned_shape_density_3d` with
      `requires_ppa=false` and `requires_source_aligned_rtl=true`.
- [x] T73 collapse audit replays T72 archive events and records why
      `grid_quantile` is required instead of fixed density bounds.
- [x] T73 seed `1001` is run on the T72 hard/tuning surface after storage and
      vLLM preflight.
- [x] T73 is visualized and compared against T47 classic with a
      reference-complete matched package, direct PPA panels, and a Phase 03.1
      viewer. T51/T66/T67/T72 remain cross-method context, not bundled
      comparison backends in this compact package.
- [x] T73 gets a promotion, ablation, or retirement rationale before another
      source-aligned live spend: exact T73 is `T0 positive_diagnostic`, and
      T74 should hybridize T73 yield/occupancy with stronger front-slot
      pressure.
- [x] T74 shape-density front-slot hybrid is pre-registered as the next
      source-aligned RTL-native spend, reusing T73 cells with
      `near_front_descriptor` gating for the existing low-rate single-thought
      two-parent prompt requests.
- [x] T74 seed `1001` is run on the T72/T73 hard/tuning surface only after
      storage and vLLM preflight.
- [x] T74 is validated, packaged, visualized, and compared against T47
      classic, T51, T66, T67, T72, and T73 with a reference-complete matched
      package.
- [x] T74 gets a promotion, ablation, or retirement rationale before another
      same-family source-aligned live spend.
- [x] T75 shape-density front-pressure QD is pre-registered as the next
      source-aligned RTL-native follow-up, using the new configurable
      `qd_front_slot_lane_fraction=0.30` knob and one-parent-only prompts.
- [x] T75 seed `1001` is run on the T72/T73/T74 hard/tuning surface only after
      storage and vLLM preflight.
- [x] T75 is validated, packaged, visualized, and compared against T47
      classic, T73, and T74 with a reference-complete matched package.
- [x] T75 gets a promotion, ablation, or retirement rationale before another
      same-family source-aligned live spend.
- [ ] Stop condition satisfies `anti_reward_hacking_policy.md`.

## Validation

- [x] Run focused pytest for touched scripts.
- [x] Run `ruff check` on touched files.
- [x] Run `python -m pyright` on touched source/report scripts.
- [x] Run `git diff --check`.
- [ ] Record blocked dependency or live-run smoke results explicitly.
- [ ] For dependency blockers, try `uv add`, isolated uv env, source checkout,
      and submodule decision before stopping a method.
- [x] Record vLLM endpoint, model id, token budgets, and timeout/preflight
      status for live runs.
- [ ] Run adversarial validation and write
      `useful_bd_push_subagent_validation_report.md`.

## Commit Hygiene

- [ ] Commit scaffold atomically.
- [ ] Commit method implementation/report batches regularly.
- [ ] Inspect every stored commit message immediately after commit.
