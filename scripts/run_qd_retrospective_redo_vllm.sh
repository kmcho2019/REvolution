#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/run_qd_retrospective_redo_vllm.sh [--preset refresh|follow-on|full] [--suite rtllm|verilogeval|matrix] [--dry-run]

Description:
  Runs a repeatable long-budget QD retrospective matrix against a live vLLM
  endpoint using the same four-design corpus used in /tmp/qd_rich20x5.

  The matrix is intended for long-budget follow-up runs after the descriptor
  and observability rollouts on feat/revolution-qd-map-elites.

Presets:
  refresh
    classic + implemented_structural_compact_3d grid + implemented_structural_fixed_5d CVT
  follow-on
    wire_ctrl_assign_3d grid + size_control_3d CVT + hybrid_phys_seq CVT + activity_control_3d grid
  full
    refresh + follow-on

Suites:
  rtllm
    Prob043_RAM, Prob045_alu
  verilogeval
    Prob153_gshare, Prob156_review2015_fancytimer
  matrix
    both suites

Environment overrides:
  VLLM_HOST                 vLLM host (default: host.docker.internal)
  VLLM_PORT                 vLLM port (default: 8000)
  REDO_MIN_MODEL_LEN        Required minimum served max_model_len (default: 128000, set 0 to disable)
  PYTHON_BIN                Python binary (default: <repo>/.venv/bin/python if present, else python3)
  REDO_SAVE_PATH            Base output directory (default: /tmp/qd_rich20x5_redo)
  REDO_BASELINE_ROOT        Baseline root for later comparison (default: /tmp/qd_rich20x5)
  REDO_POPULATION_SIZE      Population size (default: 20)
  REDO_NUM_GENERATIONS      Number of generations (default: 5)
  REDO_TOTAL_WORKER_SLOTS   Total worker-slot budget (default: 2)
  REDO_MAX_WORKERS_PER_PROBLEM Per-problem worker cap (default: 1)
  REDO_MAX_TOKENS           LLM max tokens (default: 128000)
  REDO_DIFF_MAX_TOKENS      Diff max tokens (default: REDO_MAX_TOKENS)
  REDO_TEMPERATURE          LLM temperature (default: 1.0)
  REDO_TOP_P                LLM top-p (default: 1.0)
  REDO_TIMEOUT_S            Per-command timeout in seconds (default: 0, disabled)
  REDO_NUM_CELLS            QD archive cells (default: 16)
  REDO_CVT_WARMUP           CVT warmup successes (default: 4)

Examples:
  scripts/run_qd_retrospective_redo_vllm.sh --dry-run
  scripts/run_qd_retrospective_redo_vllm.sh --preset follow-on --suite rtllm
  REDO_SAVE_PATH=/tmp/qd_redo scripts/run_qd_retrospective_redo_vllm.sh --preset full --suite matrix
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

PRESET="${REDO_PRESET:-follow-on}"
SUITE="${REDO_SUITE:-matrix}"
DRY_RUN="${DRY_RUN:-0}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --preset)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --preset" >&2
        exit 2
      fi
      PRESET="$2"
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

MIN_MODEL_LEN="${REDO_MIN_MODEL_LEN:-128000}"
MIN_MODEL_LEN_RAW="${MIN_MODEL_LEN}"
if ! MIN_MODEL_LEN="$(parse_model_len "${MIN_MODEL_LEN_RAW}")"; then
  echo "Warning: invalid REDO_MIN_MODEL_LEN='${MIN_MODEL_LEN_RAW}'. Disabling model-len gate." >&2
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

case "${PRESET}" in
  refresh|follow-on|full)
    ;;
  *)
    echo "Unsupported preset '${PRESET}'. Use refresh, follow-on, or full." >&2
    exit 2
    ;;
esac

POPULATION_SIZE="${REDO_POPULATION_SIZE:-20}"
NUM_GENERATIONS="${REDO_NUM_GENERATIONS:-5}"
TOTAL_WORKER_SLOTS="${REDO_TOTAL_WORKER_SLOTS:-2}"
MAX_WORKERS_PER_PROBLEM="${REDO_MAX_WORKERS_PER_PROBLEM:-1}"
MAX_TOKENS="${REDO_MAX_TOKENS:-128000}"
DIFF_MAX_TOKENS="${REDO_DIFF_MAX_TOKENS:-${MAX_TOKENS}}"
TEMPERATURE="${REDO_TEMPERATURE:-1.0}"
TOP_P="${REDO_TOP_P:-1.0}"
TIMEOUT_S="${REDO_TIMEOUT_S:-0}"
NUM_CELLS="${REDO_NUM_CELLS:-16}"
CVT_WARMUP="${REDO_CVT_WARMUP:-4}"
BASELINE_ROOT="${REDO_BASELINE_ROOT:-/tmp/qd_rich20x5}"
SAVE_ROOT="${REDO_SAVE_PATH:-/tmp/qd_rich20x5_redo}"
RUN_TAG="$(date +%Y%m%d_%H%M%S)"
SAVE_PATH="${SAVE_ROOT}/${RUN_TAG}"

declare -A BENCHMARK_BY_SUITE=(
  ["rtllm"]="RTLLM"
  ["verilogeval"]="VerilogEval-Spec-to-RTL"
)

declare -A PROBLEMS_BY_SUITE=(
  ["rtllm"]="Prob043_RAM Prob045_alu"
  ["verilogeval"]="Prob153_gshare Prob156_review2015_fancytimer"
)

mode_specs() {
  local preset="$1"
  case "${preset}" in
    refresh)
      cat <<'EOF'
classic|classic|revolution|na|na
grid_struct|grid_struct|revolution_qd|grid|implemented_structural_compact_3d
cvt_struct|cvt_struct|revolution_qd|cvt|implemented_structural_fixed_5d
EOF
      ;;
    follow-on)
      cat <<'EOF'
grid_wire_ctrl_assign|grid_wire_ctrl_assign|revolution_qd|grid|wire_ctrl_assign_3d
cvt_size_control|cvt_size_control|revolution_qd|cvt|size_control_3d
cvt_hybrid_phys|cvt_hybrid_phys|revolution_qd|cvt|hybrid_phys_seq
grid_activity_control|grid_activity_control|revolution_qd|grid|activity_control_3d
EOF
      ;;
    full)
      mode_specs refresh
      mode_specs follow-on
      ;;
  esac
}

echo "vLLM endpoint: ${MODEL_ENDPOINT}"
echo "Detected model: ${MODEL_NAME}"
if [[ -n "${MODEL_MAX_LEN}" ]]; then
  echo "Reported max_model_len: ${MODEL_MAX_LEN}"
fi
echo "Required min model len: ${MIN_MODEL_LEN_RAW} (normalized=${MIN_MODEL_LEN})"
echo "Preset: ${PRESET}"
echo "Suites: ${SUITES[*]}"
echo "Population size: ${POPULATION_SIZE}"
echo "Generations: ${NUM_GENERATIONS}"
echo "Total worker slots: ${TOTAL_WORKER_SLOTS}"
echo "Max workers per problem: ${MAX_WORKERS_PER_PROBLEM}"
echo "Baseline root: ${BASELINE_ROOT}"
echo "Save path: ${SAVE_PATH}"

mkdir -p "${SAVE_PATH}"
cat > "${SAVE_PATH}/redo_manifest.txt" <<EOF
baseline_root=${BASELINE_ROOT}
model_name=${MODEL_NAME}
reported_max_model_len=${MODEL_MAX_LEN}
preset=${PRESET}
suites=${SUITES[*]}
population_size=${POPULATION_SIZE}
num_generations=${NUM_GENERATIONS}
total_worker_slots=${TOTAL_WORKER_SLOTS}
max_workers_per_problem=${MAX_WORKERS_PER_PROBLEM}
max_tokens=${MAX_TOKENS}
diff_max_tokens=${DIFF_MAX_TOKENS}
temperature=${TEMPERATURE}
top_p=${TOP_P}
num_cells=${NUM_CELLS}
cvt_warmup=${CVT_WARMUP}
EOF

run_cmd() {
  local label="$1"
  shift
  echo "[${label}] command:"
  printf '  %q' "$@"
  printf '\n'
  if [[ "${DRY_RUN}" == "1" ]]; then
    return 0
  fi
  if [[ "${TIMEOUT_S}" =~ ^[0-9]+$ ]] && (( TIMEOUT_S > 0 )); then
    timeout "${TIMEOUT_S}s" "$@"
  else
    "$@"
  fi
}

status=0
for suite_name in "${SUITES[@]}"; do
  benchmark="${BENCHMARK_BY_SUITE[${suite_name}]}"
  read -r -a problems <<<"${PROBLEMS_BY_SUITE[${suite_name}]}"
  suite_root="${SAVE_PATH}/${suite_name}"
  mkdir -p "${suite_root}"
  declare -a backend_report_args=()

  while IFS='|' read -r mode_label backend_label search_mode archive_type descriptor_profile; do
    [[ -z "${mode_label}" ]] && continue
    mode_root="${suite_root}/${mode_label}"
    CMD=("${PYTHON_BIN}" "scripts/run_backend.py")
    CMD+=("--backend" "revolution")
    CMD+=("--search_mode" "${search_mode}")
    CMD+=("--benchmarks" "${benchmark}")
    CMD+=("--problems")
    CMD+=("${problems[@]}")
    CMD+=("--api_backend" "vllm")
    CMD+=("--vllm_host" "${VLLM_HOST}")
    CMD+=("--vllm_port" "${VLLM_PORT}")
    CMD+=("--vllm_min_model_len" "${MIN_MODEL_LEN}")
    CMD+=("--model_name" "${MODEL_NAME}")
    CMD+=("--population_size" "${POPULATION_SIZE}")
    CMD+=("--num_generations" "${NUM_GENERATIONS}")
    CMD+=("--total_worker_slots" "${TOTAL_WORKER_SLOTS}")
    CMD+=("--max_workers_per_problem" "${MAX_WORKERS_PER_PROBLEM}")
    CMD+=("--evaluation_mode" "search_accelerated")
    CMD+=("--accelerated_synthesis_top_k" "1")
    CMD+=("--temperature" "${TEMPERATURE}")
    CMD+=("--top_p" "${TOP_P}")
    CMD+=("--max_tokens" "${MAX_TOKENS}")
    CMD+=("--diff_max_tokens" "${DIFF_MAX_TOKENS}")
    CMD+=("--save_path" "${mode_root}")
    CMD+=("--no-backend_subdir")
    CMD+=("--seed" "42")

    if [[ "${search_mode}" == "revolution_qd" ]]; then
      CMD+=("--qd_archive_type" "${archive_type}")
      CMD+=("--qd_descriptor_profile" "${descriptor_profile}")
      if [[ "${archive_type}" == "cvt" ]]; then
        CMD+=("--qd_num_cells" "${NUM_CELLS}")
        CMD+=("--qd_cvt_warmup_successes" "${CVT_WARMUP}")
      fi
    fi

    if ! run_cmd "${suite_name}/${mode_label}" "${CMD[@]}"; then
      status=1
    fi

    backend_report_args+=("--backend_run" "${backend_label}=${mode_root}")
  done < <(mode_specs "${PRESET}")

  REPORT_CMD=(
    "${PYTHON_BIN}" "scripts/backend_comparison_report.py"
    "${backend_report_args[@]}"
    "--output" "${suite_root}/${suite_name}_backend_comparison.md"
  )
  if ! run_cmd "${suite_name}/report" "${REPORT_CMD[@]}"; then
    status=1
  fi
done

if [[ "${DRY_RUN}" == "1" ]]; then
  echo "Dry run enabled; commands were not executed."
fi

exit "${status}"
