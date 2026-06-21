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
