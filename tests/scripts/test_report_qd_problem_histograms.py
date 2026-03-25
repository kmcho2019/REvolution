import json
import os
import subprocess
from pathlib import Path


def _write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload), encoding="utf-8")


def test_report_qd_problem_histograms_generates_per_problem_outputs(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_qd_problem_histograms.py"

    problem_root = (
        tmp_path
        / "exp"
        / "cvt_backend"
        / "RTLLM"
        / "Prob024_fsm"
    )
    _write_json(
        problem_root / "archive_space.json",
        {
            "archive_type": "cvt",
            "axes": ["sequential_cells", "g_P"],
        },
    )
    _write_json(
        problem_root / "centroids.json",
        {
            "archive_type": "cvt",
            "axes": ["sequential_cells", "g_P"],
            "initialized": True,
            "warmup_successes": 2,
            "centroids": [
                [-1.0, -0.6],
                [-0.2, 0.0],
                [0.4, 0.2],
                [1.0, 0.6],
            ],
            "scaler": {
                "means": [10.0, 0.2],
                "stds": [2.0, 0.1],
            },
        },
    )
    (problem_root / "archive_history.jsonl").write_text(
        "\n".join(
            json.dumps({"generation": generation, "coverage": 0.1 * generation})
            for generation in range(3)
        )
        + "\n",
        encoding="utf-8",
    )

    events = [
        ("gen0_a", 0, "warmup_buffered", {"sequential_cells": 8.0, "g_P": 0.14}),
        ("gen1_a", 1, "filled_empty", {"sequential_cells": 9.2, "g_P": 0.18}),
        ("gen1_b", 1, "filled_empty", {"sequential_cells": 10.6, "g_P": 0.22}),
        ("gen2_a", 2, "replaced_elite", {"sequential_cells": 11.8, "g_P": 0.26}),
    ]
    for candidate_id, generation, decision, descriptor_values in events:
        _write_json(
            problem_root
            / f"Gen{generation}"
            / f"Prob024_fsm_{candidate_id}"
            / "qd_archive_event.json",
            {
                "candidate_id": candidate_id,
                "generation": generation,
                "quality_score": 0.5,
                "descriptor_values": descriptor_values,
                "decision": decision,
            },
        )

    env = os.environ.copy()
    env["MPLBACKEND"] = "Agg"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--run-root",
            str(tmp_path / "exp"),
            "--bins",
            "8",
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    output_dir = problem_root / "qd_feature_histograms"
    assert (output_dir / "final_feature_histograms.png").is_file()
    assert (output_dir / "historical_feature_histograms.png").is_file()
    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))
    assert summary["archive_type"] == "cvt"
    assert summary["success_count"] == 4
    assert summary["generation_count"] == 3
    assert summary["centroid_count"] == 4
    assert summary["initialization_generation"] == 1
    assert summary["histogram_bins"] == 8
    assert summary["axes"][0]["name"] == "sequential_cells"
    assert summary["axes"][0]["division_count"] == 3
    assert summary["axes"][1]["name"] == "g_P"
    assert "\"processed_problem_count\": 1" in result.stdout
