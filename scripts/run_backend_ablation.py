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
PRIMARY_BUDGET_AXES = ("candidate_evaluations", "llm_calls", "dual_gate")


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


def _resolve_candidate_budget(
    *,
    primary_budget_axis: str,
    max_evaluations: int,
    max_llm_calls_per_problem: int | None,
) -> int:
    if primary_budget_axis == "candidate_evaluations":
        return max(1, max_evaluations)
    if max_llm_calls_per_problem is None or max_llm_calls_per_problem <= 0:
        raise ValueError(
            "--max_llm_calls_per_problem must be > 0 when using "
            f"--primary_budget_axis={primary_budget_axis}."
        )
    if primary_budget_axis == "llm_calls":
        return max(1, max_llm_calls_per_problem)
    if primary_budget_axis == "dual_gate":
        return max(1, min(max_evaluations, max_llm_calls_per_problem))
    raise ValueError(
        f"Unsupported primary budget axis '{primary_budget_axis}'. "
        f"Expected one of: {', '.join(PRIMARY_BUDGET_AXES)}."
    )


def _derive_revolution_schedule(
    *,
    target_candidates: int,
    preferred_population_size: int,
) -> tuple[int, int]:
    target = max(1, target_candidates)
    preferred = max(1, preferred_population_size)
    if target % preferred == 0:
        return preferred, (target // preferred) - 1
    # Keep exact candidate budget in non-divisible cases.
    return target, 0


def _validate_fairness(
    *,
    revolution_cmd: list[str],
    funsearch_cmd: list[str],
    primary_budget_axis: str,
    primary_budget_candidates: int,
    max_llm_calls_per_problem: int | None,
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
    rev_generations = _arg_value(revolution_cmd, "--num_generations")
    fs_max_evals = _arg_value(funsearch_cmd, "--fs_max_evaluations")
    if rev_population is None or rev_generations is None or fs_max_evals is None:
        raise ValueError("Missing primary budget flags in ablation commands.")
    rev_candidate_budget = int(rev_population) * (int(rev_generations) + 1)
    fs_candidate_budget = int(fs_max_evals)
    if (
        rev_candidate_budget != primary_budget_candidates
        or fs_candidate_budget != primary_budget_candidates
    ):
        raise ValueError(
            "Primary budget mismatch: expected both backends to use "
            f"{primary_budget_candidates} candidate evaluations."
        )

    rev_axis = _arg_value(revolution_cmd, "--primary_budget_axis")
    fs_axis = _arg_value(funsearch_cmd, "--primary_budget_axis")
    if rev_axis != primary_budget_axis or fs_axis != primary_budget_axis:
        raise ValueError(
            "Primary budget axis metadata mismatch between backend commands."
        )

    if primary_budget_axis in {"llm_calls", "dual_gate"}:
        if max_llm_calls_per_problem is None or max_llm_calls_per_problem <= 0:
            raise ValueError(
                "max_llm_calls_per_problem must be set for llm_calls/dual_gate modes."
            )
        fs_max_llm_calls = _arg_value(funsearch_cmd, "--fs_max_llm_calls")
        if fs_max_llm_calls is None or int(fs_max_llm_calls) != max_llm_calls_per_problem:
            raise ValueError(
                "FunSearch command must include --fs_max_llm_calls matching the configured cap."
            )
        if rev_candidate_budget > max_llm_calls_per_problem:
            raise ValueError(
                "Revolution candidate budget exceeds max_llm_calls_per_problem "
                "under llm_calls/dual_gate fairness mode."
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
        "--primary_budget_axis",
        type=str,
        default="candidate_evaluations",
        choices=list(PRIMARY_BUDGET_AXES),
        help=(
            "Fairness normalization axis. candidate_evaluations keeps the historical "
            "protocol; llm_calls enforces comparable API-call caps; dual_gate applies both."
        ),
    )
    parser.add_argument(
        "--max_llm_calls_per_problem",
        type=int,
        default=None,
        help=(
            "Per-problem LLM-call cap used in llm_calls/dual_gate modes. "
            "Ignored for candidate_evaluations mode."
        ),
    )
    parser.add_argument(
        "--revolution_population_size",
        type=int,
        default=10,
        help="Preferred REvolution population size when deriving exact candidate budgets.",
    )
    parser.add_argument(
        "--funsearch_initial_population_size",
        type=int,
        default=10,
        help="Initial FunSearch population size before iterative sampling.",
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
    primary_budget_candidates = _resolve_candidate_budget(
        primary_budget_axis=args.primary_budget_axis,
        max_evaluations=max(1, args.max_evaluations),
        max_llm_calls_per_problem=args.max_llm_calls_per_problem,
    )
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
        "--primary_budget_axis",
        args.primary_budget_axis,
    ]
    if args.max_llm_calls_per_problem is not None:
        common.extend(
            ["--max_llm_calls_per_problem", str(args.max_llm_calls_per_problem)]
        )

    revolution_root = save_root / "revolution"
    funsearch_root = save_root / "funsearch"
    for seed in args.seeds:
        seed_tag = f"seed_{seed}"
        rev_population_size, rev_generations = _derive_revolution_schedule(
            target_candidates=primary_budget_candidates,
            preferred_population_size=args.revolution_population_size,
        )
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

        fs_initial_population = max(
            1,
            min(args.funsearch_initial_population_size, primary_budget_candidates),
        )
        fs_iterations = max(0, primary_budget_candidates - fs_initial_population)
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
            str(primary_budget_candidates),
            "--fs_max_iterations",
            str(fs_iterations),
            "--seed",
            str(seed),
            *common,
        ]
        if args.primary_budget_axis in {"llm_calls", "dual_gate"}:
            assert args.max_llm_calls_per_problem is not None
            funsearch_cmd.extend(
                ["--fs_max_llm_calls", str(max(1, args.max_llm_calls_per_problem))]
            )

        _validate_fairness(
            revolution_cmd=revolution_cmd,
            funsearch_cmd=funsearch_cmd,
            primary_budget_axis=args.primary_budget_axis,
            primary_budget_candidates=primary_budget_candidates,
            max_llm_calls_per_problem=args.max_llm_calls_per_problem,
        )
        print(
            f"[ablation] seed={seed} axis={args.primary_budget_axis} "
            f"candidate_budget={primary_budget_candidates} "
            f"revolution(pop={rev_population_size}, gen={rev_generations}) "
            f"funsearch(init={fs_initial_population}, iter={fs_iterations}, max_eval={primary_budget_candidates})"
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
