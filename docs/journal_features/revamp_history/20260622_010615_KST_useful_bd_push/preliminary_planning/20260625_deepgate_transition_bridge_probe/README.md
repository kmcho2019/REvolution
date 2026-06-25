# DeepGate Transition Bridge Probe

## Verdict

Transition abstraction is a real DeepGate bridge improvement, but it is still
not ready for live RTLLM spending.

The transform converts latch-bearing AIGs into combinational transition logic
by treating register state as extra inputs and next-state functions as extra
outputs. After canonical AIG renumbering and constant-literal repair, the
official `python-deepgate` parser embeds `60` generated rows across `5/8`
screen problems.

The remaining blocker is coverage and scale: `Prob015_multi_pipe_8bit`,
`Prob045_alu`, and `Prob153_gshare` exceed the practical `700`-variable cap.
`Prob015` can parse at a higher cap, but a single candidate took about
`39.8s`, which is too slow for an in-loop live descriptor without cone
extraction or caching.

## Contents

| Path | Purpose |
| --- | --- |
| `deepgate_transition_bridge_report.md` | Main result and decision. |
| `commands/run_deepgate_transition_bridge_probe.md` | Commands attempted. |
| `tables/deepgate_bridge_summary.json` | Aggregate transition embedding metrics. |
| `tables/deepgate_bridge_rows.csv` | Candidate-level export, skip, and embedding statuses. |
| `tables/transition_header_smoke.csv` | Header-level evidence for the state abstraction. |
| `tables/large_transition_parse_smoke.csv` | Large-design parser smoke for `Prob015`. |
| `figures/deepgate_embedding_pca.png` | PCA view of the transition embeddings. |
| `figures/visual_inspection_notes.md` | Manual figure inspection notes. |
| `logs/transition_smoke_log.md` | Manual run log and corrected parser rationale. |

## Decision

The next DeepGate attempt should either add cone-level extraction for large
designs or run a tiny live descriptor smoke only on a subset where transition
AIGs are known to be bounded. Do not run full RTLLM with this descriptor yet.
