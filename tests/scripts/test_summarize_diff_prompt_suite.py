import json
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


def _write_result(run_dir: Path, payload: dict) -> None:
    run_dir.mkdir(parents=True, exist_ok=True)
    (run_dir / "results.json").write_text(json.dumps(payload), encoding="utf-8")


def test_summarize_writes_expected_artifacts(tmp_path):
    from scripts import summarize_diff_prompt_suite as summary

    root = tmp_path / "runs"
    _write_result(
        root / "20260101_000001",
        {
            "timestamp": "20260101_000001",
            "suite_name": "s",
            "model_name": "m",
            "api_backend": "vllm",
            "prompt_source": "p1",
            "prompt_sha256": "aaa111",
            "diff_apply_policy": "hybrid",
            "summary": {
                "objective_score": 0.72,
                "hard_pass_pct": 70.0,
                "format_ok_pct": 100.0,
                "apply_ok_pct": 80.0,
                "safe_reject_ok_pct": 10.0,
                "total_attempts": 10,
                "llm_usage": {"prompt_tokens": 100, "completion_tokens": 40},
                "reason_code_counts": {"strict_parse_error": 1},
                "by_case": {
                    "c1": {
                        "attempts": 5,
                        "hard_pass_rate": 0.8,
                        "apply_ok_rate": 0.8,
                        "safe_reject_rate": 0.0,
                        "objective_score_avg": 0.9,
                    }
                },
            },
        },
    )
    _write_result(
        root / "20260101_000002",
        {
            "timestamp": "20260101_000002",
            "suite_name": "s",
            "model_name": "m",
            "api_backend": "vllm",
            "prompt_source": "p2",
            "prompt_sha256": "bbb222",
            "diff_apply_policy": "hybrid",
            "summary": {
                "objective_score": 0.60,
                "hard_pass_pct": 50.0,
                "format_ok_pct": 90.0,
                "apply_ok_pct": 70.0,
                "safe_reject_ok_pct": 20.0,
                "total_attempts": 10,
                "llm_usage": {"prompt_tokens": 80, "completion_tokens": 30},
                "reason_code_counts": {"ambiguous_fuzzy_match": 2},
                "by_case": {
                    "c1": {
                        "attempts": 5,
                        "hard_pass_rate": 0.4,
                        "apply_ok_rate": 0.6,
                        "safe_reject_rate": 0.2,
                        "objective_score_avg": 0.5,
                    },
                    "c2": {
                        "attempts": 5,
                        "hard_pass_rate": 0.6,
                        "apply_ok_rate": 0.8,
                        "safe_reject_rate": 0.0,
                        "objective_score_avg": 0.7,
                    },
                },
            },
        },
    )

    payload = summary.summarize(root, root / "summary_out")
    assert payload["runs_analyzed"] == 2
    assert payload["run_leaderboard"][0]["prompt_sha256"] == "aaa111"
    assert payload["reason_code_counts"]["ambiguous_fuzzy_match"] == 2
    assert payload["reason_code_counts"]["strict_parse_error"] == 1

    out = root / "summary_out"
    assert (out / "summary.json").exists()
    assert (out / "summary.md").exists()
    assert (out / "runs.csv").exists()
    assert (out / "prompt_groups.csv").exists()
    assert (out / "case_stats.csv").exists()
    assert (out / "case_matrix.csv").exists()

    md = (out / "summary.md").read_text(encoding="utf-8")
    assert "Run Leaderboard" in md
    assert "Prompt Leaderboard" in md
    assert "Case Difficulty" in md


def test_summarize_ignores_skipped_runs(tmp_path):
    from scripts import summarize_diff_prompt_suite as summary

    root = tmp_path / "runs"
    _write_result(
        root / "skip",
        {
            "timestamp": "skip",
            "status": "skipped_unreachable_vllm",
            "warning": "timeout",
        },
    )
    _write_result(
        root / "ok",
        {
            "timestamp": "ok",
            "suite_name": "s",
            "summary": {
                "objective_score": 0.5,
                "hard_pass_pct": 50.0,
                "format_ok_pct": 80.0,
                "apply_ok_pct": 70.0,
                "safe_reject_ok_pct": 10.0,
                "total_attempts": 2,
                "llm_usage": {"prompt_tokens": 1, "completion_tokens": 1},
                "reason_code_counts": {},
                "by_case": {},
            },
            "prompt_sha256": "x",
            "prompt_source": "p",
        },
    )

    payload = summary.summarize(root, root / "summary_out")
    assert payload["runs_analyzed"] == 1
    assert payload["run_leaderboard"][0]["timestamp"] == "ok"

