# Pareto REvolution TCAD Validation Adversarial Prompt

You are an independent adversarial validator. Decide whether the goal is
complete from artifacts, commands, raw run roots, and git history. Do not trust
the implementer summary or TODO checkmarks.

Read:

- `pareto_revolution_validation_plan.md`
- `pareto_revolution_validation_implementation_todo.md`
- `pareto_revolution_validation_implementation_history.md`
- `goal_template.md`
- the versioned claims addendum and mechanism card
- relevant source, tests, configs, ledgers, reports, run roots, and commits

Write the final report to
`pareto_revolution_validation_subagent_validation_report.md`. Return exactly
`PASS` or `FAIL` as the verdict. A negative experimental result may PASS only
when the registered negative-closure path is complete and honest.

## Hard Preconditions

Return FAIL immediately if any condition holds:

1. The accepted `journal_narrative.md` revision 3 was silently changed to fit
   this result, or no reviewed candidate-specific addendum predates evidence.
2. Any unregistered treatment configuration entered a decision, or more than
   one Pareto treatment configuration contributed to gate-bearing evidence.
   Registered comparator and technical-smoke configurations are excluded.
3. Any Pareto treatment or fresh comparator run launched for this goal used
   `single_thought_operator`, `M-T`, `C-D`, descriptors, cells, QD retention,
   or an adaptive scalar fallback. Registered historical V2 roots are exempt
   as descriptive evidence only.
4. Full RTLLM stages were launched out of gate order.
5. Full RTLLM or the overlapping revision-3 holdout was presented as fresh,
   paper-facing primary evidence despite the complete prior-use audit.
6. A failed final-HV gate was rescued by HV-AUC, archive health, selected seeds,
   complete cases, or a favorable task subset.
7. Required runs or report processes are still live.

## Method Inspection

Verify from code and tests that:

- one discriminated Pareto search mode exists and method state is narrow;
- Pareto-specific logic is outside the classic engine, the frozen
  `src/revolution/algorithm.py` hash is unchanged, and dispatch is thin;
- successful parents use the pinned without-replacement binary tournament and
  the pinned distinct-winner `C-F` procedure;
- successful survivors use NSGA-II over the exact registered candidate set,
  followed only by the pinned failed-offspring fill ordering;
- active objectives are power/area for combinational and power/area/timing for
  sequential designs; exactly the four frozen reference-incomplete RTLLM tasks
  resolve from unknown to sequential and every other unknown type is rejected;
- reference-complete tasks use normalized gains, reference-incomplete tasks use
  negative raw active PPA, and every Success candidate satisfies the required
  post-synthesis/PPA invariant;
- changing only scalar score cannot change Pareto parent or survivor choices;
- the Fail pool, classic EoH operators, UCB, prompts, evaluator, and budget are
  preserved;
- `C-F` receives distinct parents;
- the delivered Pareto archive is reproduced post hoc from full evaluated
  history and cannot affect search;
- classic behavior and tests did not regress.

Reject bloated config matrices, optional-state fallbacks, defensive exception
stacks, duplicated QD engine logic, or Pareto code placed directly into the
classic generation loop when a small explicit boundary was feasible. Check
type hints, useful Google-style docstrings, asserts for required data, and
exhaustive handling of typed variants.

## Evidence Inspection

Recompute or spot-check, rather than copy prose:

- manifest membership and SHA-256 hashes;
- the complete VerilogEval audit reproduces 156 source tasks and 156 prior
  evaluated outcomes; no task substitution or relaxed exclusion entered;
- the four frozen reference-incomplete circuit types match clocked reference
  RTL and no synthetic-reference fallback is reachable;
- seed/config/model/prompt/tool and comparator compatibility;
- candidate-evaluation counts, LLM calls, tokens, and the +/-10% auxiliary
  budget rule;
- operator counts and full evaluated-history completeness;
- final HV, fixed-denominator HV-AUC, valid-PPA coverage, yield, Pareto
  cardinality, and per-axis results;
- functional-any-pass and reference-beating coverage as separately named
  metrics, including resolution of the S07/S32 same-root discrepancy;
- seed-1001 stop, two-seed promotion, and five-seed full-RTLLM promotion;
- missing-treatment losses and reason codes;
- equivalence and synthesis-determinism evidence for showcased candidates.

Confirm the final classification is exact:

- positive development evidence only when five-seed full RTLLM final HV,
  valid-PPA, and functional-any-pass all meet fresh matched classic;
- supporting when parity or secondary evidence does not pass every gate;
- negative when a registered stop or final gate fails.

Confirm that no outcome is labeled `REF_WIN`, a paper-facing primary result, or
the complete TCAD extension. A genuinely fresh benchmark is outside this goal.

Confirm full RTLLM is labeled a repeatedly observed screening surface and that
no full multi-suite Branch-A claim is made without separate `NEW_OK` evidence.
Confirm scalar use in unchanged feedback/UCB reward is disclosed.

## Engineering And Reproducibility Inspection

- Run or inspect focused and full pytest evidence, ruff, pyright, ty, and
  `git diff --check`.
- Inspect report/validator tests when artifact semantics changed.
- Verify commands, raw roots, config snapshots, preflights, tool versions,
  hashes, ledgers, and handoffs are sufficient to reproduce the decision.
- Inspect each goal commit for atomic scope, Conventional Commit form,
  imperative subject, wrapped body, one sign-off, and no literal `\n` text.
- Confirm README, findings dashboard, and journal navigation reflect the final
  result and limitations.
- Confirm periodic read-only audits were recorded and their actionable findings
  were resolved or explicitly rejected with evidence.

## Report Format

```markdown
# Pareto REvolution Validation Report

## Verdict

PASS or FAIL

## Outcome Class Checked

Positive development evidence, supporting result, or negative closure.

## Evidence Recomputed

## Method And Code Findings

## Quantitative Gate Findings

## Reward-Hacking And Claim Risks

## Test, Documentation, And Commit Findings

## Required Fixes Before PASS
```

PASS is permitted only when the selected outcome path satisfies the plan and
the evidence is reproducible enough for that exact claim. Winning a metric is
not sufficient. Losing a metric is not an automatic FAIL when the negative
closure is the registered outcome.
