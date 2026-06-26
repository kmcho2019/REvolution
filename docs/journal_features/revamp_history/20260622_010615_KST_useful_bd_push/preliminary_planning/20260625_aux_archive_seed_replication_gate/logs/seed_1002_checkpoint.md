# Seed 1002 Checkpoint

Status: completed and focused validators passed.

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
| `classic_revolution_8x5` | `1002` | `1294.24s` | `8/8` problem summaries |
| `masterrtl_aux_archive_high_exploit_8x5` | `1002` | `1485.76s` | `8/8` problem summaries |

## Validators

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live \
  --classic-mode classic_revolution_8x5 \
  --pareto-qd-mode masterrtl_aux_archive_high_exploit_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

Result: passed.

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live \
  --classic-mode masterrtl_aux_archive_high_exploit_8x5 \
  --eoh-mode masterrtl_aux_archive_high_exploit_8x5 \
  --unified-mode masterrtl_aux_archive_high_exploit_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

Result: passed.

## Next

Run the same two arms with seed `1003`, then package the three-seed rollup with
seed `1001` reused from the existing preliminary screen.
