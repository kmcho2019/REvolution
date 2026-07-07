# Codex Second Opinion: N07-N10 Follow-Ups

Date: 2026-07-07.

Scope: commits `0f8f616883..HEAD` on
`feat/journal-qd-bd-exp-20260703`, covering N07a/N07c descriptor
due diligence, N09 Pareto capacity, and N10 SR-ReLU PCA.

Method: read-only multi-agent Codex audit. The local `codex` CLI was
not available in `PATH`, so this file records the Codex-side
multi-agent review output.

## Verdict: PASS

No blockers found. The audit treated the committed range as the
evidence scope and did not modify files.

## Findings

1. Natural-extension vision holds. N07 explicitly rejects the old
   multi-knob June-30 recipes and keeps only descriptor swaps; N09 is
   one existing capacity knob with no trigger or new code; N10 is
   descriptor-only, not a search heuristic.

2. Operator and representation contracts are clean. The audited arms
   follow the plan requirement for `eoh_strategies`,
   `code_individual`, and `single_thought_count=0`. N10 discloses
   M-T/C-D fill-lane use through `other_strategy_count`, but has no
   single-thought leakage.

3. Registration-before-results and validation flow pass. Commit order
   is registration/gate/result for N07, registration/result for N09,
   and smoke/registration before result for N10. Minor residual:
   N07 history timestamps are awkward (`13:05` registration appears
   before a `13:01` smoke entry), but committed order is correct.

4. Claims match artifacts and stay diagnostic. N07a/N07c close below
   classic; N09 beats classic but trails V2 and reduces breadth; N10
   beats classic only, trails V2, and loses yield/breadth. Central
   docs keep N07b open as unanswered.

5. Organization is acceptable. No core QD engine change appears in the
   audited range; new code is limited to bounded smoke helpers/tests.
   Residual risk: N10 validation JSON does not assert
   `qd_descriptor_file`, although the stored run config proves the
   lane-local file was used.

## Required Actions

None.

## Recommended Next Step

Stop opening new single-knob scans. Either run only the bounded N07b
extraction smoke to close due diligence, or explicitly leave N07b
low-priority and pivot to P4/manuscript synthesis around the two-scale
V2/N03b story, the compact_8d swap decision, and optional held-out
confirmation.
