# Seed 1003 And Rollup Checkpoint

Status: completed, validated, and packaged.

## Preflight

- Endpoint: `http://20.0.0.103:8000/v1/models`
- Model: `openai/gpt-oss-120b`
- `max_model_len`: `131072`
- Required context: `128000`

## Run Root

`exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live`

## Completed Arms

| Arm | Seed | Runtime | Completion |
| --- | ---: | ---: | --- |
| `classic_revolution_8x5` | `1003` | `1250.73s` | `8/8` problem summaries |
| `masterrtl_aux_archive_high_exploit_8x5` | `1003` | `1556.29s` | `8/8` problem summaries |

## Validators

The focused validators passed on the completed seed-replication run root:

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live \
  --classic-mode classic_revolution_8x5 \
  --pareto-qd-mode masterrtl_aux_archive_high_exploit_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live \
  --classic-mode masterrtl_aux_archive_high_exploit_8x5 \
  --eoh-mode masterrtl_aux_archive_high_exploit_8x5 \
  --unified-mode masterrtl_aux_archive_high_exploit_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

## Final Analysis

Final analysis completed with no skipped sections:

`exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live/final_analysis_seed_replication`

The package-local rollup script wrote:

- `tables/seed_pair_metrics.csv`
- `tables/seed_pair_robustness.csv`
- `tables/problem_seed_deltas.csv`
- `tables/rollup_summary.json`
- `figures/seed_hv_pairs.png`
- `figures/seed_hv_delta_robustness.png`
- `figures/problem_mean_hv_delta.png`
- `seed_replication_rollup_report.md`

## Decision

Fixed high-exploit auxiliary archive is diagnostic negative and not promoted.
