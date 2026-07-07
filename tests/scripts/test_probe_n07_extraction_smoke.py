from __future__ import annotations

import json
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

import scripts.probe_n07_extraction_smoke as smoke  # noqa: E402


class FakeEvaluator:
    def __init__(self, *, include_rf_timing: bool) -> None:
        assert include_rf_timing is True

    def extract_metrics(
        self,
        *,
        code_file_path: str | Path,
        top_module_name: str | None,
    ) -> dict[str, float]:
        index = int(Path(code_file_path).stem.removeprefix("p")) + 1
        return {
            "source_aligned_rf_timing_leaf_rows": float(index),
            "source_aligned_rf_timing_path_count": float(index + 8),
            "source_aligned_masterrtl_branching": float(index) / 10.0,
        }


def test_n07_extraction_smoke_writes_health(monkeypatch, tmp_path):
    refs = []
    for index in range(8):
        path = tmp_path / f"p{index}.sv"
        path.write_text(f"module p{index}; endmodule\n", encoding="utf-8")
        refs.append(("RTLLM", f"Prob{index:03d}", str(path)))
    monkeypatch.setattr(smoke, "SCREEN_REFS", tuple(refs))
    monkeypatch.setattr(smoke, "SourceAlignedRTLDescriptorEvaluator", FakeEvaluator)

    rc = smoke.main(["--output-dir", str(tmp_path / "out")])

    assert rc == 0
    summary = json.loads((tmp_path / "out" / "extraction_smoke_summary.json").read_text())
    assert summary["status"] == "pass"
    assert summary["requirements"]["requires_ppa"] is False
    assert summary["input_count"] == 8
    assert summary["descriptor_health"]["initialized"] is True
    assert (tmp_path / "out" / "descriptor_health.json").is_file()
    assert (tmp_path / "out" / "descriptor_health_report.md").is_file()
