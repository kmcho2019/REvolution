#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

import matplotlib.pyplot as plt

PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT / "src") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "src"))

from revolution.prompt_tuning import render_campaign_markdown, write_json  # noqa: E402


PLOT_METRICS = (
    ("functionality_pass_rate", "Functionality Pass Rate"),
    ("synthesis_pass_rate", "Synthesis Pass Rate"),
    ("valid_ppa_sample_count", "Valid PPA Samples"),
    ("designs_with_valid_ppa", "Designs With Valid PPA"),
    ("average_score", "Average Score"),
    ("average_ppa_improvement", "Average PPA Improvement"),
    ("qd_coverage", "QD Coverage"),
    ("occupied_cells", "Occupied Cells"),
    ("qd_score", "QD Score"),
)


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


def _as_float(value: Any) -> float | None:
    if value is None:
        return None
    return float(value)


def _plot_line(path: Path, title: str, ylabel: str, values: list[float | None]) -> bool:
    if not any(value is not None for value in values):
        return False
    xs = list(range(1, len(values) + 1))
    ys = [float("nan") if value is None else value for value in values]
    plt.figure(figsize=(8, 4.5))
    plt.plot(xs, ys, marker="o", linewidth=1.8)
    plt.title(title)
    plt.xlabel("Candidate Evaluation")
    plt.ylabel(ylabel)
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    plt.savefig(path, dpi=160)
    plt.close()
    return True


def _write_progress_plots(output_dir: Path, candidates: list[dict[str, Any]]) -> list[str]:
    plot_dir = output_dir / "progress_plots"
    paths: list[str] = []
    scores = [_as_float(row.get("score")) for row in candidates]
    if _plot_line(plot_dir / "candidate_score.png", "GEPA Candidate Score", "Score", scores):
        paths.append(str(plot_dir / "candidate_score.png"))
    for metric, label in PLOT_METRICS:
        values: list[float | None] = []
        for row in candidates:
            aggregates = row.get("aggregates", {})
            assert isinstance(aggregates, dict)
            values.append(_as_float(aggregates.get(metric)))
        filename = f"{metric}.png"
        if _plot_line(plot_dir / filename, f"GEPA {label}", label, values):
            paths.append(str(plot_dir / filename))
    return paths


def _append_plot_section(report_path: Path, plot_paths: list[str]) -> None:
    if not plot_paths:
        return
    lines = ["", "## Progress Visualizations", ""]
    for path in plot_paths:
        rel = Path(path).relative_to(report_path.parent)
        title = rel.stem.replace("_", " ").title()
        lines.append(f"- [{title}]({rel.as_posix()})")
    lines.append("")
    with report_path.open("a", encoding="utf-8") as handle:
        handle.write("\n".join(lines))


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
    candidate_summaries = [
        _candidate_summary(campaign_root, row)
        for row in candidates
        if isinstance(row, dict)
    ]
    plot_paths = _write_progress_plots(output_dir, candidate_summaries)
    summary = {
        "campaign_root": str(campaign_root),
        "baseline_profile": payload.get("baseline_profile"),
        "optimized_profile": payload.get("optimized_profile"),
        "selected_candidate": payload.get("selected_candidate"),
        "candidate_count": len(candidates),
        "progress_plots": plot_paths,
        "candidates": candidate_summaries,
    }
    write_json(output_dir / "summary.json", summary)
    report_path = output_dir / "report.md"
    report_path.write_text(
        render_campaign_markdown(payload),
        encoding="utf-8",
    )
    _append_plot_section(report_path, plot_paths)
    print(f"Wrote {output_dir / 'summary.json'}")
    print(f"Wrote {report_path}")
    if plot_paths:
        print(f"Wrote {len(plot_paths)} progress plots under {output_dir / 'progress_plots'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
