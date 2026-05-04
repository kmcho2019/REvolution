import math
from pathlib import Path

import pytest

from revolution.graph_descriptor_evaluator import GraphDescriptorEvaluator


def test_graph_descriptor_evaluator_extracts_theory_metrics(tmp_path: Path):
    code_path = tmp_path / "reconv.sv"
    code_path.write_text(
        "\n".join(
            [
                "module reconv(input logic a, input logic b, input logic c, input logic d, output logic y);",
                "  logic split;",
                "  logic w1;",
                "  logic w2;",
                "  assign split = a & b;",
                "  assign w1 = split ^ c;",
                "  assign w2 = split | d;",
                "  assign y = w1 & w2;",
                "endmodule",
            ]
        )
        + "\n",
        encoding="utf-8",
    )

    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path,
        top_module_name="reconv",
    )

    assert metrics["rent_exponent"] >= 0.0
    assert 0.0 <= metrics["rent_exponent_confidence_gated"] <= 1.0
    assert 0.0 <= metrics["rent_confidence"] <= 1.0
    assert 0.0 <= metrics["rent_retained_sample_ratio"] <= 1.0
    assert metrics["reconv_source_ratio"] > 0.0
    assert metrics["reconv_sink_ratio"] > 0.0
    assert 0.0 <= metrics["laplacian_lambda2"] <= 2.0
    assert 0.0 <= metrics["laplacian_spectral_entropy"] <= 1.0
    assert 0.0 <= metrics["scoap_signal_smoothness"] <= 2.0
    assert sum(metrics[f"scoap_cc0_bin_{idx}_pct"] for idx in range(4)) == pytest.approx(1.0)
    assert sum(metrics[f"scoap_cc1_bin_{idx}_pct"] for idx in range(4)) == pytest.approx(1.0)
    assert sum(metrics[f"scoap_co_bin_{idx}_pct"] for idx in range(4)) == pytest.approx(1.0)


def test_graph_descriptor_evaluator_extracts_journal_comb_chain(tmp_path: Path):
    code_path = tmp_path / "comb_chain.sv"
    code_path.write_text(
        "\n".join(
            [
                "module comb_chain(input logic a, input logic b, input logic c, input logic d, output logic y);",
                "  logic w1;",
                "  logic w2;",
                "  assign w1 = a & b;",
                "  assign w2 = c | d;",
                "  assign y = w1 ^ w2;",
                "endmodule",
            ]
        )
        + "\n",
        encoding="utf-8",
    )

    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path,
        top_module_name="comb_chain",
    )

    assert metrics["logic_depth"] == pytest.approx(2.0)
    assert metrics["ff_depth"] == pytest.approx(0.0)
    assert metrics["combinational_cells"] == pytest.approx(3.0)
    assert metrics["comb_width_log"] == pytest.approx(math.log1p(3.0))


def test_graph_descriptor_evaluator_extracts_journal_register_wrapper(tmp_path: Path):
    code_path = tmp_path / "reg_wrap.sv"
    code_path.write_text(
        "\n".join(
            [
                "module reg_wrap(input logic clk, input logic a, output logic y);",
                "  logic q;",
                "  always_ff @(posedge clk) q <= a;",
                "  assign y = q;",
                "endmodule",
            ]
        )
        + "\n",
        encoding="utf-8",
    )

    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path,
        top_module_name="reg_wrap",
    )

    assert metrics["logic_depth"] == pytest.approx(0.0)
    assert metrics["ff_depth"] == pytest.approx(1.0)
    assert metrics["comb_width_log"] == pytest.approx(0.0)


def test_graph_descriptor_evaluator_extracts_journal_two_stage_pipeline(tmp_path: Path):
    code_path = tmp_path / "pipe2.sv"
    code_path.write_text(
        "\n".join(
            [
                "module pipe2(input logic clk, input logic a, output logic y);",
                "  logic q1;",
                "  logic q2;",
                "  always_ff @(posedge clk) begin",
                "    q1 <= a;",
                "    q2 <= q1;",
                "  end",
                "  assign y = q2;",
                "endmodule",
            ]
        )
        + "\n",
        encoding="utf-8",
    )

    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path,
        top_module_name="pipe2",
    )

    assert metrics["logic_depth"] == pytest.approx(0.0)
    assert metrics["ff_depth"] == pytest.approx(2.0)
    assert metrics["comb_width_log"] == pytest.approx(0.0)


def test_graph_descriptor_evaluator_extracts_journal_comb_ff_depth_collapse(tmp_path: Path):
    code_path = tmp_path / "pure_comb.sv"
    code_path.write_text(
        "\n".join(
            [
                "module pure_comb(input logic a, input logic b, output logic y);",
                "  assign y = a & b;",
                "endmodule",
            ]
        )
        + "\n",
        encoding="utf-8",
    )

    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path,
        top_module_name="pure_comb",
    )

    assert metrics["logic_depth"] == pytest.approx(1.0)
    assert metrics["ff_depth"] == pytest.approx(0.0)
    assert metrics["comb_width_log"] == pytest.approx(math.log1p(1.0))


def test_graph_descriptor_evaluator_returns_empty_for_missing_file():
    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=Path("/tmp/does-not-exist.sv"),
        top_module_name="missing",
    )
    assert metrics == {}


def test_build_rent_metrics_downweights_clamped_small_graphs():
    evaluator = GraphDescriptorEvaluator()

    metrics = evaluator._build_rent_metrics(
        graph_node_count=8,
        raw_sample_count=4,
        retained_sample_count=4,
        fit={
            "slope": 1.3,
            "k": 1.2,
            "r2": 0.95,
            "sigma": 0.05,
        },
    )

    assert metrics["rent_exponent"] == pytest.approx(1.0)
    assert metrics["rent_clamped_flag"] == pytest.approx(1.0)
    assert metrics["rent_confidence"] < 0.5
    assert metrics["rent_exponent_confidence_gated"] < metrics["rent_exponent"]
    assert metrics["rent_exponent_confidence_gated"] > 0.5


def test_empty_rent_metrics_return_neutral_gated_exponent():
    evaluator = GraphDescriptorEvaluator()

    metrics = evaluator._empty_rent_metrics(
        graph_node_count=2,
        raw_sample_count=1,
    )

    assert metrics["rent_exponent"] == pytest.approx(0.0)
    assert metrics["rent_confidence"] == pytest.approx(0.0)
    assert metrics["rent_exponent_confidence_gated"] == pytest.approx(0.5)
