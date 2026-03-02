from __future__ import annotations

import json
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.request import urlopen


def _coerce_int(value: Any) -> int | None:
    if isinstance(value, bool):
        return None
    if isinstance(value, int):
        return value
    if isinstance(value, float):
        return int(value)
    if isinstance(value, str):
        txt = value.strip()
        if not txt:
            return None
        try:
            return int(txt)
        except ValueError:
            return None
    return None


def build_vllm_models_url(host: str, port: int) -> str:
    normalized = (host or "localhost").strip()
    if normalized.startswith(("http://", "https://")):
        base = normalized.rstrip("/")
        if not base.endswith("/v1"):
            base = f"{base}/v1"
        return f"{base}/models"
    return f"http://{normalized}:{port}/v1/models"


def fetch_vllm_model_info(host: str, port: int, timeout_s: float = 5.0) -> dict[str, Any]:
    """
    Query a vLLM OpenAI-compatible /v1/models endpoint and return normalized metadata.
    """
    endpoint = build_vllm_models_url(host, port)
    try:
        with urlopen(endpoint, timeout=timeout_s) as resp:  # nosec: B310 trusted local endpoint
            payload = json.loads(resp.read().decode("utf-8"))
    except (HTTPError, URLError, TimeoutError, json.JSONDecodeError) as exc:
        return {
            "ok": False,
            "endpoint": endpoint,
            "model_id": None,
            "max_model_len": None,
            "error": str(exc),
        }

    models = payload.get("data")
    if not isinstance(models, list) or not models:
        return {
            "ok": False,
            "endpoint": endpoint,
            "model_id": None,
            "max_model_len": None,
            "error": "models endpoint returned no model entries",
        }

    first = models[0] if isinstance(models[0], dict) else {}
    model_id = first.get("id")
    max_model_len = _coerce_int(first.get("max_model_len"))
    if max_model_len is None:
        # Some compatible servers may use alternate field names.
        max_model_len = _coerce_int(first.get("context_length"))

    return {
        "ok": True,
        "endpoint": endpoint,
        "model_id": model_id,
        "max_model_len": max_model_len,
        "error": None,
    }


def preflight_vllm_model(
    host: str,
    port: int,
    min_model_len: int = 128000,
    timeout_s: float = 5.0,
) -> dict[str, Any]:
    """
    Execute a lightweight vLLM preflight and evaluate max context length requirements.
    """
    info = fetch_vllm_model_info(host, port, timeout_s=timeout_s)
    if not info["ok"]:
        info["meets_min_model_len"] = None
        info["warning"] = (
            f"vLLM preflight failed for {info['endpoint']}: {info['error']}"
        )
        return info

    max_model_len = info.get("max_model_len")
    if max_model_len is None:
        info["meets_min_model_len"] = None
        info["warning"] = (
            "vLLM preflight could not determine max_model_len from /v1/models."
        )
        return info

    meets = max_model_len >= int(min_model_len)
    info["meets_min_model_len"] = meets
    info["warning"] = None
    if not meets:
        info["warning"] = (
            f"Served model max_model_len={max_model_len} is below recommended "
            f"threshold {int(min_model_len)}."
        )
    return info


def is_unreachable_preflight(info: dict[str, Any]) -> bool:
    """
    Return True when preflight indicates endpoint reachability failure.

    This intentionally does not treat low max_model_len warnings as
    unreachable because those cases still have a reachable endpoint and should
    proceed unless caller decides otherwise.
    """
    if info.get("ok") is False:
        return True

    warning = str(info.get("warning") or "").lower()
    if not warning:
        return False

    if "below recommended threshold" in warning:
        return False

    if info.get("model_id") is not None:
        return False

    markers = (
        "unable to reach vllm",
        "preflight failed",
        "<urlopen error",
        "connection refused",
        "name or service not known",
        "temporary failure in name resolution",
        "timed out",
    )
    return any(marker in warning for marker in markers)
