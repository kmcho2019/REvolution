# T24 SR Pareto Live Validation Artifacts Manifest

Status: ready-to-run live validation package for SR-family local-Pareto QD.

## Preflight

- endpoint: `http://20.0.0.103:8000/v1`
- command:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

- captured locally:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/preflight/models_20260621_184346_UTC.json`
- committed mirror:
  `tables/preflight_models_20260621_184346_UTC.json`
- sha256:
  `7286fa860e28d21680352c03d8352b44523fe651bb4c11378a607c391f9422b9`
- model id: `openai/gpt-oss-120b`
- max model length: `131072`
- token-policy verdict: passes `>=128000` requirement

## Fixed Inputs

- live output root:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/`
- branch: `feat/journal-useful-bd-exp-20260622`
- seed: `1001`
- population size: `12`
- generations: `3`
- model: `openai/gpt-oss-120b`
- endpoint: `20.0.0.103:8000`
- `max_tokens`: `128000`
- `diff_max_tokens`: `128000`
- `vllm_min_model_len`: `128000`
- temperature: `1.0`
- top_p: `1.0`
- evaluation mode: `strict_ablation`
- problems:
  - `RTLLM/Prob045_alu`
  - `RTLLM/Prob041_traffic_light`
  - `RTLLM/Prob015_multi_pipe_8bit`

## Descriptor Artifacts

T24 reuses frozen descriptor profiles from the prior Auto-BD work. These are
read-only provenance files, not new generated artifacts:

- random control profile:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/00_random_descriptor/descriptor_profile.yaml`
- manual-BD archive-only profile: `journal_logic_ff_width_3d`
- SR raw PCA profile:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml`
- SR ReLU PCA profile:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile_random_relu.yaml`
- SR-RFF PCA profile:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile_rff.yaml`

## Command Artifacts

- command matrix: `tables/run_matrix.csv`
- validator subset: `tables/live_screen_v0_subset.yaml`
- runnable command reference: `commands/live_screen_v0.md`

All commands write to `exp/useful_bd_push/`; none write new artifacts under
`/aux`.

## Existing Code Path

No new archive implementation was added for T24. The live method uses existing
repo-native knobs:

- `--qd_cell_mode pareto_front`
- `--qd_max_elites_per_cell 5`
- `--qd_parent_selection nsga2_global_rank`
- `--qd_champion_lane_fraction 0.5`
- `--qd_objectives ppa`

Relevant implementation/tests:

- `src/revolution/qd/archive.py`
- `src/revolution/qd/engine.py`
- `tests/revolution/test_qd_archive.py`
- `tests/revolution/test_qd_engine.py`
- `tests/scripts/test_validate_pareto_front_run.py`

## Missing Results

No live T24 run has completed in this package yet. Until it does:

- `results_report.md` is a readiness report, not a results claim;
- tier remains `pending_live_run`;
- no T1/T2/T3 conclusion is allowed.
