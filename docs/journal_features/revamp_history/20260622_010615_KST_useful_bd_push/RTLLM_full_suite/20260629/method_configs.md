# Method Configurations And Methodology

This file is the prose reproduction contract for the 20260629 RTLLM full-suite
comparison. The executable source of truth remains `commands/methods/*.sh`, but
the sections below describe each method in enough detail that the run can be
recreated without reverse-engineering the scripts.

## Terminology

- **Candidate**: one generated Verilog/RTL implementation for one benchmark
  problem.
- **Functional candidate**: a candidate that passes the functional checks used
  by `strict_ablation`.
- **Valid-PPA candidate**: a candidate with usable area and power metrics after
  the evaluation flow. Missing candidate PPA is counted as invalid for the
  method.
- **PPA**: power, performance, and area. The reporting scripts use normalized
  maximize-form improvements over each problem reference.
- **HV**: hypervolume of the non-dominated PPA front in normalized objective
  space.
- **HV-AUC**: area under the generation-by-generation hypervolume curve.
- **BD**: behavior descriptor. This is the vector used to place a candidate in
  a QD archive. A valid BD must not include final PPA, reference PPA,
  hypervolume, Pareto rank, pass rate, or problem identity.
- **Archive cell**: one grid bucket in descriptor space.
- **Elite**: a candidate retained by an archive cell.
- **Reference-complete subset**: RTLLM designs whose reference `ppa.txt` is
  valid. Only these designs support headline normalized comparisons.
- **Diagnostic-only design**: a design excluded from headline aggregates
  because reference PPA is missing, while raw artifacts may still be inspected.

## Common Experimental Protocol

All arms share the same benchmark, model, seed, candidate budget, and evaluator.
The only intentional differences are the search policy and descriptor family.

### Benchmark And Reference Contract

1. Use all 50 RTLLM prompt-file problems from
   `tables/rtllm_full_manifest.csv`.
2. Run every method on all 50 problems.
3. For headline aggregate comparison, restrict to the 46 problems in
   `tables/rtllm_reference_complete_manifest.csv`.
4. Treat these four RTLLM problems as diagnostic-only because their reference
   PPA is missing or defaulted:
   - `Prob006_adder_pipe_64bit`
   - `Prob013_multi_booth_8bit`
   - `Prob018_float_multi`
   - `Prob040_synchronizer`
5. Count missing method/candidate PPA as invalid for that method. Do not drop a
   failed method/problem pair from the denominator when computing headline mean
   HV.

### Shared Runtime Settings

All method scripts use:

- `--backend revolution`
- `--benchmarks RTLLM`
- `--seed 1001`
- `--population_size 8`
- `--num_generations 5`
- `--api_backend vllm`
- `--vllm_host 20.0.0.103`
- `--vllm_port 8000`
- `--vllm_min_model_len 128000`
- `--model_name openai/gpt-oss-120b`
- `--max_tokens 128000`
- `--diff_max_tokens 128000`
- `--evaluation_mode strict_ablation`
- `--temperature 1.0`
- `--top_p 1.0`
- `--no-backend_subdir`

The candidate budget is therefore 48 generated candidates per problem:
8 initial candidates plus 5 generations of 8 candidates each.

Most arms use:

- `--total_worker_slots 48`
- `--max_active_problems 12`
- `--max_workers_per_problem 4`

The Qwen arm uses lower fanout:

- `--total_worker_slots 12`
- `--max_active_problems 6`
- `--max_workers_per_problem 2`

This prevents too many parallel Qwen embedding-model loads from the isolated
encoder environment.

### Candidate Evaluation

For each problem and method:

1. Generate candidate RTL from the shared REvolution prompt/operator stack.
2. Keep the module interface compatible with the benchmark prompt.
3. Evaluate under `strict_ablation`.
4. Record candidate status and timing in `generation_log.jsonl`.
5. Extract area and power when synthesis/PPA data is valid.
6. Compute normalized PPA improvements only when candidate and reference PPA
   are valid.

No arm in this suite uses bounded repair:

- `--repair_kind none`
- `--repair_max_attempts_per_sample 0`
- `--repair_max_attempts_per_thought 0`
- `--repair_evidence stage_scoped_logs`

### Common QD Archive Policy

All non-classic methods use `--search_mode revolution_qd`.

The standard QD arms use:

- `--qd_archive_type grid_quantile`
- `--qd_grid_quantile_warmup_successes 4`
- `--qd_archive_activation_generation 3`
- `--qd_fill_target_fraction 0.10`
- `--qd_improve_backfill_fraction 0.05`
- `--qd_cell_mode elite_pareto_slot`
- `--qd_max_elites_per_cell 2`
- `--qd_objectives ppa`
- `--qd_champion_lane_fraction 0.90`
- `--qd_parent_selection nsga2_global_rank`
- `--qd_two_parent_probability 0.0`
- `--qd_two_parent_gate none`
- `--qd_operator_kind single_thought_operator`
- `--qd_operator_one_parent_fraction 1.0`
- `--qd_operator_archive_context_size 4`
- `--qd_operator_fail_feedback_chars 0`
- `--representation_kind code_individual`

The intended mechanics are:

1. Buffer early valid candidates until the archive has enough warmup material.
2. Build a descriptor grid from the selected axes and configured bounds.
3. Delay archive-driven parent selection until generation 3 so the run first
   behaves like a classic optimizer long enough to find valid regions.
4. Retain at most two elites per archive cell.
5. Rank retained elites by PPA objectives, using local Pareto/front-slot logic
   rather than simple descriptor novelty alone.
6. Keep 90 percent champion-lane pressure so the archive influences search
   without replacing exploitation.
7. Disable two-parent fusion for this full suite because earlier evidence
   suggested broad crossover can hurt RTL validity.

The archive grid is not a reward. It is an auxiliary memory and parent source.
The final evaluation is always based on PPA front metrics, not archive coverage
alone.

### Common Reporting Pipeline

After all method scripts finish, `commands/package_full_suite.sh` runs:

1. `scripts/report_ppa_distribution.py` for all 50 RTLLM problems.
2. `scripts/report_ppa_distribution.py` again for the 46-problem
   reference-complete subset.
3. `scripts/report_pareto_analysis.py` on the reference-complete subset.
4. `scripts/report_ppa_completeness.py` per QD arm.
5. `scripts/export_qd_ppa_visualization.py` per QD arm when archive artifacts
   are available.
6. `scripts/validate_qd_ppa_visualization.py` for each exported viewer.
7. `scripts/report_common_evaluation_contract.py` for common HV-AUC and archive
   metrics.
8. `tools/summarize_full_suite.py` for cross-method tables and figures.

Headline claims must come from:

- `tables/full_suite_method_summary.csv`
- `tables/full_suite_problem_metrics.csv`
- `figures/*.png`
- `report.md`

## Method 1: `classic_revolution_8x5`

### Role

This is the required baseline. It measures the performance of the standard
REvolution small-budget hill climber under the same model, seed, benchmark, and
candidate budget as every QD method.

### Algorithm

For each RTLLM problem:

1. Generate the initial population of 8 RTL candidates.
2. Evaluate candidates under `strict_ablation`.
3. Insert successful candidates into the classic success pool.
4. For each of 5 generations:
   1. Select parents from the current success pool using the classic
      REvolution policy.
   2. Apply the classic one-parent LLM improvement operator.
   3. Evaluate the 8 new candidates.
   4. Update the success pool with the best successful candidates.
5. Emit generation logs and PPA artifacts under
   `classic_revolution_8x5/seed_1001/openai_gpt-oss-120b`.

### Descriptor And Archive

No descriptor or QD archive is used. The method is entirely PPA/score driven.

### Reproduction Command

Run:

```bash
bash commands/methods/classic_revolution_8x5.sh
```

The command uses `--search_mode revolution` and no QD flags.

## Method 2: `qwen_canonical_rtl_pca3_8x5`

### Role

This is the pretrained text/code embedding representative. It tests whether a
large pretrained embedding model over canonical RTL text can define useful QD
archive cells for RTL PPA evolution.

### Descriptor Construction

The descriptor profile is `qwen_canonical_rtl_pca3`.

Descriptor file:

```text
preliminary_planning/20260625_qwen_live_screen_probe/qwen_descriptor_profile.yaml
```

The YAML defines:

- projection artifact: `tables/qwen_projection_artifact_v0.json`
- axes: `qwen_pc0`, `qwen_pc1`, `qwen_pc2`
- bins per axis: 4
- bounds per axis: `[-1.0, 1.0]`

For every archive-eligible candidate:

1. Canonicalize the candidate RTL text using the repo Qwen descriptor hook.
2. Embed the canonical RTL with the Qwen3 encoder in the isolated environment:
   `/workspace/exp/diversity_check/encoder_envs/qwen3_probe/bin/python`.
3. Load the frozen projection artifact from the descriptor YAML.
4. Project the embedding into PCA coordinates.
5. Use the first three projected coordinates as the BD:
   `(qwen_pc0, qwen_pc1, qwen_pc2)`.
6. Clip/bin each axis according to the configured 4-bin `[-1, 1]` grid.

The descriptor uses source text only. It must not read final PPA, reference PPA,
pass rate, hypervolume, Pareto rank, or problem identity.

### Search Policy

This arm uses the common delayed/high-exploit QD policy:

- generation 0 to 2: archive data can be accumulated, but archive pressure is
  delayed;
- generation 3 onward: QD archive parent selection is enabled;
- champion lane is 0.90;
- fill and improve-backfill fractions are 0.10 and 0.05;
- two-parent fusion is disabled.

The LLM operator remains PPA-first. The prompt does not ask the model to chase
Qwen PCA coordinates directly.

### Reproduction Command

Run:

```bash
bash commands/methods/qwen_canonical_rtl_pca3_8x5.sh
```

The command intentionally uses the Qwen environment directly rather than
`uv run` from the main environment.

## Method 3: `masterrtl_rf_leafid_structural_delayed_8x5`

### Role

This is the MasterRTL model-state and source-aligned RTL-native descriptor
representative. It tests whether hardware-native structure and pretrained
model-state partitions define better QD cells than generic text embeddings.

### Descriptor Construction

This method passes descriptor axes directly:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

For every archive-eligible candidate:

1. Run the source-aligned RTL descriptor evaluator.
2. Convert candidate RTL into the MasterRTL-style source/operator graph used by
   the local verifier.
3. Extract MasterRTL structural counts.
4. Load the RF timing model-state path used by the source-aligned evaluator and
   compute timing leaf information.
5. Extract RTLTimer-style wire-density information.
6. Return the BD vector:
   - `source_aligned_rf_timing_leaf_ids`
   - `source_aligned_masterrtl_branching`
   - `source_aligned_rtltimer_wire_density`

Axis meanings:

- `source_aligned_rf_timing_leaf_ids`: log-transformed count of unique RF
  timing leaf IDs reached by the candidate. This is a model-state descriptor,
  not a direct PPA score.
- `source_aligned_masterrtl_branching`: MasterRTL-style branching/control
  structure, binned over `[0.0, 8.0]`.
- `source_aligned_rtltimer_wire_density`: RTLTimer-style wire density, binned
  over `[0.0, 1.0]`.

The RF leaf-ID axis is transformed with `log1p` before archive insertion. The
configured/default grid uses 4 bins for each axis in this full-suite command.

### Search Policy

This arm uses the common delayed/high-exploit QD policy. The archive becomes an
auxiliary memory over RTL-native structural families. It does not directly use
MasterRTL predicted area/power/timing as an optimization objective.

### Validity Caveat

The descriptor is a MasterRTL/RTLTimer-derived model-state and structural
feature lane. The full-suite report must not claim that this arm reproduces the
entire upstream MasterRTL predictor pipeline unless a separate verification
table shows model-input schema and prediction reproduction.

### Reproduction Command

Run:

```bash
bash commands/methods/masterrtl_rf_leafid_structural_delayed_8x5.sh
```

## Method 4: `deepgate_delayed_high_exploit_8x5`

### Role

This is the synthesized-netlist graph embedding representative. It tests
whether a DeepGate-style pooled graph embedding over candidate netlists can
define useful QD cells.

### Descriptor Construction

The descriptor profile is `deepgate_pooled_pc3`.

Descriptor file:

```text
preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tables/deepgate_descriptor_profiles.yaml
```

The YAML defines:

- projection artifact: `deepgate_pooled_projection.json`
- axes: `deepgate_pool_pc0`, `deepgate_pool_pc1`, `deepgate_pool_pc2`
- bins per axis: 4
- bounds per axis: `[-1.0, 1.0]`

For every archive-eligible candidate:

1. Obtain the synthesized or synthesis-derived netlist representation used by
   the DeepGate descriptor hook.
2. Convert the netlist into the graph representation required by the frozen
   DeepGate pooled projection artifact.
3. Compute or load the pooled DeepGate-style embedding.
4. Project the embedding into the frozen PC coordinate system.
5. Use `(deepgate_pool_pc0, deepgate_pool_pc1, deepgate_pool_pc2)` as the BD.
6. Bin each axis into the fixed 4-bin `[-1, 1]` grid.

The descriptor is netlist/graph based. It must not include final PPA,
reference PPA, pass rate, hypervolume, Pareto rank, or problem identity.

### Search Policy

This arm uses the common delayed/high-exploit QD policy. Delaying archive
activation is important because DeepGate descriptor extraction depends on
candidate artifacts that are only meaningful after the candidate survives
enough of the evaluation path.

### Validity Caveat

This arm should be described as the frozen DeepGate runtime descriptor profile.
Do not broaden the claim to "full DeepGate3 end-to-end reproduction" unless the
run package contains a separate upstream-checkpoint and output-reproduction
audit.

### Reproduction Command

Run:

```bash
bash commands/methods/deepgate_delayed_high_exploit_8x5.sh
```

## Method 5: `rf_deepgate_hybrid_delayed_8x5`

### Role

This is the hybrid learned-structure descriptor representative. It tests whether
combining source-aligned MasterRTL model-state with netlist graph embedding
captures implementation families that either source alone misses.

### Descriptor Construction

The descriptor profile is `rf_deepgate_hybrid_3d`.

Descriptor file:

```text
preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/tables/rf_deepgate_hybrid_descriptor_profiles.yaml
```

The YAML defines:

- DeepGate projection artifact:
  `../../20260626_deepgate_runtime_descriptor_gate/tables/deepgate_pooled_projection.json`
- axes:
  - `source_aligned_rf_timing_leaf_ids`
  - `source_aligned_masterrtl_branching`
  - `deepgate_pool_pc0`
- bins per axis: 4
- bounds:
  - `source_aligned_rf_timing_leaf_ids`: `[0.0, 5.0]`
  - `source_aligned_masterrtl_branching`: `[0.0, 8.0]`
  - `deepgate_pool_pc0`: `[-1.0, 1.0]`

For every archive-eligible candidate:

1. Run the source-aligned MasterRTL/RTLTimer descriptor evaluator.
2. Extract RF timing leaf-ID count and MasterRTL branching.
3. Run the DeepGate pooled embedding/projection hook.
4. Keep only `deepgate_pool_pc0` from the DeepGate projection.
5. Build the 3D BD:
   `(source_aligned_rf_timing_leaf_ids,
   source_aligned_masterrtl_branching,
   deepgate_pool_pc0)`.
6. Insert the candidate into the grid archive using the configured bounds.

### Search Policy

This arm uses the common delayed/high-exploit QD policy. The hypothesis is that
the first two axes preserve source/control/timing families while the DeepGate
axis separates synthesized graph families within those source-level groups.

### Reproduction Command

Run:

```bash
bash commands/methods/rf_deepgate_hybrid_delayed_8x5.sh
```

## Method 6: `aurora_raw_impl_compact_delayed_8x5`

### Role

This is the AURORA-style learned/automatic descriptor representative. It is not
claimed to be a pretrained encoder. It represents compact implementation-level
features that can be used like an automatic BD.

### Descriptor Construction

The descriptor profile is `implemented_structural_compact_3d` from
`data/configs/qd_descriptor_profiles.yaml`.

Axes:

- `comb_ratio`
- `adder_ratio`
- `cell_count_log`

Configured grid specs:

- `comb_ratio`: 2 bins, `[0.7081081081081081, 1.0]`
- `adder_ratio`: 2 bins, `[0.0, 0.11588330632090761]`
- `cell_count_log`: 2 bins, `[5.1152555343856845, 7.605890001053122]`

For every archive-eligible candidate:

1. Evaluate the candidate far enough to obtain implementation-level structural
   statistics.
2. Compute the fraction of combinational cells.
3. Compute the fraction of adder/arithmetic cells.
4. Compute the log-scaled cell-count descriptor.
5. Use `(comb_ratio, adder_ratio, cell_count_log)` as the BD.

### Search Policy

This arm uses the common delayed/high-exploit QD policy. It asks whether a very
compact implementation-feature descriptor can preserve useful implementation
families without an external pretrained encoder.

### Reproduction Command

Run:

```bash
bash commands/methods/aurora_raw_impl_compact_delayed_8x5.sh
```

## Method 7: `masterrtl_delayed_archive_activation_8x5`

### Role

This is the custom RTL-native QD representative. It uses interpretable
MasterRTL structural ratios rather than pretrained text or graph embeddings.

### Descriptor Construction

The descriptor profile is `source_aligned_masterrtl_structural_mix_3d` from
`data/configs/qd_descriptor_profiles.yaml`.

Axes:

- `source_aligned_masterrtl_seq_fraction`
- `source_aligned_masterrtl_mux_fraction`
- `source_aligned_masterrtl_xor_fraction`

Default bounds for all three axes are `[0.0, 1.0]`. The profile uses the
source-aligned MasterRTL extractor:

1. Parse candidate RTL into the MasterRTL-style source/operator graph.
2. Count register/sequential bits and operator nodes.
3. Count mux-like operators.
4. Count XOR operators.
5. Normalize by the relevant node/operator count to produce fractions.
6. Use the three fractions as the BD.

### Search Policy

This arm uses the common delayed/high-exploit QD policy. The descriptor is meant
to preserve RTL implementation families that differ in statefulness, mux/control
structure, and XOR/logic style while still keeping PPA-first exploitation.

### Reproduction Command

Run:

```bash
bash commands/methods/masterrtl_delayed_archive_activation_8x5.sh
```

## Method 8: `fg_qdm_rf_leafid_front_credit_8x5`

### Role

This is the front-guarded QD-memory algorithmic representative. It is designed
to test the hypothesis that QD should act as selective memory for
PPA-competitive RTL families rather than as a fill-driven MAP-Elites optimizer.

The earlier T100 evidence used a 12x3 smoke. This full suite adapts the method
to the shared 8x5 budget so the comparison remains equal-budget.

### Descriptor Construction

This method uses the same RTL-native/model-state axes as
`masterrtl_rf_leafid_structural_delayed_8x5`:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

Candidate descriptor extraction follows the same source-aligned
MasterRTL/RTLTimer/RF leaf-ID procedure described in Method 3.

### Search Policy

This arm is intentionally different from the standard delayed/high-exploit QD
arms.

It uses:

- `--qd_scheduler_mode front_guarded_memory`
- `--qd_parent_selection front_guarded_memory`
- `--qd_fill_target_fraction 0.00`
- `--qd_improve_backfill_fraction 0.00`
- `--qd_memory_classic_fraction 0.85`
- `--qd_memory_refine_fraction 0.10`
- `--qd_memory_rescue_fraction 0.05`
- `--qd_memory_probe_fraction 0.00`
- `--qd_memory_min_cell_credit 0.50`
- `--qd_memory_front_gap_epsilon 0.03`
- `--qd_memory_cooldown_attempts 3`
- `--qd_memory_cooldown_generations 2`
- `--qd_champion_lane_fraction 0.00`
- `--qd_two_parent_probability 0.00`

For each problem:

1. Maintain a primary success pool that follows classic REvolution-style
   exploitation.
2. Maintain a descriptor-indexed QD memory archive in parallel.
3. Insert valid-PPA candidates passively into the memory archive.
4. Do not spend LLM calls just to fill empty descriptor cells.
5. Assign archive-cell credit when a cell contains near-front or useful PPA
   material.
6. Allocate about 85 percent of generation calls to the classic lane.
7. Allocate about 10 percent of calls to memory refinement from credited cells.
8. Allocate about 5 percent of calls to front rescue from locally relevant
   archive material.
9. Cool down archive cells that fail to produce valid/useful offspring.
10. Disable probe and two-parent fusion lanes in this first full-suite version.

The intended mechanism is:

```text
classic optimizer finds valid regions
QD memory remembers PPA-competitive alternative RTL families
guarded recall refines only cells with evidence of usefulness
PPA front metrics decide whether the memory helped
```

This is not a conventional archive-filling MAP-Elites run. It is closer to
classic REvolution with an auxiliary, descriptor-indexed memory.

### Reproduction Command

Run:

```bash
bash commands/methods/fg_qdm_rf_leafid_front_credit_8x5.sh
```

## Cross-Method Reproduction Checklist

To recreate the full suite:

1. Confirm the vLLM endpoint lists `openai/gpt-oss-120b` with
   `max_model_len >= 128000`.
2. Confirm the Qwen environment exists at
   `/workspace/exp/diversity_check/encoder_envs/qwen3_probe/bin/python`.
3. Run each script in `commands/methods/` from `/workspace`.
4. Preserve the save-root layout:
   `/workspace/exp/useful_bd_push/rtllm_full_suite_20260629/live/<method>/seed_1001`.
5. Run `commands/package_full_suite.sh`.
6. Use reference-complete outputs only for headline claims.
7. Inspect generated figures before using them in presentation material.

## Interpretation Guardrails

- Do not promote a method using all-RTLLM aggregates that include missing
  reference PPA.
- Do not claim QD success from archive occupancy alone.
- Do not claim pretrained encoder superiority unless the method beats or
  closely matches classic on reference-complete HV/HV-AUC and preserves
  classic-covered designs.
- Do not claim full upstream MasterRTL, RTLTimer, or DeepGate reproduction from
  these method names alone. The documented claim is that these are frozen
  descriptor lanes using validated repo hooks and artifacts.
- If a method has no valid-PPA candidate on a reference-complete problem, that
  problem must remain in the denominator for suite-level coverage and mean-HV
  summaries.
