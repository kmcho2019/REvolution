# H10 Runtime Implementation Review

Verdict: `PASS_FOR_RTLLM_IMPLEMENTATION`

Current disposition: runtime mechanism review remains valid, but its original
evidence-readiness conclusion was superseded before admission by
`20260721_h10_pre_admission_review.md`. Program-manifest v8 rebinding and
rereview are required.

- Scope: experimental engine, backend and CLI dispatch, telemetry, focused
  tests, reporter implementation binding, and program-manifest transition.
- Boundary: this verdict permits creation of the tracked implementation
  manifest. It is not admission, smoke, suite, confirmation, holdout, or
  performance approval.

## Reviewed Implementation

- `VerifiedStatusFeedbackEngine` subclasses the classic `EoHEngine`, calls the
  classic evaluator first, prepends one fixed status line to failures, and
  leaves successful feedback and critic artifacts unchanged.
- All six typed failures are handled explicitly. `new` asserts impossible and
  unknown states reach `assert_never`.
- The backend and CLI expose one fixed
  `revolution_verified_status_feedback` discriminant and reject changes to
  pools, EoH operators, successful-parent operators, UCB, generation mode,
  representation, repair, strict formatting, prompts, or evaluation mode.
- Activation and prompt-use telemetry bind original analysis, consumed
  feedback, untouched critic artifacts, and exact serialized failed-parent
  payloads.
- Classic `src/revolution/algorithm.py` remains SHA-256
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
  The default configuration remains SHA-256
  `cd44c8de823b9843339718cd8116d325f35a11188b38103553dcc2cbc8c0a34b`.

## Independent Audits

| Review | Initial finding | Final finding |
| --- | --- | --- |
| `019f8475-7d6d-7250-b261-5639544a6454` | No isolation, bloat, or focused-test blocker. | `PASS`; 93 focused tests passed. |
| `019f8475-de65-72a1-8a60-de9afb532415` | v6 could not bind changed backend bytes; dispatch tests were absent from the implementation file set; CVDP composition was unproved. | v7 and the file set close the RTLLM blockers; `PASS_FOR_RTLLM_IMPLEMENTATION`. |
| `019f8475-f707-7460-87c1-72b7134a06d6` | Reporter still required manifest v6; no implementation manifest existed; dispatch tests were absent; CVDP composition was unproved. | Version guard and file set are corrected; the absent implementation manifest is the next ordered gate; `PASS_FOR_RTLLM_IMPLEMENTATION`. |

Review feedback was checked against the source rather than accepted by
default. Program-manifest v7 supersedes v6 before evidence and binds the H10
engine, CLI, and backend bytes. Version 6 remains the immutable exact-card
preregistration record.

## Validation

- 161 combined runtime, backend, CLI, reporter, admission, and gate tests
  passed.
- The full repository passed with `MPLBACKEND=Agg`: 1,202 passed and 4 skipped
  in 317.02 seconds. An initial run reached 874 passed and 4 skipped before an
  existing report subprocess blocked on the workspace X11 socket; it was
  interrupted after 682.34 seconds and rerun headlessly rather than counted.
- Ruff, Pyright, `ty`, YAML loading, frozen hashes, and classic-byte checks
  passed on the reviewed surface.
- The new experimental engine passes explicit Ruff complexity checking.
- Explicit C901 diagnostics remain in shared dispatch code: pre-H10
  `run_backend.main` was complexity 26 and is now 28; backend `initialize` was
  11 and is now 14. Other reported shared-function debt predates H10. A broad
  dispatch refactor is outside this one-factor experiment and would enlarge
  its review surface.

Program-manifest v7 SHA-256:
`316bab8cb0f404a9bff6ad839522df3137f78e2321b220cd17fddd90c066a662`.

## Confirmation Blocker

The RTLLM implementation is valid. The proposed CVDP holdout composition is
not. `run_backend.py` creates `CVDPEvaluator` as `candidate_evaluator`, while
`RevolutionBackend` supplies `services.verilog_evaluator` to the H10 engine.
The candidate evaluator therefore does not implement the H10 engine's
functional-evaluation path.

No CVDP holdout or H10 confirmation campaign may launch until a prospective
composition and focused dispatch test pass independent review. This does not
block the preregistered RTLLM smoke or two-seed development suite. Without a
later correction, H10 can at most be classified `VIABLE`, never
`PAPER_CANDIDATE`.

## Decision

The runtime is sufficiently isolated, typed, and evidence-bound to advance
H10 from `READY` to `IMPLEMENTED`. The next gate is a tracked
`implementation_manifest.yaml` that binds one runtime commit and the exact
reviewed file bytes. No admission event or live benchmark evidence exists.

## Post-Review Binding

- Runtime commit: `a79bb74133886608f57cecba998834a7d3b51f0f`.
- Implementation-manifest commit:
  `0223e7c906b55132401e18d5df7d3cf185b6526b`.
- Implementation-manifest SHA-256:
  `e3514cc1e21e976ea7de2a95d38adb5e479879935e3e07ffd3a7ed8436b2d423`.
- The reporter validator reproduces all 34 current and committed file hashes.
  The admission calculation returns `PASS` for `smoke_classic`; no admission
  event has been written.
