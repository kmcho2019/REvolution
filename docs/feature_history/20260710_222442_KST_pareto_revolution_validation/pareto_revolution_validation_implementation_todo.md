# Pareto REvolution TCAD Validation TODO

Line limit: 120 lines. Keep this checklist concise. Move commands, results,
failures, and rationale to
`pareto_revolution_validation_implementation_history.md`.

Central plan: `pareto_revolution_validation_plan.md`.
Adversarial rubric: `pareto_revolution_validation_adversarial_prompt.md`.

## Scaffold Review

- [x] Ground the draft in the accepted narrative, current dashboard, QD
      negative map, and 2026-07-10 advisor bundle.
- [x] Register one candidate: global Pareto parent and survivor selection on
      the classic substrate.
- [x] Define positive, supporting, and negative completion paths.
- [ ] Obtain user/advisor approval of the method contract, parent+survivor
      bundling, and quantitative gates before activating the goal.

## Stage 0: Freeze

- [ ] Re-read the journal onboarding documents in required order.
- [ ] Write the versioned method and claims addendum without changing accepted
      `journal_narrative.md` revision 3.
- [ ] Run a read-only adversarial review of the addendum and resolve every FAIL.
- [ ] Complete the zero-compute discarded-front audit or document unavailable
      historical state exactly.
- [ ] Resolve the same-root S07/S32 classic coverage discrepancy with one
      canonical definition and regression test.
- [ ] Freeze and audit a prior-run-disjoint 20-task VerilogEval holdout; mark
      the overlapping revision-3 holdout legacy descriptive evidence only.
- [ ] Freeze and hash RTLLM, fresh holdout, seeds, model, prompts, tools, and
      budgets.
- [ ] Register compatible classic and V2 full-suite roots; rerun only a
      comparator that fails compatibility audit.
- [ ] Freeze the one Pareto arm, commands, output roots, report commands, and
      stop/promotion rules before any evidence run.
- [ ] Add rerun-ledger and restart-handoff locations.

## Stage 1: Implementation

- [ ] Add one `revolution_pareto` discriminated search mode.
- [ ] Keep Pareto-specific logic in `src/revolution/pareto_revolution/`.
- [ ] Reuse existing PPA gain, active-axis, and rank/crowding primitives.
- [ ] Implement successful-parent binary tournament by rank/crowding.
- [ ] Implement successful-survivor NSGA-II environmental selection.
- [ ] Keep Fail-pool, EoH operator, UCB, prompt, feedback, evaluator, and budget
      behavior unchanged.
- [ ] Build the delivered global front post hoc; prove it is reporting-only.
- [ ] Add only thin backend/CLI wiring and any strictly required classic hooks.

## Stage 2: Tests And Technical Smoke

- [ ] Test active axes, raw no-reference objectives, required Success/PPA
      invariants, and unknown-type failure.
- [ ] Test front ordering, crowding truncation, stable ties, population cap, and
      distinct `C-F` parents.
- [ ] Test that changing scalar score alone cannot change Pareto selection.
- [ ] Test classic seeded behavior after any hook extraction.
- [ ] Test backend/CLI dispatch and reject incompatible QD state.
- [ ] Test post-hoc front reproduction from full generation logs.
- [ ] Test valid-PPA, functional-any-pass, and reference-beating coverage as
      separate metrics; same input roots must reproduce identically.
- [ ] Test the operator contract: no single-thought, `M-T`, or `C-D` path.
- [ ] Run focused pytest, ruff, pyright, and ty checks.
- [ ] Run a seed-42 two-problem bounded vLLM smoke after a 128k preflight.
- [ ] Package the smoke as technical evidence only.
- [ ] Run the pre-seed-1001 read-only code and direction audit.

## Stage 3: Full RTLLM

- [ ] Run, validate, package, and hand off seed 1001 over all 50 RTLLM tasks.
- [ ] Apply the locked 46-task seed-1001 stop rule mechanically.
- [ ] Run seed 1002 only if seed 1001 passes.
- [ ] Package two-seed statistics and apply the promotion gate mechanically.
- [ ] Run seeds 1003-1005 only if the two-seed gate passes.
- [ ] Package five-seed paired cluster statistics, per-seed/LOSO sensitivity,
      per-problem maps, budgets, yields, and delivered fronts.
- [ ] Apply the five-seed full-RTLLM promotion gate without HV-AUC rescue.

## Stage 4: Held-Out Evidence

- [ ] Confirm the fresh 20-task holdout is absent from every prior run and
      method-development surface.
- [ ] Run fresh matched classic and Pareto seeds 1001-1005 only after promotion.
- [ ] Validate every run and resolve infrastructure failures without changing
      the method.
- [ ] Run canonical `reference_ppa` statistics and revision-3 robustness tables.
- [ ] Apply `REF_WIN`/`REF_PARITY`, valid-PPA, and functional-any-pass rules
      mechanically.
- [ ] Run equivalence and synthesis-determinism checks for showcased candidates.

## Stage 5: Closure

- [ ] Record one final class: primary positive, supporting result, or negative.
- [ ] State claim limits, scalar-score residual use, and synthesis-proxy limits.
- [ ] Update goal README/history, root README, findings dashboard, and nearest
      journal navigation/history docs.
- [ ] Preserve configs, hashes, commands, reports, raw-root map, and handoff.
- [ ] Run full pytest and final ruff, pyright, ty, and `git diff --check`.
- [ ] Inspect every goal commit for atomicity, message format, and one sign-off.
- [ ] Run the final adversarial prompt and resolve every FAIL finding.
- [ ] Record PASS in `pareto_revolution_validation_subagent_validation_report.md`.

## Completion Gate

- [ ] The plan's correct positive/supporting/negative path is complete.
- [ ] No unregistered variant, metric substitution, cherry-picking, or held-out
      tuning entered the decision.
- [ ] No required run or report process remains live.
- [ ] The final evidence is reproducible from recorded commits, commands,
      manifests, comparator roots, and hashes.

## Separate Future Goal

- [ ] After this candidate closes, decide whether to scaffold reference-seeded
      Pareto optimization. Do not begin it inside this goal.
