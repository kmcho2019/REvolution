# N03 Archive Parent Lane — Seed-1001 Result (2026-07-03)

Runs: `exp/natural_qd_push/n03_archive_parent_lane_20260703_070921_UTC/`.
Operator contracts pass (zero single-thought, zero other); coverage
8/8 both arms; config-pinned validations pass (lane fraction, cell
mode, selection mode all pinned).

## Read (frozen 8-design 8x5, seed 1001; attribution base = N01a)

| Arm | Lane fraction | Mean HV | vs classic | vs N01a | vs V2 | HV-AUC | Pareto pts |
| --- | --- | --- | --- | --- | --- | --- | --- |
| N01a base (ref) | 0 (no lane) | 0.15709 | +11.7% | - | -9.6% | 0.13116 | 3.125 |
| N03a | 0.10 | 0.14160 | +0.7% | -9.9% | -18.5% | 0.12570 | 3.125 |
| **N03b** | **0.30** | **0.18486** | **+31.4%** | **+17.7%** | **+6.4%** | **0.15511 (+8.0% vs V2)** | **2.875** |
| V2 (ref) | n/a (nsga2 uniform) | 0.17376 | +23.5% | - | - | 0.14366 | 2.625 |

## Takeaways (single seed; replication in flight)

1. **N03b is the first arm to beat V2 on both promotion metrics**
   (+6.4% HV, +8.0% HV-AUC, >2% bar cleared on both), with coverage
   retained AND more Pareto points than V2 (2.875 vs 2.625) — the
   front-breadth deficit narrows rather than widens. This is the T36
   one-front-slot mechanism plus a strong fixed archive-front parent
   lane, run operator-fair for the first time (the old T54/T75
   negatives were single-thought-contaminated and never bound this).
2. **The fraction response is non-monotone at n=1**: 0 -> 0.157,
   0.10 -> 0.142 (the weak lane HURTS vs no lane), 0.30 -> 0.185.
   Treat the shape as noise until seeds 1002/1003 land; do NOT scan
   more fractions (registered rule).
3. Mechanism sentence for the paper if it replicates: "REvolution, but
   each archive cell keeps its champion plus one bounded front slot,
   and 30% of parents are drawn from those front slots."

## Status

- N03a (0.10): closed (loses to its own no-lane base on both metrics).
- **N03b (0.30): promotion-rule replication RUNNING** — seeds
  1002/1003 launched immediately as the first co-scheduled pair under
  `tables/concurrency_policy.md` (M12 validity-funnel guard applies:
  compare both runs' funnels against solo-run twins before accepting).
  If the 3-seed mean beats V2's 3-seed mean (0.16284 HV / 0.14141
  AUC) by >2% on both with coverage retained, N03b displaces V2 as
  the registered P3 promotion arm.
