# N06 Descriptor Bake-Off — Wave-1 Seed-1001 Result (2026-07-03)

Runs: `exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/`.
Quarantine LIFTED: the real probe artifact
(`probes/live_probe_summary.csv`, built from per-problem
`descriptor_health.json`) shows extraction succeeded on 8/8 problems
for every arm with per-axis unique counts and collapse states recorded.
Operator contracts pass (zero single-thought; the C-D diverse-parent
crossover fired 15-25x in these arms — ruled admissible for QD arms as
an engine fill-phase lane, see history 2026-07-03). Config-pinned
validations pass.

## Read (frozen 8-design 8x5, seed 1001; first-ever V2-platform bake-off)

| Arm | Mean HV | vs classic | vs V2 | HV-AUC | Collapsed problems | Occupied cells | Coverage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| V2 trio (ref) | 0.17376 | +23.5% | - | 0.14366 | **6/8** | 41 | 8/8 |
| N06b graph_testability_3d | 0.15195 | +8.0% | -12.6% | 0.12273 | 4/8 | 51 | 8/8 |
| N06c size_control_3d | 0.14129 | +0.5% | -18.7% | 0.12092 | 3/8 | 37 | 8/8 |
| N06d random_hash_3d (floor) | 0.13457 | -4.3% | -22.6% | 0.10978 | **0/8** | **70** | 8/8 |

## Takeaways (single seed)

1. **The frozen trio survives its first operator-fair challenge** —
   it wins HV and HV-AUC against all three challengers despite having
   the WORST collapse health (6/8 problems degenerate). The F12-era
   worry that trio collapse costs performance is not supported on the
   V2 platform at this seed.
2. **Archive health anti-correlates with HV here**: random_hash keeps
   the healthiest, widest archive (0 collapses, 70 cells) and scores
   worst — even below classic. Occupancy is not the lever; what the
   retention + NSGA-II selection do on the quality path is.
3. **Descriptor semantics still order the challengers**: testability/
   reconvergence/cyclomatic > structural size control > random on both
   metrics, and graph_testability beats the random floor cleanly (+13%
   HV) — semantic content is real, just not enough to displace the
   trio.
4. Mechanism observation: challenger descriptor spaces trigger the
   engine's fill/backfill lanes (C-D/M-T) that the trio never fires —
   descriptor choice changes the effective operator mix. Reported, and
   visible in `operator_contract.csv`.

## Tier decisions

- N06b graph_testability_3d: diagnostic keeper (beats classic and the
  random floor; loses to trio). Not promoted; candidate for a wave-2
  co-read.
- N06c size_control_3d: closed (classic-tie; loses to trio and to
  N06b — the structural bar adds nothing on this platform).
- N06d random_hash_3d: control served its purpose (floor + the
  health-vs-HV finding); closed.
- Wave 2 (`theory_grounded_compact_8d` + trio-CVT paired control)
  remains registered with its full sampled probe required BEFORE
  launch; given wave-1's trio win, wave 2 runs at reduced priority
  behind the N03b promotion test.
