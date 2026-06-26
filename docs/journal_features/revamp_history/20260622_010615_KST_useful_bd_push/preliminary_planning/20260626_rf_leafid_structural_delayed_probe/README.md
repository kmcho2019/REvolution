# RF Leaf-ID Structural Delayed Probe

Status: pre-registered, not run.

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

## Expected Outcome

The run should either:

- recover some of delayed activation's near-classic HV while improving RF
  descriptor health, or
- retire this exact RF leaf-ID structural delayed geometry with clear evidence.

No full RTLLM spend is allowed before the frozen screen result is packaged and
compared to classic.
