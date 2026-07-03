# T79 Methodology

## Purpose

T78 showed that T75's archive is still maturing under `12 x 3`. T79 turns that
diagnostic into a fair live test by holding the candidate budget fixed at `48`
and changing only the population-by-generation shape.

The decision question is not whether deeper runs are better in general. The
decision question is whether deeper runs help QD more than classic under the
same candidate budget and subset.

## Methods

| Method | Meaning |
| --- | --- |
| `classic_revolution` | Standard REvolution hill-climbing baseline. |
| `shape_density_front_pressure_qd` | T75 QD arm with source-aligned shape-density grid-quantile archive, one-parent front-slot pressure, no repair, and no two-parent fusion. |

## Budget Shapes

| Shape | Population | Generations | Candidate Budget |
| --- | ---: | ---: | ---: |
| `12x3` | `12` | `3` | `48` |
| `8x5` | `8` | `5` | `48` |
| `6x7` | `6` | `7` | `48` |

Candidate budget is `population_size * (num_generations + 1)`.

## Frozen Subset Rule

The subset is frozen before any T79 live outcome. It is selected from the
existing frozen/holdout candidate tables using:

- valid benchmark reference PPA available;
- at least `50` prior classic valid-PPA samples;
- visible prior PPA variance;
- nontrivial design structure across arithmetic, control, and memory/interface
  strata;
- no T78 empty-archive primary weak case.

Deferred candidates stay recorded in `tables/t79_deferred_candidates.csv`.
They may be used later only as a separately labeled stress slice.

## Headline Metrics

Headline T79 comparisons must use the paired reference-complete subset only:

- mean and paired hypervolume;
- HV-AUC where emitted;
- valid-PPA yield;
- Pareto point count;
- unique PPA point count;
- reference-beating count;
- archive coverage and QD score as secondary evidence;
- per-problem win/loss heatmap.

Average fitness and average best PPA are not primary evidence.

## Promotion Rule

T79 can only support the budget-shape hypothesis if a deeper QD shape improves
more than the matching deeper classic shape on HV/HV-AUC or front material
without losing classic-covered designs or hiding a validity collapse.
