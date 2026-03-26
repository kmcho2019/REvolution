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
    assert metrics["reconv_source_ratio"] > 0.0
    assert metrics["reconv_sink_ratio"] > 0.0
    assert 0.0 <= metrics["laplacian_lambda2"] <= 2.0
    assert 0.0 <= metrics["laplacian_spectral_entropy"] <= 1.0
    assert 0.0 <= metrics["scoap_signal_smoothness"] <= 2.0
    assert sum(metrics[f"scoap_cc0_bin_{idx}_pct"] for idx in range(4)) == pytest.approx(1.0)
    assert sum(metrics[f"scoap_cc1_bin_{idx}_pct"] for idx in range(4)) == pytest.approx(1.0)
    assert sum(metrics[f"scoap_co_bin_{idx}_pct"] for idx in range(4)) == pytest.approx(1.0)


def test_graph_descriptor_evaluator_returns_empty_for_missing_file():
    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=Path("/tmp/does-not-exist.sv"),
        top_module_name="missing",
    )
    assert metrics == {}
