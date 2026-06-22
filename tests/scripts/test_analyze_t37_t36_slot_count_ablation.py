from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = Path(__file__).resolve().parents[2] / "scripts" / "analyze_t37_t36_slot_count_ablation.py"
_SPEC = importlib.util.spec_from_file_location("analyze_t37_t36_slot_count_ablation", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("analyze_t37_t36_slot_count_ablation", mod)
_SPEC.loader.exec_module(mod)


def test_analyze_t37_writes_slot_count_artifacts(tmp_path: Path) -> None:
    candidates = tmp_path / "candidates.csv"
    graph_manifest = tmp_path / "graph_manifest.csv"
    hypergraph_features = tmp_path / "hypergraph_features.csv"
    package_dir = tmp_path / "package"
    _write_inputs(candidates, graph_manifest, hypergraph_features)

    code = mod.main(
        [
            "--candidates-csv",
            str(candidates),
            "--graph-manifest-csv",
            str(graph_manifest),
            "--hypergraph-features-csv",
            str(hypergraph_features),
            "--package-dir",
            str(package_dir),
            "--retention-fraction",
            "0.5",
            "--random-seed",
            "0",
            "--cell-bins",
            "2",
        ]
    )

    assert code == 0
    comparison = pd.read_csv(package_dir / "tables" / "archive_comparison.csv")
    assert "t37_top64_slot_2" in set(comparison["representation"])
    slot_summary = pd.read_csv(package_dir / "tables" / "slot_summary.csv")
    assert set(slot_summary["front_lane_slots"]) == {0, 1, 2}
    assert (package_dir / "figures" / "t37_multi_problem_ppa_pareto_fronts.png").read_bytes().startswith(
        b"\x89PNG"
    )
    viewer = package_dir / "visualizations" / "direct_ppa_pareto"
    assert (viewer / "index.html").is_file()
    assert "T37 Direct Raw PPA Pareto Front" in (viewer / "index.html").read_text(encoding="utf-8")


def _write_inputs(candidates: Path, graph_manifest: Path, hypergraph_features: Path) -> None:
    candidate_rows = []
    graph_rows = []
    hyper_rows = []
    ref = json.dumps({"area": 120.0, "power": 12.0, "eff_clk_period": 6.0})
    sample_index = 0
    for problem in [f"toy/Prob{index:03d}" for index in range(12)]:
        for generation in range(4):
            candidate_rows.append(_candidate_row(sample_index, problem, generation, ref))
            graph_rows.append(_graph_row(sample_index, problem))
            hyper_rows.append(_hyper_row(sample_index, problem))
            sample_index += 1
    pd.DataFrame(candidate_rows).to_csv(candidates, index=False)
    pd.DataFrame(graph_rows).to_csv(graph_manifest, index=False)
    pd.DataFrame(hyper_rows).to_csv(hypergraph_features, index=False)


def _candidate_row(index: int, problem: str, generation: int, ref: str) -> dict[str, object]:
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
        "valid_ppa": True,
        "area": 120.0 - index,
        "power": 10.0 - index * 0.15,
        "eff_clk_period": 5.0 - index * 0.03,
        "fitness": float(index),
        "reference_ppa_json": ref,
        "canonical_netlist_hash": f"net-{index % 5}",
        "motif_signature_hash": f"motif-{index % 6}",
    }
    for feature in mod.t11.t13.RTL_FEATURES:
        row[feature] = float(index % 7 + 1)
    return row


def _graph_row(index: int, problem: str) -> dict[str, object]:
    row = {
        "sample_index": index,
        "candidate_id": f"cand-{index}",
        "corpus": "toy",
        "problem_id": problem,
        "netlist_path": f"/tmp/cand-{index}.v",
        "parse_status": "parsed",
        "node_count": 10 + index,
        "edge_count": 20 + index,
        "net_count": 15 + index,
        "max_level": index % 5,
        "unresolved_cycle_nodes": index % 3,
    }
    for feature in mod.t11.t13.GRAPH_FEATURES[5:]:
        row[feature] = index % 4
    return row


def _hyper_row(index: int, problem: str) -> dict[str, object]:
    return {
        "sample_index": index,
        "candidate_id": f"cand-{index}",
        "corpus": "toy",
        "problem_id": problem,
        "netlist_path": f"/tmp/cand-{index}.v",
        "parse_status": "parsed",
        "cell_count": 10 + index,
        "net_count": 12 + index,
        "directed_edge_count": 20 + index,
        "driven_net_count": 6 + index,
        "sink_net_count": 7 + index,
        "multi_driver_net_count": index % 2,
        "max_fanout": 2 + index % 4,
        "mean_fanout": 1.0 + index % 3,
        "fanout_entropy": 0.2 + index * 0.01,
        "long_range_edge_share": 0.1 + index * 0.002,
        "max_level_delta": index % 5,
        "max_level": index % 6,
        "unresolved_cycle_nodes": index % 3,
    }
