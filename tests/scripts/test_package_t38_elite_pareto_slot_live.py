import json
from pathlib import Path

from scripts.package_t38_elite_pareto_slot_live import MODE_ROOT, main


def _write_problem(root: Path, problem: str, *, sequential: bool, mode_root: Path) -> None:
    problem_root = root / mode_root / problem
    problem_root.mkdir(parents=True)
    ref = {"power": 10.0, "area": 100.0, "eff_clk_period": 5.0 if sequential else 0.0}
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps({"ref_ppa_metric": ref}),
        encoding="utf-8",
    )
    (problem_root / "archive_summary.json").write_text(
        json.dumps(
            {
                "total_archive_members": 1,
                "occupied_cells": 1,
                "max_front_size": 1,
                "best_quality": 0.5,
            }
        ),
        encoding="utf-8",
    )
    (problem_root / "global_pareto_summary.json").write_text(
        json.dumps({"total_global_pareto_members": 1}),
        encoding="utf-8",
    )
    (problem_root / "archive_cells.csv").write_text(
        "candidate_id\nfront\n",
        encoding="utf-8",
    )
    (problem_root / "global_pareto_archive.csv").write_text(
        "candidate_id\nfront\n",
        encoding="utf-8",
    )
    payload = {
        "generation": 0,
        "generated_candidates": [
            {
                "id": "front",
                "strategy": "initial",
                "code_file_path": str(problem_root / "front.sv"),
            },
            {
                "id": "other",
                "strategy": "initial",
                "code_file_path": str(problem_root / "other.sv"),
            },
        ],
        "population_ppa_details": [
            {
                "id": "front",
                "score": 0.5,
                "ppa_metrics": {"power": 8.0, "area": 90.0, "eff_clk_period": 4.0},
            },
            {
                "id": "other",
                "score": 0.1,
                "ppa_metrics": {"power": 9.0, "area": 95.0, "eff_clk_period": 5.0},
            },
        ],
    }
    (problem_root / "generation_log.jsonl").write_text(json.dumps(payload) + "\n", encoding="utf-8")


def test_package_t38_elite_pareto_slot_live(tmp_path):
    for problem in ("Prob045_alu", "Prob041_traffic_light"):
        _write_problem(tmp_path, problem, sequential=False, mode_root=MODE_ROOT)
    _write_problem(
        tmp_path,
        "Prob015_multi_pipe_8bit",
        sequential=True,
        mode_root=MODE_ROOT,
    )
    output_dir = tmp_path / "package"

    assert main(["--run-root", str(tmp_path), "--output-dir", str(output_dir)]) == 0

    assert (output_dir / "tables" / "t38_live_candidate_ppa_points.csv").is_file()
    assert (output_dir / "figures" / "t38_live_raw_area_power_fronts.png").is_file()
    html = (output_dir / "visualizations" / "direct_ppa_pareto" / "index.html").read_text(
        encoding="utf-8"
    )
    assert "T38 Elite Pareto Slot Direct PPA Fronts" in html


def test_package_t38_script_accepts_t39_labels(tmp_path):
    mode_root = Path("sparse_warmup_elite_slot_qd/seed_1001/openai_gpt-oss-120b/RTLLM")
    for problem in ("Prob045_alu", "Prob041_traffic_light"):
        _write_problem(tmp_path, problem, sequential=False, mode_root=mode_root)
    _write_problem(
        tmp_path,
        "Prob015_multi_pipe_8bit",
        sequential=True,
        mode_root=mode_root,
    )
    output_dir = tmp_path / "package"

    assert (
        main(
            [
                "--run-root",
                str(tmp_path),
                "--output-dir",
                str(output_dir),
                "--mode-root",
                str(mode_root),
                "--file-prefix",
                "t39_live",
                "--plot-title-prefix",
                "T39 Sparse-Yield Warmup",
                "--viewer-title",
                "T39 Sparse-Yield Direct PPA Fronts",
            ]
        )
        == 0
    )

    assert (output_dir / "tables" / "t39_live_candidate_ppa_points.csv").is_file()
    assert (output_dir / "figures" / "t39_live_raw_area_power_fronts.png").is_file()
    html = (output_dir / "visualizations" / "direct_ppa_pareto" / "index.html").read_text(
        encoding="utf-8"
    )
    assert "T39 Sparse-Yield Direct PPA Fronts" in html
    assert "t39_live_raw_area_power_fronts.png" in html
