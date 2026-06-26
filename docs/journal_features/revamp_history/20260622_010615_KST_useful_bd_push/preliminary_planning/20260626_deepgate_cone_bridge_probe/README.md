# DeepGate Cone Bridge Probe

This package tests whether bounded output-cone extraction can cover the large
transition AIGs that blocked the previous DeepGate bridge.

## Decision

Cone extraction passes the bridge-coverage gate. Combined with the existing
full-transition embeddings, DeepGate now covers all `8/8` preliminary screen
problems offline. This still is not a live QD result: the next step is a cached
descriptor-table prototype or a bounded live smoke with explicit cone
aggregation.

## Artifacts

| Path | Purpose |
| --- | --- |
| `preregistration.md` | Frozen cone-extraction question and promotion rule. |
| `commands/run_deepgate_cone_bridge_probe.md` | Reproducible command. |
| `tools/run_deepgate_cone_bridge_probe.py` | Cone extraction and embedding script. |
| `tables/deepgate_cone_rows.csv` | Cone-level embedding diagnostics. |
| `tables/deepgate_cone_summary.json` | Aggregate coverage and similarity summary. |
| `figures/deepgate_cone_embedding_pca.png` | Cone embedding PCA and coverage count figure. |
| `figures/visual_inspection_notes.md` | Manual figure inspection notes. |
| `logs/cone_bridge_attempt_notes.md` | Notes on the interrupted largest-cone attempt. |
| `results_report.md` | Result interpretation and next decision. |
