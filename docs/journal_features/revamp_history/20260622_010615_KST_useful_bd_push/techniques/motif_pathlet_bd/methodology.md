# Motif Pathlet BD Methodology

## Intent

Represent RTL candidates by structural implementation families rather than raw
size. This method tests whether motifs, local path shapes, fanout, and
reconvergence expose meaningful diversity that Yosys counts miss.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Yosys mapped JSON or AIG/netlist graph emitted before final PPA.
- Optional sequential boundaries from FF, latch, input, and output nodes.

Descriptor inputs exclude final PPA, reference PPA, fitness, hypervolume, and
test pass labels.

## Preprocessing

1. Build a directed graph from mapped cells and nets.
2. Collapse equivalent buffer/inverter chains with a recorded rule.
3. Label each node by coarse type: logic, mux, arithmetic, compare, memory,
   sequential, input, output, constant, or other.
4. Canonicalize graph labels so signal names do not dominate the descriptor.
5. Extract only synthesis-valid graphs; invalid graphs remain in the funnel.

## Descriptor

Compute a sparse vector containing:

- rooted 2-hop and 3-hop typed neighborhoods;
- pathlet histograms from PI/FF sources to PO/FF sinks for lengths 1 to 8;
- reconvergence markers where paths split and rejoin within a bounded radius;
- fanout bucket counts for 1, 2, 3-4, 5-8, and 9+ sinks;
- sequential cone balance: FF-to-FF, PI-to-FF, FF-to-PO, and PI-to-PO ratios;
- top-k motif occupancy after hashing typed neighborhoods with a stable hash.

Use log1p counts, benchmark-level robust scaling, and an explicit unknown motif
bucket. Store the hash salt and motif vocabulary.

## Archive Mapping

Evaluate two archive views:

- grid over motif entropy and reconvergence density;
- CVT over the full sparse motif/pathlet vector after truncated SVD.

The grid view is interpretable. The CVT view tests whether higher dimensional
motif structure has useful archive pressure.

## Parent Selection Coupling

Use normal QD occupancy for exploration. Do not reward large motif counts by
themselves; replacement remains based on the configured optimization objective
and validity constraints.

## Expected Outputs

- `tables/motif_vocabulary.csv`
- `tables/pathlet_features.csv`
- `tables/archive_metrics.csv`
- `figures/motif_entropy_vs_ppa.png`
- `figures/archive_coverage_heatmap.png`
