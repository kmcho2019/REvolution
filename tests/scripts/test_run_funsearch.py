import sys
from pathlib import Path


def test_run_funsearch_delegates_to_run_backend_with_funsearch_backend(monkeypatch):
    project_root = Path(__file__).resolve().parents[2]
    monkeypatch.syspath_prepend(str(project_root / "scripts"))
    from scripts import run_funsearch

    captured: dict[str, list[str]] = {}

    def fake_main(argv):
        captured["argv"] = list(argv)
        return 23

    monkeypatch.setattr(run_funsearch, "run_backend_main", fake_main)
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "run_funsearch.py",
            "--benchmarks",
            "RTLLM",
            "--total_worker_slots",
            "3",
            "--max_workers_per_problem",
            "2",
        ],
    )

    result = run_funsearch.main()

    assert result == 23
    assert captured["argv"] == [
        "--backend",
        "funsearch",
        "--benchmarks",
        "RTLLM",
        "--total_worker_slots",
        "3",
        "--max_workers_per_problem",
        "2",
    ]
