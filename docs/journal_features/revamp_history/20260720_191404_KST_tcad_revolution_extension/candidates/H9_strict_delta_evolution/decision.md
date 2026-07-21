# H9 Decision

Outcome: `RETIRED`

## Scope

H9 proposed switching every post-initialization classic EoH request from whole
RTL output to the repository's existing strict-diff protocol. Gen0, dual pools,
EoH operators, UCB, scalar selection, evaluator, model, and candidate budget
would have remained fixed.

## Decision

The card was retired during mandatory proposal review. No source, config,
worksheet, admission event, LLM call, synthesis evaluation, or benchmark result
was created for H9.

Two independent reasons are sufficient:

1. The novelty score is zero. AlphaEvolve already applies LLM deltas to parent
   programs inside evolutionary search and includes Verilog optimization;
   CodeEvolve explicitly supports diff-based evolution versus full-code rewrite.
   H9 would be an existing-mode ablation, not a primary TCAD algorithm.
2. The evidence-backed premise covers 1,900 success-origin one-parent offspring,
   not all 4,000 proposed treatment offspring. The 1,658 fail-origin rows reverse
   the association: successful valid-PPA repairs are broader than failed repairs
   on average. A global locality protocol is therefore not supported by the
   classic evidence.

The implementation audit also found two preventable confounds: compact diff
context omits C-F's second-parent RTL, and the strict applier accepts empty-search
appends before exact-policy enforcement. Those issues were identified before
spend and do not need runtime repair for a retired card.

## Allowed Conclusion

Whole-output breadth is negatively associated with valid-PPA yield for
success-origin refinement but not for failed-parent repair. This supports
considering, not claiming, a separately reviewed role-conditioned generation
policy. It does not support global strict-diff REvolution or novelty for delta
evolution.

## Follow-Up Boundary

A future card may ask whether REvolution's functional state should determine
offspring-generation scope: whole output for failed-parent correction and
parent-relative deltas for successful-parent refinement. It must not be called
an H9 revision, and it must first demonstrate a simple isolated implementation
that leaves the classic engine byte-identical. No live follow-up is authorized
by this decision.

## Evidence

- `hypothesis_card.md`
- `related_work.md`
- `implementation_history.md`
- `../../reviews/20260721_h9_novelty_review.md`
- `../../reviews/20260721_h9_methodology_review.md`
- `../../reviews/20260721_h9_claude_timeout.md`
