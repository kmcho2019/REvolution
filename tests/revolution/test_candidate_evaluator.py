from pathlib import Path

import pytest

from revolution.runtime import CandidateEvaluator, CandidateWorkItem, ProblemContext

RANDOM_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/00_random_descriptor/descriptor_profile.yaml"
)
YOSYS_STAT_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/01_yosys_stat_bd/descriptor_profile.yaml"
)
MOTIF_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/02_netlist_motif_occupancy/descriptor_profile.yaml"
)


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


def test_passes_synthesis_sanity_rejects_stubs(tmp_path):
    """Sanity-check mode (gate_level_functional_recheck=False) accepts genuine
    designs but rejects yosys stub-outs that would report absurd PPA."""
    evaluator = CandidateEvaluator(
        context=_context(tmp_path),
        problem_description="desc",
        verilog_evaluator=_FakeVerilogEvaluator({"status": "success"}),
        synthesis_evaluator=_FakeSynthesisEvaluator({}),
        ref_ppa_metrics={"area": 1611.0, "power": 0.349},
    )
    # Genuine design close to the reference -> accepted.
    assert evaluator._passes_synthesis_sanity(
        {"area": 1600.0, "power": 0.3}, {"total_cells": 1500.0}
    ) is True
    # Stub: area orders of magnitude below the reference -> rejected.
    assert evaluator._passes_synthesis_sanity(
        {"area": 5.0, "power": 1e-6}, {"total_cells": 3.0}
    ) is False
    # Empty netlist -> rejected.
    assert evaluator._passes_synthesis_sanity(
        {"area": 100.0, "power": 0.1}, {"total_cells": 0.0}
    ) is False
    # Zero area -> rejected.
    assert evaluator._passes_synthesis_sanity(
        {"area": 0.0, "power": 0.1}, {"total_cells": 10.0}
    ) is False
    # No reference available -> only the non-zero + non-empty guards apply.
    evaluator.ref_ppa_metrics = {}
    assert evaluator._passes_synthesis_sanity(
        {"area": 5.0, "power": 1e-6}, {"total_cells": 3.0}
    ) is True


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


def test_candidate_evaluator_extracts_graph_metrics_for_theory_profile(tmp_path, monkeypatch):
    context = _context(tmp_path)
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module TopA; endmodule\n", encoding="utf-8")
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
        descriptor_profile="theory_grounded_full_20d",
    )
    monkeypatch.setattr(
        evaluator.rtl_descriptor_evaluator,
        "extract_metrics",
        lambda **kwargs: {
            "rtl_cyclomatic_total_log": 5.0,
            "rtl_cyclomatic_max_log": 3.0,
        },
    )
    monkeypatch.setattr(
        evaluator.graph_descriptor_evaluator,
        "extract_metrics",
        lambda **kwargs: {
            "rent_exponent": 0.42,
            "rent_exponent_confidence_gated": 0.42,
            "reconv_source_ratio": 0.25,
            "reconv_sink_ratio": 0.5,
            "laplacian_lambda2": 0.9,
            "laplacian_spectral_entropy": 0.6,
            "scoap_signal_smoothness": 0.7,
            **{f"scoap_cc0_bin_{idx}_pct": 0.25 for idx in range(4)},
            **{f"scoap_cc1_bin_{idx}_pct": 0.25 for idx in range(4)},
            **{f"scoap_co_bin_{idx}_pct": 0.25 for idx in range(4)},
        },
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module TopA; endmodule", code_file_path=str(code_path))
    )

    assert result.status == "success"
    assert result.graph_metrics["rent_exponent"] == pytest.approx(0.42)
    assert result.descriptor_values["rent_exponent_confidence_gated"] == pytest.approx(0.42)
    assert result.descriptor_values["reconv_source_ratio"] == pytest.approx(0.25)
    assert result.descriptor_values["laplacian_lambda2"] == pytest.approx(0.9)


def test_candidate_evaluator_extracts_journal_descriptor_profile(tmp_path, monkeypatch):
    context = _context(tmp_path)
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module TopA; endmodule\n", encoding="utf-8")
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
        descriptor_profile="journal_logic_ff_width_3d",
    )
    monkeypatch.setattr(
        evaluator.graph_descriptor_evaluator,
        "extract_metrics",
        lambda **kwargs: {
            "logic_depth": 3.0,
            "ff_depth": 2.0,
            "comb_width_log": 1.5,
            "combinational_cells": 4.0,
        },
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module TopA; endmodule", code_file_path=str(code_path))
    )

    assert result.status == "success"
    assert result.graph_metrics["combinational_cells"] == pytest.approx(4.0)
    assert result.descriptor_values == {
        "logic_depth": pytest.approx(3.0),
        "ff_depth": pytest.approx(2.0),
        "comb_width_log": pytest.approx(1.5),
    }


def test_candidate_evaluator_extracts_random_hash_descriptor(tmp_path):
    context = _context(tmp_path)
    code_path = tmp_path / "candidate.sv"
    netlist_path = tmp_path / "candidate.syn.v"
    code_path.write_text("module TopA; endmodule\n", encoding="utf-8")
    netlist_path.write_text(
        "module TopA(input a, output y);\n"
        "  INV_X1 u0 (.A(a), .ZN(y));\n"
        "endmodule\n",
        encoding="utf-8",
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
        synthesis_evaluator=_FakeSynthesisEvaluator(
            {
                "synthesis_success": True,
                "synthesis_functionality_success": True,
                "ppa_success": True,
                "ppa_metrics": {"power": 0.9, "area": 90.0, "eff_clk_period": 0.9},
                "structural_metrics": {"total_cells": 1.0},
                "synthesized_netlist_path": str(netlist_path),
            }
        ),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        descriptor_profile="random_hash_3d",
        descriptor_file=RANDOM_DESCRIPTOR_FILE,
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module TopA; endmodule", code_file_path=str(code_path))
    )

    assert result.status == "success"
    assert tuple(result.descriptor_values) == (
        "random_hash_0",
        "random_hash_1",
        "random_hash_2",
    )
    assert all(0.0 <= value < 1.0 for value in result.descriptor_values.values())


def test_candidate_evaluator_extracts_yosys_stat_descriptor(tmp_path):
    context = _context(tmp_path)
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module TopA; endmodule\n", encoding="utf-8")
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
                "structural_metrics": {
                    "total_cells": 24.0,
                    "seq_ratio": 0.25,
                    "mux_ratio": 0.5,
                    "cell_count_log": 24.0,
                },
            }
        ),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        descriptor_profile="yosys_stat_compact_3d",
        descriptor_file=YOSYS_STAT_DESCRIPTOR_FILE,
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module TopA; endmodule", code_file_path=str(code_path))
    )

    assert result.status == "success"
    assert result.descriptor_values["cell_count_log"] == pytest.approx(3.2188758248682006)
    assert result.descriptor_values["seq_ratio"] == pytest.approx(0.25)
    assert result.descriptor_values["mux_ratio"] == pytest.approx(0.5)


def test_candidate_evaluator_extracts_motif_descriptor(tmp_path):
    context = _context(tmp_path)
    code_path = tmp_path / "candidate.sv"
    netlist_path = tmp_path / "candidate.syn.v"
    code_path.write_text("module TopA; endmodule\n", encoding="utf-8")
    netlist_path.write_text(
        "module TopA(input a, input b, input s, output y);\n"
        "  NAND2_X1 g0 (.A(a), .B(b), .ZN(n1));\n"
        "  MUX2_X1 g1 (.A(n1), .B(b), .S(s), .Z(y));\n"
        "endmodule\n",
        encoding="utf-8",
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
        synthesis_evaluator=_FakeSynthesisEvaluator(
            {
                "synthesis_success": True,
                "synthesis_functionality_success": True,
                "ppa_success": True,
                "ppa_metrics": {"power": 0.9, "area": 90.0, "eff_clk_period": 0.9},
                "structural_metrics": {"total_cells": 2.0},
                "synthesized_netlist_path": str(netlist_path),
            }
        ),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        descriptor_profile="netlist_motif_occupancy_4d",
        descriptor_file=MOTIF_DESCRIPTOR_FILE,
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module TopA; endmodule", code_file_path=str(code_path))
    )

    assert result.status == "success"
    assert result.descriptor_values["motif_logic_ratio"] == pytest.approx(0.5)
    assert result.descriptor_values["motif_control_ratio"] == pytest.approx(0.5)
    assert result.descriptor_values["motif_arith_ratio"] == pytest.approx(0.0)
    assert result.descriptor_values["motif_diversity"] == pytest.approx(1.0)


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
