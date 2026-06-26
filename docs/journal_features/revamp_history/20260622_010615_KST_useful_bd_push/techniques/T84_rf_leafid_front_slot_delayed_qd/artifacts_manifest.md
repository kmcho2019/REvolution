# T84 Artifacts Manifest

## Artifacts

| Artifact | Purpose |
| --- | --- |
| `methodology.md` | Pre-registered algorithm and descriptor axes. |
| `commands/run_t84_rf_leafid_front_slot_delayed.md` | Frozen run command. |
| `results_report.md` | Technique-level result and decision. |
| `tables/preflight_models_20260626_rf_leafid_front_slot.txt` | vLLM model metadata copied from the preliminary-planning package. |
| `tables/descriptor_probe_20260626_rf_leafid_front_slot.json` | Axis-resolution probe proving the BD requires source-aligned RTL/RF timing metrics but not PPA. |

## Result Package

The completed result package is:

`../../preliminary_planning/20260626_rf_leafid_front_slot_delayed_probe/`

It includes:

- Pareto/HV analysis tables in `analysis/pareto_analysis/`;
- comparison completeness table;
- descriptor-health summary;
- inspected summary figure;
- validator log;
- exact run root and command output paths.

The run artifacts should remain under `exp/useful_bd_push/`, not under `aux/`.
