# H5 External Contract Audit

- Date: 2026-07-21
- Reviewer: Claude Code 2.1.215 through read-only `claude -p`
- Final verdict: `FAIL / RETIRED`

The first broad result-review attempt reached its 600-second limit and emitted
only `Execution error`; it supplies no evidence. A narrower 600-second retry
reviewed the accepted claims contract, frozen baseline and program manifests,
H5 experiment manifest, reporter implementation, generated package, and raw
resource evidence. It completed successfully and edited nothing.

## Independent Findings

1. The frozen coverage rule is independently bounded at one problem per seed.
   H5 falls from 34/46 to 32/46 valid-PPA coverage at seed 1001 and therefore
   fails noninferiority. Seed 1002's 32/46 to 33/46 gain cannot be netted against
   that failure.
2. The reporter implements a different rule: it sums signed seed deficits and
   compares the net value with an aggregate maximum of two. The candidate
   manifest and generated report are subordinate to the accepted contract and
   frozen margin definitions, so their `VIABLE` label is not authoritative.
3. Independent raw-artifact recomputation confirmed cumulative discovery totals
   of 11,232 candidates, 22,466 calls, 69,289,552 tokens, 6,056 synthesis
   evaluations, and 6.231970 endpoint-arm hours. Every per-candidate ceiling is
   exceeded when mandatory matched controls are included.
4. The resource overrun is a program-process violation, not a within-pair
   fairness failure or an external blocker. It authorizes neither `BLOCKED` nor
   a new terminal vocabulary. The accepted outcome is `RETIRED`.

## Allowed Wording

> Under the frozen two-seed RTLLM development protocol, M-F-only routing
> produced five and three additional direct fail-origin valid-PPA repairs at
> equal full-suite candidate budgets. Mean final HV and HV-AUC were higher but
> unresolved; aggregate valid-PPA and RTL-functionality coverage each ended one
> unit below classic; seed 1001 exceeded the valid-PPA coverage margin.

The external review forbids viability, coverage preservation, general
reliability improvement, causal PPA gain, integration, confirmation, or journal
candidacy. It recommends preserving the generated `VIABLE` field untouched as
an auditability artifact while recording `RETIRED` in the governing decision.
