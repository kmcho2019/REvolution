# Natural QD Push TODO

Hard cap: 200 lines. Keep active unchecked work near the top; move detail
and completed-batch narratives to
`natural_qd_push_implementation_history.md`. When the cap is near, compress
finished sections into one summary line each.

Central plan: `natural_qd_push_plan.md`.
Adversarial rubric: `natural_qd_push_adversarial_prompt.md`.

## P0 Foundations

- [x] Create branch `feat/journal-qd-bd-exp-20260703` and this scaffold.
- [x] Preflight `http://20.0.0.103:8000/v1/models`
      (`openai/gpt-oss-120b`, `max_model_len=131072`, 2026-07-03).
- [x] Pin the frozen 8-design screening manifest into
      `tables/screen_manifest.csv` (source: June-25 encoder screening
      package; classic seed-1001/1002/1003 run roots verified on disk).
- [x] Pin reusable classic baselines (`tables/classic_baselines.csv`):
      8x5 screen (seeds 1001-1003), 6x7, full RTLLM seed-1001 and 5-seed,
      classic_no_cf. Screen rows recompute-verified exactly (P0 anchor +
      replication packages); 6x7 and full-RTLLM rows verify when first
      used.
- [x] Pin the exact Smooth-QD V2 platform config into
      `tables/v2_platform_config.md` (reconstructed from doc 16 +
      consolidated record; original launchers gone from exp/). Runtime
      verification happens with the P0 anchor run.
- [x] Port `audit_operator_contract.py` into `scripts/` with tests
      (commit 47b6906bf6); sanity-reproduced the 20260630 all-pass audit
      and added an `other_strategy_count` column (M-T visibility).
- [x] Canonicalize HV-AUC in shared reporting (commit b5371925ff):
      `revolution.qd.pareto_analysis.{cumulative_hypervolume_curve,
      hypervolume_auc}` + `scripts/report_hv_auc.py`; regression equality
      vs stored 20260630 tables (1e-9) tested.
- [x] Add `scripts/validate_natural_qd_run.py` + tests (commit
      03e3c48475): manifest agreement, strategy contract (M-T allowed for
      QD arms per the 20260630 precedent, forbidden for classic), QD
      artifact presence per arm.
- [x] Create `lanes/lane_registry.csv` with N01-N08 draft registrations
      (full pre-registration cards still required before each live run).
- [x] Run V2 platform anchor on the 8-design screen, seeds 1001-1003;
      package per policy. Outcome: V2 beats classic 3/3 seeds — 3-seed
      mean HV +12.9%, HV-AUC +16.2%, coverage 8/8 everywhere; all
      operator/validation gates green (`p0_v2_anchor/`). Promotion-arm
      rule registered before P1 reads.

## P1 Single-Factor Screens (each: pre-register -> run -> package -> tier)

- [x] N01 cell-retention mode. Outcome: diagnostic keepers — the
      retention ladder (classic 0.14064 -> scalar 0.14683 -> slot-2
      0.15709 -> V2 0.17376, single-seed, softened per review); no
      challenger to V2 (`lanes/N01_cell_retention_mode/`).
- [x] N02 curiosity sampling. Outcome: HARD-GATE KILL at gamma 1.0
      (gshare coverage lost; exploration tax); engine stays; gamma-0.5
      retry registered at low priority
      (`lanes/N02_curiosity_sampling/results_report.md`).
- [x] N03 archive parent lane. Outcome: N03a closed; N03b screen
      displacement failed at 3 seeds (98.9% of V2) but is the best QD
      arm at suite scale (96.9% HV, best AUC 102.5% of classic) and
      the Branch-B utility candidate
      (`lanes/N03_archive_parent_lane/`, `p3_full_rtllm/p3b_closure.md`).
- [x] N05 warmup length (4 and 16 vs platform 8) at 8x5 seed 1001.
      Outcome: RETIRED per its registered rule — both directions lose
      HV vs V2 (-14.1% / -5.7%) with coverage unaffected; recorded as
      a positive tuning validation of warmup 8
      (`lanes/N05_warmup_init/results_report.md`).
- [ ] Fix the pairwise-front figure title/legend collision in the
      shared plotting surface before any colleague-facing package.
- [ ] Every P1 verdict records cause class + follow-up idea or retirement
      rationale in the lane package and history.

## P2 Shape And Follow-Ups

- [ ] N04 budget shape: current leader (or V2) at 6x7 vs matched classic
      6x7; register 4x11 (with new classic arm) only if 6x7 is positive.
- [ ] Registered follow-up variants from P1 diagnoses (stay within the
      Natural-Extension Criterion; single factor per variant).
- [x] N06 descriptor bake-off, both scales COMPLETE (screen wave 1 +
      P3c suite sweep). Outcome: trio wins screen HV; two suite tiers;
      coverage is uniquely semantic (random-floor falsification held);
      compact_8d ties trio HV with ~4x collapse resistance —
      health-grounds swap candidate (`lanes/N06_descriptor_bakeoff/
      bd_scoreboard.md`, `p3_full_rtllm/p3c_closure.md`).
- [ ] N07 corrected-suite completion screen (three never-rerun profiles),
      lowest priority.

## P3 Confirmation

- [x] Pre-register the promotion arm before seeing any full-suite
      result. Evidence: rule in `p0_v2_anchor/results_report.md`
      (2026-07-03, before P1 reads); applied in
      `p3_full_rtllm/commands.md` after N03b's displacement failed.
- [x] Full RTLLM 46 ref-complete, seeds 1001-1005 vs reused classic
      baselines. Outcome: `p3_full_rtllm/five_seed_verdict.md` — HV
      95.2%, AUC 100.5%, coverage 166 vs 164; +5% gate fails; two-scale
      story is the finding. P3b variant probes: gt3d killed at the
      2-seed gate (coverage datum kept); N03b ladder completing.
- [x] Run the CANONICAL `report_journal_statistics.py` contract
      statistics over the P3 packages. Outcome:
      `p3_full_rtllm/canonical_statistics/` — HV parity confirmed
      (+0.0035, CI [-0.0089,+0.0210]); functionality edge canonical
      (functional_any_pass +0.020, 8W/3L); 50-problem-scoped
      complement to the 46-scoped verdict (read_note.md).
- [x] Held-out gate per `journal_narrative.md` — scoped out: not
      triggered (the 5-seed suite read did not clear the +5% gate);
      recorded in the central report's branch mapping with
      `p3_full_rtllm/five_seed_verdict.md` as evidence.

## P4 Synthesis

- [x] Central comparison report (`central_comparison_report.md`):
      two-scale verdict, finding set, branch mapping (strong
      characterization; both Branch-C floor legs met plus the
      positive), answered/unanswered/TCAD-strength.
- [ ] Refresh `docs/journal_features/13_findings_dashboard.md` tables and
      add a closure note to the June-22 `technique_lineage_ledger.md`.
- [ ] Run adversarial validation; PASS recorded in
      `natural_qd_push_subagent_validation_report.md`.

## Standing Validation (every code/report change)

- [ ] Focused pytest for touched modules/scripts.
- [ ] `ruff check` on touched files; `python -m pyright` on touched source.
- [ ] `git diff --check`; no imports from untracked dirs.
- [ ] vLLM preflight recorded before each live batch; 128k token budgets;
      blocked runs logged explicitly.
- [ ] Periodic `claude -p` review after every ~10 commits; findings
      filed. For second opinions, also run
      `codex --yolo exec "Requesting READ-ONLY review of <scope>
      following GUIDELINES.md and the push plan ..."` and record the
      output under `reviews/` (user-adopted practice 2026-07-03;
      prompts must state read-only and demand a PASS/FAIL verdict
      with numbered actions).
- [x] Hourly watch armed (user-adopted 2026-07-04, session-scoped
      persistent monitor): per-cycle progress snapshot (chain state,
      live frames, failure count, stall fingerprinting) plus a gated
      codex read-only review (on new commits, chain completion, or
      every 3rd cycle) checking progress, direction vs the registered
      protocols, and GUIDELINES organization; verdicts filed under
      `reviews/hourly_watch/`. Re-arm after any session restart.

## Commit Hygiene

- [x] Commit scaffold atomically (signed, message-verified).
- [ ] Commit per lane package / infra change; inspect stored message
      immediately (`git log --format=%B -n 1`).
