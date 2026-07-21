# H5 Full-Suite Development Probe

Governing outcome: `RETIRED`. The frozen reporter emitted `VIABLE`, but a
post-run contract audit found that its aggregate coverage gate conflicts with
the accepted per-seed rule. The generated label is preserved as evidence; it
is not the candidate decision.

## Scope And Integrity

- Fresh sequential classic and H5 arms completed all 50 RTLLM problems at
  seeds 1001 and 1002: 100 problem-seed units and 200 arm units.
- Every arm produced exactly 2,400 candidates. There were no missing units,
  imputed run units, infrastructure reruns, or concurrent matched arms.
- The reference-complete PPA headline covers 46 designs and 92 problem-seed
  units. Functionality is reported separately on all 50 and the headline 46.
- H5 changed only failed-parent operator routing: every H5 failed-parent
  request used EoH operator M-F. Successful-parent operators remained the
  classic EoH set in both arms.
- The classic engine, default configuration, run manifest, run configuration,
  experiment manifest, and reporters retained their frozen hashes.

## Generated Result And Governing Correction

The canonical reporter returned `VIABLE` from these generated statistics:

| Metric | H5 minus classic | 95% problem-cluster CI | W/L/T |
| --- | ---: | --- | ---: |
| Direct valid-PPA repair rate, all 50 | +0.001667 | [-0.002292, +0.006250] | 14/12/74 |
| Final HV, reference-complete 46 | +0.006678 | [-0.000627, +0.017287] | 20/11/61 |
| HV-AUC, reference-complete 46 | +0.004498 | [-0.002928, +0.016273] | 24/15/53 |
| RTL functionality, all 50 | -0.010000 | [-0.050000, +0.020000] | 1/2/97 |
| Valid-PPA coverage, reference-complete 46 | -0.010870 | [-0.043478, +0.021739] | 1/2/89 |
| Valid-PPA sample yield, reference-complete 46 | +0.009964 | [-0.007020, +0.026947] | 34/24/34 |

The repair-rate, final-HV, and HV-AUC directions were positive at both seeds.
Direct valid-PPA repairs totaled 73 for classic and 81 for H5. Maximum
within-pair resource skew was 0.027211, and full-suite candidate budgets were
equal.

The reporter nevertheless implemented the wrong coverage gate. The accepted
baseline contract permits a deficit of at most one problem per seed. At seed
1001, valid-PPA coverage fell from 34/46 to 32/46, a deficit of two. Seed
1002 improved from 32/46 to 33/46, but that gain cannot offset an independent
per-seed violation. The reporter instead summed signed seed deficits and
compared the net deficit of one with an aggregate maximum of two. The claims
contract and machine-readable program manifest govern, so this primary-surface
failure requires `RETIRED`.

The candidate also exceeded every frozen per-candidate discovery ceiling when
the mandatory matched controls are included:

| Resource | Actual | Ceiling | Overage |
| --- | ---: | ---: | ---: |
| Candidates | 11,232 | 10,512 | 720 |
| LLM calls | 22,466 | 21,000 | 1,466 |
| LLM tokens | 69,289,552 | 66,000,000 | 3,289,552 |
| Synthesis evaluations | 6,056 | 6,000 | 56 |
| Endpoint-arm hours | 6.231970 | 6.000000 | 0.231970 |

The overrun does not create treatment/control asymmetry within the completed
full-suite comparison. It is a separate bounded-process violation and prevents
a contract-compliant promotion.

## Interpretation Boundary

Role-aligned failed repair increased direct repairs in both seeds, but it did
not satisfy all governing gates and does not show that the repair mechanism
caused the pooled PPA uplift:

- `Prob036_edge_detect` supplied 63.97% of net final-HV uplift and 114.13% of
  net HV-AUC uplift, although neither arm made a failed-parent request on that
  problem in either seed.
- Excluding `Prob036_edge_detect`, mean final-HV delta remained +0.002459, but
  mean HV-AUC delta became -0.000650.
- Excluding the four largest final-HV gain problems (`Prob036`, `Prob037`,
  `Prob041`, and `Prob029`) changed mean final-HV delta to -0.000964.
- `Prob024_fsm` increased direct repairs at both seeds but lost final HV at one
  seed and tied at the other. Repair incidence alone is therefore not
  sufficient evidence of final-quality improvement.

Allowed wording is limited to a two-seed full-suite diagnostic: M-F-only
routing produced five and three additional direct fail-origin valid-PPA
repairs at equal full-suite candidate budgets; mean final HV and HV-AUC were
higher but unresolved; aggregate valid-PPA and RTL-functionality coverage each
ended one unit below classic; and seed 1001 violated valid-PPA coverage
noninferiority. Do not call H5 viable, coverage-preserving, a confirmed PPA
improvement, a paper candidate, or a causal mechanism win. Confirmation and
holdout are not authorized.

## Files And Reproduction

- `summary.json` is the machine-readable reporter output. Its `VIABLE` label is
  superseded by the governing contract audit described above.
- `summary.md` and `seed_metrics.csv` report pooled and per-seed results.
- `paired_metrics.csv` contains the problem-seed paired estimands.
- `leave_one_seed_out.csv` records seed sensitivity.
- `resource_totals.csv` and `resource_by_unit.csv` record resource parity.
- `treatment_pool_trajectory.csv` records failed-pool evolution.
- `artifact_manifest.md` pins the copied package files.

Raw evidence:
`exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/full_suite_probe`.
Per-seed supporting packages are under `packages/seed_1001` and
`packages/seed_1002`. The canonical package was generated exactly once with:

```bash
uv run python scripts/report_failed_parent_repair_probe.py \
  --manifest docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/candidates/H5_role_aligned_failed_repair/full_suite_experiment_manifest.yaml \
  --output-dir exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/full_suite_probe/packages/two_seed/probe
```

See `../full_suite_execution_commands.md` for the frozen execution and
per-seed packaging commands.
