# P0 V2 Anchor — Seed-1001 Result (NOT a verdict; 3-seed pending)

Date: 2026-07-03. Arm: `smooth_qd_v2_8x5` (faithful V2 platform,
`tables/v2_platform_config.md`), frozen 8-design 8x5 screen, seed 1001,
operator-fair vs the reused classic seed-1001 root. Runtime 1450 s.
Seeds 1002/1003 launched immediately after this read; no promotion or
verdict language is permitted until they land (single-seed rule).

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
