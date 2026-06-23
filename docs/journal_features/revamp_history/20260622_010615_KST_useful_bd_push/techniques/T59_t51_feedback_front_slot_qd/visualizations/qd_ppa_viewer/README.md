# T59 Phase 03.1 QD/PPA Viewer

This is the full linked archive/PPA viewer for the T59 hard/tuning run.

- `index.html`: standalone viewer.
- `manifest.json`: viewer manifest.
- `datasets/*.json`: one dataset per hard/tuning problem.
- `validation.json` and `validation.md`: latest non-strict validation status.
- `validation_output.txt`: non-strict validator stdout.
- `strict_validation_output.txt`: strict validator output and caveat source.
- `playwright_validation_output.txt`: Playwright smoke output.
- `visual_parity_report.md`: screenshot matrix index.
- `screenshots/`: Playwright screenshot matrix.
- `screenshot.png`: representative compare-mode screenshot.
- `projection_caveat.md`: documented classic projection limitation.
- `playwright_caveat.md`: documented Playwright interaction caveat.

Non-strict validation passed. Strict validation fails because classic candidates
cannot be honestly projected into T59's SR-PCA archive coordinates from the
available artifacts. Use this viewer for T59-native archive inspection and
paired PPA/front browsing, not as evidence of classic archive-cell occupancy.
