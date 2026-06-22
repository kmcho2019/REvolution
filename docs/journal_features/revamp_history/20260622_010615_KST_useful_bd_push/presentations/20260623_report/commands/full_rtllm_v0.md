# Full RTLLM V0 Commands

Do not run this until screening and adversarial pre-launch review select the
QD arm.

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/rtllm_milestone_full_${RUN_TS}"
mkdir -p "${RUN_ROOT}/preflight"
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"
```

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src

RTLLM_PROBLEMS=(
  Prob001_accu Prob002_adder_16bit Prob003_adder_32bit
  Prob004_adder_8bit Prob005_adder_bcd Prob006_adder_pipe_64bit
  Prob007_comparator_3bit Prob008_comparator_4bit Prob009_div_16bit
  Prob010_radix2_div Prob011_multi_16bit Prob012_multi_8bit
  Prob013_multi_booth_8bit Prob014_multi_pipe_4bit
  Prob015_multi_pipe_8bit Prob016_fixed_point_adder
  Prob017_fixed_point_substractor Prob018_float_multi Prob019_sub_64bit
  Prob020_JC_counter Prob021_counter_12 Prob022_ring_counter
  Prob023_up_down_counter Prob024_fsm Prob025_sequence_detector
  Prob026_asyn_fifo Prob027_LIFObuffer Prob028_LFSR
  Prob029_barrel_shifter Prob030_right_shifter Prob031_freq_div
  Prob032_freq_divbyeven Prob033_freq_divbyfrac Prob034_freq_divbyodd
  Prob035_calendar Prob036_edge_detect Prob037_parallel2serial
  Prob038_pulse_detect Prob039_serial2parallel Prob040_synchronizer
  Prob041_traffic_light Prob042_width_8to16 Prob043_RAM Prob044_ROM
  Prob045_alu Prob046_clkgenerator Prob047_instr_reg Prob048_pe
  Prob049_signal_generator Prob050_square_wave
)

COMMON_ARGS=(
  --backend revolution
  --benchmarks RTLLM
  --problems "${RTLLM_PROBLEMS[@]}"
  --api_backend vllm
  --vllm_host 20.0.0.103
  --vllm_port 8000
  --vllm_min_model_len 128000
  --model_name openai/gpt-oss-120b
  --max_tokens 128000
  --diff_max_tokens 128000
  --population_size 12
  --num_generations 3
  --evaluation_mode strict_ablation
  --temperature 1.0
  --top_p 1.0
  --total_worker_slots 50
  --max_active_problems 50
  --max_workers_per_problem 4
  --seed 1001
  --no-backend_subdir
)
```

Classic arm:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --save_path "${RUN_ROOT}/classic_revolution/seed_1001"
```

Selected QD arm, exact T26:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.00 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/sr_raw_conservative_exploit_qd/seed_1001"
```
