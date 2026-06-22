from __future__ import annotations

import csv
import importlib.util
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "generate_t33_qwen_preprocessing_views.py"
)
_SPEC = importlib.util.spec_from_file_location("generate_t33_qwen_preprocessing_views", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("generate_t33_qwen_preprocessing_views", mod)
_SPEC.loader.exec_module(mod)


def test_generate_t33_views_writes_cache_and_manifests(tmp_path: Path) -> None:
    rtl = tmp_path / "candidate.sv"
    netlist = tmp_path / "candidate.syn.v"
    rtl.write_text(
        "module top(input clk, input a, output y); // note\n"
        "wire tmp; assign tmp = a; assign y = tmp & 4'b0011; endmodule\n",
        encoding="utf-8",
    )
    netlist.write_text(
        "module top(input a, output y); (* src = \"x\" *) assign y = a; endmodule\n",
        encoding="utf-8",
    )
    candidates = tmp_path / "candidates.csv"
    _write_candidates(candidates, rtl, netlist)
    output_root = tmp_path / "run"
    package_dir = tmp_path / "package"

    code = mod.main(
        [
            "--candidates-csv",
            str(candidates),
            "--output-root",
            str(output_root),
            "--package-dir",
            str(package_dir),
        ]
    )

    assert code == 0
    manifest = _read_csv(package_dir / "tables" / "t33_preprocessing_view_manifest.csv")
    summary = _read_csv(package_dir / "tables" / "t33_preprocessing_view_summary.csv")
    cache = _read_csv(package_dir / "tables" / "t33_preprocessing_cache_manifest.csv")
    identifier_text = next(
        Path(row["output_path"]).read_text(encoding="utf-8")
        for row in manifest
        if row["view"] == "identifier_role_rtl"
    )

    assert len(manifest) == 6
    assert len(summary) == 6
    assert cache[0]["candidate_count"] == "1"
    assert "note" not in identifier_text
    assert "input_0000" in identifier_text
    assert "output_0000" in identifier_text
    assert "4'b0011" in identifier_text


def _write_candidates(path: Path, rtl: Path, netlist: Path) -> None:
    row = {
        "sample_index": "0",
        "candidate_id": "cand-0",
        "rtl_path": rtl.as_posix(),
        "netlist_path": netlist.as_posix(),
        "rtl_line_count": "2",
        "rtl_assign_count": "2",
        "rtl_always_count": "0",
        "rtl_case_count": "0",
        "rtl_if_count": "0",
        "rtl_ternary_count": "0",
        "rtl_nonblocking_count": "0",
        "rtl_blocking_count": "0",
        "rtl_add_count": "0",
        "rtl_mul_count": "0",
        "rtl_wire_count": "1",
        "rtl_reg_count": "0",
        "style_cluster": "assign_only",
    }
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(row), lineterminator="\n")
        writer.writeheader()
        writer.writerow(row)


def _read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))
