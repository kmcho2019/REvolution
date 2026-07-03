# Literature And Repo Context

Use the current bundle evidence first. The important external-method lanes are:

- QD/MAP-Elites and illumination algorithms;
- hybrid evolutionary search with exploitation-heavy parent selection;
- novelty search and novelty as a tie-breaker;
- adaptive emitter and restart policies;
- learned behavior descriptors and AURORA-style descriptor learning;
- graph/netlist encoders such as DeepGate-family methods;
- RTL-native feature/model lanes such as MasterRTL and RTLTimer;
- code/text embeddings such as Qwen3 for RTL or normalized netlist text.

Reviewer task:

1. Identify which literature idea best fits the observed failure modes.
2. Say whether the idea should be used as primary search, auxiliary memory,
   restart selection, candidate filtering, descriptor training, or reporting.
3. Specify a small experiment that could be implemented without a broad
   rewrite.

The existing bundle includes local evidence for Qwen3, DeepGate, MasterRTL,
RF leaf IDs, AURORA/raw implementation features, SR/code-thought QD, and
front-guarded QD memory.
