# Pareto REvolution Validation Report

## Verdict

PASS

The frozen two-seed gate, isolated implementation, compact evidence, and
negative documentation posture passed final independent read-only review.
No required fix remains.

## Outcome Class Checked

Negative primary-candidate closure. Global descriptor-free Pareto parent and
survivor selection did not satisfy the preregistered promotion gate.

## Evidence Recomputed

| Metric | Classic | Pareto | Result |
| --- | ---: | ---: | --- |
| Mean final HV46, seeds 1001-1002 | 0.104745178045 | 0.103990528608 | FAIL |
| Mean HV-AUC46, seeds 1001-1002 | 0.090500253790 | 0.083316533890 | Loss |
| Valid-PPA coverage | 65/92 | 65/92 | PASS |
| Functional-any-pass coverage | 75/92 | 74/92 | FAIL |
| Valid-PPA samples | 2017 | 1978 | Supporting loss |
| Evaluated candidates | 4800 | 4800 | Matched |

The reviewer recomputed each seed's HV from package per-problem tables and
recounted coverage from package report rows. Differences from tracked decimal
values were at most one floating-point unit in the last place.

## Method And Code Findings

The classic engine hash matches the frozen value. The treatment is isolated
under `src/revolution/pareto_revolution/`, descriptor-free, and limited to
NSGA-II successful-parent and successful-survivor selection. It contains no
QD cell/archive state, hidden variant, or broad fallback path. Only initial
samples and the six frozen EoH operators appear in runtime artifacts.

Scalar score does not enter Pareto rank or crowding. Its residual use for
feedback and operator UCB remains disclosed as a design limitation.

## Quantitative Gate Findings

The final-HV condition fails because `0.103990528608` is below
`0.104745178045`. Valid-PPA coverage ties and passes. Functional coverage
fails by one design-seed unit. The two-seed gate therefore fails two of three
conditions, and seeds 1003-1005 are correctly closed.

HV-AUC also trails classic and cannot rescue final HV under the contract.
Reference-beating coverage, positive-HV count, and mean front size are
secondary characterization only.

## Reward-Hacking And Claim Risks

No metric substitution, subset change, variant tuning, or retrospective seed
extension entered the decision. The documents consistently state a negative
primary result. The accepted journal claims contract remains unchanged.

Residual risks are the two-seed development scope, prior exposure of all
current VerilogEval tasks, synthesis-proxy limits, and scalar feedback/UCB.
These are disclosed and do not block a reproducible negative closure.

## Test, Documentation, And Commit Findings

Full pytest passed `1039 passed, 4 skipped`. Ruff, pyright, ty, locked hashes,
JSONL parsing, path checks, and `git diff --check` passed. Goal commits were
audited for conventional headers, wrapped bodies, one sign-off, and no raw
newline text. Compact evidence and handoff documentation are complete.

Final external evidence is preserved at
`reviews/20260713_claude_final_closure_review.md`.

## Required Fixes Before PASS

None.
