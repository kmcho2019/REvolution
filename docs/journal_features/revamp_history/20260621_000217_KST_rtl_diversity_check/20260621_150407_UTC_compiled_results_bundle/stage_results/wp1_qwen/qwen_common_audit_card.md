# Qwen3 Common-Audit Diagnostic

- Model: `Qwen/Qwen3-Embedding-0.6B`
- Candidates: 768 across 127 problems
- Verdict: `diagnostic_only_no_proceed`
- Stability raw/comment mean: 0.9493
- Stability raw/identifier mean: 0.6389
- Nearest-neighbor same-problem fraction: 0.9336

## Replay Aggregate

| representation | problem_group_count | valid_ppa_count | selected_count | baseline_hypervolume | selected_hypervolume | baseline_pareto_size | selected_pareto_size | baseline_best_fitness | selected_best_fitness | unique_canonical_netlists | unique_motif_signatures | vs_lexical_hv_gain_fraction | vs_lexical_pareto_gain_fraction |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| fitness_top | 114 | 682 | 341 | 3.864198082956659 | 3.8232476279516034 | 553 | 300 | 0.7498077353006931 | 0.7498077353006931 | 52 | 44 | 0.03280031397178676 | 0.06007067137809187 |
| generation_prefix | 114 | 682 | 341 | 3.864198082956659 | 3.1551856809847187 | 553 | 303 | 0.7498077353006931 | 0.6950547730829421 | 50 | 45 | -0.14766787844547294 | 0.0706713780918728 |
| lexical_farthest | 114 | 682 | 341 | 3.864198082956659 | 3.701826554688716 | 553 | 283 | 0.7498077353006931 | 0.6881421864520456 | 60 | 54 | 0.0 | 0.0 |
| qwen_identifier_farthest | 114 | 682 | 341 | 3.864198082956659 | 3.825836092023533 | 553 | 289 | 0.7498077353006931 | 0.7498077353006931 | 59 | 51 | 0.033499553667026144 | 0.02120141342756184 |
| qwen_raw_farthest | 114 | 682 | 341 | 3.864198082956659 | 3.6555395380963835 | 553 | 294 | 0.7498077353006931 | 0.6950547730829421 | 57 | 50 | -0.012503831799927376 | 0.038869257950530034 |
| random | 114 | 682 | 341 | 3.864198082956659 | 3.0741669813303787 | 553 | 303 | 0.7498077353006931 | 0.6950547730829421 | 59 | 50 | -0.16955401991034577 | 0.0706713780918728 |

## Leakage Policy

Frozen Qwen embeddings and lexical controls use RTL text/features only; PPA fields are used only after selection for replay evaluation.
