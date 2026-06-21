# Simple Yosys Stat BD Methodology

## Intent

Use deterministic Yosys netlist statistics as the strongest simple control.
This should answer whether a transparent, non-learned descriptor can match or
approach the classic REvolution baseline before adding learned encoders.

## Inputs

- Candidate RTL emitted by the common evolution pipeline.
- Fixed benchmark metadata: problem id, seed, prompt/model id, and operator id.
- A fixed Yosys synthesis script that stops before OpenROAD or any final PPA
  measurement.
- Optional mapped Verilog and JSON netlist emitted by Yosys.

Do not use final PPA, reference PPA, fitness, hypervolume, Pareto rank, or
functional test pass rate as descriptor inputs.

## Preprocessing

1. Canonicalize RTL with the repository's existing normalization utilities.
2. Run Yosys with a fixed script such as `read_verilog; hierarchy; proc; opt;
   techmap; abc; opt_clean; stat -json; write_json`.
3. Parse `stat -json` and the JSON netlist with structured parsers.
4. Assert that required count fields exist. Candidates missing synthesis JSON
   enter the validity funnel and are not credited as useful diversity.

## Descriptor

Construct a vector with:

- log-scaled cell counts by cell type;
- wire, bit, memory, process, and module counts;
- PI, PO, FF, latch, mux, arithmetic, comparator, and reduction-op counts;
- estimated logic depth from topological levels in the mapped graph;
- fanout summary statistics: mean, p90, max, and zero-fanout count;
- normalized ratios: sequential fraction, mux fraction, arithmetic fraction,
  control fraction, and wire-bit-per-cell ratio.

Normalize per benchmark using the baseline corpus median and median absolute
deviation. Clip normalized coordinates to fixed bounds before binning.

## Current Replay Variant

The first active-goal replay packages the historical
`development_preliminary_seed1/simple_yosys_stat_bd/seed_1001` standard-result
artifacts from the 20260618 Auto-BD worktree. That run used the compact
Yosys-stat profile:

- `cell_count_log`;
- `seq_ratio`;
- `mux_ratio`.

The archive substrate was `grid_quantile` with Pareto-front cells,
`nsga2_global_rank` parent selection, eight warmup successes, and the same
model/budget/prompt policy as the seed-1 classic and landing manual-BD
baselines. The replay report in this package does not refit or change the
descriptor; it re-scores the existing artifacts under the useful-BD tier rules
and central metric vocabulary.

## Archive Mapping

Run both mappings:

- 2D grid: first two robust-PCA axes fitted on baseline plus replay candidates.
- CVT grid: 8 to 32 dimensional normalized vector assigned to fixed centroids.

The PCA/CVT fit must be frozen before live sampling. Store fit parameters and
centroid hashes in `artifacts_manifest.md`.

## Parent Selection Coupling

Use the same QD archive replacement rule as landing Smooth-QD unless a
versioned exception is recorded. Parent selection may sample from occupied BD
cells, but it must not prefer cells by PPA labels that are not part of the
existing QD objective.

## Expected Outputs

- `tables/validity_funnel.csv`
- `tables/leaderboard_comparison.csv`
- `tables/archive_metrics.csv`
- `tables/per_problem_deltas_vs_classic.csv`
- `tables/metric_deltas_vs_classic.csv`
- `figures/seed1_mean_hypervolume.png`
- `figures/seed1_common_audit_coverage.png`
- `figures/seed1_ppa_grid_coverage.png`
- `figures/seed1_common_audit_cells_heatmap.png`
- `results_report.md` with tier decision and per-problem deltas
