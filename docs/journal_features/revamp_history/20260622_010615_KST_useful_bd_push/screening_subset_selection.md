# Screening Subset Selection

The subset must help find signal quickly without becoming a cherry-picking
loophole. It should contain tasks where PPA optimization has room to vary,
where QD could plausibly discover alternative implementation families, and
where failure modes are informative.

## Selection Metrics

Compute these from replay sources before choosing the subset:

- valid-PPA count;
- global PPA hypervolume;
- PPA-front size;
- area/power/timing variance among valid-PPA candidates;
- unique canonical netlist count;
- unique motif/codebook family count;
- duplicate rate;
- functional/synthesis failure rate;
- existing QD archive occupancy if available;
- prompt length and token-risk category.

## Required Strata

The screening subset should include:

- arithmetic/datapath tasks;
- memory/interface tasks;
- control/FSM/sequential tasks;
- bit-manipulation/vector tasks;
- at least one easier positive-control task;
- at least one hard negative-control task;
- at least one task where prior CVT or grid showed promising archive behavior.

## Candidate Seed Set

These are starting candidates, not final cherry-picked claims:

- `RTLLM/Prob043_RAM`: prior long-token QD run filled more CVT cells while
  staying near classic on best quality.
- `RTLLM/Prob045_alu`: prior long-token CVT run showed the strongest positive
  signal, including a best-quality win over classic in the recorded slice.
- `RTLLM/Prob009_div_16bit` or `RTLLM/Prob010_radix2_div`: arithmetic division
  tasks likely to expose implementation diversity.
- `RTLLM/Prob026_asyn_fifo`: memory/control boundary task with nontrivial
  sequential behavior.
- `RTLLM/Prob024_fsm` or `RTLLM/Prob041_traffic_light`: control/FSM hard
  checks.
- `VerilogEval-Spec-to-RTL/Prob030_popcount255`: larger combinational/vector
  task used in prior hard-subset guidance.
- `VerilogEval-Spec-to-RTL/Prob153_gshare`: harder predictor/control task
  with prior QD archive behavior.
- `VerilogEval-Spec-to-RTL/Prob156_review2015_fancytimer`: hard control/FSM
  task that remained difficult for all modes and should remain as a guardrail.
- `VerilogEval-Spec-to-RTL/Prob082_lfsr32` or
  `VerilogEval-Spec-to-RTL/Prob095_review2015_fsmshift`: sequential/shift
  alternatives for state-aware descriptors.

## Selection Rule

1. Generate a candidate subset table from replay data.
2. Pick 8 to 12 problems by stratified scoring:
   `score = ppa_variance_rank + pareto_size_rank + unique_family_rank -
   duplicate_rate_rank - missing_artifact_penalty`.
3. Force-include at least two prior-signal tasks and two hard controls.
4. Freeze the subset before method results are reviewed.
5. Keep a holdout subset selected by the same rule for any `T1` or `T2`
   candidate.

## Replacement Rule

Replace a problem only if it has missing artifacts, no valid-PPA candidates in
all baselines, or a documented infrastructure blocker. Replacement must happen
before reviewing new method results and must use the same stratified rule.

## Reporting

The central report must include:

- the subset selection table;
- the frozen subset and holdout subset;
- why each included problem belongs to its stratum;
- evidence that the subset was not changed after method outcomes were known;
- per-problem results so aggregate wins cannot hide failures.

## Budget-Ablation Design Set Guidance

For the planned fixed-total-budget ablation, prefer a smaller
reference-complete subset selected for discriminative PPA-front variance and
medium validity. The subset should avoid both saturated tasks where every
method finds the same PPA corner and invalid-heavy tasks where too few samples
survive for archive pressure to matter.

T78 strengthens this requirement: existing T75 archives still mature late under
`12 x 3`, but the signal would be noisy on designs that are saturated,
reference-missing, or nearly all invalid.

Candidate properties:

- valid reference `ppa.txt`;
- several classic valid-PPA samples;
- multiple unique nondominated PPA points in prior runs;
- nontrivial area/power/timing variance;
- moderate duplicate rate;
- enough RTL structure to support distinct implementation families.

Starting candidates are `RTLLM/Prob015_multi_pipe_8bit`,
`RTLLM/Prob041_traffic_light`, `RTLLM/Prob045_alu`,
`RTLLM/Prob049_signal_generator`, `RTLLM/Prob024_fsm`,
`VerilogEval-Spec-to-RTL/Prob116_m2014_q3`,
`VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`, and
`VerilogEval-Spec-to-RTL/Prob153_gshare`. This list is only a starting point;
the final budget-ablation subset must be frozen before reading new outcomes.

## Frozen Subset - 2026-06-21 UTC

The first active goal pass froze the screening subset from the compared
Auto-BD replay slice before running new useful-BD methods. The scoring table is
committed at `tables/screening_subset_candidates.csv`; the selected screening
set is `tables/frozen_screening_subset.csv`; the holdout set is
`tables/holdout_screening_subset.csv`.

Replay sources:

- candidate audit:
  `exp/diversity_check/restarted_report_20260621_075346_UTC/candidate_audit.parquet`
  (`sha256=45bf15f12ac23e429b89da8e168d7f4ad4404a9fcbb911f78c36de4af05d400f`);
- WP0 descriptor rows:
  `exp/diversity_check/wp0_stnod_sr_replay_20260621_041018_UTC/wp0_descriptor_rows.parquet`
  (`sha256=0a545bc34622b6f5c4a54dffeb33427028bcc4b0cd14903d6a27916da47af28a`).

Frozen screening problems:

| Rank | Problem | Stratum | Reason |
| --- | --- | --- | --- |
| 1 | `VerilogEval-Spec-to-RTL/Prob153_gshare` | memory/interface | forced prior signal |
| 2 | `RTLLM/Prob045_alu` | arithmetic/datapath | forced prior signal |
| 3 | `RTLLM/Prob037_parallel2serial` | bit/vector | stratum seed |
| 4 | `RTLLM/Prob041_traffic_light` | control/sequential | stratum seed |
| 5 | `RTLLM/Prob015_multi_pipe_8bit` | arithmetic/datapath | score fill |
| 6 | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | control/sequential | score fill |
| 7 | `RTLLM/Prob024_fsm` | control/sequential | score fill |
| 8 | `RTLLM/Prob004_adder_8bit` | arithmetic/datapath | score fill |
| 9 | `RTLLM/Prob049_signal_generator` | arithmetic/datapath | score fill |
| 10 | `VerilogEval-Spec-to-RTL/Prob116_m2014_q3` | control/sequential | score fill |

Holdout problems selected by the same rule:

- `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot`;
- `VerilogEval-Spec-to-RTL/Prob098_circuit7`;
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`.

Replacement remains governed by the rule above. No replacement was applied in
this setup pass.
