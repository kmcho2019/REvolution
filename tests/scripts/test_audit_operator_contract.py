from __future__ import annotations

import csv
import importlib.util
import sys
import typing
from pathlib import Path

_REPO_ROOT = Path(__file__).resolve().parent.parent.parent
_SCRIPT_PATH = _REPO_ROOT / "scripts" / "audit_operator_contract.py"
_SPEC = importlib.util.spec_from_file_location("audit_operator_contract", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
audit_operator_contract = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("audit_operator_contract", audit_operator_contract)
_SPEC.loader.exec_module(audit_operator_contract)


def _write_candidates(path: Path, rows: list[tuple[str, str]]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["backend", "strategy"])
        writer.writeheader()
        writer.writerows({"backend": backend, "strategy": strategy} for backend, strategy in rows)


def _read_output(path: Path) -> dict[str, dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return {row["method_key"]: row for row in csv.DictReader(handle)}


def test_eoh_strategy_set_matches_framework_literal() -> None:
    from revolution.algorithm import EvolStrategyMethod

    literal_names = set(typing.get_args(EvolStrategyMethod))
    assert audit_operator_contract.EOH_STRATEGIES < literal_names
    assert audit_operator_contract.SINGLE_THOUGHT in literal_names


def test_clean_run_passes(tmp_path: Path) -> None:
    candidates = tmp_path / "ppa_candidates.csv"
    _write_candidates(
        candidates,
        [("classic", "initial"), ("classic", "M-S"), ("qd", "initial"), ("qd", "C-F")],
    )
    output = tmp_path / "audit.csv"
    exit_code = audit_operator_contract.main(
        ["--ppa-candidates", str(candidates), "--output", str(output)]
    )
    assert exit_code == 0
    table = _read_output(output)
    assert table["classic"]["status"] == "pass"
    assert table["qd"]["eoh_strategy_count"] == "1"
    assert table["qd"]["initial_count"] == "1"
    assert table["qd"]["single_thought_count"] == "0"
    assert table["qd"]["other_strategy_count"] == "0"


def test_non_eoh_strategy_is_counted_as_other(tmp_path: Path) -> None:
    candidates = tmp_path / "ppa_candidates.csv"
    _write_candidates(candidates, [("qd", "M-T"), ("qd", "M-S")])
    output = tmp_path / "audit.csv"
    exit_code = audit_operator_contract.main(
        ["--ppa-candidates", str(candidates), "--output", str(output)]
    )
    assert exit_code == 0  # visible, but only single-thought hard-fails
    table = _read_output(output)
    assert table["qd"]["other_strategy_count"] == "1"


def test_single_thought_contamination_fails(tmp_path: Path) -> None:
    candidates = tmp_path / "ppa_candidates.csv"
    _write_candidates(
        candidates,
        [("classic", "M-E"), ("qd", "single_thought_operator"), ("qd", "M-E")],
    )
    output = tmp_path / "audit.csv"
    exit_code = audit_operator_contract.main(
        ["--ppa-candidates", str(candidates), "--output", str(output)]
    )
    assert exit_code == 1
    table = _read_output(output)
    assert table["classic"]["status"] == "pass"
    assert table["qd"]["status"] == "fail"
    assert table["qd"]["single_thought_count"] == "1"


def test_explicit_method_selection_ignores_other_backends(tmp_path: Path) -> None:
    candidates = tmp_path / "ppa_candidates.csv"
    _write_candidates(
        candidates,
        [("classic", "M-S"), ("legacy", "single_thought_operator")],
    )
    output = tmp_path / "audit.csv"
    exit_code = audit_operator_contract.main(
        [
            "--ppa-candidates",
            str(candidates),
            "--methods",
            "classic",
            "--output",
            str(output),
        ]
    )
    assert exit_code == 0
    assert list(_read_output(output)) == ["classic"]
