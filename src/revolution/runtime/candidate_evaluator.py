from __future__ import annotations

import re
import os
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field
from enum import StrEnum
from typing import Any

from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator
from revolution.runtime.problem_context import ProblemContext, resolve_top_module_name


class CandidateStatus(StrEnum):
    FAILED_FORMAT = "failed_format"
    FAILED_DIFF = "failed_diff"
    FAILED_SYNTAX = "failed_syntax"
    FAILED_FUNCTIONALITY = "failed_functionality"
    FAILED_SYNTHESIS = "failed_synthesis"
    FAILED_SYNTHESIS_FUNCTIONALITY = "failed_synthesis_functionality"
    SKIPPED_SYNTHESIS = "skipped_synthesis"
    SUCCESS = "success"


class EvaluationMode(StrEnum):
    STRICT_ABLATION = "strict_ablation"
    SEARCH_ACCELERATED = "search_accelerated"


_PRE_SYNTHESIS_STATUS = "_pre_synthesis_passed"


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


@dataclass
class CandidateWorkItem:
    """Input payload for candidate evaluation."""

    code: str
    code_file_path: str
    initial_status: str = "new"


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
        *,
        failure_score: float = float("-inf"),
        evaluation_mode: str = EvaluationMode.STRICT_ABLATION.value,
        accelerated_synthesis_top_k: int | None = None,
        accelerated_skip_score: float = 0.0,
    ) -> None:
        self.context = context
        self.problem_description = problem_description
        self.verilog_evaluator = verilog_evaluator
        self.synthesis_evaluator = synthesis_evaluator
        self.ref_ppa_metrics = ref_ppa_metrics or {}
        self.failure_score = failure_score
        self.top_module_name = resolve_top_module_name(context)
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

    def calculate_fitness_score(self, ppa_metrics: dict[str, float]) -> tuple[float, dict[str, float]]:
        """Compute REvolution fitness from candidate and reference PPA metrics."""
        p_gen = ppa_metrics.get("power")
        a_gen = ppa_metrics.get("area")
        t_gen = ppa_metrics.get("eff_clk_period")

        p_ref = self.ref_ppa_metrics.get("power")
        a_ref = self.ref_ppa_metrics.get("area")
        t_ref = self.ref_ppa_metrics.get("eff_clk_period")
        if any(v is None for v in (p_gen, a_gen, t_gen, p_ref, a_ref, t_ref)):
            return 0.0, {}

        # Keep historical behavior for zero values to avoid divide-by-zero.
        p_gen = p_gen if p_gen else 1.0
        a_gen = a_gen if a_gen else 1.0
        t_gen = t_gen if t_gen else 1.0
        p_ref = p_ref if p_ref else 1.0
        a_ref = a_ref if a_ref else 1.0
        t_ref = t_ref if t_ref else 1.0

        power_improvement = (p_gen - p_ref) / p_ref
        area_improvement = (a_gen - a_ref) / a_ref
        components: dict[str, float] = {
            "power_improvement": power_improvement,
            "area_improvement": area_improvement,
        }
        if t_ref == 0.0:
            total_improvement = (power_improvement + area_improvement) / 2
        else:
            timing_improvement = (t_gen - t_ref) / t_ref
            components["timing_improvement"] = timing_improvement
            total_improvement = (
                power_improvement + area_improvement + timing_improvement
            ) / 3
        return -total_improvement, components

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

        sim_results = self.verilog_evaluator.evaluate(
            item.code_file_path,
            str(self.context.test_sv_path),
            str(self.context.ref_sv_path) if self.context.ref_sv_path else None,
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
            )

        stages["syntax"] = sim_results["status"] == "success"
        sim_stdout = str(sim_results.get("simulation_stdout", ""))
        mismatch_match = re.search(r"^Mismatches: (\d+)", sim_stdout, re.M)
        mismatch_count = int(mismatch_match.group(1)) if mismatch_match else None
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
            )

        stages["functionality"] = True
        return CandidateEvaluation(
            status=_PRE_SYNTHESIS_STATUS,
            score=self.failure_score,
            stage_statuses=stages,
            mismatch_count=mismatch_count,
            simulation_result=sim_results,
        )

    def _evaluate_synthesis(
        self,
        item: CandidateWorkItem,
        pre_synthesis: CandidateEvaluation,
    ) -> CandidateEvaluation:
        stages = dict(pre_synthesis.stage_statuses)
        sim_results = pre_synthesis.simulation_result
        mismatch_count = pre_synthesis.mismatch_count

        report_base_path = item.code_file_path.rsplit(".", 1)[0]
        output_dir = os.path.dirname(item.code_file_path)
        synth_results = self.synthesis_evaluator.evaluate(
            item.code_file_path,
            self.context.problem_name,
            self.top_module_name,
            output_dir,
            report_base_path,
            self.verilog_evaluator,
            str(self.context.test_sv_path),
            str(self.context.ref_sv_path) if self.context.ref_sv_path else None,
        )
        synth_success = bool(synth_results.get("synthesis_success"))
        post_synth_success = bool(synth_results.get("synthesis_functionality_success"))
        ppa_success = bool(synth_results.get("ppa_success"))
        ppa_metrics = synth_results.get("ppa_metrics") or {}
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
            ppa_metrics=ppa_metrics if isinstance(ppa_metrics, dict) else {},
            synthesis_success=synth_success,
            synthesis_functionality_success=post_synth_success,
            ppa_success=ppa_success,
            feedback_payload=feedback_payload,
            simulation_result=sim_results,
            synthesis_result=synth_results,
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
            synthesis_skipped=True,
        )

    def _evaluate_candidate_strict(self, item: CandidateWorkItem) -> CandidateEvaluation:
        pre = self._evaluate_pre_synthesis(item)
        if pre.status != _PRE_SYNTHESIS_STATUS:
            return pre
        return self._evaluate_synthesis(item, pre)

    def evaluate_candidate(self, item: CandidateWorkItem) -> CandidateEvaluation:
        """Run evaluation for one candidate using the configured evaluation mode."""
        if self.evaluation_mode == EvaluationMode.STRICT_ABLATION.value:
            return self._evaluate_candidate_strict(item)

        pre = self._evaluate_pre_synthesis(item)
        if pre.status != _PRE_SYNTHESIS_STATUS:
            return pre
        top_k = self.accelerated_synthesis_top_k
        if top_k is not None and top_k <= 0:
            return self._mark_synthesis_skipped(item, pre)
        return self._evaluate_synthesis(item, pre)

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
        final_results: list[CandidateEvaluation] = [CandidateEvaluation(status="", score=0.0, stage_statuses={}) for _ in items]

        if candidate_workers > 1 and len(synth_indices) > 1:
            with ThreadPoolExecutor(max_workers=candidate_workers) as executor:
                synth_futures = {
                    idx: executor.submit(self._evaluate_synthesis, items[idx], pre_results[idx])
                    for idx in synth_indices
                }
                for idx in synth_indices:
                    final_results[idx] = synth_futures[idx].result()
        else:
            for idx in synth_indices:
                final_results[idx] = self._evaluate_synthesis(items[idx], pre_results[idx])

        for idx, pre in enumerate(pre_results):
            if pre.status != _PRE_SYNTHESIS_STATUS:
                final_results[idx] = pre
                continue
            if idx in synth_indices:
                continue
            final_results[idx] = self._mark_synthesis_skipped(items[idx], pre)
        return final_results
