# Run Commands

## Preflight

```bash
curl http://20.0.0.103:8000/v1/models
df -h /workspace
```

## Shared Root

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src
export RUN_ROOT=exp/useful_bd_push/prelim_rf_leafid_seed_robustness_20260626_UTC/live
mkdir -p "$RUN_ROOT"
```

## QD Seeds

Run once with `SEED=1002`, then once with `SEED=1003`.

```bash
env OPENAI_API_KEY="$OPENAI_API_KEY" PYTHONPATH="$PYTHONPATH" uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --problems Prob015_multi_pipe_8bit Prob024_fsm Prob041_traffic_light Prob045_alu Prob049_signal_generator Prob116_m2014_q3 Prob135_m2014_q6b Prob153_gshare \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 8 \
  --num_generations 5 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots 32 \
  --max_active_problems 8 \
  --max_workers_per_problem 4 \
  --seed "$SEED" \
  --no-backend_subdir \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 4 \
  --qd_fill_target_fraction 0.10 \
  --qd_improve_backfill_fraction 0.05 \
  --qd_archive_activation_generation 3 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.90 \
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
  --qd_descriptor_axes source_aligned_rf_timing_leaf_ids source_aligned_masterrtl_branching source_aligned_rtltimer_wire_density \
  --save_path "$RUN_ROOT/masterrtl_rf_leafid_structural_delayed_8x5/seed_$SEED"
```
