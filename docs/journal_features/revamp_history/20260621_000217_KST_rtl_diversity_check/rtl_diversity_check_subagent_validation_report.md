# RTL Diversity Check Experiment Subagent Validation Report

Verdict: PASS

## Scope

Validated the regenerated RTL diversity check artifacts against the current
`B illumination_only` claim. I treated the generated report, JSON, CSV tables,
implementation history, script, and tests as evidence to verify, not as
authoritative.

## Evidence Checked

- Contract files:
  `rtl_diversity_check_adversarial_prompt.md`,
  `rtl_diversity_check_plan.md`,
  `rtl_diversity_check_implementation_todo.md`, and
  `rtl_diversity_check_implementation_history.md`.
- Implementation:
  `scripts/report_rtl_diversity_check.py` and
  `tests/scripts/test_report_rtl_diversity_check.py`.
- Current artifacts under `exp/diversity_check/full_20260620/`:
  `diversity_necessity_report.md`, `diversity_necessity_report.json`,
  `d_gate_matrix.csv`, `counterfactual_replay.csv`,
  `corpus_coverage.csv`, and `candidate_audit.csv`.

## Checks Run

- `git status --short && git branch --show-current && git rev-parse HEAD`:
  branch is `feat/journal-diversity-check-exp-20260620` at
  `6a725c544265b35ffd9aa2792bc1d9974a152eaf`. Existing dirty files were not
  reverted or modified except this validation report.
- `test -w /aux/revolution-history; echo aux_write_test_exit=$?`: exit code
  `1`, so the historical checkout is not writable from this container.
- `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py`:
  4 passed.
- Read-only JSON/CSV recomputation confirmed the current payload and tables:
  203,944 total candidates; 180,544 evolution-analysis candidates; 170,131
  ASP-DAC release candidates; 10,413 legacy RTLLM candidates; 23,400 Auto-BD
  controls; 874 evolution problem-runs; 697 analyzable valid-PPA problem-runs.
- Recomputed D3 from `counterfactual_replay.csv`: best diversity policy mean
  hypervolume `0.042866` versus best-fitness mean hypervolume `0.042294`,
  a 1.35% gain, matching the rounded 1.4% report value and below the 10%
  reconstructive threshold.
- Recomputed D2 from `cluster_summary.csv`: 48.8% multi-cluster Pareto-front
  rate versus 56.0% shuffled-label rate across 697 analyzable problem-runs.
- Searched the regenerated Markdown, JSON, and key CSV artifacts for the stale
  `D3 plus D6 justify reconstructive/offline diversity follow-up` wording.
  It is absent from the current report artifacts.

## Validation Result

The regenerated `diversity_necessity_report.md` states
`Final verdict: B illumination_only`, reports D1/D2/D3/D5 as failed, D4 as
not run, and D6 as passed. The limits section now says D6 supports
illumination only and explicitly rejects reconstructive, predictive, active,
and Auto-BD method claims for this evidence package.

The JSON payload and CSV tables agree with that interpretation:
`diversity_necessity_report.json` reports `B illumination_only`; L0
descriptive is supported; L1 reconstructive, L2 predictive, L3 mechanistic,
and L5 method are not supported; L4 active was not run.

The candidate audit includes the required corpus, method, seed, model,
benchmark/problem, generation, operator, candidate id, code/netlist paths,
validity-funnel fields (`syntax_pass`, `functionality_pass`,
`synthesis_pass`, `openroad_pass`, `valid_ppa`, `failure_reason`), PPA fields,
descriptor metadata, hashes, and style clusters. The report also preserves
the 20260618 Auto-BD negative/control evidence, records Qwen as blocked by
missing `torch`, records DeepGate3 as blocked by missing `deepgate3`, and
does not rely on a live evolution run.

The current implementation and regenerated artifacts satisfy the planned
`B illumination_only` claim, and no stale reconstructive claim remains in the
current report artifacts.
