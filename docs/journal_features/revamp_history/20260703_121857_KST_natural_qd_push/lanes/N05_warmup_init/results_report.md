# N05 Warmup Length — Seed-1001 Result (2026-07-03)

Runs: `exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/`
(both arms 8/8 coverage; operator contracts pass; config-pinned
validations pass; package under `package/`).

## Read (frozen 8-design 8x5, seed 1001)

| Arm | Warmup successes | Mean HV | vs classic | vs V2 | Pareto pts |
| --- | --- | --- | --- | --- | --- |
| N05a warmup_4 | 4 | 0.14927 | +6.1% | -14.1% | 2.75 |
| V2 anchor | 8 (platform) | 0.17376 | +23.5% | - | 2.625 |
| N05b warmup_16 | 16 | 0.16383 | +16.5% | -5.7% | 2.0 |

## Interpretation and tier decision

Deviating from the platform's warmup 8 in EITHER direction costs HV on
this seed (-14.1% shorter, -5.7% longer), with no coverage effect.
Cause class: mechanism-inert-at-platform-optimum — the quantile-freeze
length matters, and 8 already sits near the optimum for this budget
shape; there is no path to the promotion bar here. Per the registered
follow-up rule ("if neither direction improves on V2, retire rather
than scanning more values"): **lane retired** at seed-1001 evidence
strength, recorded as a positive tuning validation of the platform
value rather than a mechanism discovery. Follow-up idea (backlog, not
registered): warmup interacts with budget shape — revisit only inside
N04 if the depth arm (6x7) is run, where warmup 8 covers a different
fraction of the run.
