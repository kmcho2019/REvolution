# H10 Pre-Admission Provenance Review

Verdict: `BLOCK_FOR_SMOKE_ADMISSION`

- Review time: `2026-07-21T12:33:41Z`
- Reviewer session: `019f84a0-18a3-74b1-a899-efd67ae2d6df`
- Scope: runtime and implementation commits, program-manifest v7, reporter
  path/hash traversal, implementation-file identity, Wave-2 ledger, endpoint,
  and smoke admission state.
- Boundary: no admission event or treatment evidence existed, so every
  correction below is prospective.

## Blocking Findings

1. Program-manifest v7 retained backend Git blob
   `1ccd45d1b1af6fc5ea6128ff3c03acd5252aa5ab`, whose content SHA-256 is the
   pre-H10 backend value. The declared v7 backend SHA-256 instead identifies
   the current H10-registered backend. The current Git blob is
   `be5a61ee44c734183635eee0ce4d4612ced4c364`.
2. `_validate_frozen_inputs` derived `budget_reference` from
   `budget_reference_sha256`, but the manifest uses
   `budget_reference_path`. This skipped all 13 Wave-2 `*_path` hash pairs.
   Adversarial in-memory digest corruption therefore passed validation.
3. Six skipped Wave-2 sources and five benchmark/holdout sources were absent
   from the 34-file direct implementation binding. The program manifest
   provided transitive hashes, but the frozen reporter contract promised a
   direct exact implementation file set.

## Evidence That Passed

- The first tracked implementation manifest matched its declared 34 paths,
  runtime commit, current bytes, and tracked `HEAD` bytes.
- Classic core, default configuration, 28 default prompts, and 46 reference-PPA
  files reproduced their frozen hashes.
- Candidate budget and run/report manifests were mutually consistent.
- The Wave-2 ledger contained only its hash-valid start record. Pure admission
  evaluation returned `PASS` only for `smoke_classic`; the missing event was an
  expected next action, not a blocker.
- The vLLM endpoint exposed `openai/gpt-oss-120b` at context length 131,072.
- Focused validation passed 161 tests and static checks before this audit.
- CVDP remains confirmation-only and does not affect RTLLM smoke readiness.

## Prospective Correction

- Preserve v7 and the first implementation manifest as rejected historical
  records; rewrite neither.
- Freeze program-manifest v8 with the current backend Git blob before evidence.
- Recognize both `<name>` and `<name>_path` companions for every
  `<name>_sha256`, reject ambiguous pairs, and validate current Git blobs.
- Require every resolved program source directly in `IMPLEMENTATION_FILES`.
  The corrected exact set contains 45 files.
- Add distinguishing tests for all 23 program path/hash pairs, both Git blobs,
  and direct implementation-set membership.
- Commit the corrected runtime, replace the tracked implementation manifest
  with hashes from that commit, rerun this audit, and only then admit smoke.

Closure remains pending. No benchmark arm may launch under this verdict.

## Corrected Source Rereview

Verdict: `PASS_FOR_CORRECTED_RUNTIME_COMMIT`

- The same reviewer reproduced v8 SHA-256
  `26c83aa4ea6a01ef31f0757a560564c1df1c86ee42745242aad88eaf4ef83666`
  and the current backend blob and SHA-256.
- Independent traversal found exactly 23 unique program path/hash sources; all
  exist, match, and belong to the 45-file implementation set.
- Mutation of every digest, removal of every direct source, mutation of either
  Git blob, and both ambiguous base/base-path forms were rejected.
- Focused validation passed 181 tests. The newly bound smoke-synthesis test,
  Ruff, Pyright, `ty`, YAML, and diff checks passed. The headless full
  repository passed 1,222 tests with 4 skips in 322.24 seconds.
- Historical v7, the first implementation manifest, and the one-record Wave-2
  ledger remain unchanged. No H10 evidence directory exists.

This rereview authorizes a corrected runtime commit only. Replacement of the
tracked implementation manifest and final smoke-admission rereview remain
ordered gates; no benchmark arm may launch yet.

## Final Identity Rereview

Verdict: `PASS_FOR_SMOKE_ADMISSION`

- Corrected runtime commit:
  `ed5863c5fa578a0a5a2ffb73d1aebef44e67f8e8`.
- Replacement implementation-manifest commit:
  `11ad5ccabcbc954909201543ea29cd8d633f38dc`.
- Replacement manifest SHA-256:
  `c0ef63b5852252bee8d2128b557d433543e50042e096fb0a6181cc7bd0f9a582`.
- The reporter's implementation validator passes all 45 exact current and
  runtime-commit bytes. No bound path changed after the corrected runtime
  commit.
- Frozen v8, 23 direct source hashes, two Git blobs, classic/default/prompt
  pins, 46 reference files, worksheet, configs, and report manifests pass.
- The ledger still contains only its opening record. Pure admission evaluation
  returns `PASS` only for `smoke_classic`; every later arm returns `STOP`.
- No H10 evidence root exists. The absent admission event is the expected next
  action, not a blocker. CVDP remains confirmation-only.

H10 may execute only the frozen sequential technical smoke. This is not a
smoke, suite, or performance verdict.
