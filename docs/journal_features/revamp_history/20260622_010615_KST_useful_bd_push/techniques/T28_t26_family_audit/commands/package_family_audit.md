# T28 Package Family Audit Command

Run from `/workspace`:

```bash
/workspace/.venv/bin/python scripts/package_t28_t26_family_audit.py \
  --t24-run-root exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC \
  --t25-run-root exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC \
  --t26-run-root exp/useful_bd_push/t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T28_t26_family_audit
```

This command reads completed live outputs from `exp/useful_bd_push/` and writes
package tables, figures, and a scoped `visualizations/qd_ppa_viewer/` HTML
bundle under the T28 technique directory.

Validation commands:

```bash
/workspace/.venv/bin/python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T28_t26_family_audit/visualizations/qd_ppa_viewer

/workspace/.venv/bin/python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T28_t26_family_audit/visualizations/qd_ppa_viewer \
  --playwright
```

The static validation is the supported contract for this scoped viewer. The
Playwright smoke produces screenshots but currently reports one expected
archive-hover caveat because Classic is not projected into T26's SR-PCA
archive.
