#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path
from statistics import mean
from typing import Any


PROJECT_ROOT = Path(__file__).resolve().parents[1]
SRC_ROOT = PROJECT_ROOT / "src"
if str(SRC_ROOT) not in sys.path:
    sys.path.insert(0, str(SRC_ROOT))

from revolution.vllm_preflight import preflight_vllm_model  # noqa: E402


DEFAULT_BASELINE_REPORT = Path(
    "/workspace/baselines/20260224_022519__de122199__funsearch/summaries/backend_comparison.md"
)
DEFAULT_CVDP_JSONL = PROJECT_ROOT / "data/bench/cvdp/cvdp_v1.0.2_nonagentic_code_generation_no_commercial.jsonl"
SUPPORTED_BENCHMARKS = ("RTLLM", "VerilogEval-Spec-to-RTL", "cvdp")
PLAN_DEFAULT_RTLLM_HARD = [
    "Prob026_asyn_fifo",
    "Prob033_freq_divbyfrac",
    "Prob034_freq_divbyodd",
    "Prob032_freq_divbyeven",
    "Prob018_float_multi",
    "Prob010_radix2_div",
]
PLAN_DEFAULT_VERILOGEVAL_HARD = [
    "Prob149_ece241_2013_q4",
    "Prob095_review2015_fsmshift",
    "Prob099_m2014_q6c",
    "Prob062_bugs_mux2",
    "Prob155_lemmings4",
    "Prob156_review2015_fancytimer",
]


def _default_baseline_report() -> Path | None:
    if DEFAULT_BASELINE_REPORT.exists():
        return DEFAULT_BASELINE_REPORT
    return None


def parse_baseline_functionality_rates(
    report_path: Path,
    backend: str = "revolution",
) -> dict[str, list[tuple[str, float]]]:
    """
    Parse the backend comparison markdown and extract functionality pass rates.
    Returns benchmark -> list[(problem, functionality_percent)].
    """
    rows: dict[str, list[tuple[str, float]]] = defaultdict(list)
    if not report_path.exists():
        return rows

    pattern = re.compile(r"\(([\d.]+)%\)")
    for raw_line in report_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line.startswith("|"):
            continue
        cells = [cell.strip() for cell in line.strip("|").split("|")]
        if len(cells) < 4:
            continue
        if cells[0] in ("Backend", ":---"):
            continue

        backend_cell = cells[0].strip("`")
        bench = cells[1]
        problem = cells[2]
        functionality = cells[3]
        if backend_cell != backend:
            continue
        if not bench or not problem:
            continue
        m = pattern.search(functionality)
        if not m:
            continue
        rows[bench].append((problem, float(m.group(1))))
    return rows


def _load_problems_txt(benchmark: str) -> list[str]:
    problems_txt = PROJECT_ROOT / f"data/bench/{benchmark}/problems.txt"
    if not problems_txt.exists():
        return []
    return [
        line.strip()
        for line in problems_txt.read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]


def select_hard_problems(
    benchmark: str,
    count: int,
    *,
    baseline_rows: dict[str, list[tuple[str, float]]],
    max_baseline_functionality: float | None = 70.0,
) -> list[str]:
    """
    Select hard problems by lowest historical functionality pass-rate.
    Falls back to benchmark problems.txt if baseline metadata is unavailable.
    """
    ranked = baseline_rows.get(benchmark, [])
    if ranked:
        ranked = sorted(ranked, key=lambda item: (item[1], item[0]))
        if max_baseline_functionality is not None:
            filtered = [problem for problem, rate in ranked if rate <= max_baseline_functionality]
        else:
            filtered = [problem for problem, _rate in ranked]
        if filtered:
            return filtered[:count]
        return [problem for problem, _rate in ranked[:count]]
    return _load_problems_txt(benchmark)[:count]


def select_cvdp_ids(
    jsonl_path: Path,
    count: int,
    *,
    preferred_categories: list[str],
) -> list[str]:
    """
    Pick CVDP samples by category priority (e.g. hard -> medium).
    """
    if not jsonl_path.exists():
        return []
    normalized = [c.lower() for c in preferred_categories]
    grouped: dict[str, list[str]] = defaultdict(list)

    with jsonl_path.open("r", encoding="utf-8") as handle:
        for line in handle:
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                continue
            sample_id = rec.get("id")
            categories = [str(c).lower() for c in rec.get("categories", [])]
            if not sample_id:
                continue
            for cat in normalized:
                if cat in categories:
                    grouped[cat].append(str(sample_id))
                    break

    chosen: list[str] = []
    for cat in normalized:
        for sample_id in sorted(grouped.get(cat, [])):
            if sample_id in chosen:
                continue
            chosen.append(sample_id)
            if len(chosen) >= count:
                return chosen
    return chosen


def select_cvdp_medium_long_prompt_ids(
    jsonl_path: Path,
    count: int,
    *,
    required_categories: tuple[str, str] = ("cid002", "cid003"),
    difficulty_label: str = "medium",
) -> list[str]:
    """
    Deterministically pick medium CVDP samples from cid002/cid003 by largest
    prompt length (`input` field), breaking ties by id.
    """
    if not jsonl_path.exists():
        return []
    required_set = {c.lower() for c in required_categories}
    difficulty = difficulty_label.lower()
    ranked: list[tuple[int, str]] = []

    with jsonl_path.open("r", encoding="utf-8") as handle:
        for line in handle:
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                continue
            sample_id = rec.get("id")
            categories = {str(c).lower() for c in rec.get("categories", [])}
            prompt_text = str(rec.get("input", ""))
            if not sample_id:
                continue
            if difficulty not in categories:
                continue
            if categories.isdisjoint(required_set):
                continue
            ranked.append((len(prompt_text), str(sample_id)))

    ranked.sort(key=lambda item: (-item[0], item[1]))
    return [sample_id for _prompt_len, sample_id in ranked[:count]]


def _safe_mean(values: list[float]) -> float | None:
    if not values:
        return None
    return float(mean(values))


def summarize_problem_summaries(run_root: Path) -> dict[str, Any]:
    """
    Aggregate all <problem>_summary.json files under a run root.
    """
    total_prompt = 0
    total_completion = 0
    total_runtime = 0.0
    total_calls = 0
    diff_attempts = 0
    diff_failed = 0
    functionality_rates: list[float] = []
    synth_rates: list[float] = []
    by_benchmark: dict[str, dict[str, Any]] = defaultdict(
        lambda: {
            "problems": 0,
            "total_tokens": 0,
            "total_runtime_seconds": 0.0,
            "avg_functionality_rate": None,
            "avg_synthesis_rate": None,
            "_func_acc": [],
            "_synth_acc": [],
        }
    )
    summaries: list[dict[str, Any]] = []

    for summary_path in sorted(run_root.glob("**/*_summary.json")):
        try:
            payload = json.loads(summary_path.read_text(encoding="utf-8"))
        except Exception:
            continue
        summaries.append(payload)
        bench = str(payload.get("benchmark_name", "unknown"))

        prompt_tokens = int(payload.get("total_llm_prompt_tokens", 0) or 0)
        completion_tokens = int(payload.get("total_llm_completion_tokens", 0) or 0)
        runtime_seconds = float(payload.get("total_runtime_seconds", 0.0) or 0.0)
        api_calls = int(payload.get("total_llm_api_calls", 0) or 0)

        total_prompt += prompt_tokens
        total_completion += completion_tokens
        total_runtime += runtime_seconds
        total_calls += api_calls

        diff_stats = payload.get("accumulated_diff_stats", {}) or {}
        diff_attempts += int(diff_stats.get("attempts", 0) or 0)
        diff_failed += int(diff_stats.get("failed", 0) or 0)

        acc_rates = payload.get("accumulated_success_rates", {}) or {}
        func_rate = acc_rates.get("functionality")
        synth_rate = acc_rates.get("synthesis_ppa")
        if isinstance(func_rate, (int, float)):
            functionality_rates.append(float(func_rate))
            by_benchmark[bench]["_func_acc"].append(float(func_rate))
        if isinstance(synth_rate, (int, float)):
            synth_rates.append(float(synth_rate))
            by_benchmark[bench]["_synth_acc"].append(float(synth_rate))

        by_benchmark[bench]["problems"] += 1
        by_benchmark[bench]["total_tokens"] += prompt_tokens + completion_tokens
        by_benchmark[bench]["total_runtime_seconds"] += runtime_seconds

    for bench, rec in by_benchmark.items():
        rec["avg_functionality_rate"] = _safe_mean(rec.pop("_func_acc"))
        rec["avg_synthesis_rate"] = _safe_mean(rec.pop("_synth_acc"))

    total_tokens = total_prompt + total_completion
    return {
        "problem_count": len(summaries),
        "total_tokens": total_tokens,
        "total_prompt_tokens": total_prompt,
        "total_completion_tokens": total_completion,
        "total_runtime_seconds": total_runtime,
        "total_llm_api_calls": total_calls,
        "avg_functionality_rate": _safe_mean(functionality_rates),
        "avg_synthesis_rate": _safe_mean(synth_rates),
        "diff_attempts": diff_attempts,
        "diff_failed": diff_failed,
        "diff_pass_rate": ((diff_attempts - diff_failed) / diff_attempts) if diff_attempts else None,
        "by_benchmark": dict(by_benchmark),
    }


def build_diff_failure_catalog(run_root: Path, max_examples_per_reason: int = 8) -> dict[str, Any]:
    """
    Collect diff apply error artifacts into a reason-code catalog.
    """
    counts: dict[str, int] = defaultdict(int)
    examples: dict[str, list[dict[str, Any]]] = defaultdict(list)

    for artifact_path in sorted(run_root.glob("**/*_diff_apply_error.json")):
        try:
            payload = json.loads(artifact_path.read_text(encoding="utf-8"))
        except Exception:
            continue
        reason_code = str(payload.get("reason_code") or "unknown")
        counts[reason_code] += 1
        if len(examples[reason_code]) >= max_examples_per_reason:
            continue
        examples[reason_code].append(
            {
                "path": str(artifact_path),
                "reason": payload.get("reason"),
                "phase": payload.get("diagnostics", {}).get("phase"),
                "generation": payload.get("generation"),
                "sample_index": payload.get("sample_index"),
            }
        )
    return {
        "counts": dict(sorted(counts.items(), key=lambda item: (-item[1], item[0]))),
        "examples": dict(examples),
    }


def compare_mode_summaries(whole: dict[str, Any], diff: dict[str, Any]) -> dict[str, Any]:
    whole_tokens = int(whole.get("total_tokens", 0) or 0)
    diff_tokens = int(diff.get("total_tokens", 0) or 0)
    whole_runtime = float(whole.get("total_runtime_seconds", 0.0) or 0.0)
    diff_runtime = float(diff.get("total_runtime_seconds", 0.0) or 0.0)

    token_delta = diff_tokens - whole_tokens
    runtime_delta = diff_runtime - whole_runtime

    return {
        "token_delta": token_delta,
        "token_savings_vs_whole": whole_tokens - diff_tokens,
        "token_savings_pct_vs_whole": ((whole_tokens - diff_tokens) / whole_tokens * 100.0) if whole_tokens else None,
        "runtime_delta_seconds": runtime_delta,
        "runtime_speedup_vs_whole_seconds": whole_runtime - diff_runtime,
        "runtime_speedup_pct_vs_whole": ((whole_runtime - diff_runtime) / whole_runtime * 100.0) if whole_runtime else None,
        "avg_functionality_delta": (
            (diff.get("avg_functionality_rate") or 0.0) - (whole.get("avg_functionality_rate") or 0.0)
            if whole.get("avg_functionality_rate") is not None and diff.get("avg_functionality_rate") is not None
            else None
        ),
        "avg_synthesis_delta": (
            (diff.get("avg_synthesis_rate") or 0.0) - (whole.get("avg_synthesis_rate") or 0.0)
            if whole.get("avg_synthesis_rate") is not None and diff.get("avg_synthesis_rate") is not None
            else None
        ),
    }


def _run_command(cmd: list[str], log_path: Path, dry_run: bool) -> int:
    line = " ".join(cmd)
    if dry_run:
        log_path.write_text(f"[dry-run] {line}\n", encoding="utf-8")
        print(f"[dry-run] {line}")
        return 0

    proc = subprocess.run(cmd, text=True, capture_output=True)  # noqa: S603
    log_path.write_text(
        f"$ {line}\n\n[stdout]\n{proc.stdout}\n\n[stderr]\n{proc.stderr}\n",
        encoding="utf-8",
    )
    if proc.returncode != 0:
        print(f"[ERROR] command failed ({proc.returncode}): {line}")
    return proc.returncode


def _render_markdown_report(
    output_path: Path,
    selected: dict[str, list[str]],
    whole_summary: dict[str, Any],
    diff_summary: dict[str, Any],
    comparison: dict[str, Any],
    failure_catalog: dict[str, Any],
) -> None:
    lines = [
        "# Diff Mode Benchmark Report",
        "",
        "## Selected Problems",
        "",
    ]
    for bench in sorted(selected):
        rows = selected[bench]
        lines.append(f"- `{bench}` ({len(rows)}): {', '.join(rows) if rows else '(none)'}")
    lines.extend(
        [
            "",
            "## Mode Summary",
            "",
            "| Metric | Whole | Diff |",
            "|:--|--:|--:|",
            f"| Problems | {whole_summary.get('problem_count', 0)} | {diff_summary.get('problem_count', 0)} |",
            f"| Total Tokens | {whole_summary.get('total_tokens', 0)} | {diff_summary.get('total_tokens', 0)} |",
            f"| Total Runtime (s) | {whole_summary.get('total_runtime_seconds', 0.0):.2f} | {diff_summary.get('total_runtime_seconds', 0.0):.2f} |",
            f"| Avg Functionality Rate | {((whole_summary.get('avg_functionality_rate') or 0.0) * 100.0):.2f}% | {((diff_summary.get('avg_functionality_rate') or 0.0) * 100.0):.2f}% |",
            f"| Avg Synthesis Rate | {((whole_summary.get('avg_synthesis_rate') or 0.0) * 100.0):.2f}% | {((diff_summary.get('avg_synthesis_rate') or 0.0) * 100.0):.2f}% |",
            "",
            "## Diff vs Whole",
            "",
            f"- Token savings vs whole: **{comparison.get('token_savings_vs_whole')}** "
            f"({(comparison.get('token_savings_pct_vs_whole') or 0.0):.2f}%)",
            f"- Runtime speedup vs whole: **{comparison.get('runtime_speedup_vs_whole_seconds'):.2f}s** "
            f"({(comparison.get('runtime_speedup_pct_vs_whole') or 0.0):.2f}%)",
            f"- Functionality delta (diff-whole): "
            f"{((comparison.get('avg_functionality_delta') or 0.0) * 100.0):.2f}%",
            f"- Synthesis delta (diff-whole): "
            f"{((comparison.get('avg_synthesis_delta') or 0.0) * 100.0):.2f}%",
            "",
            "## Diff Failure Catalog",
            "",
        ]
    )

    if not failure_catalog.get("counts"):
        lines.append("- No diff failure artifacts were found.")
    else:
        for reason, count in failure_catalog["counts"].items():
            lines.append(f"- `{reason}`: {count}")

    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Benchmark whole vs diff mode on hard tasks and summarize token/runtime deltas.",
    )
    parser.add_argument(
        "--benchmarks",
        nargs="+",
        default=list(SUPPORTED_BENCHMARKS),
        choices=list(SUPPORTED_BENCHMARKS),
    )
    parser.add_argument("--model_name", type=str, required=True)
    parser.add_argument(
        "--api_backend",
        type=str,
        default="vllm",
        choices=["openai", "openrouter", "deepseek", "gemini", "vllm"],
    )
    parser.add_argument("--vllm_host", type=str, default=os.getenv("VLLM_HOST", "vllm"))
    parser.add_argument("--vllm_port", type=int, default=int(os.getenv("VLLM_PORT", "8888")))
    parser.add_argument("--vllm_preflight_timeout_s", type=float, default=5.0)
    parser.add_argument("--vllm_min_model_len", type=int, default=int(os.getenv("VLLM_MIN_MODEL_LEN", "128000")))

    parser.add_argument("--save_root", type=Path, default=PROJECT_ROOT / "exp/diff_mode_benchmark")
    parser.add_argument("--baseline_report", type=Path, default=_default_baseline_report())
    parser.add_argument("--cvdp_jsonl", type=Path, default=DEFAULT_CVDP_JSONL)
    parser.add_argument("--cvdp_categories", nargs="+", default=["hard", "medium"])
    parser.add_argument(
        "--selection_profile",
        type=str,
        default="plan_defaults",
        choices=["plan_defaults", "baseline_hard"],
        help="Problem-selection policy. plan_defaults uses the fixed hard matrix from the diff-mode renewal plan.",
    )
    parser.add_argument("--rtllm_count", type=int, default=6)
    parser.add_argument("--verilogeval_count", type=int, default=6)
    parser.add_argument("--cvdp_count", type=int, default=6)
    parser.add_argument("--max_baseline_functionality", type=float, default=70.0)
    parser.add_argument("--rtllm_problems", nargs="+", default=None)
    parser.add_argument("--verilogeval_problems", nargs="+", default=None)
    parser.add_argument("--cvdp_ids", nargs="+", default=None)
    parser.add_argument(
        "--seeds",
        nargs="+",
        type=int,
        default=[1, 2],
        help="Matched seeds to run for each mode/problem set.",
    )

    parser.add_argument("--population_size", type=int, default=4)
    parser.add_argument("--num_generations", type=int, default=2)
    parser.add_argument("--num_workers", type=int, default=1)
    parser.add_argument("--temperature", type=float, default=1.0)
    parser.add_argument("--top_p", type=float, default=0.95)
    parser.add_argument("--max_tokens", type=int, default=2048)
    parser.add_argument("--strategy_selection", type=str, default="ucb", choices=["random", "epsilon-greedy", "ucb"])

    parser.add_argument("--diff_apply_policy", type=str, default="hybrid", choices=["strict", "hybrid", "fuzzy"])
    parser.add_argument("--diff_max_tokens", type=int, default=1024)
    parser.add_argument("--diff_compact_context", action=argparse.BooleanOptionalAction, default=True)
    parser.add_argument("--diff_similarity_threshold", type=float, default=0.86)
    parser.add_argument("--diff_fuzzy_margin", type=float, default=0.03)

    parser.add_argument("--dry_run", action="store_true")
    parser.add_argument("--stop_on_error", action=argparse.BooleanOptionalAction, default=False)
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)

    if args.api_backend == "vllm":
        preflight = preflight_vllm_model(
            host=args.vllm_host,
            port=args.vllm_port,
            min_model_len=args.vllm_min_model_len,
            timeout_s=args.vllm_preflight_timeout_s,
        )
        print(
            f"[vLLM preflight] endpoint={preflight.get('endpoint')} "
            f"model={preflight.get('model_id')} "
            f"max_model_len={preflight.get('max_model_len')} "
            f"min_required={args.vllm_min_model_len}"
        )
        if preflight.get("warning"):
            print(f"[vLLM preflight] WARNING: {preflight['warning']}")

    baseline_rows: dict[str, list[tuple[str, float]]] = {}
    if args.baseline_report:
        baseline_rows = parse_baseline_functionality_rates(args.baseline_report)

    selected: dict[str, list[str]] = {}
    if "RTLLM" in args.benchmarks:
        if args.rtllm_problems:
            selected["RTLLM"] = list(args.rtllm_problems)
        elif args.selection_profile == "plan_defaults":
            selected["RTLLM"] = PLAN_DEFAULT_RTLLM_HARD[: args.rtllm_count]
        else:
            selected["RTLLM"] = select_hard_problems(
                "RTLLM",
                args.rtllm_count,
                baseline_rows=baseline_rows,
                max_baseline_functionality=args.max_baseline_functionality,
            )
    if "VerilogEval-Spec-to-RTL" in args.benchmarks:
        if args.verilogeval_problems:
            selected["VerilogEval-Spec-to-RTL"] = list(args.verilogeval_problems)
        elif args.selection_profile == "plan_defaults":
            selected["VerilogEval-Spec-to-RTL"] = PLAN_DEFAULT_VERILOGEVAL_HARD[
                : args.verilogeval_count
            ]
        else:
            selected["VerilogEval-Spec-to-RTL"] = select_hard_problems(
                "VerilogEval-Spec-to-RTL",
                args.verilogeval_count,
                baseline_rows=baseline_rows,
                max_baseline_functionality=args.max_baseline_functionality,
            )
    if "cvdp" in args.benchmarks:
        if args.cvdp_ids:
            selected["cvdp"] = list(args.cvdp_ids)
        elif args.selection_profile == "plan_defaults":
            selected["cvdp"] = select_cvdp_medium_long_prompt_ids(
                args.cvdp_jsonl,
                args.cvdp_count,
                required_categories=("cid002", "cid003"),
                difficulty_label="medium",
            )
        else:
            selected["cvdp"] = select_cvdp_ids(
                args.cvdp_jsonl,
                args.cvdp_count,
                preferred_categories=args.cvdp_categories,
            )

    timestamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    out_root = args.save_root / timestamp
    mode_roots = {
        "whole": out_root / "whole",
        "diff": out_root / "diff",
    }
    logs_dir = out_root / "logs"
    logs_dir.mkdir(parents=True, exist_ok=True)

    print("[selection]")
    for bench, problems in selected.items():
        print(f"- {bench}: {len(problems)} problems")
    print(f"[seeds] {args.seeds}")

    failures: list[dict[str, Any]] = []

    for seed in args.seeds:
        seed_label = f"seed_{seed}"
        for mode in ("whole", "diff"):
            mode_root = mode_roots[mode] / seed_label
            mode_root.mkdir(parents=True, exist_ok=True)
            for benchmark, problems in selected.items():
                if not problems:
                    continue
                cmd = [
                    sys.executable,
                    str(PROJECT_ROOT / "scripts/run_evolution.py"),
                    "--benchmarks",
                    benchmark,
                    "--problems",
                    *problems,
                    "--api_backend",
                    args.api_backend,
                    "--model_name",
                    args.model_name,
                    "--save_path",
                    str(mode_root),
                    "--num_workers",
                    str(args.num_workers),
                    "--population_size",
                    str(args.population_size),
                    "--num_generations",
                    str(args.num_generations),
                    "--temperature",
                    str(args.temperature),
                    "--top_p",
                    str(args.top_p),
                    "--max_tokens",
                    str(args.max_tokens),
                    "--strategy_selection",
                    args.strategy_selection,
                    "--generation_mode",
                    mode,
                    "--vllm_host",
                    args.vllm_host,
                    "--vllm_port",
                    str(args.vllm_port),
                    "--vllm_min_model_len",
                    str(args.vllm_min_model_len),
                    "--vllm_preflight_timeout_s",
                    str(args.vllm_preflight_timeout_s),
                    "--seed",
                    str(seed),
                ]
                if benchmark == "cvdp":
                    cmd.extend(["--cvdp_jsonl", str(args.cvdp_jsonl)])
                    if args.selection_profile == "plan_defaults":
                        cmd.extend(["--cvdp_categories", "cid002", "cid003"])
                    else:
                        cmd.extend(["--cvdp_categories", *args.cvdp_categories])
                if mode == "diff":
                    cmd.extend(
                        [
                            "--diff_apply_policy",
                            args.diff_apply_policy,
                            "--diff_max_tokens",
                            str(args.diff_max_tokens),
                            "--diff_similarity_threshold",
                            str(args.diff_similarity_threshold),
                            "--diff_fuzzy_margin",
                            str(args.diff_fuzzy_margin),
                            "--diff_compact_context" if args.diff_compact_context else "--no-diff_compact_context",
                        ]
                    )

                log_path = logs_dir / f"{mode}_{benchmark}_{seed_label}.log"
                rc = _run_command(cmd, log_path, dry_run=args.dry_run)
                if rc != 0:
                    failures.append(
                        {
                            "seed": seed,
                            "mode": mode,
                            "benchmark": benchmark,
                            "returncode": rc,
                            "log": str(log_path),
                        }
                    )
                    if args.stop_on_error:
                        break
            if failures and args.stop_on_error:
                break
        if failures and args.stop_on_error:
            break

    whole_summary = summarize_problem_summaries(mode_roots["whole"])
    diff_summary = summarize_problem_summaries(mode_roots["diff"])
    comparison = compare_mode_summaries(whole_summary, diff_summary)
    failure_catalog = build_diff_failure_catalog(mode_roots["diff"])

    report = {
        "timestamp": timestamp,
        "seeds": args.seeds,
        "selection_profile": args.selection_profile,
        "selected_problems": selected,
        "failures": failures,
        "whole": whole_summary,
        "diff": diff_summary,
        "comparison": comparison,
        "diff_failure_catalog": failure_catalog,
    }

    json_path = out_root / "results.json"
    json_path.write_text(json.dumps(report, indent=2), encoding="utf-8")
    catalog_path = out_root / "diff_failure_catalog.json"
    catalog_path.write_text(json.dumps(failure_catalog, indent=2), encoding="utf-8")
    md_path = out_root / "results.md"
    _render_markdown_report(md_path, selected, whole_summary, diff_summary, comparison, failure_catalog)

    print(f"Results: {json_path}")
    print(f"Markdown: {md_path}")
    if failures:
        print(f"Completed with {len(failures)} command failures.")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
