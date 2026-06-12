# 09. Fast-Iteration Validation Set

## Why

The hard-iteration subset (13 problems, population 20 × 5 generations,
`openai-gpt-oss-120b`) is the right instrument for the QD-repair question —
its problems were chosen for low one-shot functionality, so it measures
whether evolution rescues hard problems — but it is the wrong instrument
for day-to-day iteration: each classic-vs-variant comparison costs
~1,560 candidate evaluations and hours of wall-clock, and its low pass
rates mean most of that budget produces no valid-PPA sample at all.
Quick "did this change help or hurt PPA?" loops need the opposite regime:
problems that pass often (so every generation yields PPA data) on designs
large enough that PPA actually has room to move.

## The instrument

`data/configs/fast_iteration_subset.yaml`
(regenerate: `python scripts/build_fast_iteration_subset.py`), locked with
source-CSV sha256 provenance. Predeclared selection rule over the full
202-problem one-shot pool:

- one-shot functionality rate ≥ 0.6 (valid-PPA samples flow immediately);
- reference gate count in [150, 3000] (real optimization headroom, fast
  synthesis);
- hard-subset problems excluded (the two tuning artifacts stay
  independent);
- deterministic balance: top gate-count problem per
  (benchmark × circuit type) bucket, then top-up by gate count with a
  per-benchmark cap of 3.

Result (6 problems, 3 RTLLM / 3 VerilogEval, 3 sequential / 3
combinational — all canonical PPA design spaces):

| Problem | Gates | Func | Type | Design space |
| --- | --- | --- | --- | --- |
| RTLLM Prob048_pe | 1730 | 1.0 | seq | MAC/processing element |
| VE Prob108_rule90 | 1591 | 1.0 | seq | wide register + XOR network |
| VE Prob021_mux256to1v | 1574 | 0.8 | comb | 256:1 mux (tree vs index) |
| RTLLM Prob016_fixed_point_adder | 650 | 0.8 | comb | adder architectures |
| VE Prob030_popcount255 | 633 | 1.0 | comb | adder-tree/popcount |
| RTLLM Prob011_multi_16bit | 532 | 1.0 | seq | multiplier architectures |

## Recommended budget (embedded in the config)

Population 12 (divisible by k=4, a thought_only-mode engine constraint), 3 generations, `k=4` thought-only for QD arms,
`--max_tokens 128000 --diff_max_tokens 128000`, elastic
`--total_worker_slots 12 --max_active_problems 6
--max_workers_per_problem 4`, `strict_ablation` evaluation. That is ~288
candidate evaluations per arm (6 × (12 + 3×12)) — ~15% of the hard-subset
matrix cost — and because pass rates are high, nearly all of it produces
PPA signal.

Example commands (classic vs primary QD target):

```bash
python scripts/run_backend.py --backend revolution \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --problems Prob048_pe Prob016_fixed_point_adder Prob011_multi_16bit \
             Prob108_rule90 Prob021_mux256to1v Prob030_popcount255 \
  --model_name /models/openai-gpt-oss-120b --api_backend vllm \
  --population_size 12 --num_generations 3 --seed 42 \
  --max_tokens 128000 --diff_max_tokens 128000 \
  --total_worker_slots 12 --max_active_problems 6 --max_workers_per_problem 4 \
  --save_path exp/fast_iter/<tag>/classic

# QD arm: add --search_mode revolution_qd plus the frozen target-config
# flags (grid_quantile, journal BD profile, pareto cells, unified operator,
# thought-only k=4, KS rebinning), same budget and scheduler flags.
```

Compare with the standard machinery:

```bash
python scripts/report_journal_statistics.py \
  --pair 42=exp/fast_iter/<tag>/classic=exp/fast_iter/<tag>/qd \
  --output-dir exp/fast_iter/<tag>/stats --gate-profile none
```

`paired_deltas.csv` + `statistical_tests.json` give the quick verdict
(best-quality delta, avg-PPA delta, per-problem rows). With 6 problems ×
1 seed, treat results as directional only; promising changes graduate to
the hard subset, then to the gates.

## Honesty rules

- This subset is a TUNING/DEV artifact. It is never publication evidence,
  and the future held-out final problem set must exclude these 6 problems
  in addition to the 13 hard-subset problems (recorded in the config's
  `purpose` field and the narrative's contamination rules).
- Both arms always run with identical budgets, seeds, scheduler flags, and
  evaluation mode; the statistics script's missing-as-loss accounting
  applies as everywhere else.
- Selection used only retrospective one-shot data (functionality, gate
  count) — no variant's results influenced the problem choice, and the
  rule is deterministic from the locked CSV (sha256 in the config).

## Instrument requirements (the subset is gated, not a convenience)

The fast subset may only be used for promote/demote decisions once it has
passed its own signoff gates. Requirements, predeclared:

- **R1 Speed.** A full pair (classic arm + variant arm + statistics) must
  fit a tight loop: each arm ≤ 100 minutes wall-clock on the shared
  endpoint at the recommended budget, no single problem consuming more
  than half an arm's wall time (a dominant problem is a prune candidate).
- **R2 PPA signal flow.** Every problem must yield enough functionally
  passing candidates with PPA metrics that paired PPA deltas are
  populated in every arm — the failure mode of the hard subset for this
  purpose.
- **R3 Discrimination (PPA margin).** Designs must be large enough, and
  their implementation spaces wide enough, that candidate quality
  *spreads* within a problem; a problem where every candidate lands on
  the same PPA point cannot distinguish methods and must be replaced.
- **R4 Screening validity.** The instrument must reproduce the known
  hard-subset ordering for a predeclared calibration pair before its
  verdicts are trusted: a screen that cannot detect a known difference is
  decorative.
- **R5 Stability.** The calibration pair's verdict must agree in sign
  across two seeds, or the inconclusive band must be widened and the
  escalation rule used.
- **R6 Honesty.** Tuning/dev artifact only; never publication evidence;
  excluded from the held-out final set; both arms always identical in
  budget, seed, scheduler, and evaluation mode; every pair recorded in
  the rerun ledger.

## Quantitative signoff gates

Mechanical gates G1–G3 are checked per pair by
`scripts/validate_fast_iteration_pair.py` (writes
`fast_iter_gate_report.json/md`, nonzero exit on failure). Calibration
gates G4–G5 are evaluated once per subset version and recorded in the
revamp history with run roots.

| Gate | Requirement | Threshold |
| --- | --- | --- |
| G1a | Arm wall-clock (scheduler telemetry `run_wall_seconds`) | ≤ 6,000 s per arm |
| G1b | No dominant problem | no problem > 50% of the SUM of per-problem runtimes (problems run concurrently, so the arm wall is not the basis) |
| G2 | Valid-PPA candidate flow | every problem ≥ 6 distinct successful candidates with PPA metrics (generation logs ∪ final population) per arm |
| G3 | Discrimination | best-minus-median quality gap ≥ 0.02 on ≥ 4 of 6 BASELINE-arm problems. Recalibrated from retained-IQR at v3 with recorded rationale: elite selection compresses retained-population IQR on converged problems (v3 data: sub_64bit and mux256to1v carry the LARGEST realized margins, +0.33, with IQR 0.000), while the gap directly measures R3's intent — headroom exists AND the search exploited it; saturated problems (pe +0.006, popcount255 +0.000) fail it correctly |
| G4 | Screening validity (calibration) | sign of the fast-subset mean paired best-quality delta for the predeclared pair (classic vs `grid_quantile_pareto_journal_bd_unified_rebin_on` thought-only k=4, seed 42) agrees with the hard-subset seed-42 result; if either delta lies in (−0.02, +0.02) the comparison is inconclusive and the subset must be revised or the band widened explicitly |
| G5 | Stability (calibration) | same-pair verdict sign agrees across seeds 42 and 1001, with the same inconclusive band |

If any gate fails: adjust the subset by re-running the builder with
revised bounds (or pruning the offending problem), bump
`subset_name` to `fast_iteration_subset_v2`, and re-run the full gate
set. Never edit the locked file in place; never tune the subset on a
variant's results (only on instrument properties: speed, signal flow,
spread, and the fixed calibration pair).

## Decision bands for everyday use

Once the instrument is signed off, a pair's screening verdict comes from
the paired best-quality mean delta (`statistical_tests.json`):

- **PROMOTE** (variant ≥ +0.02): graduate the change to the hard subset.
- **DEMOTE** (variant ≤ −0.02): reject or rework the change.
- **INCONCLUSIVE** (between): escalate to the hard subset — with 6
  problems and 1 seed the instrument cannot resolve small effects, and
  over-reading it is exactly the failure the bands prevent.

Verdicts are screening signals only and never enter publication evidence
or the branch-decision table.

## Calibration protocol and current status

1. Run the calibration pair (classic vs the QD primary target) at seed 42
   under the recommended budget; check G1–G3 with the pair validator.
   *Status: first pair (pop 10) ran 2026-06-12 and exposed an engine
   constraint (population must be divisible by k=4); corrected pop-12
   pair in flight.*
2. When the hard-subset seed-42 reproduction (QD-repair workstream)
   lands, evaluate G4 against it. *Status: pending the hard-subset run.*
3. Run the calibration pair at seed 1001 for G5. *Status: pending.*
4. Record gate reports and the signoff (or revision) decision in the
   revamp history; only then do PROMOTE/DEMOTE verdicts count.

Observed so far (pop-10 pilot, classic arm only — the QD arm of that
pilot crashed on the divisibility constraint, so these are
collection-path readings, not gate evidence): arm wall 4159 s (within
G1a), but the pair validator run against the pilot fails G1b/G2/G3 —
`Prob108_rule90` alone accounts for ~100% of arm wall (prune candidate),
`Prob016_fixed_point_adder` and `Prob108_rule90` produced fewer than 6
valid-PPA candidates, and only one problem cleared the 0.02 IQR floor at
the pilot's 10-candidate populations. Decision rule: wait for the
corrected pop-12 pair, re-run the validator, then either sign off v1 or
cut `fast_iteration_subset_v2` (likely: replace `Prob108_rule90` with the
next eligible VE sequential problem by the deterministic rule, and
re-examine `Prob016_fixed_point_adder`'s PPA flow). Threshold
recalibration (e.g., the 0.02 IQR floor against observed quality scales)
is allowed at v2 only with the rationale recorded — never after the
instrument is signed off.
