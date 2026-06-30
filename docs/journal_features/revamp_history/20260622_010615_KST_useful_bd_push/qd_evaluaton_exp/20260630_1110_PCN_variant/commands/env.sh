#!/usr/bin/env bash
set -euo pipefail

DOC_ROOT=/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant
EXP_ROOT=/workspace/exp/useful_bd_push/pcn_variant_20260630_1110
RUN_ROOT="$EXP_ROOT/live"
LOG_ROOT="$DOC_ROOT/logs"
MODEL_NAME=openai/gpt-oss-120b
MODEL_DIR=openai_gpt-oss-120b
VLLM_HOST=20.0.0.103
VLLM_PORT=8000
SEED=1001
MAX_TOKENS=128000
DIFF_MAX_TOKENS=128000
export PYTHONPATH=/workspace/src
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"

PCN_STAGE="${PCN_STAGE:-screen}"
case "$PCN_STAGE" in
  smoke)
    BUDGET_POPULATION="${BUDGET_POPULATION:-8}"
    BUDGET_GENERATIONS="${BUDGET_GENERATIONS:-5}"
    SUBSET_CONFIG="$DOC_ROOT/tables/smoke_subset.yaml"
    MANIFEST_CSV="$DOC_ROOT/tables/smoke_subset.csv"
    PCN_PROBLEMS=(Prob019_sub_64bit Prob036_edge_detect Prob045_alu)
    ;;
  smoke_credit025)
    BUDGET_POPULATION="${BUDGET_POPULATION:-8}"
    BUDGET_GENERATIONS="${BUDGET_GENERATIONS:-5}"
    SUBSET_CONFIG="$DOC_ROOT/tables/smoke_subset.yaml"
    MANIFEST_CSV="$DOC_ROOT/tables/smoke_subset.csv"
    PCN_PROBLEMS=(Prob019_sub_64bit Prob036_edge_detect Prob045_alu)
    ;;
  screen)
    BUDGET_POPULATION="${BUDGET_POPULATION:-8}"
    BUDGET_GENERATIONS="${BUDGET_GENERATIONS:-5}"
    SUBSET_CONFIG="$DOC_ROOT/tables/screen_subset.yaml"
    MANIFEST_CSV="$DOC_ROOT/tables/screen_subset.csv"
    PCN_PROBLEMS=(
      Prob019_sub_64bit
      Prob036_edge_detect
      Prob045_alu
      Prob015_multi_pipe_8bit
      Prob041_traffic_light
      Prob043_RAM
      Prob049_signal_generator
      Prob024_fsm
    )
    ;;
  long_20x10)
    BUDGET_POPULATION="${BUDGET_POPULATION:-20}"
    BUDGET_GENERATIONS="${BUDGET_GENERATIONS:-10}"
    SUBSET_CONFIG="$DOC_ROOT/tables/long_budget_subset.yaml"
    MANIFEST_CSV="$DOC_ROOT/tables/long_budget_subset.csv"
    PCN_PROBLEMS=(Prob019_sub_64bit Prob036_edge_detect Prob045_alu Prob041_traffic_light)
    ;;
  long_10x20)
    BUDGET_POPULATION="${BUDGET_POPULATION:-10}"
    BUDGET_GENERATIONS="${BUDGET_GENERATIONS:-20}"
    SUBSET_CONFIG="$DOC_ROOT/tables/long_budget_subset.yaml"
    MANIFEST_CSV="$DOC_ROOT/tables/long_budget_subset.csv"
    PCN_PROBLEMS=(Prob019_sub_64bit Prob036_edge_detect Prob045_alu Prob041_traffic_light)
    ;;
  *)
    echo "unknown PCN_STAGE: $PCN_STAGE" >&2
    exit 1
    ;;
esac

COMMON_TOTAL_WORKER_SLOTS="${COMMON_TOTAL_WORKER_SLOTS:-48}"
COMMON_MAX_ACTIVE_PROBLEMS="${COMMON_MAX_ACTIVE_PROBLEMS:-12}"
COMMON_MAX_WORKERS_PER_PROBLEM="${COMMON_MAX_WORKERS_PER_PROBLEM:-4}"
PCN_MEMORY_MIN_CELL_CREDIT="${PCN_MEMORY_MIN_CELL_CREDIT:-0.50}"

SR_RAW_PCA_DESCRIPTOR_FILE="$DOC_ROOT/tables/sr_raw_pca_descriptor.yaml"

METHODS=(
  classic_revolution_8x5
  pcn_passive_archive_8x5
  pcn_rf_leafid_quality_memory_8x5
  pcn_random_quality_memory_8x5
  pcn_sr_quality_memory_8x5
)

LONG_20X10_METHODS=(
  classic_revolution_20x10
  pcn_rf_leafid_quality_memory_20x10
)

LONG_10X20_METHODS=(
  classic_revolution_10x20
  pcn_rf_leafid_quality_memory_10x20
)

SMOKE_CREDIT025_METHODS=(
  classic_revolution_credit025_8x5
  pcn_rf_leafid_quality_memory_credit025_8x5
  pcn_random_quality_memory_credit025_8x5
)

method_run_dir() {
  local method="$1"
  printf '%s/%s/%s/seed_%s/%s\n' "$RUN_ROOT" "$PCN_STAGE" "$method" "$SEED" "$MODEL_DIR"
}

method_save_path() {
  local method="$1"
  printf '%s/%s/%s/seed_%s\n' "$RUN_ROOT" "$PCN_STAGE" "$method" "$SEED"
}

method_script() {
  local method="$1"
  case "$method" in
    classic_revolution_20x10|classic_revolution_10x20)
      printf '%s/commands/methods/classic_revolution_8x5.sh\n' "$DOC_ROOT"
      ;;
    classic_revolution_credit025_8x5)
      printf '%s/commands/methods/classic_revolution_8x5.sh\n' "$DOC_ROOT"
      ;;
    pcn_rf_leafid_quality_memory_20x10|pcn_rf_leafid_quality_memory_10x20)
      printf '%s/commands/methods/pcn_rf_leafid_quality_memory_8x5.sh\n' "$DOC_ROOT"
      ;;
    pcn_rf_leafid_quality_memory_credit025_8x5)
      printf '%s/commands/methods/pcn_rf_leafid_quality_memory_8x5.sh\n' "$DOC_ROOT"
      ;;
    pcn_random_quality_memory_credit025_8x5)
      printf '%s/commands/methods/pcn_random_quality_memory_8x5.sh\n' "$DOC_ROOT"
      ;;
    *)
      printf '%s/commands/methods/%s.sh\n' "$DOC_ROOT" "$method"
      ;;
  esac
}

mkdir -p "$RUN_ROOT/$PCN_STAGE" "$LOG_ROOT"
