# H5 Representative Probe Commands

Status: frozen before representative evidence on 2026-07-20 UTC. Run one arm
at a time so paired methods do not compete for the model endpoint or workers.

## Pins

- Code commit: `59acb11def38d12466cca425c6828bba25f98dc8`.
- Classic engine SHA-256:
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
- Representative selection SHA-256:
  `44bfacd9ad9969b7ec890892e5d28be3df3904b19ec734f4b8cc9505f50cc298`.
- Representative subset SHA-256:
  `9ed95986946980858b1391ce6c8725ba002959c864fed6706a0f8714b31286e5`.
- Default prompt manifest SHA-256:
  `044cc29db3bd20ecc1e00568cab74dc3efecaaf5da5a45ebbe306162b7b26a3a`.
- Shared config SHA-256:
  `b3c85757e2d18b3fa94d00f8decfd44c6468fdc0139a2bd93bced3b7c8997169`.
- Experiment manifest SHA-256:
  `0dcbc2f1012a06d5aac3f0ed64abbdfecc87ee902b174fcd096128af3fe0266f`.
- Mechanism report SHA-256:
  `f952aa636e1a553d99c2f280a9ba60d89b04069d589a44bcb0e5c18bfaba1222`.
- Probe report SHA-256:
  `15d2c6698a781ab5aa8dca46adefbbcec1c25edb4ea83b202a803aa68a0e0689`.

## Shell Setup

```bash
set -o pipefail
ROOT=/workspace/exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/representative_probe
CANDIDATE=/workspace/docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/candidates/H5_role_aligned_failed_repair
SUBSET="$CANDIDATE/representative_problem_manifest.yaml"
PROBLEMS=(
  Prob002_adder_16bit
  Prob024_fsm
  Prob025_sequence_detector
  Prob027_LIFObuffer
  Prob036_edge_detect
  Prob041_traffic_light
  Prob043_RAM
  Prob045_alu
)
mkdir -p "$ROOT/logs" "$ROOT/preflight" "$ROOT/packages"
```

## Per-Seed Preflight

Set `SEED=1001`, complete and package that pair, then repeat with `SEED=1002`.

```bash
uv run python -c '
import json
from revolution.vllm_preflight import preflight_vllm_model

payload = preflight_vllm_model("20.0.0.103", 8000, 128000, 5.0)
assert payload["ok"]
assert payload["model_id"] == "openai/gpt-oss-120b"
assert payload["meets_min_model_len"] is True
print(json.dumps(payload, indent=2))
' | tee "$ROOT/preflight/seed_${SEED}.json"
```

## Fresh Matched Pair

```bash
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  --config "$CANDIDATE/representative_run_config.yaml" \
  --search_mode revolution \
  --seed "$SEED" \
  --save_path "$ROOT/seed_${SEED}/classic" \
  2>&1 | tee "$ROOT/logs/seed_${SEED}_classic.log"
```

```bash
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  --config "$CANDIDATE/representative_run_config.yaml" \
  --search_mode revolution_failed_parent_repair \
  --seed "$SEED" \
  --save_path "$ROOT/seed_${SEED}/treatment" \
  2>&1 | tee "$ROOT/logs/seed_${SEED}_treatment.log"
```

Never overwrite an arm. A genuine infrastructure rerun receives a new
`rerun_<N>` sibling and a ledger entry.

## Per-Seed Package

```bash
PKG="$ROOT/packages/seed_${SEED}"
CLASSIC="$ROOT/seed_${SEED}/classic"
TREATMENT="$ROOT/seed_${SEED}/treatment"
mkdir -p "$PKG"

uv run python scripts/report_failed_parent_repair.py \
  --classic-root "$CLASSIC" \
  --treatment-root "$TREATMENT" \
  --output-dir "$PKG/mechanism" \
  --seed "$SEED" \
  --problems "${PROBLEMS[@]}" \
  --population-size 8 \
  --generations 5

uv run python scripts/backend_comparison_report.py \
  --backend_run "classic=$CLASSIC" \
  --backend_run "h5=$TREATMENT" \
  --output "$PKG/backend_comparison.md"

uv run python scripts/report_pareto_analysis.py \
  --backend_run "classic=$CLASSIC" \
  --backend_run "h5=$TREATMENT" \
  --subset-config "$SUBSET" \
  --output-dir "$PKG/pareto_analysis"

uv run python scripts/report_ppa_distribution.py \
  --backend_run "classic=$CLASSIC" \
  --backend_run "h5=$TREATMENT" \
  --subset-config "$SUBSET" \
  --output-dir "$PKG/ppa_distribution"

uv run python scripts/report_hv_auc.py \
  --ppa-candidates "$PKG/ppa_distribution/data/ppa_candidates.csv" \
  --num-generations 5 \
  --output "$PKG/hv_auc.csv"

uv run python scripts/audit_operator_contract.py \
  --ppa-candidates "$PKG/ppa_distribution/data/ppa_candidates.csv" \
  --methods classic h5 \
  --output "$PKG/operator_contract.csv"
```

## Two-Seed Canonical Package

Run only after both complete seed packages pass strict validation.

```bash
uv run python scripts/report_failed_parent_repair_probe.py \
  --manifest "$CANDIDATE/representative_experiment_manifest.yaml" \
  --output-dir "$ROOT/packages/two_seed/probe"
```

The canonical validator must account for all 16 problem-seed units and 32 arm
units, zero-fill HV/HV-AUC when a completed unit has no valid-PPA candidate,
include the H5 repair endpoint in clustered statistics, and assert exact
candidate plus maximum call, token, and synthesis budgets. Representative
performance cannot promote or retire H5. It diagnoses the mechanism and admits
the preregistered two-seed full suite unless correctness, budget, telemetry, or
infrastructure is invalid.
