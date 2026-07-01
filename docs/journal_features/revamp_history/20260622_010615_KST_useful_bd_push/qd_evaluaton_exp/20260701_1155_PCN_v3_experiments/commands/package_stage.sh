#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

wait_for_stage() {
  while true; do
    local pending=0
    for seed in "${ACTIVE_SEEDS[@]}"; do
      for method in "${ACTIVE_METHODS[@]}"; do
        if [ ! -f "$(log_file "seed_${seed}.${method}.done")" ] \
          && [ ! -f "$(log_file "seed_${seed}.${method}.failed")" ]; then
          pending=$((pending + 1))
        fi
      done
    done
    [ "$pending" -eq 0 ] && return
    echo "[$(date -Is)] waiting for $pending run(s)"
    sleep 300
  done
}

wait_for_stage

for seed in "${ACTIVE_SEEDS[@]}"; do
  backend_args=()
  for method in "${ACTIVE_METHODS[@]}"; do
    [ -f "$(log_file "seed_${seed}.${method}.done")" ] || continue
    [ -d "$(method_run_dir "$method" "$seed")" ] || continue
    backend_args+=(--backend_run "$method=$(method_run_dir "$method" "$seed")")
  done
  if [ "${#backend_args[@]}" -eq 0 ]; then
    echo "[$(date -Is)] no completed methods for seed=$seed"
    continue
  fi

  analysis="$DOC_ROOT/analysis/$EXP_STAGE/seed_$seed"
  mkdir -p "$analysis"

  uv run python scripts/report_ppa_distribution.py \
    "${backend_args[@]}" \
    --subset-config "$ACTIVE_SUBSET" \
    --output-dir "$analysis/reference_complete_ppa_distribution"

  uv run python scripts/report_pareto_analysis.py \
    "${backend_args[@]}" \
    --subset-config "$ACTIVE_SUBSET" \
    --output-dir "$analysis/reference_complete_pareto_analysis"

  uv run python "$DOC_ROOT/tools/audit_operator_contract.py" \
    --ppa-candidates "$analysis/reference_complete_ppa_distribution/data/ppa_candidates.csv" \
    --method-manifest "$DOC_ROOT/tables/method_manifest.csv" \
    --output "$analysis/operator_contract.csv"
done

uv run python "$DOC_ROOT/tools/summarize_pcn_v3_experiment.py" \
  --doc-root "$DOC_ROOT" \
  --stage "$EXP_STAGE"

touch "$(log_file package.done)"
echo "[$(date -Is)] packaging finished"
