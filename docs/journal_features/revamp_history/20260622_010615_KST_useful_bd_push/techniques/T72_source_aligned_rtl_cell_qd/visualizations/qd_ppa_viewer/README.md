# T72 Phase 03.1 QD/PPA Viewer

This is the full linked archive/PPA viewer for the fixed T72 hard/tuning
screen, seed `1001`.

- `index.html`: Phase 03.1 viewer.
- `manifest.json`: viewer manifest.
- `datasets/`: one dataset per hard/tuning problem.
- `descriptor_cache.json`: descriptor projection cache.
- `validation.json`: latest strict structural validation status.
- `validation.md`: human-readable validation summary.
- `screenshot.png`: representative raw area-power viewer screenshot.
- `playwright_caveat.md`: browser-validation caveat.

Generation command:

```bash
uv run python scripts/export_qd_ppa_visualization.py \
  --run-root exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC/hard_tuning \
  --backend_run source_aligned_rtl_cell_qd=exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC/hard_tuning/source_aligned_rtl_cell_qd \
  --archive_source_backend source_aligned_rtl_cell_qd \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/visualizations/qd_ppa_viewer \
  --strict
```

Validation:

- Strict non-Playwright validator: `PASS`.
- Browser screenshots rendered nonblank in manual inspection.
- Full Playwright validation: `FAIL`, because this is a single-method T72
  viewer and the scripted compare check expects a `classic` technique. See
  `playwright_caveat.md`.

Use this viewer for T72 archive/PPA inspection. Do not use it as a
classic-vs-QD comparison artifact.
