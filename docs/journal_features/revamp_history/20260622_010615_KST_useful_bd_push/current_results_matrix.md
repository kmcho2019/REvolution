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

Scaffolded but not yet real-result packages remain `T07` to `T16` and `T18`.
`T24` and `T25` are complete three-problem live development-screen results,
but both remain `T0 diagnostic`: T24 because every QD arm loses too much
`Prob015_multi_pipe_8bit` best quality, and T25 because the guarded SR raw
schedule worsens that multi-pipe quality loss while failing the traffic-light
valid-PPA gate. The ten-package minimum is satisfied, but the goal is still
active because validation of leads and adversarial sign-off are not done.

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
6. The completed T24 matrix says the archive mechanism works, but current
   local-Pareto parent pressure is not sufficient as-is.
7. T25 shows that a simple guarded SR raw schedule is not enough: lowering
   improve-phase backfill and two-parent fusion preserves coverage but does
   not recover the failing multi-pipe quality/yield behavior.

## Next Decisions

- Specify a T26-style emitter or parent-source variant instead of only tuning
  T25's guard. It should keep SR raw front material while explicitly restoring
  multi-pipe best quality and traffic-light valid-PPA yield.
- Use manual BD as the traffic-light quality control, SR raw as the
  front-material control, and random as the live partitioning control for the
  next T24/T25-derived variant.
- Keep `T22` in validation tables as a required comparator for any positive
  claim.
- Run deeper per-problem analysis on `Prob011_multi_16bit`,
  `Prob021_mux256to1v`, and `Prob030_popcount255`, because those problems
  explain much of the HV divergence.
- Keep Qwen3 preprocessing and encoder methods in the queue, but do not let
  learned encoders distract from validating the current synthesis-response
  leads.
