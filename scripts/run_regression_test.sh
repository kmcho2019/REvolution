#!/bin/bash
set -e # Exit immediately if a command fails

# vllm docker configuration
# docker run --runtime nvidia --rm --gpus all --network host -v /path/to/model/Qwen3-Coder-30B-A3B-Instruct:/root/.cache/huggingface/models/Qwen3-Coder-30B-A3B-Instruct --ipc=host vllm/vllm-openai:latest --model /root/.cache/huggingface/models/Qwen3-Coder-30B-A3B-Instruct --tensor-parallel-size 8 --host 0.0.0.0 --port 8000
# Replace /path/to/model/Qwen3-Coder-30B-A3B-Instruct with the actual path to your model directory.

# --- Configuration ---
MODEL_NAME="openrouter/horizon-alpha" #"/root/.cache/huggingface/models/Qwen3-Coder-30B-A3B-Instruct" #"google/gemini-2.5-flash-lite"
BENCHMARKS="RTLLM VerilogEval-Spec-to-RTL"
PROBLEMS="Prob001_zero Prob010_mt2015_q4a Prob052_gates100 Prob068_countbcd Prob096_review2015_fsmseq Prob116_m2014_q3 Prob129_ece241_2013_q8 Prob001_accu Prob021_counter_12 Prob022_ring_counter"
API_BACKEND="openrouter" # "vllm" #"openrouter"
POP_SIZE=10
NUM_GEN=4
NUM_WORKERS=10
STRATEGY="ucb"
MAX_TOKENS=4096

# --- Derived Variables ---
# Replace '/' in model name with '_' to match the script's output directory format
SANITIZED_MODEL_NAME=${MODEL_NAME//\//_}
BASE_EXP_DIR="./exp/${SANITIZED_MODEL_NAME}"
ORIGINAL_EXP_DIR="${BASE_EXP_DIR}_original"
REFACTORED_EXP_DIR="${BASE_EXP_DIR}_refactored"

# --- Test Execution ---
echo "🚀 Starting regression test..."
echo "--------------------------------------------------"

# 1. Run the original script and generate its report
echo "1. Running ORIGINAL script (main.py)..."
python3 scripts/main.py \
    --benchmarks $BENCHMARKS \
    --problems $PROBLEMS \
    --api_backend $API_BACKEND \
    --model_name "$MODEL_NAME" \
    --population_size $POP_SIZE \
    --num_generations $NUM_GEN \
    --num_workers $NUM_WORKERS \
    --strategy_selection $STRATEGY \
    --max_tokens $MAX_TOKENS

echo "   -> Renaming original results to: ${ORIGINAL_EXP_DIR}"
mv "$BASE_EXP_DIR" "$ORIGINAL_EXP_DIR"

echo "2. Generating report for ORIGINAL run..."
python3 scripts/evolutionary_report_generator.py \
    --experiment_path "$ORIGINAL_EXP_DIR" \
    --save_markdown

echo "--------------------------------------------------"

# 2. Run the refactored script and generate its report
echo "3. Running REFACTORED script (run_evolution.py)..."
python3 scripts/run_evolution.py \
    --benchmarks $BENCHMARKS \
    --problems $PROBLEMS \
    --api_backend $API_BACKEND \
    --model_name "$MODEL_NAME" \
    --population_size $POP_SIZE \
    --num_generations $NUM_GEN \
    --num_workers $NUM_WORKERS \
    --strategy_selection $STRATEGY \
    --max_tokens $MAX_TOKENS

echo "   -> Renaming refactored results to: ${REFACTORED_EXP_DIR}"
mv "$BASE_EXP_DIR" "$REFACTORED_EXP_DIR"

echo "4. Generating report for REFACTORED run..."
python3 scripts/evolutionary_report_generator.py \
    --experiment_path "$REFACTORED_EXP_DIR" \
    --save_markdown

echo "--------------------------------------------------"
echo "✅ Regression test complete!"
echo "Markdown reports are available at:"
echo "   - Original:   ${ORIGINAL_EXP_DIR}/OVERALL_EVOLUTIONARY_REPORT.md"
echo "   - Refactored: ${REFACTORED_EXP_DIR}/OVERALL_EVOLUTIONARY_REPORT.md"