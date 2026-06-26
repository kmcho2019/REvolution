# T08 Sequential DeepSeq BD

Status: `T0 retrospective_sequential_proxy_not_promoted`.

T08 is closed as a conservative retrospective package over measured
sequential/state-aware RTL-native runs. It does not claim a true pretrained
DeepSeq or DeepSeq2 implementation. The evidence comes from source-aligned
state/pipeline, MasterRTL, and RTLTimer-style descriptor runs that test the
same core question: whether sequential state, pipeline, and feedback structure
forms useful behavior descriptors for RTL PPA search.

## Decision

Sequential/state-aware descriptors are credible and useful diagnostic axes,
but exact state/pipeline proxy descriptors have not beaten classic REvolution
on the primary PPA-front metrics.

Useful signals:

- T63 preserves classic valid-PPA yield and improves best score while adding
  front material relative to T51 on RTLLM.
- T67 improves total valid-PPA yield by `+47` candidates versus classic.
- T72 preserves `13/13` classic-covered designs and comes within about
  `0.65%` mean HV of classic.
- T73 and T75 show that source-aligned shape-density cells improve occupancy
  and valid-PPA yield.

Blocking signals:

- Classic still wins mean HV, HV-AUC, and front breadth for T63.
- T67 loses `Prob153_gshare`, where classic has valid PPA and T67 has none.
- T72 loses HV wins, Pareto points, and reference-beating candidates.
- T75 improves over T73/T74 but still loses classic on mean HV and Pareto
  breadth.

## Follow-Up

Do not spend on exact DeepSeq-style state/pipeline proxy axes as a primary
archive descriptor. Reopen this lane only with one of:

- a real DeepSeq/DeepSeq2 checkout or isolated `uv` environment that validates
  model weights, feature schema, and nonconstant generated-candidate outputs;
- a state-aware descriptor used as a secondary/reporting archive beside a
  stronger quality-preserving generator; or
- a source-level repair or front-rescue mechanism that proves sequential
  memory contributes valid-PPA and global-front children per LLM call.
