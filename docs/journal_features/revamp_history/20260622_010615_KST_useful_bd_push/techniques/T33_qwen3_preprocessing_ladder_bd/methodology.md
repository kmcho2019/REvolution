# Qwen3 Preprocessing Ladder BD Methodology

## Intent

Test whether Qwen3 embeddings become useful behavior descriptors after
hardware-aware, PPA-free preprocessing. This is the direct follow-up to T06:
T06 showed identifier-normalized Qwen can retain hypervolume signal, but its
nearest-neighbor graph is dominated by same-problem and same-corpus effects.

T33 does not ask whether raw Qwen embeddings work. That was already tested.
T33 asks which normalized RTL/netlist view and pooling rule suppresses nuisance
clustering while preserving useful PPA-front and archive-diversity signal.

## Inputs

- Prior T06 candidates and diagnostics from
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/`.
- Committed T06 report bundle under the 20260621 compiled diversity results.
- Frozen useful-BD replay and holdout subsets from the current revamp root.
- A fixed Qwen3 embedding model, tokenizer, prompt, and pooling policy.

Descriptor construction must not use final PPA, reference PPA, fitness,
hypervolume, Pareto labels, pass/fail labels, or synthesis-validity labels.
Those fields are evaluation-only.

## Preprocessing Ladder

Run all views with the same model and embedding settings:

1. `raw_rtl`: original RTL text, retained only as the T06 reference ablation.
2. `commentless_rtl`: comments removed and whitespace normalized.
3. `identifier_role_rtl`: internal identifiers replaced by deterministic role
   names such as `wire_0007`, `reg_0002`, and `tmp_0012`. Preserve port roles,
   widths, signedness, operators, clock/reset polarity, and block structure.
4. `canonical_rtl`: deterministically serialized RTL with sorted declarations,
   normalized literals, stable procedural block order, and role identifiers.
5. `canonical_yosys_netlist`: fixed non-PPA Yosys normalization, then
   topologically sorted rows with cell type, fanin role, fanout bucket, bit
   width, and sequential-boundary tag.
6. `summary_plus_netlist`: compact structural summary concatenated with the
   canonical netlist view. The summary includes I/O shape, operator histogram,
   cell-family histogram, motif/pathlet counts, reconvergence buckets, and
   sequential-state counts.

Each view writes a manifest row with view name, source candidate id, content
hash, byte count, token count, preprocessing script hash, and Yosys script hash
when applicable.

## Embedding And Pooling

Chunk text at stable hardware boundaries:

- modules;
- declaration groups;
- continuous assignment groups;
- `always` blocks;
- topological netlist levels.

Embed every chunk, L2-normalize chunk embeddings, and pool to a whole-design
embedding. The primary pool is square-root token weighted mean because it
reduces domination by one long block without making tiny blocks equal to full
modules. Run plain mean and cell-count weighted mean as ablations.

Record model id, revision, tokenizer, prompt, max sequence length, chunk policy,
truncation count, pooling rule, embedding dtype, and embedding cache hash.

## Descriptor Candidates

Fit only PPA-free transforms over the whole-design embeddings:

- whitened PCA axes followed by CVT over 8 or 16 dimensions;
- a 2D grid over the two most stable leakage-checked PCA axes;
- hybrid 2D cells pairing one Qwen3 axis with one deterministic
  synthesis-response axis from the SR raw family;
- residual-norm buckets from reconstruction by the first `k` PCA axes.

UMAP may be used for figures only. It must not be the only archive coordinate.

## Controls

Compare every T33 view and descriptor against:

- lexical farthest-first;
- T06 raw Qwen;
- T06 identifier-normalized Qwen;
- T06 commentless Qwen when present;
- random descriptor control;
- generation-prefix control;
- fitness-top offline upper control.

The fitness-top row is a diagnostic ceiling only. It is not a legal descriptor
or archive-cell rule.

## Metrics

Report both QD and nuisance-axis metrics:

- selected hypervolume and hypervolume delta versus lexical;
- selected best fitness and final-best score where live data exists;
- Pareto-front point count, unique PPA tuples, and front-family count;
- unique canonical RTL, canonical netlist, motif, and structural-summary hashes;
- same-problem nearest-neighbor fraction;
- same-corpus nearest-neighbor fraction;
- same canonical-netlist and same motif nearest-neighbor fractions;
- text length, identifier churn, problem id, and corpus-source correlations;
- archive occupied-cell count, QD score, HV AUC, and coverage AUC where
  archive traces exist.

Any completed package with PPA data must include a standalone raw area-power
PPA Pareto-front PNG before BD-space or HTML-only figures.

## Promotion Gates

T33 can become a `T1 near_classic` candidate only if it:

- beats lexical farthest-first or T22 random on at least one claimed QD/Pareto
  metric;
- does not worsen duplicate collapse versus T06 identifier-normalized Qwen;
- lowers same-problem nearest-neighbor fraction versus T06's `0.9336`;
- preserves every classic-covered design when moved into a live run;
- avoids a 50 percent or larger functionality/synthesis-validity decline when
  the classic passing denominator is at least 10.

If the best view improves only one metric, keep it as `T0 diagnostic` and write
the specific follow-up: projection head, hybrid with SR raw, or branch to a
graph encoder.

## Dependency And Output Plan

New run artifacts belong under:

`exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_<timestamp>/`

Do not write new run artifacts under `/aux`; `/aux` is read-only evidence for
older retrospective analysis.

If the repo uv environment blocks Qwen, tokenizer, Yosys, or parser
dependencies, create an isolated uv environment under:

`exp/useful_bd_push/envs/t33_qwen3_preprocessing_ladder_bd_<timestamp>/`

External source checkouts, if needed, belong under:

`exp/useful_bd_push/sources/`

Dependency friction is not a valid stopping point until the repo env, isolated
uv env, and source-checkout routes have all been tried or explicitly ruled out.

## Planned Stages

1. `T33a`: inventory prior T06 artifacts and freeze candidate ids.
2. `T33b`: generate preprocessing-view caches and manifests.
3. `T33c`: embed all views and pool whole-design vectors.
4. `T33d`: run collapse diagnostics, replay selection, and QD/Pareto scoring.
5. `T33e`: if a view is promising, branch to projection-head or live side
   archive validation.
