# T54 Visualizations

Status: packaged.

T54 includes both required visualization bundles:

- `visualizations/direct_ppa_pareto/`: paper-readable raw area-power PPA-front
  supplement with `index.html`, `metrics.json`, figures, and browser
  screenshot.
- `visualizations/qd_ppa_viewer/`: full Phase 03.1 archive/PPA viewer with
  `index.html`, `manifest.json`, `datasets/*.json`, validation output, and
  screenshot.

Strict schema validation passes for the Phase 03.1 bundle. The optional
Playwright smoke produced screenshots but failed compare-guide and archive
hover checks; the exact caveat is recorded in
`visualizations/qd_ppa_viewer/playwright_caveat.md`.
