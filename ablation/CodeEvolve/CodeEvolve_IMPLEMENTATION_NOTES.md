# CodeEvolve Implementation Notes

## Purpose

This document cross-walks the vendored `science-codeevolve` project and paper
against the REvolution integration implemented on this branch.

## Source Material

- Paper markdown: `/workspace/ablation/CodeEvolve/CodeEvolve_2510.14150v3.md`
- Paper PDF: `/workspace/ablation/CodeEvolve/CodeEvolve_2510.14150v3.pdf`
- Vendored repo: `/workspace/ablation/CodeEvolve/science-codeevolve`

## Repo-Fit Analysis

- Upstream CodeEvolve is a general code-evolution framework, not an RTL-specific
  runner.
- Its native runtime expects a problem directory with an evaluator script and an
  initial source tree, which does not match REvolution's benchmark layout.
- Its declared Python requirement is `>=3.13.5`, while this repository targets
  Python 3.11.
- The strongest reusable asset is the algorithm design, not the runtime shell.

## Phase-1 Preserved Mechanics

- Islands-based search
- Separate solution and prompt populations
- Exploration vs exploitation split
- Inspiration-based crossover
- Meta-prompting during exploration
- Ancestor-depth exploitation
- Migration topology, interval, and rate
- Optional exploration scheduler
- Higher-is-better fitness orientation

## Phase-1 Deferred or Adapted

- Direct CLI/process orchestration
- Checkpointing
- MAP-Elites
- Embeddings
- Multi-file codebase editing
- Upstream benchmark packaging and sandbox-copy workflow

## Implementation Notes

- The REvolution backend will expose a native `codeevolve` backend through
  `scripts/run_backend.py`.
- The backend will emit the same summary/report schema consumed by the existing
  comparison and archive tools.
- Phase-1 task handling will be performed through a local RTL adapter that maps
  REvolution benchmark problems into CodeEvolve-style prompt/evaluation state.
