# Corrected Method Configurations

This suite reruns the representative RTLLM comparison after the PCN analysis
identified an operator confound in the 20260629 package. The old QD arms used
`single_thought_operator` while classic used REvolution's EoH strategy stack.
That made the run a mixed operator comparison rather than a clean QD-vs-classic
comparison.

## Shared Contract

All corrected methods use:

- benchmark: RTLLM;
- seed: `1001`;
- budget: `population_size=8`, `num_generations=5`;
- model: `openai/gpt-oss-120b`;
- token limits: `--max_tokens 128000`, `--diff_max_tokens 128000`;
- evaluation mode: `strict_ablation`;
- representation: `code_individual`;
- repair: `none`.

Classic uses:

```text
--search_mode revolution
```

Every standard QD arm uses:

```text
--search_mode revolution_qd
--qd_operator_kind eoh_strategies
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 4
--qd_archive_activation_generation 3
--qd_fill_target_fraction 0.10
--qd_improve_backfill_fraction 0.05
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
--qd_objectives ppa
--qd_champion_lane_fraction 0.90
--qd_parent_selection nsga2_global_rank
--qd_two_parent_probability 0.0
--qd_two_parent_gate none
```

The PCN memory arm uses:

```text
--qd_scheduler_mode pcn_classic_preserving_memory
--qd_parent_selection pcn_classic_preserving_memory
--qd_operator_kind eoh_strategies
--qd_memory_classic_fraction 0.90
--qd_memory_refine_fraction 0.10
--qd_memory_trigger stagnation
--qd_memory_target_front_size 2
```

The operator audit in `tools/audit_operator_contract.py` must show
`single_thought_count=0` for every method before any result is treated as a
corrected comparison.

## Stage Layout

`RUN_STAGE=smoke` runs three reference-complete designs:

- `Prob019_sub_64bit`
- `Prob036_edge_detect`
- `Prob045_alu`

`RUN_STAGE=full` runs all 50 RTLLM problems and reports headline results on
the 46 reference-complete designs. The missing-reference designs remain
diagnostic-only:

- `Prob006_adder_pipe_64bit`
- `Prob013_multi_booth_8bit`
- `Prob018_float_multi`
- `Prob040_synchronizer`

## Method Arms

### `classic_revolution_8x5`

Baseline REvolution with the classic EoH strategy stack. This is the direct
optimizer that QD variants must match or beat.

Command:

```bash
bash commands/methods/classic_revolution_8x5.sh
```

### `qwen_canonical_rtl_pca3_eoh_8x5`

Pretrained text/code encoder arm. Each candidate's RTL is canonicalized and
embedded by the Qwen3 environment, then projected to the frozen PCA3 profile
`qwen_canonical_rtl_pca3`. The archive cells are descriptor cells only; PPA is
used for quality ranking, not as a descriptor.

Command:

```bash
bash commands/methods/qwen_canonical_rtl_pca3_eoh_8x5.sh
```

The completed full add-on used:

```bash
RUN_STAGE=full \
QWEN_CUDA_VISIBLE_DEVICES=0 \
QWEN_TOTAL_WORKER_SLOTS=2 \
QWEN_MAX_ACTIVE_PROBLEMS=2 \
QWEN_MAX_WORKERS_PER_PROBLEM=1 \
bash commands/launch_qwen_gpu0_addon_tmux.sh
```

This low-fanout GPU-0 launch avoids the earlier multi-worker CUDA OOM while
preserving the same seed, budget, model, evaluator, and EoH operator contract.

### `masterrtl_rf_leafid_structural_eoh_8x5`

MasterRTL/RTLTimer-inspired model-state descriptor arm. The descriptor axes
are:

- `source_aligned_rf_timing_leaf_ids`;
- `source_aligned_masterrtl_branching`;
- `source_aligned_rtltimer_wire_density`.

This is the strongest hardware-native model-state lane from the previous
planning work. It should be described as source-aligned and model-state based,
not as a full upstream MasterRTL predictor reproduction.

### `deepgate_high_exploit_eoh_8x5`

Synthesized-netlist graph encoder lane using the frozen `deepgate_pooled_pc3`
descriptor profile. It tests whether DeepGate-style graph structure can define
useful archive cells when the generation operator is no longer weakened.

### `rf_deepgate_hybrid_eoh_8x5`

Hybrid learned-structure lane using `rf_deepgate_hybrid_3d`. It combines
MasterRTL/RF source-aligned state with DeepGate projected graph information.
This was the best 20260629 QD arm under the invalid single-thought operator,
so it is the highest-priority encoder rerun.

### `aurora_raw_impl_compact_eoh_8x5`

AURORA-style learned descriptor lane using compact implementation-level
features. This is not a pretrained encoder claim. It is included to represent
learned descriptor compression without relying on a specific external graph
checkpoint.

### `masterrtl_archive_activation_eoh_8x5`

Custom RTL-native delayed archive arm using
`source_aligned_masterrtl_structural_mix_3d`. It tests whether interpretable
MasterRTL-style structure helps as a BD under classic EoH generation.

### `pcn_v3_rf_stagnation_memory_8x5`

Corrected PCN memory arm. It keeps classic REvolution's primary EoH optimizer
dominant and spends at most one memory-refine call per generation after the
evidence and stagnation gates open. This is the direct follow-up to the PCN
smoke result where RF memory beat random and passive controls but still
trailed classic.

## Promotion Rule

The smoke stage may advance to full RTLLM only if:

- every method completes or any failures are clearly dependency-only;
- `operator_contract.csv` has no `single_thought_operator` use;
- at least one corrected QD/PCN arm is close to classic on mean HV or HV-AUC;
- no corrected QD/PCN arm loses classic-covered smoke designs in a way that
  makes full RTLLM clearly uninformative.
