# DeepGate Pooled Descriptor Replay

This package pools full-transition and cone-level DeepGate embeddings into one
candidate-level descriptor table, then replays basic descriptor-cell and
area-power Pareto structure without any live LLM calls.

## Decision

Pooled DeepGate descriptors pass the offline replay gate. All `96` sampled
candidates across all `8/8` preliminary screen problems receive descriptors,
with nonzero area-power Pareto cells in every problem. This authorizes a
bounded live smoke design, not final RTLLM spend.

## Artifacts

| Path | Purpose |
| --- | --- |
| `preregistration.md` | Frozen replay question and gate. |
| `commands/run_deepgate_pooled_descriptor_replay.md` | Reproducible command. |
| `tools/run_deepgate_pooled_descriptor_replay.py` | Candidate pooling and replay script. |
| `tables/deepgate_pooled_candidates.csv` | Candidate-level descriptor, PPA, and cell table. |
| `tables/deepgate_pooled_problem_summary.csv` | Problem-level cell/Pareto replay summary. |
| `tables/deepgate_pooled_summary.json` | Aggregate machine-readable summary. |
| `figures/deepgate_pooled_descriptor_replay.png` | Descriptor PCA and cell replay figure. |
| `figures/visual_inspection_notes.md` | Manual figure inspection notes. |
| `results_report.md` | Result interpretation and next decision. |
