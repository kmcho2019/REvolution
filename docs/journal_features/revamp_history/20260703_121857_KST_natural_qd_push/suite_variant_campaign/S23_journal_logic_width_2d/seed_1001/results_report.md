# S23 Journal Logic-Width 2D Seed 1001

## Run

- Variant: `S23_journal_logic_width_2d`
- Change: replace the frozen 3D journal trio descriptor with explicit
  `logic_depth, comb_width_log` axes on the V2 platform.
- Run root:
  `exp/natural_qd_push/suite_variants_wave_c_20260710_021651_UTC/live/journal_logic_width_2d/seed_1001`
- Runtime: 5223.39 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Contract

S23 changes only the behavior descriptor:

```text
qd_descriptor_axes=logic_depth,comb_width_log
qd_descriptor_profile=None
qd_archive_type=grid_quantile
qd_num_cells=16
qd_grid_quantile_warmup_successes=8
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

The resolved config uses explicit descriptor axes and does not use
`qd_descriptor_profile=journal_logic_ff_width_3d`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | Strict HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 8 |
| S23 logic-width 2D | 0.084403 | 0.076832 | 31/46 | 4 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 5 |

Coverage is successful-candidate coverage over the 46 reference-complete
problems. HV-AUC46 uses the fixed 46-problem denominator.

S23 is below matched classic by `-0.026999` final HV and reaches only
75.8% of classic final HV. It is also below V2 by `-0.012364` final HV.
Coverage is `-2/46` versus classic and `-1/46` versus V2.

## Mechanism Read

The intended descriptor-health mechanism did move in the expected
direction, but it did not translate into suite PPA quality:

| Arm | Collapsed archives | Mean occupied cells |
| --- | ---: | ---: |
| S23 logic-width 2D | 4/50 | 1.94 |
| Smooth-QD V2 | 24/50 | 2.36 |
| S07 capacity3 seed 1001 | 24/50 | 2.44 |

S23 sharply reduces descriptor collapse by dropping `ff_depth`, but it
also produces fewer successful candidates than the matched comparators:
857 candidates over 31 problems versus classic's 1002 over 33 problems
and V2's 1007 over 32 problems.

The final-HV loss is concentrated in high-impact problems:
`Prob036_edge_detect` (`-0.538825` vs classic), `Prob019_sub_64bit`
(`-0.449959`), and `Prob024_fsm` (`-0.195683`). S23 has isolated wins
on `Prob002_adder_16bit`, `Prob008_comparator_4bit`,
`Prob049_signal_generator`, and `Prob043_RAM`, but they do not offset
the large losses.

## Decision

Classification: `seed1001 HV-catastrophic descriptor-reduction control`.

The pre-registered smoke stop rule closes S23 after seed 1001 because
final HV is below 90% of matched classic. Do not run seed 1002 and do
not launch `S31 s07_logic_width_2d` from this evidence. The useful
finding is negative: reducing descriptor collapse alone is not enough;
the removed `ff_depth` axis or the resulting coarser archive appears to
carry PPA-search value despite the collapse-health improvement.
