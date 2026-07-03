# RF Leaf-ID Structural Delayed Probe

Status: completed diagnostic; not promoted for full RTLLM spend.

This package freezes the next preliminary candidate after the exact RF timing
state screen failed. It corresponds to technique
`T83_rf_leafid_structural_delayed_qd`.

## Decision Question

Can RF timing model-state breadth help QD when it is used as one coordinate in
a source-aligned structural archive with delayed archive activation?

## Why This Is Different From T82

T82 used:

```text
source_aligned_rf_timing_leaf_rows
source_aligned_rf_timing_path_count
source_aligned_masterrtl_branching
```

The `path_count` axis collapsed on most screened problems. T83 replaces it
with `source_aligned_rf_timing_leaf_ids` and adds
`source_aligned_rtltimer_wire_density`, while keeping
`source_aligned_masterrtl_branching`.

## Frozen Inputs

- subset:
  `../20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`;
- baseline:
  `exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001`;
- model:
  `openai/gpt-oss-120b`;
- endpoint:
  `http://20.0.0.103:8000/v1/models`;
- token budget:
  `max_tokens=128000`, `diff_max_tokens=128000`;
- seed:
  `1001`;
- budget:
  `population_size=8`, `num_generations=5`.

Preflight is recorded in `tables/preflight_models_20260626_rf_leafid.txt`.
Descriptor-axis requirements are recorded in
`tables/descriptor_probe_20260626_rf_leafid.json`.

## Result

The frozen screen completed on all eight selected designs. It is a valid
headline-paired comparison: both classic and T83 have valid candidate PPA on
every screened problem, and the references are valid for the headline subset.

| Metric | Classic | T83 QD | Read |
| --- | ---: | ---: | --- |
| Mean HV | `0.1406` | `0.1369` | near-classic but negative |
| Mean Pareto points | `3.25` | `2.00` | weaker front breadth |
| Mean reference-beating candidates | `8.00` | `4.50` | weaker reference improvement |
| HV wins | `5/8` | `3/8` | classic wins more problems |

The all-design mean HV gap is `-2.63%`, but the result is not robust. Removing
`Prob135_m2014_q6b` changes the mean-HV gap to `-20.29%`, and the RTLLM-only
slice is clearly negative.

Decision: do not promote exact T83 to the full RTLLM comparison.

## Files

- `results_report.md`: conclusion and terminology.
- `analysis/pareto_analysis/`: generated Pareto/HV report and per-problem
  diagnostic plots.
- `tables/screen_decision_metrics.csv`: aggregate promotion metrics.
- `tables/problem_hv_deltas.csv`: per-problem HV deltas.
- `tables/comparison_completeness.csv`: reference/candidate completeness.
- `tables/descriptor_health_summary.csv`: descriptor health summary.
- `tables/sensitivity_no_prob135.csv`: robustness check excluding
  `Prob135_m2014_q6b`.
- `figures/rf_leafid_structural_delayed_summary.png`: inspected
  reader-facing summary figure.
- `logs/validation_log.md`: validators, analysis command, and visual checks.
