from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

_REPO_ROOT = Path(__file__).resolve().parent.parent.parent
_SCRIPT_PATH = _REPO_ROOT / "scripts" / "validate_natural_qd_run.py"
_SPEC = importlib.util.spec_from_file_location("validate_natural_qd_run", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
validate_natural_qd_run = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("validate_natural_qd_run", validate_natural_qd_run)
_SPEC.loader.exec_module(validate_natural_qd_run)


def _write_manifest(path: Path, rows: list[tuple[str, str]]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["benchmark", "problem"])
        writer.writeheader()
        writer.writerows(
            {"benchmark": benchmark, "problem": problem} for benchmark, problem in rows
        )


def _write_problem(
    run_root: Path,
    benchmark: str,
    problem: str,
    strategy_counts: list[dict[str, int]],
    *,
    qd_artifacts: bool,
) -> None:
    problem_dir = run_root / "openai_gpt-oss-120b" / benchmark / problem
    problem_dir.mkdir(parents=True)
    lines = [
        json.dumps(
            {"generation": generation, "strategy_counts_this_generation": counts}
        )
        for generation, counts in enumerate(strategy_counts)
    ]
    (problem_dir / "generation_log.jsonl").write_text(
        "\n".join(lines) + "\n", encoding="utf-8"
    )
    if qd_artifacts:
        (problem_dir / "archive_summary.json").write_text("{}", encoding="utf-8")
        (problem_dir / "qd_metrics.json").write_text("{}", encoding="utf-8")


def _run(run_root: Path, manifest: Path, arm: str, output: Path) -> int:
    return validate_natural_qd_run.main(
        [
            "--run-root",
            str(run_root),
            "--manifest",
            str(manifest),
            "--arm",
            arm,
            "--output",
            str(output),
        ]
    )


def test_clean_qd_run_passes(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    _write_problem(
        run_root,
        "RTLLM",
        "Prob024_fsm",
        [{"initial": 8}, {"M-S": 4, "C-F": 2}],
        qd_artifacts=True,
    )
    manifest = tmp_path / "manifest.csv"
    _write_manifest(manifest, [("RTLLM", "Prob024_fsm")])
    output = tmp_path / "report.json"
    assert _run(run_root, manifest, "qd", output) == 0
    report = json.loads(output.read_text(encoding="utf-8"))
    assert report["status"] == "pass"
    assert report["errors"] == []


def test_thought_mutation_allowed_for_qd_forbidden_for_classic(
    tmp_path: Path,
) -> None:
    run_root = tmp_path / "run"
    _write_problem(
        run_root,
        "RTLLM",
        "Prob024_fsm",
        [{"initial": 8}, {"M-T": 2, "M-S": 4}],
        qd_artifacts=True,
    )
    manifest = tmp_path / "manifest.csv"
    _write_manifest(manifest, [("RTLLM", "Prob024_fsm")])
    output = tmp_path / "report.json"
    assert _run(run_root, manifest, "qd", output) == 0
    assert _run(run_root, manifest, "classic", output) == 1
    report = json.loads(output.read_text(encoding="utf-8"))
    assert any("'M-T'" in error for error in report["errors"])


def test_single_thought_strategy_fails(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    _write_problem(
        run_root,
        "RTLLM",
        "Prob024_fsm",
        [{"initial": 8}, {"single_thought_operator": 6}],
        qd_artifacts=True,
    )
    manifest = tmp_path / "manifest.csv"
    _write_manifest(manifest, [("RTLLM", "Prob024_fsm")])
    output = tmp_path / "report.json"
    assert _run(run_root, manifest, "qd", output) == 1
    report = json.loads(output.read_text(encoding="utf-8"))
    assert any("single_thought_operator" in error for error in report["errors"])


def test_missing_manifest_problem_fails(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    _write_problem(
        run_root, "RTLLM", "Prob024_fsm", [{"initial": 8}], qd_artifacts=True
    )
    manifest = tmp_path / "manifest.csv"
    _write_manifest(
        manifest, [("RTLLM", "Prob024_fsm"), ("RTLLM", "Prob045_alu")]
    )
    output = tmp_path / "report.json"
    assert _run(run_root, manifest, "qd", output) == 1
    report = json.loads(output.read_text(encoding="utf-8"))
    assert any("Prob045_alu" in error for error in report["errors"])


def test_classic_arm_rejects_qd_artifacts_and_qd_requires_them(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    _write_problem(
        run_root, "RTLLM", "Prob024_fsm", [{"initial": 8}], qd_artifacts=True
    )
    _write_problem(
        run_root, "RTLLM", "Prob045_alu", [{"initial": 8}], qd_artifacts=False
    )
    manifest = tmp_path / "manifest.csv"
    _write_manifest(
        manifest, [("RTLLM", "Prob024_fsm"), ("RTLLM", "Prob045_alu")]
    )
    output = tmp_path / "report.json"
    assert _run(run_root, manifest, "classic", output) == 1
    report = json.loads(output.read_text(encoding="utf-8"))
    assert any("classic arm has QD artifact" in error for error in report["errors"])
    assert _run(run_root, manifest, "qd", output) == 1
    report = json.loads(output.read_text(encoding="utf-8"))
    assert any("missing QD artifact" in error for error in report["errors"])
