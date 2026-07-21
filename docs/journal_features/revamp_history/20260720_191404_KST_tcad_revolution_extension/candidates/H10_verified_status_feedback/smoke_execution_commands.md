# H10 Frozen Smoke Execution Commands

Status: `FROZEN_BEFORE_ADMISSION`; drafted at `2026-07-21T12:57:53Z` and
closed by independent rereview at `2026-07-21T13:10:47Z`.

Run only the two sequential RTLLM smoke arms below. A command failure, timeout,
non-`PASS` admission/accounting result, incomplete arm, or reporter `STOP`
forbids every later command and every full-suite arm.

## Pins

- Corrected runtime commit:
  `ed5863c5fa578a0a5a2ffb73d1aebef44e67f8e8`.
- Implementation-manifest commit:
  `11ad5ccabcbc954909201543ea29cd8d633f38dc`.
- Implementation-manifest SHA-256:
  `c0ef63b5852252bee8d2128b557d433543e50042e096fb0a6181cc7bd0f9a582`.
- Program-manifest-v8 SHA-256:
  `26c83aa4ea6a01ef31f0757a560564c1df1c86ee42745242aad88eaf4ef83666`.
- Worksheet SHA-256:
  `d7bd17b10e21a2acd970d43feb75603d83b57530efd27fcf38aa2323663a7378`.
- Smoke run/report SHA-256:
  `20c8b3daf931b0b322568af61c9fa8a4ff85ab5da5fdcf56568cc8471702d490`,
  `4b3b027ae0f0806d8f08f997d700acac12fa5dfd90cc6c2896318aedf7e8be2e`.
- Endpoint/model: `http://20.0.0.103:8000`,
  `openai/gpt-oss-120b`, minimum context 128,000.
- Arm cap: 48 candidates, 300 calls, 265,153 tokens, 35 synthesis
  starts, and 161 wall seconds independently per arm.

## Setup And Preflight

Run from `/workspace` in one shell:

```bash
set -euo pipefail

H10=/workspace/docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/candidates/H10_verified_status_feedback
BASE=/workspace/exp/tcad_revolution_extension/h10_verified_status_feedback/wave2
RAW="$BASE/smoke"
OPS="$BASE/operations/smoke"
REPORT="$BASE/reports/smoke"

test ! -e "$RAW"
test ! -e "$REPORT"
mkdir -p "$RAW" "$OPS/accounting" "$OPS/logs" "$OPS/preflight"
printf 'version: 1\nunits: []\n' > "$RAW/unit_failures.yaml"

uv run python - <<'PY' | tee "$OPS/preflight/model.json"
import json

from revolution.vllm_preflight import preflight_vllm_model

payload = preflight_vllm_model("20.0.0.103", 8000, 128000, 5.0)
assert payload["ok"]
assert payload["model_id"] == "openai/gpt-oss-120b"
assert payload["meets_min_model_len"] is True
print(json.dumps(payload, indent=2, sort_keys=True))
PY

uv run python - <<'PY'
import yaml

from scripts.report_verified_status_feedback import (
    H10_ROOT,
    PROGRAM_MANIFEST,
    _validate_frozen_inputs,
    _validate_implementation_manifest,
)

_validate_implementation_manifest(H10_ROOT / "implementation_manifest.yaml")
assert len(_validate_frozen_inputs(yaml.safe_load(PROGRAM_MANIFEST.read_text()))) == 46
PY
```

## Classic Arm

The admission command must print `PASS`:

```bash
status="$(
  uv run python scripts/tcad_candidate_admission.py admit \
    --worksheet "$H10/candidate_budget.yaml" \
    --implementation-manifest "$H10/implementation_manifest.yaml" \
    --arm smoke_classic
)"
test "$status" = PASS
printf '%s\n' "$status"
```

Run the exact arm once. `timeout` and `pipefail` make a late arm nonzero:

```bash
test ! -e "$RAW/seed_42/classic"
timeout --signal=INT --kill-after=20s 161s \
  env OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}" \
  uv run python scripts/run_backend.py \
    --config "$H10/smoke_run_config.yaml" \
    --search_mode revolution \
    --save_path "$RAW/seed_42/classic" \
  2>&1 | tee "$OPS/logs/classic.log"
```

## Seal And Account One Arm

Run the block below after each successful arm with exactly these variables:

| Arm | `ARM` | `ARM_ID` | `ROOT` | `ACCOUNTING` | `EXTRA` |
| --- | --- | --- | --- | --- | --- |
| Classic | `classic` | `smoke_classic` | `$RAW/seed_42/classic` | `$OPS/accounting/smoke_classic.yaml` | empty string |
| Treatment | `treatment` | `smoke_treatment` | `$RAW/seed_42/treatment` | `$OPS/accounting/smoke_treatment.yaml` | `$RAW/unit_failures.yaml` |

```bash
export ARM ARM_ID ROOT ACCOUNTING EXTRA
uv run python - <<'PY'
import hashlib
import json
import os
from datetime import datetime, timezone
from decimal import Decimal
from pathlib import Path
from typing import cast

import yaml

from scripts.report_verified_status_feedback import Arm, _read_run_wall, _repair_rows

arm = cast(Arm, os.environ["ARM"])
arm_id = os.environ["ARM_ID"]
root = Path(os.environ["ROOT"]).resolve()
accounting = Path(os.environ["ACCOUNTING"]).resolve()
extra_value = os.environ["EXTRA"]
extras = (Path(extra_value).resolve(),) if extra_value else ()
problems = [
    "Prob002_adder_16bit",
    "Prob025_sequence_detector",
    "Prob043_RAM",
]

rows = _repair_rows(arm, root, problems, 1, set(), set(problems))
candidates = sum(row["candidate_count"] for row in rows.values())
calls = sum(row["llm_calls"] for row in rows.values())
tokens = sum(row["llm_tokens"] for row in rows.values())
synthesis = sum(row["synthesis_evaluations"] for row in rows.values())
assert candidates == 48
assert calls <= 300 and tokens <= 265153 and synthesis <= 35

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
assert wall <= 161

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

For classic, set these exact variables and run the block above:

```bash
ARM=classic
ARM_ID=smoke_classic
ROOT="$RAW/seed_42/classic"
ACCOUNTING="$OPS/accounting/smoke_classic.yaml"
EXTRA=
```

Then record it. The record command must print `PASS`:

```bash
status="$(
  uv run python scripts/tcad_candidate_admission.py record \
    --worksheet "$H10/candidate_budget.yaml" \
    --actual "$OPS/accounting/smoke_classic.yaml"
)"
test "$status" = PASS
printf '%s\n' "$status"
```

## Treatment Arm

Only after the classic record prints `PASS`, admit treatment. The command must
print `PASS`:

```bash
status="$(
  uv run python scripts/tcad_candidate_admission.py admit \
    --worksheet "$H10/candidate_budget.yaml" \
    --implementation-manifest "$H10/implementation_manifest.yaml" \
    --arm smoke_treatment
)"
test "$status" = PASS
printf '%s\n' "$status"
```

```bash
test ! -e "$RAW/seed_42/treatment"
timeout --signal=INT --kill-after=20s 161s \
  env OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}" \
  uv run python scripts/run_backend.py \
    --config "$H10/smoke_run_config.yaml" \
    --search_mode revolution_verified_status_feedback \
    --save_path "$RAW/seed_42/treatment" \
  2>&1 | tee "$OPS/logs/treatment.log"
```

Set the treatment row's exact variables:

```bash
ARM=treatment
ARM_ID=smoke_treatment
ROOT="$RAW/seed_42/treatment"
ACCOUNTING="$OPS/accounting/smoke_treatment.yaml"
EXTRA="$RAW/unit_failures.yaml"
```

Run the seal/account block above, then record it. The command must print
`PASS`:

```bash
status="$(
  uv run python scripts/tcad_candidate_admission.py record \
    --worksheet "$H10/candidate_budget.yaml" \
    --actual "$OPS/accounting/smoke_treatment.yaml"
)"
test "$status" = PASS
printf '%s\n' "$status"
```

## Frozen Smoke Report

The report output is a sibling of the raw root so report generation cannot
mutate sealed evidence:

```bash
test ! -e "$REPORT"
uv run python scripts/report_verified_status_feedback.py \
  --manifest "$H10/smoke_report_manifest.yaml" \
  --output-dir "$REPORT"

uv run python - <<'PY'
import json
from pathlib import Path

path = Path(
    "/workspace/exp/tcad_revolution_extension/"
    "h10_verified_status_feedback/wave2/reports/smoke/summary.json"
)
summary = json.loads(path.read_text(encoding="utf-8"))
assert summary["smoke_gate"] == "PASS"
assert all(summary["gate_results"].values())
print(json.dumps(summary["gate_results"], indent=2, sort_keys=True))
PY
```

Full-suite admission remains forbidden until the smoke package receives an
independent raw-evidence audit and the candidate state advances to
`SMOKE_VALIDATED`.
