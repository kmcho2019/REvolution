from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "report_auto_bd_promotion_decisions.py"
)
_SPEC = importlib.util.spec_from_file_location("report_auto_bd_promotion_decisions", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_auto_bd_promotion_decisions", mod)
_SPEC.loader.exec_module(mod)


def test_build_decision_payload_promotes_only_gate1_passes(tmp_path: Path) -> None:
    report_path = tmp_path / "central.json"
    report_path.write_text(json.dumps(_central_payload()), encoding="utf-8")

    payload = mod.build_decision_payload(report_path)

    decisions = {
        row["method_name"]: row["decision"]
        for row in payload["decisions"]
    }
    assert decisions["classic_revolution"] == "RETAIN_AS_COMPARATOR"
    assert decisions["landing_smooth_qd_manual_bd"] == "RETAIN_AS_COMPARATOR"
    assert decisions["random_descriptor_qd"] == "PROMOTE_TO_SEED3"
    assert decisions["synthesis_trajectory_nod"] == "PROMOTE_TO_SEED3"
    assert decisions["simple_yosys_stat_bd"] == "DO_NOT_PROMOTE"
    assert decisions["netlist_motif_occupancy"] == "DO_NOT_PROMOTE"
    assert payload["seed3_screening_arms"] == [
        "classic_revolution",
        "landing_smooth_qd_manual_bd",
        "random_descriptor_qd",
        "synthesis_trajectory_nod",
    ]


def _central_payload() -> dict[str, object]:
    methods = [
        "classic_revolution",
        "landing_smooth_qd_manual_bd",
        "random_descriptor_qd",
        "simple_yosys_stat_bd",
        "netlist_motif_occupancy",
        "synthesis_trajectory_nod",
    ]
    return {
        "phase": "development_preliminary_seed1",
        "seed": 1001,
        "gate_matrix": [_gate(method) for method in methods],
        "robustness_funnel": [_robust(method, _rate(method)) for method in methods],
        "leaderboard": [_leader(method) for method in methods],
        "problem_metrics": [
            {"method_name": method, "problem_id": "Bench/ProbA"}
            for method in methods
        ],
    }


def _rate(method: str) -> float:
    rates = {
        "classic_revolution": 0.72,
        "landing_smooth_qd_manual_bd": 0.76,
        "random_descriptor_qd": 0.74,
        "simple_yosys_stat_bd": 0.69,
        "netlist_motif_occupancy": 0.66,
        "synthesis_trajectory_nod": 0.72,
    }
    return rates[method]


def _gate(method: str) -> dict[str, object]:
    return {
        "method_name": method,
        "gate0": "PASS",
        "missing_classic_problems": [],
    }


def _robust(method: str, rate: float) -> dict[str, object]:
    return {
        "method_name": method,
        "functionality_rate": rate,
        "synthesis_rate": rate,
        "openroad_rate": rate,
        "valid_ppa_rate": rate,
    }


def _leader(method: str) -> dict[str, object]:
    return {
        "method_name": method,
        "valid_ppa_candidate_count": 1,
        "mean_best_fitness": 0.1,
        "mean_hypervolume": 0.1,
        "fitness_wins": 0,
        "fitness_ties": 1,
        "fitness_losses": 0,
        "hv_wins": 0,
        "hv_ties": 1,
        "hv_losses": 0,
    }
