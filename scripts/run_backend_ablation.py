#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime
import math
import multiprocessing
import os
import subprocess
import sys
from pathlib import Path
from typing import Sequence

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.backends import registered_backend_names  # noqa: E402
from revolution.configuration import (  # noqa: E402
    ConfigError,
    parse_args_with_config,
    snapshot_run_configuration,
)


REPO_ROOT = Path(__file__).resolve().parents[1]
PRIMARY_BUDGET_AXES = ("candidate_evaluations", "llm_calls", "dual_gate")
DEFAULT_ABLATION_BACKENDS = ["revolution", "funsearch", "eoh", "codeevolve"]


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


def _flag_values(cmd: Sequence[str], flag: str) -> list[str]:
    try:
        idx = cmd.index(flag) + 1
    except ValueError:
        return []
    values: list[str] = []
    while idx < len(cmd) and not cmd[idx].startswith("--"):
        values.append(cmd[idx])
        idx += 1
    return values


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
    return target, 0


def _derive_eoh_schedule(
    *,
    target_candidates: int,
    preferred_population_size: int,
    operators_count: int,
) -> tuple[int, int, int]:
    target = max(1, target_candidates)
    ops = max(1, operators_count)
    population = max(1, preferred_population_size)
    if target < 2 * population:
        population = max(1, target // 2)
    base = 2 * population
    if target <= base:
        generations = 0
    else:
        generations = int(math.ceil((target - base) / max(1, population * ops)))
    estimated = base + generations * population * ops
    return population, generations, estimated


def _derive_codeevolve_schedule(
    *,
    target_candidates: int,
    preferred_num_islands: int,
    preferred_init_pop: int,
) -> tuple[int, int, int, int]:
    target = max(1, target_candidates)
    islands = max(1, min(preferred_num_islands, target))
    epochs = int(math.ceil(target / islands))
    init_pop = max(1, min(preferred_init_pop, epochs))
    estimated = islands * epochs
    return islands, epochs, init_pop, estimated


def _candidate_budget_from_cmd(backend: str, cmd: list[str]) -> int:
    if backend == "revolution":
        pop = _arg_value(cmd, "--population_size")
        generations = _arg_value(cmd, "--num_generations")
        if pop is None or generations is None:
            raise ValueError("Revolution command is missing schedule flags.")
        return int(pop) * (int(generations) + 1)
    if backend == "funsearch":
        max_evals = _arg_value(cmd, "--fs_max_evaluations")
        if max_evals is None:
            raise ValueError("FunSearch command is missing --fs_max_evaluations.")
        return int(max_evals)
    if backend == "eoh":
        population = _arg_value(cmd, "--eoh_population_size")
        generations = _arg_value(cmd, "--eoh_num_generations")
        max_evals = _arg_value(cmd, "--eoh_max_evaluations")
        operators = _flag_values(cmd, "--eoh_operators")
        if population is None or generations is None or max_evals is None or not operators:
            raise ValueError("EoH command is missing fairness flags.")
        estimated = 2 * int(population) + int(generations) * int(population) * len(operators)
        return min(estimated, int(max_evals))
    if backend == "codeevolve":
        islands = _arg_value(cmd, "--codeevolve_num_islands")
        epochs = _arg_value(cmd, "--codeevolve_num_epochs")
        max_evals = _arg_value(cmd, "--codeevolve_max_evaluations")
        if islands is None or epochs is None or max_evals is None:
            raise ValueError("CodeEvolve command is missing fairness flags.")
        estimated = int(islands) * int(epochs)
        return min(estimated, int(max_evals))
    raise ValueError(f"Unsupported backend '{backend}' in fairness validation.")


def _validate_fairness(
    *,
    backend_cmds: dict[str, list[str]],
    primary_budget_axis: str,
    primary_budget_candidates: int,
    max_llm_calls_per_problem: int | None,
) -> None:
    if not backend_cmds:
        raise ValueError("At least one backend command is required.")
    baseline_name = next(iter(backend_cmds))
    baseline_cmd = backend_cmds[baseline_name]
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
        baseline_values = _flag_values(baseline_cmd, flag) if flag == "--benchmarks" else [_arg_value(baseline_cmd, flag)]
        for backend, cmd in backend_cmds.items():
            candidate_values = _flag_values(cmd, flag) if flag == "--benchmarks" else [_arg_value(cmd, flag)]
            if baseline_values != candidate_values:
                raise ValueError(
                    f"Fairness check failed for {flag}: {baseline_name}={baseline_values} vs {backend}={candidate_values}"
                )

    for backend, cmd in backend_cmds.items():
        axis = _arg_value(cmd, "--primary_budget_axis")
        if axis != primary_budget_axis:
            raise ValueError(
                f"Primary budget axis metadata mismatch for {backend}: {axis} != {primary_budget_axis}"
            )
        candidate_budget = _candidate_budget_from_cmd(backend, cmd)
        if candidate_budget != primary_budget_candidates:
            raise ValueError(
                f"{backend} effective budget {candidate_budget} does not match the primary budget "
                f"{primary_budget_candidates}."
            )
        if _arg_value(cmd, "--evaluation_mode") != "strict_ablation":
            raise ValueError(
                "Ablation script requires strict_ablation mode for publishable comparison."
            )

    if primary_budget_axis in {"llm_calls", "dual_gate"}:
        if max_llm_calls_per_problem is None or max_llm_calls_per_problem <= 0:
            raise ValueError(
                "max_llm_calls_per_problem must be set for llm_calls/dual_gate modes."
            )
        llm_cap_flags = {
            "funsearch": "--fs_max_llm_calls",
            "eoh": "--eoh_max_llm_calls",
            "codeevolve": "--codeevolve_max_llm_calls",
        }
        for backend, cmd in backend_cmds.items():
            if backend == "revolution":
                if _candidate_budget_from_cmd(backend, cmd) > max_llm_calls_per_problem:
                    raise ValueError(
                        "Revolution candidate budget exceeds max_llm_calls_per_problem "
                        "under llm_calls/dual_gate fairness mode."
                    )
                continue
            flag = llm_cap_flags.get(backend)
            if flag is None:
                continue
            value = _arg_value(cmd, flag)
            if value is None or int(value) != max_llm_calls_per_problem:
                raise ValueError(
                    f"{backend} command must include {flag} matching the configured LLM-call cap."
                )


def _build_parser() -> tuple[argparse.ArgumentParser, argparse.ArgumentParser]:
    config_parser = argparse.ArgumentParser(add_help=False)
    config_parser.add_argument(
        "--config",
        type=str,
        help="Path to YAML/JSON config with default options.",
    )

    parser = argparse.ArgumentParser(
        description="Run backend ablation sweeps for REvolution, FunSearch, EoH, and CodeEvolve.",
        parents=[config_parser],
    )
    parser.add_argument(
        "--backends",
        nargs="+",
        default=DEFAULT_ABLATION_BACKENDS,
        choices=registered_backend_names(),
        help="Backend set to include in the ablation sweep.",
    )
    parser.add_argument(
        "--benchmarks",
        nargs="+",
        default=_available_benchmarks(),
        help="Benchmark suites to include (defaults to all non-CVDP suites).",
    )
    parser.add_argument(
        "--problems",
        nargs="+",
        default=None,
        help="Optional problem-id subset forwarded to each backend run.",
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
        "--eoh_population_size",
        type=int,
        default=10,
        help="Preferred EoH population size when deriving fairness schedules.",
    )
    parser.add_argument(
        "--eoh_operators",
        nargs="+",
        default=["e1", "e2", "m1", "m2", "m3"],
        help="Operators used per EoH generation in ablation runs.",
    )
    parser.add_argument(
        "--codeevolve_num_islands",
        type=int,
        default=3,
        help="Preferred CodeEvolve island count when deriving fairness schedules.",
    )
    parser.add_argument(
        "--codeevolve_init_pop",
        type=int,
        default=10,
        help="Preferred CodeEvolve init_pop when deriving fairness schedules.",
    )
    parser.add_argument(
        "--run_report",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="Generate backend comparison markdown after all backend runs.",
    )
    parser.add_argument(
        "--dry_run",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="Print validated commands without executing backend runs.",
    )
    return parser, config_parser


def _build_backend_commands(
    args: argparse.Namespace,
    *,
    seed: int,
    primary_budget_candidates: int,
    common: list[str],
    save_root: Path,
) -> tuple[dict[str, list[str]], dict[str, str]]:
    commands: dict[str, list[str]] = {}
    summaries: dict[str, str] = {}
    seed_tag = f"seed_{seed}"

    if "revolution" in args.backends:
        rev_population_size, rev_generations = _derive_revolution_schedule(
            target_candidates=primary_budget_candidates,
            preferred_population_size=args.revolution_population_size,
        )
        save_path = save_root / "revolution" / seed_tag
        commands["revolution"] = [
            sys.executable,
            "scripts/run_backend.py",
            "--backend",
            "revolution",
            "--save_path",
            str(save_path),
            "--population_size",
            str(rev_population_size),
            "--num_generations",
            str(rev_generations),
            "--seed",
            str(seed),
            *common,
        ]
        summaries["revolution"] = (
            f"revolution(pop={rev_population_size}, gen={rev_generations})"
        )

    if "funsearch" in args.backends:
        fs_initial_population = max(
            1,
            min(args.funsearch_initial_population_size, primary_budget_candidates),
        )
        fs_iterations = max(0, primary_budget_candidates - fs_initial_population)
        save_path = save_root / "funsearch" / seed_tag
        cmd = [
            sys.executable,
            "scripts/run_backend.py",
            "--backend",
            "funsearch",
            "--save_path",
            str(save_path),
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
            cmd.extend(["--fs_max_llm_calls", str(max(1, args.max_llm_calls_per_problem))])
        commands["funsearch"] = cmd
        summaries["funsearch"] = (
            f"funsearch(init={fs_initial_population}, iter={fs_iterations}, max_eval={primary_budget_candidates})"
        )

    if "eoh" in args.backends:
        eoh_population_size, eoh_generations, eoh_estimated = _derive_eoh_schedule(
            target_candidates=primary_budget_candidates,
            preferred_population_size=args.eoh_population_size,
            operators_count=len(args.eoh_operators),
        )
        save_path = save_root / "eoh" / seed_tag
        cmd = [
            sys.executable,
            "scripts/run_backend.py",
            "--backend",
            "eoh",
            "--save_path",
            str(save_path),
            "--prompt_profile",
            "eoh",
            "--eoh_population_size",
            str(eoh_population_size),
            "--eoh_num_generations",
            str(eoh_generations),
            "--eoh_operators",
            *[str(op).lower() for op in args.eoh_operators],
            "--eoh_max_evaluations",
            str(primary_budget_candidates),
            "--seed",
            str(seed),
            *common,
        ]
        if args.primary_budget_axis in {"llm_calls", "dual_gate"}:
            assert args.max_llm_calls_per_problem is not None
            cmd.extend(["--eoh_max_llm_calls", str(max(1, args.max_llm_calls_per_problem))])
        commands["eoh"] = cmd
        summaries["eoh"] = (
            f"eoh(pop={eoh_population_size}, gen={eoh_generations}, est_eval={eoh_estimated}, max_eval={primary_budget_candidates})"
        )

    if "codeevolve" in args.backends:
        ce_islands, ce_epochs, ce_init_pop, ce_estimated = _derive_codeevolve_schedule(
            target_candidates=primary_budget_candidates,
            preferred_num_islands=args.codeevolve_num_islands,
            preferred_init_pop=args.codeevolve_init_pop,
        )
        save_path = save_root / "codeevolve" / seed_tag
        cmd = [
            sys.executable,
            "scripts/run_backend.py",
            "--backend",
            "codeevolve",
            "--save_path",
            str(save_path),
            "--prompt_profile",
            "codeevolve",
            "--codeevolve_num_islands",
            str(ce_islands),
            "--codeevolve_num_epochs",
            str(ce_epochs),
            "--codeevolve_init_pop",
            str(ce_init_pop),
            "--codeevolve_max_evaluations",
            str(primary_budget_candidates),
            "--seed",
            str(seed),
            *common,
        ]
        if args.primary_budget_axis in {"llm_calls", "dual_gate"}:
            assert args.max_llm_calls_per_problem is not None
            cmd.extend(
                ["--codeevolve_max_llm_calls", str(max(1, args.max_llm_calls_per_problem))]
            )
        commands["codeevolve"] = cmd
        summaries["codeevolve"] = (
            f"codeevolve(islands={ce_islands}, epochs={ce_epochs}, init_pop={ce_init_pop}, "
            f"est_eval={ce_estimated}, max_eval={primary_budget_candidates})"
        )

    return commands, summaries


def main(argv: list[str] | None = None) -> int:
    parser, config_parser = _build_parser()
    try:
        args, config_from_file, raw_argv = parse_args_with_config(
            parser, config_parser, argv=argv
        )
    except ConfigError as exc:
        print(f"Configuration error: {exc}")
        return 2

    if not args.backends:
        print("No backends selected.")
        return 2

    workers = _safe_workers(args.num_workers)
    save_root = args.save_root.resolve()
    save_root.mkdir(parents=True, exist_ok=True)
    run_datetime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    run_config_path = save_root / f"{run_datetime}_ablation_config.yaml"
    allowed_keys = {action.dest for action in parser._actions if action.dest != "help"}
    snapshot_run_configuration(
        args,
        run_config_path,
        config_from_file=config_from_file,
        argv=raw_argv,
        allowed_keys=allowed_keys,
    )
    primary_budget_candidates = _resolve_candidate_budget(
        primary_budget_axis=args.primary_budget_axis,
        max_evaluations=max(1, args.max_evaluations),
        max_llm_calls_per_problem=args.max_llm_calls_per_problem,
    )
    common = [
        "--benchmarks",
        *args.benchmarks,
        *([] if not args.problems else ["--problems", *args.problems]),
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

    save_roots: dict[str, Path] = {}
    for backend in args.backends:
        save_roots[backend] = save_root / backend

    for seed in args.seeds:
        backend_cmds, summaries = _build_backend_commands(
            args,
            seed=seed,
            primary_budget_candidates=primary_budget_candidates,
            common=common,
            save_root=save_root,
        )
        _validate_fairness(
            backend_cmds=backend_cmds,
            primary_budget_axis=args.primary_budget_axis,
            primary_budget_candidates=primary_budget_candidates,
            max_llm_calls_per_problem=args.max_llm_calls_per_problem,
        )
        summary_text = " ".join(
            summary for backend, summary in summaries.items() if backend in backend_cmds
        )
        print(
            f"[ablation] seed={seed} axis={args.primary_budget_axis} "
            f"candidate_budget={primary_budget_candidates} {summary_text}"
        )
        ordered_backends = [backend for backend in args.backends if backend in backend_cmds]
        if args.dry_run:
            print("\n[ablation] dry-run validated commands:")
            for backend in ordered_backends:
                print("  " + " ".join(backend_cmds[backend]))
        else:
            for backend in ordered_backends:
                _run_cmd(backend_cmds[backend])

    if args.run_report and not args.dry_run:
        report_path = save_root / "backend_comparison.md"
        comparison_cmd = [
            sys.executable,
            "scripts/backend_comparison_report.py",
        ]
        for backend in args.backends:
            comparison_cmd.extend(
                ["--backend_run", f"{backend}={save_roots[backend]}"]
            )
        comparison_cmd.extend(["--output", str(report_path)])
        _run_cmd(comparison_cmd)
        print(f"\n[ablation] comparison report written: {report_path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
