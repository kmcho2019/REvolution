# Artifacts Manifest

## Source Changes

| Path | Purpose |
| --- | --- |
| `src/revolution/algorithm.py` | Enables RF timing extraction through the QDEngine candidate path. |
| `src/revolution/qd/engine.py` | Detects RF timing descriptor requirements for live QD archives. |
| `src/revolution/source_aligned_descriptor_evaluator.py` | Adds opt-in RF timing metric extraction. |
| `src/revolution/qd/descriptors.py` | Adds RF timing descriptor axes and requirements. |
| `src/revolution/runtime/candidate_evaluator.py` | Enables RF timing extraction only when selected by descriptor requirements. |
| `scripts/extract_masterrtl_rf_timing_metrics.py` | Helper run under the pinned RF timing environment. |
| `data/configs/qd_descriptor_profiles.yaml` | Adds `source_aligned_rf_timing_state_3d`. |

## T82 Artifacts

| Path | Purpose |
| --- | --- |
| `commands/runtime_hook_smoke.md` | Exact setup, helper, and evaluator smoke commands. |
| `tables/runtime_hook_smoke_metrics.json` | Smoke metrics from the full evaluator path. |
| `figures/rf_timing_runtime_hook_smoke.png` | Inspected smoke summary figure. |

## External Runtime

| Path | Purpose |
| --- | --- |
| `exp/useful_bd_push/envs/masterrtl_rf_timing/` | Local isolated RF timing environment. |
| `exp/external_repos/MasterRTL/ML_model/saved_model/rfr_model.pkl` | Saved MasterRTL RF timing model. |
