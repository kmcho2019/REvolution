# Synthesis-Response Kernel PCA Decision

Decision: reject as the selected final method; keep as the first
projected synthesis-response baseline.

Current status: seed-1 development evaluated for `sr_raw_pca_qd`.
`sr_random_relu_pca_qd` is artifact-frozen and ready for its seed-1
development run.

## Evidence

- Seed-1 development Gate 0: pass.
- Covered problems: 6.
- Missing classic-covered problems: 0.
- Valid PPA: 209/288, equal to classic REvolution.
- Valid-PPA rate delta versus classic: 0 percentage points.
- Mean best fitness: 0.2404 versus 0.2671 for classic.
- Fitness W/T/L versus classic: 0/5/1.
- Mean hypervolume: 0.1208 versus 0.1245 for classic.
- Hypervolume W/T/L versus classic: 1/4/1.
- Unique canonical netlists: 74 versus 70 for classic.
- Unique motif signatures: 48 versus 43 for classic.
- PPA-front unique netlists: 14 versus 12 for classic.
- Common-audit occupied cells: 12, equal to classic.
- Common-audit QD score: 1.9663 versus 2.3163 for classic.
- Method report: `seed1_artifact_report.md`.
- Coverage artifact:
  `../../auto_bd_gate0_coverage_seed1_sr_raw_pca_qd.json`.
- Centralized report: `../../auto_bd_seed1_centralized_report.md`.

## Remaining Evidence For Later Projected Variants

- Strict zero-reference HV and `ANHV@1.5`.
- Learned-BD scatter and descriptor/PPA correlation plots.
- Seed-3 screening only for variants that clear seed-1 gates.

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

## Rationale

The method passes the hard coverage gate and preserves repair/PPA
robustness on the seed-1 development subset. It also provides modest
structural diversity uplift over classic REvolution.

It is not strong enough to promote as the selected method. The PPA-front
unique-netlist uplift is about 16.7 percent, below the 20 percent target,
and the PPA/HV metrics do not improve over classic. The result is useful
as a clean fixed-vector projected baseline and motivates trying the
planned random-kernel expansion before PCA.

## Next Use

Run `sr_random_relu_pca_qd` next. Its frozen fitting artifact uses the
same leakage controls: no PPA, no fitness, no hypervolume, no reference
PPA, no visible testbench pass percentage, and no problem ID as
descriptor inputs.
