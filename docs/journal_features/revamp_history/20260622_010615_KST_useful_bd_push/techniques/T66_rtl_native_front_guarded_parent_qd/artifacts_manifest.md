# T66 Artifacts Manifest

Status: pre-registered; raw run pending.

## Planned Raw Run

- Planned QD root pattern:
  `exp/useful_bd_push/t66_rtl_native_front_guarded_parent_<RUN_TS>/hard_tuning/rtl_native_front_guarded_parent_qd/seed_1001`
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
| `results_report.md` | Pending result and tier decision. |
| `commands/hard_tuning_sanity.md` | Descriptor probe, preflight, run, validation, and packaging command plan. |
| `tables/hard_tuning_subset.yaml` | Frozen 13-problem hard/tuning comparator surface. |
| `tables/README.md` | Planned table guide. |
| `figures/README.md` | Planned figure guide. |

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
- vLLM preflight: pending.
- Single-thought run validator: pending.
- Pareto/front run validator: pending.
- PPA completeness table: pending.
- Direct PPA visual inspection: pending.
- Phase 03.1 viewer validation: pending.
