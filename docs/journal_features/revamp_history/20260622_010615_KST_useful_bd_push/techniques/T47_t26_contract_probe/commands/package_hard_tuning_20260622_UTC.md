# T47 Hard/Tuning Package Command

Status: completed on 2026-06-22 UTC.

Regenerate the two-seed hard/tuning package with:

```bash
uv run python scripts/package_t47_contract_probe.py \
  --run-root exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning \
  --matrix docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/tables/probe_problem_matrix.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/hard_tuning_package
```

The package is diagnostic. It should not be used to launch held-out exact T26
without a new variant rationale.
