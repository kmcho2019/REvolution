from __future__ import annotations

import csv
import importlib.util
import sys
from pathlib import Path

_REPO_ROOT = Path(__file__).resolve().parent.parent.parent
_SCRIPT_PATH = _REPO_ROOT / "scripts" / "report_branch_b_utility.py"
_SPEC = importlib.util.spec_from_file_location("report_branch_b_utility", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
report_branch_b_utility = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_branch_b_utility", report_branch_b_utility)
_SPEC.loader.exec_module(report_branch_b_utility)

_BEST_FIELDS = ["backend", "problem", "circuit_type", "g_P", "g_A", "g_T"]
_CAND_FIELDS = ["backend", "problem", "circuit_type", "g_P", "g_A", "g_T"]


def _write(path: Path, fields: list[str], rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def test_utility_counts_qd_only_and_nondominated(tmp_path: Path) -> None:
    pkg = tmp_path / "pkg"
    _write(
        pkg / "data" / "best_candidate_by_backend_problem.csv",
        _BEST_FIELDS,
        [
            # p1: classic best dominates everything the treatment has
            {"backend": "classic", "problem": "p1", "circuit_type": "combinational",
             "g_P": "0.9", "g_A": "0.9", "g_T": ""},
            # p2: treatment holds a nondominated improving point
            {"backend": "classic", "problem": "p2", "circuit_type": "combinational",
             "g_P": "0.5", "g_A": "0.5", "g_T": ""},
            # p3: classic covered, treatment empty
            {"backend": "classic", "problem": "p3", "circuit_type": "combinational",
             "g_P": "0.4", "g_A": "0.4", "g_T": ""},
        ],
    )
    _write(
        pkg / "data" / "ppa_candidates.csv",
        _CAND_FIELDS,
        [
            {"backend": "qd", "problem": "p1", "circuit_type": "combinational",
             "g_P": "0.1", "g_A": "0.1", "g_T": ""},
            {"backend": "qd", "problem": "p2", "circuit_type": "combinational",
             "g_P": "0.8", "g_A": "0.3", "g_T": ""},
            # p4: qd-only coverage (classic has no best row)
            {"backend": "qd", "problem": "p4", "circuit_type": "combinational",
             "g_P": "0.2", "g_A": "0.2", "g_T": ""},
        ],
    )
    output = tmp_path / "utility.csv"
    assert (
        report_branch_b_utility.main(
            [
                "--seed-package", f"7:{pkg}",
                "--baseline", "classic",
                "--treatment", "qd",
                "--problems-per-seed", "5",
                "--output", str(output),
            ]
        )
        == 0
    )
    rows = {row["seed"]: row for row in csv.DictReader(output.open())}
    assert rows["7"]["qd_only_covered"] == "1"       # p4
    assert rows["7"]["nondominated_improving"] == "1"  # p2
    assert rows["7"]["utility_units"] == "2"
    assert rows["7"]["utility_fraction"] == "0.400000"
    assert rows["ALL"]["utility_units"] == "2"


def test_dominated_and_equal_points_do_not_count(tmp_path: Path) -> None:
    pkg = tmp_path / "pkg"
    _write(
        pkg / "data" / "best_candidate_by_backend_problem.csv",
        _BEST_FIELDS,
        [{"backend": "classic", "problem": "p1", "circuit_type": "sequential",
          "g_P": "0.5", "g_A": "0.5", "g_T": "0.5"}],
    )
    _write(
        pkg / "data" / "ppa_candidates.csv",
        _CAND_FIELDS,
        [
            # equal point: no strict improvement
            {"backend": "qd", "problem": "p1", "circuit_type": "sequential",
             "g_P": "0.5", "g_A": "0.5", "g_T": "0.5"},
            # dominated point
            {"backend": "qd", "problem": "p1", "circuit_type": "sequential",
             "g_P": "0.4", "g_A": "0.4", "g_T": "0.4"},
        ],
    )
    output = tmp_path / "utility.csv"
    report_branch_b_utility.main(
        [
            "--seed-package", f"7:{pkg}",
            "--baseline", "classic",
            "--treatment", "qd",
            "--problems-per-seed", "1",
            "--output", str(output),
        ]
    )
    rows = {row["seed"]: row for row in csv.DictReader(output.open())}
    assert rows["7"]["utility_units"] == "0"
