# Pareto REvolution Final Closure Review

Independent read-only review run with `claude -p` on 2026-07-13 UTC. The
first broad invocation reached its 900-second bound without a verdict. A
focused rerun covered the frozen contracts, compact raw tables, isolated
source, tests, and journal posture documents and completed successfully.

## Verdict

**PASS** - preserve the negative closure and launch no additional seed in
this goal.

No blocking finding was identified. The reviewer independently reconstructed
the frozen two-seed gate from package tables rather than accepting the compact
summary.

## Independently Recomputed Evidence

| Metric | Classic | Pareto | Gate |
| --- | ---: | ---: | --- |
| Seed-1001 final HV46 | 0.101013240548 | 0.098858992569 | - |
| Seed-1002 final HV46 | 0.108477115543 | 0.109122064646 | - |
| Two-seed mean final HV46 | 0.104745178045 | 0.103990528608 | FAIL |
| Valid-PPA coverage | 65/92 | 65/92 | PASS |
| Functional-any-pass coverage | 75/92 | 74/92 | FAIL |
| Full-50 functional-any-pass | 83/100 | 82/100 | Supporting |
| Mean HV-AUC46 | 0.090500253790 | 0.083316533890 | Supporting loss |

The independent means differ from the tracked aggregate by at most one unit
in the last place due to floating-point summation order. The final-HV delta is
`-0.000754649438`, or `99.280%` retention.

The reviewer also reproduced 2,017 versus 1,978 valid-PPA samples, the
16/19/57 Pareto-win/classic-win/tie map over 92 design-seed units, and the
negative cross-seed correlation. The frozen gate therefore fails on final HV
and functionality. Seeds 1003-1005 must not run.

## Method And Scope Findings

Both arms evaluate 2,400 candidates per seed. Runtime arguments differ only
in `search_mode` and `save_path`. Operator contracts contain initial samples
and the six EoH operators, with no single-thought or unregistered strategy.
Call, token, and runtime differences are disclosed and remain within the
frozen tolerance.

The classic engine SHA-256 reproduced exactly as
`78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
The treatment remains isolated under `src/revolution/pareto_revolution/` and
contains no descriptor, cell, archive, capacity, warmup, or emitter state.
The reviewer confirmed that scalar score does not enter NSGA-II ranking and
that its residual feedback/UCB use is disclosed.

## Documentation Findings

The goal README, two-seed report, findings dashboard, and narrative posture
all classify the method as a negative primary candidate. They do not use
HV-AUC, reference-beating coverage, or front size to rescue the failed gate.
The accepted `journal_narrative.md` remains unchanged.

Recorded local verification is credible: full pytest passed with `1039
passed, 4 skipped`; ruff, pyright, ty, and `git diff --check` passed; and the
goal commit-message audit found one sign-off and compliant formatting on each
commit.

## Non-Blocking Residual Risks

- Two-seed statistics are development diagnostics, not paper-level evidence.
- All current VerilogEval tasks have prior experimental exposure.
- The smoke did not obtain live valid PPA for Prob006, although the raw branch
  ran successfully on Prob013 and Prob018 in the full suite and is unit-tested.
- Tiny last-place numeric differences depend on summation order.
- Two launch commits share a subject but have distinct, accurate bodies.

## Recommendation

Close this candidate as a clean negative result. Preserve its secondary
diversity observations as characterization only. Any reference-seeded Pareto
method or other journal candidate requires a separate preregistered goal.
