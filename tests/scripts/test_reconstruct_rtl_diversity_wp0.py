from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "reconstruct_rtl_diversity_wp0.py"
)
_SPEC = importlib.util.spec_from_file_location("reconstruct_rtl_diversity_wp0", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("reconstruct_rtl_diversity_wp0", mod)
_SPEC.loader.exec_module(mod)


def test_build_reconstruction_keeps_generated_descriptors(tmp_path: Path) -> None:
    auto_bd_root = tmp_path / "auto_bd"
    _write_method(auto_bd_root, "synthesis_trajectory_nod", "stnod_cell:0")
    _write_method(auto_bd_root, "sr_random_relu_pca_qd", "sr_cell:0")

    summary = mod.build_reconstruction(auto_bd_root, tmp_path / "out")

    assert summary["candidate_rows"] == 4
    assert summary["event_rows"] == 2
    assert summary["budget_rows"] == 8
    assert summary["duplicate_suppression_rows"] == 16
    methods = {row["method_name"]: row for row in summary["methods"]}
    assert methods["synthesis_trajectory_nod"]["descriptor_rows"] == 2
    assert methods["synthesis_trajectory_nod"]["valid_ppa_rows"] == 1
    assert methods["synthesis_trajectory_nod"]["parent_id_rows"] == 0
    assert (tmp_path / "out" / "wp0_descriptor_rows.parquet").is_file()
    budget = pd.read_csv(tmp_path / "out" / "wp0_budget_curves.csv")
    assert set(budget["budget_fraction"]) == {0.25, 0.5, 0.75, 1.0}
    duplicate = pd.read_csv(tmp_path / "out" / "wp0_duplicate_suppression.csv")
    assert set(duplicate["replay_key"]) == {
        "canonical_netlist",
        "exact_motif_signature",
    }


def _write_method(auto_bd_root: Path, method: str, cell_id: str) -> None:
    result_dir = auto_bd_root / method / "seed_1001" / "standard_results"
    result_dir.mkdir(parents=True)
    pd.DataFrame(
        [
            _candidate(method, valid=True, cell_id=cell_id),
            _candidate(method, valid=False, cell_id=""),
        ]
    ).to_parquet(result_dir / "candidates.parquet", index=False)
    event_dir = (
        auto_bd_root
        / method
        / "seed_1001"
        / "revolution"
        / "model"
        / "RTLLM"
        / "ProbA"
        / "Gen0"
        / "sample1"
    )
    event_dir.mkdir(parents=True)
    (event_dir / "qd_archive_event.json").write_text(
        json.dumps(
            {
                "candidate_id": f"{method}-valid",
                "generation": 0,
                "generated_mode": "whole",
                "origin_pool": "initial",
                "strategy": "initial",
                "parent_count": None,
                "requested_parent_count": None,
                "inserted": True,
                "cell_id": cell_id,
                "quality_score": 0.7,
                "descriptor_values": {"x": 0.1},
                "objectives": {"area": 1.0},
            }
        ),
        encoding="utf-8",
    )


def _candidate(method: str, *, valid: bool, cell_id: str) -> dict[str, object]:
    return {
        "method_name": method,
        "method_family": "auto_bd",
        "descriptor_version": "v1",
        "problem_id": "RTLLM/ProbA",
        "benchmark_source": "RTLLM",
        "seed": 1001,
        "generation": 0 if valid else 1,
        "candidate_id": f"{method}-{'valid' if valid else 'invalid'}",
        "parent_id": "",
        "operator_name": "initial" if valid else "M-S",
        "prompt_hash": "",
        "model_id": "model",
        "model_endpoint_hash": "",
        "syntax_pass": valid,
        "functionality_pass": valid,
        "synthesis_pass": valid,
        "openroad_pass": valid,
        "valid_ppa": valid,
        "failure_reason": "" if valid else "failed",
        "area": 1.0 if valid else None,
        "power": 1.0 if valid else None,
        "timing_or_clock_period": 1.0 if valid else None,
        "fitness": 0.7 if valid else None,
        "ppa_hypervolume_contribution": None,
        "descriptor_vector": "[0.1, 0.2]",
        "common_audit_descriptor_vector": "[0.3, 0.4, 0.5, 0.6]",
        "archive_cell_id": cell_id,
        "common_audit_cell_id": "audit:0" if valid else "",
        "canonical_netlist_hash": "hash-a" if valid else "",
        "motif_signature_hash": "motif-a" if valid else "",
        "rtl_path": "code.sv",
        "netlist_path": "code.syn.v" if valid else "",
    }
