# T89 DeepGate Signal Vs AIG Stats Preregistration

## Question

Does the verified official DeepGate transition bridge produce useful
pretrained-encoder signal beyond simple AIG size/count statistics?

## Inputs

- Rows:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe/tables/deepgate_bridge_rows.csv`
- Embeddings:
  `exp/useful_bd_push/deepgate_transition_bridge_probe_20260625_190300_UTC/deepgate_embeddings.npy`

The rows come from the transition bridge that embedded 60 generated valid-PPA
candidates across 5/8 preliminary screen problems with the official
`python-deepgate` pretrained model.

## Method

Compare three representations on the same 60 embedded rows:

1. `deepgate`: pooled official DeepGate embeddings.
2. `aig_stats`: standardized `log1p` AIG and embedded-graph counts.
3. `deepgate_residual`: DeepGate vectors after linear residualization against
   the AIG statistics.

The gate measures nearest-neighbor structure and same-problem pairwise cosine
separation for each representation.

## Promotion Gate

DeepGate can advance only to a bounded live smoke, not full RTLLM spend, if all
conditions hold:

- the bridge still uses the official pretrained model vectors;
- residual embeddings remain nonconstant after removing AIG statistics;
- DeepGate nearest-neighbor structure is not explainable by AIG statistics
  alone;
- the result report preserves the coverage caveat that only 5/8 screen
  problems embedded under the current cap.

If DeepGate behaves like AIG statistics or residual structure collapses, the
next step must be cone extraction or another bridge fix rather than live spend.
