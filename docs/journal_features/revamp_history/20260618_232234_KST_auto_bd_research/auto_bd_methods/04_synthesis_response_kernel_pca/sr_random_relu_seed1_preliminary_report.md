# sr_random_relu_pca_qd Seed-1 Preliminary Report

Status: promote to seed-3 screening only; not accepted as final.

## Setup

- Method arm: `sr_random_relu_pca_qd`
- Phase: `development_preliminary_seed1`
- Seed: `1001`
- Model: `openai/gpt-oss-120b`
- Endpoint preflight: `max_model_len=131072`
- Token settings: `--max_tokens 128000`, `--diff_max_tokens 128000`
- Descriptor: frozen `sr_random_relu_pca_v1`, axes `sr_pca_0..2`
- Run root:
  `exp/auto_bd_research/development_preliminary_seed1/sr_random_relu_pca_qd/seed_1001`

## Result

| Metric | ReLU PCA | Classic |
| --- | ---: | ---: |
| Gate 0 missing problems | 0 | 0 |
| Valid PPA | 197/288 | 209/288 |
| Mean best fitness | 0.2536 | 0.2671 |
| Mean hypervolume | 0.1454 | 0.1245 |
| PPA-front unique netlists | 11 | 12 |
| Unique canonical netlists | 68 | 70 |
| Unique motif signatures | 44 | 43 |
| Common-audit occupied cells | 10 | 12 |
| Common-audit QD score | 2.3765 | 2.3163 |

Per-problem comparison versus classic:

- Fitness W/T/L: 1/4/1.
- Hypervolume W/T/L: 2/3/1.
- Strongest win: `VerilogEval-Spec-to-RTL/Prob021_mux256to1v`.
- Main loss: `RTLLM/Prob011_multi_16bit`.

## Decision

Promote to seed-3 screening because Gate 0 passes, valid-PPA drop is
within the 5 percentage-point tolerance, scalar fitness does not collapse,
and mean HV improves by about 16.8 percent.

Do not accept as final from seed-1 evidence. Diversity is weaker than
classic on PPA-front unique netlists and common-audit occupied cells, and
valid-PPA count drops by 12 candidates.

## Next Check

Seed-3 must retain Gate 0 coverage and HV/PPA-quality uplift while
recovering diversity. If diversity remains below classic, keep
`sr_random_relu_pca_qd` as a PPA/HV ablation and try the next predeclared
kernel/control variant only after recording the rejection.
