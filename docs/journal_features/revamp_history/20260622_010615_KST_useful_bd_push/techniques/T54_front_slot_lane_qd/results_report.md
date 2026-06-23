# T54 Front-Slot Lane QD Result Report

Status: `T0 diagnostic_not_promoted`.

## Question

T54 tested whether a fixed, role-separated parent lane for non-elite
local-front slots could recover the front-breadth loss seen in T51 through
T53 while keeping T51's direct-code yield and champion pressure.

## Method

T54 kept the T51 hard/tuning surface, seed, local vLLM model, token budgets,
SR-PCA descriptor profile, `single_thought_operator`, `elite_pareto_slot`
capacity `2`, sparse warmup `4`, champion lane `0.80`, no repair, and no
two-parent fusion. The only live-search change was
`qd_parent_selection=front_slot_lane_nsga2`.

That mode gives each archive parent request a fixed 10 percent chance to draw
from non-elite members retained by `elite_pareto_slot` cells. If no such slot
exists, it falls back to T51-style champion and global NSGA-II sampling.

## Primary Result

| Metric | Classic | T54 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.092601 | 0.075892 | -0.016709 |
| Mean HV-AUC | 0.082020 | 0.062753 | -0.019267 |
| Mean best score | 0.227928 | 0.263027 | 0.035099 |
| Valid PPA | 257 | 253 | -4 |
| PPA front points | 30 | 21 | -9 |
| Unique PPA points | 87 | 67 | -20 |
| Reference-beating candidates | 46 | 31 | -15 |

T54 preserved every classic-covered design at the design-level valid-PPA gate.
That means it did not fail by losing all usable candidates for any design that
classic covered.

The method still does not advance. It improves mean best score, but the claim
we need is QD/MAP-Elites effectiveness on broader PPA/front exploration. T54
lost HV, HV-AUC, front points, unique PPA breadth, and reference-beating
candidate count versus classic.

## Family Comparison

| Comparison | HV Delta | HV-AUC Delta | Best Delta | Valid PPA Delta | Front Delta |
| --- | ---: | ---: | ---: | ---: | ---: |
| T54 - classic | -0.016709 | -0.019267 | 0.035099 | -4 | -9 |
| T54 - T51 | -0.013360 | -0.022701 | -0.030453 | -13 | 0 |
| T54 - T52 | -0.007610 | 0.006961 | 0.020766 | -1 | -3 |
| T54 - T53 | -0.009901 | -0.008258 | -0.027408 | 14 | -1 |

T54 is not a useful continuation of T51. It ties T51 on aggregate front
points but loses T51 on HV, HV-AUC, best score, valid-PPA count, unique PPA
count, and reference-beating candidates.

## Validity And Operator Evidence

The validity gate has two warnings on `Prob015_multi_pipe_8bit`:
functionality drops from `13` to `6`, and valid PPA drops from `13` to `5`.
The design is still covered, so this is not a hard design-level failure under
the current PPA-first policy, but it is a visible yield warning.

The front-slot lane recorded `12` parent requests and `4` hits. This means
the implementation was active, but it rarely found non-elite local-front slot
parents. The result suggests that simply sampling the existing slot more often
does not create enough front material. The next attempt should change how
front slots are created or switch to a different descriptor/retention lane,
not keep nudging parent pressure.

## Visual Artifacts

- Direct PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- Direct PPA screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`.
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Phase 03.1 screenshot:
  `visualizations/qd_ppa_viewer/screenshot.png`.
- Phase 03.1 caveat:
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.

The direct PPA supplement renders correctly after the operator counter figure
was regenerated with shorter labels. The Phase 03.1 schema validator passes.
The optional Playwright smoke still reports compare-guide and archive-hover
hook failures, so the bundle is accepted with that caveat rather than claimed
as a fully clean Playwright pass.

## Conclusion

T54 answers a narrow question: explicit non-elite front-slot parent sampling
does not fix the hard/tuning front-breadth gap. It is a useful diagnostic
because it isolates the lane and records nonzero usage, but it is not a
candidate for seed `1002`, held-out RTLLM spend, or a useful-QD claim.

The immediate T51/T52/T53/T54 parent-lane lineage should stop. A credible
next step should either create better local front slots, return to the exact
T11 runtime projection line with a stronger descriptor change, or move to a
learned/auxiliary archive lane. Another scalar champion-lane or parent-lane
tweak is unlikely to address the measured failure.
