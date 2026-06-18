from pathlib import Path

from revolution.auto_bd.stage_dumps import (
    STNOD_STAGE_NAMES,
    write_yosys_stage_dump_script,
)


def test_stage_dump_plan_lists_expected_sidecar_paths(tmp_path: Path):
    plan = write_yosys_stage_dump_script(
        verilog_file=tmp_path / "candidate.sv",
        module_name="top",
        output_directory=tmp_path,
        pdk_path=tmp_path / "pdk",
        ref_dir_path=tmp_path / "ref",
        clk_period_ps=10.0,
    )

    assert plan.stage_names == STNOD_STAGE_NAMES
    assert plan.script_path == tmp_path / "top.stnod.yosys.tcl"
    assert plan.stage_dir == tmp_path / "top.stnod.stages"
    assert plan.json_paths()[0] == tmp_path / "top.stnod.stages" / "00_read.json"
    assert plan.verilog_paths()[-1] == tmp_path / "top.stnod.stages" / "07_buffered.v"


def test_stage_dump_script_is_observational_sidecar(tmp_path: Path):
    plan = write_yosys_stage_dump_script(
        verilog_file=tmp_path / "candidate.sv",
        module_name="top",
        output_directory=tmp_path,
        pdk_path=tmp_path / "pdk",
        ref_dir_path=tmp_path / "ref",
        clk_period_ps=10.0,
        aux_files=(tmp_path / "support.sv",),
        include_dirs=(tmp_path / "include",),
        defines=("DISABLE_ASSERTS",),
    )
    script = plan.script_path.read_text(encoding="utf-8")

    assert "set OUTPUT_FILE" not in script
    assert "write_json ${STAGE_DIR}/${stage_name}.json" in script
    assert "write_verilog -noattr -noexpr -nohex -nodec" in script
    assert "read_verilog -defer -sv -DDISABLE_ASSERTS -I" in script
    assert str((tmp_path / "support.sv").resolve()) in script
    assert "abc -D $ABC_CLOCK_PERIOD_IN_PS" in script
    assert "dump_stage 00_read" in script
    assert "dump_stage 07_buffered" in script
