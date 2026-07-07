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
| N03 | front_slot_lane_030 | 0.16106 (3-seed) | +11.7% (3/3 wins) | -1.1% (3-seed) | keeper; Branch-B utility candidate; displacement failed |
| N01 | elite_pareto_slot_2 | 0.15709 | +11.7% | -9.6% | diagnostic keeper |
| N02 | curiosity gamma 1.0 | 0.15449 | +9.8% | -11.1% | KILL (coverage 7/8); exploration tax |
| N02 | curiosity gamma 0.5 | 0.12864 | -8.5% | -26.0% | retired; coverage fixed, quality worse |
| N06 | graph_testability_3d | 0.15195 | +8.0% | -12.6% | diagnostic keeper (best challenger; trio wins) |
| N05 | warmup_16 | 0.16383 | +16.5% | -5.7% | parked |
| N05 | warmup_4 | 0.14927 | +6.1% | -14.1% | closed |
| N01 | scalar_elite (control) | 0.14683 | +4.4% | -15.5% | diagnostic keeper |
| N03 | front_slot_lane_010 | 0.14160 | +0.7% | -18.5% | closed (weak lane hurts) |
| N06 | size_control_3d | 0.14129 | +0.5% | -18.7% | closed |
| N06 | random_hash_3d (floor) | 0.13457 | -4.3% | -22.6% | control closed (health-vs-HV finding) |
| N04 | V2 6x7 | 0.17200 | +1.1% | n/a | no escalation: HV near tie, HV-AUC 90.5% |
| N07 | source-aligned RF timing | 0.12759 | -9.3% | -26.6% | N07a closed; descriptor-collapse/front-loss |
| N07 | implemented structural compact | 0.12395 | -11.9% | -28.7% | N07c closed; descriptor-collapse/front-loss |
| N08 | combination | blocked | - | - | needs replicated winners |
| N09 | pareto_front capacity 7 | 0.15928 | +13.3% | -8.3% | diagnostic keeper; no escalation |
| N10 | SR-ReLU PCA descriptor | probe pass | - | - | smoke-passed; live screen eligible |

**Promotion decision (2026-07-03): V2 stays the P3 arm.** N03b cleared
the bar at seed 1001 (+6.4%/+8.0%) but replication landed at 98.9% HV
/ -2.8% AUC vs V2 — the pre-registered ladder intercepted a seed
artifact before any full-suite spend. N03b remains the best
non-platform arm (beats classic 3/3 seeds, better front breadth than
V2 on every seed) and the Branch-B utility candidate.

## Full-suite standings (P3/P3b: RTLLM 46 ref-complete, 8x5)

| Arm | Seeds | Mean HV | vs classic | HV-AUC | Coverage | Verdict |
| --- | --- | --- | --- | --- | --- | --- |
| classic (reused roots) | 5 | 0.103802 | - | 0.086982 | 164/230 | baseline (HV recompute = pinned; AUC is the canonical recompute, see tables/README correction note) |
| **N03b front-slot lane** | 5 | **0.100587** | **96.9%** | **0.089186 (102.5%)** | 163/230 | best QD arm at suite scale; best AUC of ALL arms; seed-1003 outright win |
| V2 platform | 5 | 0.098801 | 95.2% | 0.087428 (100.5%) | **166/230** | +5% gate FAILS; AUC tie; coverage edge |
| gt3d descriptor swap | 2 | 0.091397 | 87.5% (2-seed) | - | 34+34 designs (best/seed) | KILLED at gate; coverage datum kept |

Suite-family finding (`../p3_full_rtllm/p3b_closure.md`): the QD
mechanisms reallocate a few HV points into anytime performance (AUC),
coverage, or front breadth depending on the knob — a controllable
trade surface at the scale where LLM capability binds. N03b and V2
INVERT their screen-scale ordering at suite scale — the transfer gap
applies between QD variants too.

**The two-scale story** (`../p3_full_rtllm/five_seed_verdict.md`): the
natural QD extension WINS at screening scale (+12.9%, 3/3 seeds) and
lands at no-cost parity with a coverage edge at suite scale, where
outcomes are LLM-capability-bound. The measured screen->suite transfer
gap (~18 points) is itself a methodology finding and triggered the
P3b amendment (near-band arms get direct suite probes). Suite-scale
descriptor result so far: BD semantics move COVERAGE (gt3d covered
more designs than classic on both seeds), not HV.

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
| Engine + focused tests | done | pool ordering mirrors V2; gamma required-and-only-valid for the natural mode |
| Bounded live smoke (1 problem, 4x1, seed 42) | done | 107 s, clean; never evidence |
| Full screen, gamma 1.0, seed 1001 | done | HV 0.15449 (+9.8% classic, -11.1% V2) but **coverage 7/8 — HARD-GATE KILL** (gshare lost, 0 valid-PPA) |
| gamma 0.5 (N02b) | done | HV 0.12864 (-8.5% classic, -26.0% V2), HV-AUC 0.11454, coverage 8/8 |

**Takeaways:** curiosity weighting is a mechanism negative. Gamma 1.0
taxes exactly the problem that needs concentrated exploitation (the
largest design, gshare) into zero valid candidates. Gamma 0.5 recovers
valid-PPA coverage, including gshare, but falls below both classic and
V2 on final HV and HV-AUC. Retire the lane; do not scan gamma without a
new mechanism card.

## N03 — Archive Parent Lane (`N03_archive_parent_lane/`)

**Question:** does drawing a fixed fraction of parents from the
archive's local-front slots help? Amended before launch: the
front-slot pool only exists under `elite_pareto_slot` cells, so N03
runs on the N01a cell mode and is attributed against N01a (recorded
two-factor exception vs V2).

| Arm | Lane fraction | Mean HV | vs N01a | vs V2 | HV-AUC | Status |
| --- | --- | --- | --- | --- | --- | --- |
| N03a | 0.10 | 0.14160 | -9.9% | -18.5% | 0.12570 | closed (weak lane hurts) |
| **N03b** | **0.30** | **0.18486** | **+17.7%** | **+6.4%** | **0.15511 (+8.0%)** | seed-1001 win; 3-seed displacement failed |

**Takeaways:** N03b cleared the promotion bar at seed 1001, but the
registered replication ladder reversed the read: three-seed mean HV
`0.16106` vs V2 `0.16284` (`98.9%`), HV-AUC `0.13750` vs `0.14141`
(`-2.8%`). V2 stays the P3 arm. N03b remains a diagnostic keeper and
Branch-B utility candidate because it beats classic on all three screen
seeds and preserves more Pareto-front material than V2. Fraction
response is non-monotone at n=1 (0.10 hurts, 0.30 helps), so no
fraction scan is allowed. The earlier pre-launch dependency catch (a
bare V2+lane arm silently draws nothing) remains a process win.

## N04 — Budget Shape (`N04_budget_shape/`)

**Question:** does the QD platform benefit more from deeper budgets
(6x7, 4x11) than classic does? Prior negative (T79) is bound to a
contaminated arm and does not carry. N04 reran the faithful V2 platform
at 6x7 against the recompute-verified T79 classic 6x7 comparator.

| Arm | Mean HV | vs classic | HV-AUC | Coverage | Verdict |
| --- | --- | --- | --- | --- | --- |
| classic 6x7 | 0.17010 | - | 0.14622 | 8/8 | verified comparator |
| V2 6x7 | 0.17200 | +1.1% | 0.13227 (90.5%) | 8/8 | no escalation |

**Takeaway:** deeper budget does not rescue a headline win. V2 catches
classic on final HV only late, while HV-AUC and Pareto breadth degrade
(1.75 vs 2.625 points). Cause class: front-loss / anytime-loss. No 4x11
spend is justified by this read; N05b warmup-depth remains only a
diagnostic idea, not a promotion path.

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

| Sub-track | Profile | Mean HV | vs V2 | Collapsed probs | Occupied cells | Verdict |
| --- | --- | --- | --- | --- | --- | --- |
| ref | V2 trio | 0.17376 | - | 6/8 | 41 | winner despite worst health |
| Wave 1 | journal_graph_testability_3d | 0.15195 | -12.6% | 4/8 | 51 | diagnostic keeper (best challenger) |
| Wave 1 | size_control_3d | 0.14129 | -18.7% | 3/8 | 37 | closed |
| Wave 1 | random_hash_3d (floor) | 0.13457 | -22.6% | 0/8 | 70 | control closed |
| Wave 2 | theory_grounded_compact_8d + CVT | 0.09760 suite | - | 6/50 suite | - | health-grounds swap candidate; no HV win |
| Follow-up | SR ReLU PCA (T19 family) | registered idea | - | - | - | needs frozen-projection spec |

**Quarantine LIFTED** (real probe artifact:
`probes/live_probe_summary.csv` from the runs' descriptor_health
data). **Headline findings:** the frozen trio survives its first
operator-fair challenge, winning both metrics DESPITE the worst
collapse health (6/8 degenerate problems) — while the random floor
keeps the healthiest, widest archive (0 collapses, 70 cells) and
scores worst. Archive health and HV anti-correlate on this platform:
occupancy is not the lever. Descriptor semantics still order the
challengers (testability > size control > random). Also observed:
challenger spaces trigger the engine's C-D/M-T fill lanes that the
trio never fires — descriptor choice changes the effective operator
mix (visible in operator_contract.csv).

## N07 — Corrected-Suite Completion (`N07_corrected_suite_completion/`)

Due-diligence lane: screen the three never-rerun corrected arms'
descriptor profiles (rf_leafid structural, aurora raw-impl compact,
rf_deepgate hybrid) operator-fair before the negative map cites them.
The lane is registered as V2-faithful descriptor-only due diligence.
The 20260630 delayed/archive-activation commands are provenance only and
are forbidden launch templates because they change multiple archive
knobs at once. All three lightweight descriptor probes resolve with
`requires_ppa=false`.

N07a source-aligned RF timing passed its reference extraction smoke, but
the live seed-1001 screen closed negative: mean HV `0.12759` (`90.7%`
of classic, `73.4%` of V2), HV-AUC `0.10013`, 8/8 coverage, and
`5/8` live descriptor-collapse problems plus one uninitialized archive.
Cause class: descriptor-collapse plus front-loss. Do not escalate N07a.
N07c implemented structural compact passed a generated-candidate smoke,
then the live seed-1001 screen also closed negative: mean HV `0.12395`
(`88.1%` of classic, `71.3%` of V2), HV-AUC `0.10457`, 8/8 coverage,
and live descriptor health degraded to `3/8` collapsed-axis problems
plus two uninitialized archives. Cause class: descriptor-collapse plus
front-loss. Do not escalate N07c. N07b remains
bounded-extraction-smoke gated and low priority.

## N08 — Combination (`N08` — no directory yet)

Pre-registered merge of measured single-factor winners only. Blocked:
no lane has beaten V2 yet. If N06 or N02 produces a winner, the
combination card is written BEFORE any combined run.

## N09 — Pareto Capacity (`N09_pareto_capacity/`)

**Question:** does the V2 archive lose useful front material because
each cell keeps only five non-dominated elites? This is the registered
capacity-above-five follow-up from N01, now narrowed to a single
config-only probe: `qd_cell_mode=pareto_front` unchanged, but
`qd_max_elites_per_cell=7`.

The seed-1001 screen retained coverage and beat classic on mean HV/AUC
(`0.15928`, +13.3%; HV-AUC +14.5%) but did not beat V2 (`91.7%` HV,
`98.7%` HV-AUC). It also reduced Pareto points (2.375 vs V2's 2.625)
and valid-PPA count (182 vs 196). Cause class: capacity-inert plus
front-loss. Keep as a diagnostic result; do not escalate or scan
capacity values.

## N10 — SR-ReLU PCA (`N10_sr_relu_pca/`)

**Question:** can the strongest synthesis-response replay lead move onto
the V2 platform without leakage or extraction collapse? This is a
descriptor-only probe: same V2 archive, operators, representation,
parent selection, warmup, and capacity; only the descriptor profile
would change to `sr_pca_3d` if a live screen launches.

The frozen T19 SR-ReLU artifact trains on six development problems and
has no overlap with the frozen 8-design screen. The extraction smoke
ran fresh ST-NOD Yosys stage dumps on one existing V2 seed-1001
candidate per screen problem, projected descriptors, and wrote compact
health artifacts under `N10_sr_relu_pca/smokes/`. Result: PASS —
8/8 problems, initialized `4x4x4`, 8 occupied cells, and no collapsed
axes. This clears only the seed-1001 live-screen gate; it is not an HV
or functionality result. Full-RTLLM use would require a fresh
holdout-clean artifact because the old fitting corpus includes RTLLM
problems.

---

Maintenance: update the standings table and per-lane sections whenever
a lane package lands; numbers come from each lane's
`package/pareto_analysis/aggregate_backend_metrics.csv` and
`package/tables/hv_auc.csv` (never hand-typed from memory — regenerate
via `scripts/report_screen_seed_summary.py` where applicable).
