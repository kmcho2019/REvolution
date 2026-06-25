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
