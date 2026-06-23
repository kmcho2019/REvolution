# T53 Strict Phase 03.1 Validation Failure

Strict validation was run with:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T53_sparse_front_trigger_qd/visualizations/qd_ppa_viewer \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T53_sparse_front_trigger_qd/tables/hard_tuning_subset.yaml \
  --strict
```

It failed because classic candidates do not have honest `sr_pca_0/1/2`
descriptor coordinates in this archive. Projection coverage is `0.000` for the
classic arm on the listed problems. This matches the T51 and T52 caveat.

The non-strict validator passes. Use the viewer for T53 archive inspection and
paired PPA/front browsing, not for classic archive-cell occupancy claims.
