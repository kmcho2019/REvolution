# Reusable Config Snapshot Implementation Plan

## Objective

Improve auto-saved run YAML snapshots so they are directly reusable as `--config`
inputs, while preserving provenance metadata, and extend this behavior to
ablation orchestration. Validate with tests and short real LLM-backed runs.

This plan is tracked in-repo to keep implementation and validation auditable.

## Scope

- Flat runnable config snapshots for:
  - `scripts/run_backend.py`
  - `scripts/run_evolution.py`
  - `scripts/run_one_shot.py`
  - `scripts/run_backend_ablation.py`
- Metadata sidecar snapshots (`*_meta.yaml`) for reproducibility context.
- Backward compatibility with legacy nested snapshots (`resolved_arguments`).
- Ablation top-level config snapshot generation.
- Defaults:
  - strategy selection default: `ucb`
  - CVDP simulation timeout default: `120` seconds with CLI override.
- Tests + short real run validation matrix.

## Implementation Checklist

- [x] Add/adjust config normalization and snapshot writing in `src/revolution/configuration.py`.
- [x] Ensure generated primary `*_config.yaml` files are runnable flat configs.
- [x] Generate sidecar metadata `*_config_meta.yaml`.
- [x] Add legacy snapshot compatibility (`resolved_arguments` extraction).
- [x] Add type coercion for config-loaded defaults to match argparse types.
- [x] Add `--config` support and top-level snapshot output in `scripts/run_backend_ablation.py`.
- [x] Change strategy-selection defaults to `ucb` in relevant code paths.
- [x] Change CVDP timeout default to `120` and add `--cvdp_simulation_timeout_s`.
- [x] Update docs (README/user guide/module structure/spec references).
- [x] Add/refresh tests for roundtrip and edited-config reruns.
- [x] Execute test suite subset for changed areas.
- [x] Execute short live run matrix with generated + edited configs.
- [x] Record outputs/artifact paths in this document.

## Test Matrix

### Unit and Script Tests

- `tests/revolution/test_configuration.py`
  - flat snapshot output
  - sidecar metadata output
  - legacy snapshot loading
  - typed config coercion
- `tests/revolution/test_defaults.py`
  - `EoHEngine` default strategy
  - `RevolutionBackendConfig` default strategy
  - `CVDPEngine` default timeout
- `tests/scripts/test_run_backend.py`
  - generated config roundtrip
  - edited config rerun (`save_path` + behavioral setting)
- `tests/scripts/test_run_backend_ablation.py`
  - top-level ablation config generation
  - ablation config roundtrip
  - edited ablation config rerun

### Live Validation (Real LLM-backed runs, low budget)

- `run_backend.py --backend revolution`
- `run_backend.py --backend funsearch`
- `run_evolution.py`
- `run_one_shot.py`

For each:
1. run once to generate config,
2. rerun with generated config,
3. copy/edit config (`save_path` + at least one runtime parameter),
4. rerun and confirm effective params and output path behavior.

## Validation Log

### Automated tests

Executed on 2026-02-23 in worktree `/workspace/.worktrees/reusable-config-snapshots`:

```bash
/workspace/.venv/bin/python -m pytest \
  tests/revolution/test_configuration.py \
  tests/revolution/test_defaults.py \
  tests/scripts/test_run_backend.py \
  tests/scripts/test_run_backend_ablation.py \
  tests/scripts/test_backend_comparison_report.py \
  tests/scripts/test_archive_baseline.py
```

Result: `32 passed in 1.78s`.

### Live runs

Executed on 2026-02-23 with real vLLM backend (`vllm:8888`) and model
`/models/openai-gpt-oss-120b`, using single-problem benchmark `RTLLM-mini-live`
for low-cost validation.

Artifacts root:
- `exp/config_snapshot_live_20260223_112557`
- consolidated command/output log: `exp/config_snapshot_live_20260223_112557/live_validation.log`

Validated workflows:

1. `scripts/run_backend.py --backend revolution`
- initial run generated:
  - `exp/config_snapshot_live_20260223_112557/backend_revolution/revolution/_models_openai-gpt-oss-120b/20260223_112601_revolution_config.yaml`
- rerun with generated config succeeded (no config parse failures).
- modified-config rerun succeeded:
  - input edit: `revolution_config_modified.yaml` (`save_path`, `population_size`)
  - output config reflected edited values:
    - `exp/config_snapshot_live_20260223_112557/backend_revolution_modified/revolution/_models_openai-gpt-oss-120b/20260223_112632_revolution_config.yaml`

2. `scripts/run_backend.py --backend funsearch`
- initial run generated:
  - `exp/config_snapshot_live_20260223_112557/backend_funsearch/funsearch/_models_openai-gpt-oss-120b/20260223_112639_funsearch_config.yaml`
- rerun with generated config succeeded.
- modified-config rerun succeeded:
  - input edit: `funsearch_config_modified.yaml` (`save_path`, `fs_max_evaluations`)
  - output config reflected edited values:
    - `exp/config_snapshot_live_20260223_112557/backend_funsearch_modified/funsearch/_models_openai-gpt-oss-120b/20260223_112642_funsearch_config.yaml`

3. `scripts/run_evolution.py`
- initial run generated:
  - `exp/config_snapshot_live_20260223_112557/evolution/_models_openai-gpt-oss-120b/20260223_112646_config.yaml`
- rerun with generated config succeeded.
- modified-config rerun succeeded:
  - input edit: `evolution_config_modified.yaml` (`save_path`, `population_size`)
  - output config reflected edited values:
    - `exp/config_snapshot_live_20260223_112557/evolution_modified/_models_openai-gpt-oss-120b/20260223_112646_config.yaml`

4. `scripts/run_one_shot.py`
- initial run generated:
  - `exp/config_snapshot_live_20260223_112557/one_shot/_models_openai-gpt-oss-120b/20260223_112648_config.yaml`
- rerun with generated config succeeded.
- modified-config rerun succeeded:
  - input edit: `one_shot_config_modified.yaml` (`save_path`, `num_samples`)
  - output config reflected edited values:
    - `exp/config_snapshot_live_20260223_112557/one_shot_modified/_models_openai-gpt-oss-120b/20260223_112649_config.yaml`

5. `scripts/run_backend_ablation.py`
- initial run generated top-level ablation config + sidecar:
  - `exp/config_snapshot_live_20260223_112557/ablation/20260223_112656_ablation_config.yaml`
  - `exp/config_snapshot_live_20260223_112557/ablation/20260223_112656_ablation_config_meta.yaml`
- rerun with generated ablation config succeeded.
- modified-config rerun succeeded:
  - input edit: `ablation_config_modified.yaml` (`save_root`, `seeds`)
  - output config reflected edited values:
    - `exp/config_snapshot_live_20260223_112557/ablation_modified/20260223_112702_ablation_config.yaml`

Notes:
- These live checks validated config roundtrip/reusability and argument parity.
- Problem-level benchmark outcomes in this low-budget run were mostly non-success
  statuses (for example `failed`, `initialization_failed`, `single_shot_failed`),
  which does not affect the config snapshot feature validation objective.

## Commit Blueprint (for eventual merge; do not merge now)

When this worktree is later merged, split into signed, multi-line conventional commits:

1. `feat(config): make generated run configs directly reusable`
   - flat runnable snapshots
   - metadata sidecars
   - legacy snapshot compatibility
2. `feat(ablation): add top-level ablation config snapshots and config ingestion`
3. `feat(defaults): set strategy default to ucb and cvdp timeout to 120s`
4. `test(config): add snapshot roundtrip and edited-config rerun coverage`
5. `docs(config): document runnable snapshots, sidecars, and validation workflow`

Each commit should include:

- detailed multi-line message body,
- explicit test evidence block,
- `Signed-off-by` trailer (`-s`).

### Implemented branch stack (2026-02-23)

Current worktree branch `feat/reusable-config-snapshots` is already organized
into signed, multi-line commits and can be merged/cherry-picked in order:

1. `66e6afcc6e` `feat(config): make run snapshots reusable and extend ablation config support`
2. `2de198bcb1` `test(config): cover config roundtrip and edited-yaml reruns`
3. `0c9f421047` `docs(config): document reusable snapshots and validation plan`
