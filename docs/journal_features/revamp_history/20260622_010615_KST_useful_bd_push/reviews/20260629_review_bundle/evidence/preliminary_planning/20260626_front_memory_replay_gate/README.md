# Front-Memory Replay Gate

This package tests whether a front-guarded QD memory has useful material to
rescue before we spend more live vLLM budget.

The replay question is narrow:

> Would scalar top-k selection discard final Pareto-front candidates that a
> QD memory could have retained?

This is not a performance claim and does not promote any method. It is a
mechanism-selection gate for the next archive-coupling experiment.

## Inputs

- T96 candidate-level PPA table:
  `../20260626_rf_deepgate_hybrid_delayed_probe/analysis/ppa_distribution/data/ppa_candidates.csv`
- `top_k = 8`, matching the frozen `8x5` screen population size.

## Outputs

- `tables/front_memory_replay_by_problem.csv`
- `tables/front_memory_replay_by_backend.csv`
- `figures/front_retention_gap_by_backend.png`
- `results_report.md`
- `artifacts_manifest.md`

## Interpretation

If final Pareto candidates are usually already retained by scalar top-k
selection, then QD memory is unlikely to help without changing generation or
descriptor semantics. If scalar top-k discards many final Pareto candidates,
then the next mechanism should focus on retaining and refining those discarded
front families.
