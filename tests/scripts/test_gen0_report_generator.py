import json
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from scripts.gen0_report_generator import collate_summaries  # noqa: E402


def _make_best_candidate_dir(tmp_path: Path, benchmark: str, problem: str) -> Path:
    root = tmp_path / "model" / benchmark / problem / "Gen0" / "best_candidate"
    root.mkdir(parents=True, exist_ok=True)
    return root


def test_collate_summaries_parses_successful_metadata(tmp_path):
    best_dir = _make_best_candidate_dir(tmp_path, "Bench", "Prob001")
    metadata = {
        "score": 9.5,
        "evaluation": {
            "status": "completed",
            "simulation": {"status": "success"},
            "synthesis": {
                "synthesis_success": True,
                "synthesis_functionality_success": True,
                "ppa_success": True,
            },
            "ppa_metrics": {"area": 12.0, "power": 1.6e-3, "eff_clk_period": 0.42},
        },
    }
    (best_dir / "best_candidate_metadata.json").write_text(
        json.dumps(metadata), encoding="utf-8"
    )

    summaries = collate_summaries(tmp_path)
    assert len(summaries) == 1
    summary = summaries[0]
    assert summary.benchmark == "Bench"
    assert summary.problem == "Prob001"
    assert summary.score == 9.5
    assert summary.syntax_status == "pass"
    assert summary.functionality_status == "pass"
    assert summary.synthesis_status == "pass"
    assert summary.area == 12.0
    assert summary.power == 1.6e-3
    assert summary.eff_clk_period == 0.42


def test_collate_summaries_handles_failures_and_ppa_fallback(tmp_path):
    best_dir = _make_best_candidate_dir(tmp_path, "Bench", "Prob002")
    metadata = {
        "score": None,
        "evaluation": {
            "status": "simulation_failed",
            "simulation": {"status": "compilation_error"},
            "synthesis": {},
        },
    }
    (best_dir / "best_candidate_metadata.json").write_text(
        json.dumps(metadata), encoding="utf-8"
    )
    (best_dir / "best_candidate_synthesis_report.ppa").write_text(
        "tns,wns,eff_clk_period,power,area\n0,0,1.2,3.4,5.6\n", encoding="utf-8"
    )

    summaries = collate_summaries(tmp_path)
    assert len(summaries) == 1
    summary = summaries[0]
    assert summary.syntax_status == "fail"
    assert summary.functionality_status == "not_run"
    assert summary.synthesis_status == "not_run"
    # Fallback picks up the CSV file even when the metadata lacks PPA metrics
    assert summary.area == 5.6
    assert summary.power == 3.4
    assert summary.eff_clk_period == 1.2
