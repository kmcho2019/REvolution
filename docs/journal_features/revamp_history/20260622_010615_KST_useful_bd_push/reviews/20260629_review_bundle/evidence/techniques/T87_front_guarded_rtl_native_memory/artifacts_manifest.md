# T87 Artifacts Manifest

## Live Run

Run artifacts must stay under:

`exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/`

Backend root:

`exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/fg_qdm_shape_density_memory_12x3/seed_1001/openai_gpt-oss-120b`

The run completed `3/3` smoke problems in `690.97s`.

## Analysis

Technique-local analysis is under:

- `analysis/shape_density_pareto_analysis/`
- `analysis/shape_density_ppa_distribution/`

Reader-facing summaries are under:

- `figures/`
- `tables/`

## Required Checks

- vLLM preflight confirmed `openai/gpt-oss-120b` and `max_model_len >= 128000`.
- all three smoke problems completed;
- `scripts/report_pareto_analysis.py` ran on the matched smoke;
- `scripts/report_ppa_distribution.py` ran on the matched smoke;
- generated JSON summaries parse.
