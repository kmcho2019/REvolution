# N02 Curiosity Sampling — Pre-Registration (2026-07-03)

Status: registered before implementation; blocked on the P0 V2 anchor
package and a bounded one-problem live smoke of the new engine.

## Mechanism (single factor: one-parent draw distribution over the pool)

REvolution-QD, but one-parent draws from the V2 NSGA-II global pool are
weighted toward under-populated archive cells instead of uniform:
weight = (1 / cell_occupancy) ** gamma. Pool construction (rank,
crowding, trim) is unchanged from V2; the C-F two-parent path is
untouched, so the single factor is exactly the one-parent draw
distribution. Arms: gamma 1.0 (N02a); gamma 0.5 registered as N02b only
if N02a shows signal.

## Implementation (per plan code-organization rules)

Self-contained subpackage `src/revolution/qd_natural/` with
`NaturalQDEngine(QDEngine)` overriding only `_sample_success_parents`
(champion lane preserved; empty-pool falls back to `super()`), plus a
pure `curiosity_pool()` helper. Selected via
`--search_mode revolution_qd_natural` + `--qd_curiosity_gamma`;
`src/revolution/qd/engine.py` is not modified. The engine asserts
`qd_parent_selection == nsga2_global_rank` (curiosity composes only
with the V2 selection).

## Natural-Extension Criterion check

1. "V2, but parents are drawn from the same NSGA-II pool with
   inverse-cell-occupancy weights." 2. Knobs: gamma (one number; mode
   flag selects the engine) — no triggers. 3. Single factor vs V2.
   4. Operators/representation/budget/eval identical. 5. Published
   concept: curiosity/novelty-weighted selection over MAP-Elites elites.

## Prior evidence

Idea-backlog entry "Smooth-QD-v2 Pareto-biased parent sampling"
(untried); MAP-Elites uniform-over-elites vs fitness-proportional
selection literature. No contaminated prior negative exists for this
mechanism.

## Descriptor inputs / leakage

Frozen trio unchanged; weights use archive cell occupancy only (no
PPA/fitness/HV/rank/pass-rate/problem-id inputs — occupancy is a
behavioral-space quantity, consistent with the BD-input exclusions).

## Surface, comparators, gates

Same as N01/N03/N05: frozen 8-design 8x5, seed ladder 1001 ->
1002/1003; comparators = pinned classic + V2 anchor; plan gates
verbatim. Before the screen: focused unit tests (pool parity with V2
ordering at the kept set; weight math; gamma>0 assertion) and a bounded
one-problem live smoke with the run validator.

## Artifacts (per arm)

`exp/natural_qd_push/n02_curiosity_<UTC>/live/<arm>/seed_<s>/` plus the
standard package (operator audit, run validation, canonical HV-AUC,
direct raw PPA Pareto PNG, tier decision, follow-up note).

## Registered follow-up rule

If gamma 1.0 loses to V2 with an exploration-tax signature, try gamma
0.5 once (N02b) before retiring; never scan more than these two values
without a new card and a mechanism-level diagnosis.
