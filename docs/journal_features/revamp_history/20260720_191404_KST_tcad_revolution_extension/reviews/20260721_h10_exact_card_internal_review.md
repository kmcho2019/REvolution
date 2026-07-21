# H10 Exact-Card Internal Review

Verdict: `PASS_FOR_IMPLEMENTATION`

- Freeze time: `2026-07-21T11:16:00Z`
- Scope: frozen H10 hypothesis, six-arm budget, source/report manifests,
  reporter translation, admission identity, raw-evidence provenance, and code
  simplicity
- Boundary: this verdict authorizes implementation only. It is not an
  implementation, admission, smoke, suite, or performance verdict.

## Independent Reviewers

| Role | Session | Final verdict |
| --- | --- | --- |
| Code boundary | `019f83d6-c2e6-75c3-b18b-1de19599c68a` | `PASS` |
| Scientific contract | `019f841a-ec3c-7532-beeb-b6a57f46fcf2` | `PASS` |
| Evidence provenance | `019f8451-fa14-71d1-ac93-fda04ac928ac` | `PASS` |
| Simplicity and bloat | `019f83d6-c332-75c0-8bfe-203afd4af410` | `PASS` |

## Blocking Findings Closed

- Complete classic method failures are excluded from paired PPA gates;
  classic infrastructure and malformed states produce the contracted terminal
  outcome rather than an assertion or historical substitution.
- The reporter executes both the absolute final-HV margin and catastrophic
  `0.90` ratio, imports the shared per-seed coverage rules, and reports the
  separate loss-only catastrophic coverage gate.
- Exact serialized parent payloads prove that status-prefixed feedback reaches
  the offspring prompt; immutable critic artifacts remain independently bound.
- Every arm is sealed by an exact regular-file manifest. The final treatment
  arm seals the stage failure registry, report output must be outside raw
  roots, and accounting reconciles to scheduler telemetry.
- The frozen opening-ledger prefix, arm intervals, cross-arm chronology,
  worksheet identity, and one implementation-manifest identity are replayed.
- The implementation manifest must be a tracked `HEAD` file and bind a real
  ancestor commit, the exact implementation/test/contract/environment file
  set, and identical current and committed bytes.
- Every non-ledger program-manifest path/hash pair is revalidated, including
  backend, representative selection, full-suite, holdout, and Wave-2 contract
  dependencies. Prompt and reference-PPA manifests are checked separately.

An earlier evidence pass raised the impossible stronger threat model of a
dishonest actor coherently rewriting Git history, manifests, ledger, and raw
evidence before review. That is outside the declared reproducibility boundary.
The accepted boundary detects mutation and substitution after capture; it does
not claim cryptographic attestation against pre-capture fabrication.

## Validation

- `64 passed` for the H10 reporter and admission tests after the final
  provenance correction.
- `ruff check` and `git diff --check` passed on the corrected surfaces.
- Final freeze validation passed `68` relevant tests and the full repository at
  `1167 passed, 4 skipped`. Earlier closure runs also passed before the final
  provenance cases were added.
- A 600-second exact-card `claude -p` retry timed out with no substantive
  output. It is recorded as `UNAVAILABLE`, not as approval.

## Decision

The exact scientific and evidence contract is frozen and H10 may become
`READY`, which authorizes the smallest isolated implementation. No live arm may
be admitted until runtime tests, implementation audits, a tracked
`implementation_manifest.yaml`, and ledger admission all pass.
