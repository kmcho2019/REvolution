#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

method_family() {
  case "$1" in
    classic_revolution_8x5) printf 'classic' ;;
    qwen_canonical_rtl_pca3_eoh_8x5) printf 'encoder' ;;
    masterrtl_rf_leafid_structural_eoh_8x5) printf 'encoder' ;;
    deepgate_high_exploit_eoh_8x5) printf 'encoder' ;;
    rf_deepgate_hybrid_eoh_8x5) printf 'encoder' ;;
    aurora_raw_impl_compact_eoh_8x5) printf 'learned_descriptor' ;;
    masterrtl_archive_activation_eoh_8x5) printf 'custom_qd' ;;
    pcn_v3_rf_stagnation_memory_8x5) printf 'pcn_qd_memory' ;;
    *) echo "unknown method $1" >&2; return 1 ;;
  esac
}

wait_for_methods() {
  while true; do
    local pending=0
    for method in "${METHODS[@]}"; do
      if [ ! -f "$(log_file "$method.done")" ] && [ ! -f "$(log_file "$method.failed")" ]; then
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
    [ -f "$(log_file "$method.done")" ] && [ -d "$(method_run_dir "$method")" ] && echo "$method"
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

ANALYSIS_ROOT="$DOC_ROOT/analysis/$RUN_STAGE"
VIEWER_ROOT="$DOC_ROOT/visualizations/$RUN_STAGE/qd_ppa_viewers"
mkdir -p "$ANALYSIS_ROOT/completeness"
mkdir -p "$ANALYSIS_ROOT/common_contract"
mkdir -p "$VIEWER_ROOT"

uv run python scripts/report_ppa_distribution.py \
  "${backend_args[@]}" \
  --subset-config "$ACTIVE_FULL_SUBSET" \
  --output-dir "$ANALYSIS_ROOT/all_rtllm_ppa_distribution"

uv run python scripts/report_ppa_distribution.py \
  "${backend_args[@]}" \
  --subset-config "$ACTIVE_REFERENCE_SUBSET" \
  --output-dir "$ANALYSIS_ROOT/reference_complete_ppa_distribution"

uv run python scripts/report_pareto_analysis.py \
  "${backend_args[@]}" \
  --subset-config "$ACTIVE_REFERENCE_SUBSET" \
  --output-dir "$ANALYSIS_ROOT/reference_complete_pareto_analysis"

uv run python "$DOC_ROOT/tools/audit_operator_contract.py" \
  --ppa-candidates "$ANALYSIS_ROOT/reference_complete_ppa_distribution/data/ppa_candidates.csv" \
  --method-manifest "$DOC_ROOT/tables/method_manifest.csv" \
  --output "$ANALYSIS_ROOT/operator_contract.csv"

for method in "${QD_METHODS[@]}"; do
  [ -f "$(log_file "$method.done")" ] || continue
  [ -d "$(method_run_dir "$method")" ] || continue

  completeness="$ANALYSIS_ROOT/completeness/$method.csv"
  uv run python scripts/report_ppa_completeness.py \
    --ppa-candidates "$ANALYSIS_ROOT/all_rtllm_ppa_distribution/data/ppa_candidates.csv" \
    --reference-ppa-metrics "$ANALYSIS_ROOT/all_rtllm_ppa_distribution/data/reference_ppa_metrics.csv" \
    --problem-manifest "$ACTIVE_FULL_MANIFEST_CSV" \
    --classic-method classic_revolution_8x5 \
    --qd-method "$method" \
    --manifest-references-complete \
    "${ACTIVE_REFERENCE_MISSING_ARGS[@]}" \
    --output "$completeness"

  viewer="$VIEWER_ROOT/$method"
  if uv run python scripts/export_qd_ppa_visualization.py \
    --run-root "$DOC_ROOT/visualizations/$RUN_STAGE/qd_ppa_viewer_sources/$method" \
    --backend_run "classic_revolution_8x5=$(method_run_dir classic_revolution_8x5)" \
    --backend_run "$method=$(method_run_dir "$method")" \
    --archive_source_backend "$method" \
    --subset-config "$ACTIVE_REFERENCE_SUBSET" \
    --output-dir "$viewer" \
    --no-classic-descriptor-recovery \
    --strict; then
    if uv run python scripts/validate_qd_ppa_visualization.py \
      --viewer-root "$viewer" \
      --subset-config "$ACTIVE_REFERENCE_SUBSET" \
      --strict; then
      if ! uv run python scripts/report_common_evaluation_contract.py \
        --viewer-root "$viewer" \
        --ppa-completeness "$completeness" \
        --pareto-problem-metrics "$ANALYSIS_ROOT/reference_complete_pareto_analysis/backend_problem_metrics.csv" \
        --backend-run "classic_revolution_8x5=$(method_run_dir classic_revolution_8x5)" \
        --backend-run "$method=$(method_run_dir "$method")" \
        --seed "$SEED" \
        --budget-shape 8x5 \
        --method-family "classic_revolution_8x5=classic" \
        --method-family "$method=$(method_family "$method")" \
        --output-dir "$ANALYSIS_ROOT/common_contract/$method"; then
        echo "[$(date -Is)] common contract failed for $method" \
          >> "$(log_file package_viewer_failures.log)"
      fi
    else
      echo "[$(date -Is)] viewer validation failed for $method" \
        >> "$(log_file package_viewer_failures.log)"
    fi
  else
    echo "[$(date -Is)] viewer export failed for $method" \
      >> "$(log_file package_viewer_failures.log)"
  fi
done

uv run python "$DOC_ROOT/tools/summarize_full_suite.py" \
  --doc-root "$DOC_ROOT" \
  --stage "$RUN_STAGE"

touch "$(log_file package.done)"
echo "[$(date -Is)] packaging finished"
