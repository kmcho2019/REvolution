# T73 Matched Classic Comparison

This package compares the completed T73 source-aligned shape-density QD run
against the matched classic REvolution hard/tuning baseline.

## Scope

- Classic run:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- T73 run:
  `exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning/source_aligned_shape_density_qd/seed_1001`
- Final-analysis scratch output:
  `exp/useful_bd_push/t73_matched_classic_comparison_20260624_001300_UTC/final_analysis`
- Subset:
  `../tables/hard_tuning_subset.yaml`

The comparison is reference-complete: all `13/13` problems have valid
reference PPA and both methods have at least one valid candidate PPA.

## Result

T73 is `T0 positive_diagnostic_not_promoted`.

It preserves every classic-covered design and improves valid-PPA yield and
reference-beating candidate count. It is not a promoted QD win because classic
still wins the multi-objective Pareto read:

| Metric | Classic | T73 |
| --- | ---: | ---: |
| Mean HV | 0.0926007600 | 0.0890223082 |
| HV wins | 8 | 5 |
| Mean Pareto points | 2.31 | 1.46 |
| Mean reference-beating candidates | 3.54 | 3.69 |
| Valid PPA samples | 257 | 294 |

The main positive case is `Prob045_alu`; the main negative case is
`Prob041_traffic_light`, whose HV loss dominates the mean.
`Prob151_review2015_fsm` is a caveat: final analysis finds three T73
candidate-PPA rows, but the live archive summary failed and has zero archive
members.

## Navigation

- `results_report.md`: conclusion, terminology, and interpretation.
- `artifacts_manifest.md`: committed artifacts and regeneration commands.
- `tables/`: aggregate, per-problem, and completeness tables.
- `data/`: compact candidate and reference CSVs.
- `figures/`: inspected summary figures and representative PPA panels.
- `tools/package_t73_matched_summary.py`: compact package regeneration.
- `visualizations/qd_ppa_viewer/`: full Phase 03.1 viewer bundle.
