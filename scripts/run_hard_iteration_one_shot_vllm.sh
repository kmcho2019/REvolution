#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/run_hard_iteration_one_shot_vllm.sh [--benchmarks RTLLM VerilogEval-Spec-to-RTL] [--dry-run]

Description:
  Run or resume the long-context vanilla one-shot baseline used to freeze the
  hard iteration subset. Existing problem summaries are treated as completed,
  and the remaining pending problems are launched in bounded batches so the run
  can be resumed after endpoint outages.

Environment overrides:
  HARD_ONE_SHOT_VLLM_HOST       vLLM host (default: host.docker.internal)
  HARD_ONE_SHOT_VLLM_PORT       vLLM port (default: 8000)
  HARD_ONE_SHOT_MIN_MODEL_LEN   Required minimum served max_model_len (default: 128000, set 0 to disable)
  HARD_ONE_SHOT_SAVE_PATH       Output root (default: <repo>/exp/hard_iteration_one_shot)
  HARD_ONE_SHOT_BATCH_SIZE      Problems per batch (default: 8)
  HARD_ONE_SHOT_NUM_WORKERS     run_one_shot worker count (default: 8)
  HARD_ONE_SHOT_NUM_SAMPLES     Samples per problem (default: 10)
  HARD_ONE_SHOT_MAX_TOKENS      Max tokens (default: 128000)
  HARD_ONE_SHOT_TEMPERATURE     Temperature (default: 1.0)
  HARD_ONE_SHOT_TOP_P           Top-p (default: 0.95)
  HARD_ONE_SHOT_POLL_INTERVAL_S Endpoint poll interval (default: 60)
  HARD_ONE_SHOT_MAX_WAIT_S      Max endpoint wait before aborting (default: 0, disabled)
  HARD_ONE_SHOT_MODEL_NAME      Model name (default: /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b)
  PYTHON_BIN                    Python binary (default: <repo>/.venv/bin/python if present, else python3)

Examples:
  scripts/run_hard_iteration_one_shot_vllm.sh --dry-run
  HARD_ONE_SHOT_NUM_WORKERS=2 scripts/run_hard_iteration_one_shot_vllm.sh --benchmarks RTLLM
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

declare -a BENCHMARKS=()
DRY_RUN="${DRY_RUN:-0}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --benchmarks)
      shift
      while [[ $# -gt 0 ]] && [[ ! "$1" =~ ^-- ]]; do
        BENCHMARKS+=("$1")
        shift
      done
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ${#BENCHMARKS[@]} -eq 0 ]]; then
  BENCHMARKS=("RTLLM" "VerilogEval-Spec-to-RTL")
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required but not found in PATH." >&2
  exit 1
fi

DEFAULT_PYTHON="python3"
if [[ -x "${REPO_ROOT}/.venv/bin/python" ]]; then
  DEFAULT_PYTHON="${REPO_ROOT}/.venv/bin/python"
elif [[ -x "/workspace/.venv/bin/python" ]]; then
  DEFAULT_PYTHON="/workspace/.venv/bin/python"
fi
PYTHON_BIN="${PYTHON_BIN:-${DEFAULT_PYTHON}}"
if ! command -v "${PYTHON_BIN}" >/dev/null 2>&1; then
  echo "${PYTHON_BIN} is required but not found in PATH." >&2
  exit 1
fi

VLLM_HOST="${HARD_ONE_SHOT_VLLM_HOST:-host.docker.internal}"
VLLM_PORT="${HARD_ONE_SHOT_VLLM_PORT:-8000}"
MIN_MODEL_LEN="${HARD_ONE_SHOT_MIN_MODEL_LEN:-128000}"
SAVE_PATH="${HARD_ONE_SHOT_SAVE_PATH:-${REPO_ROOT}/exp/hard_iteration_one_shot}"
BATCH_SIZE="${HARD_ONE_SHOT_BATCH_SIZE:-8}"
NUM_WORKERS="${HARD_ONE_SHOT_NUM_WORKERS:-8}"
NUM_SAMPLES="${HARD_ONE_SHOT_NUM_SAMPLES:-10}"
MAX_TOKENS="${HARD_ONE_SHOT_MAX_TOKENS:-128000}"
TEMPERATURE="${HARD_ONE_SHOT_TEMPERATURE:-1.0}"
TOP_P="${HARD_ONE_SHOT_TOP_P:-0.95}"
POLL_INTERVAL_S="${HARD_ONE_SHOT_POLL_INTERVAL_S:-60}"
MAX_WAIT_S="${HARD_ONE_SHOT_MAX_WAIT_S:-0}"
MODEL_NAME="${HARD_ONE_SHOT_MODEL_NAME:-/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b}"
MODEL_DIR_NAME="${MODEL_NAME//\//_}"
MODEL_ENDPOINT="http://${VLLM_HOST}:${VLLM_PORT}/v1/models"

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  export OPENAI_API_KEY="vllm-local-placeholder"
fi

wait_for_endpoint() {
  local start_ts now elapsed
  start_ts="$(date +%s)"
  while true; do
    if curl -sS --fail "${MODEL_ENDPOINT}" >/tmp/hard_one_shot_models.json 2>/tmp/hard_one_shot_models.err; then
      return 0
    fi
    if [[ "${MAX_WAIT_S}" =~ ^[0-9]+$ ]] && (( MAX_WAIT_S > 0 )); then
      now="$(date +%s)"
      elapsed="$(( now - start_ts ))"
      if (( elapsed >= MAX_WAIT_S )); then
        echo "Endpoint wait exceeded HARD_ONE_SHOT_MAX_WAIT_S=${MAX_WAIT_S}." >&2
        cat /tmp/hard_one_shot_models.err >&2 || true
        return 1
      fi
    fi
    echo "Endpoint unavailable at ${MODEL_ENDPOINT}; retrying in ${POLL_INTERVAL_S}s."
    if [[ "${DRY_RUN}" == "1" ]]; then
      return 0
    fi
    sleep "${POLL_INTERVAL_S}"
  done
}

run_cmd() {
  local label="$1"
  shift
  echo "[${label}] command:"
  printf '  %q' "$@"
  printf '\n'
  if [[ "${DRY_RUN}" == "1" ]]; then
    return 0
  fi
  "$@"
}

echo "vLLM endpoint: ${MODEL_ENDPOINT}"
echo "Model: ${MODEL_NAME}"
echo "Benchmarks: ${BENCHMARKS[*]}"
echo "Save path: ${SAVE_PATH}"
echo "Batch size: ${BATCH_SIZE}"
echo "Workers: ${NUM_WORKERS}"

status=0
for benchmark in "${BENCHMARKS[@]}"; do
  mapfile -t PENDING < <(
    "${PYTHON_BIN}" - <<'PY' "${REPO_ROOT}" "${SAVE_PATH}" "${MODEL_DIR_NAME}" "${benchmark}"
from pathlib import Path
import sys

repo_root = Path(sys.argv[1])
save_path = Path(sys.argv[2])
model_dir_name = sys.argv[3]
benchmark = sys.argv[4]
problems_file = repo_root / "data" / "bench" / benchmark / "problems.txt"
problems = [line.strip() for line in problems_file.read_text(encoding="utf-8").splitlines() if line.strip()]
summary_root = save_path / model_dir_name / benchmark
completed = {path.parent.name for path in summary_root.rglob("*_summary.json")} if summary_root.exists() else set()
for problem in problems:
    if problem not in completed:
        print(problem)
PY
  )

  if [[ ${#PENDING[@]} -eq 0 ]]; then
    echo "[${benchmark}] no pending problems."
    continue
  fi

  echo "[${benchmark}] pending problems: ${#PENDING[@]}"
  batch_index=0
  for ((start=0; start<${#PENDING[@]}; start+=BATCH_SIZE)); do
    batch_index=$(( batch_index + 1 ))
    BATCH=("${PENDING[@]:start:BATCH_SIZE}")
    if ! wait_for_endpoint; then
      status=1
      break 2
    fi

    CMD=("${PYTHON_BIN}" "scripts/run_one_shot.py")
    CMD+=("--benchmarks" "${benchmark}")
    CMD+=("--problems")
    CMD+=("${BATCH[@]}")
    CMD+=("--api_backend" "vllm")
    CMD+=("--vllm_host" "${VLLM_HOST}")
    CMD+=("--vllm_port" "${VLLM_PORT}")
    CMD+=("--vllm_min_model_len" "${MIN_MODEL_LEN}")
    CMD+=("--model_name" "${MODEL_NAME}")
    CMD+=("--save_path" "${SAVE_PATH}")
    CMD+=("--num_workers" "${NUM_WORKERS}")
    CMD+=("--temperature" "${TEMPERATURE}")
    CMD+=("--top_p" "${TOP_P}")
    CMD+=("--max_tokens" "${MAX_TOKENS}")
    CMD+=("--num_samples" "${NUM_SAMPLES}")
    CMD+=("--generation_mode" "whole")

    if ! run_cmd "${benchmark}/batch${batch_index}" "${CMD[@]}"; then
      status=1
      break 2
    fi
  done
done

if [[ "${DRY_RUN}" == "1" ]]; then
  echo "Dry run enabled; commands were not executed."
fi

exit "${status}"
