# T24 SR Pareto Live Validation Artifacts Manifest

Status: partial live result. The classic and SR-RFF PCA arms have completed;
the full six-arm live matrix is still pending.

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

## Completed Live Result Artifacts

- classic summary:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/classic_revolution/seed_1001/openai_gpt-oss-120b/20260621_185250_revolution_summary_results.txt`
  - sha256:
    `fa30592847b46e137c9262b49b37cebba224351b171ee6ade3089ab9936861ff`
- classic run log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/classic_revolution/seed_1001/openai_gpt-oss-120b/20260621_185250_revolution_run_log.txt`
  - sha256:
    `02ea064f903998b6f5b7097f4c68c8896cbd8ef8d4ae2ab28f0727bf31b9f13d`
- classic console log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/logs/classic_revolution_seed_1001.log`
  - sha256:
    `63fa2fd96d5e3c503fa0ac5e49f3e369735487d71e516b0598d144e9b3e1208c`
- SR-RFF summary:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/sr_rff_pca_qd/seed_1001/openai_gpt-oss-120b/20260621_190410_revolution_summary_results.txt`
  - sha256:
    `547c773906a2b6a2b206a18a11fc41eb40f64ff88e62d168813a4b6e04e606f0`
- SR-RFF run log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/sr_rff_pca_qd/seed_1001/openai_gpt-oss-120b/20260621_190410_revolution_run_log.txt`
  - sha256:
    `6dffd506f63339617638540dbd1b54bad9baf94366be99c9a2de898ea46cc35c`
- SR-RFF console log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/logs/sr_rff_pca_qd_seed_1001.log`
  - sha256:
    `9ab82a45bf5e7b76c7f294258696240343b3d115a8b309c4254aab20939310dd`

## Packaged Result Mirrors

- comparison table: `tables/live_sr_rff_vs_classic.csv`
  - sha256:
    `71e5b57abc19e222e3a79761ab1f6ec512efbda326a57df62e1e36de1c0959d3`
- Pareto validator JSON: `tables/live_sr_rff_pareto_validation.json`
  - sha256:
    `45e136a600d2ab8187145cdea79ba1f2d31c27f9bcb3a454c54a59c17f08a9e5`
- Pareto validator Markdown: `tables/live_sr_rff_pareto_validation.md`
  - sha256:
    `531c591e0d1ac50d9bd114a33efbff017625f4610e0c5df6884cbe2033d03ae3`
- figure: `figures/live_sr_rff_vs_classic.png`
  - sha256:
    `adcc7ec52d50f551bd89cb912bc0575086530a5256f8d3ebd5bf201eb036e942`
- packaging script: `scripts/package_t24_sr_rff_live_result.py`

The validator was run without `--acceptance-hard-subset` because that flag
currently asserts the manual-BD descriptor profile. Classic-covered design
preservation was checked from the summary files instead: both completed arms
produce valid results on all three fixed problems.

## Missing Results

The following T24 live arms are still missing:

- `landing_smooth_qd_manual_bd`
- `random_descriptor_qd`
- `sr_raw_pca_qd`
- `sr_random_relu_pca_qd`

Until those arms land, T24 remains `pending_live_matrix` and no positive
T1/T2/T3 claim is allowed.
