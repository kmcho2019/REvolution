# REvolution TCAD Extension Adversarial Validation Prompt

You are an independent senior TCAD reviewer and research-reproducibility
validator. Inspect the raw evidence, code, tests, configs, manifests, reports,
histories, commits, and generated tables for the program defined in
`tcad_revolution_extension_plan.md`. Do not trust implementer summaries.

Write the review to
`tcad_revolution_extension_subagent_validation_report.md` with two decisions:

1. process verdict: `PASS` or `FAIL`;
2. evidence outcome: `JOURNAL_READY`, `PORTFOLIO_READY`, or `PIVOT_REQUIRED`.

`PASS` means the reported outcome is honest and reproducible. It does not imply
that the program produced a journal-ready method.

## Audit The Research Logic

- Verify the conference-method audit against the paper and exact classic code.
- Check that every implemented candidate addresses a documented weakness.
- Challenge hardware/CAD rationale, mechanistic clarity, generality, and
  REvolution-specific novelty against current primary literature.
- Reject parameter scans, generic algorithm transplants, benchmark-specific
  rules, fallback ladders, and combinations of unsupported near-misses.
- Verify that candidate ranking preceded treatment results and was not rewritten
  to favor successful runs.
- Check that negative and mixed results constrain later hypotheses.

## Audit Experimental Validity

- Reproduce the classic baseline and verify its engine hash.
- Check equal model, operator substrate except an explicit operator treatment,
  candidate, LLM, token, synthesis, evaluator, and benchmark budgets.
- Verify baseline-only representative-set selection and frozen benchmark roles.
- Check development, confirmation, and holdout separation and no final-set tuning.
- Confirm reference completeness, missing-treatment penalties, exclusions, and
  failure reasons against raw artifacts.
- Recompute final HV, HV-AUC, functionality, valid-PPA, yield, paired deltas,
  W/L/T, uncertainty, seed sensitivity, and concentration of gains.
- Compare reporter gate logic line by line with the governing contract. Reject
  aggregate netting when a margin is frozen independently per seed.
- Check that small-set results were not used as paper evidence.
- Check that every terminal `VIABLE` result reached the frozen two-seed
  full-suite probe.
- Check that every claimed RTL artifact passes its stated functional or
  equivalence gate and that unchanged seeded designs are not optimization wins.
- Verify that modest gains are described modestly and that HV-AUC never rescues
  a final-HV loss for a primary PPA claim.

## Audit Mechanism And Code

- Inspect the complete treatment diff and prove classic code is byte-identical.
- Confirm one narrow typed mechanism, exhaustive state handling, and required
  data assertions.
- Reject defensive fallbacks, optional-state growth, backward-compatibility
  layers, problem branches, prompt leakage, and unrelated refactors.
- Verify focused tests, determinism, mechanism telemetry, and one end-to-end
  smoke before live spend.
- Review `ruff`, pytest, pyright, and `ty` evidence and distinguish existing debt.
- Confirm experimental code is removable without changing classic behavior.

## Audit Process And Documentation

- Check every candidate has one terminal decision and reproducible artifacts.
- Verify no candidate exceeded two mechanism-preserving revisions.
- Verify no more than three candidates per wave and one active candidate at a
  time.
- Verify no more than two waves and no more than two confirmation finalists.
- Verify confirmation seeds were preregistered and disjoint from development.
- Verify commits and timestamps show gates, margins, manifests, and statistical
  methods were frozen before treatment outputs were inspected.
- Verify the holdout eligibility audit predates treatment selection and supports
  the claimed lack of exposure.
- Reconcile per-candidate, per-wave, and program token, candidate, call,
  synthesis, endpoint-arm, and elapsed-time ceilings against actual spend.
  Count every mandatory matched classic and treatment arm at every stage.
- Inspect internal and external read-only review prompts, findings, and owner
  dispositions. Confirm external advice was verified rather than blindly used.
- Trace every claim through the claim ledger to raw evidence and report commands.
- Check the portfolio, negative map, conference-to-journal delta, limitations,
  and artifact index for completeness.
- Review commits for atomic scope, signed-off footers, and valid stored messages.

Return process `FAIL` when the outcome is overstated, evidence is missing,
classic fairness is broken, candidate discovery drifted into heuristic tuning,
or a required artifact cannot be reproduced. List concrete required fixes and
the exact evidence needed for re-review.
