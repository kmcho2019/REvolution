# Current Encoder Assessment

## Short Answer

The best actual pretrained encoder signal to date is Qwen3 canonical RTL, but
its first live screen lost to classic. The best encoder-like signal is still
T36/T11 bounded front graph, but the exact live conversion in T58 lost. The
best screened QD arm right now is the T80 MasterRTL structural mix, and it also
does not clear the full-RTLLM promotion gate.

## Candidate Ranking

| Rank | Candidate | Type | Assessment |
| --- | --- | --- | --- |
| 1 | Qwen3 canonical RTL | Actual pretrained text/code embedding | Model-valid and live-screened. Preserved `8/8` problem coverage, but mean HV was `0.1108` versus classic `0.1406`, so it is not promoted as-is. |
| 2 | T36/T11 bounded front graph | Encoder-like graph representation | Strongest replay signal: about `+4.04%` HV versus lexical and more front hits. Exact T58 live conversion lost HV/front breadth, so it needs a successor design. |
| 3 | T51-style SR front slot | Custom BD/archive coupling | Most practical custom-BD live base. It preserves conservative archive pressure and is already commandable. |
| 4 | T80 MasterRTL structural mix | RTL-native custom BD | Best current methodology story and strongest screened QD arm by mean HV, but still trails classic. |
| 5 | DeepGate2 transition-AIG bridge | Pretrained netlist encoder candidate | Official pretrained model embeds transition AIGs with nonconstant signal on `60` rows across `5/8` screen problems, but large designs and same-problem clustering still block promotion. |
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

The current screen rejected the tested descriptor stories before the full RTLLM
spend.

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
pretrained path works on shipped examples. The newer generated bridge probe
improves the old collapsed result: it embeds `24` bounded generated AIG rows
with pairwise cosine mean `0.9318` and all four screen backends represented.
The remaining blocker is coverage, because only `Prob116_m2014_q3` and
`Prob135_m2014_q6b` embed under the current latch-free and `400`-variable
policy. The corrected transition bridge improves coverage to five problems:
`Prob024_fsm`, `Prob041_traffic_light`, `Prob049_signal_generator`,
`Prob116_m2014_q3`, and `Prob135_m2014_q6b`. It still misses
`Prob015_multi_pipe_8bit`, `Prob045_alu`, and `Prob153_gshare` under the
practical cap, and nearest neighbors are `83.33%` same-problem. MasterRTL
pretrained artifacts also load, but T77 blocks the generated-candidate
Area-head leaf BD.

## Qwen Generated-Candidate Probe

The `20260625_qwen_live_screen_probe` package embeds the completed live-screen
candidate corpus with Qwen3 canonical RTL. It confirms the model is usable on
actual generated RTL: `540` valid-PPA rows produce `424` unique canonical RTL
hashes and a `540 x 1024` embedding table.

The warning is that Qwen is still dominated by problem structure:
nearest-neighbor matches are `99.26%` same-problem, `53.15%` same-backend, and
`26.67%` duplicate canonical RTL. This is not a full spend-ready result.

The live runtime hook passed a bounded smoke and then completed the matched
`qwen_canonical_rtl_pca3_8x5` screen. It preserved `8/8` problem coverage and
produced `192` valid-PPA files, but mean HV was `0.1108` versus classic
`0.1406`, with weaker Pareto breadth (`1.62` versus `3.25` mean front points).

Decision: Qwen canonical RTL is a real pretrained-encoder BD implementation,
but it should not be promoted to the final full-RTLLM comparison as-is.
