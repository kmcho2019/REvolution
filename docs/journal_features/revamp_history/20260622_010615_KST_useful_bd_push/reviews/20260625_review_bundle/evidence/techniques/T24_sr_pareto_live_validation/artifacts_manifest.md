# T24 SR Pareto Live Validation Artifacts Manifest

Status: complete six-arm live development-screen result.

## Preflight

- endpoint: `http://20.0.0.103:8000/v1`
- preflight command:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Every captured preflight reported `openai/gpt-oss-120b` with
`max_model_len=131072`, satisfying the `>=128000` token-policy requirement.

| Arm batch | Local capture | Committed mirror | sha256 |
| --- | --- | --- | --- |
| classic/SR-RFF | `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/preflight/models_20260621_184346_UTC.json` | `tables/preflight_models_20260621_184346_UTC.json` | `7286fa860e28d21680352c03d8352b44523fe651bb4c11378a607c391f9422b9` |
| SR ReLU | `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/preflight/models_20260621_192641_UTC.json` | `tables/preflight_models_20260621_192641_UTC.json` | `c43da529f2e1f9d6b8d94e232fe6ab24b787b984fceb274f58b58caeb50ae0cb` |
| SR raw | `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/preflight/models_20260621_195144_UTC.json` | `tables/preflight_models_20260621_195144_UTC.json` | `c37ae65f39a572fead377d75271da8d88fa74a6cd381c5c63eb4e1c62e65a01b` |
| random | `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/preflight/models_20260621_201337_UTC.json` | `tables/preflight_models_20260621_201337_UTC.json` | `3b1be131ab2840dc18420af465cbdbf8e31817730720f2becc32872f89378892` |
| manual BD | `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/preflight/models_20260621_203536_UTC.json` | `tables/preflight_models_20260621_203536_UTC.json` | `df54be70f8e1f3ed6b8db5114aa0fbd85458dcc07f2c4c1a3bce238c2c657ecd` |

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

T24 reuses frozen descriptor profiles from prior Auto-BD work. These are
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

## Command And Code Artifacts

- command matrix: `tables/run_matrix.csv`
- validator subset: `tables/live_screen_v0_subset.yaml`
- runnable command reference: `commands/live_screen_v0.md`
- packaging script: `scripts/package_t24_sr_rff_live_result.py`

All commands write to `exp/useful_bd_push/`; none write new artifacts under
`/aux`.

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
- `tests/scripts/test_package_t24_sr_rff_live_result.py`

## Live Run Artifacts

| Arm | Summary sha256 | Run log sha256 | Scheduler sha256 | Console sha256 |
| --- | --- | --- | --- | --- |
| classic | `fa30592847b46e137c9262b49b37cebba224351b171ee6ade3089ab9936861ff` | `02ea064f903998b6f5b7097f4c68c8896cbd8ef8d4ae2ab28f0727bf31b9f13d` | not captured | `63fa2fd96d5e3c503fa0ac5e49f3e369735487d71e516b0598d144e9b3e1208c` |
| manual BD | `18ecb20b697b585468995cc05c5c38f8b80b4283da59cdb6ea95d48173f8e436` | `239f9e93e61382400ddaae406570cbfea34ac1a5b042e3b3fbc766d05f488ae8` | `027827a3ebf704bc51487be0f8e771e08ee4e24c5e0ff75c7b487492fc1e7cac` | `543aadaba63a5fc07e34a39a1b1305af81a74fa7cb535fbee7d115378acc94f3` |
| random | `1aadecb7635849805c0c5d7aac66ca0a95324434616f5d9acabb3f09af69ab6c` | `e69115ba519d32c17ef9a2db1452e4db3e8cce2061e9b8b26a4edc007ec3d0a5` | `e9cd63fcdb372b0bb3dea770c16b88f025611c08b6a5446feacc9164e963b02c` | `44499e8a9af345eaaa53fe82c0b0b17083233e31dcffd8575e4a8d2ec36f9de8` |
| SR-RFF | `547c773906a2b6a2b206a18a11fc41eb40f64ff88e62d168813a4b6e04e606f0` | `6dffd506f63339617638540dbd1b54bad9baf94366be99c9a2de898ea46cc35c` | not captured | `9ab82a45bf5e7b76c7f294258696240343b3d115a8b309c4254aab20939310dd` |
| SR ReLU | `7bf550bc2d58e54b3732eb7fbb2182bf8fcc92b0607e1aba13940a7231c0b6f6` | `c76ca1bc3e54e086ef6369ca6d84e76eccadfe9522a67f655f9653425b2f25d4` | `d6a2de9d77c309f848bdd5f125f3f1bce505ed7112e3d45f70687aa6feea7fc1` | `ac12c721dbe2fedfedb8538412ce8fa2dc328cd9a7aa67e666b91306dbf316a6` |
| SR raw | `08b1abaf3e80b54b89a051432a45ae2288820e4e582c5252b4076192cfbdd44f` | `901bec42d3f4d58f9536f91f7fc29062c21e8669dddf0de2fefe762ace5c754f` | `17ffc3603ab1a8ccd55ecc6111cd869c8f9fd2515824c4dcddea68074f11ece9` | `e08ae4a2e232d93692dd8128aab49493d46ece7be2d1324adf3854ef1e12c2c5` |

Manual BD local files:

- summary:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/landing_smooth_qd_manual_bd/seed_1001/openai_gpt-oss-120b/20260621_203559_revolution_summary_results.txt`
- run log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/landing_smooth_qd_manual_bd/seed_1001/openai_gpt-oss-120b/20260621_203559_revolution_run_log.txt`
- scheduler telemetry:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/landing_smooth_qd_manual_bd/seed_1001/openai_gpt-oss-120b/20260621_203559_revolution_scheduler_telemetry.json`
- console log:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/logs/landing_smooth_qd_manual_bd_seed_1001.log`

## Packaged Result Mirrors

| Artifact | sha256 |
| --- | --- |
| `tables/live_completed_qd_vs_classic.csv` | `ab3ce33250f8027c8b3ac9efce10330f60da4a5008b0f1d1eae133b11af331de` |
| `tables/live_sr_family_vs_classic.csv` | `59037a8fa9124f035df9c57766937cdb1dd8c76dc733460a43a45a017d42aa96` |
| `tables/live_sr_rff_vs_classic.csv` | `5716714c5c63b70a34ffb5e876ea38ec8bf12ed87a2ccb3a94667cdf8d385359` |
| `tables/live_manual_pareto_validation.json` | `eacb2a51dac230a330fd8bf1ca411cd19f64d4c649ba9bbfd6438e0f2eaa73c4` |
| `tables/live_manual_pareto_validation.md` | `147534f702d17c0cd0a5c7a89151345aadbc35f45566053731520273782419e3` |
| `tables/live_random_pareto_validation.json` | `4272ad18e9a482a479b2ad65d568285f76ffac7588eece3e85d6f5fedf54893c` |
| `tables/live_random_pareto_validation.md` | `2b2e9d09b9f7463c23ab2c76d6471c52a35f086955c620a23bb52602ed6a2806` |
| `tables/live_sr_rff_pareto_validation.json` | `45e136a600d2ab8187145cdea79ba1f2d31c27f9bcb3a454c54a59c17f08a9e5` |
| `tables/live_sr_rff_pareto_validation.md` | `531c591e0d1ac50d9bd114a33efbff017625f4610e0c5df6884cbe2033d03ae3` |
| `tables/live_sr_relu_pareto_validation.json` | `cb4f6d76371657b680ae5d0f1ff90d16da180a8411421bffce5041e48b9ea3f5` |
| `tables/live_sr_relu_pareto_validation.md` | `03550cd366121937907fbd084784264b69f3d233aef969441aab57034e446367` |
| `tables/live_sr_raw_pareto_validation.json` | `078685386da062f85d34b0c8505beaa4fa07d47db7af8c8207b3eaa377698d1d` |
| `tables/live_sr_raw_pareto_validation.md` | `e3e6ae6eaa79d97f9a32107f759b725793d4c37d38eadb05f812c50e5c2007ce` |
| `figures/live_completed_qd_vs_classic.png` | `cd95990f4c2e3accf861cd8e4a8a23127381486762fa15bb3955f0b74b07864f` |
| `figures/live_sr_family_vs_classic.png` | `b382eff69158caee757bbd8860f7f645d88f5bf05a5bfdeb1d45f4f954704dc9` |
| `figures/live_sr_rff_vs_classic.png` | `adcc7ec52d50f551bd89cb912bc0575086530a5256f8d3ebd5bf201eb036e942` |

## Missing Results

No T24 live arms are missing. T24 is complete for the three-problem
development screen, but it remains `T0 diagnostic` because the live matrix does
not satisfy promotion gates.
