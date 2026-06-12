from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "validate_fast_iteration_pair.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "validate_fast_iteration_pair", _SCRIPT_PATH
)
assert _SPEC is not None and _SPEC.loader is not None
validate_fast_iteration_pair = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("validate_fast_iteration_pair", validate_fast_iteration_pair)
_SPEC.loader.exec_module(validate_fast_iteration_pair)


def _write_arm(
    root: Path,
    *,
    problems: int = 6,
    candidates_per_problem: int = 8,
    score_spread: float = 0.1,
    runtime_seconds: float = 600.0,
    wall_seconds: float = 3000.0,
) -> None:
    model_dir = root / "_models_demo"
    for index in range(problems):
        problem = f"Prob{index:03d}"
        problem_dir = model_dir / "RTLLM" / problem
        problem_dir.mkdir(parents=True, exist_ok=True)
        details = [
            {
                "id": f"{problem}-c{c}",
                "score": 0.1 + score_spread * c / max(1, candidates_per_problem - 1),
                "ppa_metrics": {"area": 1.0},
            }
            for c in range(candidates_per_problem)
        ]
        (problem_dir / "generation_log.jsonl").write_text(
            json.dumps({"generation": 1, "population_ppa_details": details}) + "\n",
            encoding="utf-8",
        )
        (problem_dir / f"{problem}_summary.json").write_text(
            json.dumps(
                {
                    "total_runtime_seconds": runtime_seconds,
                    "final_population_ppa_details": details[:3],
                }
            ),
            encoding="utf-8",
        )
    (model_dir / "20260612_revolution_scheduler_telemetry.json").write_text(
        json.dumps({"run_wall_seconds": wall_seconds}), encoding="utf-8"
    )


def test_passing_pair(tmp_path, capsys):
    classic = tmp_path / "classic"
    variant = tmp_path / "variant"
    _write_arm(classic)
    _write_arm(variant)
    stats = tmp_path / "stats.json"
    stats.write_text(
        json.dumps({"metrics": {"best_quality": {"mean_delta": 0.05}}}),
        encoding="utf-8",
    )
    output = tmp_path / "report"

    code = validate_fast_iteration_pair.main(
        [
            "--classic-root",
            str(classic),
            "--variant-root",
            str(variant),
            "--stats-json",
            str(stats),
            "--output-dir",
            str(output),
        ]
    )

    assert code == 0
    report = json.loads(
        (output / "fast_iter_gate_report.json").read_text(encoding="utf-8")
    )
    assert report["gates_passed"] is True
    assert report["verdict"]["verdict"] == "PROMOTE"
    out = capsys.readouterr().out
    assert "Instrument gates PASSED" in out


def test_low_ppa_flow_fails_g2(tmp_path):
    classic = tmp_path / "classic"
    variant = tmp_path / "variant"
    _write_arm(classic)
    _write_arm(variant, candidates_per_problem=3)  # below min 6

    code = validate_fast_iteration_pair.main(
        [
            "--classic-root",
            str(classic),
            "--variant-root",
            str(variant),
            "--output-dir",
            str(tmp_path / "report"),
        ]
    )

    assert code == 1
    report = json.loads(
        (tmp_path / "report" / "fast_iter_gate_report.json").read_text(
            encoding="utf-8"
        )
    )
    failing = {c["name"] for c in report["checks"] if not c["passed"]}
    assert "G2_valid_ppa_flow_variant" in failing
    # G3 also fails: 3 candidates cannot form an IQR sample.
    assert "G3_discrimination_variant" in failing


def test_saturated_scores_fail_g3(tmp_path):
    classic = tmp_path / "classic"
    variant = tmp_path / "variant"
    _write_arm(classic)
    _write_arm(variant, score_spread=0.0)  # all candidates identical

    code = validate_fast_iteration_pair.main(
        [
            "--classic-root",
            str(classic),
            "--variant-root",
            str(variant),
            "--output-dir",
            str(tmp_path / "report"),
        ]
    )

    assert code == 1


def test_wall_clock_and_dominance_fail_g1(tmp_path):
    classic = tmp_path / "classic"
    variant = tmp_path / "variant"
    _write_arm(classic, wall_seconds=7000.0)  # over budget
    _write_arm(variant, runtime_seconds=2900.0, wall_seconds=3000.0)  # dominant

    code = validate_fast_iteration_pair.main(
        [
            "--classic-root",
            str(classic),
            "--variant-root",
            str(variant),
            "--output-dir",
            str(tmp_path / "report"),
        ]
    )

    assert code == 1
    report = json.loads(
        (tmp_path / "report" / "fast_iter_gate_report.json").read_text(
            encoding="utf-8"
        )
    )
    failing = {c["name"] for c in report["checks"] if not c["passed"]}
    assert "G1_wall_clock_classic" in failing
    assert "G1_no_dominant_problem_variant" in failing


def test_inconclusive_band(tmp_path):
    classic = tmp_path / "classic"
    variant = tmp_path / "variant"
    _write_arm(classic)
    _write_arm(variant)
    stats = tmp_path / "stats.json"
    stats.write_text(
        json.dumps({"metrics": {"best_quality": {"mean_delta": 0.01}}}),
        encoding="utf-8",
    )

    code = validate_fast_iteration_pair.main(
        [
            "--classic-root",
            str(classic),
            "--variant-root",
            str(variant),
            "--stats-json",
            str(stats),
            "--output-dir",
            str(tmp_path / "report"),
        ]
    )

    assert code == 0
    report = json.loads(
        (tmp_path / "report" / "fast_iter_gate_report.json").read_text(
            encoding="utf-8"
        )
    )
    assert report["verdict"]["verdict"] == "INCONCLUSIVE"
