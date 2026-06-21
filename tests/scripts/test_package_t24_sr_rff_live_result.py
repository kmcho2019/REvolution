from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_t24_sr_rff_live_result import main


def test_package_t24_sr_family_live_result(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    output_dir = tmp_path / "package" / "tables"
    for problem in ("Prob045_alu", "Prob041_traffic_light", "Prob015_multi_pipe_8bit"):
        _write_problem(
            run_root=run_root,
            mode="classic_revolution/seed_1001/openai_gpt-oss-120b",
            problem=problem,
            best_score=1.0,
            synthesis_rate=0.5,
        )
        _write_problem(
            run_root=run_root,
            mode="sr_rff_pca_qd/seed_1001/openai_gpt-oss-120b",
            problem=problem,
            best_score=1.25,
            synthesis_rate=0.75,
            archive_members=3,
            global_pareto_members=2,
        )
        _write_problem(
            run_root=run_root,
            mode="sr_random_relu_pca_qd/seed_1001/openai_gpt-oss-120b",
            problem=problem,
            best_score=0.75,
            synthesis_rate=0.25,
            archive_members=4,
            global_pareto_members=5,
        )

    assert main(["--run-root", str(run_root), "--output-dir", str(output_dir)]) == 0

    family_csv = output_dir / "live_sr_family_vs_classic.csv"
    rff_csv = output_dir / "live_sr_rff_vs_classic.csv"
    family_figure = output_dir.parent / "figures" / "live_sr_family_vs_classic.png"
    rff_figure = output_dir.parent / "figures" / "live_sr_rff_vs_classic.png"
    rows = list(csv.DictReader(family_csv.read_text(encoding="utf-8").splitlines()))
    assert len(rows) == 6
    assert rows[0]["arm"] == "sr_rff_pca_qd"
    assert rows[0]["best_score_delta"] == "0.250000"
    assert rows[0]["archive_members"] == "3"
    assert rows[3]["arm"] == "sr_random_relu_pca_qd"
    assert rows[3]["best_score_delta"] == "-0.250000"
    assert rows[3]["global_pareto_members"] == "5"
    assert len(list(csv.DictReader(rff_csv.read_text(encoding="utf-8").splitlines()))) == 3
    assert family_figure.stat().st_size > 0
    assert rff_figure.stat().st_size > 0


def _write_problem(
    *,
    run_root: Path,
    mode: str,
    problem: str,
    best_score: float,
    synthesis_rate: float,
    archive_members: int | None = None,
    global_pareto_members: int | None = None,
) -> None:
    problem_root = run_root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps(
            {
                "final_population_ppa": {"best_score": best_score},
                "accumulated_success_rates": {
                    "functionality": synthesis_rate,
                    "synthesis_ppa": synthesis_rate,
                },
            }
        ),
        encoding="utf-8",
    )
    if archive_members is None:
        return
    assert global_pareto_members is not None
    (problem_root / "archive_summary.json").write_text(
        json.dumps(
            {
                "occupied_cells": 2,
                "total_archive_members": archive_members,
                "max_front_size": 2,
            }
        ),
        encoding="utf-8",
    )
    (problem_root / "global_pareto_summary.json").write_text(
        json.dumps({"total_global_pareto_members": global_pareto_members}),
        encoding="utf-8",
    )
