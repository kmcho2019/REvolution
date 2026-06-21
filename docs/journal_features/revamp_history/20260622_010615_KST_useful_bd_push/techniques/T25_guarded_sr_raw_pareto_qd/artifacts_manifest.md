# T25 Guarded SR Raw Pareto QD Artifacts Manifest

Status: planned, not yet run.

## Pre-Registered Run Root

`exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/`

## Fixed Inputs

- branch: `feat/journal-useful-bd-exp-20260622`
- seed: `1001`
- population size: `12`
- generations: `3`
- model: `openai/gpt-oss-120b`
- endpoint: `20.0.0.103:8000`
- `max_tokens`: `128000`
- `diff_max_tokens`: `128000`
- `vllm_min_model_len`: `128000`
- temperature: `1.0`
- top_p: `1.0`
- evaluation mode: `strict_ablation`
- descriptor: frozen SR raw PCA descriptor profile
- scheduler guard:
  - `qd_fill_target_fraction=0.10`
  - `qd_improve_backfill_fraction=0.05`
  - `qd_two_parent_probability=0.25`
  - `qd_champion_lane_fraction=0.50`

## Command Artifacts

- command reference: `commands/live_screen_v0.md`
- run matrix: `tables/run_matrix.csv`
- subset config: `tables/live_screen_v0_subset.yaml`

## Expected Mirrors

After execution, mirror the following into `tables/`:

- preflight `/v1/models` JSON;
- Pareto validation JSON and Markdown;
- comparison CSV against T24 classic/manual/random/SR raw.

## Missing Results

All live result artifacts are missing because T25 has not run yet.
