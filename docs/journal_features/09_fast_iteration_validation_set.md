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

Population 10, 3 generations, `k=4` thought-only for QD arms,
`--max_tokens 128000 --diff_max_tokens 128000`, elastic
`--total_worker_slots 12 --max_active_problems 6
--max_workers_per_problem 4`, `strict_ablation` evaluation. That is ~240
candidate evaluations per arm (6 × (10 + 3×10)) — ~15% of the hard-subset
matrix cost — and because pass rates are high, nearly all of it produces
PPA signal.

Example commands (classic vs primary QD target):

```bash
python scripts/run_backend.py --backend revolution \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --problems Prob048_pe Prob016_fixed_point_adder Prob011_multi_16bit \
             Prob108_rule90 Prob021_mux256to1v Prob030_popcount255 \
  --model_name /models/openai-gpt-oss-120b --api_backend vllm \
  --population_size 10 --num_generations 3 --seed 42 \
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

## Future calibration

After the first few fast-subset runs, record observed wall-clock and
per-problem valid-PPA sample counts in the revamp history. If a problem
turns out to dominate wall-clock (slow synthesis) or saturate (every
candidate hits the same PPA point, no discrimination), replace it by
re-running the builder with adjusted bounds — and bump the subset version
rather than editing the locked file in place.
