# H3: Contract-Preserving Patch Evolution

Status: `RETIRED` at proposal review; no implementation or live spend.

## Conference Weakness

Whole-output success mutations may change interfaces, reset behavior, latency,
or protocol behavior even when the PPA optimization intent is local. The audit
must first quantify whether edit breadth predicts avoidable functional failure.

## Falsifiable Hypothesis

At equal budget, localized RTL patches constrained by a general machine-readable
design contract improve valid-PPA child yield or time to PPA
improvement without material final-HV loss versus full-output success mutation.

## Proposed Mechanism

- Derive ports, clock/reset signals, and immutable interface structure from
  existing RTL and evaluator metadata, without per-design annotations.
- Request one unified diff or similarly narrow edit from a success parent.
- Reject edits that exceed one frozen locality rule or violate the contract.
- Keep full repair in the fail population unchanged.
- Log changed lines/nodes, contract rejection, functionality, and PPA delta.

Do not build a new AST framework, retrieval system, transformation library, or
fallback ladder for the first implementation.

## Required Controls And Telemetry

1. classic full-output success mutation;
2. local patch mutation;
3. local patch mutation without contract rejection, if safe to isolate.

Measure changed descendants only, patch size, parse/compile/pass rates, contract
violations, equivalence outcomes, valid-PPA yield, and first improvement cost.

## Validation Posture

- Every claimed generated artifact must pass the frozen functional gate.
- Small paired-parent runs test locality and contract behavior only.
- A sound mechanism advances through representative and full-suite probes.
- This candidate is normally `VIABLE` supporting evidence unless it satisfies
  the role-specific `PAPER_CANDIDATE` gate and accompanies an independently
  supported algorithmic contribution.

## Retirement Conditions

Retire when patch size does not predict validity, edits are mostly cosmetic,
contract extraction requires per-design policy, locality blocks useful PPA
changes, novelty overlaps existing RTL rewriting systems, or allowed revisions
fail the frozen gates.

## Main Reviewer Risk

Local rewriting, AST templates, and formal validation already have extensive
related work. Evolutionary lineage alone may not provide sufficient novelty.
