# Restart Handoff - 2026-07-09

Last updated: 2026-07-09T19:52:22Z.
Branch: `feat/journal-qd-bd-exp-20260703`.
Current completed result package:
`suite_variant_campaign/S07_capacity3/seed_1001`.

## Immediate State

S07 capacity3 seed 1001 has completed and been packaged. S07 capacity3
seed 1002 is currently running.

```text
run root:
exp/natural_qd_push/suite_variants_wave_b_20260709_182124_UTC/live/capacity3/seed_1001
launch log:
exp/natural_qd_push/suite_variants_wave_b_20260709_182124_UTC/launch_capacity3_seed1001.log
preflight:
suite_variant_campaign/preflights/s07_capacity3_seed1001_20260709_182124_UTC.json
package:
suite_variant_campaign/S07_capacity3/seed_1001
active run:
exp/natural_qd_push/suite_variants_wave_b_20260709_195220_UTC/live/capacity3/seed_1002
active launch log:
exp/natural_qd_push/suite_variants_wave_b_20260709_195220_UTC/launch_capacity3_seed1002.log
active preflight:
suite_variant_campaign/preflights/s07_capacity3_seed1002_20260709_195220_UTC.json
```

Observed at this handoff: S07 seed 1001 completed all 50 RTLLM problems
normally in 4763.21 seconds with 4800 LLM API calls. The package passes
the full 50-problem run validation and operator audit.

The earlier S09 launch rooted at
`exp/natural_qd_push/suite_variants_wave_b_20260709_102340_UTC` was
stopped before any completed problem because it missed
`qd_champion_lane_fraction=0.5`. Its raw directory is quarantined as
`exp/natural_qd_push/suite_variants_wave_b_20260709_102340_UTC_INVALID_MISSING_CHAMPION_LANE`
and must not be interpreted.

## S09 Contract

S09 is the front-slot interpolation probe:

```text
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
--qd_parent_selection front_slot_lane_nsga2
--qd_front_slot_lane_fraction 0.20
--qd_champion_lane_fraction 0.5
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 8
--qd_rebinning_kind ks_triggered
--qd_operator_kind eoh_strategies
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--max_tokens 128000
--diff_max_tokens 128000
--evaluation_mode strict_ablation
```

Seed 1001 is already packaged. It is a positive single-seed probe:
S09 `0.102139` HV / `0.093403` HV-AUC46 / `34/46` coverage vs matched
classic `0.111401` / `0.090551` / `33/46` and V2 `0.096767` /
`0.083539` / `32/46`.

Seed 1002 is packaged. It did not replicate seed 1001:
S09 `0.090574` HV / `0.077897` HV-AUC46 / `32/46` coverage vs matched
classic `0.097557` / `0.081183` / `33/46` and V2 `0.100310` /
`0.090753` / `33/46`.

Across two seeds, S09 is a front-loss control, not a promotion arm:
S09 `0.096357` HV / `0.085650` HV-AUC46 / `66/92` coverage vs classic
`0.104479` / `0.085867` / `66/92` and V2 `0.098539` / `0.087146` /
`65/92`.

## S22 Contract

S22 is the conservative front-slot interpolation probe:

```text
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
--qd_parent_selection front_slot_lane_nsga2
--qd_front_slot_lane_fraction 0.10
--qd_champion_lane_fraction 0.5
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 8
--qd_rebinning_kind ks_triggered
--qd_operator_kind eoh_strategies
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--max_tokens 128000
--diff_max_tokens 128000
--evaluation_mode strict_ablation
```

Seed 1001 is packaged. It is V2-positive and coverage-positive against
classic, but still below classic on final HV and HV-AUC46:
S22 `0.102589` HV / `0.088878` HV-AUC46 / `34/46` coverage vs classic
`0.111401` / `0.090551` / `33/46` and V2 `0.096767` / `0.083539` /
`32/46`.

Seed 1002 is packaged. It beats matched classic on final HV and HV-AUC46
but loses one coverage point: S22 `0.100856` HV / `0.089351` HV-AUC46 /
`32/46` coverage vs classic `0.097557` / `0.081183` / `33/46` and V2
`0.100310` / `0.090753` / `33/46`.

Across two seeds, S22 is HV-AUC-positive but not a primary HV win:
S22 `0.101722` HV / `0.089115` HV-AUC46 / `66/92` coverage vs classic
`0.104479` / `0.085867` / `66/92` and V2 `0.098539` / `0.087146` /
`65/92`.

## S07 Contract

S07 is the smaller per-cell Pareto capacity interpolation probe:

```text
--qd_cell_mode pareto_front
--qd_max_elites_per_cell 3
--qd_parent_selection nsga2_global_rank
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 8
--qd_rebinning_kind ks_triggered
--qd_champion_lane_fraction 0.5
--qd_operator_kind eoh_strategies
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--max_tokens 128000
--diff_max_tokens 128000
--evaluation_mode strict_ablation
```

Seed 1001 is packaged. It is HV-AUC-positive and V2-positive on final HV,
but not a primary classic win: S07 `0.100296` HV / `0.091895` HV-AUC46 /
`32/46` coverage vs matched classic `0.111401` / `0.090551` / `33/46`
and V2 `0.096767` / `0.083539` / `32/46`.

Do not promote S07 from one seed. A seed 1002 replication is reasonable
under the two-seed probe ladder, but this seed alone fails the primary
classic final-HV and coverage gates.

## S21 Contract

S21 is the canonical one-elite MAP-Elites retention control:

```text
--qd_cell_mode scalar_elite
--qd_max_elites_per_cell 1
--qd_parent_selection nsga2_global_rank
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 8
--qd_rebinning_kind ks_triggered
--qd_operator_kind eoh_strategies
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--max_tokens 128000
--diff_max_tokens 128000
--evaluation_mode strict_ablation
```

Seed 1001 is already packaged. It was coverage-positive but HV-negative:
S21 `0.089155` HV / `0.082753` HV-AUC46 / `34/46` coverage vs matched
classic `0.111401` / `0.090551` / `33/46` and V2 `0.096767` /
`0.083539` / `32/46`.

Seed 1002 is packaged. Do not promote S21: the two-seed read trails
classic on HV, HV-AUC46, and coverage and trails V2 on HV/HV-AUC46 while
only tying V2 coverage.

## Package Pointers

S07 seed 1001 was packaged with the same compact S20/S21/S22 structure:

```text
MANIFEST_YAML=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml
MANIFEST_CSV=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_full_manifest.csv
CLASSIC=exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5/seed_1001
V2=exp/natural_qd_push/p3_v2_full_rtllm_20260703_101258_UTC/live/smooth_qd_v2_8x5/seed_1001
ARM=exp/natural_qd_push/suite_variants_wave_b_20260709_182124_UTC/live/capacity3/seed_1001
PKG=docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/suite_variant_campaign/S07_capacity3/seed_1001
```

The standard package chain was run:

```text
uv run python scripts/report_pareto_analysis.py
uv run python scripts/report_ppa_distribution.py
uv run python scripts/report_hv_auc.py
uv run python scripts/audit_operator_contract.py
uv run python scripts/validate_natural_qd_run.py
```

Validation expectations included every S07 pin above. The run would be
invalid as a headline comparison if `single_thought_count` were nonzero
or if the QD config drifted from the registered flags.

Updated:

```text
suite_variant_campaign/README.md
suite_variant_campaign/results_log.md
suite_variant_campaign/variant_registry.csv
natural_qd_push_implementation_history.md
docs/journal_features/13_findings_dashboard.md
suite_variant_campaign/restart_handoff_20260709.md
```

S07 seed 1001 is classified as an HV-AUC-positive capacity-control
signal, not a promotion arm on one seed.
S09 is classified as a two-seed front-loss parent-source interpolation
control and should not be promoted to five seeds.
S21 remains classified as a negative scalar-retention control.

Compute HV-AUC46 with the fixed 46-problem denominator. Do not use a row
mean over `hv_auc.csv`, because sparse arms omit zero-coverage problems
and that inflates the score.

## If The Server Restarts

No S07 seed 1001 process needs to be preserved. After restart, verify the
S07 seed 1001 package and docs are present before launching any new
variant.

If S07 seed 1002 is still active, let it finish before launching any
other full-suite run. If it is gone after a restart, inspect the active
launch log above and package only if all 50 RTLLM problems completed.

## Audit Feedback To Carry Forward

Read-only narrative audit verdict: V2 remains the primary natural journal
extension unless a later full-suite variant beats classic. S21 should close
the scalar MAP-Elites control, not become a new paper arm on weak coverage
alone.

Read-only organization audit verdict: WARN, not FAIL. Operator parity was
clean in sampled packages, but the campaign has bloat and command-spec
risks:

- `suite_variant_campaign/` is too large because early S01-S03 packages
  kept broad PNG/problem trees. Future packages should stay compact.
- Wave B should get first-class launch documentation before more runs.
- Launch parity pins are easy to omit because `scripts/run_backend.py`
  defaults are not the V2 suite contract.
- Keep future S29/S30 ideas out of central `QDEngine` until a small typed
  module is justified.
- Resolve the typo file `suite_campagin_initial_message.md` later.

Claude CLI review was attempted but unavailable due the weekly limit until
2026-07-10 08:00 UTC.

Read-only experimental-validity audit verdict: completing S21 seed 1002 is
justified as the pre-registered scalar MAP-Elites control, but promotion
language must stay strict. A coverage-only claim would need coverage above
both classic and V2 with a bounded HV tax. The audit recommends
front-slot parent-source interpolation as the strongest next full-suite
direction if the campaign continues after restart.

## Next Campaign Step After S07 Seed 1001

S07 seed 1002 is active. The conservative next executable options after
it completes are:

1. Treat S22 as an HV-AUC-positive front-slot control, not a primary arm.
2. Package S07 capacity3 seed 1002 and compute the two-seed aggregate.
   Seed 1001 has a real HV-AUC signal, but misses classic final HV and
   coverage.
3. S04/S05 descriptor completion to five seeds if descriptor-health
   evidence is needed.

Avoid combination arms unless a single-factor full-suite result gives a
positive signal.

## Post-S22 Launch Guidance

Read-only sub-agent audit after S22 closure recommends stopping launches
before the server restart. Do not launch S10 from the current evidence:
Wave B only justified the stronger 0.40 front-slot lane if S09 showed a
positive HV/AUC signal without major coverage loss, and both S09 and S22
missed the primary classic final-HV gate.

If the campaign resumes after restart, first add an exact launch block
for the selected variant with all V2 parity pins expanded. The generic
command template is not enough; the invalid S09 attempt showed that
missing `qd_champion_lane_fraction=0.5` can silently invalidate a run.
Keep future packages compact and do not copy broad figure trees into
docs.

S07 capacity3 seed 1001 is now packaged. Prefer a seed 1002 replication
over S10 if continuing the same capacity branch, but do not describe S07
as promotion-ready unless the two-seed aggregate clears the primary gate.
