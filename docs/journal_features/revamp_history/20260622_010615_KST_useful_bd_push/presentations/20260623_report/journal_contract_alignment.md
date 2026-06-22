# Journal Contract Alignment

Status: diagnostic milestone only. This file maps the one-seed full RTLLM
package against the accepted `docs/journal_features/journal_narrative.md`
claims contract.

## Bottom Line

The current full RTLLM package is useful for method triage and presentation
discussion, but it is not final TCAD claim evidence. It should be described as
`diagnostic` because it does not satisfy the frozen final-evidence scale,
statistics, held-out contamination rules, or paired-PPA gates.

## Contract Map

Authority:
`journal_narrative.md` is the accepted claims contract and wins on conflict.
The package now references that contract and treats local claim gates as
diagnostic scaffolding. Verdict: aligned.

RTLLM scale:
The frozen requirement is a 13-problem hard/tuning set plus a 20-problem
held-out set. The current package uses all 50 RTLLM problems without labeling
the frozen tuning/held-out split. Verdict: not final-gate eligible.

Seeds:
Final evidence uses seeds `1001` through `1005`. The current package uses seed
`1001` only. Verdict: diagnostic only.

Held-out contamination:
Held-out reference-PPA units must not be touched by repair or tuning. `Prob013`,
`Prob018`, and `Prob040` were repaired with default-reference handling after the
first full run. No held-out claim may use those repairs until the frozen split
is resolved. Verdict: not final-gate eligible.

Reference data:
Reference-normalized PPA claims require valid reference data and disclosed
missing-data treatment. `Prob040_synchronizer` uses a defaulted reference and
carries the aggregate HV/HV-AUC sign. It must be quarantined or rerun with a
benchmark reference before headline gating. Verdict: blocker for a positive
claim.

Gate statistic:
The contract requires penalized cluster-bootstrap mean log-HV ratio,
best-quality and avg-PPA gates, sign-test win rate, and zero-HV counts. The
current package reports mean HV/HV-AUC, front counts, best score, and validity
gates, but no final `journal_stats` gate. Verdict: diagnostic only.

Paired PPA evidence:
Aggregate-only wins are insufficient. Per-problem HV is `4` QD wins, `15` QD
losses, and `31` ties. Prob040-excluded mean HV delta is `-0.009465`. Verdict:
fails the useful-QD gate.

Scalar quality:
Best-quality scalar remains a required sanity and gate metric. All-RTLLM mean
`best_score` is lower for exact T26 (`-0.798824` versus `0.260455`). Verdict:
fails a positive claim.

Budget:
Candidate evaluations are the matched axis; LLM calls and tokens are reported,
with asymmetry flagged. Candidate count is matched (`2400` each), and LLM calls
are matched (`4801` versus `4800`). Token details are in
`full_rtllm/tables/full_budget_parity.csv`. Verdict: diagnostic budget aligned.

Candidate pools:
Gate-bearing HV and Pareto-cardinality use full evaluated successful-candidate
history. Candidate-level PPA data is packaged, but final gate extraction parity
is not certified by `journal_stats`. Verdict: needs the final pipeline.

Duplicate and family evidence:
Duplicates cannot count as useful diversity, and semantic family dominance
needs stronger evidence. The family-proxy audit rejects duplicate collapse, but
front-family/netlist counts equal the front-point count when
`front_family_ratio=1.0`. Verdict: diagnostic only.

Branch decision:
Branch A/B/C is decided after held-out/fresh 5-seed finals. The current result
cannot trigger Branch A or B. If treated as final evidence it would fall below
`REF_WIN` and `REF_PARITY`, but it is not final-gate eligible. Verdict: no
branch claim.

## Presentation Rule

Use this wording:

> The one-seed RTLLM result is a diagnostic front-signal package. It preserves
> classic-covered problems and adds front points, but it does not prove QD
> usefulness under the frozen journal contract.

Avoid this wording:

> QD/MAP-Elites beats classic on RTLLM.

## Required Next Evidence

- Freeze the contract-aligned RTLLM hard/tuning and held-out split before any
  next final-style run.
- Run seeds `1001` through `1005` or explicitly keep the result outside final
  claim gates.
- Quarantine default-reference problems from headline HV, or add real benchmark
  reference PPA before using them in reference-normalized claims.
- Run the `journal_stats` penalized cluster-bootstrap/sign-test gates.
- Report `best_score`, avg-PPA, HV log-ratio, win rate, valid-PPA count,
  zero-HV units, and token/candidate budget parity together.
- Add the duplicate-synthesis determinism check and equivalence spot checks
  required by the measurement model before showcasing candidates.
