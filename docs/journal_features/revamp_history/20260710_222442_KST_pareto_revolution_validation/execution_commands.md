# Pareto REvolution Frozen Execution Commands

Status: frozen before any LLM-backed evidence run on 2026-07-13 UTC.

These commands implement claims addenda V2 and V3. V3's `technical only`
language governs the smoke. Run classic and Pareto sequentially so they do not
compete for the model server or evaluation workers.

## Immutable Pins

- Evidence code commit: `0bb3fbc51dd3700564aa6de951aebc9a1d064f76`.
- Classic engine SHA-256:
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
- V2 config SHA-256:
  `22ed6fcfeaa18b8f8db526a47a456b1830e58a6808e46c2d6e290da9cfd2aadb`.
- V2 addendum SHA-256:
  `cdf284610e5f9e0cdeca2b328ac9ca2a97439bf8d042ee5e11a887f641c2688e`.
- V3 addendum SHA-256:
  `1468ec2ed5352ffc0730d422eb218bdcfd30afd8a54f51386767ace0e9ebb707`.
- RTLLM-46 manifest SHA-256:
  `92d6ad2981b04a8aed531ca04ca1ac085bb9fb6fee866ada2a4bf397ee52497b`.
- Endpoint: `http://20.0.0.103:8000`, model
  `openai/gpt-oss-120b`, minimum context `128000`.

## Shell Setup

Run this setup in the same Bash session as each launch command.

```bash
set -o pipefail
ROOT=/workspace/exp/pareto_revolution_validation
MANIFEST=/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml
COMMON_ARGS=(
  --backend revolution
  --benchmarks RTLLM
  --api_backend vllm
  --vllm_host 20.0.0.103
  --vllm_port 8000
  --vllm_min_model_len 128000
  --model_name openai/gpt-oss-120b
  --population_size 8
  --num_generations 5
  --generation_mode whole
  --population_pool_mode dual
  --strategy_selection ucb
  --evaluation_mode strict_ablation
  --classic_operator_kind eoh_strategies
  --eoh_success_operator_set classic
  --representation_kind code_individual
  --prompt_profile default
  --temperature 1.0
  --top_p 1.0
  --max_tokens 128000
  --diff_max_tokens 128000
  --total_worker_slots 48
  --max_active_problems 12
  --max_workers_per_problem 4
  --no-backend_subdir
)
SMOKE_PROBLEMS=(
  Prob003_adder_32bit
  Prob025_sequence_detector
  Prob006_adder_pipe_64bit
)
FULL_PROBLEMS=(
  Prob001_accu Prob002_adder_16bit Prob003_adder_32bit
  Prob004_adder_8bit Prob005_adder_bcd Prob006_adder_pipe_64bit
  Prob007_comparator_3bit Prob008_comparator_4bit Prob009_div_16bit
  Prob010_radix2_div Prob011_multi_16bit Prob012_multi_8bit
  Prob013_multi_booth_8bit Prob014_multi_pipe_4bit Prob015_multi_pipe_8bit
  Prob016_fixed_point_adder Prob017_fixed_point_substractor
  Prob018_float_multi Prob019_sub_64bit Prob020_JC_counter
  Prob021_counter_12 Prob022_ring_counter Prob023_up_down_counter
  Prob024_fsm Prob025_sequence_detector Prob026_asyn_fifo
  Prob027_LIFObuffer Prob028_LFSR Prob029_barrel_shifter
  Prob030_right_shifter Prob031_freq_div Prob032_freq_divbyeven
  Prob033_freq_divbyfrac Prob034_freq_divbyodd Prob035_calendar
  Prob036_edge_detect Prob037_parallel2serial Prob038_pulse_detect
  Prob039_serial2parallel Prob040_synchronizer Prob041_traffic_light
  Prob042_width_8to16 Prob043_RAM Prob044_ROM Prob045_alu
  Prob046_clkgenerator Prob047_instr_reg Prob048_pe
  Prob049_signal_generator Prob050_square_wave
)
mkdir -p "$ROOT/logs" "$ROOT/preflight" "$ROOT/packages"
```

## Preflight

Run before the smoke and again before each full-suite seed pair.

```bash
set -o pipefail
uv run python -c '
import json
from revolution.vllm_preflight import preflight_vllm_model

payload = preflight_vllm_model("20.0.0.103", 8000, 128000, 5.0)
assert payload["ok"]
assert payload["model_id"] == "openai/gpt-oss-120b"
assert payload["meets_min_model_len"] is True
print(json.dumps(payload, indent=2))
' | tee "$ROOT/preflight/latest.json"
```

## Seed-42 Technical Smoke

The exact raw roots are `$ROOT/smoke/seed_42/classic` and
`$ROOT/smoke/seed_42/pareto`. Delete neither root; a genuine infrastructure
rerun gets a new `rerun_<N>` sibling and a ledger entry.

```bash
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution \
  --seed 42 \
  --problems "${SMOKE_PROBLEMS[@]}" \
  --save_path "$ROOT/smoke/seed_42/classic" \
  2>&1 | tee "$ROOT/logs/smoke_seed42_classic.log"
```

```bash
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution_pareto \
  --seed 42 \
  --problems "${SMOKE_PROBLEMS[@]}" \
  --save_path "$ROOT/smoke/seed_42/pareto" \
  2>&1 | tee "$ROOT/logs/smoke_seed42_pareto.log"
```

Package the smoke without making a performance decision:

```bash
SMOKE_PKG="$ROOT/packages/smoke_seed_42"
mkdir -p "$SMOKE_PKG"
uv run python scripts/backend_comparison_report.py \
  --backend_run "classic=$ROOT/smoke/seed_42/classic" \
  --backend_run "pareto=$ROOT/smoke/seed_42/pareto" \
  --output "$SMOKE_PKG/backend_comparison.md"
uv run python scripts/report_pareto_analysis.py \
  --backend_run "classic=$ROOT/smoke/seed_42/classic" \
  --backend_run "pareto=$ROOT/smoke/seed_42/pareto" \
  --output-dir "$SMOKE_PKG/pareto_analysis"
```

The package must show all three problem summaries per arm, `8 x 5`, EoH-only
strategies, classic/Pareto search modes, and Pareto objective sources
`normalized_reference_gains`, `normalized_reference_gains`, and
`negative_raw_ppa` for the frozen problem order. A smoke failure permits only
an infrastructure or correctness repair, never treatment tuning.

## Full RTLLM Seed Pair

Set `SEED=1001` first. `1002` is legal only after the seed-1001 stop rule
passes. `1003`, `1004`, and `1005` are legal only after the two-seed promotion
gate passes. Each command names all 50 tasks explicitly.

```bash
SEED=1001
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution \
  --seed "$SEED" \
  --problems "${FULL_PROBLEMS[@]}" \
  --save_path "$ROOT/full_rtllm/seed_${SEED}/classic" \
  2>&1 | tee "$ROOT/logs/full_rtllm_seed${SEED}_classic.log"
```

```bash
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution_pareto \
  --seed "$SEED" \
  --problems "${FULL_PROBLEMS[@]}" \
  --save_path "$ROOT/full_rtllm/seed_${SEED}/pareto" \
  2>&1 | tee "$ROOT/logs/full_rtllm_seed${SEED}_pareto.log"
```

## Per-Seed Report Chain

Run this chain immediately after each completed full seed pair.

```bash
PKG="$ROOT/packages/full_rtllm_seed_${SEED}"
CLASSIC="$ROOT/full_rtllm/seed_${SEED}/classic"
PARETO="$ROOT/full_rtllm/seed_${SEED}/pareto"
mkdir -p "$PKG"
uv run python scripts/backend_comparison_report.py \
  --backend_run "classic=$CLASSIC" \
  --backend_run "pareto=$PARETO" \
  --output "$PKG/backend_comparison.md"
uv run python scripts/report_pareto_analysis.py \
  --backend_run "classic=$CLASSIC" \
  --backend_run "pareto=$PARETO" \
  --subset-config "$MANIFEST" \
  --output-dir "$PKG/pareto_analysis"
uv run python scripts/report_ppa_distribution.py \
  --backend_run "classic=$CLASSIC" \
  --backend_run "pareto=$PARETO" \
  --subset-config "$MANIFEST" \
  --output-dir "$PKG/ppa_distribution"
uv run python scripts/report_hv_auc.py \
  --ppa-candidates "$PKG/ppa_distribution/data/ppa_candidates.csv" \
  --num-generations 5 \
  --output "$PKG/hv_auc.csv"
uv run python scripts/audit_operator_contract.py \
  --ppa-candidates "$PKG/ppa_distribution/data/ppa_candidates.csv" \
  --methods classic pareto \
  --output "$PKG/operator_contract.csv"
```

The package must retain raw-root paths and reason-coded missing units. Verify
50 summaries per arm, 46 PPA headline rows per arm, exact candidate evaluator
counts, zero forbidden operators in all generation logs, calls/tokens/wall
time, valid-PPA coverage, functional any-pass on 50 and 46, weak
reference-beating coverage, positive-HV coverage, final HV46, and HV-AUC46.

## Mechanical Gates

1. After seed 1001, stop if Pareto final mean HV46 is below `0.90 *` fresh
   classic, Pareto valid-PPA coverage trails by at least four, or correctness
   or budget equality fails.
2. After seeds 1001-1002, continue only if aggregate Pareto final mean HV46,
   valid-PPA coverage, and functional any-pass are each at least fresh classic.
3. Positive five-seed development evidence requires Pareto final mean HV46 to
   be strictly greater than fresh classic and both coverage metrics at least
   classic. Exact HV parity is supporting. HV-AUC cannot rescue final HV.
4. Calls or tokens beyond `+/-10%` are disclosed as budget-asymmetric. A
   method-inherent persistent skew closes as supporting or negative evidence.
5. No failed gate authorizes another method, parameter, prompt, descriptor, or
   operator inside this goal.
