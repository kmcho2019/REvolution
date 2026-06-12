from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

spec = importlib.util.spec_from_file_location(
    "report_tool_provenance",
    Path(__file__).resolve().parents[2] / "scripts" / "report_tool_provenance.py",
)
assert spec and spec.loader
rtp = importlib.util.module_from_spec(spec)
sys.modules["report_tool_provenance"] = rtp
spec.loader.exec_module(rtp)


def test_provenance_artifact_records_required_fields(tmp_path):
    out = tmp_path / "prov.json"

    rc = rtp.main(["--output", str(out)])

    assert rc == 0
    payload = json.loads(out.read_text(encoding="utf-8"))
    assert payload["git_commit"]
    assert payload["python"]
    for name in ("iverilog", "verilator", "yosys"):
        assert name in payload["binaries"]
    assert "openai" in payload["packages"]


def test_missing_binary_is_recorded_not_fatal(monkeypatch):
    version = rtp.binary_version(["definitely_not_a_real_binary_xyz"])
    assert "unavailable" in version
