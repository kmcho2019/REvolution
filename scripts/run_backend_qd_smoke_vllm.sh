#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/run_backend_qd_smoke_vllm.sh [--archive grid|cvt|matrix] [--suite rtllm|verilogeval] [--policy whole-heavy|diff-heavy] [--dry-run]

Description:
  Runs a small REvolution QD smoke matrix against a live vLLM endpoint.
  The script auto-detects the served model from /v1/models and uses a small,
  deterministic problem budget intended for faster smoke validation than the
  paper-grade long-context runs.

Environment overrides:
  VLLM_HOST                 vLLM host (default: host.docker.internal)
  VLLM_PORT                 vLLM port (default: 8000)
  SMOKE_MIN_MODEL_LEN       Required minimum served max_model_len (default: 128000, set 0 to disable)
  PYTHON_BIN                Python binary (default: <repo>/.venv/bin/python if present, else python3)
  SMOKE_PROBLEMS            Space-separated problem IDs (overrides suite defaults)
  SMOKE_MAX_TOKENS          LLM max tokens (default: 128000)
  SMOKE_DIFF_MAX_TOKENS     Diff max tokens (default: SMOKE_MAX_TOKENS)
  SMOKE_TEMPERATURE         LLM temperature (default: 0.3)
  SMOKE_TOP_P               LLM top-p (default: 0.95)
  SMOKE_SAVE_PATH           Base output directory (default: <repo>/exp/revolution_qd_smoke)
  SMOKE_TIMEOUT_S           Per-command timeout in seconds (default: 180)

Examples:
  scripts/run_backend_qd_smoke_vllm.sh --dry-run
  scripts/run_backend_qd_smoke_vllm.sh --archive grid --suite verilogeval
  scripts/run_backend_qd_smoke_vllm.sh --archive matrix --policy diff-heavy
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

ARCHIVE="${SMOKE_ARCHIVE:-matrix}"
SUITE="${SMOKE_SUITE:-verilogeval}"
POLICY="${SMOKE_POLICY:-whole-heavy}"
DRY_RUN="${DRY_RUN:-0}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --archive)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --archive" >&2
        exit 2
      fi
      ARCHIVE="$2"
      shift 2
      ;;
    --suite)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --suite" >&2
        exit 2
      fi
      SUITE="$2"
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
    exit 1
  fi
fi

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  export OPENAI_API_KEY="vllm-local-placeholder"
  echo "OPENAI_API_KEY was not set; exported placeholder for local vLLM compatibility."
fi

case "${SUITE}" in
  rtllm)
    BENCHMARK="RTLLM"
    DEFAULT_PROBLEMS=("Prob001_accu")
    DEFAULT_GRID_AXES=("g_A" "g_T")
    DEFAULT_CVT_AXES=("g_A" "g_T")
    ;;
  verilogeval|verilogevalv2|ve2)
    BENCHMARK="VerilogEval-Spec-to-RTL"
    DEFAULT_PROBLEMS=("Prob001_zero")
    DEFAULT_GRID_AXES=("g_A" "g_P")
    DEFAULT_CVT_AXES=("g_A" "g_P")
    ;;
  *)
    echo "Unsupported suite '${SUITE}'. Use rtllm or verilogeval." >&2
    exit 2
    ;;
esac

if [[ -n "${SMOKE_PROBLEMS:-}" ]]; then
  read -r -a PROBLEMS <<<"${SMOKE_PROBLEMS}"
else
  PROBLEMS=("${DEFAULT_PROBLEMS[@]}")
fi

case "${ARCHIVE}" in
  grid)
    ARCHIVES=("grid")
    ;;
  cvt)
    ARCHIVES=("cvt")
    ;;
  matrix)
    ARCHIVES=("grid" "cvt")
    ;;
  *)
    echo "Unsupported archive '${ARCHIVE}'. Use grid, cvt, or matrix." >&2
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

MAX_TOKENS="${SMOKE_MAX_TOKENS:-128000}"
DIFF_MAX_TOKENS="${SMOKE_DIFF_MAX_TOKENS:-${MAX_TOKENS}}"
TEMPERATURE="${SMOKE_TEMPERATURE:-0.3}"
TOP_P="${SMOKE_TOP_P:-0.95}"
TIMEOUT_S="${SMOKE_TIMEOUT_S:-180}"
SAVE_ROOT="${SMOKE_SAVE_PATH:-${REPO_ROOT}/exp/revolution_qd_smoke}"
RUN_TAG="$(date +%Y%m%d_%H%M%S)"
SAVE_PATH="${SAVE_ROOT}/${RUN_TAG}"

echo "vLLM endpoint: ${MODEL_ENDPOINT}"
echo "Detected model: ${MODEL_NAME}"
if [[ -n "${MODEL_MAX_LEN}" ]]; then
  echo "Reported max_model_len: ${MODEL_MAX_LEN}"
fi
echo "Required min model len: ${MIN_MODEL_LEN_RAW} (normalized=${MIN_MODEL_LEN})"
echo "Suite: ${SUITE}"
echo "Policy: ${POLICY}"
echo "Archives: ${ARCHIVES[*]}"
echo "Problems: ${PROBLEMS[*]}"
echo "Save path: ${SAVE_PATH}"

status=0
for archive_type in "${ARCHIVES[@]}"; do
  CMD=("${PYTHON_BIN}" "scripts/run_backend.py")
  CMD+=("--backend" "revolution")
  CMD+=("--search_mode" "revolution_qd")
  CMD+=("--qd_archive_type" "${archive_type}")
  CMD+=("--benchmarks" "${BENCHMARK}")
  CMD+=("--problems")
  CMD+=("${PROBLEMS[@]}")
  CMD+=("--api_backend" "vllm")
  CMD+=("--vllm_host" "${VLLM_HOST}")
  CMD+=("--vllm_port" "${VLLM_PORT}")
  CMD+=("--vllm_min_model_len" "${MIN_MODEL_LEN}")
  CMD+=("--model_name" "${MODEL_NAME}")
  CMD+=("--population_size" "1")
  CMD+=("--num_generations" "0")
  CMD+=("--num_workers" "1")
  CMD+=("--candidate_workers" "0")
  CMD+=("--evaluation_mode" "strict_ablation")
  CMD+=("--temperature" "${TEMPERATURE}")
  CMD+=("--top_p" "${TOP_P}")
  CMD+=("--max_tokens" "${MAX_TOKENS}")
  CMD+=("--diff_max_tokens" "${DIFF_MAX_TOKENS}")
  CMD+=("--save_path" "${SAVE_PATH}/${archive_type}")
  CMD+=("--no-backend_subdir")
  CMD+=("--seed" "42")

  if [[ "${archive_type}" == "grid" ]]; then
    CMD+=("--qd_grid_axes")
    CMD+=("${DEFAULT_GRID_AXES[@]}")
  else
    CMD+=("--qd_cvt_axes")
    CMD+=("${DEFAULT_CVT_AXES[@]}")
    CMD+=("--qd_num_cells" "4")
    CMD+=("--qd_cvt_warmup_successes" "1")
  fi

  if [[ "${POLICY}" == "diff-heavy" ]]; then
    CMD+=("--qd_backfill_generation_mode" "diff")
    CMD+=("--qd_refine_generation_mode" "diff")
  else
    CMD+=("--qd_backfill_generation_mode" "whole")
    CMD+=("--qd_refine_generation_mode" "whole")
  fi

  echo
  echo "[${archive_type}] command:"
  printf '  %q' timeout "${TIMEOUT_S}s" "${CMD[@]}"
  printf '\n'

  if [[ "${DRY_RUN}" == "1" ]]; then
    continue
  fi

  if ! timeout "${TIMEOUT_S}s" "${CMD[@]}"; then
    status=1
    echo "[${archive_type}] smoke command failed or timed out." >&2
  fi
done

if [[ "${DRY_RUN}" == "1" ]]; then
  echo "Dry run enabled; commands were not executed."
  exit 0
fi

if (( status != 0 )); then
  exit "${status}"
fi

echo "QD smoke matrix completed."
