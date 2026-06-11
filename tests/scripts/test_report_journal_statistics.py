from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "report_journal_statistics.py"
)
_SPEC = importlib.util.spec_from_file_location("report_journal_statistics", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
report_journal_statistics = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_journal_statistics", report_journal_statistics)
_SPEC.loader.exec_module(report_journal_statistics)


def _write_summary(
    root: Path,
    benchmark: str,
    problem: str,
    *,
    best_score: float | None,
    functionality: float,
    avg_ppa_pct: float | None = None,
) -> None:
    problem_dir = root / "_models_demo" / benchmark / problem
    problem_dir.mkdir(parents=True, exist_ok=True)
    payload = {
        "accumulated_success_rates": {
            "syntax": 1.0,
            "functionality": functionality,
            "synthesis_ppa": functionality,
        },
        "final_population_ppa": {
            "best_metrics": {},
            "best_score": best_score,
        },
        "total_runtime_seconds": 10.0,
    }
    if avg_ppa_pct is not None:
        payload["final_population_ppa"]["average_improvements"] = {
            "area": avg_ppa_pct,
            "power": avg_ppa_pct,
            "period": avg_ppa_pct,
        }
    (problem_dir / f"{problem}_summary.json").write_text(
        json.dumps(payload), encoding="utf-8"
    )


def _build_roots(tmp_path: Path) -> tuple[Path, Path]:
    baseline = tmp_path / "classic_run"
    treatment = tmp_path / "qd_run"
    problems = [f"Prob{i:03d}" for i in range(4)]
    for problem in problems:
        _write_summary(baseline, "RTLLM", problem, best_score=0.10, functionality=0.5)
    # Treatment improves three problems and is missing one entirely.
    for problem in problems[:3]:
        _write_summary(treatment, "RTLLM", problem, best_score=0.20, functionality=0.8)
    return baseline, treatment


def test_main_writes_paired_outputs(tmp_path, capsys):
    baseline, treatment = _build_roots(tmp_path)
    output = tmp_path / "stats"

    code = report_journal_statistics.main(
        [
            "--pair",
            f"42={baseline}={treatment}",
            "--output-dir",
            str(output),
            "--gate-profile",
            "none",
        ]
    )

    assert code == 0
    payload = json.loads((output / "statistical_tests.json").read_text(encoding="utf-8"))
    best = payload["metrics"]["best_quality"]
    assert best["unit_count"] == 4
    assert best["paired_count"] == 3
    assert best["missing_treatment_count"] == 1
    assert best["losses"] == 1  # missing treatment counted as loss
    # Gate-bearing mean is penalized: floor = worst observed value (0.10),
    # so the missing unit contributes delta 0.0 -> (3 * 0.10 + 0.0) / 4.
    assert best["imputed_loss_count"] == 1
    assert best["ci_method"] == "cluster_bootstrap_penalized"
    assert abs(best["mean_delta"] - 0.075) < 1e-9
    assert abs(best["complete_case_mean_delta"] - 0.10) < 1e-9
    assert "per_seed_mean_deltas" in payload

    with (output / "paired_deltas.csv").open() as handle:
        rows = list(csv.DictReader(handle))
    best_rows = [row for row in rows if row["metric"] == "best_quality"]
    assert len(best_rows) == 4
    statuses = {row["unit_id"]: row["status"] for row in best_rows}
    assert statuses["42/RTLLM/Prob003"] == "missing_treatment_counted_as_loss"

    md = (output / "statistical_tests.md").read_text(encoding="utf-8")
    assert "best_quality" in md
    assert "Missing-T" in md


def test_main_reference_gate_profile_evaluates_thresholds(tmp_path):
    baseline, treatment = _build_roots(tmp_path)
    # Complete the missing problem so the win rate is 100%.
    _write_summary(treatment, "RTLLM", "Prob003", best_score=0.20, functionality=0.8)
    output = tmp_path / "stats_gate"

    code = report_journal_statistics.main(
        [
            "--pair",
            f"42={baseline}={treatment}",
            "--output-dir",
            str(output),
            "--gate-profile",
            "reference_ppa",
        ]
    )

    assert code == 0
    payload = json.loads((output / "statistical_tests.json").read_text(encoding="utf-8"))
    gate_names = {gate["name"] for gate in payload["gates"]}
    assert "mean_paired_best_quality_delta" in gate_names
    assert "hypervolume_log_ratio_mean" in gate_names
    best_gate = next(
        gate for gate in payload["gates"] if gate["name"] == "mean_paired_best_quality_delta"
    )
    assert best_gate["passed"] is True  # +0.10 >= +0.03
    win_gate = next(gate for gate in payload["gates"] if gate["name"] == "win_rate_non_tied")
    assert win_gate["passed"] is True
    # Only 4 non-tied pairs: the predeclared sample-size floor must fail.
    pair_gate = next(
        gate
        for gate in payload["gates"]
        if gate["name"] == "win_rate_non_tied_pair_count"
    )
    assert pair_gate["passed"] is False
    assert payload["gates_passed"] is False
    assert payload["equivalence_gates"]
    assert "hypervolume_log_ratio" in payload


def test_multi_pair_emits_loso_and_epsilon_sensitivity(tmp_path):
    baselines: list[Path] = []
    treatments: list[Path] = []
    for seed in ("1001", "1002", "1003"):
        baseline = tmp_path / f"classic_{seed}"
        treatment = tmp_path / f"qd_{seed}"
        for idx in range(3):
            _write_summary(
                baseline, "RTLLM", f"Prob{idx:03d}", best_score=0.10, functionality=0.5
            )
            _write_summary(
                treatment, "RTLLM", f"Prob{idx:03d}", best_score=0.18, functionality=0.8
            )
        baselines.append(baseline)
        treatments.append(treatment)
    output = tmp_path / "stats_multi"

    code = report_journal_statistics.main(
        [
            "--pair",
            f"1001={baselines[0]}={treatments[0]}",
            "--pair",
            f"1002={baselines[1]}={treatments[1]}",
            "--pair",
            f"1003={baselines[2]}={treatments[2]}",
            "--output-dir",
            str(output),
            "--gate-profile",
            "reference_ppa",
        ]
    )

    assert code == 0
    payload = json.loads((output / "statistical_tests.json").read_text(encoding="utf-8"))
    loso = payload["leave_one_seed_out_penalized"]
    assert set(loso) == {"1001", "1002", "1003"}
    for seed_label in loso:
        best = loso[seed_label]["best_quality"]
        assert abs(best["mean_delta"] - 0.08) < 1e-9
    epsilon = payload["hypervolume_log_ratio"]["epsilon_sensitivity"]
    assert set(epsilon) == {"1e-06", "1e-12"}
    for entry in epsilon.values():
        assert "mean" in entry and "ci_low" in entry


def test_main_fails_on_missing_root(tmp_path):
    code = report_journal_statistics.main(
        [
            "--pair",
            f"42={tmp_path / 'nope_a'}={tmp_path / 'nope_b'}",
            "--output-dir",
            str(tmp_path / "out"),
        ]
    )
    assert code == 2
