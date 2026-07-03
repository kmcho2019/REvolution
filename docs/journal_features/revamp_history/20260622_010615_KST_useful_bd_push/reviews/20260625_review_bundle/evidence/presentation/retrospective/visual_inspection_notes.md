# Retrospective Visual Inspection Notes

Date: 2026-06-22 UTC.

## Inspected Figures

- `retrospective_source_coverage.png`: clear three-source coverage comparison.
  The ASP-DAC release dominates the candidate and PPA artifact counts, which
  supports using it as the main retrospective source.
- `retrospective_gate_status.png`: readable gate labels and status colors.
  The x-axis is labeled as problem-group coverage so bar length is not confused
  with failure severity. The figure makes the negative utility result visually
  obvious while keeping the D6 descriptive pass visible.
- `retrospective_replay_tradeoff.png`: readable policy labels. The left pane
  shows that diversity oracles barely improve HV over best-fitness retention,
  while the right pane shows that style diversity increases clusters without a
  matching utility jump.
- `retrospective_qwen_replay_delta.png`: readable positive and negative bars.
  It clearly shows that identifier-normalized Qwen is mildly positive but
  below the promotion threshold, while raw Qwen and random are negative.
- `retrospective_early_diversity_vs_final_hv.png`: readable scatter with rho
  annotation. It conveys weak association and high variance.
- `retrospective_cluster_case_study.png`: readable RTLLM case study after
  switching to a log power axis and coloring front points by implementation
  style. It is a 2D area-power projection of an active PPA-space front, so it
  supports the limited message that style is visible but not sufficient as a
  causal descriptor. Tiny deterministic marker offsets separate overlapping
  front-style markers without changing the underlying table.

## Decision

The figure set is acceptable for the scoped retrospective subsection. The
figures support a diagnostic/illumination claim, not a standalone active-QD
utility claim.
