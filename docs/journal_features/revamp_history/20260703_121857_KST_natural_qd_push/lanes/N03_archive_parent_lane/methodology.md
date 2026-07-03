# N03 Archive Parent Lane — Pre-Registration (2026-07-03)

Status: registered before any run; blocked on the P0 V2 anchor package.

## Mechanism (single factor: parent-selection mode's fixed archive lane)

REvolution-QD, but a fixed fraction of parent draws comes from the
archive's local-front slot pool instead of the NSGA-II global pool:
`--qd_parent_selection front_slot_lane_nsga2` with
`--qd_front_slot_lane_fraction {0.10 | 0.30}` (arms N03a / N03b).
Existing engine mode (`engine.py:_sample_success_parents`); champion
lane preserved.

Amendment (2026-07-03, before any launch): the front-slot pool exists
only under `qd_cell_mode=elite_pareto_slot`, so N03 arms run on the
N01a cell mode (`elite_pareto_slot`, max 2) rather than the platform's
`pareto_front(5)`. The lane is therefore single-factor relative to
N01a, not V2: verdicts attribute the lane effect from the N03x-vs-N01a
delta, and N03 is sequenced after N01a's seed-1001 read (re-registered
if N01a is a kill).

## Natural-Extension Criterion check

1. "V2, but 10% (or 30%) of parents are drawn from archive front
   slots." 2. Knobs: parent-selection mode + one fixed fraction — no
   triggers. 3. Single factor vs V2 (selection source mix only).
   4. Operators/representation/budget/eval identical. 5. Published
   concept: MAP-Elites archive-parent sampling (uniform-over-elites
   lane blended with rank-based selection).

## Prior evidence

T54/T75 exercised front-slot lanes only under the contaminated
`single_thought_operator` stack (T75 used fraction 0.30) — negative
results there are not citable against the mechanism. Never measured
operator-fair; that is the point of this lane.

## Descriptor inputs / leakage

Frozen trio unchanged; lane draws use archive membership only.

## Surface, comparators, gates

Same as N01: frozen 8-design 8x5, seed ladder 1001 -> 1002/1003;
comparators = pinned classic + V2 anchor; plan gates verbatim. The
N03x-vs-V2 delta attributes the lane effect; between-arm read (0.10 vs
0.30) picks at most one arm for replication.

## Artifacts (per arm)

`exp/natural_qd_push/n03_archive_parent_lane_<UTC>/live/<arm>/seed_<s>/`
plus the standard package (operator audit, run validation, canonical
HV-AUC, direct raw PPA Pareto PNG, tier decision, follow-up note).

## Registered follow-up rule

If both fractions lose to V2 with a front-loss or exploration-tax
signature, retire the lane (do not scan more fractions); if one leads,
replicate it at seeds 1002/1003 before any combination registration.
