from __future__ import annotations

import math
import pickle
import re
import shlex
import subprocess
import sys
import tempfile
from pathlib import Path


_MODULE_RE = re.compile(r"\bmodule\s+([A-Za-z_][A-Za-z0-9_$]*)\b")


class SourceAlignedRTLDescriptorEvaluator:
    """Extract T70/T71 source-aligned MasterRTL and RTL-Timer descriptors."""

    def __init__(
        self,
        *,
        repo_root: Path | None = None,
        yosys_path: str = "yosys",
        timeout_seconds: int = 60,
    ) -> None:
        root = repo_root or Path(__file__).resolve().parents[2]
        self.yosys_path = yosys_path
        self.timeout_seconds = max(1, int(timeout_seconds))
        self.master_vlg2ir = root / "exp/external_repos/MasterRTL/vlg2ir"
        self.master_python = root / "exp/venvs/rtl_native_verify/bin/python"
        self.rtltimer_lib = (
            root / "exp/external_repos/RTL-Timer/vlg2bog/scr_ys/lib/nangate45_sog.lib"
        )

    def extract_metrics(
        self,
        *,
        code_file_path: str | Path,
        top_module_name: str | None,
    ) -> dict[str, float]:
        """Run the verified T70 extractor flows and return RTL-native metrics."""

        code_path = Path(code_file_path)
        assert code_path.is_file(), f"missing RTL file: {code_path}"
        assert self.master_python.is_file(), f"missing MasterRTL python: {self.master_python}"
        assert self.master_vlg2ir.is_dir(), f"missing MasterRTL vlg2ir: {self.master_vlg2ir}"
        assert self.rtltimer_lib.is_file(), f"missing RTL-Timer library: {self.rtltimer_lib}"
        top = top_module_name or _infer_top(code_path)

        with tempfile.TemporaryDirectory(prefix="source_aligned_rtl_") as tmp:
            tmp_dir = Path(tmp)
            master = self._run_masterrtl(code_path, top, tmp_dir / "masterrtl")
            rtltimer = self._run_rtltimer(code_path, top, tmp_dir / "rtltimer")

        graph_keys = int(master["masterrtl_graph_keys"])
        graph_edges = int(master["masterrtl_graph_edges"])
        lines = int(rtltimer["rtltimer_lines"])
        wires = int(rtltimer["rtltimer_wires"])
        dff_refs = int(rtltimer["rtltimer_dff_refs"])
        assert graph_keys > 0
        assert lines > 0
        return {
            "masterrtl_operator_log_edges": math.log1p(graph_edges),
            "rtltimer_state_timing_class": float(_state_timing_class(dff_refs)),
            "source_aligned_masterrtl_graph_keys": float(graph_keys),
            "source_aligned_masterrtl_graph_edges": float(graph_edges),
            "source_aligned_masterrtl_node_dict": float(master["masterrtl_node_dict"]),
            "source_aligned_masterrtl_branching": graph_edges / graph_keys,
            "source_aligned_rtltimer_lines": float(lines),
            "source_aligned_rtltimer_assigns": float(rtltimer["rtltimer_assigns"]),
            "source_aligned_rtltimer_wires": float(wires),
            "source_aligned_rtltimer_dff_refs": float(dff_refs),
            "source_aligned_rtltimer_wire_density": wires / lines,
            "source_aligned_rtltimer_dff_density": dff_refs / lines,
        }

    def _run_masterrtl(
        self,
        code_path: Path,
        top: str,
        output_dir: Path,
    ) -> dict[str, int]:
        output_dir.mkdir(parents=True)
        raw_path = output_dir / "sog.v"
        clean_path = output_dir / "sog.clean.v"
        parse_dir = output_dir / "parse"
        parse_dir.mkdir()
        if str(self.master_vlg2ir) not in sys.path:
            sys.path.insert(0, str(self.master_vlg2ir))
        script = (
            f"read_verilog -sv {shlex.quote(str(code_path))}; "
            f"hierarchy -check -top {shlex.quote(top)}; "
            "proc; flatten; opt; fsm; opt; memory; opt; techmap; opt; "
            f"write_verilog {shlex.quote(str(raw_path))}"
        )
        self._run([self.yosys_path, "-q", "-p", script])
        _clean_generated_attrs(raw_path, clean_path)
        name = code_path.stem
        self._run(
            [
                str(self.master_python),
                str(self.master_vlg2ir / "analyze.py"),
                str(clean_path),
                "-N",
                name,
                "-C",
                "sog",
                "-O",
                f"{parse_dir}/",
            ],
            cwd=parse_dir,
        )
        graph_path = parse_dir / f"{name}_sog.pkl"
        node_path = parse_dir / f"{name}_sog_node_dict.pkl"
        with graph_path.open("rb") as handle:
            graph = pickle.load(handle)
        with node_path.open("rb") as handle:
            node_dict = pickle.load(handle)
        return {
            "masterrtl_graph_keys": len(graph),
            "masterrtl_graph_edges": sum(len(edges) for edges in graph.values()),
            "masterrtl_node_dict": len(node_dict),
        }

    def _run_rtltimer(
        self,
        code_path: Path,
        top: str,
        output_dir: Path,
    ) -> dict[str, int]:
        output_dir.mkdir(parents=True)
        raw_path = output_dir / "sog.v"
        clean_path = output_dir / "sog.clean.v"
        script = (
            f"read_verilog -sv {shlex.quote(str(code_path))}; "
            f"hierarchy -top {shlex.quote(top)}; "
            "proc; opt -fast; fsm; opt -fast; memory; opt -fast; "
            "techmap; opt -fast; rename -wire t:$*DFF*; "
            f"dfflibmap -liberty {shlex.quote(str(self.rtltimer_lib))}; "
            f"abc -liberty {shlex.quote(str(self.rtltimer_lib))}; clean; "
            f"write_verilog {shlex.quote(str(raw_path))}"
        )
        self._run([self.yosys_path, "-q", "-p", script])
        _clean_rtltimer(raw_path, clean_path)
        self._run(
            [
                self.yosys_path,
                "-q",
                "-p",
                f"read_verilog {shlex.quote(str(clean_path))}; hierarchy -top {shlex.quote(top)}; stat",
            ]
        )
        return _verilog_counts(clean_path)

    def _run(
        self,
        args: list[str],
        *,
        cwd: Path | None = None,
    ) -> subprocess.CompletedProcess[str]:
        result = subprocess.run(
            args,
            cwd=cwd,
            text=True,
            capture_output=True,
            check=False,
            timeout=self.timeout_seconds,
        )
        assert result.returncode == 0, result.stderr[-2000:]
        return result


def _infer_top(path: Path) -> str:
    match = _MODULE_RE.search(path.read_text(encoding="utf-8", errors="ignore"))
    assert match is not None, f"could not infer top module from {path}"
    return match.group(1)


def _clean_generated_attrs(source: Path, target: Path) -> None:
    text = source.read_text(encoding="utf-8")
    target.write_text(re.sub(r"\(\*.*?\*\)", "", text, flags=re.S), encoding="utf-8")


def _clean_rtltimer(source: Path, target: Path) -> None:
    cleaned = []
    for line in source.read_text(encoding="utf-8").splitlines():
        line = re.sub(r"\(\*.*\*\)", "", line)
        line = re.sub(r"/\*.*", "", line)
        if line.strip():
            cleaned.append(line)
    target.write_text("\n".join(cleaned) + "\n", encoding="utf-8")


def _verilog_counts(path: Path) -> dict[str, int]:
    lines = path.read_text(encoding="utf-8").splitlines()
    return {
        "rtltimer_lines": len(lines),
        "rtltimer_assigns": _count_lines(lines, r"^\s*assign\b"),
        "rtltimer_wires": _count_lines(lines, r"^\s*wire\b"),
        "rtltimer_dff_refs": _count_lines(lines, r"\$dff|DFF|_DFF"),
    }


def _count_lines(lines: list[str], pattern: str) -> int:
    regex = re.compile(pattern)
    return sum(1 for line in lines if regex.search(line))


def _state_timing_class(dff_refs: int) -> int:
    if dff_refs == 0:
        return 0
    if dff_refs <= 7:
        return 1
    if dff_refs <= 20:
        return 2
    return 3
