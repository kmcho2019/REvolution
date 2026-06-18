import math
from pathlib import Path

import pytest

from revolution.auto_bd.trajectory_descriptor import (
    synthesis_trajectory_descriptor_values,
)


def test_synthesis_trajectory_descriptor_tracks_stage_swings(tmp_path: Path):
    read_stage = tmp_path / "00_read.v"
    synth_stage = tmp_path / "01_synth.v"
    final_stage = tmp_path / "07_buffered.v"
    read_stage.write_text(
        "module top(input a, output y);\n"
        "  INV_X1 u0 (.A(a), .ZN(y));\n"
        "endmodule\n",
        encoding="utf-8",
    )
    synth_stage.write_text(
        "module top(input a, input b, input s, output y);\n"
        "  INV_X1 u0 (.A(a), .ZN(n1));\n"
        "  MUX2_X1 u1 (.A(n1), .B(b), .S(s), .Z(y));\n"
        "endmodule\n",
        encoding="utf-8",
    )
    final_stage.write_text(
        "module top(input a, input b, output y);\n"
        "  ADD_X1 u0 (.A(a), .B(b), .SUM(n1));\n"
        "  INV_X1 u1 (.A(n1), .ZN(y));\n"
        "endmodule\n",
        encoding="utf-8",
    )

    values = synthesis_trajectory_descriptor_values(
        (read_stage, synth_stage, final_stage)
    )

    assert values["stnod_cell_growth_log"] == pytest.approx(
        math.log1p(2) - math.log1p(1)
    )
    assert values["stnod_logic_swing"] == pytest.approx(0.5)
    assert values["stnod_control_swing"] == pytest.approx(0.5)
    assert values["stnod_arith_swing"] == pytest.approx(0.5)
    assert values["stnod_diversity_swing"] == pytest.approx(1.0)


def test_synthesis_trajectory_descriptor_requires_stage_paths():
    with pytest.raises(AssertionError):
        synthesis_trajectory_descriptor_values(())
