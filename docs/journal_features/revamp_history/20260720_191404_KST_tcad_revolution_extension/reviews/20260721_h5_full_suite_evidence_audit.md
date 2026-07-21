# H5 Full-Suite Evidence Audit

- Date: 2026-07-21
- Mode: read-only independent subagent
- Session: `019f81e2-5676-7081-910f-5ed69b0af79f`
- Final verdict: `FAIL / RETIRED`

## Verified Evidence

- All 200 arm units completed with exactly 48 candidates per unit. No unit was
  missing, excluded, or rerun.
- Direct valid-PPA repairs changed 36 to 41 at seed 1001 and 37 to 40 at seed
  1002. The pooled repair-rate delta was +0.001667, 95% problem-cluster CI
  [-0.002292, +0.006250], W/L/T 14/12/74, sign-test p=0.8450.
- Final-HV46 delta was +0.006678, CI [-0.000627, +0.017287]. HV-AUC46 delta
  was +0.004498, CI [-0.002928, +0.016273]. Both seed directions were positive.
- All 1,561 H5 failed-parent requests used M-F. Classic used all five failed
  operators; both arms used the five classic success operators.
- Source, prompt, configuration, manifest, reporter, and excluded-unit hashes
  matched their frozen values. Within each seed, arm configurations differed
  only by search mode and save path.

## Blocking Coverage Finding

The accepted baseline contract permits valid-PPA and RTL-functionality
coverage to trail by at most one problem per seed. The program manifest encodes
this as `coverage_deficit_per_seed: 1`.

- Seed 1001 valid-PPA coverage: classic 34/46, H5 32/46, deficit 2.
- Seed 1002 valid-PPA coverage: classic 32/46, H5 33/46, gain 1.

The candidate reporter summed signed deficits before comparing the result with
an aggregate maximum of two. That incorrectly lets the seed-1002 gain cancel a
seed-1001 per-seed violation. The later experiment manifest is subordinate to
the accepted claims contract, baseline contract, and program manifest, so its
aggregate translation cannot loosen the governing rule.

## Blocking Resource Finding

Raw generation logs, per-problem summaries, and scheduler telemetry give:

| Stage | Candidates | Calls | Tokens | Synthesis | Endpoint-arm h |
| --- | ---: | ---: | ---: | ---: | ---: |
| Smoke, both arms | 96 | 192 | 473,209 | 61 | 0.079355 |
| Representative, both arms | 1,536 | 3,073 | 10,048,993 | 939 | 1.090425 |
| Full suite, both arms | 9,600 | 19,201 | 58,767,350 | 5,056 | 5.062190 |
| Cumulative | 11,232 | 22,466 | 69,289,552 | 6,056 | 6.231970 |
| Frozen ceiling | 10,512 | 21,000 | 66,000,000 | 6,000 | 6.000000 |

The ceiling counts the mandatory matched classic and treatment arms: the
contract defines arm cost, uses endpoint-arm hours, and states that the limit
covers smoke, representative, and full-suite discovery. Treatment-only
accounting has no contractual basis.

## Disposition

H5 fails a primary practical gate and exceeded its bounded discovery ceiling.
The generated `VIABLE` field is an auditable reporter defect, not the governing
decision. Record H5 as `RETIRED`, preserve the positive repair and PPA
directions as scoped diagnostics, and do not launch confirmation or holdout.
