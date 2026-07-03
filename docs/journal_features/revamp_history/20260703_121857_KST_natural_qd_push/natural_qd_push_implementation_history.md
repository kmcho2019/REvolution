# Natural QD Push Implementation History

Unbounded journal for `natural_qd_push`. Record notable decisions,
commands, outputs, experiments, failed attempts, blockers, commits, and
validation evidence. Entry format: `## <ISO-8601 UTC or KST stamp> -
<Title>`; new lane work lands as a Pre-Registration entry then a Result
entry.

## 2026-07-03 12:19 KST - Scaffold Start

- Branch `feat/journal-qd-bd-exp-20260703` created from `f786d9306b`
  (tip of `feat/journal-useful-bd-exp-20260622`). Worktree clean except
  pre-existing untracked `.devcontainer/devcontainer-lock.json` (left
  alone).
- Scaffold generated with the goal-scaffold helper
  (`scaffold_goal_docs.py --slug natural_qd_push`) and moved to
  `docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/`.
- vLLM preflight 2026-07-03 (KST): `curl http://20.0.0.103:8000/v1/models`
  returned `openai/gpt-oss-120b`, `max_model_len=131072`, `owned_by=vllm`
  (`created=1783048634`). Meets the 128000-token research floor.

## 2026-07-03 12:20 KST - Founding Analysis (sources and load-bearing numbers)

Four read-only reviews of the June-22 push, the frozen narrative, the
reviews bundles, and the codebase were run before writing the plan.
Load-bearing findings, with sources (paths relative to
`../20260622_010615_KST_useful_bd_push/` unless absolute):

- Operator contamination: QD arms from T31 onward ran
  `single_thought_operator` while classic ran `eoh_strategies`
  (`RTLLM_full_suite/20260630/README.md`, `method_configs.md`; ~60 STO vs
  25 EOH occurrences across `techniques/*/commands/*.md`). Corrected
  reruns (same seed, EoH restored): DeepGate delayed 57.5% -> 93.5% of
  classic HV, MasterRTL activation 62.3% -> 91.6%, Qwen PCA3 43.1% ->
  89.5% (`RTLLM_full_suite/20260630/report.md`). Operator-fair prior
  lanes: T24-T30, T32, T38-T48. Audit tool:
  `RTLLM_full_suite/20260630/tools/audit_operator_contract.py`.
- Corrected suite unfinished: `masterrtl_rf_leafid_structural_eoh_8x5`,
  `rf_deepgate_hybrid_eoh_8x5`, `aurora_raw_impl_compact_eoh_8x5` are
  `not_started` in `RTLLM_full_suite/20260630/tables/
  full_suite_method_summary.csv`.
- PCN-v3 post-mortem: single-seed full-RTLLM 0.1031 vs classic 0.0997
  (103.4%) did not replicate at 5 seeds (clean_pcn_vs_classic -0.0021,
  p=0.19; pcn_no_cf vs classic_no_cf -0.0065); the apparent gain was
  partly from disabling C-F; memory-refine events 332/4266 with no
  method-level HV advantage (`qd_evaluaton_exp/20260701_1155_PCN_v3_
  experiments/reports/rtllm_full_5seed_detailed_report.md`, `tables/
  rtllm_full_5seed_*.csv`). `classic_no_cf` was the best 5-seed arm
  overall (0.10685 HV / 0.09459 HV-AUC, not significant, 41/41/148).
- Classic baselines (operator-fair, reusable): 8-design 8x5 screen seed
  1001 mean HV 0.1406, 3-seed 0.1442 (`best_current_techniques.md`,
  `central_comparison_report.md`); matched classic 6x7 0.1701 (T79);
  full RTLLM 46 ref-complete seed-1001 0.0997 HV / 0.0899 HV-AUC
  (20260630) and 5-seed 0.10380 / 0.08680, coverage 32.8/46 (20260701
  tables). Missing-reference designs excluded everywhere: Prob006,
  Prob013, Prob018, Prob040.
- Platform: Smooth-QD V2 (code_individual + full EoH suite + champion
  refinement + NSGA-II rank selection over grid-quantile BD-trio archive)
  is at 5-seed statistical parity with classic (quality -0.016, CI
  [-0.045,+0.007]; F23 in `docs/journal_features/13_findings_dashboard.md`;
  design in `docs/journal_features/16_smooth_qd_integration_track.md`).
- Frozen contract: `docs/journal_features/journal_narrative.md` rev 3
  ACCEPTED — per-cell bounded Pareto fronts thesis, +5% HV log-ratio gate
  with cluster CI low > 0, penalized statistics, seeds 1001-1005,
  descriptor-input exclusions, Branch A/B/C rules, Branch-B utility
  metric >= 0.25.
- Un-killed natural leads feeding the lane portfolio: T36/T37 bounded
  front slot (+4.04% replay HV, `T2_replay_candidate`, never run live
  operator-fair); F5 Pareto-vs-scalar cells +0.013 (inconclusive);
  idea-backlog "Smooth-QD-v2 Pareto-biased parent sampling" (untried);
  T39 warmup positive ablation (operator-fair); T78 late-maturing
  archives (9/13 fill at gen >= 2) with T79's negative bound to the
  contaminated T75 arm.
- Codebase seams: existing knobs cover N01/N03/N05 (`qd_cell_mode`
  {scalar_elite, pareto_front, elite_pareto_slot} in
  `src/revolution/qd/archive.py`; lane fraction; warmup); `auto_bd/` is
  the self-contained subpackage precedent; PCN modes live inline in
  `src/revolution/qd/engine.py` and stay untouched; HV-AUC has no
  canonical shared implementation yet (only push-local computations —
  drift was flagged in `reviews/claude_periodic_review_20260626_t96.md`).

## 2026-07-03 12:25 KST - Founding Decisions

- D1: Platform = Smooth-QD V2 exact config; every lane is a single-factor
  delta vs V2; parity -> win is the mission framing.
- D2: Screening reuses the June-22 frozen 8-design 8x5 surface and its
  classic baselines (classic arms were operator-fair); manifests and run
  roots pinned in `tables/` before any live run.
- D3: Lane IDs are `N##` under `lanes/` here; June-22 T-series is closed.
- D4: Operator-contract audit is a per-comparison hard gate; auditor gets
  promoted into `scripts/` with tests during P0.
- D5: HV-AUC becomes a canonical shared metric in P0, regression-tested
  against the stored 20260630 tables.
- D6: Natural-Extension Criterion (plan) is binding lane admissibility;
  PCN-style triggers/credit stacks are out of scope for this push.
