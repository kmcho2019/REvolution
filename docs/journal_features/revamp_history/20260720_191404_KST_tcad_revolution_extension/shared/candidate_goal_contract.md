# Candidate Goal Contract

Every candidate goal must produce a scientific decision, not merely code or a
positive-looking metric.

## State Model

Progression states:

`PROPOSED -> READY -> IMPLEMENTED -> SMOKE_VALIDATED -> SUITE_EVALUATED`

After `SUITE_EVALUATED`, a nominated finalist enters `CONFIRMING`; otherwise it
receives a terminal outcome. Proposal review may move `PROPOSED` directly to
`RETIRED`, and a named external resource may move any state to `BLOCKED`.

Terminal outcomes:

`PAPER_CANDIDATE | VIABLE | RETIRED | BLOCKED`

Do not invent intermediate or ambiguous states. A candidate goal ends only when
one terminal outcome is written to `decision.md`.

## READY Gate

A candidate becomes `READY` only when its frozen hypothesis card contains:

- one evidence-backed conference weakness;
- one falsifiable mechanism and explicit non-goals;
- hardware/CAD or evolutionary-search rationale;
- current related-work delta and strongest novelty objection;
- natural-extension score with no hard rejection;
- one-factor classic comparator and mechanism control;
- mechanism telemetry and expected causal signature;
- exact code boundary and complexity budget;
- frozen smoke, suite, and retirement rules;
- matched budgets, benchmark roles, seeds, and missing-result policy;
- one control-inclusive stage-total worksheet below every frozen candidate
  resource ceiling;
- dispositions for independent scientific and methodology reviews.

Use `hypothesis_card.template.md`. Proposal review may retire a candidate without
implementation; record that decision in the portfolio and history.

## Required Outputs

- frozen hypothesis card and natural-extension review;
- minimal method specification;
- isolated implementation and focused tests;
- classic-core hash and complete diff audit;
- frozen experiment manifest for every stage;
- smoke and full-suite reports reached by the candidate;
- raw artifacts and reproducible report commands;
- mechanism analysis, paired statistics, and failure accounting;
- `decision.md` with one terminal outcome;
- methodology-ready description, limitations, and allowed claim wording;
- internal review dispositions and external review records when available;
- updated program history, negative map, claim ledger, and portfolio row.

## Iteration Policy

1. Establish the exact paired classic baseline.
2. Implement the smallest mechanism-complete version.
3. Prove tests, logs, budget accounting, and code isolation before live spend.
4. Run one technical smoke for execution and catastrophic failures.
5. Omit the representative probe under the prospective Wave-2 contract.
6. Advance a sound, non-catastrophic mechanism directly to the frozen two-seed
   full-suite probe.
7. Permit at most two mechanism-preserving revisions across the candidate.
8. Confirm only a nominated finalist with five preregistered seeds disjoint from
   development and one disjoint holdout.
9. Decide and update the program portfolio before any new candidate starts.

A revision must answer a measured failure mechanism without changing the core
hypothesis. Nearby parameter values, added fallbacks, combined mechanisms, or
benchmark-specific conditions are not valid revisions. They require a new card
or retirement.

## Stage Gates

### Code Gate

- classic engine and control configuration remain unchanged;
- one explicit typed treatment mode, no optional hidden states;
- no defensive fallback or backward-compatibility layer;
- required inputs assert and unknown discriminants fail;
- focused tests, determinism, and telemetry checks pass;
- an independent reviewer finds no unrelated refactor or bloat.

### Smoke Gate

- every expected artifact is emitted and parsed;
- candidate and classic budgets reconcile;
- the mechanism is active and visible in telemetry;
- no preregistered catastrophic functionality or PPA failure occurs.

The smoke cannot provide positive performance evidence.

### Representative Gate

This historical Wave-1 stage is omitted in Wave 2. Reintroducing it requires a
prospective claims-contract and worksheet revision before candidate treatment
evidence; a candidate card cannot opt into it.

### Full-Suite Gate

- every frozen reference-complete unit is accounted for;
- missing treatment outputs count as method failures;
- final HV, HV-AUC, functionality, valid-PPA, yield, W/L/T, uncertainty,
  per-problem deltas, calls, tokens, and synthesis evaluations are reported;
- seed direction and concentration of gains are disclosed;
- every per-seed practical margin is evaluated independently unless the frozen
  contract explicitly defines an aggregate gate;
- cumulative smoke and full-suite resources include all mandatory classic and
  treatment arms and remain under every candidate ceiling;
- a post-run audit checks that reporter logic exactly translates the governing
  contract rather than relying on the generated outcome label;
- an independent evidence reviewer checks raw artifacts and report commands.

A terminal `VIABLE` result requires this full-suite gate.

## Terminal Outcomes

- `PAPER_CANDIDATE`: satisfies its role-specific confirmation and holdout gates
  from `../program_claims_contract_v4.md` for Wave 2.
- `VIABLE`: passes the full-suite viability definition in the claims contract.
- `RETIRED`: review or evidence rejects the mechanism before or after
  implementation.
- `BLOCKED`: a named external resource prevents the decision; the decision file
  states exactly what evidence would unblock it.

Never upgrade `VIABLE` to `PAPER_CANDIDATE` by combining it with another near
miss. Integration begins only from independently supported evidence.
