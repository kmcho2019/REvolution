"""Regression tests for SynthesisEvaluator._create_sdc_file clock extraction.

Bug: the prior parser split the file on ';' and unconditionally inspected only
the first chunk, so any module preceded by a license header containing a ';'
(every RealBench e203 golden) yielded NO create_clock -> OpenROAD STA ran
unconstrained and reported tns/wns = 0 for the whole design. These tests pin the
fixed behavior.
"""
from __future__ import annotations

from pathlib import Path

from revolution.evaluation import SynthesisEvaluator


def _sdc_for(tmp_path, source: str, module_name: str) -> str:
    v = tmp_path / f"{module_name}.v"
    v.write_text(source, encoding="utf-8")
    se = SynthesisEvaluator()
    sdc_path = se._create_sdc_file(str(v), module_name, str(tmp_path), clk_period=0.01)
    return Path(sdc_path).read_text(encoding="utf-8")


def test_clock_found_despite_license_header_with_semicolon(tmp_path):
    """A license header containing ';' before the module must not hide the clock."""
    source = (
        "/////////////////////////////////////////////////\n"
        "// Licensed under the Apache License, Version 2.0 (the \"License\");\n"
        "// you may not use this file except in compliance.\n"
        "`include \"e203_defines.v\"\n"
        "module e203_seqmod(\n"
        "  input  clk,\n"
        "  input  rst_n,\n"
        "  input  [31:0] d,\n"
        "  output [31:0] q\n"
        ");\n"
        "  reg [31:0] q;\n"
        "  always @(posedge clk or negedge rst_n) q <= d;\n"
        "endmodule\n"
    )
    sdc = _sdc_for(tmp_path, source, "e203_seqmod")
    assert "create_clock" in sdc
    assert "get_ports clk" in sdc


def test_simple_module_clock_still_found(tmp_path):
    """The RTLLM-style simple module (no header) keeps working."""
    source = (
        "module top(input clk, input a, output reg b);\n"
        "  always @(posedge clk) b <= a;\n"
        "endmodule\n"
    )
    sdc = _sdc_for(tmp_path, source, "top")
    assert sdc.count("create_clock") == 1
    assert "get_ports clk" in sdc


def test_combinational_module_left_unconstrained(tmp_path):
    """A purely combinational module (no clock port) gets no create_clock."""
    source = (
        "module comb(input [3:0] a, input [3:0] b, output [3:0] y);\n"
        "  assign y = a & b;\n"
        "endmodule\n"
    )
    sdc = _sdc_for(tmp_path, source, "comb")
    assert "create_clock" not in sdc
    assert "current_design comb" in sdc


def test_clock_in_ifdef_guarded_multiline_header(tmp_path):
    """ANSI port list spanning `ifdef blocks (e203 style) still yields the clock."""
    source = (
        "// header with a ; in it; tricky\n"
        "module e203_x(\n"
        "  `ifdef E203_HAS_NICE\n"
        "  input nice_req,\n"
        "  `endif\n"
        "  input clk,\n"
        "  output o\n"
        ");\n"
        "  reg o; always @(posedge clk) o <= nice_req;\n"
        "endmodule\n"
    )
    sdc = _sdc_for(tmp_path, source, "e203_x")
    assert "create_clock" in sdc and "get_ports clk" in sdc
