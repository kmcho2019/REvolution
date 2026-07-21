# H9 Implementation History

## Proposal

- Date: 2026-07-21
- State: `PROPOSED`
- Live spend: none
- Source implementation: none

The classic-only edit-breadth premise now satisfies H3's missing evidence
condition, but H3 remains retired because it combined contracts, locality
rejection, patching, and equivalence control. H9 isolates only the existing
post-Gen0 mutation representation and requires no core source change.

Before `READY`, independent reviewers must close novelty/naturalness,
hardware/EDA methodology, statistics/reporter translation, code simplicity,
and the exact candidate budget worksheet. No candidate config or result may be
used to alter the frozen program gates.

## Artifact Feasibility Audit

- Date: 2026-07-21
- Live spend: none

The existing engine preserves request metadata, generated-candidate status,
valid-PPA score rows, raw JSON/text deltas, parent and child RTL, and aggregate
failure reasons. Parent scores can be joined by candidate ID across generation
rows. No core logging change is required.

The audit also found that `diff_apply_policy=strict` disables fuzzy fallback
but still permits an empty-search append, while successful generation logs
record the outer JSON path rather than each exact-match phase. H9 therefore
uses deterministic reporter-side replay as its mechanism audit: every accepted
hunk must have a nonempty anchor that matches exactly once at its sequential
application point, and the replayed RTL must equal the saved child. Unsupported
generation pool-size telemetry was removed instead of adding runtime state.

Compact diff context was also rejected for this card: it omits the second
parent's RTL from C-F and would confound representation with information
availability. H9 freezes `diff_compact_context=false`; the resulting duplicate
copy of the first parent's RTL is disclosed as schema overhead and evaluated by
the existing resource-parity gate.

## Proposal Review Decision

- Date: 2026-07-21
- State: `RETIRED`
- Live spend: none
- Candidate implementation: none
- Admission ledger events: none

Independent novelty review identified direct collisions with AlphaEvolve and
CodeEvolve. Primary-source checking confirmed that AlphaEvolve applies deltas
to parent programs inside its evolutionary loop and reports a Verilog hardware
optimization, while CodeEvolve explicitly supports diff-based evolution or a
full-code rewrite. The global diff toggle scores zero for novelty and cannot
enter the live ladder.

The omitted classic strata were recomputed read-only over all 4,000 post-Gen0
offspring. Results use the same deterministic line edit-ratio definition:

| Scope | N | Valid-PPA pass/fail edit mean | Spearman rho |
| --- | ---: | ---: | ---: |
| Success origin, one parent | 1,900 | 0.529609 / 0.621488 | -0.250869 |
| Fail origin, one parent | 1,658 | 0.582580 / 0.526275 | +0.060274 |
| Success C-F, closer parent | 442 | 0.427000 / 0.555935 | -0.314816 |
| All offspring, first parent | 4,000 | 0.527392 / 0.556408 | -0.084988 |

The failed-pool reversal rejects the all-offspring causal premise. A future
role-conditioned representation policy would be a different mechanism and
must independently clear novelty, implementation-simplicity, and budget gates.
H9 is not revised into that idea.
