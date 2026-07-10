# Literature And Repository Context

The bundle's recommendation is evidence-first. These sources anchor the
standard methods and the two proposed directions.

## Multi-Objective And QD Methods

- K. Deb et al., [A Fast and Elitist Multiobjective Genetic Algorithm:
  NSGA-II](https://doi.org/10.1109/4235.996017), IEEE Transactions on
  Evolutionary Computation, 2002. Basis for global non-domination rank and
  crowding selection.
- K. Deb, [An Efficient Constraint Handling Method for Genetic
  Algorithms](https://doi.org/10.1016/S0045-7825(99)00389-8), 2000. Basis
  for feasibility-first evolutionary selection.
- J.-B. Mouret and J. Clune, [Illuminating Search Spaces by Mapping
  Elites](https://arxiv.org/abs/1504.04909), 2015.
- V. Vassiliades et al., [Using Centroidal Voronoi Tessellations to Scale
  Up the Multidimensional Archive of Phenotypic
  Elites](https://arxiv.org/abs/1610.05729), 2016.
- T. Pierrot et al., [Multi-Objective Quality Diversity
  Optimization](https://arxiv.org/abs/2202.03057), 2022. Basis for Pareto
  fronts inside MAP-Elites cells.

## LLM RTL Feedback And Scale

- S. Thakur et al., [AutoChip: Automating HDL Generation Using LLM
  Feedback](https://arxiv.org/abs/2311.04887), 2023/2024. Relevant iterative
  feedback baseline for the seeded optimization track.
- S. Islam et al., [VeriGraphi: A Multi-Agent Framework of Hierarchical RTL
  Generation for Large Hardware Designs](https://arxiv.org/abs/2604.14550),
  2026. Relevant to the alternative hierarchical path, but materially more
  complex than the proposed seeded-edit track.
- J. Wang et al., [RTL-BenchLS: A Large-Scale Benchmark for RTL Reasoning and
  Generation with Large Language Models](https://arxiv.org/abs/2606.08976),
  2026. Relevant context for larger-design validation and formal checking.

## Local Repository Anchors

- Conference paper snapshot:
  `docs/REvolution_evolutionary_framework_for_RTL_generation_driven_by_LLMs.md`.
- ASP-DAC release:
  `https://github.com/kmcho2019/REvolution/releases/tag/aspdac2026-submission`.
- Classic engine: `src/revolution/algorithm.py`.
- QD engine/archive: `src/revolution/qd/engine.py` and
  `src/revolution/qd/archive.py`.
- Evaluation stack: `src/revolution/evaluation.py` and
  `src/revolution/runtime/candidate_evaluator.py`.
- Canonical runner: `scripts/run_backend.py`.
- Formal check: `scripts/check_equivalence.py`.
- Statistics: `scripts/report_journal_statistics.py`.
