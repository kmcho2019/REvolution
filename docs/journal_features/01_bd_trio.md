# BD Trio: Logic Depth, FF Depth, Width

## Goal

Add the journal-version behavior descriptor profile:
`logic_depth`, `ff_depth`, and `comb_width_log`.

These axes define RTL design diversity as architecture depth, temporal
scheduling depth, and spatial hardware width. They are intended to replace
surface-level or PPA-result descriptors for the main journal MAP-Elites
experiments.

## Current State

The repo already has a descriptor registry in `src/revolution/qd/descriptors.py`
and structural metrics from synthesis reports. Existing descriptors include
`ltp_noff`, cell-count ratios, PPA gains, RTL-text metrics, dynamic activity
metrics, and graph-theoretic metrics.

The journal profile needs clearer post-synthesis definitions:

- `logic_depth`: longest combinational cell path between PI/FF-Q boundaries and
  PO/FF-D boundaries.
- `ff_depth`: maximum number of FF boundaries on a PI-to-PO dependency path.
- `comb_width_log`: `log1p(combinational_cells)`.

The closest code seams are:

- `src/revolution/qd/descriptors.py` for descriptor names, profiles, and
  requirement flags.
- `src/revolution/runtime/candidate_evaluator.py` for materializing descriptor
  values after simulation and synthesis.
- `src/revolution/graph_descriptor_evaluator.py` and
  `src/revolution/runtime/structural_evaluator.py` as likely places to reuse or
  extend post-synthesis netlist graph extraction.
- `scripts/qd_descriptor_probe.py` for user-visible profile validation.

## Descriptor Rationale

The journal paper should define RTL design diversity as implementation choice
inside one fixed functionality, not as output PPA and not as source-code style.
The selected axes correspond to:

- architecture: captured by `logic_depth`.
- temporal scheduling: captured by `ff_depth`.
- spatial allocation: captured by `comb_width_log`.

The first profile should stay 3D because grid MAP-Elites is easiest to reason
about in two to four dimensions. Five or more descriptors should be deferred to
CVT or learned-space ablations after the journal grid path is stable.

The brainstorm rejected these candidate BDs for the first pass:

| Candidate | Reason to defer or reject |
| --- | --- |
| Operator profile | Mostly fixed by benchmark functionality. |
| Code embeddings | Sensitive to surface syntax and hard to explain as RTL diversity. |
| Cell type distribution | Often reflects synthesis mapping choices more than design intent. |
| Absolute cell count | Too directly aligned with area fitness. Use log combinational width instead. |
| Cycles per output / II | Meaningful, but needs broader testbench and protocol support. |
| Datapath/control ratio | Requires convention-heavy classification. |
| FF ratio | Redundant with `ff_depth` and less directly tied to pipeline stage count. |
| Largest combinational block | Interesting, but more extraction-heavy than the first-pass trio. |

## Implementation Specification

- Add descriptor definitions for `logic_depth`, `ff_depth`, and
  `comb_width_log`.
- Add profile `journal_logic_ff_width_3d`.
- Extract the descriptors from a synthesized graph or Yosys JSON view.
- `logic_depth` is the longest path of non-buffer combinational cells from a
  primary input or FF-Q boundary to a primary output or FF-D boundary. A design
  with no combinational segment reports `0`.
- `ff_depth` is the largest number of FF boundaries on any primary-input to
  primary-output dependency path. Pure combinational designs report `0`.
- `comb_width_log` is `log1p(combinational_cells)`. Keep the raw
  `combinational_cells` count in metrics or artifacts when the extractor has it
  available, but use the log value as the descriptor axis.
- Treat FFs/latches as temporal boundaries for depth calculation, not as
  combinational cells.
- Prefer post-synthesis extraction because behavioral RTL can compile to very
  different hardware even when source-level syntax looks similar.
- Fail on unknown descriptor names instead of silently using zero.

## Configuration

The profile must be selectable as:

```yaml
profiles:
  journal_logic_ff_width_3d:
    - logic_depth
    - ff_depth
    - comb_width_log
```

The profile has no optional parameters. Any future alternative descriptor
family should be added as a separate named profile.

## Artifacts And Reporting

- Add raw descriptor values to per-candidate descriptor payloads.
- Include `journal_logic_ff_width_3d` in descriptor probes.
- Ensure archive event files record all three descriptor values.
- Update descriptor-health reporting so collapsed FF-depth axes are visible.

## Testing Plan

- Unit-test descriptor registry resolution for `journal_logic_ff_width_3d`.
- Unit-test `logic_depth`, `ff_depth`, and `comb_width_log` on small synthetic
  netlists.
- Synthetic coverage should include a combinational chain, input/output
  register wrappers, a two-stage pipeline, and a collapsed all-combinational
  FF-depth axis.
- Integration-test candidate evaluation with the profile selected.
- Regression-test descriptor probe output.

## Completion Checklist

Target deadline: `2026-05-03`

- [x] 1.1 Add exact descriptor names and config profile
  `journal_logic_ff_width_3d`.
- [x] 1.2 Implement post-synthesis graph extraction for `logic_depth`,
  `ff_depth`, and `comb_width_log`.
- [x] 1.3 Wire descriptors into `CandidateEvaluator`, QD descriptor registry,
  descriptor probe, and focused tests.

## Phase 01 Implementation Notes

Implemented profile:

```yaml
journal_logic_ff_width_3d:
  - logic_depth
  - ff_depth
  - comb_width_log
```

`GraphDescriptorEvaluator` now emits all three journal descriptors from the
flattened Yosys JSON graph. It also includes raw `combinational_cells` in the
graph metrics payload so archive events and reports can show the unscaled width
source when graph descriptors are active.

Descriptor projection now fails on unknown profiles, unknown axes, and missing
required metric values instead of filling absent required descriptors with
`0.0`. Failed and synthesis-skipped candidates remain non-archiveable without
fabricated descriptor values.

Known limits for this phase:

- `ff_depth` naturally collapses to `0` for combinational-only problems.
- Feedback cycles are not unrolled indefinitely; cyclic FF dependency
  components are counted once when estimating PI-to-PO FF depth.
- Quantile binning, Pareto cells, thought-only individuals, and KS re-binning
  remain out of scope for Phase 01.

Focused non-live verification commands:

```bash
/workspace/.venv/bin/python -m pytest \
  tests/revolution/test_qd_descriptors.py \
  tests/revolution/test_graph_descriptor_evaluator.py \
  tests/revolution/test_candidate_evaluator.py \
  tests/scripts/test_qd_theory_descriptor_probe.py \
  -q

/workspace/.venv/bin/python scripts/qd_descriptor_probe.py \
  --archive_type cvt \
  --profile journal_logic_ff_width_3d \
  --circuit_type sequential

/workspace/.venv/bin/python scripts/qd_descriptor_probe.py \
  --archive_type cvt \
  --profile journal_logic_ff_width_3d \
  --circuit_type combinational
```

Phase 01 verification results on `2026-05-03`:

- Focused pytest command above passed: `47 passed`.
- Additional adjacent QD runtime coverage passed:
  `tests/revolution/test_qd_engine.py`,
  `tests/revolution/test_qd_archive.py`, and
  `tests/revolution/test_successful_candidate_catalog.py`.
- Both descriptor-probe commands above resolved
  `logic_depth, ff_depth, comb_width_log` with graph-metric and synthesis
  requirements.
- Live smoke run root:
  `exp/journal_bd_trio_live_smoke_20260503_143237`.
  The QD smoke completed without descriptor extraction crashes, produced
  archive summaries and per-candidate `qd_archive_event.json` files, and showed
  `ff_depth` collapsed only on the combinational adder problem.
- Bounded hard-subset run root:
  `exp/journal_bd_trio_hard_subset/20260503_143855`.
  QD archive coverage was `8/16`, `5/16`, and `2/16` cells on the three
  selected problems. Sequential event payloads included nonzero `ff_depth`
  values.
- The bounded three-problem run had lower mean best score for
  `cvt_journal_bd` than classic (`0.0984` vs `0.1904`). Archive artifacts,
  descriptor health, and per-candidate payloads were present, so this looked
  like small-sample search/PPA variance rather than a descriptor extraction
  failure.
- Pyright reported environment import-resolution noise for `numpy`, `scipy`,
  and `yaml`; no implementation type errors were reported in the checked
  targets.
