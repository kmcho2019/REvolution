# Suite Variant Commands

All Wave A commands follow the P3 full RTLLM command shape:

- `--benchmarks RTLLM` with no explicit problem list.
- `--population_size 8 --num_generations 5`.
- `--evaluation_mode strict_ablation`.
- `--total_worker_slots 48 --max_active_problems 12
  --max_workers_per_problem 4`.
- `--max_tokens 128000 --diff_max_tokens 128000
  --vllm_min_model_len 128000`.
- `--search_mode revolution_qd`.
- `--representation_kind code_individual`.
- `--qd_operator_kind eoh_strategies`.
- `--eoh_success_operator_set classic`.
- `--no-backend_subdir`.

## S01 Capacity 7

Change only `--qd_max_elites_per_cell 7` and save under:

`exp/natural_qd_push/suite_variants_wave_a_<UTC>/live/capacity7/seed_<seed>`.

## S02 Warmup 16

Change only `--qd_grid_quantile_warmup_successes 16` and save under:

`exp/natural_qd_push/suite_variants_wave_a_<UTC>/live/warmup16/seed_<seed>`.

## S03 Elite Pareto Slot 2

Change:

```text
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
```

Save under:

`exp/natural_qd_push/suite_variants_wave_a_<UTC>/live/elite_pareto_slot_2/seed_<seed>`.

## S04/S05 Descriptor Completions

Continue the existing P3c roots:

- `exp/natural_qd_push/p3c_bd_sweep_20260704_093150_UTC/live/compact8d_cvt/seed_<seed>`
- `exp/natural_qd_push/p3c_bd_sweep_20260704_093150_UTC/live/trio_cvt/seed_<seed>`

Use the same descriptor/CVT flags recorded in
`../p3_full_rtllm/p3c_bd_sweep_registration.md`.

## Packaging

Use the P3 package chain per seed:

1. `scripts/report_pareto_analysis.py` over classic, V2, and variant.
2. `scripts/report_ppa_distribution.py`.
3. `scripts/report_hv_auc.py`.
4. `scripts/audit_operator_contract.py`.
5. `scripts/validate_natural_qd_run.py`.

Then update `results_log.md`, `variant_registry.csv`, and the campaign
README before any promotion decision.
