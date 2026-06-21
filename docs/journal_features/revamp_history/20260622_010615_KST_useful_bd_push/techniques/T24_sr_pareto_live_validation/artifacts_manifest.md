# T24 SR Pareto Live Validation Artifacts Manifest

Status: partial live result. The classic, random descriptor, SR-RFF PCA,
SR ReLU PCA, and SR raw PCA arms have completed; the full six-arm live matrix
is still pending.

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

Second live-arm preflight:

- captured locally:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/preflight/models_20260621_192641_UTC.json`
- committed mirror:
  `tables/preflight_models_20260621_192641_UTC.json`
- sha256:
  `c43da529f2e1f9d6b8d94e232fe6ab24b787b984fceb274f58b58caeb50ae0cb`
- model id: `openai/gpt-oss-120b`
- max model length: `131072`
- token-policy verdict: passes `>=128000` requirement

Third live-arm preflight:

- captured locally:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/preflight/models_20260621_195144_UTC.json`
- committed mirror:
  `tables/preflight_models_20260621_195144_UTC.json`
- sha256:
  `c37ae65f39a572fead377d75271da8d88fa74a6cd381c5c63eb4e1c62e65a01b`
- model id: `openai/gpt-oss-120b`
- max model length: `131072`
- token-policy verdict: passes `>=128000` requirement

Fourth live-arm preflight:

- captured locally:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/preflight/models_20260621_201337_UTC.json`
- committed mirror:
  `tables/preflight_models_20260621_201337_UTC.json`
- sha256:
  `3b1be131ab2840dc18420af465cbdbf8e31817730720f2becc32872f89378892`
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
- random descriptor summary:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/random_descriptor_qd/seed_1001/openai_gpt-oss-120b/20260621_201359_revolution_summary_results.txt`
  - sha256:
    `1aadecb7635849805c0c5d7aac66ca0a95324434616f5d9acabb3f09af69ab6c`
- random descriptor run log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/random_descriptor_qd/seed_1001/openai_gpt-oss-120b/20260621_201359_revolution_run_log.txt`
  - sha256:
    `e69115ba519d32c17ef9a2db1452e4db3e8cce2061e9b8b26a4edc007ec3d0a5`
- random descriptor scheduler telemetry:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/random_descriptor_qd/seed_1001/openai_gpt-oss-120b/20260621_201359_revolution_scheduler_telemetry.json`
  - sha256:
    `e9cd63fcdb372b0bb3dea770c16b88f025611c08b6a5446feacc9164e963b02c`
- random descriptor console log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/logs/random_descriptor_qd_seed_1001.log`
  - sha256:
    `44499e8a9af345eaaa53fe82c0b0b17083233e31dcffd8575e4a8d2ec36f9de8`
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
- SR ReLU summary:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/sr_random_relu_pca_qd/seed_1001/openai_gpt-oss-120b/20260621_192708_revolution_summary_results.txt`
  - sha256:
    `7bf550bc2d58e54b3732eb7fbb2182bf8fcc92b0607e1aba13940a7231c0b6f6`
- SR ReLU run log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/sr_random_relu_pca_qd/seed_1001/openai_gpt-oss-120b/20260621_192708_revolution_run_log.txt`
  - sha256:
    `c76ca1bc3e54e086ef6369ca6d84e76eccadfe9522a67f655f9653425b2f25d4`
- SR ReLU scheduler telemetry:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/sr_random_relu_pca_qd/seed_1001/openai_gpt-oss-120b/20260621_192708_revolution_scheduler_telemetry.json`
  - sha256:
    `d6a2de9d77c309f848bdd5f125f3f1bce505ed7112e3d45f70687aa6feea7fc1`
- SR ReLU console log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/logs/sr_random_relu_pca_qd_seed_1001.log`
  - sha256:
    `ac12c721dbe2fedfedb8538412ce8fa2dc328cd9a7aa67e666b91306dbf316a6`
- SR raw summary:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b/20260621_195210_revolution_summary_results.txt`
  - sha256:
    `08b1abaf3e80b54b89a051432a45ae2288820e4e582c5252b4076192cfbdd44f`
- SR raw run log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b/20260621_195210_revolution_run_log.txt`
  - sha256:
    `901bec42d3f4d58f9536f91f7fc29062c21e8669dddf0de2fefe762ace5c754f`
- SR raw scheduler telemetry:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b/20260621_195210_revolution_scheduler_telemetry.json`
  - sha256:
    `17ffc3603ab1a8ccd55ecc6111cd869c8f9fd2515824c4dcddea68074f11ece9`
- SR raw console log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/logs/sr_raw_pca_qd_seed_1001.log`
  - sha256:
    `e08ae4a2e232d93692dd8128aab49493d46ece7be2d1324adf3854ef1e12c2c5`

## Packaged Result Mirrors

- completed-QD comparison table:
  `tables/live_completed_qd_vs_classic.csv`
  - sha256:
    `3a2e0f3d3135e676fb139d56fbf572e251b4183ebac41c1076f2a5d5e78d3e7a`
- completed SR-family comparison table:
  `tables/live_sr_family_vs_classic.csv`
  - sha256:
    `59037a8fa9124f035df9c57766937cdb1dd8c76dc733460a43a45a017d42aa96`
- comparison table: `tables/live_sr_rff_vs_classic.csv`
  - sha256:
    `5716714c5c63b70a34ffb5e876ea38ec8bf12ed87a2ccb3a94667cdf8d385359`
- Pareto validator JSON: `tables/live_sr_rff_pareto_validation.json`
  - sha256:
    `45e136a600d2ab8187145cdea79ba1f2d31c27f9bcb3a454c54a59c17f08a9e5`
- Pareto validator Markdown: `tables/live_sr_rff_pareto_validation.md`
  - sha256:
    `531c591e0d1ac50d9bd114a33efbff017625f4610e0c5df6884cbe2033d03ae3`
- random Pareto validator JSON: `tables/live_random_pareto_validation.json`
  - sha256:
    `4272ad18e9a482a479b2ad65d568285f76ffac7588eece3e85d6f5fedf54893c`
- random Pareto validator Markdown:
  `tables/live_random_pareto_validation.md`
  - sha256:
    `2b2e9d09b9f7463c23ab2c76d6471c52a35f086955c620a23bb52602ed6a2806`
- SR ReLU Pareto validator JSON: `tables/live_sr_relu_pareto_validation.json`
  - sha256:
    `cb4f6d76371657b680ae5d0f1ff90d16da180a8411421bffce5041e48b9ea3f5`
- SR ReLU Pareto validator Markdown:
  `tables/live_sr_relu_pareto_validation.md`
  - sha256:
    `03550cd366121937907fbd084784264b69f3d233aef969441aab57034e446367`
- SR raw Pareto validator JSON: `tables/live_sr_raw_pareto_validation.json`
  - sha256:
    `078685386da062f85d34b0c8505beaa4fa07d47db7af8c8207b3eaa377698d1d`
- SR raw Pareto validator Markdown:
  `tables/live_sr_raw_pareto_validation.md`
  - sha256:
    `e3e6ae6eaa79d97f9a32107f759b725793d4c37d38eadb05f812c50e5c2007ce`
- completed SR-family figure: `figures/live_sr_family_vs_classic.png`
  - sha256:
    `042383c5951f04aace7d7afe30fd1f999bfacbcdb4247f97314d7b2c894bd3c6`
- completed-QD comparison figure: `figures/live_completed_qd_vs_classic.png`
  - sha256:
    `ff3f27235c95922dba823c7956b6fa440db6d1cece538942f0a0cda3524d139e`
- SR-RFF comparison figure: `figures/live_sr_rff_vs_classic.png`
  - sha256:
    `adcc7ec52d50f551bd89cb912bc0575086530a5256f8d3ebd5bf201eb036e942`
- packaging script: `scripts/package_t24_sr_rff_live_result.py`

The validator was run without `--acceptance-hard-subset` because that flag
currently asserts the manual-BD descriptor profile. Classic-covered design
preservation was checked from the summary files instead: all completed arms
produce valid results on all three fixed problems.

## Missing Results

The following T24 live arms are still missing:

- `landing_smooth_qd_manual_bd`

Until that arm lands, T24 remains `pending_live_matrix` and no positive
T1/T2/T3 claim is allowed.
