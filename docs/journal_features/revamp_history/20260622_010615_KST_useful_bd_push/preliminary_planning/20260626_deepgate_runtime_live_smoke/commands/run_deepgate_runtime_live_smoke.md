# T93 DeepGate Runtime Live Smoke Commands

All commands used the T92 descriptor file:

```text
docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tables/deepgate_descriptor_profiles.yaml
```

All commands used:

```text
--qd_descriptor_profile deepgate_pooled_pc3
--search_mode revolution_qd
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 1
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
--qd_objectives ppa
--qd_parent_selection nsga2_global_rank
--qd_two_parent_probability 0.0
--representation_kind code_individual
--repair_kind none
```

## Endpoint Preflight

The run command performed the vLLM preflight:

```text
endpoint=http://20.0.0.103:8000/v1/models
model=openai/gpt-oss-120b
max_model_len=131072
min_required=128000
```

## Attempts

### Attempt 1

```bash
RUN_ROOT=exp/useful_bd_push/deepgate_runtime_live_smoke_20260626_1115_UTC
PYTHONPATH=src uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob024_fsm \
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
  --save_path "$RUN_ROOT/qd_deepgate_pooled_pc3_2x0_prob024/seed_1001"
```

### Attempt 2

```bash
RUN_ROOT=exp/useful_bd_push/deepgate_runtime_live_smoke_20260626_1135_UTC
PYTHONPATH=src uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob041_traffic_light \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 4 \
  --num_generations 0 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots 1 \
  --max_active_problems 1 \
  --max_workers_per_problem 1 \
  --seed 1001 \
  --no-backend_subdir \
  --save_path "$RUN_ROOT/qd_deepgate_pooled_pc3_4x0_prob041/seed_1001"
```

### Attempt 3

```bash
RUN_ROOT=exp/useful_bd_push/deepgate_runtime_live_smoke_20260626_1145_UTC
PYTHONPATH=src uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob045_alu \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 4 \
  --num_generations 0 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots 1 \
  --max_active_problems 1 \
  --max_workers_per_problem 1 \
  --seed 1001 \
  --no-backend_subdir \
  --save_path "$RUN_ROOT/qd_deepgate_pooled_pc3_4x0_prob045/seed_1001"
```

### Attempt 4

```bash
RUN_ROOT=exp/useful_bd_push/deepgate_runtime_live_smoke_20260626_1155_UTC
PYTHONPATH=src uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob045_alu \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 4 \
  --num_generations 1 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots 1 \
  --max_active_problems 1 \
  --max_workers_per_problem 1 \
  --seed 1001 \
  --no-backend_subdir \
  --save_path "$RUN_ROOT/qd_deepgate_pooled_pc3_4x1_prob045/seed_1001"
```

For all attempts, add the common QD arguments listed above plus:

```bash
--qd_descriptor_profile deepgate_pooled_pc3 \
--qd_descriptor_file docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tables/deepgate_descriptor_profiles.yaml
```
