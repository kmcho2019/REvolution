# T48 Artifacts Manifest

Status: pre-registered. Implementation and live result are pending.

## Method Sources

Expected source touch points:

- `src/revolution/qd/engine.py`
- `src/revolution/backends/revolution_backend.py`
- `scripts/run_backend.py`
- focused QD parent-selection tests under `tests/revolution/`

The implementation must keep `qd_two_parent_gate=none` as the default so prior
T26/T47 behavior is unchanged.

## Planned Live Run

- run root:
  `exp/useful_bd_push/t48_t26_gated_near_front_fusion_<timestamp>/hard_tuning`
- candidate backend:
  `t26_gated_near_front_fusion_qd`
- comparator backend:
  T47 `classic_revolution` seeds `1001` and `1002`
- fixed subset:
  `data/configs/hard_iteration_subset.yaml`
- command card:
  `commands/hard_tuning_sanity.md`

## Required Result Artifacts

- vLLM `/v1/models` preflight metadata;
- T48 live command log;
- per-problem/seed metrics table;
- aggregate metrics table;
- validity gate table;
- candidate-level PPA data;
- direct raw area-power PPA-front figures;
- visual inspection notes;
- results report with T0/T1/T2/T3 tier decision.

If archive artifacts are complete, add the full Phase 03.1
`visualizations/qd_ppa_viewer/` bundle beside the direct PPA-front supplement.
