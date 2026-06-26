# Validation Log

## Preflight

- First seed run preflight:
  `openai/gpt-oss-120b`, `max_model_len=131072`.
- Second seed run preflight:
  `openai/gpt-oss-120b`, `max_model_len=131072`.
- Storage after seed `1003`:
  `/workspace` had `2.7T` free at `90%` use.

## Live Runs

| Seed | Completed | Runtime |
| --- | --- | ---: |
| `1002` | `8/8` problems | `1471.93` seconds |
| `1003` | `8/8` problems | `1531.95` seconds |

## Validators

Seed `1002`:

```bash
PYTHONPATH=src uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/prelim_rf_leafid_seed_robustness_20260626_UTC/live \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --pareto-qd-mode masterrtl_rf_leafid_structural_delayed_8x5/seed_1002/openai_gpt-oss-120b
```

Result: passed.

```bash
PYTHONPATH=src uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/prelim_rf_leafid_seed_robustness_20260626_UTC/live \
  --classic-mode masterrtl_rf_leafid_structural_delayed_8x5 \
  --eoh-mode masterrtl_rf_leafid_structural_delayed_8x5 \
  --unified-mode masterrtl_rf_leafid_structural_delayed_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

Result: passed.

Seed `1003`:

```bash
PYTHONPATH=src uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/prelim_rf_leafid_seed_robustness_20260626_UTC/live \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --pareto-qd-mode masterrtl_rf_leafid_structural_delayed_8x5/seed_1003/openai_gpt-oss-120b
```

Result: passed.

```bash
PYTHONPATH=src uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/prelim_rf_leafid_seed_robustness_20260626_UTC/live \
  --classic-mode masterrtl_rf_leafid_structural_delayed_8x5 \
  --eoh-mode masterrtl_rf_leafid_structural_delayed_8x5 \
  --unified-mode masterrtl_rf_leafid_structural_delayed_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

Result: passed.

## Packaging

```bash
PYTHONPATH=src uv run python scripts/report_pareto_analysis.py \
  --backend_run classic_s1001=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run t83_s1001=exp/useful_bd_push/prelim_rf_leafid_structural_delayed_20260626_052350_UTC/live/masterrtl_rf_leafid_structural_delayed_8x5/seed_1001 \
  --backend_run classic_s1002=exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live/classic_revolution_8x5/seed_1002 \
  --backend_run t83_s1002=exp/useful_bd_push/prelim_rf_leafid_seed_robustness_20260626_UTC/live/masterrtl_rf_leafid_structural_delayed_8x5/seed_1002 \
  --backend_run classic_s1003=exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live/classic_revolution_8x5/seed_1003 \
  --backend_run t83_s1003=exp/useful_bd_push/prelim_rf_leafid_seed_robustness_20260626_UTC/live/masterrtl_rf_leafid_structural_delayed_8x5/seed_1003 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_leafid_seed_robustness_gate/analysis/pareto_analysis
```

Result: completed.

```bash
uv run ruff check docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_leafid_seed_robustness_gate/tools/package_t88_results.py
PYTHONPATH=src uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_leafid_seed_robustness_gate/tools/package_t88_results.py
```

Result: completed.
