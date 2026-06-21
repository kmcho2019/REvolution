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
- [ ] Add figures that are readable enough for review.
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
- [ ] `T05_vq_elites_codebook_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T06_qwen_projection_bd` has methodology, results, figures, tables, and tier
      decision.
- [ ] `T07_deepgate_family_bd` has methodology, results, figures, tables, and tier
      decision.
- [ ] `T08_sequential_deepseq_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T09_nettag_text_graph_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T10_circuitfusion_multimodal_bd` has methodology, results, figures, tables,
      and tier decision.
- [ ] `T11_mgvga_contrastive_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T12_lineage_repair_bd` has methodology, results, figures, tables, and tier
      decision.
- [ ] `T13_aurora_incremental_autoencoder_bd` has methodology, results, figures,
      tables, and tier decision.
- [ ] `T14_dehnn_hypergraph_bd` has methodology, results, figures, tables, and tier
      decision.
- [ ] `T15_masterrtl_sog_bd` has methodology, results, figures, tables, and tier
      decision.
- [ ] `T16_deepcell_multiview_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T17_mome_pareto_archive_bd` has methodology, results, figures, tables, and
      tier decision.
- [ ] `T18_adaptive_emitter_cvt_bd` has methodology, results, figures, tables, and
      tier decision.

## Minimum Goal Completion

- [ ] At least one simple control, one synthesis/netlist descriptor, one
      learned/projection descriptor, and one archive-coupling method are run.
- [ ] At least 10 technique packages contain real results.
- [ ] At least one method attempts a multi-objective/Pareto-front archive or
      passive Pareto audit.
- [ ] Every `T1` or higher method preserves every classic-covered design in the
      fixed compared subset.
- [ ] No promoted method has a 50 percent or larger relative decline in
      functionality or synthesis-valid rate versus classic when the classic
      passing denominator is at least 10 for that stage.
- [ ] Any `T1` or `T2` method gets deeper per-problem and per-seed analysis.
- [ ] Central comparison report states whether QD/MAP-Elites is useful,
      near-classic, or still negative.
- [ ] Central and per-technique reports pass
      `visualization_reporting_policy.md`.
- [ ] Conclusions distinguish `T0`, `T1`, `T2`, and `T3`.
- [ ] Every `T0` result adds a follow-up idea, ablation, hybrid, or retirement
      rationale before the next method starts.
- [ ] Stop condition satisfies `anti_reward_hacking_policy.md`.

## Validation

- [ ] Run focused pytest for touched scripts.
- [ ] Run `ruff check` on touched files.
- [ ] Run `python -m pyright` on touched source/report scripts.
- [ ] Run `git diff --check`.
- [ ] Record blocked dependency or live-run smoke results explicitly.
- [ ] For dependency blockers, try `uv add`, isolated uv env, source checkout,
      and submodule decision before stopping a method.
- [ ] Record vLLM endpoint, model id, token budgets, and timeout/preflight
      status for live runs.
- [ ] Run adversarial validation and write
      `useful_bd_push_subagent_validation_report.md`.

## Commit Hygiene

- [ ] Commit scaffold atomically.
- [ ] Commit method implementation/report batches regularly.
- [ ] Inspect every stored commit message immediately after commit.
