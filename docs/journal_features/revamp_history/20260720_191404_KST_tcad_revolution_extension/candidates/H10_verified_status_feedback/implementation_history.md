# H10 Implementation History

Append-only record for proposal, implementation, validation, and decision
events. No treatment code or result existed at candidate selection.

## 2026-07-21: Proposal selection

- Audited 4,800 candidates from the fresh H5 matched classic controls with
  `scripts/report_revolution_feedback_contract.py`.
- Reproduced 687/2,309 clear failure-contract mismatches, 4/2,067 success
  mismatches, 215 false score-10 functional failures, and the independent
  failed-parent outcome counts.
- Retracted a prior broad-regex missing-testbench count; the strict phrase audit
  found zero and the withdrawn claim has no role.
- Rejected all-candidate raw evaluator payloads because they exceed the measured
  need, risk prompt-resource skew, and require a payload sidecar. Rejected
  success-only and mismatch-triggered treatments for lack of premise and added
  policy state.
- Selected one fixed failed-candidate terminal-status line as a distinct H10
  supporting reliability proposal.
- Preliminary independent scientific and code reviews accepted the narrow
  concept at 13/14. Exact-card, budget, and external closure remain open.
- No runtime source, config, worksheet, admission event, LLM call, synthesis
  evaluation, or benchmark result was created for H10 at this transition.

## 2026-07-21: Exact-card freeze

- Froze the hypothesis, one-line mechanism, six-arm discovery budget, source
  and report manifests, reporter contract, and Wave-2 provenance amendment.
- Closed code, scientific, evidence, and simplicity review after correcting
  classic method-failure handling, catastrophic HV and coverage translation,
  serialized-prompt proof, implementation identity, complete program-input
  hashing, arm-tree sealing, failure-registry binding, and ledger chronology.
- Focused reporter and admission tests passed 64 cases after the final
  adversarial dependency mutation tests. Final freeze validation passed 68
  relevant tests and the full repository at 1,167 passed with 4 skips. The
  external exact-card retry timed out and is recorded as unavailable.
- Frozen provenance-amendment SHA-256:
  `2a541309ba17f65e1682744bd2cfc941011b82cd7948fd597ba5a7cfde366c7f`.
- Frozen program-manifest-v6 SHA-256:
  `e54c59823640604f8669ca2fae2b7ced8d9dc5c3d76a310cd964c4948e7c06d6`.
- Advanced H10 from `PROPOSED` to `READY`. This authorizes implementation only;
  no runtime source, implementation manifest, admission event, LLM call,
  synthesis evaluation, or benchmark result existed at the transition.

## 2026-07-21: Runtime implementation

- Added one isolated `VerifiedStatusFeedbackEngine` subclass. It calls classic
  evaluation first, exhaustively transforms only the six failed terminal
  states, leaves success unchanged, and records exact activation and
  failed-parent serialization telemetry.
- Registered one fixed H10 mode in the shared backend and CLI. Contract checks
  pin dual pools, whole generation, EoH strategies, the classic success set,
  UCB, code individuals, no repair, strict formatting, default prompts, and
  strict-ablation evaluation.
- The classic engine and default configuration remain byte-identical at
  SHA-256 values
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`
  and
  `cd44c8de823b9843339718cd8116d325f35a11188b38103553dcc2cbc8c0a34b`.
- Three read-only audits accepted the RTLLM implementation after replacing the
  stale v6 runtime binding with frozen program-manifest v7, correcting the
  reporter version guard, and adding backend/CLI dispatch tests to the exact
  implementation file set. Combined validation passed 161 relevant tests,
  Ruff, Pyright, `ty`, YAML, and hash checks. The headless full repository
  passed 1,202 tests with 4 skips.
- Program-manifest v7 SHA-256:
  `316bab8cb0f404a9bff6ad839522df3137f78e2321b220cd17fddd90c066a662`.
- Review found that CVDP's `candidate_evaluator` is not supplied to this
  classic-engine path. RTLLM smoke and development remain eligible, but
  confirmation and holdout are blocked until a prospective composition review;
  absent that fix, H10 cannot exceed `VIABLE`.
- Advanced H10 from `READY` to `IMPLEMENTED`. No tracked implementation
  manifest, admission event, model call, synthesis evaluation, or benchmark
  result existed at this transition.
