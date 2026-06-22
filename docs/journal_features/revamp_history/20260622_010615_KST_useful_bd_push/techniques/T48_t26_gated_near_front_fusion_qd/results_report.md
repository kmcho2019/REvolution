# T48 Gated Near-Front Fusion Results

Status: seed `1001` complete; seed `1002` pending.

T48 seed `1001` was launched at run root:

`exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning`

The run passed the in-command vLLM preflight for `openai/gpt-oss-120b` with
`max_model_len=131072` and completed `13/13` problems with exit code `0`.
Total runtime was `1572.27` seconds.

Preliminary seed-1001 readout:

- summary best-status count: `11` success, `2` failed;
- QD artifact coverage: `13/13` `archive_summary.json` and `13/13`
  `qd_metrics.json`;
- global PPA-front coverage: `13/13`, including the two summary-level failed
  problems;
- summary best-score comparison versus T47 classic seed `1001`: `3` wins,
  `3` losses, `5` ties, and `2` missing summary best scores;
- total archive members: `65`;
- total global Pareto candidates: `25`;
- two-parent attempts: `21`;
- near-front gate attempts: `6`;
- near-front gate accepts: `5`;
- near-front gate rejects: `1`;
- one-parent fallbacks after two-parent requests: `16`.

The two summary-level failures need package-level handling rather than a
simple failure label. `Prob024_fsm` has two global-Pareto PPA candidates and
matches the T47 classic best score. `Prob151_review2015_fsm` has one
global-Pareto PPA candidate, but its best quality is worse than the T47
classic seed-1001 best score. Do not assign a T48 tier until seed `1002`,
paired candidate-level packaging, and direct PPA-front inspection are done.

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

Do not claim useful QD from this package until the two-seed measured result
is present.
