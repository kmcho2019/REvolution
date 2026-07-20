# Candidate Hypothesis Card Template

Status: `PROPOSED`

## Identity

- Candidate ID:
- Short name:
- Candidate class: `CORE_CORRECTION | HARDWARE_EXTENSION | AUGMENTATION`
- Intended paper role: `PRIMARY_ALGORITHM | RELIABILITY | GENERALIZATION`

## Conference Weakness

- Conference component:
- Exact classic code/config path:
- Conference claim:
- Evidence that the component is `UNPROVEN` or `LIMITING`:
- Why leaving it unchanged matters:

## Falsifiable Hypothesis

One sentence stating treatment, matched classic control, expected primary
effect, and functionality constraint.

## Mechanism And Rationale

- Single mechanism:
- Hardware/CAD or evolutionary-search basis:
- Expected causal chain:
- Mechanism telemetry and expected signature:
- Explicit non-goals:

## Novelty And Naturalness

- Closest current work:
- Exact REvolution-specific delta:
- Strongest reviewer objection:
- Natural-extension score:
- Hard-rejection audit:

## Minimal Implementation

- Experimental module and typed mode:
- Classic files that must remain byte-identical:
- New required state:
- Public knobs and frozen values:
- Lines/modules expected to change:
- Removal boundary if retired:

## Controls

- Matched classic arm:
- Mechanism control or shuffled/null arm:
- Factors held constant:
- Missing-treatment policy:
- Development and confirmation seed-role manifests:
- Statistical protocol and practical margins:

## Validation Ladder

### Technical Smoke

- Manifest/design classes:
- Seed/budget:
- Catastrophic stop rule:

### Representative Probe

- Baseline-only selection rule and manifest hash:
- Seeds/budget:
- Registered metrics and mechanism checks:

### Full-Suite Probe

- Suite/manifest:
- Seeds/budget:
- `VIABLE` gate:
- `RETIRED` gate:

### Confirmation And Holdout

- Five-seed confirmation gate:
- Disjoint holdout:
- `PAPER_CANDIDATE` gate:

## Risks And Interpretation

- Expected failure modes:
- Result that would falsify the rationale:
- Scope of an allowed positive claim:
- Negative result value:

## Review Dispositions

| Review | Reviewer/artifact | Finding | Disposition |
| --- | --- | --- | --- |
| Conference-method | | | |
| TCAD novelty | | | |
| Hardware/EDA methodology | | | |
| Statistics/reproducibility | | | |
| Code simplicity | | | |
