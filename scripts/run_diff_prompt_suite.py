#!/usr/bin/env python3
from __future__ import annotations

import argparse
import asyncio
import datetime as dt
import hashlib
import json
import os
import sys
from collections import defaultdict
from pathlib import Path
from statistics import mean
from typing import Any


PROJECT_ROOT = Path(__file__).resolve().parents[1]
SRC_ROOT = PROJECT_ROOT / "src"
if str(SRC_ROOT) not in sys.path:
    sys.path.insert(0, str(SRC_ROOT))

from revolution.algorithm import EoHEngine  # noqa: E402
from revolution.llm import LLMInterface  # noqa: E402
from revolution.prompt_store import PromptStore  # noqa: E402
from revolution.vllm_preflight import preflight_vllm_model  # noqa: E402


DEFAULT_SUITE_FILE = PROJECT_ROOT / "data" / "diff_prompt_suite" / "diff_prompt_suite_v1.json"
DEFAULT_SAVE_ROOT = PROJECT_ROOT / "exp" / "diff_prompt_suite"
EXPECTED_BEHAVIORS = {"apply_success", "apply_or_safe_reject", "safe_reject_only"}
OBJECTIVE_WEIGHTS = {
    "format_ok": 0.20,
    "mode_ok": 0.10,
    "behavior_ok": 0.40,
    "terminal_ok": 0.30,
}


class _DiffPromptSuiteEngine(EoHEngine):
    def load_problem_description(self) -> str:
        return "Diff prompt optimization suite harness"


def _normalize_str_list(raw: Any, *, field_name: str, case_id: str) -> list[str]:
    if raw is None:
        return []
    if not isinstance(raw, list) or not all(isinstance(x, str) for x in raw):
        raise ValueError(
            f"Case '{case_id}' field '{field_name}' must be a list of strings."
        )
    return list(raw)


def load_suite(path: Path) -> dict[str, Any]:
    if not path.exists():
        raise FileNotFoundError(f"Suite file not found: {path}")
    payload = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise ValueError("Suite JSON must be an object.")
    if "cases" not in payload or not isinstance(payload["cases"], list):
        raise ValueError("Suite JSON must include a top-level 'cases' array.")
    if not payload["cases"]:
        raise ValueError("Suite must include at least one case.")

    normalized_cases: list[dict[str, Any]] = []
    for raw_case in payload["cases"]:
        if not isinstance(raw_case, dict):
            raise ValueError("Each case must be a JSON object.")
        case_id = raw_case.get("id")
        if not isinstance(case_id, str) or not case_id.strip():
            raise ValueError("Each case must define a non-empty string 'id'.")
        expected_behavior = raw_case.get("expected_behavior", "apply_success")
        if expected_behavior not in EXPECTED_BEHAVIORS:
            raise ValueError(
                f"Case '{case_id}' has invalid expected_behavior '{expected_behavior}'. "
                f"Allowed: {sorted(EXPECTED_BEHAVIORS)}"
            )
        for key in ("description", "file_to_edit", "original_file", "change_request"):
            if not isinstance(raw_case.get(key), str) or not raw_case[key].strip():
                raise ValueError(f"Case '{case_id}' field '{key}' must be a non-empty string.")

        normalized_cases.append(
            {
                "id": case_id,
                "description": raw_case["description"],
                "tags": _normalize_str_list(raw_case.get("tags", []), field_name="tags", case_id=case_id),
                "file_to_edit": raw_case["file_to_edit"],
                "original_file": raw_case["original_file"],
                "change_request": raw_case["change_request"],
                "expected_behavior": expected_behavior,
                "must_contain": _normalize_str_list(
                    raw_case.get("must_contain", []),
                    field_name="must_contain",
                    case_id=case_id,
                ),
                "must_not_contain": _normalize_str_list(
                    raw_case.get("must_not_contain", []),
                    field_name="must_not_contain",
                    case_id=case_id,
                ),
                "safe_reject_reason_codes": _normalize_str_list(
                    raw_case.get("safe_reject_reason_codes", []),
                    field_name="safe_reject_reason_codes",
                    case_id=case_id,
                ),
            }
        )

    case_ids = [c["id"] for c in normalized_cases]
    if len(case_ids) != len(set(case_ids)):
        raise ValueError("Suite case ids must be unique.")

    return {
        "suite_name": payload.get("suite_name", path.stem),
        "version": payload.get("version", 1),
        "description": payload.get("description", ""),
        "cases": normalized_cases,
    }


def select_cases(
    suite_cases: list[dict[str, Any]],
    *,
    case_ids: list[str] | None,
    tags: list[str] | None,
) -> list[dict[str, Any]]:
    selected = list(suite_cases)
    if case_ids:
        wanted = set(case_ids)
        selected = [c for c in selected if c["id"] in wanted]
    if tags:
        wanted_tags = {t.lower() for t in tags}
        selected = [
            c for c in selected if wanted_tags.intersection({t.lower() for t in c.get("tags", [])})
        ]
    return selected


def build_prompt(case: dict[str, Any]) -> str:
    payload = {
        "task": "diff_prompt_optimization_suite",
        "case_id": case["id"],
        "file_to_edit": case["file_to_edit"],
        "original_file": case["original_file"],
        "change_request": case["change_request"],
    }
    return (
        "Generate exactly one eoh_v1 diff JSON object for this edit request.\n"
        "Requirements:\n"
        "- mode must be diff.\n"
        "- code.edits must target a single file.\n"
        "- hunks must use concise, non-overlapping, unique search anchors.\n"
        "- output must be strict JSON with correct escaping.\n\n"
        f"CONTEXT_JSON:\n{json.dumps(payload, indent=2)}\n"
    )


def _compute_semantic_checks(applied_code: str, case: dict[str, Any]) -> tuple[bool, list[str]]:
    errors: list[str] = []
    for needle in case.get("must_contain", []):
        if needle not in applied_code:
            errors.append(f"missing required substring: {needle}")
    for needle in case.get("must_not_contain", []):
        if needle in applied_code:
            errors.append(f"forbidden substring still present: {needle}")
    return (len(errors) == 0, errors)


def _evaluate_behavior(
    case: dict[str, Any],
    *,
    apply_ok: bool,
    semantic_ok: bool,
    reason_code: str | None,
) -> tuple[bool, bool]:
    behavior = case["expected_behavior"]
    safe_codes = set(case.get("safe_reject_reason_codes", []))
    safe_reject_ok = (not apply_ok) and bool(reason_code in safe_codes)

    if behavior == "apply_success":
        hard_pass = apply_ok and semantic_ok
    elif behavior == "safe_reject_only":
        hard_pass = safe_reject_ok
    else:  # apply_or_safe_reject
        hard_pass = (apply_ok and semantic_ok) or safe_reject_ok

    return hard_pass, safe_reject_ok


def _attempt_score(
    *,
    format_ok: bool,
    mode_ok: bool,
    behavior_ok: bool,
    terminal_ok: bool,
) -> float:
    return (
        OBJECTIVE_WEIGHTS["format_ok"] * float(format_ok)
        + OBJECTIVE_WEIGHTS["mode_ok"] * float(mode_ok)
        + OBJECTIVE_WEIGHTS["behavior_ok"] * float(behavior_ok)
        + OBJECTIVE_WEIGHTS["terminal_ok"] * float(terminal_ok)
    )


def evaluate_attempt(
    *,
    case: dict[str, Any],
    repeat_index: int,
    thought: str | None,
    code: str | None,
    meta: dict[str, Any],
    applier: _DiffPromptSuiteEngine,
) -> dict[str, Any]:
    format_ok = bool(meta.get("format_ok"))
    parsed_mode = meta.get("parsed_mode")
    mode_ok = parsed_mode == "diff"
    strict_error = meta.get("error")

    apply_ok = False
    semantic_ok = False
    semantic_errors: list[str] = []
    applied_code = None
    diagnostics: dict[str, Any] = {}
    reason_code: str | None = None
    phase: str | None = None

    if format_ok and code:
        applied_code = applier._apply_diff(
            case["original_file"],
            code,
            target_file_path=case["file_to_edit"],
        )
        diagnostics = dict(applier._last_diff_apply_diagnostics)
        reason_code = diagnostics.get("reason_code")
        phase = diagnostics.get("phase")
        apply_ok = applied_code is not None
        if apply_ok and applied_code is not None:
            semantic_ok, semantic_errors = _compute_semantic_checks(applied_code, case)
    else:
        reason_code = "strict_parse_error"

    hard_pass, safe_reject_ok = _evaluate_behavior(
        case,
        apply_ok=apply_ok,
        semantic_ok=semantic_ok,
        reason_code=reason_code,
    )

    behavior_ok = hard_pass
    terminal_ok = semantic_ok if apply_ok else safe_reject_ok
    score = _attempt_score(
        format_ok=format_ok,
        mode_ok=mode_ok,
        behavior_ok=behavior_ok,
        terminal_ok=terminal_ok,
    )

    return {
        "case_id": case["id"],
        "description": case["description"],
        "tags": case.get("tags", []),
        "repeat_index": repeat_index,
        "expected_behavior": case["expected_behavior"],
        "format_ok": format_ok,
        "parsed_mode": parsed_mode,
        "mode_ok": mode_ok,
        "strict_error": strict_error,
        "apply_ok": apply_ok,
        "semantic_ok": semantic_ok,
        "semantic_errors": semantic_errors,
        "safe_reject_ok": safe_reject_ok,
        "hard_pass": hard_pass,
        "objective_score": score,
        "apply_reason_code": reason_code,
        "apply_phase": phase,
        "thought_preview": (thought or "")[:180],
        "raw_preview": (meta.get("raw") or "")[:240],
        "applied_sha256": (
            hashlib.sha256(applied_code.encode("utf-8")).hexdigest() if isinstance(applied_code, str) else None
        ),
        "diagnostics": diagnostics,
    }


def summarize_attempts(attempts: list[dict[str, Any]], llm_usage: dict[str, Any]) -> dict[str, Any]:
    total = len(attempts)
    format_ok = sum(1 for a in attempts if a["format_ok"])
    mode_ok = sum(1 for a in attempts if a["mode_ok"])
    apply_ok = sum(1 for a in attempts if a["apply_ok"])
    semantic_ok = sum(1 for a in attempts if a["semantic_ok"])
    safe_reject_ok = sum(1 for a in attempts if a["safe_reject_ok"])
    hard_pass = sum(1 for a in attempts if a["hard_pass"])
    objective_score = mean(a["objective_score"] for a in attempts) if attempts else 0.0

    reason_counts: dict[str, int] = defaultdict(int)
    phase_counts: dict[str, int] = defaultdict(int)
    for rec in attempts:
        if rec.get("apply_reason_code"):
            reason_counts[str(rec["apply_reason_code"])] += 1
        if rec.get("apply_phase"):
            phase_counts[str(rec["apply_phase"])] += 1

    case_groups: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for rec in attempts:
        case_groups[rec["case_id"]].append(rec)
    by_case: dict[str, dict[str, Any]] = {}
    for case_id in sorted(case_groups):
        rows = case_groups[case_id]
        by_case[case_id] = {
            "attempts": len(rows),
            "format_ok_rate": sum(1 for r in rows if r["format_ok"]) / len(rows),
            "apply_ok_rate": sum(1 for r in rows if r["apply_ok"]) / len(rows),
            "safe_reject_rate": sum(1 for r in rows if r["safe_reject_ok"]) / len(rows),
            "hard_pass_rate": sum(1 for r in rows if r["hard_pass"]) / len(rows),
            "objective_score_avg": mean(r["objective_score"] for r in rows),
        }

    def _pct(numerator: int) -> float:
        return (numerator / total * 100.0) if total else 0.0

    return {
        "total_attempts": total,
        "format_ok_count": format_ok,
        "format_ok_pct": _pct(format_ok),
        "mode_ok_count": mode_ok,
        "mode_ok_pct": _pct(mode_ok),
        "apply_ok_count": apply_ok,
        "apply_ok_pct": _pct(apply_ok),
        "semantic_ok_count": semantic_ok,
        "semantic_ok_pct": _pct(semantic_ok),
        "safe_reject_ok_count": safe_reject_ok,
        "safe_reject_ok_pct": _pct(safe_reject_ok),
        "hard_pass_count": hard_pass,
        "hard_pass_pct": _pct(hard_pass),
        "objective_score": objective_score,
        "reason_code_counts": dict(sorted(reason_counts.items())),
        "phase_counts": dict(sorted(phase_counts.items())),
        "by_case": by_case,
        "llm_usage": llm_usage,
    }


def render_report(output_path: Path, results: dict[str, Any]) -> None:
    summary = results["summary"]
    lines = [
        "# Diff Prompt Optimization Suite Report",
        "",
        f"- Suite: `{results['suite_name']}`",
        f"- Model: `{results['model_name']}` ({results['api_backend']})",
        f"- Attempts: {summary['total_attempts']}",
        f"- Objective Score: **{summary['objective_score']:.4f}**",
        f"- Hard Pass Rate: **{summary['hard_pass_pct']:.2f}%**",
        "",
        "## Aggregate Metrics",
        "",
        "| Metric | Value |",
        "|:--|--:|",
        f"| Format OK | {summary['format_ok_count']} ({summary['format_ok_pct']:.2f}%) |",
        f"| Mode OK (diff) | {summary['mode_ok_count']} ({summary['mode_ok_pct']:.2f}%) |",
        f"| Apply OK | {summary['apply_ok_count']} ({summary['apply_ok_pct']:.2f}%) |",
        f"| Semantic OK | {summary['semantic_ok_count']} ({summary['semantic_ok_pct']:.2f}%) |",
        f"| Safe Reject OK | {summary['safe_reject_ok_count']} ({summary['safe_reject_ok_pct']:.2f}%) |",
        "",
        "## Per-Case",
        "",
        "| Case | Attempts | Hard Pass | Apply OK | Safe Reject | Avg Objective |",
        "|:--|--:|--:|--:|--:|--:|",
    ]
    for case_id, stats in summary["by_case"].items():
        lines.append(
            f"| `{case_id}` | {stats['attempts']} | {stats['hard_pass_rate']*100.0:.2f}% | "
            f"{stats['apply_ok_rate']*100.0:.2f}% | {stats['safe_reject_rate']*100.0:.2f}% | "
            f"{stats['objective_score_avg']:.4f} |"
        )

    lines.extend(["", "## Reason Codes", ""])
    if summary["reason_code_counts"]:
        for reason, count in summary["reason_code_counts"].items():
            lines.append(f"- `{reason}`: {count}")
    else:
        lines.append("- none")

    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run a self-contained diff prompt optimization suite against an LLM and score robustness.",
    )
    parser.add_argument("--suite_file", type=Path, default=DEFAULT_SUITE_FILE)
    parser.add_argument("--case_ids", nargs="+", default=None)
    parser.add_argument("--tags", nargs="+", default=None)
    parser.add_argument("--repeat_per_case", type=int, default=1)

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
    parser.add_argument(
        "--skip_if_unreachable",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="If vLLM preflight is unreachable, write a skip artifact and exit 0.",
    )

    parser.add_argument(
        "--prompt_profile",
        type=str,
        default="default",
        help="Prompt profile under data/prompts/<profile>/ when no explicit prompt file is provided.",
    )
    parser.add_argument(
        "--prompt_root",
        type=Path,
        default=PROJECT_ROOT / "data" / "prompts",
        help="Root directory containing prompt profiles.",
    )
    parser.add_argument(
        "--system_prompt_file",
        type=Path,
        default=None,
        help="Optional explicit system prompt file to evaluate (for prompt-optimization candidates).",
    )

    parser.add_argument("--temperature", type=float, default=1.0)
    parser.add_argument("--top_p", type=float, default=0.95)
    parser.add_argument("--max_tokens", type=int, default=1024)

    parser.add_argument("--diff_apply_policy", type=str, default="hybrid", choices=["strict", "hybrid", "fuzzy"])
    parser.add_argument("--diff_similarity_threshold", type=float, default=0.86)
    parser.add_argument("--diff_fuzzy_margin", type=float, default=0.03)

    parser.add_argument("--save_root", type=Path, default=DEFAULT_SAVE_ROOT)
    return parser


def _resolve_api_key(api_backend: str) -> str | None:
    if api_backend == "openai":
        return os.getenv("OPENAI_API_KEY")
    if api_backend == "openrouter":
        return os.getenv("OPENROUTER_API_KEY")
    if api_backend == "deepseek":
        return os.getenv("DEEPSEEK_API_KEY")
    if api_backend == "gemini":
        return os.getenv("GEMINI_API_KEY")
    if api_backend == "vllm":
        return os.getenv("OPENAI_API_KEY") or "vllm-local-placeholder"
    return None


def _save_skip_artifact(
    *,
    save_root: Path,
    warning: str,
) -> int:
    ts = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    out_root = save_root / ts
    out_root.mkdir(parents=True, exist_ok=True)
    payload = {
        "timestamp": ts,
        "status": "skipped_unreachable_vllm",
        "warning": warning,
    }
    (out_root / "results.json").write_text(json.dumps(payload, indent=2), encoding="utf-8")
    (out_root / "results.md").write_text(
        "# Diff Prompt Optimization Suite Report\n\n- Skipped: vLLM endpoint unreachable.\n",
        encoding="utf-8",
    )
    print(f"Results: {out_root / 'results.json'}")
    print(f"Report: {out_root / 'results.md'}")
    return 0


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    if args.repeat_per_case < 1:
        raise ValueError("--repeat_per_case must be >= 1")

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
        warning = preflight.get("warning")
        if warning:
            print(f"[vLLM preflight] WARNING: {warning}")
            if args.skip_if_unreachable and "Unable to reach vLLM" in warning:
                return _save_skip_artifact(save_root=args.save_root, warning=warning)

    suite_payload = load_suite(args.suite_file.resolve())
    selected_cases = select_cases(
        suite_payload["cases"],
        case_ids=args.case_ids,
        tags=args.tags,
    )
    if not selected_cases:
        raise ValueError("No suite cases selected. Check --case_ids/--tags filters.")

    api_key = _resolve_api_key(args.api_backend)
    llm = LLMInterface(
        api_key=api_key,
        model_name=args.model_name,
        api_backend=args.api_backend,
        port=args.vllm_port,
        vllm_host=args.vllm_host,
    )

    prompt_source = ""
    system_prompt_override = None
    if args.system_prompt_file:
        prompt_path = args.system_prompt_file.resolve()
        system_prompt_override = prompt_path.read_text(encoding="utf-8")
        prompt_source = str(prompt_path)
    else:
        prompt_store = PromptStore(
            root_dir=str(args.prompt_root.resolve()),
            profile=args.prompt_profile,
        )
        system_prompt_override = prompt_store.read("system/diff")
        if system_prompt_override:
            prompt_source = str(args.prompt_root.resolve() / args.prompt_profile / "system" / "diff.txt")
        else:
            prompt_source = "LLMInterface internal fallback"
            print(
                "[suite] WARNING: profile system/diff prompt missing; using LLMInterface internal fallback."
            )

    applier = _DiffPromptSuiteEngine(
        benchmark_name="RTLLM",
        problem_name="Prob001_accu",
        llm_interface=llm,
        verilog_evaluator=object(),  # not used in this harness
        synthesis_evaluator=type("S", (), {"clk_period": 1.0})(),
        num_generations=0,
        population_size=1,
        generation_mode="diff",
        require_strict_format=True,
        diff_apply_policy=args.diff_apply_policy,
        diff_similarity_threshold=args.diff_similarity_threshold,
        diff_fuzzy_margin=args.diff_fuzzy_margin,
    )

    attempts: list[dict[str, Any]] = []
    for case in selected_cases:
        prompt = build_prompt(case)
        for repeat_idx in range(args.repeat_per_case):
            thought, code, meta = asyncio.run(
                llm.generate_response(
                    prompt=prompt,
                    temperature=args.temperature,
                    top_p=args.top_p,
                    max_tokens=args.max_tokens,
                    generation_mode="diff",
                    system_prompt_override=system_prompt_override,
                )
            )
            attempts.append(
                evaluate_attempt(
                    case=case,
                    repeat_index=repeat_idx,
                    thought=thought,
                    code=code,
                    meta=meta,
                    applier=applier,
                )
            )

    llm_usage = asyncio.run(llm.get_and_reset_usage_stats())
    summary = summarize_attempts(attempts, llm_usage)

    timestamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    out_root = args.save_root / timestamp
    out_root.mkdir(parents=True, exist_ok=True)

    prompt_hash = hashlib.sha256((system_prompt_override or "").encode("utf-8")).hexdigest()
    results = {
        "timestamp": timestamp,
        "suite_name": suite_payload["suite_name"],
        "suite_version": suite_payload["version"],
        "suite_path": str(args.suite_file.resolve()),
        "suite_case_count": len(suite_payload["cases"]),
        "selected_case_count": len(selected_cases),
        "selected_case_ids": [c["id"] for c in selected_cases],
        "repeat_per_case": args.repeat_per_case,
        "model_name": args.model_name,
        "api_backend": args.api_backend,
        "prompt_source": prompt_source,
        "prompt_sha256": prompt_hash,
        "diff_apply_policy": args.diff_apply_policy,
        "diff_similarity_threshold": args.diff_similarity_threshold,
        "diff_fuzzy_margin": args.diff_fuzzy_margin,
        "objective_weights": OBJECTIVE_WEIGHTS,
        "summary": summary,
        "attempts": attempts,
    }

    (out_root / "results.json").write_text(json.dumps(results, indent=2), encoding="utf-8")
    render_report(out_root / "results.md", results)

    print(f"Results: {out_root / 'results.json'}")
    print(f"Report: {out_root / 'results.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
