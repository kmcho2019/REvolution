# T55 Visualizations

Status: completed with strict Phase 03.1 schema validation.

T55 includes both required visualization bundles:

- `visualizations/direct_ppa_pareto/`: paper-readable raw area-power PPA-front
  supplement with `index.html`, `metrics.json`, copied figures, and browser
  screenshot.
- `visualizations/qd_ppa_viewer/`: full Phase 03.1 archive/PPA viewer with
  `index.html`, `manifest.json`, `datasets/*.json`, validation output, and
  screenshot.

The Phase 03.1 export honestly projects classic candidates into T55's two-axis
SR-PCA archive coordinates. The viewer renderer was patched to display
two-axis archives as a `4 x 4 x 1` canvas slab without changing the exported
dataset. Strict validation passes.

The optional Playwright smoke produced screenshots but still fails deeper
compare and hover checks. The caveat is recorded in
`qd_ppa_viewer/playwright_caveat.md`.
