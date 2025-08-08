import os
import subprocess
from unittest.mock import MagicMock

import pytest

from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator


def make_proc(returncode=0, stdout="", stderr=""):
    m = MagicMock()
    m.returncode = returncode
    m.stdout = stdout
    m.stderr = stderr
    return m


# Tests for VerilogEvaluator
def test_success_simulation_creates_log_and_sets_cwd(
    mocker, minimal_sv_files, tmp_path
):
    comp = make_proc(returncode=0, stdout="OK compile")
    sim = make_proc(returncode=0, stdout="Simulation fine")
    mock_run = mocker.patch("subprocess.run", side_effect=[comp, sim])
    mocker.patch("os.chmod")  # avoid real chmod

    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(
        generated_sv_file=minimal_sv_files["dut"],
        test_sv_file=minimal_sv_files["tb"],
        ref_sv_file=None,
        top_module_name="tb",
        simulation_timeout_seconds=5,
    )

    assert res["status"] == "success"
    # Compile call: verify command elements
    compile_args, compile_kwargs = mock_run.call_args_list[0]
    argv = compile_args[0]
    assert argv[0] == "/fake/iverilog"
    assert "-g2012" in argv and "-s" in argv and "tb" in argv
    assert minimal_sv_files["dut"] in argv and minimal_sv_files["tb"] in argv
    # Simulation call has correct working dir (dirname of first DUT file)
    _, run_kwargs = mock_run.call_args_list[1]
    assert run_kwargs["cwd"] == os.path.dirname(minimal_sv_files["dut"])
    # Log gets written alongside dut
    log = os.path.join(os.path.dirname(minimal_sv_files["dut"]), "dut_simulation.log")
    assert os.path.isfile(log)


def test_compilation_error_path(mocker, minimal_sv_files):
    comp = make_proc(returncode=1, stderr="Syntax error at line 5.")
    mocker.patch("subprocess.run", return_value=comp)
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(minimal_sv_files["dut"], minimal_sv_files["tb"], None)
    assert res["status"] == "compilation_error"
    assert "Syntax error" in res["compilation_stderr"]
    assert res["compiled_file_path"] is None


def test_simulation_error_nonzero_exit(mocker, minimal_sv_files):
    comp = make_proc(returncode=0)
    sim = make_proc(returncode=1, stdout="TB failed")
    mocker.patch("subprocess.run", side_effect=[comp, sim])
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(minimal_sv_files["dut"], minimal_sv_files["tb"], None)
    assert res["status"] == "simulation_error"
    assert "TB failed" in res["simulation_stdout"]


def test_simulation_timeout(mocker, minimal_sv_files):
    comp = make_proc(returncode=0)
    mocker.patch(
        "subprocess.run",
        side_effect=[comp, subprocess.TimeoutExpired(cmd="vvp", timeout=1)],
    )
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(
        minimal_sv_files["dut"],
        minimal_sv_files["tb"],
        None,
        simulation_timeout_seconds=1,
    )
    assert res["status"] == "simulation_timeout"
    assert "timed out" in res["simulation_stderr"].lower()


def test_compile_stage_file_not_found_safeguard(mocker, minimal_sv_files):
    mocker.patch("subprocess.run", side_effect=FileNotFoundError("iverilog not found"))
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(minimal_sv_files["dut"], minimal_sv_files["tb"], None)
    assert res["status"] == "file_error"
    assert "iverilog" in res["compilation_stderr"].lower()


def test_simulation_stage_vvp_missing(mocker, minimal_sv_files):
    comp = make_proc(returncode=0)
    mocker.patch("subprocess.run", side_effect=[comp, FileNotFoundError("vvp missing")])
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(minimal_sv_files["dut"], minimal_sv_files["tb"], None)
    assert res["status"] == "file_error"
    assert "vvp" in res["simulation_stderr"].lower()


def test_invalid_generated_type_returns_file_error(mocker, minimal_sv_files):
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(
        generated_sv_file=123, test_sv_file=minimal_sv_files["tb"], ref_sv_file=None
    )  # type: ignore
    assert res["status"] == "file_error"
    assert "invalid type" in res["compilation_stderr"].lower()


def test_missing_ref_file_short_circuits(mocker, minimal_sv_files):
    # Only the ref should be missing; others real
    mock_run = mocker.patch("subprocess.run")
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(
        minimal_sv_files["dut"],
        minimal_sv_files["tb"],
        ref_sv_file=str(os.path.join(minimal_sv_files["dir"], "nope.sv")),
    )
    assert res["status"] == "file_error"
    assert "reference verilog file not found" in res["compilation_stderr"].lower()
    mock_run.assert_not_called()


def test_dedup_input_files_and_skip_ref_if_in_dut_list(mocker, minimal_sv_files):
    comp = make_proc(returncode=0)
    sim = make_proc(returncode=0)
    mock_run = mocker.patch("subprocess.run", side_effect=[comp, sim])

    # Include duplicates; also pass ref equal to the first DUT to ensure it isn't appended
    dut_list = [
        minimal_sv_files["dut"],
        minimal_sv_files["pdk"],
        minimal_sv_files["dut"],
    ]
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    _ = ev.evaluate(
        generated_sv_file=dut_list,
        test_sv_file=minimal_sv_files["tb"],
        ref_sv_file=minimal_sv_files["dut"],
        top_module_name="custom_tb",
    )

    compile_args, _ = mock_run.call_args_list[0]
    argv = compile_args[0]
    svs = [a for a in argv if a.endswith((".sv", ".v"))]
    # Only one of each DUT + PDK, testbench included, ref skipped
    assert svs.count(minimal_sv_files["dut"]) == 1
    assert svs.count(minimal_sv_files["pdk"]) == 1
    assert minimal_sv_files["tb"] in svs
    assert svs.count(minimal_sv_files["dut"]) == 1  # ref wasn't appended
    # top module propagated
    assert "-s" in argv and "custom_tb" in argv


def test_os_chmod_warning_is_non_fatal(mocker, minimal_sv_files):
    comp = make_proc(returncode=0)
    sim = make_proc(returncode=0)
    mocker.patch("subprocess.run", side_effect=[comp, sim])
    mocker.patch("os.chmod", side_effect=OSError("nope"))

    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(minimal_sv_files["dut"], minimal_sv_files["tb"], None)
    assert res["status"] == "success"


def test_verilog_evaluator_compilation_error(mocker):
    """
    Tests that VerilogEvaluator correctly handles a compilation error.
    """
    # Arrange: Mock subprocess.run to simulate a failed compilation
    mock_process = MagicMock()
    mock_process.returncode = 1  # Non-zero return code indicates an error
    mock_process.stdout = ""
    mock_process.stderr = "Syntax error at line 5."

    mocker.patch("shutil.which", return_value=True)
    mocker.patch("subprocess.run", return_value=mock_process)

    # We also need to mock os.path.isfile to prevent FileNotFoundError
    mocker.patch("os.path.isfile", return_value=True)
    mocker.patch("os.makedirs")  # Mock makedirs to avoid creating directories

    evaluator = VerilogEvaluator(
        iverilog_executable_path="/fake/iverilog", vvp_executable_path="/fake/vvp"
    )

    # Action
    results = evaluator.evaluate(
        generated_sv_file="dut.sv", test_sv_file="tb.sv", ref_sv_file=None
    )

    # Assert
    assert results["status"] == "compilation_error"
    assert "Syntax error" in results["compilation_stderr"]
    assert results["compiled_file_path"] is None  # No vvp file should be created


def test_compilation_error_is_reported(
    mocker, fake_binaries, minimal_sv_files, no_chmod
):
    # Arrange: first subprocess.run (compile) fails
    compile_proc = make_proc(returncode=1, stderr="Syntax error at line 5.")
    mock = mocker.patch("subprocess.run", return_value=compile_proc)

    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    results = ev.evaluate(
        generated_sv_file=minimal_sv_files["dut"],
        test_sv_file=minimal_sv_files["tb"],
        ref_sv_file=None,
    )

    assert results["status"] == "compilation_error"
    assert "Syntax error" in results["compilation_stderr"]
    assert results["compiled_file_path"] is None
    # compile was invoked once, simulation not started
    assert mock.call_count == 1


def test_simulation_success(mocker, fake_binaries, minimal_sv_files, no_chmod):
    compile_proc = make_proc(returncode=0, stdout="Compile OK")
    sim_proc = make_proc(returncode=0, stdout="Simulation OK")

    run = mocker.patch("subprocess.run", side_effect=[compile_proc, sim_proc])

    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    results = ev.evaluate(
        generated_sv_file=minimal_sv_files["dut"],
        test_sv_file=minimal_sv_files["tb"],
        ref_sv_file=None,
    )

    assert results["status"] == "success"
    # ensure vvp invocation used compiled file path and cwd=dut dir
    _, sim_kwargs = run.call_args_list[1]
    assert sim_kwargs["cwd"] == os.path.dirname(minimal_sv_files["dut"])
    assert (
        "simulation_stdout" in results
        and "Simulation OK" in results["simulation_stdout"]
    )


def test_simulation_nonzero_return_is_error(
    mocker, fake_binaries, minimal_sv_files, no_chmod
):
    compile_proc = make_proc(returncode=0, stdout="Compile OK")
    sim_proc = make_proc(returncode=2, stdout="TB failed", stderr="assertion")

    mocker.patch("subprocess.run", side_effect=[compile_proc, sim_proc])

    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    results = ev.evaluate(
        generated_sv_file=minimal_sv_files["dut"],
        test_sv_file=minimal_sv_files["tb"],
        ref_sv_file=None,
    )

    assert results["status"] == "simulation_error"
    assert "TB failed" in results["simulation_stdout"]


def test_file_errors_missing_inputs(mocker, fake_binaries, tmp_path, no_chmod):
    # Missing DUT
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    res = ev.evaluate(
        generated_sv_file=str(tmp_path / "missing_dut.sv"),
        test_sv_file=str(tmp_path / "tb.sv"),
        ref_sv_file=None,
    )
    assert res["status"] == "file_error"
    assert "Generated Verilog file not found" in res["compilation_stderr"]

    # Present DUT, missing TB
    dut = tmp_path / "dut.sv"
    dut.write_text("module dut; endmodule\n")
    res2 = ev.evaluate(
        generated_sv_file=str(dut),
        test_sv_file=str(tmp_path / "missing_tb.sv"),
        ref_sv_file=None,
    )
    assert res2["status"] == "file_error"
    assert "Test Verilog file not found" in res2["compilation_stderr"]

    # Present DUT + TB, missing ref
    tb = tmp_path / "tb.sv"
    tb.write_text("module tb; endmodule\n")
    res3 = ev.evaluate(
        generated_sv_file=str(dut),
        test_sv_file=str(tb),
        ref_sv_file=str(tmp_path / "missing_ref.sv"),
    )
    assert res3["status"] == "file_error"
    assert "Reference Verilog file not found" in res3["compilation_stderr"]


def test_compile_cmd_flags_and_dedup(mocker, fake_binaries, minimal_sv_files, no_chmod):
    compile_proc = make_proc(returncode=0)
    sim_proc = make_proc(returncode=0, stdout="OK")

    run = mocker.patch("subprocess.run", side_effect=[compile_proc, sim_proc])

    pdk_file = os.path.join(os.path.dirname(minimal_sv_files["dut"]), "cells.v")
    open(pdk_file, "w").write("//cells\n")

    # include duplicates and testbench inside dut_files (should not be added twice)
    files = [
        minimal_sv_files["dut"],
        minimal_sv_files["dut"],
        pdk_file,
        pdk_file,
        minimal_sv_files["tb"],
    ]
    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    _ = ev.evaluate(
        generated_sv_file=files,
        test_sv_file=minimal_sv_files["tb"],
        ref_sv_file=minimal_sv_files["dut"],  # same as first; must not be re-added
    )

    # First call is compile
    (compile_cmd,), compile_kwargs = run.call_args_list[0]
    # cmd is a list; verify core flags + ordering
    assert compile_cmd[0].endswith("iverilog")
    assert "-g2012" in compile_cmd
    assert "-s" in compile_cmd and "tb" in compile_cmd
    assert "-o" in compile_cmd
    # De-duplication: each file count is 1
    assert compile_cmd.count(minimal_sv_files["dut"]) == 1
    assert compile_cmd.count(pdk_file) == 1
    # testbench should appear only once, despite being in dut_files
    assert compile_cmd.count(minimal_sv_files["tb"]) == 1


def test_windows_skips_chmod(mocker, fake_binaries, minimal_sv_files):
    compile_proc = make_proc(returncode=0)
    sim_proc = make_proc(returncode=0)

    mocker.patch("subprocess.run", side_effect=[compile_proc, sim_proc])
    # Force Windows path
    mocker.patch("os.name", "nt")
    chmod_spy = mocker.patch("os.chmod")

    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    _ = ev.evaluate(
        generated_sv_file=minimal_sv_files["dut"],
        test_sv_file=minimal_sv_files["tb"],
        ref_sv_file=None,
    )
    chmod_spy.assert_not_called()


def test_output_directory_and_log_written(mocker, fake_binaries, tmp_path, no_chmod):
    # Force compilation error to check log creation
    compile_proc = make_proc(returncode=1, stderr="compile broke")
    mocker.patch("subprocess.run", return_value=compile_proc)

    outdir = tmp_path / "out"
    dut = tmp_path / "dut.sv"
    tb = tmp_path / "tb.sv"
    dut.write_text("module dut; endmodule\n")
    tb.write_text("module tb; endmodule\n")

    ev = VerilogEvaluator("/fake/iverilog", "/fake/vvp")
    results = ev.evaluate(
        generated_sv_file=str(dut),
        test_sv_file=str(tb),
        ref_sv_file=None,
        output_directory=str(outdir),
    )

    assert results["status"] == "compilation_error"
    assert results["log_file_path"] is not None
    assert os.path.exists(results["log_file_path"])
    with open(results["log_file_path"], "r", encoding="utf-8") as f:
        content = f.read()
    assert "--- Compilation Phase ---" in content


# Tests for SynthesisEvaluator


def _mk_templates(root):
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
    # PDK verilog lib for post-synth sim
    (root / "data" / "pdk" / "Nangate45" / "work_around_yosys").mkdir(
        parents=True, exist_ok=True
    )
    (root / "data" / "pdk" / "Nangate45" / "work_around_yosys" / "cells.v").write_text(
        "// lib", encoding="utf-8"
    )
    return ref


def _mk_design(tmp_path):
    dut = tmp_path / "top.sv"
    tb = tmp_path / "tb.sv"
    ref = tmp_path / "ref.sv"
    dut.write_text("module top(input clk); endmodule", encoding="utf-8")
    tb.write_text("module tb; endmodule", encoding="utf-8")
    ref.write_text("module ref; endmodule", encoding="utf-8")
    return str(dut), str(tb), str(ref)


def test_create_sdc_and_parse_clk(tmp_path):
    se = SynthesisEvaluator()
    # Point internal dirs to temp
    se.script_root_dir = str(tmp_path)
    se.ref_dir_path = str(_mk_templates(tmp_path))
    se.pdk_path = os.path.join(str(tmp_path), "data", "pdk")

    verilog = tmp_path / "mod.sv"
    verilog.write_text("module mod(input clk, input rst); endmodule;", encoding="utf-8")
    sdc = se._create_sdc_file(str(verilog), "mod", str(tmp_path), clk_period=0.01)
    text = open(sdc, "r", encoding="utf-8").read()
    assert "create_clock" in text and "get_ports clk" in text
    assert "set clk_period 0.01" in text


def test_create_yosys_and_openroad_scripts(tmp_path):
    se = SynthesisEvaluator()
    se.script_root_dir = str(tmp_path)
    se.ref_dir_path = str(_mk_templates(tmp_path))
    se.pdk_path = os.path.join(str(tmp_path), "data", "pdk")

    yosys = se._create_yosys_script(
        verilog_file=str(tmp_path / "a.sv"),
        module_name="top",
        output_directory=str(tmp_path),
        clk_period=0.01,
        output_file=str(tmp_path / "a.syn.v"),
    )
    ytxt = open(yosys, "r", encoding="utf-8").read()
    assert "__VERILOG_FILE__" not in ytxt
    assert "read_verilog" in ytxt and "write_verilog" in ytxt
    assert "set clk_ns 10.0" in ytxt  # 0.01 * 1000

    orc = se._create_openroad_script(
        sdc_file_path=str(tmp_path / "top.sdc"),
        module_name="top",
        output_directory=str(tmp_path),
        output_file=str(tmp_path / "a.syn.v"),
    )
    otxt = open(orc, "r", encoding="utf-8").read()
    assert "__NETLIST__" not in otxt and "__SDC__" not in otxt
    assert "set netlist" in otxt and "set sdc" in otxt


def test_run_synthesis_success_and_failure(mocker, tmp_path):
    se = SynthesisEvaluator()
    se.script_root_dir = str(tmp_path)
    se.ref_dir_path = str(_mk_templates(tmp_path))
    se.pdk_path = os.path.join(str(tmp_path), "data", "pdk")

    report_base = str(tmp_path / "rpt" / "design")
    os.makedirs(os.path.dirname(report_base), exist_ok=True)

    # Ensure the verilog file exists because _create_sdc_file reads it
    (tmp_path / "a.sv").write_text("module top(input clk); endmodule", encoding="utf-8")
    # Success path
    mocker.patch(
        "subprocess.run", return_value=make_proc(returncode=0, stdout="ok", stderr=b"")
    )
    ok, report = se._run_synthesis(
        verilog_file=str(tmp_path / "a.sv"),
        problem_name="p",
        synth_top_module_name="top",
        output_directory=str(tmp_path),
        report_base_path=report_base,
        synthesized_netlist_path=str(tmp_path / "a.syn.v"),
    )
    assert ok and report.endswith("_synthesis_report.rpt")

    # Failure path ensures report is written/appended
    mocker.patch("subprocess.run", return_value=make_proc(returncode=1, stderr=b"boom"))
    ok, report = se._run_synthesis(
        verilog_file=str(tmp_path / "a.sv"),
        problem_name="p",
        synth_top_module_name="top",
        output_directory=str(tmp_path),
        report_base_path=report_base,
        synthesized_netlist_path=str(tmp_path / "a.syn.v"),
    )
    assert not ok
    assert os.path.isfile(report)
    assert "SYNTHESIS FAILED" in open(report, "r", encoding="utf-8").read()


def test_check_synthesis_functionality_happy_and_unhappy_paths(mocker, tmp_path):
    se = SynthesisEvaluator()
    se.script_root_dir = str(tmp_path)
    se.ref_dir_path = str(_mk_templates(tmp_path))
    se.pdk_path = os.path.join(str(tmp_path), "data", "pdk")

    dut, tb, ref = _mk_design(tmp_path)

    mock_ev = MagicMock(spec=VerilogEvaluator)
    # Pass case: status success with "Mismatches: 0"
    mock_ev.evaluate.return_value = {
        "status": "success",
        "compilation_stdout": "",
        "compilation_stderr": "",
        "simulation_stdout": "Mismatches: 0\nAll good",
        "simulation_stderr": "",
        "log_file_path": None,
        "compiled_file_path": None,
    }
    ok, _ = se._check_synthesis_functionality(
        synthesized_netlist=dut,
        test_sv=tb,
        ref_sv=ref,
        tb_top_module="tb",
        output_dir=str(tmp_path),
        verilog_evaluator=mock_ev,
    )
    assert ok

    # Fail case: mismatches not zero
    mock_ev.evaluate.return_value["simulation_stdout"] = "Mismatches: 2"
    ok, _ = se._check_synthesis_functionality(
        synthesized_netlist=dut,
        test_sv=tb,
        ref_sv=ref,
        tb_top_module="tb",
        output_dir=str(tmp_path),
        verilog_evaluator=mock_ev,
    )
    assert not ok

    # Missing PDK lib path
    se.pdk_path = str(tmp_path / "no_pdk_here")
    ok, log = se._check_synthesis_functionality(
        synthesized_netlist=dut,
        test_sv=tb,
        ref_sv=None,
        tb_top_module="tb",
        output_dir=str(tmp_path),
        verilog_evaluator=mock_ev,
    )
    assert not ok and "PDK Verilog library not found" in log


def test_parse_ppa_log_various_cases(tmp_path):
    se = SynthesisEvaluator()
    # Negative WNS => sequential => eff = clk_period - wns
    rpt = tmp_path / "r.rpt"
    rpt.write_text(
        "\n".join(
            [
                "tns -5.0",
                "wns -1.5",
                "Total something something x 0.99",
                "Design area 123.45",
            ]
        ),
        encoding="utf-8",
    )
    metrics = se._parse_ppa_log(str(rpt))
    assert metrics["tns"] == -5.0
    assert metrics["wns"] == -1.5
    assert abs(metrics["eff_clk_period"] - (se.clk_period - (-1.5))) < 1e-12
    assert metrics["power"] == 0.99
    assert metrics["area"] == 123.45
    assert os.path.isfile(metrics["report_path"])

    # Non-negative WNS => combinational => eff = 0.0
    rpt2 = tmp_path / "r2.rpt"
    rpt2.write_text(
        "\n".join(
            [
                "tns 0.0",
                "wns 0.0",
                "Total a b c 1.23",
                "Design area 42 u^2 1% utilization.",
            ]
        ),
        encoding="utf-8",
    )
    m2 = se._parse_ppa_log(str(rpt2))
    assert m2["eff_clk_period"] == 0.0
    assert m2["tns"] == 0.0
    assert m2["wns"] == 0.0
    assert m2["power"] == 1.23
    assert m2["area"] == 42.0

    # Missing report file handled gracefully
    m3 = se._parse_ppa_log(str(tmp_path / "missing.rpt"))
    assert m3["tns"] is None and m3["report_path"] is None


def test_evaluate_end_to_end_with_stubs(mocker, tmp_path):
    se = SynthesisEvaluator()
    se.script_root_dir = str(tmp_path)
    se.ref_dir_path = str(_mk_templates(tmp_path))
    se.pdk_path = os.path.join(str(tmp_path), "data", "pdk")

    dut, tb, _ = _mk_design(tmp_path)
    outdir = str(tmp_path / "out")
    os.makedirs(outdir, exist_ok=True)
    report_base = os.path.join(outdir, "prob")

    # Stub _run_synthesis to succeed and point to a real report file we control
    rpt = report_base + "_synthesis_report.rpt"
    os.makedirs(os.path.dirname(rpt), exist_ok=True)
    open(rpt, "w", encoding="utf-8").write(
        "\n".join(
            [
                "tns -7.0",
                "wns -0.4",
                "Total a b c 0.50",
                "Design area 256.0",
            ]
        )
    )

    mocker.patch.object(se, "_run_synthesis", return_value=(True, rpt))

    # Mock post-synth functional sim to pass
    mock_ev = MagicMock(spec=VerilogEvaluator)
    mock_ev.evaluate.return_value = {
        "status": "success",
        "compilation_stdout": "",
        "compilation_stderr": "",
        "simulation_stdout": "Mismatches: 0",
        "simulation_stderr": "",
        "log_file_path": None,
        "compiled_file_path": None,
    }

    results = se.evaluate(
        verilog_file=dut,
        problem_name="prob",
        synth_top_module_name="top",
        output_directory=outdir,
        report_base_path=report_base,
        verilog_evaluator=mock_ev,
        test_sv_file=tb,
        ref_sv_file=None,
    )

    assert results["synthesis_success"] is True
    assert results["synthesis_functionality_success"] is True
    assert results["ppa_success"] is True
    ppa = results["ppa_metrics"]
    assert isinstance(ppa, dict), f"ppa_metrics should be a dict, got {type(ppa)}"

    assert ppa.get("area") == 256.0
    assert ppa.get("power") == 0.50


def test_create_yosys_script_replacements(tmp_path):
    se = SynthesisEvaluator()
    # Patch ref_dir and pdk path to temporary files
    se.ref_dir_path = str(tmp_path / "ref")
    se.pdk_path = str(tmp_path / "pdk")
    os.makedirs(se.ref_dir_path, exist_ok=True)
    os.makedirs(se.pdk_path, exist_ok=True)

    ref_tcl = os.path.join(se.ref_dir_path, "ref.yosys.tcl")
    with open(ref_tcl, "w") as f:
        f.write(
            "__VERILOG_FILE__ __MODULE_NAME__ __OUTPUT_DIR__ __OUTPUT_FILE__ __REF_DIR__ __PDK_DIR__ __CLK_PERIOD__"
        )

    out = se._create_yosys_script(
        verilog_file="/abs/v.sv",
        module_name="top",
        output_directory=str(tmp_path),
        clk_period=0.01,
        output_file="/abs/out.syn.v",
    )

    text = open(out).read()
    assert "/abs/v.sv" in text
    assert "top" in text
    assert str(tmp_path) in text
    assert "/abs/out.syn.v" in text
    assert se.ref_dir_path in text
    assert se.pdk_path in text
    assert "10.0" in text  # 0.01ns * 1000 => 10.0


def test_create_openroad_script_replacements(tmp_path):
    se = SynthesisEvaluator()
    se.ref_dir_path = str(tmp_path / "ref")
    se.pdk_path = str(tmp_path / "pdk")
    os.makedirs(se.ref_dir_path, exist_ok=True)
    os.makedirs(se.pdk_path, exist_ok=True)

    ref_tcl = os.path.join(se.ref_dir_path, "ref.openroad.tcl")
    with open(ref_tcl, "w") as f:
        f.write(
            "__UTIL_DIR__ __PDK_DIR__ __DESIGN_NAME__ __MODULE_NAME__ __NETLIST__ __SDC__ __UTILIZATION__"
        )

    sdc = str(tmp_path / "top.sdc")
    net = str(tmp_path / "top.syn.v")
    out = se._create_openroad_script(
        sdc_file_path=sdc,
        module_name="top",
        output_directory=str(tmp_path),
        output_file=net,
    )

    text = open(out).read()
    assert "__UTIL_DIR__" not in text
    assert se.pdk_path in text
    assert "top" in text
    assert net in text
    assert sdc in text
    assert "0.5" in text


def test_run_synthesis_success_and_failure_alt(mocker, tmp_path):
    se = SynthesisEvaluator()

    # Avoid reading templates in this unit test; patch helpers to return known paths
    mocker.patch.object(se, "_create_sdc_file", return_value=str(tmp_path / "a.sdc"))
    mocker.patch.object(
        se, "_create_yosys_script", return_value=str(tmp_path / "a.yosys.tcl")
    )
    mocker.patch.object(
        se, "_create_openroad_script", return_value=str(tmp_path / "a.openroad.tcl")
    )

    rpt_base = str(tmp_path / "report")
    # Success path
    ok = MagicMock(returncode=0, stdout=b"ok", stderr=b"")
    run = mocker.patch("subprocess.run", return_value=ok)
    success, rpt_path = se._run_synthesis(
        "/d.v", "p", "top", str(tmp_path), rpt_base, str(tmp_path / "d.syn.v")
    )
    assert success is True
    assert rpt_path == rpt_base + "_synthesis_report.rpt"

    # Failure path
    fail = MagicMock(returncode=1, stdout=b"", stderr=b"boom")
    run.return_value = fail
    success2, rpt_path2 = se._run_synthesis(
        "/d.v", "p", "top", str(tmp_path), rpt_base, str(tmp_path / "d.syn.v")
    )
    assert success2 is False
    with open(rpt_path2, "r") as f:
        content = f.read()
    assert "SYNTHESIS FAILED" in content
    assert "boom" in content


def test_check_synthesis_functionality_requires_pdk(tmp_path):
    se = SynthesisEvaluator()
    se.pdk_path = str(tmp_path / "no_pdk_here")  # ensure missing
    ve = MagicMock(spec=VerilogEvaluator)

    ok, log = se._check_synthesis_functionality(
        synthesized_netlist=str(tmp_path / "n.syn.v"),
        test_sv=str(tmp_path / "tb.sv"),
        ref_sv=None,
        tb_top_module="tb",
        output_dir=str(tmp_path),
        verilog_evaluator=ve,
    )
    assert ok is False
    assert "PDK Verilog library not found" in log


@pytest.mark.parametrize(
    "sim_stdout,expected",
    [
        ("Mismatches: 0\nAll good\n", True),
        ("hello\n===========Your Design Passed===========\n", True),
        ("Mismatches: 1\n", False),
    ],
)
def test_check_synthesis_functionality_delegates_to_verilog_ev(
    tmp_path, pdk_cells, sim_stdout, expected
):
    se = SynthesisEvaluator()
    # point instance to the temp PDK root that contains our cells.v
    se.pdk_path = os.path.dirname(os.path.dirname(os.path.dirname(pdk_cells)))

    ve = MagicMock(spec=VerilogEvaluator)
    ve.evaluate.return_value = {
        "status": "success",
        "simulation_stdout": sim_stdout,
        "simulation_stderr": "",
        "compilation_stdout": "",
        "compilation_stderr": "",
        "log_file_path": None,
        "compiled_file_path": None,
    }

    ok, log = se._check_synthesis_functionality(
        synthesized_netlist=str(tmp_path / "n.syn.v"),
        test_sv=str(tmp_path / "tb.sv"),
        ref_sv=None,
        tb_top_module="tb",
        output_dir=str(tmp_path),
        verilog_evaluator=ve,
    )
    assert ok is expected
    # verify we passed a list [synthesized_netlist, cells.v]
    called_args, called_kwargs = ve.evaluate.call_args
    # The code uses keyword args, so args is empty; pull from kwargs
    dut_list = called_kwargs.get("generated_sv_file") or called_args[0]
    assert isinstance(dut_list, list)
    assert dut_list[0] == str(tmp_path / "n.syn.v")
    # pdk_cells is the exact path created by the fixture
    assert pdk_cells in dut_list
