#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/run_qd_theory_followup_vllm.sh [--suite rtllm|verilogeval|matrix] [--dry-run]

Description:
  Runs a repeatable bounded CVT follow-up matrix for the theory-grounded QD
  profile beside the current structural controls. This is intended for the
  next experiment stage after single-problem smoke validation.

Suites:
  rtllm
    default problems: Prob001_accu, Prob002_adder_16bit
  verilogeval
    default problems: Prob001_zero, Prob017_mux2to1v
  matrix
    both suites

Environment overrides:
  VLLM_HOST                           vLLM host (default: host.docker.internal)
  VLLM_PORT                           vLLM port (default: 8000)
  THEORY_FOLLOWUP_MIN_MODEL_LEN       Required minimum served max_model_len (default: 128000, set 0 to disable)
  PYTHON_BIN                          Python binary (default: <repo>/.venv/bin/python if present, else python3)
  THEORY_FOLLOWUP_PROBLEMS_RTLLM      Space-separated RTLLM problem IDs
  THEORY_FOLLOWUP_PROBLEMS_VERILOGEVAL Space-separated VerilogEval problem IDs
  THEORY_FOLLOWUP_SAVE_PATH           Base output directory (default: /tmp/qd_theory_followup)
  THEORY_FOLLOWUP_POPULATION_SIZE     Population size (default: 4)
  THEORY_FOLLOWUP_NUM_GENERATIONS     Number of generations (default: 2)
  THEORY_FOLLOWUP_TOTAL_WORKER_SLOTS  Total worker-slot budget (default: 2)
  THEORY_FOLLOWUP_MAX_WORKERS         Max workers per problem (default: 1)
  THEORY_FOLLOWUP_MAX_TOKENS          LLM max tokens (default: 128000)
  THEORY_FOLLOWUP_DIFF_MAX_TOKENS     Diff max tokens (default: THEORY_FOLLOWUP_MAX_TOKENS)
  THEORY_FOLLOWUP_TEMPERATURE         LLM temperature (default: 0.3)
  THEORY_FOLLOWUP_TOP_P               LLM top-p (default: 0.95)
  THEORY_FOLLOWUP_TIMEOUT_S           Per-command timeout in seconds (default: 0, disabled)
  THEORY_FOLLOWUP_NUM_CELLS           CVT cell count (default: 16)
  THEORY_FOLLOWUP_CVT_WARMUP          CVT warmup successes (default: 4)

Examples:
  scripts/run_qd_theory_followup_vllm.sh --dry-run
  scripts/run_qd_theory_followup_vllm.sh --suite rtllm
  THEORY_FOLLOWUP_SAVE_PATH=/tmp/qd_theory_followup scripts/run_qd_theory_followup_vllm.sh --suite matrix
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

SUITE="${THEORY_FOLLOWUP_SUITE:-matrix}"
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
elif [[ -x "/workspace/.venv/bin/python" ]]; then
  DEFAULT_PYTHON="/workspace/.venv/bin/python"
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

suite_benchmark() {
  case "$1" in
    rtllm)
      echo "RTLLM"
      return 0
      ;;
    verilogeval)
      echo "VerilogEval-Spec-to-RTL"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

suite_problem_string() {
  case "$1" in
    rtllm)
      if [[ -n "${THEORY_FOLLOWUP_PROBLEMS_RTLLM:-}" ]]; then
        echo "${THEORY_FOLLOWUP_PROBLEMS_RTLLM}"
        return 0
      fi
      echo "Prob001_accu Prob002_adder_16bit"
      return 0
      ;;
    verilogeval)
      if [[ -n "${THEORY_FOLLOWUP_PROBLEMS_VERILOGEVAL:-}" ]]; then
        echo "${THEORY_FOLLOWUP_PROBLEMS_VERILOGEVAL}"
        return 0
      fi
      echo "Prob001_zero Prob017_mux2to1v"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

profile_label() {
  case "$1" in
    implemented_structural_fixed_5d)
      echo "cvt_structural_fixed"
      return 0
      ;;
    size_control_3d)
      echo "cvt_size_control"
      return 0
      ;;
    theory_grounded_full_20d)
      echo "cvt_theory_grounded"
      return 0
      ;;
    *)
      echo "$1"
      return 0
      ;;
  esac
}

case "${SUITE}" in
  rtllm)
    SUITES=("rtllm")
    ;;
  verilogeval|verilogevalv2|ve2)
    SUITES=("verilogeval")
    ;;
  matrix)
    SUITES=("rtllm" "verilogeval")
    ;;
  *)
    echo "Unsupported suite '${SUITE}'. Use rtllm, verilogeval, or matrix." >&2
    exit 2
    ;;
esac

VLLM_HOST="${VLLM_HOST:-host.docker.internal}"
VLLM_PORT="${VLLM_PORT:-8000}"
MODEL_ENDPOINT="http://${VLLM_HOST}:${VLLM_PORT}/v1/models"
MODELS_JSON="$(curl -sS --fail "${MODEL_ENDPOINT}")"
mapfile -t MODEL_INFO < <(
  printf '%s' "${MODELS_JSON}" | "${PYTHON_BIN}" -c '
import json, sys
payload = json.load(sys.stdin)
models = payload.get("data") or []
first = models[0] if models else {}
print(first.get("id", ""))
max_len = first.get("max_model_len", "")
print(max_len if isinstance(max_len, int) else "")
'
)
MODEL_NAME="${MODEL_INFO[0]:-}"
MODEL_MAX_LEN="${MODEL_INFO[1]:-}"

if [[ -z "${MODEL_NAME}" ]]; then
  echo "No model id found from ${MODEL_ENDPOINT}." >&2
  exit 1
fi

MIN_MODEL_LEN_RAW="${THEORY_FOLLOWUP_MIN_MODEL_LEN:-128000}"
if ! MIN_MODEL_LEN="$(parse_model_len "${MIN_MODEL_LEN_RAW}")"; then
  echo "Warning: invalid THEORY_FOLLOWUP_MIN_MODEL_LEN='${MIN_MODEL_LEN_RAW}'. Disabling model-len gate." >&2
  MIN_MODEL_LEN=0
fi

if (( MIN_MODEL_LEN > 0 )); then
  if [[ -z "${MODEL_MAX_LEN}" ]]; then
    echo "Warning: model '${MODEL_NAME}' did not report max_model_len; cannot verify >= ${MIN_MODEL_LEN}."
  elif [[ ! "${MODEL_MAX_LEN}" =~ ^[0-9]+$ ]]; then
    echo "Warning: non-numeric max_model_len '${MODEL_MAX_LEN}' reported for '${MODEL_NAME}'."
  elif (( MODEL_MAX_LEN < MIN_MODEL_LEN )); then
    echo "Model '${MODEL_NAME}' reports max_model_len=${MODEL_MAX_LEN}, below required ${MIN_MODEL_LEN}." >&2
    exit 1
  fi
fi

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  export OPENAI_API_KEY="vllm-local-placeholder"
  echo "OPENAI_API_KEY was not set; exported placeholder for local vLLM compatibility."
fi

SAVE_ROOT="${THEORY_FOLLOWUP_SAVE_PATH:-/tmp/qd_theory_followup}"
RUN_TAG="$(date +%Y%m%d_%H%M%S)"
SAVE_PATH="${SAVE_ROOT}/${RUN_TAG}"
POPULATION_SIZE="${THEORY_FOLLOWUP_POPULATION_SIZE:-4}"
NUM_GENERATIONS="${THEORY_FOLLOWUP_NUM_GENERATIONS:-2}"
TOTAL_WORKER_SLOTS="${THEORY_FOLLOWUP_TOTAL_WORKER_SLOTS:-2}"
MAX_WORKERS_PER_PROBLEM="${THEORY_FOLLOWUP_MAX_WORKERS:-1}"
MAX_TOKENS="${THEORY_FOLLOWUP_MAX_TOKENS:-128000}"
DIFF_MAX_TOKENS="${THEORY_FOLLOWUP_DIFF_MAX_TOKENS:-${MAX_TOKENS}}"
TEMPERATURE="${THEORY_FOLLOWUP_TEMPERATURE:-0.3}"
TOP_P="${THEORY_FOLLOWUP_TOP_P:-0.95}"
TIMEOUT_S="${THEORY_FOLLOWUP_TIMEOUT_S:-0}"
NUM_CELLS="${THEORY_FOLLOWUP_NUM_CELLS:-16}"
CVT_WARMUP="${THEORY_FOLLOWUP_CVT_WARMUP:-4}"
PROFILES=(
  "implemented_structural_fixed_5d"
  "size_control_3d"
  "theory_grounded_full_20d"
)

echo "vLLM endpoint: ${MODEL_ENDPOINT}"
echo "Detected model: ${MODEL_NAME}"
if [[ -n "${MODEL_MAX_LEN}" ]]; then
  echo "Reported max_model_len: ${MODEL_MAX_LEN}"
fi
echo "Required min model len: ${MIN_MODEL_LEN_RAW} (normalized=${MIN_MODEL_LEN})"
echo "Suite: ${SUITE}"
echo "Profiles: ${PROFILES[*]}"
echo "Save path: ${SAVE_PATH}"

status=0
for suite_key in "${SUITES[@]}"; do
  BENCHMARK="$(suite_benchmark "${suite_key}")"
  read -r -a PROBLEMS <<<"$(suite_problem_string "${suite_key}")"

  for profile in "${PROFILES[@]}"; do
    LABEL="$(profile_label "${profile}")"
    CMD=("${PYTHON_BIN}" "scripts/run_backend.py")
    CMD+=("--backend" "revolution")
    CMD+=("--search_mode" "revolution_qd")
    CMD+=("--qd_archive_type" "cvt")
    CMD+=("--qd_descriptor_profile" "${profile}")
    CMD+=("--qd_num_cells" "${NUM_CELLS}")
    CMD+=("--qd_cvt_warmup_successes" "${CVT_WARMUP}")
    CMD+=("--benchmarks" "${BENCHMARK}")
    CMD+=("--problems")
    CMD+=("${PROBLEMS[@]}")
    CMD+=("--api_backend" "vllm")
    CMD+=("--vllm_host" "${VLLM_HOST}")
    CMD+=("--vllm_port" "${VLLM_PORT}")
    CMD+=("--vllm_min_model_len" "${MIN_MODEL_LEN}")
    CMD+=("--model_name" "${MODEL_NAME}")
    CMD+=("--population_size" "${POPULATION_SIZE}")
    CMD+=("--num_generations" "${NUM_GENERATIONS}")
    CMD+=("--total_worker_slots" "${TOTAL_WORKER_SLOTS}")
    CMD+=("--max_workers_per_problem" "${MAX_WORKERS_PER_PROBLEM}")
    CMD+=("--evaluation_mode" "strict_ablation")
    CMD+=("--temperature" "${TEMPERATURE}")
    CMD+=("--top_p" "${TOP_P}")
    CMD+=("--max_tokens" "${MAX_TOKENS}")
    CMD+=("--diff_max_tokens" "${DIFF_MAX_TOKENS}")
    CMD+=("--save_path" "${SAVE_PATH}/${suite_key}/${LABEL}")
    CMD+=("--no-backend_subdir")
    CMD+=("--seed" "42")

    echo
    echo "[${suite_key}/${LABEL}] command:"
    if (( TIMEOUT_S > 0 )); then
      printf '  %q' timeout "${TIMEOUT_S}s" "${CMD[@]}"
    else
      printf '  %q' "${CMD[@]}"
    fi
    printf '\n'

    if [[ "${DRY_RUN}" == "1" ]]; then
      continue
    fi

    if (( TIMEOUT_S > 0 )); then
      if ! timeout "${TIMEOUT_S}s" "${CMD[@]}"; then
        status=1
        echo "[${suite_key}/${LABEL}] follow-up command failed or timed out." >&2
      fi
      continue
    fi

    if ! "${CMD[@]}"; then
      status=1
      echo "[${suite_key}/${LABEL}] follow-up command failed." >&2
    fi
  done
done

if [[ "${DRY_RUN}" == "1" ]]; then
  echo "Dry run enabled; commands were not executed."
  exit 0
fi

if (( status != 0 )); then
  exit "${status}"
fi

echo "Theory follow-up matrix completed."
