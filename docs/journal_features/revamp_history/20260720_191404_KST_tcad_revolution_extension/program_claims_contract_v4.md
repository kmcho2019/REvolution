# TCAD Extension Claims Contract

Status: `ACCEPTED`, revision 4, 2026-07-21. Revision 4 applies prospectively to
Wave 2. It preserves revision 3's candidate outcomes, statistical rules,
numeric margins, and resource thresholds while making the executable
resource semantics and per-seed coverage translation explicit. Revision 3
remains frozen in `program_claims_contract.md` for Wave 1 and H5.

This contract supersedes the direction-selection and candidate-gating portions
of `docs/journal_features/journal_narrative.md` for Wave 2. Prior empirical
findings and accepted measurement disclosures remain authoritative unless a
later versioned contract explicitly replaces them.

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
work removes the claimed delta, the allowed revisions do not resolve the
failure, or an outcome-blind resource or process gate fails. Preserve the
negative evidence.

### BLOCKED

Use `BLOCKED` only for a named external infrastructure failure that prevents a
valid scientific decision. When a required classic rerun does not fit a frozen
worksheet, resumption requires an outcome-blind, versioned worksheet revision
that names the failure and is independently reviewed before any output is read.

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
  candidate evaluations, synthesis eligibility, evaluator policy, and
  pair-equal resource envelopes. Actual calls, tokens, synthesis starts,
  runtime, and failures are outcomes and are reported.
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

## Wave 2 Resource Compliance

The numeric candidate, wave, and program thresholds in `baseline_contract.md`
and `shared/program_manifest_v5.yaml` remain unchanged. For Wave 2 they are strict
evidence-eligibility thresholds; this section supersedes only their earlier
hard-dispatch interpretation.

Candidate evaluations and LLM calls are enforced structurally by frozen command
configuration, and wall time by a frozen command timeout. Authoritative token
and synthesis-start totals are evaluated at sequential arm boundaries because
the frozen concurrent runner has no arm-wide dispatch counter. A single arm may
therefore exceed its envelope, and in the worst case a numeric threshold, before
the post-arm gate observes it. Timeout expiry is a wall-envelope violation.

Before every arm, admission requires, independently for each resource:

```text
candidate actuals + current unlaunched caps <= candidate threshold
all Wave-2 actuals + current unlaunched caps <= wave threshold
all Wave-2 actuals + current unlaunched caps <= post-H5 program remainder
```

Projected completion must also fit the 21-day program deadline. After every
arm, authoritative actual totals are recorded before any later arm is admitted.
An arm exceeding its envelope, or causing a candidate, wave, or program
threshold to be exceeded, is a resource-compliance failure.

One append-only Wave-2 program ledger accumulates completed and stopped spend
across candidates. Admission holds one exclusive ledger lock across validation
and append, so concurrent launch commands cannot admit overlapping candidates.
Every event is bound to its candidate ID, worksheet SHA-256,
and exact arm; every accounting artifact is bound to a hashed raw-evidence
artifact, records `completed` or `timed_out`, and cannot be replayed. A timeout
retires the candidate even when the numeric totals fit. Candidate count must
equal the arm budget. Accounting and raw-evidence hashes are unique across
recorded arms.
Count resources are nonnegative integers and wall time is an exact decimal.
Missing, malformed, or unauthenticated accounting never creates a zero-spend
event: the executing arm remains pending and every later admission is forbidden
until authoritative totals are reconstructed and charged.

A resource-compliance failure:

- retires the candidate independently of every performance outcome;
- forbids every later arm for that candidate;
- charges all actual spend to the wave and program ledgers;
- forbids a later candidate whose complete frozen ladder no longer fits;
- cannot be rerun, waived, offset by another arm, or used as positive evidence.

Only the currently executing arm can create an overrun. This is an acknowledged
execution risk, not an increase in any numeric eligibility threshold. Matched
classic and treatment arms use identical frozen candidate, call, token,
synthesis, and wall envelopes. The launch operator receives only `PASS` or
`STOP`; exact token and synthesis totals stay sealed until the terminal
candidate decision. The bit is a disclosed minimal outcome leak and may not
inform candidate selection within the same wave.

Admission time comes from the process UTC clock and is recorded in the ledger;
no launch command can supply or reset it. The fixed program remainder subtracts
H5's audited Wave-1 spend from the original program ceiling before Wave 2.

The Wave-2 ladder is the three-design technical smoke plus the two-seed
full-suite development pair. The representative stage, mandatory in Wave 1, is
omitted prospectively in Wave 2. Its frozen definition remains available for
historical comparison, it carries no candidate gate, and no evidence is
relabeled.

Coverage noninferiority is evaluated independently per seed and per declared
surface. Deficits are never netted across seeds, surfaces, or against gains.
This restates and does not alter revision 3's margins. This revision applies
only to Wave 2 and does not alter H5 or any earlier decision.

The separate catastrophic coverage check also forbids netting. For each
declared surface it uses
`sum(max(0, classic_seed - treatment_seed))` over exactly seeds 1001 and 1002.
Every Wave-2 terminal reporter must import the shared gate implementation and
pass its frozen integration tests before launch.
