# PCN Method Configurations

All methods use `openai/gpt-oss-120b` through the local vLLM endpoint,
`temperature=1.0`, `top_p=1.0`, `max_tokens=128000`,
`diff_max_tokens=128000`, and `seed=1001`.

The default staged budget is:

```text
population_size = 8
num_generations = 5
```

The corrective smoke keeps `8x5` but lowers the memory-credit gate. The
long-budget diagnostic overrides this with `20x10` and `10x20`.

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

1. Generate the initial population with the standard REvolution prompt and
   classic success/failure strategy set.
2. Evaluate syntax, functionality, synthesis, and PPA.
3. Keep the classic success pool ordered by scalar quality.
4. For each generation, sample parents using the classic REvolution policy.
5. Generate one-parent refinements and evaluate them.
6. Update the success pool and fail pool exactly as classic REvolution.

No descriptor, archive, memory, or QD parent schedule is active.

Command:

```bash
bash commands/methods/classic_revolution_8x5.sh
```

## Method 2: `pcn_passive_archive_8x5`

Purpose: control for passive archive logging without memory recall.

Descriptor:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

Algorithm:

1. Run the same one-parent PPA-first operator as classic.
2. Maintain `PrimaryPool` separately from the archive.
3. Passively insert valid-PPA candidates into a grid-quantile archive.
4. Compute PCN cell credit, valid-PPA seen count, and front gaps.
5. Never sample from memory because memory fractions are all zero and
   `qd_memory_min_valid_ppa=9999`.

This arm asks whether passive archive accounting changes anything. It should
not improve search unless implementation accidentally leaks archive pressure.

Command:

```bash
bash commands/methods/pcn_passive_archive_8x5.sh
```

## Method 3: `pcn_rf_leafid_quality_memory_8x5`

Purpose: main PCN candidate.

Descriptor:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

Interpretation:

- `source_aligned_rf_timing_leaf_ids`: log-scale count of unique leaf IDs from
  the validated MasterRTL RF timing model path. This is a tree-model partition
  signal, not a scalar PPA prediction.
- `source_aligned_masterrtl_branching`: MasterRTL-style branching/control
  structure extracted from RTL source.
- `source_aligned_rtltimer_wire_density`: RTLTimer-style source density signal
  tied to wire/reference structure.

Algorithm:

1. Generate and evaluate candidates as classic REvolution.
2. Insert only valid-PPA candidates into the descriptor archive.
3. Keep `PrimaryPool` as the classic parent pool.
4. Before generation 2 or before 8 valid-PPA candidates, use only the classic
   lane.
5. After activation, reserve 10 percent of generation calls for
   `memory_refine`.
6. Sample only cells with credit at least 0.50.
7. Pick the cell champion unless a local front slot is available and selected
   by the existing memory sampler.
8. Use a PPA-first prompt; never expose descriptor coordinates as a target.
9. Update cell credit from the child outcome.

Command:

```bash
bash commands/methods/pcn_rf_leafid_quality_memory_8x5.sh
```

Corrective smoke variant:

```text
method = pcn_rf_leafid_quality_memory_credit025_8x5
stage = smoke_credit025
qd_memory_min_cell_credit = 0.25
```

This variant exists because the initial smoke produced zero memory-refine
calls at the 0.50 credit gate. It reuses the exact RF/MasterRTL/RTLTimer
descriptor and changes only the sampling eligibility threshold.

## Method 4: `pcn_random_quality_memory_8x5`

Purpose: negative control for "any memory archive helps".

Descriptor:

```text
random_hash_0
random_hash_1
random_hash_2
```

Algorithm:

The search policy is identical to `pcn_rf_leafid_quality_memory_8x5`, but the
cell identity comes from a deterministic hash of the canonical synthesized
netlist. It should not consistently beat the RF/MasterRTL/RTLTimer descriptor.
If it does, the result is evidence for generic memory pressure rather than
meaningful RTL-native diversity.

Command:

```bash
bash commands/methods/pcn_random_quality_memory_8x5.sh
```

Corrective smoke variant:

```text
method = pcn_random_quality_memory_credit025_8x5
stage = smoke_credit025
qd_memory_min_cell_credit = 0.25
```

This is the paired control for the RF-leaf corrective smoke. If random memory
matches or beats RF memory when both are allowed to sample, the descriptor is
not carrying the result.

## Method 5: `pcn_sr_quality_memory_8x5`

Purpose: synthesis-response descriptor candidate.

Descriptor:

```text
sr_pca_0
sr_pca_1
sr_pca_2
```

Descriptor file:

```text
tables/sr_raw_pca_descriptor.yaml
```

Algorithm:

The search policy is identical to `pcn_rf_leafid_quality_memory_8x5`, but the
cell identity comes from the frozen SR raw PCA artifact fitted in the
20260618 auto-BD research package. The descriptor uses final netlist statistics,
motif occupancy, and synthesis-trajectory signals projected into three PCA
axes. It does not fit on the staged PCN candidates.

Command:

```bash
bash commands/methods/pcn_sr_quality_memory_8x5.sh
```

## Long-Budget Diagnostic Arms

The long-budget arms reuse the same commands with method-name and budget
overrides:

```bash
bash commands/run_stage.sh long_20x10
bash commands/run_stage.sh long_10x20
```

These stages compare:

- `classic_revolution_20x10` vs `pcn_rf_leafid_quality_memory_20x10`
- `classic_revolution_10x20` vs `pcn_rf_leafid_quality_memory_10x20`

The long-budget diagnostic should be launched only after Stage 2 shows that
PCN RF is not clearly worse than classic.

## PCN Common CLI Flags

The executable PCN arms use:

```text
--search_mode revolution_qd
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 4
--qd_archive_activation_generation 2
--qd_fill_target_fraction 0.00
--qd_improve_backfill_fraction 0.00
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
--qd_objectives ppa
--qd_scheduler_mode pcn_quality_memory
--qd_parent_selection pcn_quality_memory
--qd_memory_classic_fraction 0.90
--qd_memory_refine_fraction 0.10
--qd_memory_rescue_fraction 0.00
--qd_memory_probe_fraction 0.00
--qd_memory_min_cell_credit 0.50
--qd_memory_front_gap_epsilon 0.03
--qd_memory_min_valid_ppa 8
--qd_memory_cooldown_attempts 3
--qd_memory_cooldown_generations 2
--qd_two_parent_probability 0.00
--qd_operator_kind single_thought_operator
--qd_operator_one_parent_fraction 1.0
--qd_operator_archive_context_size 4
--representation_kind code_individual
--repair_kind none
```

These flags are intentionally strict. Any run that changes memory fractions,
enables two-parent fusion, enables repair, or lets the archive replace the
classic primary pool is a different algorithm and must get a new method name.
For `smoke_credit025`, only `--qd_memory_min_cell_credit` changes, from `0.50`
to `0.25`, for the RF and random PCN arms.
