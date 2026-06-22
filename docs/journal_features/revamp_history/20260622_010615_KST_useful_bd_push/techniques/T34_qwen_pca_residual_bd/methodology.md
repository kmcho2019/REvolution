# T34 Qwen PCA-Residual BD Methodology

## Question

T33 found a split signal: canonical RTL and identifier-role RTL Qwen views
modestly improved selected hypervolume, while netlist views reduced
same-problem/corpus collapse but did not improve PPA-front metrics. T34 asks
whether a simple, label-free projection can suppress dominant nuisance axes in
the useful RTL-view embeddings without using PPA or problem labels.

## Descriptor

For each selected T33 embedding view, fit PCA on the whole 768-candidate
embedding matrix, remove the first `k` principal components, and L2-normalize
the residual vectors. Replay farthest-first selection on those residual
matrices.

Planned residual variants:

- `canonical_rtl` with `k in {1, 4, 8, 16}`;
- `identifier_role_rtl` with `k in {1, 4, 8, 16}`;
- `commentless_rtl` with `k in {1, 4, 8}`;
- `summary_plus_netlist` with `k in {1, 4}`;
- a concatenated `canonical_rtl + canonical_yosys_netlist` residual with
  `k in {4, 8}`.

PCA fitting uses only embedding coordinates. It does not use final PPA,
reference PPA, fitness, hypervolume, Pareto rank, validity labels, problem id,
or corpus id. Problem/corpus labels are used only for post-selection collapse
diagnostics.

## Controls

The replay includes:

- lexical farthest-first;
- random selection;
- generation-prefix selection;
- fitness-top offline ceiling;
- the original T33 base Qwen views for direct comparison.

The fitness-top row is not a legal BD. It is a diagnostic ceiling only.

## Metrics

Primary metrics:

- selected hypervolume and delta versus lexical;
- selected Pareto size;
- unique canonical-netlist and motif-signature counts;
- direct raw area-power front hits after deduplicating area/power points;
- same-problem and same-corpus nearest-neighbor fractions.

Required figures:

- direct raw area-power PPA Pareto front;
- selected hypervolume by representation;
- collapse-versus-HV scatter or table-backed diagnostic plot.

## Tier Gate

T34 can only become `T1 near_classic` if a residual descriptor:

1. beats lexical on selected hypervolume or direct PPA-front hits;
2. improves same-problem or same-corpus collapse versus the corresponding T33
   base view;
3. does not rely on duplicates or invalid candidates;
4. preserves the common replay validity surface.

If the residuals improve collapse but lose HV, or improve HV while keeping
T33's nuisance clustering, T34 remains `T0 diagnostic`.
