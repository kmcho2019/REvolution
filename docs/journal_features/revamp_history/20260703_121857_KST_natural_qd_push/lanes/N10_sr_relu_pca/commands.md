# N10 Commands

## Descriptor Probe

```bash
uv run python scripts/qd_descriptor_probe.py \
  --profile sr_pca_3d \
  --descriptor_file docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N10_sr_relu_pca/descriptor_profile.yaml \
  --archive_type grid_quantile \
  --circuit_type sequential
```

Result: resolves axes `sr_pca_0`, `sr_pca_1`, `sr_pca_2`;
`requires_ppa=false`; `requires_auto_bd_sr_pca=true`.

## Extraction Smoke

```bash
uv run python scripts/probe_n10_sr_relu_smoke.py \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N10_sr_relu_pca/smokes/sr_relu_pca_20260707_151320_UTC
```

Result: PASS. `extraction_smoke_summary.json` reports no
screen/training overlap, initialized descriptor health, eight occupied
cells, and no collapsed axes.
