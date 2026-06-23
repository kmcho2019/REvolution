# T58 Visualizations

Status: generated, validated, and screenshot-inspected.

T58 includes both required visualization bundles:

- `visualizations/direct_ppa_pareto/`: paper-readable raw area-power PPA-front
  supplement with browser screenshot.
- `visualizations/qd_ppa_viewer/`: full Phase 03.1 archive/PPA viewer with
  `index.html`, `manifest.json`, `datasets/*.json`, validation output,
  screenshot, and any honest projection caveat.

The full viewer uses T58 as the archive source backend and keeps classic
projection enabled for the T11-PCA4 graph archive space. Strict validation
passed. Playwright generated screenshots and reported the rank-guide caveat
documented in `qd_ppa_viewer/playwright_caveat.md`.
