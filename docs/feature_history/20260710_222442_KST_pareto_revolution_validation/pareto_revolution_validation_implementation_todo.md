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
- [x] Obtain user/advisor approval of the method contract, parent+survivor
      bundling, and quantitative gates before activating the goal.

## Stage 0: Freeze

- [x] Re-read the journal onboarding documents in required order.
- [x] Write the versioned method and claims addendum without changing accepted
      `journal_narrative.md` revision 3.
- [x] Run a read-only adversarial review of the addendum and resolve every FAIL.
- [x] Complete the zero-compute discarded-front audit or document unavailable
      historical state exactly.
- [x] Resolve the same-root S07/S32 classic coverage discrepancy with one
      canonical definition and regression test.
- [x] Prove the prior-run-disjoint VerilogEval holdout infeasible and narrow
      this campaign to RTLLM development evidence without relaxing exclusions.
- [x] Freeze the RTLLM surfaces, missing-reference circuit types, seeds, model,
      prompts, tools, and budgets in the V2 config.
- [x] Require fresh matched classic for gates; keep historical classic and V2
      roots descriptive because server-revision parity is unproven.
- [x] Freeze the one Pareto arm, commands, output roots, report commands, and
      stop/promotion rules before any evidence run.
- [x] Add rerun-ledger and restart-handoff locations.

## Stage 1: Implementation

- [x] Add one `revolution_pareto` discriminated search mode.
- [x] Keep Pareto-specific logic in `src/revolution/pareto_revolution/`.
- [x] Reuse existing PPA gain, active-axis, and rank/crowding primitives.
- [x] Implement successful-parent binary tournament by rank/crowding.
- [x] Implement successful-survivor NSGA-II environmental selection.
- [x] Keep Fail-pool, EoH operator, UCB, prompt, feedback, evaluator, and budget
      behavior unchanged.
- [x] Build the delivered global front post hoc; prove it is reporting-only.
- [x] Add only thin backend/CLI wiring; keep `algorithm.py` byte-identical.
- [x] Record copied-loop source ranges and prove only the two selection blocks
      differ before seed 1001.

## Stage 2: Tests And Technical Smoke

- [x] Test active axes, raw no-reference objectives, required Success/PPA
      invariants, and unknown-type failure.
- [x] Test front ordering, crowding truncation, stable ties, population cap, and
      distinct `C-F` parents.
- [x] Test that changing scalar score alone cannot change Pareto selection.
- [x] Test classic seeded behavior and the frozen `algorithm.py` hash.
- [x] Test backend/CLI dispatch and reject incompatible QD state.
- [x] Test post-hoc front reproduction from full generation logs.
- [x] Test valid-PPA, functional-any-pass, and reference-beating coverage as
      separate metrics; same input roots must reproduce identically.
- [x] Test the operator contract: no single-thought, `M-T`, or `C-D` path.
- [x] Run focused pytest, ruff, pyright, and ty checks.
- [x] Run a seed-42 three-problem `8 x 5` vLLM smoke after a 128k preflight.
- [x] Package the smoke as technical evidence only.
- [x] Run the pre-seed-1001 read-only code, direction, and smoke-package audit.

## Stage 3: Full RTLLM

- [ ] Run, validate, package, and hand off seed 1001 over all 50 RTLLM tasks.
- [ ] Apply the locked 46-task seed-1001 stop rule mechanically.
- [ ] Run seed 1002 only if seed 1001 passes.
- [ ] Package two-seed statistics and apply the promotion gate mechanically.
- [ ] Run seeds 1003-1005 only if the two-seed gate passes.
- [ ] Package five-seed paired cluster statistics, per-seed/LOSO sensitivity,
      per-problem maps, budgets, yields, and delivered fronts.
- [ ] Apply the five-seed full-RTLLM promotion gate without HV-AUC rescue.

## Stage 4: Closure

- [ ] Record one final class: positive development evidence, supporting result,
      or negative closure.
- [ ] State claim limits, scalar-score residual use, and synthesis-proxy limits.
- [ ] Update goal README/history, root README, findings dashboard, and nearest
      journal navigation/history docs.
- [ ] Preserve configs, hashes, commands, reports, raw-root map, and handoff.
- [ ] Run equivalence and synthesis-determinism checks for showcased candidates.
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
- [ ] Freeze a genuinely fresh benchmark before any paper-facing primary claim;
      all 156 current VerilogEval tasks have prior evaluated outcomes.
