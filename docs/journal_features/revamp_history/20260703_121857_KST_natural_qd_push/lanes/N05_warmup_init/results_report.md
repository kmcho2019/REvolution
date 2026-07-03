# N05 Warmup Length — Seed-1001 Result (2026-07-03; reframed same day)

Runs: `exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/`
(both arms 8/8 coverage; operator contracts pass; validations
repackaged with the FULL config-pin set after the codex second-opinion
review flagged the reduced pins — action 2).

## Read (frozen 8-design 8x5, seed 1001)

| Arm | Warmup | Mean HV | vs classic | vs V2 | HV-AUC | AUC vs V2 | Pareto pts |
| --- | --- | --- | --- | --- | --- | --- | --- |
| N05a warmup_4 | 4 | 0.14927 | +6.1% | -14.1% | 0.120195 | -16.3% | 2.75 |
| V2 anchor | 8 | 0.17376 | +23.5% | - | 0.143660 | - | 2.625 |
| N05b warmup_16 | 16 | 0.16383 | +16.5% | -5.7% | 0.142240 | **-0.99%** | 2.0 |

## Interpretation (reframed per codex review action 3)

- warmup_4 loses clearly on both metrics (HV -14.1%, HV-AUC -16.3% vs
  V2): shortening the quantile-freeze phase hurts at this budget.
- warmup_16 trails V2 on final HV (-5.7%) but is a near-tie on HV-AUC
  (-0.99%) while still beating classic by +16.5% HV / +14.8% HV-AUC
  with full coverage. The earlier "no path to the promotion bar"
  wording conflated two gates: warmup_16 plausibly clears the plan's
  classic-based promote gate at 3 seeds, but it cannot displace V2 as
  the promotion arm under the registered promotion-arm rule (needs
  >2% over V2 on BOTH metrics, and it trails on both).

## Decision

- N05a: closed (loses both metrics decisively; single seed suffices
  for a same-direction-both-metrics loss against the platform).
- N05b: **parked, not retired** — not a promotion-arm candidate under
  the registered rule, and not spending its own 3-seed replication now
  (budget priority goes to challenger lanes), but explicitly available
  for revival inside N04 (depth shapes change what fraction of the run
  the warmup covers, which is exactly where a longer freeze could pay).
- Lane-level cause class: platform-near-optimum on this budget shape;
  a positive tuning validation of warmup 8, with the warmup-x-depth
  interaction recorded as the live follow-up inside N04.
