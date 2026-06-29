#!/usr/bin/env bash
set -euo pipefail

DOC_ROOT=/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260629
EXP_ROOT=/workspace/exp/useful_bd_push/rtllm_full_suite_20260629
RUN_ROOT="$EXP_ROOT/live"
LOG_ROOT="$DOC_ROOT/logs"
MODEL_NAME=openai/gpt-oss-120b
MODEL_DIR=openai_gpt-oss-120b
VLLM_HOST=20.0.0.103
VLLM_PORT=8000
SEED=1001
BUDGET_POPULATION=8
BUDGET_GENERATIONS=5
MAX_TOKENS=128000
DIFF_MAX_TOKENS=128000
export PYTHONPATH=/workspace/src
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
QWEN_PYTHON=/workspace/exp/diversity_check/encoder_envs/qwen3_probe/bin/python

COMMON_TOTAL_WORKER_SLOTS=48
COMMON_MAX_ACTIVE_PROBLEMS=12
COMMON_MAX_WORKERS_PER_PROBLEM=4
QWEN_TOTAL_WORKER_SLOTS=12
QWEN_MAX_ACTIVE_PROBLEMS=6
QWEN_MAX_WORKERS_PER_PROBLEM=2

FULL_SUBSET="$DOC_ROOT/tables/rtllm_full_manifest.yaml"
REFERENCE_SUBSET="$DOC_ROOT/tables/rtllm_reference_complete_manifest.yaml"
FULL_MANIFEST_CSV="$DOC_ROOT/tables/rtllm_full_manifest.csv"
REFERENCE_MANIFEST_CSV="$DOC_ROOT/tables/rtllm_reference_complete_manifest.csv"

QWEN_DESCRIPTOR_FILE=/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_qwen_live_screen_probe/qwen_descriptor_profile.yaml
DEEPGATE_DESCRIPTOR_FILE=/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tables/deepgate_descriptor_profiles.yaml
RF_DEEPGATE_DESCRIPTOR_FILE=/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/tables/rf_deepgate_hybrid_descriptor_profiles.yaml

METHODS=(
  classic_revolution_8x5
  qwen_canonical_rtl_pca3_8x5
  masterrtl_rf_leafid_structural_delayed_8x5
  deepgate_delayed_high_exploit_8x5
  rf_deepgate_hybrid_delayed_8x5
  aurora_raw_impl_compact_delayed_8x5
  masterrtl_delayed_archive_activation_8x5
  fg_qdm_rf_leafid_front_credit_8x5
)

QD_METHODS=(
  qwen_canonical_rtl_pca3_8x5
  masterrtl_rf_leafid_structural_delayed_8x5
  deepgate_delayed_high_exploit_8x5
  rf_deepgate_hybrid_delayed_8x5
  aurora_raw_impl_compact_delayed_8x5
  masterrtl_delayed_archive_activation_8x5
  fg_qdm_rf_leafid_front_credit_8x5
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

REFERENCE_MISSING_ARGS=(
  --reference-missing-problem RTLLM:Prob006_adder_pipe_64bit
  --reference-missing-problem RTLLM:Prob013_multi_booth_8bit
  --reference-missing-problem RTLLM:Prob018_float_multi
  --reference-missing-problem RTLLM:Prob040_synchronizer
)

method_run_dir() {
  local method="$1"
  printf '%s/%s/seed_%s/%s\n' "$RUN_ROOT" "$method" "$SEED" "$MODEL_DIR"
}

method_save_path() {
  local method="$1"
  printf '%s/%s/seed_%s\n' "$RUN_ROOT" "$method" "$SEED"
}

method_script() {
  local method="$1"
  printf '%s/commands/methods/%s.sh\n' "$DOC_ROOT" "$method"
}

mkdir -p "$RUN_ROOT" "$LOG_ROOT"
