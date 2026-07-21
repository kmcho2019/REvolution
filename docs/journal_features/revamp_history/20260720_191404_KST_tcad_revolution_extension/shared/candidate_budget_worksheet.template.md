# Candidate Discovery Budget Worksheet

Status: `DRAFT`. Freeze once before candidate treatment evidence and never edit
the frozen copy. Record later admissions and actuals in the single append-only
Wave-2 program ledger.

- Candidate ID: `REQUIRED`
- Wave: `REQUIRED`
- Candidate commit: `REQUIRED`
- Program manifest SHA-256: `REQUIRED`
- Program start UTC: `2026-07-20T14:21:33+00:00`
- Program deadline UTC: `2026-08-10T14:21:33+00:00`
- Candidate freeze UTC: `REQUIRED`
- Machine worksheet path: `REQUIRED`
- Machine worksheet SHA-256: `REQUIRED`
- Program-ledger path: `shared/wave2_resource_ledger.jsonl`
- Initial program-ledger SHA-256: `REQUIRED`
- Reviewer: `REQUIRED`

## Frozen Arm Caps

Count every mandatory classic and treatment arm. `FROZEN_CAP` is an immutable
prospective maximum. `ACTUAL_REFERENCE` may justify a cap but does not itself
bound a new arm. An omitted stage has kind `OMITTED` and literal zero in every
numeric field.

| Arm | Kind | Problems | Seed | Candidates | Calls | Tokens | Synthesis | Wall s | Basis |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Smoke classic | FROZEN_CAP | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED |
| Smoke treatment | FROZEN_CAP | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED |
| Representative classic | OMITTED | 0 | 0 | 0 | 0 | 0 | 0 | 0 | OMITTED |
| Representative treatment | OMITTED | 0 | 0 | 0 | 0 | 0 | 0 | 0 | OMITTED |
| Full seed 1001 classic | FROZEN_CAP | REQUIRED | 1001 | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED |
| Full seed 1001 treatment | FROZEN_CAP | REQUIRED | 1001 | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED |
| Full seed 1002 classic | FROZEN_CAP | REQUIRED | 1002 | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED |
| Full seed 1002 treatment | FROZEN_CAP | REQUIRED | 1002 | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED |
| Revisions or reruns | OMITTED | 0 | 0 | 0 | 0 | 0 | 0 | 0 | NONE |
| Total | | | | REQUIRED | REQUIRED | REQUIRED | REQUIRED | REQUIRED | Exact sum |

## Enforcement

| Resource | Enforcement before or during each arm |
| --- | --- |
| Candidates | Exact population and generation count in the command and reporter |
| Calls | `--max_llm_calls_per_problem` multiplied by the frozen problem count |
| Tokens | Pair-equal admission envelope and sealed post-arm stop gate |
| Synthesis | Pair-equal admission envelope and sealed post-arm stop gate |
| Wall time | Command timeout with the frozen arm cap |

Post-arm accounting names the candidate, worksheet SHA-256, exact pending arm,
capture time, and a hashed raw-evidence artifact. Candidate count must equal the
arm cap. Count resources are nonnegative integers; authoritative wall seconds
are an exact decimal string and are never rounded in cumulative accounting.

- Admission tool path: `REQUIRED`
- Admission tool SHA-256: `REQUIRED`
- Admission test path: `REQUIRED`
- Admission test SHA-256: `REQUIRED`
- Concurrent token/synthesis hard-cap support: `UNAVAILABLE`

## Ceiling Check

| Resource | Candidate total | Frozen candidate ceiling | Wave-2 ceiling | Wave-2 program remainder | Pass |
| --- | ---: | ---: | ---: | ---: | --- |
| Candidates | REQUIRED | 10,512 | 32,000 | 93,768 | REQUIRED |
| LLM calls | REQUIRED | 21,000 | 64,000 | 187,534 | REQUIRED |
| LLM tokens | REQUIRED | 66,000,000 | 200,000,000 | 580,710,448 | REQUIRED |
| Synthesis evaluations | REQUIRED | 6,000 | 18,000 | 53,944 | REQUIRED |
| Endpoint-arm hours | REQUIRED | 6.0 | 18.0 | 53.76803 | REQUIRED |
| Elapsed program days | REQUIRED | 21 | n/a | 21 | REQUIRED |

## Admission Formula

Before arm `k`, the program ledger computes each resource independently:

```text
candidate_projection_r(k) = current-candidate actuals
                          + current-candidate unlaunched caps
wave_projection_r(k)      = all Wave-2 actuals + current unlaunched caps
program_projection_r(k)   = all Wave-2 actuals + current unlaunched caps
```

Count terms are integers and wall time uses exact decimal seconds. Launch only
when all three projections are no greater than their frozen thresholds. The
program threshold is the original program ceiling minus H5's audited Wave-1
spend. Projected completion also requires process-clock UTC plus all remaining
sequential wall caps to be no later than the fixed deadline. The worksheet
never changes when actuals become available.

## Assertions

- [ ] Every classic and treatment arm is included exactly once.
- [ ] Arm IDs, order, pairs, and roles match the frozen six-arm Wave-2 ladder.
- [ ] Every ledger event binds this candidate ID and machine worksheet SHA-256.
- [ ] Admission holds the program-ledger lock across validation and append; a
      concurrent process cannot admit another active candidate.
- [ ] Every accounting artifact binds the pending arm and a verified evidence
      path/SHA-256; neither artifact can be replayed across arms.
- [ ] Every accounting artifact records `completed` or `timed_out`; timeout
      spend is charged and retires the candidate.
- [ ] Candidate counts use fixed evaluated outputs, not successful outputs.
- [ ] Each classic/treatment pair has identical candidate, call, token,
      synthesis, and wall caps.
- [ ] Calls, tokens, synthesis attempts, and wall time use raw telemetry.
- [ ] The shared ledger charges every prior Wave-2 candidate's completed or
      stopped spend; every current unlaunched arm retains its frozen cap.
- [ ] Every candidate, wave, and program ceiling passes without rounding.
- [ ] Omitted stages contain literal zero in every numeric field.
- [ ] Candidate and call bounds are structural; wall caps name a command
      timeout; token and synthesis are labeled post-arm stop gates.
- [ ] Resource checks use no treatment performance outcome.
- [ ] The launch operator sees only `PASS` or `STOP`; exact resource totals stay
      sealed until the candidate decision.
- [ ] Missing or malformed accounting leaves the admitted arm pending; no zero
      actual is manufactured and no later arm can launch before reconstruction.
- [ ] The 21-day elapsed-program ceiling passes.
- [ ] An independent reviewer reproduced every total before live spend.

Decision: `PASS | FAIL`. A candidate with `FAIL` does not launch.
