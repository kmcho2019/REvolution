# T74 Phase 03.1 QD/PPA Viewer

This is the full linked archive/PPA viewer for the matched classic versus T74
hard/tuning comparison, seed `1001`.

- `index.html`: Phase 03.1 viewer.
- `manifest.json`: viewer manifest.
- `datasets/`: one dataset per hard/tuning problem.
- `descriptor_cache.json`: descriptor projection cache.
- `validation.json`: latest strict structural validation status.
- `validation.md`: human-readable validation summary.
- `screenshot.png`: representative classic-vs-T74 compare screenshot.
- `playwright_caveat.md`: browser-interaction validation caveat.

Validation:

- Strict non-Playwright validator: `PASS`.
- Browser screenshot rendered nonblank in manual inspection.
- Playwright interaction validator: `FAIL` on known archive hover and backend
  alias checks. See `playwright_caveat.md`.

Classic candidates are included in the PPA compare pane. Do not claim classic
archive coverage from this viewer: T74 archive cells are native to the QD run.
