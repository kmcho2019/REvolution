# T48 Phase 03.1 QD/PPA Viewer

This is the full linked archive/PPA viewer for T48 seed `1002`.

- `index.html`: Phase 03.1 viewer.
- `manifest.json`: viewer manifest.
- `datasets/`: one dataset per hard/tuning problem.
- `validation.json`: latest validation status.
- `screenshot.png`: manual reference screenshot.

Generation command:

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1002 \
  --backend_run t26_gated_near_front_fusion_qd=exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning/t26_gated_near_front_fusion_qd/seed_1002 \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --output-dir exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/qd_ppa_viewer_source/final_analysis

uv run python scripts/export_qd_ppa_visualization.py \
  --run-root exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/qd_ppa_viewer_source \
  --backend_run classic=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1002 \
  --backend_run t26_gated_near_front_fusion_qd=exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning/t26_gated_near_front_fusion_qd/seed_1002 \
  --archive_source_backend t26_gated_near_front_fusion_qd \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T48_t26_gated_near_front_fusion_qd/visualizations/qd_ppa_viewer \
  --strict \
  --no-classic-descriptor-recovery
```

Validation:

- Non-strict validator: `PASS`.
- Strict validator: `FAIL`, because classic candidates have no honest
  `sr_pca_0/1/2` projection and therefore have `0.000` archive projection
  coverage.
- Playwright smoke: `FAIL` on the archive-hover check after the same
  projection limitation, but screenshots show the viewer renders and compare
  mode works.

Do not use this viewer as evidence of classic-vs-QD archive-cell occupancy.
Use it for QD archive inspection and paired PPA/front browsing.
