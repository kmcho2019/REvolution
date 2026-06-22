# T39 Sparse-Yield Warmup QD Methodology

Status: pre-registered live ablation.

## Question

T38 showed that `elite_pareto_slot` can retain active archive/front material on
ALU and traffic-light, but `Prob015_multi_pipe_8bit` produced seven valid PPA
points and still had zero active archive members because grid-quantile warmup
required eight successes.

T39 asks whether the same one-slot archive rule works better when sparse-yield
designs can initialize their quantile archive during the run.

## Method Delta

T39 keeps T38 fixed except for grid-quantile warmup:

- same model, seed, subset, prompt, budget, operators, descriptor, archive
  type, parent selection, and `elite_pareto_slot` cell mode;
- `--qd_grid_quantile_warmup_successes 4` instead of `8`;
- `--qd_max_elites_per_cell 2`, preserving one quality champion plus one local
  PPA-front slot per occupied descriptor cell.

The value `4` is the minimum live threshold chosen for this ablation because
the quantile archive has four intended bins per axis. It is not selected from
T39 outcomes. It is a direct response to the T38 small-n failure mode: a design
with four to seven valid PPA candidates should not end with a completely empty
active archive.

## Descriptor

T39 uses the same live descriptor as T38:

- `rtl_cyclomatic_total_log`;
- `reconv_sink_ratio`;
- `scoap_signal_smoothness`.

The descriptor profile is `journal_graph_testability_3d` from
`data/configs/qd_descriptor_profiles.yaml`.

## Leakage Rules

PPA, final score, reference PPA, hypervolume, Pareto rank, test pass rate, and
validity labels are not descriptor inputs. T39 changes only the number of
already-valid archiveable samples required before quantile cells are frozen.
PPA enters only after evaluation for archive retention, parent selection, and
reporting.

## Controls

The first bounded arm compares directly against T38 because it is an ablation
of one configuration value. T39 cannot be promoted from this arm alone. Any
`T1` or higher claim still needs comparison against classic and the relevant
QD controls under the same budget.

## Acceptance Signals

T39 advances only if it improves over T38 without breaking the core guardrails:

- multi-pipe has at least one active archive member;
- every T38-covered design still has valid functional PPA;
- direct raw area-power Pareto front material is preserved or improved;
- global PPA hypervolume, HV-AUC, valid-PPA count, active archive coverage, or
  front spread improves on at least one problem;
- no catastrophic functionality or synthesis-validity decline is observed
  when the compared denominator is large enough for the 50 percent gate.

## Required Artifacts

- `/v1/models` preflight capture;
- exact command in `commands/live_screen_v0.md`;
- frozen subset in `tables/live_screen_v0_subset.yaml`;
- run matrix in `tables/run_matrix.csv`;
- Pareto archive validation output;
- direct raw area-power PPA Pareto PNGs and HTML viewer;
- candidate/front table sufficient to regenerate plots;
- results report with a T0/T1/T2/T3 tier decision;
- visual inspection notes.

## Tier Rule

Until a live run completes, T39 is only pre-registered. A positive bounded arm
can at most become a live ablation lead. Promotion requires the broader
same-budget controls from the useful-BD plan.
