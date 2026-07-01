#!/usr/bin/env bash
set -euo pipefail

DOC_ROOT=/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260701_1155_PCN_v3_experiments
EXP_ROOT=/workspace/exp/useful_bd_push/pcn_v3_experiments_20260701
EXP_STAGE="${EXP_STAGE:-rtllm_smoke}"
RUN_ROOT="$EXP_ROOT/live/$EXP_STAGE"
LOG_ROOT="$DOC_ROOT/logs"
MODEL_NAME=openai/gpt-oss-120b
MODEL_DIR=openai_gpt-oss-120b
VLLM_HOST=20.0.0.103
VLLM_PORT=8000
BUDGET_POPULATION=8
BUDGET_GENERATIONS=5
MAX_TOKENS=128000
DIFF_MAX_TOKENS=128000
export PYTHONPATH=/workspace/src
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"

COMMON_TOTAL_WORKER_SLOTS="${COMMON_TOTAL_WORKER_SLOTS:-48}"
COMMON_MAX_ACTIVE_PROBLEMS="${COMMON_MAX_ACTIVE_PROBLEMS:-12}"
COMMON_MAX_WORKERS_PER_PROBLEM="${COMMON_MAX_WORKERS_PER_PROBLEM:-4}"
PCN_MEMORY_MIN_CELL_CREDIT=0.25

RTLLM_SMOKE_SUBSET="$DOC_ROOT/tables/rtllm_smoke_manifest.yaml"
RTLLM_REFERENCE_SUBSET="$DOC_ROOT/tables/rtllm_reference_complete_manifest.yaml"
VERILOGEVAL_HOLDOUT_SUBSET="$DOC_ROOT/tables/verilogeval_holdout_manifest.yaml"

RTLLM_SMOKE_PROBLEMS=(
  Prob019_sub_64bit
  Prob036_edge_detect
  Prob045_alu
)

RTLLM_PROBLEMS=(
  Prob001_accu
  Prob002_adder_16bit
  Prob003_adder_32bit
  Prob004_adder_8bit
  Prob005_adder_bcd
  Prob006_adder_pipe_64bit
  Prob007_comparator_3bit
  Prob008_comparator_4bit
  Prob009_div_16bit
  Prob010_radix2_div
  Prob011_multi_16bit
  Prob012_multi_8bit
  Prob013_multi_booth_8bit
  Prob014_multi_pipe_4bit
  Prob015_multi_pipe_8bit
  Prob016_fixed_point_adder
  Prob017_fixed_point_substractor
  Prob018_float_multi
  Prob019_sub_64bit
  Prob020_JC_counter
  Prob021_counter_12
  Prob022_ring_counter
  Prob023_up_down_counter
  Prob024_fsm
  Prob025_sequence_detector
  Prob026_asyn_fifo
  Prob027_LIFObuffer
  Prob028_LFSR
  Prob029_barrel_shifter
  Prob030_right_shifter
  Prob031_freq_div
  Prob032_freq_divbyeven
  Prob033_freq_divbyfrac
  Prob034_freq_divbyodd
  Prob035_calendar
  Prob036_edge_detect
  Prob037_parallel2serial
  Prob038_pulse_detect
  Prob039_serial2parallel
  Prob040_synchronizer
  Prob041_traffic_light
  Prob042_width_8to16
  Prob043_RAM
  Prob044_ROM
  Prob045_alu
  Prob046_clkgenerator
  Prob047_instr_reg
  Prob048_pe
  Prob049_signal_generator
  Prob050_square_wave
)

VERILOGEVAL_HOLDOUT_PROBLEMS=(
  Prob116_m2014_q3
  Prob135_m2014_q6b
  Prob153_gshare
)

REFERENCE_MISSING_ARGS=(
  --reference-missing-problem RTLLM:Prob006_adder_pipe_64bit
  --reference-missing-problem RTLLM:Prob013_multi_booth_8bit
  --reference-missing-problem RTLLM:Prob018_float_multi
  --reference-missing-problem RTLLM:Prob040_synchronizer
)

CORE_METHODS=(
  classic_revolution_8x5
  classic_no_cf_8x5
  pcn_v3_no_cf_memory_8x5
  pcn_v3_cf_restored_memory_8x5
)

ELITE_METHODS=(
  classic_revolution_8x5
  pcn_v3_cf_restored_memory_8x5
  pcn_v3_cf_restored_elite3_8x5
  pcn_v3_cf_restored_pareto3_8x5
)

VERILOGEVAL_METHODS=(
  classic_revolution_8x5
  classic_no_cf_8x5
  pcn_v3_cf_restored_memory_8x5
)

case "$EXP_STAGE" in
  rtllm_smoke)
    ACTIVE_BENCHMARK=RTLLM
    ACTIVE_SUBSET="$RTLLM_SMOKE_SUBSET"
    ACTIVE_PROBLEMS=("${RTLLM_SMOKE_PROBLEMS[@]}")
    ACTIVE_SEEDS=(1001)
    ACTIVE_METHODS=("${CORE_METHODS[@]}")
    ;;
  rtllm_full_5seed)
    ACTIVE_BENCHMARK=RTLLM
    ACTIVE_SUBSET="$RTLLM_REFERENCE_SUBSET"
    ACTIVE_PROBLEMS=("${RTLLM_PROBLEMS[@]}")
    ACTIVE_SEEDS=(1001 1002 1003 1004 1005)
    ACTIVE_METHODS=("${CORE_METHODS[@]}")
    ;;
  rtllm_elite)
    ACTIVE_BENCHMARK=RTLLM
    ACTIVE_SUBSET="$RTLLM_REFERENCE_SUBSET"
    ACTIVE_PROBLEMS=("${RTLLM_PROBLEMS[@]}")
    ACTIVE_SEEDS=(1001)
    ACTIVE_METHODS=("${ELITE_METHODS[@]}")
    ;;
  verilogeval_holdout)
    ACTIVE_BENCHMARK=VerilogEval-Spec-to-RTL
    ACTIVE_SUBSET="$VERILOGEVAL_HOLDOUT_SUBSET"
    ACTIVE_PROBLEMS=("${VERILOGEVAL_HOLDOUT_PROBLEMS[@]}")
    ACTIVE_SEEDS=(1001 1002 1003 1004 1005)
    ACTIVE_METHODS=("${VERILOGEVAL_METHODS[@]}")
    ;;
  *)
    echo "unknown EXP_STAGE: $EXP_STAGE" >&2
    exit 1
    ;;
esac

log_file() {
  local name="$1"
  printf '%s/%s.%s\n' "$LOG_ROOT" "$EXP_STAGE" "$name"
}

method_run_dir() {
  local method="$1"
  local seed="$2"
  printf '%s/%s/seed_%s/%s\n' "$RUN_ROOT" "$method" "$seed" "$MODEL_DIR"
}

method_save_path() {
  local method="$1"
  local seed="$2"
  printf '%s/%s/seed_%s\n' "$RUN_ROOT" "$method" "$seed"
}

method_script() {
  local method="$1"
  printf '%s/commands/methods/%s.sh\n' "$DOC_ROOT" "$method"
}

mkdir -p "$RUN_ROOT" "$LOG_ROOT"
