# Current Results Matrix

Status: interim comparison after packaging at least ten real current results.

This is not a final sign-off report. It is the navigation table for deciding
which lanes deserve deeper validation now that the minimum package-count gate is
satisfied.

## Package Count

Real result packages:

- `T01_simple_yosys_stat_bd`
- `T02_motif_pathlet_bd`
- `T03_synthesis_delta_stnod_bd`
- `T04_autoqd_mmd_synthesis_bd`
- `T05_vq_elites_codebook_bd`
- `T06_qwen_projection_bd`
- `T17_mome_pareto_archive_bd`
- `T19_sr_relu_pca_bd`
- `T20_sr_raw_pca_bd`
- `T21_stnod_motif_hybrid_bd`
- `T22_random_descriptor_control`
- `T23_sr_pareto_validation_matrix`
- `T24_sr_pareto_live_validation` complete six-arm live development-screen
  result
- `T25_guarded_sr_raw_pareto_qd` guarded live follow-up result
- `T26_sr_raw_conservative_exploit_qd` conservative exploit live follow-up
  result
- `T27_t26_live_qd_audit` live QD audit over T24, T25, and T26 runs
- `T28_t26_family_audit` canonical/family duplicate audit over T24, T25, and
  T26 runs
- `T29_sr_raw_front_recovery_qd` front-recovery live follow-up result

Scaffolded but not yet real-result packages remain `T07` to `T16` and `T18`.
`T24`, `T25`, and `T26` are complete three-problem live development-screen
results. T24 and T25 remain negative diagnostics. T26 is the active SR-family
lead because it recovers ALU and multi-pipe best-score pressure while passing
the covered-design and catastrophic-validity gates. T27 upgrades the evidence
for T26 to `T1 near_classic` audit support on live HV and HV-AUC, but it still
blocks final promotion until family-front and holdout behavior improve. T28
adds canonical/family duplicate accounting: T26 valid candidates are mostly
distinct, but the front-family deficit versus classic and SR raw is real. The
T29 front-recovery variant is also negative: it does not recover the front
deficit and loses multi-pipe final-PPA coverage. The ten-package minimum is
satisfied, but the goal remains active.

## Comparable Seed-1001 Replay Metrics

The table below uses the central replay source:

`exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`

`Best` is secondary diagnostic evidence, not the primary claim metric.

| Package | Method | Tier | Mean HV | HV AUC | Best | Valid PPA | Front nets | Audit cells | Audit QD | Current read |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| baseline | `classic_revolution` | reference | 0.1245 | 0.0728 | 0.2671 | 209 | 12 | 12 | 2.3163 | Baseline to beat. |
| baseline | `landing_smooth_qd_manual_bd` | reference | 0.1059 | 0.0643 | 0.2271 | 219 | 18 | 9 | 1.8526 | Manual BD loses quality and passive-QD score. |
| `T22` | `random_descriptor_qd` | `T0` control | 0.1175 | 0.0987 | 0.2645 | 213 | 21 | 8 | 1.7008 | Strong enough control that positive claims must beat random, not only manual BD. |
| `T01` | `simple_yosys_stat_bd` | `T0` | 0.1242 | 0.0919 | 0.2512 | 201 | 16 | 11 | 2.0779 | Nearly classic HV, but best quality and passive QD drop. |
| `T02` | `netlist_motif_occupancy` | `T0` | 0.0606 | 0.0416 | 0.2350 | 192 | 13 | 8 | -3.0274 | Clear deterministic descriptor failure. |
| `T03` | `synthesis_trajectory_nod` | `T0` near-miss | 0.1208 | 0.0789 | 0.2511 | 205 | 13 | 11 | -2.0643 | Hardware-native near-miss, but passive-QD quality is poor. |
| `T04` | `sr_rff_pca_qd` | `T1` validation candidate | 0.1229 | 0.0801 | 0.2630 | 197 | 20 | 10 | 2.8111 | Best current near-classic lead; strong audit-QD/front signal. |
| `T05` | `sr_vq_codebook_qd` | `T0` | 0.1110 | 0.0669 | 0.2105 | 174 | 13 | 9 | 0.8485 | Direct codebook pressure loses too much quality and yield. |
| `T19` | `sr_random_relu_pca_qd` | `T0` HV lead | 0.1454 | 0.1202 | 0.2536 | 197 | 11 | 10 | 2.3765 | Strongest HV/HV-AUC lead, but quality and coverage regressions block promotion. |
| `T20` | `sr_raw_pca_qd` | `T0` near-miss | 0.1208 | 0.0904 | 0.2404 | 209 | 14 | 12 | 1.9663 | Validity-preserving ablation with front-diversity signal. |
| `T21` | `synthesis_trajectory_motif_nod` | `T0` coverage ablation | 0.1204 | 0.0903 | 0.2380 | 198 | 20 | 16 | 1.7144 | Broad coverage, but quality and passive-QD score fall. |

## Non-Comparable Packaged Evidence

`T06_qwen_projection_bd` is a common-audit diagnostic over prior Qwen3
embedding artifacts, not the same six-problem seed-1001 replay. It remains
`T0 diagnostic`: identifier-normalized Qwen improves selected HV by 3.35%
over lexical farthest-first, but nearest-neighbor structure is dominated by
same-problem and same-corpus clustering.

`T17_mome_pareto_archive_bd` is a passive local-Pareto retention audit, not a
new live method. It shows that local nondominated sets recover much more front
material than one scalar elite per cell, especially for `sr_rff_pca_qd`, but
the standalone HV delta is too small for promotion.

`T23_sr_pareto_validation_matrix` is a focused passive validation matrix over
classic, manual BD, T22 random, T19 SR ReLU PCA, and T04 SR-RFF PCA. It is the
current bridge from replay evidence to the next live local-Pareto experiment.

`T24_sr_pareto_live_validation` fixes that next live experiment and has a
complete six-arm three-problem live matrix: classic, manual BD, random, SR-RFF,
SR ReLU, and SR raw. Every QD arm preserves all classic-covered problems and
passes Pareto-archive validation. None is promoted: manual BD loses 73.16%
relative best score on `Prob015_multi_pipe_8bit`, random loses 71.33%, SR-RFF
loses 66.06%, SR ReLU loses 75.20%, and SR raw still loses 57.09%. Manual BD is
strongest on traffic-light best score, and SR raw is strongest on ALU best
score plus multi-pipe front material, so the next live method should preserve
those strengths with explicit quality/yield guarding.

`T25_guarded_sr_raw_pareto_qd` is the completed pre-registered follow-up to
T24. It keeps the SR raw descriptor and local Pareto archive but lowers
improve-phase backfill and two-parent fusion. It preserves all three
classic-covered designs and passes Pareto archive validation, but it is not
promoted: ALU remains positive (+1.23% best score versus classic),
traffic-light valid-PPA falls from 30 to 9 passing samples, and multi-pipe best
score falls by 75.20% versus classic. The guard reduces SR raw's multi-pipe
global Pareto material from 10 to 6 and worsens best quality, so the next
variant needs an explicit exploit/explore/repair emitter or stronger
quality-preserving parent source rather than more tuning of this guard alone.

`T26_sr_raw_conservative_exploit_qd` is the completed conservative exploit
parent-source test. It restores T24-style fill pressure, removes crossover, and
biases archive parents toward the current champion. It preserves all three
classic-covered designs, passes Pareto validation, improves ALU best score by
3.73% versus classic, and improves multi-pipe best score by 14.34% versus
classic. Traffic-light best score remains 3.48% below classic, and SR raw still
retains more multi-pipe global Pareto members, so T26 is an active lead for
passive audit rather than a promoted result.

`T27_t26_live_qd_audit` is the completed live audit over T24, T25, and T26.
It shows that T26 beats classic on mean live PPA hypervolume (+11.62%),
hypervolume AUC (+17.62%), and mean best score (+3.02%). T26 also beats random
on every audited aggregate metric. The caveat is front material: T26 has 9
PPA-front points versus classic's 18 and SR raw's 16, and the audit can only
deduplicate unique PPA tuples, not canonical implementation families.

`T28_t26_family_audit` is the completed canonical/family duplicate audit. It
hashes normalized RTL, normalized synthesized netlists, and synthesized
cell-histogram families. T26 has the best valid-family ratio (0.912281) and 37
reference-beating families, one more than classic and fourteen more than SR
raw. The blocker is front families: T26 has 9, while classic has 19 and SR raw
has 16. The package now includes direct raw and normalized PPA-front plots plus
a scoped Phase 03.1 HTML viewer for Classic versus T26.

`visualization_audits/20260621_direct_ppa_fronts` is a cross-cutting figure
bundle over T24, T25, and T26 live methods. It adds the missing straightforward
area-power Pareto/front scatter plots, including candidate-zoomed raw PPA views
and normalized improvement-space views. The direct front plots make the current
T26 blocker visually obvious: Conservative exploit has strong best-PPA points,
but on `Prob015_multi_pipe_8bit` it has 6 candidate-level rank-1 front points
while SR raw has 10 and Classic has 14.

`T29_sr_raw_front_recovery_qd` is the completed front-recovery live variant. It
keeps SR raw PCA, local Pareto cells, the T26 fill target, and NSGA-II parent
selection, but lowers champion-lane pressure from 0.80 to 0.60 and restores
limited two-parent archive fusion at 0.20. It is `T0 diagnostic`: mean HV
falls to 0.139295 versus T26's 0.178862, HV-AUC falls to 0.118396 versus
0.144485, valid PPA falls to 42 versus 57, and total front points fall to 8
versus 9. The direct PPA-front plots show the core failure: on
`Prob015_multi_pipe_8bit`, T29 has only two candidate-level front points and
no final-population best PPA.

## Current Conclusions

1. `T04` is still the cleanest `T1 near_classic` validation candidate because
   it keeps final HV and best quality within the tier tolerance while improving
   common-audit QD score and PPA-front unique netlists.
2. `T19` is the most interesting HV source. It should not be promoted as-is,
   but it should be paired with local-Pareto archive coupling or a
   quality-safe parent schedule.
3. `T20` and `T21` show that synthesis-response and ST-NOD descriptors can
   expose front material without solving quality retention. They are inputs to
   archive-coupling variants, not final methods.
4. The random descriptor control is too strong to ignore. Any final positive
   claim should compare against classic, manual BD, and random descriptor.
5. A broad negative sign-off is not justified because `T04` and `T19` remain
   active leads.
6. The completed T24 matrix says the archive mechanism works, but unguarded
   local-Pareto parent pressure is not sufficient as-is.
7. T25 shows that a simple guarded SR raw schedule is not enough: lowering
   improve-phase backfill and two-parent fusion preserves coverage but does
   not recover the failing multi-pipe quality/yield behavior.
8. T26 is the first live parent-source variant that recovers best-quality
   pressure on the screen.
9. T27 shows that the T26 signal extends to live HV and HV-AUC, not only final
   best score. It is enough to continue validation, but not enough to claim a
   final useful-BD win.
10. T28 shows T26's valid candidates are not duplicate collapse, but also
    confirms the front-family deficit is real.
11. T29 shows that simply backing off T26's champion lane and restoring limited
    two-parent fusion is not the right front-recovery path.

## Next Decisions

- Run a T26 holdout audit or specify a T30 repair/yield/front-preserving
  emitter before any promotion claim.
- Do not continue blind interpolation between T24 SR raw and T26 scheduler
  settings; T29 is the measured negative result for that idea.
- Use the direct PPA-front audit figures when deciding whether a candidate has
  improved front shape, not only HV, best score, or aggregate front counts.
- Use manual BD as the traffic-light quality control, SR raw as the
  front-material control, and random as the live partitioning control for the
  next T24/T25/T26-derived audit.
- Keep `T22` in validation tables as a required comparator for any positive
  claim.
- Run deeper per-problem analysis on `Prob011_multi_16bit`,
  `Prob021_mux256to1v`, and `Prob030_popcount255`, because those problems
  explain much of the HV divergence.
- Keep Qwen3 preprocessing and encoder methods in the queue, but do not let
  learned encoders distract from validating the current synthesis-response
  leads.
