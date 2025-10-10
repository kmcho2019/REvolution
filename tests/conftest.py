from __future__ import annotations

from pathlib import Path

import pytest


@pytest.fixture(autouse=True)
def fake_binaries(mocker):
    """Pretend external binaries exist so evaluators can be constructed."""

    return mocker.patch("shutil.which", side_effect=lambda exe: exe)


@pytest.fixture
def no_chmod(mocker):
    """Silence os.chmod during tests."""

    return mocker.patch("os.chmod")


@pytest.fixture
def minimal_sv_files(tmp_path: Path) -> dict[str, str]:
    """Create a tiny DUT/testbench/pdk set for VerilogEvaluator tests."""

    workdir = tmp_path / "sv"
    workdir.mkdir()
    dut = workdir / "dut.sv"
    tb = workdir / "tb.sv"
    pdk = workdir / "cells.v"

    dut.write_text("module dut; endmodule\n", encoding="utf-8")
    tb.write_text("module tb; initial $finish; endmodule\n", encoding="utf-8")
    pdk.write_text("module cell; endmodule\n", encoding="utf-8")

    return {
        "dir": str(workdir),
        "dut": str(dut),
        "tb": str(tb),
        "pdk": str(pdk),
    }


@pytest.fixture
def pdk_cells(tmp_path: Path) -> str:
    """Provide a mock PDK cells.v for synthesis tests."""

    cells = tmp_path / "pdkroot" / "Nangate45" / "work_around_yosys" / "cells.v"
    cells.parent.mkdir(parents=True, exist_ok=True)
    cells.write_text("// fake cells\n", encoding="utf-8")
    return str(cells)
