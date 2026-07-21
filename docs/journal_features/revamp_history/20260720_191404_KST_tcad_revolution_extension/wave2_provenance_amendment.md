# Wave 2 Provenance Amendment

Status: `FROZEN` at `2026-07-21T11:16:00Z`; no H10 arm may launch until its
runtime implementation, tracked implementation manifest, and admission gate
also pass.

This amendment closes evidence-binding gaps found during the H10 exact-card
review. It changes no candidate mechanism, benchmark, seed, metric, practical
margin, resource ceiling, or decision role from the frozen Wave-2 methodology.
Program-manifest v5 remains the historical pre-amendment artifact; v6 is the
prospective manifest for H10 and later Wave-2 candidates.

## Implementation Identity

Every `admit` command requires the candidate's implementation manifest. The
admission tool records its resolved path and SHA-256 in every admitted,
completed, or stopped event. All events for one candidate must retain exactly
one worksheet hash and one implementation-manifest identity. A later arm or
accounting record returns `STOP` if the manifest bytes changed.

The candidate reporter additionally requires the manifest to name a real
40-character Git commit that is an ancestor of the reporting checkout. Every
declared file must have the registered SHA-256 both in that commit and in the
reporting tree, and the manifest itself must be tracked byte-identically in
reporting `HEAD`. The exact file set includes the experimental engine, shared
dispatch, reporter, every imported gate-bearing helper, governing contracts,
focused tests, and environment lock files. The reporter also rehashes every
non-ledger path/hash pair declared by program-manifest v6.

## Outcome Evidence

Each completed arm contains `arm_evidence_manifest.sha256`. It hashes the exact
regular-file tree below that canonical arm root, excluding only itself. The
last treatment arm of each stage also includes that stage's
`unit_failures.yaml`; the registry in turn binds every registered failure
artifact by SHA-256.

The accounting artifact names the arm-evidence manifest as its raw-evidence
artifact. The admission ledger therefore binds the manifest path and hash
before the next arm can launch. The reporter rejects a changed, missing, or
extra arm file, a changed failure registry, more than one scheduler-telemetry
file, or scheduler wall time that disagrees with accounting.
The consumed registry path must equal the sealed stage-root path, and report
output must remain outside every raw stage root.

The reporter reproduces the frozen opening-ledger hash and requires each later
arm admission time to follow the preceding capture time. These checks detect
prefix substitution and cross-arm chronology rewrites while retaining the
existing six-arm state machine.

This is a hash inventory, not a copied archive and not a claim against
dishonest pre-capture fabrication. Its purpose is narrower: preserve the exact
raw bytes used by the terminal report and make post-capture mutation visible.

## Scientific Corrections

The H10 reporter must also execute three already-frozen program rules that its
draft omitted:

- exclude genuine complete classic method failures from paired PPA gates and
  report treatment-only valid-PPA successes separately;
- require treatment/classic mean final-HV ratio of at least `0.90` in addition
  to the absolute final-HV noninferiority margin;
- report the separate loss-only catastrophic coverage reduction on all three
  frozen coverage surfaces, without offsetting losses by gains.

Treatment prompt-use telemetry retains the exact serialized parent payload.
The reporter parses it and proves that its `feedback` field equals the
status-prefixed bytes reconstructed from the immutable critic artifact.

## Review Gate

- [x] Admission tests prove manifest identity is recorded and mutation stops.
- [x] Reporter tests prove real-commit bytes and exact dependency coverage.
- [x] Reporter tests prove exact arm-tree sealing and failure-registry binding.
- [x] Reporter tests reject opening-ledger, cross-arm chronology, and
      output-root substitutions.
- [x] Distinguishing tests prove classic-failure exclusion and the `0.90` HV
      ratio gate, plus loss-only catastrophic coverage.
- [x] Adversarial telemetry proves a hash-valid payload without transformed
      feedback fails.
- [x] Independent code, evidence, scientific, and simplicity reviews pass.

Decision: `PASS`; see
`reviews/20260721_h10_exact_card_internal_review.md`. The external exact-card
retry is separately recorded as `UNAVAILABLE`.
