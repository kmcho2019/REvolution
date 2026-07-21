# H5 Implementation And Experiment History

Append candidate-specific state transitions, commands, raw roots, reports,
reruns, and decisions here. Program-level consequences also belong in the root
history.

## 2026-07-20: Code Gate

- Implemented one isolated `revolution_failed_parent_repair` mode at commit
  `59acb11def38d12466cca425c6828bba25f98dc8`.
- Preserved the frozen classic engine and default configuration hashes.
- Closed focused, broad, static, external code, internal code, and evidence
  readiness reviews before live evidence.
- Froze a shared smoke configuration and sequential three-problem execution
  commands. No H5 model-backed result had been inspected at this transition.
- Program manifest revision 4 SHA-256:
  `1ace858fdaf2bc3a9468526a48293d674afac7badaa726592d3a72a0b624be34`.
- Smoke config SHA-256:
  `20c8b3daf931b0b322568af61c9fa8a4ff85ab5da5fdcf56568cc8471702d490`.
- Smoke experiment manifest SHA-256:
  `b663c89673bd3b8a336d3ef36253a7774f11550bc9421a374994dc2446792fb9`.

## 2026-07-20: Technical Smoke

- Raw root:
  `exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/smoke_seed42`.
- Ran fresh classic and H5 arms sequentially after a passing vLLM preflight.
  Each arm completed the three frozen problems at seed 42 with 48 total
  candidates and 96 LLM calls.
- The strict mechanism report accepted both runtime configs, all 96 candidate
  records, lineage, stage states, exact budgets, operator sets, and treatment
  pool trajectories. A replay reproduced every report file byte-for-byte.
- Classic failed-parent allocation was M-E 1, M-F 1, M-I 2, M-R 2, and M-S 2.
  All nine H5 failed-parent requests used M-F. Success-side operators remained
  the classic set in both arms.
- Classic had 31 valid-PPA candidates and H5 had 30; every design had at least
  one. Direct failed-parent valid-PPA repairs were 1 and 4, respectively. The
  `+0.0625` normalized delta is smoke telemetry, not performance evidence.
- Classic used 232,161 tokens in 140.14 wall seconds; H5 used 241,048 tokens in
  145.54 wall seconds. Both stayed inside the frozen stage budget.
- Independent read-only audit session
  `019f80e8-a363-7af3-81bd-43094e71a965` returned `PASS` with no technical
  finding and declared the representative probe technically admissible.
- Candidate state: `SMOKE_VALIDATED`.

## 2026-07-20: Representative Probe Freeze

- Froze the eight classic-only-selected tasks, development seeds 1001 and 1002,
  population 8, five generations, and fresh matched controls before inspecting
  representative treatment evidence.
- Shared run config SHA-256:
  `b3c85757e2d18b3fa94d00f8decfd44c6468fdc0139a2bd93bced3b7c8997169`.
- Problem manifest SHA-256:
  `9ed95986946980858b1391ce6c8725ba002959c864fed6706a0f8714b31286e5`.
- Experiment manifest SHA-256:
  `0dcbc2f1012a06d5aac3f0ed64abbdfecc87ee902b174fcd096128af3fe0266f`.
- Canonical probe report SHA-256:
  `15d2c6698a781ab5aa8dca46adefbbcec1c25edb4ea83b202a803aa68a0e0689`.
- The independent preregistration review found and closed incomplete metric,
  unit-accounting, resource, prompt-hash, and classic-only floor issues. Final
  verdict: `PASS`.
- No representative H5 result existed when the commands and hashes froze.

## 2026-07-20: Representative Probe

- Completed fresh sequential classic and H5 arms for all eight frozen problems
  at seeds 1001 and 1002. Each arm has 384 candidates and no missing unit.
- Raw root:
  `exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/representative_probe`.
- H5-minus-classic deltas were repair rate `+0.0052083`, final HV
  `-0.0014420`, HV-AUC `+0.0076497`, valid-PPA sample yield `+0.0299479`, and
  best normalized PPA `-0.0115159`. Functionality and valid-PPA coverage were
  tied at `16/16`.
- Repair-rate direction was positive at both seeds; final-HV and HV-AUC seed
  directions were mixed. The stage is diagnostic and created no candidate
  classification.
- A reporting-only closure emitted per-seed, sensitivity, resource, and pool
  trajectory tables. It documented that the frozen
  `llm_calls_to_first_improvement` name lacked an estimand and excluded that
  non-gating metric rather than defining it after outcomes.
- Independent reporting audit session
  `019f8152-17e0-72c1-89a9-40eeb2a1868e` returned final `PASS`. No live run was
  repeated. Canonical derived package:
  `packages/two_seed/probe_reporting_closure_v3`.

## 2026-07-20: Full-Suite Probe Freeze

- Froze all 50 RTLLM run tasks and the locked 46 reference-complete PPA
  headline tasks, development seeds 1001 and 1002, population 8, five
  generations, fresh sequential controls, and exact missing-result penalties.
- Full run manifest SHA-256:
  `e46d54c07a7ef7f315f70872e8fab04ac49bc63ad5c0676f9aeecdea42bff578`.
- Shared config SHA-256:
  `3a4ec607702bac8dbf53eedadfb637d2d5e952c12680834f113865de6576582a`.
- Full-suite experiment manifest SHA-256:
  `10cdf1eedbb560c6b36b5b7197490d2fe7f0bd5f48510c2b330574f575e9da9e`.
- The stage can return only `VIABLE` or `RETIRED`. It cannot confer a paper
  claim or use representative outcomes to change a numeric gate.
- The first broad external review timed out without evidence. A focused
  600-second `claude -p` retry verified all pins and gates and returned `PASS`
  with no blocker.
- No full-suite arm had launched at freeze time.

## 2026-07-21: Full-Suite Execution

- Raw root:
  `exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/full_suite_probe`.
- Ran four fresh arms sequentially: classic then H5 at seed 1001, followed by
  classic then H5 at seed 1002. All 200 arm units completed, every arm emitted
  exactly 2,400 candidates, and no exclusion, missing unit, or rerun occurred.
- Calls were 4,800, 4,800, 4,801, and 4,800. Tokens were 14,679,912,
  14,810,831, 14,598,180, and 14,678,427. Maximum matched resource skew was
  0.027211.
- All 1,561 H5 failed-parent requests used M-F, classic used all five failed
  EoH operators, and both arms used the five classic success operators.
- Direct valid-PPA repairs were 36 to 41 at seed 1001 and 37 to 40 at seed
  1002. Final-HV deltas were +0.009943 and +0.003413; HV-AUC deltas were
  +0.007007 and +0.001989.
- Valid-PPA coverage changed 34/46 to 32/46 at seed 1001 and 32/46 to 33/46 at
  seed 1002. RTL functionality50 changed 43/50 to 42/50 and 41/50 to 41/50.
- The canonical reporter generated one two-seed package and returned `VIABLE`.
  No raw arm or report was rerun after this result.

## 2026-07-21: Post-Run Contract Audit And Decision

- Independent evidence audit found that the reporter's aggregate coverage gate
  conflicts with the accepted per-seed contract. The governing limit is one
  problem per seed; H5's two-problem valid-PPA deficit at seed 1001 fails it.
- A second scientific reviewer initially accepted the reporter label, then
  independently rechecked the contract hierarchy and corrected its verdict to
  `FAIL / RETIRED`. The later candidate manifest cannot supersede the accepted
  claims contract, baseline contract, or program manifest.
- The audit also recomputed cumulative discovery spend across smoke,
  representative, and full-suite arms: 11,232 candidates, 22,466 calls,
  69,289,552 tokens, 6,056 synthesis evaluations, and 6.231970 endpoint-arm
  hours. These exceed every frozen per-candidate ceiling. Matched full-suite
  arm fairness remains intact, but the bounded discovery process was violated.
- PPA uplift is not attributable to failed repair. `Prob036_edge_detect`
  contributes most pooled HV/HV-AUC uplift despite zero failed-parent requests
  in either arm. The repair gain is concentrated, primarily syntax-stage, and
  does not broaden repaired-unit coverage.
- Governing outcome: `RETIRED`. Preserve the generated `VIABLE` field as an
  auditable reporter defect; do not alter frozen contracts or regenerate the
  evidence package after observing results.
- No H5 revision, confirmation, holdout, combination, or integration arm is
  authorized. Wave 1 closes with diagnostic positive directions but no viable
  journal candidate.
