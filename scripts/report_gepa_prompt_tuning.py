#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT / "src") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "src"))

from revolution.prompt_tuning import render_campaign_markdown, write_json  # noqa: E402


def _parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Regenerate GEPA prompt-tuning campaign reports."
    )
    parser.add_argument("--campaign-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, default=None)
    return parser.parse_args(argv)


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _candidate_summary(campaign_root: Path, row: dict[str, Any]) -> dict[str, Any]:
    candidate_id = row["candidate_id"]
    score_path = campaign_root / "candidates" / candidate_id / "score.json"
    score = _load_json(score_path) if score_path.is_file() else {}
    return {
        "candidate_id": candidate_id,
        "status": row.get("status"),
        "score": row.get("score"),
        "bundle_hash": row.get("bundle_hash"),
        "changed_sections": row.get("changed_sections", []),
        "run_root": row.get("run_root"),
        "failure_reasons": row.get("errors", []),
        "aggregates": score.get("aggregates", {}),
    }


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(argv)
    campaign_root = args.campaign_root.resolve()
    campaign_json = campaign_root / "campaign.json"
    if not campaign_json.is_file():
        raise FileNotFoundError(campaign_json)
    payload = _load_json(campaign_json)
    output_dir = args.output_dir.resolve() if args.output_dir else campaign_root
    output_dir.mkdir(parents=True, exist_ok=True)

    candidates = payload.get("candidates", [])
    assert isinstance(candidates, list)
    summary = {
        "campaign_root": str(campaign_root),
        "baseline_profile": payload.get("baseline_profile"),
        "optimized_profile": payload.get("optimized_profile"),
        "selected_candidate": payload.get("selected_candidate"),
        "candidate_count": len(candidates),
        "candidates": [
            _candidate_summary(campaign_root, row)
            for row in candidates
            if isinstance(row, dict)
        ],
    }
    write_json(output_dir / "summary.json", summary)
    (output_dir / "report.md").write_text(
        render_campaign_markdown(payload),
        encoding="utf-8",
    )
    print(f"Wrote {output_dir / 'summary.json'}")
    print(f"Wrote {output_dir / 'report.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
