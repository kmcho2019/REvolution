# Current Selection Status

Status: no QD configuration is currently promoted for the final full-RTLLM
comparison.

## Answer

The preliminary plan is not finished. It has produced hard negative screening
data, including a three-seed replication of the best diagnostic arm, but it has
not identified a QD/MAP-Elites configuration that is strong enough to spend the
full RTLLM budget on as a positive candidate.

## Best Hard Result So Far

The closest QD arm from the frozen eight-design screen was
`masterrtl_aux_archive_high_exploit_8x5`. It reached seed `1001` mean HV
`0.1339` versus classic `0.1406`, but the result did not replicate.

| Metric | Classic | Aux archive | Read |
| --- | ---: | ---: | --- |
| Three-seed mean HV | `0.1442` | `0.1261` | QD loses by `-12.51%` |
| Seed-level HV wins | `3` | `0` | QD loses every seed |
| No-Prob135 relative HV delta | - | - | QD loses by `-18.25%` |

Decision: fixed high-exploit auxiliary archive is diagnostic negative and not
promoted.

## Encoder And Descriptor Read

| Lane | Current Status | Decision |
| --- | --- | --- |
| Qwen3 canonical RTL | Real pretrained live hook; matched screen completed at `8x5`. | Not promoted: mean HV `0.1108` versus classic `0.1406`. |
| DeepGate transition AIG | Official pretrained bridge embeds nonconstant generated candidates across `5/8` screen problems. | Not spend-ready: large designs still exceed the practical bridge cap. |
| MasterRTL pretrained Area leaf | Pretrained model artifact loads, but generated candidates collapse to one Area prediction and one leaf row. | Retire direct Area-head leaves unless retrained or replaced. |
| MasterRTL raw structural mix | Credible RTL-native descriptor lane. | Needs stronger coupling; fixed auxiliary archive failed replication. |
| T11/T36 graph-like lane | Replay signal exists; live top-4/front-slot successor ran. | Not promoted: live `8x5` mean HV `0.1208` versus classic `0.1406`. |

## Next Gate

Do not run another fixed MasterRTL geometry tweak. The active next candidate is
`20260626_aux_archive_adaptive_sparse_front_probe/`, which uses the existing
`sparse_front_triggered_nsga2` selector to lower champion pressure only when
local archive fronts are thin. If that also loses on the frozen screen, the
current milestone should report a rigorous negative result for the tested QD
families rather than escalating to full RTLLM spend.
