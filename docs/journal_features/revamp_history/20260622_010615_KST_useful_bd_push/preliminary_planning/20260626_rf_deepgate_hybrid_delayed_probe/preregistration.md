# T96 Pre-Registration

## Method

`rf_deepgate_hybrid_delayed_8x5`

## Descriptor Axes

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
deepgate_pool_pc0
```

Descriptor profile:

```text
rf_deepgate_hybrid_3d
```

Descriptor config:

```text
docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/tables/rf_deepgate_hybrid_descriptor_profiles.yaml
```

## Fixed Evaluation Surface

- Subset:
  `preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
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

T96 reuses the T83 delayed high-exploit coupling:

| Field | Value |
| --- | ---: |
| `qd_archive_activation_generation` | `3` |
| `qd_fill_target_fraction` | `0.10` |
| `qd_improve_backfill_fraction` | `0.05` |
| `qd_champion_lane_fraction` | `0.90` |
| `qd_parent_selection` | `nsga2_global_rank` |
| `qd_max_elites_per_cell` | `2` |

## Primary Metrics

- mean PPA hypervolume;
- HV wins;
- Pareto point count;
- reference-beating candidate count;
- valid-PPA yield;
- `ppa_completeness.csv` headline status;
- archive occupancy and descriptor health as mechanism evidence.

## Decision Rule

T96 is a continuation candidate only if it clearly improves over both T83 and
T95 without losing classic-covered problem coverage. If it trails classic and
does not recover front breadth, retire this exact RF/DeepGate hybrid and avoid
another minor axis substitution.
