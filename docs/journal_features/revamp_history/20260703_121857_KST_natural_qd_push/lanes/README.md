# Lanes Index — Natural QD Push

One page to understand every experiment lane: what it tests, which
arms ran, what the numbers said, and what we concluded. Each lane is a
single-mechanism variation of the **Smooth-QD V2 platform** (classic
REvolution operators and (thought, code, feedback) individuals +
MAP-Elites grid-quantile archive over the BD trio + bounded 5-elite
per-cell Pareto fronts + NSGA-II global parent selection + champion
refinement). Registry: `lane_registry.csv`. Gates: plan "Gates"
section. Verdict vocabulary: an arm must beat BOTH classic (promote
eligibility) AND V2 by >2% on HV and HV-AUC (promotion-arm rule) to
displace V2 as the full-RTLLM candidate.

## The bar every lane is measured against

Frozen 8-design 8x5 screen, operator-fair, coverage 8/8 everywhere:

| Reference | Seeds | Mean HV | Mean HV-AUC | Note |
| --- | --- | --- | --- | --- |
| classic REvolution | 1001 | 0.14064 | 0.12387 | reused June-25 root, recompute-verified |
| classic REvolution | 1001-1003 | 0.14418 | - | replication bar |
| **V2 platform (the bar)** | 1001 | **0.17376** | **0.14366** | `../p0_v2_anchor/` |
| **V2 platform (the bar)** | 1001-1003 | **0.16284 (+12.9%)** | **0.14141 (+16.2%)** | 3/3 seed wins vs classic |

## Standings at a glance (seed 1001 unless noted)

| Lane | Arm | Mean HV | vs classic | vs V2 | Status |
| --- | --- | --- | --- | --- | --- |
| N01 | elite_pareto_slot_2 | 0.15709 | +11.7% | -9.6% | diagnostic keeper |
| N01 | scalar_elite (control) | 0.14683 | +4.4% | -15.5% | diagnostic keeper |
| N02 | curiosity gamma 1.0 | running (chain 2) | - | - | in flight |
| N03 | front-slot lane 0.10 / 0.30 | running (chain 2) | - | - | in flight |
| N04 | budget shape | not started | - | - | registered draft |
| N05 | warmup_4 | 0.14927 | +6.1% | -14.1% | closed |
| N05 | warmup_16 | 0.16383 | +16.5% | -5.7% | parked |
| N06 | 3 wave-1 profiles | running (chain 2) | - | - | in flight, QUARANTINED until real probes |
| N07 | corrected-suite completion | not started | - | - | conditional |
| N08 | combination | blocked | - | - | needs a single-factor winner |

No lane has displaced V2 yet; V2 remains the registered promotion arm.

---

## N01 — Cell Retention Mode (`N01_cell_retention_mode/`)

**Question:** how much of the V2 win comes from what each archive cell
KEEPS? The platform keeps a bounded 5-elite Pareto front per cell;
these arms swap only that retention rule.

| Arm | Cell keeps | Mean HV | vs classic | vs V2 | HV-AUC | Pareto pts | Coverage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| classic (ref) | population, no archive | 0.14064 | - | -19.1% | 0.12387 | 3.25 | 8/8 |
| N01b scalar_elite | 1 scalar elite | 0.14683 | +4.4% | -15.5% | 0.12865 | 3.375 | 8/8 |
| N01a elite_pareto_slot_2 | champion + 1 front slot (T36 semantic) | 0.15709 | +11.7% | -9.6% | 0.13116 | 3.125 | 8/8 |
| V2 (ref) | 5-elite Pareto front | 0.17376 | +23.5% | - | 0.14366 | 2.625 | 8/8 |

**Takeaways (single-seed diagnostic; softened per codex review):**
retention capacity is monotone in HV on this seed — even scalar cells
beat classic, and each retention upgrade adds more; the frozen
thesis's per-cell Pareto fronts carry the largest share. Caveats: V2
beats classic on only 3/8 individual problems, the slot-2 -> V2 gain
concentrates in traffic_light/alu, and Pareto POINT counts run the
other way (richer cells concentrate mass into dominating designs).
Attribution ladder needs seed replication before any paper claim.
Registered follow-up if pursued: capacity ABOVE 5 (new card required).

## N02 — Curiosity Sampling (`N02_curiosity_sampling/`)

**Question:** does biasing one-parent draws toward under-populated
archive cells (weight = 1/occupancy^gamma) beat V2's uniform draws
from the same NSGA-II pool? Implemented as the self-contained
`src/revolution/qd_natural/` engine (`--search_mode
revolution_qd_natural --qd_curiosity_gamma`), zero edits to the shared
engine.

| Sub-track | Status | Result |
| --- | --- | --- |
| Engine + unit tests | done | 11 tests; pool ordering mirrors V2; gamma required-and-only-valid for the natural mode |
| Bounded live smoke (1 problem, 4x1, seed 42) | done | 107 s, config confirms natural mode + gamma 1.0, archive artifacts written; never evidence |
| Full screen, gamma 1.0, seed 1001 | running (chain 2) | pending |
| gamma 0.5 (N02b) | registered | only if gamma 1.0 shows signal |

**Takeaway so far:** mechanism is live and contract-clean; verdict
pending.

## N03 — Archive Parent Lane (`N03_archive_parent_lane/`)

**Question:** does drawing a fixed fraction of parents from the
archive's local-front slots help? Amended before launch: the
front-slot pool only exists under `elite_pareto_slot` cells, so N03
runs on the N01a cell mode and is attributed against N01a (recorded
two-factor exception vs V2).

| Arm | Lane fraction | Status |
| --- | --- | --- |
| N03a | 0.10 | running (chain 2) |
| N03b | 0.30 | running (chain 2) |

**Takeaway so far:** the pre-launch dependency catch (a bare V2+lane
arm would have silently drawn nothing) is itself the lane's first
result — command cards are audited against engine semantics before
spend.

## N04 — Budget Shape (`N04` — no directory yet)

**Question:** does the QD platform benefit more from deeper budgets
(6x7, 4x11) than classic does? Prior negative (T79) is bound to a
contaminated arm and does not carry. Not started; the pinned classic
6x7 comparator (0.1701) awaits recompute verification when this lane
opens. N05b's warmup-x-depth interaction question lives here too.

## N05 — Warmup Length (`N05_warmup_init/`)

**Question:** is the platform's quantile-freeze warmup (8 successes)
tuned right?

| Arm | Warmup | Mean HV | vs classic | vs V2 | HV-AUC | AUC vs V2 | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- |
| N05a | 4 | 0.14927 | +6.1% | -14.1% | 0.12020 | -16.3% | closed (loses both metrics) |
| V2 (ref) | 8 | 0.17376 | - | - | 0.14366 | - | platform |
| N05b | 16 | 0.16383 | +16.5% | -5.7% | 0.14224 | -0.99% | parked |

**Takeaways:** warmup 8 is near-optimal at this budget shape — a
positive tuning validation of the platform. N05b is PARKED, not
retired (codex review reframe): it nearly ties V2 on HV-AUC and
clearly clears classic, but cannot displace V2 under the
promotion-arm rule; revive inside N04 where depth changes what
fraction of a run the warmup covers.

## N06 — Descriptor Bake-Off (`N06_descriptor_bakeoff/`)

**Question (user-requested):** can an empirically strong,
theoretically grounded behavior space beat the frozen trio
{logic_depth, ff_depth, comb_width_log}? Key context from
`research_memo.md`: no descriptor bake-off has EVER run on the V2
platform (F12's negative was radical-regime evidence), while the
trio's collapse on small control logic is substrate-independent.

| Sub-track | Profile | Theory | Status |
| --- | --- | --- | --- |
| Wave 1 | journal_graph_testability_3d | cyclomatic + reconvergence + SCOAP testability | running (chain 2), QUARANTINED |
| Wave 1 | size_control_3d | structural control bar | running (chain 2), QUARANTINED |
| Wave 1 | random_hash_3d | falsification floor (random is not weak — T22) | running (chain 2), QUARANTINED |
| Wave 2 | theory_grounded_compact_8d + CVT | SCOAP histograms + Laplacian spectral entropy; zero collapses operator-fair | registered; full probe before launch |
| Follow-up | SR ReLU PCA (T19 family) | behavior-distribution embedding | registered idea; needs frozen-projection spec |

**Quarantine (codex review):** the pre-launch probes were
metadata-only, weaker than the card's sampled-extraction gate; wave-1
live results carry no tier decisions until real probe artifacts
(per-candidate values, collapse counts, occupied cells) are packaged
from the runs and pass. A challenger must beat BOTH the V2 trio
anchor AND the random floor, with archive-health co-reads.

## N07 — Corrected-Suite Completion (`N07` — no directory yet)

Due-diligence lane: screen the three never-rerun corrected arms'
descriptor profiles (rf_leafid structural, aurora raw-impl compact,
rf_deepgate hybrid) operator-fair before the negative map cites them.
Lowest priority; encoder-flavored lanes do not headline this push.

## N08 — Combination (`N08` — no directory yet)

Pre-registered merge of measured single-factor winners only. Blocked:
no lane has beaten V2 yet. If N06 or N02 produces a winner, the
combination card is written BEFORE any combined run.

---

Maintenance: update the standings table and per-lane sections whenever
a lane package lands; numbers come from each lane's
`package/pareto_analysis/aggregate_backend_metrics.csv` and
`package/tables/hv_auc.csv` (never hand-typed from memory — regenerate
via `scripts/report_screen_seed_summary.py` where applicable).
