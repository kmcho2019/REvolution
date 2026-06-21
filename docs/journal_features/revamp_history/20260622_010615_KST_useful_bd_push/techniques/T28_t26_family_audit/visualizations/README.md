# T28 Visualizations

This directory contains the scoped Phase 03.1 PPA/archive viewer for the T28
family audit.

| Path | Purpose |
| --- | --- |
| `qd_ppa_viewer/index.html` | Filesystem-openable HTML viewer for Classic versus T26. |
| `qd_ppa_viewer/datasets/` | Per-problem JSON datasets consumed by the viewer. |
| `qd_ppa_viewer/manifest.json` | Viewer manifest and source-artifact hashes. |
| `qd_ppa_viewer/screenshots/` | Playwright smoke screenshots used for visual inspection. |
| `qd_ppa_viewer/visual_parity_report.md` | Screenshot index from the Playwright smoke. |
| `qd_ppa_viewer_source/final_analysis/` | Synthetic source CSVs used to export the viewer. |

The viewer uses T26's native SR-PCA archive as the archive source. Classic is
shown in the PPA/Pareto pane but is not projected into that SR-PCA archive,
because that projection would imply descriptors Classic never used.

Static validation:

```bash
/workspace/.venv/bin/python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T28_t26_family_audit/visualizations/qd_ppa_viewer
```

Playwright caveat: the repository browser smoke generates usable screenshots
but reports one archive-hover assertion for Classic's empty SR-PCA archive
projection.
