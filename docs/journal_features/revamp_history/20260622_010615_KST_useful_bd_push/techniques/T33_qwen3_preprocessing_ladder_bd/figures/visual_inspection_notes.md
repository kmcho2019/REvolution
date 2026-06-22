# T33 Visual Inspection Notes

Inspection date: 2026-06-22 UTC.

## `t33_raw_area_power_pareto_front.png`

- Pass. The figure shows raw area on x and raw power on y, with lower-is-better
  labels on both axes.
- Pass. It uses two panels: the full valid-PPA range and a lower-left Pareto
  zoom for `Prob018_float_multi`, the richest valid-PPA group selected by
  unique PPA/front richness.
- Pass. The all-valid candidate cloud and all-valid Pareto front are visible.
  Lexical, random, canonical Yosys-netlist, and summary-plus-netlist selected
  points are overlaid with distinct colors.
- Caveat. The plot is representative, not exhaustive. The aggregate direct
  front counts live in `tables/t33_ppa_front_metrics.csv`.

## `t33_hypervolume_by_view.png`

- Pass. The lexical baseline is marked with a vertical dashed line.
- Pass. The ordering makes the main replay result visible: canonical RTL,
  identifier-role RTL, and commentless RTL beat lexical on selected
  hypervolume; the two netlist views do not.

## `t33_duplicate_and_motif_counts.png`

- Pass. Canonical-netlist and motif-signature uniqueness are readable for all
  representations.
- Caveat. The uniqueness count is supporting evidence only. It does not
  override the selected-HV and direct PPA-front metrics.
