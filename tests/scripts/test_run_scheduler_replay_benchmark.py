from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "run_scheduler_replay_benchmark.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "run_scheduler_replay_benchmark", _SCRIPT_PATH
)
assert _SPEC is not None and _SPEC.loader is not None
run_scheduler_replay_benchmark = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("run_scheduler_replay_benchmark", run_scheduler_replay_benchmark)
_SPEC.loader.exec_module(run_scheduler_replay_benchmark)


def test_default_workload_is_seed_deterministic():
    first = run_scheduler_replay_benchmark.build_default_workload(42)
    second = run_scheduler_replay_benchmark.build_default_workload(42)
    other = run_scheduler_replay_benchmark.build_default_workload(7)

    assert first == second
    assert first != other
    assert len(first["problems"]) == 8


def test_replay_modes_produce_identical_outcomes(tmp_path):
    # Tiny scale keeps the smoke fast; the assertion is outcome equality and
    # report shape, not the timing-dependent improvement percentage.
    output = tmp_path / "report.json"
    code = run_scheduler_replay_benchmark.main(
        [
            "--scale",
            "0.002",
            "--total-worker-slots",
            "8",
            "--gate-percent",
            "-1000",
            "--output",
            str(output),
        ]
    )

    assert code == 0
    report = json.loads(output.read_text(encoding="utf-8"))
    assert report["outcomes_match"] is True
    assert report["fixed"]["outcome_digest"] == report["elastic"]["outcome_digest"]
    assert report["fixed"]["outcome_count"] == report["elastic"]["outcome_count"] > 0
    telemetry = report["elastic"]["telemetry"]
    assert telemetry is not None
    assert telemetry["total_worker_slots"] == 8
    assert telemetry["problems"]
