# Validation Log

## Live Run

- Command:
  `commands/run_rf_leafid_front_slot_delayed.md`
- Run root:
  `exp/useful_bd_push/prelim_rf_leafid_front_slot_delayed_20260626_062400_UTC/live/`
- Runtime:
  `1651.69` seconds
- Completed problems:
  `8/8`

## Validators

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/prelim_rf_leafid_front_slot_delayed_20260626_062400_UTC/live \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --pareto-qd-mode masterrtl_rf_leafid_front_slot_delayed_8x5/seed_1001/openai_gpt-oss-120b
```

Result: passed.

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/prelim_rf_leafid_front_slot_delayed_20260626_062400_UTC/live \
  --classic-mode masterrtl_rf_leafid_front_slot_delayed_8x5 \
  --eoh-mode masterrtl_rf_leafid_front_slot_delayed_8x5 \
  --unified-mode masterrtl_rf_leafid_front_slot_delayed_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

Result: passed.

## Pareto Analysis

```bash
uv run python scripts/report_pareto_analysis.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run masterrtl_rf_leafid_front_slot_delayed_8x5=exp/useful_bd_push/prelim_rf_leafid_front_slot_delayed_20260626_062400_UTC/live/masterrtl_rf_leafid_front_slot_delayed_8x5/seed_1001 \
  --backend_run masterrtl_rf_leafid_structural_delayed_8x5=exp/useful_bd_push/prelim_rf_leafid_structural_delayed_20260626_052350_UTC/live/masterrtl_rf_leafid_structural_delayed_8x5/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_leafid_front_slot_delayed_probe/analysis/pareto_analysis
```

Result: completed.

## Derived Package

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_leafid_front_slot_delayed_probe/tools/package_t84_results.py
```

Result: completed.

## Visual Inspection

Inspected:

- `figures/rf_leafid_front_slot_delayed_summary.png`

The summary figure is presentation-readable and clearly communicates that T84
loses mean HV and has no positive per-problem HV deltas versus classic.
