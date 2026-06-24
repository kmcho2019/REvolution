# T74 Viewer Playwright Caveat

Playwright validation was run with:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T74_shape_density_front_slot_hybrid_qd/matched_classic_comparison/visualizations/qd_ppa_viewer \
  --strict \
  --playwright
```

It failed on browser-interaction checks:

- compare technique alias `classic` was not found because this package uses
  the explicit backend name `classic_revolution`;
- selected archive hover and layer-panel bridge checks found no sample-level
  hit targets in projected archive views;
- projected combinational archive did not report a collapsed `ff_depth` field.

The strict non-Playwright validator passes, and manual inspection of
`screenshot.png` showed a nonblank classic-vs-T74 viewer with visible archive
and PPA panes. Treat this as a browser-interaction caveat, not as a failed
T74 result package.
