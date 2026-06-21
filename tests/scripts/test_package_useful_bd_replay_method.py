from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "package_useful_bd_replay_method.py"
)
_SPEC = importlib.util.spec_from_file_location("package_useful_bd_replay_method", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("package_useful_bd_replay_method", mod)
_SPEC.loader.exec_module(mod)


def test_build_package_writes_small_n_gate_and_figures(tmp_path: Path) -> None:
    report = _report()
    package = mod.build_package(report, "motif")

    gate = {row["stage"]: row for row in package["validity_gate"]}
    assert gate["functionality"]["gate_enforced"] is True
    assert gate["functionality"]["collapse_50pct"] is False
    assert gate["synthesis"]["small_n_validity"] is True

    report_path = tmp_path / "central.json"
    report_path.write_text(json.dumps(report), encoding="utf-8")
    technique_dir = tmp_path / "technique"

    code = mod.main(
        [
            "--central-json",
            str(report_path),
            "--method-name",
            "motif",
            "--technique-dir",
            str(technique_dir),
        ]
    )

    assert code == 0
    assert (technique_dir / "tables" / "metric_deltas_vs_classic.csv").is_file()
    assert (technique_dir / "tables" / "validity_gate.csv").is_file()
    assert (technique_dir / "figures" / "seed1_mean_hypervolume.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (technique_dir / "figures" / "duplicate_accounting.png").read_bytes().startswith(
        b"\x89PNG"
    )


def _report() -> dict[str, object]:
    methods = ["classic_revolution", "landing_smooth_qd_manual_bd", "motif"]
    return {
        "leaderboard": [_leaderboard(method) for method in methods],
        "robustness_funnel": [_robustness(method) for method in methods],
        "qd_summary": [_qd_summary(method) for method in methods],
        "gate_matrix": [_gate(method) for method in methods],
        "comparison_matrix": [
            {
                "method_name": "motif",
                "problem_id": "Bench/ProbA",
                "fitness_delta": 0.01,
                "fitness_outcome": "T",
                "hypervolume_delta": 0.02,
                "hypervolume_outcome": "W",
            }
        ],
        "problem_metrics": [_problem(method) for method in methods],
        "descriptor_correlations": [
            {
                "method_name": "motif",
                "descriptor_space": "internal",
                "descriptor_axis": "motif_entropy",
                "metric": "area",
                "pearson_r": 0.1,
                "sample_count": 12,
            }
        ],
        "anytime_metrics": [
            {
                "method_name": method,
                "generation": generation,
                "covered_problems": 1,
                "valid_ppa_candidate_count": 4 + generation,
                "mean_best_fitness": 0.1 + generation / 10,
                "mean_hypervolume": 0.2 + generation / 10,
            }
            for method in methods
            for generation in (0, 1)
        ],
        "archive_metrics": [
            {
                "method_name": method,
                "problem_id": "Bench/ProbA",
                "common_audit_occupied_cells": 2,
            }
            for method in methods
        ],
    }


def _leaderboard(method: str) -> dict[str, object]:
    offset = 0.0 if method == "classic_revolution" else 0.02
    return {
        "method_name": method,
        "covered_problems": 1,
        "valid_ppa_candidate_count": 20,
        "mean_best_fitness": 0.3 + offset,
        "mean_hypervolume": 0.4 + offset,
        "mean_ppa_grid_coverage": 0.05 + offset,
        "ppa_front_unique_netlist_count": 3,
        "unique_motif_signature_count": 4,
        "common_audit_occupied_cells": 5,
        "common_audit_qd_score": 1.0 + offset,
        "unique_canonical_netlist_count": 9,
        "duplicate_netlist_count": 2,
    }


def _robustness(method: str) -> dict[str, object]:
    if method == "classic_revolution":
        functionality = 12
        synthesis = 8
    else:
        functionality = 8
        synthesis = 4
    return {
        "method_name": method,
        "total_candidates": 16,
        "syntax_pass": 16,
        "syntax_rate": 1.0,
        "functionality_pass": functionality,
        "functionality_rate": functionality / 16,
        "synthesis_pass": synthesis,
        "synthesis_rate": synthesis / 16,
        "openroad_pass": synthesis,
        "openroad_rate": synthesis / 16,
        "valid_ppa": synthesis,
        "valid_ppa_rate": synthesis / 16,
    }


def _qd_summary(method: str) -> dict[str, object]:
    return {
        "method_name": method,
        "archive_type": "none" if method == "classic_revolution" else "grid",
        "problem_count": 1,
        "internal_occupied_cells": 3,
        "internal_qd_score": 0.2,
        "internal_entropy_bits": 1.0,
        "internal_entropy_evenness": 1.0,
        "common_audit_total_cells": 16,
        "common_audit_occupied_cells": 5,
        "common_audit_coverage": 5 / 16,
        "common_audit_qd_score": 0.4,
        "common_audit_entropy_bits": 1.5,
        "common_audit_entropy_normalized": 0.3,
    }


def _gate(method: str) -> dict[str, object]:
    return {
        "method_name": method,
        "covered_problems": 1,
        "classic_covered_problems": 1,
        "missing_classic_problems": [],
        "extra_problems": [],
        "gate0": "PASS",
    }


def _problem(method: str) -> dict[str, object]:
    return {
        "method_name": method,
        "problem_id": "Bench/ProbA",
        "valid_ppa_candidate_count": 8,
        "best_fitness": 0.3,
        "hypervolume": 0.4,
        "ppa_grid_occupied_cells": 2,
        "ppa_grid_coverage": 0.1,
        "pareto_point_count": 2,
        "reference_beating_count": 1,
        "unique_canonical_netlist_count": 4,
        "duplicate_netlist_count": 4,
        "ppa_front_unique_netlist_count": 2,
    }
