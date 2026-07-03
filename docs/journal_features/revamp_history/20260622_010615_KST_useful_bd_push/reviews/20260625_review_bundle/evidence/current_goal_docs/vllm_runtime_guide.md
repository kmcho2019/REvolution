# Local vLLM Runtime Guide

This guide makes the useful-BD goal self-contained for live experiments using
local or shared vLLM instances. Treat these as known runtime targets, not as
guaranteed live services. Every run must preflight the selected endpoint and
record the returned model metadata.

## Known Endpoint Patterns

| target | endpoint | model name normally used | notes |
| --- | --- | --- | --- |
| shared host endpoint | `http://host.docker.internal:8000/v1` | `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b` | Used by prior long-token QD/REvolution runs from this workspace. Prefer this when working inside the devcontainer and the model server runs on the host. |
| compose vLLM service | `http://vllm:8888/v1` | `/models/openai-gpt-oss-120b` | Used when `.devcontainer/docker-compose.yml --profile vllm` starts the vLLM service on the compose network. |
| host-local vLLM | `http://localhost:8888/v1` | server-dependent | Used by host-side scripts or manual local runs outside the devcontainer. |
| verified GPT-OSS endpoint | `http://20.0.0.103:8000/v1` | `openai/gpt-oss-120b` | Verified from this workspace on 2026-06-21 UTC with `max_model_len=131072`. Prefer this when the shared host endpoint is reachable and the goal needs a live GPT-OSS-120B API. |

Do not assume a model path from the endpoint name. Query `/v1/models` and use
the returned `id` unless a run policy explicitly locks `--model_name`.

## Required Preflight

Run one of these before live experiments:

```bash
curl -sS --max-time 10 http://host.docker.internal:8000/v1/models
curl -sS --max-time 10 http://vllm:8888/v1/models
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

The preflight record must include:

- endpoint URL;
- returned model `id`;
- returned `max_model_len`, if present;
- command timestamp;
- whether `max_model_len >= 128000`;
- any warning or timeout.

For runner commands, keep `--vllm_min_model_len 128000` unless the command is
explicitly a tiny smoke or endpoint debugging check.

## Token Policy

For research evidence on the shared reasoning-model endpoint:

- use `--max_tokens 128000`;
- use `--diff_max_tokens 128000`;
- use `--vllm_min_model_len 128000`;
- record `temperature`, `top_p`, population, generation count, seeds, and
  worker counts.

Runs below the 128000 token budget are debug smokes only. They must not support
claims about QD archive quality, descriptor usefulness, functional yield, or
classic-vs-QD performance.

## Standard Smoke Commands

Inspect the command matrix without launching:

```bash
VLLM_HOST=host.docker.internal VLLM_PORT=8000 \
  bash scripts/run_backend_qd_smoke_vllm.sh --archive matrix --suite rtllm \
  --policy whole-heavy --dry-run
```

Run the repeatable QD smoke matrix:

```bash
VLLM_HOST=host.docker.internal VLLM_PORT=8000 \
  SMOKE_SAVE_PATH=exp/useful_bd_push/vllm_smokes \
  bash scripts/run_backend_qd_smoke_vllm.sh --archive matrix --suite rtllm \
  --policy whole-heavy
```

For the compose service, switch to:

```bash
VLLM_HOST=vllm VLLM_PORT=8888 \
  SMOKE_SAVE_PATH=exp/useful_bd_push/vllm_smokes \
  bash scripts/run_backend_qd_smoke_vllm.sh --archive matrix --suite rtllm \
  --policy whole-heavy
```

## Bounded Live QD Command Shape

Use this as the base shape for a method promoted from replay diagnostics:

```bash
OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} \
/workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --search_mode revolution_qd \
  --qd_archive_type cvt \
  --benchmarks RTLLM \
  --problems Prob043_RAM \
  --api_backend vllm \
  --vllm_host host.docker.internal \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b \
  --population_size 4 \
  --num_generations 1 \
  --total_worker_slots 1 \
  --max_workers_per_problem 1 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --temperature 1.0 \
  --top_p 1.0 \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --save_path exp/useful_bd_push/<technique>/<timestamp>/live_cvt \
  --no-backend_subdir \
  --seed 42
```

Change only the method-specific descriptor/profile/archive flags after
recording the method version in `artifacts_manifest.md`.

## Run Artifact Requirements

Every live run root must include or reference:

- `/v1/models` preflight JSON or text capture;
- full command line;
- environment overrides: `VLLM_HOST`, `VLLM_PORT`,
  `VLLM_MIN_MODEL_LEN`, `OPENAI_API_KEY` placeholder status;
- resolved model id and model path;
- token budgets;
- runner stdout/stderr;
- timeout or blocked status if the endpoint was reachable but the run did not
  finish;
- generated archive, PPA, validity, and visualization artifacts.

The technique `artifacts_manifest.md` must mirror these fields so the run can
be reproduced without searching shell history.

## Failure Policy

- If preflight fails, record the endpoint, command, timeout, and next endpoint
  to try.
- If preflight succeeds but `max_model_len < 128000`, the endpoint can be used
  only for debug smokes unless a new run policy justifies a lower context
  requirement.
- If the model endpoint is reachable but a live run times out, record the
  partial output path and decide whether to reduce problem count, population,
  or generation count before changing descriptor methodology.
- Do not switch endpoints mid-comparison unless the change is registered as a
  new method/run version.
