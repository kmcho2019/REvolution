# T76 Verification Commands

Run from `/workspace`.

```bash
exp/venvs/rtl_native_verify/bin/python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T76_masterrtl_pretrained_model_gate/tools/verify_masterrtl_pretrained_models.py
```

The script writes all tables under
`techniques/T76_masterrtl_pretrained_model_gate/tables/`.

Direct upstream MasterRTL inference smoke:

```bash
cd /workspace/exp/external_repos/MasterRTL/ML_model/infer
/workspace/exp/venvs/rtl_native_verify/bin/python infer.py
```

Observed output:

```text
Predicted Power: [0.]
```

The upstream script currently hardcodes the last assigned `ppa_tpe` value,
which is `Power`. The T76 script reproduces the same load/preprocess contract
for all four XGBoost heads instead of modifying upstream code.
