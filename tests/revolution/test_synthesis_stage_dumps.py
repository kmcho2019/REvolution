import shutil
from pathlib import Path
from types import SimpleNamespace

import pytest

from revolution.auto_bd.netlist_hash import canonical_netlist_hash
from revolution.evaluation import SynthesisEvaluator, _run_command


def make_proc(returncode=0, stdout="", stderr="", timed_out=False):
    return SimpleNamespace(
        returncode=returncode,
        stdout=stdout,
        stderr=stderr,
        timed_out=timed_out,
    )


def test_run_yosys_stage_dumps_uses_sidecar_script(mocker, tmp_path: Path):
    evaluator = SynthesisEvaluator(yosys_path="/bin/yosys")
    evaluator.pdk_path = str(tmp_path / "pdk")
    evaluator.ref_dir_path = str(tmp_path / "ref")
    run = mocker.patch(
        "revolution.evaluation._run_command",
        return_value=make_proc(returncode=0, stdout="dumped"),
    )

    result = evaluator.run_yosys_stage_dumps(
        verilog_file=str(tmp_path / "candidate.sv"),
        synth_top_module_name="top",
        output_directory=str(tmp_path),
        aux_files=(str(tmp_path / "support.sv"),),
        include_dirs=(str(tmp_path / "include"),),
        defines=("DISABLE_ASSERTS",),
    )

    assert result["stage_dump_success"] is True
    assert result["stage_dump_script_path"] == str(tmp_path / "top.stnod.yosys.tcl")
    assert result["stage_dump_dir"] == str(tmp_path / "top.stnod.stages")
    assert result["stage_dump_json_paths"][0].endswith("00_read.json")
    assert result["stage_dump_verilog_paths"][-1].endswith("07_buffered.v")
    assert run.call_args.args[0] == ["/bin/yosys", str(tmp_path / "top.stnod.yosys.tcl")]

    script = (tmp_path / "top.stnod.yosys.tcl").read_text(encoding="utf-8")
    assert "set OUTPUT_FILE" not in script
    assert str((tmp_path / "support.sv").resolve()) in script
    assert "-DDISABLE_ASSERTS" in script
    assert (tmp_path / "top.stnod.yosys.log").is_file()


def test_run_yosys_stage_dumps_reports_timeout(mocker, tmp_path: Path):
    evaluator = SynthesisEvaluator(yosys_path="/bin/yosys")
    evaluator.pdk_path = str(tmp_path / "pdk")
    evaluator.ref_dir_path = str(tmp_path / "ref")
    mocker.patch(
        "revolution.evaluation._run_command",
        return_value=make_proc(returncode=-15, stderr="timeout", timed_out=True),
    )

    result = evaluator.run_yosys_stage_dumps(
        verilog_file=str(tmp_path / "candidate.sv"),
        synth_top_module_name="top",
        output_directory=str(tmp_path),
    )

    assert result["stage_dump_success"] is False
    assert "timeout" in (tmp_path / "top.stnod.yosys.log").read_text(encoding="utf-8")


def test_stage_dump_final_snapshot_matches_baseline_yosys_netlist(tmp_path: Path):
    yosys = shutil.which("yosys")
    if yosys is None:
        pytest.skip()

    candidate = tmp_path / "candidate.sv"
    baseline_netlist = tmp_path / "candidate.syn.v"
    candidate.write_text(
        "module top(input a, input b, output y);\n"
        "  assign y = a & b;\n"
        "endmodule\n",
        encoding="utf-8",
    )
    evaluator = SynthesisEvaluator(yosys_path=yosys)
    baseline_script = evaluator._create_yosys_script(
        verilog_file=str(candidate),
        module_name="top",
        output_directory=str(tmp_path),
        clk_period=0.01,
        output_file=str(baseline_netlist),
    )
    baseline = _run_command([yosys, baseline_script], timeout_s=60)
    stage_result = evaluator.run_yosys_stage_dumps(
        verilog_file=str(candidate),
        synth_top_module_name="top",
        output_directory=str(tmp_path),
        synthesis_timeout_s=60,
    )

    assert baseline.returncode == 0
    assert stage_result["stage_dump_success"] is True
    final_stage = Path(stage_result["stage_dump_verilog_paths"][-1])
    assert final_stage.is_file()
    assert canonical_netlist_hash(baseline_netlist.read_text(encoding="utf-8")) == (
        canonical_netlist_hash(final_stage.read_text(encoding="utf-8"))
    )
