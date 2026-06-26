# T94 DeepGate Runtime Screen

This package records the first matched `8x5` preliminary screen for the
runtime DeepGate pooled descriptor profile.

## Question

Does the T92/T93 `deepgate_pooled_pc3` runtime descriptor path produce a
competitive QD/MAP-Elites arm when compared against the frozen
`classic_revolution_8x5` baseline on the same eight-design preliminary subset?

## Short Answer

No. The implementation is now screened, reference-complete, and useful as the
current synthesized-netlist pretrained encoder category representative, but it
does not justify full RTLLM spend.

Classic wins the aggregate PPA-front comparison:

| Method | Mean HV | Pareto points | Ref-beating candidates | HV wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1406` | `3.25` | `8.00` | `6` |
| `deepgate_pooled_pc3_8x5` | `0.1040` | `1.75` | `4.50` | `2` |

The useful signal is narrow: DeepGate slightly wins HV on `Prob024_fsm` and
`Prob153_gshare`, and ties HV on `Prob116_m2014_q3`, but it loses the larger
RTLLM front-breadth cases that drive the aggregate.

## Evidence

- Run command:
  [commands/run_deepgate_runtime_screen.md](commands/run_deepgate_runtime_screen.md)
- Validation and analysis log:
  [logs/validation_log.md](logs/validation_log.md)
- Figure inspection:
  [logs/visual_inspection_notes.md](logs/visual_inspection_notes.md)
- Results report:
  [results_report.md](results_report.md)
- Per-problem deltas:
  [tables/deepgate_runtime_problem_deltas.csv](tables/deepgate_runtime_problem_deltas.csv)
- Completeness table:
  [analysis/ppa_completeness.csv](analysis/ppa_completeness.csv)
- Full Phase 03.1 viewer:
  [visualizations/qd_ppa_viewer/index.html](visualizations/qd_ppa_viewer/index.html)
- Direct PPA supplement:
  [visualizations/direct_ppa_pareto/index.html](visualizations/direct_ppa_pareto/index.html)
- Pareto analysis:
  [analysis/pareto_analysis/report.md](analysis/pareto_analysis/report.md)
- PPA distribution analysis:
  [analysis/ppa_distribution/report.md](analysis/ppa_distribution/report.md)

## Decision

Keep `deepgate_pooled_pc3_8x5` as the best current DeepGate category
representative. Do not promote it into the final RTLLM comparison unless a
later DeepGate coupling materially improves HV or front breadth on this same
reference-complete screen.
