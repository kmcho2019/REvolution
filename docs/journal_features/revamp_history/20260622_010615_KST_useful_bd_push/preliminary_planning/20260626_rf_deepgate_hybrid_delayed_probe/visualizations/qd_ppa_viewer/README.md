# T96 Phase 03.1 QD/PPA Viewer

This directory contains the full Phase 03.1-compatible viewer for the T96
RF/DeepGate hybrid screen.

## Contents

- `index.html`: linked archive/PPA viewer.
- `manifest.json`: viewer manifest.
- `datasets/`: per-problem viewer datasets.
- `validation.json` and `validation.md`: strict validation output.
- `screenshots/`: Playwright-rendered screenshots.
- `screenshot.png`: inspected compare-mode render.

Classic candidates are not projected into the RF/DeepGate descriptor archive.
The viewer was exported with `--no-classic-descriptor-recovery`; QD archive
cells come from recorded hybrid archive artifacts, and classic is used as the
PPA comparator.
