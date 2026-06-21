from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "report_useful_bd_push_setup.py"
)
_SPEC = importlib.util.spec_from_file_location("report_useful_bd_push_setup", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_useful_bd_push_setup", mod)
_SPEC.loader.exec_module(mod)


def test_build_setup_freezes_screening_subset(tmp_path: Path) -> None:
    candidate_audit = tmp_path / "candidate_audit.parquet"
    wp0_rows = tmp_path / "wp0_descriptor_rows.parquet"
    pd.DataFrame(_candidate_rows()).to_parquet(candidate_audit, index=False)
    pd.DataFrame([{"candidate_id": "wp0-a"}]).to_parquet(wp0_rows, index=False)

    summary = mod.build_setup(
        candidate_audit=candidate_audit,
        wp0_descriptor_rows=wp0_rows,
        output_root=tmp_path / "exp",
        docs_root=tmp_path / "docs",
        timestamp="20260621_170000_UTC",
        subset_size=5,
    )

    frozen = pd.read_csv(tmp_path / "docs" / "tables" / "frozen_screening_subset.csv")
    candidates = pd.read_csv(tmp_path / "docs" / "tables" / "screening_subset_candidates.csv")
    assert summary["frozen_subset_size"] == 5
    assert "RTLLM/Prob045_alu" in set(frozen["problem_id"])
    assert "VerilogEval-Spec-to-RTL/Prob153_gshare" in set(frozen["problem_id"])
    assert {"arithmetic_datapath", "control_sequential", "memory_interface"}.issubset(
        set(frozen["stratum"])
    )
    assert candidates["selection_score"].notna().all()
    assert (tmp_path / "exp" / "run_ledger.jsonl").is_file()
    assert (tmp_path / "exp" / "envs").is_dir()
    assert (tmp_path / "exp" / "sources").is_dir()


def _candidate_rows() -> list[dict[str, object]]:
    problems = [
        "RTLLM/Prob004_adder_8bit",
        "RTLLM/Prob024_fsm",
        "RTLLM/Prob041_traffic_light",
        "RTLLM/Prob045_alu",
        "RTLLM/Prob049_signal_generator",
        "VerilogEval-Spec-to-RTL/Prob153_gshare",
    ]
    rows = []
    for problem_index, problem_id in enumerate(problems):
        for method in sorted(mod.REQUIRED_METHODS):
            rows.append(_candidate(problem_id, method, problem_index, valid=True))
            rows.append(_candidate(problem_id, method, problem_index, valid=False))
    return rows


def _candidate(
    problem_id: str,
    method: str,
    problem_index: int,
    *,
    valid: bool,
) -> dict[str, object]:
    return {
        "corpus": "auto_bd_standard_results",
        "method": method,
        "problem_id": problem_id,
        "candidate_id": f"{method}-{problem_id}-{valid}",
        "valid_ppa": valid,
        "area": 100.0 + problem_index if valid else None,
        "power": 1.0 + problem_index / 10 if valid else None,
        "eff_clk_period": 0.5 + problem_index / 100 if valid else None,
        "canonical_netlist_hash": f"net-{problem_index}-{method}" if valid else "",
        "motif_signature_hash": f"motif-{problem_index % 3}" if valid else "",
    }
