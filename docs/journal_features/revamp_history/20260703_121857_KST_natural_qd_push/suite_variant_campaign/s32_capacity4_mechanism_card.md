# S32 Capacity4 Mechanism Card

Date: 2026-07-10.

## Question

Can an intermediate per-cell Pareto capacity recover S07's final-HV gap
while preserving its HV-AUC and coverage benefits?

## Rationale

S07 `capacity3` is the strongest suite-first QD result so far: it beats
classic on HV-AUC46 and coverage, and beats V2 on final HV and HV-AUC46.
It still misses classic final HV by `0.001321`. This suggests compact
per-cell retention helps trajectory and coverage, but capacity 3 may be
slightly too restrictive for final Pareto quality.

S32 changes only `qd_max_elites_per_cell` from 5 to 4. It is the direct
interpolation between V2 capacity 5 and S07 capacity 3. The mechanism is
still MOME-style per-cell Pareto retention, with no operator, scheduler,
descriptor, parent-selection, warmup, or budget change.

## Why Not BD First

BD variants have been partially tested, but not as the best immediate
primary-HV follow-up:

- S23 `journal_logic_width_2d` reduced descriptor collapse but was
  final-HV catastrophic, so S31 `S07 + logic_width_2d` is blocked.
- S04/S05 compact8d/trio CVT and S06 gt3d were tested as V2-platform
  descriptor/geometry probes. They are useful descriptor-health or
  coverage appendix reserves, but none is a primary final-HV signal.
- S07 + compact8d/CVT or S07 + gt3d would combine retention and
  descriptor changes. That is a weaker story than first testing the
  one-knob capacity interpolation implied by S07.

## Contract

S32 uses the standard full-suite command shape with exactly one variant
pin:

```text
--qd_max_elites_per_cell 4
```

All other pins remain the V2/S07 platform:

```text
--classic_operator_kind eoh_strategies
--qd_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--evaluation_mode strict_ablation
--qd_archive_type grid_quantile
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_num_cells 16
--qd_grid_quantile_warmup_successes 8
--qd_cell_mode pareto_front
--qd_parent_selection nsga2_global_rank
--qd_champion_lane_fraction 0.5
--qd_rebinning_kind ks_triggered
--max_tokens 128000
--diff_max_tokens 128000
```

## Seed Ladder

Run seed 1001 first as a full-suite smoke/probe.

Stop after seed 1001 if any of these hold:

- run validation or operator audit fails;
- `single_thought_count` is nonzero;
- final HV is below 90% of matched classic;
- coverage is at least four reference-complete problems below matched
  classic.

If seed 1001 is valid and not catastrophic, run seed 1002 before any
promotion decision.

Promote to five seeds only if the two-seed S32 read beats matched classic
on final HV while retaining at least matched classic coverage, or clearly
beats S07 on final HV while retaining S07's HV-AUC/coverage posture.

## Interpretation

- If S32 wins final HV and keeps AUC/coverage, the journal candidate is
  compact-but-not-too-compact per-cell Pareto retention.
- If S32 keeps AUC/coverage but misses final HV, the manuscript posture
  remains a near-miss trajectory/coverage characterization.
- If S32 loses both final HV and AUC, the capacity-interpolation path is
  closed and BD variants should remain appendix-specific unless a new
  independent descriptor mechanism is written first.
