# T57 Visualizations

Status: completed hard/tuning result.

- `direct_ppa_pareto/`: paper-readable raw area-power PPA-front supplement
  with browser screenshot.
- `qd_ppa_viewer/`: full Phase 03.1 archive/PPA viewer with `index.html`,
  `manifest.json`, `datasets/*.json`, validation output, screenshot, and
  Playwright caveat.

The full viewer uses T57 as the archive source backend and projects classic
candidates into T57's archive space for comparison. Strict non-Playwright
validation passed. Playwright generated screenshots but reported the caveats
documented in `qd_ppa_viewer/playwright_caveat.md`.
