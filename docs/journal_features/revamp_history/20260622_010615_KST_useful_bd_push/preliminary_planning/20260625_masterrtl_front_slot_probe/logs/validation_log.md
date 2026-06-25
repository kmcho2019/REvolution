# Validation Log

## Live Run

- Completed all `8/8` frozen-screen problems.
- Wrote run-level summary:
  `20260625_191459_revolution_summary_results.txt`.
- Wrote scheduler telemetry:
  `20260625_191459_revolution_scheduler_telemetry.json`.

## Validators

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live \
  --classic-mode classic_revolution_8x5 \
  --pareto-qd-mode masterrtl_structural_front_slot_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

Result: pass.

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live \
  --classic-mode masterrtl_structural_front_slot_8x5 \
  --eoh-mode masterrtl_structural_front_slot_8x5 \
  --unified-mode masterrtl_structural_front_slot_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

Result: pass.

## Figure Inspection

- `figures/mean_hv_by_backend.png`: readable; makes classic's aggregate HV
  lead clear.
- `figures/masterrtl_front_slot_hv_delta.png`: readable; the main losses on
  `Prob041_traffic_light`, `Prob045_alu`, and `Prob049_signal_generator` are
  clear.

## Reporting Caveat

`scripts/report_final_analysis_bundle.py` was interrupted with `KeyboardInterrupt`
during `source_aligned_descriptor_evaluator.py` subprocess recovery for
design-space feature plotting. This does not affect the completed
`pareto_analysis/`, `ppa_distribution/`, or `evolutionary_reports/` outputs
used by this package.
