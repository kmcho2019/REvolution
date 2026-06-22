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
- [ ] Inspect generated figures with `view_image` or equivalent before marking
      any technique complete.
- [ ] Add tests for any new report/packaging code.
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

## Minimum Goal Completion

- [x] At least one simple control, one synthesis/netlist descriptor, one
      learned/projection descriptor, and one archive-coupling method are run.
- [x] At least 10 technique packages contain real results.
- [x] At least one method attempts a multi-objective/Pareto-front archive or
      passive Pareto audit.
- [ ] Every `T1` or higher method preserves every classic-covered design in the
      fixed compared subset.
- [ ] No promoted method has a 50 percent or larger relative decline in
      functionality or synthesis-valid rate versus classic when the classic
      passing denominator is at least 10 for that stage.
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
- [ ] Conclusions distinguish `T0`, `T1`, `T2`, and `T3`.
- [ ] Every `T0` result adds a follow-up idea, ablation, hybrid, or retirement
      rationale before the next method starts.
- [ ] T36 bounded front lane gets same-budget live validation or a slot-count
      ablation before any final useful-BD claim.
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
