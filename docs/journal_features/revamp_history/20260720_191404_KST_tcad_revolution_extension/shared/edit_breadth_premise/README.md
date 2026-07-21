# Classic Edit-Breadth Premise

Status: `CLASSIC_ONLY_ASSOCIATION`; suitable for candidate selection, not a
treatment or performance claim.

## Question

Do broad whole-output mutations in classic REvolution associate with lower RTL
and verification-complete valid-PPA yield strongly enough to justify one
controlled mutation-representation experiment?

## Scope

- Fresh matched classic arms from H5 full-suite development seeds 1001 and
  1002; no H5 treatment output enters this analysis.
- All 50 RTLLM tasks for pooled and operator summaries; the frozen 46-task
  reference-complete manifest for problem-stratified checks.
- 1,900 post-initialization, one-parent, success-origin offspring. C-F is
  excluded because it has no unique parent-to-child edit anchor.
- Edit ratio is changed parent lines plus changed child lines divided by total
  parent plus child lines, using deterministic line-sequence opcodes.

## Result

| Outcome | Pass edit mean/median | Fail edit mean/median | Spearman rho | p-value |
| --- | ---: | ---: | ---: | ---: |
| RTL valid | 0.5368 / 0.5412 | 0.6173 / 0.6286 | -0.2066 | 9.13e-20 |
| Valid PPA | 0.5296 / 0.5349 | 0.6215 / 0.6391 | -0.2509 | 1.17e-28 |

The valid-PPA association remains negative inside every EoH one-parent
operator (`M-E`, `M-I`, `M-R`, and `M-S`; all p < 0.007). Across the 31
reference-complete problems with both outcomes, 27 have a negative Spearman
coefficient and four have a positive coefficient. Passing offspring have a
smaller mean edit than failing offspring in 29 of those 31 strata.

The association is negative in each seed and each post-initialization
generation. None of the 1,900 selected offspring has `failed_format` status,
so malformed whole-output envelopes do not explain the pooled result.

The binned valid-PPA rate falls monotonically from `0.9412` for edit ratios in
`[0.10, 0.25)` to `0.5111` for `[0.75, 1.01)`. The five samples below `0.10`
all pass but are too few for a separate claim.

## Interpretation

This closes H3's previously missing classic-only premise: edit breadth is
associated with semantic and valid-PPA loss after operator and problem checks.
It does not show that strict deltas cause an improvement, that small edits are
always better, or that a delta treatment improves final HV. A candidate must
isolate mutation representation, preserve the EoH operator family and search
logic, and test both validity and PPA on fresh matched arms.

The row-level p-values do not account for shared problems, parents, or
lineages. They are descriptive support for a controlled experiment, not causal
or paper-level inferential evidence.

## Reproduction

```bash
uv run python scripts/report_tcad_edit_breadth_premise.py \
  --classic-root exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/full_suite_probe/seed_1001/classic \
  --classic-root exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/full_suite_probe/seed_1002/classic \
  --headline-manifest docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml \
  --output-dir docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/shared/edit_breadth_premise
```

See `artifact_manifest.md` for immutable inputs and generated-output hashes.
