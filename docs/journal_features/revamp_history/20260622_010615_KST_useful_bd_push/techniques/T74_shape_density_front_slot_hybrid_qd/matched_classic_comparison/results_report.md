# T74 Matched Results Report

Status: completed `T0 diagnostic_regression_not_promoted`.

## Answer

T74 does not beat classic and does not improve on T73 enough to justify another
same-family live spend. It preserves all 13 headline comparisons, but its
front quality is weaker than classic and its yield is weaker than T73.

## Evidence

| Backend | Solved | Functionality Mean | Synthesis Mean | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classic | 13/13 | 42.6% | 41.2% | 0.0926007600 | 2.31 | 3.54 | 8 |
| T73 | 13/13 | 48.4% | 47.1% | 0.0890223082 | 1.46 | 3.69 | 0 |
| T74 | 13/13 | 39.4% | 38.0% | 0.0851926237 | 1.62 | 3.15 | 1 |

The completeness table has 13 headline rows. There are no missing-reference
headline problems.

## Interpretation

The near-front descriptor gate worked mechanically for the few auditable
two-parent rows, but the intervention is too sparse to recover front material.
T74's lower functionality/synthesis mean and lower valid-PPA yield versus T73
also removes the main T73 benefit.

## Visual Checks

- `figures/t74_hv_delta_by_problem.png`: readable; shows one small positive
  and several negative HV deltas, including the dominant traffic-light loss.
- `figures/t74_valid_ppa_counts.png`: readable; shows mixed yield with lower
  total T74 valid-PPA count than classic.
- `visualizations/qd_ppa_viewer/screenshot.png`: nonblank classic-vs-T74
  compare screenshot.
- strict viewer validator: pass.
- Playwright interaction validator: fail on known hover/alias checks; see
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.

## Follow-Up

Do not spend another seed on exact T74. The next method should either change
front creation directly or return to a better-performing archive-coupling
lineage. Low-rate pair gating is not enough evidence of useful RTL diversity.
