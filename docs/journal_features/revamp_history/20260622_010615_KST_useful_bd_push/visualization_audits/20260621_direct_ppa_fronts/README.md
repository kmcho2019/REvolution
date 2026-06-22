# Direct PPA Front Visualization Audit

This audit fills the live-result visualization gap: the T24-T27 packages had
good aggregate bars and QD/archive summaries, but did not put the actual
area-power Pareto/front scatter plots in one obvious place.

## Scope

Source runs:

- `T24_sr_pareto_live_validation`: Classic, Manual BD, Random, SR-RFF, SR ReLU,
  and SR raw.
- `T25_guarded_sr_raw_pareto_qd`: Guarded SR raw.
- `T26_sr_raw_conservative_exploit_qd`: Conservative exploit.

Problems:

- `Prob045_alu`
- `Prob041_traffic_light`
- `Prob015_multi_pipe_8bit`

## Terminology

- **PPA candidate**: a generated RTL candidate with valid synthesis/OpenROAD
  area, power, and optional clock-period metrics recorded in the live run log.
- **Active objectives**: area and power for combinational references; area,
  power, and `eff_clk_period` when the reference clock objective is nonzero.
- **Raw area-power front**: candidates not dominated by another candidate from
  the same method and problem using raw area and raw power only. Open circles
  in the raw area-power plots mark this front, and lower-left is better.
- **Active-objective front**: candidates not dominated under the active
  objectives. For `Prob015_multi_pipe_8bit`, this includes clock period.
  Open circles in the improvement plots mark this front.
- **Reference-beating candidate**: candidate with no active objective worse
  than the reference and at least one active objective better.
- **Candidate zoom**: raw area-power view that omits the reference star from
  the axis limits so the candidate-level front geometry remains readable.

These are candidate-level plots. They intentionally do not collapse duplicate
PPA tuples, RTL hashes, netlist hashes, or cell-family hashes. Use
`../../techniques/T28_t26_family_audit/` for canonical/family duplicate
accounting.

## Main Read

The clearest figures are:

- `figures/live_key_ppa_fronts_area_power_zoom.png`: direct raw area-power
  front shape for Classic, Manual BD, Random, SR raw, and Conservative exploit
  on conventional non-inverted axes.
- `figures/live_key_ppa_fronts_improvement.png`: normalized improvement view
  where up/right is better and the reference is at `(0, 0)`.
- `figures/live_front_count_summary.png`: candidate-level front-point and
  reference-beating counts by problem.

The front-shape evidence reinforces the current blocker. Conservative exploit
recovers strong best-PPA pressure, especially on `Prob045_alu` and
`Prob015_multi_pipe_8bit`, but it does not illuminate as broad an
active-objective PPA front as Classic. On `Prob015_multi_pipe_8bit`,
Conservative exploit has 2 raw area-power front points and 6 active-objective
front points, SR raw has 2 raw area-power front points and 10 active-objective
front points, and Classic has 4 raw area-power front points and 14
active-objective front points. That is why the next live variant should be a
front-recovery test rather than a promotion claim.

## Regeneration

```bash
/workspace/.venv/bin/python scripts/package_useful_bd_direct_ppa_fronts.py \
  --t24-run-root exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC \
  --t25-run-root exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC \
  --t26-run-root exp/useful_bd_push/t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/visualization_audits/20260621_direct_ppa_fronts
```

The source tables needed to regenerate the figures are under `tables/`.
