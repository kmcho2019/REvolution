from pathlib import Path

import pytest

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


def test_candidate_evaluator_format_failure_short_circuit(tmp_path):
    context = _context(tmp_path)
    evaluator = CandidateEvaluator(
        context=context,
        problem_description="desc",
        verilog_evaluator=_FakeVerilogEvaluator({"status": "success"}),
        synthesis_evaluator=_FakeSynthesisEvaluator({}),
    )
    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module m; endmodule", code_file_path="x.sv", initial_status="failed_format")
    )
    assert result.status == "failed_format"
    assert result.score == float("-inf")
    assert result.stage_statuses["format"] is False


def test_candidate_evaluator_maps_functionality_failure(tmp_path):
    context = _context(tmp_path)
    evaluator = CandidateEvaluator(
        context=context,
        problem_description="desc",
        verilog_evaluator=_FakeVerilogEvaluator(
            {
                "status": "success",
                "simulation_stdout": "Mismatches: 4\n",
                "simulation_stderr": "",
                "compilation_stderr": "",
            }
        ),
        synthesis_evaluator=_FakeSynthesisEvaluator({}),
    )
    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module m; endmodule", code_file_path="x.sv")
    )
    assert result.status == "failed_functionality"
    assert result.mismatch_count == 4
    assert result.stage_statuses["syntax"] is True
    assert result.stage_statuses["functionality"] is False


def test_candidate_evaluator_success_path(tmp_path):
    context = _context(tmp_path)
    evaluator = CandidateEvaluator(
        context=context,
        problem_description="desc",
        verilog_evaluator=_FakeVerilogEvaluator(
            {
                "status": "success",
                "simulation_stdout": "Mismatches: 0\n",
                "simulation_stderr": "",
                "compilation_stderr": "",
            }
        ),
        synthesis_evaluator=_FakeSynthesisEvaluator(
            {
                "synthesis_success": True,
                "synthesis_functionality_success": True,
                "ppa_success": True,
                "ppa_metrics": {"power": 0.9, "area": 90.0, "eff_clk_period": 0.9},
            }
        ),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
    )
    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module m; endmodule", code_file_path="x.sv")
    )
    assert result.status == "success"
    assert result.stage_statuses["ppa"] is True
    assert result.score == pytest.approx(0.1)
