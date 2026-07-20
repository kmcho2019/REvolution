# TCAD Extension Claims Contract

Status: `ACCEPTED`, revision 3, 2026-07-20. Revision 3 distinguishes
RTL-simulation functionality from verification-complete valid-PPA coverage
after pre-implementation review; it does not loosen a candidate gate. This
contract supersedes the
direction-selection and candidate-gating portions of
`docs/journal_features/journal_narrative.md`; prior empirical findings and the
accepted measurement disclosures remain authoritative unless a later versioned
contract explicitly replaces them.

## Purpose

This contract permits a persistent search for natural REvolution extensions
without forcing every useful idea to satisfy the same headline threshold. It
separates scientific viability from paper-ready evidence and prevents secondary
metrics from being elevated into unsupported primary claims.

## Program Outcomes

The completed program has exactly one outcome:

- `JOURNAL_READY`: at least one independently confirmed `PAPER_CANDIDATE`, a
  coherent conference-to-journal delta, and sufficient reliability,
  generalization, or evaluation evidence for the intended TCAD narrative.
- `PORTFOLIO_READY`: no complete journal method is confirmed, but the program
  produced an audited limitation map, reproducible candidate decisions, and one
  or more `VIABLE` directions suitable for advisor selection or future work.
- `PIVOT_REQUIRED`: no candidate remains credible after the allowed discovery
  waves, or current related work removes the intended novelty.

`PORTFOLIO_READY` and `PIVOT_REQUIRED` are honest goal completions, not journal
success claims.

## Candidate Outcomes

### PAPER_CANDIDATE

An algorithmic primary candidate requires:

- a natural, general, and literature-differentiated mechanism;
- final mean reference-complete HV above matched classic REvolution;
- no material regression in verification-complete valid-PPA or RTL-simulation
  functionality coverage;
- no material HV-AUC regression;
- paired per-problem evidence, uncertainty, W/L/T, and seed sensitivity;
- five matched, preregistered, development-disjoint seeds on the frozen
  confirmation suite;
- one frozen run on the repository-evidence-disjoint holdout defined by the
  eligibility audit; this is not a secret or cross-suite-independent benchmark;
- mechanism ablation, code audit, reproducibility evidence, and adversarial PASS.

The uplift may be modest. No fixed 3% or 5% gain is required unless justified by
the baseline MDE analysis. The confidence interval and allowed noninferiority
margin must be frozen before candidate outcomes are observed. HV-AUC cannot
rescue a final-HV loss for a primary PPA claim.

A supporting reliability or generalization candidate may be a
`PAPER_CANDIDATE` when it materially improves its preregistered primary metric,
preserves final HV within the frozen noninferiority margin, and is paired with a
separately confirmed algorithmic contribution.

### VIABLE

A candidate is `VIABLE` when:

- naturalness, novelty, code, functionality, and mechanism checks pass;
- a frozen two-seed full-suite probe shows a reproducible benefit on at least
  one preregistered metric;
- other primary surfaces remain inside the frozen practical-regression limits;
- evidence is too small, mixed, or role-specific for a headline claim.

Allowed wording must identify the exact benefit, tested scope, and unresolved
uncertainty. A `VIABLE` result may motivate a distinct follow-up, but does not
license integration by itself.

### RETIRED

Retire a candidate when its mechanism is unsupported, it fails a frozen
practical gate, it depends on heuristic or benchmark-specific behavior, related
work removes the claimed delta, or the allowed revisions do not resolve the
failure. Preserve the negative evidence.

### BLOCKED

Use `BLOCKED` only for a named external resource failure that prevents a valid
scientific decision. Record the evidence required to resume.

## Evidence Rules

- Candidate selection and benchmark filtering may use classic-only evidence,
  never treatment outcomes.
- Small sets may detect runtime or catastrophic failures; they do not license a
  paper claim.
- Missing treatment results where classic succeeds count as method failures.
- Every claimed RTL artifact must pass the stated functional gate. Unchanged
  seeded RTL does not count as an optimization success.
- Search uses no hidden tests, reference PPA, problem identifiers, or
  benchmark-specific prompt clauses.
- Equal-budget comparisons freeze model, prompt family, operator substrate,
  candidate evaluations, and synthesis evaluations. Calls, tokens, runtime, and
  failures are reported.
- Claims follow evidence role: development, confirmation, and holdout results
  are never relabeled after observation.

## Statistical Protocol

- The statistical unit is the problem-seed pair; problems are resampling
  clusters and all seed replicates for a sampled problem remain together.
- Gate-bearing intervals use the repository's existing seeded problem-cluster
  bootstrap with the replicate count and bootstrap seed frozen in the manifest.
- Primary statistics are penalized. A missing treatment unit where classic has
  evidence is a method failure: functionality, coverage, hypervolume, and
  HV-AUC receive zero. A higher-is-better normalized PPA score receives the
  minimum locked classic score. Raw lower-is-better area, power, and period are
  never imputed; report valid-pair complete-case summaries and missing counts as
  secondary evidence.
- A missing classic unit caused by infrastructure is rerun before gating. A
  genuine classic method failure is reported and excluded from paired PPA gates;
  the treatment-only success count is reported separately.
- W/L/T uses one frozen numerical tie tolerance derived from classic duplicate
  evaluations, never from treatment outcomes. Exact sign tests and effect sizes
  accompany W/L/T when the non-tied sample is sufficient.
- Confirmation uses five preregistered seeds that are disjoint from all
  representative and full-suite development seeds. Seed roles are frozen before
  Wave 1 candidate outcomes.
- Exact practical noninferiority margins, minimum effects, bootstrap settings,
  and tie tolerance are frozen from classic-only variance/MDE evidence in the
  accepted claims addendum and experiment manifests.
