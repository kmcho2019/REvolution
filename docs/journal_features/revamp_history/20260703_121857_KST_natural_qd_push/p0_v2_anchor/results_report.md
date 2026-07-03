# P0 V2 Anchor — 3-Seed Result: V2 BEATS CLASSIC ON THE SCREEN

Date: 2026-07-03. Arm: `smooth_qd_v2_8x5` (faithful V2 platform,
`tables/v2_platform_config.md`), frozen 8-design 8x5 screen,
operator-fair vs reused classic roots, seeds 1001/1002/1003.

## 3-Seed Verdict (pre-registered screening gates)

`tables/three_seed_summary.csv` (scripted from the per-seed packages):

| Seed | classic HV | V2 HV | ratio | classic HV-AUC | V2 HV-AUC |
| --- | --- | --- | --- | --- | --- |
| 1001 | 0.140645 | 0.173764 | 123.5% | 0.123874 | 0.143660 |
| 1002 | 0.159369 | 0.171800 | 107.8% | 0.129963 | 0.151323 |
| 1003 | 0.132531 | 0.142943 | 107.9% | 0.111402 | 0.129256 |
| mean | 0.144182 | 0.162835 | **112.9%** | 0.121746 | **0.141413 (+16.2%)** |

- Promote gate: 3-seed mean HV >= classic (0.16284 vs 0.14418, +12.9%)
  PASS; 3-seed HV-AUC >= classic (+16.2%) PASS; coverage retained 8/8
  on every seed for both arms PASS.
- **3/3 per-seed HV wins** — including classic's best seed (1002) —
  the exact replication bar that killed every prior QD arm (T83,
  aux-archive, PCN-v3 all went 0/3 or failed 5-seed).
- Per-seed operator contracts and run validations all pass
  (`replication/seed_100{2,3}/operator_contract.csv`,
  `run_validation.json`); zero single-thought, zero M-T candidates.
- Classic recomputes reproduced the pinned per-seed baselines exactly
  (0.14064478405974706 / 0.15936940200276137 / 0.13253100841854415) —
  the reused-baseline verification is complete for all three screen
  roots.
- Front breadth is seed-dependent, not uniformly worse: Pareto points
  2.625/2.0/3.125 vs classic 3.25/2.125/2.875.

**Result statement (scoped):** on the frozen 8-design 8x5 screen with
seeds 1001-1003, the faithful Smooth-QD V2 platform — the natural
MAP-Elites extension of classic REvolution (unchanged EoH operators
and (thought, code, feedback) individuals; grid-quantile archive over
the frozen BD trio; bounded per-cell Pareto fronts; NSGA-II global
parent selection; champion refinement) — beats classic REvolution on
mean PPA hypervolume (+12.9%) and canonical HV-AUC (+16.2%) with
functionality retained on every design. This is a screening-scale
result; the frozen-contract claim gates (full RTLLM, 5 seeds, cluster
statistics, +5% log-ratio CI) remain to be run (P3).

## Promotion-arm decision rule (registered 2026-07-03, before any P1 read)

The P3 full-RTLLM promotion arm is V2 itself, unless a P1 lane beats
V2 on 3-seed screening mean HV AND HV-AUC by more than +2% relative
with coverage retained — in which case that lane (single factor only,
no unregistered combinations) becomes the promotion arm. This rule is
fixed now to prevent post-hoc arm shopping.

## Seed-1001 detail (historical, superseded by the 3-seed table)

## Headline (seed 1001 only)

| Metric | classic | smooth_qd_v2 | delta |
| --- | --- | --- | --- |
| mean global PPA HV | 0.14064478405974706 | 0.17376375275693837 | +23.55% rel |
| mean HV-AUC (canonical) | 0.123873865 | 0.143659910 | +15.97% rel |
| covered designs (>=1 valid PPA) | 8/8 | 8/8 | tied |
| mean Pareto points | 3.25 | 2.625 | -0.625 |
| mean reference-beating count | 8.0 | 7.875 | ~tied |
| per-problem HV W/L/T (V2 view) | - | 3W/2L/3T | - |

Per-problem HV: V2 wins fsm (0.3406 vs 0.1447), traffic_light (0.4084
vs 0.3101), gshare (0.00085 vs 0.00035); ties multi_pipe (0), m2014_q3
(identical 0.39842), m2014_q6b (0); loses alu (0.2318 vs 0.2524) and
signal_generator (0.0100 vs 0.0192).

## Gates and audits (all green)

- Operator contract (`tables/operator_contract.csv`):
  `single_thought_count=0` both arms; V2 emitted 166 EoH-suite
  candidates, 0 `M-T`, 0 other.
- Run validation (`tables/run_validation.json`): pass, 0 errors.
- Classic recompute reproduced the pinned baseline exactly
  (0.14064478405974706) — the reused-baseline verification for the
  seed-1001 screen root is complete.
- HV-AUC computed by the shared canonical path
  (`scripts/report_hv_auc.py`, `tables/hv_auc.csv`).

## Figure inspection notes (direct raw PPA gate)

- `pareto_analysis/problems/RTLLM/Prob024_fsm/pairwise_fronts.png`:
  the V2 win is a genuinely dominating design (~+0.48 area / +0.71
  power improvement vs classic's best ~+0.37/+0.29 front) — front
  quality, not metric artifact. Inspected.
- `.../Prob045_alu/pairwise_fronts.png`: power axis saturated (~0.99);
  classic's best area improvement ~0.254 vs V2 ~0.234 — a small
  exploitation deficit on the heavy-exploit problem. Inspected.
- Cosmetic: pairwise figure titles collide with the legend box; fix in
  the shared plotting surface before any colleague-facing package (do
  not fork a package-local plotting script).

## Honest caveats

1. One seed at temperature 1.0; classic's own seed spread on this
   screen is 0.1325-0.1594 (seeds 1001-1003). V2 0.1738 exceeds
   classic's best seed, but the fsm jackpot (2.35x classic HV on one
   problem) is exactly the single-problem-dependence pattern that
   killed T83; the 3-seed read decides.
2. Mean Pareto points trail (2.625 vs 3.25): the known front-breadth
   deficit persists even in this winning read; N01a targets it.
3. This is the PLATFORM at screen scale, stronger than its 13-problem
   tuning-set reputation (parity); surface composition and
   strict_ablation evaluation differ from the June-12 matrix — do not
   retrofit this number onto the old tuning-set claims.
