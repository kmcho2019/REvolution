# T87 Artifacts Manifest

## Planned Live Run

Run artifacts must stay under:

`exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/`

Expected backend root:

`exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/fg_qdm_shape_density_memory_12x3/seed_1001/openai_gpt-oss-120b`

## Planned Analysis

Technique-local analysis should be written under:

- `analysis/shape_density_pareto_analysis/`
- `analysis/shape_density_ppa_distribution/`

Copy or link the most useful reader-facing figures into:

- `figures/`
- `tables/`

## Required Checks

- vLLM preflight confirms `openai/gpt-oss-120b` and `max_model_len >= 128000`.
- all three smoke problems complete or the failure is recorded as a blocker;
- `scripts/report_pareto_analysis.py` runs on the matched smoke;
- `scripts/report_ppa_distribution.py` runs on the matched smoke;
- generated JSON summaries parse;
- generated text artifacts pass `git diff --check`.
