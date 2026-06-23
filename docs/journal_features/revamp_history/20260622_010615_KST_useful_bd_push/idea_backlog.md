# Idea Backlog

Use this backlog to keep generating methods during the goal. Move an idea into
a numbered `techniques/T##_slug/` package before running it.

## From `T01_simple_yosys_stat_bd` T0

- Keep simple Yosys-stat as the transparent CAD-native lower bound rather than
  a promoted method.
- Next descriptor should preserve the same validity/coverage guardrails while
  adding motif/pathlet or synthesis-delta information to recover common-audit
  QD score and best fitness.

## From `T02_motif_pathlet_bd` T0

- Coarse motif occupancy alone is not enough: it preserved Gate 0 but lost
  mean HV, common-audit coverage, and common-audit QD score.
- Retry the family only with richer non-PPA structure: pathlet histograms,
  reconvergence density, fanout buckets, or sequential cone balance.
- Prefer a hybrid with `T03_synthesis_delta_stnod_bd` before another pure
  motif-only archive, because the T02 failure suggests static motif ratios
  miss stage-response signal.

## From `T03_synthesis_delta_stnod_bd` T0

- ST-NOD is a prioritized near-miss: validity and HV are close enough to keep
  investigating, but common-audit QD score is much worse than classic.
- Next archive-coupling attempt should preserve ST-NOD's early HV behavior
  while preventing low-quality archive fill, for example by MOME-style local
  Pareto fronts or a stronger classic-exploitation lane.
- A richer hybrid can add pathlet/reconvergence features as auxiliary axes, but
  only if common-audit QD score improves rather than merely increasing motif
  signatures.

## From `T04_autoqd_mmd_synthesis_bd` T1

- RFF-PCA is the first `T1 near_classic` lead: final HV and best fitness are
  within 2% of classic, HV AUC improves, common-audit QD score improves, and
  PPA-front unique netlists increase.
- The immediate validation should compare RFF-PCA, ReLU-PCA, raw PCA, and an
  ST-NOD plus RFF hybrid under the same passive archive before any seed-3 or
  live-run promotion.
- Do not frame the current win as broad archive fill. Common-audit occupied
  cells and unique canonical netlists still decline, so the next variant needs
  quality-safe diversity pressure or local Pareto retention.

## From `T05_vq_elites_codebook_bd` T0

- A fixed 16-centroid codebook preserves classic-covered problems but loses
  too much PPA quality, valid-PPA yield, motif diversity, and passive QD score.
- Do not retry direct codebook parent pressure as the next live method.
  Codebook ideas should move to archive coupling: local Pareto fronts inside
  codebook cells, residual-norm auxiliary axes, or a codebook side archive
  paired with a classic/RFF exploitation lane.
- Keep `Prob030_popcount255` in mind for diagnostics because SR VQ produced
  one per-problem HV win there despite failing the global comparison.

## From `T06_qwen_projection_bd` T0

- Whole-RTL Qwen embeddings have PPA-relevant signal but are not a clean BD:
  identifier-normalized Qwen improves HV over lexical by 3.35%, while raw
  Qwen loses 1.25%, and nearest neighbors are dominated by same-problem and
  same-corpus clustering.
- The next Qwen attempt should be normalized-view projection, not another raw
  whole-file farthest-first replay: canonical RTL, Yosys-normalized netlist
  text, structural-summary text, pooled whole-design embeddings, then
  contrastive or structural-bucket projection.
- Treat Qwen as an auxiliary descriptor or side archive unless nuisance-axis
  diagnostics improve: same-problem nearest-neighbor fraction must fall, and
  duplicate/motif alignment must rise, before any live-run promotion.
- Keep a simple Qwen3 preprocessing-ladder replay as a future low-cost check:
  raw RTL, commentless RTL, role-normalized RTL, canonical RTL,
  Yosys-normalized netlist text, and summary-plus-netlist text should be
  embedded with the same frozen model before projection-head training. The open
  decision is which view and pooling rule produces a whole-design embedding that
  improves QD/Pareto replay metrics without increasing same-problem collapse.

## From `T33_qwen3_preprocessing_ladder_bd` Pre-Registration

- Run the ladder before claiming learned-encoder failure. The first useful
  signal is lower same-problem nearest-neighbor fraction than T06's `0.9336`
  while matching or beating lexical/random controls on at least one QD/Pareto
  metric.
- If only one normalized view improves nuisance diagnostics, try a small
  projection-head or SR-raw hybrid before escalating to DeepGate/AURORA-style
  external encoders.
- If every view still clusters by problem or identifier churn, retire whole-text
  Qwen as a direct BD and use it only as an auxiliary report feature.

## From `T17_mome_pareto_archive_bd` T0

- Passive local-Pareto retention is promising as an archive-coupling direction:
  it substantially increases retained nondominated points, PPA-front unique
  netlists, and PPA-grid cells, but its own HV delta is tiny.
- Do not promote T17 from passive evidence alone. The next attempt should be a
  bounded live variant on `sr_rff_pca_qd` or `sr_random_relu_pca_qd` with local
  Pareto cell fronts and a frozen parent schedule that samples crowded local
  fronts, underfilled cells, and the global nondominated front.
- Keep scalar weighted-sum fitness out of descriptor construction. Fitness and
  PPA can be used only after evaluation for archive insertion and parent
  selection within the already evaluated Pareto archive.

## From `T38_elite_pareto_slot_live_qd` T0

- T38 validates the live champion-plus-one-front-slot code path, but the
  grid-quantile warmup threshold of eight leaves sparse-yield multi-pipe with
  seven valid PPA points, three global/front points, and zero active archive
  members.
- The immediate follow-up is T39: keep every T38 setting fixed except lower
  `--qd_grid_quantile_warmup_successes` from `8` to `4`.
- If T39 still leaves multi-pipe archive-empty, do not keep lowering the
  threshold blindly. The next ablation should be a run-end or generation-end
  replay of already-valid global Pareto members into a reporting archive, kept
  separate from in-loop descriptor construction.

## From `T39_sparse_yield_warmup_qd` Positive Ablation

- T39 fixes the T38 multi-pipe active-archive gap without changing descriptor
  inputs, but T40 shows it is not a promoted useful-QD result. The uniform
  one-slot rule wins multi-pipe best score and pooled-front hits, while classic
  still wins ALU and traffic-light raw area-power fronts.
- Next candidate: adaptive sparse-yield gating. Initialize at four successes
  only for designs still archive-empty after the first generation, or when
  direct front recovery is explicitly weak. Keep the classic/champion lane
  stronger on designs that already have healthy front and yield behavior.
- T41 pre-registers the first version: primary warmup `8`, generation-1
  fallback `4`, same T40 subset/model/seed/budget, matched live classic, and
  frozen T40 manual/random/full-Pareto controls.
- Any adaptive follow-up must lead with straightforward raw area-power PPA
  fronts: area on x, power on y, no inverted axes, and lower-left marked as
  better.

## From `T41_adaptive_sparse_yield_gate_qd` T0

- T41 shows adaptive gating can find a real traffic-light win: 7 pooled raw
  area-power front hits and best score `0.473631`.
- T41 also shows generation-1 fallback is too late for the hard multi-pipe
  slice. Multi-pipe initialized from 5 samples, but best quality collapsed to
  `-0.000378` versus T39's `0.222285`.
- Next candidate is now pre-registered as
  `T42_initial_sparse_yield_gate_qd`. Keep strict warmup `8`, but allow
  fallback `4` at trigger generation `0` so sparse-yield designs can
  initialize immediately after the initial population. Keep the same T41
  subset/model/seed/budget and the same direct raw PPA-front figure gate.

## From `T45_t11_runtime_top4_graph` T0

- T45 fixes the T44 catastrophic valid-PPA yield warning but loses to classic
  on every primary aggregate metric. This means direct ranked top-k graph axes
  are not the right next escalation path.
- T46 tested the planned replacement: a frozen non-PPA PCA4 projection over
  T44's top-8 graph feature family. The fit used graph-only T14 rows and
  excluded PPA, fitness, validity, pass-rate, problem, corpus, model, method,
  seed, and candidate-id labels.
- T46 also loses on the primary aggregate metrics, so stop treating T11
  runtime graph axes as a primary live archive coordinate. Reuse them only as a
  secondary archive lane, a reporting projection, or input to a genuinely
  trained encoder.

## From `T46_t11_runtime_pca4_graph` T0

- T46 preserves all classic-covered designs and avoids the 50 percent
  valid-PPA yield warning, so the frozen projection is operationally usable.
- It is not a promoted method: classic wins mean HV, HV wins, reference-beating
  count, valid-PPA samples, and traffic-light quality. T46's useful signal is
  restricted to ALU HV, one ALU pooled raw-front hit, and best-score wins on
  ALU plus multi-pipe.
- Do not spend the next live budget on another direct graph-axis dimensionality
  tweak. Reuse graph features as a secondary archive/reporting projection or
  as trained-encoder inputs, and return primary live budget to T26-family
  SR/archive-coupling variants or role-separated emitters.

## From `T19_sr_relu_pca_bd` T0

- SR ReLU PCA is a high-priority HV lead, not a promoted method: final mean HV
  improves by 16.82% and HV AUC by 65.24%, but final best fitness,
  PPA-front unique netlists, and common-audit occupied cells decline.
- Validate the two per-problem HV wins, especially
  `VerilogEval-Spec-to-RTL/Prob021_mux256to1v`, under another seed or holdout
  subset before relying on the aggregate HV gain.
- The next live variant should pair SR ReLU with bounded local-Pareto cell
  fronts from `T17` and a quality-safe parent schedule. The goal is to keep the
  HV lead while recovering best-fitness and audit-coverage losses.
- Try an SR-RFF/SR-ReLU ensemble or ST-NOD plus SR-ReLU hybrid only if the live
  local-Pareto variant still loses front coverage.

## From `T20_sr_raw_pca_bd` T0

- Raw PCA preserves validity exactly and improves PPA-front unique netlists by
  16.67%, unique canonical netlists by 5.71%, and motif signatures by 11.63%.
  This is evidence that synthesis-response features contain useful diversity
  signal before nonlinear random maps are added.
- Do not promote raw PCA alone: final best fitness drops by 9.97% and
  common-audit QD score drops by 15.11%.
- Use raw PCA as the ablation baseline for SR-ReLU, SR-RFF, and local-Pareto
  archive coupling. The target improvement is keeping raw PCA's front-material
  gain while restoring best-fitness and passive-QD score.

## From `T21_stnod_motif_hybrid_bd` T0

- ST-NOD+motif is an archive-coverage ablation: it improves PPA-front unique
  netlists by 66.67% and common-audit occupied cells by 33.33%, but loses
  final best fitness by 10.90% and common-audit QD score by 25.98%.
- Do not continue this family by blindly concatenating more deterministic axes.
  The next deterministic descriptor should use feature selection, CVT, or
  local-Pareto retention to keep coverage without lowering cell quality.
- If this hybrid is reused, use it as a side archive or CVT source, not as the
  main parent-pressure descriptor.

## From `T22_random_descriptor_control` T0

- Random descriptor is a required comparator, not a candidate. It improves HV
  AUC by 35.69%, valid-PPA count by 1.91%, and PPA-front unique netlists by
  75.00% versus classic, so weak semantic descriptors cannot claim success by
  beating manual BD only.
- Do not improve random hash itself. Use it to calibrate whether apparent QD
  gains are real descriptor value or random archive partitioning.
- Any SR-RFF, SR-ReLU, local-Pareto, Qwen, or encoder follow-up should compare
  against T22 on the metric being claimed.

## From `T23_sr_pareto_validation_matrix` T0

- SR-RFF is the cleaner live archive-coupling candidate: it is within the
  near-classic quality tolerance, improves common-audit QD versus classic and
  random, and has the strongest local-Pareto front material in the focused
  matrix.
- SR ReLU is the stronger HV candidate: it beats classic and random on final HV
  and HV AUC, but it needs a parent/retention rule that recovers local front
  material versus random BD.
- The next live variant should compare SR-RFF-local-Pareto and SR-ReLU-local-
  Pareto against classic, manual BD, and T22 random descriptor under the same
  budget.

## From `T24_sr_pareto_live_validation` T0

- Local Pareto cells and NSGA-II parent selection run end to end, but unguarded
  local-Pareto pressure loses too much `Prob015_multi_pipe_8bit` best quality.
- SR raw remains the best immediate source for a follow-up because it keeps the
  strongest multi-pipe front material and the best ALU gain.
- Manual BD is the traffic-light quality control: it improves traffic-light
  best score without a catastrophic validity drop, but still fails multi-pipe.
- The next method should not reset descriptors. It should keep SR raw and test
  a quality/yield-guarded schedule that lowers improve-phase backfill and
  two-parent fusion before spending budget on learned encoders.

## From `T25_guarded_sr_raw_pareto_qd` T0

- A simple guarded schedule is not enough. T25 preserves all three
  classic-covered designs and passes Pareto validation, but worsens the
  multi-pipe best-score loss versus SR raw and still fails the traffic-light
  valid-PPA gate.
- Do not continue by only nudging `qd_improve_backfill_fraction` or
  `qd_two_parent_probability`. The next live method should change parent-source
  structure: explicit exploit/explore/repair emitters, per-problem yield
  guardrails, or a champion lane that can recover best quality while keeping
  SR raw front material.
- Keep the T25 comparison set fixed for the next variant: classic, manual BD,
  random BD, SR raw, and T25. The next result should beat T25 on multi-pipe
  best quality or traffic-light valid-PPA yield before claiming progress.

## From `T26_sr_raw_conservative_exploit_qd` T0

- Conservative fill plus champion exploit is the first live parent-source
  variant that recovers best-quality pressure on the screen: ALU improves by
  3.73% and multi-pipe improves by 14.34% versus classic.
- Do not promote from this live screen alone. Traffic-light best score still
  trails classic and manual BD, and SR raw still keeps stronger multi-pipe
  front material.
- Next step should be an audit package, not another blind scheduler nudge:
  recompute passive HV/QD, front spread, unique implementation families,
  front-material retention versus SR raw, and holdout behavior.
- If the audit keeps the ALU/multi-pipe best-quality signal but shows weak
  traffic-light yield or weak front material, branch to a repair-emitter or
  per-problem emitter schedule with T26 as the direct comparator.

## From `T27_t26_live_qd_audit`

- T26 now has live HV/HV-AUC support: +11.62% mean HV, +17.62% HV AUC, and
  +3.02% mean best score versus classic on the fixed screen. The next step
  should validate this signal, not discard it for another descriptor reset.
- Front material is still the blocker. T26 has 9 PPA-front points versus
  classic's 18 and SR raw's 16, so the next variant must either recover front
  material or make a narrower HV/best-quality claim.
- Canonical duplicate/family audit is now covered by T28 on the development
  screen. Unique PPA tuples remain only a proxy for any future screen until the
  same audit is rerun there.
- Holdout audit should be the next package before repair emitters. If T26
  keeps HV/HV-AUC on holdout but loses front material, then branch to an
  emitter schedule that reintroduces SR raw exploration while preserving the
  champion lane.
- Potential T29: `t26_holdout_family_audit`, a replay/live-audit package that
  extracts canonical netlist hashes or motif-family signatures where available,
  recomputes common passive archive metrics, and decides whether T26 advances
  to a longer live confirmation branch.

## From `T28_t26_family_audit`

- T26's valid candidates are not mostly duplicates: it has the best
  valid-family ratio (0.912281) and only 5 family duplicates among 57 valid-PPA
  candidates.
- The front-family blocker is real: T26 has 9 front families versus classic's
  19 and SR raw's 16. Do not claim broad QD/front illumination from T26 as-is.
- Next live direction should either validate T26 on holdout as a narrow
  HV/best-quality method or add front recovery while preserving the champion
  lane.
- Potential T29: `t26_holdout_audit`, same T28 family metrics on holdout tasks
  if a bounded live holdout run is launched.
- Potential T29 alternative: `sr_raw_exploit_front_recovery`, with a fixed
  SR-raw exploration quota, repair emitter, or local-front parent quota to
  recover front families while keeping T26's champion exploit pressure.
- T29 selected: `sr_raw_front_recovery_qd` keeps SR raw PCA and T26's archive
  substrate, lowers champion lane to 0.60, and restores limited 0.20 two-parent
  fusion. Any further schedule tweak should become T30 after the T29 result is
  measured.

## From `T29_sr_raw_front_recovery_qd`

- T29 is a measured negative for simple schedule interpolation. Lowering
  champion pressure to 0.60 and restoring 0.20 two-parent fusion reduces mean
  HV, HV-AUC, valid PPA, total front points, and multi-pipe final-PPA coverage
  versus T26.
- Direct PPA-front plots are now mandatory evidence for any follow-up. The
  multi-pipe panel shows only two T29 front points, so aggregate bars alone
  would overstate the method.
- Potential T30: `t26_holdout_family_audit`, using the same direct-front and
  family-audit tables before adding a new live mechanism.
- Potential T30 alternative: `sr_raw_repair_front_emitter`, keeping T26's
  champion lane while adding a bounded repair/yield/front-preserving emitter
  instead of generic two-parent exploration.
- T30 selected: `t26_holdout_front_audit` compares classic versus exact T26
  conservative-exploit SR raw on the frozen VerilogEval holdout screen. A new
  repair/yield emitter should wait for this holdout evidence.

## From `T30_t26_holdout_front_audit`

- T26 earns holdout support but not promotion. It preserves all three
  classic-covered holdout designs, improves mean final-best score by 9.91%,
  and produces the only positive normalized HV through P135.
- The blocker is now sharper: P098 valid PPA samples fall from 31 to 15,
  candidate-level front points only tie classic, unique PPA points fall from
  11 to 8, and front netlists fall from 9 to 6.
- T31 should be a repair/yield/front-preserving emitter, not another blind
  champion-lane interpolation. Keep T26's champion refinement lane, add a
  bounded repair lane for invalid or weak-yield descendants, and add a local
  front-preservation lane that samples rank-1 or near-rank-1 candidates even
  when they are not the scalar champion.
- Required T31 controls: classic, exact T26, T29 as the failed front-recovery
  control, and the T30 holdout direct raw PPA Pareto plots.
- Required T31 visual: a straightforward raw area-power Pareto front with no
  inverted axes, plus normalized improvement front and valid-PPA/yield bars.
- T31 selected: `sr_raw_fail_feedback_repair_qd` keeps code-individual SR raw
  QD, NSGA-II parent selection, and the 0.80 champion lane, but routes
  same-budget fail-pool requests through `single_thought_operator` with
  1200-character failure feedback. It intentionally avoids `thought_only` and
  extra local repair attempts in the first holdout run because prior journal
  evidence showed those mechanisms can trade away PPA quality.

## From `T31_sr_raw_fail_feedback_repair_qd`

- Direct same-budget fail-pool feedback is retired as a standalone follow-up.
  It preserves final-best coverage on all three holdout designs, but valid PPA
  falls to 56 versus T26's 68 and classic's 103.
- T31 does not repair the target P098 issue: P098 valid PPA is 14, slightly
  worse than T26's already weak 15 and far below classic's 31.
- T31 loses the T30/T26 P135 signal: final-best score falls to 0.263617, and
  mean normalized HV/HV-AUC return to zero.
- Candidate-level front points still tie at 3, but unique PPA points fall to
  6 and reference-beating points fall to 2. The direct raw PPA Pareto figure
  shows no visible front widening.
- Potential T32: `sr_raw_front_preserving_emitter_qd`, an explicit emitter
  ensemble with separate lanes for champion exploitation, near-front parent
  sampling, and bounded repair attempts. The key difference from T31 is that
  repair is isolated to a bounded lane and cannot replace all archive-parent
  requests.
- Potential T32 acceptance controls: T26/T30 for quality pressure, T29 for
  failed generic exploration, T31 for failed direct repair, and the raw
  area-power PPA Pareto plots as mandatory primary figures.
- T32 selected: `sr_raw_front_preserving_emitter_qd` keeps the T26/T30 SR raw
  archive substrate, lowers champion pressure from `0.80` to `0.72`, adds a
  small `0.08` two-parent success-parent lane, and removes T31's direct
  fail-feedback text. The first acceptance view must be the straightforward
  raw area-power PPA Pareto plot and candidate table, not aggregate bars or
  BD/archive visualizations.

## From `T32_sr_raw_front_preserving_emitter_qd`

- T32 is a measured negative for small near-front success-parent tuning. It
  improves P098 valid PPA to 19 versus T26's 15 and T31's 14, and improves
  unique PPA points to 9 versus T26's 8 and T31's 6.
- The useful P135 signal still collapses: T32 mean final-best score is
  0.201770, matching T31 and below T26's 0.246463, while mean HV/HV-AUC remain
  zero.
- Do not continue by only nudging `qd_champion_lane_fraction` or
  `qd_two_parent_probability`. The next same-family attempt needs genuinely
  separate roles: a T26-style champion lane, a local rank-1/front-preserving
  lane, and a bounded repair/yield lane that cannot replace champion pressure.
- Keep T32 as a P098-yield hint and direct-front control. The raw area-power
  Pareto plot is mandatory evidence for any follow-up because aggregate valid
  counts alone would overstate the result.

## From `T49_thought_k_role_separated_repair_qd`

- T49 is useful diagnostic evidence, not a lead. It preserves every
  classic-covered valid-PPA design and improves mean best score, but loses mean
  HV, valid-PPA count, aggregate front points, unique PPA points, and
  reference-beating candidates.
- T49 also exposed a control issue: `thought_only` interprets
  `population_size` as code-sample budget. With `population_size=9` and
  `code_samples_per_thought=3`, the run used only nine base code samples per
  generation, not the classic/T47/T48 twelve-sample base budget.
- T50 should test a narrow but multi-variable correction before another repair
  mechanism: restore `population_size=12`, keep `code_samples_per_thought=3`,
  disable repair so evaluated-candidate budget is visible, and widen the local
  Pareto cap to preserve more front material. A positive result would motivate
  ablation; it would not identify a single causal knob.
- If T50 still loses front/yield evidence, retire direct thought-only
  role-separated emitters until a genuinely new front-preservation mechanism is
  specified.

## From `T35_t11_pareto_coupling_bd`

- T35 shows that the T11 candidate pool contains recoverable front material:
  the front-seeded upper bound reaches `+4.39%` HV and `132` direct front
  hits. This is evidence about the pool, not a method claim, because it uses
  global raw PPA-front membership directly.
- The deployable cell-local Pareto arms are negative as standalone replacements
  for T11 farthest-first retention. They improve front hits to `126`, but lose
  `8.97%` HV and reduce unique PPA to `162`.
- Potential T36: `t11_bounded_front_lane_bd`. Keep the T11 contrastive
  farthest/HV selector as the main lane, reserve a small fixed quota for
  descriptor-cell or near-front recovery, and compare against lexical, T11,
  T35 cell-local Pareto, and the T35 front-seeded upper bound.
- Required T36 visual: the first figure must again be a direct raw area-power
  PPA Pareto front, with the HTML viewer regenerated from committed point
  tables and inspected before any aggregate conclusion is accepted.

## From `T36_t11_bounded_front_lane_bd`

- T36 is the strongest replay lead so far: one local-front slot reaches
  `3.851344` HV (`+4.04%` versus lexical) and `126` direct front hits (`+4`
  versus lexical), beating T11 and fitness-top on the claimed replay metrics.
- The `5%` to `20%` quota arms collapse to the same one-slot bounded lane
  because retained group sizes are small. Do not count those labels as
  independent evidence.
- Potential live follow-up: `t37_live_bounded_front_lane_qd`. Implement the same archive
  rule in a same-budget live screen, keeping the T11 descriptor and one local
  front-recovery slot per cell/group. Acceptance gates: preserve every
  classic-covered design, avoid catastrophic validity collapse, and show the
  direct raw PPA front before aggregate claims.
- Completed passive follow-up: `T37_t36_slot_count_ablation` compares zero,
  one, two, and three local-front slots under the same replay setup so the
  slot-count effect is explicit rather than hidden behind percent quotas.

## From `T37_t36_slot_count_ablation`

- T37 confirms that one bounded local-front slot is the useful replay boundary:
  it keeps the T36 HV/front-hit win, while two or more local-front slots fall
  back to the weaker T35 cell-Pareto HV regime.
- Do not spend live budget on two-slot or three-slot front lanes unless a new
  mechanism changes the retained group size or archive pressure. Wider front
  lanes are not automatically better.
- Next live method should implement exactly one bounded local-front slot on
  top of the T11 structural contrastive descriptor. The direct raw PPA Pareto
  plot is the first acceptance figure; aggregate HV bars are secondary.
- T38 implements the live archive-rule portion as `elite_pareto_slot`, using a
  runtime graph/testability descriptor because exact T11 projection is not yet
  available online. If T38 helps, implement the exact T11 runtime projection
  next; if it fails, do not blame the T11 descriptor without that follow-up.
- T38 live result: ALU and traffic-light retain active archive/front material,
  but multi-pipe has seven valid PPA candidates and three front points with
  zero active archive members because `grid_quantile` warmup needs eight
  successes. Next idea: T39 sparse-yield warmup/fallback keeps
  `elite_pareto_slot` but initializes when a problem has at least 4-7 valid
  PPA candidates or replays global Pareto members into the active archive at
  run end for low-yield problems.

## From `T42_initial_sparse_yield_gate_qd`

- T42 shows that generation-0 sparse-yield fallback is not enough as a global
  timing change. The direct raw PPA front adds one ALU pooled-front point and
  one multi-pipe pooled-front point, but it loses T41's traffic-light front
  win and still misses T39's multi-pipe best score.
- Do not continue by moving the same warmup trigger earlier or later. The next
  method should use staged or per-design activation: keep strict warmup and
  champion pressure for healthy-yield problems, then activate sparse one-slot
  fallback only when initial archive sparsity is measured.
- Candidate follow-up: `T43_staged_sparse_yield_gate_qd`. Gate variables
  should be pre-PPA-leakage runtime state only: initial valid-PPA count,
  archive initialized/not initialized, descriptor spread, and warmup buffer
  size. The method must not branch on final score, final Pareto rank,
  reference PPA, or problem identity.
- Required visual gate remains the direct raw area-power Pareto front. The
  method cannot be interpreted from archive heatmaps or aggregate counts alone.

## From `T43_staged_sparse_yield_gate_qd`

- T43 answers the staged champion-lane idea negatively for this screen. The
  method preserved all classic-covered designs and passed validation, but all
  three QD archives completed strict eight-success warmup, so the staged
  `0.60` lane never activated.
- The direct raw area-power front is the decisive artifact: T43 has zero
  pooled raw-front hits. It broadens the traffic-light method front, but T41
  still owns the pooled traffic-light front and T39/T42 remain better
  multi-pipe controls.
- Do not continue with another global champion-lane percentage tweak unless
  the screen actually enters sparse fallback. A valid follow-up must either
  add a bounded warmup buffer/patience rule that creates pre-registered sparse
  fallback evidence, or change the descriptor by implementing exact T11 runtime
  projection.

## From `T44_t11_runtime_graph_bridge`

- T44 proves the live T11 graph bridge is not empty evidence: traffic-light and
  multi-pipe win final-analysis HV, and the direct raw PPA front adds one
  pooled hit on each of those problems.
- The top-8 axis archive is too sparse for promotion. ALU valid PPA drops from
  35 to 16 and traffic-light valid PPA drops from 25 to 7, both beyond the
  50% gate with classic denominators above 10.
- Candidate follow-up: `T45_t11_runtime_compact_graph_qd`. Keep the T39/T44
  one-slot sparse-warmup substrate, but use a smaller pre-registered top-3 or
  top-4 axis subset, or a frozen non-PPA projection fitted only from descriptor
  geometry. Do not use PPA, score, reference PPA, Pareto rank, pass/fail label,
  or problem identity in the projection.
- Do not jump to top-16/top-64 fitted T11 projection until the compact version
  shows that the yield drop was caused by avoidable archive sparsity rather
  than by the graph descriptor itself.
- Required visual gates remain unchanged: full Phase 03.1 `qd_ppa_viewer/`,
  direct raw PPA supplement, strict validation, and inspected screenshots.

## From `T45_t11_runtime_top4_graph`

- T45 tested the compact top-4 follow-up. It preserves all three
  classic-covered designs and avoids a 50 percent yield warning, but classic
  wins mean HV, HV wins, mean Pareto points, reference-beating count,
  valid-PPA samples, and every best-score comparison.
- Retire direct ranked-axis escalation for this lane. Do not run top-16 or
  top-64 graph axes as the next method just because top-4 avoided the yield
  warning.
- Candidate follow-up: use T11/T45 graph features as a secondary archive lane
  or frozen non-PPA projection. The primary archive geometry should remain a
  proven quality/yield-safe descriptor, while graph features influence a
  bounded side lane or parent tie-breaker.
- A stronger graph follow-up must pre-register the projection source and prove
  it excludes final PPA, score, reference PPA, Pareto rank, pass/fail labels,
  and problem identity.

## From `T50_candidate_matched_thought_front_qd`

- T50 rejects the simple candidate-budget/front-retention explanation for
  T49's losses. Restoring `population_size=12`, disabling repair, and widening
  per-cell Pareto retention improves mean best score, but loses HV, HV-AUC,
  valid-PPA count, unique PPA points, and reference-beating candidates on the
  completed 12-problem screen.
- Do not run T50 seed `1002` or held-out spend. The next idea must change the
  mechanism, not just the same thought-only role-separation budget.
- T51 is the first bounded version of that next idea. It restores direct code
  individuals, keeps `single_thought_operator`, uses one local front slot, and
  lowers sparse-yield warmup to `4`.
- Candidate follow-up: a front/yield-preserving emitter with two explicit
  lanes. One lane samples archive champions for best-score pressure. The other
  lane samples underrepresented valid-PPA front families and near-front
  parents, but it must be gated by pre-PPA-safe runtime state such as archive
  occupancy, valid-PPA count, descriptor spread, parent arity, and duplicate
  family count from already evaluated candidates.
- The follow-up must report both direct raw area-power fronts and unique
  PPA-family counts. It must not use final PPA score, reference PPA, final
  Pareto rank, problem identity, or held-out outcomes to choose the descriptor
  or emitter schedule.

## From `T51_code_thought_front_slot_qd`

- T51 confirms that the direct-code representation is the right recovery from
  T50's thought-only yield collapse. It restores the full 13-problem candidate
  budget, improves valid-PPA count, improves HV-AUC, and keeps best-score
  pressure.
- T51 is not a promoted useful-BD claim because classic still has more mean HV,
  more PPA-front points, and more unique PPA points on the all-13 comparison.
- Candidate follow-up: keep `representation_kind=code_individual` and
  `single_thought_operator`, but replace the one passive local-front slot with
  an explicit front-family lane. The lane should upsample already valid
  low-crowding front families or underrepresented archive-front cells without
  using held-out outcomes or problem identity.
- The follow-up should specifically address `Prob015_multi_pipe_8bit`, where
  T51's valid-PPA recovery does not translate to front breadth.

## Near-Term Hybrids

- ST-NOD plus motif/pathlet CVT: deterministic, cheap, likely first live
  candidate.
- SOG plus Yosys-stat grid: pre-synthesis operator graph paired with
  post-synthesis structural counts.
- VQ codebook plus MOME: codebook cells keep local PPA Pareto fronts instead
  of one elite.
- Smooth-QD-v2 Pareto-biased parent sampling: keep MAP-Elites cell assignment
  on a non-PPA descriptor, but upsample evaluated nondominated candidates from
  local cell fronts and underfilled cells so the search can hill-climb without
  collapsing into a single scalar-fitness population.
- AutoQD over synthesis-event distributions: random Fourier features over
  stage occupancy and fixed-stimulus sketches.
- Lineage repair plus adaptive emitters: one emitter explores repair-prone
  regions while one preserves classic exploitation.
- Qwen normalized-view projection: embed canonical RTL, Yosys-normalized
  netlist text, and compact structural summaries; pool chunks to whole-design
  embeddings, then train contrastive or structural-bucket projections on
  non-PPA pairs.
- Qwen3 preprocessing ladder: before training a head, compare preprocessing
  strength and chunk-pooling rules directly against lexical farthest-first,
  using collapse diagnostics as a hard filter.
- DeepGate/DE-HNN cone fusion: combine AIG cone embeddings with hypergraph
  long-range net summaries.
- DeepCell-style multiview: post-mapping cell features plus AIG summaries with
  masked-circuit surrogate loss.

## More Aggressive Ideas

- Active subset curriculum: start on frozen screening tasks, then automatically
  add holdout tasks by pre-registered complexity strata.
- Descriptor ensemble archive: one candidate can occupy separate structural,
  lineage, and learned-embedding archives; parent selection alternates archives.
- Disagreement-driven BD: descriptor cells defined by disagreement among
  PPA-free proxy models, then evaluated with real PPA after generation.
- Pareto-novelty selection: active archive stores the best PPA front per cell,
  while parent sampling favors cells with sparse Pareto neighborhoods.
- Cross-model transfer: learn descriptors on ASP-DAC DeepSeek/GPT/Llama replay
  and test on a different model's candidates or live vLLM samples.
- Function-sketch descriptors: fixed random simulation outputs, toggle
  histograms, and response entropy, never testbench pass/fail.

## Retirement Requirement

An idea is retired only after the history records:

- what was tried;
- what metric failed;
- whether failure was validity, duplicate, collapse, runtime, or no PPA signal;
- the next related idea or why the family is exhausted.
