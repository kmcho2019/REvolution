# Post-S23 Warmup Decision

Date: 2026-07-10.

Scope: choose the next action after S23 closed as a valid but
HV-catastrophic descriptor-reduction control.

## Decision

Run one bounded S11 `warmup12` seed as warmup-family closure, not as the
next primary TCAD lane.

S11 changes only one V2 platform knob:

```text
qd_grid_quantile_warmup_successes=12
```

All operator, archive, descriptor, token-budget, and evaluation pins stay
at the V2/Smooth-QD platform values:

```text
qd_descriptor_profile=journal_logic_ff_width_3d
qd_archive_type=grid_quantile
qd_num_cells=16
qd_cell_mode=pareto_front
qd_max_elites_per_cell=5
qd_parent_selection=nsga2_global_rank
qd_champion_lane_fraction=0.5
qd_rebinning_kind=ks_triggered
classic_operator_kind=eoh_strategies
qd_operator_kind=eoh_strategies
eoh_success_operator_set=classic
representation_kind=code_individual
evaluation_mode=strict_ablation
max_tokens=128000
diff_max_tokens=128000
```

## Rationale

S02 `warmup16` is already a two-seed primary negative: it nearly ties
classic HV-AUC46 but loses mean final HV and coverage. S11 is only the
smaller interpolation that checks whether warmup16 overshot the useful
initialization window.

This is a natural MAP-Elites/QD setting because it changes when the
quantile grid is initialized, not the operator set, objectives, scoring,
or scheduler. It is weak as a primary manuscript lane because it is a
parameter interpolation after a negative warmup16 result.

## Stop Rule

Package S11 seed 1001 before interpreting any metrics. Stop after seed
1001 unless S11 avoids the S02 coverage/yield loss and shows either:

- final HV at least matched classic, or
- clear coverage recovery with HV-AUC46 at least near matched classic.

Do not launch S12 `warmup24` or any warmup combination from current
evidence. Promote S11 beyond two seeds only if a two-seed result can
plausibly challenge classic, not merely V2.

## Outcome

S11 seed 1001 completed and was packaged at
`S11_warmup12/seed_1001/`. It ties matched classic coverage but fails the
stop rule on PPA quality:

| Arm | HV | HV-AUC46 | Coverage |
| --- | ---: | ---: | ---: |
| classic REvolution | 0.111401 | 0.090551 | 33/46 |
| S11 warmup12 | 0.095807 | 0.085702 | 33/46 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 |

Final HV is far below matched classic and HV-AUC46 is not near matched
classic. Close S11 after seed 1001, do not launch seed 1002, and keep
S12 `warmup24` blocked from current evidence.
