# H10 Full-Suite Execution Commands

Status: `FROZEN_BEFORE_ADMISSION`. No command in this file has been executed.

This runbook is the only allowed path from `SMOKE_VALIDATED` to the frozen
two-seed RTLLM-50 evaluation. Run one arm at a time in this exact order:

1. `seed_1001_classic`
2. `seed_1001_treatment`
3. `seed_1002_classic`
4. `seed_1002_treatment`

For each arm, admission must print exactly `PASS` before the live command. The
arm must exit successfully, seal, account, and record exactly `PASS` before the
next arm is admitted. Any nonzero command, assertion, timeout, or `STOP` ends
automatic execution. Do not rerun, overwrite, edit a failure registry, or
launch the next arm without a new prospective audit.

Open one shell and run every block in that shell. Each operational block also
sets `set -euo pipefail`; executing a block without its required exported state
therefore fails before admission or launch.

## Frozen Inputs

- Smoke-transition commit:
  `1255431b5637ac15a368a42146b1b3d43162e564`.
- Runtime commit:
  `ed5863c5fa578a0a5a2ffb73d1aebef44e67f8e8`.
- Implementation-manifest SHA-256:
  `c0ef63b5852252bee8d2128b557d433543e50042e096fb0a6181cc7bd0f9a582`.
- Program-manifest-v8 SHA-256:
  `26c83aa4ea6a01ef31f0757a560564c1df1c86ee42745242aad88eaf4ef83666`.
- Worksheet SHA-256:
  `d7bd17b10e21a2acd970d43feb75603d83b57530efd27fcf38aa2323663a7378`.
- Full-suite config SHA-256:
  `3a4ec607702bac8dbf53eedadfb637d2d5e952c12680834f113865de6576582a`.
- Full-suite report-manifest SHA-256:
  `048e2e2cfd491d032fc88dffbffdb3cc7a75838df25082895fe5386e5a0b6aeb`.
- Canonical smoke-summary SHA-256:
  `c57a221ec87afe2674fc3e19f2b99f84bb4863c0c8a363662a8595f723d2f806`.
- Model: `openai/gpt-oss-120b` at `20.0.0.103:8000`, with at least 128,000
  context tokens.

## One-Time Setup

Run from `/workspace` on branch `feat/journal-workshop-exp-20260720`:

```bash
set -euo pipefail
H10=/workspace/docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/candidates/H10_verified_status_feedback
BASE=/workspace/exp/tcad_revolution_extension/h10_verified_status_feedback/wave2
RAW="$BASE/full_suite"
OPS="$BASE/operations/full_suite"
REPORT="$BASE/reports/full_suite"

test "$(git branch --show-current)" = feat/journal-workshop-exp-20260720
test -z "$(git status --porcelain --untracked-files=no)"
git merge-base --is-ancestor \
  1255431b5637ac15a368a42146b1b3d43162e564 HEAD
test ! -e "$RAW"
test ! -e "$OPS"
test ! -e "$REPORT"
mkdir -p "$RAW" "$OPS/accounting" "$OPS/logs" "$OPS/preflight" \
  "$(dirname "$REPORT")"
printf 'version: 1\nunits: []\n' > "$RAW/unit_failures.yaml"
```

The empty registry is the only automatic path. If an arm is incomplete or
malformed, stop before sealing. A nonempty registry requires its own reviewed
evidence records and is not created by this runbook.

## Prelaunch Gates

```bash
set -euo pipefail
uv run python - <<'PY' | tee "$OPS/preflight/model.json"
import json

from revolution.vllm_preflight import preflight_vllm_model

payload = preflight_vllm_model("20.0.0.103", 8000, 128000, 5.0)
assert payload["ok"]
assert payload["model_id"] == "openai/gpt-oss-120b"
assert payload["meets_min_model_len"] is True
print(json.dumps(payload, indent=2))
PY
```

```bash
set -euo pipefail
export H10 OPS
uv run python - <<'PY'
import hashlib
import json
import os
from datetime import datetime, timezone
from pathlib import Path

import yaml

from scripts.report_verified_status_feedback import (
    H10_ROOT,
    PROGRAM_MANIFEST,
    _validate_frozen_inputs,
    _validate_implementation_manifest,
    generate_report,
)
from scripts.tcad_candidate_admission import (
    PROGRAM_LEDGER,
    _load_ledger,
    _load_worksheet,
    admission_status,
)

h10 = Path(os.environ["H10"])
ops = Path(os.environ["OPS"])
_validate_implementation_manifest(H10_ROOT / "implementation_manifest.yaml")
program = yaml.safe_load(PROGRAM_MANIFEST.read_text(encoding="utf-8"))
assert len(_validate_frozen_inputs(program)) == 46

smoke_report = ops / "preflight" / "smoke_recheck"
summary = generate_report(h10 / "smoke_report_manifest.yaml", smoke_report)
assert summary["smoke_gate"] == "PASS"
assert all(summary["gate_results"].values())
assert hashlib.sha256((smoke_report / "summary.json").read_bytes()).hexdigest() == (
    "c57a221ec87afe2674fc3e19f2b99f84bb4863c0c8a363662a8595f723d2f806"
)

worksheet = _load_worksheet(h10 / "candidate_budget.yaml")
events = _load_ledger(PROGRAM_LEDGER)
assert admission_status(
    worksheet, events, "seed_1001_classic", datetime.now(timezone.utc)
) == "PASS"
print(json.dumps({"smoke": "PASS", "next_arm": "seed_1001_classic"}))
PY
```

## Exact Arm Matrix

| Arm ID | `SEED` | `ARM` | `MODE` | `TIMEOUT` | `EXTRA` |
| --- | ---: | --- | --- | ---: | --- |
| `seed_1001_classic` | 1001 | `classic` | `revolution` | 5125 | empty |
| `seed_1001_treatment` | 1001 | `treatment` | `revolution_verified_status_feedback` | 5125 | empty |
| `seed_1002_classic` | 1002 | `classic` | `revolution` | 4985 | empty |
| `seed_1002_treatment` | 1002 | `treatment` | `revolution_verified_status_feedback` | 4985 | `$RAW/unit_failures.yaml` |

For each row, set the six variables exactly, then run the next four sections
without running any other row concurrently.

## Admit One Arm

```bash
set -euo pipefail
export SEED ARM ARM_ID MODE TIMEOUT EXTRA
tuple="$ARM_ID|$SEED|$ARM|$MODE|$TIMEOUT|$EXTRA"
case "$tuple" in
  "seed_1001_classic|1001|classic|revolution|5125|") ;;
  "seed_1001_treatment|1001|treatment|revolution_verified_status_feedback|5125|") ;;
  "seed_1002_classic|1002|classic|revolution|4985|") ;;
  "seed_1002_treatment|1002|treatment|revolution_verified_status_feedback|4985|$RAW/unit_failures.yaml") ;;
  *) printf 'invalid arm tuple: %s\n' "$tuple" >&2; exit 1 ;;
esac
status="$(
  uv run python scripts/tcad_candidate_admission.py admit \
    --worksheet "$H10/candidate_budget.yaml" \
    --implementation-manifest "$H10/implementation_manifest.yaml" \
    --arm "$ARM_ID"
)"
test "$status" = PASS
printf '%s\n' "$status"
```

## Run One Arm

```bash
set -euo pipefail
ROOT="$RAW/seed_${SEED}/${ARM}"
LOG="$OPS/logs/${ARM_ID}.log"
test ! -e "$ROOT"
test ! -e "$LOG"
timeout --signal=INT --kill-after=60s "${TIMEOUT}s" \
  env OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}" \
  uv run python scripts/run_backend.py \
    --config "$H10/full_suite_run_config.yaml" \
    --search_mode "$MODE" \
    --seed "$SEED" \
    --save_path "$ROOT" \
  2>&1 | tee "$LOG"
```

## Seal And Account One Arm

The block validates every one of the 50 complete units before writing the arm
seal. The final treatment seal also binds the still-empty failure registry.

```bash
set -euo pipefail
export RAW OPS
uv run python - <<'PY'
import hashlib
import json
import os
from datetime import datetime, timezone
from decimal import Decimal
from pathlib import Path
from typing import cast

import yaml

from scripts.report_verified_status_feedback import (
    Arm,
    H10_ROOT,
    NORMALIZED_CONFIG_SHA256,
    PROGRAM_MANIFEST,
    RUN_CONFIG_SHA256,
    _build_arm_rows,
    _path,
    _problem_names,
    _read_config,
    _read_run_wall,
)
from scripts.tcad_candidate_admission import _load_worksheet

seed = int(os.environ["SEED"])
arm = cast(Arm, os.environ["ARM"])
arm_id = os.environ["ARM_ID"]
assert arm_id == f"seed_{seed}_{arm}"
raw = Path(os.environ["RAW"]).resolve()
ops = Path(os.environ["OPS"]).resolve()
root = raw / f"seed_{seed}" / arm
accounting = ops / "accounting" / f"{arm_id}.yaml"
extra_value = os.environ["EXTRA"]
extras = (Path(extra_value).resolve(),) if extra_value else ()
assert bool(extras) is (seed == 1002 and arm == "treatment")
registry = raw / "unit_failures.yaml"
assert registry.read_bytes() == b"version: 1\nunits: []\n"

match arm:
    case "classic":
        expected_mode = "revolution"
    case "treatment":
        expected_mode = "revolution_verified_status_feedback"
    case unknown:
        raise AssertionError(f"unknown arm: {unknown}")
assert os.environ["MODE"] == expected_mode

config = yaml.safe_load(
    (H10_ROOT / "full_suite_run_config.yaml").read_text(encoding="utf-8")
)
problems = config["problems"]
assert len(problems) == 50 and len(set(problems)) == 50
program = yaml.safe_load(PROGRAM_MANIFEST.read_text(encoding="utf-8"))
headline = set(_problem_names(_path(program["benchmarks"]["full_suite"]["headline_manifest"])))
assert len(headline) == 46 and headline <= set(problems)

resolved, _ = _read_config(root)
assert resolved.pop("search_mode") == expected_mode
assert _path(resolved.pop("save_path")).resolve() == root
assert _path(resolved.pop("config")).resolve() == H10_ROOT / "full_suite_run_config.yaml"
assert resolved.pop("seed") == seed
assert resolved.pop("problems") == problems
assert resolved.pop("num_generations") == 5
assert resolved.pop("total_worker_slots") == 48
assert resolved.pop("max_active_problems") == 12
normalized = json.dumps(resolved, sort_keys=True, separators=(",", ":")).encode()
assert hashlib.sha256(normalized).hexdigest() == NORMALIZED_CONFIG_SHA256
assert hashlib.sha256(
    (H10_ROOT / "full_suite_run_config.yaml").read_bytes()
).hexdigest() == RUN_CONFIG_SHA256[5]

rows = _build_arm_rows(arm, root, seed, problems, 5, program, {}, headline)
assert all(row["unit_status"] == "complete" for row in rows)
candidates = sum(row["candidate_count"] for row in rows)
calls = sum(row["llm_calls"] for row in rows)
tokens = sum(row["llm_tokens"] for row in rows)
synthesis = sum(row["synthesis_evaluations"] for row in rows)
worksheet = _load_worksheet(H10_ROOT / "candidate_budget.yaml")
caps = {row["id"]: row["caps"] for row in worksheet["arms"]}[arm_id]
assert candidates == caps["candidates"] == 2400
assert calls <= caps["calls"]
assert tokens <= caps["tokens"]
assert synthesis <= caps["synthesis"]

manifest = root / "arm_evidence_manifest.sha256"
assert not manifest.exists() and not accounting.exists()
paths = {
    path.resolve()
    for path in root.rglob("*")
    if path.is_file() and path.resolve() != manifest.resolve()
} | set(extras)
assert all(path.is_file() for path in paths)
lines = [
    f"{hashlib.sha256(path.read_bytes()).hexdigest()}  "
    f"{os.path.relpath(path, root)}"
    for path in sorted(paths)
]
manifest.write_text("\n".join(lines) + "\n", encoding="utf-8")
wall, evidence, evidence_sha256 = _read_run_wall(root, extras)
assert wall <= caps["wall_seconds"]

payload = {
    "version": 1,
    "candidate_id": "H10",
    "worksheet_sha256": "d7bd17b10e21a2acd970d43feb75603d83b57530efd27fcf38aa2323663a7378",
    "arm_id": arm_id,
    "arm_status": "completed",
    "captured_at_utc": datetime.now(timezone.utc).isoformat(),
    "evidence_path": str(evidence),
    "evidence_sha256": evidence_sha256,
    "candidates": candidates,
    "calls": calls,
    "tokens": tokens,
    "synthesis": synthesis,
    "wall_seconds": format(Decimal(str(wall)), "f"),
}
accounting.write_text(yaml.safe_dump(payload, sort_keys=False), encoding="utf-8")
print(json.dumps(payload, indent=2))
PY
```

## Record One Arm

```bash
set -euo pipefail
status="$(
  uv run python scripts/tcad_candidate_admission.py record \
    --worksheet "$H10/candidate_budget.yaml" \
    --actual "$OPS/accounting/${ARM_ID}.yaml"
)"
test "$status" = PASS
printf '%s\n' "$status"
```

## Per-Arm Variable Blocks

Run the four blocks above after each exact assignment, in this order.

```bash
SEED=1001
ARM=classic
ARM_ID=seed_1001_classic
MODE=revolution
TIMEOUT=5125
EXTRA=
```

```bash
SEED=1001
ARM=treatment
ARM_ID=seed_1001_treatment
MODE=revolution_verified_status_feedback
TIMEOUT=5125
EXTRA=
```

```bash
SEED=1002
ARM=classic
ARM_ID=seed_1002_classic
MODE=revolution
TIMEOUT=4985
EXTRA=
```

```bash
SEED=1002
ARM=treatment
ARM_ID=seed_1002_treatment
MODE=revolution_verified_status_feedback
TIMEOUT=4985
EXTRA="$RAW/unit_failures.yaml"
```

## Canonical Full-Suite Report

Run only after the final treatment record prints exactly `PASS`:

```bash
set -euo pipefail
test ! -e "$REPORT"
uv run python scripts/report_verified_status_feedback.py \
  --manifest "$H10/full_suite_report_manifest.yaml" \
  --output-dir "$REPORT"

uv run python - <<'PY'
import json
from pathlib import Path

path = Path(
    "/workspace/exp/tcad_revolution_extension/"
    "h10_verified_status_feedback/wave2/reports/full_suite/summary.json"
)
summary = json.loads(path.read_text(encoding="utf-8"))
assert summary["stage"] == "full_suite"
assert summary["validated_arm_units"] == 200
assert summary["smoke_prerequisite"]["smoke_gate"] == "PASS"
assert summary["performance_gate"] in {"VIABLE", "RETIRED", "BLOCKED"}
assert len(summary["resource_totals"]) == 4
print(json.dumps({
    "performance_gate": summary["performance_gate"],
    "gate_results": summary["gate_results"],
    "breadth": summary["breadth"],
    "statistics": summary["statistics"],
}, indent=2, sort_keys=True))
PY
```

Do not launch confirmation or holdout work from this result. First preserve the
report, run an independent raw-evidence audit, and record H10 as exactly
`VIABLE`, `RETIRED`, or `BLOCKED` under the frozen gates. CVDP confirmation and
holdout remain forbidden without the prospective evaluator-composition fix.
