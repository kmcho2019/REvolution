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

## 2026-07-03 12:50 KST - P0 Pinning Completed (goal activated)

- Goal activated via `/goal` with the scaffold's goal template.
- Pinned into `tables/`: `screen_manifest.csv` (8 designs, verbatim from
  `prelim_screen_subset.csv`), `classic_baselines.csv` (screen seeds
  1001/1002/1003 = 0.14064478405974706 / 0.15936940200276137 /
  0.13253100841854415, 3-seed mean 0.14418173149368419; 6x7 0.1701; full
  RTLLM rows), `v2_platform_config.md` (V2 flag set + anchor command),
  `tables/README.md` (provenance + run-root availability).
- Run-root check: classic screen roots exist on disk
  (`exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC`,
  `.../prelim_aux_archive_seed_replication_20260625_232854_UTC`); June-12
  `exp/ablation_matrix/` + `exp/fast_iter/` roots are gone, so V2 flags
  were reconstructed from tracked docs (doc 16 section 5; consolidated
  record section 8) and screen-scale V2 evidence comes from the P0 anchor.
- Canonical HV-AUC source identified for porting:
  `RTLLM_full_suite/20260630/tools/summarize_full_suite.py::{hv_at_step,
  auc,load_hv_auc}` — trapezoidal mean over cumulative-generation Pareto
  HV, steps 0..num_generations, `g_P/g_A/g_T` (sequential) or `g_P/g_A`
  (combinational), empty prefix = 0.0. Regression fixture:
  `RTLLM_full_suite/20260630/analysis/full/reference_complete_ppa_
  distribution/data/ppa_candidates.csv` vs stored
  `tables/full_suite_problem_metrics.csv`.
- Operator auditor source: `RTLLM_full_suite/20260630/tools/
  audit_operator_contract.py` (counts `single_thought_operator` vs EoH
  strategies {M-S, M-R, M-I, C-F, M-E, M-F} per method from
  `ppa_candidates.csv`; any single-thought row fails).

## 2026-07-03 13:05 KST - P0 Tooling Landed + M-T Contract Note

- Commits: b5371925ff (canonical HV-AUC: pareto_analysis primitives +
  `scripts/report_hv_auc.py` + 1e-9 regression vs stored 20260630
  tables), 47b6906bf6 (tracked `scripts/audit_operator_contract.py`),
  03e3c48475 (`scripts/validate_natural_qd_run.py`). 18 focused tests
  pass; ruff and pyright clean on touched files.
- Auditor sanity run on the stored 20260630 candidates reproduced the
  suite's all-pass contract (single_thought_count=0 for all five arms).
- Versioned contract note (M-T): the corrected 20260630 EoH-preserving
  QD arms emitted `M-T` (DeepGate 34, MasterRTL 18, Qwen 46 candidates)
  — the QD engine's thought-mutation lane under `eoh_strategies`. Ruling
  for this push, matching that precedent: QD arms MAY emit `M-T` (the
  auditor's `other_strategy_count` keeps it visible; report it in every
  lane package), classic arms may not; `single_thought_operator` remains
  a hard fail everywhere.
- generation_log.jsonl schema confirmed on a live classic root:
  per-generation `strategy_counts_this_generation` dict is the audited
  surface; problem dirs sit at `<save_path>/<model>/<benchmark>/<problem>`.

## 2026-07-03 13:10 KST - V2 Anchor Seed-1001 Launched

- Preflight recorded: `openai/gpt-oss-120b`, `max_model_len=131072`
  (`exp/natural_qd_push/p0_v2_anchor_20260703_041010_UTC/
  preflight_models_20260703_041010_UTC.json`).
- Launched the pinned V2 anchor command (tables/v2_platform_config.md)
  on the frozen 8-design screen, seed 1001, save path
  `exp/natural_qd_push/p0_v2_anchor_20260703_041010_UTC/live/
  smooth_qd_v2_8x5/seed_1001`, stdout/err in
  `launch_smooth_qd_v2_seed1001.log`.
- Comparator: reused classic seed-1001 metrics (mean HV
  0.14064478405974706) from `tables/classic_baselines.csv`; no classic
  relaunch.
