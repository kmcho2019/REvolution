The write wasn't permitted — that's fine; I'll deliver the findings directly here rather than to the file.

# Screen Prelaunch Review — Adversarial Findings

I read the screening package, claim gates, plan, report, slides, command cards, and `scripts/package_rtllm_milestone_screen.py` (located at repo root, not the package), cross-checked the CSVs, confirmed the screen run root exists on disk, and traced the gate code. The package is honestly scaffolded, but there is one **correctness blocker** plus a fragile selection that needs reframing.

## Blockers

**B1 — The "hard" classic-covered retention gate is dead code.** `package_rtllm_milestone_screen.py:238-244` sets `gate_status` with three *independent* `if`s, not precedence:

```
if ref_value > 0 and value == 0:      status = "classic_covered_loss"
if ref_value >= 10 and value < ceil:  status = "yield_warning"
if 0 < ref_value < 10:                status = "small_n"
```

For the exact case the gate exists to catch — classic covered, QD got **0** — `classic_covered_loss` is set, then unconditionally overwritten: `classic≥10,QD=0` → `yield_warning`; `0<classic<10,QD=0` → `small_n`. Since any `ref>0` is in one of those bands, `classic_covered_loss` is **never** the final status, so `choose_method` (`:406-421`) — which blocks only on that string — has a perpetually empty `blocked` set. **The one hard launch gate is unenforced.** It didn't change *this* screen (all 3 problems retained ≥1 valid sample for every arm), but at 50 problems the lowest-yield arm (T26) will hit zeros that get silently mislabeled and never block.

**B2 — Contradictory selection record + missing gate artifact.** `selection_report.md`/`screening/README.md` say "selected: exact T26," but `README.md:33` says "Full-run method: not selected yet" and `tables/method_lineage_selection.md` is still "pending screening" with its record-the-choice items open. The selection-timing gate (`claim_gates.md:15`) needs the lock recorded *before* launch — reconcile and freeze these. Also `reviews/claude_screen_prelaunch_review.md` is 0 bytes; `adversarial_validation.md` makes the screening review a required gate-#2 artifact (my write to it was denied, so it still needs saving).

## Q1 — Is exact T26 the right arm?
Defensible **only** as the audited, low-code-risk confirmatory arm — not as a PPA/HV win:
- HV edge over classic is **+1.35% on one seed** (0.183839 vs 0.181382) and **single-problem**: traffic_light **+0.0966** nets against ALU **−0.0892** (multi_pipe = 0 for all). It flips with mild noise on either problem.
- T26 is **worst of four arms on every breadth/yield axis**: valid PPA 40 (classic 66), front points 6 (mid-fusion 15 > classic 10), unique 33, reference-beating 24.
- It **loses HV-AUC to low-fusion** (0.1339 vs 0.1429) — yet `claim_gates.md:11` calls HV-AUC the more stable metric while selection is primary-keyed on the less-stable *final* HV. The tie-break order is what picks T26.
- For a "diversity matters" headline, T26 is the arm that most contradicts it (fewest front points; T28's 9 vs 19 families). Mid-fusion tells the diversity story better.

Keep T26 as confirmatory, but drop the "traffic-light HV win"/"only QD arm with positive HV" framing.

## Q2 — Caveats that must appear
One seed + temp 1.0/top_p 1.0 → noise, no significance; the +1.35% is all traffic_light while ALU regressed −34% HV / −61.5% yield; both yield warnings (ALU −61.5%, multi_pipe −52.4%) first-class; multi_pipe HV=0 is a floor hiding that T26 is the *only* arm with negative best_score there (−0.000378); front-family deficit likely recurs at scale; screen problems are inside the 50 → report screen-excluded aggregates; descriptor↔policy confound (bundle-level claim only); budget parity by LLM calls not pop×gen; pin claim to `near_classic` (report.md:14-17 drifts bullish).

## Q3 — Launch blockers
The run can launch (manifest/endpoint/commands present, screen done). Before results are *trusted/packaged*: fix B1 if full-run packaging reuses this gate; reconcile/freeze B2 and save this review; confirm the not-yet-written full-run packaging emits screen-excluded aggregates and eval-count/LLM-call parity (`experiment_plan.md:88-91`); honor the "record failure, re-version" rule on the pre-registered 50-worker risk.

## Q4 — Reward hacking or defensible policy?
The **policy** (PPA-first, yield drops as visible warnings, retention as the one hard gate) is a defensible milestone choice — not inherently hacking. But two hacking-adjacent issues: (a) the one hard constraint is non-functional in code (B1), so "we kept the safety gate" is currently unbacked; (b) selecting the lowest-yield/lowest-breadth arm on the single aggregate metric where it edges classic, while it loses on all others, is conclusion-favorable selection unless adverse metrics get equal prominence. The package *does* log the warnings, which keeps it defensible — **contingent on** fixing the gate and reframing T26 as "quality-safe, HV-neutral-to-marginally-positive, yield- and breadth-negative."

## Q5 — Cleanliness under AGENTS.md/GUIDELINES.md
- **C1:** the three-independent-`if` gate is the multi-state hazard simplicity rules 2–3 warn against and is the root of B1 — use `elif`/precedence (most-severe wins) + docstring. `tests/scripts/test_package_rtllm_milestone_screen.py` only checks row counts and the selection string; it never exercises the gate branches, so the bug is untested. Add a `classic=K, QD=0` gate test.
- **C2:** nothing in the package points to its generating script `scripts/package_rtllm_milestone_screen.py` (not README, evidence_sources, or experiment_plan) — the review brief itself pointed at a nonexistent package-local `scripts/` path. Add the pointer (GUIDELINES:26-27).
- **C3:** doc/code mismatch — `selection_report.md`/`screening/README.md` assert a hard gate the code doesn't enforce; README/method_lineage say "not selected." Reconcile.
- **C4 (minor):** `choose_method`, `problem_gate_row`, `delta_row` lack the Google docstrings rule 12 asks for; the gate function most needs one.

**Recommendation: conditional go.** Exact T26 may proceed as the one-seed confirmatory arm, but (1) fix gate-status precedence + add its test before any full-run packaging relies on the gate; (2) reconcile/freeze the selection records and save this review; (3) reframe T26 as quality-safe/HV-neutral with explicit yield+breadth warnings, not a PPA or diversity win; (4) hold the claim at `near_classic`.

Note: prior-review concerns about empty `claude_prelaunch_review.md` and a missing `original_thought.txt` are now resolved (7,247 and 12,839 bytes on disk). I did not modify any package files. If you'd like, I can save this review to `reviews/claude_screen_prelaunch_review.md` and/or open a one-line fix for the gate-status precedence + its unit test.
