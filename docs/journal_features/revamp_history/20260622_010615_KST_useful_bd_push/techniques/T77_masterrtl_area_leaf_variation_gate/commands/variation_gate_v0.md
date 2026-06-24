# T77 Variation Gate Commands

Run from `/workspace`.

```bash
exp/venvs/rtl_native_verify/bin/python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T77_masterrtl_area_leaf_variation_gate/tools/run_t77_area_leaf_gate.py
```

Inputs:

- `techniques/T70_generated_rtl_extractor_smoke/tables/t70_extractor_results.csv`
- `exp/verification/t70_generated_rtl_extractor_smoke/*/masterrtl/parse/*_sog.pkl`
- `exp/verification/t70_generated_rtl_extractor_smoke/*/masterrtl/parse/*_sog_node_dict.pkl`
- `exp/external_repos/MasterRTL/ML_model/saved_model/xgboost_Area_model.pkl`

Outputs:

- `tables/t77_area_candidate_features.csv`
- `tables/t77_head_status.csv`
- `tables/t77_variation_summary.json`
- `figures/t77_area_leaf_variation_gate.png`
