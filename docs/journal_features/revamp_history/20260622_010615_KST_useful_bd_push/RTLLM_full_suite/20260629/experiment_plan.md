# RTLLM Representative Full-Run Plan

## Objective

Run a bounded but broad RTLLM comparison that can answer whether the strongest
current QD/MAP-Elites variants are competitive with classic REvolution on PPA
front metrics.

The experiment is not allowed to promote a method using defaulted or missing
reference PPA. Headline results use the reference-complete paired subset only.

## Fixed Run Settings

- Benchmark: RTLLM prompt-file manifest, 50 problems.
- Headline subset: 46 RTLLM problems with valid reference `ppa.txt`.
- Seed: `1001`.
- Budget: `population_size=8`, `num_generations=5`.
- Model: `openai/gpt-oss-120b`.
- Endpoint: `http://20.0.0.103:8000/v1/models`.
- Context requirement: `--vllm_min_model_len 128000`.
- Tokens: `--max_tokens 128000`, `--diff_max_tokens 128000`.
- Evaluation mode: `strict_ablation`.
- Temperature/top-p: `1.0` / `1.0`.
- Non-Qwen worker budget: `total_worker_slots=48`,
  `max_active_problems=12`, `max_workers_per_problem=4`.
- Qwen worker budget: `total_worker_slots=12`,
  `max_active_problems=6`, `max_workers_per_problem=2`.

The worker split keeps non-embedding methods fast while avoiding many parallel
Qwen model loads from the separate encoder environment.

## Method Arms

1. `classic_revolution_8x5`
2. `qwen_canonical_rtl_pca3_8x5`
3. `masterrtl_rf_leafid_structural_delayed_8x5`
4. `deepgate_delayed_high_exploit_8x5`
5. `rf_deepgate_hybrid_delayed_8x5`
6. `aurora_raw_impl_compact_delayed_8x5`
7. `masterrtl_delayed_archive_activation_8x5`
8. `fg_qdm_rf_leafid_front_credit_8x5`

Each exact CLI lives under `commands/methods/`.

## Primary Metrics

- Designs with at least one valid PPA candidate.
- Mean global PPA hypervolume on the reference-complete paired subset.
- Mean HV-AUC from the Phase 03.1 timeline datasets.
- Pareto point count.
- Reference-beating candidate count.
- Valid-PPA count and yield warning status.
- Method wins/losses/ties against classic by per-problem HV.

Secondary QD diagnostics include passive archive coverage, QD score, archive
AUC, Pareto-cell count, and descriptor-spread metrics where projection exists.

## Reference Completeness Rule

For headline direct classic-vs-QD claims:

- Missing candidate PPA is invalid/non-PPA for that method.
- Missing reference PPA makes the design diagnostic-only.
- A method cannot claim a full RTLLM headline win from all-RTLLM aggregates if
  the reference-complete paired subset does not support it.

## Packaging Steps

After the method scripts finish, `commands/package_full_suite.sh` runs:

1. PPA distribution reports for all 50 RTLLM problems and the 46-problem
   reference-complete subset.
2. Pareto analysis on the reference-complete subset.
3. Completeness tables per QD method.
4. Phase 03.1 `qd_ppa_viewer/` exports per QD method when archive artifacts are
   available.
5. Common evaluation contract tables from viewer data.
6. Suite-level CSV summaries, Markdown report, and comparison figures.

Viewer export failure for one method is recorded in logs and does not erase the
raw run. The suite report distinguishes completed metrics from missing viewer
diagnostics.
