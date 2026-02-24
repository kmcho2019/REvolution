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


def test_main_skips_when_vllm_unreachable(monkeypatch, tmp_path):
    from scripts import run_diff_mode_diagnostics as diag

    monkeypatch.setattr(
        diag,
        "preflight_vllm_model",
        lambda **_kwargs: {
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": None,
            "max_model_len": None,
            "warning": "Unable to reach vLLM at http://vllm:8888/v1/models: timeout",
        },
    )

    rc = diag.main(
        [
            "--model_name",
            "m",
            "--api_backend",
            "vllm",
            "--save_root",
            str(tmp_path / "out"),
        ]
    )
    assert rc == 0
    payload = json.loads(_latest_results_json(tmp_path / "out").read_text(encoding="utf-8"))
    assert payload["status"] == "skipped_unreachable_vllm"


def test_main_collects_attempts_with_mocked_llm_and_applier(monkeypatch, tmp_path):
    from scripts import run_diff_mode_diagnostics as diag

    monkeypatch.setattr(
        diag,
        "preflight_vllm_model",
        lambda **_kwargs: {
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": "m",
            "max_model_len": 131072,
            "warning": None,
        },
    )

    captured_system_prompts = []

    class _FakeLLM:
        def __init__(self, **_kwargs):
            pass

        async def generate_response(self, **_kwargs):
            captured_system_prompts.append(_kwargs.get("system_prompt_override"))
            payload = json.dumps(
                {
                    "format": "eoh_v1",
                    "mode": "diff",
                    "thought": "t",
                    "code": {
                        "edits": [
                            {
                                "file": "/tmp/f.sv",
                                "hunks": [{"search": "x\n", "replace": "y\n"}],
                            }
                        ]
                    },
                }
            )
            return "t", payload, {"format_ok": True, "error": None, "parsed_mode": "diff"}

        async def get_and_reset_usage_stats(self):
            return {"api_calls": 1, "prompt_tokens": 2, "completion_tokens": 3}

    class _FakeApplier:
        def __init__(self, **_kwargs):
            self._last_diff_apply_diagnostics = {"phase": "json", "reason_code": None}

        def _apply_diff(self, _original, _diff, target_file_path=None):
            self._last_diff_apply_diagnostics = {
                "phase": "json",
                "reason_code": None,
                "target_file_path": target_file_path,
            }
            return "applied"

    monkeypatch.setattr(diag, "LLMInterface", _FakeLLM)
    monkeypatch.setattr(diag, "_DiffDiagnosticsEngine", _FakeApplier)

    rc = diag.main(
        [
            "--model_name",
            "m",
            "--api_backend",
            "vllm",
            "--repeat_per_case",
            "1",
            "--save_root",
            str(tmp_path / "out"),
        ]
    )
    assert rc == 0
    payload = json.loads(_latest_results_json(tmp_path / "out").read_text(encoding="utf-8"))
    assert payload["summary"]["total_attempts"] == 6
    assert payload["summary"]["format_ok"] == 6
    assert payload["summary"]["apply_ok"] == 6
    assert captured_system_prompts
    assert all(isinstance(p, str) and p.strip() for p in captured_system_prompts)
