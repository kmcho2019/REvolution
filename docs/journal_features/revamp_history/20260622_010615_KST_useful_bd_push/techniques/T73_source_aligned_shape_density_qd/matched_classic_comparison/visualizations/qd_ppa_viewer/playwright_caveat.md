# T73 Viewer Playwright Caveat

Playwright validation was run with:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T73_source_aligned_shape_density_qd/matched_classic_comparison/visualizations/qd_ppa_viewer \
  --strict \
  --playwright
```

It failed with the same class of browser-hover checks seen in the earlier T72
viewer:

- compare technique alias `classic` was not found because this package uses
  the explicit backend name `classic_revolution`;
- archive hover and layer-panel bridge checks found no sample-level hit
  targets in selected projected archive views;
- projected combinational archive did not report a collapsed `ff_depth`
  field.

The strict non-Playwright validator passes, and manual inspection of
`screenshot.png` showed a nonblank compare-mode viewer with visible archive
and PPA panes. Treat this as a browser-interaction caveat, not as a failed
T73 result.
