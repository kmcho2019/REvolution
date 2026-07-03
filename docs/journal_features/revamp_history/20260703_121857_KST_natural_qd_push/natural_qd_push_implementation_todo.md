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
- [ ] Pin the frozen 8-design screening manifest from
      `../20260622_010615_KST_useful_bd_push/preliminary_planning/`
      `20260625_encoder_config_screening/` into `tables/` here, with the
      classic seed-1001/1002/1003 run roots and recomputed metrics.
- [ ] Pin reusable classic baselines table (`tables/classic_baselines.csv`):
      8x5 screen, 6x7, full RTLLM seed-1001 and 5-seed, classic_no_cf.
- [ ] Pin the exact Smooth-QD V2 platform config (flags + descriptor
      profile) from doc 16 / journal-revamp evidence into
      `tables/v2_platform_config.md`; verify it runs on current code.
- [ ] Port `audit_operator_contract.py` into `scripts/` with tests;
      wire it into every comparison packaging step.
- [ ] Canonicalize HV-AUC in shared reporting; regression-test equality
      against stored 20260630 tables before first use.
- [ ] Add `scripts/validate_natural_qd_run.py` (operator contract, token
      budgets, seed, descriptor profile, archive config vs registration)
      plus `tests/scripts/test_validate_natural_qd_run.py`.
- [ ] Create `lanes/lane_registry.csv` and register N01-N08 with
      mechanism, knobs, gates (before any live run).
- [ ] Run V2 platform anchor on the 8-design screen, seed 1001; add seeds
      1002/1003 (expected within +-5% of classic); package per policy.

## P1 Single-Factor Screens (each: pre-register -> run -> package -> tier)

- [ ] N01 per-cell Pareto slots (slot count 1; then 2 as registered
      follow-up) at 8x5 seed 1001; replicate seeds per gate ladder.
- [ ] N02 Pareto-biased parent sampling (one weight knob; new code as a
      small module with focused tests) at 8x5 seed 1001; replicate.
- [ ] N03 archive parent lane fraction 0.10 and 0.30 at 8x5 seed 1001;
      replicate the better arm.
- [ ] N05 warmup initialization (fixed g0) at 8x5 seed 1001; replicate.
- [ ] Every P1 verdict records cause class + follow-up idea or retirement
      rationale in the lane package and history.

## P2 Shape And Follow-Ups

- [ ] N04 budget shape: current leader (or V2) at 6x7 vs matched classic
      6x7; register 4x11 (with new classic arm) only if 6x7 is positive.
- [ ] Registered follow-up variants from P1 diagnoses (stay within the
      Natural-Extension Criterion; single factor per variant).
- [ ] N06 descriptor bake-off only if N01-N03 stall (predeclared rule,
      random-descriptor control, collapse diagnostics).
- [ ] N07 corrected-suite completion screen (three never-rerun profiles),
      lowest priority.

## P3 Confirmation

- [ ] Pre-register the promotion arm (single-factor winner or N08
      combination) before seeing any full-suite result.
- [ ] Full RTLLM 46 ref-complete seed 1001; then seeds 1001-1005 vs reused
      classic 5-seed baselines; contract statistics; `ppa_completeness.csv`.
- [ ] Held-out gate per `journal_narrative.md` if the 5-seed read clears
      the screen bars.

## P4 Synthesis

- [ ] Central comparison report here (win or operator-fair negative map).
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
- [ ] Periodic `claude -p` review after every ~10 commits; findings filed.

## Commit Hygiene

- [x] Commit scaffold atomically (signed, message-verified).
- [ ] Commit per lane package / infra change; inspect stored message
      immediately (`git log --format=%B -n 1`).
