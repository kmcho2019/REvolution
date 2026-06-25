# Qwen Live-Hook Smoke Commands

Run from `/workspace`.

## Isolated Env Preparation

The existing Qwen env had the model stack but not the project runtime deps.
Install the project into that env, then restore the `regex` version required by
`transformers`.

```bash
uv pip install \
  --python exp/diversity_check/encoder_envs/qwen3_probe/bin/python \
  -e .

uv pip install \
  --python exp/diversity_check/encoder_envs/qwen3_probe/bin/python \
  'regex>=2025.10.22'
```

## Real Descriptor Smoke

```bash
exp/diversity_check/encoder_envs/qwen3_probe/bin/python - <<'PY'
from revolution.qwen_descriptor_evaluator import QwenCanonicalRTLEmbeddingEvaluator

path = (
    "docs/journal_features/revamp_history/"
    "20260622_010615_KST_useful_bd_push/preliminary_planning/"
    "20260625_qwen_live_screen_probe/tables/qwen_projection_artifact_v0.json"
)
evaluator = QwenCanonicalRTLEmbeddingEvaluator(path)
values = evaluator.extract_metrics(
    "module Top(input a, output y); assign y = a; endmodule"
)
print(values)
PY
```

Observed output:

```text
{'qwen_pc0': -0.029284536649955974, 'qwen_pc1': 0.021249967183939775, 'qwen_pc2': 0.10700321583591776, 'qwen_pc3': 0.023276044849739885}
```

## Launch Smoke

The `Prob045_alu` `1x0` smoke checked launch compatibility but produced no
valid PPA candidate, so it did not exercise archive insertion.

The `Prob135_m2014_q6b` `2x0` smoke produced one valid-PPA candidate and one
archive member with Qwen descriptor values.

```bash
OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}" \
PYTHONPATH=src \
exp/diversity_check/encoder_envs/qwen3_probe/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob135_m2014_q6b \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 2 \
  --num_generations 0 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots 1 \
  --max_active_problems 1 \
  --max_workers_per_problem 1 \
  --seed 1001 \
  --no-backend_subdir \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 1 \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.0 \
  --qd_two_parent_gate none \
  --qd_operator_kind single_thought_operator \
  --qd_operator_one_parent_fraction 1.0 \
  --qd_operator_archive_context_size 4 \
  --qd_operator_fail_feedback_chars 0 \
  --representation_kind code_individual \
  --repair_kind none \
  --repair_max_attempts_per_sample 0 \
  --repair_max_attempts_per_thought 0 \
  --repair_evidence stage_scoped_logs \
  --qd_descriptor_profile qwen_canonical_rtl_pca3 \
  --qd_descriptor_file \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_qwen_live_screen_probe/qwen_descriptor_profile.yaml \
  --save_path \
  exp/useful_bd_push/qwen_live_hook_smoke_20260625_170100_UTC/qd_qwen_canonical_rtl_pca3_2x0_prob135/seed_1001
```
