# T74 Results Report

Status: completed `T0 diagnostic_regression_not_promoted`.

## Current Tier

`T0 diagnostic_regression_not_promoted`.

T74 is a negative follow-up to T73. It preserves reference-complete coverage
on the 13-problem hard/tuning subset, but it loses to classic on every primary
PPA-front metric and also regresses from T73 on mean HV and valid-PPA yield.

## Run

- run root:
  `exp/useful_bd_push/t74_shape_density_front_slot_hybrid_20260624_010922_UTC/hard_tuning`
- backend:
  `shape_density_front_slot_hybrid_qd/seed_1001`
- model: `openai/gpt-oss-120b`, `max_model_len=131072`
- token budgets: `128000` max tokens and diff tokens
- budget: population `12`, generations `3`, seed `1001`
- runtime: `1698.28` seconds
- validators:
  - `validate_single_thought_operator_run.py`: pass
  - `validate_pareto_front_run.py`: pass
  - strict Phase 03.1 viewer validator: pass
  - Playwright interaction validator: failed hover/alias checks; see
    `matched_classic_comparison/visualizations/qd_ppa_viewer/playwright_caveat.md`

## Headline Metrics

All 13 problems have valid reference PPA and at least one classic and T74
valid-PPA candidate, so the headline comparison uses the full hard/tuning
subset.

| Backend | Solved | Functionality Mean | Synthesis Mean | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins | Valid PPA |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classic | 13/13 | 42.6% | 41.2% | 0.0926007600 | 2.31 | 3.54 | 8 | 257 |
| T73 | 13/13 | 48.4% | 47.1% | 0.0890223082 | 1.46 | 3.69 | 0 | 294 |
| T74 | 13/13 | 39.4% | 38.0% | 0.0851926237 | 1.62 | 3.15 | 1 | 237 |

T74 is worse than classic by `0.0074081363` mean HV and worse than T73 by
`0.0038296845` mean HV. It does not trigger the catastrophic 50% validity
collapse gate, but the validity/yield direction is still worse than both
classic and T73.

## Two-Parent Audit

`tables/t74_two_parent_descriptor_audit_summary.json` reports:

- `two_parent_rows=4`;
- `audited_two_parent_rows=3`;
- `compatible_two_parent_rows=3`;
- `missing_parent_descriptor_rows=1`.

The audited two-parent rows obey the `near_front_descriptor` threshold
(`distance_sq <= 6.75`), but there are too few realized pairs and no front/HV
gain. This supports the pre-registered underpowered-intervention caveat:
gating the existing low-rate single-thought two-parent requests is not enough.

## Visual Evidence

- HV delta figure:
  `matched_classic_comparison/figures/t74_hv_delta_by_problem.png`
- valid-PPA count figure:
  `matched_classic_comparison/figures/t74_valid_ppa_counts.png`
- representative PPA-front panels:
  `matched_classic_comparison/figures/pareto_examples/`
- full Phase 03.1 viewer:
  `matched_classic_comparison/visualizations/qd_ppa_viewer/index.html`

Manual inspection found the figures readable and the viewer screenshot
nonblank. The viewer is structurally valid, but Playwright hover checks fail
on the same browser-interaction class already seen in T73.

## Decision

Retire exact T74. The result says T73's shape-density cells should not be
combined with only low-rate near-front pair gating. A follow-up should change
front creation more directly, reduce reliance on rare two-parent prompts, or
return to the T72/T51 mechanism lineage instead of spending another seed on
the same T73/T74 shape-density coupling.
