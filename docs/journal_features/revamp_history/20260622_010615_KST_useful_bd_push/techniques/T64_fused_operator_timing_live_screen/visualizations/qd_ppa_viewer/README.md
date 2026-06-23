# T64 Phase 03.1 QD/PPA Viewer

This is the full Phase 03.1 linked archive/PPA viewer for the T64 hard/tuning
screen.

Files:

- `index.html`: filesystem-openable linked archive/PPA viewer.
- `manifest.json`: exported dataset and source-artifact manifest.
- `datasets/*.json`: one dataset per benchmark problem.
- `validation.json` and `validation.md`: static strict validator output.
- `screenshot.png`: inspected compare-mode Playwright screenshot.
- `screenshots/`: additional Playwright screenshots from the interactive
  validator.

Static strict validation passed. The Playwright run generated screenshots but
reported the known compare-guide caveat for rank-guide emission in compare
mode, matching the T63 viewer caveat.
