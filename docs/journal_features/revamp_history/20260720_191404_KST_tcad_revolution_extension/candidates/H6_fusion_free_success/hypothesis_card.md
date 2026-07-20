# H6: Fusion-Free Success Evolution

Status: `HISTORICAL_SUPPORT`; outside the prospective candidate state machine.

## Identity

- Candidate ID: H6
- Class: `CORE_CORRECTION`
- Intended role: `RELIABILITY`

## Hypothesis And Mechanism

The conference gives C-F qualitative credit but no isolated evidence. H6 removes
only the two-parent C-F success operator through the existing
`eoh_success_operator_set=one_parent` mode. All one-parent EoH operators, fail
operators, UCB, pools, selection, evaluator, and budgets remain matched.

The falsifiable hypothesis was that fusion-free success evolution improves
anytime HV or coverage without a material final-HV loss. It does not assert that
C-F is intrinsically harmful.

## Naturalness Review

- Continuity 2; evidence-backed need 2; hardware grounding 1; generality 2;
  mechanistic clarity 2; simplicity 2; novelty/paper value 1: **12/14**.
- No hard rejection applies. Its paper role is capped at supporting
  simplification because operator subtraction is not a primary algorithmic
  contribution.
- Closest basis is EoH's generic crossover/mutation portfolio. No related work
  makes an isolated REvolution C-F ablation novel by itself.

## Evidence

The five-seed 46-task canonical result is in `component_evidence_audit.md`:

- final HV `0.106846` versus `0.103802`, delta `+0.003044`, clustered CI
  `[-0.004214, +0.013837]`;
- HV-AUC `0.094729` versus `0.086982`, delta `+0.007747`, clustered CI
  `[-0.000467, +0.018882]`;
- valid PPA `166/230` versus `164/230`;
- RTL-simulation functionality `191/230` versus `188/230`;
- final-HV seed deltas have mixed signs and leave-one-seed-out sensitivity;
- calls differ by 2 and total tokens by 1.8%.

The treatment improves HV-AUC in seeds 1001 and 1002 and remains inside the
later-frozen practical margins. Those seed roles, margins, and the AUC gate were
assigned after these outcomes existed, so this result cannot receive a
prospective `VIABLE` classification. It remains useful retrospective component
evidence and does not satisfy a resolved primary final-HV claim.

## Reuse Boundary

Do not rerun H6 alone. An H5-plus-no-C-F interaction becomes eligible only after
H5 independently reaches `VIABLE` or better. Any interaction is a new
prospective experiment and must preserve a clean two-by-two attribution against
classic, H5, and the historical no-C-F mechanism.
