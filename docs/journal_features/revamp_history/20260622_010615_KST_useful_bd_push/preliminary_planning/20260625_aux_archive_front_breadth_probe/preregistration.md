# Preregistration

## Rationale

The completed `masterrtl_aux_archive_high_exploit_8x5` probe is the best
screened QD arm by mean HV (`0.1339` versus classic `0.1406`), but it fails the
full-spend gate because it loses front breadth and reference-beating count:

| Metric | Classic | High-exploit auxiliary archive |
| --- | ---: | ---: |
| Mean HV | 0.1406 | 0.1339 |
| Mean Pareto points | 3.25 | 1.75 |
| Mean reference-beating candidates | 8.00 | 4.00 |

This follow-up tests whether a bounded front-slot lane can restore local-front
material while keeping the auxiliary archive setup close to classic-like
exploitation.

## Arm Definition

Run name: `masterrtl_aux_archive_front_breadth_8x5`

Settings relative to `masterrtl_aux_archive_high_exploit_8x5`:

| Setting | High-exploit | Front-breadth follow-up | Reason |
| --- | ---: | ---: | --- |
| champion lane | `0.90` | `0.80` | Reduce single-champion collapse. |
| parent selection | `nsga2_global_rank` | `front_slot_lane_nsga2` | Reintroduce local non-elite front material. |
| front-slot fraction | unused | `0.20` | Explicitly sample per-cell front slots. |
| improve backfill | `0.05` | `0.10` | Preserve a small archive exploration channel. |
| fill target | `0.10` | `0.10` | Keep low forced-fill tax. |
| descriptor profile | same | same | Do not change BD geometry in this probe. |

This remains a QD archive run, not a classic fallback: descriptor-indexed
archive cells, archive summaries, descriptor health, and QD metrics must exist
for all eight problems.

## Frozen Screen

Use the same screen as
`preliminary_planning/20260625_encoder_config_screening/screening_plan.md`:

- seed `1001`;
- `population_size=8`, `num_generations=5`;
- `openai/gpt-oss-120b` through the local vLLM endpoint;
- `max_tokens=128000`, `diff_max_tokens=128000`;
- the eight reference-complete screening problems.

## Promotion Read

The arm can become a full-RTLLM candidate only if it:

1. covers every classic-covered screening problem;
2. is within about `1-2%` of classic or beats classic on mean HV;
3. improves Pareto breadth or reference-beating count versus
   `masterrtl_aux_archive_high_exploit_8x5`;
4. does not introduce a severe valid-PPA or synthesis-yield collapse;
5. emits all QD archive artifacts.

If it improves front breadth but loses most of the high-exploit HV gain, it is
a useful ablation but not a promotion candidate. If it preserves mean HV and
improves front breadth, it becomes the strongest candidate for a larger
comparison.

## Command Shape

```bash
env OPENAI_API_KEY=vllm-local-placeholder PYTHONPATH=src uv run python scripts/run_backend.py \
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
  --seed 1001 \
  --no-backend_subdir \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 4 \
  --qd_fill_target_fraction 0.10 \
  --qd_improve_backfill_fraction 0.10 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection front_slot_lane_nsga2 \
  --qd_front_slot_lane_fraction 0.20 \
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
  --qd_descriptor_profile source_aligned_masterrtl_structural_mix_3d \
  --save_path exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/masterrtl_aux_archive_front_breadth_8x5/seed_1001
```
