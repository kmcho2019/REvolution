# T79 Live Budget-Shape V0 Commands

Status: pre-registered; do not change after reading any T79 live outcome.

Run from `/workspace`.

## Storage And Endpoint Preflight

```bash
df -h /workspace
df -ih /workspace

RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t79_budget_shape_ablation_${RUN_TS}/live"
mkdir -p "${RUN_ROOT}/preflight"
mkdir -p "${RUN_ROOT}/logs"

curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"

uv run python - "${RUN_ROOT}/preflight/models_${RUN_TS}.json" \
  > "${RUN_ROOT}/preflight/models_summary_${RUN_TS}.txt" <<'PY'
import json
import sys

payload = json.load(open(sys.argv[1], encoding="utf-8"))
for model in payload["data"]:
    print(f"{model['id']} max_model_len={model.get('max_model_len')}")
PY
```

Required line:

```text
openai/gpt-oss-120b max_model_len=131072
```

## Common Arguments

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src

COMMON_ARGS=(
  --backend revolution
  --benchmarks RTLLM VerilogEval-Spec-to-RTL
  --problems
    Prob015_multi_pipe_8bit
    Prob024_fsm
    Prob041_traffic_light
    Prob045_alu
    Prob049_signal_generator
    Prob116_m2014_q3
    Prob135_m2014_q6b
    Prob153_gshare
  --api_backend vllm
  --vllm_host 20.0.0.103
  --vllm_port 8000
  --vllm_min_model_len 128000
  --model_name openai/gpt-oss-120b
  --max_tokens 128000
  --diff_max_tokens 128000
  --evaluation_mode strict_ablation
  --temperature 1.0
  --top_p 1.0
  --total_worker_slots 48
  --max_active_problems 8
  --max_workers_per_problem 6
  --no-backend_subdir
)

SEED=1001
```

## Shape Matrix

```bash
SHAPES=(
  "12x3:12:3"
  "8x5:8:5"
  "6x7:6:7"
)
```

Each shape has `population_size * (num_generations + 1) = 48` candidates per
design.

## Classic Arms

```bash
for ITEM in "${SHAPES[@]}"; do
  IFS=: read -r SHAPE POP GEN <<< "${ITEM}"
  uv run python scripts/run_backend.py \
    "${COMMON_ARGS[@]}" \
    --seed "${SEED}" \
    --population_size "${POP}" \
    --num_generations "${GEN}" \
    --search_mode revolution \
    --classic_operator_kind eoh_strategies \
    --representation_kind code_individual \
    --save_path "${RUN_ROOT}/classic_revolution_${SHAPE}/seed_${SEED}"
done
```

## T75 QD Arms

```bash
for ITEM in "${SHAPES[@]}"; do
  IFS=: read -r SHAPE POP GEN <<< "${ITEM}"
  uv run python scripts/run_backend.py \
    "${COMMON_ARGS[@]}" \
    --seed "${SEED}" \
    --population_size "${POP}" \
    --num_generations "${GEN}" \
    --search_mode revolution_qd \
    --qd_archive_type grid_quantile \
    --qd_grid_quantile_warmup_successes 4 \
    --qd_fill_target_fraction 0.25 \
    --qd_improve_backfill_fraction 0.20 \
    --qd_cell_mode elite_pareto_slot \
    --qd_max_elites_per_cell 2 \
    --qd_objectives ppa \
    --qd_champion_lane_fraction 0.80 \
    --qd_parent_selection front_slot_lane_nsga2 \
    --qd_front_slot_lane_fraction 0.30 \
    --qd_two_parent_probability 0.0 \
    --qd_two_parent_gate none \
    --qd_operator_kind single_thought_operator \
    --qd_operator_one_parent_fraction 1.0 \
    --qd_operator_archive_context_size 4 \
    --representation_kind code_individual \
    --repair_kind none \
    --repair_max_attempts_per_sample 0 \
    --repair_max_attempts_per_thought 0 \
    --repair_evidence stage_scoped_logs \
    --qd_descriptor_profile source_aligned_shape_density_3d \
    --save_path "${RUN_ROOT}/shape_density_front_pressure_qd_${SHAPE}/seed_${SEED}"
done
```

## Validators

```bash
SUBSET="docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T79_budget_shape_ablation_protocol/tables/budget_shape_subset.yaml"

for ITEM in "${SHAPES[@]}"; do
  IFS=: read -r SHAPE POP GEN <<< "${ITEM}"
  uv run python scripts/validate_pareto_front_run.py \
    --run-root "${RUN_ROOT}" \
    --subset-config "${SUBSET}" \
    --classic-mode "classic_revolution_${SHAPE}" \
    --pareto-qd-mode "shape_density_front_pressure_qd_${SHAPE}" \
    --require-full-subset

  uv run python scripts/validate_single_thought_operator_run.py \
    --run-root "${RUN_ROOT}" \
    --subset-config "${SUBSET}" \
    --classic-mode "shape_density_front_pressure_qd_${SHAPE}" \
    --eoh-mode "shape_density_front_pressure_qd_${SHAPE}" \
    --unified-mode "shape_density_front_pressure_qd_${SHAPE}" \
    --require-full-subset
done
```

## Final Analysis Bundle

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic_revolution_12x3="${RUN_ROOT}/classic_revolution_12x3/seed_${SEED}" \
  --backend_run shape_density_front_pressure_qd_12x3="${RUN_ROOT}/shape_density_front_pressure_qd_12x3/seed_${SEED}" \
  --backend_run classic_revolution_8x5="${RUN_ROOT}/classic_revolution_8x5/seed_${SEED}" \
  --backend_run shape_density_front_pressure_qd_8x5="${RUN_ROOT}/shape_density_front_pressure_qd_8x5/seed_${SEED}" \
  --backend_run classic_revolution_6x7="${RUN_ROOT}/classic_revolution_6x7/seed_${SEED}" \
  --backend_run shape_density_front_pressure_qd_6x7="${RUN_ROOT}/shape_density_front_pressure_qd_6x7/seed_${SEED}" \
  --subset-config "${SUBSET}" \
  --output-dir "${RUN_ROOT}/final_analysis"
```

## Required Packaging

After the live run, package under this T79 directory:

- direct raw area-power Pareto figures for every shape;
- paired shape-delta tables;
- validity and reference-completeness tables;
- Phase 03.1 viewers for completed QD archive arms;
- screenshots and visual inspection notes.

Do not promote a budget-shape conclusion until this package is complete.
