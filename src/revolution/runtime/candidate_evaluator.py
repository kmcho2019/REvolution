from __future__ import annotations

import re
import os
import threading
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Any

from revolution.auto_bd.motif_descriptor import motif_occupancy_descriptor_values
from revolution.auto_bd.netlist_hash import canonical_netlist_hash
from revolution.auto_bd.random_descriptor import random_hash_descriptor_values
from revolution.auto_bd.trajectory_descriptor import (
    synthesis_trajectory_descriptor_values,
)
from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator
from revolution.graph_descriptor_evaluator import GraphDescriptorEvaluator
from revolution.runtime.problem_context import (
    ProblemContext,
    resolve_synthesis_top_module_name,
    resolve_testbench_top_module,
)
from revolution.runtime.problem_spec import ProblemSpec
from revolution.qd.descriptors import (
    descriptor_requirements,
    extract_descriptor_values,
    resolve_descriptor_axes,
)
from revolution.qd.scoring import (
    CircuitType,
    compute_partial_pass_fraction,
    compute_quality_score,
    compute_repair_score,
    functional_quality_score,
    normalize_code_hash,
)
from revolution.rtl_descriptor_evaluator import RTLDescriptorEvaluator
from revolution.simulation_descriptor_evaluator import SimulationDescriptorEvaluator
from revolution.source_aligned_descriptor_evaluator import SourceAlignedRTLDescriptorEvaluator


class CandidateStatus(str, Enum):
    """Normalized candidate-status values shared across backend evaluators."""

    FAILED_FORMAT = "failed_format"
    FAILED_DIFF = "failed_diff"
    FAILED_SYNTAX = "failed_syntax"
    FAILED_FUNCTIONALITY = "failed_functionality"
    FAILED_SYNTHESIS = "failed_synthesis"
    FAILED_SYNTHESIS_FUNCTIONALITY = "failed_synthesis_functionality"
    SKIPPED_SYNTHESIS = "skipped_synthesis"
    SUCCESS = "success"


class EvaluationMode(str, Enum):
    """Evaluation-policy choices for synthesis scheduling behavior."""

    STRICT_ABLATION = "strict_ablation"
    SEARCH_ACCELERATED = "search_accelerated"


_PRE_SYNTHESIS_STATUS = "_pre_synthesis_passed"

# Sanity-check mode (gate_level_functional_recheck=False): a candidate whose
# synthesized area is below this fraction of the reference golden's area is treated
# as a yosys stub-out and rejected (a real design is never ~20x smaller).
_SANITY_MIN_AREA_FRACTION = 0.05


@dataclass
class CandidateEvaluation:
    """Structured evaluation result for one candidate."""

    status: str
    score: float
    stage_statuses: dict[str, bool]
    mismatch_count: int | None = None
    ppa_metrics: dict[str, float] = field(default_factory=dict)
    synthesis_success: bool = False
    synthesis_functionality_success: bool = False
    ppa_success: bool = False
    score_components: dict[str, float] = field(default_factory=dict)
    feedback_payload: dict[str, str] | None = None
    simulation_result: dict[str, Any] | None = None
    synthesis_result: dict[str, Any] | None = None
    synthesis_skipped: bool = False
    quality_score: float | None = None
    repair_score: float | None = None
    quality_mode: str = "ppa"
    circuit_type: CircuitType = "unknown"
    structural_metrics: dict[str, float] = field(default_factory=dict)
    rtl_metrics: dict[str, float] = field(default_factory=dict)
    dynamic_metrics: dict[str, float] = field(default_factory=dict)
    graph_metrics: dict[str, float] = field(default_factory=dict)
    physical_metrics: dict[str, float] = field(default_factory=dict)
    descriptor_values: dict[str, float] = field(default_factory=dict)
    partial_pass_fraction: float = 0.0
    normalized_code_hash: str = ""
    archiveable: bool = False
    archive_rejection_reason: str | None = None


@dataclass
class CandidateWorkItem:
    """Input payload for candidate evaluation."""

    code: str
    code_file_path: str
    initial_status: str = "new"


def parse_mismatch_count(sim_stdout: str) -> int | None:
    """Parse the testbench mismatch count from simulation stdout.

    Primary protocol is the VerilogEval-v2 ``Mismatches: N in M samples``
    line; benches that only emit the v1-style
    ``Total mismatched samples is N out of M`` summary (RealBench e203
    harnesses) are handled as a fallback. Returns None when neither summary
    is present.
    """

    primary = re.search(r"^Mismatches: (\d+)", sim_stdout, re.M)
    if primary:
        return int(primary.group(1))
    fallback = re.search(r"Total mismatched samples is (\d+) out of", sim_stdout)
    if fallback:
        return int(fallback.group(1))
    return None


def _coerce_metric_dict(value: Any) -> dict[str, float]:
    """Normalize a loosely typed metrics payload into one float-valued mapping."""

    if not isinstance(value, dict):
        return {}
    metrics: dict[str, float] = {}
    for key, metric_value in value.items():
        if isinstance(key, str) and isinstance(metric_value, (int, float)):
            metrics[key] = float(metric_value)
    return metrics


def _coerce_result_dict(value: Any) -> dict[str, Any]:
    """Return an evaluator result payload as a mapping when available."""

    return value if isinstance(value, dict) else {}


class CandidateEvaluator:
    """
    Backend-agnostic candidate evaluator that mirrors existing REvolution semantics.
    """

    def __init__(
        self,
        context: ProblemContext,
        problem_description: str,
        verilog_evaluator: VerilogEvaluator,
        synthesis_evaluator: SynthesisEvaluator,
        ref_ppa_metrics: dict[str, float] | None = None,
        problem_spec: ProblemSpec | None = None,
        *,
        failure_score: float = float("-inf"),
        evaluation_mode: str = EvaluationMode.STRICT_ABLATION.value,
        accelerated_synthesis_top_k: int | None = None,
        accelerated_skip_score: float = 0.0,
        quality_mode: str = "auto",
        alpha: float | None = None,
        beta: float | None = None,
        gamma: float | None = None,
        descriptor_profile: str | None = None,
        descriptor_axes: list[str] | tuple[str, ...] | None = None,
        descriptor_file: str | None = None,
        archive_type: str = "grid",
    ) -> None:
        self.context = context
        self.problem_spec = problem_spec
        # Suites whose gate-level functional re-sim is unstable (RealBench) accept
        # PPA on the pre-synthesis RTL gate + synthesis, guarded by a
        # non-degeneracy sanity check instead of the gate-level re-check.
        self.gate_level_functional_recheck = (
            problem_spec.capabilities.gate_level_functional_recheck
            if problem_spec is not None and problem_spec.capabilities is not None
            else True
        )
        self.problem_description = problem_description
        self.verilog_evaluator = verilog_evaluator
        self.synthesis_evaluator = synthesis_evaluator
        self.ref_ppa_metrics = ref_ppa_metrics or {}
        self.failure_score = failure_score
        self.synthesis_top_module_name = resolve_synthesis_top_module_name(context)
        self.testbench_top_module_name = (
            problem_spec.testbench_top_module
            if problem_spec is not None
            else resolve_testbench_top_module(context)
        )
        self.quality_mode = (
            problem_spec.quality_mode
            if quality_mode == "auto" and problem_spec is not None
            else quality_mode
        )
        resolved_circuit_type: CircuitType = (
            problem_spec.circuit_type if problem_spec is not None else "unknown"
        )
        self.circuit_type: CircuitType = resolved_circuit_type
        self.alpha = alpha
        self.beta = beta
        self.gamma = gamma
        resolved_profile = descriptor_profile
        if resolved_profile is None and problem_spec is not None:
            resolved_profile = problem_spec.default_descriptor_profile
        self.descriptor_profile = resolved_profile
        self.descriptor_axes = resolve_descriptor_axes(
            profile_name=self.descriptor_profile,
            explicit_axes=descriptor_axes,
            descriptor_file=descriptor_file,
            archive_type=archive_type,
            circuit_type=self.circuit_type,
        )
        self.descriptor_requirements = descriptor_requirements(self.descriptor_axes)
        self.rtl_descriptor_evaluator = RTLDescriptorEvaluator()
        self.simulation_descriptor_evaluator = SimulationDescriptorEvaluator()
        self.graph_descriptor_evaluator = GraphDescriptorEvaluator()
        self.source_aligned_descriptor_evaluator: SourceAlignedRTLDescriptorEvaluator | None = None
        if evaluation_mode not in {
            EvaluationMode.STRICT_ABLATION.value,
            EvaluationMode.SEARCH_ACCELERATED.value,
        }:
            raise ValueError(
                f"Unsupported evaluation_mode '{evaluation_mode}'. "
                "Expected strict_ablation or search_accelerated."
            )
        if accelerated_synthesis_top_k is not None and accelerated_synthesis_top_k < 0:
            raise ValueError("accelerated_synthesis_top_k must be >= 0 when provided.")
        self.evaluation_mode = evaluation_mode
        self.accelerated_synthesis_top_k = accelerated_synthesis_top_k
        self.accelerated_skip_score = accelerated_skip_score
        (
            self.aux_source_files,
            self.aux_include_dirs,
            self.force_include_headers,
        ) = self._resolve_aux_sources()
        self.compile_defines = self._resolve_compile_defines()
        self._telemetry_lock = threading.Lock()
        # Evaluator-side scheduler telemetry. evaluator_retries is structurally
        # zero today (the evaluator never retries); the field exists so reports
        # can show it explicitly instead of omitting it.
        self.telemetry_counters: dict[str, int] = {
            "candidates_evaluated": 0,
            "rtl_simulation_timeouts": 0,
            "synthesis_failures": 0,
            "evaluator_retries": 0,
        }

    def _bump_telemetry(self, key: str, amount: int = 1) -> None:
        with self._telemetry_lock:
            self.telemetry_counters[key] = self.telemetry_counters.get(key, 0) + amount

    def _resolve_compile_defines(self) -> list[str]:
        """Parse benchmark compile defines from the problem-spec metadata.

        Stored as a comma-separated ``compile_defines`` metadata entry (for
        example RealBench's upstream ``DISABLE_SV_ASSERTION`` guard for e203
        support sources).
        """

        if self.problem_spec is None:
            return []
        raw = self.problem_spec.metadata.get("compile_defines", "")
        return [token.strip() for token in raw.split(",") if token.strip()]

    def _resolve_aux_sources(self) -> tuple[list[str], list[str], list[str]]:
        """Resolve benchmark aux files into compile units, include dirs, and headers.

        Aux files declared by a problem spec (for example RealBench bundled
        dependency modules and defines headers) split into two kinds:

        - module sources (contain a ``module`` declaration): extra compile units
          for the pre-synthesis simulation and synthesis.
        - defines/config headers (no ``module``): NOT compile units. Their names
          are returned as force-include headers, because verilator preprocesses
          each file independently, so a candidate that uses the design's global
          macros (e.g. e203 ``E203_XLEN``) resolves them only if it
          \\`include`s the header itself. The LLM is told to but often omits the
          line, which would otherwise fail every candidate at preprocessing and
          mask its real logic. Only "entry" headers are returned (a header that
          another header already \\`include`s — e203_defines.v -> config.v — is
          dropped so it is not double-included).

        Every aux parent becomes an ``-I`` include path so the force-includes and
        any harness \\`include directives resolve.
        """

        if self.problem_spec is None or not self.problem_spec.aux_files:
            return [], [], []
        root = Path(self.problem_spec.benchmark_root)
        sources: list[str] = []
        include_dirs: list[str] = []
        headers: list[tuple[str, str]] = []
        for raw in self.problem_spec.aux_files:
            path = Path(raw)
            if not path.is_absolute():
                path = root / path
            if not path.is_file() or path.suffix not in {".v", ".sv", ".vh", ".svh"}:
                continue
            parent = str(path.parent.resolve())
            if parent not in include_dirs:
                include_dirs.append(parent)
            text = path.read_text(encoding="utf-8", errors="ignore")
            if re.search(r"(?m)^\s*module\b", text):
                resolved = str(path.resolve())
                if path.suffix in {".v", ".sv"} and resolved not in sources:
                    sources.append(resolved)
            else:
                headers.append((path.name, text))
        force_includes = [
            name
            for name, _ in headers
            if not any(other != name and name in text for other, text in headers)
        ]
        return sources, include_dirs, force_includes

    def _forced_header_path(self, item: CandidateWorkItem) -> str:
        """Return the candidate path to compile, force-including design headers.

        Verilator preprocesses each file independently, so a candidate that uses
        a design's global macros (e.g. e203 ``E203_XLEN``) resolves them only if
        it \\`include`s the defines header. The LLM is instructed to but often
        omits the line; without this every e203 candidate fails preprocessing,
        masking its real logic. Writes a sibling file with the missing
        \\`include lines prepended and returns its path; ``item.code`` and the
        original ``code_file_path`` (used for metrics, feedback, and archival)
        are left untouched. Idempotent: same inputs -> same file. A no-op when
        the problem has no header aux or the candidate already includes them.
        """
        missing = [h for h in self.force_include_headers if h not in item.code]
        if not missing:
            return item.code_file_path
        includes = "".join(f'`include "{h}"\n' for h in missing)
        src = Path(item.code_file_path)
        patched = src.with_name(f"{src.stem}__with_headers{src.suffix}")
        patched.write_text(includes + item.code, encoding="utf-8")
        return str(patched)

    def calculate_fitness_score(self, ppa_metrics: dict[str, float]) -> tuple[float, dict[str, float]]:
        """Compute the QD quality score using the REvolution PPA equation."""
        return compute_quality_score(
            ppa_metrics,
            self.ref_ppa_metrics,
            circuit_type=self.circuit_type,
            alpha=self.alpha,
            beta=self.beta,
            gamma=self.gamma,
        )

    def _base_stage_statuses(self) -> dict[str, bool]:
        return {
            "format": False,
            "diff": False,
            "syntax": False,
            "functionality": False,
            "synthesis": False,
            "synthesis_functionality": False,
            "ppa": False,
        }

    def _extract_descriptor_values(self, result: CandidateEvaluation) -> dict[str, float]:
        descriptor_metrics: dict[str, float] = {}
        descriptor_metrics.update(result.structural_metrics)
        descriptor_metrics.update(result.rtl_metrics)
        descriptor_metrics.update(result.dynamic_metrics)
        descriptor_metrics.update(result.graph_metrics)
        descriptor_metrics.update(result.physical_metrics)
        descriptor_metrics.update(self._extract_auto_bd_netlist_metrics(result))
        descriptor_metrics.update(self._extract_auto_bd_stage_metrics(result))
        descriptor_metrics.update(
            {
                axis: float(result.score_components[axis])
                for axis in ("g_P", "g_A", "g_T")
                if axis in result.score_components
            }
        )
        return extract_descriptor_values(descriptor_metrics, self.descriptor_axes)

    def _extract_auto_bd_netlist_metrics(
        self,
        result: CandidateEvaluation,
    ) -> dict[str, float]:
        needs_hash = self.descriptor_requirements.get("requires_auto_bd_hash", False)
        needs_motif = self.descriptor_requirements.get("requires_auto_bd_motif", False)
        if not (needs_hash or needs_motif):
            return {}
        assert result.synthesis_result is not None
        netlist_path = Path(str(result.synthesis_result["synthesized_netlist_path"]))
        assert netlist_path.is_file()
        netlist_text = netlist_path.read_text(encoding="utf-8", errors="ignore")
        values: dict[str, float] = {}
        if needs_hash:
            values.update(
                random_hash_descriptor_values(canonical_netlist_hash(netlist_text))
            )
        if needs_motif:
            values.update(motif_occupancy_descriptor_values(netlist_text))
        return values

    def _extract_auto_bd_stage_metrics(
        self,
        result: CandidateEvaluation,
    ) -> dict[str, float]:
        if not self.descriptor_requirements.get("requires_auto_bd_stage_dumps", False):
            return {}
        assert result.synthesis_result is not None
        paths = tuple(
            Path(str(path))
            for path in result.synthesis_result["stage_dump_verilog_paths"]
        )
        return synthesis_trajectory_descriptor_values(paths)

    def _enrich_result(
        self,
        item: CandidateWorkItem,
        result: CandidateEvaluation,
    ) -> CandidateEvaluation:
        result.normalized_code_hash = normalize_code_hash(item.code)
        result.quality_mode = self.quality_mode
        result.circuit_type = self.circuit_type
        result.partial_pass_fraction = compute_partial_pass_fraction(result.stage_statuses)

        quality_score = result.quality_score
        if quality_score is None:
            if result.status == CandidateStatus.SUCCESS.value and self.quality_mode == "functional_only":
                quality_score, components = functional_quality_score(
                    functional_score=result.score,
                    structural_metrics=result.structural_metrics,
                )
                result.score_components.update(components)
            else:
                quality_score = result.score
        result.quality_score = quality_score

        if (
            not result.rtl_metrics
            and self.descriptor_requirements.get("requires_rtl_metrics", False)
        ):
            result.rtl_metrics = self.rtl_descriptor_evaluator.extract_metrics(
                code_text=item.code,
                code_file_path=item.code_file_path,
                mapped_cell_count=result.structural_metrics.get("total_cells"),
            )
        if (
            not result.dynamic_metrics
            and self.descriptor_requirements.get("requires_dynamic_metrics", False)
        ):
            result.dynamic_metrics = self._extract_dynamic_metrics(result.simulation_result)
        if (
            not result.graph_metrics
            and result.status == CandidateStatus.SUCCESS.value
            and self.descriptor_requirements.get("requires_graph_metrics", False)
        ):
            result.graph_metrics = self._extract_graph_metrics(item.code_file_path)

        result.archiveable = bool(
            result.status == CandidateStatus.SUCCESS.value
            and (self.quality_mode != "ppa" or result.ppa_success)
        )
        if result.archiveable and not result.descriptor_values and self.descriptor_axes:
            result.descriptor_values = self._extract_descriptor_values(result)
        if not result.archiveable:
            if result.status != CandidateStatus.SUCCESS.value:
                result.archive_rejection_reason = result.status
            elif self.quality_mode == "ppa" and not result.ppa_success:
                result.archive_rejection_reason = "missing_ppa"

        result.repair_score = compute_repair_score(
            result.status,
            stage_statuses=result.stage_statuses,
            partial_pass_fraction=result.partial_pass_fraction,
        )
        return result

    def _extract_dynamic_metrics(
        self,
        simulation_result: dict[str, Any] | None,
    ) -> dict[str, float]:
        """Extract activity descriptors from an optional waveform emitted by simulation."""
        if not simulation_result:
            return {}
        return self.simulation_descriptor_evaluator.extract_metrics(
            vcd_file_path=simulation_result.get("vcd_file_path"),
            top_module_name=self.testbench_top_module_name,
        )

    def _extract_graph_metrics(
        self,
        code_file_path: str | Path,
    ) -> dict[str, float]:
        """Extract graph-theoretic descriptors from the candidate RTL."""
        return self.graph_descriptor_evaluator.extract_metrics(
            code_file_path=code_file_path,
            top_module_name=self.synthesis_top_module_name,
        )

    def _extract_source_aligned_metrics(
        self,
        code_file_path: str | Path,
    ) -> dict[str, float]:
        """Extract source-aligned MasterRTL/RTL-Timer descriptors."""
        if self.source_aligned_descriptor_evaluator is None:
            self.source_aligned_descriptor_evaluator = SourceAlignedRTLDescriptorEvaluator()
        return self.source_aligned_descriptor_evaluator.extract_metrics(
            code_file_path=code_file_path,
            top_module_name=self.synthesis_top_module_name,
        )

    def _evaluate_pre_synthesis(self, item: CandidateWorkItem) -> CandidateEvaluation:
        """Run format/syntax/functionality stages and return an intermediate result."""
        stages = self._base_stage_statuses()
        if item.initial_status == "failed_format":
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": item.code,
                "simulation_log": "Candidate failed format compliance checks.",
            }
            return CandidateEvaluation(
                status=CandidateStatus.FAILED_FORMAT.value,
                score=self.failure_score,
                stage_statuses=stages,
                feedback_payload=feedback_payload,
            )
        if item.initial_status == "failed_diff":
            stages["format"] = True
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": item.code,
                "simulation_log": "Candidate failed diff-application checks.",
            }
            return CandidateEvaluation(
                status=CandidateStatus.FAILED_DIFF.value,
                score=self.failure_score,
                stage_statuses=stages,
                feedback_payload=feedback_payload,
            )

        stages["format"] = True
        stages["diff"] = True

        enable_dynamic_probe = bool(
            self.descriptor_requirements.get("requires_dynamic_metrics", False)
        )
        dut_path = self._forced_header_path(item)
        generated_sources: str | list[str] = (
            [dut_path, *self.aux_source_files]
            if self.aux_source_files
            else dut_path
        )
        sim_results = _coerce_result_dict(
            self.verilog_evaluator.evaluate(
                generated_sources,
                str(self.context.test_sv_path),
                str(self.context.ref_sv_path) if self.context.ref_sv_path else None,
                top_module_name=self.testbench_top_module_name,
                enable_vcd_probe=enable_dynamic_probe,
                include_dirs=self.aux_include_dirs or None,
                defines=self.compile_defines or None,
            )
        )
        dynamic_metrics = (
            self._extract_dynamic_metrics(sim_results) if enable_dynamic_probe else {}
        )
        if sim_results["status"] == "compilation_error":
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": item.code,
                "simulation_log": sim_results.get(
                    "compilation_stderr", "Compilation log not available."
                ),
            }
            return CandidateEvaluation(
                status=CandidateStatus.FAILED_SYNTAX.value,
                score=self.failure_score,
                stage_statuses=stages,
                feedback_payload=feedback_payload,
                simulation_result=sim_results,
                dynamic_metrics=dynamic_metrics,
            )

        self._bump_telemetry("candidates_evaluated")
        if sim_results["status"] == "simulation_timeout":
            self._bump_telemetry("rtl_simulation_timeouts")
        stages["syntax"] = sim_results["status"] == "success"
        sim_stdout = str(sim_results.get("simulation_stdout", ""))
        mismatch_count = parse_mismatch_count(sim_stdout)
        functionality_ok = bool(
            (mismatch_count == 0)
            or ("===========Your Design Passed===========" in sim_stdout)
        )
        if not functionality_ok:
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": item.code,
                "simulation_log": (
                    f"Compilation Log:\n{sim_results.get('compilation_stderr')}\n\n"
                    f"Simulation Log:\n{sim_results.get('simulation_stdout')}\n"
                    f"{sim_results.get('simulation_stderr')}"
                ),
            }
            return CandidateEvaluation(
                status=CandidateStatus.FAILED_FUNCTIONALITY.value,
                score=self.failure_score,
                stage_statuses=stages,
                mismatch_count=mismatch_count,
                feedback_payload=feedback_payload,
                simulation_result=sim_results,
                dynamic_metrics=dynamic_metrics,
            )

        stages["functionality"] = True
        return CandidateEvaluation(
            status=_PRE_SYNTHESIS_STATUS,
            score=self.failure_score,
            stage_statuses=stages,
            mismatch_count=mismatch_count,
            simulation_result=sim_results,
            dynamic_metrics=dynamic_metrics,
        )

    def _passes_synthesis_sanity(
        self,
        ppa_metrics: dict[str, float],
        structural_metrics: dict[str, float],
    ) -> bool:
        """Non-degeneracy gate used when ``gate_level_functional_recheck`` is False.

        Replaces the (unstable, for RealBench) gate-level functional re-sim. It
        rejects degenerate yosys results — empty / stub netlists that would
        otherwise report absurdly low power/area and corrupt PPA scoring — while
        accepting genuine designs. Guards: non-zero power + area, a non-empty
        cell count, and (when a reference exists) an area at least
        ``_SANITY_MIN_AREA_FRACTION`` of the reference, since a real design is
        never orders of magnitude smaller than its golden but a stub is.
        """
        area = ppa_metrics.get("area", 0.0)
        power = ppa_metrics.get("power", 0.0)
        total_cells = structural_metrics.get("total_cells", 0.0)
        if area <= 0.0 or power <= 0.0 or total_cells < 1.0:
            return False
        reference_area = self.ref_ppa_metrics.get("area", 0.0)
        if reference_area > 0.0 and area < reference_area * _SANITY_MIN_AREA_FRACTION:
            return False
        return True

    def _evaluate_synthesis(
        self,
        item: CandidateWorkItem,
        pre_synthesis: CandidateEvaluation,
    ) -> CandidateEvaluation:
        stages = dict(pre_synthesis.stage_statuses)
        sim_results = pre_synthesis.simulation_result
        mismatch_count = pre_synthesis.mismatch_count
        dynamic_metrics = dict(pre_synthesis.dynamic_metrics)

        dut_path = self._forced_header_path(item)
        report_base_path = dut_path.rsplit(".", 1)[0]
        output_dir = os.path.dirname(item.code_file_path)
        synth_results = _coerce_result_dict(
            self.synthesis_evaluator.evaluate(
                dut_path,
                self.context.problem_name,
                self.synthesis_top_module_name,
                output_dir,
                report_base_path,
                self.verilog_evaluator,
                str(self.context.test_sv_path),
                str(self.context.ref_sv_path) if self.context.ref_sv_path else None,
                aux_files=tuple(self.aux_source_files),
                include_dirs=tuple(self.aux_include_dirs),
                defines=tuple(self.compile_defines),
                gate_level_functional_recheck=self.gate_level_functional_recheck,
            )
        )
        synth_success = bool(synth_results.get("synthesis_success"))
        if not synth_success:
            self._bump_telemetry("synthesis_failures")
        post_synth_success = bool(synth_results.get("synthesis_functionality_success"))
        ppa_success = bool(synth_results.get("ppa_success"))
        ppa_metrics = _coerce_metric_dict(synth_results.get("ppa_metrics"))
        physical_metrics = _coerce_metric_dict(synth_results.get("physical_metrics"))
        structural_metrics = _coerce_metric_dict(synth_results.get("structural_metrics"))
        # Sanity-check mode (e.g. RealBench): the gate-level re-sim was skipped, so
        # PPA acceptance is gated on a non-degeneracy check that rejects yosys
        # stub-outs (absurdly low PPA) instead of the gate-level functional pass.
        if synth_success and not self.gate_level_functional_recheck:
            post_synth_success = self._passes_synthesis_sanity(ppa_metrics, structural_metrics)
        if synth_success and ppa_success and self.descriptor_requirements.get(
            "requires_auto_bd_stage_dumps",
            False,
        ):
            stage_dump_result = self.synthesis_evaluator.run_yosys_stage_dumps(
                verilog_file=dut_path,
                synth_top_module_name=self.synthesis_top_module_name,
                output_directory=output_dir,
                aux_files=tuple(self.aux_source_files),
                include_dirs=tuple(self.aux_include_dirs),
                defines=tuple(self.compile_defines),
            )
            synth_results.update(stage_dump_result)
            ppa_success = bool(stage_dump_result.get("stage_dump_success"))
        rtl_metrics = self.rtl_descriptor_evaluator.extract_metrics(
            code_text=item.code,
            code_file_path=item.code_file_path,
            mapped_cell_count=structural_metrics.get("total_cells"),
        )
        graph_metrics = {}
        if synth_success:
            graph_metrics = (
                self._extract_graph_metrics(item.code_file_path)
                if self.descriptor_requirements.get("requires_graph_metrics", False)
                else {}
            )
            if self.descriptor_requirements.get("requires_source_aligned_rtl", False):
                graph_metrics.update(
                    self._extract_source_aligned_metrics(item.code_file_path)
                )
        if synth_success and post_synth_success and ppa_success:
            stages["synthesis"] = True
            stages["synthesis_functionality"] = True
            stages["ppa"] = True
            score, components = self.calculate_fitness_score(ppa_metrics)
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": item.code,
                "simulation_log": (
                    "Functionality OK and Synthesis OK. Now focus on improving PPA metrics while "
                    "preserving functionality. PPA metrics (tns/wns/eff_clk_period: ns, power: W, area: um^2): "
                    f"{ppa_metrics}, Reference PPA metrics: {self.ref_ppa_metrics}, PPA score: {score:.4f}, "
                    "Try to improve PPA metrics further. If effective clockspeed is close to 0.0, "
                    "focus on improving area and power metrics."
                ),
            }
            return CandidateEvaluation(
                status=CandidateStatus.SUCCESS.value,
                score=score,
                stage_statuses=stages,
                mismatch_count=mismatch_count,
                ppa_metrics=ppa_metrics,
                synthesis_success=True,
                synthesis_functionality_success=True,
                ppa_success=True,
                score_components=components,
                feedback_payload=feedback_payload,
                simulation_result=sim_results,
                synthesis_result=synth_results,
                quality_score=score,
                structural_metrics=structural_metrics,
                physical_metrics=physical_metrics,
                rtl_metrics=rtl_metrics,
                dynamic_metrics=dynamic_metrics,
                graph_metrics=graph_metrics,
            )

        if not synth_success:
            status = CandidateStatus.FAILED_SYNTHESIS.value
            synthesis_log = (
                "Functionality OK, but synthesis failed.\nLog:\n"
                f"{synth_results.get('synthesis_log', 'N/A')}"
            )
        elif not post_synth_success:
            status = CandidateStatus.FAILED_SYNTHESIS_FUNCTIONALITY.value
            synthesis_log = (
                "Functionality OK, Synthesis OK, but Post-Synthesis Functional Check failed.\nLog:\n"
                f"{synth_results.get('synthesis_log', 'N/A')}"
            )
        else:
            status = CandidateStatus.FAILED_SYNTHESIS.value
            synthesis_log = (
                "Synthesis or PPA failed.\nLog:\n"
                f"{synth_results.get('synthesis_log', 'N/A')}"
            )

        stages["synthesis"] = synth_success
        stages["synthesis_functionality"] = post_synth_success
        feedback_payload = {
            "problem_def": self.problem_description,
            "code": item.code,
            "simulation_log": synthesis_log,
        }
        return CandidateEvaluation(
            status=status,
            score=self.failure_score,
            stage_statuses=stages,
            mismatch_count=mismatch_count,
            ppa_metrics=ppa_metrics,
            synthesis_success=synth_success,
            synthesis_functionality_success=post_synth_success,
            ppa_success=ppa_success,
            feedback_payload=feedback_payload,
            simulation_result=sim_results,
            synthesis_result=synth_results,
            structural_metrics=structural_metrics,
            rtl_metrics=rtl_metrics,
            dynamic_metrics=dynamic_metrics,
            graph_metrics=graph_metrics,
            physical_metrics=physical_metrics,
        )

    def _mark_synthesis_skipped(
        self,
        item: CandidateWorkItem,
        pre_synthesis: CandidateEvaluation,
    ) -> CandidateEvaluation:
        feedback_payload = {
            "problem_def": self.problem_description,
            "code": item.code,
            "simulation_log": (
                "Functionality passed. Synthesis was intentionally skipped under "
                "search_accelerated mode due to synthesis_top_k throttling."
            ),
        }
        return CandidateEvaluation(
            status=CandidateStatus.SKIPPED_SYNTHESIS.value,
            score=self.accelerated_skip_score,
            stage_statuses=dict(pre_synthesis.stage_statuses),
            mismatch_count=pre_synthesis.mismatch_count,
            feedback_payload=feedback_payload,
            simulation_result=pre_synthesis.simulation_result,
            dynamic_metrics=pre_synthesis.dynamic_metrics,
            synthesis_skipped=True,
        )

    def _evaluate_candidate_strict(self, item: CandidateWorkItem) -> CandidateEvaluation:
        pre = self._evaluate_pre_synthesis(item)
        if pre.status != _PRE_SYNTHESIS_STATUS:
            return self._enrich_result(item, pre)
        return self._enrich_result(item, self._evaluate_synthesis(item, pre))

    def evaluate_candidate(self, item: CandidateWorkItem) -> CandidateEvaluation:
        """Run evaluation for one candidate using the configured evaluation mode."""
        if self.evaluation_mode == EvaluationMode.STRICT_ABLATION.value:
            return self._evaluate_candidate_strict(item)

        pre = self._evaluate_pre_synthesis(item)
        if pre.status != _PRE_SYNTHESIS_STATUS:
            return self._enrich_result(item, pre)
        top_k = self.accelerated_synthesis_top_k
        if top_k is not None and top_k <= 0:
            return self._enrich_result(item, self._mark_synthesis_skipped(item, pre))
        return self._enrich_result(item, self._evaluate_synthesis(item, pre))

    def _select_synthesis_indices(
        self,
        items: list[CandidateWorkItem],
        pre_results: list[CandidateEvaluation],
    ) -> set[int]:
        """Select which functionality-pass candidates should run synthesis in accelerated mode."""
        functionality_pass_indices = [
            idx for idx, result in enumerate(pre_results) if result.status == _PRE_SYNTHESIS_STATUS
        ]
        if not functionality_pass_indices:
            return set()
        top_k = self.accelerated_synthesis_top_k
        if top_k is None:
            return set(functionality_pass_indices)
        if top_k <= 0:
            return set()
        if top_k >= len(functionality_pass_indices):
            return set(functionality_pass_indices)
        # Deterministic throttling policy: synthesize the shortest functional candidates first.
        ranked = sorted(functionality_pass_indices, key=lambda idx: (len(items[idx].code), idx))
        return set(ranked[:top_k])

    def evaluate_candidates(
        self,
        items: list[CandidateWorkItem],
        *,
        candidate_workers: int = 0,
    ) -> list[CandidateEvaluation]:
        """Evaluate a batch of candidates, optionally with thread parallelism."""
        if self.evaluation_mode == EvaluationMode.STRICT_ABLATION.value:
            if candidate_workers > 1:
                with ThreadPoolExecutor(max_workers=candidate_workers) as executor:
                    futures = [executor.submit(self._evaluate_candidate_strict, item) for item in items]
                    return [future.result() for future in futures]
            return [self._evaluate_candidate_strict(item) for item in items]

        if candidate_workers > 1:
            with ThreadPoolExecutor(max_workers=candidate_workers) as executor:
                pre_futures = [executor.submit(self._evaluate_pre_synthesis, item) for item in items]
                pre_results = [future.result() for future in pre_futures]
        else:
            pre_results = [self._evaluate_pre_synthesis(item) for item in items]

        synth_indices = self._select_synthesis_indices(items, pre_results)
        final_results: list[CandidateEvaluation] = [
            CandidateEvaluation(status="", score=0.0, stage_statuses={})
            for _ in items
        ]

        if candidate_workers > 1 and len(synth_indices) > 1:
            with ThreadPoolExecutor(max_workers=candidate_workers) as executor:
                synth_futures = {
                    idx: executor.submit(self._evaluate_synthesis, items[idx], pre_results[idx])
                    for idx in synth_indices
                }
                for idx in synth_indices:
                    final_results[idx] = self._enrich_result(
                        items[idx], synth_futures[idx].result()
                    )
        else:
            for idx in synth_indices:
                final_results[idx] = self._enrich_result(
                    items[idx], self._evaluate_synthesis(items[idx], pre_results[idx])
                )

        for idx, pre in enumerate(pre_results):
            if pre.status != _PRE_SYNTHESIS_STATUS:
                final_results[idx] = self._enrich_result(items[idx], pre)
                continue
            if idx in synth_indices:
                continue
            final_results[idx] = self._enrich_result(
                items[idx], self._mark_synthesis_skipped(items[idx], pre)
            )
        return final_results
