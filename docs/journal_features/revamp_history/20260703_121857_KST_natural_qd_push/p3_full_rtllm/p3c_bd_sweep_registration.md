# P3c Suite-Scale BD Sweep — Registration (2026-07-04, user-directed)

Purpose: complete the descriptor characterization at suite scale. The
current coverage-vs-HV finding rests on two suite points (trio,
gt3d); the user directs a uniform sweep of the notable BD variants on
full RTLLM. The decisive falsification test: if the RANDOM floor also
buys coverage at suite scale, gt3d's coverage edge is not semantic.

## Protocol (registered before results)

- Uniform **2 seeds per arm (1001+1002)**, matching gt3d's existing
  suite baseline, giving one comparable n=2 sweep table across ALL BD
  variants. No arm completes to 5 seeds without a new registration.
  Reads are CHARACTERIZATION co-primaries: mean HV, canonical AUC46,
  per-seed coverage; no promotion claims from this sweep (the +5%
  question is settled at 5 seeds for the trio).
- Arms (single descriptor-profile factor on the pinned V2 platform,
  full 50-problem RTLLM command as P3):
  1. `size_control_3d` (structural bar).
  2. `random_hash_3d` (falsification floor).
  3. `source_aligned_shape_density_3d` (T73 axes; transparent
     operator-graph/wire/DFF topology; probe recorded).
  4. `theory_grounded_compact_8d` on **CVT** (8-D axes; grid-quantile
     not meaningful at 8-D/16 cells) with `qd_cvt_warmup_successes 4`
     (the June-18 YAML value), PLUS the paired `trio_cvt` control
     (trio axes on the same CVT config) — descriptor effect attributed
     from compact8d-vs-trio_cvt, archive-geometry effect from
     trio_cvt-vs-V2(grid).
- compact_8d probe adjustment (versioned): the wave-2 sampled-probe
  requirement is satisfied live-first (the lifted-quarantine
  precedent): metadata probe recorded now; seed-1001 runs first and
  its per-problem `descriptor_health.json` (extraction success on all
  problems, collapse states) gates seed 1002. Extraction failure on
  any problem kills the arm at one seed.
- gt3d: existing 2 suite seeds stand; NOT re-run (uniform n=2 already
  satisfied); its registered HV kill is unaffected.
- Pairing per `../tables/concurrency_policy.md` (two runs at a time);
  per-run preflights; standard packaging chain + operator audit +
  config-pinned validation per seed; jackpot decomposition noted in
  the sweep read.

## Budget

10 runs (~9 h endpoint time in pairs): size/random/shape_density
pairs, then compact_8d+trio_cvt seed 1001, then (health-gated) their
seed 1002. Comparators fully reused (classic + trio-V2 + gt3d suite
packages).

## Output

`bd_scoreboard.md` gains a uniform suite-sweep section; the coverage
claim is upgraded, downgraded, or falsified by the random floor's
suite behavior.
