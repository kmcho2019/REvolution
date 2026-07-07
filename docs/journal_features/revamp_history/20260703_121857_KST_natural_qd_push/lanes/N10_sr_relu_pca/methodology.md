# N10 SR-ReLU PCA Descriptor Probe

Status: extraction smoke passed; seed-1001 live screen closed diagnostic
with no escalation.

## Question

Can the strongest synthesis-response replay lead, SR ReLU PCA, be moved onto
the Smooth-QD V2 platform without leakage, descriptor-collapse, or extraction
fragility, and does it improve the V2 screen result?

This is a natural descriptor extension, not a new search heuristic: keep V2's
operators, representation, archive mode, parent selection, warmup, and
capacity unchanged. The only live-screen change, if the probe passes, is
`--qd_descriptor_profile sr_pca_3d` with the frozen descriptor file in this
lane.

## Why This Is Next

- N06 left SR ReLU PCA as the strongest unlaunched descriptor-isolating lead:
  T19 replay reported +16.82% mean HV and +65.24% HV-AUC against classic on a
  six-problem development subset.
- N07a/N07c and N09 showed that more structural descriptor swaps and more
  per-cell capacity do not displace V2; more simple capacity/fraction scans are
  now low value.
- The existing SR-ReLU artifact is leak-clean for the frozen July 8-design
  screen: its six training problems do not overlap the screen manifest. It is
  not a full-suite promotion artifact because its training set includes RTLLM
  problems; a full RTLLM claim would need a fresh holdout-clean artifact.

## Frozen Profile

- descriptor file: `descriptor_profile.yaml`
- profile: `sr_pca_3d`
- artifact:
  `../../../20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/fitting_artifacts/sr_random_relu_pca_dev_seed1001/sr_random_relu_pca_artifact.json`
- raw feature schema: `synthesis_response_raw_v1`
- random map: ReLU, 128 features, seed `20260618`
- descriptor hash:
  `5a4c6690deca43d298ec385ad65186fd053f73caef00e29a00e6b4ac6ba6e88a`

Forbidden descriptor inputs remain PPA, reference PPA, fitness, hypervolume,
test pass percentage, problem ID, Pareto rank, and final evaluation labels.

## Probe Gate

First run only the bounded extraction smoke:

```bash
uv run python scripts/probe_n10_sr_relu_smoke.py \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N10_sr_relu_pca/smokes/sr_relu_pca_20260707_151320_UTC
```

The smoke uses one existing valid V2 seed-1001 candidate per frozen screen
problem, runs fresh ST-NOD Yosys stage dumps, projects SR-ReLU descriptors, and
writes `descriptor_health.json`, `descriptor_health_report.md`,
`descriptor_values.csv`, and `extraction_smoke_summary.json`. It discards
generated stage-dump artifacts after projection. It makes no LLM, HV, or
functionality claim.

Gate to live screen:

- status `pass`;
- no screen/training problem overlap;
- descriptor health initialized;
- no collapsed axes on the 8-problem smoke;
- no stage-dump failures.

If any gate fails, close N10 without live LLM spend.

Smoke result (2026-07-07 15:13 UTC): PASS. `8/8` screen problems, no
screen/training overlap, initialized `4x4x4`, eight occupied cells, and no
collapsed axes.

## Live Screen

After the smoke passed, run one seed-1001 8-design V2-faithful screen:

- `search_mode=revolution_qd`
- `representation_kind=code_individual`
- `qd_operator_kind=eoh_strategies`
- `qd_cell_mode=pareto_front`
- `qd_max_elites_per_cell=5`
- `qd_parent_selection=nsga2_global_rank`
- `qd_descriptor_file=.../lanes/N10_sr_relu_pca/descriptor_profile.yaml`
- `qd_descriptor_profile=sr_pca_3d`
- `max_tokens=128000`
- `diff_max_tokens=128000`

Close immediately on coverage loss, mean HV below `0.95x` classic, operator
audit failure, or `single_thought_count>0`. Escalate only if it beats V2 on
both mean HV and HV-AUC with coverage retained.

Live result (2026-07-07 15:51 UTC): PASS on hard gates, negative for
promotion. Mean HV `0.15683` clears classic (`0.14064`) but trails V2
(`0.17376`); HV-AUC `0.13411` clears classic (`0.12387`) but trails V2
(`0.14366`). Coverage remains 8/8 and operator audit reports
`single_thought_count=0`. Gate decision: diagnostic keeper only; do not
escalate to seeds 1002/1003.
