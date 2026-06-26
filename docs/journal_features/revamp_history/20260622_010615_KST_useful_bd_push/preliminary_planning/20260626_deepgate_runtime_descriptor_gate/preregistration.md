# T92 DeepGate Runtime Descriptor Preregistration

## Question

Can the official DeepGate transition/cone bridge be made available as a real
QD runtime descriptor instead of a report-only replay?

## Descriptor

Use the frozen T91 pooled candidate embeddings:

```text
deepgate_pool_pc0
deepgate_pool_pc1
deepgate_pool_pc2
```

The axes are PCA components over normalized candidate-level vectors. Candidates
with bounded transition AIGs use the full transition embedding. Larger
transition AIGs use the normalized mean of up to three bounded output-cone
embeddings. The descriptor does not use PPA, reference PPA, pass rate, problem
identity, or archive outcome.

## Gate

This gate only verifies runtime readiness:

- frozen projection artifact exists and has the expected shape;
- descriptor profile resolves through normal QD descriptor APIs;
- unit tests cover both `QDEngine` and worker `CandidateEvaluator` extraction;
- isolated DeepGate smoke emits finite projected values.

Promotion to a live QD candidate still requires matched HV data.
