# T25 Guarded SR Raw Pareto QD Artifacts Manifest

Status: completed live development-screen run.

## Run Root

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

## Mirrored Result Artifacts

| Artifact | SHA-256 |
| --- | --- |
| `tables/preflight_models_20260621_210402_UTC.json` | `4db45ca0673b7478b25b0406642abdefb66ed7f609bb5632f95a387aba6aeef6` |
| `tables/live_guarded_pareto_validation.json` | `d62f3f38d4ca4b7e28fe7f558491fdfa5fd9bb6b349db4e3dbcbdb97cdf6d0cc` |
| `tables/live_guarded_pareto_validation.md` | `80b1dc7ee0abedf5b053cb5021ce0ddea1eaa6525f939865d72e3a4d98647386` |
| `tables/live_guarded_vs_t24_controls.csv` | `532b3339f752a4486ad030cbf9121bb66008cb34800cc96a9475a213e1fa053e` |
| `figures/live_guarded_vs_t24_controls.png` | `9f834330c9de3ff29c9faebd341f7904f57df95773a74c5e060b208812c468eb` |

## Source Run Artifacts

- run log:
  `exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/guarded_sr_raw_pareto_qd/seed_1001/openai_gpt-oss-120b/20260621_210908_revolution_run_log.txt`
- summary results:
  `exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/guarded_sr_raw_pareto_qd/seed_1001/openai_gpt-oss-120b/20260621_210908_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/guarded_sr_raw_pareto_qd/seed_1001/openai_gpt-oss-120b/20260621_210908_revolution_scheduler_telemetry.json`

## Validation Status

- vLLM preflight passed: `openai/gpt-oss-120b`, `max_model_len=131072`.
- Pareto validation passed: zero failures, max local front size 2.
- Result decision: `T0 diagnostic`, not promoted.
