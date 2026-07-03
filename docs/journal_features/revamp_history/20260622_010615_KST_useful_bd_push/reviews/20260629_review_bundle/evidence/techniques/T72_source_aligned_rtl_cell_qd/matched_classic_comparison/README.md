# T72 Matched Classic Comparison

This package compares the fixed T72 source-aligned RTL-cell QD run against the
matched classic REvolution hard/tuning run.

## Scope

- Classic run:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- T72 run:
  `exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC/hard_tuning/source_aligned_rtl_cell_qd/seed_1001`
- Final-analysis scratch output:
  `exp/useful_bd_push/t72_matched_classic_comparison_20260623_213900_UTC/final_analysis`
- Subset:
  `../tables/hard_tuning_subset.yaml`

The comparison is reference-complete: all `13/13` problems have valid
reference PPA and both methods have at least one valid candidate PPA.

## Result

T72 is `T1 near_classic_not_promoted`.

It preserves every classic-covered design and avoids a catastrophic valid-PPA
drop, but classic remains the multi-objective winner:

- mean HV: classic `0.0926007600`, T72 `0.0920035731`;
- HV wins: classic `9`, T72 `4`;
- mean Pareto points: classic `2.31`, T72 `1.31`;
- mean reference-beating candidates: classic `3.54`, T72 `2.85`;
- valid PPA samples: classic `257`, T72 `233`.

## Navigation

- `results_report.md`: conclusion, terminology, and interpretation.
- `artifacts_manifest.md`: committed artifacts and regeneration notes.
- `tables/`: compact aggregate, per-problem, and completeness tables.
- `data/`: raw analysis CSVs needed to regenerate the summary figures.
- `figures/`: inspected summary figures and representative Pareto examples.
- `tools/plot_t72_matched_summary.py`: figure regeneration script.
- `visualizations/`: notes on the Phase 03.1 viewer status for this matched
  package.
