# N04 Budget Shape Methodology

Status: pre-registered 2026-07-07 before any N04 V2 6x7 result.
Comparator verification complete before V2 launch.

## Question

Does the faithful Smooth-QD V2 platform benefit more than classic
REvolution from a deeper equal-candidate 6x7 budget shape?

## Arm

- `smooth_qd_v2_6x7`, seed 1001.
- Same frozen eight-design subset as the P0 screen.
- Same V2 mechanism as `tables/v2_platform_config.md`.
- Only budget shape changes from 8x5 to 6x7.

## Comparator

The matched classic comparator is the T79 `classic_revolution_6x7`
seed-1001 root:

`exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live/classic_revolution_6x7/seed_1001`

The comparator was recompute-verified from that run root before V2 launch:
mean HV `0.1700994814185665`, mean HV-AUC `0.146221021526`, coverage `8/8`,
operator audit pass, and run validation pass. See `baseline_verification.md`.

## Gates

- Hard fail: missing comparator verification, operator-contract failure,
  run-validation failure, or coverage loss versus classic.
- Retire 6x7: V2 mean HV below `0.95x` classic, unless the package shows a
  specific worker/runtime failure that invalidates the read.
- Escalate: V2 mean HV and HV-AUC at least match classic with coverage
  retained. The next registered action is either a 6x7 seed ladder or a
  tightly scoped warmup-depth follow-up from N05b.
- Do not register 4x11 unless 6x7 is positive enough to justify a new
  matched classic spend.

## Interpretation Limits

This is a follow-up shape probe, not a new headline by itself. A single
seed near tie cannot override the existing P3 verdict. Any manuscript claim
needs replication or must be phrased as a registered follow-up datum.
