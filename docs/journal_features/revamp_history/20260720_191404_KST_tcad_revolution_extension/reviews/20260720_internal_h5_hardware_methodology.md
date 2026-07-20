# H5 Hardware/EDA Methodology Review

- Date: 2026-07-20
- Mode: independent read-only subagent
- Scope: H5 card, contracts, classic prompts/code, and log schema
- Initial verdict: `DEFER`

## Blocking Findings

1. Every classic failed-parent operator receives stored feedback, and M-I also
   requests correctness improvement. The mechanism must be described as
   M-F-only routing versus the five-operator policy, not unique feedback use.
2. Existing logs omit parent IDs and stage booleans, while `failed_synthesis`
   conflates true synthesis failure with later PPA-flow failure.
3. Conditional repair yield is treatment-dependent. The primary mechanism
   estimand must be unconditional direct valid-PPA repairs per fixed
   48-candidate budget.
4. Confirmation's “stable telemetry” language was undefined. Exact activation,
   a positive unconditional repair delta, and mandatory final HV must replace
   it. Coverage improvement requires positive confirmation coverage.
5. Unspecified descendant HV contribution is ambiguous for multi-parent
   lineages and must be removed.

## Accepted Dispositions

- Reframe H5 as exclusive dedicated-correction intent routing and explicitly
  acknowledge M-I and shared feedback.
- Freeze `candidates/H5_role_aligned_failed_repair/telemetry_schema.md` before
  implementation.
- Add parent IDs and stage booleans to matched-arm candidate logs; add pre/post
  pool telemetry around the inherited treatment generation method.
- Gate development on unconditional direct valid-PPA repair count in each seed;
  retain conditional yield as diagnostic evidence.
- Remove descendant-level HV credit and tighten confirmation/coverage wording.

## Residual Risks

M-F remains a generic Verilog correction intent rather than a stage-specific
EDA operator. M-F-only routing may lose useful redesign diversity, and success
pool saturation may break the proposed intermediate causal chain. A positive
mean with an interval crossing zero is observed uplift, not statistically
resolved superiority.

Closure review is required after the card and telemetry schema implement these
dispositions.

## Closure

The independent reviewer re-read the corrected card and frozen telemetry
schema. Final verdict: `ACCEPT`.

All five blockers are resolved: the contrast is exact M-F-only routing with
shared-feedback disclosure; parent/stage/pool fields are exhaustive; the
estimand is unconditional direct repair count; confirmation has explicit
activation, repair, HV, and coverage rules; and descendant HV attribution is
absent. Implementation conformance remains a separate code and smoke gate.
