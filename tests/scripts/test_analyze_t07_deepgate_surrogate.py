from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = Path(__file__).resolve().parents[2] / "scripts" / "analyze_t07_deepgate_surrogate.py"
_SPEC = importlib.util.spec_from_file_location("analyze_t07_deepgate_surrogate", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("analyze_t07_deepgate_surrogate", mod)
_SPEC.loader.exec_module(mod)


def test_analyze_t07_writes_graph_replay_artifacts(tmp_path: Path) -> None:
    candidates = tmp_path / "candidates.csv"
    package_dir = tmp_path / "package"
    _write_candidates(candidates, tmp_path)

    code = mod.main(
        [
            "--candidates-csv",
            str(candidates),
            "--package-dir",
            str(package_dir),
            "--retention-fraction",
            "0.5",
            "--random-seed",
            "0",
        ]
    )

    assert code == 0
    comparison = pd.read_csv(package_dir / "tables" / "ppa_comparison.csv")
    manifest = pd.read_csv(package_dir / "tables" / "netlist_graph_manifest.csv")
    assert "t07_graph_wl_farthest" in set(comparison["representation"])
    assert int(manifest["node_count"].sum()) > 0
    assert (package_dir / "tables" / "ppa_front_plot_points.csv").is_file()
    assert (package_dir / "figures" / "deepgate_surrogate_hypervolume.png").read_bytes().startswith(b"\x89PNG")
    assert (package_dir / "figures" / "deepgate_raw_area_power_pareto_front.png").read_bytes().startswith(b"\x89PNG")
    assert (package_dir / "figures" / "deepgate_multi_problem_ppa_pareto_fronts.png").read_bytes().startswith(b"\x89PNG")


def _write_candidates(path: Path, root: Path) -> None:
    ref = json.dumps({"area": 120.0, "power": 12.0, "eff_clk_period": 6.0})
    rows = []
    for index in range(8):
        netlist = root / f"cand_{index}.syn.v"
        _write_netlist(netlist, index)
        rows.append(
            {
                "corpus": "toy",
                "method": "classic",
                "seed": 1,
                "model": "toy",
                "benchmark": "RTLLM",
                "problem_id": "toy/problem",
                "generation": index,
                "candidate_id": f"cand-{index}",
                "sample_index": index,
                "netlist_path": netlist.as_posix(),
                "valid_ppa": True,
                "area": 120.0 - index,
                "power": 10.0 - index * 0.2,
                "eff_clk_period": 5.0 - index * 0.05,
                "fitness": float(index),
                "reference_ppa_json": ref,
                "canonical_netlist_hash": f"net-{index % 3}",
                "motif_signature_hash": f"motif-{index % 4}",
                "rtl_line_count": 10 + index,
                "rtl_assign_count": 1 + index % 3,
                "rtl_always_count": index % 2,
                "rtl_case_count": 0,
                "rtl_if_count": index % 4,
                "rtl_ternary_count": 0,
                "rtl_nonblocking_count": 0,
                "rtl_blocking_count": 0,
                "rtl_add_count": index % 5,
                "rtl_mul_count": 0,
                "rtl_wire_count": 1,
                "rtl_reg_count": 0,
                "rtl_comment_count": 0,
            }
        )
    pd.DataFrame(rows).to_csv(path, index=False)


def _write_netlist(path: Path, index: int) -> None:
    extra = "\n  XOR2_X1 u3 (.A(_1_), .B(b), .Z(_2_));" if index % 2 else ""
    path.write_text(
        f"""
module toy(input a, input b, output y);
  wire _0_;
  wire _1_;
  wire _2_;
  NAND2_X1 u0 (.A1(a), .A2(b), .ZN(_0_));
  INV_X1 u1 (.A(_0_), .ZN(_1_));{extra}
  BUF_X1 u2 (.A(_1_), .Z(y));
endmodule
""",
        encoding="utf-8",
    )
