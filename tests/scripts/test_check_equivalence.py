from __future__ import annotations

import importlib.util
import json
import shutil
import sys
from pathlib import Path

import pytest

spec = importlib.util.spec_from_file_location(
    "check_equivalence",
    Path(__file__).resolve().parents[2] / "scripts" / "check_equivalence.py",
)
assert spec and spec.loader
check_equivalence = importlib.util.module_from_spec(spec)
sys.modules["check_equivalence"] = check_equivalence
spec.loader.exec_module(check_equivalence)

yosys_available = shutil.which("yosys") is not None

GOLD = """
module top(input [3:0] a, input [3:0] b, output [4:0] y);
  assign y = a + b;
endmodule
"""
EQUIVALENT = """
module top(input [3:0] a, input [3:0] b, output [4:0] y);
  assign y = b + a;
endmodule
"""
DIFFERENT = """
module top(input [3:0] a, input [3:0] b, output [4:0] y);
  assign y = a - b;
endmodule
"""


@pytest.mark.skipif(not yosys_available, reason="yosys binary required")
def test_equivalent_pair_is_proven(tmp_path):
    gold = tmp_path / "gold.sv"
    gate = tmp_path / "gate.sv"
    gold.write_text(GOLD, encoding="utf-8")
    gate.write_text(EQUIVALENT, encoding="utf-8")

    result = check_equivalence.check_pair(gold, gate, "top")

    assert result["verdict"] == "PROVEN"


@pytest.mark.skipif(not yosys_available, reason="yosys binary required")
def test_inequivalent_pair_is_not_proven_and_main_reports(tmp_path, capsys):
    gold = tmp_path / "gold.sv"
    good = tmp_path / "good.sv"
    bad = tmp_path / "bad.sv"
    gold.write_text(GOLD, encoding="utf-8")
    good.write_text(EQUIVALENT, encoding="utf-8")
    bad.write_text(DIFFERENT, encoding="utf-8")
    out = tmp_path / "report"

    rc = check_equivalence.main(
        [
            "--gold", str(gold),
            "--gate", str(good),
            "--gate", str(bad),
            "--top", "top",
            "--output-dir", str(out),
        ]
    )

    assert rc == 1
    report = json.loads((out / "equivalence_report.json").read_text(encoding="utf-8"))
    assert report["proven"] == 1 and report["total"] == 2
    verdicts = {Path(p["gate"]).name: p["verdict"] for p in report["pairs"]}
    assert verdicts == {"good.sv": "PROVEN", "bad.sv": "NOT_PROVEN"}
    assert all(Path(p["log_path"]).is_file() for p in report["pairs"])


@pytest.mark.skipif(not yosys_available, reason="yosys binary required")
def test_separate_gold_gate_top_names(tmp_path):
    gold = tmp_path / "ref.sv"
    gate = tmp_path / "cand.sv"
    gold.write_text(GOLD.replace("module top", "module RefModule"), encoding="utf-8")
    gate.write_text(EQUIVALENT, encoding="utf-8")  # module top

    result = check_equivalence.check_pair(
        gold, gate, top="top", gold_top="RefModule", gate_top="top"
    )
    assert result["verdict"] == "PROVEN"
