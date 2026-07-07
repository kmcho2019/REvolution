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
            "source_aligned_rf_timing_leaf_ids": float(index + 2),
            "source_aligned_rf_timing_path_count": float(index + 8),
            "source_aligned_masterrtl_branching": float(index) / 10.0,
        }


class FakeDeepGateEvaluator:
    def __init__(self, artifact_path: Path) -> None:
        assert artifact_path.name == "projection.json"

    def extract_metrics(
        self,
        *,
        code_file_path: str | Path,
        top_module_name: str,
    ) -> dict[str, float]:
        assert top_module_name == "RefModule"
        index = int(Path(code_file_path).stem.removeprefix("p")) + 1
        return {"deepgate_pool_pc0": float(index) / 10.0}


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
    assert len(summary["problem_counts"]) == 8
    assert summary["descriptor_health"]["initialized"] is True
    assert (tmp_path / "out" / "descriptor_health.json").is_file()
    assert (tmp_path / "out" / "descriptor_health_report.md").is_file()


def test_n07_rf_deepgate_smoke_combines_metrics(monkeypatch, tmp_path):
    refs = []
    for index in range(8):
        path = tmp_path / f"p{index}.sv"
        path.write_text(f"module p{index}; endmodule\n", encoding="utf-8")
        refs.append(("RTLLM", f"Prob{index:03d}", str(path)))
    monkeypatch.setattr(smoke, "SCREEN_REFS", tuple(refs))
    monkeypatch.setattr(smoke, "SourceAlignedRTLDescriptorEvaluator", FakeEvaluator)
    monkeypatch.setattr(smoke, "DeepGatePooledDescriptorEvaluator", FakeDeepGateEvaluator)
    monkeypatch.setattr(
        smoke,
        "load_deepgate_projection_artifact_path",
        lambda path: tmp_path / "projection.json",
    )

    rc = smoke.main(
        [
            "--profile",
            "rf_deepgate_hybrid_3d",
            "--output-dir",
            str(tmp_path / "out"),
        ]
    )

    summary = json.loads((tmp_path / "out" / "extraction_smoke_summary.json").read_text())
    assert rc == 0
    assert summary["profile"] == "rf_deepgate_hybrid_3d"
    assert summary["requirements"]["requires_deepgate_pooled_embedding"] is True
    assert summary["input_count"] == 8
    assert summary["descriptor_health"]["initialized"] is True


def test_n07_structural_smoke_uses_existing_metrics(monkeypatch, tmp_path):
    refs = []
    metrics_root = tmp_path / "metrics"
    for index in range(8):
        benchmark = "RTLLM"
        problem = f"Prob{index:03d}"
        refs.append((benchmark, problem, f"unused_{index}.sv"))
        sample_dir = metrics_root / benchmark / problem / "Gen0" / f"s{index}"
        sample_dir.mkdir(parents=True)
        (sample_dir / "code_synthesis_report.metrics.json").write_text(
            json.dumps(
                {
                    "structural_metrics": {
                        "comb_ratio": 0.5 + index * 0.01,
                        "adder_ratio": index * 0.01,
                        "cell_count_log": index + 1,
                    }
                }
            ),
            encoding="utf-8",
        )
    monkeypatch.setattr(smoke, "SCREEN_REFS", tuple(refs))
    monkeypatch.setattr(smoke, "V2_ANCHOR_METRICS_ROOT", metrics_root)

    rc = smoke.main(
        [
            "--profile",
            "implemented_structural_compact_3d",
            "--output-dir",
            str(tmp_path / "out"),
        ]
    )

    summary = json.loads((tmp_path / "out" / "extraction_smoke_summary.json").read_text())
    assert rc == 0
    assert summary["profile"] == "implemented_structural_compact_3d"
    assert summary["requirements"]["requires_synthesis"] is True
    assert summary["input_count"] == 8
    assert len(summary["problem_counts"]) == 8
    assert summary["descriptor_health"]["initialized"] is True
