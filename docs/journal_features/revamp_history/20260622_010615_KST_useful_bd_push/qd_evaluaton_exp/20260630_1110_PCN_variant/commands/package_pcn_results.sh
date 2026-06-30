#!/usr/bin/env bash
set -euo pipefail

stage="${1:-screen}"
export PCN_STAGE="$stage"
source "$(dirname "$0")/env.sh"

case "$PCN_STAGE" in
  long_20x10)
    stage_methods=("${LONG_20X10_METHODS[@]}")
    ;;
  long_10x20)
    stage_methods=("${LONG_10X20_METHODS[@]}")
    ;;
  *)
    stage_methods=("${METHODS[@]}")
    ;;
esac

completed_methods=()
for method in "${stage_methods[@]}"; do
  if [ -f "$LOG_ROOT/$PCN_STAGE.$method.done" ] && [ -d "$(method_run_dir "$method")" ]; then
    completed_methods+=("$method")
  fi
done

if [ "${#completed_methods[@]}" -eq 0 ]; then
  echo "no completed methods for stage $PCN_STAGE" >&2
  exit 1
fi

classic_method="${completed_methods[0]}"
if [[ "$classic_method" != classic_revolution* ]]; then
  echo "first completed method must be classic for packaging" >&2
  exit 1
fi

backend_args=()
for method in "${completed_methods[@]}"; do
  backend_args+=(--backend_run "$method=$(method_run_dir "$method")")
done

stage_analysis="$DOC_ROOT/analysis/$PCN_STAGE"
mkdir -p "$stage_analysis/completeness" "$DOC_ROOT/figures/$PCN_STAGE"

uv run python scripts/report_ppa_distribution.py \
  "${backend_args[@]}" \
  --subset-config "$SUBSET_CONFIG" \
  --output-dir "$stage_analysis/ppa_distribution"

uv run python scripts/report_pareto_analysis.py \
  "${backend_args[@]}" \
  --subset-config "$SUBSET_CONFIG" \
  --output-dir "$stage_analysis/pareto_analysis"

for method in "${completed_methods[@]}"; do
  [ "$method" = "$classic_method" ] && continue
  uv run python scripts/report_ppa_completeness.py \
    --ppa-candidates "$stage_analysis/ppa_distribution/data/ppa_candidates.csv" \
    --reference-ppa-metrics "$stage_analysis/ppa_distribution/data/reference_ppa_metrics.csv" \
    --problem-manifest "$MANIFEST_CSV" \
    --classic-method "$classic_method" \
    --qd-method "$method" \
    --manifest-references-complete \
    --output "$stage_analysis/completeness/$method.csv"
done

uv run python "$DOC_ROOT/tools/summarize_pcn_stage.py" \
  --doc-root "$DOC_ROOT" \
  --stage "$PCN_STAGE"

touch "$LOG_ROOT/$PCN_STAGE.package.done"
echo "[$(date -Is)] packaging finished for $PCN_STAGE"
