# T100 Validation Log

## Runtime

The live smoke completed under:

```text
exp/useful_bd_push/front_credit_rf_leafid_fg_qdm_20260626/
```

The vLLM preflight returned `openai/gpt-oss-120b` with
`max_model_len=131072`.

## Checks

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/front_credit_rf_leafid_fg_qdm_20260626 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/tables/smoke_subset.yaml \
  --pareto-qd-mode fg_qdm_rf_leafid_front_credit_12x3/seed_1001/openai_gpt-oss-120b
```

Result: passed.

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/front_credit_rf_leafid_fg_qdm_20260626 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/tables/smoke_subset.yaml \
  --classic-mode fg_qdm_rf_leafid_front_credit_12x3 \
  --eoh-mode fg_qdm_rf_leafid_front_credit_12x3 \
  --unified-mode fg_qdm_rf_leafid_front_credit_12x3
```

Result: passed.

```bash
uv run python scripts/report_ppa_distribution.py ...
uv run python scripts/report_pareto_analysis.py ...
```

Result: completed. The PPA distribution report contains `207` valid-PPA
candidate rows and no warnings.

```bash
uv run python scripts/report_ppa_completeness.py ...
uv run python scripts/report_common_evaluation_contract.py ...
```

Result: completed. The common summary records T100 mean HV `0.156553`,
classic mean HV `0.190331`, and T100 classic-delta mean HV `-0.033777`.
All three smoke problems are `headline` and have `pass` valid-PPA yield
status.

```bash
uv run python scripts/export_qd_ppa_visualization.py \
  --strict \
  --no-classic-descriptor-recovery ...
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T100_front_credit_rf_leafid_fg_qdm_memory/visualizations/qd_ppa_viewer \
  --strict
```

Result: passed.

## Browser Caveat

`validate_qd_ppa_visualization.py --playwright` did not pass. The failure is
expected for this T100 package because:

- classic RF leaf-ID archive projection is intentionally disabled; and
- the strict browser suite expects canonical validation problems that are not
  in this three-problem smoke subset.

A manual Playwright screenshot was captured at
`techniques/T100_front_credit_rf_leafid_fg_qdm_memory/visualizations/qd_ppa_viewer/screenshot.png`.
