# RTL Diversity Check Experiment Implementation History

Unbounded journal for `rtl_diversity_check`. Record notable decisions,
commands, outputs, experiments, failed attempts, blockers, commits, and
validation evidence.

## Session Start - 2026-06-21 KST

- Branch: `feat/journal-diversity-check-exp-20260620`.
- Base branch: `feat/journal-auto-bd-exp-20260618`.
- Setup commit already present:
  `d4d5872f3f chore(devcontainer): enable gpu diversity audit setup`.
- Current goal-scaffold output directory:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/`.
- User intent: prepare a future `/goal` contract for testing whether
  implementation diversity matters for RTL/Verilog PPA evolution, using
  historical runs and pre-trained encoders before adding new AutoQD/AURORA
  mechanisms.
- Scope guard: this scaffold does not start the goal and does not implement
  the corpus indexer, embedding extraction, or analysis scripts.

## Branch And Devcontainer Notes

- The devcontainer should expose NVIDIA GPUs to both the main devcontainer
  service and optional `vllm` service.
- Historical REvolution data should be mounted read-only at
  `/aux/revolution-history`.
- The intended host path for the auxiliary mount is
  `/home/kmcho/1_RESEARCH/2026_REvolution_Journal_Ext/code_repo/REvolution`.

## Initial Research Position

- The Auto-BD work established that descriptors can organize archives, but
  not that diversity pressure improves RTL PPA search.
- The next goal should test diversity as an empirical variable before adding
  more descriptor-learning complexity.
- Pre-trained encoders should be diagnostic first:
  Qwen3-Embedding-0.6B for RTL/source or netlist text, and DeepGate3 for
  synthesized netlist graphs when graph export is ready.
- AURORA-style custom encoder training is intentionally deferred.
- New live evolutionary runs are not the default path. If live runs or
  AURORA-style encoder training become necessary, the intended endpoint is
  `http://20.0.0.103:8000/v1/models` with `gpt-oss-120b`, served
  `max_model_len >= 131072`, and 128K-token REvolution settings to avoid
  reasoning-model output truncation.
- Development subsets are acceptable for debugging the pipeline, but final
  conclusions should use a large retrospective corpus or run. Broad RTLLM
  coverage is the preferred practical final target; VerilogEval evidence
  should be used when available but labeled partial if full-suite coverage is
  impractical.

## Evidence To Record During The Future Goal

- Corpus roots scanned and artifact coverage.
- Candidate counts by method, model, seed, benchmark, and problem.
- Exact commands used to build audit tables and reports.
- Embedding model names, local paths or revisions, GPU device, batch size,
  max length, and output hashes.
- Analysis report paths and plots.
- Failed or inconclusive checks, especially missing lineage, missing PPA, or
  model/budget confounds.
- Commit hashes and validation commands.
