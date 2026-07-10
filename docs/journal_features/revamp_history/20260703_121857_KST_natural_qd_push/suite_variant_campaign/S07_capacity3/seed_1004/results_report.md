# S07 Capacity3 Seed 1004 Report

Package:
`suite_variant_campaign/S07_capacity3/seed_1004/`.

Run root:
`exp/natural_qd_push/suite_variants_wave_b_20260709_225719_UTC/live/capacity3/seed_1004`.

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
classic: 974 candidates, 0 single-thought, 782 EoH
S07_capacity3: 1001 candidates, 0 single-thought, 780 EoH
smooth_qd_v2: 993 candidates, 0 single-thought, 789 EoH
```

## Seed 1004 Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic | 0.103555 | 0.089027 | 32/46 | 13 |
| S07 capacity3 | 0.112252 | 0.093789 | 33/46 | 12 |
| Smooth-QD V2 | 0.101008 | 0.086425 | 33/46 | 8 |

Seed 1004 is a positive S07 seed. It beats matched classic on final HV,
HV-AUC46, and coverage, while also beating V2 on final HV and HV-AUC46.

## Four-Seed Aggregate

| Arm | Mean HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic | 0.103652 | 0.086993 | 131/184 | 57 |
| S07 capacity3 | 0.104661 | 0.090397 | 132/184 | 50 |
| Smooth-QD V2 | 0.099485 | 0.087753 | 133/184 | 28 |

S07 now clears the confirmation threshold before the fifth seed: it is
above matched classic on mean final HV, HV-AUC46, and coverage across
seeds 1001-1004. The final-HV margin is small, so this is not yet a
paper-grade five-seed claim. It is strong enough to justify finishing
seed 1005 as the next run.

## Decision

Classification: `promoted-to-final-confirmation`.

Continue S07 to seed 1005 before launching a new variant. A five-seed
S07 win would be a clean, natural TCAD extension story: smaller per-cell
Pareto retention reduces archive crowding while preserving the
operator-fair Smooth-QD substrate.
