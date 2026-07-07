# P3 Five-Seed Verdict (2026-07-03/04)

V2 (promotion arm) vs the reused classic 5-seed full-suite roots, 46
reference-complete RTLLM designs, seeds 1001-1005, all operator
contracts and config-pinned validations green, per-seed preflights
recorded. The classic recompute reproduces the pinned 5-seed baseline
exactly (0.103802 vs pinned 0.10380).

## Numbers

| Seed | classic HV | V2 HV | ratio | classic AUC46 | V2 AUC46 | cov C | cov V2 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1001 | 0.111401 | 0.096767 | 86.9% | 0.090551 | 0.083539 | 33 | 32 |
| 1002 | 0.097557 | 0.100310 | 102.8% | 0.081183 | 0.090753 | 33 | 33 |
| 1003 | 0.102093 | 0.099854 | 97.8% | 0.087210 | 0.090295 | 33 | 35 |
| 1004 | 0.103555 | 0.101008 | 97.5% | 0.089027 | 0.086425 | 32 | 33 |
| 1005 | 0.104404 | 0.096063 | 92.0% | 0.086940 | 0.086125 | 33 | 33 |
| mean | 0.103802 | 0.098801 | **95.2%** | 0.086982 | **0.087428 (100.5%)** | 164 | **166** |

Contract-form statistics (interim implementation of the frozen
formula — per-unit log((HV_t+1e-9)/(HV_b+1e-9)), problem-clustered
bootstrap, 10k resamples, seed 7777; the canonical
report_journal_statistics.py run is a P4 item):
mean log-ratio +0.0298 (gate: >= log(1.05)=0.0488 with CI low > 0);
95% CI [-0.729, +0.764]; pooled unit W/L/T 37/44/149.

## Verdict against the frozen gates

- The +5% HV log-ratio gate FAILS at full-suite scale (mean below the
  bar; CI includes zero widely). REF_WIN and REF_PARITY (which
  requires the HV gate) both fail -> the full-suite QD-WIN headline is
  not available; the frozen branch mapping points to the
  characterization regime.
- Functionality: V2 coverage 166 vs classic 164 (and >= classic on
  4/5 seeds) — the QD validity tax of the June arms is ABSENT;
  HV-AUC ties (100.5%).

## The two-scale story (the push's actual finding)

1. Screening scale (8 small/mid designs, 3 seeds, operator-fair): the
   natural QD extension WINS decisively — +12.9% HV, +16.2% HV-AUC,
   3/3 seeds, coverage kept (`../p0_v2_anchor/`). First replicated
   operator-fair QD win in the program.
2. Full-suite scale (46 designs, 5 seeds): parity — HV 95.2% with the
   gap concentrated in single-problem jackpots (seed-1001 edge_detect
   alone ~80% of that seed's gap), AUC tied, coverage edge to V2.
   Consistent with the F18-F32 finding that suite-scale outcomes are
   LLM-capability-bound: where the model can solve, archive+NSGA-II
   search wins; where it cannot, no selection scheme manufactures
   valid designs.
3. Both directions rest on clean operator parity — the June negative
   map's contamination is the artifact that hid (1).

## Consequences

- Journal posture: characterization with a positive, replicated,
  scale-scoped win + the contamination forensics + the no-cost
  full-scale overlay result (stronger than June's Branch C in all
  three legs). Branch-B utility-metric analysis over the V2/N03b
  archives is the remaining upside at full scale (registered N03b
  property: better front breadth).
- Registered follow-up lanes remain non-blocking. N04 depth was measured
  on 2026-07-07 and does not escalate (HV 101.1%, HV-AUC 90.5% at 6x7);
  N02b/N07 and descriptor diagnostics remain open only with fresh
  pre-registration.
