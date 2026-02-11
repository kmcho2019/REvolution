import argparse
import datetime
import multiprocessing
import os
import sys
import time
from pathlib import Path
from typing import Any

from tqdm import tqdm

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.backends import (  # noqa: E402
    BackendExecutionContext,
    BackendServices,
    FunSearchBackend,
    FunSearchBackendConfig,
    RevolutionBackend,
    RevolutionBackendConfig,
)
from revolution.configuration import (  # noqa: E402
    ConfigError,
    parse_args_with_config,
    snapshot_run_configuration,
)
from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator  # noqa: E402
from revolution.llm import LLMInterface  # noqa: E402
from revolution.prompt_store import PromptStore  # noqa: E402
from revolution.runtime import ArtifactWriter, CandidateEvaluator, load_problem_context  # noqa: E402
from revolution.utils import StreamRedirector  # noqa: E402


def _derive_seed(base_seed: int | None, index: int) -> int | None:
    if base_seed is None:
        return None
    return int(base_seed + index * 9973)


def _resolve_api_key(args: argparse.Namespace) -> str | None:
    if args.api_backend == "vllm":
        return os.getenv("OPENAI_API_KEY") or "vllm-local-placeholder"
    env_map = {
        "openai": "OPENAI_API_KEY",
        "openrouter": "OPENROUTER_API_KEY",
        "deepseek": "DEEPSEEK_API_KEY",
        "gemini": "GEMINI_API_KEY",
    }
    required = env_map.get(args.api_backend)
    if required is None:
        return None
    value = os.getenv(required)
    if not value:
        raise ValueError(
            f"API key for backend '{args.api_backend}' not found in environment variable '{required}'."
        )
    return value


def _resolve_prompt_profile(args: argparse.Namespace) -> str:
    if args.prompt_profile:
        return args.prompt_profile
    if args.backend == "funsearch":
        return "funsearch"
    return "default"


def _effective_save_path(args: argparse.Namespace) -> str:
    if getattr(args, "backend_subdir", True):
        return os.path.join(args.save_path, args.backend)
    return args.save_path


def _build_backend(
    args: argparse.Namespace,
    benchmark: str,
    problem: str,
    task_seed: int | None,
):
    prompt_profile = _resolve_prompt_profile(args)
    prompt_root = args.prompt_root or os.path.abspath(
        os.path.join(os.path.dirname(__file__), "..", "data", "prompts")
    )

    llm_interface = LLMInterface(
        api_key=_resolve_api_key(args),
        model_name=args.model_name,
        api_backend=args.api_backend,
        port=args.vllm_port,
        vllm_host=args.vllm_host,
    )
    verilog_evaluator = VerilogEvaluator(
        iverilog_executable_path="iverilog", vvp_executable_path="vvp"
    )
    synthesis_evaluator = SynthesisEvaluator()

    problem_context = load_problem_context(benchmark, problem)
    prompt_store = PromptStore(root_dir=prompt_root, profile=prompt_profile)
    effective_save_path = _effective_save_path(args)
    artifact_writer = ArtifactWriter(
        save_path=effective_save_path,
        model_name=args.model_name,
        benchmark_name=benchmark,
        problem_name=problem,
    )
    candidate_evaluator = CandidateEvaluator(
        context=problem_context,
        problem_description=problem_context.problem_description,
        verilog_evaluator=verilog_evaluator,
        synthesis_evaluator=synthesis_evaluator,
        evaluation_mode=args.evaluation_mode,
        accelerated_synthesis_top_k=args.accelerated_synthesis_top_k,
    )
    services = BackendServices(
        llm=llm_interface,
        verilog_evaluator=verilog_evaluator,
        synthesis_evaluator=synthesis_evaluator,
        prompt_store=prompt_store,
        artifact_writer=artifact_writer,
        candidate_evaluator=candidate_evaluator,
    )
    context = BackendExecutionContext(
        backend_name=args.backend,
        model_name=args.model_name,
        benchmark_name=benchmark,
        problem_name=problem,
        problem_context=problem_context,
        generation_mode=args.generation_mode,
        seed=task_seed,
        metadata={"seed": task_seed},
    )

    if args.backend == "revolution":
        backend_cfg = RevolutionBackendConfig(
            population_size=args.population_size,
            num_generations=args.num_generations,
            default_llm_temp=args.temperature,
            default_llm_top_p=args.top_p,
            default_llm_max_tokens=args.max_tokens,
            strategy_selection_method=args.strategy_selection,
            epsilon=args.epsilon,
            ucb_c=args.ucb_c,
            generation_mode=args.generation_mode,
            population_pool_mode=args.population_pool_mode,
            require_strict_format=True,
            prompt_profile=prompt_profile,
            prompt_root=prompt_root,
            candidate_workers=args.candidate_workers,
        )
        return RevolutionBackend(
            context=context,
            services=services,
            config=backend_cfg,
            base_save_path=effective_save_path,
        )

    feedback_policy = args.fs_feedback_policy
    if args.fs_enable_feedback and feedback_policy == "off":
        feedback_policy = "always"

    fs_cfg = FunSearchBackendConfig(
        initial_population_size=args.fs_initial_population_size,
        samples_per_prompt=args.fs_samples_per_prompt,
        num_islands=args.fs_num_islands,
        functions_per_prompt=args.fs_functions_per_prompt,
        reset_period_seconds=args.fs_reset_period_seconds,
        cluster_sampling_temperature_init=args.fs_cluster_temp_init,
        cluster_sampling_temperature_period=args.fs_cluster_temp_period,
        program_sampling_temperature=args.fs_program_sampling_temp,
        max_evaluations=args.fs_max_evaluations,
        max_iterations=args.fs_max_iterations,
        max_runtime_seconds=args.fs_max_runtime_seconds,
        max_llm_calls=args.fs_max_llm_calls,
        max_llm_tokens=args.fs_max_llm_tokens,
        default_llm_temp=args.temperature,
        default_llm_top_p=args.top_p,
        default_llm_max_tokens=args.max_tokens,
        prompt_profile=prompt_profile,
        prompt_root=prompt_root,
        strict_prompt_keys=args.fs_strict_prompt_keys,
        allow_diff_mode=args.fs_allow_diff_mode,
        score_reducer=args.fs_score_reducer,
        failed_candidate_bucket_score=args.fs_failed_candidate_bucket_score,
        feedback_policy=feedback_policy,
        feedback_sample_probability=args.fs_feedback_sample_probability,
        seed=task_seed,
        candidate_workers=args.candidate_workers,
    )
    return FunSearchBackend(context=context, services=services, config=fs_cfg)


def run_problem_worker(args_tuple: tuple[str, str, argparse.Namespace, int]):
    benchmark, problem, args, task_index = args_tuple
    task_seed = _derive_seed(args.seed, task_index)
    if task_seed is not None:
        os.environ["PYTHONHASHSEED"] = str(task_seed)

    model_name_cleaned = args.model_name.replace("/", "_")
    effective_save_path = _effective_save_path(args)
    problem_log_dir = os.path.join(effective_save_path, model_name_cleaned, benchmark, problem)
    os.makedirs(problem_log_dir, exist_ok=True)
    individual_log_path = os.path.join(problem_log_dir, "problem_run.log")

    with StreamRedirector(filepath=individual_log_path):
        print(
            f"\n[Worker PID: {os.getpid()}] backend={args.backend} starting {benchmark}/{problem} seed={task_seed}\n"
        )
        backend = _build_backend(args, benchmark, problem, task_seed)
        result = backend.run()
        print(
            f"[Worker PID: {os.getpid()}] finished {benchmark}/{problem} status={result.status}\n"
        )
        return result.result_string, individual_log_path


def run_indexed_problem_worker(indexed_task):
    index, payload = indexed_task
    benchmark, problem, args = payload
    result = run_problem_worker((benchmark, problem, args, index))
    return index, result


def _build_parser() -> tuple[argparse.ArgumentParser, argparse.ArgumentParser]:
    config_parser = argparse.ArgumentParser(add_help=False)
    config_parser.add_argument(
        "--config",
        type=str,
        help="Path to YAML/JSON config with default options.",
    )

    parser = argparse.ArgumentParser(
        description="Run REvolution/FunSearch backends on benchmark problems.",
        parents=[config_parser],
    )
    benchmark_root = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "..", "data", "bench")
    )
    available_benchmarks = [
        d
        for d in os.listdir(benchmark_root)
        if os.path.isdir(os.path.join(benchmark_root, d))
    ]

    parser.add_argument("--backend", type=str, default="revolution", choices=["revolution", "funsearch"])
    parser.add_argument(
        "--benchmarks",
        nargs="+",
        default=available_benchmarks,
        choices=available_benchmarks,
    )
    parser.add_argument("--problems", nargs="+")
    parser.add_argument(
        "--api_backend",
        type=str,
        default="openai",
        choices=["openai", "openrouter", "deepseek", "gemini", "vllm"],
    )
    parser.add_argument(
        "--vllm_port",
        type=int,
        default=int(os.getenv("VLLM_PORT", "8888")),
    )
    parser.add_argument(
        "--vllm_host",
        type=str,
        default=os.getenv("VLLM_HOST", "localhost"),
    )
    parser.add_argument("--model_name", type=str, default="gpt-4.1-mini")
    parser.add_argument("--save_path", type=str, default=os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "exp")))
    parser.add_argument("--num_workers", type=int, default=1)
    parser.add_argument("--candidate_workers", type=int, default=0)
    parser.add_argument(
        "--evaluation_mode",
        type=str,
        default="strict_ablation",
        choices=["strict_ablation", "search_accelerated"],
        help="Evaluation semantics. strict_ablation runs full syntax/functionality/synthesis on all candidates.",
    )
    parser.add_argument(
        "--accelerated_synthesis_top_k",
        type=int,
        default=1,
        help="For search_accelerated mode: synthesize only top-K functional candidates per batch (deterministic shortest-code policy).",
    )
    parser.add_argument("--temperature", type=float, default=1.0)
    parser.add_argument("--top_p", type=float, default=0.95)
    parser.add_argument("--max_tokens", type=int, default=2048)
    parser.add_argument("--generation_mode", type=str, default="whole", choices=["whole", "diff"])
    parser.add_argument("--prompt_profile", type=str, default=None)
    parser.add_argument("--prompt_root", type=str, default=None)
    parser.add_argument(
        "--backend_subdir",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="When true (default), writes backend outputs under <save_path>/<backend>/...",
    )
    parser.add_argument("--seed", type=int, default=None)

    # REvolution-specific
    parser.add_argument("--population_size", type=int, default=5)
    parser.add_argument("--num_generations", type=int, default=5)
    parser.add_argument(
        "--strategy_selection",
        type=str,
        default="random",
        choices=["random", "epsilon-greedy", "ucb"],
    )
    parser.add_argument("--epsilon", type=float, default=0.1)
    parser.add_argument("--ucb_c", type=float, default=2.0)
    parser.add_argument("--population_pool_mode", type=str, default="dual", choices=["dual", "single"])

    # FunSearch-specific
    parser.add_argument("--fs_initial_population_size", type=int, default=4)
    parser.add_argument("--fs_samples_per_prompt", type=int, default=1)
    parser.add_argument("--fs_num_islands", type=int, default=10)
    parser.add_argument("--fs_functions_per_prompt", type=int, default=2)
    parser.add_argument("--fs_reset_period_seconds", type=int, default=4 * 60 * 60)
    parser.add_argument("--fs_cluster_temp_init", type=float, default=0.1)
    parser.add_argument("--fs_cluster_temp_period", type=int, default=30_000)
    parser.add_argument("--fs_program_sampling_temp", type=float, default=1.0)
    parser.add_argument("--fs_max_evaluations", type=int, default=None)
    parser.add_argument("--fs_max_iterations", type=int, default=None)
    parser.add_argument("--fs_max_runtime_seconds", type=float, default=None)
    parser.add_argument("--fs_max_llm_calls", type=int, default=None)
    parser.add_argument("--fs_max_llm_tokens", type=int, default=None)
    parser.add_argument(
        "--fs_score_reducer",
        type=str,
        default="last_input",
        choices=["last_input", "mean", "fitness"],
    )
    parser.add_argument("--fs_failed_candidate_bucket_score", type=float, default=-1e6)
    parser.add_argument(
        "--fs_feedback_policy",
        type=str,
        default="off",
        choices=["off", "fail_only", "always"],
    )
    # Backward-compatible alias from earlier integration iteration.
    parser.add_argument("--fs_enable_feedback", action="store_true")
    parser.add_argument("--fs_feedback_sample_probability", type=float, default=1.0)
    parser.add_argument("--fs_allow_diff_mode", action="store_true")
    parser.add_argument("--fs_strict_prompt_keys", action=argparse.BooleanOptionalAction, default=True)
    return parser, config_parser


def _discover_tasks(args: argparse.Namespace) -> list[tuple[str, str, argparse.Namespace]]:
    benchmark_root = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "..", "data", "bench")
    )
    tasks: list[tuple[str, str, argparse.Namespace]] = []
    for benchmark in args.benchmarks:
        if benchmark.lower() == "cvdp":
            print(f"Skipping benchmark '{benchmark}' in run_backend.py (unsupported in backend runner).")
            continue
        benchmark_dir = os.path.join(benchmark_root, benchmark)
        problems_file = os.path.join(benchmark_dir, "problems.txt")
        if not os.path.exists(problems_file):
            print(f"Warning: missing {problems_file}; skipping benchmark {benchmark}.")
            continue
        with open(problems_file, "r", encoding="utf-8") as handle:
            all_problems = [line.strip() for line in handle if line.strip()]
        selected = args.problems if args.problems else all_problems
        for problem in selected:
            if problem in all_problems:
                tasks.append((benchmark, problem, args))
    return tasks


def main(argv: list[str] | None = None) -> int:
    parser, config_parser = _build_parser()
    try:
        args, config_from_file, raw_argv = parse_args_with_config(
            parser, config_parser, argv=argv
        )
    except ConfigError as exc:
        print(f"Configuration error: {exc}")
        return 2

    tasks_to_run = _discover_tasks(args)
    if not tasks_to_run:
        print("No valid tasks found to run.")
        return 1

    run_datetime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    start_time = time.time()
    model_name_cleaned = args.model_name.replace("/", "_")
    effective_save_path = _effective_save_path(args)
    master_log_dir = os.path.join(effective_save_path, model_name_cleaned)
    os.makedirs(master_log_dir, exist_ok=True)
    comprehensive_log_path = os.path.join(
        master_log_dir, f"{run_datetime}_{args.backend}_run_log.txt"
    )
    summary_results_path = os.path.join(
        master_log_dir, f"{run_datetime}_{args.backend}_summary_results.txt"
    )
    run_config_path = os.path.join(
        master_log_dir, f"{run_datetime}_{args.backend}_config.yaml"
    )
    snapshot_run_configuration(
        args,
        run_config_path,
        config_from_file=config_from_file,
        argv=raw_argv,
    )

    original_stdout = sys.stdout
    results_data = []
    try:
        with StreamRedirector(filepath=comprehensive_log_path):
            print(f"--- Backend run started: {run_datetime} backend={args.backend} ---")
            print(f"Arguments: {vars(args)}")
            print("-" * 50)
            if args.num_workers <= 1:
                results_data = [
                    run_problem_worker((benchmark, problem, args, index))
                    for index, (benchmark, problem, _) in enumerate(
                        tqdm(
                            tasks_to_run,
                            total=len(tasks_to_run),
                            desc="Running problems",
                            file=original_stdout,
                        )
                    )
                ]
            else:
                indexed_tasks = list(enumerate(tasks_to_run))
                with multiprocessing.Pool(processes=args.num_workers) as pool:
                    results_iter = pool.imap_unordered(
                        run_indexed_problem_worker, indexed_tasks
                    )
                    unordered = list(
                        tqdm(
                            results_iter,
                            total=len(indexed_tasks),
                            desc="Running problems",
                            file=original_stdout,
                        )
                    )
                unordered.sort(key=lambda item: item[0])
                results_data = [item[1] for item in unordered]
            print("--- All backend tasks completed ---")
    finally:
        end_time = time.time()
        with open(comprehensive_log_path, "a", encoding="utf-8") as log_file:
            log_file.write("\n\n==================== AGGREGATED INDIVIDUAL LOGS ====================\n")
            if not results_data:
                log_file.write("No worker results were returned.\n")
            else:
                for result_str, individual_log_path in results_data:
                    try:
                        parts = individual_log_path.split(os.sep)
                        identifier = os.path.join(parts[-3], parts[-2])
                        log_contents = Path(individual_log_path).read_text(
                            encoding="utf-8"
                        )
                        log_file.write(f"\n{identifier}:\n{{\n{log_contents}\n}}\n")
                        log_file.write("-" * 50 + "\n")
                    except Exception as exc:  # pragma: no cover - filesystem errors
                        log_file.write(
                            f"\n--- Error processing log {individual_log_path}: {exc} ---\n"
                        )
            log_file.write("\n--- Backend run completed ---\n")
            log_file.write(f"Total run time: {end_time - start_time:.2f} seconds\n")

        if results_data:
            with open(summary_results_path, "w", encoding="utf-8") as summary_file:
                for result_str, _ in results_data:
                    summary_file.write(f"{result_str}\n")

        print(f"Comprehensive run log saved to: {comprehensive_log_path}")
        print(f"Summary results saved to: {summary_results_path}")
        print(f"Total run time: {end_time - start_time:.2f} seconds")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
