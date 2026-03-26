#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/run_qd_theory_grounded_smoke_vllm.sh [--suite rtllm|verilogeval|matrix] [--mode theory-only|compare] [--policy whole-heavy|diff-heavy] [--dry-run]

Description:
  Runs a bounded CVT-only smoke or comparison matrix for the theory-grounded
  descriptor family against the shared vLLM endpoint. This harness is intended
  for repeatable follow-on validation of the theory-grounded profile rather
  than one-off shell history commands.

Environment overrides:
  VLLM_HOST                         vLLM host (default: host.docker.internal)
  VLLM_PORT                         vLLM port (default: 8000)
  THEORY_SMOKE_MIN_MODEL_LEN        Required minimum served max_model_len (default: 128000, set 0 to disable)
  PYTHON_BIN                        Python binary (default: <repo>/.venv/bin/python if present, else python3)
  THEORY_SMOKE_PROBLEMS_RTLLM       Space-separated RTLLM problem IDs (default: Prob001_accu)
  THEORY_SMOKE_PROBLEMS_VERILOGEVAL Space-separated VerilogEval problem IDs (default: Prob001_zero)
  THEORY_SMOKE_MAX_TOKENS           LLM max tokens (default: 128000)
  THEORY_SMOKE_DIFF_MAX_TOKENS      Diff max tokens (default: THEORY_SMOKE_MAX_TOKENS)
  THEORY_SMOKE_TEMPERATURE          LLM temperature (default: 0.3)
  THEORY_SMOKE_TOP_P                LLM top-p (default: 0.95)
  THEORY_SMOKE_SAVE_PATH            Base output directory (default: <repo>/exp/qd_theory_grounded_smoke)
  THEORY_SMOKE_TIMEOUT_S            Per-command timeout in seconds (default: 300)
  THEORY_SMOKE_POPULATION_SIZE      Population size (default: 1)
  THEORY_SMOKE_NUM_GENERATIONS      Number of generations (default: 1)
  THEORY_SMOKE_TOTAL_WORKER_SLOTS   Total worker slots (default: 1)
  THEORY_SMOKE_MAX_WORKERS          Max workers per problem (default: 1)
  THEORY_SMOKE_NUM_CELLS            CVT cell count (default: 4)
  THEORY_SMOKE_WARMUP_SUCCESSES     CVT warmup successes (default: 1)

Examples:
  scripts/run_qd_theory_grounded_smoke_vllm.sh --dry-run
  scripts/run_qd_theory_grounded_smoke_vllm.sh --suite rtllm --mode theory-only
  scripts/run_qd_theory_grounded_smoke_vllm.sh --suite matrix --mode compare --policy diff-heavy
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

SUITE="${THEORY_SMOKE_SUITE:-matrix}"
MODE="${THEORY_SMOKE_MODE:-compare}"
POLICY="${THEORY_SMOKE_POLICY:-whole-heavy}"
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
    --mode)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --mode" >&2
        exit 2
      fi
      MODE="$2"
      shift 2
      ;;
    --policy)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --policy" >&2
        exit 2
      fi
      POLICY="$2"
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

profile_label() {
  case "$1" in
    theory_grounded_full_20d)
      echo "cvt_theory_grounded"
      return 0
      ;;
    implemented_structural_fixed_5d)
      echo "cvt_structural_fixed"
      return 0
      ;;
    size_control_3d)
      echo "cvt_size_control"
      return 0
      ;;
    *)
      echo "$1"
      return 0
      ;;
  esac
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

suite_problems() {
  case "$1" in
    rtllm)
      if [[ -n "${THEORY_SMOKE_PROBLEMS_RTLLM:-}" ]]; then
        echo "${THEORY_SMOKE_PROBLEMS_RTLLM}"
        return 0
      fi
      echo "Prob001_accu"
      return 0
      ;;
    verilogeval)
      if [[ -n "${THEORY_SMOKE_PROBLEMS_VERILOGEVAL:-}" ]]; then
        echo "${THEORY_SMOKE_PROBLEMS_VERILOGEVAL}"
        return 0
      fi
      echo "Prob001_zero"
      return 0
      ;;
    *)
      return 1
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

case "${MODE}" in
  theory-only)
    PROFILES=("theory_grounded_full_20d")
    ;;
  compare)
    PROFILES=(
      "implemented_structural_fixed_5d"
      "size_control_3d"
      "theory_grounded_full_20d"
    )
    ;;
  *)
    echo "Unsupported mode '${MODE}'. Use theory-only or compare." >&2
    exit 2
    ;;
esac

case "${POLICY}" in
  whole-heavy|diff-heavy)
    ;;
  *)
    echo "Unsupported policy '${POLICY}'. Use whole-heavy or diff-heavy." >&2
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

MIN_MODEL_LEN_RAW="${THEORY_SMOKE_MIN_MODEL_LEN:-128000}"
if ! MIN_MODEL_LEN="$(parse_model_len "${MIN_MODEL_LEN_RAW}")"; then
  echo "Warning: invalid THEORY_SMOKE_MIN_MODEL_LEN='${MIN_MODEL_LEN_RAW}'. Disabling model-len gate." >&2
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

MAX_TOKENS="${THEORY_SMOKE_MAX_TOKENS:-128000}"
DIFF_MAX_TOKENS="${THEORY_SMOKE_DIFF_MAX_TOKENS:-${MAX_TOKENS}}"
TEMPERATURE="${THEORY_SMOKE_TEMPERATURE:-0.3}"
TOP_P="${THEORY_SMOKE_TOP_P:-0.95}"
TIMEOUT_S="${THEORY_SMOKE_TIMEOUT_S:-300}"
POPULATION_SIZE="${THEORY_SMOKE_POPULATION_SIZE:-1}"
NUM_GENERATIONS="${THEORY_SMOKE_NUM_GENERATIONS:-1}"
TOTAL_WORKER_SLOTS="${THEORY_SMOKE_TOTAL_WORKER_SLOTS:-1}"
MAX_WORKERS_PER_PROBLEM="${THEORY_SMOKE_MAX_WORKERS:-1}"
NUM_CELLS="${THEORY_SMOKE_NUM_CELLS:-4}"
WARMUP_SUCCESSES="${THEORY_SMOKE_WARMUP_SUCCESSES:-1}"
SAVE_ROOT="${THEORY_SMOKE_SAVE_PATH:-${REPO_ROOT}/exp/qd_theory_grounded_smoke}"
RUN_TAG="$(date +%Y%m%d_%H%M%S)"
SAVE_PATH="${SAVE_ROOT}/${RUN_TAG}"

echo "vLLM endpoint: ${MODEL_ENDPOINT}"
echo "Detected model: ${MODEL_NAME}"
if [[ -n "${MODEL_MAX_LEN}" ]]; then
  echo "Reported max_model_len: ${MODEL_MAX_LEN}"
fi
echo "Required min model len: ${MIN_MODEL_LEN_RAW} (normalized=${MIN_MODEL_LEN})"
echo "Suite: ${SUITE}"
echo "Mode: ${MODE}"
echo "Policy: ${POLICY}"
echo "Profiles: ${PROFILES[*]}"
echo "Save path: ${SAVE_PATH}"

status=0
for suite_key in "${SUITES[@]}"; do
  BENCHMARK="$(suite_benchmark "${suite_key}")"
  read -r -a PROBLEMS <<<"$(suite_problems "${suite_key}")"

  for profile in "${PROFILES[@]}"; do
    LABEL="$(profile_label "${profile}")"
    CMD=("${PYTHON_BIN}" "scripts/run_backend.py")
    CMD+=("--backend" "revolution")
    CMD+=("--search_mode" "revolution_qd")
    CMD+=("--qd_archive_type" "cvt")
    CMD+=("--qd_descriptor_profile" "${profile}")
    CMD+=("--qd_num_cells" "${NUM_CELLS}")
    CMD+=("--qd_cvt_warmup_successes" "${WARMUP_SUCCESSES}")
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

    if [[ "${POLICY}" == "diff-heavy" ]]; then
      CMD+=("--qd_backfill_generation_mode" "diff")
      CMD+=("--qd_refine_generation_mode" "diff")
    else
      CMD+=("--qd_backfill_generation_mode" "whole")
      CMD+=("--qd_refine_generation_mode" "whole")
    fi

    echo
    echo "[${suite_key}/${LABEL}] command:"
    printf '  %q' timeout "${TIMEOUT_S}s" "${CMD[@]}"
    printf '\n'

    if [[ "${DRY_RUN}" == "1" ]]; then
      continue
    fi

    if ! timeout "${TIMEOUT_S}s" "${CMD[@]}"; then
      status=1
      echo "[${suite_key}/${LABEL}] smoke command failed or timed out." >&2
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

echo "Theory-grounded smoke matrix completed."
