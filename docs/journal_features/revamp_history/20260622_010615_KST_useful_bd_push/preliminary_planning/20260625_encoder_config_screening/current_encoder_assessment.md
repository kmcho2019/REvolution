# Current Encoder Assessment

## Short Answer

The best actual pretrained encoder signal to date is T33 Qwen3 canonical RTL,
but it is still replay-only. The best encoder-like signal is T36/T11 bounded
front graph, but the exact live conversion in T58 lost. The best spend-ready
live custom candidates right now are the T51-style synthesis-response front
slot and the T80 MasterRTL structural mix.

## Candidate Ranking

| Rank | Candidate | Type | Assessment |
| --- | --- | --- | --- |
| 1 | T33 Qwen3 canonical RTL | Actual pretrained text/code embedding | Best strict pretrained signal: replay HV was about `+2.63%` versus lexical. Not live-proven and still has same-problem collapse risk. |
| 2 | T36/T11 bounded front graph | Encoder-like graph representation | Strongest replay signal: about `+4.04%` HV versus lexical and more front hits. Exact T58 live conversion lost HV/front breadth, so it needs a successor design. |
| 3 | T51-style SR front slot | Custom BD/archive coupling | Most practical custom-BD live base. It preserves conservative archive pressure and is already commandable. |
| 4 | T80 MasterRTL structural mix | RTL-native custom BD | Best current methodology story. The descriptor gate is non-collapsed, but no live PPA comparison has landed yet. |
| 5 | DeepGate3 verified netlist | Pretrained netlist encoder candidate | Checkpoints exist and load, but the prior probe had pairwise cosine mean `0.999923`, so it is not spend-ready. |
| 6 | AURORA-style raw implementation features | Learned auto-BD lane | Raw features had replay signal, but compressed bottlenecks lost and no live profile is frozen. |
| 7 | MasterRTL pretrained prediction/leaf heads | Pretrained model candidate | Artifacts exist, but the direct Area-head leaf lane collapsed on generated candidates. Keep as future bridge work, not a live arm today. |

## Colleague-Facing Interpretation

Classic REvolution is a strong direct optimizer because it spends nearly all
budget on the actual PPA reward. QD only looks useful if the descriptor
preserves implementation families that remain PPA-competitive. Generic
syntactic spread, opaque embeddings, and archive occupancy alone are not
enough.

The strongest claim we can test next is therefore:

> RTL diversity may help PPA evolution when the archive preserves
> PPA-competitive implementation families, especially with source-aligned or
> synthesis-response descriptors and conservative exploitation pressure.

The next screen is designed to reject weak descriptor stories before the full
RTLLM spend.

## Post-Screen Update

The completed `8x5` live screen rejected both spend-ready QD arms as full-RTLLM
candidates. Classic REvolution won the headline Pareto comparison with mean HV
`0.1406`; SR front-slot QD reached `0.1141`; MasterRTL structural-mix QD
reached `0.1218`.

The result does not invalidate all encoder/BD research, but it does mean the
next full-RTLLM run should not use either of these two QD configs as-is.
Pretrained encoder work should first close the validation gap described in
`pretrained_encoder_validation.md`.

## Post-Bridge Update

The follow-up bridge validation moves Qwen3 canonical RTL to the front of the
pretrained queue. The actual `Qwen/Qwen3-Embedding-0.6B` model loads in the
isolated Qwen env and produces nonconstant toy RTL embeddings, while T33 still
provides the strongest true-pretrained replay signal.

DeepGate should not be treated as invalid: the official python-deepgate
pretrained path works on shipped examples. The blocker is our generated RTL to
AIG/embedding bridge, which previously produced only three usable embeddings
with near-identical pairwise cosine. MasterRTL pretrained artifacts also load,
but T77 blocks the generated-candidate Area-head leaf BD.

Next action: implement `qd_qwen3_canonical_rtl_8x5` with explicit
preprocessing, embedding cache keys, descriptor projection, and collapse
diagnostics before spending any full RTLLM budget.
