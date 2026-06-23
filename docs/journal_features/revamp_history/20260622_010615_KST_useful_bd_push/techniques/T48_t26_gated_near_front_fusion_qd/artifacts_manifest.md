# T48 Artifacts Manifest

Status: seeds `1001` and `1002` complete; hard/tuning package generated.

## Method Sources

Implemented source touch points:

- `src/revolution/qd/engine.py`
- `src/revolution/backends/revolution_backend.py`
- `scripts/run_backend.py`
- `tests/revolution/test_qd_engine.py`
- `tests/revolution/test_revolution_backend.py`

The implementation must keep `qd_two_parent_gate=none` as the default so prior
T26/T47 behavior is unchanged.

Focused validation:

- `uv run pytest tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py -q`
- `uv run ruff check src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py scripts/run_backend.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py`
- `uv tool run ty check src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
- `uv run python -m pyright src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`

## Live Run

- completed seeds:
  `1001`, `1002`
- run root:
  `exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning`
- candidate backend:
  `t26_gated_near_front_fusion_qd`
- comparator backend:
  T47 `classic_revolution` seeds `1001` and `1002`
- fixed subset:
  `data/configs/hard_iteration_subset.yaml`
- command card:
  `commands/hard_tuning_sanity.md`
- preflight:
  `preflight/models_20260622_225714_UTC.json`
- seed-1002 preflight:
  `preflight/models_seed1002_20260622_232737_UTC.json`
- seed-1001 summary:
  `t26_gated_near_front_fusion_qd/seed_1001/openai_gpt-oss-120b/20260622_225715_revolution_summary_results.txt`
- seed-1001 scheduler telemetry:
  `t26_gated_near_front_fusion_qd/seed_1001/openai_gpt-oss-120b/20260622_225715_revolution_scheduler_telemetry.json`
- seed-1002 summary:
  `t26_gated_near_front_fusion_qd/seed_1002/openai_gpt-oss-120b/20260622_232739_revolution_summary_results.txt`
- seed-1002 scheduler telemetry:
  `t26_gated_near_front_fusion_qd/seed_1002/openai_gpt-oss-120b/20260622_232739_revolution_scheduler_telemetry.json`

## Required Result Artifacts

- vLLM `/v1/models` preflight metadata: present for seed `1001`;
- T48 live command log: present for seed `1001`;
- per-problem/seed metrics table:
  `hard_tuning_package/tables/t48_problem_seed_metrics.csv`;
- aggregate metrics table:
  `hard_tuning_package/tables/t48_aggregate_metrics.csv`;
- validity gate table:
  `hard_tuning_package/tables/t48_validity_gates.csv`;
- candidate-level PPA data:
  `hard_tuning_package/data/t48_ppa_candidates.csv`;
- direct raw area-power PPA-front figures:
  `hard_tuning_package/figures/t48_direct_ppa_fronts_seed1001.png`,
  `hard_tuning_package/figures/t48_direct_ppa_fronts_seed1002.png`;
- direct PPA HTML supplement:
  `visualizations/direct_ppa_pareto/index.html`;
- full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`;
- viewer screenshot:
  `visualizations/qd_ppa_viewer/screenshot.png`;
- visual inspection notes:
  `hard_tuning_package/figures/visual_inspection_notes.md`;
- results report with tier decision:
  `results_report.md`.

Validation caveat: the Phase 03.1 viewer passes non-strict validation, but
strict validation fails because classic candidates cannot be honestly projected
into the learned `sr_pca_3d` archive space. The export therefore used
`--no-classic-descriptor-recovery`.
