# Wave 2 Internal Methodology Review

- Date: 2026-07-21
- Mode: read-only independent subagent
- Session: `019f82d3-76f5-7b41-ba68-e45c314004f8`
- Final verdict: `PASS`

The reviewer performed four adversarial passes. It edited no file. Draft
status and unresolved hashes remained intentional until this final verdict.

## Initial Rejections

The first pass rejected ambiguous per-seed coverage translation, unbound H5
resource arithmetic, a mutable budget worksheet, one-sided arm envelopes, an
unimplemented token sentinel, information leakage, and incomplete deadline
projection. The second pass required exact pair-equal caps, honest post-arm
token/synthesis semantics, and an explicit prospective contract revision.

The executable pass then found six concrete gaps:

1. the ledger did not enforce the exact six-arm sequence or worksheet identity;
2. malformed accounting could manufacture zero spend;
3. candidate worksheets could redefine the 21-day window;
4. coverage helpers did not require both seeds or loss-only catastrophic sums;
5. classic-rerun `BLOCKED` recovery existed only in prose;
6. draft hashes and statuses were unresolved.

A later consistency pass rejected the nominally global ledger because a new
candidate could be admitted while another candidate was pending or between
arms. That finding superseded the earlier provisional pass.

## Owner Dispositions

| Finding | Disposition |
| --- | --- |
| Exact ladder and ledger identity | `ACCEPT`: enforce arm IDs/order/pairs/roles, pair-equal maxima, event order, candidate ID, and worksheet SHA-256. |
| Zeroed malformed accounting | `ACCEPT`: invalid accounting emits `STOP`, appends nothing, and leaves the arm pending until authoritative reconstruction. |
| Candidate-controlled program window | `ACCEPT`: pin goal activation and its exact 21-day deadline in manifest v5, the template, and admission code. |
| Coverage seed/netting ambiguity | `ACCEPT`: require exactly seeds 1001/1002 on all three surfaces and sum catastrophic losses without gains. |
| Generic `BLOCKED` continuation engine | `REJECT`: fail closed now; any named failure requires a new outcome-blind worksheet and tool review. Prebuilding an unused fallback would add unjustified state. The reviewer accepted this boundary. |
| Raw smoke synthesis provenance | `ACCEPT`: generate a pinned artifact from all six raw generation logs and count RTL-simulation-passing candidates as synthesis starts. |
| Cross-candidate serialization | `ACCEPT`: reject another candidate while the current candidate is pending or between arms, reject interleaved ledgers, and permit transition only after terminal stop or all six arms. |
| Final hashes/status | `ACCEPT`: populate only after the final review, then freeze in the signed commit. |

## Final Verification

- The H5 source artifacts reproduce all six pair-equal envelopes and totals.
- Invalid, pending, wrong-order, duplicate, switched-worksheet, and terminal
  transitions fail closed without corrupting the ledger.
- Pending, between-arm, and concurrent cross-candidate transitions return
  `STOP`; terminal stop and six-arm completion permit the next candidate.
- Fractional, Boolean, negative, missing-source, and incomplete accounting
  cannot erase spend or permit another arm.
- Cross-seed gains cannot offset per-seed noninferiority or catastrophic losses.
- The smoke synthesis artifact reproduces from all six raw logs.
- Focused validation: 37 tests passed; Ruff, Pyright, and `ty` passed.

No methodology launch blocker remains. Candidate treatment still requires its
own frozen card, worksheet, reporter integration test, and independent review.
