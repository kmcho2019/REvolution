# T27 Package Audit Command

Run from `/workspace`:

```bash
/workspace/.venv/bin/python scripts/package_t27_t26_live_qd_audit.py \
  --t24-run-root exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC \
  --t25-run-root exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC \
  --t26-run-root exp/useful_bd_push/t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T27_t26_live_qd_audit
```

This command reads completed live outputs from `exp/useful_bd_push/` and writes
only package tables and figures under the T27 technique directory.
