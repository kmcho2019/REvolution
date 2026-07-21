# H10 Related-Work Boundary

Status: `REVIEWED`; primary sources and H10's narrow delta froze on 2026-07-21.

## Closest Work

| Work | Established mechanism | Boundary for H10 |
| --- | --- | --- |
| [REvolution](https://arxiv.org/abs/2510.21407v1) | Evolves `(Thought, Code, Feedback)` individuals with dual Fail/Success populations and adaptive prompt strategies. | H10 changes only which already-computed state is retained in classic parent memory. |
| [AutoChip](https://arxiv.org/abs/2311.04887v2) | Feeds compiler and simulator outputs into iterative HDL repair. | H10 cannot claim tool-grounded RTL feedback as new. |
| [RTLFixer](https://arxiv.org/abs/2311.16543) | Uses RAG, ReAct, and compiler feedback for interactive RTL syntax repair. | H10 adds no repair agent, retrieval, or tool loop. |
| [Reflexion](https://arxiv.org/abs/2303.11366) | Retains linguistic reflections over scalar or textual environment signals in episodic memory. | H10 cannot claim textual environment memory as a general novelty. |
| [COEVO](https://arxiv.org/abs/2604.15001v2) | Uses fine-grained correctness, diagnostic feedback, synthesis diagnoses, category-specific rewards, and Pareto optimization. | H10 adds no continuous score, reward category, adaptive gate, or Pareto behavior. |
| [Verilog-Evolve](https://arxiv.org/abs/2605.26498v1) | Uses executable simulation and synthesis feedback during versioned RTL refinement and skill evolution. | H10 adds no version promotion or skill memory. |

## Exact Delta

H10 preserves one authoritative terminal verifier label alongside the unchanged
classic critic analysis for failed REvolution individuals. It retains critic
calls, dual pools, EoH operators, UCB, scalar fitness, and whole-output
generation. The contribution is a controlled REvolution reliability ablation,
not a new feedback-generation framework.

The repository's retired unified single-thought operator already emits a coarse
`succeeded` or `failed` label while deleting classic feedback and replacing the
six EoH intents. H10 does not reuse that operator. Its question is whether typed
terminal state adds value on the accepted classic substrate.

## Claim Boundary

Allowed if the prospective gates pass:

> Retaining REvolution's terminal failure type alongside unchanged critic
> analysis broadens fail-origin valid-PPA repair under a fixed search budget.

Forbidden:

- EDA-tool feedback, executable feedback, reflection, or verifier memory is new;
- score disagreement proves the consumed critic analysis is wrong;
- the one-line prefix corrects the critic or guarantees model compliance;
- H10 alone supplies a primary TCAD algorithmic contribution.
