#!/usr/bin/env python3
from __future__ import annotations

import argparse
import multiprocessing
import os
import subprocess
import sys
from pathlib import Path
from typing import Sequence


REPO_ROOT = Path(__file__).resolve().parents[1]


def _available_benchmarks() -> list[str]:
    root = REPO_ROOT / "data" / "bench"
    return sorted(
        d.name for d in root.iterdir() if d.is_dir() and d.name.lower() != "cvdp"
    )


def _safe_workers(requested: int) -> int:
    cpus = max(1, multiprocessing.cpu_count())
    return max(1, min(requested, cpus))


def _run_cmd(cmd: list[str]) -> None:
    print("\n[ablation] running:")
    print("  " + " ".join(cmd))
    subprocess.run(cmd, check=True, cwd=REPO_ROOT)


def _arg_value(cmd: Sequence[str], flag: str) -> str | None:
    try:
        idx = cmd.index(flag)
    except ValueError:
        return None
    if idx + 1 >= len(cmd):
        return None
    return cmd[idx + 1]


def _validate_fairness(
    *,
    revolution_cmd: list[str],
    funsearch_cmd: list[str],
    primary_budget_candidates: int,
) -> None:
    shared_flags = [
        "--evaluation_mode",
        "--benchmarks",
        "--api_backend",
        "--vllm_host",
        "--vllm_port",
        "--model_name",
        "--num_workers",
        "--temperature",
        "--top_p",
        "--max_tokens",
        "--seed",
    ]
    for flag in shared_flags:
        rev_value = _arg_value(revolution_cmd, flag)
        fs_value = _arg_value(funsearch_cmd, flag)
        if flag == "--benchmarks":
            # Benchmarks is variadic; enforce by string slice equality.
            rev_slice = " ".join(
                revolution_cmd[revolution_cmd.index(flag) + 1 : revolution_cmd.index("--api_backend")]
            )
            fs_slice = " ".join(
                funsearch_cmd[funsearch_cmd.index(flag) + 1 : funsearch_cmd.index("--api_backend")]
            )
            if rev_slice != fs_slice:
                raise ValueError(
                    f"Fairness check failed for {flag}: revolution='{rev_slice}' vs funsearch='{fs_slice}'"
                )
            continue
        if rev_value != fs_value:
            raise ValueError(
                f"Fairness check failed for {flag}: revolution='{rev_value}' vs funsearch='{fs_value}'"
            )

    rev_population = _arg_value(revolution_cmd, "--population_size")
    fs_max_evals = _arg_value(funsearch_cmd, "--fs_max_evaluations")
    if rev_population is None or fs_max_evals is None:
        raise ValueError("Missing primary budget flags in ablation commands.")
    if int(rev_population) != primary_budget_candidates or int(fs_max_evals) != primary_budget_candidates:
        raise ValueError(
            "Primary budget mismatch: expected both backends to use "
            f"{primary_budget_candidates} candidate evaluations."
        )

    if _arg_value(revolution_cmd, "--evaluation_mode") != "strict_ablation":
        raise ValueError("Ablation script requires strict_ablation mode for publishable comparison.")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run backend ablation sweeps for REvolution vs FunSearch."
    )
    parser.add_argument(
        "--benchmarks",
        nargs="+",
        default=_available_benchmarks(),
        help="Benchmark suites to include (defaults to all non-CVDP suites).",
    )
    parser.add_argument("--api_backend", type=str, default="vllm")
    parser.add_argument("--vllm_host", type=str, default=os.getenv("VLLM_HOST", "vllm"))
    parser.add_argument("--vllm_port", type=int, default=int(os.getenv("VLLM_PORT", "8888")))
    parser.add_argument("--model_name", type=str, default="/models/openai-gpt-oss-120b")
    parser.add_argument("--save_root", type=Path, default=REPO_ROOT / "exp" / "ablation")
    parser.add_argument("--num_workers", type=int, default=8)
    parser.add_argument("--candidate_workers", type=int, default=0)
    parser.add_argument(
        "--evaluation_mode",
        type=str,
        default="strict_ablation",
        choices=["strict_ablation", "search_accelerated"],
    )
    parser.add_argument("--accelerated_synthesis_top_k", type=int, default=1)
    parser.add_argument("--temperature", type=float, default=0.7)
    parser.add_argument("--top_p", type=float, default=0.95)
    parser.add_argument("--max_tokens", type=int, default=1024)
    parser.add_argument(
        "--seeds",
        nargs="+",
        type=int,
        default=[42],
        help="Run all backend conditions for each seed.",
    )
    parser.add_argument(
        "--max_evaluations",
        type=int,
        default=1,
        help="Primary budget axis: candidates evaluated per problem per backend.",
    )
    parser.add_argument(
        "--run_report",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="Generate backend comparison markdown after both runs.",
    )
    parser.add_argument(
        "--dry_run",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="Print validated commands without executing backend runs.",
    )
    args = parser.parse_args()

    workers = _safe_workers(args.num_workers)
    save_root = args.save_root.resolve()
    save_root.mkdir(parents=True, exist_ok=True)
    common = [
        "--benchmarks",
        *args.benchmarks,
        "--api_backend",
        args.api_backend,
        "--vllm_host",
        args.vllm_host,
        "--vllm_port",
        str(args.vllm_port),
        "--model_name",
        args.model_name,
        "--num_workers",
        str(workers),
        "--candidate_workers",
        str(max(0, args.candidate_workers)),
        "--evaluation_mode",
        args.evaluation_mode,
        "--accelerated_synthesis_top_k",
        str(max(0, args.accelerated_synthesis_top_k)),
        "--temperature",
        str(args.temperature),
        "--top_p",
        str(args.top_p),
        "--max_tokens",
        str(args.max_tokens),
    ]

    revolution_root = save_root / "revolution"
    funsearch_root = save_root / "funsearch"
    for seed in args.seeds:
        seed_tag = f"seed_{seed}"
        # Budget-normalized by candidate evaluations.
        rev_population_size = max(1, args.max_evaluations)
        rev_generations = 0
        revolution_cmd = [
            sys.executable,
            "scripts/run_backend.py",
            "--backend",
            "revolution",
            "--save_path",
            str(revolution_root / seed_tag),
            "--population_size",
            str(rev_population_size),
            "--num_generations",
            str(rev_generations),
            "--seed",
            str(seed),
            *common,
        ]

        fs_initial_population = max(1, args.max_evaluations)
        funsearch_cmd = [
            sys.executable,
            "scripts/run_backend.py",
            "--backend",
            "funsearch",
            "--save_path",
            str(funsearch_root / seed_tag),
            "--prompt_profile",
            "funsearch",
            "--fs_initial_population_size",
            str(fs_initial_population),
            "--fs_samples_per_prompt",
            "1",
            "--fs_num_islands",
            "8",
            "--fs_functions_per_prompt",
            "2",
            "--fs_max_evaluations",
            str(args.max_evaluations),
            "--fs_max_iterations",
            str(args.max_evaluations),
            "--seed",
            str(seed),
            *common,
        ]

        _validate_fairness(
            revolution_cmd=revolution_cmd,
            funsearch_cmd=funsearch_cmd,
            primary_budget_candidates=max(1, args.max_evaluations),
        )
        if args.dry_run:
            print("\n[ablation] dry-run validated command:")
            print("  " + " ".join(revolution_cmd))
            print("  " + " ".join(funsearch_cmd))
        else:
            _run_cmd(revolution_cmd)
            _run_cmd(funsearch_cmd)

    if args.run_report and not args.dry_run:
        report_path = save_root / "backend_comparison.md"
        comparison_cmd = [
            sys.executable,
            "scripts/backend_comparison_report.py",
            "--backend_run",
            f"revolution={revolution_root}",
            "--backend_run",
            f"funsearch={funsearch_root}",
            "--output",
            str(report_path),
        ]
        _run_cmd(comparison_cmd)
        print(f"\n[ablation] comparison report written: {report_path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
