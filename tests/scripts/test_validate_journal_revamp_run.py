from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import yaml

_SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "validate_journal_revamp_run.py"
)
_SPEC = importlib.util.spec_from_file_location("validate_journal_revamp_run", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
validate_journal_revamp_run = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("validate_journal_revamp_run", validate_journal_revamp_run)
_SPEC.loader.exec_module(validate_journal_revamp_run)


def _write_subset(tmp_path: Path, problems: list[str]) -> Path:
    config = tmp_path / "subset.yaml"
    config.write_text(
        yaml.safe_dump({"benchmarks": {"RTLLM": {"problems": problems}}}),
        encoding="utf-8",
    )
    return config


def _write_problem(
    run_root: Path,
    problem: str,
    *,
    qd: bool = False,
    occupied_cells: int = 5,
    collapsed_axes: list[str] | None = None,
) -> None:
    problem_dir = run_root / "_models_demo" / "RTLLM" / problem
    problem_dir.mkdir(parents=True, exist_ok=True)
    (problem_dir / f"{problem}_summary.json").write_text("{}", encoding="utf-8")
    if qd:
        (problem_dir / "archive_summary.json").write_text(
            json.dumps({"occupied_cells": occupied_cells}), encoding="utf-8"
        )
        (problem_dir / "qd_metrics.json").write_text("{}", encoding="utf-8")
        (problem_dir / "descriptor_health.json").write_text(
            json.dumps(
                {
                    "axes": ["logic_depth", "ff_depth", "comb_width_log"],
                    "collapsed_axes": collapsed_axes or [],
                }
            ),
            encoding="utf-8",
        )


def _write_run_metadata(run_root: Path, *, seed: int = 42) -> None:
    model_dir = run_root / "_models_demo"
    model_dir.mkdir(parents=True, exist_ok=True)
    (model_dir / "20260612_backend_config.yaml").write_text(
        yaml.safe_dump({"seed": seed, "backend": "revolution"}), encoding="utf-8"
    )
    (model_dir / "20260612_backend_scheduler_telemetry.json").write_text(
        json.dumps(
            {"mean_occupancy_fraction": 0.5, "run_wall_seconds": 120.0}
        ),
        encoding="utf-8",
    )


def test_classic_run_passes_validation(tmp_path, capsys):
    run_root = tmp_path / "run"
    for problem in ("Prob001", "Prob002"):
        _write_problem(run_root, problem)
    _write_run_metadata(run_root)
    subset = _write_subset(tmp_path, ["Prob001", "Prob002"])
    output = tmp_path / "validation"

    code = validate_journal_revamp_run.main(
        [
            "--run-root",
            str(run_root),
            "--subset-config",
            str(subset),
            "--search-mode",
            "classic",
            "--expect-seed",
            "42",
            "--require-scheduler-telemetry",
            "--output-dir",
            str(output),
        ]
    )

    assert code == 0
    payload = json.loads((output / "validation_report.json").read_text(encoding="utf-8"))
    assert payload["all_passed"] is True
    assert (output / "validation_report.md").is_file()


def test_missing_problem_fails_coverage(tmp_path):
    run_root = tmp_path / "run"
    _write_problem(run_root, "Prob001")
    _write_run_metadata(run_root)
    subset = _write_subset(tmp_path, ["Prob001", "Prob002"])

    code = validate_journal_revamp_run.main(
        [
            "--run-root",
            str(run_root),
            "--subset-config",
            str(subset),
            "--output-dir",
            str(tmp_path / "validation"),
        ]
    )

    assert code == 1


def test_qd_run_requires_archive_artifacts_and_occupancy(tmp_path):
    run_root = tmp_path / "run"
    _write_problem(run_root, "Prob001", qd=True, occupied_cells=4)
    _write_problem(run_root, "Prob002", qd=True, occupied_cells=0)
    _write_run_metadata(run_root)
    subset = _write_subset(tmp_path, ["Prob001", "Prob002"])
    output = tmp_path / "validation"

    code = validate_journal_revamp_run.main(
        [
            "--run-root",
            str(run_root),
            "--subset-config",
            str(subset),
            "--search-mode",
            "qd",
            "--output-dir",
            str(output),
        ]
    )

    assert code == 1
    payload = json.loads((output / "validation_report.json").read_text(encoding="utf-8"))
    failing = {
        check["name"]: check for check in payload["checks"] if not check["passed"]
    }
    assert "qd_artifacts:RTLLM/Prob002" in failing


def test_qd_fatal_descriptor_collapse_fails(tmp_path):
    run_root = tmp_path / "run"
    _write_problem(
        run_root,
        "Prob001",
        qd=True,
        collapsed_axes=["logic_depth", "ff_depth", "comb_width_log"],
    )
    _write_run_metadata(run_root)
    subset = _write_subset(tmp_path, ["Prob001"])

    code = validate_journal_revamp_run.main(
        [
            "--run-root",
            str(run_root),
            "--subset-config",
            str(subset),
            "--search-mode",
            "qd",
            "--output-dir",
            str(tmp_path / "validation"),
        ]
    )

    assert code == 1


def test_wrong_seed_fails(tmp_path):
    run_root = tmp_path / "run"
    _write_problem(run_root, "Prob001")
    _write_run_metadata(run_root, seed=7)
    subset = _write_subset(tmp_path, ["Prob001"])

    code = validate_journal_revamp_run.main(
        [
            "--run-root",
            str(run_root),
            "--subset-config",
            str(subset),
            "--expect-seed",
            "42",
            "--output-dir",
            str(tmp_path / "validation"),
        ]
    )

    assert code == 1
