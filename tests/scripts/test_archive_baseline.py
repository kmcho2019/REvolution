import csv
import json
import sys
import tarfile
from unittest import mock
from pathlib import Path

import pytest


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from scripts.archive_baseline import archive_baseline  # noqa: E402


@pytest.fixture
def mocker(request):
    """Local fallback for environments without pytest-mock."""

    patchers = []

    class _Mocker:
        def patch(self, target: str, *args, **kwargs):
            patcher = mock.patch(target, *args, **kwargs)
            patchers.append(patcher)
            return patcher.start()

    instance = _Mocker()
    request.addfinalizer(lambda: [patcher.stop() for patcher in reversed(patchers)])
    return instance


def _write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def _write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def _build_run_log(run_started: str, *, backend: str = "revolution") -> str:
    args = {
        "backend": backend,
        "model_name": "stub-model",
        "num_generations": 2,
        "population_size": 3,
        "max_tokens": 512,
    }
    return (
        f"Run Started: {run_started}\n"
        f"Arguments: {args}\n"
        "Git commit: deadbeefcafebabe\n"
        "default_llm_max_tokens: 512\n"
    )


def _make_single_run_tree(root: Path, *, run_started: str) -> Path:
    run_dir = root / "single" / "stub-model"
    _write_text(run_dir / f"{run_started}_run_log.txt", _build_run_log(run_started))
    _write_text(run_dir / f"{run_started}_summary_results.txt", "ok\n")
    _write_text(run_dir / f"{run_started}_config.yaml", "model_name: stub-model\n")
    _write_text(run_dir / "OVERALL_EVOLUTIONARY_REPORT.md", "# report\n")
    _write_text(run_dir / "keep.txt", "artifact\n")
    _write_text(run_dir / "__pycache__" / "ignored.pyc", "binary\n")
    _write_json(
        run_dir / "RTLLM" / "Prob001_accu" / "Prob001_accu_summary.json",
        {"benchmark_name": "RTLLM", "problem_name": "Prob001_accu"},
    )
    _write_text(
        run_dir / "RTLLM" / "Prob001_accu" / "problem_run.log",
        "worker log\n",
    )
    return run_dir


def _make_ablation_tree(root: Path, *, run_started: str) -> Path:
    run_dir = root / "ablation" / run_started
    _write_text(run_dir / "backend_comparison.md", "# compare\n")

    for backend in ("revolution", "funsearch"):
        model_root = run_dir / backend / "stub-model"
        _write_text(
            model_root / f"{run_started}_{backend}_run_log.txt",
            _build_run_log(run_started, backend=backend),
        )
        _write_text(
            model_root / f"{run_started}_{backend}_summary_results.txt",
            f"{backend}: ok\n",
        )
        _write_text(
            model_root / f"{run_started}_{backend}_config.yaml",
            f"backend: {backend}\n",
        )
        _write_json(
            model_root / "RTLLM" / "Prob001_accu" / "Prob001_accu_summary.json",
            {"benchmark_name": "RTLLM", "problem_name": "Prob001_accu"},
        )
    return run_dir


def _add_candidate_artifacts(run_dir: Path) -> None:
    modern_candidate = run_dir / "RTLLM" / "Prob001_accu" / "Gen0" / "Prob001_accu_sample1_initial"
    _write_text(modern_candidate / "code.sv", "module code_mod; endmodule\n")
    _write_text(modern_candidate / "thought.txt", "Use a two-stage pipeline.\n")
    _write_text(
        modern_candidate / "code_feedback.txt",
        "Score: 7\nJustification: good\n\nANALYSIS:\nfeedback\n",
    )
    _write_text(modern_candidate / "candidate_simulation.log", "sim log\n")
    _write_text(modern_candidate / "candidate_synthesis_report.rpt", "report\n")
    _write_text(modern_candidate / "candidate_netlist.v", "module netlist; endmodule\n")

    legacy_candidate = run_dir / "RTLLM" / "Prob001_accu" / "Gen1"
    _write_text(legacy_candidate / "candidate_2.sv", "module legacy; endmodule\n")
    _write_text(legacy_candidate / "candidate_2_thought.txt", "legacy thought\n")
    _write_text(legacy_candidate / "candidate_2_feedback.txt", "legacy feedback\n")


def test_archive_single_run_includes_configs_and_summaries(tmp_path):
    run_started = "20260223_010203"
    run_dir = _make_single_run_tree(tmp_path, run_started=run_started)
    archive_root = tmp_path / "archives"

    archive_dir = archive_baseline(
        run_dir=run_dir,
        archive_root=archive_root,
        embed_images=False,
        regenerate_plots=False,
    )

    manifest = json.loads((archive_dir / "manifest.json").read_text(encoding="utf-8"))
    assert manifest["archive_version"] == 3
    assert manifest["archive_type"] == "single_run"
    assert manifest["config_snapshot_count"] == 1
    assert (archive_dir / "configs" / f"{run_started}_config.yaml").exists()
    assert (archive_dir / "artifacts" / "raw_results.tar.xz").exists()

    source_names = {Path(entry["source"]).name for entry in manifest["summary_files"]}
    assert f"{run_started}_summary_results.txt" in source_names
    assert "Prob001_accu_summary.json" in source_names
    assert "OVERALL_EVOLUTIONARY_REPORT.md" in source_names


def test_archive_ablation_root_includes_backend_report_and_configs(tmp_path):
    run_started = "20260223_020304"
    run_dir = _make_ablation_tree(tmp_path, run_started=run_started)
    archive_root = tmp_path / "archives"

    archive_dir = archive_baseline(
        run_dir=run_dir,
        archive_root=archive_root,
        embed_images=False,
        regenerate_plots=False,
    )
    manifest = json.loads((archive_dir / "manifest.json").read_text(encoding="utf-8"))

    assert manifest["archive_type"] == "ablation_run"
    assert manifest["config_snapshot_count"] == 2
    source_names = {Path(entry["source"]).name for entry in manifest["summary_files"]}
    assert "backend_comparison.md" in source_names
    assert (
        archive_dir
        / "configs"
        / "revolution"
        / "stub-model"
        / f"{run_started}_revolution_config.yaml"
    ).exists()
    assert (
        archive_dir
        / "configs"
        / "funsearch"
        / "stub-model"
        / f"{run_started}_funsearch_config.yaml"
    ).exists()


def test_archive_fails_when_no_config_snapshot_found(tmp_path):
    run_started = "20260223_030405"
    run_dir = _make_single_run_tree(tmp_path, run_started=run_started)
    (run_dir / f"{run_started}_config.yaml").unlink()

    with pytest.raises(ValueError, match="No run configuration snapshots found"):
        archive_baseline(
            run_dir=run_dir,
            archive_root=tmp_path / "archives",
            embed_images=False,
            regenerate_plots=False,
        )


def test_archive_index_files_are_appended(tmp_path):
    archive_root = tmp_path / "archives"
    run_dir_a = _make_single_run_tree(tmp_path / "run_a", run_started="20260223_040506")
    run_dir_b = _make_single_run_tree(tmp_path / "run_b", run_started="20260223_040507")

    archive_baseline(
        run_dir=run_dir_a,
        archive_root=archive_root,
        embed_images=False,
        regenerate_plots=False,
    )
    archive_baseline(
        run_dir=run_dir_b,
        archive_root=archive_root,
        embed_images=False,
        regenerate_plots=False,
    )

    csv_rows = list(csv.DictReader((archive_root / "index.csv").open(encoding="utf-8")))
    assert len(csv_rows) == 2
    jsonl_lines = (archive_root / "index.jsonl").read_text(encoding="utf-8").strip().splitlines()
    assert len(jsonl_lines) == 2


def test_archive_excludes_cache_files_from_tar(tmp_path):
    run_dir = _make_single_run_tree(tmp_path, run_started="20260223_050607")
    archive_root = tmp_path / "archives"

    archive_dir = archive_baseline(
        run_dir=run_dir,
        archive_root=archive_root,
        embed_images=False,
        regenerate_plots=False,
        artifact_mode="full",
    )

    tar_path = archive_dir / "artifacts" / "raw_results.tar.xz"
    with tarfile.open(tar_path, "r:xz") as handle:
        names = handle.getnames()

    assert "keep.txt" in names
    assert not any("__pycache__" in name for name in names)
    assert not any(name.endswith(".pyc") for name in names)


def test_manifest_contains_required_fields(tmp_path):
    run_dir = _make_single_run_tree(tmp_path, run_started="20260223_060708")
    archive_root = tmp_path / "archives"
    archive_dir = archive_baseline(
        run_dir=run_dir,
        archive_root=archive_root,
        embed_images=False,
        regenerate_plots=False,
    )
    manifest = json.loads((archive_dir / "manifest.json").read_text(encoding="utf-8"))

    required_keys = {
        "archive_version",
        "archive_type",
        "run_dir",
        "summary_files",
        "config_snapshots",
        "config_snapshot_count",
        "artifact_mode",
        "artifact_file_count",
        "artifacts_tar",
    }
    assert required_keys.issubset(manifest)
    assert manifest["archive_version"] == 3
    assert manifest["config_snapshot_count"] > 0


def test_archive_candidate_core_mode_limits_artifacts_tar(tmp_path):
    run_started = "20260223_070809"
    run_dir = _make_single_run_tree(tmp_path, run_started=run_started)
    _add_candidate_artifacts(run_dir)
    archive_root = tmp_path / "archives"

    archive_dir = archive_baseline(
        run_dir=run_dir,
        archive_root=archive_root,
        embed_images=False,
        regenerate_plots=False,
        artifact_mode="candidate_core",
    )

    tar_path = archive_dir / "artifacts" / "raw_results.tar.xz"
    with tarfile.open(tar_path, "r:xz") as handle:
        names = sorted(handle.getnames())

    assert "RTLLM/Prob001_accu/Gen0/Prob001_accu_sample1_initial/code.sv" in names
    assert "RTLLM/Prob001_accu/Gen0/Prob001_accu_sample1_initial/thought.txt" in names
    assert "RTLLM/Prob001_accu/Gen0/Prob001_accu_sample1_initial/code_feedback.txt" in names
    assert "RTLLM/Prob001_accu/Gen1/candidate_2.sv" in names
    assert "RTLLM/Prob001_accu/Gen1/candidate_2_thought.txt" in names
    assert "RTLLM/Prob001_accu/Gen1/candidate_2_feedback.txt" in names
    assert "keep.txt" not in names
    assert (
        "RTLLM/Prob001_accu/Gen0/Prob001_accu_sample1_initial/candidate_simulation.log"
        not in names
    )
    assert (
        "RTLLM/Prob001_accu/Gen0/Prob001_accu_sample1_initial/candidate_synthesis_report.rpt"
        not in names
    )
    assert "RTLLM/Prob001_accu/Gen0/Prob001_accu_sample1_initial/candidate_netlist.v" not in names

    manifest = json.loads((archive_dir / "manifest.json").read_text(encoding="utf-8"))
    assert manifest["artifact_mode"] == "candidate_core"
    assert manifest["artifact_file_count"] == len(names)
    assert (archive_dir / "configs" / f"{run_started}_config.yaml").exists()
    assert (archive_dir / "summaries" / "OVERALL_EVOLUTIONARY_REPORT.md").exists()


def test_archive_default_mode_is_candidate_core(tmp_path):
    run_started = "20260223_080910"
    run_dir = _make_single_run_tree(tmp_path, run_started=run_started)
    _add_candidate_artifacts(run_dir)
    archive_root = tmp_path / "archives"

    archive_dir = archive_baseline(
        run_dir=run_dir,
        archive_root=archive_root,
        embed_images=False,
        regenerate_plots=False,
    )

    tar_path = archive_dir / "artifacts" / "raw_results.tar.xz"
    with tarfile.open(tar_path, "r:xz") as handle:
        names = sorted(handle.getnames())

    assert "RTLLM/Prob001_accu/Gen0/Prob001_accu_sample1_initial/code.sv" in names
    assert "RTLLM/Prob001_accu/Gen0/Prob001_accu_sample1_initial/thought.txt" in names
    assert "RTLLM/Prob001_accu/Gen0/Prob001_accu_sample1_initial/code_feedback.txt" in names
    assert "keep.txt" not in names
    manifest = json.loads((archive_dir / "manifest.json").read_text(encoding="utf-8"))
    assert manifest["artifact_mode"] == "candidate_core"
