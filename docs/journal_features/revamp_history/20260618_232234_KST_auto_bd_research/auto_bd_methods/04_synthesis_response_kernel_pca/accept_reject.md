# Synthesis-Response Kernel PCA Decision

Decision: not evaluated.

Current status: runtime ready for `sr_raw_pca_qd`; evolution runs are not
implemented yet.

## Required Evidence

- Frozen feature schema, scaler, random-map, and PCA hashes.
- Training candidate list and excluded held-out/final-evaluation data.
- Gate 0 coverage versus original REvolution.
- Robustness rates versus landing Smooth-QD manual-BD and classic
  REvolution.
- Strict zero-reference HV and `ANHV@1.5`.
- Common-audit QD coverage and score.
- Pareto-front unique netlists and motif-signature diversity.
- Learned-BD scatter and descriptor/PPA correlation plots.

## Acceptance Bar

The method is a final candidate only if it:

- covers every classic-covered problem,
- has valid-PPA rate drop <= 5 percentage points versus classic,
- avoids scalar fitness collapse,
- improves strict HV or `ANHV@1.5` by at least 5 percent paired versus
  classic, or gives a documented comparable PPA-quality gain,
- improves Pareto-front unique netlists by at least 20 percent,
- holds at seed-3 before any seed-5 final run.

If it improves diversity while losing too much PPA or repair robustness,
keep it as an ablation rather than the selected journal method.
