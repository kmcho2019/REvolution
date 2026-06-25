# DeepGate Generated Bridge Probe

## Verdict

The current plan is still not finished. Qwen3 has now been live-screened and
rejected as-is, so this package reopens the DeepGate pretrained-netlist lane at
the bridge level.

DeepGate is partially unblocked but not spend-ready. The official pretrained
`python-deepgate` model can embed generated RTL-derived AIGs without the
near-total collapse seen in the earlier three-sample probe, but the current
bounded bridge only covers two of the eight screening problems.

## Key Result

| Metric | Value |
| --- | ---: |
| Generated valid-PPA candidates sampled | 96 |
| AIG exports | 36 |
| Embedded bounded AIGs | 24 |
| Embedded problems | 2 |
| Embedded backends | 4 |
| Pairwise cosine mean | 0.9315 |
| Pairwise cosine min | 0.7700 |
| Same-problem nearest ratio | 0.6667 |
| Same-backend nearest ratio | 0.0417 |

## Decision

Do not launch a live DeepGate QD arm yet. The pretrained model path is real and
the generated embeddings are no longer trivially constant, but coverage is too
small for a fair RTLLM comparison. The next bridge work should handle
sequential designs and large AIGs before any expensive live budget.

## Contents

| Path | Purpose |
| --- | --- |
| `deepgate_generated_bridge_report.md` | Main result and decision report. |
| `commands/run_deepgate_generated_bridge_probe.md` | Exact command and environment. |
| `tables/deepgate_bridge_summary.json` | Machine-readable aggregate metrics. |
| `tables/deepgate_bridge_rows.csv` | Candidate-level export, skip, and embedding statuses. |
| `figures/deepgate_embedding_pca.png` | PCA view of the 24 generated-candidate embeddings. |
| `figures/visual_inspection_notes.md` | Manual figure inspection notes. |
| `tools/run_deepgate_generated_bridge_probe.py` | Reproducible probe script. |
