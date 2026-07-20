# H5 Frozen Execution Commands

Status: smoke commands frozen before any live H5 evidence on 2026-07-20 UTC.
Run the arms sequentially so they do not compete for the model endpoint or
evaluation workers.

## Pins

- Code commit: `59acb11def38d12466cca425c6828bba25f98dc8`.
- Classic engine SHA-256:
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
- Program manifest revision 4 SHA-256:
  `1ace858fdaf2bc3a9468526a48293d674afac7badaa726592d3a72a0b624be34`.
- Smoke manifest SHA-256:
  `b663c89673bd3b8a336d3ef36253a7774f11550bc9421a374994dc2446792fb9`.
- Shared smoke config SHA-256:
  `20c8b3daf931b0b322568af61c9fa8a4ff85ab5da5fdcf56568cc8471702d490`.
- Mechanism report SHA-256:
  `f952aa636e1a553d99c2f280a9ba60d89b04069d589a44bcb0e5c18bfaba1222`.
- Model endpoint: `http://20.0.0.103:8000`, model
  `openai/gpt-oss-120b`, minimum context 128000.
- Shared config: `smoke_run_config.yaml`.

## Setup And Preflight

```bash
set -o pipefail
ROOT=/workspace/exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/smoke_seed42
CANDIDATE=/workspace/docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/candidates/H5_role_aligned_failed_repair
mkdir -p "$ROOT/logs" "$ROOT/preflight" "$ROOT/package"

uv run python -c '
import json
from revolution.vllm_preflight import preflight_vllm_model

payload = preflight_vllm_model("20.0.0.103", 8000, 128000, 5.0)
assert payload["ok"]
assert payload["model_id"] == "openai/gpt-oss-120b"
assert payload["meets_min_model_len"] is True
print(json.dumps(payload, indent=2))
' | tee "$ROOT/preflight/prelaunch.json"
```

## Fresh Matched Arms

```bash
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  --config "$CANDIDATE/smoke_run_config.yaml" \
  --search_mode revolution \
  --save_path "$ROOT/classic" \
  2>&1 | tee "$ROOT/logs/classic.log"
```

```bash
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  --config "$CANDIDATE/smoke_run_config.yaml" \
  --search_mode revolution_failed_parent_repair \
  --save_path "$ROOT/treatment" \
  2>&1 | tee "$ROOT/logs/treatment.log"
```

Do not delete or overwrite either root. A genuine infrastructure rerun uses a
new `rerun_<N>` sibling and a ledger entry.

## Strict Mechanism Package

```bash
uv run python scripts/report_failed_parent_repair.py \
  --classic-root "$ROOT/classic" \
  --treatment-root "$ROOT/treatment" \
  --output-dir "$ROOT/package/mechanism" \
  --seed 42 \
  --problems Prob002_adder_16bit Prob025_sequence_detector Prob043_RAM \
  --population-size 8 \
  --generations 1

uv run python scripts/backend_comparison_report.py \
  --backend_run "classic=$ROOT/classic" \
  --backend_run "treatment=$ROOT/treatment" \
  --output "$ROOT/package/backend_comparison.md"
```

The smoke gate requires three complete problem logs per arm, exactly 16
candidates per problem, five classic failed-pool operators, only M-F in H5,
classic success operators in both arms, complete lineage/stage fields, and
valid treatment pool transitions. Performance is recorded but cannot promote
or retire H5 at this stage.
