# T53 Phase 03.1 QD/PPA Viewer

This is the full linked archive/PPA viewer for T53 seed `1001`.

- `index.html`: Phase 03.1 viewer.
- `manifest.json`: viewer manifest.
- `datasets/`: one dataset per hard/tuning problem.
- `validation.json`: latest non-strict validation status.
- `screenshot.png`: representative compare-mode screenshot.
- `screenshots/`: Playwright screenshot set from the validation run.
- `strict_validation_failure.md`: strict validation caveat.
- `playwright_hover_caveat.md`: Playwright hover-clear caveat.

Generation command:

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run code_thought_sparse_front_trigger_qd=exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/hard_tuning/code_thought_sparse_front_trigger_qd/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T53_sparse_front_trigger_qd/tables/hard_tuning_subset.yaml \
  --output-dir exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/qd_ppa_viewer_source/final_analysis

uv run python scripts/export_qd_ppa_visualization.py \
  --run-root exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/qd_ppa_viewer_source \
  --backend_run classic=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run code_thought_sparse_front_trigger_qd=exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/hard_tuning/code_thought_sparse_front_trigger_qd/seed_1001 \
  --archive_source_backend code_thought_sparse_front_trigger_qd \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T53_sparse_front_trigger_qd/tables/hard_tuning_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T53_sparse_front_trigger_qd/visualizations/qd_ppa_viewer \
  --strict \
  --no-classic-descriptor-recovery
```

Validation:

- Non-strict validator: `PASS`.
- Playwright screenshots: generated, with a hover-clear caveat.
- Strict validator: `FAIL`, because classic candidates have no honest
  `sr_pca_0/1/2` projection and therefore have `0.000` archive projection
  coverage.

Use this viewer for T53 archive inspection and paired PPA/front browsing. Do
not use it as evidence of classic archive-cell occupancy.
