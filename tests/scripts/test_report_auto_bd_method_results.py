from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "report_auto_bd_method_results.py"
)
_SPEC = importlib.util.spec_from_file_location("report_auto_bd_method_results", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_auto_bd_method_results", mod)
_SPEC.loader.exec_module(mod)


def test_build_reports_writes_method_reports(tmp_path: Path) -> None:
    method_root = tmp_path / "auto_bd_methods"
    for directory in mod.METHOD_DIRS.values():
        (method_root / directory).mkdir(parents=True)
    central_report = tmp_path / "central.json"
    central_report.write_text(json.dumps(_central_payload()), encoding="utf-8")

    outputs = mod.build_reports(
        central_report_json=central_report,
        method_root=method_root,
        output_name="seed1_artifact_report.md",
    )

    assert set(outputs) == set(mod.METHOD_DIRS)
    for path in outputs.values():
        text = path.read_text(encoding="utf-8")
        assert "## Gate 0" in text
        assert "## Representative Elites" in text
        assert "accept_reject.md" in text


def _central_payload() -> dict[str, object]:
    methods = list(mod.METHOD_DIRS)
    return {
        "phase": "development_preliminary_seed1",
        "seed": 1001,
        "reference_method": "classic_revolution",
        "artifact_roots": {
            method: f"exp/{method}/standard_results"
            for method in methods
        },
        "gate_matrix": [_gate(method) for method in methods],
        "leaderboard": [_leader(method) for method in methods],
        "robustness_funnel": [_robust(method) for method in methods],
        "qd_summary": [_qd(method) for method in methods],
        "representative_elites": [
            row
            for method in methods
            for row in [_elite(method, "method_best_fitness"), _elite(method, "problem_best_fitness")]
        ],
    }


def _gate(method: str) -> dict[str, object]:
    return {
        "method_name": method,
        "gate0": "PASS",
        "covered_problems": 1,
        "classic_covered_problems": 1,
        "missing_classic_problems": [],
    }


def _leader(method: str) -> dict[str, object]:
    return {
        "method_name": method,
        "valid_ppa_candidate_count": 2,
        "mean_best_fitness": 0.1,
        "fitness_wins": 0,
        "fitness_ties": 1,
        "fitness_losses": 0,
        "mean_hypervolume": 0.2,
        "hv_wins": 0,
        "hv_ties": 1,
        "hv_losses": 0,
        "unique_canonical_netlist_count": 2,
        "unique_motif_signature_count": 2,
        "ppa_front_unique_netlist_count": 1,
    }


def _robust(method: str) -> dict[str, object]:
    return {
        "method_name": method,
        "syntax_pass": 2,
        "syntax_rate": 1.0,
        "functionality_pass": 2,
        "functionality_rate": 1.0,
        "synthesis_pass": 2,
        "synthesis_rate": 1.0,
        "openroad_pass": 2,
        "openroad_rate": 1.0,
        "valid_ppa": 2,
        "valid_ppa_rate": 1.0,
    }


def _qd(method: str) -> dict[str, object]:
    return {
        "method_name": method,
        "archive_type": "grid_quantile",
        "internal_occupied_cells": 1,
        "internal_qd_score": 0.1,
        "common_audit_occupied_cells": 1,
        "common_audit_coverage": 0.01,
        "common_audit_qd_score": 0.1,
        "common_audit_entropy_bits": 0.0,
    }


def _elite(method: str, selection_kind: str) -> dict[str, object]:
    return {
        "method_name": method,
        "selection_kind": selection_kind,
        "problem_id": "Bench/ProbA",
        "fitness": 0.1,
        "area": 1.0,
        "power": 0.1,
        "timing_or_clock_period": 0.0,
        "rtl_path": "exp/Bench/ProbA/Gen0/code.sv",
        "netlist_path": "exp/Bench/ProbA/Gen0/code.syn.v",
    }
