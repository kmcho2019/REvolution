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


def _load_validator_module():
    path = Path(__file__).resolve().parents[2] / "scripts" / "validate_qd_ppa_visualization.py"
    spec = importlib.util.spec_from_file_location("qd_ppa_visualization_validator", path)
    assert spec is not None
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


class _OptionPage:
    def __init__(self, values: list[str]) -> None:
        self.values = values

    def eval_on_selector_all(self, _selector: str, _script: str) -> list[str]:
        return self.values


def test_strict_visual_case_matrix_is_explicit() -> None:
    validator = _load_validator_module()
    cases = validator.STRICT_VISUAL_CASES

    assert cases == (
        ("sequential_ppa_3d", "RTLLM/Prob015_multi_pipe_8bit", "ppa", "3d"),
        ("sequential_archive_3d", "RTLLM/Prob015_multi_pipe_8bit", "archive", "3d"),
        ("combinational_ppa_2d", "RTLLM/Prob004_adder_8bit", "ppa", "2d"),
        ("combinational_projected_archive", "VerilogEval-Spec-to-RTL/Prob135_m2014_q6b", "archive", "2d_slab"),
    )


def test_compare_pair_uses_available_non_classic_backend() -> None:
    validator = _load_validator_module()
    errors: list[str] = []

    pair = validator._compare_pair(
        _OptionPage(["classic", "grid_quantile_pareto_journal_thought_k4"]),
        errors,
    )

    assert pair == ("classic", "grid_quantile_pareto_journal_thought_k4")
    assert errors == []


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


def test_strict_validation_rejects_flat_2d_index_html(tmp_path: Path) -> None:
    fixture = _load_export_fixture()
    run_root, classic_root, qd_root = fixture._write_run(tmp_path)
    repo_root = Path(__file__).resolve().parents[2]
    output_dir = run_root / "visualization" / "flat_viewer"

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

    (output_dir / "index.html").write_text(
        """<!doctype html>
<html><body>
<canvas id="ppaCanvas"></canvas>
<script>
const ctx = document.getElementById('ppaCanvas').getContext('2d');
function drawPpa() {
  ctx.fillRect(0, 0, 100, 100);
}
drawPpa();
</script>
</body></html>
""",
        encoding="utf-8",
    )

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

    assert validate_result.returncode != 0
    stderr = validate_result.stderr
    assert "__QD_PPA_VIEWER_DEBUG__" in stderr
    assert "flat 2D-only canvas viewer" in stderr


def test_strict_validation_rejects_network_assets(tmp_path: Path) -> None:
    fixture = _load_export_fixture()
    run_root, classic_root, qd_root = fixture._write_run(tmp_path)
    repo_root = Path(__file__).resolve().parents[2]
    output_dir = run_root / "visualization" / "network_asset_viewer"

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

    html_path = output_dir / "index.html"
    html_path.write_text(
        html_path.read_text(encoding="utf-8").replace(
            "</head>",
            '<script src="https://cdn.example.invalid/viewer.js"></script></head>',
        ),
        encoding="utf-8",
    )

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

    assert validate_result.returncode != 0
    assert "strict HTML references network assets" in validate_result.stderr
