# RF Timing Gate Command

The probe uses isolated dependencies so the main repository uv environment
does not need to absorb MasterRTL timing-path packages.

```bash
PYTHONHASHSEED=0 uv run \
  --with scikit-learn==1.3.0 \
  --with numpy==1.26.4 \
  --with networkx \
  --with joblib \
  --with matplotlib \
  python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T81_masterrtl_rf_timing_state_gate/tools/run_t81_rf_timing_gate.py
```

Validation:

```bash
uv run ruff check \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T81_masterrtl_rf_timing_state_gate/tools/run_t81_rf_timing_gate.py

git diff --check
```
