# T97 Artifacts Manifest

## Live Run

`exp/useful_bd_push/front_credit_fg_qdm_20260626/fg_qdm_sr_front_credit_12x3/seed_1001/openai_gpt-oss-120b`

Runtime: `685.64s`.

Preflight:

`exp/useful_bd_push/front_credit_fg_qdm_20260626/preflight/models.json`

Model: `openai/gpt-oss-120b`, `max_model_len=131072`.

## Packaged Reports

- `analysis/pareto_analysis/`
- `analysis/ppa_distribution/`
- `tables/t97_backend_metrics.csv`
- `tables/t97_mechanism_summary.csv`

## Validation

- `validate_pareto_front_run.py`: passed.
- `validate_single_thought_operator_run.py`: passed.
- `report_pareto_analysis.py`: completed.
- `report_ppa_distribution.py`: completed.
