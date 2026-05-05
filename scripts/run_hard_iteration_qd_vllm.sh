#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/run_hard_iteration_qd_vllm.sh [--config path] [--mode classic|grid_struct|cvt_struct|cvt_size_control|cvt_theory_grounded|cvt_theory_grounded_compact|matrix] [--dry-run]

Description:
  Run the hard-iteration benchmark subset against classic REvolution and the
  recommended QD variants on a live vLLM endpoint.

Environment overrides:
  HARD_SUBSET_VLLM_HOST         vLLM host override (defaults to config value)
  HARD_SUBSET_VLLM_PORT         vLLM port override (defaults to config value)
  HARD_SUBSET_MIN_MODEL_LEN     Required minimum served max_model_len (default: 128000, set 0 to disable)
  HARD_SUBSET_SAVE_PATH         Base output directory (default: <repo>/exp/hard_iteration_qd)
  HARD_SUBSET_TIMEOUT_S         Per-command timeout in seconds (default: 0, disabled)
  HARD_SUBSET_SEED              Seed override (defaults to config value)
  HARD_SUBSET_TOTAL_WORKER_SLOTS Total worker-slot override (defaults to config value)
  HARD_SUBSET_MAX_ACTIVE_PROBLEMS Active problem cap override (defaults to config value)
  HARD_SUBSET_MAX_WORKERS_PER_PROBLEM Per-problem worker cap override (defaults to config value)
  HARD_SUBSET_POPULATION_SIZE   Population size override (defaults to config value)
  HARD_SUBSET_NUM_GENERATIONS   Generation count override (defaults to config value)
  HARD_SUBSET_MAX_TOKENS        Max token override (defaults to config value)
  HARD_SUBSET_DIFF_MAX_TOKENS   Diff max token override (defaults to config value)
  HARD_SUBSET_TEMPERATURE       Temperature override (defaults to config value)
  HARD_SUBSET_TOP_P             Top-p override (defaults to config value)
  HARD_SUBSET_NUM_CELLS         CVT cell override (defaults to config value)
  HARD_SUBSET_CVT_WARMUP        CVT warmup override (defaults to config value)
  HARD_SUBSET_GRID_QUANTILE_WARMUP Grid-quantile warmup override (defaults to config value)
  HARD_SUBSET_QD_FILL_TARGET_FRACTION QD fill-target override (defaults to config value)
  HARD_SUBSET_QD_CELL_RESERVOIR QD per-cell reservoir override (defaults to config value)
  PYTHON_BIN                    Python binary (default: <repo>/.venv/bin/python if present, else python3)

Examples:
  scripts/run_hard_iteration_qd_vllm.sh --dry-run
  scripts/run_hard_iteration_qd_vllm.sh --mode cvt_struct
  scripts/run_hard_iteration_qd_vllm.sh --config data/configs/hard_iteration_subset.yaml --mode matrix
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

CONFIG_PATH="${HARD_SUBSET_CONFIG:-${REPO_ROOT}/data/configs/hard_iteration_subset.yaml}"
MODE="${HARD_SUBSET_MODE:-matrix}"
DRY_RUN="${DRY_RUN:-0}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --config" >&2
        exit 2
      fi
      CONFIG_PATH="$2"
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

if [[ ! -f "${CONFIG_PATH}" ]]; then
  echo "Config file not found: ${CONFIG_PATH}" >&2
  exit 1
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

eval "$("${PYTHON_BIN}" - <<'PY' "${CONFIG_PATH}"
from __future__ import annotations

import shlex
import sys

import yaml


def emit_scalar(name: str, value: object) -> None:
    print(f"{name}={shlex.quote(str(value))}")


def emit_array(name: str, values: list[object]) -> None:
    quoted = " ".join(shlex.quote(str(value)) for value in values)
    print(f"{name}=({quoted})")


config_path = sys.argv[1]
with open(config_path, "r", encoding="utf-8") as handle:
    cfg = yaml.safe_load(handle)

model = cfg["model"]
defaults = cfg["matrix_defaults"]
benchmarks = list(cfg["benchmarks"].keys())
problems = [entry["problem"] for entry in cfg["selected_problems"]]
configured_mode_names = list(cfg["modes"].keys())
matrix_modes = list(
    cfg.get(
        "matrix_modes",
        ["classic", "grid_struct", "cvt_struct", "cvt_size_control"],
    )
)

emit_scalar("CONFIG_SUBSET_NAME", cfg.get("subset_name", "hard_iteration_subset"))
emit_scalar("CONFIG_MODEL_NAME", model["model_name"])
emit_scalar("CONFIG_VLLM_HOST", model.get("vllm_host", "host.docker.internal"))
emit_scalar("CONFIG_VLLM_PORT", model.get("vllm_port", 8000))
emit_scalar("CONFIG_API_BACKEND", model.get("api_backend", "vllm"))
emit_scalar("CONFIG_POPULATION_SIZE", defaults["population_size"])
emit_scalar("CONFIG_NUM_GENERATIONS", defaults["num_generations"])
emit_scalar("CONFIG_EVALUATION_MODE", defaults["evaluation_mode"])
emit_scalar(
    "CONFIG_ACCELERATED_SYNTHESIS_TOP_K",
    defaults["accelerated_synthesis_top_k"],
)
total_worker_slots = defaults.get("total_worker_slots")
if total_worker_slots is None:
    total_worker_slots = defaults.get("num_workers")
    if total_worker_slots is not None:
        print(
            "[parallelism] WARNING: hard-subset config key 'num_workers' is deprecated. "
            f"Translated it to 'total_worker_slots={total_worker_slots}'.",
            file=sys.stderr,
        )
if total_worker_slots is None:
    raise KeyError("matrix_defaults.total_worker_slots is required")

max_active_problems = defaults.get("max_active_problems", total_worker_slots)
max_workers_per_problem = defaults.get("max_workers_per_problem")
if max_workers_per_problem is None:
    legacy_candidate_workers = defaults.get("candidate_workers")
    if legacy_candidate_workers is not None:
        max_workers_per_problem = max(1, int(legacy_candidate_workers))
        print(
            "[parallelism] WARNING: hard-subset config key 'candidate_workers' is deprecated. "
            f"Translated it to 'max_workers_per_problem={max_workers_per_problem}'.",
            file=sys.stderr,
        )
    else:
        max_workers_per_problem = total_worker_slots

emit_scalar("CONFIG_TOTAL_WORKER_SLOTS", total_worker_slots)
emit_scalar("CONFIG_MAX_ACTIVE_PROBLEMS", max_active_problems)
emit_scalar("CONFIG_MAX_WORKERS_PER_PROBLEM", max_workers_per_problem)
emit_scalar("CONFIG_TEMPERATURE", defaults["temperature"])
emit_scalar("CONFIG_TOP_P", defaults["top_p"])
emit_scalar("CONFIG_MAX_TOKENS", defaults["max_tokens"])
emit_scalar("CONFIG_DIFF_MAX_TOKENS", defaults["diff_max_tokens"])
emit_scalar("CONFIG_QD_NUM_CELLS", defaults["qd_num_cells"])
emit_scalar("CONFIG_QD_CVT_WARMUP", defaults["qd_cvt_warmup_successes"])
emit_scalar("CONFIG_QD_GRID_QUANTILE_WARMUP", defaults.get("qd_grid_quantile_warmup_successes", 20))
emit_scalar("CONFIG_QD_FILL_TARGET_FRACTION", defaults.get("qd_fill_target_fraction", 0.25))
emit_scalar("CONFIG_QD_CELL_RESERVOIR", defaults.get("qd_cell_reservoir", 2))
emit_scalar("CONFIG_SEED", defaults["seed"])
emit_array("CONFIG_BENCHMARKS", benchmarks)
emit_array("CONFIG_PROBLEMS", problems)
emit_array("CONFIG_MODE_NAMES", configured_mode_names)
emit_array("CONFIG_MATRIX_MODES", matrix_modes)

for mode_name, mode_cfg in cfg["modes"].items():
    prefix = f"MODE_{mode_name.upper()}"
    emit_scalar(f"{prefix}_SEARCH_MODE", mode_cfg["search_mode"])
    emit_scalar(f"{prefix}_QD_ARCHIVE_TYPE", mode_cfg.get("qd_archive_type", ""))
    emit_scalar(
        f"{prefix}_QD_DESCRIPTOR_PROFILE",
        mode_cfg.get("qd_descriptor_profile", ""),
    )
    emit_scalar(f"{prefix}_QD_NUM_CELLS", mode_cfg.get("qd_num_cells", ""))
    emit_scalar(
        f"{prefix}_QD_CVT_WARMUP",
        mode_cfg.get("qd_cvt_warmup_successes", ""),
    )
    emit_scalar(
        f"{prefix}_QD_GRID_QUANTILE_WARMUP",
        mode_cfg.get("qd_grid_quantile_warmup_successes", ""),
    )
    emit_scalar(
        f"{prefix}_QD_FILL_TARGET_FRACTION",
        mode_cfg.get("qd_fill_target_fraction", ""),
    )
    emit_scalar(
        f"{prefix}_QD_CELL_RESERVOIR",
        mode_cfg.get("qd_cell_reservoir", ""),
    )
PY
)"

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

VLLM_HOST="${HARD_SUBSET_VLLM_HOST:-${CONFIG_VLLM_HOST}}"
VLLM_PORT="${HARD_SUBSET_VLLM_PORT:-${CONFIG_VLLM_PORT}}"
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
MODEL_NAME="${MODEL_INFO[0]:-${CONFIG_MODEL_NAME}}"
MODEL_MAX_LEN="${MODEL_INFO[1]:-}"

if [[ -z "${MODEL_NAME}" ]]; then
  echo "No model id found from ${MODEL_ENDPOINT}." >&2
  exit 1
fi

MIN_MODEL_LEN="${HARD_SUBSET_MIN_MODEL_LEN:-128000}"
MIN_MODEL_LEN_RAW="${MIN_MODEL_LEN}"
if ! MIN_MODEL_LEN="$(parse_model_len "${MIN_MODEL_LEN_RAW}")"; then
  echo "Warning: invalid HARD_SUBSET_MIN_MODEL_LEN='${MIN_MODEL_LEN_RAW}'. Disabling model-len gate." >&2
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
fi

mode_in_config=0
for configured_mode in "${CONFIG_MODE_NAMES[@]}"; do
  if [[ "${MODE}" == "${configured_mode}" ]]; then
    mode_in_config=1
    break
  fi
done

if [[ "${MODE}" == "matrix" ]]; then
  MODES=("${CONFIG_MATRIX_MODES[@]}")
elif (( mode_in_config == 1 )); then
  MODES=("${MODE}")
else
  echo "Unsupported mode '${MODE}'. Use one of: matrix ${CONFIG_MODE_NAMES[*]}" >&2
  exit 2
fi

POPULATION_SIZE="${HARD_SUBSET_POPULATION_SIZE:-${CONFIG_POPULATION_SIZE}}"
NUM_GENERATIONS="${HARD_SUBSET_NUM_GENERATIONS:-${CONFIG_NUM_GENERATIONS}}"
TOTAL_WORKER_SLOTS="${HARD_SUBSET_TOTAL_WORKER_SLOTS:-${CONFIG_TOTAL_WORKER_SLOTS}}"
MAX_ACTIVE_PROBLEMS="${HARD_SUBSET_MAX_ACTIVE_PROBLEMS:-${CONFIG_MAX_ACTIVE_PROBLEMS}}"
MAX_WORKERS_PER_PROBLEM="${HARD_SUBSET_MAX_WORKERS_PER_PROBLEM:-${CONFIG_MAX_WORKERS_PER_PROBLEM}}"
TEMPERATURE="${HARD_SUBSET_TEMPERATURE:-${CONFIG_TEMPERATURE}}"
TOP_P="${HARD_SUBSET_TOP_P:-${CONFIG_TOP_P}}"
MAX_TOKENS="${HARD_SUBSET_MAX_TOKENS:-${CONFIG_MAX_TOKENS}}"
DIFF_MAX_TOKENS="${HARD_SUBSET_DIFF_MAX_TOKENS:-${CONFIG_DIFF_MAX_TOKENS}}"
NUM_CELLS="${HARD_SUBSET_NUM_CELLS:-${CONFIG_QD_NUM_CELLS}}"
CVT_WARMUP="${HARD_SUBSET_CVT_WARMUP:-${CONFIG_QD_CVT_WARMUP}}"
GRID_QUANTILE_WARMUP="${HARD_SUBSET_GRID_QUANTILE_WARMUP:-${CONFIG_QD_GRID_QUANTILE_WARMUP}}"
QD_FILL_TARGET_FRACTION="${HARD_SUBSET_QD_FILL_TARGET_FRACTION:-${CONFIG_QD_FILL_TARGET_FRACTION}}"
QD_CELL_RESERVOIR="${HARD_SUBSET_QD_CELL_RESERVOIR:-${CONFIG_QD_CELL_RESERVOIR}}"
SEED="${HARD_SUBSET_SEED:-${CONFIG_SEED}}"
TIMEOUT_S="${HARD_SUBSET_TIMEOUT_S:-0}"
SAVE_ROOT="${HARD_SUBSET_SAVE_PATH:-${REPO_ROOT}/exp/hard_iteration_qd}"
RUN_TAG="$(date +%Y%m%d_%H%M%S)"
SAVE_PATH="${SAVE_ROOT}/${RUN_TAG}"
mkdir -p "${SAVE_PATH}"

cat > "${SAVE_PATH}/hard_iteration_manifest.txt" <<EOF
config_path=${CONFIG_PATH}
subset_name=${CONFIG_SUBSET_NAME}
mode=${MODE}
model_name=${MODEL_NAME}
reported_max_model_len=${MODEL_MAX_LEN}
benchmarks=${CONFIG_BENCHMARKS[*]}
problems=${CONFIG_PROBLEMS[*]}
population_size=${POPULATION_SIZE}
num_generations=${NUM_GENERATIONS}
total_worker_slots=${TOTAL_WORKER_SLOTS}
max_active_problems=${MAX_ACTIVE_PROBLEMS}
max_workers_per_problem=${MAX_WORKERS_PER_PROBLEM}
temperature=${TEMPERATURE}
top_p=${TOP_P}
max_tokens=${MAX_TOKENS}
diff_max_tokens=${DIFF_MAX_TOKENS}
qd_num_cells=${NUM_CELLS}
qd_cvt_warmup_successes=${CVT_WARMUP}
qd_grid_quantile_warmup_successes=${GRID_QUANTILE_WARMUP}
qd_fill_target_fraction=${QD_FILL_TARGET_FRACTION}
qd_cell_reservoir=${QD_CELL_RESERVOIR}
seed=${SEED}
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

echo "Config: ${CONFIG_PATH}"
echo "Subset: ${CONFIG_SUBSET_NAME}"
echo "vLLM endpoint: ${MODEL_ENDPOINT}"
echo "Detected model: ${MODEL_NAME}"
if [[ -n "${MODEL_MAX_LEN}" ]]; then
  echo "Reported max_model_len: ${MODEL_MAX_LEN}"
fi
echo "Benchmarks: ${CONFIG_BENCHMARKS[*]}"
echo "Problems: ${CONFIG_PROBLEMS[*]}"
echo "Modes: ${MODES[*]}"
echo "Save path: ${SAVE_PATH}"

status=0
declare -a backend_report_args=()
for mode_name in "${MODES[@]}"; do
  upper_mode="${mode_name^^}"
  search_mode_var="MODE_${upper_mode}_SEARCH_MODE"
  archive_type_var="MODE_${upper_mode}_QD_ARCHIVE_TYPE"
  descriptor_profile_var="MODE_${upper_mode}_QD_DESCRIPTOR_PROFILE"
  mode_num_cells_var="MODE_${upper_mode}_QD_NUM_CELLS"
  mode_cvt_warmup_var="MODE_${upper_mode}_QD_CVT_WARMUP"
  mode_grid_quantile_warmup_var="MODE_${upper_mode}_QD_GRID_QUANTILE_WARMUP"
  mode_fill_target_var="MODE_${upper_mode}_QD_FILL_TARGET_FRACTION"
  mode_cell_reservoir_var="MODE_${upper_mode}_QD_CELL_RESERVOIR"

  search_mode="${!search_mode_var}"
  archive_type="${!archive_type_var}"
  descriptor_profile="${!descriptor_profile_var}"
  resolved_num_cells="${!mode_num_cells_var}"
  resolved_cvt_warmup="${!mode_cvt_warmup_var}"
  resolved_grid_quantile_warmup="${!mode_grid_quantile_warmup_var}"
  resolved_fill_target="${!mode_fill_target_var}"
  resolved_cell_reservoir="${!mode_cell_reservoir_var}"
  if [[ -z "${resolved_num_cells}" ]]; then
    resolved_num_cells="${NUM_CELLS}"
  fi
  if [[ -z "${resolved_cvt_warmup}" ]]; then
    resolved_cvt_warmup="${CVT_WARMUP}"
  fi
  if [[ -z "${resolved_grid_quantile_warmup}" ]]; then
    resolved_grid_quantile_warmup="${GRID_QUANTILE_WARMUP}"
  fi
  if [[ -z "${resolved_fill_target}" ]]; then
    resolved_fill_target="${QD_FILL_TARGET_FRACTION}"
  fi
  if [[ -z "${resolved_cell_reservoir}" ]]; then
    resolved_cell_reservoir="${QD_CELL_RESERVOIR}"
  fi
  mode_root="${SAVE_PATH}/${mode_name}"

  {
    echo "mode.${mode_name}.search_mode=${search_mode}"
    echo "mode.${mode_name}.qd_archive_type=${archive_type}"
    echo "mode.${mode_name}.qd_descriptor_profile=${descriptor_profile}"
    echo "mode.${mode_name}.qd_num_cells=${resolved_num_cells}"
    echo "mode.${mode_name}.qd_cvt_warmup_successes=${resolved_cvt_warmup}"
    echo "mode.${mode_name}.qd_grid_quantile_warmup_successes=${resolved_grid_quantile_warmup}"
    echo "mode.${mode_name}.qd_fill_target_fraction=${resolved_fill_target}"
    echo "mode.${mode_name}.qd_cell_reservoir=${resolved_cell_reservoir}"
  } >> "${SAVE_PATH}/hard_iteration_manifest.txt"

  CMD=("${PYTHON_BIN}" "scripts/run_backend.py")
  CMD+=("--backend" "revolution")
  CMD+=("--search_mode" "${search_mode}")
  CMD+=("--benchmarks")
  CMD+=("${CONFIG_BENCHMARKS[@]}")
  CMD+=("--problems")
  CMD+=("${CONFIG_PROBLEMS[@]}")
  CMD+=("--api_backend" "${CONFIG_API_BACKEND}")
  CMD+=("--vllm_host" "${VLLM_HOST}")
  CMD+=("--vllm_port" "${VLLM_PORT}")
  CMD+=("--vllm_min_model_len" "${MIN_MODEL_LEN}")
  CMD+=("--model_name" "${MODEL_NAME}")
  CMD+=("--population_size" "${POPULATION_SIZE}")
  CMD+=("--num_generations" "${NUM_GENERATIONS}")
  CMD+=("--total_worker_slots" "${TOTAL_WORKER_SLOTS}")
  CMD+=("--max_active_problems" "${MAX_ACTIVE_PROBLEMS}")
  CMD+=("--max_workers_per_problem" "${MAX_WORKERS_PER_PROBLEM}")
  CMD+=("--evaluation_mode" "${CONFIG_EVALUATION_MODE}")
  CMD+=("--accelerated_synthesis_top_k" "${CONFIG_ACCELERATED_SYNTHESIS_TOP_K}")
  CMD+=("--temperature" "${TEMPERATURE}")
  CMD+=("--top_p" "${TOP_P}")
  CMD+=("--max_tokens" "${MAX_TOKENS}")
  CMD+=("--diff_max_tokens" "${DIFF_MAX_TOKENS}")
  CMD+=("--save_path" "${mode_root}")
  CMD+=("--no-backend_subdir")
  CMD+=("--seed" "${SEED}")

  if [[ "${search_mode}" == "revolution_qd" ]]; then
    CMD+=("--qd_archive_type" "${archive_type}")
    CMD+=("--qd_descriptor_profile" "${descriptor_profile}")
    CMD+=("--qd_num_cells" "${resolved_num_cells}")
    CMD+=("--qd_fill_target_fraction" "${resolved_fill_target}")
    CMD+=("--qd_cell_reservoir" "${resolved_cell_reservoir}")
    if [[ "${archive_type}" == "cvt" ]]; then
      CMD+=("--qd_cvt_warmup_successes" "${resolved_cvt_warmup}")
    fi
    if [[ "${archive_type}" == "grid_quantile" ]]; then
      CMD+=("--qd_grid_quantile_warmup_successes" "${resolved_grid_quantile_warmup}")
    fi
  fi

  if ! run_cmd "${mode_name}" "${CMD[@]}"; then
    status=1
  fi
  backend_report_args+=("--backend_run" "${mode_name}=${mode_root}")
done

REPORT_CMD=(
  "${PYTHON_BIN}" "scripts/backend_comparison_report.py"
  "${backend_report_args[@]}"
  "--output" "${SAVE_PATH}/hard_iteration_backend_comparison.md"
)
if ! run_cmd "report" "${REPORT_CMD[@]}"; then
  status=1
fi

if [[ "${DRY_RUN}" == "1" ]]; then
  echo "Dry run enabled; commands were not executed."
fi

exit "${status}"
