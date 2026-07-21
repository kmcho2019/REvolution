# H10 Discovery Budget Worksheet

Status: `FROZEN`. The machine worksheet and program-manifest v6 preregistration
passed independent review at `2026-07-21T11:16:00Z`. Program-manifest v7 now
binds the audited H10 runtime without changing any arm or gate. No arm may
launch until the runtime is bound by a tracked implementation manifest and
explicitly admitted.

- Candidate ID: `H10`
- Wave: `wave2`
- Candidate proposal commit:
  `fec538bba98f10aee00ce3f88a15033fa6f75a17`
- Program manifest path: `../../shared/program_manifest_v7.yaml`
- Program manifest SHA-256:
  `316bab8cb0f404a9bff6ad839522df3137f78e2321b220cd17fddd90c066a662`
- Historical exact-card manifest: `../../shared/program_manifest_v6.yaml`,
  SHA-256
  `e54c59823640604f8669ca2fae2b7ced8d9dc5c3d76a310cd964c4948e7c06d6`
- Program start UTC: `2026-07-20T14:21:33+00:00`
- Program deadline UTC: `2026-08-10T14:21:33+00:00`
- Worksheet draft UTC: `2026-07-21T07:58:54+00:00`
- Candidate freeze UTC: `2026-07-21T11:16:00Z`
- Machine worksheet path: `candidate_budget.yaml`
- Machine worksheet SHA-256:
  `d7bd17b10e21a2acd970d43feb75603d83b57530efd27fcf38aa2323663a7378`
- Smoke/full config SHA-256:
  `20c8b3daf931b0b322568af61c9fa8a4ff85ab5da5fdcf56568cc8471702d490`,
  `3a4ec607702bac8dbf53eedadfb637d2d5e952c12680834f113865de6576582a`
- Smoke/full report-manifest SHA-256:
  `4b3b027ae0f0806d8f08f997d700acac12fa5dfd90cc6c2896318aedf7e8be2e`,
  `048e2e2cfd491d032fc88dffbffdb3cc7a75838df25082895fe5386e5a0b6aeb`
- Reference-PPA manifest SHA-256:
  `bd883853c6f2cb3adf6bf6a000cd2af3c2011bf2cc59f740b36d20c308ca95ed`
- Program-ledger path: `../../shared/wave2_resource_ledger.jsonl`
- Initial program-ledger SHA-256:
  `8aaf7d6eff5e00167b4a07522e674a8c3817062b48edc946aea375dffba26690`
- Reviewer: `../../reviews/20260721_h10_exact_card_internal_review.md`
- Runtime reviewer: `../../reviews/20260721_h10_implementation_review.md`

## Frozen Arm Caps

Every value is copied from `../../shared/wave2_budget_reference.yaml`. The
separate representative screen and every revision or rerun are omitted with
literal zero spend.

| Arm | Kind | Problems | Seed | Candidates | Calls | Tokens | Synthesis | Wall s | Basis |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Smoke classic | FROZEN_CAP | 3 | 42 | 48 | 300 | 265,153 | 35 | 161 | Pair-equal H5 reference envelope |
| Smoke treatment | FROZEN_CAP | 3 | 42 | 48 | 300 | 265,153 | 35 | 161 | Pair-equal H5 reference envelope |
| Representative classic | OMITTED | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Wave-2 ladder omits it |
| Representative treatment | OMITTED | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Wave-2 ladder omits it |
| Full seed 1001 classic | FROZEN_CAP | 50 | 1001 | 2,400 | 5,000 | 16,291,915 | 1,407 | 5,125 | Pair-equal H5 reference envelope |
| Full seed 1001 treatment | FROZEN_CAP | 50 | 1001 | 2,400 | 5,000 | 16,291,915 | 1,407 | 5,125 | Pair-equal H5 reference envelope |
| Full seed 1002 classic | FROZEN_CAP | 50 | 1002 | 2,400 | 5,000 | 16,146,270 | 1,415 | 4,985 | Pair-equal H5 reference envelope |
| Full seed 1002 treatment | FROZEN_CAP | 50 | 1002 | 2,400 | 5,000 | 16,146,270 | 1,415 | 4,985 | Pair-equal H5 reference envelope |
| Revisions or reruns | OMITTED | 0 | 0 | 0 | 0 | 0 | 0 | 0 | None admitted |
| Total | |  |  | 9,696 | 20,600 | 65,406,676 | 5,714 | 20,542 | Exact six-arm sum |

## Enforcement

| Resource | Enforcement before or during each arm |
| --- | --- |
| Candidates | Exact population and generation count in the command and reporter |
| Calls | `--max_llm_calls_per_problem` multiplied by the frozen problem count |
| Tokens | Pair-equal admission envelope and sealed post-arm stop gate |
| Synthesis | Pair-equal admission envelope and sealed post-arm stop gate |
| Wall time | Command timeout with the frozen arm cap |

Every admission names `implementation_manifest.yaml`; the ledger records its
resolved path and SHA-256 and rejects mutation before a later event. Post-arm
accounting names H10, the machine worksheet hash, the exact pending arm,
capture time, and the hashed `arm_evidence_manifest.sha256` inside that arm's
canonical raw root. That manifest covers the exact arm tree and binds the
scheduler telemetry used for wall time. Candidate count must equal the arm cap.
Counts are nonnegative integers; wall seconds use an exact decimal string.

- Admission tool path: `../../../../../../scripts/tcad_candidate_admission.py`
- Admission tool SHA-256:
  `d80abec47748bc309c552e1b1f9c74391b4888ee4646e98cbbe97b14af5df40a`
- Admission test path:
  `../../../../../../tests/scripts/test_tcad_candidate_admission.py`
- Admission test SHA-256:
  `a32cde5812907f2cd524c5c76560815691208660199dcbc7bb8dbd247fe249bc`
- Concurrent token/synthesis hard-cap support: `UNAVAILABLE`

## Ceiling Check

The empty Wave-2 ledger makes the candidate, wave, and post-H5 program
projections equal to the six-arm H10 total.

| Resource | H10 total | Candidate ceiling | Wave-2 ceiling | Program remainder | Pass |
| --- | ---: | ---: | ---: | ---: | --- |
| Candidates | 9,696 | 10,512 | 32,000 | 93,768 | Yes |
| LLM calls | 20,600 | 21,000 | 64,000 | 187,534 | Yes |
| LLM tokens | 65,406,676 | 66,000,000 | 200,000,000 | 580,710,448 | Yes |
| Synthesis evaluations | 5,714 | 6,000 | 18,000 | 53,944 | Yes |
| Endpoint-arm hours | 5.706111111 | 6.0 | 18.0 | 53.76803 | Yes |
| Elapsed program days | 21-day fixed window | 21 | n/a | 21 | Pending launch-time clock |

The machine worksheet loads successfully through `_load_worksheet`, and
`admission_status` returns `PASS` for `smoke_classic` against the empty ledger
at the draft time. This is a preregistration check, not an admission event.

## Admission Formula

Before arm `k`, the program ledger evaluates every resource independently:

```text
candidate_projection_r(k) = H10 actuals + H10 unlaunched caps
wave_projection_r(k)      = all Wave-2 actuals + H10 unlaunched caps
program_projection_r(k)   = all Wave-2 actuals + H10 unlaunched caps
```

Counts use integers and wall time uses exact decimal seconds. Launch only when
all three projections pass and the process clock plus every remaining
sequential wall cap is no later than the fixed deadline. The worksheet never
changes when actuals become available.

## Assertions

- [x] Every classic and treatment arm appears exactly once.
- [x] Arm IDs, order, pairs, and roles match the frozen six-arm ladder.
- [x] Every pair has identical candidate, call, token, synthesis, and wall caps.
- [x] Candidate and call bounds are structural; wall caps name timeouts.
- [x] Token and synthesis caps are prospective post-arm stop gates.
- [x] Candidate, wave, and program ceilings pass without rounding.
- [x] Omitted stages contain literal zero in every numeric field.
- [x] The candidate proposal predates treatment implementation and evidence.
- [x] The machine worksheet passes the admission parser.
- [x] Admission binds one implementation-manifest identity to every arm event.
- [x] Arm accounting binds an exact raw-tree hash manifest, not a mutable
      scheduler path alone.
- [x] An independent reviewer reproduced every total and hash.
- [x] The reporter contract and distinguishing gate tests pass review.
- [x] The candidate froze `READY`, then reached `IMPLEMENTED`, before any
      admission event.

Decision: budget `PASS`; runtime `PASS_FOR_RTLLM_IMPLEMENTATION`. This is not an
admission or result verdict.
