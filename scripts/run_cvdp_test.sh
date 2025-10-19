#!/bin/bash
set -e # Exit immediately if a command fails

# vllm docker configuration
# docker run --runtime nvidia --rm --gpus all --network host -v /path/to/model/Qwen3-Coder-30B-A3B-Instruct:/root/.cache/huggingface/models/Qwen3-Coder-30B-A3B-Instruct --ipc=host vllm/vllm-openai:latest --model /root/.cache/huggingface/models/Qwen3-Coder-30B-A3B-Instruct --tensor-parallel-size 8 --host 0.0.0.0 --port 8000
# Replace /path/to/model/Qwen3-Coder-30B-A3B-Instruct with the actual path to your model directory.
# version that works with open-ai oss, running on 8xA6000 (Ampere GPUs)
# docker run --runtime nvidia --rm -e VLLM_ATTENTION_BACKEND=TRITON_ATTN_VLLM_V1 --gpus all --network host -v ./openai-gpt-oss-20b:/root/.cache/huggingface/models/openai-gpt-oss-20b --ipc=host vllm/vllm-openai:gptoss --model /root/.cache/huggingface/models/openai-gpt-oss-20b --tensor-parallel-size 8 --async-scheduling --host 0.0.0.0 --port 8888
# docker run --runtime nvidia --rm -e VLLM_ATTENTION_BACKEND=TRITON_ATTN_VLLM_V1 --gpus all --network host -v ./openai-gpt-oss-120b:/root/.cache/huggingface/models/openai-gpt-oss-120b --ipc=host vllm/vllm-openai:gptoss --model /root/.cache/huggingface/models/openai-gpt-oss-120b --tensor-parallel-size 8 --async-scheduling --host 0.0.0.0 --port 8888


# --- Configuration ---
MODEL_NAME="/root/.cache/huggingface/models/Qwen3-235B-A22B-Instruct-2507-FP8" #"/root/.cache/huggingface/models/openai-gpt-oss-120b" #"openrouter/horizon-alpha" #"/root/.cache/huggingface/models/Qwen3-Coder-30B-A3B-Instruct" #"google/gemini-2.5-flash-lite"
BENCHMARKS="cvdp"
API_BACKEND="vllm" # "vllm" #"openrouter"
PROBLEMS="" #"cvdp_copilot_64b66b_decoder_0001 cvdp_copilot_16qam_mapper_0001" # 2 example problems
CVDP_CATEGORIES="cid003" #"cid002 cid003"
POP_SIZE=10
NUM_GEN=4
NUM_WORKERS=10
STRATEGY="ucb"
MAX_TOKENS=8192
TEMP=0.7
TOPP=0.8
CUR_TIME=$(date +%Y%m%d_%H%M)
VLLM_PORT=8888
VLLM_HOST="localhost"
EDIT_MODE="whole" # "whole" or "diff"
POPULATION_POOL_MODE="dual" # "dual" or "single"

# --- Derived Variables ---
# Replace '/' in model name with '_' to match the script's output directory format
SANITIZED_MODEL_NAME=${MODEL_NAME//\//_}
BASE_EXP_DIR="./exp/${SANITIZED_MODEL_NAME}"
SAVE_DIR="/home/kmcho/1_RESEARCH/LLM_Evol_Legalization/PisoCode/submodules/rtl-llm-evo/exp/exp_cvdp_${CUR_TIME}_${EDIT_MODE}_${POPULATION_POOL_MODE}_evolve_cid003"
ORIGINAL_EXP_DIR="${BASE_EXP_DIR}_test"
REFACTORED_EXP_DIR="${BASE_EXP_DIR}_refactored"

# --- Test Execution ---
echo "🚀 Starting regression test..."
echo "Script started at: $CUR_TIME"
echo "--------------------------------------------------"

# 1. Run the original script and generate its report
echo "1. Running  script (run_evolution.py)..."

# Build the command arguments in an array for flexibility
CMD_ARGS=(
    --benchmarks "$BENCHMARKS"
    --api_backend "$API_BACKEND"
    --model_name "$MODEL_NAME"
    --population_size "$POP_SIZE"
    --num_generations "$NUM_GEN"
    --num_workers "$NUM_WORKERS"
    --strategy_selection "$STRATEGY"
    --max_tokens "$MAX_TOKENS"
    --save_path "$SAVE_DIR"
    --vllm_port "$VLLM_PORT"
    --vllm_host "$VLLM_HOST"
    --generation_mode "$EDIT_MODE"
    --temperature "$TEMP"
    --top_p "$TOPP"
    --population_pool_mode "$POPULATION_POOL_MODE"
)

# Conditionally add the cvdp_categories argument if the string is not empty
if [ -n "$CVDP_CATEGORIES" ]; then
    CMD_ARGS+=(--cvdp_categories $CVDP_CATEGORIES)
fi

# Conditionally add the problems argument if the string is not empty
if [ -n "$PROBLEMS" ]; then
    CMD_ARGS+=(--problems $PROBLEMS)
fi

# Execute the python script with the constructed arguments
python3 scripts/run_evolution.py "${CMD_ARGS[@]}"

echo "2. Generating report for ORIGINAL run..."
python3 scripts/evolutionary_report_generator.py \
    --experiment_path "$SAVE_DIR/${SANITIZED_MODEL_NAME}" \
    --save_markdown

echo "--------------------------------------------------"
