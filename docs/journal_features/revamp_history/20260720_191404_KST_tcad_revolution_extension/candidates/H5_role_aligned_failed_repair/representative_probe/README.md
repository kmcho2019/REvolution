# H5 Representative Probe Evidence

Status: complete diagnostic evidence; no promotion or retirement gate applies
at this stage.

The fresh matched probe covered the eight frozen representative problems at
development seeds 1001 and 1002. Every one of the 32 arm/problem/seed units
completed its exact 48-candidate budget. The H5 mechanism activated as
registered and all treatment pool trajectories validated.

H5 improved the unconditional fail-origin valid-PPA repair rate by
`+0.005208` and valid-PPA sample yield by `+0.029948`. Mean final-HV delta was
`-0.001442`; mean HV-AUC delta was `+0.007650`. RTL-simulation functionality and
valid-PPA coverage were saturated at `16/16` in both arms. Seed directions were
mixed for final HV and HV-AUC, so these observations are not suite claims.

`summary.json` and the CSV files are a reporting-only closure generated after
the live runs. No arm was rerun. The original package remains under
`packages/two_seed/probe`; the first reporting closure remains under
`packages/two_seed/probe_reporting_closure`; and this exact derived revision is
under `packages/two_seed/probe_reporting_closure_v3` in the raw artifact root.
The revision adds per-seed direction, resource totals, pool trajectories,
missing-unit fields, and the exact registered endpoint alias without changing
raw outcomes.

Raw root:
`exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/representative_probe`.

Generation command:

```bash
uv run python scripts/report_failed_parent_repair_probe.py \
  --manifest docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/candidates/H5_role_aligned_failed_repair/representative_experiment_manifest.yaml \
  --output-dir exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/representative_probe/packages/two_seed/probe_reporting_closure_v3
```

See `artifact_manifest.md` for exact hashes and `summary.md` for the compact
result table.
