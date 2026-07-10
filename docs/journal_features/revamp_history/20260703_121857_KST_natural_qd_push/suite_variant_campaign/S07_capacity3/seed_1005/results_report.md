# S07 Capacity3 Seed 1005 Report

Package:
`suite_variant_campaign/S07_capacity3/seed_1005/`.

Run root:
`exp/natural_qd_push/suite_variants_wave_b_20260710_002626_UTC/live/capacity3/seed_1005`.

## Contract

S07 changes only the V2 per-cell Pareto capacity:

```text
qd_cell_mode=pareto_front
qd_max_elites_per_cell=3
qd_parent_selection=nsga2_global_rank
qd_champion_lane_fraction=0.5
qd_descriptor_profile=journal_logic_ff_width_3d
qd_archive_type=grid_quantile
qd_grid_quantile_warmup_successes=8
qd_rebinning_kind=ks_triggered
classic_operator_kind=eoh_strategies
qd_operator_kind=eoh_strategies
eoh_success_operator_set=classic
representation_kind=code_individual
evaluation_mode=strict_ablation
max_tokens=128000
diff_max_tokens=128000
```

`tables/run_validation.json` passes this contract on all 50 RTLLM
problems. `tables/operator_contract.csv` also passes:

```text
classic: 982 candidates, 0 single-thought, 787 EoH
S07_capacity3: 997 candidates, 0 single-thought, 793 EoH
smooth_qd_v2: 985 candidates, 0 single-thought, 781 EoH
```

## Seed 1005 Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic | 0.104404 | 0.086940 | 33/46 | 17 |
| S07 capacity3 | 0.093760 | 0.078565 | 33/46 | 10 |
| Smooth-QD V2 | 0.096063 | 0.086125 | 33/46 | 7 |

Seed 1005 is negative for S07 against matched classic and V2 on final HV
and HV-AUC46. Coverage ties both comparators.

## Five-Seed Aggregate

| Arm | Mean HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic | 0.103802 | 0.086982 | 164/230 | 74 |
| S07 capacity3 | 0.102481 | 0.088031 | 165/230 | 60 |
| Smooth-QD V2 | 0.098801 | 0.087428 | 166/230 | 35 |

S07 closes below the primary classic final-HV gate: it reaches 98.7% of
classic HV, with a delta of `-0.001321`. It remains positive on
trajectory and coverage, beating classic by `+0.001049` HV-AUC46 and
`+1/230` covered problem. It also beats V2 on mean final HV and HV-AUC46,
but not coverage.

## Decision

Classification: `five-seed HV-negative, HV-AUC-positive,
coverage-positive`.

S07 is not the primary TCAD PPA-HV win. It is a clean secondary result:
smaller per-cell Pareto retention improves trajectory quality and
slightly improves coverage while recovering much of classic's final HV.
Do not open S07 combinations unless a separate mechanism explains how to
recover the remaining final-HV gap.
