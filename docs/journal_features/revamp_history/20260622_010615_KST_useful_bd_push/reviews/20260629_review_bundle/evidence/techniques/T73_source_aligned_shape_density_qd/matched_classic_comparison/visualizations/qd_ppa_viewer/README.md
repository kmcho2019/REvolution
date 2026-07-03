# T73 Phase 03.1 QD/PPA Viewer

This is the full linked archive/PPA viewer for the matched classic versus T73
hard/tuning comparison, seed `1001`.

- `index.html`: Phase 03.1 viewer.
- `manifest.json`: viewer manifest.
- `datasets/`: one dataset per hard/tuning problem.
- `descriptor_cache.json`: descriptor projection cache.
- `validation.json`: latest strict structural validation status.
- `validation.md`: human-readable validation summary.
- `screenshot.png`: representative compare-mode screenshot.
- `playwright_caveat.md`: browser-interaction validation caveat.

Generation command:

```bash
uv run python scripts/export_qd_ppa_visualization.py \
  --run-root exp/useful_bd_push/t73_matched_classic_comparison_20260624_001300_UTC \
  --backend_run classic_revolution=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run source_aligned_shape_density_qd=exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning/source_aligned_shape_density_qd/seed_1001 \
  --archive_source_backend source_aligned_shape_density_qd \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T73_source_aligned_shape_density_qd/matched_classic_comparison/visualizations/qd_ppa_viewer \
  --strict
```

Validation:

- Strict non-Playwright validator: `PASS`.
- Browser screenshot rendered nonblank in manual inspection.
- Playwright interaction validator: `FAIL` on archive hover bridge checks.
  See `playwright_caveat.md`.

Classic candidates are included in the PPA compare pane. Do not claim classic
archive coverage from this viewer: T73 archive cells are native to the QD run,
and classic candidates are not used as evidence of T73 archive occupancy.
