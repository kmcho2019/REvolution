# H9 Related-Work Delta

Status: `RETIRED_REVIEW`; sources checked 2026-07-21.

## Closest RTL Work

| Work | Central mechanism | H9 distinction |
| --- | --- | --- |
| [AlphaEvolve](https://arxiv.org/abs/2506.13131) | LLM-generated deltas are applied to sampled parent programs inside an evolutionary loop; the paper includes a Verilog hardware-optimization case. | Direct collision: H9's global strict-diff toggle is not a new evolutionary representation. |
| [CodeEvolve](https://arxiv.org/abs/2605.04677) | Its published algorithm explicitly branches between diff-based evolution and parsing a full-code rewrite. | Direct collision: whole-versus-diff generation is already an explicit evolutionary-code design choice. |
| [DeltaEvolve](https://arxiv.org/abs/2602.02919) | Stores semantic change summaries and plans as evolutionary memory while retaining full executable parent code. | Different mechanism, but it further crowds broad claims around delta representations in evolutionary coding. |
| [SymRTLO](https://arxiv.org/abs/2504.10369) | RAG optimization rules, AST templates, symbolic FSM reasoning, and fast formal/test verification. | No retrieval, AST, symbolic optimizer, or new verifier; only the mutation representation changes inside classic REvolution. |
| [LongRTL](https://arxiv.org/abs/2606.08944) | AST-similarity partitioning, multimodal RAG, optimization agents, and logic-aware reconstruction for long RTL. | No partition/reconstruction or agent system; the selected parent remains the only edit context. |
| [Veri-Sure](https://arxiv.org/abs/2601.19747) | Design contracts, dependency slicing, localized repair, temporal tracing, and formal verification. | No contract, slice, repair policy, or formal claim; exact patches are applied to every EoH mutation, including PPA exploration. |
| [Dr. RTL](https://arxiv.org/abs/2604.14989) | Critical-path agents, parallel rewriting, tool feedback, and learned reusable optimization skills. | No timing agent or skill library; UCB and the existing EoH intents remain unchanged. |
| [POET](https://arxiv.org/abs/2603.19333) | Differential-test generation plus Pareto/power-first survivor selection. | No test generation or selection/objective change. |
| [COEVO](https://arxiv.org/abs/2604.15001) | Continuous correctness, annealed gate, and four-dimensional Pareto co-evolution. | Binary verification, scalar fitness, and classic dual pools remain unchanged. |

## Reviewed Delta

H9 does not claim novelty for textual patches. It asks a narrower unanswered
question inside the conference method:

> Does replacing whole-output EoH mutation with strict parent-relative RTL
> deltas improve fixed-budget REvolution search without changing its operators,
> population semantics, adaptation, selection, objective, or evaluator?

The classic-only breadth association supplied a reason to ask the question,
but the all-offspring treatment was broader than the supporting stratum and the
mechanism is already established in evolutionary coding. Even a positive run
would support only a REvolution configuration ablation. That does not satisfy
this program's nonzero novelty requirement for a live candidate.

A role-conditioned policy could remain distinct: whole-output generation for
failed-parent repair and delta generation for successful-parent refinement.
The current evidence motivates that split, but it is not H9 as reviewed and it
has no accepted clean implementation boundary. It requires a new card rather
than a post-review rescue.

## Excluded Claims

- Patching or localized RTL rewriting is new.
- Exact text matching guarantees functional preservation.
- Smaller edits are always better.
- The approach scales to industrial multi-file RTL.
- A validity-yield or token benefit can substitute for final-HV evidence.
