# T30 Artifacts Manifest

Status: live run packaged.

## Run

| Item | Value |
| --- | --- |
| Package | `T30_t26_holdout_front_audit` |
| Run root | `exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/` |
| Arms | `classic_revolution`, `sr_raw_conservative_exploit_qd` |
| Seed | `1001` |
| Model | `openai/gpt-oss-120b` |
| Endpoint | `http://20.0.0.103:8000/v1` |
| Token budget | `--max_tokens 128000 --diff_max_tokens 128000` |
| Benchmark | `VerilogEval-Spec-to-RTL` |
| Problems | `Prob150_review2015_fsmonehot`, `Prob098_circuit7`, `Prob135_m2014_q6b` |
| Classic runtime | `580.04` seconds |
| T26 runtime | `646.44` seconds |

## Source Artifacts

| Artifact | SHA256 |
| --- | --- |
| `exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/preflight/models_20260621_233506_UTC.json` | `685ace0537c0caa4a1a7a8f57e899f100a3380211814e70527f6586fdad451ce` |
| `exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/logs/classic_revolution_seed_1001.log` | `7bd6a41da2ec8c79dd19b7efd0f0dd89cc32878351d9e7e7daa88f90e19c22cf` |
| `exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/logs/sr_raw_conservative_exploit_qd_seed_1001.log` | `32ca11aefab2962930d598084c4a13ff11aeb97ceeb18e339faa0de658dfe407` |
| `exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/classic_revolution/seed_1001/openai_gpt-oss-120b/20260621_233528_revolution_summary_results.txt` | `c7f6920ef036a7c8afa8b3c0a702d25acfca0ba6b9c01234f81ee8a8ae1e81fe` |
| `exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b/20260621_234528_revolution_summary_results.txt` | `7f0f48b1b5a9629a2b5136f07f39181c6982ea0f6205227a4f7096131e923040` |

## Packaged Tables

| Artifact | SHA256 |
| --- | --- |
| `tables/t30_holdout_live_aggregate_metrics.csv` | `bd734754c979c915eb76e92e98651c14572b143e353aa0853431075ea837accb` |
| `tables/t30_holdout_live_problem_metrics.csv` | `30c381f5f47d57c51db9826358c91ae20a1b9be1126af994b50afe7c97ada533` |
| `tables/t30_holdout_family_aggregate_metrics.csv` | `4aad49400d815d59fc5cf610d520037bba6eb500d71cc562ae13b79adde685b6` |
| `tables/holdout_t26_pareto_validation.json` | `ebb36571f08733ee52d31d819d2d52c2ae11356d4f3b72d987a9c3790cc61275` |

## Packaged Figures

| Artifact | SHA256 |
| --- | --- |
| `figures/t30_holdout_ppa_pareto_area_power_candidate_zoom.png` | `4736594605cf83bbc0784e294a9b9bf91855a858ce711bc205e0f824dd819be0` |
| `figures/t30_holdout_ppa_pareto_area_power.png` | `c6c07bb3c565c2e826274f1e53d12faa98f52a5e5a23ba026695195da5193b8b` |
| `figures/t30_holdout_ppa_fronts_improvement.png` | `940464e82ee373c1e553eb527b7719fd2a20d2a5d5e531f15ed25c0d61b6b039` |

## Reproduction

The packaging command was:

```bash
/workspace/.venv/bin/python -m scripts.package_t30_holdout_front_audit \
  --run-root exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T30_t26_holdout_front_audit
```

The T26 Pareto archive validation command is recorded in
`commands/live_holdout_v0.md`.
