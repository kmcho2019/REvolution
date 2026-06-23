# T72 Live Screen V0 Commands

Status: command template only. Do not launch until the descriptor gate passes.

## Storage Check

```bash
df -h /workspace
df -ih /workspace
```

Observed before pre-registration:

```text
/workspace: 27T total, 23T used, 3.5T available, 87% used
/workspace inodes: 2.7G total, 62M used, 2.6G free, 3% used
```

## Runtime Descriptor Gate

The profile is intentionally not assumed to exist. Implement the narrow
runtime hook first, then run:

```bash
uv run python scripts/qd_descriptor_probe.py \
  --profile source_aligned_masterrtl_rtltimer_cell_2d \
  --archive_type grid \
  --circuit_type sequential \
  > docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/descriptor_probe_source_aligned_masterrtl_rtltimer_cell_2d.json
```

Required probe properties:

- axes are `masterrtl_operator_log_edges` and `rtltimer_state_timing_class`;
- `requires_ppa=false`;
- descriptor summary identifies source-aligned MasterRTL/RTL-Timer sources;
- no final PPA, reference PPA, fitness, hypervolume, Pareto rank, or test pass
  is an input.

Then run a candidate-level regression probe that compares runtime output to
the T71 table. The implementation may choose the script name, but it must
write this artifact before live spend:

```text
tables/source_aligned_runtime_regression.csv
```

Required regression columns:

```text
candidate_id,masterrtl_operator_log_edges,rtltimer_state_timing_class,operator_scale_bin,state_timing_class,matches_t71
```

## vLLM Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t72_source_aligned_rtl_cell_${RUN_TS}/hard_tuning"
mkdir -p "${RUN_ROOT}/preflight"
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

Required model line:

```text
openai/gpt-oss-120b max_model_len=131072
```

## Shared Arguments

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src

COMMON_ARGS=(
  --backend revolution
  --benchmarks RTLLM VerilogEval-Spec-to-RTL
  --problems
    Prob004_adder_8bit
    Prob015_multi_pipe_8bit
    Prob024_fsm
    Prob037_parallel2serial
    Prob041_traffic_light
    Prob045_alu
    Prob049_signal_generator
    Prob098_circuit7
    Prob116_m2014_q3
    Prob135_m2014_q6b
    Prob150_review2015_fsmonehot
    Prob151_review2015_fsm
    Prob153_gshare
  --api_backend vllm
  --vllm_host 20.0.0.103
  --vllm_port 8000
  --vllm_min_model_len 128000
  --model_name openai/gpt-oss-120b
  --max_tokens 128000
  --diff_max_tokens 128000
  --population_size 12
  --num_generations 3
  --evaluation_mode strict_ablation
  --temperature 1.0
  --top_p 1.0
  --total_worker_slots 48
  --max_active_problems 12
  --max_workers_per_problem 4
  --no-backend_subdir
)
```

## T72 QD Arm

Run only after the descriptor gate succeeds.

```bash
SEED=1001
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --seed "${SEED}" \
  --search_mode revolution_qd \
  --qd_archive_type grid \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection front_slot_lane_nsga2 \
  --qd_two_parent_probability 0.0 \
  --qd_operator_kind single_thought_operator \
  --qd_operator_one_parent_fraction 0.90 \
  --qd_operator_archive_context_size 4 \
  --representation_kind code_individual \
  --repair_kind none \
  --repair_max_attempts_per_sample 0 \
  --repair_max_attempts_per_thought 0 \
  --repair_evidence stage_scoped_logs \
  --qd_descriptor_profile source_aligned_masterrtl_rtltimer_cell_2d \
  --save_path "${RUN_ROOT}/source_aligned_rtl_cell_qd/seed_${SEED}"
```

## Validators

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --classic-mode source_aligned_rtl_cell_qd \
  --eoh-mode source_aligned_rtl_cell_qd \
  --unified-mode source_aligned_rtl_cell_qd \
  --require-full-subset

uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --classic-mode source_aligned_rtl_cell_qd \
  --pareto-qd-mode source_aligned_rtl_cell_qd \
  --require-full-subset
```

## Packaging Requirements

Package against:

- T47 classic seed `1001`;
- T51 code-thought front-slot seed `1001`;
- T63 fused state/pipeline seed `1001`;
- T66 guarded parent seed `1001`;
- T67 seeded thought-code seed `1001`.

The package must include direct raw PPA-front plots, `ppa_completeness.csv`,
cell occupancy, out-of-range count, parent counters, and the Phase 03.1 viewer
if archive artifacts exist.
