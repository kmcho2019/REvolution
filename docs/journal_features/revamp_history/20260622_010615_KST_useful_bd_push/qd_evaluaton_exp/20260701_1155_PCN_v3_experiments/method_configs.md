# Method Configurations

All core methods use:

- model: `openai/gpt-oss-120b`;
- budget: population `8`, generations `5`;
- token limits: `max_tokens=128000`, `diff_max_tokens=128000`;
- operators: EoH-style thought/code/feedback individual formulation;
- benchmark for main run: RTLLM, 50 problems;
- headline RTLLM subset: reference-complete designs only.

## `classic_revolution_8x5`

Classic REvolution conference-style baseline.

Key flags:

```bash
--search_mode revolution
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
```

The success pool may select `M-S`, `M-E`, `M-R`, `M-I`, and `C-F`.

## `classic_no_cf_8x5`

Operator ablation of classic REvolution.

Key flags:

```bash
--search_mode revolution
--classic_operator_kind eoh_strategies
--eoh_success_operator_set one_parent
```

The success pool may select `M-S`, `M-E`, `M-R`, and `M-I`. It cannot select
`C-F`. This isolates whether removing C-F alone explains PCN-v3's prior gain.

## `pcn_v3_no_cf_memory_8x5`

Explicit reproduction of the current PCN-v3 behavior.

Key flags:

```bash
--search_mode revolution_qd
--classic_operator_kind eoh_strategies
--eoh_success_operator_set one_parent
--qd_scheduler_mode pcn_classic_preserving_memory
--qd_parent_selection pcn_classic_preserving_memory
--qd_two_parent_probability 0.00
--qd_operator_kind eoh_strategies
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
```

This arm uses PCN memory but keeps the classic-preserving success lane
one-parent only. It tests the same operator condition as the prior PCN-v3 run.

## `pcn_v3_cf_restored_memory_8x5`

Clean PCN memory test.

Key flags:

```bash
--search_mode revolution_qd
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
--qd_scheduler_mode pcn_classic_preserving_memory
--qd_parent_selection pcn_classic_preserving_memory
--qd_two_parent_probability 0.00
--qd_operator_kind eoh_strategies
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
```

This restores classic success-pool `C-F` while keeping QD/archive two-parent
fusion disabled. Any gain over classic is therefore a cleaner PCN-memory
claim than the prior no-C-F PCN result.

## PCN Descriptor And Memory Settings

PCN-v3 uses RF/MasterRTL/RTLTimer source-aligned descriptor axes:

```bash
--qd_descriptor_axes \
  source_aligned_rf_timing_leaf_ids \
  source_aligned_masterrtl_branching \
  source_aligned_rtltimer_wire_density
```

Memory schedule:

```bash
--qd_memory_classic_fraction 0.90
--qd_memory_refine_fraction 0.10
--qd_memory_rescue_fraction 0.00
--qd_memory_probe_fraction 0.00
--qd_memory_min_cell_credit 0.25
--qd_memory_min_valid_ppa 8
--qd_memory_trigger stagnation
--qd_memory_target_front_size 2
```

This keeps classic REvolution as the dominant optimizer and uses QD memory as
a small, guarded recall lane.

## Elite-Cell Follow-Up Variants

These are not part of the first core claim.

- `pcn_v3_cf_restored_elite3_8x5`: same as C-F-restored PCN, but raises
  `qd_max_elites_per_cell` from `2` to `3`.
- `pcn_v3_cf_restored_pareto3_8x5`: uses `qd_cell_mode=pareto_front` and
  `qd_max_elites_per_cell=3` to reduce reliance on scalar cell champions.
