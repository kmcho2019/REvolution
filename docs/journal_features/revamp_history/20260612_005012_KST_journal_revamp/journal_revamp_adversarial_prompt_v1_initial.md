> **ARCHIVED v1 (2026-06-12).** Superseded by the v2 document of the same
> base name after the phase-0 foundations landed; kept verbatim for the
> record. See journal_revamp_implementation_history.md for the refactor entry.

# Journal Revamp Adversarial Review Prompt

Use this prompt for sub-agent or human review of the journal narrative and
experiment plan. The reviewer must be critical and must not assume the plan is
good because it is detailed.

## Materials To Review

- `docs/journal_features/08_journal_revamp_goal.md`
- `docs/journal_features/journal_narrative.md`
- `docs/journal_features/resources/conference_submission_paper/main.tex`
- `docs/journal_features/resources/conference_submission_paper/content/1_intro/v_camera.tex`
- `docs/journal_features/resources/conference_submission_paper/content/3_method/v_camera.tex`
- `docs/journal_features/resources/conference_submission_paper/content/4_expnrst/v_camera.tex`
- `docs/journal_features/resources/conference_submission_paper/table/result.tex`
- `baselines/20260316_120539__447c0128__funsearch/`
- `baselines/20260316_120708__447c0128__codeevolve/`
- `baselines/20260316_120813__447c0128__eoh/`
- final benchmark manifests and seed manifests
- final statistical reports
- descriptor-health reports
- scheduler telemetry reports
- manuscript methodology/results text in `docs/journal_features/resources/journal_draft/`

## Reviewer Persona

Choose exactly one persona per review:

1. TCAD editor deciding whether the extension is substantial enough beyond
   ASP-DAC.
2. Skeptical Reviewer 2 looking for overclaims, post-hoc metrics, cherry-picked
   tasks, and arbitrary method choices.
3. Hardware/EDA methodology reviewer checking whether RTL descriptors,
   synthesis metrics, benchmark harnesses, and PPA claims are technically
   defensible.
4. Reproducibility/statistics reviewer checking locked seeds, paired tests,
   missing data handling, confidence intervals, run ledgers, and fairness of
   classic-vs-QD comparisons.

## Review Instructions

Assume the burden of proof is on the authors. Identify the strongest reason a
TCAD reviewer should reject or require major revision. Be specific: cite files,
figures, tables, commands, artifacts, or missing evidence.

Do not accept generic statements such as "QD improves diversity" or "larger
benchmarks were added" unless the evidence supports the exact claim. Check that
CVDP does not use invalid reference-normalized PPA and that RealBench results
are deterministic enough for publication.

Do not require the final MAP-Elites behavior descriptor to be the original
`logic_depth`, `ff_depth`, `comb_width_log` trio. Instead, verify that the
selected descriptor profile was predeclared before final runs, improves or
preserves PPA-search evidence, gives non-decorative diversity metrics, remains
stable across seeds/families, and has a persuasive RTL-design-space rationale.

Check the scheduler claims separately from the search-quality claims. A faster
run is only valid if candidate outcomes are unchanged or the comparison is
otherwise controlled.

Check model capability claims separately from method claims. If DeepSeek was
used for RealBench, verify that `DEEPSEEK_API_KEY` was not leaked, the
RealBench long-model probe was locked before use, and DeepSeek was applied
symmetrically to classic and QD rather than used as one-sided rescue.

If FunSearch, CodeEvolve, or EoH baselines are mentioned in final claims, verify
that they were rerun or revalidated under the same locked problems, seeds,
model policy, token budgets, scheduler policy, evaluator settings, and
statistics. Retrospective archived results alone are not enough for a headline
TCAD comparison.

If the final method changes the original seven journal-extension pillars,
evaluate the replacement structure directly. The change is acceptable only if
it makes the method easier to explain, improves or preserves fair performance
evidence, and avoids turning the manuscript into an unrelated feature list.

## Required Output

Return:

- Persona name.
- Verdict: `sign_off`, `minor_revision`, or `block`.
- Top 3 blocking or high-risk issues.
- Exact claim changes required, if any.
- Exact extra evidence required, if any.
- Whether the narrative is clear, persuasive, and non-awkward.
- Whether the quantitative gates are strong enough to prevent metric hacking.

A `sign_off` verdict is allowed only if the narrative and evidence would be
credible to a skeptical TCAD reviewer.
