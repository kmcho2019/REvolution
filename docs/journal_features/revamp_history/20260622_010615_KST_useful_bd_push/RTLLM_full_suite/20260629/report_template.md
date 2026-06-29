# RTLLM Full Suite Report Template

## Executive Read

State whether any QD/MAP-Elites variant beats, ties, or remains close to
classic REvolution on the reference-complete RTLLM subset.

## Comparison Scope

- Full diagnostic RTLLM scope: 50 prompt-file designs.
- Headline comparison scope: 46 reference-complete designs.
- Diagnostic-only missing-reference designs:
  `Prob006_adder_pipe_64bit`, `Prob013_multi_booth_8bit`,
  `Prob018_float_multi`, `Prob040_synchronizer`.

## Results Summary

Use `tables/full_suite_method_summary.csv` after packaging.

Report:

- valid-PPA coverage;
- mean HV;
- mean HV-AUC;
- mean Pareto points;
- reference-beating candidate count;
- per-problem HV wins/losses/ties against classic.

## Method Notes

For each method, record:

- descriptor type;
- exact command path;
- whether Phase 03.1 viewer export exists;
- whether classic descriptors were projected honestly or omitted;
- any failed or partial problems.

## Figures

Expected generated figures:

- `figures/mean_hv_by_method.png`
- `figures/mean_hv_auc_by_method.png`
- `figures/hv_delta_by_method.png`
- `figures/valid_ppa_count_by_method.png`
- `figures/pareto_points_by_method.png`
- `figures/hv_win_loss_heatmap.png`

## Conclusion

Answer:

1. Does diversity matter for RTL/Verilog PPA evolution?
2. Which diversity appears useful, weak, or misleading?

Use reference-complete paired evidence only for headline claims.
