# T57 Phase 03.1 QD/PPA Viewer

This is the full linked archive/PPA viewer for the T57 hard/tuning run.

- `index.html`: standalone viewer.
- `manifest.json`: viewer manifest.
- `datasets/*.json`: one dataset per hard/tuning problem.
- `validation.json` and `validation.md`: strict schema/control validation.
- `strict_validation_output.txt`: strict validator stdout.
- `playwright_validation_output.txt`: Playwright smoke output.
- `visual_parity_report.md`: screenshot matrix index.
- `screenshots/`: Playwright screenshot matrix.
- `screenshot.png`: representative compare-mode screenshot.
- `playwright_caveat.md`: documented Playwright caveat.

Strict non-Playwright validation passed. Playwright generated screenshots but
reported two interaction caveats; use `playwright_caveat.md` with
`screenshot.png` when citing this viewer.
