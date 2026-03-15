import json
import os
import shutil
import subprocess
from pathlib import Path
from unittest.mock import MagicMock

import pytest

from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator


FIXTURE_ROOT = (
    Path(__file__).resolve().parents[1] / "fixtures" / "prob144_conwaylife_timeout"
)
FIXTURE_MANIFEST = json.loads((FIXTURE_ROOT / "manifest.json").read_text(encoding="utf-8"))
PRIMARY_TIMEOUT_STRESS_FIXTURE = FIXTURE_MANIFEST["primary_timeout_stress_fixture"]
BENCH_ROOT = (
    Path(__file__).resolve().parents[2]
    / "data"
    / "bench"
    / "VerilogEval-Spec-to-RTL"
)
TOP_MODULE = "TopModule"


def _live_eda_available() -> bool:
    return bool(shutil.which("yosys") and shutil.which("openroad"))


def _assert_no_path_scoped_eda_processes(outdir: Path) -> None:
    ps = subprocess.run(
        ["ps", "-eo", "pid=,args="],
        capture_output=True,
        text=True,
        check=True,
    )
    leaked = [
        line
        for line in ps.stdout.splitlines()
        if str(outdir) in line
        and any(tool in line for tool in ("yosys", "openroad", "yosys-abc", "vvp"))
    ]
    assert leaked == []


@pytest.mark.skipif(
    os.getenv("RUN_LIVE_EDA_SMOKE") != "1",
    reason="Set RUN_LIVE_EDA_SMOKE=1 to run live EDA timeout smoke tests.",
)
@pytest.mark.skipif(
    not _live_eda_available(),
    reason="Live EDA timeout smoke tests require yosys and openroad in PATH.",
)
@pytest.mark.parametrize(
    "fixture_name",
    [
        "epoch11_timeout_whole_reg_q.sv",
        "epoch16_timeout_indexed_neighbors.sv",
        "epoch22_timeout_cur_state_next_state.sv",
    ],
)
def test_prob144_live_timeout_smoke(tmp_path, fixture_name):
    fixture_path = FIXTURE_ROOT / fixture_name
    outdir = tmp_path / fixture_path.stem
    outdir.mkdir(parents=True, exist_ok=True)
    report_base = str(outdir / "candidate")

    se = SynthesisEvaluator(
        default_synthesis_timeout_s=45,
        default_simulation_timeout_s=45,
    )
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

    report_path = Path(str(result["synthesis_log"]))
    assert report_path.exists()
    _assert_no_path_scoped_eda_processes(outdir)


@pytest.mark.skipif(
    os.getenv("RUN_LIVE_EDA_SMOKE") != "1",
    reason="Set RUN_LIVE_EDA_SMOKE=1 to run live EDA timeout smoke tests.",
)
@pytest.mark.skipif(
    not _live_eda_available(),
    reason="Live EDA timeout smoke tests require yosys and openroad in PATH.",
)
def test_prob144_primary_live_timeout_stress_sample_times_out_and_cleans_up(tmp_path):
    fixture_path = FIXTURE_ROOT / PRIMARY_TIMEOUT_STRESS_FIXTURE
    outdir = tmp_path / "primary_timeout_stress"
    outdir.mkdir(parents=True, exist_ok=True)
    report_base = str(outdir / "candidate")

    se = SynthesisEvaluator(
        default_synthesis_timeout_s=10,
        default_simulation_timeout_s=45,
    )
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

    report_path = Path(str(result["synthesis_log"]))
    assert report_path.exists()
    report_text = report_path.read_text(encoding="utf-8")

    assert result["synthesis_success"] is False
    assert result["ppa_success"] is False
    assert "TIMEOUT" in report_text
    assert "stage 'yosys'" in report_text
    _assert_no_path_scoped_eda_processes(outdir)
