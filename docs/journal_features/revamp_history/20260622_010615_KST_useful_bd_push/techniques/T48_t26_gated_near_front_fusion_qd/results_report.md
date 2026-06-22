# T48 Gated Near-Front Fusion Results

Status: seed `1001` live run in progress.

T48 seed `1001` was launched at run root:

`exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning`

The run passed the in-command vLLM preflight for `openai/gpt-oss-120b` with
`max_model_len=131072`. Do not claim a result until the run exits cleanly and
the package is built.

T48 was implemented because T47 exact T26 was diagnostic but not
held-out-ready:

- mean HV delta: `-0.015483`;
- mean HV-AUC delta: `-0.018435`;
- mean best-score delta: `+0.024728`;
- valid-PPA candidates: `428` versus `538`;
- aggregate PPA-front points: `53` versus `61`;
- classic-covered valid-PPA losses: `0`;
- yield warnings: `4`.

## Planned Decision

After the live package is built, assign one of:

- `T0 diagnostic` if T48 repeats T47's HV/HV-AUC or yield losses;
- `T1 near_classic` if it improves T47 on HV/HV-AUC or front points while
  preserving classic-covered designs and avoiding additional yield warnings;
- `T2 validation_candidate` only after direct PPA-front figures, candidate raw
  data, and gate-counter tables show that the win is not a denominator trick.

Do not claim useful QD from this package until a measured result is present.
