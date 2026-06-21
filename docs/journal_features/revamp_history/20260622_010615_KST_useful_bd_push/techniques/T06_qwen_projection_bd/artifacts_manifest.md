# Qwen Projection BD Artifacts Manifest

Status: current diagnostic package for the prior Qwen common-audit run.

## Prior Diagnostic Evidence To Reuse

- prior common-audit card:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/stage_results/wp1_qwen/qwen_common_audit_card.md`
- prior summary JSON:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/stage_results/wp1_qwen/qwen_common_audit_summary.json`
- prior aggregate table:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/stage_results/wp1_qwen/qwen_common_audit_aggregate.csv`
- source script:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/scripts/processing/run_rtl_diversity_wp1_qwen_common_audit.py`

Prior diagnostic facts to preserve in the next manifest:

- model id: `Qwen/Qwen3-Embedding-0.6B`
- embedded candidates: 768 across 127 problems
- embedding shape: 1024 dimensions for raw, comment-stripped, and
  identifier-normalized RTL views
- raw/comment cosine mean: 0.9493
- raw/identifier cosine mean: 0.6389
- nearest-neighbor same-problem fraction: 0.9336
- best prior replay signal: identifier-normalized Qwen farthest-first improved
  HV by 3.35% over lexical farthest-first, but the prior verdict remained
  `diagnostic_only_no_proceed`

## Package Command

```bash
.venv/bin/python scripts/package_useful_bd_qwen_audit.py \
  --qwen-dir docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/stage_results/wp1_qwen \
  --technique-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T06_qwen_projection_bd
```

## Committed Tables

- `tables/qwen_embedding_manifest.csv`
- `tables/preprocessing_view_manifest.csv`
- `tables/replay_aggregate.csv`
- `tables/qwen_vs_lexical_deltas.csv`
- `tables/collapse_diagnostics.csv`
- `tables/nuisance_axis_diagnostics.csv`

## Committed Figures

- `figures/qwen_replay_hypervolume.png`
- `figures/qwen_vs_lexical_hv_delta.png`
- `figures/qwen_diversity_counts.png`
- `figures/qwen_collapse_diagnostics.png`
- `figures/visual_inspection_notes.md`

## New T06 Manifest Requirements

- exact model id, revision, tokenizer, pooling rule, max sequence length, and
  prompt string;
- preprocessing view manifest for `canonical_rtl_view`, `yosys_netlist_view`,
  and `structural_summary_view`;
- canonicalization script path, Yosys script path, and hashes of generated
  normalized text caches;
- embedding cache hashes for every view and chunk;
- projection training command, positive/negative pair manifest, and random
  seed;
- nuisance-axis diagnostics for text length, identifier churn, problem id,
  canonical netlist hash, and motif signature hash;
- archive mapping command and passive-audit report path.
