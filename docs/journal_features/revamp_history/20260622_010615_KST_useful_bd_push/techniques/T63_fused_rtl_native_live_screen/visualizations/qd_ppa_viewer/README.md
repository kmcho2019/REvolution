# T63 Phase 03.1 QD/PPA Viewer

This is the full linked archive/PPA viewer for T63, separate from the simpler
`../direct_ppa_pareto/` raw area-power supplement.

Files:

- `index.html`: standalone viewer.
- `manifest.json`: backend, problem, and artifact manifest.
- `datasets/*.json`: one dataset per hard/tuning problem.
- `descriptor_cache.json`: recovered descriptor values, including projected
  classic candidates.
- `validation.json` and `validation.md`: strict static validation result.
- `validation_output.txt`: strict validator command output.
- `screenshots/`: Playwright screenshot matrix.
- `screenshot.png`: representative compare-mode screenshot.
- `playwright_caveat.md`: documented compare-guide assertion failure.

Static strict validation passed. The Playwright smoke generated readable
screenshots but failed two compare-guide debug assertions; see
`playwright_caveat.md`.
