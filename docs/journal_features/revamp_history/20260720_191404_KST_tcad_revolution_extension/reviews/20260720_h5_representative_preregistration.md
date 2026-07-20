# H5 Representative Preregistration Review

- Date: 2026-07-20
- Reviewer: independent read-only explorer
- Review session: `019f80f8-7782-7d43-b545-2ba2d0ec8cb8`
- Final verdict: `PASS`

## Initial Findings

The first review returned `FAIL` and prohibited launch because the draft used a
generic paired-statistics report that omitted HV-AUC and the H5 repair endpoint,
did not guarantee all 16 frozen units or zero-PPA HV/HV-AUC rows, did not check
token and synthesis ceilings, and supplied no reproducible prompt-hash recipe.

The first closure review accepted those four corrections but found that missing
normalized-PPA values used the minimum score across both arms. That violated
the frozen `minimum_locked_classic_score` policy and kept the verdict `FAIL`.

## Accepted Corrections

- Added one isolated H5 probe report that joins every frozen problem, seed, and
  arm; reports final HV, HV-AUC, the fixed-denominator repair endpoint,
  functionality, valid PPA, yield, and normalized PPA; and emits clustered
  paired statistics without a representative performance gate.
- Zero-PPA completed units receive zero final HV and HV-AUC. Missing arm units
  fail the exact 16-unit and 32-arm technical contract instead of disappearing.
- Candidate, LLM-call, token, and synthesis ceilings assert per problem/arm.
- Added a directly checkable 28-file prompt checksum manifest whose SHA-256 is
  the frozen prompt hash.
- Derive normalized-PPA missing-treatment penalties only from classic scores.
  The regression test uses a lower treatment score and verifies the locked
  classic floor through the expected `-0.075` mean delta.

## Validation

```text
uv run pytest -q \
  tests/scripts/test_report_failed_parent_repair_probe.py \
  tests/scripts/test_report_failed_parent_repair.py \
  tests/scripts/test_report_hv_auc.py \
  tests/scripts/test_report_ppa_distribution.py \
  tests/scripts/test_report_pareto_analysis.py \
  tests/scripts/test_report_journal_statistics.py
```

Result before the final floor regression: 17 passed. The final probe-specific
rerun passed 2 tests. Ruff, Pyright, and `ty` pass for the new report and test.
All 28 prompt files pass `sha256sum -c`.

## Closure

`PASS`. No blocker remains. The frozen representative commands may be committed
and launched; representative metrics remain diagnostic and non-gating.
