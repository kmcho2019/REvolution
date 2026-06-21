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

## Near-Term Hybrids

- ST-NOD plus motif/pathlet CVT: deterministic, cheap, likely first live
  candidate.
- SOG plus Yosys-stat grid: pre-synthesis operator graph paired with
  post-synthesis structural counts.
- VQ codebook plus MOME: codebook cells keep local PPA Pareto fronts instead
  of one elite.
- AutoQD over synthesis-event distributions: random Fourier features over
  stage occupancy and fixed-stimulus sketches.
- Lineage repair plus adaptive emitters: one emitter explores repair-prone
  regions while one preserves classic exploitation.
- Qwen normalized-view projection: embed canonical RTL, Yosys-normalized
  netlist text, and compact structural summaries; pool chunks to whole-design
  embeddings, then train contrastive or structural-bucket projections on
  non-PPA pairs.
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
