# N05 Warmup Initialization — Pre-Registration (2026-07-03)

Status: registered before any run; blocked on the P0 V2 anchor package.

## Mechanism (single factor: quantile-freeze warmup length)

REvolution-QD, but the grid-quantile archive freezes its bin boundaries
after a different number of buffered successes:
`--qd_grid_quantile_warmup_successes {4 | 16}` (arms N05a / N05b) vs
the platform's 8. A shorter warmup starts archive-structured pressure
earlier; a longer one gives boundary estimation more evidence before
binning (the standard MAP-Elites random-init phase length — a fixed
schedule, not a trigger). Everything else identical to the pinned V2
anchor command.

## Natural-Extension Criterion check

1. "V2, but the archive's init phase is shorter (or longer)." 2. Knob:
   one integer, fixed schedule, no runtime trigger. 3. Single factor vs
   V2. 4. Operators/representation/budget/eval identical. 5. Published
   concept: MAP-Elites initialization-phase length.

## Prior evidence

T39 (operator-fair, `T0_positive_ablation`): shortening warmup 8 -> 4
fixed multi-pipe coverage in the sparse-yield family — the only
warmup-family read taken under `eoh_strategies`, and it was positive on
the yield/coverage axis. Never read on the V2 platform.

## Descriptor inputs / leakage

Frozen trio unchanged; warmup uses success counts only (no PPA-derived
descriptor inputs).

## Surface, comparators, gates

Same as N01/N03: frozen 8-design 8x5, seed ladder 1001 -> 1002/1003;
comparators = pinned classic + V2 anchor; plan gates verbatim, with
special attention to the coverage hard gate (this is the
yield-protection lane — a win that costs any classic-covered design is
still a kill).

## Artifacts (per arm)

`exp/natural_qd_push/n05_warmup_init_<UTC>/live/<arm>/seed_<s>/` plus
the standard package (operator audit, run validation, canonical HV-AUC,
direct raw PPA Pareto PNG, tier decision, follow-up note).

## Registered follow-up rule

Pick at most one direction (shorter or longer) from seed 1001; if
neither moves HV or coverage relative to V2 beyond noise, retire the
lane as mechanism-inert rather than scanning more values.
