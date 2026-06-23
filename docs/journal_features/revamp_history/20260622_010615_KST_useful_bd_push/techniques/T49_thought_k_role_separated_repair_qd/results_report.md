# T49 Results Report

Status: seed `1001` live run in progress; no tier assigned yet.

T49 is pre-registered as a T48 follow-up. Seed `1001` has been launched on the
hard/tuning comparator surface, but it has not been packaged, compared, or
tiered.

## Pre-Registered Claim

The method will test whether thought-level role separation and bounded
sample-local repair can improve the T47/T48 hard/tuning contract without using
PPA, pass rate, or front labels as behavior-descriptor inputs.

## Current Tier

`running_seed_1001`

## Live Run Audit

- Run root:
  `exp/useful_bd_push/t49_thought_k_role_separated_repair_20260623_003408_UTC/hard_tuning`
- vLLM preflight accepted `openai/gpt-oss-120b` with
  `max_model_len=131072`.
- The launch uses the pre-registered T49 settings from
  `commands/hard_tuning_sanity.md`.
- First checkpoint: `11/13` problem-level `qd_metrics.json` files were present.
  Do not infer quality from this partial state.

## Required Before Tiering

- Run at least seed `1001` with the command in
  `commands/hard_tuning_sanity.md`.
- Package matched classic/T48/T49 metrics.
- Inspect direct raw area-power PPA-front figures.
- Record repair attempts and repaired-candidate contribution.
- Export the Phase 03.1 viewer when archive artifacts are usable.
- Assign `T0`, `T1`, `T2`, or `T3` without overclaiming.
