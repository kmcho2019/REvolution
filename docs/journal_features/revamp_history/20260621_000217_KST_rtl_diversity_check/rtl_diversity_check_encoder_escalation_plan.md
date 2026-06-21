# RTL Diversity Encoder Escalation Plan

Status: active next-step plan after the restarted WP1/WP3 diagnostics.

## Current Result

Qwen3 and DeepGate3 did not return promotable results.

- Qwen3-Embedding-0.6B ran successfully and produced non-collapsed text
  embeddings, including Yosys-normalized RTL embeddings. It remains
  diagnostic-only because predictive, replay, and common-audit utility have
  not been established.
- DeepGate3 was attempted end to end through the bounded AIG/tokenizer path.
  The current graph policy is combinational-only, rejects or excludes much of
  the sequential evidence, and the nontrivial embeddings collapsed with mean
  pairwise cosine near 0.999971.
- The bounded AURORA-style linear autoencoder probes over the four-axis
  common-audit vectors also returned `diagnostic_only_no_proceed`.

The next escalation is allowed, but only as a diagnostic plan until it clears
one utility gate and one meaning gate.

## Required Gates

Any finetuned, AURORA-style, VQ, or larger pre-trained encoder must declare
these before training:

- fitting corpus and held-out problem split;
- input features and forbidden fields;
- checkpoint path, hash, and dependency environment;
- utility target: D1 early prediction, D3 replay retention, D4 live
  intervention, or D5 real-beats-random;
- meaning target: D2 multi-region Pareto-front contribution or D6
  interpretable regions;
- no-proceed threshold.

No encoder may be promoted if its result is explained by valid-count,
duplicate-count, or descriptor-owned archive-space confounds.

## Training Rules

- Use problem-held-out evaluation by default. Candidate-level random splits
  are not enough for paper-facing claims.
- Do not train on area, power, timing, fitness, Pareto membership, valid-PPA,
  archive cell id, problem id, candidate id, or prompt/model labels unless the
  run is explicitly labeled outcome-supervised diagnostic evidence.
- For in-loop eligibility, train only on implementation-side features:
  normalized RTL, syntax/operator features, canonical netlist or motif
  features, graph features, and synthesis-trajectory features.
- Outcome-supervised probes may use PPA or descendant labels only to test D1
  or D3 under held-out problems. They do not justify in-loop use by
  themselves.
- Freeze the encoder before replay or live evaluation.

## Escalation Order

1. Larger common-audit Qwen3 extraction:
   run Qwen3 on a broader valid-PPA slice with raw, comment-stripped,
   identifier-normalized, and Yosys-normalized RTL. Compare against lexical,
   canonical-netlist, motif, and common-audit baselines.
2. Richer AURORA-style encoder:
   train a non-PPA autoencoder or contrastive encoder on D_code, D_struct, and
   D_synth features, not only the four common-audit axes. Evaluate latent
   dimensions 8 and 16 before any in-loop claim.
3. Frozen projection or LoRA diagnostic:
   train a small projection head, or LoRA only if necessary, over frozen Qwen
   embeddings with augmentation positives and same-problem hard negatives.
   Keep outcome labels out unless the run is labeled diagnostic-only.
4. Graph encoder retry:
   do not rerun the collapsed DeepGate tokenizer path as-is. First define a
   sequential-state policy, cone split, or alternate graph encoder
   (DeepSeq, NetTAG, CircuitFusion, or a simpler message-passing baseline)
   that covers sequential RTL.
5. Live sampling:
   launch only after an offline encoder passes a utility gate under common
   audit. Use the vLLM preflight and 128k-token policy from the goal.

## No-Proceed Thresholds

- Collapse: fail if pairwise cosine mean is above 0.99 or any latent axis has
  near-zero standard deviation after normalization.
- Stability: fail if identifier/comment/Yosys perturbations dominate
  nearest-neighbor structure without matching netlist or motif agreement.
- D1: fail if held-out predictive signal does not beat the lexical baseline
  by at least 0.10 Spearman rho on the primary metric.
- D3: fail if replay hypervolume gain over best-fitness retention is below
  10% or valid-PPA coverage drops by more than 5 percentage points.
- D4/D5: fail if live or replay evidence repeats the ST-NOD-style robustness
  drop or does not beat the random descriptor control.

## First Concrete Next Run

Start with a richer AURORA-style diagnostic, not full finetuning:

- build a training table from candidate audit rows with recovered RTL,
  canonical/motif hashes, synthesis-valid status, and synthesis-trajectory
  features where present;
- train on implementation-only features with held-out problems;
- evaluate against common-audit and best-fitness replay controls;
- record the encoder card before considering Qwen projection, LoRA, or live
  sampling.
