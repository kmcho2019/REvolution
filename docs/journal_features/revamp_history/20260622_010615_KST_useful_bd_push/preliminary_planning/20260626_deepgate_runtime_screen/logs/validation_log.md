# T94 Validation Log

## Live Run

- Run root:
  `exp/useful_bd_push/prelim_deepgate_runtime_screen_20260626_113100_UTC/live/deepgate_pooled_pc3_8x5/seed_1001/openai_gpt-oss-120b`
- Completed problems: `8/8`
- Budget: `8x5`
- Seed: `1001`
- Model: `openai/gpt-oss-120b`
- Endpoint preflight: passed, `max_model_len=131072`

## Validators

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/prelim_deepgate_runtime_screen_20260626_113100_UTC/live \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --pareto-qd-mode deepgate_pooled_pc3_8x5/seed_1001/openai_gpt-oss-120b
```

Result: passed.

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/prelim_deepgate_runtime_screen_20260626_113100_UTC/live \
  --classic-mode deepgate_pooled_pc3_8x5 \
  --eoh-mode deepgate_pooled_pc3_8x5 \
  --unified-mode deepgate_pooled_pc3_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

Result: passed.

## Completeness

`analysis/ppa_completeness.csv` marks all eight problems as `headline`.

That means:

- classic has at least one valid-PPA candidate on every screen problem;
- DeepGate has at least one valid-PPA candidate on every screen problem;
- every screen problem has valid reference PPA;
- no headline aggregate uses defaulted or missing reference PPA.

## Analysis Outputs

- Pareto analysis:
  `analysis/pareto_analysis/report.md`
- PPA distribution:
  `analysis/ppa_distribution/report.md`
- Completeness:
  `analysis/ppa_completeness.csv`
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`
- Direct PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`

## Viewer Validation

Strict non-Playwright viewer validation passed:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_screen/visualizations/qd_ppa_viewer \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --strict
```

Playwright rendered screenshots, but its scripted smoke returned extra
assertions because the comparison check expected a technique named `classic`
and one archive-hover check could not find an occupied target. The inspected
compare screenshot is nonblank and kept as
`visualizations/qd_ppa_viewer/screenshot.png`.

## Result Classification

`T0_screened_negative_not_promoted`.

The run is valid evidence for the DeepGate category, but the exact
`deepgate_pooled_pc3_8x5` arm trails classic on aggregate HV, Pareto breadth,
and reference-beating candidates.
