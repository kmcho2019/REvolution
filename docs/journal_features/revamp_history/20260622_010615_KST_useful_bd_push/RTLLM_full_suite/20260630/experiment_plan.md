# Corrected RTLLM Rerun Plan

## Objective

Rerun the representative RTLLM QD comparison without the 20260629 operator
confound. The central question is whether QD/MAP-Elites descriptors or PCN
memory remain weak after preserving classic REvolution's EoH
thought/code/feedback operators.

## Fixed Settings

- Benchmark: RTLLM.
- Seed: `1001`.
- Budget: `population_size=8`, `num_generations=5`.
- Model: `openai/gpt-oss-120b`.
- Endpoint: `http://20.0.0.103:8000/v1/models`.
- Context requirement: `--vllm_min_model_len 128000`.
- Tokens: `--max_tokens 128000`, `--diff_max_tokens 128000`.
- Evaluation mode: `strict_ablation`.
- Non-Qwen workers: `48` total, `12` active problems, `4` per problem.
- Qwen workers: `12` total, `6` active problems, `2` per problem.

## Stages

### Smoke

`RUN_STAGE=smoke` runs:

- `Prob019_sub_64bit`
- `Prob036_edge_detect`
- `Prob045_alu`

This stage verifies:

- every method script launches under the corrected flags;
- `operator_contract.csv` has `single_thought_count=0` for every method;
- QD candidates are generated through EoH strategy rows rather than the old
  single-thought path;
- at least one corrected QD/PCN arm is not obviously worse than classic.

### Full

`RUN_STAGE=full` runs all 50 RTLLM problems and reports headline metrics on
the 46 reference-complete designs. It should launch only after the smoke stage
passes the operator audit and does not show an immediate catastrophic collapse.

## Method Arms

1. `classic_revolution_8x5`
2. `qwen_canonical_rtl_pca3_eoh_8x5`
3. `masterrtl_rf_leafid_structural_eoh_8x5`
4. `deepgate_high_exploit_eoh_8x5`
5. `rf_deepgate_hybrid_eoh_8x5`
6. `aurora_raw_impl_compact_eoh_8x5`
7. `masterrtl_archive_activation_eoh_8x5`
8. `pcn_v3_rf_stagnation_memory_8x5`

## Primary Metrics

- Designs with at least one valid PPA candidate.
- Mean final PPA hypervolume.
- Mean generation-wise HV-AUC.
- Pareto point count.
- Reference-beating candidate count.
- Per-problem HV wins/losses/ties against classic.
- Operator contract status.

## Decision Rule

The 20260630 full run can support a real QD claim only if the operator audit
passes and a QD/PCN arm is competitive with classic on reference-complete mean
HV or HV-AUC. If all corrected arms still lose, the negative result is much
stronger than 20260629 because the known operator mismatch has been removed.
