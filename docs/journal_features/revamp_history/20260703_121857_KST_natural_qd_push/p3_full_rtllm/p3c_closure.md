# P3c Closure — Suite-Scale BD Sweep Complete (2026-07-04)

All ten runs completed, packaged, operator-audited, and config-pin
validated; the chain finished with zero run-level failures and the
compact_8d health gate passed with its semantic ruling recorded
(`p3c_sweep/cvt_pair/health_gate_rationale.md`).

## Final suite sweep table (46 ref-complete, 8x5, seeds 1001+1002; classic 2-seed reference 0.104479)

| Descriptor / geometry | Mean HV | vs classic | Coverage/seed | Collapse note |
| --- | --- | --- | --- | --- |
| trio on grid (V2 reference) | 0.098539 | 94.3% | 32+33 | trio degenerates broadly (26/50 nonzero-obs problems collapsed on CVT twin) |
| **compact_8d on CVT** | 0.097600 | 93.4% | 32+32 | **6/50 collapsed — ~4x more collapse-resistant than trio on identical geometry** |
| trio on CVT (geometry control) | 0.097440 | 93.3% | 33+32 | - |
| size_control_3d | 0.096091 | 92.0% | 32+31 | - |
| random_hash_3d (floor) | 0.091996 | 88.1% | 32+31 | healthiest screen archive, worst-tier HV |
| source_aligned_shape_density_3d | 0.091818 | 87.9% | 32+32 | - |
| journal_graph_testability_3d | 0.091397 | 87.5% | **34+34 (best)** | HV-killed in P3b; coverage datum kept |

## Answers (the user's descriptor question, closed at both scales)

1. **Two HV tiers exist and descriptor choice sets them**: the
   trio-family and compact_8d sit at 93-94% of classic; every other
   profile sits at 87-92%. No profile beats classic or the +5% gate
   at suite scale.
2. **Attribution is clean**: archive geometry (CVT vs grid) is a wash
   (trio-CVT within 1.1% of trio-grid); the descriptor is the active
   factor.
3. **compact_8d is the theoretically-solid match**: it TIES the trio's
   HV (+0.2% at n=2) while being ~4x more collapse-resistant on
   identical geometry — trio-level optimization without the trio's
   degeneracy (the M13 criticism). Under the narrative's predeclared
   bake-off rule this is a health-grounds swap CANDIDATE, not an HV
   winner; a swap decision would need the full 5-seed + contract
   treatment and is deferred to the manuscript decision (recorded as
   an open option, not exercised).
4. **Coverage remains uniquely semantic**: across seven suite-measured
   profile/geometry combinations, ONLY testability semantics (gt3d)
   lifted design coverage above classic; random and every structural
   profile cost coverage. The falsification held.
5. Descriptor choice also modulates the engine's effective operator
   mix (C-D/M-T fill lanes fire only under non-trio spaces) — a
   mechanism observation for the methods section.

## Campaign state

P0-P3c: 27 live runs, all operator-fair, gate-governed, packaged, and
reviewer-verified. No further runs are registered; P4 synthesis
(canonical statistics, Branch-B utility metric, central report,
dashboard refresh, adversarial sign-off) closes the push.
