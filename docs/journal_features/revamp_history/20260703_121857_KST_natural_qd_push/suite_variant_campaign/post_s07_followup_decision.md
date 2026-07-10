# Post-S07 Follow-Up Decision

Date: 2026-07-10.

Scope: choose the next suite-first lane after `S07_capacity3` closed as
five-seed HV-negative, HV-AUC-positive, and coverage-positive.

## Evidence Reviewed

- `S07_capacity3/five_seed_analysis/summary.md`.
- `suite_variant_campaign/README.md`.
- `suite_variant_campaign/variant_registry.csv`.
- `suite_variant_campaign/restart_handoff_20260709.md`.
- `p3_full_rtllm/p3c_closure.md`.
- `data/configs/qd_descriptor_profiles.yaml`.
- Non-LLM config smoke for the candidate descriptor/geometry settings.

## Decision

Register one immediate follow-up: `S23 journal_logic_width_2d`.

S23 changes only the behavior descriptor from the frozen 3D journal trio
to the 2D `logic_depth, comb_width_log` subset. This is the cleanest next
test because it keeps the original descriptor family and asks whether
dropping the often-collapsed `ff_depth` axis improves suite behavior
without changing operators, schedulers, retention, or archive geometry.

Run S23 as a one-seed full RTLLM smoke first. If it is not
catastrophically HV- or coverage-negative, complete the two-seed probe.
Only then reopen the contingent combination `S31 s07_logic_width_2d`,
which applies the same reduced descriptor to S07 capacity3 retention.
The small screen remains useful only for debugging extraction failures.

For the seed-1001 smoke, treat "catastrophic" as a coarse stop rule,
not a promotion rule. Quarantine the run if validation, extraction,
config pins, or operator audit fail. If the package is valid, stop after
seed 1001 only if S23 final HV is below 90% of matched classic or its
successful-candidate coverage is at least four RTLLM problems below
matched classic. Otherwise finish seed 1002 before deciding whether S23
is useful.

## Candidate Triage

| Candidate | Posture | Reason |
| --- | --- | --- |
| `S23 journal_logic_width_2d` | Register and smoke first | Clean single-factor descriptor reduction inside the original trio family. |
| `S31 s07_logic_width_2d` | Contingent | Closest S07 combination, but it should wait for S23 because S07 is final-HV-negative and combination arms need a full-suite single-factor signal. |
| `S07 + compact_8d CVT` | Defer | Changes descriptor family and archive geometry at once; prior P3c read was health-positive but HV-neutral and hit a disclosed compact8d extraction failure. |
| `S07 + gt3d/testability` | Defer to coverage appendix | Prior gt3d evidence is coverage-positive but HV-weak, so it is not the next primary PPA-HV lane. |
| `S07 + logic_ff_2d` | Reserve | Useful only if S23 is ambiguous; it retains the possibly-collapsed `ff_depth` axis and drops width, so it is less aligned with the immediate mechanism. |

## S23 Contract

S23 uses the standard full-suite command shape with these variant pins:

```text
--qd_archive_type grid_quantile
--qd_descriptor_axes logic_depth comb_width_log
--qd_num_cells 16
--qd_grid_quantile_warmup_successes 8
--qd_cell_mode pareto_front
--qd_max_elites_per_cell 5
--qd_parent_selection nsga2_global_rank
--qd_champion_lane_fraction 0.5
--qd_rebinning_kind ks_triggered
--classic_operator_kind eoh_strategies
--qd_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--evaluation_mode strict_ablation
--max_tokens 128000
--diff_max_tokens 128000
```

Do not pass `--qd_descriptor_profile` for S23. The explicit axis pins are
the descriptor definition.

## S31 Contingent Contract

S31 uses the same command shape as S23, but also changes S07's retention
capacity:

```text
--qd_archive_type grid_quantile
--qd_descriptor_axes logic_depth comb_width_log
--qd_num_cells 16
--qd_grid_quantile_warmup_successes 8
--qd_cell_mode pareto_front
--qd_max_elites_per_cell 3
--qd_parent_selection nsga2_global_rank
--qd_champion_lane_fraction 0.5
--qd_rebinning_kind ks_triggered
--classic_operator_kind eoh_strategies
--qd_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--evaluation_mode strict_ablation
--max_tokens 128000
--diff_max_tokens 128000
```

Do not pass `--qd_descriptor_profile` for S31. After the S23 seed-1001
closure, do not launch S31 from current evidence because the required
single-factor descriptor signal was HV-catastrophic.

## Config Smoke

The non-LLM smoke resolved and constructed all candidate archives:

| Candidate | Axes | Archive | Descriptor requirements |
| --- | --- | --- | --- |
| S23/S31 logic-width 2D | `logic_depth, comb_width_log` | `GridQuantileArchive` | synthesis + graph metrics |
| logic-ff 2D reserve | `logic_depth, ff_depth` | `GridQuantileArchive` | synthesis + graph metrics |
| compact8d CVT reserve | `theory_grounded_compact_8d` profile | `CVTArchive` | graph metrics |
| gt3d reserve | `journal_graph_testability_3d` profile | `GridQuantileArchive` | RTL + graph metrics |

No code change is needed before S23. Before a live run, record a vLLM
preflight and use the normal package chain.

## Promotion Rule

Promote S23 from two seeds to five only if one of these holds:

- S23 mean final HV is at least matched classic and coverage is at least
  matched classic.
- S23 remains slightly HV-negative but clearly improves HV-AUC and
  coverage enough to justify a near-miss mechanism analysis.

If S23 is HV-negative and does not improve coverage, close it as a
descriptor-reduction control and do not broaden into a descriptor scan.

## Seed-1001 Outcome

S23 seed 1001 completed and was packaged under
`S23_journal_logic_width_2d/seed_1001/`. It is a valid but negative
descriptor-reduction control:

```text
S23:    0.084403 HV / 0.076832 HV-AUC46 / 31/46 coverage
classic:0.111401 HV / 0.090551 HV-AUC46 / 33/46 coverage
V2:     0.096767 HV / 0.083539 HV-AUC46 / 32/46 coverage
```

S23 reduced descriptor collapse to `4/50` archives, compared with
`24/50` for matched V2 seed 1001, but final HV reached only 75.8% of
matched classic. The smoke stop rule therefore closes S23 after seed
1001. Do not run S23 seed 1002 or launch `S31 s07_logic_width_2d` from
current evidence.
