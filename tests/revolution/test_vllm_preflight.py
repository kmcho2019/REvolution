import io
import json
from urllib.error import URLError

from revolution.vllm_preflight import (
    build_vllm_models_url,
    fetch_vllm_model_info,
    preflight_vllm_model,
)


class _FakeResp:
    def __init__(self, payload: dict):
        self._buf = io.BytesIO(json.dumps(payload).encode("utf-8"))

    def read(self) -> bytes:
        return self._buf.read()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc, tb):
        return False


def test_build_vllm_models_url_normalizes_host_and_v1_suffix():
    assert build_vllm_models_url("vllm", 8888) == "http://vllm:8888/v1/models"
    assert build_vllm_models_url("http://vllm:8888", 9999) == "http://vllm:8888/v1/models"
    assert build_vllm_models_url("http://vllm:8888/v1", 9999) == "http://vllm:8888/v1/models"


def test_fetch_vllm_model_info_reads_max_model_len(monkeypatch):
    def fake_urlopen(url, timeout):
        assert url == "http://vllm:8888/v1/models"
        assert timeout == 3.0
        return _FakeResp(
            {
                "data": [
                    {
                        "id": "m",
                        "max_model_len": "131072",
                    }
                ]
            }
        )

    monkeypatch.setattr("revolution.vllm_preflight.urlopen", fake_urlopen)
    info = fetch_vllm_model_info("vllm", 8888, timeout_s=3.0)
    assert info["ok"] is True
    assert info["model_id"] == "m"
    assert info["max_model_len"] == 131072


def test_fetch_vllm_model_info_falls_back_to_context_length(monkeypatch):
    monkeypatch.setattr(
        "revolution.vllm_preflight.urlopen",
        lambda *_args, **_kwargs: _FakeResp(
            {
                "data": [
                    {
                        "id": "m2",
                        "context_length": 64000,
                    }
                ]
            }
        ),
    )
    info = fetch_vllm_model_info("vllm", 8888)
    assert info["ok"] is True
    assert info["max_model_len"] == 64000


def test_fetch_vllm_model_info_reports_transport_error(monkeypatch):
    def boom(*_args, **_kwargs):
        raise URLError("down")

    monkeypatch.setattr("revolution.vllm_preflight.urlopen", boom)
    info = fetch_vllm_model_info("vllm", 8888)
    assert info["ok"] is False
    assert "down" in (info["error"] or "")


def test_preflight_vllm_model_flags_short_context(monkeypatch):
    monkeypatch.setattr(
        "revolution.vllm_preflight.fetch_vllm_model_info",
        lambda *_args, **_kwargs: {
            "ok": True,
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": "m",
            "max_model_len": 32000,
            "error": None,
        },
    )
    out = preflight_vllm_model("vllm", 8888, min_model_len=128000)
    assert out["meets_min_model_len"] is False
    assert "below recommended threshold" in (out["warning"] or "")

