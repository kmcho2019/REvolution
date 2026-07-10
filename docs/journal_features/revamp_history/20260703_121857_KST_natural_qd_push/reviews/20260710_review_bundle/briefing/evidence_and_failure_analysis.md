# Evidence And Failure Analysis

## Was The QD Push Successful?

It depends on the claim.

| Question | Answer |
| --- | --- |
| Did the push find an operator-fair QD method that beats classic on a small screen? | Yes. V2 wins 3/3 screen seeds. |
| Did QD improve a useful full-suite metric? | Yes. V2/S07 improve HV-AUC or coverage, and V2 utility is 0.413. |
| Did any QD variant beat classic final HV on five-seed full RTLLM? | No. |
| Did the frozen +5% HV log-ratio gate pass? | No. |
| Is S07 strong enough to headline the journal extension? | No. It is the strongest supporting near miss. |
| Did the campaign produce a useful scientific result? | Yes. It produced an operator-fair negative map and isolated the useful Pareto mechanism. |

The campaign succeeded as research and failed as the originally targeted
headline method.

## Evidence Hierarchy

1. Five-seed full RTLLM results are decision-grade for this campaign.
2. Two-seed full-suite probes are triage evidence.
3. One-seed full-suite runs are technical or catastrophic-stop evidence.
4. Eight-design screens are mechanism/debug evidence only because transfer is
   weak.
5. June-22 single-thought QD runs are contamination forensics, not method
   evidence.

## What Partly Worked

- Smooth integration matters. Direct-code individuals with EoH operators
  avoid the large loss caused by thought-only regeneration.
- Global NSGA-II selection improves V2 over V1 by `+0.018`, with a confidence
  interval entirely above zero in the earlier five-seed 13-problem tuning
  ablation. Full-suite isolation remains an open test.
- S07 capacity3 improves full-suite HV-AUC and coverage while nearly matching
  classic final HV.
- S07 produces clear positive problem cases. On `Prob015_multi_pipe_8bit`,
  it recovers reference-beating coverage on 3/5 seeds where classic has 0/5.
  On `Prob024_fsm`, it improves both final HV and trajectory while retaining
  5/5 coverage.
- The QD archive exposes engineer-useful alternatives even when the best
  scalar quality is tied. V2's contract-defined utility is 0.413.

## Why Final HV Did Not Win

| Failure mechanism | Evidence |
| --- | --- |
| Descriptor tax | Profile and geometry changes alter health/coverage but do not produce a classic-beating HV tier. |
| Per-cell retention tax | Globally useful candidates can compete for bounded local slots; S07 helps but S32 shows capacity interpolation is unstable. |
| Parent-selection entropy | Front-slot, curiosity, and cell-crowded variants often trade final quality for exploration or trajectory. |
| Fragile yield | Several negative arms generate fewer valid-PPA candidates, leaving less material for the final front. |
| Capability ceiling | Large modules have no valid starting candidates, so QD preserves diverse wrong designs rather than useful stepping stones. |
| Jackpot variance | A few high-HV problems dominate seed and suite means; seed 1005 reverses the apparent S07 headline. |

S23 is the clearest warning against optimizing an archive-health proxy. It
reduces collapsed archives from 24/50 to 4/50 but reaches only 75.8% of
classic final HV. Archive geometry is not the missing objective.

## Why S07 Is A Near Miss, Not A Win

S07 has a coherent mechanism: reducing per-cell capacity from five to three
keeps compact local Pareto material and can improve trajectory. The five-seed
aggregate is still below classic final HV, the seed-paired tests are
non-significant, and S32 capacity4 fails at 86.3% of matched classic on seed
1001. The result supports the statement "compact retention can help," not
"capacity3 dominates classic REvolution."

## What Should Be Retired

- More capacity, warmup, front-slot, or 2D descriptor scans without a new
  mechanism.
- Learned or hybrid descriptors as a primary HV path unless a separate
  extraction and causal gate justifies them.
- PCN-style stagnation, credit, activation, or front-gap threshold stacks.
- Fixed exploit/explore multi-emitter QD as the next run. Its ingredients
  have already been tested through parent-source and retention controls.
- Any narrative that promotes HV-AUC to the primary metric after final HV
  failed. HV-AUC remains an anytime-search secondary metric.

## Manuscript Consequence

The existing accepted QD narrative cannot silently absorb a new method. If
the project reopens, preserve revision 3 as the historical contract and write
a versioned claims addendum before new evidence runs. Reuse its measurement,
budget, missing-data, and statistical rules unless a change is explicitly
reviewed and registered.
