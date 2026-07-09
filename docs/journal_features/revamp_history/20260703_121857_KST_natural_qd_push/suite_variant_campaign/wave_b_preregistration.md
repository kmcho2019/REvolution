# Wave B Pre-Registration

Date: 2026-07-09.

## Rationale

Wave A closed the simple retention controls without finding a primary
TCAD arm. S03 `elite_pareto_slot_2` recovered V2 final HV but missed
classic HV, HV-AUC46, and coverage at five seeds. S20 and S21 then
closed as clean parent-selection and scalar-retention negatives.

The strongest remaining config-only direction is to interpolate the
older N03b front-slot signal. N03b beat classic on suite HV-AUC46 but
lost coverage and final HV. S09 lowers the front-slot parent lane from
that aggressive 0.30 setting to 0.20 while keeping the simple
`elite_pareto_slot_2` cell semantics.

## Scope

Full RTLLM 50-problem run, with headline metrics restricted to the same
46 reference-complete designs used by P3 and Wave A. The first Wave B
front-slot probe is two seeds, `1001-1002`, with 8x5 population and
generation settings.

## Baselines

Classic 5-seed baseline: `0.103802` HV, `0.086982` HV-AUC46,
coverage `164/230`.

V2 5-seed baseline: `0.098801` HV, `0.087428` HV-AUC46,
coverage `166/230`.

Matched two-seed seed-1001/1002 reference used by recent probes:
classic `0.104479` HV, `0.085867` HV-AUC46, coverage `66/92`;
V2 `0.098539` HV, `0.087146` HV-AUC46, coverage `65/92`.

## Arms

| ID | Arm | Seeds | Change |
| --- | --- | --- | --- |
| S09 | front_slot_lane_020 | 1001-1002 | `qd_cell_mode=elite_pareto_slot`, `qd_max_elites_per_cell=2`, `qd_parent_selection=front_slot_lane_nsga2`, `qd_front_slot_lane_fraction=0.20`. |
| S22 | front_slot_lane_010 | 1001-1002 | Same as S09, but `qd_front_slot_lane_fraction=0.10`. |
| S10 | front_slot_lane_040 | 1001-1002 | Same as S09, but `qd_front_slot_lane_fraction=0.40`. |

S09 runs first. S22 is the conservative follow-up if S09 still appears
too front-slot-heavy. S10 is a stronger-source follow-up only if S09
shows a positive AUC/HV signal without a major coverage loss.

## Gates

- Every launched seed needs vLLM preflight, 128k token budgets,
  `qd_operator_kind=eoh_strategies`, `representation_kind=code_individual`,
  `--eoh_success_operator_set classic`, operator audit, and config-pin
  validation.
- Promote S09 to seeds `1003-1005` only if the two-seed read improves
  HV-AUC46 over matched classic while keeping coverage at least matched
  classic, and does not take a large final-HV loss.
- Do not promote a coverage-only result if final HV remains materially
  below classic and V2.
- Quarantine any run with nonzero `single_thought_count`, failed
  validation, missing reference-complete package, or wrong parent/cell
  pins.

## Interpretation

S09 is not a new heuristic family. It is a natural interpolation of the
existing MAP-Elites/MOME-style archive-parent idea: one quality champion
plus one local front slot per cell, with a fixed parent lane that samples
those front slots. The purpose is to test whether moderate front-slot
pressure keeps N03b's AUC/front-material benefit while recovering
coverage.
