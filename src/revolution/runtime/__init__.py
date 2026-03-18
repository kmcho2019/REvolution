from __future__ import annotations

from importlib import import_module
from typing import TYPE_CHECKING, Any

__all__ = [
    "ArtifactWriter",
    "CandidateEvaluation",
    "CandidateEvaluator",
    "CandidateStatus",
    "CandidateWorkItem",
    "CVDPEvaluator",
    "DiffApplyConfig",
    "DiffApplier",
    "DiffApplyPolicy",
    "EvaluationMode",
    "ProblemContext",
    "ProblemSpec",
    "RTLDescriptorEvaluator",
    "StructuralEvaluator",
    "build_cvdp_problem_context",
    "build_cvdp_problem_spec",
    "build_problem_spec",
    "build_realbench_problem_context",
    "build_realbench_problem_spec",
    "add_legacy_strategy_key_alias",
    "default_benchmark_root",
    "load_cvdp_record",
    "load_problem_context",
    "load_realbench_manifest",
    "load_realbench_record",
    "load_realbench_reference_ppa_metrics",
    "resolve_synthesis_top_module_name",
    "resolve_testbench_top_module",
    "resolve_top_module_name",
    "select_cvdp_ids",
    "select_realbench_problem_ids",
]

_EXPORT_MAP = {
    "ArtifactWriter": ("revolution.runtime.run_artifacts", "ArtifactWriter"),
    "CandidateEvaluation": (
        "revolution.runtime.candidate_evaluator",
        "CandidateEvaluation",
    ),
    "CandidateEvaluator": (
        "revolution.runtime.candidate_evaluator",
        "CandidateEvaluator",
    ),
    "CandidateStatus": ("revolution.runtime.candidate_evaluator", "CandidateStatus"),
    "CandidateWorkItem": (
        "revolution.runtime.candidate_evaluator",
        "CandidateWorkItem",
    ),
    "CVDPEvaluator": ("revolution.runtime.cvdp_evaluator", "CVDPEvaluator"),
    "DiffApplyConfig": ("revolution.runtime.diff_apply", "DiffApplyConfig"),
    "DiffApplier": ("revolution.runtime.diff_apply", "DiffApplier"),
    "DiffApplyPolicy": ("revolution.runtime.diff_apply", "DiffApplyPolicy"),
    "EvaluationMode": ("revolution.runtime.candidate_evaluator", "EvaluationMode"),
    "ProblemContext": ("revolution.runtime.problem_context", "ProblemContext"),
    "ProblemSpec": ("revolution.runtime.problem_spec", "ProblemSpec"),
    "RTLDescriptorEvaluator": (
        "revolution.rtl_descriptor_evaluator",
        "RTLDescriptorEvaluator",
    ),
    "StructuralEvaluator": (
        "revolution.runtime.structural_evaluator",
        "StructuralEvaluator",
    ),
    "add_legacy_strategy_key_alias": (
        "revolution.runtime.run_artifacts",
        "add_legacy_strategy_key_alias",
    ),
    "build_cvdp_problem_context": (
        "revolution.runtime.cvdp_evaluator",
        "build_cvdp_problem_context",
    ),
    "build_cvdp_problem_spec": (
        "revolution.runtime.problem_spec",
        "build_cvdp_problem_spec",
    ),
    "build_problem_spec": ("revolution.runtime.problem_spec", "build_problem_spec"),
    "build_realbench_problem_context": (
        "revolution.runtime.realbench_adapter",
        "build_realbench_problem_context",
    ),
    "build_realbench_problem_spec": (
        "revolution.runtime.realbench_adapter",
        "build_realbench_problem_spec",
    ),
    "default_benchmark_root": (
        "revolution.runtime.problem_context",
        "default_benchmark_root",
    ),
    "load_cvdp_record": ("revolution.runtime.cvdp_evaluator", "load_cvdp_record"),
    "load_problem_context": ("revolution.runtime.problem_context", "load_problem_context"),
    "load_realbench_manifest": (
        "revolution.runtime.realbench_adapter",
        "load_realbench_manifest",
    ),
    "load_realbench_record": (
        "revolution.runtime.realbench_adapter",
        "load_realbench_record",
    ),
    "load_realbench_reference_ppa_metrics": (
        "revolution.runtime.realbench_adapter",
        "load_realbench_reference_ppa_metrics",
    ),
    "resolve_synthesis_top_module_name": (
        "revolution.runtime.problem_context",
        "resolve_synthesis_top_module_name",
    ),
    "resolve_testbench_top_module": (
        "revolution.runtime.problem_context",
        "resolve_testbench_top_module",
    ),
    "resolve_top_module_name": (
        "revolution.runtime.problem_context",
        "resolve_top_module_name",
    ),
    "select_cvdp_ids": ("revolution.runtime.cvdp_evaluator", "select_cvdp_ids"),
    "select_realbench_problem_ids": (
        "revolution.runtime.realbench_adapter",
        "select_realbench_problem_ids",
    ),
}

if TYPE_CHECKING:
    from revolution.rtl_descriptor_evaluator import RTLDescriptorEvaluator
    from revolution.runtime.candidate_evaluator import (
        CandidateEvaluation,
        CandidateEvaluator,
        CandidateStatus,
        CandidateWorkItem,
        EvaluationMode,
    )
    from revolution.runtime.cvdp_evaluator import (
        CVDPEvaluator,
        build_cvdp_problem_context,
        load_cvdp_record,
        select_cvdp_ids,
    )
    from revolution.runtime.diff_apply import DiffApplyConfig, DiffApplier, DiffApplyPolicy
    from revolution.runtime.problem_context import (
        ProblemContext,
        default_benchmark_root,
        load_problem_context,
        resolve_synthesis_top_module_name,
        resolve_testbench_top_module,
        resolve_top_module_name,
    )
    from revolution.runtime.problem_spec import (
        ProblemSpec,
        build_cvdp_problem_spec,
        build_problem_spec,
    )
    from revolution.runtime.realbench_adapter import (
        build_realbench_problem_context,
        build_realbench_problem_spec,
        load_realbench_manifest,
        load_realbench_record,
        load_realbench_reference_ppa_metrics,
        select_realbench_problem_ids,
    )
    from revolution.runtime.run_artifacts import (
        ArtifactWriter,
        add_legacy_strategy_key_alias,
    )
    from revolution.runtime.structural_evaluator import StructuralEvaluator


def __getattr__(name: str) -> Any:
    target = _EXPORT_MAP.get(name)
    if target is None:
        raise AttributeError(f"module {__name__!r} has no attribute {name!r}")
    module_name, attr_name = target
    value = getattr(import_module(module_name), attr_name)
    globals()[name] = value
    return value


def __dir__() -> list[str]:
    return sorted(set(globals()) | set(__all__))
