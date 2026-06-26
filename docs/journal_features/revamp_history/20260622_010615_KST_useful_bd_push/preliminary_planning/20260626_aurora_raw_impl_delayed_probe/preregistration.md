# T99 Pre-Registration

## Method

`aurora_raw_impl_compact_delayed_8x5`

## Hypothesis

T13 showed that raw implementation-side features beat lexical replay HV by
`+1.06%`, while compressed AURORA/PCA/RFF bottlenecks lost HV. T99 tests that
specific positive clue live: use compact raw implementation features as archive
coordinates on the delayed high-exploit QD substrate.

This is a category representative for AURORA-style raw implementation features,
not a pretrained model result and not an autoencoder bottleneck result.

## Descriptor

Descriptor profile:

```text
implemented_structural_compact_3d
```

Descriptor axes:

```text
comb_ratio
adder_ratio
cell_count_log
```

These axes require candidate synthesis metrics but do not use final PPA,
reference PPA, hypervolume, Pareto rank, pass rate, problem identity, or model
identity.

## Fixed Evaluation Surface

- Subset:
  `preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- Baseline: existing matched `classic_revolution_8x5` from the preliminary
  encoder screen.
- Seed: `1001`
- Budget: population `8`, generations `5`
- Model: `openai/gpt-oss-120b`
- Endpoint: `http://20.0.0.103:8000/v1/models`
- Token budgets: `128000` max tokens and diff max tokens
- Evaluation mode: `strict_ablation`
- Representation: `code_individual`
- Operator: `single_thought_operator`
- Repair: disabled
- Two-parent fusion: disabled

## Coupling

Use the delayed high-exploit substrate so this test isolates the descriptor
category instead of adding another scheduler variable.

| Field | Value |
| --- | ---: |
| `qd_archive_activation_generation` | `3` |
| `qd_fill_target_fraction` | `0.10` |
| `qd_improve_backfill_fraction` | `0.05` |
| `qd_champion_lane_fraction` | `0.90` |
| `qd_parent_selection` | `nsga2_global_rank` |
| `qd_grid_quantile_warmup_successes` | `4` |
| `qd_cell_mode` | `elite_pareto_slot` |
| `qd_max_elites_per_cell` | `2` |

## Primary Metrics

- mean PPA hypervolume on the reference-complete paired subset;
- HV wins versus classic;
- Pareto point count;
- reference-beating candidate count;
- valid-PPA yield;
- completeness status for missing candidate PPA and missing reference PPA.

Archive occupancy and descriptor health are mechanism diagnostics only.

## Decision Rule

T99 becomes the AURORA/raw-implementation category representative if it
improves over the existing Qwen/DeepGate live encoder representatives or comes
within the current best screened QD arm without losing classic-covered problem
coverage.

It advances toward full RTLLM spend only if it is competitive with classic on
mean HV or HV-AUC and does not hide validity, duplicate, or missing-reference
failures.
