# Baseline Contract External Review

Date: 2026-07-20. Reviewer: Claude Code, read-only methodology role.

## Attempts

1. A broad repository-and-artifact audit was stopped after 11 minutes 55
   seconds with no output. It supplied no review evidence.
2. A narrower artifact audit reached its explicit 600-second limit with no
   output. It supplied no review evidence.
3. A four-document Sonnet medium-effort review completed in read-only plan mode.
   It reviewed `baseline_contract.md`, `shared/program_manifest.yaml`,
   `shared/holdout_eligibility_audit.md`, and `program_claims_contract.md`.

## Initial Verdict

`FAIL`

### Required Findings

- `BLOCKING`: the accepted claims contract's broad "other PPA metric floor"
  conflicted with the baseline rule that raw lower-is-better area, power, and
  period are never imputed. The reviewer required the accepted contract to
  scope the floor to a higher-is-better normalized PPA score.
- `MAJOR`: "genuinely disjoint holdout" overstated a local, known benchmark.
  The reviewer required the calibrated term `repository-evidence-disjoint` and
  an explicit statement that CVDP is not a secret or cross-suite-independent
  benchmark.

### Precision Findings

- State that representative tasks are ranked by descending final-HV sample
  standard deviation.
- State explicitly that the 92-unit catastrophic stop applies to two-seed
  development only, not outcome-based truncation of confirmation.
- Ordering of the same eight representative tasks differed cosmetically between
  prose and YAML; no correction was required.

## Disposition

All required and precision findings were accepted in claims-contract revision
2, the baseline contract, and the program manifest. The changes strengthen
missing-data and holdout claims without changing any performance threshold.
A focused closure review is required before these contracts become frozen.

## Closure Review

The same read-only role verified that the normalized-score floor is scoped
correctly, raw PPA is not imputed, holdout wording is calibrated, representative
ranking is explicitly descending, and confirmation has no outcome-based early
stop. It found no new material contradiction and confirmed that no performance
gate was weakened.

`VERDICT: PASS`
