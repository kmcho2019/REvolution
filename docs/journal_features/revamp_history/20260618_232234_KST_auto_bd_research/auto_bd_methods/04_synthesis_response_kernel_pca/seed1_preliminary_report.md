# SR Raw PCA QD Seed-1 Preliminary Report

## Scope

This is a development-subset seed-1 sanity report for `sr_raw_pca_qd`.
It checks whether the frozen SR-PCA descriptor can run in-loop without
breaking repair/PPA coverage. It is not a seed-3 screening report or a
final method claim.

## Run Policy

- Phase: `development_preliminary_seed1`
- Method arm: `sr_raw_pca_qd`
- Seed: `1001`
- Model: `openai/gpt-oss-120b`
- vLLM context requirement: `max_model_len=131072`
- Token policy: `--max_tokens 128000`, `--diff_max_tokens 128000`
- Archive substrate: landing Smooth-QD with `grid_quantile`,
  `pareto_front` cells, and `nsga2_global_rank` parent selection
- Descriptor: frozen `sr_raw_pca_v1`, axes `sr_pca_0..2`

## Gate 0 Result

| Metric | Value |
| --- | ---: |
| Covered problems | 6 |
| Missing problems | 0 |
| Classic minus SR-PCA | 0 |
| SR-PCA minus classic | 0 |

`sr_raw_pca_qd` matches original REvolution's seed-1 development coverage
set `C`.

## Problem Summary

| Problem | PPA Artifacts | Best Score |
| --- | ---: | ---: |
| `RTLLM/Prob011_multi_16bit` | 34 | 0.20652973429742938 |
| `RTLLM/Prob019_sub_64bit` | 47 | 0.48228021147642647 |
| `RTLLM/Prob048_pe` | 15 | 0.0008356886603559543 |
| `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 35 | 0.4231863785854045 |
| `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 36 | 0.28828258969148557 |
| `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 42 | 0.04155040525406675 |

## Cross-Method Summary

| Metric | SR-PCA | Classic |
| --- | ---: | ---: |
| Valid PPA | 209 | 209 |
| Mean best fitness | 0.2404 | 0.2671 |
| Mean hypervolume | 0.1208 | 0.1245 |
| Unique canonical netlists | 74 | 70 |
| Unique motif signatures | 48 | 43 |
| PPA-front unique netlists | 14 | 12 |
| Common-audit occupied cells | 12 | 12 |
| Common-audit QD score | 1.9663 | 2.3163 |

## Runtime Sanity

| Benchmark half | Runtime |
| --- | ---: |
| RTLLM | 551.68 s |
| VerilogEval | 486.39 s |

## Artifacts

- `../../auto_bd_gate0_coverage_seed1_sr_raw_pca_qd.json`
- `seed1_artifact_report.md`
- `../../auto_bd_seed1_centralized_report.md`
- `../../auto_bd_seed1_centralized_report.json`
- `../../../../../../exp/auto_bd_research/development_preliminary_seed1/sr_raw_pca_qd/seed_1001/standard_results/`

## Interpretation

The fixed raw-PCA descriptor is viable in-loop and does not regress Gate 0
or valid-PPA rate on the development seed. It gives modest structural
diversity uplift over classic REvolution, but not enough to satisfy the
predeclared final-method bar.

Do not promote `sr_raw_pca_qd` as the selected method. Use it as the
first projected baseline and proceed to the planned random-kernel PCA
variant.
