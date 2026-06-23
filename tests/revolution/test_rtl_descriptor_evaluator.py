import math
from pathlib import Path

import pytest

from revolution.rtl_descriptor_evaluator import RTLDescriptorEvaluator


def test_rtl_descriptor_evaluator_extracts_text_metrics_without_ast():
    evaluator = RTLDescriptorEvaluator()
    metrics = evaluator.extract_metrics(
        code_text=(
            "module demo(input logic a, input logic b, output logic y);\n"
            "wire w0;\n"
            "assign w0 = a;\n"
            "always_comb begin\n"
            "  if (a) y = b ? a : w0;\n"
            "  else y = 1'b0;\n"
            "end\n"
            "endmodule\n"
        ),
        code_file_path=None,
    )

    assert metrics["assign_count"] == pytest.approx(1.0)
    assert metrics["always_count"] == pytest.approx(1.0)
    assert metrics["if_count"] == pytest.approx(1.0)
    assert metrics["ternary_count"] == pytest.approx(1.0)
    assert metrics["wire_count_log_est"] > 0.0
    assert metrics["ast_depth_est"] == pytest.approx(0.0)
    assert metrics["timing_risk_score"] > 0.0
    assert metrics["control_pipeline_ratio"] > 0.0
    assert metrics["timing_risk_entropy"] > 0.0


def test_rtl_descriptor_evaluator_merges_ast_and_netlist_estimates(monkeypatch, tmp_path: Path):
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module demo; endmodule\n", encoding="utf-8")
    evaluator = RTLDescriptorEvaluator()

    monkeypatch.setattr(
        evaluator,
        "_load_netlist_text",
        lambda path: "wire a;\nwire b;\n$_DFF_P_ ff0 (\n$_ADD_ add0 (\n",
    )
    monkeypatch.setattr(
        evaluator,
        "_load_ast_dump",
        lambda path: "\n".join(
            [
                "Dumping AST after simplification:",
                "  AST_MODULE",
                "    AST_COND",
                "      AST_ADD",
                "        AST_MUL",
                "End of script.",
            ]
        ),
    )

    metrics = evaluator.extract_metrics(
        code_text="module demo; endmodule\n",
        code_file_path=code_path,
        mapped_cell_count=2.0,
    )

    assert metrics["wire_count_log_est"] == pytest.approx(math.log1p(2))
    assert metrics["wire_cell_ratio_est"] == pytest.approx(1.0)
    assert metrics["ast_depth_est"] == pytest.approx(3.0)
    assert metrics["ctrl_depth_est"] == pytest.approx(1.0)
    assert metrics["math_op_ast_count"] == pytest.approx(2.0)
    assert metrics["resource_sharing_ratio_est"] == pytest.approx(1.0)


def test_rtl_descriptor_evaluator_extracts_cyclomatic_metrics_from_ast(monkeypatch, tmp_path: Path):
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module demo; endmodule\n", encoding="utf-8")
    evaluator = RTLDescriptorEvaluator()

    monkeypatch.setattr(evaluator, "_load_netlist_text", lambda path: None)
    monkeypatch.setattr(
        evaluator,
        "_load_ast_dump",
        lambda path: "\n".join(
            [
                "Dumping AST after simplification:",
                "  AST_MODULE",
                "    AST_ALWAYS",
                "      AST_CASE",
                "        AST_COND",
                "        AST_COND",
                "    AST_ALWAYS",
                "      AST_CASE",
                "        AST_COND",
                "End of script.",
            ]
        ),
    )

    metrics = evaluator.extract_metrics(
        code_text="module demo; endmodule\n",
        code_file_path=code_path,
    )

    assert metrics["rtl_cyclomatic_total_log"] == pytest.approx(5.0)
    assert metrics["rtl_cyclomatic_max_log"] == pytest.approx(3.0)


def test_rtl_descriptor_evaluator_extracts_timing_risk_metrics() -> None:
    evaluator = RTLDescriptorEvaluator()
    metrics = evaluator.extract_text_metrics(
        "\n".join(
            [
                "module demo(input logic clk, input logic [3:0] a, b, output logic [3:0] y);",
                "  logic [3:0] q;",
                "  always_ff @(posedge clk) q <= a * b;",
                "  assign y = q ? (a + b) : (a - b);",
                "endmodule",
            ]
        )
    )

    assert metrics["pipeline_event_count"] == pytest.approx(2.0)
    assert metrics["control_count"] == pytest.approx(1.0)
    assert metrics["mul_count"] == pytest.approx(1.0)
    assert metrics["max_rhs_operator_count"] > 0.0
    assert metrics["timing_risk_score"] > 0.0
