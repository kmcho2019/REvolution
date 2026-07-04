# BD Variant Scoreboard (consolidated, 2026-07-04)

Every behavioral-descriptor variant measured in this push, both
scales, one page. All arms share the identical V2 platform mechanism
(code individuals, EoH six-op suite, grid-quantile archive, 16 cells,
warmup 8, pareto_front(5) cells, NSGA-II global selection, champion
0.5) — the ONLY factor that changes between rows is
`--qd_descriptor_profile`. Sources: `package/` tables here,
`../../p0_v2_anchor/`, `../../p3_full_rtllm/`. N03b is excluded — it
is a mechanism variant (parent-selection lane), not a BD variant; see
`../../p3_full_rtllm/p3b_closure.md`.

## 1. Screen scale (frozen 8-design 8x5, seed 1001)

| Descriptor profile | Axes (theory) | Mean HV | vs classic | vs trio | HV-AUC | Rank |
| --- | --- | --- | --- | --- | --- | --- |
| **journal_logic_ff_width_3d (trio, frozen)** | logic depth, FF depth, comb width (size) | **0.17376** | **+23.5%** | - | **0.14366** | 1 |
| journal_graph_testability_3d | cyclomatic, reconvergence, SCOAP (testability/structure) | 0.15195 | +8.0% | -12.6% | 0.12273 | 2 |
| size_control_3d | wire count, assign count, ctrl depth (size control) | 0.14129 | +0.5% | -18.7% | 0.12092 | 3 |
| random_hash_3d (floor) | deterministic netlist-hash axes (no semantics) | 0.13457 | -4.3% | -22.6% | 0.10978 | 4 |
| classic (no archive, reference) | - | 0.14064 | - | -19.1% | 0.12387 | - |

Trio context: 3-seed replicated at 0.16284 (+12.9%) / AUC 0.14141
(+16.2%); challengers are seed-1001 reads (single-factor screens).
Coverage: 8/8 for every arm. Ordering on BOTH metrics:
trio > testability > size-control > random — descriptor semantics are
real, and the frozen trio survives its first operator-fair challenge.

## 2. Archive health at screen scale (same runs)

| Profile | Problems with collapsed axes | Occupied cells (sum/8) | Health rank | HV rank |
| --- | --- | --- | --- | --- |
| random_hash_3d | **0/8** | **70** | 1 | 4 |
| size_control_3d | 3/8 | 37 | 2 | 3 |
| journal_graph_testability_3d | 4/8 | 51 | 3 | 2 |
| trio (V2) | 6/8 | 41 | 4 | **1** |

**Archive health and HV anti-correlate (rank inversion is exact).**
The healthiest, widest archive (random) scores worst; the most
collapse-prone space (trio) wins. Occupancy is not the optimization
lever on this platform; what retention + NSGA-II selection do on the
quality path is. Source: `probes/live_probe_summary.csv` (from
per-problem `descriptor_health.json`).

## 3. Suite scale (RTLLM 46 ref-complete, 8x5)

| Descriptor profile | Seeds | Mean HV | vs classic | HV-AUC46 | vs classic | Coverage |
| --- | --- | --- | --- | --- | --- | --- |
| trio (V2) | 5 | 0.098801 | 95.2% | 0.087428 | 100.5% | **166** (cls 164) |
| journal_graph_testability_3d | 2 (killed at gate) | 0.091397 | 87.5% (2-seed) | 0.079018 | 92.0% (2-seed) | **34+34/seed — best of ANY arm** |

gt3d per-seed AUC46: 0.083973 / 0.074062 (classic same-seeds:
0.090551 / 0.081183). The registered 2-seed gate (0.90x classic)
killed gt3d on HV before seeds 1003-1005; its coverage datum is kept:
it covered more designs per seed than classic (33/33) and the trio
(32/33) on both seeds.

## 4. The descriptor findings in one paragraph

Across both scales and four descriptor spaces on an identical
mechanism: (i) the frozen trio is the best HV descriptor despite the
worst collapse health — its axes align with the PPA quality path even
where they degenerate; (ii) descriptor semantics order the
challengers consistently (testability > size-control > random on both
screen metrics); (iii) what BD choice reliably moves is COVERAGE and
archive breadth, not HV — gt3d bought the best per-seed design
coverage in the campaign at the cost of ~8-12% HV; (iv) therefore BD
selection on this platform is a functionality/diversity dial, and the
trio remains the right default for HV-gated claims. Prior-regime
descriptor numbers (F12 quality deltas, T19 SR-PCA replay +16.8%,
CODE-EoH theory-profile reads) are NOT comparable to these tables —
regime flags and details in `research_memo.md`.

## 5. Not-yet-measured on this platform (registered, unlaunched)

| Profile | Status | Why it waits |
| --- | --- | --- |
| theory_grounded_compact_8d (+CVT, paired trio-CVT control) | registered wave 2 | needs 2 arms per read; suite evidence shows BD moves coverage, not HV; scoped out in `p3b_closure.md`, revisitable |
| SR ReLU PCA (T19 family) | registered follow-up idea | needs frozen-projection profile spec + holdout to stay leakage-clean |
| source_aligned_shape_density_3d (T73 axes) | backlog | wave-2 candidate if the descriptor question reopens |
