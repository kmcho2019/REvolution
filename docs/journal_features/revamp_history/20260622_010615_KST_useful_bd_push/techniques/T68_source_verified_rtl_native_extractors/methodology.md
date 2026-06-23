# T68 Source-Verified RTL-Native Extractors Methodology

## Question

Can we use real MasterRTL SOG and RTL-Timer artifacts as RTL-native behavior
descriptors, rather than only using local proxy features?

## Protocol

1. Clone the original upstream repositories under `exp/external_repos/`.
2. Record the exact upstream commits.
3. Try the upstream conversion commands without changing their source.
4. Build an isolated `uv` environment when the repository environment lacks
   required dependencies.
5. Verify shipped example artifacts quantitatively:
   - MasterRTL SOG graph parse must produce nonempty graph and node dictionaries.
   - MasterRTL saved models must deserialize and run prediction on the shipped
     example feature vectors.
   - RTL-Timer SOG timing feature-label files must load and show nontrivial
     BOG-slack to net-slack alignment.
6. Decide whether the next live QD run can honestly claim upstream-aligned
   MasterRTL/RTLTimer descriptor evidence.

## Glossary

- SOG: MasterRTL simple operator graph, a bit-level RTL operator graph.
- BOG: RTL-Timer Boolean operator graph or pseudo-netlist emitted from Yosys
  and ABC preprocessing.
- `init-word` and `route-word`: RTL-Timer signal-level timing-label stages
  derived from post-synthesis and post-route timing reports.
- `read -verific`: a Yosys frontend command that requires a Yosys build with
  Verific support.
- `vlg2ir` and `vlg2bog`: upstream MasterRTL and RTL-Timer preprocessing
  directories for Verilog-to-graph conversion.

## Leakage Rules

The extractor check may inspect upstream PPA/timing labels only to validate the
upstream repository's own example workflow. Those labels are not allowed as
in-loop BD inputs for REvolution/QD candidates. A future live descriptor must
use only pre-synthesis RTL/operator/timing-risk features or pre-registered
upstream model outputs that do not depend on candidate final PPA, reference
PPA, fitness, Pareto rank, hypervolume, or test pass rate.

## Promotion Rule

T68 cannot be promoted as a QD method. It can only unblock a future technique
if that future technique uses source-aligned conversion/model loading on our
candidate RTL and reports:

- extractor success/failure rate by problem;
- model/checkpoint hashes when weights are used;
- quantitative descriptor sanity metrics;
- reference-complete PPA comparison after the QD run.
