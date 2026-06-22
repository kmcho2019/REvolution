# Milestone Adversarial Validation

Status: packaging review passed for the scoped PPA-first T26-bundle claim.

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

The milestone can be presented as scoped PPA-first evidence that QD/MAP-Elites
should continue only if the final report has current artifacts for required
PPA figures/tables, clear limitations, and no overclaim relative to the paired
RTLLM evidence. Archive-viewer or implementation-family breadth claims require
the corresponding follow-up artifacts before being presented as complete.
