# T39 Results Report

Status: bounded live arm completed and packaged.

T39 is the sparse-yield follow-up to T38. It keeps the
`elite_pareto_slot` champion-plus-one-front-slot archive rule and lowers only
the grid-quantile warmup threshold from `8` to `4`.

Run root:
`exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/sparse_warmup_elite_slot_qd/seed_1001/openai_gpt-oss-120b/`.

The live arm used the same three RTLLM problems, population `12`, generations
`3`, seed `1001`, `journal_graph_testability_3d` descriptor, and full
128000-token caps as T38. Runtime completed in 750 seconds. The Pareto archive
validator passed with `failure_count=0` and `max_front_size_seen=2`.

| Problem | Valid PPA | Local front | Global front | Archive members | Best quality |
| --- | ---: | ---: | ---: | ---: | ---: |
| `Prob045_alu` | 18 | 3 | 3 | 13 | 0.402072 |
| `Prob041_traffic_light` | 15 | 3 | 3 | 10 | 0.403821 |
| `Prob015_multi_pipe_8bit` | 11 | 8 | 6 | 10 | 0.222285 |

## T38 Comparison

The specific T38 blocker is fixed. Multi-pipe moved from 7 valid PPA,
3 local/global front points, and 0 active archive members to 11 valid PPA,
8 local-front points, 6 global-front points, and 10 active archive members.

Traffic-light also improved valid PPA from 8 to 15 and best quality from
0.399899 to 0.403821. ALU kept archive/front material but best quality fell
from 0.416377 to 0.402072, so the lower warmup threshold is not a blanket
quality improvement.

## Conclusion

T39 is a positive live ablation lead, not a promoted useful-BD claim. It shows
that the T38 archive gap was caused by the warmup setting rather than by the
one-slot archive rule itself. However, this package did not rerun classic,
manual BD, random BD, or the full local-Pareto control, so it cannot establish
near-classic or better QD utility by itself.

Current tier: `T0 positive_ablation`.

Next step: run a same-budget control matrix or targeted comparison that keeps
T39's sparse warmup and compares against classic, manual/random controls, and
the full local-Pareto cell mode before any `T1` or `T2` claim.
