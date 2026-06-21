# T24 Figures

Generated complete live-matrix figures:

- `live_completed_qd_vs_classic.png`: completed QD-arm best-score delta,
  synthesis-PPA-rate delta, and global Pareto member comparison for manual BD,
  random, SR-RFF, SR ReLU, and SR raw.
- `live_sr_family_vs_classic.png`: completed SR-family best-score delta,
  synthesis-PPA-rate delta, and global Pareto member comparison for SR-RFF,
  SR ReLU, and SR raw.
- `live_sr_rff_vs_classic.png`: classic-vs-SR-RFF best-score delta,
  synthesis-PPA-rate delta, and SR-RFF front material for the first completed
  T24 live arm pair.

Future larger-screen or holdout reports should add:

- anytime global PPA hypervolume and HV AUC;
- validity funnel by arm;
- duplicate accounting by arm;
- local-Pareto cell/front-size heatmap;
- per-problem delta plot for classic, manual BD, random BD, SR raw, SR ReLU,
  and SR-RFF across a larger subset.

Direct PPA-front scatter plots for the completed T24 live arms are now in the
cross-method audit:
`../../../visualization_audits/20260621_direct_ppa_fronts/`.

Every figure must be manually inspected before T24 receives a tier decision.
