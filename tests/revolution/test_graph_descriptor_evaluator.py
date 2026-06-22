import math
from pathlib import Path

import pytest

from revolution.graph_descriptor_evaluator import GraphDescriptorEvaluator
from revolution.qd.descriptors import extract_descriptor_values


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


def test_graph_descriptor_evaluator_extracts_t11_runtime_bridge(tmp_path: Path):
    code_path = tmp_path / "t11_bridge.sv"
    code_path.write_text(
        "\n".join(
            [
                "module t11_bridge(input logic a, input logic b, input logic c, output logic y);",
                "  logic n1;",
                "  logic n2;",
                "  assign n1 = ~a;",
                "  assign n2 = n1 & b;",
                "  assign y = n2 | c;",
                "endmodule",
            ]
        )
        + "\n",
        encoding="utf-8",
    )

    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path,
        top_module_name="t11_bridge",
    )
    axes = ("hyper_mean_fanout", "edge_per_node", "log_edge_count", "share_family_inv")
    values = extract_descriptor_values(metrics, axes)

    assert metrics["hyper_mean_fanout"] > 0.0
    assert metrics["edge_per_node"] > 0.0
    assert metrics["hyper_directed_edge_count"] == pytest.approx(metrics["log_edge_count"])
    assert values["log_edge_count"] == pytest.approx(math.log1p(metrics["log_edge_count"]))
    assert 0.0 <= values["share_family_inv"] <= 1.0


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


def test_logic_depth_ground_truth_mixed_chain(tmp_path: Path):
    """Four distinct ops in a chain: depth is exactly 4 (literature: levels
    of logic between sequential/IO boundaries)."""
    code_path = tmp_path / "chain4.sv"
    code_path.write_text(
        "module chain4(input logic a, b, c, d, e, output logic y);\n"
        "  logic w1, w2, w3;\n"
        "  assign w1 = a & b;\n"
        "  assign w2 = w1 | c;\n"
        "  assign w3 = w2 ^ d;\n"
        "  assign y = w3 & e;\n"
        "endmodule\n",
        encoding="utf-8",
    )
    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path, top_module_name="chain4"
    )
    assert metrics["logic_depth"] == pytest.approx(4.0)


def test_ff_depth_ground_truth_pipeline(tmp_path: Path):
    """A 3-stage register pipeline has sequential depth exactly 3."""
    code_path = tmp_path / "pipe3.sv"
    code_path.write_text(
        "module pipe3(input logic clk, input logic d, output logic q);\n"
        "  logic s1, s2;\n"
        "  always_ff @(posedge clk) begin\n"
        "    s1 <= d; s2 <= s1; q <= s2;\n"
        "  end\n"
        "endmodule\n",
        encoding="utf-8",
    )
    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path, top_module_name="pipe3"
    )
    assert metrics["ff_depth"] == pytest.approx(3.0)


def test_ff_depth_counter_feedback_counts_loop_once(tmp_path: Path):
    """Sequential feedback (accumulator) is SCC-collapsed, not unrolled: the
    register in the loop contributes its weight once on the PI->PO path.
    DOCUMENTED LIBERTY: control ports (clk/en/rst) are excluded from data
    dependency tracing, so an enable-only-reachable register reports 0."""
    acc = tmp_path / "acc.sv"
    acc.write_text(
        "module acc(input logic clk, input logic [3:0] din, output logic [3:0] q);\n"
        "  always_ff @(posedge clk) q <= q + din;\n"
        "endmodule\n",
        encoding="utf-8",
    )
    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=acc, top_module_name="acc"
    )
    assert metrics["ff_depth"] == pytest.approx(1.0)

    enable_only = tmp_path / "cnt.sv"
    enable_only.write_text(
        "module cnt(input logic clk, input logic en, output logic [3:0] q);\n"
        "  always_ff @(posedge clk) if (en) q <= q + 4'd1;\n"
        "endmodule\n",
        encoding="utf-8",
    )
    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=enable_only, top_module_name="cnt"
    )
    assert metrics["ff_depth"] == pytest.approx(0.0)


def test_logic_depth_survives_very_deep_chain(tmp_path: Path):
    """Regression: recursive traversal hit Python's recursion limit on long
    combinational chains; the iterative walk must not."""
    stages = 1500
    lines = [
        "module deep(input logic a, input logic b, output logic y);",
        "  logic w0;",
        "  assign w0 = a ^ b;",
    ]
    for i in range(1, stages):
        lines.append(f"  logic w{i};")
        lines.append(f"  assign w{i} = w{i-1} ^ a;")
    lines.append(f"  assign y = w{stages-1};")
    lines.append("endmodule")
    code_path = tmp_path / "deep.sv"
    code_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path, top_module_name="deep"
    )
    assert metrics["logic_depth"] == pytest.approx(float(stages))


def test_rent_exponent_orders_chain_below_dense(tmp_path: Path):
    """Sanity ordering from Rent literature: a 1D chain partitions with few
    boundary pins (low p); dense reconvergent logic partitions badly
    (higher p). Also: extraction is deterministic."""
    chain = tmp_path / "rchain.sv"
    lines = ["module rchain(input logic a, input logic b, output logic y);", "  logic w0;", "  assign w0 = a ^ b;"]
    for i in range(1, 24):
        lines.append(f"  logic w{i};")
        lines.append(f"  assign w{i} = w{i-1} ^ a;")
    lines.append("  assign y = w23;")
    lines.append("endmodule")
    chain.write_text("\n".join(lines) + "\n", encoding="utf-8")

    dense = tmp_path / "rdense.sv"
    dlines = ["module rdense(input logic [7:0] a, output logic [7:0] y);"]
    for i in range(8):
        terms = " ^ ".join(f"a[{j}]" for j in range(8) if j != i)
        dlines.append(f"  assign y[{i}] = {terms};")
    dlines.append("endmodule")
    dense.write_text("\n".join(dlines) + "\n", encoding="utf-8")

    evaluator = GraphDescriptorEvaluator()
    chain_metrics = evaluator.extract_metrics(code_file_path=chain, top_module_name="rchain")
    chain_again = evaluator.extract_metrics(code_file_path=chain, top_module_name="rchain")
    dense_metrics = evaluator.extract_metrics(code_file_path=dense, top_module_name="rdense")

    assert chain_metrics["rent_exponent"] == pytest.approx(chain_again["rent_exponent"])
    assert 0.0 <= chain_metrics["rent_exponent"] <= 1.0
    assert 0.0 <= dense_metrics["rent_exponent"] <= 1.0
    assert chain_metrics["rent_exponent"] < dense_metrics["rent_exponent"]


def test_ltp_cross_check_buffer_delta(tmp_path: Path):
    """Calibrate the documented ours-vs-ltp relationship: our logic_depth
    skips buffers, yosys ltp counts them, so ltp - ours == buffer count
    on a chain with explicit buffers."""
    code_path = tmp_path / "bufchain.sv"
    code_path.write_text(
        "module bufchain(input logic a, b, output logic y);\n"
        "  logic w1, b1, w2;\n"
        "  assign w1 = a & b;   // depth 1\n"
        "  buf g1(b1, w1);      // buffer: ltp counts, ours skips\n"
        "  assign w2 = b1 ^ a;  // depth 2\n"
        "  assign y = ~w2;      // depth 3\n"
        "endmodule\n",
        encoding="utf-8",
    )
    metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=code_path, top_module_name="bufchain"
    )
    assert metrics["logic_depth"] == pytest.approx(3.0)
    # CALIBRATION FACT: the evaluator's yosys script runs `opt` before both
    # measurements, which removes explicit buffers - so ours == ltp on the
    # production pipeline (delta 0). The buffer-skip liberty only matters
    # for buffer-preserving flows.
    if "logic_depth_ltp" in metrics:  # ltp available in this yosys
        assert metrics["logic_depth_ltp"] == pytest.approx(3.0)
        assert metrics["logic_depth_ltp_delta"] == pytest.approx(0.0)
