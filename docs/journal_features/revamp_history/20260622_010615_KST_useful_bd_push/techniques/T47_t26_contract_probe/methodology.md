# T47 T26 Contract Probe Methodology

Status: pre-registered method card. No live run has been launched.

## Question

The one-seed full RTLLM package gave a diagnostic front-count signal for exact
T26, but the stricter review downgraded the claim because the aggregate HV win
depends on defaulted-reference `Prob040_synchronizer`, paired HV is
net-negative, and all-RTLLM `best_score` is worse than classic.

T47 asks whether a T26-family method can survive a contract-aligned probe before
we spend final-run budget. The probe is not a new descriptor; it is a gate that
prevents the next T26/T26.1 experiment from repeating the same overclaim.

## Method Under Test

Primary arm:
exact T26, `sr_raw_conservative_exploit_qd`.

Allowed follow-up arm after the exact T26 probe:
T26.1 role-separated conservative exploit, only if implemented narrowly and
tested first. The intended T26.1 direction is:

- keep T26 champion pressure;
- add a bounded near-front or local-rank-1 lane;
- add a bounded repair lane only when it cannot replace champion sampling;
- keep two-parent fusion disabled unless a gated parent-compatibility rule is
  implemented and tested.

## Frozen Inputs

- seed manifest: `data/configs/journal_seed_manifest.yaml`;
- tuning set: `data/configs/hard_iteration_subset.yaml`;
- held-out set: `data/configs/holdout_reference_subset.yaml`;
- model endpoint: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- output root: `exp/useful_bd_push/t47_t26_contract_probe_<timestamp>/`.

The probe must not use `Prob040_synchronizer` or any other default-reference
problem as a headline reference-normalized HV carrier. If a problem lacks a
benchmark reference, it is quarantined for headline PPA gates until a real
reference is added or the problem is excluded before the run is frozen.

## Probe Ladder

1. Hard/tuning sanity probe:
   Run classic and exact T26 on the frozen hard/tuning subset with seeds
   `1001` and `1002`. This is not final evidence; it checks stability before
   held-out spend.
2. Held-out dry run:
   Only after the method is frozen, run one held-out seed without repair or
   descriptor tuning. Any held-out infrastructure issue must be recorded before
   deciding whether to rerun.
3. Final-style escalation:
   Only if the first two phases pass, consider the full seeds `1001` through
   `1005` and the `journal_stats` gate. That escalation should happen in a
   dedicated branch or clearly recorded run ledger entry.

## Acceptance Signals

T47 can advance T26-family work only if the probe shows all of the following:

- no classic-covered valid-PPA problem is lost;
- paired HV is not net-negative after default-reference problems are
  quarantined;
- mean `best_score` is not worse than classic by more than the contract's
  `0.03` parity margin on the probe set;
- valid-PPA yield drops are labeled and do not hide a design-level failure;
- front-point gains remain after duplicate/family-proxy accounting;
- no claim depends on family/front counts that merely duplicate the front-point
  count.

## Non-Claims

This package does not prove QD usefulness. It is a pre-final filter that
decides whether exact T26 or a narrow T26.1 variant deserves a contract-aligned
multi-seed run.

## Required Artifacts

Before T47 can be marked complete, the package must include:

- vLLM `/v1/models` preflight metadata;
- command log for every probe phase;
- method manifest and run matrix;
- problem/method metrics with `best_score`, HV, HV-AUC, valid-PPA count,
  front points, unique PPA points, and budget parity;
- default-reference quarantine table;
- direct raw area-power PPA-front figures;
- full Phase 03.1 `qd_ppa_viewer/` bundle for any live QD archive result;
- visual inspection notes;
- adversarial review that checks this methodology against
  `journal_contract_alignment.md`.
