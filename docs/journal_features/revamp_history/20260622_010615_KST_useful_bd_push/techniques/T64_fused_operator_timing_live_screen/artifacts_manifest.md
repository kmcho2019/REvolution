# T64 Artifacts Manifest

Status: pre-registered; raw run pending.

## Planned Raw Run

- QD root pattern:
  `exp/useful_bd_push/t64_fused_operator_timing_<UTC>/hard_tuning/fused_rtl_operator_timing_qd/seed_1001`
- Classic comparator root:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- T51 comparator root:
  `exp/useful_bd_push/t51_code_thought_front_slot_20260623_030540_UTC/hard_tuning/code_thought_front_slot_qd/seed_1001`
- T63 comparator root:
  `exp/useful_bd_push/t63_fused_rtl_native_20260623_133903_UTC/hard_tuning/fused_rtl_state_pipeline_qd/seed_1001`
- vLLM endpoint:
  `http://20.0.0.103:8000/v1/models`
- Required model:
  `openai/gpt-oss-120b max_model_len=131072`

## Package

| Path | Purpose |
| --- | --- |
| `methodology.md` | Pre-registered live-screen method card. |
| `results_report.md` | Pending result and tier decision. |
| `commands/hard_tuning_sanity.md` | Descriptor probe, preflight, run, and validation commands. |
| `tables/hard_tuning_subset.yaml` | Frozen 13-problem hard/tuning comparator surface. |
| `tables/descriptor_probe_fused_rtl_operator_timing_2d.json` | PPA-free graph-plus-RTL descriptor profile probe. |
| `tables/README.md` | Table guide. |
| `figures/README.md` | Figure guide. |

## Required After Run

| Path | Purpose |
| --- | --- |
| `hard_tuning_package/` | Packaged metric summary, raw data, figures, and tables. |
| `hard_tuning_package/tables/t64_ppa_completeness.csv` | Reference-complete comparison eligibility table. |
| `visualizations/direct_ppa_pareto/` | Direct raw PPA-front supplement with screenshot. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1 linked archive/PPA viewer. |
| `visualizations/qd_ppa_viewer_source/final_analysis/` | Source analysis bundle for viewer export. |
