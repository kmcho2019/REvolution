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


def test_load_suite_default_has_expected_shape():
    from scripts import run_diff_prompt_suite as suite

    payload = suite.load_suite(suite.DEFAULT_SUITE_FILE)
    assert payload["suite_name"]
    assert len(payload["cases"]) >= 10
    assert all(isinstance(c["id"], str) and c["id"] for c in payload["cases"])


def test_main_skips_when_vllm_unreachable(monkeypatch, tmp_path):
    from scripts import run_diff_prompt_suite as suite

    monkeypatch.setattr(
        suite,
        "preflight_vllm_model",
        lambda **_kwargs: {
            "ok": False,
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": None,
            "max_model_len": None,
            "warning": "vLLM preflight failed for http://vllm:8888/v1/models: <urlopen error [Errno 111] Connection refused>",
        },
    )

    rc = suite.main(
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


def test_main_apply_success_case(monkeypatch, tmp_path):
    from scripts import run_diff_prompt_suite as suite

    suite_path = tmp_path / "suite.json"
    suite_path.write_text(
        json.dumps(
            {
                "suite_name": "test_suite",
                "version": 1,
                "cases": [
                    {
                        "id": "case_apply",
                        "description": "simple apply",
                        "file_to_edit": "/tmp/a.sv",
                        "original_file": "module m;\n  assign y = a & b;\nendmodule\n",
                        "change_request": "AND to OR",
                        "expected_behavior": "apply_success",
                        "must_contain": ["assign y = a | b;"],
                        "must_not_contain": ["assign y = a & b;"],
                        "safe_reject_reason_codes": [],
                    }
                ],
            }
        ),
        encoding="utf-8",
    )
    prompt_file = tmp_path / "prompt.txt"
    prompt_file.write_text("system prompt", encoding="utf-8")

    monkeypatch.setattr(
        suite,
        "preflight_vllm_model",
        lambda **_kwargs: {
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": "m",
            "max_model_len": 131072,
            "warning": None,
        },
    )

    class _FakeLLM:
        def __init__(self, **_kwargs):
            pass

        async def generate_response(self, **_kwargs):
            payload = json.dumps(
                {
                    "edits": [
                        {
                            "file": "/tmp/a.sv",
                            "hunks": [
                                {
                                    "search": "  assign y = a & b;\n",
                                    "replace": "  assign y = a | b;\n",
                                }
                            ],
                        }
                    ]
                }
            )
            return "t", payload, {"format_ok": True, "error": None, "parsed_mode": "diff", "raw": payload}

        async def get_and_reset_usage_stats(self):
            return {"api_calls": 2, "prompt_tokens": 20, "completion_tokens": 10}

    class _FakeApplier:
        def __init__(self, **_kwargs):
            self._last_diff_apply_diagnostics = {}

        def _apply_diff(self, original_code, diff_payload, target_file_path=None):
            self._last_diff_apply_diagnostics = {
                "phase": "json",
                "reason_code": None,
                "target_file_path": target_file_path,
            }
            _ = diff_payload
            return original_code.replace("assign y = a & b;", "assign y = a | b;")

    monkeypatch.setattr(suite, "LLMInterface", _FakeLLM)
    monkeypatch.setattr(suite, "_DiffPromptSuiteEngine", _FakeApplier)

    rc = suite.main(
        [
            "--model_name",
            "m",
            "--api_backend",
            "vllm",
            "--suite_file",
            str(suite_path),
            "--repeat_per_case",
            "2",
            "--system_prompt_file",
            str(prompt_file),
            "--save_root",
            str(tmp_path / "out"),
        ]
    )
    assert rc == 0
    payload = json.loads(_latest_results_json(tmp_path / "out").read_text(encoding="utf-8"))
    assert payload["summary"]["total_attempts"] == 2
    assert payload["summary"]["hard_pass_count"] == 2
    assert payload["summary"]["apply_ok_count"] == 2
    assert payload["summary"]["objective_score"] == 1.0


def test_main_apply_or_safe_reject_counts_safe_reject(monkeypatch, tmp_path):
    from scripts import run_diff_prompt_suite as suite

    suite_path = tmp_path / "suite.json"
    suite_path.write_text(
        json.dumps(
            {
                "suite_name": "safe_suite",
                "version": 1,
                "cases": [
                    {
                        "id": "case_safe",
                        "description": "ambiguous case",
                        "file_to_edit": "/tmp/a.sv",
                        "original_file": "module m;\n  assign y0 = a & b;\n  assign y1 = a & b;\nendmodule\n",
                        "change_request": "change one occurrence only",
                        "expected_behavior": "apply_or_safe_reject",
                        "must_contain": [],
                        "must_not_contain": [],
                        "safe_reject_reason_codes": ["ambiguous_fuzzy_match"],
                    }
                ],
            }
        ),
        encoding="utf-8",
    )
    prompt_file = tmp_path / "prompt.txt"
    prompt_file.write_text("system prompt", encoding="utf-8")

    monkeypatch.setattr(
        suite,
        "preflight_vllm_model",
        lambda **_kwargs: {
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": "m",
            "max_model_len": 131072,
            "warning": None,
        },
    )

    class _FakeLLM:
        def __init__(self, **_kwargs):
            pass

        async def generate_response(self, **_kwargs):
            payload = json.dumps(
                {
                    "edits": [
                        {
                            "file": "/tmp/a.sv",
                            "hunks": [
                                {
                                    "search": "assign y0 = a & b;\n",
                                    "replace": "assign y0 = a | b;\n",
                                }
                            ],
                        }
                    ]
                }
            )
            return "t", payload, {"format_ok": True, "error": None, "parsed_mode": "diff", "raw": payload}

        async def get_and_reset_usage_stats(self):
            return {"api_calls": 1, "prompt_tokens": 5, "completion_tokens": 5}

    class _FakeApplier:
        def __init__(self, **_kwargs):
            self._last_diff_apply_diagnostics = {}

        def _apply_diff(self, _original_code, _diff_payload, target_file_path=None):
            self._last_diff_apply_diagnostics = {
                "phase": "fuzzy",
                "reason_code": "ambiguous_fuzzy_match",
                "target_file_path": target_file_path,
            }
            return None

    monkeypatch.setattr(suite, "LLMInterface", _FakeLLM)
    monkeypatch.setattr(suite, "_DiffPromptSuiteEngine", _FakeApplier)

    rc = suite.main(
        [
            "--model_name",
            "m",
            "--api_backend",
            "vllm",
            "--suite_file",
            str(suite_path),
            "--system_prompt_file",
            str(prompt_file),
            "--save_root",
            str(tmp_path / "out"),
        ]
    )
    assert rc == 0
    payload = json.loads(_latest_results_json(tmp_path / "out").read_text(encoding="utf-8"))
    assert payload["summary"]["apply_ok_count"] == 0
    assert payload["summary"]["safe_reject_ok_count"] == 1
    assert payload["summary"]["hard_pass_count"] == 1
    assert payload["summary"]["reason_code_counts"]["ambiguous_fuzzy_match"] == 1
