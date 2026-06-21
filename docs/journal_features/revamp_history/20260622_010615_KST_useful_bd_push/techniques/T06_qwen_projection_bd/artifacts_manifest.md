# Qwen Projection BD Artifacts Manifest

Status: scaffold only.

Record run roots, model name/revision, tokenizer and pooling rule, dependency
install command, embedding cache hashes, projection training command, split
manifest, generated tables, generated figures, and git commit hashes.

## Prior Diagnostic Evidence To Reuse

- prior common-audit card:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/stage_results/wp1_qwen/qwen_common_audit_card.md`
- prior summary JSON:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/stage_results/wp1_qwen/qwen_common_audit_summary.json`
- prior aggregate table:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/stage_results/wp1_qwen/qwen_common_audit_aggregate.csv`

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
