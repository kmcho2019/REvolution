# Run Checkpoint

Status: completed, validated, and analyzed for decision metrics.

## Preflight

- Endpoint: `http://20.0.0.103:8000/v1/models`
- Model: `openai/gpt-oss-120b`
- `max_model_len`: `131072`
- Required context: `128000`
- Workspace storage before launch: `90%` used, `2.9T` available.

## Run

- Run root:
  `exp/useful_bd_push/prelim_adaptive_sparse_front_20260626_013437_UTC/live`
- Arm:
  `masterrtl_aux_archive_adaptive_sparse_front_8x5/seed_1001`
- Completion: `8/8` problems.
- Runtime: `1569.92s`.

## Validators

Both focused validators passed:

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/prelim_adaptive_sparse_front_20260626_013437_UTC/live \
  --classic-mode masterrtl_aux_archive_adaptive_sparse_front_8x5 \
  --pareto-qd-mode masterrtl_aux_archive_adaptive_sparse_front_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/prelim_adaptive_sparse_front_20260626_013437_UTC/live \
  --classic-mode masterrtl_aux_archive_adaptive_sparse_front_8x5 \
  --eoh-mode masterrtl_aux_archive_adaptive_sparse_front_8x5 \
  --unified-mode masterrtl_aux_archive_adaptive_sparse_front_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

## Analysis

Decision sections completed under:

`exp/useful_bd_push/prelim_adaptive_sparse_front_20260626_013437_UTC/live/final_analysis_with_adaptive_sparse_front`

Completed sections:

- `backend_comparison.md`
- `hard_iteration_analysis/`
- `pareto_analysis/`
- `evolutionary_reports/`
- `ppa_distribution/`

The final-analysis command was interrupted during
`report_design_space_analysis.py` source-aligned feature recovery after the
decision sections above were written. The traceback showed it was waiting in
MasterRTL subprocess recovery through
`source_aligned_descriptor_evaluator.py`. Do not use this package for
design-space feature claims; use it only for the completed Pareto/PPA decision
metrics.
