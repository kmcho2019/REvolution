# RTLLM QD Milestone Experiment Plan

Status: pre-registered protocol; one-seed full RTLLM run completed and
packaged under `full_rtllm/`.

## Objective

Run a broad RTLLM comparison between classic REvolution and the strongest
T26-family QD/MAP-Elites method to determine whether QD improves PPA-centered
search outcomes enough to justify continuing the research direction.

## Frozen Benchmark Manifest

The full benchmark set is the 50 problems derived from
`bench/RTLLM/*_prompt.txt`, not `scripts/RTLLM.csv`. The manifest is committed
as `data/rtllm_50_problem_manifest.csv`.

## Candidate Methods

| Method | Purpose | Code status |
| --- | --- | --- |
| `classic_revolution` | Conference baseline comparator. | Existing. |
| `sr_raw_conservative_exploit_qd` | Exact T26 fallback and current lead. | Existing. |
| `sr_raw_conservative_exploit_low_fusion_qd` | T26.1 with `qd_two_parent_probability=0.10`. | No source change if no gate. |
| `sr_raw_conservative_exploit_gated_fusion_qd` | T26.1 with near-front descriptor-compatible two-parent gate. | Requires narrow implementation and tests. |

Actual deadline screen note: the completed screen used exact T26, low-fusion,
and mid-fusion. The gated-fusion arm was not launched before the deadline
because the narrow gate was not available yet. Treat mid-fusion as a recorded
deviation, not as pre-registered primary evidence.

Do not launch the full RTLLM run with a new variant until the variant passes
screening and adversarial pre-launch review. If the gated variant complicates
the code or fails smoke/screening, exact T26 remains the full-run QD arm.

## Screening Ladder

Screen before full RTLLM:

- fixed hard screen: `Prob045_alu`, `Prob041_traffic_light`,
  `Prob015_multi_pipe_8bit`;
- stress slice if endpoint time permits: `Prob006_adder_pipe_64bit`,
  `Prob013_multi_booth_8bit`, `Prob043_RAM`.

Selection metrics:

- preserves every classic-covered design;
- valid-PPA and synthesis-valid declines are reported as yield warnings, not
  launch blockers, as long as every classic-covered design still has at least
  one valid QD PPA sample;
- paired HV and HV-AUC;
- raw area-power front hits;
- unique front families and duplicate accounting;
- valid-PPA yield.

The full-run method must be selected before seeing full RTLLM outcomes.
The three development-screen problems must be labeled in the full aggregate,
and the report must include both all-problem and screen-excluded aggregates.

## Full RTLLM Run

Fixed settings:

- benchmark: RTLLM 50-problem manifest;
- seed: `1001`;
- population size: `12`;
- generations: `3`;
- model: `openai/gpt-oss-120b`;
- endpoint: `http://20.0.0.103:8000/v1`;
- token budgets: `--max_tokens 128000 --diff_max_tokens 128000`;
- evaluation mode: `strict_ablation`;
- operators: `eoh_strategies`;
- representation: `code_individual`;
- worker target: `--total_worker_slots 50 --max_active_problems 50
  --max_workers_per_problem 4`.

The 50-worker setting is pre-registered for throughput. If it causes endpoint,
CPU, or filesystem thrashing, record the failure and resume with a versioned
worker setting before interpreting results.

This is a one-seed milestone run. It can support paired problem-level
engineering evidence, but not seed-stable significance. Any bootstrap interval
must state that it resamples over problems, not over independent seeds.
Because the presentation deadline is tight, the one-seed run is the first
deliverable. Multi-seed replication is a follow-on milestone after the
one-seed results are organized into the report, plots, tables, and slides.

## Required Outputs

- raw run roots under `exp/useful_bd_push/`;
- commands and model metadata under `commands/` and `data/`;
- one row per method/problem with HV, HV-AUC, best score, valid-PPA count,
  front points, and runtime;
- `ppa_completeness.csv` with `classic_valid_ppa`, `qd_valid_ppa`,
  `reference_ppa_valid`, and `comparison_status` for every manifest problem;
- paired aggregate tables with mean/median deltas; bootstrap intervals are
  deferred because the one-seed package is not a seed-stability claim;
- all-problem and screen-excluded aggregate tables;
- per-arm evaluation-count and LLM-call parity tables;
- direct static plots under `figures/`;
- full Phase 03.1 `qd_ppa_viewer/` bundle for the selected QD arm if archive
  artifacts are available;
- adversarial review logs under `reviews/`.

Full-suite unique front-family breadth and the Phase 03.1 viewer remain
follow-up artifacts for archive/family claims. The current presentation claim
is deliberately scoped to matched-budget PPA evidence: HV, HV-AUC, valid-PPA
retention, PPA-front points, and unique PPA points.

## Claim Scope

The two-arm full RTLLM comparison tests a T26-family bundle against classic.
It does not isolate descriptor contribution from parent-source policy. A
positive result should be claimed as evidence for the bundle unless an added
control arm separates SR raw archive effects from champion-biased exploitation.

Headline direct classic-vs-QD claims must use the reference-complete paired
subset. Missing candidate PPA is counted as a method invalid/non-PPA outcome.
Missing or defaulted reference `ppa.txt` makes the problem diagnostic-only for
normalized improvement, HV, HV-AUC, and aggregate direct-comparison claims.
