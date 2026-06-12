from __future__ import annotations

import shutil

import pytest

from revolution.verilator_evaluation import VerilatorEvaluator

verilator_available = shutil.which("verilator") is not None

DUT = """
module adder(input [3:0] a, input [3:0] b, output [4:0] y);
  assign y = a + b;
endmodule
"""
TB = """
module tb;
  reg [3:0] a, b;
  wire [4:0] y;
  integer mismatches = 0;
  adder dut(.a(a), .b(b), .y(y));
  initial begin
    a = 4'd3; b = 4'd4; #1;
    if (y !== 5'd7) mismatches = mismatches + 1;
    a = 4'd15; b = 4'd1; #1;
    if (y !== 5'd16) mismatches = mismatches + 1;
    $display("Mismatches: %0d in 2 samples", mismatches);
    $finish;
  end
endmodule
"""


@pytest.mark.skipif(not verilator_available, reason="verilator binary required")
def test_verilator_pass_flow(tmp_path):
    dut = tmp_path / "adder.sv"
    tb = tmp_path / "tb.sv"
    dut.write_text(DUT, encoding="utf-8")
    tb.write_text(TB, encoding="utf-8")

    result = VerilatorEvaluator().evaluate(
        str(dut), str(tb), None, top_module_name="tb",
        output_directory=str(tmp_path),
    )

    assert result["status"] == "success"
    assert "Mismatches: 0 in 2 samples" in result["simulation_stdout"]
    assert result["compiled_file_path"] and result["log_file_path"]


@pytest.mark.skipif(not verilator_available, reason="verilator binary required")
def test_verilator_compile_error_flow(tmp_path):
    dut = tmp_path / "broken.sv"
    tb = tmp_path / "tb.sv"
    dut.write_text("module broken(input a; endmodule", encoding="utf-8")
    tb.write_text(TB, encoding="utf-8")

    result = VerilatorEvaluator().evaluate(
        str(dut), str(tb), None, top_module_name="tb",
        output_directory=str(tmp_path),
    )

    assert result["status"] == "compilation_error"
    assert result["compilation_stderr"]


def test_verilator_missing_file_flow(tmp_path):
    result = VerilatorEvaluator().evaluate(
        str(tmp_path / "absent.sv"), str(tmp_path / "tb.sv"), None,
    )

    assert result["status"] == "file_error"
