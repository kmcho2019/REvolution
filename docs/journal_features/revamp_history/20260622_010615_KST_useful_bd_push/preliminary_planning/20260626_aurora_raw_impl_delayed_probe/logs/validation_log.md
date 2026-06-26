# T99 Validation Log

## vLLM Preflight

Endpoint:

```text
http://20.0.0.103:8000/v1/models
```

Observed model: `openai/gpt-oss-120b`

Observed `max_model_len`: `131072`

## Live Run

Run root:

```text
exp/useful_bd_push/prelim_aurora_raw_impl_delayed_20260626/live/aurora_raw_impl_compact_delayed_8x5/seed_1001/openai_gpt-oss-120b
```

The run completed all eight frozen preliminary problems in `1546.09` seconds.

## Validators

Passed:

```text
uv run python scripts/validate_pareto_front_run.py
uv run python scripts/validate_single_thought_operator_run.py
uv run python scripts/validate_qd_ppa_visualization.py --strict
```

Reports generated:

```text
scripts/report_pareto_analysis.py
scripts/report_ppa_distribution.py
scripts/report_ppa_completeness.py
scripts/export_qd_ppa_visualization.py
```

The first viewer export attempt used a run-root without
`final_analysis/ppa_distribution/data` inputs. The export was rerun with the
generated candidate and reference PPA CSVs staged for the exporter, and strict
validation then passed. The retained regeneration inputs are the CSVs in
`analysis/ppa_distribution/data/`.

The viewer was regenerated again after fixing classic-like backend descriptor
recovery for names such as `classic_revolution_8x5`. The regenerated datasets
project all classic valid-PPA samples into the T99 archive space:

```text
classic projected samples: 191 / 191
descriptor cache entries: 191
```

Strict validation passed after regeneration:

```text
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_aurora_raw_impl_delayed_probe/visualizations/qd_ppa_viewer \
  --strict
```

The common table exporter was rerun after adding
`tables/method_seed_summary.csv`. The aggregate row reports T99 mean HV
`0.120094`, classic mean HV `0.140740`, and T99 mean HV delta `-0.020646`.

## Completeness Gate

All eight problems are headline-comparable because both backends have valid
candidate PPA and every problem has valid reference PPA. `Prob045_alu` is
flagged as a T99 yield warning because T99 has `9` valid-PPA rows versus
classic's `36`.
