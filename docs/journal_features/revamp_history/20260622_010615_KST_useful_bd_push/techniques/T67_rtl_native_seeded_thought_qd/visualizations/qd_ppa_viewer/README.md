# T67 Phase 03.1 QD/PPA Viewer

Files:

- `index.html`: full linked archive/PPA viewer.
- `manifest.json`: viewer manifest for the 13 hard/tuning datasets.
- `datasets/*.json`: per-problem classic/QD archive and PPA data.
- `validation.json` and `validation.md`: strict validator output.
- `visual_parity_report.md`: Playwright screenshot parity summary.
- `screenshots/`: Playwright screenshot matrix.
- `screenshot.png`: inspected compare-mode screenshot copied from
  `screenshots/compare_classic_qd.png`.

The viewer was generated from the T47 classic comparator and the T67
`rtl_native_seeded_thought_qd` archive with `--strict`, then validated with
`--strict --playwright`. Classic candidates were projected into the
RTL-native state/pipeline archive using the export contract rather than
default cells.
