from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

STNOD_STAGE_NAMES = (
    "00_read",
    "01_synth",
    "02_opt",
    "03_arithmap",
    "04_dffmap",
    "05_abc",
    "06_clean",
    "07_buffered",
)


@dataclass(frozen=True)
class YosysStageDumpPlan:
    """Sidecar Yosys script and artifact paths for ST-NOD observations."""

    script_path: Path
    stage_dir: Path
    stage_names: tuple[str, ...]

    def json_paths(self) -> tuple[Path, ...]:
        """Return expected per-stage Yosys JSON snapshots."""

        return tuple(self.stage_dir / f"{stage}.json" for stage in self.stage_names)

    def verilog_paths(self) -> tuple[Path, ...]:
        """Return expected per-stage Verilog snapshots."""

        return tuple(self.stage_dir / f"{stage}.v" for stage in self.stage_names)


def write_yosys_stage_dump_script(
    *,
    verilog_file: Path,
    module_name: str,
    output_directory: Path,
    pdk_path: Path,
    ref_dir_path: Path,
    clk_period_ps: float,
    aux_files: tuple[Path, ...] = (),
    include_dirs: tuple[Path, ...] = (),
    defines: tuple[str, ...] = (),
) -> YosysStageDumpPlan:
    """Write an observational Yosys script for synthesis-trajectory dumps."""

    assert module_name
    assert clk_period_ps > 0

    output_directory.mkdir(parents=True, exist_ok=True)
    script_path = output_directory / f"{module_name}.stnod.yosys.tcl"
    stage_dir = output_directory / f"{module_name}.stnod.stages"
    define_flags = "".join(f" -D{define}" for define in defines)
    incdir_flags = "".join(f" -I{path.resolve()}" for path in include_dirs)
    aux_read = "\n".join(
        f"read_verilog -defer -sv{define_flags}{incdir_flags} {path.resolve()}"
        for path in aux_files
    )
    script_path.write_text(
        _stage_dump_script_text(
            verilog_file=verilog_file.resolve(),
            module_name=module_name,
            output_directory=output_directory.resolve(),
            stage_dir=stage_dir.resolve(),
            pdk_path=pdk_path.resolve(),
            ref_dir_path=ref_dir_path.resolve(),
            clk_period_ps=clk_period_ps,
            define_flags=define_flags,
            incdir_flags=incdir_flags,
            aux_read=aux_read,
        ),
        encoding="utf-8",
    )
    return YosysStageDumpPlan(
        script_path=script_path,
        stage_dir=stage_dir,
        stage_names=STNOD_STAGE_NAMES,
    )


def _stage_dump_script_text(
    *,
    verilog_file: Path,
    module_name: str,
    output_directory: Path,
    stage_dir: Path,
    pdk_path: Path,
    ref_dir_path: Path,
    clk_period_ps: float,
    define_flags: str,
    incdir_flags: str,
    aux_read: str,
) -> str:
    return f"""yosys -import

set VERILOG_FILE {verilog_file}
set MODULE_NAME {module_name}
set OUTPUT_DIR {output_directory}
set STAGE_DIR {stage_dir}
set REF_DIR {ref_dir_path}
set PDK_DIR {pdk_path}
set ABC_CLOCK_PERIOD_IN_PS {clk_period_ps}
set LIBERTY_PATH ${{PDK_DIR}}/Nangate45/Nangate45_typ.lib
set CLKGATE_MAP_FILE ${{PDK_DIR}}/cells_clkgate.v
set LATCH_MAP_FILE ${{PDK_DIR}}/cells_latch.v
set ADDER_MAP_FILE ${{PDK_DIR}}/cells_adders.v

file mkdir ${{STAGE_DIR}}

proc dump_stage {{stage_name}} {{
    global STAGE_DIR
    write_json ${{STAGE_DIR}}/${{stage_name}}.json
    write_verilog -noattr -noexpr -nohex -nodec ${{STAGE_DIR}}/${{stage_name}}.v
}}

read_verilog -defer -sv{define_flags}{incdir_flags} $VERILOG_FILE
{aux_read}
read_liberty -lib ${{LIBERTY_PATH}}
read_verilog -defer $CLKGATE_MAP_FILE
dump_stage 00_read

synth -top ${{MODULE_NAME}} -flatten
dump_stage 01_synth

opt -purge
dump_stage 02_opt

extract_fa
techmap -map $ADDER_MAP_FILE
techmap
opt -fast -purge
dump_stage 03_arithmap

techmap -map $LATCH_MAP_FILE
dfflibmap -liberty $LIBERTY_PATH
opt
dump_stage 04_dffmap

set constr [open ${{OUTPUT_DIR}}/${{MODULE_NAME}}.stnod.abc.constr w]
puts $constr "set_driving_cell BUF_X1"
puts $constr "set_load 3.898"
close $constr

set abc_script ${{REF_DIR}}/ref.abc.script
abc -D $ABC_CLOCK_PERIOD_IN_PS \\
    -script $abc_script \\
    -liberty $LIBERTY_PATH \\
    -constr ${{OUTPUT_DIR}}/${{MODULE_NAME}}.stnod.abc.constr
dump_stage 05_abc

setundef -zero
splitnets
opt_clean -purge
dump_stage 06_clean

set TIEHI_CELL_AND_PORT "LOGIC1_X1 Z"
set TIELO_CELL_AND_PORT "LOGIC0_X1 Z"
hilomap -singleton \\
        -hicell {{*}}$TIEHI_CELL_AND_PORT \\
        -locell {{*}}$TIELO_CELL_AND_PORT

set MIN_BUF_CELL_AND_PORTS "BUF_X1 A Z"
insbuf -buf {{*}}$MIN_BUF_CELL_AND_PORTS
dump_stage 07_buffered
"""
