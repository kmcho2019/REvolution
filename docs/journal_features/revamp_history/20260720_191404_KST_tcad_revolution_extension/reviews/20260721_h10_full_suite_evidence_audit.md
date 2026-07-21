# H10 Full-Suite Evidence Audit

- Date: 2026-07-21
- Mode: independent read-only raw-evidence audit
- Session: `019f8611-a882-7d80-8b6f-95b799313360`
- Verdict: `PASS_FOR_H10_SUITE_EVIDENCE`

## Integrity Checks

- Rehashed all 96,651 seal entries: 24,190, 24,114, 24,402, and 23,945
  files across the four arms. No covered file had a post-seal modification.
- Reproduced the four arm-manifest SHA-256 values:
  `0dd50d9e96ed027ae336ebaa4f38d7bae14a848e10f4674341331794aa016377`,
  `c9570a91cc9f0c6bf3a702b282623e2d30e075a667397c7f786a5f359c94c22e`,
  `d29ae9768eedf2b05fb11e822def5190254abf1006a36ce1296fa1cecf026b90`,
  and
  `0826b4e34c509e8d0bec57b169b6f462a468fe18ba420189d6257bcebc309b04`.
- Verified the exact empty failure registry, accounting hashes, and strict
  ledger admission/capture order.
- Verified all 200 complete problem-arm units and 2,400 candidates per arm.
  No unit was missing, excluded, or rerun.
- Reproduced seed, mode, source config, normalized config, save-root, candidate,
  operator, and generation-local PPA joins.

## Mechanism Checks

All 4,800 treatment activation records validate. Exactly 2,744 failed
candidates received the canonical prefix, and all 1,571 failed-parent prompt
uses reproduce from source feedback and lineage. Classic contains neither H10
telemetry nor the prefix.

## Recomputed Evidence

- Repair-breadth mean delta: 0; W/L/T 7/7/86.
- Seed 1001 breadth: 16 to 15; deletion minimum -2.
- Seed 1002 breadth: 14 to 15; deletion minimum 0.
- Final-HV delta: -0.017568569535370747.
- HV-AUC delta: -0.008203193879029829.
- Final-HV ratio: 0.8875213701846218.
- Coverage tied exactly at 33/32 valid-PPA46, 38/37 RTL-functionality46,
  and 42/41 RTL-functionality50 for seeds 1001/1002 in both arms.
- Independently accumulated HV differed from the report only by floating-point
  roundoff below `4e-18`.

The audit found 27 classic method failures and 65 eligible paired PPA units,
matching the canonical report. Breadth, catastrophic-HV-ratio, final-HV, and
HV-AUC gates fail. Integrity, coverage, resource, mechanism, and process gates
pass.

## Reproducibility Check

A separate local replay regenerated all seven report files from the frozen
manifest. `diff -qr` was empty, and every SHA-256 matched the canonical package,
including summary JSON
`12bcc4fd7b4f8bd38528d84ace7e60bc5211e745389b8d34ccb82be2ec6ae340`.
Focused engine, reporter, and admission validation passed 97 tests.

## Disposition

There is no evidence-integrity blocker. The residual uncertainty is statistical
and belongs to the two-seed development role. Under the frozen gates, H10 is
`RETIRED`; confirmation and positive journal claims are forbidden.
