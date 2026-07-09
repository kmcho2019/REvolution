# Restart Handoff - 2026-07-09

Last updated: 2026-07-09T11:59:13Z.
Branch: `feat/journal-qd-bd-exp-20260703`.
Current completed result package:
`suite_variant_campaign/S09_front_slot_lane_020/seed_1001`.

## Immediate State

Do not launch another long full-suite run before the planned server restart.
The corrected S09 seed 1001 long-running benchmark has completed and
been packaged.
There is no active full-suite process from this handoff.

```text
run root:
exp/natural_qd_push/suite_variants_wave_b_20260709_103042_UTC/live/front_slot_lane_020/seed_1001
launch log:
exp/natural_qd_push/suite_variants_wave_b_20260709_103042_UTC/launch_front_slot_lane_020_seed1001.log
preflight:
suite_variant_campaign/preflights/s09_front_slot_lane_020_seed1001_20260709_103042_UTC.json
package:
suite_variant_campaign/S09_front_slot_lane_020/seed_1001
```

Observed at this handoff: S09 seed 1001 completed all 50 RTLLM problems
normally in 4809.40 seconds with 4800 LLM API calls. The package passes
the full 50-problem run validation and operator audit. It is a positive
single-seed probe: S09 `0.102139` HV / `0.093403` HV-AUC46 / `34/46`
coverage vs matched classic `0.111401` / `0.090551` / `33/46` and V2
`0.096767` / `0.083539` / `32/46`.

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

Seed 1002 should be the next benchmark after restart. Do not promote S09
on one seed; final HV still trails matched classic even though HV-AUC46
and coverage beat both comparators.

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

S09 seed 1001 was packaged with the compact S20/S21 structure:

```text
MANIFEST_YAML=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml
MANIFEST_CSV=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_full_manifest.csv
CLASSIC=exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5/seed_1001
V2=exp/natural_qd_push/p3_v2_full_rtllm_20260703_101258_UTC/live/smooth_qd_v2_8x5/seed_1001
ARM=exp/natural_qd_push/suite_variants_wave_b_20260709_103042_UTC/live/front_slot_lane_020/seed_1001
PKG=docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/suite_variant_campaign/S09_front_slot_lane_020/seed_1001
```

The standard package chain was run:

```text
uv run python scripts/report_pareto_analysis.py
uv run python scripts/report_ppa_distribution.py
uv run python scripts/report_hv_auc.py
uv run python scripts/audit_operator_contract.py
uv run python scripts/validate_natural_qd_run.py
```

Validation expectations included every S09 pin above. The run would be
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

S09 is classified as a positive single-seed probe pending seed 1002.
S21 remains classified as a negative scalar-retention control.

Compute HV-AUC46 with the fixed 46-problem denominator. Do not use a row
mean over `hv_auc.csv`, because sparse arms omit zero-coverage problems
and that inflates the score.

## If The Server Restarts

No S09 or S21 process needs to be preserved. After restart, verify the
S09 package and docs are present. The next registered full-suite run is
S09 seed 1002, but launch it only after the user confirms the server is
ready.

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

## Next Campaign Step After S09 Seed 1001

No new long process should start before the restart. After restart and
S09 seed 1001 packaging, the conservative next executable options are:

1. S09 seed 1002 as the direct replication of the current positive
   front-slot interpolation signal.
2. S22 front-slot lane 0.10 only if S09 seed 1002 is encouraging but too
   volatile.
3. S04/S05 descriptor completion to five seeds if descriptor-health
   evidence is needed.
4. S07/S08 capacity interpolation only if coverage remains worth probing.

Avoid combination arms unless a single-factor full-suite result gives a
positive signal.
