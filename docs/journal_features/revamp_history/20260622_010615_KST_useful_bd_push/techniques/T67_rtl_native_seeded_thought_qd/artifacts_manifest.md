# T67 Artifacts Manifest

Status: completed seed `1001`; packaged and inspected.

## Raw Run

- QD root:
  `exp/useful_bd_push/t67_rtl_native_seeded_thought_20260623_170935_UTC/hard_tuning/rtl_native_seeded_thought_qd/seed_1001`
- Classic comparator root:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- Method:
  `rtl_native_seeded_thought_qd`
- Descriptor profile:
  `fused_rtl_state_pipeline_2d`
- Seed:
  `1001`
- Surface:
  13-problem hard/tuning reference-complete subset
- vLLM endpoint:
  `http://20.0.0.103:8000/v1/models`
- Required model:
  `openai/gpt-oss-120b max_model_len>=128000`
- Token budgets:
  `128000` max tokens and `128000` diff max tokens

## Current Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Package overview and comparator list. |
| `methodology.md` | Pre-registered method definition and acceptance signals. |
| `commands/hard_tuning_sanity.md` | Descriptor probe, preflight, run, validation, and packaging commands. |
| `tables/hard_tuning_subset.yaml` | Frozen hard/tuning subset. |
| `tables/descriptor_probe_fused_rtl_state_pipeline_2d.json` | Completed descriptor probe proving the RTL-native axes and no PPA requirement. |
| `results_report.md` | Result summary and tier decision. |
| `hard_tuning_package/` | Packaged metrics, raw data, figures, and tables. |
| `hard_tuning_package/tables/t67_ppa_completeness.csv` | Reference-complete eligibility table. |
| `visualizations/direct_ppa_pareto/` | Static raw PPA-front supplement with screenshot and metrics. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1 linked archive/PPA viewer with screenshot. |
| `visualizations/qd_ppa_viewer_source/final_analysis/` | Final-analysis source bundle for viewer export and reference tables. |

## Descriptor Probe

- Axes: `state_control_ratio`, `control_pipeline_ratio`
- `requires_ppa=false`
- `requires_graph_metrics=true`
- `requires_rtl_metrics=true`

## Validation Status

- Descriptor probe: passed; axes are `state_control_ratio` and
  `control_pipeline_ratio`, with `requires_ppa=false`.
- vLLM preflight: passed; `openai/gpt-oss-120b max_model_len=131072`.
- Single-thought run validator: passed after accepting thought-code prompt
  stages.
- Pareto/front run validator: passed.
- PPA completeness table: passed for reference availability, but marks
  `Prob153_gshare` as T67 `candidate_missing`.
- Direct PPA visual inspection: passed after regenerating a raw area-power
  panel and recapturing the screenshot.
- Phase 03.1 viewer validation: passed with `--strict --playwright`.
