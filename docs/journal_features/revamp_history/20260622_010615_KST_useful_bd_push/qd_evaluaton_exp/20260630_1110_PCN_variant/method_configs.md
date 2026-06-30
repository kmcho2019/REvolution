# PCN Method Configurations

All methods use `openai/gpt-oss-120b` through the local vLLM endpoint,
`temperature=1.0`, `top_p=1.0`, `max_tokens=128000`,
`diff_max_tokens=128000`, and `seed=1001`.

The corrected smoke budget is:

```text
population_size = 8
num_generations = 5
stage = smoke_v2
```

The old `smoke` stage is diagnostic only. It used `pcn_quality_memory` with
`single_thought_operator` and did not fire the memory-refine lane. The active
PCN-v2 method is `pcn_classic_preserving_memory`.

## Common Evaluation Rules

Candidate PPA is method-local. If a candidate lacks valid PPA, it counts as an
invalid/non-PPA candidate for that method.

Reference PPA is problem-global. If the reference `ppa.txt` is missing, that
design is excluded from headline normalized comparisons and may appear only in
diagnostic tables.

All stage subsets in this package are reference-complete.

## Method 1: `classic_revolution_8x5`

Purpose: matched baseline.

Algorithm:

1. Generate the initial population with the standard REvolution prompt.
2. Evaluate syntax, functionality, synthesis, and PPA.
3. Maintain the classic success and fail pools.
4. Select EoH strategies from the classic strategy set:
   `M-F`, `M-S`, `M-E`, `M-R`, `M-I`, and `C-F`.
5. Sample parents with the classic score-weighted parent policy.
6. Generate, evaluate, reward the selected strategy, and update the pools.

No descriptor, archive, memory, or QD parent schedule is active.

Command:

```bash
bash commands/methods/classic_revolution_8x5.sh
```

## Method 2: `pcn_v2_rf_eoh_memory_8x5`

Purpose: main corrected PCN-v2 candidate.

Descriptor:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

Descriptor interpretation:

- `source_aligned_rf_timing_leaf_ids`: tree-leaf partition signal from the
  validated MasterRTL RF timing path. It is used as a representation of learned
  RTL/timing regions, not as a direct scalar PPA objective.
- `source_aligned_masterrtl_branching`: RTL source branching/control shape.
- `source_aligned_rtltimer_wire_density`: RTLTimer-style source density signal
  tied to wire/reference structure.

Algorithm:

1. Run the same classic EoH generation loop as `classic_revolution_8x5`.
2. Keep the classic success/fail pools as the authoritative parent pools.
3. Passively insert every evaluated valid-PPA candidate into a grid-quantile
   descriptor archive.
4. Give each archive cell an exponential moving credit score from valid-PPA,
   local-front, global-front, and cell-champion outcomes.
5. Keep memory inactive until generation at least 2 and at least 8 valid-PPA
   candidates have been observed for that problem.
6. After activation, if a cell has credit at least 0.25, force one
   `memory_refine` call in an 8-candidate generation.
7. Sample a memory parent from a credited cell, usually the cell champion.
8. Mutate the memory parent with one-parent classic EoH operators only:
   `M-S`, `M-E`, `M-R`, or `M-I`.
9. Do not expose descriptor coordinates to the LLM and do not target novelty.
10. Update memory-cell credit from the child outcome.

The only intended difference from classic is the one auxiliary memory parent
source after the evidence gate opens.

Command:

```bash
bash commands/methods/pcn_v2_rf_eoh_memory_8x5.sh
```

## Method 3: `pcn_v2_random_eoh_memory_8x5`

Purpose: control for "any memory archive helps".

Descriptor:

```text
random_hash_0
random_hash_1
random_hash_2
```

Algorithm:

The search policy is identical to `pcn_v2_rf_eoh_memory_8x5`, but the cell
identity comes from deterministic random-hash descriptor axes. If this arm
matches or beats RF memory, the result is evidence for generic memory pressure
rather than meaningful RTL-native diversity.

Command:

```bash
bash commands/methods/pcn_v2_random_eoh_memory_8x5.sh
```

## Method 4: `pcn_v2_passive_eoh_archive_8x5`

Purpose: passive archive control.

Descriptor:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

Algorithm:

This arm uses the corrected PCN-v2 EoH loop and passively logs the RF
descriptor archive, but never samples from memory:

```text
qd_memory_refine_fraction = 0.00
qd_memory_min_valid_ppa = 9999
```

It checks whether archive accounting alone changes the result. It should track
classic closely; any large difference is an implementation warning.

Command:

```bash
bash commands/methods/pcn_v2_passive_eoh_archive_8x5.sh
```

## Long-Budget Diagnostic Arms

Long-budget stages are blocked until `smoke_v2` passes the mechanism gates.
If they are launched, they compare:

- `classic_revolution_20x10` vs `pcn_v2_rf_eoh_memory_20x10`;
- `classic_revolution_10x20` vs `pcn_v2_rf_eoh_memory_10x20`.

The question is whether remembered implementation families mature with depth
more effectively than classic alone.

Commands:

```bash
bash commands/run_stage.sh long_20x10
bash commands/run_stage.sh long_10x20
```

## PCN-v2 Common CLI Flags

The executable PCN-v2 memory arms use:

```text
--search_mode revolution_qd
--classic_operator_kind eoh_strategies
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 4
--qd_archive_activation_generation 2
--qd_fill_target_fraction 0.00
--qd_improve_backfill_fraction 0.00
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
--qd_objectives ppa
--qd_scheduler_mode pcn_classic_preserving_memory
--qd_parent_selection pcn_classic_preserving_memory
--qd_memory_classic_fraction 0.90
--qd_memory_refine_fraction 0.10
--qd_memory_rescue_fraction 0.00
--qd_memory_probe_fraction 0.00
--qd_memory_min_cell_credit 0.25
--qd_memory_front_gap_epsilon 0.03
--qd_memory_min_valid_ppa 8
--qd_memory_cooldown_attempts 3
--qd_memory_cooldown_generations 2
--qd_two_parent_probability 0.00
--qd_operator_kind eoh_strategies
--representation_kind code_individual
--repair_kind none
```

These flags are intentionally strict. Any run that enables descriptor-targeted
operators, two-parent memory fusion, repair, empty-cell fill, or archive-driven
primary parent selection is a different algorithm and must get a new method
name.
