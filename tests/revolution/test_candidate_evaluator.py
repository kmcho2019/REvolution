from pathlib import Path

import pytest

from revolution.runtime import CandidateEvaluator, CandidateWorkItem, ProblemContext


class _FakeVerilogEvaluator:
    def __init__(self, result):
        self.result = result
        self.calls: list[tuple[tuple[object, ...], dict[str, object]]] = []

    def evaluate(self, *args, **kwargs):
        self.calls.append((args, kwargs))
        return dict(self.result)


class _FakeSynthesisEvaluator:
    def __init__(self, result):
        self.result = result
        self.calls = 0
        self.call_args: list[tuple[tuple[object, ...], dict[str, object]]] = []

    def evaluate(self, *args, **kwargs):
        self.calls += 1
        self.call_args.append((args, kwargs))
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
    (bench / "synthesis_top_module_names.json").write_text(
        '{"Prob":"TopA"}',
        encoding="utf-8",
    )
    return ProblemContext(
        benchmark_name="Bench",
        problem_name="Prob",
        benchmark_path=bench,
        prompt_path=prompt,
        problem_description="desc",
        test_sv_path=test_sv,
        ref_sv_path=ref_sv,
        top_module_names_path=bench / "synthesis_top_module_names.json",
        testbench_top_module="tb",
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
    assert result.quality_score == pytest.approx(0.1)
    assert result.score_components["g_P"] == pytest.approx(0.1)
    assert result.score_components["g_A"] == pytest.approx(0.1)
    assert result.normalized_code_hash
    assert result.archiveable is True


def test_candidate_evaluator_uses_runtime_retro_profile_axes(tmp_path, monkeypatch):
    context = _context(tmp_path)
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module m; endmodule\n", encoding="utf-8")
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
                "structural_metrics": {"total_cells": 12.0},
            }
        ),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        descriptor_profile="size_control_3d",
    )
    monkeypatch.setattr(
        evaluator.rtl_descriptor_evaluator,
        "extract_metrics",
        lambda **kwargs: {
            "wire_count_log_est": 5.5,
            "assign_count": 3.0,
            "ctrl_depth_est": 2.0,
        },
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module m; endmodule", code_file_path=str(code_path))
    )

    assert result.status == "success"
    assert result.rtl_metrics["wire_count_log_est"] == pytest.approx(5.5)
    assert result.descriptor_values["wire_count_log_est"] == pytest.approx(5.5)
    assert result.descriptor_values["assign_count"] == pytest.approx(3.0)
    assert result.descriptor_values["ctrl_depth_est"] == pytest.approx(2.0)


def test_candidate_evaluator_extracts_dynamic_metrics_for_activity_profile(tmp_path, monkeypatch):
    context = _context(tmp_path)
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module m; endmodule\n", encoding="utf-8")
    evaluator = CandidateEvaluator(
        context=context,
        problem_description="desc",
        verilog_evaluator=_FakeVerilogEvaluator(
            {
                "status": "success",
                "simulation_stdout": "Mismatches: 0\n",
                "simulation_stderr": "",
                "compilation_stderr": "",
                "vcd_file_path": str(tmp_path / "candidate_activity.vcd"),
            }
        ),
        synthesis_evaluator=_FakeSynthesisEvaluator(
            {
                "synthesis_success": True,
                "synthesis_functionality_success": True,
                "ppa_success": True,
                "ppa_metrics": {"power": 0.9, "area": 90.0, "eff_clk_period": 0.9},
                "structural_metrics": {"total_cells": 12.0},
            }
        ),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        descriptor_profile="activity_size_3d",
    )
    monkeypatch.setattr(
        evaluator.simulation_descriptor_evaluator,
        "extract_metrics",
        lambda **kwargs: {
            "toggle_count_log_est": 4.5,
            "active_signal_ratio_est": 0.75,
            "wire_count_log_est": 5.2,
        },
    )
    monkeypatch.setattr(
        evaluator.rtl_descriptor_evaluator,
        "extract_metrics",
        lambda **kwargs: {"wire_count_log_est": 5.2},
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module m; endmodule", code_file_path=str(code_path))
    )

    assert result.status == "success"
    assert result.dynamic_metrics["toggle_count_log_est"] == pytest.approx(4.5)
    assert result.descriptor_values["toggle_count_log_est"] == pytest.approx(4.5)
    assert result.descriptor_values["active_signal_ratio_est"] == pytest.approx(0.75)


def test_candidate_evaluator_search_accelerated_throttles_synthesis(tmp_path):
    context = _context(tmp_path)
    synthesis = _FakeSynthesisEvaluator(
        {
            "synthesis_success": True,
            "synthesis_functionality_success": True,
            "ppa_success": True,
            "ppa_metrics": {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        }
    )
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
        synthesis_evaluator=synthesis,
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        evaluation_mode="search_accelerated",
        accelerated_synthesis_top_k=1,
    )
    results = evaluator.evaluate_candidates(
        [
            CandidateWorkItem(code="module this_is_a_much_longer_name; endmodule", code_file_path="long.sv"),
            CandidateWorkItem(code="module s; endmodule", code_file_path="short.sv"),
        ]
    )
    assert results[0].status == "skipped_synthesis"
    assert results[0].synthesis_skipped is True
    assert results[1].status == "success"
    assert synthesis.calls == 1


def test_candidate_evaluator_search_accelerated_top_k_zero_skips_all(tmp_path):
    context = _context(tmp_path)
    synthesis = _FakeSynthesisEvaluator({})
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
        synthesis_evaluator=synthesis,
        evaluation_mode="search_accelerated",
        accelerated_synthesis_top_k=0,
    )
    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module m; endmodule", code_file_path="x.sv")
    )
    assert result.status == "skipped_synthesis"
    assert result.synthesis_skipped is True
    assert synthesis.calls == 0


def test_candidate_evaluator_uses_testbench_top_for_simulation_and_synthesis_top_for_synthesis(
    tmp_path,
):
    context = _context(tmp_path)
    verilog = _FakeVerilogEvaluator(
        {
            "status": "success",
            "simulation_stdout": "Mismatches: 0\n",
            "simulation_stderr": "",
            "compilation_stderr": "",
        }
    )
    synthesis = _FakeSynthesisEvaluator(
        {
            "synthesis_success": True,
            "synthesis_functionality_success": True,
            "ppa_success": True,
            "ppa_metrics": {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        }
    )
    evaluator = CandidateEvaluator(
        context=context,
        problem_description="desc",
        verilog_evaluator=verilog,
        synthesis_evaluator=synthesis,
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module m; endmodule", code_file_path="x.sv")
    )

    assert result.status == "success"
    assert verilog.calls[-1][1]["top_module_name"] == "tb"
    assert synthesis.call_args[-1][0][2] == "TopA"


def test_candidate_evaluator_rejects_invalid_mode(tmp_path):
    context = _context(tmp_path)
    with pytest.raises(ValueError, match="evaluation_mode"):
        CandidateEvaluator(
            context=context,
            problem_description="desc",
            verilog_evaluator=_FakeVerilogEvaluator({"status": "success"}),
            synthesis_evaluator=_FakeSynthesisEvaluator({}),
            evaluation_mode="invalid-mode",
        )
