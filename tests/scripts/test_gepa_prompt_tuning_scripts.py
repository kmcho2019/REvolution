from __future__ import annotations

import json
import sys
from pathlib import Path

from scripts.report_gepa_prompt_tuning import main as report_main
from scripts.run_gepa_prompt_tuning import _parse_args, run_campaign


def _write_profile(root: Path) -> None:
    for key in (
        "system/thought_spec",
        "thought_only/generate_thought",
        "thought_only/code/whole",
        "evolve/single_thought_operator/thought",
        "thought_only/repair/whole",
    ):
        path = root / "journal_thought_only" / f"{key}.txt"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(f"{key} seed prompt\n", encoding="utf-8")


def _write_fake_evaluator(path: Path) -> None:
    path.write_text(
        """
from __future__ import annotations

import argparse
import json
from pathlib import Path

PROBLEMS = (
    ("RTLLM", "Prob015_multi_pipe_8bit"),
    ("RTLLM", "Prob045_alu"),
    ("VerilogEval-Spec-to-RTL", "Prob116_m2014_q3"),
    ("VerilogEval-Spec-to-RTL", "Prob153_gshare"),
)

parser = argparse.ArgumentParser()
parser.add_argument("--run-root", type=Path, required=True)
args = parser.parse_args()
for benchmark, problem in PROBLEMS:
    root = args.run_root / benchmark / problem
    thought_root = root / "Gen0" / "g000_thought_0001"
    thought_root.mkdir(parents=True, exist_ok=True)
    summary = {
        "benchmark_name": benchmark,
        "problem_name": problem,
        "accumulated_success_rates": {"functionality": 0.5, "synthesis_ppa": 0.25},
        "final_population_ppa": {
            "average_score": 0.4,
            "best_metrics": {"area": 90.0, "power": 0.9},
        },
        "final_population_ppa_details": [
            {"id": "sample_0", "score": 0.4, "ppa_metrics": {"area": 90.0, "power": 0.9}}
        ],
        "ref_ppa_metric": {"area": 100.0, "power": 1.0},
        "worker_errors": [],
    }
    (root / f"{problem}_summary.json").write_text(json.dumps(summary), encoding="utf-8")
    (root / "archive_summary.json").write_text(
        json.dumps({"coverage": 0.25, "occupied_cells": 2, "qd_score": 1.5}),
        encoding="utf-8",
    )
    (thought_root / "thought_evaluation.json").write_text(
        json.dumps({
            "aggregate_status": "partial_success",
            "code_samples_per_thought": 4,
            "sample_records": [],
        }),
        encoding="utf-8",
    )
""".strip()
        + "\n",
        encoding="utf-8",
    )


def test_gepa_runner_fake_evaluator_and_report(tmp_path, monkeypatch):
    monkeypatch.setenv("OPENAI_API_KEY", "test-key")
    prompt_root = tmp_path / "prompts"
    save_root = tmp_path / "campaigns"
    _write_profile(prompt_root)
    fake_eval = tmp_path / "fake_eval.py"
    _write_fake_evaluator(fake_eval)

    args = _parse_args(
        [
            "--prompt-root",
            str(prompt_root),
            "--save-root",
            str(save_root),
            "--max-metric-calls",
            "1",
            "--evaluator-command",
            f"{sys.executable} {fake_eval} --run-root {{run_root}}",
        ]
    )
    payload = run_campaign(args)
    campaign_root = Path(payload["campaign_root"])

    assert (campaign_root / "campaign.json").is_file()
    assert (campaign_root / "campaign.md").is_file()
    assert (prompt_root / "journal_thought_only_gepa").is_dir()
    assert payload["selected_candidate"]["bundle_hash"]

    assert report_main(["--campaign-root", str(campaign_root)]) == 0
    summary = json.loads((campaign_root / "summary.json").read_text(encoding="utf-8"))
    assert summary["candidate_count"] == 1
    assert summary["candidates"][0]["status"] == "ok"
