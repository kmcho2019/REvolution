# T75 Results Report

Status: completed `T0 positive_diagnostic_not_promoted`.

## Headline Result

T75 ran on the 13-problem reference-complete hard/tuning subset with seed
`1001`, `population_size=12`, `num_generations=3`, the local
`openai/gpt-oss-120b` endpoint, and `128000` token budgets.

T75 preserves every classic-covered problem and raises total valid-PPA samples
above classic. It does not beat classic on the primary PPA-front evidence, so
it remains diagnostic.

## Headline Table

| Method | Mean HV | HV wins | Mean Pareto points | Valid-PPA samples | Covered problems | Tier |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| Classic | 0.0926007600 | 8 | 2.31 | 257 | 13/13 | reference |
| T73 | 0.0890223082 | 0 | 1.46 | 294 | 13/13 | context |
| T74 | 0.0851926237 | 1 | 1.62 | 237 | 13/13 | retired |
| T75 | 0.0899974770 | 1 | 1.62 | 274 | 13/13 | T0 diagnostic |

## Direct Pairwise Read

| Comparison | HV wins/losses/ties | Mean HV delta | Mean Pareto point delta | Mean ref-beating delta |
| --- | --- | ---: | ---: | ---: |
| T75 minus classic | 4/3/6 | -0.0026032830 | -0.6923076923 | -0.4615384615 |
| T75 minus T73 | 3/2/8 | +0.0009751689 | +0.1538461538 | -0.6153846154 |
| T75 minus T74 | 3/0/10 | +0.0048048533 | 0.0000000000 | -0.0769230769 |

## Completeness And Validity

- Reference PPA is valid for all 13 problems.
- Classic has at least one valid-PPA sample for every problem.
- T75 has at least one valid-PPA sample for every problem.
- Registered single-thought and Pareto validators passed.
- The full final-analysis bundle was interrupted in `design_space_analysis`
  while recovering source-aligned features, after `backend_comparison`,
  `hard_iteration_analysis`, `pareto_analysis`, `evolutionary_reports`, and
  `ppa_distribution` had been written.

The interruption does not affect the committed headline PPA/Pareto tables, but
it is recorded in
`matched_classic_comparison/tables/t75_final_analysis_caveat.json`.

## Interpretation

T75 is the strongest source-aligned shape-density front-pressure variant so far
on mean HV: it improves over T73 and T74. It also restores valid-PPA yield
relative to T74. The change did not solve the central blocker: classic still
has the best aggregate multi-objective read, higher Pareto point count, and
more reference-beating candidates.

The result supports the new strategy note: front pressure helps recover some
signal, but shallow `12 x 3` runs still favor the direct classic hill climber.
The next move should be the planned budget-shape ablation or a
verification-gated MasterRTL pretrained tree-embedding lane, not another small
front-slot fraction tweak.
