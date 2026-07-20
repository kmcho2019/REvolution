# H3 Hypothesis Card: Contract-Preserving Patch Evolution

## Falsifiable hypothesis

Restricting success-population mutations to localized, contract-checked RTL
patches increases hardened valid-PPA yield and HV-AUC without final-HV
regression compared with full-file rewrites.

## Conference limitation addressed

Whole-design rewrites can introduce interface, reset, latency, and protocol
regressions even when the optimization intent is local.

## Novelty warning

Proceed only after a related-work audit distinguishes this from existing
symbolic/AST-template and formal/localized RTL-repair systems. The intended
REvolution-specific delta is evolutionary patch lineage, PPA-conditioned patch
selection, and integration with the dual success/fail populations.

## Proposed mechanism

- Define a typed design contract: ports, reset semantics, latency class, and
  protected state/interface signals.
- Request a unified diff or AST-local edit from success-population parents.
- Reject patches that exceed the allowed locality or violate the contract.
- Use full repair only in the fail population.
- Measure patch size, contract rejection, functional preservation, and PPA gain.

## Smallest decisive screen

Paired-parent experiment on 6 designs:

1. full-file success mutation;
2. local patch mutation;
3. local patch mutation without contract enforcement.

## Promotion gate

- hardened valid-PPA child rate improves by at least 20% relative;
- final HV is within 1% of classic/full rewrite;
- HV-AUC improves or LLM calls to first PPA improvement decrease;
- contract enforcement materially reduces hidden/equivalence failures.

## Retirement gate

Retire if local patches are mostly cosmetic, final HV falls by more than 3%, or
novelty cannot be clearly separated from related work.

## Existing code path

Start from the success-population mutation interface and evaluation harness.
Avoid a large AST rewrite framework unless the smallest diff-based version
passes the screen.
