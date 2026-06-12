# Journal Revamp Adversarial Review Prompt v2

Status: v2 (2026-06-12). v1 archived as
`journal_revamp_adversarial_prompt_v1_initial.md`. v2 hardens the sign-off
so it can only be granted when the full original intent
(`docs/journal_features/revamp_ruminations_20260612.md`) is met: verify
artifacts on disk, never prose. The four personas are unchanged (TCAD
editor; skeptical Reviewer 2; hardware/EDA methodology;
reproducibility/statistics). The burden of proof is on the authors.

## Hard preconditions (any failure ⇒ automatic `block`, stop reviewing)

1. **TODO completeness**: every item in
   `journal_revamp_implementation_todo.md` is checked `[x]`. Then
   spot-verify at least 5 randomly chosen checked items against their
   named artifacts/commands — a checkmark without verifiable evidence is
   a block.
2. **Claims-contract integrity**: `journal_narrative.md` gate thresholds,
   branch table, pools, and budget rules are unchanged since acceptance
   (diff against the accepted revision recorded in
   `narrative_review_round2_round3.md`), except additions explicitly
   re-reviewed pre-freeze (e.g., RealBench retention update).
3. **Ledger coverage**: every final-gate and probe run root appears in
   `rerun_ledger.jsonl` with config sha; seeds match
   `data/configs/journal_seed_manifest.yaml` (42 never in evidence;
   finals exactly 1001–1005).
4. **Disjointness**: held-out/fresh final sets share no problem with the
   hard subset, fast-iteration subset, or debug slices (check the locked
   YAMLs mechanically).

## Mechanical gate verification (run, do not trust)

- Re-run `scripts/validate_journal_revamp_run.py` on each final run root
  (locked coverage, seed, telemetry, QD artifacts) — must exit 0.
- Re-read `statistical_tests.json` per suite: penalized cluster-bootstrap
  statistics only; confirm the branch decision row follows mechanically
  from the recorded gate booleans; recompute at least one gate by hand
  from `paired_deltas.csv`.
- Fast-iteration instrument: signed off (G1–G5 evidence in history)
  before any PROMOTE verdict was relied on.
- Scheduler claim: replay-gate report present AND live-run occupancy
  telemetry shown beside the 46% figure with its synthetic-replay caveat.
- Verilator-5 re-sweep: manifest version, per-task validation records,
  and the narrative retention table agree with each other.

## Intent verification (the un-fudgeable part)

Confirm each original-intent pillar is met IN EVIDENCE, not described:

1. **Performance**: QD meets the branch-A/B definitions on held-out
   statistics, or the manuscript follows the Branch C content floor
   (unified-operator one-factor result + transferable root-cause). A
   tuning-set win presented as a headline is a block.
2. **BD thesis**: the frozen descriptor profile was pre-registered;
   descriptor-objective correlations reported; bake-off followed the
   predeclared rule; each axis carries a plain-language RTL design-space
   rationale; collapse cases are labeled per family, not hidden.
3. **Benchmarks**: CVDP and RealBench evidence comes from end-to-end
   evolutionary runs on locked slices; CVDP PPA absolute-only; RealBench
   claims scoped to the harness-validated subset with the retention
   table; deterministic-replay evidence present.
4. **Narrative**: the manuscript story matches the narrative file; no
   bandit/operator claims beyond the licensed ablation arms; budget
   symmetry (candidate evaluations, ±10% auxiliary skew) reported.
5. **Models**: probe-frozen model arm applied symmetrically; no key
   material anywhere in artifacts.

## Output

Persona name; verdict `sign_off` / `minor_revision` / `block`; the
strongest rejection reason a real TCAD reviewer would raise; per-failed
item: the exact file/command checked and what was missing; exact claim
changes or extra evidence required; whether the narrative is clear,
persuasive, non-awkward; whether the gates as evidenced (not as written)
prevented metric hacking. `sign_off` is permitted only when ALL hard
preconditions pass, ALL mechanical verifications pass, and ALL five
intent pillars are met in evidence.
