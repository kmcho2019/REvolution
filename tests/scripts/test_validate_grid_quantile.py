import json
from pathlib import Path

import yaml

from revolution.algorithm import Heuristic
from revolution.qd.archive import GridQuantileArchive
from revolution.qd.artifacts import (
    append_archive_history,
    write_archive_cells_csv,
    write_archive_space_files,
    write_qd_summary_files,
)
from revolution.qd.visualization import write_grid_quantile_visualizations_from_artifacts
from scripts.validate_grid_quantile_run import main as validate_run_main
from scripts.validate_grid_quantile_visualizations import validate_problem


def _candidate(
    tmp_path: Path,
    *,
    name: str,
    score: float,
    descriptors: tuple[float, float, float],
) -> Heuristic:
    candidate = Heuristic(name, "module m; endmodule", "", score=score, status="success")
    candidate.id = name
    candidate.ppa_success = True
    candidate.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    candidate.graph_metrics = {
        "logic_depth": descriptors[0],
        "ff_depth": descriptors[1],
        "comb_width_log": descriptors[2],
    }
    candidate.code_file_path = str(tmp_path / f"Prob_sample{name[-1]}_initial" / "code.sv")
    candidate.archive_insertion_index = int(name[-1])
    candidate.generation_candidate_index = int(name[-1])
    return candidate


def _write_problem(
    root: Path,
    tmp_path: Path,
    *,
    second_descriptors: tuple[float, float, float] = (4.0, 0.0, 2.0),
) -> None:
    archive = GridQuantileArchive(
        ("logic_depth", "ff_depth", "comb_width_log"),
        warmup_successes=2,
    )
    first = _candidate(tmp_path, name="cand1", score=0.5, descriptors=(1.0, 0.0, 1.0))
    second = _candidate(tmp_path, name="cand2", score=0.7, descriptors=second_descriptors)
    archive.insert(first.id, (1.0, 0.0, 1.0), first.score, first)
    archive.insert(second.id, second_descriptors, second.score, second)

    root.mkdir(parents=True)
    for candidate, descriptors in ((first, (1.0, 0.0, 1.0)), (second, second_descriptors)):
        event_dir = root / "Gen0" / candidate.code_file_path.split("/")[-2]
        event_dir.mkdir(parents=True)
        cell_id = archive.cell_id_for(descriptors)
        (event_dir / "qd_archive_event.json").write_text(
            json.dumps(
                {
                    "candidate_id": candidate.id,
                    "generation": 0,
                    "strategy": "initial",
                    "archive_type": "grid_quantile",
                    "archive_axes": ["logic_depth", "ff_depth", "comb_width_log"],
                    "quality_score": candidate.score,
                    "descriptor_tuple": list(descriptors),
                    "archive_insertion_index": candidate.archive_insertion_index,
                    "cell_id": cell_id,
                    "assignment": archive.describe_assignment(descriptors),
                    "decision": "filled_empty",
                    "inserted": True,
                    "replaced": False,
                }
            ),
            encoding="utf-8",
        )
    history = [
        {
            "generation": 0,
            "archive_type": "grid_quantile",
            "occupied_cells": archive.occupied_count(),
            "num_cells": archive.num_cells,
            "coverage": archive.occupied_count() / archive.num_cells,
            "qd_score": 1.2,
            "best_quality": 0.7,
            "mean_quality": 0.6,
            "grid_quantile_geometry": archive.describe_history_geometry(),
        }
    ]
    append_archive_history(path=root / "archive_history.jsonl", snapshot=history[0])
    write_archive_cells_csv(
        path=root / "archive_cells.csv",
        entries=sorted(archive.entries().items()),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
    )
    artifacts = write_qd_summary_files(
        summary_path=root / "archive_summary.json",
        metrics_path=root / "qd_metrics.json",
        output_dir=root,
        history=history,
        archive=archive,
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        descriptor_profile="journal_logic_ff_width_3d",
        descriptor_axes=("logic_depth", "ff_depth", "comb_width_log"),
    )
    write_archive_space_files(
        json_path=root / "archive_space.json",
        report_path=root / "archive_space_report.md",
        archive=archive,
        descriptor_profile="journal_logic_ff_width_3d",
        descriptor_axes=("logic_depth", "ff_depth", "comb_width_log"),
        occupied_cells=archive.occupied_count(),
        visualization_files=artifacts.generated_files,
    )
    (root / "descriptor_health.json").write_text("{}", encoding="utf-8")
    (root / "descriptor_health_report.md").write_text("# Descriptor Health\n", encoding="utf-8")
    _write_problem_summary(root, success_count=2)
    write_grid_quantile_visualizations_from_artifacts(root)


def _write_problem_summary(root: Path, *, success_count: int) -> None:
    root.mkdir(parents=True, exist_ok=True)
    (root / "generation_log.jsonl").write_text(
        json.dumps(
            {
                "generation": 0,
                "status_counts_this_generation": {"success": success_count},
            }
        )
        + "\n",
        encoding="utf-8",
    )
    (root / f"{root.name}_summary.json").write_text(
        json.dumps(
            {
                "problem_name": root.name,
                "total_candidates_generated": success_count,
                "accumulated_success_rates": {
                    "functionality": 1.0,
                    "total_synthesis_ppa": 1.0,
                },
                "run_budget": {
                    "total_worker_slots": 4,
                    "max_active_problems": 4,
                    "max_workers_per_problem": 4,
                },
            }
        ),
        encoding="utf-8",
    )


def test_grid_quantile_visualization_validator_accepts_generated_artifacts(tmp_path):
    problem_root = tmp_path / "problem"
    _write_problem(problem_root, tmp_path)

    assert validate_problem(problem_root) == []
    manifest = json.loads(
        (problem_root / "grid_quantile_visualization_manifest.json").read_text(
            encoding="utf-8"
        )
    )
    assert manifest["visualization_mode"] == "2d"
    assert manifest["frames"][0] == "grid_quantile_frames/frame_0000.png"
    assert manifest["has_clean_final_frame"] is True
    assert manifest["frame_count"] == manifest["history_frame_count"] + 1
    assert manifest["axis_layout"]["z"] == "ff_depth"
    assert manifest["final_cell_ids"]
    html = (problem_root / "grid_quantile_occupancy_evolution.html").read_text(
        encoding="utf-8"
    )
    assert "spinBtn" in html
    assert "statsSizeBtn" in html
    assert "BD axes" in html
    assert "slice-layer" in html
    assert "drawAxisGuides" in html
    assert "drawSampleMarker" in html


def test_grid_quantile_visualization_supports_3d_artifacts(tmp_path):
    problem_root = tmp_path / "problem"
    _write_problem(problem_root, tmp_path, second_descriptors=(4.0, 2.0, 2.0))

    assert validate_problem(problem_root) == []
    manifest = json.loads(
        (problem_root / "grid_quantile_visualization_manifest.json").read_text(
            encoding="utf-8"
        )
    )
    assert manifest["visualization_mode"] == "3d"


def test_grid_quantile_run_validator_accepts_synthetic_run(tmp_path, monkeypatch):
    run_root = tmp_path / "run"
    problem_root = run_root / "grid_quantile_journal_bd" / "Prob"
    _write_problem(problem_root, tmp_path)
    _write_problem_summary(run_root / "classic" / "Prob", success_count=2)
    subset_config = tmp_path / "subset.yaml"
    subset_config.write_text(
        yaml.safe_dump({"selected_problems": [{"benchmark": "Bench", "problem": "Prob"}]}),
        encoding="utf-8",
    )

    monkeypatch.setattr(
        "sys.argv",
        [
            "validate_grid_quantile_run.py",
            "--run-root",
            str(run_root),
            "--subset-config",
            str(subset_config),
            "--require-full-subset",
            "--require-visualizations",
        ],
    )

    assert validate_run_main() == 0
    payload = json.loads((run_root / "grid_quantile_validation.json").read_text(encoding="utf-8"))
    assert payload["failure_count"] == 0
    assert payload["problem_invalid_count"] == 0
    assert payload["acceptance_error_count"] == 0


def test_grid_quantile_acceptance_validator_fails_closed(tmp_path, monkeypatch):
    run_root = tmp_path / "run"
    problem_root = run_root / "grid_quantile_journal_bd" / "Prob"
    _write_problem(problem_root, tmp_path)
    _write_problem_summary(run_root / "classic" / "Prob", success_count=2)
    subset_config = tmp_path / "subset.yaml"
    subset_config.write_text(
        yaml.safe_dump({"selected_problems": [{"benchmark": "Bench", "problem": "Prob"}]}),
        encoding="utf-8",
    )

    monkeypatch.setattr(
        "sys.argv",
        [
            "validate_grid_quantile_run.py",
            "--run-root",
            str(run_root),
            "--subset-config",
            str(subset_config),
            "--require-full-subset",
            "--require-visualizations",
            "--acceptance-hard-subset",
        ],
    )

    assert validate_run_main() == 1
    payload = json.loads((run_root / "grid_quantile_validation.json").read_text(encoding="utf-8"))
    assert payload["failure_count"] > 0
    assert payload["problem_invalid_count"] == 0
    assert payload["acceptance_error_count"] > 0
    assert "missing classic resolved run config" in payload["errors"]
