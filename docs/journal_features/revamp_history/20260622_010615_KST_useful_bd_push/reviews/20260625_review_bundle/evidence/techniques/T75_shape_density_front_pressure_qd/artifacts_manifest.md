# T75 Artifacts Manifest

Status: completed compact package.

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
| `results_report.md` | T75 result and tier decision. |
| `matched_classic_comparison/` | Compact committed matched comparison package. |

## Live Run Root

```text
exp/useful_bd_push/t75_shape_density_front_pressure_20260624_024005_UTC/hard_tuning
```

Do not write new run artifacts under `/aux`.

## Result Artifacts

- vLLM preflight:
  `exp/useful_bd_push/t75_shape_density_front_pressure_20260624_024005_UTC/hard_tuning/preflight/`
- live run:
  `exp/useful_bd_push/t75_shape_density_front_pressure_20260624_024005_UTC/hard_tuning/shape_density_front_pressure_qd/seed_1001/`
- compact comparison:
  `matched_classic_comparison/`
- completeness table:
  `matched_classic_comparison/tables/t75_ppa_completeness.csv`
- direct comparison table:
  `matched_classic_comparison/tables/t75_direct_comparisons.csv`
- summary figures:
  `matched_classic_comparison/figures/t75_hv_delta_by_problem.png` and
  `matched_classic_comparison/figures/t75_valid_ppa_counts.png`

The full final-analysis command was interrupted in `design_space_analysis`
after PPA/Pareto outputs were written. The caveat is committed at
`matched_classic_comparison/tables/t75_final_analysis_caveat.json`.

## Source Commit

T75 depends on the configurable front-slot pressure knob added in:

```text
a4c2c0ac99 feat(qd): Configure front slot pressure
```
