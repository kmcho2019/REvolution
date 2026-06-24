# T76 MasterRTL Pretrained Model Gate

Status: `T0 verification_gate_partial`.

This package checks whether the next RTL-native lane can honestly use
pretrained MasterRTL model artifacts instead of only raw SOG/BOG count
features. It is a verification package, not a live QD result.

## Result

MasterRTL pretrained artifacts are real and loadable in the existing isolated
RTL-native environment:

- four XGBoost heads load from `ML_model/saved_model`;
- the RF timing model loads with `joblib`;
- model hashes and feature-schema checks are recorded.

The gate is only partial because the shipped TinyRocket XGBoost example
predicts all zeros and yields one leaf ID per head, while RTL-Timer still has
no confirmed packaged pretrained checkpoint in the local clone. A live
pretrained-model BD claim still needs generated-candidate variation and
upstream parity checks.

## Files

| File | Purpose |
| --- | --- |
| `methodology.md` | Verification protocol and planned BD follow-up. |
| `results_report.md` | Tier decision and interpretation. |
| `artifacts_manifest.md` | Reproducible file index. |
| `commands/verification_v0.md` | Commands and observed upstream output. |
| `tables/masterrtl_model_inventory.csv` | Model hashes, load status, schema, predictions, and leaf counts. |
| `tables/masterrtl_example_predictions.json` | Exact TinyRocket XGBoost example outputs. |
| `tables/rtltimer_artifact_inventory.csv` | RTL-Timer scripts and example feature/label inventory. |
| `tables/t76_verification_summary.json` | Compact gate decision. |
| `tools/verify_masterrtl_pretrained_models.py` | Reproducer script. |
