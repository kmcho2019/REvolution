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

## 2026-07-03 13:20 KST - V2 Pin Corrected; Anchor Relaunched

- While pre-registering N01, found the authoritative qd_target flag
  values in `20260618_briefing/exp_artifacts/01_integrated_v2_vs_classic/
  config_hard_subset_adaptive_rebinning.yaml`: `qd_num_cells 16`,
  `qd_grid_quantile_warmup_successes 8`, `qd_max_elites_per_cell 5`
  (matching the narrative's "bounded per-cell Pareto fronts holding <=5
  elites"). The first pin had left these at current repo defaults
  (64 / 20 / 1) — three material infidelities.
- Stopped the first anchor ~10 minutes in; quarantined its root as
  `exp/natural_qd_push/p0_v2_anchor_20260703_041010_UTC_INTERRUPTED_
  UNFAITHFUL/` (not a result; must not be interpreted).
- Ruling recorded in the pin: screen-scale runs keep the June-25
  screen's `strict_ablation` evaluation surface (comparability with the
  pinned classic baselines beats matching the June-12 matrix's
  `search_accelerated`); the V2 platform is defined by mechanism flags.
- Relaunched with the corrected flag set (fresh preflight recorded:
  `openai/gpt-oss-120b`, 131072):
  `exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/
  smooth_qd_v2_8x5/seed_1001`, log `launch_smooth_qd_v2_seed1001.log`.
- Lane-relevant knob semantics confirmed while checking:
  `qd_parent_selection=front_slot_lane_nsga2` already implements the N03
  mechanism (fixed archive-front parent lane on top of the NSGA-II pool,
  `engine.py:_sample_success_parents`), so N03 is config-only.
- N01 redefinition forced by the faithful platform: V2 already runs
  `pareto_front` cells with 5 elites, so "add per-cell Pareto slots" is
  not a delta. N01 becomes the cell-retention-mode family, single factor
  = `qd_cell_mode` (+ its paired capacity): N01a `elite_pareto_slot`
  with `qd_max_elites_per_cell 2` (the T36/T37 one-bounded-front-slot
  semantic, +4.04% replay HV, never run live operator-fair), N01b
  `scalar_elite` control (isolates whether V2's Pareto-cell retention
  contributes anything — F5 left this inconclusive at +0.013). Registry
  updated.
- N05 maps to the grid-quantile warmup length
  (`qd_grid_quantile_warmup_successes`, platform value 8; arms 4 and
  16). Exact single-factor definitions go in the registration cards
  before any launch.

## 2026-07-03 13:55 KST - V2 Anchor Seed-1001 Landed (+23.5% HV, unverified)

- Anchor completed in 1450 s, exit 0. Packaged per the pre-registered
  chain into `p0_v2_anchor/` (pareto_analysis, ppa_distribution,
  canonical hv_auc.csv, operator_contract.csv, run_validation.json).
- Headline (seed 1001 only): V2 mean HV 0.17376375275693837 vs classic
  0.14064478405974706 (+23.55%); mean HV-AUC 0.143659910 vs
  0.123873865 (+15.97%); coverage tied 8/8; mean Pareto points 2.625 vs
  3.25 (front breadth still trails); W/L/T 3/2/3.
- All gates green: single_thought_count=0 both arms (V2: 166 EoH ops,
  0 M-T); run validation pass; classic recompute reproduced the pinned
  0.14064478405974706 exactly (baseline verification done for this
  root).
- Figures inspected (fsm: genuinely dominating new design; alu: small
  area-axis exploit deficit). Cosmetic title/legend collision in
  pairwise figures noted for a shared-surface fix.
- Discipline: NO verdict language; the fsm 2.35x single-problem jump is
  the T83-style pattern that dies at replication. Seeds 1002+1003
  launched back-to-back immediately (same faithful config, per-seed
  preflights recorded in the anchor base dir).

## 2026-07-03 15:10 KST - 3-SEED READ: V2 BEATS CLASSIC 3/3 ON THE SCREEN

- Seeds 1002 (1355 s) and 1003 (1393 s) completed exit 0; packaged per
  the same chain under `p0_v2_anchor/replication/seed_100{2,3}/`.
- 3-seed means (scripted `tables/three_seed_summary.csv`): V2 HV
  0.16283536749649596 vs classic 0.14418173149368418 (+12.9%); V2
  HV-AUC 0.141413240 vs 0.121746133 (+16.2%); coverage 8/8 both arms
  all seeds; per-seed ratios 123.5% / 107.8% / 107.9% — 3/3 wins,
  including classic's best seed.
- All per-seed gates green (operator contract, run validation); classic
  recomputes matched all three pinned baselines exactly.
- Pre-registered screening promote gate: PASS on all three conditions.
  First QD arm in program history to beat classic on a seed-replicated
  operator-fair surface. Scope discipline: screening-scale only; the
  frozen-contract claim needs P3 (full RTLLM 46, 5 seeds, cluster
  stats, +5% log-ratio CI, held-out).
- Registered the promotion-arm decision rule BEFORE any P1 read (in
  `p0_v2_anchor/results_report.md`): promotion arm = V2 unless a P1
  lane beats V2 by >2% relative on 3-seed mean HV AND HV-AUC with
  coverage retained.
- Interpretation note for the journal narrative: this directly
  confirms the operator-contamination thesis — the identical archive
  mechanism that lost as thought_only+single_thought (F1 -0.093) wins
  operator-fair. The mechanism sentence for the paper stays one line:
  "REvolution, but survivors live in a MAP-Elites archive with bounded
  per-cell Pareto fronts and NSGA-II parent selection."
- One transcription-error near-miss: the first three_seed_summary.csv
  was hand-typed and had two wrong trailing digit runs; caught and
  replaced by the scripted generator before commit (rubric rule: no
  hand-copied numbers).

## 2026-07-03 15:25 KST - P1 Chain Launched; P3 De-Risked; Review Running

- P1 screen chain launched sequentially in one background job: N01a
  elite_pareto_slot_2, N01b scalar_elite, N05a warmup_4, N05b warmup_16
  (all seed 1001, per registered cards), then the N02 bounded
  one-problem smoke (Prob045_alu, 4x1, debug seed 42, never evidence).
  Per-arm preflights recorded in the run bases.
- P3 comparator check: classic full-RTLLM 5-seed roots AND classic_no_cf
  roots survive on disk under `exp/useful_bd_push/
  pcn_v3_experiments_20260701/live/rtllm_full_5seed/` (seeds 1001-1005)
  — the P3 promotion comparison needs zero new classic spend.
- Periodic `claude -p` adversarial review launched (due at ~12 commits);
  output will land in `reviews/claude_periodic_review_20260703_p0.md`.

## 2026-07-03 15:50 KST - Periodic Review: PASS_WITH_ACTIONS (8 actions)

- Review recorded at `reviews/claude_periodic_review_20260703_p0.md`.
  The reviewer independently recomputed all six per-seed means (exact
  match), verified operator contracts, registration ordering,
  quarantine, and the engine-untouched diffstat. Verdict:
  PASS_WITH_ACTIONS; no evidence-integrity violation.
- Interpretation softening (review F-6, adopted): the V2 screen win is
  CONSISTENT WITH the operator-contamination thesis but does not
  isolate it — representation and evaluation surface also differ from
  the F1 radical arm; the clean operator isolation remains the 20260630
  same-seed reruns. Narrative-facing text must use the softened form.
- Reviewer-surfaced strengthener: at seed 1003 V2 loses fsm (0.1459 vs
  0.2652) yet still wins the seed overall — direct rebuttal to
  fsm-jackpot dependence; use in the lane report and any deck.
- Budget-parity observation (F-7): per-arm initial_count varies
  (30/22/25 vs 20/22/22) with flipping direction — reads as
  retry/yield variance; per-arm LLM-call totals from scheduler
  telemetry join the standard package via the validator extension.
- Actions being executed: plan strict_ablation correction note (F-1);
  validator extension for config-vs-registration + LLM-call totals
  (F-2/F-7); tracked seed-summary generator (F-3); N03 card consistency
  + versioned criterion note (F-4); TODO syncs (F-5); commit-subject
  length + cards-before-code practice going forward (F-8); N02 test
  draw fix + required gamma + figure-fix TODO line (F-9).

## 2026-07-03 16:40 KST - N06 Upgraded to Active (descriptor research)

- User request: research empirically-strong, theoretically-grounded
  descriptors for V2. Evidence deep-dive completed and condensed into
  `lanes/N06_descriptor_bakeoff/research_memo.md`.
- Decisive finding: NO descriptor bake-off has ever run on the V2
  platform. F12's "no profile beats classic" is RADICAL-regime
  evidence (the June-18 briefing itself attributed the deficit to
  representation+operator, not the archive). What DOES transfer is the
  trio's collapse: confirmed in three regimes, incl. operator-fair
  CODE-EoH (ff_depth collapses 7/13); comb_width_log is a formal size
  proxy (diversity claim dropped at freeze).
- Registered wave structure (methodology.md): wave 1 = pure profile
  swaps journal_graph_testability_3d (semantic challenger: SCOAP/
  reconvergence/cyclomatic; F12 occupancy 0.50 vs trio 0.12) +
  size_control_3d (structural bar that beat theory under CODE-EoH) +
  random floor (T22 lesson: random is not weak); wave 2 =
  theory_grounded_compact_8d (zero axis collapses operator-fair) on
  CVT with a paired trio-CVT control (versioned two-factor note, N03
  pattern). Probe step before any spend. SR ReLU PCA (T19, +16.82% HV
  replay, beats random) stays a registered follow-up requiring a
  frozen-projection spec.
- Sequencing: N06 wave 1 launches after the P1 chain frees the
  endpoint, alongside whatever N03/N02 steps their dependencies allow.

## 2026-07-03 17:20 KST - P1 Reads: Retention Ladder; N05 Retired; Chain 2 Up

- P1 chain completed exit 0 (all four screen arms + N02 smoke).
  Packages: `lanes/N01_cell_retention_mode/package/`,
  `lanes/N05_warmup_init/package/`; all operator contracts pass
  (single_thought=0, M-T=0), coverage 8/8 everywhere, config-pinned
  validations pass for all four arms.
- N01 seed-1001 attribution ladder (mean HV): classic 0.14064 ->
  scalar_elite 0.14683 (+4.4%) -> elite_pareto_slot_2 0.15709
  (+11.7%) -> V2 pareto_front(5) 0.17376 (+23.5%). Retention capacity
  monotone in HV; Pareto POINTS monotone the other way (3.375 -> 3.125
  -> 2.625). Both arms diagnostic keepers; no challenger to V2.
- N05 seed-1001: warmup 4 = 0.14927 (-14.1% vs V2), warmup 16 =
  0.16383 (-5.7%); both directions lose, coverage unaffected. Lane
  RETIRED per its registered rule (cause: platform-optimum; positive
  tuning validation of warmup 8). Backlog note: revisit only inside
  N04 depth shapes.
- N02 smoke: `revolution_qd_natural` ran live cleanly (107 s, config
  shows gamma 1.0 + nsga2_global_rank, archive artifacts written) —
  N02a full screen cleared for chain 2.
- N06 wave-1 probes recorded (`lanes/N06_descriptor_bakeoff/probes/`):
  all three profiles resolve with requires_ppa=false
  (graph_testability: rtl+graph metrics; size_control: rtl-text only;
  random_hash: synthesis hash). Random control runs via explicit
  `--qd_descriptor_axes random_hash_0..2` (profile not in the locked
  YAML; no YAML edit needed).
- Chain 2 launched sequentially: N06b graph_testability_3d, N06c
  size_control_3d, N06d random_hash_3d, N03a/b front-slot lanes
  (0.10/0.30 on elite_pareto_slot(2) per the amended card), N02a
  curiosity gamma 1.0 — all seed 1001 with per-arm preflights.

## 2026-07-03 17:45 KST - Second-Opinion Review Channel Adopted (codex)

- User-adopted practice: alongside the periodic `claude -p` review, run
  `codex --yolo exec "Requesting READ-ONLY review of <scope> following
  GUIDELINES.md and the push plan ..."` for an independent second
  opinion; outputs land under `reviews/`. Prompts must state read-only
  and demand a PASS/FAIL verdict with numbered actions.
- First trial launched now (codex-cli 0.142.4) over the review-action
  batch + P1 packages (6fa46cfc77..HEAD), with spot-recompute of the
  N01/N05 report numbers, the N05 retirement justification, GUIDELINES
  simplicity of the three new scripts, single-seed overclaim risk in
  the retention-ladder wording, and N06 registration quality as the
  focus questions. Output:
  `reviews/codex_second_opinion_20260703_p1.md`.

## 2026-07-03 18:20 KST - Codex Second Opinion: PASS_WITH_ACTIONS (5), Executed

- Codex verdict PASS_WITH_ACTIONS with five findings the claude -p
  channel missed — the dual-reviewer practice paid for itself on its
  first run:
  1. N06 probe gate not actually satisfied (metadata-only probes;
     live arms already launched). Ruling recorded in the N06 card:
     wave-1 live results QUARANTINED until a real sampled probe
     artifact (per-candidate values, collapse counts, occupied cells)
     is packaged from the runs and passes; wave 2 probes fully before
     launch.
  2. N05 validations used a reduced pin set — repackaged with the full
     P0/N01 pin set; both arms pass.
  3. N05 retirement misframed — warmup_16 is a near-tie on HV-AUC
     (0.142240 vs V2 0.143660, -0.99%) and +16.5% HV over classic.
     Report reframed: N05a closed, N05b PARKED (not a promotion-arm
     candidate under the registered rule; revive inside N04 where
     warmup x depth interacts). The "no path to the promotion bar"
     wording conflated the plan's classic-based promote gate with the
     registered V2-based promotion-arm rule.
  4. N01 ladder wording softened to single-seed diagnostic signal
     (V2 beats classic on 3/8 problems; slot2->V2 gain concentrated in
     traffic_light/alu; replication before any narrative claim).
  5. Validator config discovery tightened: exactly one resolved
     config YAML required, ambiguity is an error (test added).
- Note for the promotion decision: the two gates (plan promote gate =
  vs classic; registered promotion-arm rule = vs V2) coexist by
  design — the plan gate defines full-RTLLM eligibility, the
  registered rule picks the single P3 arm. Recorded here to prevent
  the next conflation.

## 2026-07-03 18:40 KST - Concurrency Policy (user question, telemetry-decided)

- User asked whether we exploit the 64-core box (budget ~48) with
  flexible workers. Telemetry answer: the elastic scheduler is active
  (32 slots / 8 problems / 4-per-problem with borrowing), but the V2
  anchor shows 22% mean occupancy, peak 14/32 busy, zero shortfall —
  local eval is NOT the bottleneck; LLM generation latency is.
- Versioned policy recorded (`tables/concurrency_policy.md`): per-arm
  settings stay pinned 32/8/4 (comparability + no benefit); speedup
  comes from co-running up to TWO arms (observed combined peak ~28
  busy workers, inside the 48-core budget), with an M12-style
  validity-funnel guard on the first co-scheduled pair vs solo twins,
  per-run pairing records, and an endpoint-courtesy fallback to
  sequential. Applies from the next batch (chain 2 is mid-flight
  sequential and stays so).

## 2026-07-03 19:50 KST - Chain 2 Reads: N03b BEATS V2; C-D Ruling; N06 Verdict

- Chain 2 completed exit 0 (6 arms); all packaged with the standard
  chain; all operator audits pass (zero single-thought everywhere).
- **C-D ruling (versioned, extends the M-T ruling):** challenger-
  descriptor arms emitted `C-D` (15-25 candidates) — the QD engine's
  diverse-parent crossover in fill/backfill phases
  (engine.py:4787-4808, `_sample_diverse_success_parents`), a
  tuple-individual operator in the same engine-lane family as M-T.
  Ruled admissible for QD arms; validator allowlist extended
  (test updated); audits keep counts visible. Trio-based arms fired
  zero C-D — descriptor choice changes the effective operator mix.
- **N03b front_slot_lane_030 = 0.18486 mean HV / 0.15511 HV-AUC —
  first arm past the promotion bar at seed 1001** (+6.4% / +8.0% over
  V2, both >2%; coverage 8/8; Pareto points 2.875 > V2's 2.625).
  N03a (0.10) closed: 0.14160, loses to its own no-lane base.
  Non-monotone fraction response flagged; no scanning. Seeds
  1002/1003 launched IMMEDIATELY as the first co-scheduled pair under
  the concurrency policy (M12 funnel guard applies at read time).
- **N02a curiosity gamma 1.0: HARD-GATE KILL** — coverage 7/8
  (gshare 0 valid-PPA; classic covers it); HV 0.15449 / 8-normalized
  HV-AUC 0.12919. Cause: exploration-tax on the hardest design.
  Registered gamma-0.5 retry stands at reduced priority; the
  qd_natural engine stays (mechanism negative, not implementation).
- **N06 wave-1: quarantine LIFTED** via the real probe artifact
  (`lanes/N06_descriptor_bakeoff/probes/live_probe_summary.csv`:
  extraction 8/8 problems per arm, per-axis unique counts, collapse
  states). Verdict: trio wins both metrics against all challengers
  (graph_testability 0.15195 > size_control 0.14129 > random 0.13457)
  DESPITE the worst collapse health (trio 6/8 degenerate; random 0/8
  with 70 occupied cells and the worst HV). Archive health and HV
  anti-correlate on this platform at this seed — occupancy is not the
  lever. Wave 2 (compact_8d+CVT) drops to reduced priority behind the
  N03b promotion test.
- Persistence accounting: 8 lanes registered, 6 with live results, 11
  measured arms across 5 mechanism families; the >=8-packages bar is
  met at arm level with diagnoses recorded for every kill.

## 2026-07-03 21:00 KST - N03b Replication FAILS Displacement; P3 Launched (V2)

- First co-scheduled pair (N03b seeds 1002+1003) completed: 1845/1855 s
  (~34% slower per run than solo, both-at-once ~1.5x faster than
  sequential). M12 funnel guard PASSED: coverage 8/8 both seeds,
  validations green, no validity-collapse signature. Pairing adopted
  as standard.
- N03b 3-seed vs V2 (tracked generator, three_seed_vs_v2.csv):
  HV 0.16106 vs 0.16284 (98.9%); HV-AUC 0.13750 vs 0.14141 (-2.8%).
  Seed-1001's +6.4% was a seed artifact — the same single-seed pattern
  as T83/PCN-v3, intercepted PRE-SPEND by the registered ladder.
  N03b keeps: 3/3 seed wins vs classic (+11.7%), better front breadth
  than V2 every seed; designated Branch-B utility candidate.
- One packaging correction: the N03 seed-1001 hv_auc table initially
  lacked V2 rows (ppa run omitted the V2 backend); repackaged with V2
  included before the summary was generated — the tracked generator's
  assert caught it (no silent partial table).
- **P3 launched with V2 as the promotion arm** (registration:
  `p3_full_rtllm/commands.md`, written before any full-suite result):
  full RTLLM 50-problem list (headline = 46 ref-complete), seed 1001,
  command cloned from the 20260701 classic comparator method script
  (strict_ablation, 48/12/4 workers, --eoh_success_operator_set
  classic explicit), preflight recorded. Comparators are the reused
  classic 5-seed roots (0.10380/0.08680) and classic_no_cf
  (0.10685/0.09459). Ladder: seed 1001 -> 1002-1005 -> contract stats;
  weak single-seed reads do not stop the ladder.

## 2026-07-03 22:35 KST - P3 Seed-1001: V2 Trails at This Seed; Ladder Continues

- Seed-1001 full-suite read (`p3_full_rtllm/seed_1001/read_note.md`):
  V2 0.09677 vs classic-root 0.11140 mean HV (-13.1%); AUC -7.7%;
  coverage 32 vs 33; W/L/T 6/9/31. All audits/validations green.
- Decomposition: ~80% of the gap is a single classic jackpot
  (Prob036_edge_detect 0.8947 vs 0.3559); coverage miss =
  Prob039_serial2parallel. Comparator-variance context: this classic
  root scores 0.11140 while the 20260630 run of the SAME config scored
  0.0997 — single-seed spread exceeds the judged deltas.
- Discipline note (symmetry): no verdict from n=1 in either direction;
  the registered ladder proceeds. Seeds 1002+1003 launched as a
  co-scheduled pair with per-seed preflights.

## 2026-07-04 01:30 KST - P3 COMPLETE: Five-Seed Verdict (two-scale story)

- All five seeds packaged and audited; classic recompute matches the
  pinned 5-seed baseline exactly (0.103802). Verdict doc:
  `p3_full_rtllm/five_seed_verdict.md`.
- Full-suite result: HV 95.2% (per-seed 86.9/102.8/97.8/97.5/92.0 —
  1W/4L, jackpot-dominated), HV-AUC 100.5% (tie), coverage 166 vs 164
  (V2 edge; >= classic on 4/5 seeds). Interim contract-form stats:
  mean log-ratio +0.0298 < gate 0.0488, CI [-0.73, +0.76] — the +5%
  gate FAILS at full scale; canonical report_journal_statistics run is
  a P4 item.
- THE PUSH'S FINDING (two-scale, both directions operator-fair and
  seed-replicated): the natural QD extension WINS at screening scale
  (+12.9% HV, 3/3 seeds) and lands at no-cost parity with a coverage
  edge at full-suite scale, where outcomes are LLM-capability-bound
  (F18-F32 consistent). The June negative map's contamination is what
  hid the win; the June validity tax is absent in V2.
- Consequence: journal posture = characterization with a positive,
  replicated, scale-scoped win + contamination forensics + no-cost
  full-scale overlay; Branch-B utility-metric analysis over V2/N03b
  archives is the remaining full-scale upside. N04/N06-w2/N02b remain
  open follow-ups, not blockers.
- P4 remaining: canonical contract statistics, central comparison
  report, dashboard refresh + lineage closure note, viewer bundle,
  figure legend fix, next periodic dual review, adversarial
  validation PASS.

## 2026-07-04 04:20 KST - P3b: gt3d Killed at the 2-Seed Gate; N03b Pair Up

- P3b registered (user-directed amendment: measured ~18-point
  screen->suite transfer gap downgrades screen-based elimination for
  near-band arms; the gap itself is a methodology finding).
- P3b-A graph_testability_3d, seeds 1001+1002 (7132/7122 s, audits
  green): 2-seed mean HV 0.09140 vs classic 2-seed 0.10448 -> below
  the registered 0.90x kill threshold (0.09403) -> KILLED per gate;
  no seeds 1003-1005.
- Characterization datum worth keeping: gt3d covered 34 designs on
  BOTH seeds — more than classic (33/33) and V2 (32/33). The
  healthier-archive/more-coverage/less-HV pattern from the screen
  holds at suite scale: descriptor semantics move coverage, not HV,
  on this platform.
- P3b-B (N03b front-slot lane 0.30) pair launched (seeds 1001+1002)
  with per-seed preflights; same gate applies. P3b-C (compact_8d+CVT)
  remains contingent and currently unjustified.

## 2026-07-04 06:30 KST - Dual Review on P3: codex PASS, claude PASS_WITH_ACTIONS

- codex: clean PASS, zero actions — independently recomputed the
  5-seed verdict, the interim log-ratio stats (faithful to the frozen
  formula), both P3b gate decisions, scoping, and the coverage-vs-HV
  wording (`reviews/codex_second_opinion_20260704_p3.md`).
- claude -p: PASS_WITH_ACTIONS (4, documentation-grade), verifying the
  same surface without execution (set-structure recount of T=149; the
  80.0% jackpot decomposition; single-commit histories on all three
  registration files; the C-D validator change shown irrelevant to the
  headline — V2 P3 contracts all have other_strategy_count=0)
  (`reviews/claude_periodic_review_20260704_p3.md`).
- Actions executed: (1) dated AUC pinned-vs-canonical divergence note
  in tables/README (0.086982 canonical vs 0.08680 pre-canonical
  pinned; no validity impact; "recompute = pinned" scoped to HV);
  (2) P3 todo items ticked with evidence pointers + explicit canonical
  report_journal_statistics.py checkbox added + held-out gate marked
  not-triggered; (3) scaffold README Current State rewritten for the
  completed P0-P3 campaign; (4) subjects <=50 chars henceforth.

## 2026-07-04 10:40 KST - CAMPAIGN MEASURED: N03b 5-Seed Suite Verdict

- Final run landed (seed 1005, audits green). N03b 5-seed suite:
  HV 0.100587 (96.9% of classic — best QD arm), HV-AUC46 0.089186
  (102.5% — best of ALL arms including classic), coverage 163;
  per-seed 88.7/97.2/106.0/95.6/97.7% with an outright seed-1003 win.
  Closure: `p3_full_rtllm/p3b_closure.md`.
- Suite family finding: N03b and V2 INVERT their screen ordering at
  suite scale — the transfer gap applies between QD variants, not
  just QD-vs-classic. The QD family trades a few HV points for
  AUC/coverage/front-breadth depending on the mechanism knob; no arm
  clears +5%.
- P3b-C ruling recorded: contingency met in letter by N03b (a
  mechanism arm), but the descriptor evidence (gt3d kill,
  coverage-only movement) does not justify the two-arm CVT spend;
  scoped out, revisitable with N04/wave-2.
- Promotion arm remains V2 by rule sequence; N03b becomes co-headline
  QD arm and the primary Branch-B utility-metric archive (P4
  analysis, no new runs).
- P4 queue (all runs done; analysis/docs only): canonical
  report_journal_statistics over P3 packages; Branch-B utility metric
  from V2/N03b archives; central comparison report; dashboard 13
  refresh + June-22 lineage closure note; viewer bundle; figure
  legend fix; final adversarial validation.

## 2026-07-04 23:50 KST - Adversarial Validation v1: FAIL (packaging only); v2 rerun

- The first full-rubric adversarial validation returned FAIL scoped
  explicitly to packaging/completion-gate items, with "evidence and
  claim tier verified sound - now with all headline numbers
  independently recomputed to exactness" (a third verification agent
  re-derived every number in items A-H from packaged CSVs, including
  all six anchor seed-arm cells and the canonical paired deltas to
  1e-9).
- Capture defect: claude -p emits only the final message; the
  validator's full report body (Required Fixes 1-7) was not in it -
  only its addendum survived (preserved at
  reviews/adversarial_validation_v1_addendum_only.md). The rerun (v2)
  carries an explicit entire-final-message-is-the-report instruction.
- The addendum's one concrete fix is EXECUTED (commit 91b6220d5d): the
  canonical HV delta's positive sign is 50-scope-only - the 46-scope
  restriction is -0.0050 (matching the packaged tables), with the sign
  driven by the excluded missing-reference designs; scope note added
  to read_note.md and the central report.
- The addendum also independently confirmed the +0.0298 log-ratio /
  95.2% ratio-of-means coexistence (epsilon coverage-jackpot terms
  cancel 11-vs-11; the positive mean comes from V2's large-relative
  wins on both-covered units) - no drift between the interim
  implementation and the frozen formula.

## 2026-07-04 (backfill, watch-c9-era) - P3c Registration/Launch/Closure

Backfilled per validation-v2 observation 1 (the audit log skipped the
P3c window; full detail lives in the P3c files and the hourly-watch
verdict log):

- 15:22Z registered `p3_full_rtllm/p3c_bd_sweep_registration.md`
  (user-directed uniform 2-seed suite BD sweep; random floor as the
  falsification test; compact_8d+CVT with paired trio-CVT control,
  live-probe-first health gate). `source_aligned_shape_density_3d`
  provenance: the T73 axes (MasterRTL branching + RTLTimer wire/DFF
  density), registered in `data/configs/qd_descriptor_profiles.yaml`,
  probe recorded PPA-free in `lanes/N06_descriptor_bakeoff/probes/`.
- 09:31-19:50Z ran all five pairs (size_control, random_hash,
  shape_density, compact8d+trio_cvt x2 seeds), zero failures; each
  pair packaged with the standard chain before any read (hourly-watch
  c1-c9 verdicts + actions in `reviews/hourly_watch/verdict_log.md`).
- Closure `p3_full_rtllm/p3c_closure.md`: two HV tiers; geometry a
  wash; coverage uniquely semantic (floor falsification held);
  compact_8d ties trio HV with ~4x collapse resistance (qualified
  2026-07-05: one hard extraction failure, Prob050 s1002 missing
  SCOAP metric — watch c19 find).

## 2026-07-04 24:00 KST - ADVERSARIAL VALIDATION v2: PASS (goal outcome met)

- Verdict PASS at the claimed tier (two-scale characterization), with
  "Required Fixes Before PASS: None" and a 10-item non-blocking punch
  list. Report recorded verbatim in
  `natural_qd_push_subagent_validation_report.md`.
- The validator independently verified: screening win to the last
  digit; suite reads against original run roots; every operator
  contract (30 files, single_thought=0 both arms everywhere); all 26
  config-pin validations; empty diffs on engine.py/algorithm.py; the
  0.413 utility robust even under the stricter no-QD-only reading
  (0.396); reward-hacking risk LOW with the record "consistently
  self-adverse".
- Punch list disposition: items 1 (this backfill) executed; remaining
  items tracked in the TODO as post-PASS polish for the manuscript
  phase.

## 2026-07-07 11:18 UTC - Goal Restart; N04 Pre-Registered

- Restarted the natural-QD push as a continuation of the July-7 cleared
  state, not a repeat of P0-P4. The active goal is the open-by-design
  follow-up campaign: N04 first, then N02b/N07/descriptor decisions only
  if their gates justify them.
- Read the restart log (`20260707_2005_code_logs.md`), the goal template,
  plan, TODO, central report, lanes index, T79 command table, and the
  binding GUIDELINES.md simplicity/validation rules.
- N04 is now pre-registered in `lanes/N04_budget_shape/`: first arm is
  faithful Smooth-QD V2 at 6x7, seed 1001, with only the budget shape
  changed from the P0 V2 platform. The matched comparator is the T79
  `classic_revolution_6x7` seed-1001 run root. Before reading any V2
  result, the comparator must be recompute-verified from that root and
  validated against the manifest/config/operator contract.
- Comparator verification completed before V2 launch:
  `lanes/N04_budget_shape/baseline_verification.md`. Fresh recompute:
  mean HV `0.1700994814185665`, mean HV-AUC `0.146221021526`, coverage
  `8/8`, candidates `222`, LLM API calls `768`, `single_thought_count=0`,
  operator audit pass, run validation pass. This matches the archived
  T79 exact HV row and clears N04 to launch the V2 6x7 arm.
- N04a launched at
  `exp/natural_qd_push/n04_budget_shape_20260707_112042_UTC/live`.
  Built-in vLLM preflight passed (`openai/gpt-oss-120b`,
  `max_model_len=131072`); run completed exit 0 after the expected
  `gshare` tail. Packaged in `lanes/N04_budget_shape/`.
- Result: V2 6x7 mean HV `0.17199937669444593` vs classic
  `0.1700994814185665` (`101.1%`), coverage `8/8`, but HV-AUC
  `0.132267067187` vs classic `0.146221021526` (`90.5%`), Pareto
  points `1.75` vs `2.625`, final-HV W/L/T `2/2/4`. Operator audit
  pass (`single_thought_count=0`, `other_strategy_count=0`) and run
  validation pass.
- Gate decision: no 4x11 and no 6x7 seed ladder. Cause class:
  front-loss / anytime-loss. This is useful negative evidence against
  the simple "QD just needs deeper equal-candidate shape" explanation.

## 2026-07-07 12:30 UTC - N02b Gamma 0.5 Retry Completed; Lane Retired

- Pre-registered the only allowed N02 retry in
  `lanes/N02_curiosity_sampling/commands.md`: same frozen 8-design 8x5
  screen, same V2 platform pins, natural-QD engine, only
  `qd_curiosity_gamma=0.5` changed from the N02a mechanism.
- Focused tests before launch passed:
  `uv run pytest tests/revolution/test_qd_natural_engine.py
  tests/scripts/test_validate_natural_qd_run.py` (`15 passed`).
- Launched N02b at
  `exp/natural_qd_push/n02b_curiosity_20260707_120427_UTC/live`;
  built-in vLLM preflight passed (`openai/gpt-oss-120b`,
  `max_model_len=131072`). Run completed cleanly after the expected
  gshare tail.
- Packaged against the pinned classic 8x5 and P0 V2 anchors in
  `lanes/N02_curiosity_sampling/`. Operator audit passed
  (`curiosity_g05`: 178 candidates, 26 initial, `single_thought_count=0`,
  152 EoH strategies, 0 other), and config-pinned run validation passed
  with 768 total LLM API calls.
- Result: gamma 0.5 retained valid-PPA coverage (`8/8`, including
  19 gshare candidates) but underperformed. Mean HV `0.1286403090258023`
  vs classic `0.14064478405974706` (`91.5%`) and V2
  `0.17376375275693837` (`74.0%`); HV-AUC `0.11454281702479292` vs
  classic `0.12387386482166513` (`92.5%`) and V2
  `0.14365991026686661` (`79.7%`). Final-HV W/L/T: `1/4/3` vs V2 and
  `0/5/3` vs classic.
- Gate decision: retire N02. The softened curiosity bias fixes the
  coverage kill but not the quality loss; no gamma scan is allowed
  without a new mechanism card and diagnosis. The self-contained engine
  remains useful as a tested negative-control implementation, not as a
  TCAD headline candidate.

## 2026-07-07 12:45 UTC - Read-Only Follow-Up Audit: PASS

- Ran a scoped `claude -p` read-only audit with a 10-minute timeout over
  the July-7 follow-up commits (`338c4d2302`, `6f424a1270`) and the
  current docs, focused on drift from the natural-extension vision,
  operator parity, registration-before-results, metric recomputation,
  navigation consistency, and commit hygiene.
- Verdict recorded in
  `reviews/claude_periodic_review_20260707_followups.md`: PASS, no
  blocking issues. The reviewer recomputed N04 and N02b headline
  values from tracked artifacts, confirmed the natural-extension
  framing, and verified operator/config validation gates.
- Non-blocking actions adopted immediately: refresh the stale N03 block
  in `lanes/README.md` and update the central report header date for
  the July-7 follow-up additions.

## 2026-07-07 13:05 UTC - N07 Probe-Only Pre-Registration

- Opened `lanes/N07_corrected_suite_completion/` as a due-diligence
  lane, not a headline mechanism. The card explicitly rejects copying
  the 20260630 delayed/archive-activation commands because they change
  archive activation, cell mode, champion lane fraction, and fill knobs
  in addition to descriptors.
- Re-scoped N07 to V2-faithful descriptor-only variants:
  `source_aligned_rf_timing_state_3d`, `rf_deepgate_hybrid_3d` with the
  frozen June-26 descriptor file, and `implemented_structural_compact_3d`
  as the compact structural proxy used by the old AURORA-labeled arm.
- Ran lightweight descriptor probes for all three. They resolve and
  report `requires_ppa=false`; N07a needs source-aligned RF timing,
  N07b needs RF timing plus DeepGate pooled embeddings, and N07c needs
  synthesis metrics. Live 8-design screens remain blocked until the
  relevant arm passes a bounded extraction smoke that writes
  descriptor-health artifacts.

## 2026-07-07 13:01 UTC - N07a Extraction Smoke: PASS

- Added `scripts/probe_n07_extraction_smoke.py` as a narrow operational
  helper outside the core engine. It extracts source-aligned RF timing
  descriptors on the frozen 8-design reference RTLs, inserts synthetic
  archive records only to exercise grid-quantile health reporting, and
  writes smoke artifacts. It performs no LLM calls and makes no HV or
  functionality claim.
- Ran:
  `timeout 600s uv run python scripts/probe_n07_extraction_smoke.py --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/smokes/n07a_source_aligned_rf_timing_20260707_130130_UTC`
- Result: PASS. Descriptor extraction completed for all 8 frozen inputs;
  grid-quantile warmup initialized (`4x4x4` effective shape), occupied
  7 cells, and reported no collapsed axes. N07a is now eligible for a
  seed-1001 live screen if we choose to spend the LLM budget. N07b/N07c
  remain extraction-smoke gated.

## 2026-07-07 13:35 UTC - N07a Live Screen: CLOSE

- Preflight recorded
  `preflight_vllm_models_20260707_130714_UTC.json`:
  `openai/gpt-oss-120b`, `max_model_len=131072`, `owned_by=vllm`.
- Ran the V2-faithful N07a screen at
  `exp/natural_qd_push/n07_corrected_suite_20260707_130714_UTC/live/source_aligned_rf_timing_state_3d/seed_1001`
  with `qd_operator_kind=eoh_strategies`,
  `representation_kind=code_individual`, 128k token budgets, seed 1001,
  and only the descriptor changed to
  `source_aligned_rf_timing_state_3d`. Runtime completed exit 0 in
  1440.80 s.
- Package artifacts: `n07a_pareto_analysis/`,
  `n07a_ppa_distribution/`, `n07a_hv_auc.csv`,
  `n07a_operator_contract.csv`, `n07a_run_validation.json`, and
  `results_report.md`.
- Validation: config-pinned run validation PASS; operator audit PASS
  with `single_thought_count=0`; package warnings empty.
- Read: mean HV `0.12758666838914773` vs classic
  `0.14064478405974706` (`90.7%`) and V2
  `0.17376375275693837` (`73.4%`). HV-AUC `0.100130201074` vs classic
  `0.123873864822` (`80.8%`) and V2 `0.143659910267` (`69.7%`).
  Coverage retained at 8/8; final-HV W/L/T `2/3/3` vs classic and V2.
- Descriptor health explains the negative read: live generated
  candidates have `5/8` collapsed-axis problems and one uninitialized
  archive. Cause class: descriptor-collapse plus front-loss. Gate
  decision: close N07a; do not escalate to seeds 1002/1003.

## 2026-07-07 13:42 UTC - N07c Extraction Smoke: PASS

- Extended `scripts/probe_n07_extraction_smoke.py` narrowly to support
  `implemented_structural_compact_3d` using existing V2 anchor
  `code_synthesis_report.metrics.json` artifacts. The helper asserts the
  expected profile and metrics shape, writes descriptor-health artifacts,
  and makes no HV/functionality claim.
- Ran:
  `timeout 600s uv run python scripts/probe_n07_extraction_smoke.py --profile implemented_structural_compact_3d --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/smokes/n07c_implemented_structural_compact_20260707_134155_UTC`
- Result: PASS. Descriptor extraction covered 196 existing synthesized
  candidate metric artifacts across the frozen 8 problems; grid-quantile
  warmup initialized (`3x4x4` effective shape), occupied 14 cells,
  retained 57 archive entries, and reported no collapsed axes. This
  cleared only the N07c launch gate and made no live HV claim.

## 2026-07-07 14:11 UTC - N07c Live Screen: CLOSE

- Preflight recorded
  `preflight_vllm_models_20260707_134510_UTC.json`:
  `openai/gpt-oss-120b`, `max_model_len=131072`, `owned_by=vllm`.
- Ran the V2-faithful N07c screen at
  `exp/natural_qd_push/n07_corrected_suite_20260707_134510_UTC/live/implemented_structural_compact_3d/seed_1001`
  with `qd_operator_kind=eoh_strategies`,
  `representation_kind=code_individual`, 128k token budgets, seed 1001,
  and only the descriptor changed to
  `implemented_structural_compact_3d`. Runtime completed exit 0 in
  1492.84 s.
- Package artifacts: `n07c_pareto_analysis/`,
  `n07c_ppa_distribution/`, `n07c_hv_auc.csv`,
  `n07c_operator_contract.csv`, `n07c_run_validation.json`, and the
  refreshed `results_report.md`.
- Validation: config-pinned run validation PASS; operator audit PASS
  with `single_thought_count=0`; package warnings empty.
- Read: mean HV `0.12395121259161174` vs classic
  `0.14064478405974706` (`88.1%`) and V2
  `0.17376375275693837` (`71.3%`). HV-AUC `0.104572116155462` vs
  classic `0.123873864821665` (`84.4%`) and V2
  `0.143659910266867` (`72.8%`). Coverage retained at 8/8; final-HV
  W/L/T `1/4/3` vs classic and V2.
- Descriptor health explains the negative read: live generated
  candidates have `3/8` collapsed-axis problems, two uninitialized
  archives, and 31 occupied cells total. Cause class:
  descriptor-collapse plus front-loss. Gate decision: close N07c; do
  not escalate to seeds 1002/1003.

## 2026-07-07 14:25 UTC - N09 Pareto Capacity: REGISTERED

- Registered `lanes/N09_pareto_capacity/` as the next cheapest natural
  follow-up after N07a/N07c closed. The mechanism is V2 with
  `qd_max_elites_per_cell=7` instead of 5, while keeping
  `qd_cell_mode=pareto_front`, the frozen descriptor trio, NSGA-II global
  parent selection, `qd_operator_kind=eoh_strategies`,
  `representation_kind=code_individual`, and the same 8x5 budget.
- Rationale: N01's seed-1001 retention ladder suggested per-cell Pareto
  capacity carries much of the screen-scale gain, while N04/N07 failures
  diagnose front-loss. Capacity 7 is one existing config knob and avoids
  descriptor/projection machinery, PCN-style triggers, and core-engine
  edits.
- Gate: run only seed 1001 first; close on coverage loss or mean HV below
  `0.95x` matched classic; escalate only if it beats V2 on both HV and
  HV-AUC with coverage retained. No capacity scan is allowed from this
  card.

## 2026-07-07 15:03 UTC - N09 Pareto Capacity: DIAGNOSTIC

- Preflight recorded
  `lanes/N09_pareto_capacity/preflight_vllm_models_20260707_142703_UTC.json`:
  `openai/gpt-oss-120b`, `max_model_len=131072`, `owned_by=vllm`.
- Ran the V2-faithful N09 screen at
  `exp/natural_qd_push/n09_pareto_capacity_20260707_142703_UTC/live/pareto_front_7/seed_1001`
  with `qd_operator_kind=eoh_strategies`,
  `representation_kind=code_individual`, 128k token budgets, seed 1001,
  and only `qd_max_elites_per_cell=7` changed. Runtime completed exit 0
  in 1857.00 s.
- Package artifacts: `pareto_analysis/`, `ppa_distribution/`,
  `hv_auc.csv`, `operator_contract.csv`, `run_validation.json`, and
  `results_report.md`.
- Validation: config-pinned run validation PASS; operator audit PASS
  with `single_thought_count=0`; package warnings empty.
- Read: mean HV `0.15928268015096297` vs classic
  `0.14064478405974706` (`113.3%`) and V2
  `0.17376375275693837` (`91.7%`). HV-AUC `0.141828877732136` vs
  classic `0.123873864821665` (`114.5%`) and V2
  `0.143659910266867` (`98.7%`). Coverage retained at 8/8; final-HV
  W/L/T `1/4/3` vs classic and `1/3/4` vs V2.
- Diagnosis: capacity-inert plus front-loss. N09 has fewer Pareto
  points than V2 (2.375 vs 2.625) and fewer valid-PPA candidates
  (182 vs 196), so larger per-cell capacity does not add front
  material. Gate decision: diagnostic keeper only; do not escalate to
  seeds 1002/1003 and do not scan capacity values.

## 2026-07-07 15:13 UTC - N10 SR-ReLU PCA: SMOKE PASS

- Registered `lanes/N10_sr_relu_pca/` as the next natural descriptor
  probe after N09 closed capacity-above-five. The mechanism is
  V2-faithful descriptor-only: keep `qd_cell_mode=pareto_front`,
  `qd_max_elites_per_cell=5`, `qd_parent_selection=nsga2_global_rank`,
  `qd_operator_kind=eoh_strategies`, and
  `representation_kind=code_individual`; only switch to the frozen
  `sr_pca_3d` descriptor file if the live screen launches.
- Rationale: T19 SR-ReLU PCA is the strongest descriptor-isolating
  replay lead on record, but it needed a frozen projection spec and an
  extraction gate. The old artifact trains on six development problems
  and has no overlap with the frozen July 8-design screen; it is
  screen-eligible only, not a full-RTLLM promotion artifact.
- Added `scripts/probe_n10_sr_relu_smoke.py` plus a focused test. The
  helper runs fresh ST-NOD Yosys stage dumps on one existing V2
  seed-1001 candidate per frozen screen problem, projects SR-ReLU
  descriptors, writes compact descriptor-health artifacts, and removes
  generated stage-dump artifacts after projection. It performs no LLM
  calls and makes no HV/functionality claim.
- Ran:
  `timeout 1200s uv run python scripts/probe_n10_sr_relu_smoke.py --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N10_sr_relu_pca/smokes/sr_relu_pca_20260707_151320_UTC`
- Result: PASS. Summary reports status `pass`,
  `screen_training_overlap=[]`, initialized descriptor health,
  effective `4x4x4`, `8` occupied cells, `8` archive entries, and no
  collapsed axes. Package size after trimming generated stage dumps is
  `24K`.
- Gate decision: N10 is eligible for exactly one seed-1001 live screen
  under the registered V2-faithful descriptor-only rule. Close on
  coverage loss, mean HV below `0.95x` classic, operator audit failure,
  or any `single_thought_count>0`. Full-suite use would require a new
  holdout-clean artifact because the T19 fitting corpus includes RTLLM
  problems.

## 2026-07-07 15:56 UTC - N10 SR-ReLU PCA: DIAGNOSTIC

- Preflight recorded
  `lanes/N10_sr_relu_pca/preflight_vllm_models_20260707_152537_UTC.json`:
  `openai/gpt-oss-120b`, `max_model_len=131072`, `owned_by=vllm`.
- Ran the V2-faithful N10 screen at
  `exp/natural_qd_push/n10_sr_relu_pca_20260707_152554_UTC/live/sr_relu_pca_3d/seed_1001`
  with `qd_operator_kind=eoh_strategies`,
  `representation_kind=code_individual`, 128k token budgets, seed 1001,
  and only the descriptor changed to the lane-local `sr_pca_3d` profile.
  Runtime completed exit 0 in 1520.15 s.
- Package artifacts: `pareto_analysis/`, `ppa_distribution/`,
  `hv_auc.csv`, `operator_contract.csv`, `run_validation.json`, and
  `results_report.md`.
- Validation: config-pinned run validation PASS; operator audit PASS
  with `single_thought_count=0`; package warnings empty. The candidate
  audit shows 27 QD fill/backfill strategies (M-T/C-D), visible as
  `other_strategy_count=27`, but no single-thought leakage.
- Read: mean HV `0.156825295476909` vs classic
  `0.140644784059788` (`111.5%`) and V2 `0.173763752757077`
  (`90.3%`). HV-AUC `0.134106202651801` vs classic
  `0.123873864821665` (`108.3%`) and V2 `0.143659910266867`
  (`93.3%`). Coverage retained at 8/8; final-HV W/L/T `2/3/3` vs
  classic and `1/2/5` vs V2.
- Diagnosis: yield-loss plus front-loss. Live descriptor health is
  materially better than N07a/N07c (`7/8` problems keep all SR-PCA axes
  live), but `Prob135_m2014_q6b` collapses all three axes, valid-PPA
  yield drops to 139 vs V2's 196, and Pareto breadth falls to 2.125 vs
  V2's 2.625. Gate decision: diagnostic keeper only; do not escalate to
  seeds 1002/1003. Full-suite use still requires a new holdout-clean
  SR-ReLU artifact.

## 2026-07-07 16:10 UTC - N07-N10 Dual Review: PASS

- Ran the requested periodic read-only audit after nine follow-up commits
  since `0f8f616883`. Claude review is recorded at
  `reviews/claude_periodic_review_20260707_n07_n10.md`; verdict:
  PASS_WITH_ACTIONS, with no science blockers. It verified natural
  extension faithfulness, operator parity, registration-before-results,
  metric claims, and doc organization for N07a/N07c/N09/N10.
- Ran the Codex-side read-only second opinion through the multi-agent
  audit tool because the local `codex` CLI was not available in `PATH`.
  Verdict: PASS, no required actions, recorded at
  `reviews/codex_second_opinion_20260707_n07_n10.md`.
- Review recommendation: do not open new single-knob scans. Either run the
  bounded N07b extraction smoke to close due diligence, or explicitly
  leave N07b low-priority and pivot to manuscript synthesis around the
  two-scale V2/N03b story, compact_8d swap decision, and optional held-out
  confirmation.
- Working-tree note: `20260707_2005_code_logs.md` remains untracked as a
  user-provided raw restart transcript/source log rather than a committed
  result artifact. `.devcontainer/devcontainer-lock.json` also remains an
  unrelated pre-existing untracked file.

## 2026-07-07 16:24 UTC - N07b RF/DeepGate Smoke: FAIL

- Extended `scripts/probe_n07_extraction_smoke.py` narrowly to support
  `rf_deepgate_hybrid_3d` using the frozen June-26 descriptor profile and
  existing `DeepGatePooledDescriptorEvaluator`. No core QD engine code was
  changed.
- Focused validation before the smoke passed:
  `uv run pytest tests/scripts/test_probe_n07_extraction_smoke.py`
  (`3 passed`), `uv run ruff check scripts/probe_n07_extraction_smoke.py
  tests/scripts/test_probe_n07_extraction_smoke.py`, `uv run python -m
  pyright scripts/probe_n07_extraction_smoke.py
  tests/scripts/test_probe_n07_extraction_smoke.py`, and `uv tool run ty
  check scripts/probe_n07_extraction_smoke.py
  tests/scripts/test_probe_n07_extraction_smoke.py`.
- Ran:
  `timeout 1800s uv run python scripts/probe_n07_extraction_smoke.py --profile rf_deepgate_hybrid_3d --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/smokes/n07b_rf_deepgate_hybrid_20260707_162135_UTC`
- Result: FAIL. A localization loop confirmed DeepGate extraction passed
  `RTLLM/Prob015_multi_pipe_8bit`, `Prob024_fsm`, and
  `Prob041_traffic_light`, then failed on `RTLLM/Prob045_alu` during AIG
  export after undriven-bit warnings with
  ``ERROR: Assert `a >= 0' failed in backends/aiger/aiger.cc:130.``
- Decision: N07b fails the bounded extraction gate and no live N07b
  screen is allowed. The corrected-suite due-diligence lane is closed:
  N07a/N07c are live negatives and N07b is an extraction negative.

## 2026-07-07 16:45 UTC - Post-N10 Follow-Up Decision Map

- Added `followup_decision_map.md` to summarize the operator-fair
  follow-up portfolio after N04, N02b, N07a/N07b/N07c, N09, and N10.
  The map records the current decision: stop opening new single-knob
  natural-variant screens unless a qualitatively new mechanism card is
  registered with a pre-launch gate.
- Synthesis: the current best journal extension remains Smooth-QD V2,
  with N03b as the suite utility/front-material candidate and compact_8d
  as a qualified descriptor-health manuscript option. Post-PASS variants
  failed by front-loss, yield-loss, exploration-tax, descriptor-collapse,
  extraction failure, or mechanism-inert behavior rather than operator
  contamination.
- Boundaries: this does not declare the overall goal complete. The plan's
  exhausted-portfolio stop condition still needs adversarial PASS before
  the whole push can close on the negative map.

## 2026-07-07 16:58 UTC - Decision Map Read-Only Review: PASS

- Ran a targeted `claude -p` read-only audit of commit `b8e2b51ff3`
  against `GUIDELINES.md`/`AGENTS.md`, `journal_narrative.md`, the
  push plan, and the touched decision-map docs.
- Verdict: PASS, no blockers. The review confirms quantitative accuracy,
  operator-fair constraints, correct stop-decision scoping, no PCN-style
  mechanism drift, and adequate documentation navigation.
- Recorded the review at `reviews/claude_post_n10_decision_map_20260707.md`.
  Applied its two non-blocking wording nits: note that N03b/N06 are
  context rows and explicitly mark N08 as blocked for lack of a winner
  pair to combine.

## 2026-07-07 17:10 UTC - Negative-Map Adversarial Validation: PASS

- Ran a stricter read-only adversarial validation of the exhausted-portfolio
  alternative outcome. The prompt required evidence-level inspection of the
  plan, goal template, journal narrative, follow-up decision map, central
  report, lane packages, P3 suite closures, operator contracts, and prior
  reviews.
- Verdict: PASS. The validator found no required fixes before the
  alternative outcome: no stronger natural QD/MAP-Elites extension than
  V2/N03b was found, and the operator-fair decision map is complete enough
  to guide the TCAD manuscript.
- Recorded the report at `negative_map_adversarial_validation_report.md`.
  Residual non-blocking paper decisions remain compact_8d stance and
  optional held-out confirmation. The raw `20260707_2005_code_logs.md`
  remains an untracked local restart transcript/source log, not a curated
  result artifact; leaving it uncommitted avoids adding a bulky raw
  transcript to the manuscript evidence tree.
- Added a short post-N10 addendum to the canonical
  `natural_qd_push_subagent_validation_report.md` so the goal template's
  named validation surface also records the exhausted-portfolio PASS.
