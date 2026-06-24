# T75 Artifacts Manifest

Status: pre-run.

## Committed Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Package overview and decision state. |
| `methodology.md` | Method card and anti-gaming contract. |
| `commands/live_screen_v0.md` | Frozen command plan. |
| `tables/descriptor_probe_source_aligned_shape_density_3d.json` | Descriptor dependency probe. |
| `tables/t75_method_contract.json` | Machine-readable method contract. |
| `tables/README.md` | Table inventory. |
| `figures/README.md` | Figure expectations. |
| `visualizations/README.md` | Visualization expectations. |
| `results_report.md` | Pending result slot. |

## Expected Live Run Root

```text
exp/useful_bd_push/t75_shape_density_front_pressure_<UTC>/hard_tuning
```

Do not write new run artifacts under `/aux`.

## Required Result Artifacts

After the live run, add or link:

- validator outputs from `validate_single_thought_operator_run.py`;
- validator outputs from `validate_pareto_front_run.py`;
- final-analysis bundle under the run root;
- compact matched classic comparison package;
- `ppa_completeness.csv`;
- direct raw PPA-front figures;
- visual inspection notes;
- Phase 03.1 `qd_ppa_viewer/` bundle with `screenshot.png` and strict
  validation output;
- tier decision in `results_report.md`.

## Source Commit

T75 depends on the configurable front-slot pressure knob added in:

```text
a4c2c0ac99 feat(qd): Configure front slot pressure
```
