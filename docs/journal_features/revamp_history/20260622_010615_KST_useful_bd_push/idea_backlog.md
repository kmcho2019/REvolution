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
- Qwen structural-summary projection: embed canonical structural summaries,
  not raw full files, then train contrastive projection on non-PPA pairs.
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
