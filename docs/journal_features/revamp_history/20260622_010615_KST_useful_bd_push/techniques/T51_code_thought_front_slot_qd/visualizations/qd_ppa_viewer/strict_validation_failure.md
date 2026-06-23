# T51 Strict Viewer Validation Failure

Command:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T51_code_thought_front_slot_qd/visualizations/qd_ppa_viewer \
  --strict
```

Result: failed because classic candidates have no honest `sr_pca_0/1/2`
archive projection. Each classic problem reports projection coverage `0.000`.

The non-strict validator passes. Use the viewer for T51 archive inspection and
paired PPA/front browsing, not for classic archive occupancy claims.
