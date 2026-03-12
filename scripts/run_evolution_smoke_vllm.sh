#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/run_evolution_smoke_vllm.sh [--suite rtllm|verilogeval|mixed] [--dry-run]

Description:
  Runs a small REvolution evolution smoke test against a live vLLM endpoint.
  The script auto-detects the model name from /v1/models and uses it for --model_name.
  If OPENAI_API_KEY is unset, a local placeholder value is exported for OpenAI-compatible client initialization.
  The script exits non-zero if summary results contain initialization_failed or run_failed statuses.

Environment overrides:
  VLLM_HOST                 vLLM host (default: vllm)
  VLLM_PORT                 vLLM port (default: 8888)
  SMOKE_MIN_MODEL_LEN       Required minimum served max_model_len (default: 128000, set 0 to disable).
                            Supports raw integers or suffixes (k/m/g), e.g. 128k, 131072, 12800k.
  PYTHON_BIN                Python binary (default: <repo>/.venv/bin/python if present, else python3)
  SMOKE_PROBLEMS            Space-separated problem IDs (overrides suite defaults)
  SMOKE_POPULATION_SIZE     Population size (default: 2)
  SMOKE_NUM_GENERATIONS     Number of generations (default: 1)
  SMOKE_NUM_WORKERS         Worker count (default: 1)
  SMOKE_MAX_TOKENS          LLM max tokens (default: 128000)
  SMOKE_DIFF_MAX_TOKENS     Diff max tokens (default: SMOKE_MAX_TOKENS)
  SMOKE_TEMPERATURE         LLM temperature (default: 0.7)
  SMOKE_TOP_P               LLM top-p (default: 0.95)
  SMOKE_STRATEGY_SELECTION  Meta-strategy (default: ucb)
  SMOKE_GENERATION_MODE     whole|diff (default: whole)
  SMOKE_POOL_MODE           dual|single (default: dual)
  SMOKE_SAVE_PATH           Base output directory (default: <repo>/exp/funsearch_backend_smoke)

Examples:
  scripts/run_evolution_smoke_vllm.sh
  scripts/run_evolution_smoke_vllm.sh --suite rtllm
  SMOKE_PROBLEMS="Prob001_accu Prob002_adder_16bit" scripts/run_evolution_smoke_vllm.sh
  scripts/run_evolution_smoke_vllm.sh --dry-run
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

SUITE="${SMOKE_SUITE:-mixed}"
DRY_RUN="${DRY_RUN:-0}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --suite)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --suite" >&2
        exit 2
      fi
      SUITE="$2"
      shift 2
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

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required but not found in PATH." >&2
  exit 1
fi

DEFAULT_PYTHON="python3"
if [[ -x "${REPO_ROOT}/.venv/bin/python" ]]; then
  DEFAULT_PYTHON="${REPO_ROOT}/.venv/bin/python"
fi

PYTHON_BIN="${PYTHON_BIN:-${DEFAULT_PYTHON}}"
if ! command -v "${PYTHON_BIN}" >/dev/null 2>&1; then
  echo "${PYTHON_BIN} is required but not found in PATH." >&2
  exit 1
fi

parse_model_len() {
  local raw="$1"
  local cleaned="${raw//_/}"
  local base suffix multiplier

  if [[ "${cleaned}" =~ ^[0-9]+$ ]]; then
    echo "${cleaned}"
    return 0
  fi
  if [[ "${cleaned}" =~ ^([0-9]+)([kKmMgG])$ ]]; then
    base="${BASH_REMATCH[1]}"
    suffix="${BASH_REMATCH[2]}"
    case "${suffix}" in
      k|K) multiplier=1000 ;;
      m|M) multiplier=1000000 ;;
      g|G) multiplier=1000000000 ;;
      *) return 1 ;;
    esac
    echo $(( base * multiplier ))
    return 0
  fi
  return 1
}

VLLM_HOST="${VLLM_HOST:-vllm}"
VLLM_PORT="${VLLM_PORT:-8888}"
MODEL_ENDPOINT="http://${VLLM_HOST}:${VLLM_PORT}/v1/models"

MODELS_JSON="$(curl -sS --fail "${MODEL_ENDPOINT}")"
mapfile -t MODEL_INFO < <(
  printf '%s' "${MODELS_JSON}" | "${PYTHON_BIN}" -c '
import json, sys
data = json.load(sys.stdin)
models = data.get("data") or []
first = models[0] if models else {}
model_id = first.get("id", "")
max_len = first.get("max_model_len", "")
print(model_id)
print(max_len if isinstance(max_len, int) else "")
'
)
MODEL_NAME="${MODEL_INFO[0]:-}"
MODEL_MAX_LEN="${MODEL_INFO[1]:-}"

if [[ -z "${MODEL_NAME}" ]]; then
  echo "No model id found from ${MODEL_ENDPOINT}." >&2
  exit 1
fi

MIN_MODEL_LEN="${SMOKE_MIN_MODEL_LEN:-128000}"
MIN_MODEL_LEN_RAW="${MIN_MODEL_LEN}"
if ! MIN_MODEL_LEN="$(parse_model_len "${MIN_MODEL_LEN_RAW}")"; then
  echo "Warning: invalid SMOKE_MIN_MODEL_LEN='${MIN_MODEL_LEN_RAW}'. Disabling model-len gate." >&2
  MIN_MODEL_LEN=0
fi
if (( MIN_MODEL_LEN > 0 )); then
  if [[ -z "${MODEL_MAX_LEN}" ]]; then
    echo "Warning: model '${MODEL_NAME}' did not report max_model_len; cannot verify >= ${MIN_MODEL_LEN}."
  elif [[ ! "${MODEL_MAX_LEN}" =~ ^[0-9]+$ ]]; then
    echo "Warning: non-numeric max_model_len '${MODEL_MAX_LEN}' reported for '${MODEL_NAME}'."
  elif (( MODEL_MAX_LEN < MIN_MODEL_LEN )); then
    echo "Model '${MODEL_NAME}' reports max_model_len=${MODEL_MAX_LEN}, below required ${MIN_MODEL_LEN}." >&2
    echo "Start vLLM with a higher context window (for example: --max-model-len 131072) and retry." >&2
    exit 1
  fi
fi

# AsyncOpenAI requires an API key value even for local OpenAI-compatible endpoints.
# Keep a harmless placeholder for local vLLM if nothing is already exported.
if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  export OPENAI_API_KEY="vllm-local-placeholder"
  echo "OPENAI_API_KEY was not set; exported placeholder for local vLLM compatibility."
fi

case "${SUITE}" in
  rtllm)
    BENCHMARKS=("RTLLM")
    DEFAULT_PROBLEMS=("Prob001_accu")
    ;;
  verilogeval|verilogevalv2|ve2)
    BENCHMARKS=("VerilogEval-Spec-to-RTL")
    DEFAULT_PROBLEMS=("Prob001_zero")
    ;;
  mixed)
    BENCHMARKS=("RTLLM" "VerilogEval-Spec-to-RTL")
    DEFAULT_PROBLEMS=("Prob001_accu" "Prob001_zero")
    ;;
  *)
    echo "Unsupported suite '${SUITE}'. Use rtllm, verilogeval, or mixed." >&2
    exit 2
    ;;
esac

if [[ -n "${SMOKE_PROBLEMS:-}" ]]; then
  read -r -a PROBLEMS <<<"${SMOKE_PROBLEMS}"
else
  PROBLEMS=("${DEFAULT_PROBLEMS[@]}")
fi

POPULATION_SIZE="${SMOKE_POPULATION_SIZE:-2}"
NUM_GENERATIONS="${SMOKE_NUM_GENERATIONS:-1}"
NUM_WORKERS="${SMOKE_NUM_WORKERS:-1}"
MAX_TOKENS="${SMOKE_MAX_TOKENS:-128000}"
DIFF_MAX_TOKENS="${SMOKE_DIFF_MAX_TOKENS:-${MAX_TOKENS}}"
TEMPERATURE="${SMOKE_TEMPERATURE:-0.7}"
TOP_P="${SMOKE_TOP_P:-0.95}"
STRATEGY_SELECTION="${SMOKE_STRATEGY_SELECTION:-ucb}"
GENERATION_MODE="${SMOKE_GENERATION_MODE:-whole}"
POOL_MODE="${SMOKE_POOL_MODE:-dual}"
SAVE_ROOT="${SMOKE_SAVE_PATH:-${REPO_ROOT}/exp/funsearch_backend_smoke}"
RUN_TAG="$(date +%Y%m%d_%H%M%S)"
SAVE_PATH="${SAVE_ROOT}/${RUN_TAG}"
SANITIZED_MODEL_NAME="${MODEL_NAME//\//_}"

CMD=("${PYTHON_BIN}" "scripts/run_evolution.py")
CMD+=("--benchmarks")
CMD+=("${BENCHMARKS[@]}")
CMD+=("--problems")
CMD+=("${PROBLEMS[@]}")
CMD+=("--api_backend" "vllm")
CMD+=("--vllm_host" "${VLLM_HOST}")
CMD+=("--vllm_port" "${VLLM_PORT}")
CMD+=("--model_name" "${MODEL_NAME}")
CMD+=("--population_size" "${POPULATION_SIZE}")
CMD+=("--num_generations" "${NUM_GENERATIONS}")
CMD+=("--num_workers" "${NUM_WORKERS}")
CMD+=("--strategy_selection" "${STRATEGY_SELECTION}")
CMD+=("--generation_mode" "${GENERATION_MODE}")
CMD+=("--population_pool_mode" "${POOL_MODE}")
CMD+=("--temperature" "${TEMPERATURE}")
CMD+=("--top_p" "${TOP_P}")
CMD+=("--max_tokens" "${MAX_TOKENS}")
CMD+=("--diff_max_tokens" "${DIFF_MAX_TOKENS}")
CMD+=("--save_path" "${SAVE_PATH}")

echo "vLLM endpoint: ${MODEL_ENDPOINT}"
echo "Detected model: ${MODEL_NAME}"
if [[ -n "${MODEL_MAX_LEN}" ]]; then
  echo "Reported max_model_len: ${MODEL_MAX_LEN}"
fi
echo "Required min model len: ${MIN_MODEL_LEN_RAW} (normalized=${MIN_MODEL_LEN})"
echo "Suite: ${SUITE}"
echo "Benchmarks: ${BENCHMARKS[*]}"
echo "Problems: ${PROBLEMS[*]}"
echo "Population size: ${POPULATION_SIZE}"
echo "Generations: ${NUM_GENERATIONS}"
echo "Workers: ${NUM_WORKERS}"
echo "Output path: ${SAVE_PATH}"
echo "Command:"
printf '  %q' "${CMD[@]}"
printf '\n'

if [[ "${DRY_RUN}" == "1" ]]; then
  echo "Dry run enabled; command was not executed."
  exit 0
fi

"${CMD[@]}"

MODEL_OUTPUT_DIR="${SAVE_PATH}/${SANITIZED_MODEL_NAME}"
SUMMARY_FILE="$(ls -1t "${MODEL_OUTPUT_DIR}"/*_summary_results.txt 2>/dev/null | head -n 1 || true)"

if [[ -z "${SUMMARY_FILE}" ]]; then
  echo "Smoke run completed but no summary file was found under ${MODEL_OUTPUT_DIR}." >&2
  exit 1
fi

if grep -Eq ",(initialization_failed|run_failed)$" "${SUMMARY_FILE}"; then
  echo "Smoke run finished with failed problem statuses. See ${SUMMARY_FILE}." >&2
  exit 1
fi

echo "Smoke evolution run completed."
echo "Artifacts saved under: ${SAVE_PATH}"
