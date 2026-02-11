from __future__ import annotations

from types import MethodType, SimpleNamespace
from pathlib import Path

import pytest

from revolution.algorithm import EoHEngine, Heuristic
from revolution.runtime import CandidateEvaluator, CandidateWorkItem, ProblemContext


class _FakeVerilogEvaluator:
    def __init__(self, result):
        self.result = result

    def evaluate(self, *args, **kwargs):
        return dict(self.result)


class _FakeSynthesisEvaluator:
    def __init__(self, result):
        self.result = result

    def evaluate(self, *args, **kwargs):
        return dict(self.result)


def _context(tmp_path: Path) -> ProblemContext:
    bench = tmp_path / "bench"
    bench.mkdir()
    prompt = bench / "Prob_prompt.txt"
    test_sv = bench / "Prob_test.sv"
    ref_sv = bench / "Prob_ref.sv"
    prompt.write_text("desc", encoding="utf-8")
    test_sv.write_text("module tb; endmodule\n", encoding="utf-8")
    ref_sv.write_text("module ref; endmodule\n", encoding="utf-8")
    return ProblemContext(
        benchmark_name="Bench",
        problem_name="Prob",
        benchmark_path=bench,
        prompt_path=prompt,
        problem_description="desc",
        test_sv_path=test_sv,
        ref_sv_path=ref_sv,
        top_module_names_path=bench / "synthesis_top_module_names.json",
    )


def _run_legacy(
    *,
    verilog_result: dict,
    synthesis_result: dict,
    initial_status: str = "new",
) -> tuple[str, float]:
    engine = SimpleNamespace()
    engine.problem_description = "desc"
    engine.problem_name = "Prob"
    engine.evaluator = _FakeVerilogEvaluator(verilog_result)
    engine.synthesis_evaluator = _FakeSynthesisEvaluator(synthesis_result)
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    engine._calculate_fitness_score = MethodType(EoHEngine._calculate_fitness_score, engine)

    candidate = Heuristic(thought="", code="module m; endmodule\n", feedback="")
    candidate.code_file_path = "x.sv"
    candidate.status = initial_status  # type: ignore[assignment]
    evaluated, _ = EoHEngine._evaluate_candidate_pipeline(
        engine, candidate, "test.sv", "ref.sv", "TopModule"
    )
    return evaluated.status, evaluated.score


def _run_new(
    tmp_path: Path,
    *,
    verilog_result: dict,
    synthesis_result: dict,
    initial_status: str = "new",
) -> tuple[str, float]:
    evaluator = CandidateEvaluator(
        context=_context(tmp_path),
        problem_description="desc",
        verilog_evaluator=_FakeVerilogEvaluator(verilog_result),
        synthesis_evaluator=_FakeSynthesisEvaluator(synthesis_result),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        evaluation_mode="strict_ablation",
    )
    result = evaluator.evaluate_candidate(
        CandidateWorkItem(
            code="module m; endmodule\n",
            code_file_path="x.sv",
            initial_status=initial_status,
        )
    )
    return result.status, result.score


@pytest.mark.parametrize(
    "name,initial_status,verilog_result,synthesis_result",
    [
        (
            "failed_format",
            "failed_format",
            {"status": "success", "simulation_stdout": "Mismatches: 0\n"},
            {},
        ),
        (
            "failed_syntax",
            "new",
            {"status": "compilation_error", "compilation_stderr": "err"},
            {},
        ),
        (
            "failed_functionality",
            "new",
            {
                "status": "success",
                "simulation_stdout": "Mismatches: 3\n",
                "simulation_stderr": "",
                "compilation_stderr": "",
            },
            {},
        ),
        (
            "failed_synthesis",
            "new",
            {
                "status": "success",
                "simulation_stdout": "Mismatches: 0\n",
                "simulation_stderr": "",
                "compilation_stderr": "",
            },
            {
                "synthesis_success": False,
                "synthesis_functionality_success": False,
                "ppa_success": False,
                "synthesis_log": "synth failed",
                "ppa_metrics": {},
            },
        ),
        (
            "failed_synthesis_functionality",
            "new",
            {
                "status": "success",
                "simulation_stdout": "Mismatches: 0\n",
                "simulation_stderr": "",
                "compilation_stderr": "",
            },
            {
                "synthesis_success": True,
                "synthesis_functionality_success": False,
                "ppa_success": False,
                "synthesis_log": "post synth mismatch",
                "ppa_metrics": {},
            },
        ),
        (
            "success",
            "new",
            {
                "status": "success",
                "simulation_stdout": "Mismatches: 0\n",
                "simulation_stderr": "",
                "compilation_stderr": "",
            },
            {
                "synthesis_success": True,
                "synthesis_functionality_success": True,
                "ppa_success": True,
                "ppa_metrics": {"power": 0.9, "area": 90.0, "eff_clk_period": 0.9},
            },
        ),
    ],
)
def test_candidate_evaluator_strict_ablation_matches_legacy_pipeline(
    tmp_path: Path,
    name: str,
    initial_status: str,
    verilog_result: dict,
    synthesis_result: dict,
) -> None:
    legacy_status, legacy_score = _run_legacy(
        initial_status=initial_status,
        verilog_result=verilog_result,
        synthesis_result=synthesis_result,
    )
    new_status, new_score = _run_new(
        tmp_path,
        initial_status=initial_status,
        verilog_result=verilog_result,
        synthesis_result=synthesis_result,
    )

    assert new_status == legacy_status, f"{name}: status mismatch"
    if legacy_status == "success":
        assert new_score == pytest.approx(legacy_score)
    else:
        assert legacy_score == float("-inf")
        assert new_score == float("-inf")
