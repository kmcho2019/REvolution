# T66 Artifacts Manifest

Status: completed seed `1001`; packaged and inspected.

## Raw Run

- QD root:
  `exp/useful_bd_push/t66_rtl_native_front_guarded_parent_20260623_160756_UTC/hard_tuning/rtl_native_front_guarded_parent_qd/seed_1001`
- Classic comparator root:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- T51 comparator root:
  `exp/useful_bd_push/t51_code_thought_front_slot_20260623_030540_UTC/hard_tuning/code_thought_front_slot_qd/seed_1001`
- T63 comparator root:
  `exp/useful_bd_push/t63_fused_rtl_native_20260623_133903_UTC/hard_tuning/fused_rtl_state_pipeline_qd/seed_1001`
- T64 comparator root:
  `exp/useful_bd_push/t64_fused_operator_timing_20260623_144117_UTC/hard_tuning/fused_rtl_operator_timing_qd/seed_1001`
- vLLM endpoint:
  `http://20.0.0.103:8000/v1/models`
- Required model:
  `openai/gpt-oss-120b max_model_len>=128000`

## Package Files

| Path | Purpose |
| --- | --- |
| `methodology.md` | Pre-registered algorithm, leakage exclusions, acceptance gates. |
| `results_report.md` | Result summary and tier decision. |
| `commands/hard_tuning_sanity.md` | Descriptor probe, preflight, run, validation, and packaging commands. |
| `tables/hard_tuning_subset.yaml` | Frozen 13-problem hard/tuning comparator surface. |
| `tables/README.md` | Planned table guide. |
| `figures/README.md` | Planned figure guide. |
| `hard_tuning_package/` | Packaged metrics, raw data, figures, tables, and package README. |
| `visualizations/direct_ppa_pareto/` | Static raw PPA-front supplement with screenshot and metrics. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1 linked archive/PPA viewer with screenshot. |
| `visualizations/qd_ppa_viewer_source/final_analysis/` | Final-analysis source bundle for viewer export and reference tables. |

## Required Result Artifacts

| Path | Purpose |
| --- | --- |
| `hard_tuning_package/` | Packaged metrics, raw data, figures, and tables. |
| `hard_tuning_package/tables/t66_ppa_completeness.csv` | Reference-complete eligibility table. |
| `visualizations/direct_ppa_pareto/` | Direct raw PPA-front supplement with screenshot and metrics. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1 linked archive/PPA viewer if archive artifacts are available. |

## Validation Status

- Descriptor probe: passed; axes are `state_control_ratio` and
  `control_pipeline_ratio`, with `requires_ppa=false`.
- vLLM preflight: passed; `openai/gpt-oss-120b max_model_len=131072`.
- Single-thought run validator: passed.
- Pareto/front run validator: passed.
- PPA completeness table: passed; 13/13 rows are headline rows.
- Direct PPA visual inspection: passed.
- Phase 03.1 viewer validation: passed.
