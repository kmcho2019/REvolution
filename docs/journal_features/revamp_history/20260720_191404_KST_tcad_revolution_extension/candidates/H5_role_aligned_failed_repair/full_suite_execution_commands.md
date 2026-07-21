# H5 Full-Suite Probe Commands

Status: completed once on 2026-07-21 with no missing units or reruns. These are
the frozen commands used for the preserved raw evidence. The generated reporter
label is not the governing candidate decision; see `decision.md` and
`full_suite_probe/README.md` for the post-run contract audit.

## Pins

- H5 implementation commit:
  `59acb11def38d12466cca425c6828bba25f98dc8`.
- Classic engine SHA-256:
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
- Full run manifest SHA-256:
  `e46d54c07a7ef7f315f70872e8fab04ac49bc63ad5c0676f9aeecdea42bff578`.
- Locked 46-task headline manifest SHA-256:
  `92d6ad2981b04a8aed531ca04ca1ac085bb9fb6fee866ada2a4bf397ee52497b`.
- Shared run config SHA-256:
  `3a4ec607702bac8dbf53eedadfb637d2d5e952c12680834f113865de6576582a`.
- Full-suite experiment manifest SHA-256:
  `10cdf1eedbb560c6b36b5b7197490d2fe7f0bd5f48510c2b330574f575e9da9e`.
- Default prompt manifest SHA-256:
  `044cc29db3bd20ecc1e00568cab74dc3efecaaf5da5a45ebbe306162b7b26a3a`.
- Mechanism report SHA-256:
  `350371b2b53cd069c63db3d92bae6e05d23fb3b1f3ac974358cd017ada2d5116`.
- Probe report SHA-256:
  `518cb20b78bef3aa796287644f27fc3f2ca43e0735674b7952835431a069f6c8`.

## Shell Setup

```bash
set -o pipefail
ROOT=/workspace/exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/full_suite_probe
CANDIDATE=/workspace/docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/candidates/H5_role_aligned_failed_repair
RUN_MANIFEST="$CANDIDATE/full_suite_problem_manifest.yaml"
HEADLINE=/workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml
mapfile -t PROBLEMS < <(uv run python -c '
import sys, yaml
from pathlib import Path
rows = yaml.safe_load(Path(sys.argv[1]).read_text())["selected_problems"]
print("\n".join(row["problem"] for row in rows))
' "$RUN_MANIFEST")
test "${#PROBLEMS[@]}" -eq 50
mkdir -p "$ROOT/logs" "$ROOT/preflight" "$ROOT/packages"
```

## Per-Seed Preflight

Set `SEED=1001`, complete the matched pair and package, then repeat with
`SEED=1002`.

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
test ! -e "$ROOT/seed_${SEED}/classic"
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  --config "$CANDIDATE/full_suite_run_config.yaml" \
  --search_mode revolution \
  --seed "$SEED" \
  --save_path "$ROOT/seed_${SEED}/classic" \
  2>&1 | tee "$ROOT/logs/seed_${SEED}_classic.log"
```

Validate the completed classic arm before starting H5:

```bash
uv run python - "$ROOT/seed_${SEED}/classic" "$RUN_MANIFEST" <<'PY'
import sys, yaml
from pathlib import Path
from scripts.report_failed_parent_repair_probe import _read_arm

root = Path(sys.argv[1]).resolve()
rows = yaml.safe_load(Path(sys.argv[2]).read_text())["selected_problems"]
problems = [row["problem"] for row in rows]
evidence = _read_arm(root, problems, 8, 5, 100, 650000, 48, "forbid")
assert all(row["runtime_seconds"] <= 2400 for row in evidence.values())
print("PASS: 50 problems, 2,400 candidates")
PY
```

```bash
test ! -e "$ROOT/seed_${SEED}/treatment"
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
uv run python scripts/run_backend.py \
  --config "$CANDIDATE/full_suite_run_config.yaml" \
  --search_mode revolution_failed_parent_repair \
  --seed "$SEED" \
  --save_path "$ROOT/seed_${SEED}/treatment" \
  2>&1 | tee "$ROOT/logs/seed_${SEED}_treatment.log"
```

The package command below validates completed treatment units and emits zero
rows for any registered missing unit. The canonical report then retires a run
with a candidate-budget mismatch. Never overwrite an arm. A genuine
infrastructure rerun receives a new `rerun_<N>` sibling and a ledger entry
before it is used.

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
  --generations 5 \
  --treatment-missing-policy zero

uv run python scripts/backend_comparison_report.py \
  --backend_run "classic=$CLASSIC" \
  --backend_run "h5=$TREATMENT" \
  --output "$PKG/backend_comparison.md"

uv run python scripts/report_pareto_analysis.py \
  --backend_run "classic=$CLASSIC" \
  --backend_run "h5=$TREATMENT" \
  --subset-config "$HEADLINE" \
  --output-dir "$PKG/pareto_analysis"

uv run python scripts/report_ppa_distribution.py \
  --backend_run "classic=$CLASSIC" \
  --backend_run "h5=$TREATMENT" \
  --subset-config "$HEADLINE" \
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

## Canonical Two-Seed Package

Run only after both per-seed mechanism packages pass strict validation.

```bash
uv run python scripts/report_failed_parent_repair_probe.py \
  --manifest "$CANDIDATE/full_suite_experiment_manifest.yaml" \
  --output-dir "$ROOT/packages/two_seed/probe"
```

The canonical validator must account for all 100 run units, all 92
reference-complete headline units, and all 200 arm units. It zero-fills
completed reference-complete units with no valid PPA, reports 46-task and
50-task functionality separately, evaluates the repair benefit independently
in each seed, and applies only the margins frozen in the experiment manifest.
This stage may yield `VIABLE` or `RETIRED`; it cannot produce a
`PAPER_CANDIDATE` without fresh confirmation and holdout evidence.
