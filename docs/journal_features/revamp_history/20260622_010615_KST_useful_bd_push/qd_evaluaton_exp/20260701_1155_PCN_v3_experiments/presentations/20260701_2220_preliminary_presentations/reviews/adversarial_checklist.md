# Adversarial Review Checklist

Sub-agents are intentionally not used in this side conversation. This checklist
is the manual adversarial review gate for the preliminary deck.

## Claim Discipline

- [x] 20260629 is framed as negative evidence for the tested methods and
  operator setup, not proof that diversity is useless.
- [x] 20260630 PCN is framed as a one-seed positive signal, not final
  statistical proof.
- [x] 20260701 smoke is framed as a C-F confound check, not final validation.
- [x] No 20260701 full-run partial results are used in headline slides.
- [x] Missing-reference RTLLM handling is mentioned in the appendix.

## Numeric Evidence

- [x] 20260629 classic mean HV `0.1002` and best-QD mean HV `0.0735` come from
  copied CSV/report artifacts.
- [x] 20260630 PCN mean HV `0.1031`, classic `0.0997`, and retention `103.4%`
  come from copied CSV/report artifacts.
- [x] 20260630 PCN memory counters come from
  `20260630_pcn_memory_mechanism_summary.csv`.
- [x] 20260701 smoke operator counts come from
  `20260701_rtllm_smoke_operator_contract.csv`.

## Anticipated Colleague Questions

| Question | Deck answer |
| --- | --- |
| Is QD itself bad? | No. The evidence says naive descriptor/archive replacement was bad under this budget. |
| Was the 20260629 failure caused by descriptors or operators? | Both are plausible; the operator mismatch was a major discovered confound. |
| Why trust PCN? | PCN preserves classic exploitation and has mechanism counters showing memory-refine was active. |
| Is PCN statistically proven? | No. The five-seed C-F ablation is the required next gate. |
| Is C-F removal the real cause? | Unknown. The 20260701 smoke validates the ablation machinery; full results are pending. |
| Are pretrained encoders useless? | No. Qwen improved strongly after operator correction, but did not beat classic. |
| What do PCN, RF, leaf ID, and canonical mean? | The appendix glossary now defines each term directly. |
| What are MasterRTL/RTLTimer-inspired features? | The appendix lists each feature family and avoids overclaiming pretrained reproduction. |

## Visual Review

- [x] Main deck uses figures or tables on nearly every slide.
- [x] Concept diagrams are labeled as conceptual.
- [x] Quantitative plots are generated from copied raw CSVs.
- [x] Original source figures are retained for sanity checks.
- [x] Optional imagegen methodology figures have caption files with prompts,
  usage limits, and manual counterparts.
