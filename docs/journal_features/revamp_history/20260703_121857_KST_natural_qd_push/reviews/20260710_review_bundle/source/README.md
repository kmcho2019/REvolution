# Source Review Map

This bundle copies only small source files that demonstrate the validation and
reporting contract. The large runtime modules stay canonical in the main tree
to avoid a stale duplicate implementation.

Copied source:

- `scripts/audit_operator_contract.py`: rejects single-thought operator
  contamination.
- `scripts/validate_natural_qd_run.py`: validates run manifests and config
  pins.
- `scripts/report_hv_auc.py`: fixed-denominator canonical HV-AUC reporting.
- `scripts/check_equivalence.py`: Yosys equivalence checking.
- `scripts/generate_realbench_reference_ppa.py`: reproducible RealBench
  reference PPA generation.
- `src/revolution/qd_natural/engine.py`: the deliberately small natural-QD
  experimental extension module.

Canonical runtime entry points not copied:

- `src/revolution/algorithm.py`: conference/classic evolutionary loop.
- `src/revolution/qd/engine.py`: QD runtime.
- `src/revolution/qd/archive.py`: Pareto and archive primitives.
- `src/revolution/runtime/candidate_evaluator.py`: common evaluation pipeline.
- `src/revolution/evaluation.py`: Icarus/Yosys/OpenROAD evaluation.
- `src/revolution/verilator_evaluation.py`: RealBench functional evaluation.
- `scripts/run_backend.py`: canonical experiment runner.
- `scripts/report_journal_statistics.py`: gate-bearing statistical reporter.

The proposed Pareto-Revolution method should reuse `ranked_front` and its
crowding implementation from `src/revolution/qd/archive.py` in one small
selection module. No new descriptor or QD scheduler should be required.
