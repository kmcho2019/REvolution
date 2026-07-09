# Suite Variant Commands

All suite-variant commands follow the P3 full RTLLM command shape:

- `--benchmarks RTLLM` with no explicit problem list.
- `--population_size 8 --num_generations 5`.
- `--evaluation_mode strict_ablation`.
- `--total_worker_slots 48 --max_active_problems 12
  --max_workers_per_problem 4`.
- `--max_tokens 128000 --diff_max_tokens 128000
  --vllm_min_model_len 128000`.
- `--search_mode revolution_qd`.
- `--representation_kind code_individual`.
- `--qd_operator_kind eoh_strategies`.
- `--eoh_success_operator_set classic`.
- V2 parity pins unless the arm explicitly changes one of them:
  `--qd_parent_selection nsga2_global_rank`, `--qd_archive_type
  grid_quantile`, `--qd_descriptor_profile journal_logic_ff_width_3d`,
  `--qd_num_cells 16`, `--qd_grid_quantile_warmup_successes 8`,
  `--qd_cell_mode pareto_front`, `--qd_max_elites_per_cell 5`, and
  `--qd_champion_lane_fraction 0.5`, and
  `--qd_rebinning_kind ks_triggered`.
- `--no-backend_subdir`.

## S01 Capacity 7

Change only `--qd_max_elites_per_cell 7` and save under:

`exp/natural_qd_push/suite_variants_wave_a_<UTC>/live/capacity7/seed_<seed>`.

## S02 Warmup 16

Change only `--qd_grid_quantile_warmup_successes 16` and save under:

`exp/natural_qd_push/suite_variants_wave_a_<UTC>/live/warmup16/seed_<seed>`.

## S03 Elite Pareto Slot 2

Change:

```text
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
```

Save under:

`exp/natural_qd_push/suite_variants_wave_a_<UTC>/live/elite_pareto_slot_2/seed_<seed>`.

## S07/S08/S19 Capacity Interpolation

Change only the capacity value:

```text
--qd_max_elites_per_cell 3
--qd_max_elites_per_cell 9
--qd_max_elites_per_cell 11
```

Save under one of:

- `exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/capacity3/seed_<seed>`
- `exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/capacity9/seed_<seed>`
- `exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/capacity11/seed_<seed>`

### S07 Capacity 3 Seed 1001 Launch

Use this as the first post-restart primary-search run if continuing the
capacity/interpolation branch. It changes only
`qd_max_elites_per_cell=3` from the V2 suite contract.

```bash
TS=$(date -u +%Y%m%d_%H%M%S_UTC)
ROOT="/workspace/exp/natural_qd_push/suite_variants_wave_b_${TS}"
RUN_DIR="$ROOT/live/capacity3/seed_1001"
LOG="$ROOT/launch_capacity3_seed1001.log"
PREFLIGHT="docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/suite_variant_campaign/preflights/s07_capacity3_seed1001_${TS}.json"
mkdir -p "$ROOT" "$(dirname "$PREFLIGHT")"
uv run python - <<PY
import json
from datetime import UTC, datetime
from pathlib import Path
from revolution.vllm_preflight import preflight_vllm_model

path = Path("$PREFLIGHT")
preflight = preflight_vllm_model(
    host="20.0.0.103",
    port=8000,
    min_model_len=128000,
    timeout_s=5.0,
)
max_model_len = preflight.get("max_model_len")
payload = {
    "endpoint": "http://20.0.0.103:8000/v1/models",
    "generated_at_utc": datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "max_model_len": max_model_len,
    "min_required": 128000,
    "model": preflight.get("model_id") or preflight.get("model"),
    "status": "pass" if max_model_len and int(max_model_len) >= 128000 else "fail",
}
path.write_text(json.dumps(payload, indent=2) + "\n")
print(json.dumps(payload, indent=2))
assert payload["status"] == "pass"
assert payload["model"] == "openai/gpt-oss-120b"
PY
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} uv run python scripts/run_backend.py \
  --backend revolution \
  --search_mode revolution_qd \
  --benchmarks RTLLM \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --population_size 8 \
  --num_generations 5 \
  --total_worker_slots 48 \
  --max_active_problems 12 \
  --max_workers_per_problem 4 \
  --evaluation_mode strict_ablation \
  --classic_operator_kind eoh_strategies \
  --eoh_success_operator_set classic \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --qd_num_cells 16 \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 3 \
  --qd_parent_selection nsga2_global_rank \
  --qd_champion_lane_fraction 0.5 \
  --qd_rebinning_kind ks_triggered \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --seed 1001 \
  --save_path "$RUN_DIR" \
  --no-backend_subdir 2>&1 | tee "$LOG"
```

### S07 Capacity 3 Seed 1002 Launch

Use this only as the S07 replication run. It keeps the same one-knob
capacity change as seed 1001 and changes only `seed=1002`.

```bash
TS=$(date -u +%Y%m%d_%H%M%S_UTC)
ROOT="/workspace/exp/natural_qd_push/suite_variants_wave_b_${TS}"
RUN_DIR="$ROOT/live/capacity3/seed_1002"
LOG="$ROOT/launch_capacity3_seed1002.log"
PREFLIGHT="docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/suite_variant_campaign/preflights/s07_capacity3_seed1002_${TS}.json"
mkdir -p "$ROOT" "$(dirname "$PREFLIGHT")"
uv run python - <<PY
import json
from datetime import UTC, datetime
from pathlib import Path
from revolution.vllm_preflight import preflight_vllm_model

path = Path("$PREFLIGHT")
preflight = preflight_vllm_model(
    host="20.0.0.103",
    port=8000,
    min_model_len=128000,
    timeout_s=5.0,
)
max_model_len = preflight.get("max_model_len")
payload = {
    "endpoint": "http://20.0.0.103:8000/v1/models",
    "generated_at_utc": datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "max_model_len": max_model_len,
    "min_required": 128000,
    "model": preflight.get("model_id") or preflight.get("model"),
    "status": "pass" if max_model_len and int(max_model_len) >= 128000 else "fail",
}
path.write_text(json.dumps(payload, indent=2) + "\n")
print(json.dumps(payload, indent=2))
assert payload["status"] == "pass"
assert payload["model"] == "openai/gpt-oss-120b"
PY
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} uv run python scripts/run_backend.py \
  --backend revolution \
  --search_mode revolution_qd \
  --benchmarks RTLLM \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --population_size 8 \
  --num_generations 5 \
  --total_worker_slots 48 \
  --max_active_problems 12 \
  --max_workers_per_problem 4 \
  --evaluation_mode strict_ablation \
  --classic_operator_kind eoh_strategies \
  --eoh_success_operator_set classic \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --qd_num_cells 16 \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 3 \
  --qd_parent_selection nsga2_global_rank \
  --qd_champion_lane_fraction 0.5 \
  --qd_rebinning_kind ks_triggered \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --seed 1002 \
  --save_path "$RUN_DIR" \
  --no-backend_subdir 2>&1 | tee "$LOG"
```

## S09/S22/S10 Front-Slot Lane Interpolation

Change:

```text
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
--qd_parent_selection front_slot_lane_nsga2
--qd_front_slot_lane_fraction 0.20
```

Use fraction `0.10` for S22 and `0.40` for S10. Save under one of:

- `exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/front_slot_lane_020/seed_<seed>`
- `exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/front_slot_lane_010/seed_<seed>`
- `exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/front_slot_lane_040/seed_<seed>`

S09 runs first. Keep all other V2 parity pins, including
`--qd_archive_type grid_quantile`,
`--qd_descriptor_profile journal_logic_ff_width_3d`,
`--qd_num_cells 16`, `--qd_grid_quantile_warmup_successes 8`, and
`--qd_champion_lane_fraction 0.5`, and `--qd_rebinning_kind
ks_triggered`.

### Current S09 Seed 1002 Launch

This was the seed 1002 replication command. Before reusing it, verify
that no `front_slot_lane_020/seed_1002` process or completed run root
already exists.

```bash
ROOT=/workspace/exp/natural_qd_push/suite_variants_wave_b_20260709_134750_UTC
RUN_DIR="$ROOT/live/front_slot_lane_020/seed_1002"
LOG="$ROOT/launch_front_slot_lane_020_seed1002.log"
mkdir -p "$ROOT"
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} uv run python scripts/run_backend.py \
  --backend revolution \
  --search_mode revolution_qd \
  --benchmarks RTLLM \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --population_size 8 \
  --num_generations 5 \
  --total_worker_slots 48 \
  --max_active_problems 12 \
  --max_workers_per_problem 4 \
  --evaluation_mode strict_ablation \
  --classic_operator_kind eoh_strategies \
  --eoh_success_operator_set classic \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --qd_num_cells 16 \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_parent_selection front_slot_lane_nsga2 \
  --qd_front_slot_lane_fraction 0.20 \
  --qd_champion_lane_fraction 0.5 \
  --qd_rebinning_kind ks_triggered \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --seed 1002 \
  --save_path "$RUN_DIR" \
  --no-backend_subdir 2>&1 | tee "$LOG"
```

### S22 Seed 1002 Launch

S22 is the conservative front-slot interpolation check after S09
front-loss closure. It changes only the front-slot lane fraction from
`0.20` to `0.10` relative to S09.

```bash
ROOT=/workspace/exp/natural_qd_push/suite_variants_wave_b_20260709_164211_UTC
RUN_DIR="$ROOT/live/front_slot_lane_010/seed_1002"
LOG="$ROOT/launch_front_slot_lane_010_seed1002.log"
mkdir -p "$ROOT"
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} uv run python scripts/run_backend.py \
  --backend revolution \
  --search_mode revolution_qd \
  --benchmarks RTLLM \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --population_size 8 \
  --num_generations 5 \
  --total_worker_slots 48 \
  --max_active_problems 12 \
  --max_workers_per_problem 4 \
  --evaluation_mode strict_ablation \
  --classic_operator_kind eoh_strategies \
  --eoh_success_operator_set classic \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --qd_num_cells 16 \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_parent_selection front_slot_lane_nsga2 \
  --qd_front_slot_lane_fraction 0.10 \
  --qd_champion_lane_fraction 0.5 \
  --qd_rebinning_kind ks_triggered \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --seed 1002 \
  --save_path "$RUN_DIR" \
  --no-backend_subdir 2>&1 | tee "$LOG"
```

## S20 Cell-Crowded Parent Selection

Change only:

```text
--qd_parent_selection cell_crowded_tournament
```

Save under:

`exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/pareto_front_cell_crowded/seed_<seed>`.

## S21 Scalar Elite NSGA-II

Change:

```text
--qd_cell_mode scalar_elite
--qd_max_elites_per_cell 1
```

Keep `--qd_parent_selection nsga2_global_rank` and all other V2 parity
pins. Save under:

`exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/scalar_elite_nsga2/seed_<seed>`.

## S11/S12 Warmup Interpolation

Change only the warmup value:

```text
--qd_grid_quantile_warmup_successes 12
--qd_grid_quantile_warmup_successes 24
```

Save under one of:

- `exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/warmup12/seed_<seed>`
- `exp/natural_qd_push/suite_variants_wave_b_<UTC>/live/warmup24/seed_<seed>`

## S04/S05 Descriptor Completions

Continue the existing P3c roots:

- `exp/natural_qd_push/p3c_bd_sweep_20260704_093150_UTC/live/compact8d_cvt/seed_<seed>`
- `exp/natural_qd_push/p3c_bd_sweep_20260704_093150_UTC/live/trio_cvt/seed_<seed>`

Use the same descriptor/CVT flags recorded in
`../p3_full_rtllm/p3c_bd_sweep_registration.md`.

## Packaging

Use the P3 package chain per seed:

1. `scripts/report_pareto_analysis.py` over classic, V2, and variant.
2. `scripts/report_ppa_distribution.py`.
3. `scripts/report_hv_auc.py`.
4. `scripts/audit_operator_contract.py`.
5. `scripts/validate_natural_qd_run.py`.

Validation packages should assert the shared pins above plus the
variant-specific changed pins. This keeps the curated package contract as
strict as the live launch command and prevents silent drift in
suite-level comparisons.

Then update `results_log.md`, `variant_registry.csv`, and the campaign
README before any promotion decision.

For negative probe or confirmation packages, keep the curated docs copy
compact: summary JSON, CSV data/tables, validation output, operator
audit, and a short result report are sufficient. Leave broad
per-problem figure trees in the raw `exp/` root unless a figure is
selected for paper-facing analysis.
