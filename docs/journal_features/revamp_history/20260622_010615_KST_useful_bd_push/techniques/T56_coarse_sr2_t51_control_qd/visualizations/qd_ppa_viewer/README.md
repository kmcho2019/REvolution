# T56 Phase 03.1 Viewer

This directory is the full Phase 03.1 linked archive/PPA viewer for T56.

- `index.html`: filesystem-openable viewer.
- `manifest.json`: exported problem and technique manifest.
- `datasets/*.json`: per-problem archive/PPA datasets.
- `validation.json`: strict validation status.
- `strict_validation_output.txt`: strict validator console output.
- `playwright_validation_output.txt`: optional Playwright smoke output.
- `playwright_caveat.md`: documented Playwright caveat.
- `screenshot.png`: manually inspected compare-mode screenshot.

T56 uses an honest two-axis SR-PCA archive (`sr_pca_0`, `sr_pca_1`). The
viewer renders that archive as a `4 x 4 x 1` slab so the existing canvas
controls can show it beside the raw PPA distribution.

Classic candidates are projected into the T56 archive coordinates for
comparison. That projection is for visualization only and does not change the
classic run or give classic an archive during evaluation.
