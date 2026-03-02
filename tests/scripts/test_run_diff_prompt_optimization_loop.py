import json
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


def _latest_results_json(root: Path) -> Path:
    candidates = sorted(root.glob("*/results.json"))
    assert candidates
    return candidates[-1]


def _arg_value(argv: list[str], flag: str) -> str:
    idx = argv.index(flag)
    return argv[idx + 1]


def test_main_ranks_candidates_by_objective_score(monkeypatch, tmp_path):
    from scripts import run_diff_prompt_optimization_loop as loop

    p1 = tmp_path / "p1.txt"
    p2 = tmp_path / "p2.txt"
    p1.write_text("prompt-1", encoding="utf-8")
    p2.write_text("prompt-2", encoding="utf-8")

    state = {"n": 0}

    def _fake_suite_main(argv: list[str]) -> int:
        state["n"] += 1
        save_root = Path(_arg_value(argv, "--save_root"))
        out = save_root / f"20260101_00000{state['n']}"
        out.mkdir(parents=True, exist_ok=True)

        prompt_file = _arg_value(argv, "--system_prompt_file")
        score = 0.9 if prompt_file.endswith("p2.txt") else 0.4
        payload = {
            "timestamp": out.name,
            "summary": {
                "objective_score": score,
                "hard_pass_pct": score * 100.0,
                "total_attempts": 6,
            },
        }
        (out / "results.json").write_text(json.dumps(payload), encoding="utf-8")
        return 0

    monkeypatch.setattr(loop.suite_runner, "main", _fake_suite_main)

    rc = loop.main(
        [
            "--model_name",
            "m",
            "--api_backend",
            "vllm",
            "--no-include_profile_prompt",
            "--system_prompt_files",
            str(p1),
            str(p2),
            "--save_root",
            str(tmp_path / "out"),
        ]
    )
    assert rc == 0
    payload = json.loads(_latest_results_json(tmp_path / "out").read_text(encoding="utf-8"))
    assert payload["counts"]["total"] == 2
    assert payload["counts"]["ok"] == 2
    assert payload["best_candidate"]["prompt_path"].endswith("p2.txt")
    assert payload["best_candidate"]["objective_score"] == 0.9


def test_main_handles_all_skipped_candidates(monkeypatch, tmp_path):
    from scripts import run_diff_prompt_optimization_loop as loop

    p1 = tmp_path / "p1.txt"
    p1.write_text("prompt-1", encoding="utf-8")

    def _fake_suite_main(argv: list[str]) -> int:
        save_root = Path(_arg_value(argv, "--save_root"))
        out = save_root / "20260101_000001"
        out.mkdir(parents=True, exist_ok=True)
        payload = {
            "timestamp": out.name,
            "status": "skipped_unreachable_vllm",
            "warning": "connection refused",
        }
        (out / "results.json").write_text(json.dumps(payload), encoding="utf-8")
        return 0

    monkeypatch.setattr(loop.suite_runner, "main", _fake_suite_main)

    rc = loop.main(
        [
            "--model_name",
            "m",
            "--api_backend",
            "vllm",
            "--no-include_profile_prompt",
            "--system_prompt_files",
            str(p1),
            "--save_root",
            str(tmp_path / "out"),
        ]
    )
    assert rc == 0
    payload = json.loads(_latest_results_json(tmp_path / "out").read_text(encoding="utf-8"))
    assert payload["counts"]["total"] == 1
    assert payload["counts"]["skipped"] == 1
    assert payload["best_candidate"] is None
    assert payload["candidates"][0]["status"] == "skipped_unreachable_vllm"
