import math
import pickle
import subprocess
from pathlib import Path

import pytest

from revolution.qd.descriptors import (
    descriptor_requirements,
    extract_descriptor_values,
    resolve_descriptor_axes,
    resolve_grid_axis_specs,
)
from revolution.source_aligned_descriptor_evaluator import SourceAlignedRTLDescriptorEvaluator


def test_source_aligned_profile_resolves_without_ppa() -> None:
    axes = resolve_descriptor_axes(
        profile_name="source_aligned_masterrtl_rtltimer_cell_2d",
        explicit_axes=None,
        descriptor_file=None,
        archive_type="grid",
        circuit_type="sequential",
    )
    requirements = descriptor_requirements(axes)
    specs = resolve_grid_axis_specs(axes, num_cells=16, descriptor_file=None)

    assert axes == ["masterrtl_operator_log_edges", "rtltimer_state_timing_class"]
    assert requirements["requires_source_aligned_rtl"] is True
    assert requirements["requires_ppa"] is False
    assert requirements["requires_synthesis"] is False
    assert [(spec.bins, spec.lower_bound, spec.upper_bound) for spec in specs] == [
        (4, 4.0, 8.8),
        (4, 0.0, 4.0),
    ]


def test_source_aligned_evaluator_projects_t72_axes(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
) -> None:
    code_path = tmp_path / "demo.sv"
    code_path.write_text("module demo; endmodule\n", encoding="utf-8")
    (tmp_path / "exp/external_repos/MasterRTL/vlg2ir").mkdir(parents=True)
    (tmp_path / "exp/venvs/rtl_native_verify/bin").mkdir(parents=True)
    (tmp_path / "exp/venvs/rtl_native_verify/bin/python").write_text("", encoding="utf-8")
    rtltimer_lib = tmp_path / "exp/external_repos/RTL-Timer/vlg2bog/scr_ys/lib/nangate45_sog.lib"
    rtltimer_lib.parent.mkdir(parents=True)
    rtltimer_lib.write_text("", encoding="utf-8")
    evaluator = SourceAlignedRTLDescriptorEvaluator(repo_root=tmp_path)
    monkeypatch.setattr(
        evaluator,
        "_run_masterrtl",
        lambda code, top, out: {
            "masterrtl_graph_keys": 58,
            "masterrtl_graph_edges": 128,
            "masterrtl_node_dict": 160,
        },
    )
    monkeypatch.setattr(
        evaluator,
        "_run_rtltimer",
        lambda code, top, out: {
            "rtltimer_lines": 116,
            "rtltimer_assigns": 1,
            "rtltimer_wires": 15,
            "rtltimer_dff_refs": 0,
        },
    )

    metrics = evaluator.extract_metrics(code_file_path=code_path, top_module_name="demo")
    values = extract_descriptor_values(
        metrics,
        ["masterrtl_operator_log_edges", "rtltimer_state_timing_class"],
    )

    assert values["masterrtl_operator_log_edges"] == pytest.approx(math.log1p(128))
    assert values["rtltimer_state_timing_class"] == pytest.approx(0.0)
    assert metrics["source_aligned_rtltimer_dff_refs"] == pytest.approx(0.0)


def test_masterrtl_uses_candidate_local_parse_cwd(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
) -> None:
    code_path = tmp_path / "demo.sv"
    code_path.write_text("module demo; endmodule\n", encoding="utf-8")
    (tmp_path / "exp/external_repos/MasterRTL/vlg2ir").mkdir(parents=True)
    (tmp_path / "exp/venvs/rtl_native_verify/bin").mkdir(parents=True)
    (tmp_path / "exp/venvs/rtl_native_verify/bin/python").write_text("", encoding="utf-8")
    rtltimer_lib = tmp_path / "exp/external_repos/RTL-Timer/vlg2bog/scr_ys/lib/nangate45_sog.lib"
    rtltimer_lib.parent.mkdir(parents=True)
    rtltimer_lib.write_text("", encoding="utf-8")
    evaluator = SourceAlignedRTLDescriptorEvaluator(repo_root=tmp_path)
    output_dir = tmp_path / "out"
    calls = []

    def fake_run(args: list[str], *, cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
        calls.append((args, cwd))
        if args[0] == evaluator.yosys_path:
            (output_dir / "sog.v").write_text("module demo; endmodule\n", encoding="utf-8")
        else:
            parse_dir = output_dir / "parse"
            with (parse_dir / "demo_sog.pkl").open("wb") as handle:
                pickle.dump({0: [1, 2]}, handle)
            with (parse_dir / "demo_sog_node_dict.pkl").open("wb") as handle:
                pickle.dump({0: "demo"}, handle)
        return subprocess.CompletedProcess(args, 0, "", "")

    monkeypatch.setattr(evaluator, "_run", fake_run)

    metrics = evaluator._run_masterrtl(code_path, "demo", output_dir)

    assert calls[1][0][1] == str(evaluator.master_vlg2ir / "analyze.py")
    assert calls[1][1] == output_dir / "parse"
    assert metrics["masterrtl_graph_edges"] == 2
