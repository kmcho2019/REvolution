# Reproduce FG-QDM Contribution Audit

The audit is assembled from existing committed technique tables. No additional
vLLM run is required.

## Source Tables

- `techniques/T85_front_guarded_qd_memory/tables/warmup4_backend_problem_metrics.csv`
- `techniques/T86_front_guarded_memory_controls/tables/random_memory_mechanism_summary.csv`
- `techniques/T86_front_guarded_memory_controls/tables/random_memory_backend_problem_metrics.csv`
- `techniques/T87_front_guarded_rtl_native_memory/tables/shape_density_mechanism_summary.csv`
- `techniques/T87_front_guarded_rtl_native_memory/tables/shape_density_backend_problem_metrics.csv`

## T97 Smoke Command Delta

Start from:

`techniques/T85_front_guarded_qd_memory/commands/run_t85_front_guarded_qd_memory.md`

Change only these settings for the first T97 smoke:

```bash
--qd_memory_classic_fraction 0.85 \
--qd_memory_refine_fraction 0.10 \
--qd_memory_rescue_fraction 0.05 \
--qd_memory_min_cell_credit 0.50 \
--save_path exp/useful_bd_push/front_credit_fg_qdm_20260626/fg_qdm_sr_front_credit_12x3/seed_1001
```

Keep the same model, seed, problems, evaluator, descriptor profile, and
worker settings as T85.
