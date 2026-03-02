#!/usr/bin/env python3
from __future__ import annotations

import argparse
import asyncio
import datetime as dt
import json
import os
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any


PROJECT_ROOT = Path(__file__).resolve().parents[1]
SRC_ROOT = PROJECT_ROOT / "src"
if str(SRC_ROOT) not in sys.path:
    sys.path.insert(0, str(SRC_ROOT))

from revolution.algorithm import EoHEngine  # noqa: E402
from revolution.llm import LLMInterface  # noqa: E402
from revolution.prompt_store import PromptStore  # noqa: E402
from revolution.vllm_preflight import is_unreachable_preflight, preflight_vllm_model  # noqa: E402


def _build_cases() -> list[dict[str, Any]]:
    long_lines = "\n".join([f"  logic [7:0] reg_{i};" for i in range(64)]) + "\n"
    long_module = (
        "module long_case(input logic clk, input logic rst_n);\n"
        f"{long_lines}"
        "  always_ff @(posedge clk or negedge rst_n) begin\n"
        "    if (!rst_n) begin\n"
        "      reg_0 <= 8'h00;\n"
        "    end else begin\n"
        "      reg_0 <= reg_0 + 8'h01;\n"
        "    end\n"
        "  end\n"
        "endmodule\n"
    )
    return [
        {
            "id": "quote_escape",
            "file_to_edit": "/tmp/diag_quote.sv",
            "original_file": (
                "module quote_case;\n"
                '  string s = "A";\n'
                "endmodule\n"
            ),
            "change_request": "Rename string value from A to AX and keep syntax valid.",
        },
        {
            "id": "newline_escape",
            "file_to_edit": "/tmp/diag_newline.sv",
            "original_file": (
                "module nl_case(input logic clk, input logic d, output logic q);\n"
                "  always_ff @(posedge clk) begin\n"
                "    q <= d;\n"
                "  end\n"
                "endmodule\n"
            ),
            "change_request": "Add synchronous active-high reset input rst and reset q to 0.",
        },
        {
            "id": "duplicate_anchor",
            "file_to_edit": "/tmp/diag_dup.sv",
            "original_file": (
                "module dup_case(input logic clk, input logic a, output logic y);\n"
                "  always_ff @(posedge clk) begin\n"
                "    y <= a;\n"
                "  end\n"
                "  always_ff @(posedge clk) begin\n"
                "    y <= a;\n"
                "  end\n"
                "endmodule\n"
            ),
            "change_request": "Update the first always_ff assignment to y <= ~a; do not touch the second block.",
        },
        {
            "id": "minimal_context",
            "file_to_edit": "/tmp/diag_min.sv",
            "original_file": (
                "module min_case(input logic a, input logic b, output logic y);\n"
                "  assign y = a & b;\n"
                "endmodule\n"
            ),
            "change_request": "Change AND to XOR with the smallest unique diff anchors.",
        },
        {
            "id": "long_file",
            "file_to_edit": "/tmp/diag_long.sv",
            "original_file": long_module,
            "change_request": "Double the increment step so reg_0 increases by 2 each cycle.",
        },
        {
            "id": "append_helper",
            "file_to_edit": "/tmp/diag_append.sv",
            "original_file": "module append_case;\nendmodule\n",
            "change_request": "Append a localparam WIDTH = 8 line inside module scope.",
        },
    ]


class _DiffDiagnosticsEngine(EoHEngine):
    def load_problem_description(self) -> str:
        return "Diff diagnostics helper"


def _build_prompt(case: dict[str, Any]) -> str:
    payload = {
        "task": "diff_output_robustness_diagnostics",
        "file_to_edit": case["file_to_edit"],
        "original_file": case["original_file"],
        "change_request": case["change_request"],
    }
    return (
        "Generate exactly one eoh_v1 diff JSON object for this edit request.\n"
        "The output must be strict JSON and must edit exactly one file.\n\n"
        f"CONTEXT_JSON:\n{json.dumps(payload, indent=2)}\n"
    )


def _to_float(value: Any, default: float = 0.0) -> float:
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def _build_failure_examples(
    attempts: list[dict[str, Any]],
    *,
    max_per_reason: int,
) -> dict[str, list[dict[str, Any]]]:
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for rec in attempts:
        if rec.get("apply_ok"):
            continue
        reason = str(rec.get("apply_reason_code") or "unknown")
        grouped[reason].append(rec)

    def _sort_key(rec: dict[str, Any]) -> tuple[Any, ...]:
        reason = str(rec.get("apply_reason_code") or "unknown")
        diag = rec.get("diagnostics") or {}
        strict_error = str(rec.get("strict_error") or "")
        raw_preview = str(rec.get("raw_preview") or "")

        if reason == "ambiguous_fuzzy_match":
            best = _to_float(diag.get("best_ratio"), 0.0)
            second = _to_float(diag.get("second_ratio"), 0.0)
            gap = best - second
            # Smaller gap means more ambiguous and therefore "worse".
            return (0, gap, -best, str(rec.get("case_id") or ""), int(rec.get("repeat_index") or 0))

        if reason == "fuzzy_below_threshold":
            best = _to_float(diag.get("best_ratio"), 0.0)
            # Lower best ratio means further from threshold and therefore "worse".
            return (1, best, str(rec.get("case_id") or ""), int(rec.get("repeat_index") or 0))

        if reason == "strict_parse_error":
            lower_err = strict_error.lower()
            is_escape = ("escape" in lower_err) or ("invalid \\escape" in lower_err)
            # Prioritize escaping failures and more informative/larger raw payload snippets.
            return (2, 0 if is_escape else 1, -len(strict_error), -len(raw_preview), str(rec.get("case_id") or ""))

        return (3, str(rec.get("case_id") or ""), int(rec.get("repeat_index") or 0))

    out: dict[str, list[dict[str, Any]]] = {}
    for reason in sorted(grouped):
        chosen = sorted(grouped[reason], key=_sort_key)[: max(1, max_per_reason)]
        rows: list[dict[str, Any]] = []
        for rec in chosen:
            diag = rec.get("diagnostics") or {}
            top_candidates = diag.get("top_candidates")
            if isinstance(top_candidates, list):
                top_candidates = top_candidates[:3]
            else:
                top_candidates = None
            rows.append(
                {
                    "case_id": rec.get("case_id"),
                    "repeat_index": rec.get("repeat_index"),
                    "apply_phase": rec.get("apply_phase"),
                    "strict_error": rec.get("strict_error"),
                    "reason": diag.get("reason"),
                    "best_ratio": diag.get("best_ratio"),
                    "second_ratio": diag.get("second_ratio"),
                    "raw_preview": rec.get("raw_preview"),
                    "top_candidates": top_candidates,
                }
            )
        out[reason] = rows
    return out


def _render_report(output_path: Path, results: dict[str, Any]) -> None:
    summary = results["summary"]
    lines = [
        "# Diff Mode Diagnostics Report",
        "",
        "## Summary",
        "",
        f"- Total attempts: {summary['total_attempts']}",
        f"- Strict format pass: {summary['format_ok']} ({summary['format_ok_pct']:.2f}%)",
        f"- Apply pass: {summary['apply_ok']} ({summary['apply_ok_pct']:.2f}%)",
        "",
        "## Apply Failure Reasons",
        "",
    ]
    if not summary["apply_fail_reason_counts"]:
        lines.append("- none")
    else:
        for reason, count in summary["apply_fail_reason_counts"].items():
            lines.append(f"- `{reason}`: {count}")

    lines.extend(
        [
            "",
            "## Phase Distribution",
            "",
        ]
    )
    if not summary["diff_phase_counts"]:
        lines.append("- none")
    else:
        for phase, count in summary["diff_phase_counts"].items():
            lines.append(f"- `{phase}`: {count}")

    lines.extend(
        [
            "",
            "## Worst-Case Failure Samples",
            "",
            "| Reason | Case | Repeat | Phase | Detail |",
            "|:--|:--|--:|:--|:--|",
        ]
    )
    failure_examples = summary.get("failure_examples", {}) or {}
    if not failure_examples:
        lines.append("| none | - | - | - | - |")
    else:
        for reason, rows in failure_examples.items():
            for row in rows:
                detail = (
                    str(row.get("reason") or row.get("strict_error") or row.get("raw_preview") or "")
                    .replace("\n", "\\n")
                    .replace("|", "\\|")
                )
                if len(detail) > 120:
                    detail = detail[:117] + "..."
                lines.append(
                    f"| `{reason}` | `{row.get('case_id')}` | {row.get('repeat_index')} | "
                    f"`{row.get('apply_phase')}` | {detail or '-'} |"
                )

    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run real-LLM diff output diagnostics and collect parse/apply failure taxonomy.",
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
    parser.add_argument(
        "--skip_if_unreachable",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="If vLLM preflight is unreachable, record a note and exit successfully.",
    )
    parser.add_argument("--repeat_per_case", type=int, default=5)
    parser.add_argument(
        "--prompt_profile",
        type=str,
        default="default",
        help="Prompt profile under data/prompts/<profile>/ to use for system prompts.",
    )
    parser.add_argument(
        "--prompt_root",
        type=Path,
        default=PROJECT_ROOT / "data" / "prompts",
        help="Root directory containing prompt profiles.",
    )
    parser.add_argument("--temperature", type=float, default=1.0)
    parser.add_argument("--top_p", type=float, default=0.95)
    parser.add_argument("--max_tokens", type=int, default=1024)
    parser.add_argument(
        "--failure_examples_per_reason",
        type=int,
        default=5,
        help="How many worst-case failure samples to keep per reason code.",
    )
    parser.add_argument(
        "--save_root",
        type=Path,
        default=PROJECT_ROOT / "exp/diff_mode_diagnostics",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    if args.failure_examples_per_reason < 1:
        raise ValueError("--failure_examples_per_reason must be >= 1")

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
        if args.skip_if_unreachable and is_unreachable_preflight(preflight):
            ts = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
            out_root = args.save_root / ts
            out_root.mkdir(parents=True, exist_ok=True)
            payload = {
                "timestamp": ts,
                "status": "skipped_unreachable_vllm",
                "warning": warning or "vLLM preflight indicates endpoint is unreachable.",
            }
            (out_root / "results.json").write_text(
                json.dumps(payload, indent=2), encoding="utf-8"
            )
            (out_root / "results.md").write_text(
                "# Diff Mode Diagnostics Report\n\n- Skipped: vLLM endpoint unreachable.\n",
                encoding="utf-8",
            )
            print(f"Results: {out_root / 'results.json'}")
            print(f"Report: {out_root / 'results.md'}")
            return 0

    api_key = None
    if args.api_backend == "openai":
        api_key = os.getenv("OPENAI_API_KEY")
    elif args.api_backend == "openrouter":
        api_key = os.getenv("OPENROUTER_API_KEY")
    elif args.api_backend == "deepseek":
        api_key = os.getenv("DEEPSEEK_API_KEY")
    elif args.api_backend == "gemini":
        api_key = os.getenv("GEMINI_API_KEY")
    elif args.api_backend == "vllm":
        api_key = os.getenv("OPENAI_API_KEY") or "vllm-local-placeholder"

    llm = LLMInterface(
        api_key=api_key,
        model_name=args.model_name,
        api_backend=args.api_backend,
        port=args.vllm_port,
        vllm_host=args.vllm_host,
    )
    prompt_store = PromptStore(
        root_dir=str(args.prompt_root.resolve()),
        profile=args.prompt_profile,
    )
    system_prompt_override = prompt_store.read("system/diff")
    if not system_prompt_override:
        print(
            "[diagnostics] WARNING: Missing profile system prompt 'system/diff'; "
            "falling back to LLMInterface internal prompt."
        )

    applier = _DiffDiagnosticsEngine(
        benchmark_name="RTLLM",
        problem_name="Prob001_accu",
        llm_interface=llm,
        verilog_evaluator=object(),  # not used by diagnostics
        synthesis_evaluator=type("S", (), {"clk_period": 1.0})(),
        num_generations=0,
        population_size=1,
        generation_mode="diff",
        require_strict_format=True,
    )

    attempts: list[dict[str, Any]] = []
    cases = _build_cases()
    for case in cases:
        prompt = _build_prompt(case)
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
            rec: dict[str, Any] = {
                "case_id": case["id"],
                "repeat_index": repeat_idx,
                "format_ok": bool(meta.get("format_ok")),
                "strict_error": meta.get("error"),
                "parsed_mode": meta.get("parsed_mode"),
                "thought_preview": (thought or "")[:160],
                "raw_preview": (meta.get("raw") or "")[:260],
            }
            if rec["format_ok"]:
                applied = applier._apply_diff(
                    case["original_file"],
                    code or "",
                    target_file_path=case["file_to_edit"],
                )
                diag = dict(applier._last_diff_apply_diagnostics)
                rec["apply_ok"] = applied is not None
                rec["apply_reason_code"] = diag.get("reason_code")
                rec["apply_phase"] = diag.get("phase")
                rec["diagnostics"] = diag
            else:
                rec["apply_ok"] = False
                rec["apply_reason_code"] = "strict_parse_error"
                rec["apply_phase"] = None
            attempts.append(rec)

    stats = asyncio.run(llm.get_and_reset_usage_stats())

    total = len(attempts)
    format_ok = sum(1 for a in attempts if a["format_ok"])
    apply_ok = sum(1 for a in attempts if a["apply_ok"])
    apply_fail_reason_counts: dict[str, int] = defaultdict(int)
    diff_phase_counts: dict[str, int] = defaultdict(int)
    for rec in attempts:
        if not rec["apply_ok"]:
            apply_fail_reason_counts[str(rec.get("apply_reason_code") or "unknown")] += 1
        phase = rec.get("apply_phase")
        if phase:
            diff_phase_counts[str(phase)] += 1
    failure_examples = _build_failure_examples(
        attempts,
        max_per_reason=args.failure_examples_per_reason,
    )

    summary = {
        "total_attempts": total,
        "format_ok": format_ok,
        "format_ok_pct": (format_ok / total * 100.0) if total else 0.0,
        "apply_ok": apply_ok,
        "apply_ok_pct": (apply_ok / total * 100.0) if total else 0.0,
        "apply_fail_reason_counts": dict(sorted(apply_fail_reason_counts.items())),
        "diff_phase_counts": dict(sorted(diff_phase_counts.items())),
        "failure_examples_per_reason": args.failure_examples_per_reason,
        "failure_examples": failure_examples,
        "llm_usage": stats,
    }

    ts = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    out_root = args.save_root / ts
    out_root.mkdir(parents=True, exist_ok=True)
    results = {
        "timestamp": ts,
        "model_name": args.model_name,
        "api_backend": args.api_backend,
        "repeat_per_case": args.repeat_per_case,
        "prompt_profile": args.prompt_profile,
        "prompt_root": str(args.prompt_root.resolve()),
        "system_prompt_source": (
            f"{Path(args.prompt_root.resolve()) / args.prompt_profile / 'system' / 'diff.txt'}"
            if system_prompt_override
            else "LLMInterface internal fallback"
        ),
        "summary": summary,
        "attempts": attempts,
    }
    (out_root / "results.json").write_text(json.dumps(results, indent=2), encoding="utf-8")
    _render_report(out_root / "results.md", results)
    print(f"Results: {out_root / 'results.json'}")
    print(f"Report: {out_root / 'results.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
