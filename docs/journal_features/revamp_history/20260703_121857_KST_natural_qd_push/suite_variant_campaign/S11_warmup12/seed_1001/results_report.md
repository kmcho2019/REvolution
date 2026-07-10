# S11 Warmup12 Seed 1001

## Run

- Variant: `S11_warmup12`
- Change: increase quantile-grid warmup successes from `8` to `12` on
  the V2 Smooth-QD platform.
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260710_035929_UTC/live/warmup12/seed_1001`
- Runtime: 4793.56 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Contract

S11 changes only the quantile warmup count:

```text
qd_grid_quantile_warmup_successes=12
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

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | Strict HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 17 |
| S11 warmup12 | 0.095807 | 0.085702 | 33/46 | 8 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 9 |

Coverage is successful-candidate coverage over the 46 reference-complete
problems. HV-AUC46 uses the fixed 46-problem denominator.

S11 ties matched classic coverage and improves on V2 coverage by one
problem, but it is below matched classic by `-0.015595` final HV and
`-0.004849` HV-AUC46. It also trails V2 by `-0.000961` final HV, though
it beats V2 by `+0.002163` HV-AUC46.

## Mechanism Read

The longer warmup does not recover the PPA-quality gap. It produces fewer
successful candidates than the matched comparators:

| Arm | Candidates | Initial | EoH strategy | Single-thought |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 1002 | 198 | 804 | 0 |
| S11 warmup12 | 970 | 207 | 763 | 0 |
| Smooth-QD V2 | 1007 | 204 | 803 | 0 |

The largest final-HV gains versus classic are concentrated in
`Prob002_adder_16bit` (`+0.140520`), `Prob008_comparator_4bit`
(`+0.030368`), and `Prob045_alu` (`+0.009815`). They do not offset the
large losses on `Prob036_edge_detect` (`-0.538825`), `Prob024_fsm`
(`-0.239912`), `Prob041_traffic_light` (`-0.054059`), and
`Prob025_sequence_detector` (`-0.043390`).

## Decision

Classification: `seed1001 HV-negative warmup interpolation control`.

S11 avoids the warmup16-style coverage loss against matched classic, but
it does not meet the stop rule: final HV is far below classic and
HV-AUC46 is not near classic. Close S11 after seed 1001, do not launch
seed 1002, and keep S12 `warmup24` blocked from current evidence.
