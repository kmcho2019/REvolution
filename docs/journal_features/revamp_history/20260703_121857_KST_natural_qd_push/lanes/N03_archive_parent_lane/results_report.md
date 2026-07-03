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

## Replication verdict (seeds 1002/1003; first co-scheduled pair)

`package/tables/three_seed_vs_v2.csv` (tracked generator):

| Seed | V2 HV | N03b HV | ratio | V2 AUC | N03b AUC |
| --- | --- | --- | --- | --- | --- |
| 1001 | 0.17376 | 0.18486 | 106.4% | 0.14366 | 0.15511 |
| 1002 | 0.17180 | 0.16127 | 93.9% | 0.15132 | 0.15002 |
| 1003 | 0.14294 | 0.13704 | 95.9% | 0.12926 | 0.10736 |
| mean | 0.16284 | 0.16106 | **98.9%** | 0.14141 | 0.13750 (-2.8%) |

**Displacement FAILS** — the seed-1001 +6.4% did not replicate; the
registered promotion rule keeps V2 as the P3 arm. This is exactly the
single-seed pattern that fooled T83/PCN-v3, intercepted pre-spend by
the pre-registered ladder.

## Status

- N03a (0.10): closed (loses to its own no-lane base on both metrics).
- N03b (0.30): **diagnostic keeper with a Branch-B role** — beats
  classic on all three seeds (+11.7% 3-seed HV) and holds MORE Pareto
  points than V2 on every seed (2.875/3.0/3.125 vs 2.625/2.0/3.125);
  designated utility-metric candidate if V2's full-suite margin lands
  between parity and +5%. No further fraction scans (registered rule).
- M12 funnel guard on the first co-scheduled pair: PASSED — coverage
  8/8 both seeds, validations green, no validity-collapse signature;
  runtimes +~34% vs solo (endpoint sharing), results normal. Pairing
  adopted as standard per `../../tables/concurrency_policy.md`.
