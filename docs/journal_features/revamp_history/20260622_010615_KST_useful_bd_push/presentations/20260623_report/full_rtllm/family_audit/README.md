# Full RTLLM Family Audit

Status: completed post-hoc canonical RTL/netlist/family-proxy audit.

This package checks whether the one-seed full RTLLM T26 result
is explained by duplicate implementations or by broader
front-family proxy material.

## Scope

- RTLLM manifest problems: `50`.
- Classic audited deduplicated PPA-point rows: `352`.
- Exact T26 QD audited deduplicated PPA-point rows: `318`.
- Classic audited PPA-point problems: `31`.
- Exact T26 QD audited PPA-point problems: `37`.
- Family proxy: SHA-256 of the synthesized standard-cell count
  signature, summed per problem. The signature grammar is sorted
  `CELL_TYPE:COUNT` terms joined with `|`. It is a duplicate/front-material
  proxy, not a proof of semantic RTL implementation families.

## Headline Metrics

| Metric | Classic | Exact T26 QD | Delta |
| --- | ---: | ---: | ---: |
| Summed unique family proxies | 341 | 311 | -30.000000 |
| Summed front family proxies | 61 | 69 | 8.000000 |
| Front netlists | 61 | 69 | 8.000000 |
| Reference-beating family proxies | 179 | 129 | -50.000000 |
| Family duplicates | 11 | 7 | -4.000000 |
| Audited family ratio | 0.968750 | 0.977987 | 0.009237 |
| Front family ratio | 1.000000 | 1.000000 | 0.000000 |

## Interpretation

The audit does not support a duplicate-collapse explanation for the T26 PPA-HV
signal: exact T26 QD has fewer audited deduplicated PPA rows, fewer family
duplicates, and a slightly higher audited family-proxy ratio than classic.

The audit strengthens the full-suite front-material claim: exact T26 QD
has `69` front family-proxy hits and
`69` front netlists versus classic's
`61` and `61`.
That is positive post-hoc front-material evidence for the active PPA front. It
is not independent of the front-point count because both arms have
`front_family_ratio=1.0`.

The caveat is total audited breadth and quality: exact T26 QD still has
fewer summed family proxies (`311` versus
`341`) and fewer reference-beating
family proxies (`129` versus
`179`). The presentation
should describe better front-family proxy material only as a front observation,
not broad implementation-family dominance.

## Files

- `tables/full_family_candidate_rows.csv`
- `tables/full_family_problem_metrics.csv`
- `tables/full_family_aggregate_metrics.csv`
- `tables/full_family_comparison_deltas.csv`
- `figures/full_family_aggregate_counts.png`
- `figures/full_front_family_delta_heatmap.png`
- `figures/full_family_ratio_distribution.png`
- `figures/visual_inspection_notes.md`
