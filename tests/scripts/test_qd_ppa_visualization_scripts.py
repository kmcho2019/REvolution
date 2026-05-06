from __future__ import annotations

import importlib.util
import json
import os
import subprocess
from pathlib import Path


def _load_export_fixture():
    path = Path(__file__).resolve().parents[1] / "revolution" / "test_ppa_visualization_export.py"
    spec = importlib.util.spec_from_file_location("ppa_visualization_export_fixture", path)
    assert spec is not None
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_export_and_validate_qd_ppa_visualization_cli(tmp_path: Path) -> None:
    fixture = _load_export_fixture()
    run_root, classic_root, qd_root = fixture._write_run(tmp_path)
    repo_root = Path(__file__).resolve().parents[2]
    output_dir = run_root / "visualization" / "qd_ppa_viewer"

    export_result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(repo_root / "scripts" / "export_qd_ppa_visualization.py"),
            "--run-root",
            str(run_root),
            "--backend_run",
            f"classic={classic_root}",
            "--backend_run",
            f"grid_quantile_pareto_journal_bd={qd_root}",
            "--archive_source_backend",
            "grid_quantile_pareto_journal_bd",
            "--problem",
            "RTLLM/Prob001",
            "--output-dir",
            str(output_dir),
            "--strict",
            "--no-classic-descriptor-recovery",
        ],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )

    assert export_result.returncode == 0, export_result.stderr
    assert (output_dir / "manifest.json").is_file()
    assert (output_dir / "index.html").is_file()

    validate_result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(repo_root / "scripts" / "validate_qd_ppa_visualization.py"),
            "--viewer-root",
            str(output_dir),
            "--strict",
        ],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )

    assert validate_result.returncode == 0, validate_result.stderr
    validation = json.loads((output_dir / "validation.json").read_text(encoding="utf-8"))
    assert validation["status"] == "passed"
