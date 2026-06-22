from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = Path(__file__).resolve().parents[2] / "scripts" / "analyze_t14_dehnn_hypergraph.py"
_SPEC = importlib.util.spec_from_file_location("analyze_t14_dehnn_hypergraph", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("analyze_t14_dehnn_hypergraph", mod)
_SPEC.loader.exec_module(mod)


def test_analyze_t14_writes_hypergraph_replay_artifacts(tmp_path: Path) -> None:
    candidates = tmp_path / "candidates.csv"
    graph_manifest = tmp_path / "graph_manifest.csv"
    package_dir = tmp_path / "package"
    _write_inputs(candidates, graph_manifest, tmp_path)

    code = mod.main(
        [
            "--candidates-csv",
            str(candidates),
            "--graph-manifest-csv",
            str(graph_manifest),
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
    hyper = pd.read_csv(package_dir / "tables" / "hypergraph_features.csv")
    assert "t14_hyper_combo_farthest" in set(comparison["representation"])
    assert int(hyper["cell_count"].sum()) > 0
    assert (package_dir / "tables" / "ppa_front_plot_points.csv").is_file()
    assert (package_dir / "figures" / "dehnn_hypervolume.png").read_bytes().startswith(b"\x89PNG")
    assert (package_dir / "figures" / "hypergraph_multi_problem_ppa_pareto_fronts.png").read_bytes().startswith(
        b"\x89PNG"
    )


def _write_inputs(candidates: Path, graph_manifest: Path, root: Path) -> None:
    candidate_rows = []
    graph_rows = []
    ref = json.dumps({"area": 120.0, "power": 12.0, "eff_clk_period": 6.0})
    sample_index = 0
    for problem in _problem_ids():
        for generation in range(4):
            netlist = root / f"cand_{sample_index}.syn.v"
            _write_netlist(netlist, sample_index)
            candidate_rows.append(_candidate_row(sample_index, problem, generation, ref, netlist))
            graph_rows.append(_graph_row(sample_index, problem, netlist))
            sample_index += 1
    pd.DataFrame(candidate_rows).to_csv(candidates, index=False)
    pd.DataFrame(graph_rows).to_csv(graph_manifest, index=False)


def _problem_ids() -> list[str]:
    problems = []
    index = 0
    while len(problems) < 12:
        problems.append(f"toy/Prob{index:03d}")
        index += 1
    return problems


def _candidate_row(index: int, problem: str, generation: int, ref: str, netlist: Path) -> dict[str, object]:
    row = {
        "corpus": "toy",
        "method": "classic",
        "seed": 1,
        "model": "toy",
        "benchmark": "RTLLM",
        "problem_id": problem,
        "generation": generation,
        "candidate_id": f"cand-{index}",
        "sample_index": index,
        "netlist_path": netlist.as_posix(),
        "valid_ppa": True,
        "area": 120.0 - index,
        "power": 10.0 - index * 0.2,
        "eff_clk_period": 5.0 - index * 0.05,
        "fitness": float(index),
        "reference_ppa_json": ref,
        "canonical_netlist_hash": f"net-{index % 5}",
        "motif_signature_hash": f"motif-{index % 6}",
    }
    for feature in mod.t13.RTL_FEATURES:
        row[feature] = float(index % 7 + 1)
    return row


def _graph_row(index: int, problem: str, netlist: Path) -> dict[str, object]:
    row = {
        "sample_index": index,
        "candidate_id": f"cand-{index}",
        "corpus": "toy",
        "problem_id": problem,
        "netlist_path": netlist.as_posix(),
        "parse_status": "parsed",
        "node_count": 10 + index,
        "edge_count": 20 + index,
        "net_count": 15 + index,
        "max_level": index % 5,
        "unresolved_cycle_nodes": index % 3,
    }
    for feature in mod.t13.GRAPH_FEATURES[5:]:
        row[feature] = index % 4
    return row


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
