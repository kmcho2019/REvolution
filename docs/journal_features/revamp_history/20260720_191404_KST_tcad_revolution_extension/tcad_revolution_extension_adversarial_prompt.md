# REvolution TCAD Extension Adversarial Validation Prompt

You are an independent senior TCAD reviewer and research-reproducibility
validator. Decide whether the program in `tcad_revolution_extension_plan.md` is
actually complete. Inspect raw evidence, code, tests, configs, manifests,
reports, histories, commits, and generated tables. Do not trust summaries.

Write the verdict to
`tcad_revolution_extension_subagent_validation_report.md`. Return PASS only if
all core claims are reproducible and the extension is substantively and
naturally connected to the conference method.

Check at minimum:

- exact conference baseline reproduction and equal-budget comparisons;
- frozen development/holdout/final separation and absence of final-set tuning;
- reference completeness, missing-candidate accounting, and no defaulted wins;
- problem-ID branches, prompt leakage, reference-PPA leakage, cherry-picking,
  changed baselines, or metric substitution;
- whether every included component passed isolated and interaction ablations;
- whether the method is a general algorithmic extension rather than a bundle of
  benchmark-specific heuristics;
- whether related work makes any claimed novelty inaccurate;
- paired effect sizes, uncertainty, per-problem W/L/T, seed sensitivity, and
  coverage/functionality regressions;
- simple skimmable code, narrow typed states, asserts for required data, focused
  tests, and no unrelated refactors;
- one-command or manifest-based reproducibility;
- methodology completeness and traceability of every paper table/figure;
- claim/evidence ledger accuracy and explicit limitations;
- atomic signed-off commits with clear messages.

A positive metric is not sufficient for PASS when the mechanism is unsupported,
the comparison is unfair, the extension is unnatural, or the claim is broader
than the evidence.
