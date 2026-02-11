from __future__ import annotations

import re
import os
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field
from typing import Any

from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator
from revolution.runtime.problem_context import ProblemContext, resolve_top_module_name


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
    ) -> None:
        self.context = context
        self.problem_description = problem_description
        self.verilog_evaluator = verilog_evaluator
        self.synthesis_evaluator = synthesis_evaluator
        self.ref_ppa_metrics = ref_ppa_metrics or {}
        self.failure_score = failure_score
        self.top_module_name = resolve_top_module_name(context)

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

    def evaluate_candidate(self, item: CandidateWorkItem) -> CandidateEvaluation:
        """Run format/syntax/functionality/synthesis/PPA stages for one candidate."""
        stages = self._base_stage_statuses()
        if item.initial_status == "failed_format":
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": item.code,
                "simulation_log": "Candidate failed format compliance checks.",
            }
            return CandidateEvaluation(
                status="failed_format",
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
                status="failed_diff",
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
                status="failed_syntax",
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
                status="failed_functionality",
                score=self.failure_score,
                stage_statuses=stages,
                mismatch_count=mismatch_count,
                feedback_payload=feedback_payload,
                simulation_result=sim_results,
            )

        stages["functionality"] = True
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
                status="success",
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
            status = "failed_synthesis"
            synthesis_log = (
                "Functionality OK, but synthesis failed.\nLog:\n"
                f"{synth_results.get('synthesis_log', 'N/A')}"
            )
        elif not post_synth_success:
            status = "failed_synthesis_functionality"
            synthesis_log = (
                "Functionality OK, Synthesis OK, but Post-Synthesis Functional Check failed.\nLog:\n"
                f"{synth_results.get('synthesis_log', 'N/A')}"
            )
        else:
            status = "failed_synthesis"
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

    def evaluate_candidates(
        self,
        items: list[CandidateWorkItem],
        *,
        candidate_workers: int = 0,
    ) -> list[CandidateEvaluation]:
        """Evaluate a batch of candidates, optionally with thread parallelism."""
        if candidate_workers > 1:
            with ThreadPoolExecutor(max_workers=candidate_workers) as executor:
                futures = [executor.submit(self.evaluate_candidate, item) for item in items]
                return [future.result() for future in futures]
        return [self.evaluate_candidate(item) for item in items]
