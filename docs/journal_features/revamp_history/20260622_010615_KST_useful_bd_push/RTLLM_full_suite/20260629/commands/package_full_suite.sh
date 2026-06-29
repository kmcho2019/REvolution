#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

method_family() {
  case "$1" in
    classic_revolution_8x5) printf 'classic' ;;
    qwen_canonical_rtl_pca3_8x5) printf 'encoder' ;;
    masterrtl_rf_leafid_structural_delayed_8x5) printf 'encoder' ;;
    deepgate_delayed_high_exploit_8x5) printf 'encoder' ;;
    rf_deepgate_hybrid_delayed_8x5) printf 'encoder' ;;
    aurora_raw_impl_compact_delayed_8x5) printf 'learned_descriptor' ;;
    masterrtl_delayed_archive_activation_8x5) printf 'custom_qd' ;;
    fg_qdm_rf_leafid_front_credit_8x5) printf 'front_guarded_qd_memory' ;;
    *) echo "unknown method $1" >&2; return 1 ;;
  esac
}

wait_for_methods() {
  while true; do
    local pending=0
    for method in "${METHODS[@]}"; do
      if [ ! -f "$LOG_ROOT/$method.done" ] && [ ! -f "$LOG_ROOT/$method.failed" ]; then
        pending=$((pending + 1))
      fi
    done
    [ "$pending" -eq 0 ] && return
    echo "[$(date -Is)] waiting for $pending method(s)"
    sleep 300
  done
}

completed_methods() {
  for method in "${METHODS[@]}"; do
    [ -f "$LOG_ROOT/$method.done" ] && [ -d "$(method_run_dir "$method")" ] && echo "$method"
  done
}

wait_for_methods

mapfile -t completed < <(completed_methods)
if [[ " ${completed[*]} " != *" classic_revolution_8x5 "* ]]; then
  echo "classic_revolution_8x5 is required for packaging" >&2
  exit 1
fi

backend_args=()
for method in "${completed[@]}"; do
  backend_args+=(--backend_run "$method=$(method_run_dir "$method")")
done

mkdir -p "$DOC_ROOT/analysis/completeness"
mkdir -p "$DOC_ROOT/analysis/common_contract"
mkdir -p "$DOC_ROOT/visualizations/qd_ppa_viewers"

uv run python scripts/report_ppa_distribution.py \
  "${backend_args[@]}" \
  --subset-config "$FULL_SUBSET" \
  --output-dir "$DOC_ROOT/analysis/all_rtllm_ppa_distribution"

uv run python scripts/report_ppa_distribution.py \
  "${backend_args[@]}" \
  --subset-config "$REFERENCE_SUBSET" \
  --output-dir "$DOC_ROOT/analysis/reference_complete_ppa_distribution"

uv run python scripts/report_pareto_analysis.py \
  "${backend_args[@]}" \
  --subset-config "$REFERENCE_SUBSET" \
  --output-dir "$DOC_ROOT/analysis/reference_complete_pareto_analysis"

for method in "${QD_METHODS[@]}"; do
  [ -f "$LOG_ROOT/$method.done" ] || continue
  [ -d "$(method_run_dir "$method")" ] || continue

  completeness="$DOC_ROOT/analysis/completeness/$method.csv"
  uv run python scripts/report_ppa_completeness.py \
    --ppa-candidates "$DOC_ROOT/analysis/all_rtllm_ppa_distribution/data/ppa_candidates.csv" \
    --reference-ppa-metrics "$DOC_ROOT/analysis/all_rtllm_ppa_distribution/data/reference_ppa_metrics.csv" \
    --problem-manifest "$FULL_MANIFEST_CSV" \
    --classic-method classic_revolution_8x5 \
    --qd-method "$method" \
    --manifest-references-complete \
    "${REFERENCE_MISSING_ARGS[@]}" \
    --output "$completeness"

  viewer="$DOC_ROOT/visualizations/qd_ppa_viewers/$method"
  if uv run python scripts/export_qd_ppa_visualization.py \
    --run-root "$DOC_ROOT/visualizations/qd_ppa_viewer_sources/$method" \
    --backend_run "classic_revolution_8x5=$(method_run_dir classic_revolution_8x5)" \
    --backend_run "$method=$(method_run_dir "$method")" \
    --archive_source_backend "$method" \
    --subset-config "$REFERENCE_SUBSET" \
    --output-dir "$viewer" \
    --no-classic-descriptor-recovery \
    --strict; then
    if uv run python scripts/validate_qd_ppa_visualization.py \
      --viewer-root "$viewer" \
      --subset-config "$REFERENCE_SUBSET" \
      --strict; then
      if ! uv run python scripts/report_common_evaluation_contract.py \
        --viewer-root "$viewer" \
        --ppa-completeness "$completeness" \
        --pareto-problem-metrics "$DOC_ROOT/analysis/reference_complete_pareto_analysis/backend_problem_metrics.csv" \
        --backend-run "classic_revolution_8x5=$(method_run_dir classic_revolution_8x5)" \
        --backend-run "$method=$(method_run_dir "$method")" \
        --seed "$SEED" \
        --budget-shape 8x5 \
        --method-family "classic_revolution_8x5=classic" \
        --method-family "$method=$(method_family "$method")" \
        --output-dir "$DOC_ROOT/analysis/common_contract/$method"; then
        echo "[$(date -Is)] common contract failed for $method" \
          >> "$LOG_ROOT/package_viewer_failures.log"
      fi
    else
      echo "[$(date -Is)] viewer validation failed for $method" \
        >> "$LOG_ROOT/package_viewer_failures.log"
    fi
  else
    echo "[$(date -Is)] viewer export failed for $method" \
      >> "$LOG_ROOT/package_viewer_failures.log"
  fi
done

uv run python "$DOC_ROOT/tools/summarize_full_suite.py" \
  --doc-root "$DOC_ROOT"

touch "$LOG_ROOT/package.done"
echo "[$(date -Is)] packaging finished"
