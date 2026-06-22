# Useful BD Push TODO

Line limit: 160 lines. Keep this checklist concise. Move details to
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
- [ ] Add Phase 03.1 viewer artifacts for the full RTLLM QD archive when the
      archive projection/export contract is ready.
- [x] Complete `presentations/20260623_report/report.md` and `slides.md` with
      precise answers to the two main questions.
- [x] Run sub-agent and `claude -p` adversarial reviews when available, and
      record outputs under `presentations/20260623_report/reviews/`.
- [x] Pass final presentation/report adversarial validation before sign-off.
- [ ] Define shared classic/manual/random/simple-control baselines.
- [ ] Define central method result schema.
- [ ] Add or reuse validity funnel, PPA/HV, duplicate, archive, and runtime
      reporting.
- [ ] Add passive archive scoring for classic and every QD method.
- [ ] Add global PPA hypervolume, Pareto-cell count, Pareto spread, unique
      front family, QD-score AUC, coverage AUC, and HV AUC metrics.
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
- [ ] `T15_masterrtl_sog_bd` has methodology, results, figures, tables, and tier
      decision.
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
- [ ] `T45_t11_runtime_top4_graph` full three-problem live screen is
      executed, validated, packaged with Phase 03.1 `qd_ppa_viewer/` and
      `direct_ppa_pareto/`, visually inspected, and assigned a tier decision.

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
- [ ] T45 has a full Phase 03.1 `qd_ppa_viewer/` bundle with strict
      validation, Playwright screenshot, honest classic projection, and a
      direct raw-PPA supplement.
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
