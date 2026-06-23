# T57 T51 Adaptive-Rebin QD Result Report

Status: `T0 diagnostic_no_rebin_signal`.

## Question

T57 tested whether T51's code-individual, single-thought, NSGA-II global-rank
QD run could recover more front breadth by adapting only the `grid_quantile`
archive cut points. It kept T51's descriptor, operator, parent selection,
champion lane, one-slot archive retention, and no-repair path fixed.

## Headline Result

T57 is not promoted. It completed all 13 hard/tuning problems, but the
adaptive-rebin mechanism emitted checks without any rebin events and did not
beat classic or T51 on the primary PPA-front metrics.

| Metric | Classic | T57 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.092601 | 0.075811 | -0.016790 |
| Mean HV-AUC | 0.082020 | 0.070421 | -0.011599 |
| Mean best score | 0.227928 | 0.261728 | 0.033800 |
| Valid PPA | 257 | 245 | -12 |
| Front points | 30 | 23 | -7 |
| Unique PPA points | 87 | 75 | -12 |
| Reference-beating candidates | 46 | 39 | -7 |

T57 has one classic-covered valid-PPA loss: `Prob151_review2015_fsm`.
It also has two denominator-gated yield warnings. The best-score increase is
not enough to claim QD usefulness because the HV, HV-AUC, front breadth, and
coverage-preservation evidence is weaker.

## Rebinning Evidence

The adaptive mechanism is structurally present but did not actuate:

| Rebin metric | Value |
| --- | ---: |
| Rebin checks | 26 |
| Rebin events | 0 |
| Recent samples considered | 70 |
| Replay members tracked | 245 |

`scripts/validate_adaptive_rebinning_run.py` passed artifact parsing but
returned invalid because localized trigger evidence was inconclusive:
the selected collapsed/localized T51 off-mode case did not improve healthy or
occupied cells under T57.

## Family Comparison

| Comparison | HV | HV-AUC | Best | Valid PPA | Front | Unique | Ref-beating |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| T57 - classic | -0.016790 | -0.011599 | 0.033800 | -12 | -7 | -12 | -7 |
| T57 - T51 | -0.013441 | -0.015033 | -0.031752 | -21 | 2 | 0 | -4 |
| T57 - T56 | -0.006245 | 0.001326 | -0.006897 | 14 | 1 | 9 | 4 |

T57 is better than T56 on several breadth/yield counters, so adaptive
rebinning is less damaging than coarse SR2 geometry. It is still worse than
T51 on HV, HV-AUC, best score, valid-PPA volume, and reference-beating count.

## Visualizations

- Direct PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- Direct PPA screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`.
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Full viewer screenshot:
  `visualizations/qd_ppa_viewer/screenshot.png`.
- Strict non-Playwright validation passed:
  `visualizations/qd_ppa_viewer/validation.md`.
- Playwright caveat:
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.

The full viewer projects classic candidates into T57's archive space for
comparison and uses T57 as the archive source backend.

## Conclusion

T57 answers the archive-mechanics question negatively for this hard/tuning
surface. KS-triggered adaptive rebinning did not trigger under the
pre-registered thresholds, and the no-trigger outcome did not preserve T51's
front/HV evidence. Do not spend seed `1002` on exact T57.

The next attempt should not be another T51 archive-boundary tweak. Use a
stronger mechanism that changes candidate creation or archive semantics,
such as exact T11 runtime projection, a learned auxiliary archive lane, or a
front-yield protected emitter with explicit protection against
`Prob151_review2015_fsm`-style coverage loss.
