# Natural QD Follow-Up Decision Map

Date: 2026-07-07.

Purpose: summarize what the post-PASS follow-up portfolio says after N04,
N02b, N07a/N07b/N07c, N09, and N10, with N03b/N06/N08 context where it
sets the manuscript stance. This is the manuscript-facing map for why the
campaign should not keep opening one-knob scans unless a new mechanism
card changes the theory.

## Decision

Stop new single-knob natural-variant screens for this push.

The evidence now covers budget shape, initialization depth, curiosity
sampling, archive retention capacity, archive parent sourcing,
descriptor semantics, descriptor geometry, and descriptor extraction
due diligence. The tested variants are operator-fair:
`qd_operator_kind=eoh_strategies`, `representation_kind=code_individual`,
and `single_thought_count=0` in headline comparisons. None displaces the
Smooth-QD V2 platform.

The plan's negative-map stop condition has now been adversarially
reviewed as PASS in `negative_map_adversarial_validation_report.md`.
This file is the manuscript-facing evidence map for that closure path.

## Current Best Answer

The natural journal extension remains Smooth-QD V2, not a later
post-PASS variant. The paper-facing result is stronger as a two-scale
characterization:

- Screening scale: V2 beats classic by `+12.9%` mean HV and `+16.2%`
  HV-AUC across 3 seeds with coverage retained.
- Full RTLLM scale: V2 lands at `95.2%` mean HV, `100.5%` HV-AUC, and
  coverage `166` vs classic `164`; N03b is the suite AUC/front-material
  utility candidate (`102.5%` HV-AUC, `96.9%` HV).
- Follow-up variants explain why the win does not become a simple
  full-suite HV dominance claim: the failures are yield-loss,
  front-loss, descriptor-collapse, exploration-tax, or mechanism-inert,
  not operator contamination.

## Lane Map

| Lane | Mechanism question | Result | Cause class | Manuscript use |
| --- | --- | --- | --- | --- |
| N04 budget shape | Does faithful V2 benefit from deeper equal-candidate budget? | 6x7 reaches final-HV parity/slight edge vs classic (`101.1%`) but loses HV-AUC (`90.5%`) and Pareto breadth. | front-loss / anytime-loss | Budget depth is not the missing full-suite win lever; no 4x11. |
| N02b curiosity | Does softer under-populated-cell parent bias rescue gamma 1.0? | Coverage recovers, but HV/HV-AUC fall below classic (`91.5%` / `92.5%`) and far below V2 (`74.0%` / `79.7%`). | exploration-tax | Curiosity weighting is a clean negative; do not scan gamma. |
| N07a/N07c corrected-suite descriptors | Do source-aligned RF timing or structural compact descriptors complete the suite story? | Both retain coverage but close below classic (`90.7%` and `88.1%` HV). | descriptor-collapse / front-loss | Smoke health is insufficient; live generated candidates can collapse the descriptor. |
| N07b RF/DeepGate hybrid | Can the richer hybrid clear extraction before live spend? | Extraction gate fails on `RTLLM/Prob045_alu` during AIG export. | extraction failure | No live screen; corrected-suite descriptor due diligence is closed. |
| N09 capacity 7 | Is V2's 5-elite cell cap too tight? | Beats classic (`113.3%` HV, `114.5%` HV-AUC) but trails V2 (`91.7%` / `98.7%`) and reduces Pareto breadth. | capacity-inert / front-loss | Capacity above five is diagnostic only. |
| N10 SR-ReLU PCA | Does the strongest descriptor-isolating replay lead transfer live? | Beats classic (`111.5%` HV, `108.3%` HV-AUC) but trails V2 (`90.3%` / `93.3%`) with lower valid-PPA yield and one all-axis collapse. | yield-loss / front-loss | Diagnostic descriptor result; no seed ladder or full-suite spend. |
| N06/P3c descriptor sweep | Is BD choice an HV lever at suite scale? | Compact_8d ties trio-family HV while improving collapse resistance, but no descriptor beats classic or the +5% gate. | descriptor-health trade | Descriptor choice is a health/functionality dial, not a headline HV dial. |
| N03b suite probe | Does archive parent sourcing matter at RTLLM scale? | N03b beats V2 on suite HV-AUC (`102.5%` of classic) but not the +5% HV gate; coverage is lower than V2. | axis trade | Keep as Branch-B utility/front-material candidate, not the registered promotion arm. |
| N08 combination | Is there a replicated winner to combine with V2? | Blocked by gate: no post-PASS single-factor arm displaces V2. | blocked escalation | Do not invent combination arms without a winner pair. |

## Stop Rules For More Variants

Do not open another capacity, gamma, warmup, budget-depth, descriptor-only,
or archive-shape scan from the existing backlog. A new run needs all of:

1. A short mechanism card that is qualitatively different from the tested
   knobs above.
2. A gate recorded before launch.
3. No PCN-style triggers, credit assignment, stagnation logic, or operator
   changes.
4. V2-faithful runtime settings unless the card explicitly justifies a
   different comparator.
5. An explanation for which existing failure class it should defeat.

## Remaining Paper Decisions

- Compact_8d swap: still a manuscript decision, not a live-screen reason
  by itself. It has a health advantage and one disclosed extraction
  fragility; use it as a qualified robustness/appendix option unless the
  manuscript needs a full 5-seed contract treatment.
- Held-out confirmation: optional because the suite +5% gate did not fire.
  If used, it should confirm the screening-scale characterization, not
  create a new Branch-A/B claim.
- Adversarial negative-map review: completed with PASS in
  `negative_map_adversarial_validation_report.md`.

## Next Action

Pivot to manuscript synthesis from the V2/N03b two-scale characterization
and this operator-fair negative map. Do not spend more vLLM budget on N07,
N09, N10, or other one-knob natural variants without a new mechanism card
that passes the stop rules above.

## 2026-07-08 User-Directed Reopen

The user explicitly requested a more ambitious suite-first continuation
because the 8-design screen appears weakly correlated with full RTLLM.
That continuation is tracked separately under
`suite_variant_campaign/`. It does not invalidate this decision map; it
changes the research policy from screen-gated follow-ups to direct
full-suite probing of natural variants.

## 2026-07-10 Suite-First Addendum

The suite-first reopen did not produce a primary full-RTLLM HV winner.
Its strongest result is S07 `capacity3`: five-seed HV-AUC and coverage
improve over classic, but final HV remains below classic (`0.102481` vs
`0.103802`). S23 descriptor reduction and S11 warmup12 are valid negative
controls. S04/S05/S06 are now appendix-only reserves, not primary HV
lanes.

Current posture returns to the negative-map synthesis path. One fresh
S07-family exception was tested after this note: S32 `capacity4`, the
direct interpolation between V2 capacity5 and S07 capacity3. It closed
negative at seed 1001 (`0.096196` HV / `0.080789` HV-AUC46 / `21/46`
coverage vs matched classic `0.111401` / `0.090551` / `24/46`) and
blocks seed 1002 under its 90% classic-HV stop rule. A new primary
experiment still requires a fresh mechanism card before launch, not
another queue scan of capacity, warmup, front-slot, or descriptor-only
knobs.
