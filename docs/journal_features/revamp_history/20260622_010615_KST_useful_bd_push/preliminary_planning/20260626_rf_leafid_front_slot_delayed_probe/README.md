# RF Leaf-ID Front-Slot Delayed Probe

Status: pre-registered, not run.

This package freezes the next preliminary candidate after T83 came close on
all-design mean HV but lost Pareto breadth and RTLLM-only HV. It corresponds
to technique `T84_rf_leafid_front_slot_delayed_qd`.

## Decision Question

Can RF timing model-state descriptors become more useful when archive pressure
explicitly samples local front-slot parents instead of only using global
NSGA-II rank and a high champion lane?

## Why This Is Different From T83

T83 used the validated RF leaf-ID axis and delayed archive activation, but kept
parent selection as `nsga2_global_rank` with `0.90` champion pressure. It
nearly matched classic mean HV, but lost front material:

- mean Pareto points: T83 `2.00`, classic `3.25`;
- mean reference-beating candidates: T83 `4.50`, classic `8.00`;
- RTLLM-only mean HV: T83 `0.0995`, classic `0.1453`.

T84 keeps the same PPA-free descriptor axes and delayed activation schedule,
but changes the coupling mechanism to `front_slot_lane_nsga2`. That forces a
bounded parent lane toward non-elite local front-slot members.

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

Preflight is recorded in
`tables/preflight_models_20260626_rf_leafid_front_slot.txt`. Descriptor-axis
requirements are recorded in
`tables/descriptor_probe_20260626_rf_leafid_front_slot.json`.

## Expected Outcome

The run should either:

- improve T83's front-material metrics without losing the near-classic mean-HV
  signal; or
- retire this front-slot coupling as too expensive for RF leaf-ID model-state
  descriptors.

No full RTLLM spend is allowed before the frozen screen result is packaged and
compared to classic and T83.
