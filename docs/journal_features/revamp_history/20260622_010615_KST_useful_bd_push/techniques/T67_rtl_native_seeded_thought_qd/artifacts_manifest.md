# T67 Artifacts Manifest

Status: pre-registered package; run artifacts pending.

## Planned Run

- Method: `rtl_native_seeded_thought_qd`
- Descriptor profile: `fused_rtl_state_pipeline_2d`
- Seed: `1001`
- Surface: hard/tuning 13-problem reference-complete subset
- Model: local vLLM `openai/gpt-oss-120b`
- Token budgets: `128000` max tokens and `128000` diff max tokens

## Current Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Package overview and comparator list. |
| `methodology.md` | Pre-registered method definition and acceptance signals. |
| `commands/hard_tuning_sanity.md` | Descriptor probe, preflight, run, validation, and packaging commands. |
| `tables/hard_tuning_subset.yaml` | Frozen hard/tuning subset. |
| `tables/descriptor_probe_fused_rtl_state_pipeline_2d.json` | Completed descriptor probe proving the RTL-native axes and no PPA requirement. |
| `results_report.md` | Pending result report template. |

## Pending Artifacts

- vLLM preflight JSON and summary;
- seed `1001` run root under `exp/useful_bd_push/`;
- validation JSON/Markdown;
- `hard_tuning_package/` tables, figures, and data;
- `t67_ppa_completeness.csv`;
- direct raw PPA HTML supplement;
- full Phase 03.1 `qd_ppa_viewer/`.

## Descriptor Probe

- Axes: `state_control_ratio`, `control_pipeline_ratio`
- `requires_ppa=false`
- `requires_graph_metrics=true`
- `requires_rtl_metrics=true`
