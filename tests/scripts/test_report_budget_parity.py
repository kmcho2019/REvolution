from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

spec = importlib.util.spec_from_file_location(
    "report_budget_parity",
    Path(__file__).resolve().parents[2] / "scripts" / "report_budget_parity.py",
)
assert spec and spec.loader
report_budget_parity = importlib.util.module_from_spec(spec)
sys.modules["report_budget_parity"] = report_budget_parity
spec.loader.exec_module(report_budget_parity)


def _write_summary(root: Path, problem: str, calls: int, prompt: int, completion: int):
    pdir = root / "model" / "bench" / problem
    pdir.mkdir(parents=True)
    (pdir / f"{problem}_summary.json").write_text(
        json.dumps(
            {
                "total_llm_api_calls": calls,
                "total_llm_prompt_tokens": prompt,
                "total_llm_completion_tokens": completion,
            }
        ),
        encoding="utf-8",
    )


def test_parity_verdict_within_tolerance(tmp_path):
    classic, variant = tmp_path / "classic", tmp_path / "variant"
    _write_summary(classic, "Prob001_a", 100, 1000, 2000)
    _write_summary(variant, "Prob001_a", 105, 1050, 2100)

    report = report_budget_parity.build_report(classic, variant)

    assert report["verdict"] == "PARITY"
    assert report["aggregate"]["total_llm_api_calls"]["ratio"] == 1.05


def test_confounded_verdict_and_unpaired_listing(tmp_path):
    classic, variant = tmp_path / "classic", tmp_path / "variant"
    _write_summary(classic, "Prob001_a", 100, 1000, 2000)
    _write_summary(classic, "Prob002_b", 100, 1000, 2000)
    _write_summary(variant, "Prob001_a", 130, 1000, 3000)

    report = report_budget_parity.build_report(classic, variant)

    assert report["verdict"] == "CONFOUNDED"
    assert report["unpaired_classic"] == ["Prob002_b"]
    assert report["aggregate"]["total_llm_completion_tokens"]["within_tolerance"] is False


def test_main_writes_artifacts(tmp_path, capsys):
    classic, variant = tmp_path / "classic", tmp_path / "variant"
    _write_summary(classic, "Prob001_a", 100, 1000, 2000)
    _write_summary(variant, "Prob001_a", 100, 1000, 2000)
    out = tmp_path / "report"

    rc = report_budget_parity.main(
        [
            "--classic-root", str(classic),
            "--variant-root", str(variant),
            "--output-dir", str(out),
        ]
    )

    assert rc == 0
    assert (out / "budget_parity.json").is_file()
    assert "PARITY" in (out / "budget_parity.md").read_text(encoding="utf-8")
