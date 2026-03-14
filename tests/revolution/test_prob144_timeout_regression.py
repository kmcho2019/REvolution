import os
import sys
import time
from pathlib import Path
from unittest.mock import MagicMock

import pytest

from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator


FIXTURE_ROOT = (
    Path(__file__).resolve().parents[1] / "fixtures" / "prob144_conwaylife_timeout"
)
BENCH_ROOT = (
    Path(__file__).resolve().parents[2]
    / "data"
    / "bench"
    / "VerilogEval-Spec-to-RTL"
)
TOP_MODULE = "TopModule"


def _write_executable(path: Path, body: str) -> str:
    path.write_text(body, encoding="utf-8")
    os.chmod(path, 0o755)
    return str(path)


def _timeout_spawner_script() -> str:
    return """#!/usr/bin/env python3
import os
import signal
import subprocess
import sys
import time

child = None

def _cleanup(_signum, _frame):
    global child
    if child is not None:
        try:
            child.terminate()
        except ProcessLookupError:
            pass
        try:
            child.wait(timeout=5)
        except subprocess.TimeoutExpired:
            child.kill()
            child.wait()
    raise SystemExit(143)

signal.signal(signal.SIGTERM, _cleanup)
signal.signal(signal.SIGINT, _cleanup)

pid_file = os.environ["EDA_CHILD_PID_FILE"]
child = subprocess.Popen([sys.executable, "-c", "import time; time.sleep(300)"])
with open(pid_file, "w", encoding="utf-8") as handle:
    handle.write(str(child.pid))
while True:
    time.sleep(1)
"""


def _wait_for_pid_exit(pid: int, timeout_s: float = 5.0) -> None:
    deadline = time.time() + timeout_s
    while time.time() < deadline:
        if not Path(f"/proc/{pid}").exists():
            return
        time.sleep(0.05)
    raise AssertionError(f"PID {pid} is still alive after {timeout_s} seconds")


def _mk_templates(root: Path) -> str:
    ref = root / "scripts" / "ref"
    util = root / "scripts" / "util"
    (root / "data" / "pdk").mkdir(parents=True, exist_ok=True)
    ref.mkdir(parents=True, exist_ok=True)
    util.mkdir(parents=True, exist_ok=True)

    (ref / "ref.yosys.tcl").write_text(
        "\n".join(
            [
                "read_verilog __VERILOG_FILE__",
                "synth -top __MODULE_NAME__",
                "write_verilog __OUTPUT_FILE__",
                "set clk_ns __CLK_PERIOD__",
                "# __REF_DIR__ __PDK_DIR__ __OUTPUT_DIR__",
            ]
        ),
        encoding="utf-8",
    )
    (ref / "ref.openroad.tcl").write_text(
        "\n".join(
            [
                "set ::util_dir __UTIL_DIR__",
                "set pdk __PDK_DIR__",
                "set design __DESIGN_NAME__",
                "set top __MODULE_NAME__",
                "set netlist __NETLIST__",
                "set sdc __SDC__",
                "set util __UTILIZATION__",
            ]
        ),
        encoding="utf-8",
    )
    (root / "data" / "pdk" / "Nangate45" / "work_around_yosys").mkdir(
        parents=True, exist_ok=True
    )
    (root / "data" / "pdk" / "Nangate45" / "work_around_yosys" / "cells.v").write_text(
        "// lib\n",
        encoding="utf-8",
    )
    return str(ref)


@pytest.mark.parametrize(
    "fixture_name",
    [
        "epoch11_timeout_whole_reg_q.sv",
        "epoch16_timeout_indexed_neighbors.sv",
        "epoch22_timeout_cur_state_next_state.sv",
    ],
)
def test_prob144_timeout_fixtures_kill_yosys_children(monkeypatch, tmp_path, fixture_name):
    fixture_path = FIXTURE_ROOT / fixture_name
    assert fixture_path.exists(), fixture_path
    pid_file = tmp_path / "yosys_child.pid"

    se = SynthesisEvaluator(
        yosys_path=_write_executable(
            tmp_path / "fake_yosys.py",
            _timeout_spawner_script(),
        ),
        openroad_path=_write_executable(
            tmp_path / "fake_openroad.py",
            """#!/usr/bin/env python3
print("openroad should not run")
""",
        ),
        default_synthesis_timeout_s=1,
    )
    se.script_root_dir = str(tmp_path)
    se.ref_dir_path = _mk_templates(tmp_path)
    se.pdk_path = os.path.join(str(tmp_path), "data", "pdk")
    monkeypatch.setenv("EDA_CHILD_PID_FILE", str(pid_file))

    outdir = tmp_path / fixture_path.stem
    outdir.mkdir(parents=True, exist_ok=True)
    report_base = str(outdir / "candidate")

    result = se.evaluate(
        verilog_file=str(fixture_path),
        problem_name="Prob144_conwaylife",
        synth_top_module_name=TOP_MODULE,
        output_directory=str(outdir),
        report_base_path=report_base,
        verilog_evaluator=MagicMock(spec=VerilogEvaluator),
        test_sv_file=str(BENCH_ROOT / "Prob144_conwaylife_test.sv"),
        ref_sv_file=str(BENCH_ROOT / "Prob144_conwaylife_ref.sv"),
    )

    assert result["synthesis_success"] is False
    assert result["ppa_success"] is False
    report_path = Path(str(result["synthesis_log"]))
    assert report_path.exists()
    report_text = report_path.read_text(encoding="utf-8")
    assert "stage 'yosys'" in report_text
    assert "--- YOSYS ---" in report_text
    child_pid = int(pid_file.read_text(encoding="utf-8"))
    _wait_for_pid_exit(child_pid)
