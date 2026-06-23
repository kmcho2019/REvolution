# T56 Visualizations

Status: completed with strict Phase 03.1 schema validation.

T56 includes both required visualization bundles:

- `visualizations/direct_ppa_pareto/`: paper-readable raw area-power PPA-front
  supplement with `index.html`, `metrics.json`, copied figures, and browser
  screenshot.
- `visualizations/qd_ppa_viewer/`: full Phase 03.1 archive/PPA viewer with
  `index.html`, `manifest.json`, `datasets/*.json`, strict validation output,
  screenshot, and documented Playwright caveat.

The full viewer shows T56's two-axis archive honestly as `sr_pca_0` and
`sr_pca_1`, rendered as a `4 x 4 x 1` slab for canvas display. Classic
candidates are projected into T56's archive coordinates for visualization
only.
