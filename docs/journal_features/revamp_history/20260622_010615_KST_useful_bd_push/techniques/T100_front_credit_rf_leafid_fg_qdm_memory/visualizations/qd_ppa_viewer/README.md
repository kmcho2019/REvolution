# T100 QD/PPA Viewer

This is the Phase 03.1-compatible linked archive/PPA viewer for the T100
three-problem smoke.

Files:

- `index.html`: viewer entry point.
- `manifest.json`: viewer manifest.
- `datasets/*.json`: per-problem linked archive and PPA datasets.
- `validation.json`, `validation.md`: strict non-browser validation output.
- `screenshot.png`: manually captured browser screenshot.

Classic descriptor recovery was disabled because the generic recovery path
cannot honestly recompute `source_aligned_rf_timing_leaf_ids` for classic
candidates. Classic PPA samples are visible, but classic archive-cell
projection is intentionally absent.
