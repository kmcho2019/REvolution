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

For Phase 01, `journal_logic_ff_width_3d` is an archive-only descriptor
profile. It changes archive placement, archive events, descriptor health, and
QD reports, but it does not switch the QD generator to descriptor-targeted
success operators. The journal profile uses the same success-side generation
operators and global generation mode as classic REvolution so candidate pass
counts remain comparable; `M-T`, `C-D`, and per-phase QD diff defaults remain
available to the older descriptor-guided QD profiles.

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
  like small-sample search/PPA variance rather than descriptor extraction
  rejecting successful candidates. A follow-up inspection found that the first
  implementation had enabled descriptor-targeted QD generation for this new
  profile, including `M-T`, `C-D`, and problem-specific diff defaults, which
  changed generated candidates in generation 2. The profile is now constrained
  to archive-only behavior for Phase 01.
- Additional regression coverage now checks that ordinary QD profiles still use
  descriptor-targeted operators, while `journal_logic_ff_width_3d` uses the
  classic success-side generation policy. The targeted regression command
  passed with `97 passed`.
- Ruff passed on touched runtime, script, and test files. Pyright passed with
  `0 errors, 0 warnings, 0 informations` on the checked runtime targets.
- Post-fix live smoke run root:
  `exp/journal_bd_trio_live_smoke_postfix_20260503_170506`.
  Both classic and `cvt_journal_bd` had `2/2` problems with at least one
  synthesis-passing sample. Both modes had `6/16` synthesis-passing candidates;
  functionality-passing candidates were `7/16` for classic and `6/16` for
  `cvt_journal_bd`. The QD run produced six `qd_archive_event.json` files, all
  with `logic_depth`, `ff_depth`, and `comb_width_log`, and no archive event
  used `M-T` or `C-D`.
- Post-fix bounded hard-subset run root:
  `exp/journal_bd_trio_hard_subset_postfix/20260503_174526`.
  This used `population_size=8`, `num_generations=2`, full 128k token budgets,
  and the three representative problems
  `RTLLM/Prob004_adder_8bit`, `RTLLM/Prob015_multi_pipe_8bit`, and
  `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm`.
  Both classic and `cvt_journal_bd` had `3/3` functionality-pass designs and
  `3/3` synthesis-pass designs. Classic had `26/72` functionality-passing
  samples and `23/72` synthesis-passing samples; `cvt_journal_bd` had `28/72`
  for both. Average synthesis-passing samples per design improved from `7.67`
  to `9.33`.
- The bounded post-fix comparison showed mixed outcome by metric. Journal QD
  improved pass-sample yield and Pareto hypervolume (`0.0503` vs `0.0137`,
  with `2` hypervolume wins vs `1` for classic), and the generated final
  analysis recommended `cvt_journal_bd` overall. It did not improve mean best
  score/PPA on this three-problem slice (`+4.00%` average score delta vs
  `+10.03%` for classic), mostly because
  `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` regressed. The current
  evidence supports the journal profile as an archive/multi-objective and
  success-yield improvement on this bounded run, but not as an unqualified PPA
  improvement; larger multi-seed runs are still needed before claiming a
  robust journal result.
- Full hard-subset single-seed run root:
  `exp/journal_bd_trio_hard_subset_full/20260503_181144`. This used the full
  `data/configs/hard_iteration_subset.yaml` selected-problem list through the
  scratch config
  `exp/journal_bd_trio_configs/hard_iteration_subset_journal_bd_full.yaml`,
  `population_size=20`, `num_generations=5`, and full 128k token budgets.
  Each backend evaluated `13` designs with `120` generated candidates per
  design.
- In the full hard-subset run, classic and `cvt_journal_bd` both had `13/13`
  functionality-pass designs and `13/13` synthesis-pass designs. Classic had
  `794/1560` functionality-passing samples and `779/1560`
  synthesis-passing samples. `cvt_journal_bd` had `793/1560`
  functionality-passing samples and `765/1560` synthesis-passing samples. The
  journal mode therefore had no design-level pass gap, a `1`-sample
  functionality gap, and a `14`-sample synthesis-success gap on this run
  (`49.0%` synthesis mean vs `49.9%` for classic).
- A stricter loop-artifact check confirmed that those synthesis-passing counts
  also passed PPA extraction inside the candidate-evaluation loop. Classic had
  `779` `code_synthesis_report.metrics.json` files, `779` `.ppa` files, and
  `779` finite loop PPA metric payloads. `cvt_journal_bd` had `765` of each.
  All final-population PPA details were valid as well (`260/260` for classic
  and `72/72` for `cvt_journal_bd`).
- The full hard-subset quality result was mixed and slightly favored classic
  on aggregate best-score and Pareto hypervolume. The completed
  hard-iteration analysis reported mean best score `0.2649` for classic and
  `0.2258` for `cvt_journal_bd`; mean Pareto hypervolume was `0.1122` for
  classic and `0.0868` for `cvt_journal_bd`. Journal QD produced more mean
  Pareto points (`2.85` vs `2.46`) and had mean archive coverage `34.6%`, but
  this single-seed full run does not support a PPA-performance improvement
  claim.
- Full-run archive validation found `13` archive summaries with descriptor
  profile `journal_logic_ff_width_3d` and descriptor axes
  `logic_depth`, `ff_depth`, and `comb_width_log`. The run produced `765`
  `qd_archive_event.json` files, all with the three journal descriptor values.
  No archive event used descriptor-targeted generation strategies `M-T` or
  `C-D`. Descriptor health reported `ff_depth` as collapsed in `7/13`
  problems, which is expected for combinational or shallow temporal designs.
- The full-run matrix report and final hard-iteration, Pareto, and
  evolutionary subreports completed. The default design-space report path was
  stopped because the t-SNE embedding step remained CPU-bound for more than
  `20` minutes without new output on this full artifact tree. A PCA-only
  design-space attempt was also stopped after more than `6` minutes without
  output. This is a post-processing limitation and did not affect the completed
  run artifacts, archive summaries, descriptor health, or pass-count analysis.
