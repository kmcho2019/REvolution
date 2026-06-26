# Sequential DeepSeq BD Results Report

Status: `T0 retrospective_sequential_proxy_not_promoted`.

## Answer

The current branch has enough measured evidence to close the original
DeepSeq-style sequential proxy scaffold, but not enough to promote it.

Sequential/state-aware descriptors help as methodology and diagnostics:

- T63 shows a fused RTL-native state/pipeline descriptor can run live,
  preserve valid-PPA yield, and improve best score.
- T67 shows source-preserving seeded thought-code generation increases
  valid-PPA yield.
- T72 shows source-aligned MasterRTL/RTLTimer cells can preserve all
  classic-covered designs and come near classic on one hard/tuning screen.
- T73/T75 show source-aligned shape-density axes improve occupancy and
  valid-PPA yield relative to earlier RTL-native cells.

They do not establish a promoted QD method. Classic still wins the primary
HV/front evidence, and T67 drops `Prob153_gshare`.

## Evidence Matrix

The detailed evidence table is `tables/t08_sequential_proxy_evidence.csv`.

| Source | Useful Signal | Blocking Signal |
| --- | --- | --- |
| T63 | Same valid-PPA count as classic and `+18%` best-score relative delta. | Mean HV `0.089551` versus classic `0.092601`; front points `25` versus `30`. |
| T67 | Valid-PPA count `304` versus classic `257`; HV-AUC is slightly positive. | `Prob153_gshare` is candidate-missing; front points `18` versus classic `30`. |
| T72 | Preserves `13/13` covered designs and trails classic mean HV by about `0.65%`. | Pareto points `1.31` versus classic `2.31`; reference-beating candidates `2.85` versus `3.54`. |
| T73 | Valid-PPA count `294` versus classic `257`; shape-density reduces T72 cell collapse. | Mean HV `0.0890223082` versus classic `0.0926007600`. |
| T75 | Preserves `13/13` designs and improves over T73/T74 mean HV. | Mean HV `0.0899974770` versus classic `0.0926007600`; Pareto points `1.62` versus `2.31`. |

## Decision

T08 is not promoted. The evidence supports a narrower conclusion:

> Sequential/state-aware RTL descriptors are useful as interpretable
> implementation-family diagnostics and can improve yield or near-classic
> coverage, but the current state/pipeline proxy variants do not create enough
> PPA-front material to beat classic REvolution.

Do not spend a fresh live run on exact DeepSeq-style proxy axes. Reopen this
lane only with a true validated DeepSeq/DeepSeq2 implementation, a trained
state-aware encoder objective, or a front-rescue/source-selection mechanism
that proves sequential memory contributes quality-productive children.
