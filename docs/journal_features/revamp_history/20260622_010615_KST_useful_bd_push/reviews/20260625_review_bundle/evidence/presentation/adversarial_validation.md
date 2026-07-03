# Milestone Adversarial Validation

Status: current package is approved only as a `diagnostic` front-signal
milestone after the stricter current-package review. It is not approved as a
positive `useful_qd` claim.

## Review Gates

1. Pre-registration review before screening.
2. Screening review before full RTLLM launch. Complete:
   `reviews/subagent_screen_prelaunch_review.md` and
   `reviews/claude_screen_prelaunch_review.md` gave conditional go after
   fixing the gate-order bug and freezing the exact T26 selection.
3. Packaging review before presentation sign-off. Initial sub-agent review
   returned `FAIL`; the follow-up sub-agent and `claude -p` reviews passed
   after Q2 scope, budget parity, and family-breadth caveats were fixed.
   See `reviews/subagent_packaging_review.md` and
   `reviews/claude_packaging_review.md`.
4. Current package review after the full family-proxy audit. Sub-agent review
   passed with limitations, but `claude -p` found presentation-integrity
   blockers around Prob040/defaulted-reference dominance, omitted `best_score`,
   aggregate-only HV evidence, and non-independent family-front counts. The
   report was narrowed to `diagnostic`. See
   `reviews/claude_current_package_review.md` and
   `reviews/claude_current_package_resolution.md`.
5. Journal contract alignment. The current package was mapped against the
   accepted `journal_narrative.md` contract and labeled not final-gate
   eligible. See `journal_contract_alignment.md`.

## Required Reviewer Questions

- Does the report answer whether diversity matters for RTL PPA evolution?
- Does the report answer which diversity matters?
- Is the full RTLLM experiment selected before seeing full RTLLM outcomes?
- Are classic and QD compared under the same seed, model, prompts, budget, and
  evaluation flow?
- Are PPA, reference PPA, fitness, HV, Pareto rank, and test pass rate excluded
  from in-loop BD inputs?
- Are invalid candidates and duplicate netlists excluded from useful-diversity
  claims?
- Are small-n validity cases labeled instead of used as hard accept/reject
  evidence?
- Are figures readable, conventional, visually inspected, and tied to claims?
- Does any T26.1/gated implementation obey GUIDELINES.md simplicity rules:
  narrow state, no broad fallback, no optional clutter, and focused tests?
- Is exact T26 used as fallback if a new variant fails smoke or adds messy code?

## External Review

Run sub-agent reviews at each gate and save prompts/outputs in `reviews/`.
If `claude -p` is available, run an independent third-party review and save
the exact prompt and output. If it is unavailable, record the command failure.

## Pass Condition

The milestone can be presented as diagnostic evidence that exact T26 preserves
classic-covered problems and adds front points under matched budget. It must
not be presented as a positive QD-effectiveness claim until paired PPA evidence,
scalar-quality evidence, and non-defaulted-reference or multi-seed evidence are
stronger. Archive-viewer or implementation-family breadth claims require the
corresponding follow-up artifacts before being presented as complete.
Any TCAD-style final claim must also pass the frozen `journal_narrative.md`
contract, not only the local presentation gates.
