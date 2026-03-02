#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import json
from collections import defaultdict
from pathlib import Path
from statistics import mean
from typing import Any


def _safe_float(value: Any, default: float = 0.0) -> float:
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def _safe_int(value: Any, default: int = 0) -> int:
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def _pct_bar(pct: float, width: int = 10) -> str:
    pct = max(0.0, min(100.0, pct))
    filled = int(round((pct / 100.0) * width))
    return "█" * filled + "░" * (width - filled)


def _load_result_json(path: Path) -> dict[str, Any] | None:
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return None
    if not isinstance(payload, dict):
        return None
    if payload.get("status") == "skipped_unreachable_vllm":
        return None
    if "summary" not in payload:
        return None
    return payload


def collect_runs(results_root: Path) -> list[dict[str, Any]]:
    runs: list[dict[str, Any]] = []
    for path in sorted(results_root.glob("*/results.json")):
        payload = _load_result_json(path)
        if payload is None:
            continue
        summary = payload.get("summary", {})
        run_row = {
            "run_path": str(path.parent.resolve()),
            "timestamp": str(payload.get("timestamp") or path.parent.name),
            "suite_name": str(payload.get("suite_name", "")),
            "model_name": str(payload.get("model_name", "")),
            "api_backend": str(payload.get("api_backend", "")),
            "prompt_source": str(payload.get("prompt_source", "")),
            "prompt_sha256": str(payload.get("prompt_sha256", "")),
            "diff_apply_policy": str(payload.get("diff_apply_policy", "")),
            "objective_score": _safe_float(summary.get("objective_score"), 0.0),
            "hard_pass_pct": _safe_float(summary.get("hard_pass_pct"), 0.0),
            "format_ok_pct": _safe_float(summary.get("format_ok_pct"), 0.0),
            "apply_ok_pct": _safe_float(summary.get("apply_ok_pct"), 0.0),
            "safe_reject_ok_pct": _safe_float(summary.get("safe_reject_ok_pct"), 0.0),
            "total_attempts": _safe_int(summary.get("total_attempts"), 0),
            "llm_prompt_tokens": _safe_int((summary.get("llm_usage") or {}).get("prompt_tokens"), 0),
            "llm_completion_tokens": _safe_int((summary.get("llm_usage") or {}).get("completion_tokens"), 0),
            "reason_code_counts": dict(summary.get("reason_code_counts", {})),
            "by_case": dict(summary.get("by_case", {})),
        }
        runs.append(run_row)
    return runs


def collect_skipped_runs(results_root: Path) -> list[dict[str, str]]:
    skipped: list[dict[str, str]] = []
    for path in sorted(results_root.glob("*/results.json")):
        try:
            payload = json.loads(path.read_text(encoding="utf-8"))
        except Exception:
            continue
        if not isinstance(payload, dict):
            continue
        if payload.get("status") != "skipped_unreachable_vllm":
            continue
        skipped.append(
            {
                "timestamp": str(payload.get("timestamp") or path.parent.name),
                "run_path": str(path.parent.resolve()),
                "warning": str(payload.get("warning", "")),
            }
        )
    return skipped


def aggregate_prompt_groups(runs: list[dict[str, Any]]) -> list[dict[str, Any]]:
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in runs:
        grouped[row["prompt_sha256"] or "unknown_prompt_hash"].append(row)

    out: list[dict[str, Any]] = []
    for prompt_sha, group in grouped.items():
        best = max(group, key=lambda r: (r["objective_score"], r["hard_pass_pct"], -r["total_attempts"]))
        out.append(
            {
                "prompt_sha256": prompt_sha,
                "runs": len(group),
                "objective_score_avg": mean(r["objective_score"] for r in group),
                "objective_score_best": best["objective_score"],
                "hard_pass_pct_avg": mean(r["hard_pass_pct"] for r in group),
                "hard_pass_pct_best": best["hard_pass_pct"],
                "apply_ok_pct_avg": mean(r["apply_ok_pct"] for r in group),
                "format_ok_pct_avg": mean(r["format_ok_pct"] for r in group),
                "best_run_path": best["run_path"],
                "prompt_source_example": best["prompt_source"],
            }
        )
    out.sort(key=lambda x: (-x["objective_score_avg"], -x["hard_pass_pct_avg"], x["prompt_sha256"]))
    return out


def aggregate_case_stats(runs: list[dict[str, Any]]) -> list[dict[str, Any]]:
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for run in runs:
        by_case = run.get("by_case", {}) or {}
        for case_id, stats in by_case.items():
            if not isinstance(stats, dict):
                continue
            grouped[str(case_id)].append(
                {
                    "attempts": _safe_int(stats.get("attempts"), 0),
                    "hard_pass_rate": _safe_float(stats.get("hard_pass_rate"), 0.0),
                    "apply_ok_rate": _safe_float(stats.get("apply_ok_rate"), 0.0),
                    "safe_reject_rate": _safe_float(stats.get("safe_reject_rate"), 0.0),
                    "objective_score_avg": _safe_float(stats.get("objective_score_avg"), 0.0),
                }
            )

    out: list[dict[str, Any]] = []
    for case_id, rows in grouped.items():
        out.append(
            {
                "case_id": case_id,
                "runs_present": len(rows),
                "attempts_total": sum(r["attempts"] for r in rows),
                "hard_pass_rate_avg_pct": mean(r["hard_pass_rate"] for r in rows) * 100.0,
                "apply_ok_rate_avg_pct": mean(r["apply_ok_rate"] for r in rows) * 100.0,
                "safe_reject_rate_avg_pct": mean(r["safe_reject_rate"] for r in rows) * 100.0,
                "objective_score_avg": mean(r["objective_score_avg"] for r in rows),
            }
        )
    out.sort(key=lambda x: (x["hard_pass_rate_avg_pct"], x["case_id"]))
    return out


def aggregate_reason_codes(runs: list[dict[str, Any]]) -> dict[str, int]:
    counts: dict[str, int] = defaultdict(int)
    for run in runs:
        for reason, value in (run.get("reason_code_counts") or {}).items():
            counts[str(reason)] += _safe_int(value)
    return dict(sorted(counts.items(), key=lambda item: (-item[1], item[0])))


def _write_csv(path: Path, fieldnames: list[str], rows: list[dict[str, Any]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({k: row.get(k) for k in fieldnames})


def _render_markdown(
    path: Path,
    *,
    runs: list[dict[str, Any]],
    prompt_groups: list[dict[str, Any]],
    case_stats: list[dict[str, Any]],
    reason_counts: dict[str, int],
) -> None:
    best = max(runs, key=lambda r: (r["objective_score"], r["hard_pass_pct"], -r["total_attempts"]))
    avg_objective = mean(r["objective_score"] for r in runs)
    avg_hard_pass = mean(r["hard_pass_pct"] for r in runs)
    lines = [
        "# Diff Prompt Suite Summary",
        "",
        "## Overview",
        "",
        f"- Runs analyzed: **{len(runs)}**",
        f"- Distinct prompts: **{len(prompt_groups)}**",
        f"- Avg objective score: **{avg_objective:.4f}**",
        f"- Avg hard pass: **{avg_hard_pass:.2f}%**",
        f"- Best run: `{best['run_path']}` (objective `{best['objective_score']:.4f}`, hard pass `{best['hard_pass_pct']:.2f}%`)",
        "",
        "## Run Leaderboard",
        "",
        "| Rank | Objective | Hard Pass | Apply OK | Format OK | Attempts | Tokens | Prompt Hash | Run |",
        "|---:|---:|---:|---:|---:|---:|---:|:---|:---|",
    ]
    ranked = sorted(runs, key=lambda r: (-r["objective_score"], -r["hard_pass_pct"], r["timestamp"]))
    for idx, row in enumerate(ranked, start=1):
        tokens = row["llm_prompt_tokens"] + row["llm_completion_tokens"]
        lines.append(
            f"| {idx} | {row['objective_score']:.4f} | {row['hard_pass_pct']:.2f}% | "
            f"{row['apply_ok_pct']:.2f}% | {row['format_ok_pct']:.2f}% | "
            f"{row['total_attempts']} | {tokens} | `{row['prompt_sha256'][:12]}` | `{row['timestamp']}` |"
        )

    lines.extend(
        [
            "",
            "## Prompt Leaderboard",
            "",
            "| Rank | Prompt Hash | Runs | Avg Objective | Best Objective | Avg Hard Pass | Avg Apply OK |",
            "|---:|:---|---:|---:|---:|---:|---:|",
        ]
    )
    for idx, row in enumerate(prompt_groups, start=1):
        lines.append(
            f"| {idx} | `{row['prompt_sha256'][:12]}` | {row['runs']} | "
            f"{row['objective_score_avg']:.4f} | {row['objective_score_best']:.4f} | "
            f"{row['hard_pass_pct_avg']:.2f}% | {row['apply_ok_pct_avg']:.2f}% |"
        )

    lines.extend(
        [
            "",
            "## Case Difficulty",
            "",
            "| Case | Avg Hard Pass | Avg Apply OK | Avg Safe Reject | Avg Objective | Visual |",
            "|:---|---:|---:|---:|---:|:---|",
        ]
    )
    for row in case_stats:
        bar = _pct_bar(row["hard_pass_rate_avg_pct"])
        lines.append(
            f"| `{row['case_id']}` | {row['hard_pass_rate_avg_pct']:.2f}% | "
            f"{row['apply_ok_rate_avg_pct']:.2f}% | {row['safe_reject_rate_avg_pct']:.2f}% | "
            f"{row['objective_score_avg']:.4f} | `{bar}` |"
        )

    lines.extend(["", "## Reason Codes", ""])
    if not reason_counts:
        lines.append("- none")
    else:
        for reason, count in reason_counts.items():
            lines.append(f"- `{reason}`: {count}")

    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _write_case_matrix(path: Path, runs: list[dict[str, Any]]) -> None:
    all_case_ids = sorted(
        {
            case_id
            for run in runs
            for case_id in (run.get("by_case", {}) or {}).keys()
        }
    )
    fieldnames = [
        "timestamp",
        "run_path",
        "prompt_sha256",
        "objective_score",
        "hard_pass_pct",
    ] + [f"case_hard_pass_{case_id}" for case_id in all_case_ids]

    rows: list[dict[str, Any]] = []
    for run in runs:
        row: dict[str, Any] = {
            "timestamp": run["timestamp"],
            "run_path": run["run_path"],
            "prompt_sha256": run["prompt_sha256"],
            "objective_score": run["objective_score"],
            "hard_pass_pct": run["hard_pass_pct"],
        }
        for case_id in all_case_ids:
            val = None
            case_stats = (run.get("by_case", {}) or {}).get(case_id)
            if isinstance(case_stats, dict):
                val = _safe_float(case_stats.get("hard_pass_rate"), 0.0) * 100.0
            row[f"case_hard_pass_{case_id}"] = val
        rows.append(row)
    _write_csv(path, fieldnames, rows)


def summarize(results_root: Path, output_dir: Path) -> dict[str, Any]:
    runs = collect_runs(results_root)
    skipped_runs = collect_skipped_runs(results_root)
    if not runs:
        output_dir.mkdir(parents=True, exist_ok=True)

        runs_fields = [
            "timestamp",
            "run_path",
            "suite_name",
            "model_name",
            "api_backend",
            "prompt_source",
            "prompt_sha256",
            "diff_apply_policy",
            "objective_score",
            "hard_pass_pct",
            "format_ok_pct",
            "apply_ok_pct",
            "safe_reject_ok_pct",
            "total_attempts",
            "llm_prompt_tokens",
            "llm_completion_tokens",
            "llm_total_tokens",
        ]
        _write_csv(output_dir / "runs.csv", fieldnames=runs_fields, rows=[])
        _write_csv(
            output_dir / "prompt_groups.csv",
            fieldnames=[
                "prompt_sha256",
                "runs",
                "objective_score_avg",
                "objective_score_best",
                "hard_pass_pct_avg",
                "hard_pass_pct_best",
                "apply_ok_pct_avg",
                "format_ok_pct_avg",
                "best_run_path",
                "prompt_source_example",
            ],
            rows=[],
        )
        _write_csv(
            output_dir / "case_stats.csv",
            fieldnames=[
                "case_id",
                "runs_present",
                "attempts_total",
                "hard_pass_rate_avg_pct",
                "apply_ok_rate_avg_pct",
                "safe_reject_rate_avg_pct",
                "objective_score_avg",
            ],
            rows=[],
        )
        _write_csv(
            output_dir / "case_matrix.csv",
            fieldnames=["timestamp", "run_path", "prompt_sha256", "objective_score", "hard_pass_pct"],
            rows=[],
        )

        summary_payload = {
            "results_root": str(results_root.resolve()),
            "runs_analyzed": 0,
            "prompt_count": 0,
            "best_run": None,
            "run_leaderboard": [],
            "prompt_leaderboard": [],
            "case_stats": [],
            "reason_code_counts": {},
            "skipped_runs": skipped_runs,
        }
        (output_dir / "summary.json").write_text(json.dumps(summary_payload, indent=2), encoding="utf-8")
        lines = [
            "# Diff Prompt Suite Summary",
            "",
            "## Overview",
            "",
            "- Runs analyzed: **0**",
            f"- Skipped runs: **{len(skipped_runs)}**",
            "- No valid prompt-suite runs were available for leaderboard aggregation.",
            "",
        ]
        if skipped_runs:
            lines.append("## Skipped Runs")
            lines.append("")
            for row in skipped_runs:
                lines.append(f"- `{row['timestamp']}`: {row['warning']}")
            lines.append("")
        (output_dir / "summary.md").write_text("\n".join(lines), encoding="utf-8")
        return summary_payload

    ranked_runs = sorted(runs, key=lambda r: (-r["objective_score"], -r["hard_pass_pct"], r["timestamp"]))
    prompt_groups = aggregate_prompt_groups(runs)
    case_stats = aggregate_case_stats(runs)
    reason_counts = aggregate_reason_codes(runs)

    output_dir.mkdir(parents=True, exist_ok=True)

    runs_csv_rows = [
        {
            "timestamp": r["timestamp"],
            "run_path": r["run_path"],
            "suite_name": r["suite_name"],
            "model_name": r["model_name"],
            "api_backend": r["api_backend"],
            "prompt_source": r["prompt_source"],
            "prompt_sha256": r["prompt_sha256"],
            "diff_apply_policy": r["diff_apply_policy"],
            "objective_score": r["objective_score"],
            "hard_pass_pct": r["hard_pass_pct"],
            "format_ok_pct": r["format_ok_pct"],
            "apply_ok_pct": r["apply_ok_pct"],
            "safe_reject_ok_pct": r["safe_reject_ok_pct"],
            "total_attempts": r["total_attempts"],
            "llm_prompt_tokens": r["llm_prompt_tokens"],
            "llm_completion_tokens": r["llm_completion_tokens"],
            "llm_total_tokens": r["llm_prompt_tokens"] + r["llm_completion_tokens"],
        }
        for r in ranked_runs
    ]

    _write_csv(
        output_dir / "runs.csv",
        fieldnames=list(runs_csv_rows[0].keys()),
        rows=runs_csv_rows,
    )
    _write_csv(
        output_dir / "prompt_groups.csv",
        fieldnames=[
            "prompt_sha256",
            "runs",
            "objective_score_avg",
            "objective_score_best",
            "hard_pass_pct_avg",
            "hard_pass_pct_best",
            "apply_ok_pct_avg",
            "format_ok_pct_avg",
            "best_run_path",
            "prompt_source_example",
        ],
        rows=prompt_groups,
    )
    _write_csv(
        output_dir / "case_stats.csv",
        fieldnames=[
            "case_id",
            "runs_present",
            "attempts_total",
            "hard_pass_rate_avg_pct",
            "apply_ok_rate_avg_pct",
            "safe_reject_rate_avg_pct",
            "objective_score_avg",
        ],
        rows=case_stats,
    )
    _write_case_matrix(output_dir / "case_matrix.csv", ranked_runs)

    summary_payload = {
        "results_root": str(results_root.resolve()),
        "runs_analyzed": len(ranked_runs),
        "prompt_count": len(prompt_groups),
        "best_run": ranked_runs[0],
        "run_leaderboard": ranked_runs,
        "prompt_leaderboard": prompt_groups,
        "case_stats": case_stats,
        "reason_code_counts": reason_counts,
        "skipped_runs": skipped_runs,
    }
    (output_dir / "summary.json").write_text(json.dumps(summary_payload, indent=2), encoding="utf-8")
    _render_markdown(
        output_dir / "summary.md",
        runs=ranked_runs,
        prompt_groups=prompt_groups,
        case_stats=case_stats,
        reason_counts=reason_counts,
    )
    return summary_payload


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Aggregate and summarize cross-run results from run_diff_prompt_suite.py.",
    )
    parser.add_argument(
        "--results_root",
        type=Path,
        default=Path("exp/diff_prompt_suite"),
        help="Directory containing per-run folders with results.json.",
    )
    parser.add_argument(
        "--output_dir",
        type=Path,
        default=None,
        help="Output directory for summary artifacts. Defaults to <results_root>/summary.",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    output_dir = args.output_dir or (args.results_root / "summary")
    payload = summarize(args.results_root, output_dir)
    print(f"Summary runs: {payload['runs_analyzed']}")
    print(f"Summary JSON: {output_dir / 'summary.json'}")
    print(f"Summary Markdown: {output_dir / 'summary.md'}")
    print(f"Runs CSV: {output_dir / 'runs.csv'}")
    print(f"Prompt CSV: {output_dir / 'prompt_groups.csv'}")
    print(f"Case CSV: {output_dir / 'case_stats.csv'}")
    print(f"Case Matrix CSV: {output_dir / 'case_matrix.csv'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
