from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "report_auto_bd_run_matrix_status.py"
)
_SPEC = importlib.util.spec_from_file_location("report_auto_bd_run_matrix_status", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_auto_bd_run_matrix_status", mod)
_SPEC.loader.exec_module(mod)


def test_build_status_reports_pending_and_standard_complete(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    matrix = _write_matrix(tmp_path)
    complete_root = tmp_path / "exp" / "complete"
    _write_problem_summary(complete_root, "RTLLM", "P0")
    _write_standard_results(complete_root / "standard_results")
    (tmp_path / "exp" / "complete" / "run_manifest.json").write_text("{}", encoding="utf-8")

    payload = mod.build_status(matrix)

    assert payload["manifest_summary"] == {"total": 2, "complete": 1, "pending": 1}
    assert payload["entry_summary"] == {"total": 2, "complete": 1, "pending": 1}
    assert payload["arm_seed_summary"] == {
        "total": 2,
        "standard_results_complete": 1,
        "pending": 1,
    }
    assert payload["next_pending_commands"][0]["arm_name"] == "pending_arm"


def test_main_writes_json_and_markdown(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    matrix = _write_matrix(tmp_path)
    output_json = tmp_path / "status.json"
    output_md = tmp_path / "status.md"

    code = mod.main(
        [
            "--matrix",
            str(matrix),
            "--output-json",
            str(output_json),
            "--output-md",
            str(output_md),
        ]
    )

    payload = json.loads(output_json.read_text(encoding="utf-8"))
    assert code == 0
    assert payload["phase"] == "main_screening"
    assert "# Auto-BD Main Screening Run Status" in output_md.read_text(encoding="utf-8")


def _write_matrix(tmp_path: Path) -> Path:
    matrix = tmp_path / "matrix.json"
    matrix.write_text(
        json.dumps(
            {
                "phase": "main_screening",
                "arms": ["complete_arm", "pending_arm"],
                "manifest_commands": [
                    {
                        "arm_name": "complete_arm",
                        "seed": "1001",
                        "command_string": (
                            "python manifest.py --output "
                            f"{tmp_path / 'exp' / 'complete' / 'run_manifest.json'}"
                        ),
                    },
                    {
                        "arm_name": "pending_arm",
                        "seed": "1001",
                        "command_string": (
                            "python manifest.py --output "
                            f"{tmp_path / 'exp' / 'pending' / 'run_manifest.json'}"
                        ),
                    },
                ],
                "entries": [
                    {
                        "arm_name": "complete_arm",
                        "phase": "main_screening",
                        "seed": 1001,
                        "benchmark": "RTLLM",
                        "problems": ["P0"],
                        "save_path": str(tmp_path / "exp" / "complete"),
                        "command_string": "python run.py --arm complete",
                    },
                    {
                        "arm_name": "pending_arm",
                        "phase": "main_screening",
                        "seed": 1001,
                        "benchmark": "RTLLM",
                        "problems": ["P1"],
                        "save_path": str(tmp_path / "exp" / "pending"),
                        "command_string": "python run.py --arm pending",
                    },
                ],
            }
        )
        + "\n",
        encoding="utf-8",
    )
    return matrix


def _write_problem_summary(save_path: Path, benchmark: str, problem: str) -> None:
    path = (
        save_path
        / "revolution"
        / "openai_gpt-oss-120b"
        / benchmark
        / problem
        / f"{problem}_summary.json"
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("{}", encoding="utf-8")


def _write_standard_results(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)
    for name in mod.RESULT_FILES:
        (path / name).write_text("", encoding="utf-8")
