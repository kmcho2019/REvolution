#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import json
import re
import sys
from pathlib import Path
from typing import Any


PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from scripts import run_diff_prompt_suite as suite_runner  # noqa: E402


DEFAULT_SAVE_ROOT = PROJECT_ROOT / "exp" / "diff_prompt_optimization_loop"
DEFAULT_PROMPT_ROOT = PROJECT_ROOT / "data" / "prompts"
DEFAULT_SUITE_FILE = PROJECT_ROOT / "data" / "diff_prompt_suite" / "diff_prompt_suite_v1.json"


def _slugify(text: str) -> str:
    slug = re.sub(r"[^A-Za-z0-9._-]+", "_", text).strip("_").lower()
    return slug or "candidate"


def _latest_results_json(root: Path) -> Path | None:
    items = sorted(root.glob("*/results.json"))
    return items[-1] if items else None


def _collect_candidates(args: argparse.Namespace) -> list[dict[str, Any]]:
    candidates: list[dict[str, Any]] = []
    seen: set[str] = set()

    prompt_root = args.prompt_root.resolve()
    if args.include_profile_prompt:
        profile_prompt = prompt_root / args.prompt_profile / "system" / "diff.txt"
        if not profile_prompt.exists():
            raise FileNotFoundError(
                f"Profile prompt not found for --include_profile_prompt: {profile_prompt}"
            )
        key = f"profile::{args.prompt_profile}"
        seen.add(key)
        candidates.append(
            {
                "name": f"profile:{args.prompt_profile}",
                "kind": "profile",
                "prompt_path": profile_prompt,
                "dedupe_key": key,
            }
        )

    for raw in args.system_prompt_files or []:
        path = Path(raw).resolve()
        if not path.exists():
            raise FileNotFoundError(f"System prompt file not found: {path}")
        key = f"file::{path}"
        if key in seen:
            continue
        seen.add(key)
        candidates.append(
            {
                "name": path.stem,
                "kind": "file",
                "prompt_path": path,
                "dedupe_key": key,
            }
        )

    if args.system_prompt_dir:
        directory = args.system_prompt_dir.resolve()
        if not directory.exists():
            raise FileNotFoundError(f"--system_prompt_dir does not exist: {directory}")
        for path in sorted(directory.glob(args.system_prompt_glob)):
            if not path.is_file():
                continue
            rp = path.resolve()
            key = f"file::{rp}"
            if key in seen:
                continue
            seen.add(key)
            candidates.append(
                {
                    "name": rp.stem,
                    "kind": "file",
                    "prompt_path": rp,
                    "dedupe_key": key,
                }
            )

    if not candidates:
        raise ValueError("No prompt candidates selected. Use files/dir or --include_profile_prompt.")

    for idx, cand in enumerate(candidates, start=1):
        cand["candidate_id"] = f"cand_{idx:02d}"
        cand["slug"] = f"{cand['candidate_id']}_{_slugify(cand['name'])}"
    return candidates


def _build_suite_args(
    args: argparse.Namespace,
    *,
    candidate: dict[str, Any],
    candidate_save_root: Path,
) -> list[str]:
    argv = [
        "--suite_file",
        str(args.suite_file.resolve()),
        "--repeat_per_case",
        str(args.repeat_per_case),
        "--model_name",
        args.model_name,
        "--api_backend",
        args.api_backend,
        "--vllm_host",
        args.vllm_host,
        "--vllm_port",
        str(args.vllm_port),
        "--vllm_preflight_timeout_s",
        str(args.vllm_preflight_timeout_s),
        "--vllm_min_model_len",
        str(args.vllm_min_model_len),
        "--temperature",
        str(args.temperature),
        "--top_p",
        str(args.top_p),
        "--max_tokens",
        str(args.max_tokens),
        "--diff_apply_policy",
        args.diff_apply_policy,
        "--diff_similarity_threshold",
        str(args.diff_similarity_threshold),
        "--diff_fuzzy_margin",
        str(args.diff_fuzzy_margin),
        "--save_root",
        str(candidate_save_root),
    ]
    argv.append("--skip_if_unreachable" if args.skip_if_unreachable else "--no-skip_if_unreachable")

    if args.case_ids:
        argv.extend(["--case_ids", *args.case_ids])
    if args.tags:
        argv.extend(["--tags", *args.tags])

    if candidate["kind"] == "file":
        argv.extend(["--system_prompt_file", str(candidate["prompt_path"])])
    else:
        argv.extend(
            [
                "--prompt_profile",
                args.prompt_profile,
                "--prompt_root",
                str(args.prompt_root.resolve()),
            ]
        )
    return argv


def _score(record: dict[str, Any]) -> tuple[float, float, int]:
    return (
        float(record.get("objective_score") or 0.0),
        float(record.get("hard_pass_pct") or 0.0),
        int(record.get("total_attempts") or 0),
    )


def _render_report(path: Path, payload: dict[str, Any]) -> None:
    rows = payload["candidates"]
    best = payload.get("best_candidate")
    lines = [
        "# Diff Prompt Optimization Loop Report",
        "",
        f"- Total candidates: **{payload['counts']['total']}**",
        f"- Successful runs: **{payload['counts']['ok']}**",
        f"- Skipped runs: **{payload['counts']['skipped']}**",
        f"- Error runs: **{payload['counts']['error']}**",
        "",
    ]
    if best:
        lines.extend(
            [
                "## Best Candidate",
                "",
                f"- Candidate: `{best['candidate_id']}` / `{best['candidate_name']}`",
                f"- Objective score: `{best['objective_score']:.4f}`",
                f"- Hard pass: `{best['hard_pass_pct']:.2f}%`",
                f"- Run: `{best['run_root']}`",
                "",
            ]
        )
    else:
        lines.extend(
            [
                "## Best Candidate",
                "",
                "- none (no successful candidate runs)",
                "",
            ]
        )

    lines.extend(
        [
            "## Candidate Table",
            "",
            "| Candidate | Type | Status | Objective | Hard Pass | Attempts | Run |",
            "|:--|:--|:--|--:|--:|--:|:--|",
        ]
    )
    for row in rows:
        obj = "-" if row["objective_score"] is None else f"{row['objective_score']:.4f}"
        hard = "-" if row["hard_pass_pct"] is None else f"{row['hard_pass_pct']:.2f}%"
        attempts = "-" if row["total_attempts"] is None else str(row["total_attempts"])
        lines.append(
            f"| `{row['candidate_id']}` `{row['candidate_name']}` | `{row['kind']}` | `{row['status']}` | "
            f"{obj} | {hard} | {attempts} | `{row['run_root']}` |"
        )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run prompt candidates through diff prompt suite and rank by objective_score.",
    )
    parser.add_argument("--suite_file", type=Path, default=DEFAULT_SUITE_FILE)
    parser.add_argument("--case_ids", nargs="+", default=None)
    parser.add_argument("--tags", nargs="+", default=None)
    parser.add_argument("--repeat_per_case", type=int, default=3)

    parser.add_argument("--model_name", type=str, required=True)
    parser.add_argument(
        "--api_backend",
        type=str,
        default="vllm",
        choices=["openai", "openrouter", "deepseek", "gemini", "vllm"],
    )
    parser.add_argument("--vllm_host", type=str, default="vllm")
    parser.add_argument("--vllm_port", type=int, default=8888)
    parser.add_argument("--vllm_preflight_timeout_s", type=float, default=5.0)
    parser.add_argument("--vllm_min_model_len", type=int, default=128000)
    parser.add_argument(
        "--skip_if_unreachable",
        action=argparse.BooleanOptionalAction,
        default=True,
    )

    parser.add_argument("--system_prompt_files", nargs="+", default=None)
    parser.add_argument("--system_prompt_dir", type=Path, default=None)
    parser.add_argument("--system_prompt_glob", type=str, default="*.txt")
    parser.add_argument(
        "--include_profile_prompt",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="Include data/prompts/<prompt_profile>/system/diff.txt as a baseline candidate.",
    )
    parser.add_argument("--prompt_profile", type=str, default="default")
    parser.add_argument("--prompt_root", type=Path, default=DEFAULT_PROMPT_ROOT)

    parser.add_argument("--temperature", type=float, default=1.0)
    parser.add_argument("--top_p", type=float, default=0.95)
    parser.add_argument("--max_tokens", type=int, default=1024)
    parser.add_argument("--diff_apply_policy", type=str, default="hybrid", choices=["strict", "hybrid", "fuzzy"])
    parser.add_argument("--diff_similarity_threshold", type=float, default=0.86)
    parser.add_argument("--diff_fuzzy_margin", type=float, default=0.03)

    parser.add_argument("--save_root", type=Path, default=DEFAULT_SAVE_ROOT)
    parser.add_argument("--stop_on_error", action=argparse.BooleanOptionalAction, default=False)
    return parser


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    if args.repeat_per_case < 1:
        raise ValueError("--repeat_per_case must be >= 1")

    candidates = _collect_candidates(args)

    ts = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    out_root = args.save_root / ts
    runs_root = out_root / "candidate_runs"
    runs_root.mkdir(parents=True, exist_ok=True)

    rows: list[dict[str, Any]] = []
    exit_code = 0
    for cand in candidates:
        candidate_save_root = runs_root / cand["slug"]
        suite_args = _build_suite_args(
            args,
            candidate=cand,
            candidate_save_root=candidate_save_root,
        )
        rc = suite_runner.main(suite_args)

        row: dict[str, Any] = {
            "candidate_id": cand["candidate_id"],
            "candidate_name": cand["name"],
            "kind": cand["kind"],
            "prompt_path": str(cand["prompt_path"]),
            "status": "error",
            "return_code": rc,
            "run_root": "",
            "warning": None,
            "objective_score": None,
            "hard_pass_pct": None,
            "total_attempts": None,
        }
        result_json = _latest_results_json(candidate_save_root)
        if result_json is not None:
            payload = json.loads(result_json.read_text(encoding="utf-8"))
            row["run_root"] = str(result_json.parent.resolve())
            if payload.get("status") == "skipped_unreachable_vllm":
                row["status"] = "skipped_unreachable_vllm"
                row["warning"] = payload.get("warning")
            elif isinstance(payload.get("summary"), dict):
                summary = payload["summary"]
                row["status"] = "ok"
                row["objective_score"] = float(summary.get("objective_score", 0.0))
                row["hard_pass_pct"] = float(summary.get("hard_pass_pct", 0.0))
                row["total_attempts"] = int(summary.get("total_attempts", 0))
            else:
                row["status"] = "invalid_results_payload"
        else:
            row["status"] = "missing_results"

        rows.append(row)
        if row["status"] not in {"ok", "skipped_unreachable_vllm"}:
            exit_code = 1
            if args.stop_on_error:
                break

    successful = [r for r in rows if r["status"] == "ok" and r["objective_score"] is not None]
    successful.sort(key=_score, reverse=True)
    best = successful[0] if successful else None

    rows_sorted = sorted(
        rows,
        key=lambda r: (
            0 if r["status"] == "ok" else 1,
            -(_score(r)[0]) if r["status"] == "ok" else 0.0,
            r["candidate_id"],
        ),
    )
    counts = {
        "total": len(rows),
        "ok": sum(1 for r in rows if r["status"] == "ok"),
        "skipped": sum(1 for r in rows if r["status"] == "skipped_unreachable_vllm"),
        "error": sum(1 for r in rows if r["status"] not in {"ok", "skipped_unreachable_vllm"}),
    }
    payload = {
        "timestamp": ts,
        "suite_file": str(args.suite_file.resolve()),
        "model_name": args.model_name,
        "api_backend": args.api_backend,
        "repeat_per_case": args.repeat_per_case,
        "counts": counts,
        "best_candidate": best,
        "candidates": rows_sorted,
    }
    (out_root / "results.json").write_text(json.dumps(payload, indent=2), encoding="utf-8")
    _render_report(out_root / "results.md", payload)

    print(f"Results: {out_root / 'results.json'}")
    print(f"Report: {out_root / 'results.md'}")
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
