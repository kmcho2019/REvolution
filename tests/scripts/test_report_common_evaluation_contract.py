from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.report_common_evaluation_contract import main


def test_common_evaluation_contract_reports_passive_archive_gaps(tmp_path: Path) -> None:
    viewer_root = tmp_path / "viewer"
    dataset_dir = viewer_root / "datasets"
    dataset_dir.mkdir(parents=True)
    completeness = tmp_path / "ppa_completeness.csv"
    pareto_metrics = tmp_path / "backend_problem_metrics.csv"
    output_dir = tmp_path / "tables"

    (dataset_dir / "RTLLM__Prob001.json").write_text(
        json.dumps(_dataset(), indent=2) + "\n",
        encoding="utf-8",
    )
    _write_csv(
        completeness,
        [
            {
                "benchmark": "RTLLM",
                "problem": "Prob001",
                "classic_valid_ppa": "yes",
                "qd_valid_ppa": "yes",
                "reference_ppa_valid": "yes",
                "comparison_status": "headline",
                "classic_valid_ppa_count": "1",
                "qd_valid_ppa_count": "3",
                "valid_ppa_yield_status": "small_n",
                "reference_missing_reason": "",
            }
        ],
    )
    _write_csv(
        pareto_metrics,
        [
            _pareto_row("classic_revolution_8x5", 0.55, 1, 1),
            _pareto_row("qd_method", 0.35, 1, 2),
        ],
    )

    assert (
        main(
            [
                "--viewer-root",
                str(viewer_root),
                "--ppa-completeness",
                str(completeness),
                "--seed",
                "1001",
                "--budget-shape",
                "8x5",
                "--pareto-problem-metrics",
                str(pareto_metrics),
                "--method-family",
                "classic_revolution_8x5=classic",
                "--method-family",
                "qd_method=encoder",
                "--output-dir",
                str(output_dir),
            ]
        )
        == 0
    )

    rows = _read_csv(output_dir / "method_problem_seed_metrics.csv")
    by_method = {row["method_key"]: row for row in rows}
    assert by_method["qd_method"]["global_ppa_hv"] == "0.35"
    assert by_method["qd_method"]["hv_auc"] == "0.3"
    assert by_method["qd_method"]["valid_ppa_count"] == "3"
    assert by_method["qd_method"]["pareto_point_count"] == "1"
    assert by_method["qd_method"]["reference_beating_count"] == "2"
    assert by_method["qd_method"]["passive_archive_coverage"] == "0.5"
    assert by_method["classic_revolution_8x5"]["passive_archive_coverage"] == "not_available"
    assert by_method["classic_revolution_8x5"]["notes"] == "descriptor_projection_missing"

    passive_rows = _read_csv(output_dir / "passive_archive_metrics.csv")
    passive_by_method = {row["method_key"]: row for row in passive_rows}
    assert passive_by_method["qd_method"]["occupied_cell_count"] == "2"
    assert passive_by_method["qd_method"]["passive_archive_qd_score"] == "1"
    assert passive_by_method["qd_method"]["passive_archive_qd_auc"] == "0.65"
    assert passive_by_method["qd_method"]["passive_archive_coverage_auc"] == "0.375"
    assert passive_by_method["qd_method"]["pareto_cell_count"] == "2"
    assert passive_by_method["qd_method"]["unique_front_family_count"] == "not_available"
    assert passive_by_method["qd_method"]["notes"] == "candidate_level_no_canonical_dedup"

    summary_rows = _read_csv(output_dir / "method_seed_summary.csv")
    summary_by_method = {row["method_key"]: row for row in summary_rows}
    assert summary_by_method["classic_revolution_8x5"]["mean_global_ppa_hv"] == "0.55"
    assert summary_by_method["classic_revolution_8x5"]["classic_delta_mean_hv"] == "0"
    assert summary_by_method["qd_method"]["headline_problem_count"] == "1"
    assert summary_by_method["qd_method"]["mean_global_ppa_hv"] == "0.35"
    assert summary_by_method["qd_method"]["classic_delta_mean_hv"] == "-0.2"
    assert summary_by_method["qd_method"]["classic_hv_loss_count"] == "1"
    assert summary_by_method["qd_method"]["mean_passive_archive_qd_auc"] == "0.65"
    assert summary_by_method["qd_method"]["notes"] == "candidate_level_no_canonical_dedup"

    config = json.loads((output_dir / "passive_archive_config.json").read_text())
    assert config["scope"] == "per_problem_phase_03_1_viewer_archive"
    assert config["problem_archives"][0]["cell_count"] == 4
    assert (output_dir / "ppa_completeness.csv").read_text() == completeness.read_text()


def _dataset() -> dict[str, object]:
    return {
        "benchmark": "RTLLM",
        "problem": "Prob001",
        "objective_keys": ["g_P", "g_A"],
        "archive_definition": {
            "descriptor_profile": "test_descriptor",
            "effective_shape": [2, 2],
            "num_cells": 4,
            "axes": [
                {"name": "x", "effective_bins": 2},
                {"name": "y", "effective_bins": 2},
            ],
        },
        "techniques": {
            "classic_revolution_8x5": {"label": "classic_revolution_8x5"},
            "qd_method": {"label": "qd_method"},
        },
        "technique_stats_by_step": {
            "0": {
                "classic_revolution_8x5": _stats(0.3, 1, 1),
                "qd_method": _stats(0.2, 1, 1),
            },
            "1": {
                "classic_revolution_8x5": _stats(0.5, 1, 1),
                "qd_method": _stats(0.4, 2, 3),
            },
            "final": {
                "classic_revolution_8x5": _stats(0.5, 1, 1),
                "qd_method": _stats(0.4, 2, 3),
            },
        },
        "samples": [
            _sample("classic_revolution_8x5", "c0", 0, "", 0.5, 1, 0.2, 0.2),
            _sample("qd_method", "q0", 0, "0,0", 0.3, 1, 0.1, 0.2),
            _sample("qd_method", "q1", 1, "0,1", 0.7, 1, 0.3, 0.1),
            _sample("qd_method", "q2", 1, "0,1", 0.4, 2, 0.2, 0.2),
        ],
    }


def _stats(hv: float, rank1_count: int, sample_count: int) -> dict[str, object]:
    return {
        "hypervolume": {"value": hv},
        "rank1_count": rank1_count,
        "sample_count": sample_count,
    }


def _pareto_row(
    method: str,
    hv: float,
    pareto_count: int,
    ref_beating: int,
) -> dict[str, str]:
    return {
        "backend": method,
        "benchmark": "RTLLM",
        "problem": "Prob001",
        "candidate_count": "3",
        "pareto_point_count": str(pareto_count),
        "hypervolume": str(hv),
        "reference_beating_count": str(ref_beating),
    }


def _sample(
    method: str,
    candidate_id: str,
    generation: int,
    cell_id: str,
    quality: float,
    rank: int,
    g_p: float,
    g_a: float,
) -> dict[str, object]:
    return {
        "technique": method,
        "candidate_id": candidate_id,
        "generation": generation,
        "final_fixed_archive_cell_id": cell_id,
        "quality_score": quality,
        "pareto_rank_final": rank,
        "viewer_pooled_pareto_member": rank == 1,
        "descriptor_values": {"x": g_p, "y": g_a},
        "g_P": g_p,
        "g_A": g_a,
    }


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def _read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))
