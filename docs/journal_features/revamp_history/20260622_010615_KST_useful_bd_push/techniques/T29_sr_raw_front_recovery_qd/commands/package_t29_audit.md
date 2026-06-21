# T29 Package Audit Command

Run from `/workspace` after the live run completes:

```bash
/workspace/.venv/bin/python -m scripts.package_t29_front_recovery_audit \
  --t24-run-root exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC \
  --t25-run-root exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC \
  --t26-run-root exp/useful_bd_push/t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC \
  --t29-run-root exp/useful_bd_push/t29_sr_raw_front_recovery_qd_20260621_225827_UTC \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T29_sr_raw_front_recovery_qd
```

Validate the T29 Pareto archive:

```bash
/workspace/.venv/bin/python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/t29_sr_raw_front_recovery_qd_20260621_225827_UTC \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T29_sr_raw_front_recovery_qd/tables/live_screen_v0_subset.yaml \
  --pareto-qd-mode sr_raw_front_recovery_qd/seed_1001/openai_gpt-oss-120b
```

The package command uses module form because the script reuses helper functions
from the T27 and T28 packaging scripts.
