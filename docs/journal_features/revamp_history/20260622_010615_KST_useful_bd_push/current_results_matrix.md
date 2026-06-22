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
- `T30_t26_holdout_front_audit` classic-versus-T26 VerilogEval holdout audit
- `T31_sr_raw_fail_feedback_repair_qd` failure-feedback repair holdout arm
- `T32_sr_raw_front_preserving_emitter_qd` front-preserving emitter holdout arm
- `T33_qwen3_preprocessing_ladder_bd` Qwen preprocessing replay diagnostic
- `T34_qwen_pca_residual_bd` Qwen residual replay diagnostic
- `T07_deepgate_family_bd` graph-surrogate encoder replay diagnostic
- `T13_aurora_incremental_autoencoder_bd` implementation-feature/AURORA replay
  diagnostic
- `T14_dehnn_hypergraph_bd` directed-hypergraph replay diagnostic
- `T11_mgvga_contrastive_bd` structural-contrastive replay diagnostic
- `T35_t11_pareto_coupling_bd` T11 archive-coupling replay diagnostic
- `T36_t11_bounded_front_lane_bd` T11 bounded-front-lane replay diagnostic
- `T37_t36_slot_count_ablation` T36 explicit slot-count replay ablation
- `T38_elite_pareto_slot_live_qd` champion-plus-one-slot live diagnostic
- `T39_sparse_yield_warmup_qd` sparse-yield warmup live ablation
- `T40_sparse_warmup_control_matrix` completed T39 control matrix
- `T41_adaptive_sparse_yield_gate_qd` adaptive sparse-yield warmup fallback
- `T42_initial_sparse_yield_gate_qd` initial sparse-yield warmup fallback
- `T43_staged_sparse_yield_gate_qd` staged sparse-yield champion-pressure
  follow-up
- `T44_t11_runtime_graph_bridge` live-safe T11 runtime graph descriptor bridge
- `T45_t11_runtime_top4_graph` compact top-4 T11 runtime graph bridge
  live ablation
- `T46_t11_runtime_pca4_graph` frozen PCA4 T11 runtime graph projection
  live ablation

Scaffolded but not yet real-result packages remain `T08` to `T10`, `T12`,
`T15`, `T16`, and `T18`.
`T24`, `T25`, and `T26` are complete three-problem live development-screen
results. T24 and T25 remain negative diagnostics. T26 is the active SR-family
lead because it recovers ALU and multi-pipe best-score pressure while passing
the covered-design and catastrophic-validity gates. T27 upgrades the evidence
for T26 to `T1 near_classic` audit support on live HV and HV-AUC, but it still
blocks final promotion until family-front and holdout behavior improve. T28
adds canonical/family duplicate accounting: T26 valid candidates are mostly
distinct, but the front-family deficit versus classic and SR raw is real. The
T29 front-recovery variant is also negative: it does not recover the front
deficit and loses multi-pipe final-PPA coverage. T30 gives T26 holdout support:
it preserves all three classic-covered VerilogEval holdout designs and improves
mean best score, but it has a P098 yield warning and does not broaden the raw
PPA/front-family evidence. T31 is a negative same-budget repair result: it
does not repair P098 yield and loses T26's P135 HV/quality signal. T32 is also
negative: it improves P098 valid PPA versus T26/T31 and recovers some unique
PPA/front-netlist breadth, but it still loses T26's P135 HV/quality signal and
has zero mean HV/HV-AUC. T35 shows that T11 cell-local Pareto retention can
recover direct front hits, but the deployable cell-local arms lose too much HV;
the front-seeded arm is only an upper-bound diagnostic. T36 is the current
best replay lead: one local-front slot improves HV and direct front hits over
both lexical and T11. T37 confirms that the useful replay boundary is one
local-front slot: two or more slots collapse toward the weaker T35
cell-Pareto HV regime. T38 validates the live code path but exposes a
multi-pipe warmup archive gap. T39 fixes that specific gap by lowering
grid-quantile warmup from 8 to 4. T40 answers the same-budget control question
and keeps T39/T40 at `T0`: T39 wins multi-pipe best score and contributes
multi-pipe pooled-front points, but classic still owns ALU and traffic-light
pooled raw area-power fronts. The ten-package minimum is satisfied, but the
goal remains active.

T41 is complete and remains `T0 mixed_diagnostic`. It keeps the strict primary
grid-quantile warmup threshold of `8`, then permits a generation-1 fallback to
`4` valid PPA successes only when the archive is still empty and descriptor
geometry is ready. It preserves all classic-covered problems and wins
traffic-light with seven pooled raw area-power front hits and best score
`0.473631`, but it loses ALU to classic and loses the T39 multi-pipe signal
(`-0.000378` versus T39 `0.222285`).

T42 is complete and remains `T0 mixed_diagnostic`. It keeps T41's descriptor,
archive, parent selection, operator, model, seed, subset, and budget, but
changes `qd_grid_quantile_adaptive_warmup_generation` from `1` to `0`. The
primary evidence is the straightforward raw area-power Pareto figure
`techniques/T42_initial_sparse_yield_gate_qd/figures/t42_raw_area_power_fronts.png`,
with regeneration data in `tables/t42_candidate_ppa_points.csv`. T42 preserves
all classic-covered problems and adds one pooled raw-front hit on ALU plus one
on multi-pipe, but it loses T41's traffic-light win: zero traffic-light pooled
hits and best score `0.391093` versus T41's seven pooled hits and `0.473631`.
It also does not recover T39's multi-pipe best score (`0.116397` versus
T39's `0.222285`).

T43 is complete and remains `T0 mixed_diagnostic`. It keeps T42's archive,
descriptor, subset, model, seed, and budget, but lowers champion-lane pressure
from `0.80` to `0.60` only for a problem whose archive initializes through
`adaptive_sparse_yield_fallback`. The live run preserved all classic-covered
designs and passed validation, but all three archives completed strict
eight-success warmup, so the staged branch never activated. The direct raw
PPA-front figure
`techniques/T43_staged_sparse_yield_gate_qd/figures/t43_raw_area_power_fronts.png`
shows the blocker: T43 has zero pooled raw-front hits. It improves
traffic-light valid-PPA count versus matched classic (`26` versus `12`) and
has seven traffic-light method-front points, but those points are dominated in
the pooled comparison. T41 still owns the traffic-light pooled front, and
T39/T42 remain stronger multi-pipe controls.

T44 is complete and remains `T0 mixed_diagnostic`. It replaces the
`journal_graph_testability_3d` descriptor with a live-safe top-8 subset of
T11 structural graph axes on the T39 one-slot sparse-warmup substrate. It has
real signal: traffic-light and multi-pipe win final-analysis HV versus matched
classic, mean Pareto point count rises from 3.333 to 3.667, and the direct raw
PPA front adds one traffic-light pooled hit plus one multi-pipe pooled hit.
The blockers are also clear. Aggregate mean HV falls from 0.163787 to
0.154221, mean reference-beating count falls from 16.333 to 6.333, ALU valid
PPA drops from 35 to 16, and traffic-light valid PPA drops from 25 to 7. Those
two yield drops exceed the 50% gate with classic denominators above 10. T44's
full Phase 03.1 viewer is packaged at
`techniques/T44_t11_runtime_graph_bridge/visualizations/qd_ppa_viewer/index.html`;
the direct raw-PPA supplement is packaged at
`techniques/T44_t11_runtime_graph_bridge/visualizations/direct_ppa_pareto/index.html`.

T45 is complete and remains `T0 mixed_diagnostic`. It keeps T44's archive
substrate, model, subset, seed, budget, operator, and Phase 03.1/direct-PPA
visualization gates, but reduces `t11_runtime_top8_graph` to
`t11_runtime_top4_graph`. The compact profile preserves all three
classic-covered designs and avoids a 50 percent valid-PPA yield warning, but
the primary result is negative: classic wins mean HV (`0.2043` versus
`0.1775`), value-level HV outcomes (`2` wins plus one zero-HV tie versus no
wins), mean Pareto points (`3.67` versus `3.33`), reference-beating count
(`10.00` versus `8.67`), valid-PPA samples (`61` versus `41`), and every
best-score comparison. T45 contributes one traffic-light pooled raw-front
point, not enough to justify promotion.

T46 is complete and remains `T0 mixed_diagnostic`. It avoids direct
top-16/top-64 ranked-axis escalation by replacing raw top-k axes with a frozen
non-PPA four-component PCA projection over T44's top-8 graph feature family.
It preserves all three classic-covered designs and avoids the 50 percent
valid-PPA yield warning. The positive signal is narrow: T46 wins ALU HV
(`0.2046` versus classic `0.1962`), contributes one ALU pooled raw-front hit,
and improves best score on ALU and multi-pipe. The primary result is still
negative: classic wins mean HV (`0.1588` versus `0.1155`), HV wins (`2` versus
`1`), reference-beating count (`11.00` versus `7.00`), valid-PPA samples
(`54` versus `37`), and traffic-light quality. This retires direct graph-axis
dimensionality variants as the next live path; graph features should move to a
secondary archive/reporting role or a trained-encoder input unless a new
mechanism is specified.

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
but on `Prob015_multi_pipe_8bit` it has 2 raw area-power front points and 6
active-objective front points, while SR raw has 2 raw area-power front points
and 10 active-objective front points, and Classic has 4 raw area-power front
points and 14 active-objective front points.

`T29_sr_raw_front_recovery_qd` is the completed front-recovery live variant. It
keeps SR raw PCA, local Pareto cells, the T26 fill target, and NSGA-II parent
selection, but lowers champion-lane pressure from 0.80 to 0.60 and restores
limited two-parent archive fusion at 0.20. It is `T0 diagnostic`: mean HV
falls to 0.139295 versus T26's 0.178862, HV-AUC falls to 0.118396 versus
0.144485, valid PPA falls to 42 versus 57, and total front points fall to 8
versus 9. The direct PPA-front plots show the core failure: on
`Prob015_multi_pipe_8bit`, T29 has only two candidate-level front points and
no final-population best PPA.

`T30_t26_holdout_front_audit` is the completed holdout audit for the current
T26 lead. It compares classic REvolution and exact T26 conservative-exploit SR
raw on the frozen VerilogEval holdout screen: `Prob150_review2015_fsmonehot`,
`Prob098_circuit7`, and `Prob135_m2014_q6b`. T26 preserves final-best coverage
on all three problems, improves mean final-best score by 9.91%, and produces
positive normalized PPA HV from P135. The result is not a clean promotion:
valid PPA samples drop from 103 to 68, P098 drops from 31 to 15 valid PPA
samples, candidate-level front points tie at 3, unique PPA points drop from
11 to 8, and front netlists drop from 9 to 6. The package includes a
straightforward raw area-power Pareto figure with no inverted axes:
`figures/t30_holdout_ppa_pareto_area_power_candidate_zoom.png`.

`T31_sr_raw_fail_feedback_repair_qd` is the completed same-budget
failure-feedback repair holdout arm. It keeps T26's SR raw descriptor,
local-Pareto grid-quantile archive, NSGA-II parent selection, and 0.80
champion lane, but switches the code-individual emitter to
`single_thought_operator` with `1200` characters of failure feedback for
fail-pool parents. It is `T0 diagnostic`: final-best coverage stays at 3/3,
but valid PPA falls to 56 versus classic's 103 and T26's 68, P098 falls to
14 valid PPA samples versus T26's 15, mean final-best score falls to 0.201770,
and mean HV/HV-AUC return to zero. The direct raw PPA Pareto figure is
`figures/t31_holdout_ppa_pareto_area_power_candidate_zoom.png`.

`T32_sr_raw_front_preserving_emitter_qd` is the completed front-preserving
emitter holdout arm. It keeps the T26/T30 SR raw archive substrate, lowers
champion pressure only to 0.72, adds a small 0.08 two-parent success-parent
lane, and removes T31's direct fail-feedback text. It is `T0 diagnostic`.
T32 improves P098 valid PPA to 19 versus T26's 15 and T31's 14, and improves
unique PPA points to 9 versus T26's 8 and T31's 6. It does not preserve T26's
P135 final-best score or HV: mean final-best score stays at T31's 0.201770,
and mean HV/HV-AUC remain zero. The direct raw PPA Pareto figure is
`figures/t32_holdout_ppa_pareto_area_power_candidate_zoom.png`.

`T33_qwen3_preprocessing_ladder_bd` and `T34_qwen_pca_residual_bd` are the
completed Qwen L4 replay diagnostics. They show that normalized RTL views
carry a small HV signal, but label-free whole-design Qwen projections do not
align reduced nuisance collapse with PPA-front utility.

`T07_deepgate_family_bd` is the completed graph-surrogate L4 replay diagnostic.
The full DeepGate-family checkpoint path remains blocked for a full replay, so
T07 uses parsed standard-cell graphs with WL-hashed and graph-stat descriptors.
Graph WL/combo barely improves HV versus lexical (`+0.07%`) and improves
unique PPA points from 183 to 185, while same-problem nearest-neighbor collapse
is lower than in the Qwen probes. The direct PPA-front evidence blocks a
stronger claim: graph WL/combo keep 120 all-valid front hits versus lexical's
122. The primary figure is
`techniques/T07_deepgate_family_bd/figures/deepgate_multi_problem_ppa_pareto_fronts.png`.

`T13_aurora_incremental_autoencoder_bd` is the completed AURORA-style
implementation-feature replay. Raw implementation features are the current
best L4 replay lead: selected HV is `3.740943`, `+1.06%` over lexical
(`3.701827`), and unique PPA points improve from 183 to 186. The compressed
PCA, RFF-PCA, and incremental PCA bottlenecks are negative; all lose HV versus
lexical. Direct front-hit evidence still blocks promotion: raw implementation
features keep 120 all-valid front hits versus lexical's 122. The primary
figure is
`techniques/T13_aurora_incremental_autoencoder_bd/figures/aurora_multi_problem_ppa_pareto_fronts.png`.

`T14_dehnn_hypergraph_bd` is the completed directed-hypergraph replay. The
hypergraph-only descriptors improve selected PPA breadth but lose HV versus
lexical. The hybrid that concatenates hypergraph incidence features with T13
implementation features keeps a positive HV delta: `3.739236`, `+1.01%` over
lexical, and improves unique PPA points to 187. It is still not promoted
because direct front hits stay below lexical: 119 versus 122. The primary
figure is
`techniques/T14_dehnn_hypergraph_bd/figures/hypergraph_multi_problem_ppa_pareto_fronts.png`.

`T11_mgvga_contrastive_bd` is the completed MGVGA-style structural
contrastive replay. It uses T13/T07/T14 structural feature views and
self-supervised canonical-netlist/motif duplicate keys, excluding PPA,
fitness, validity, problem id, corpus, model, method, seed, and candidate id
from descriptor fitting. The top-64 and weighted contrastive descriptors are
the strongest L4 replay HV lead so far: selected HV is `3.769259`, `+1.82%`
over lexical, with 186 unique PPA points. It is still not promoted because
direct front hits remain below lexical: 120 versus 122. The primary PNG is
`techniques/T11_mgvga_contrastive_bd/figures/mgvga_multi_problem_ppa_pareto_fronts.png`.
The filesystem-openable direct raw PPA viewer is
`techniques/T11_mgvga_contrastive_bd/visualizations/direct_ppa_pareto/index.html`.

`T35_t11_pareto_coupling_bd` is the completed T11 archive-coupling replay. It
keeps T11's structural contrastive descriptors and tests local area-power
Pareto retention inside descriptor cells. The deployable cell-Pareto arms
improve direct front hits to `126`, versus lexical's `122` and T11's `120`,
but they lose too much selected HV: `3.369630`, or `-8.97%` versus lexical.
The passive front-seeded upper-bound arm reaches `3.864198` HV and `132`
front hits, proving the candidate pool contains recoverable front material,
but it uses global raw area-power front membership directly and must not be
claimed as a useful BD. The primary PNG is
`techniques/T35_t11_pareto_coupling_bd/figures/t35_multi_problem_ppa_pareto_fronts.png`.
The filesystem-openable direct raw PPA viewer is
`techniques/T35_t11_pareto_coupling_bd/visualizations/direct_ppa_pareto/index.html`.

`T36_t11_bounded_front_lane_bd` is the completed T11 bounded-front-lane replay.
It keeps the T11 farthest-first selector for most of each replay group and
fills one local-front slot from descriptor-cell area-power Pareto order. The
bounded lane reaches HV `3.851344`, `+4.04%` versus lexical and above T11's
`3.769259`. It also recovers direct front hits to `126`, above lexical's
`122` and T11's `120`. It is a `T2 replay_candidate`, not a final useful-BD
promotion, because no same-budget live run has tested generation-time
validity/coverage. The tested `5%` to `20%` quota labels collapse to one
front-lane slot on this replay surface, so they are not independent variants.
The primary PNG is
`techniques/T36_t11_bounded_front_lane_bd/figures/t36_multi_problem_ppa_pareto_fronts.png`.
The filesystem-openable direct raw PPA viewer is
`techniques/T36_t11_bounded_front_lane_bd/visualizations/direct_ppa_pareto/index.html`.

`T37_t36_slot_count_ablation` is the completed explicit slot-count ablation
for the T36 replay lead. Slot zero reproduces T11 (`3.769259` HV, `120` front
hits). One slot reproduces the T36 win (`3.851344` HV, `+4.04%` versus lexical,
`126` front hits). Two or more local-front slots lose too much HV
(`3.369630`, `-8.97%` versus lexical) even when front hits improve. The result
keeps T36/T37 at `T2 replay_candidate`: the next step is same-budget live
validation of exactly one bounded local-front slot, not a wider front lane.
The primary PNG is
`techniques/T37_t36_slot_count_ablation/figures/t37_multi_problem_ppa_pareto_fronts.png`.
The filesystem-openable direct raw PPA viewer is
`techniques/T37_t36_slot_count_ablation/visualizations/direct_ppa_pareto/index.html`.

`T38_elite_pareto_slot_live_qd` is the first live validation of the T37
one-slot boundary. It adds `elite_pareto_slot`, a runtime cell mode that keeps
the scalar quality champion plus one local PPA Pareto slot when
`--qd_max_elites_per_cell 2` is used. The bounded arm completed on the three
RTLLM screen problems and produced direct PPA figures. ALU has 25 valid PPA
points, 2 local/global front points, and 19 active archive members.
Traffic-light has 8 valid PPA points, 2 local/global front points, and 7
active archive members. Multi-pipe has 7 valid PPA points and 3 global/local
front points, but zero active archive members because the grid-quantile
warmup threshold is 8. T38 is therefore `T0 diagnostic`, not a useful-BD win.

`T39_sparse_yield_warmup_qd` is the focused T38 warmup ablation. It keeps the
same one-slot archive rule, descriptor, model, seed, subset, and budget, but
lowers `--qd_grid_quantile_warmup_successes` from 8 to 4. The bounded arm
completed in 750 seconds and passed Pareto validation with `failure_count=0`.
Multi-pipe moved from T38's 7 valid PPA, 3 local/global front points, and 0
archive members to 11 valid PPA, 8 local-front points, 6 global-front points,
and 10 active archive members. Traffic-light also improved valid PPA from 8
to 15 and best quality from 0.399899 to 0.403821. ALU kept archive/front
material but best quality fell from 0.416377 to 0.402072. T39 remains a `T0`
positive ablation after T40: it fixes the T38 archive gap and wins the hard
multi-pipe slice, but it is not a broad same-budget promotion.

`T40_sparse_warmup_control_matrix` is the completed control package for T39.
It freezes the completed T39 arm and compares matched classic, manual-BD,
random-descriptor, and full local-Pareto controls under the same subset, seed,
model, budget, warmup, and scheduler settings. Its first accepted figure is
`techniques/T40_sparse_warmup_control_matrix/figures/t40_raw_area_power_fronts.png`,
a straightforward raw area-power PPA Pareto comparison with conventional
non-inverted axes and lower-left marked as better. The result is `T0
mixed_control_no_promotion`: T39's multi-pipe best score is +321.04% versus
classic and it adds two multi-pipe pooled-front points, but classic keeps all
three ALU pooled-front points, three traffic-light pooled-front points, and
the best ALU and traffic-light scores.

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
12. T30 shows T26 can survive a small frozen VerilogEval holdout and improve
    mean best score, but it does not yet establish a broader QD front claim.
13. T31 shows same-budget fail-pool feedback is not the missing repair
    mechanism: it preserves coverage but worsens yield, unique PPA breadth,
    P135 HV/quality, and reference-beating count.
14. T32 shows a small near-front success-parent lane can recover some P098
    yield and unique PPA breadth, but not the T26 P135 quality/HV signal.
15. The next result must be read from direct raw PPA Pareto/front geometry
    before aggregate bars or BD-space visualizations, because the T30/T31/T32
    holdout panels expose front collapse that summary metrics can obscure.
16. T07 shows graph-structured learned-encoder features are more promising
    than label-free whole-design Qwen projections, but the current surrogate is
    still not a front win.
17. T13 shows raw implementation features are a better L4 signal than
    unsupervised AURORA-style compression. The next L4 step should preserve
    that signal and target front hits explicitly.
18. T14 shows hypergraph structure can add unique PPA breadth when combined
    with the T13 signal, but simple concatenation still does not recover direct
    front hits.
19. T11 shows structural contrastive feature selection is the strongest L4
    replay direction so far, but the direct raw PPA front still blocks
    promotion: it improves HV without beating lexical front-hit retention.
20. T35 shows local Pareto coupling can recover T11's missing front hits, but
    replacing descriptor novelty with cell-local Pareto retention loses too
    much HV. The next attempt should keep the T11 selector and add only a
    bounded front lane.
21. The T36/T37 one-slot bounded lane is the strongest current replay lead. It
    improves HV by +4.04% over lexical and recovers direct front hits to 126,
    but it still needs live validation before any useful-BD claim.
22. T37 confirms the T36 result is a one-slot boundary, not a broad quota
    sweep. Adding a second or third local-front slot over-replaces the T11
    selector and loses HV.
23. T38 proves the champion-plus-one-slot cell mode can run live and retain
    front material on ALU/traffic-light, but it also exposes a sparse-yield
    warmup failure: multi-pipe has valid/global front candidates and no active
    archive members.
24. T39 fixes the T38 sparse-yield archive gap and improves multi-pipe
    front/archive material, but T40 blocks a broad useful-QD promotion because
    classic still dominates ALU and traffic-light pooled raw PPA fronts.
25. T40 shows the next archive-coupling step should be adaptive or per-design:
    preserve classic/champion pressure on easier designs and reserve the
    sparse-yield one-slot lane for designs where archive activation or hard
    front recovery is the bottleneck.

## Next Decisions

- Do not continue direct fail-feedback repair as the next T26 follow-up.
- Do not continue simple champion-fraction/two-parent-probability tuning as
  the next T26 follow-up.
- Use the T30 P098 yield warning, T30/T31/T32 direct raw PPA-front plots, and
  T31/T32 failure modes as acceptance controls for the next emitter.
- If staying in this lane, separate emitter roles more sharply: restore T26
  champion pressure, add a bounded local-rank-1 or repair lane, and prevent
  the repair/front lane from replacing the P135 quality source.
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
- For the T11 lineage, do not promote front-seeded evidence as a method. Use it
  only to justify a gentler replay or live variant that preserves T11's
  farthest/HV behavior while reserving a small front-recovery lane.
- Do not promote T39 as a general useful-QD method after T40. It is a useful
  multi-pipe signal and sparse-yield ablation, not a same-budget win across
  the three-problem screen.
- For the T36/T37/T38/T39/T40/T41/T42/T43 lineage, stop global trigger-only
  champion-pressure tuning. Next either force a real sparse-trigger condition
  with a bounded warmup buffer/patience rule, or branch exact T11 runtime
  projection so the descriptor changes.
- For the T44/T45/T46 graph-runtime lineage, direct graph-axis dimensionality
  variants are now exhausted as the next primary live path. T46 tested the
  frozen non-PPA projection and still lost the aggregate comparison, so graph
  features should move to secondary archive/reporting coordinates or trained
  encoder inputs unless a new mechanism is specified.
