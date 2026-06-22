# T34 Qwen PCA-Residual BD Results Report

Status: completed replay diagnostic with PCA-residual Qwen descriptors,
collapse diagnostics, direct PPA-front figures, and regeneration tables.

Tier decision: `T0 diagnostic`. T34 preserves the useful T33 RTL-view HV
signal but does not solve the nuisance-collapse problem behind that signal.

## Purpose

T34 follows T33's mixed result. It tests whether removing dominant PCA
components from Qwen embedding views can keep the RTL-view hypervolume signal
while reducing same-problem/corpus collapse.

## Replay Summary

T34 replays 15 PCA-residual Qwen variants plus T33 base views and common
controls on the same 768-candidate surface as T33. PCA residuals are fitted
from embedding coordinates only; PPA and validity fields are used only after
selection for evaluation.

Best residuals by selected hypervolume:

| Representation | HV | Delta vs Lexical | Front Hits | Unique PPA | Same Problem |
| --- | ---: | ---: | ---: | ---: | ---: |
| `t34_canonical_rtl_pc16_residual` | 3.799167 | +0.026295 | 122 | 184 | 0.895833 |
| `t34_canonical_rtl_pc1_residual` | 3.799167 | +0.026295 | 121 | 184 | 0.907552 |
| `t34_canonical_rtl_pc4_residual` | 3.799167 | +0.026295 | 121 | 184 | 0.908854 |
| `t34_canonical_rtl_pc8_residual` | 3.799167 | +0.026295 | 121 | 184 | 0.904948 |
| `t34_identifier_role_rtl_pc16_residual` | 3.799167 | +0.026295 | 120 | 185 | 0.911458 |
| `t34_identifier_role_rtl_pc1_residual` | 3.799167 | +0.026295 | 120 | 185 | 0.898438 |

Best residuals by unique direct area-power front hits:

| Representation | HV | Front Hits | Unique PPA | Same Problem |
| --- | ---: | ---: | ---: | ---: |
| `t34_commentless_rtl_pc1_residual` | 3.772692 | 123 | 180 | 0.951823 |
| `t34_commentless_rtl_pc4_residual` | 3.772692 | 123 | 180 | 0.947917 |
| `t34_canonical_rtl_pc16_residual` | 3.799167 | 122 | 184 | 0.895833 |
| `t34_canonical_rtl_pc1_residual` | 3.799167 | 121 | 184 | 0.907552 |
| `t34_rtl_yosys_concat_pc8_residual` | 3.735272 | 121 | 187 | 0.917969 |

Best residuals by same-problem collapse:

| Representation | HV | Delta vs Lexical | Front Hits | Same Problem | Same Corpus |
| --- | ---: | ---: | ---: | ---: | ---: |
| `t34_summary_plus_netlist_pc4_residual` | 3.570861 | -0.035379 | 120 | 0.805990 | 0.904948 |
| `t34_summary_plus_netlist_pc1_residual` | 3.686043 | -0.004264 | 121 | 0.812500 | 0.903646 |
| `t34_canonical_rtl_pc16_residual` | 3.799167 | +0.026295 | 122 | 0.895833 | 0.927083 |

## Interpretation

- PCA residualization does not create a new useful descriptor. The best
  residual HV ties T33 canonical RTL at `3.799167`, or `+2.63%` versus
  lexical, but it does not beat the T33 base view.
- The highest-HV residuals remain high-collapse: same-problem nearest-neighbor
  fractions stay around `0.895833` to `0.911458`.
- The lower-collapse residuals are netlist-derived. They improve
  same-problem fraction modestly versus `summary_plus_netlist`, but they remain
  below lexical on selected HV.
- Direct PPA-front accounting is also not decisive. The best residual front
  hit count is `123`, matching T33 commentless RTL and only one unique hit
  above lexical's `122`.

## Conclusion

T34 answers the T33 follow-up: simple label-free PCA residuals are not enough.
They preserve the RTL embedding signal but do not align HV, direct PPA-front
coverage, and nuisance-collapse reduction in one descriptor.

Next action: do not add more whole-design Qwen projection variants unless they
change the training signal, for example a contrastive anti-problem/corpus head
or a graph/multimodal encoder. The L4 lane should now move toward a graph
encoder package or a clearly different Qwen fine-tuning objective.

## Outputs

- `tables/t34_replay_rows.csv`
- `tables/t34_replay_aggregate.csv`
- `tables/t34_selected_candidates.csv`
- `tables/t34_ppa_front_metrics.csv`
- `tables/t34_collapse_metrics.csv`
- `tables/t34_vs_controls.csv`
- `figures/t34_raw_area_power_pareto_front.png`
- `figures/t34_hypervolume_by_projection.png`
- `figures/t34_collapse_vs_hypervolume.png`
