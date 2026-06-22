# T38 Elite Pareto Slot Live QD Methodology

Status: pre-registered live method.

## Question

T36 and T37 found that one descriptor-cell local PPA-front slot improved the
best replay tradeoff, while two or more slots collapsed HV. T38 asks whether
that bounded retention rule can be tested in the live QD runtime without
pretending that the retrospective T11 descriptor is already available online.

## Method Delta

T38 adds a new QD cell mode, `elite_pareto_slot`.

Each descriptor cell keeps:

1. the scalar quality champion, selected by `quality_score`;
2. `max_elites_per_cell - 1` local members selected by PPA Pareto rank and
   NSGA-II crowding distance.

The intended live screen sets `--qd_max_elites_per_cell 2`, so each occupied
cell has exactly one quality champion lane and one local PPA-front slot. This
is the direct live analogue of the T37 one-slot result. It is not a two-slot
or full local-front replay.

## Descriptor

The initial live descriptor is the existing runtime
`journal_graph_testability_3d` profile:

- `rtl_cyclomatic_total_log`;
- `reconv_sink_ratio`;
- `scoap_signal_smoothness`.

This profile is chosen because the retrospective T11/T37 feature winners were
structural graph/hypergraph features, while an exact T11 live projection is
not yet implemented in the runtime descriptor registry.

## Controls

The planned live screen compares:

- classic revolution under the same model, seed, problems, and budget;
- `journal_graph_testability_3d` with the existing `pareto_front` cell mode;
- `journal_graph_testability_3d` with the new `elite_pareto_slot` cell mode.

This isolates whether the bounded one-slot archive rule helps relative to the
same live descriptor with a full local Pareto cell.

## Leakage Rules

PPA, final score, reference PPA, hypervolume, Pareto rank, test pass rate, and
validity labels are not descriptor inputs. PPA enters only after evaluation for
archive retention, parent selection, and reporting.

## Acceptance Signals

T38 can advance only if it preserves every classic-covered design under the
same budget and improves at least one direct QD/PPA metric without a
catastrophic yield regression:

- global PPA hypervolume or HV-AUC;
- direct raw area-power Pareto-front hits;
- unique valid PPA points;
- passive archive coverage/QD score;
- front-family or canonical-netlist breadth.

The 50 percent validity/synthesis drop gate applies only when the comparator
has at least 10 passing valid-PPA samples in the compared unit.

## Required Artifacts

- `/v1/models` preflight capture;
- exact commands in `commands/live_screen_v0.md`;
- run matrix in `tables/run_matrix.csv`;
- Pareto archive validation for the `elite_pareto_slot` arm;
- direct raw area-power PPA Pareto PNGs and an HTML viewer;
- raw candidate/front table sufficient to regenerate the PPA plots;
- results report with a T0/T1/T2/T3 tier decision;
- visual inspection notes.

## Tier Rule

Until a live run completes, T38 is only a pre-registered method. A positive
result would be `T1` or `T2` depending on holdout strength and whether the
direct PPA-front signal survives visual and numerical audit.
