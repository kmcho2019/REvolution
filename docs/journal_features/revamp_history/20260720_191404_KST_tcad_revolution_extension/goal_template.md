# Program Goal Template

Review `intake_review.md` before launch. Do not begin live candidate experiments
until the claims contract and frozen baseline/benchmark gates are accepted.

```text
/goal Conduct the bounded REvolution TCAD extension discovery program defined in
docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/tcad_revolution_extension_plan.md.

The outcome is an evidence-backed, advisor-facing portfolio of natural
extensions to the ASP-DAC 2026 classic REvolution method. Start by auditing the
conference paper, exact classic implementation, operators, populations,
selection/adaptation, verification, evaluator, prior experiment history, and
current related work. Identify which components are supported, unproven, or
limiting before proposing replacements.

Before Wave 1, freeze the classic baseline, benchmark and contamination roles,
development-disjoint confirmation seeds, statistical protocol, missing-result
rules, practical margins, and program resource ceilings from classic-only
evidence.

Generate several candidate cards from documented weaknesses. Include core
corrections, hardware/RTL-grounded evolutionary mechanisms, and compatible
augmentations where justified. A candidate must have a falsifiable rationale,
a clear REvolution-specific and related-work delta, one isolatable mechanism,
mechanism telemetry, and frozen gates. Reject problem-specific heuristics,
fallback ladders, generic algorithm transplants, parameter scans, and combined
mechanisms without isolated evidence.

Evaluate candidates in at most two sequential waves of no more than three
distinct mechanisms each. Keep one candidate active at a time. For each: run
independent naturalness/novelty review,
implement the smallest typed mechanism in isolated experimental code while
keeping classic byte-identical, add focused tests and logs, conduct a code
simplicity audit, run a bounded diverse smoke, then a baseline-only-selected
representative probe. Candidates that work end to end and avoid preregistered
catastrophic failure receive a frozen two-seed full-suite probe because prior
small screens transferred weakly. Permit at most two mechanism-preserving
revisions, each justified by measured failure evidence rather than nearby knobs.

Classify every evaluated candidate as PAPER_CANDIDATE, VIABLE, RETIRED, or
BLOCKED. Modest gains can be viable; do not require arbitrary 3% or 5% uplift.
For a primary PPA claim, however, HV-AUC or a case study cannot rescue a final-HV
loss. Confirm only the strongest one or two candidates with five matched,
preregistered seeds disjoint from development and one frozen disjoint holdout.
Count missing treatment outputs as failures and report functionality/valid-PPA,
final HV, HV-AUC, paired uncertainty, W/L/T, tokens, calls, synthesis
evaluations, runtime, and mechanism evidence.

After each decision, update the append-only history, negative map, claim ledger,
and extension_portfolio.md before choosing the next candidate. Use independent
read-only subagents at scientific, code, and evidence gates. When available,
also use read-only claude -p reviews at major transitions and about every ten
goal commits with a 5-10 minute timeout; verify rather than blindly accept their
feedback.

Finish with exactly one program outcome from program_claims_contract.md:
JOURNAL_READY, PORTFOLIO_READY, or PIVOT_REQUIRED. Completion requires a frozen
classic baseline, completed conference audit, reproducible candidate decisions,
organized portfolio, honest conference-to-journal contribution map, documented
negative results, code/docs validation, and adversarial process PASS. Never
weaken gates or stack near-misses to manufacture a journal-ready result.
```
