from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "package_useful_bd_validation_matrix.py"
)
_SPEC = importlib.util.spec_from_file_location("package_useful_bd_validation_matrix", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("package_useful_bd_validation_matrix", mod)
_SPEC.loader.exec_module(mod)


def test_validation_matrix_compares_leads_to_controls(tmp_path: Path) -> None:
    central_path = tmp_path / "central.json"
    aggregate_path = tmp_path / "aggregate.csv"
    output_dir = tmp_path / "package"
    central_path.write_text(json.dumps(_central_report()), encoding="utf-8")
    pd.DataFrame(_aggregate_rows()).to_csv(aggregate_path, index=False)

    code = mod.main(
        [
            "--central-json",
            str(central_path),
            "--mome-aggregate",
            str(aggregate_path),
            "--output-dir",
            str(output_dir),
        ]
    )

    assert code == 0
    matrix = pd.read_csv(output_dir / "tables" / "validation_matrix.csv")
    assert matrix["method_name"].tolist() == list(mod.FOCUS_METHODS)
    sr_rff = matrix.loc[matrix["method_name"].eq("sr_rff_pca_qd")].iloc[0]
    assert sr_rff["tier_read"] == "T1_near_classic_candidate"
    assert sr_rff["local_ppa_front_unique_netlist_count"] == 14

    deltas = pd.read_csv(output_dir / "tables" / "comparison_deltas.csv")
    relu_vs_random = deltas.loc[
        deltas["method_name"].eq("sr_random_relu_pca_qd")
        & deltas["reference_method"].eq("random_descriptor_qd")
        & deltas["metric"].eq("final_mean_hypervolume")
    ].iloc[0]
    assert relu_vs_random["delta"] > 0.0
    assert (output_dir / "figures" / "validation_hv_summary.png").read_bytes().startswith(
        b"\x89PNG"
    )


def _central_report() -> dict[str, object]:
    methods = {
        "classic_revolution": (0.12, 0.20, 0.07, 0.18, 200, 12, 12, 2.0),
        "landing_smooth_qd_manual_bd": (0.10, 0.16, 0.06, 0.15, 205, 18, 9, 1.5),
        "random_descriptor_qd": (0.11, 0.19, 0.09, 0.20, 210, 21, 8, 1.4),
        "sr_random_relu_pca_qd": (0.14, 0.18, 0.12, 0.21, 198, 11, 10, 2.1),
        "sr_rff_pca_qd": (0.121, 0.198, 0.08, 0.19, 197, 20, 10, 2.7),
    }
    return {
        "leaderboard": [
            {
                "method_name": name,
                "mean_hypervolume": values[0],
                "mean_best_fitness": values[1],
                "valid_ppa_candidate_count": values[4],
                "ppa_front_unique_netlist_count": values[5],
                "common_audit_occupied_cells": values[6],
                "common_audit_qd_score": values[7],
            }
            for name, values in methods.items()
        ],
        "anytime_summary": [
            {
                "method_name": name,
                "auc_mean_hypervolume": values[2],
                "auc_mean_best_fitness": values[3],
            }
            for name, values in methods.items()
        ],
    }


def _aggregate_rows() -> list[dict[str, object]]:
    rows = []
    values = {
        "classic_revolution": (12, 30, 6, 17, 6, 10, 7, 7, 0.12),
        "landing_smooth_qd_manual_bd": (9, 24, 7, 18, 7, 11, 8, 9, 0.10),
        "random_descriptor_qd": (8, 21, 6, 18, 6, 13, 7, 7, 0.11),
        "sr_random_relu_pca_qd": (10, 26, 6, 17, 6, 11, 7, 9, 0.14),
        "sr_rff_pca_qd": (10, 23, 6, 19, 6, 14, 7, 9, 0.121),
    }
    for method, data in values.items():
        scalar_retained, local_retained, scalar_pareto, local_pareto = data[:4]
        scalar_front, local_front, scalar_grid, local_grid, hv = data[4:]
        rows.append(_aggregate_row(method, "scalar_cell_elite", scalar_retained, scalar_pareto, scalar_front, scalar_grid, hv))
        rows.append(_aggregate_row(method, "bounded_local_pareto", local_retained, local_pareto, local_front, local_grid, hv))
    return rows


def _aggregate_row(
    method: str,
    mode: str,
    retained: int,
    pareto: int,
    front: int,
    grid: int,
    hv: float,
) -> dict[str, object]:
    return {
        "method_name": method,
        "retention_mode": mode,
        "retained_candidate_count": retained,
        "global_pareto_point_count": pareto,
        "ppa_front_unique_netlist_count": front,
        "ppa_grid_occupied_cells": grid,
        "mean_hypervolume": hv,
        "unique_canonical_netlist_count": retained,
        "unique_motif_signature_count": retained,
    }
