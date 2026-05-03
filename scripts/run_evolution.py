import argparse
import datetime
import multiprocessing
import os
import sys
import time
import random
import hashlib
import traceback

from tqdm import tqdm

# Imports for CVDP Integration
import json
from pathlib import Path


# Ensure the src directory is in the Python path for imports
sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

# Import the core logic from new src package
from revolution.algorithm import EoHEngine, CVDPEngine, Gen0LatencyEngine
from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator
from revolution.llm import LLMInterface
from revolution.utils import StreamRedirector
from revolution.vllm_preflight import preflight_vllm_model
from revolution.configuration import (
    ConfigError,
    load_config_file,
    parse_args_with_config,
    snapshot_run_configuration,
)
from revolution.runtime.parallelism import (
    EVOLUTION_LEGACY_CLI_OPTIONS,
    FixedProblemConcurrencyController,
    apply_resolved_parallelism_args,
    build_elastic_parallelism_runtime,
    build_problem_concurrency_controller,
    reject_legacy_cli_options,
    resolve_evolution_parallelism_config,
    translate_evolution_legacy_parallelism_config,
)

CUSTOM_PROMPT_BENCHMARK = "CustomPrompt"


def _load_cvdp_ids(
    jsonl_path: str,
    allowed_categories: list[str],
    selected_ids: list[str] | None,
) -> list[str]:
    allowed = {category.lower() for category in allowed_categories}
    ids: list[str] = []
    try:
        with open(jsonl_path, "r", encoding="utf-8") as handle:
            for line in handle:
                line = line.strip()
                if not line:
                    continue
                try:
                    payload = json.loads(line)
                except Exception:
                    continue
                problem_id = payload.get("id")
                categories = [str(item).lower() for item in payload.get("categories", [])]
                if not problem_id:
                    continue
                if selected_ids is not None and problem_id not in selected_ids:
                    continue
                if any(category in allowed for category in categories):
                    ids.append(problem_id)
    except FileNotFoundError:
        print(f"[CVDP] JSONL not found: {jsonl_path}")
    return ids


def _discover_tasks(
    args: argparse.Namespace,
    *,
    benchmark_root: str,
    custom_prompt_mode: bool,
) -> list[tuple[str, str, argparse.Namespace]]:
    if custom_prompt_mode:
        return [(args.gen0_prompt_benchmark, args.gen0_prompt_name, args)]

    tasks: list[tuple[str, str, argparse.Namespace]] = []
    for benchmark in args.benchmarks:
        if benchmark.lower() == "cvdp":
            selected_ids = args.problems if args.problems else None
            cvdp_ids = _load_cvdp_ids(
                args.cvdp_jsonl,
                args.cvdp_categories,
                selected_ids,
            )
            for problem_id in cvdp_ids:
                tasks.append((benchmark, problem_id, args))
            continue

        benchmark_dir = os.path.join(benchmark_root, benchmark)
        problems_file = os.path.join(benchmark_dir, "problems.txt")
        if not os.path.exists(problems_file):
            print(
                f"Warning: 'problems.txt' not found in {benchmark_dir}. Skipping."
            )
            continue
        with open(problems_file, "r", encoding="utf-8") as handle:
            all_problems = [line.strip() for line in handle if line.strip()]
        problems_to_process = args.problems if args.problems else all_problems
        for problem in problems_to_process:
            if problem in all_problems:
                tasks.append((benchmark, problem, args))
    return tasks


def _run_indexed_tasks_with_pool(
    *,
    process_count: int,
    indexed_tasks,
    original_stdout,
):
    pool = multiprocessing.Pool(processes=process_count)
    try:
        results_iter = pool.imap_unordered(run_indexed_problem_worker, indexed_tasks)
        unordered = list(
            tqdm(
                results_iter,
                total=len(indexed_tasks),
                desc="Running problems",
                file=original_stdout,
            )
        )
    except BaseException:
        pool.terminate()
        pool.join()
        raise
    pool.close()
    pool.join()
    unordered.sort(key=lambda item: item[0])
    return [item[1] for item in unordered]


# Wrapper function for multiprocessing
def run_problem_worker(args_tuple):
    """
    Wrapper function to run a single problem instance.
    This function will be executed by each worker process.
    All stdout/stderr from this process is redirected to a problem-specific log file.
    """
    # Unpack arguments
    benchmark, problem, args = args_tuple

    # Optional deterministic seeding for reproducible whole-vs-diff comparisons.
    base_seed = getattr(args, "seed", None)
    task_seed: int | None = None
    if base_seed is not None:
        seed_key = f"{base_seed}:{benchmark}:{problem}".encode("utf-8")
        task_seed = int(hashlib.sha256(seed_key).hexdigest()[:8], 16)
        random.seed(task_seed)
        try:
            import numpy as np  # pyright: ignore[reportMissingImports]

            np.random.seed(task_seed % (2**32 - 1))
        except Exception:
            pass

    # Individual Log Setup
    model_name_cleaned = args.model_name.replace("/", "_")
    problem_log_dir = os.path.join(
        args.save_path, model_name_cleaned, benchmark, problem
    )
    # The EoHEngine will create this directory, but we ensure it exists early.
    os.makedirs(problem_log_dir, exist_ok=True)
    individual_log_path = os.path.join(problem_log_dir, "problem_run.log")

    evaluation_mode = getattr(args, "evaluation_mode", "standard")
    config = getattr(args, "resolved_parallelism_config", None)
    handles = getattr(args, "parallelism_handles", None)
    if config is None:
        fallback_workers = max(
            1,
            int(getattr(args, "max_workers_per_problem", 1) or 1),
        )
        candidate_workers = fallback_workers
        problem_concurrency = FixedProblemConcurrencyController(fallback_workers)
    else:
        candidate_workers = int(config.candidate_worker_limit)
        problem_id = f"{benchmark}/{problem}"
        problem_concurrency = build_problem_concurrency_controller(
            config,
            problem_id=problem_id,
            handles=handles,
        )
    custom_prompt_path = getattr(args, "gen0_prompt_file", None)
    custom_prompt_encoding = getattr(args, "gen0_prompt_encoding", "utf-8")
    custom_prompt_benchmark = getattr(args, "gen0_prompt_benchmark", None)

    # --- Prompt Profile Configuration ---
    # If the user provided a profile via CLI, use it.
    # Custom prompt profile takes precedence over default behavior.
    # Custom prompt profile can be added within data/prompts/{profile_name}/ directory. 
    # Otherwise, fallback to specific defaults: 'batchpick' for Gen0, 'default' for others.
    if args.prompt_profile:
        target_prompt_profile = args.prompt_profile
    else:
        target_prompt_profile = "batchpick" if evaluation_mode == "gen0" else "default"


    # Redirect all output from this worker to the individual log file
    problem_concurrency.open_problem()
    try:
        with StreamRedirector(filepath=individual_log_path):
            print(
                f"\n[Worker PID: {os.getpid()}] Starting problem: {benchmark}/{problem}\n"
            )
            if task_seed is not None:
                print(f"[Seed] base_seed={base_seed} task_seed={task_seed}")

            try:
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

                if args.api_backend != "vllm" and not api_key:
                    raise ValueError(
                        f"API key for backend '{args.api_backend}' not found. "
                        f"Please set the corresponding environment variable (e.g., OPENAI_API_KEY, OPENROUTER_API_KEY, DEEPSEEK_API_KEY)."
                    )
                llm_interface = LLMInterface(
                    api_key=api_key,
                    model_name=args.model_name,
                    api_backend=args.api_backend,
                    port=args.vllm_port,
                    vllm_host=args.vllm_host,
                )

                gen0_eval_best = getattr(args, "gen0_evaluate_best", False)
                if evaluation_mode == "gen0":
                    if gen0_eval_best:
                        verilog_evaluator = VerilogEvaluator(
                            iverilog_executable_path="iverilog",
                            vvp_executable_path="vvp",
                            default_simulation_timeout_seconds=args.rtl_simulation_timeout_s,
                        )
                        synthesis_evaluator = SynthesisEvaluator(
                            default_simulation_timeout_s=args.post_synthesis_simulation_timeout_s,
                            default_synthesis_timeout_s=args.synthesis_timeout_s,
                        )
                    else:
                        verilog_evaluator = None
                        synthesis_evaluator = None
                else:
                    verilog_evaluator = VerilogEvaluator(
                        iverilog_executable_path="iverilog",
                        vvp_executable_path="vvp",
                        default_simulation_timeout_seconds=args.rtl_simulation_timeout_s,
                    )
                    synthesis_evaluator = SynthesisEvaluator(
                        default_simulation_timeout_s=args.post_synthesis_simulation_timeout_s,
                        default_synthesis_timeout_s=args.synthesis_timeout_s,
                    )

                if evaluation_mode == "gen0":
                    if benchmark.lower() == "cvdp":
                        raise ValueError("Gen0 latency mode is not supported for CVDP benchmarks.")
                    eoh_engine = Gen0LatencyEngine(
                        benchmark_name=benchmark,
                        problem_name=problem,
                        llm_interface=llm_interface,
                        verilog_evaluator=verilog_evaluator,
                        synthesis_evaluator=synthesis_evaluator,
                        population_size=args.population_size,
                        base_save_path=args.save_path,
                        default_llm_temp=args.temperature,
                        default_llm_top_p=args.top_p,
                        default_llm_max_tokens=args.max_tokens,
                        require_strict_format=True,
                        prompt_profile=target_prompt_profile,
                        prompt_root=None,
                        custom_prompt_path=(
                            custom_prompt_path
                            if custom_prompt_benchmark
                            and benchmark == custom_prompt_benchmark
                            else None
                        ),
                        custom_prompt_encoding=custom_prompt_encoding,
                        evaluate_best_candidate=gen0_eval_best,
                    )
                elif benchmark.lower() == "cvdp":
                    assert verilog_evaluator is not None
                    assert synthesis_evaluator is not None
                    eoh_engine = CVDPEngine(
                        cvdp_jsonl_path=args.cvdp_jsonl,
                        cvdp_id=problem,
                        simulation_timeout_s=args.cvdp_simulation_timeout_s,
                        problem_name=problem,
                        benchmark_name=benchmark,
                        llm_interface=llm_interface,
                        verilog_evaluator=verilog_evaluator,
                        synthesis_evaluator=synthesis_evaluator,
                        population_size=args.population_size,
                        num_generations=args.num_generations,
                        base_save_path=args.save_path,
                        default_llm_temp=args.temperature,
                        default_llm_top_p=args.top_p,
                        default_llm_max_tokens=args.max_tokens,
                        strategy_selection_method=args.strategy_selection,
                        epsilon=args.epsilon,
                        ucb_c=args.ucb_c,
                        generation_mode=args.generation_mode,
                        population_pool_mode=args.population_pool_mode,
                        diff_apply_policy=args.diff_apply_policy,
                        diff_max_tokens=args.diff_max_tokens,
                        diff_compact_context=args.diff_compact_context,
                        diff_similarity_threshold=args.diff_similarity_threshold,
                        diff_fuzzy_margin=args.diff_fuzzy_margin,
                        prompt_profile=target_prompt_profile,
                        prompt_root=None,
                        candidate_workers=candidate_workers,
                        problem_concurrency=problem_concurrency,
                    )
                else:
                    assert verilog_evaluator is not None
                    assert synthesis_evaluator is not None
                    eoh_engine = EoHEngine(
                        problem_name=problem,
                        benchmark_name=benchmark,
                        llm_interface=llm_interface,
                        verilog_evaluator=verilog_evaluator,
                        synthesis_evaluator=synthesis_evaluator,
                        population_size=args.population_size,
                        num_generations=args.num_generations,
                        base_save_path=args.save_path,
                        default_llm_temp=args.temperature,
                        default_llm_top_p=args.top_p,
                        default_llm_max_tokens=args.max_tokens,
                        strategy_selection_method=args.strategy_selection,
                        epsilon=args.epsilon,
                        ucb_c=args.ucb_c,
                        generation_mode=args.generation_mode,
                        population_pool_mode=args.population_pool_mode,
                        diff_apply_policy=args.diff_apply_policy,
                        diff_max_tokens=args.diff_max_tokens,
                        diff_compact_context=args.diff_compact_context,
                        diff_similarity_threshold=args.diff_similarity_threshold,
                        diff_fuzzy_margin=args.diff_fuzzy_margin,
                        prompt_profile=target_prompt_profile,
                        prompt_root=None,
                        candidate_workers=candidate_workers,
                        problem_concurrency=problem_concurrency,
                    )
                result_str = eoh_engine.run()
            except Exception as exc:
                traceback.print_exc()
                print(f"[Worker PID: {os.getpid()}] Failed problem: {benchmark}/{problem} error={exc}\n")
                return f"{problem},worker_error,{exc}", individual_log_path
            print(f"[Worker PID: {os.getpid()}] Finished problem: {benchmark}/{problem}\n")
        return result_str, individual_log_path
    finally:
        problem_concurrency.close_problem()


# Wrapper function for multiprocessing
def run_indexed_problem_worker(indexed_task):
    """
    Wrapper function to run a single problem instance.
    This function will be executed by each worker process.
    All stdout/stderr from this process is redirected to a problem-specific log file.

    This version includes the index of the task for better tracking.
    To support parallel processing with imap_unordered, while preserving the order of tasks,
    we need to index the tasks before passing them to the pool.

    :param indexed_task: A tuple containing the index and a tuple of (benchmark, problem, args).
    :type indexed_task: tuple
    :return: A tuple containing the index and the result tuple(result_str, individual_log_path) from the EoHEngine run.
    :rtype: tuple

    """
    index, args_tuple = indexed_task
    benchmark, problem, args = args_tuple
    result = run_problem_worker((benchmark, problem, args))
    return (index, result)


def main():
    """Main function to parse arguments and orchestrate the evolutionary run."""
    raw_argv = list(sys.argv[1:])
    try:
        reject_legacy_cli_options(
            raw_argv,
            runner_name="run_evolution.py",
            legacy_options=EVOLUTION_LEGACY_CLI_OPTIONS,
        )
    except ValueError as exc:
        print(f"Configuration error: {exc}")
        raise SystemExit(2)

    config_backend: str | None = None
    config_search_mode: str | None = None
    config_has_funsearch_keys = False
    config_has_nonrevolution_backend_keys = False
    config_has_qd_keys = False
    if "--config" in raw_argv:
        cfg_idx = raw_argv.index("--config")
        if cfg_idx + 1 < len(raw_argv):
            try:
                cfg = load_config_file(raw_argv[cfg_idx + 1])
                config_backend = cfg.get("backend")
                config_search_mode = cfg.get("search_mode")
                config_has_funsearch_keys = any(
                    str(key).startswith("fs_") for key in cfg.keys()
                )
                config_has_qd_keys = any(
                    str(key).startswith("qd_") for key in cfg.keys()
                )
                config_has_nonrevolution_backend_keys = any(
                    str(key).startswith(prefix)
                    for key in cfg.keys()
                    for prefix in ("fs_", "eoh_", "codeevolve_")
                )
            except Exception:
                # Let the normal parser/config loader surface errors later.
                pass
    if "--backend" in raw_argv:
        backend_idx = raw_argv.index("--backend")
        if backend_idx + 1 >= len(raw_argv):
            print("Missing value for --backend")
            sys.exit(2)
        backend_name = raw_argv[backend_idx + 1]
        if backend_name != "revolution":
            from run_backend import main as run_backend_main

            raise SystemExit(run_backend_main(raw_argv))
        # Preserve backward compatibility: ignore explicit '--backend revolution'.
        del raw_argv[backend_idx : backend_idx + 2]
    if "--search_mode" in raw_argv:
        mode_idx = raw_argv.index("--search_mode")
        if mode_idx + 1 >= len(raw_argv):
            print("Missing value for --search_mode")
            sys.exit(2)
        if raw_argv[mode_idx + 1] == "revolution_qd":
            from run_backend import main as run_backend_main

            raise SystemExit(run_backend_main(["--backend", "revolution", *raw_argv]))
    elif config_search_mode == "revolution_qd" or config_has_qd_keys:
        from run_backend import main as run_backend_main

        raise SystemExit(run_backend_main(["--backend", "revolution", *raw_argv]))
    elif (config_backend and config_backend != "revolution") or config_has_funsearch_keys or config_has_nonrevolution_backend_keys:
        from run_backend import main as run_backend_main

        raise SystemExit(run_backend_main(raw_argv))

    # Use argparse to make the script configurable
    config_parser = argparse.ArgumentParser(add_help=False)
    config_parser.add_argument(
        "--config",
        type=str,
        help="Path to a YAML or JSON config file supplying default arguments.",
    )

    parser = argparse.ArgumentParser(
        description="Run the EoH framework on specified Verilog benchmarks.",
        parents=[config_parser],
    )

    # List of all available benchmarks in the 'bench' directory
    # Current benches: ['RTLLM', 'VerilogEval-Code-Complete', 'VerilogEval-Spec-to-RTL']
    # Assumes that the script is in scripts/run_evolution.py, and bench is in data/bench/
    benchmark_root = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "..", "data", "bench")
    )
    available_benchmarks = [
        d
        for d in os.listdir(benchmark_root)
        if os.path.isdir(os.path.join(benchmark_root, d))
    ]

    parser.add_argument(
        "--benchmarks",
        nargs="+",
        default=available_benchmarks,
        choices=available_benchmarks,
        help=f"A list of benchmark suites to run. Default is all available. Choices: {available_benchmarks}",
    )
    parser.add_argument(
        "--problems",
        nargs="+",
        help="A list of specific problem names to run. If not provided, all problems in the suite will be run.",
    )
    parser.add_argument(
        "--api_backend",
        type=str,
        default="openai",
        choices=["openai", "openrouter", "deepseek", "gemini", "vllm"],
        help="The API backend to use for LLM calls.",
    )
    parser.add_argument(
        "--vllm_port",
        type=int,
        default=int(os.getenv("VLLM_PORT", "8888")),
        help="Port for the vLLM OpenAI-compatible server. Defaults to VLLM_PORT or 8888.",
    )
    parser.add_argument(
        "--vllm_host",
        type=str,
        default=os.getenv("VLLM_HOST", "localhost"),
        help="Hostname or IP for the vLLM OpenAI-compatible server. Defaults to VLLM_HOST or localhost.",
    )
    parser.add_argument(
        "--vllm_preflight_timeout_s",
        type=float,
        default=5.0,
        help="Timeout (seconds) for vLLM /v1/models preflight checks.",
    )
    parser.add_argument(
        "--vllm_min_model_len",
        type=int,
        default=int(os.getenv("VLLM_MIN_MODEL_LEN", "128000")),
        help="Recommended minimum max_model_len for vLLM reasoning runs (warn-only gate).",
    )
    parser.add_argument(
        "--model_name",
        type=str,
        default="gpt-4.1-mini",
        help="Name of the OpenAI model to use.",
    )
    parser.add_argument(
        "--population_size",
        type=int,
        default=5,
        help="Number of candidates in each generation.",
    )
    parser.add_argument(
        "--num_generations",
        type=int,
        default=5,
        help="Number of evolutionary generations to run.",
    )
    parser.add_argument(
        "--save_path",
        type=str,
        default=os.path.abspath(
            os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "exp")
        ),
        help="Base path to save results.",
    )  # Default is ./exp, defined relative to main.py
    parser.add_argument(
        "--total_worker_slots",
        type=int,
        default=10,
        help="Total worker budget shared across the run.",
    )
    parser.add_argument(
        "--max_active_problems",
        type=int,
        default=None,
        help="Maximum number of simultaneously active problems.",
    )
    parser.add_argument(
        "--max_workers_per_problem",
        type=int,
        default=None,
        help="Maximum worker count that a single problem may borrow.",
    )
    parser.add_argument(
        "--parallelism_mode",
        type=str,
        default="elastic",
        help=argparse.SUPPRESS,
    )
    parser.add_argument("--num_workers", type=int, default=None, help=argparse.SUPPRESS)
    parser.add_argument("--temperature", type=float, default=1.0)
    parser.add_argument("--top_p", type=float, default=0.95)
    parser.add_argument("--max_tokens", type=int, default=2048)
    parser.add_argument(
        "--rtl_simulation_timeout_s",
        type=int,
        default=60,
        help="Timeout in seconds for RTL compile/simulation stages.",
    )
    parser.add_argument(
        "--synthesis_timeout_s",
        type=int,
        default=300,
        help="Timeout in seconds for each synthesis/physical-design tool stage.",
    )
    parser.add_argument(
        "--post_synthesis_simulation_timeout_s",
        type=int,
        default=300,
        help="Timeout in seconds for post-synthesis compile/simulation.",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=None,
        help="Optional base seed for deterministic strategy/parent sampling per (benchmark, problem).",
    )
    parser.add_argument(
        "--strategy_selection",
        type=str,
        default="ucb",
        choices=["random", "epsilon-greedy", "ucb"],
        help="The meta-strategy for selecting genetic operators.",
    )
    parser.add_argument(
        "--epsilon",
        type=float,
        default=0.1,
        help="The exploration factor for the epsilon-greedy strategy.",
    )
    parser.add_argument(
        "--ucb_c",
        type=float,
        default=2.0,
        help="The exploration constant (c) for the UCB strategy.",
    )
    parser.add_argument(  # Choice of generation mode either "whole" or "diff"
        "--generation_mode",
        type=str,
        default="whole",
        choices=["whole", "diff"],
        help="Mode of generation, either 'whole' (full code) or 'diff' (code diffs). "
        "In 'whole' mode, the entire code is generated. "
        "In 'diff' mode, only the differences from the original code are generated.",
    )
    parser.add_argument(
        "--diff_apply_policy",
        type=str,
        default="hybrid",
        choices=["strict", "hybrid", "fuzzy"],
        help="Diff apply behavior: strict exact matching, hybrid strict+guarded-fuzzy, or fuzzy-first.",
    )
    parser.add_argument(
        "--diff_max_tokens",
        type=int,
        default=1024,
        help="Per-request max token budget used for diff-mode offspring generation.",
    )
    parser.add_argument(
        "--diff_compact_context",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="When true, reduce duplicated parent-code context in diff prompts to save tokens.",
    )
    parser.add_argument(
        "--diff_similarity_threshold",
        type=float,
        default=0.86,
        help="Minimum fuzzy similarity threshold used by diff matching fallback.",
    )
    parser.add_argument(
        "--diff_fuzzy_margin",
        type=float,
        default=0.03,
        help="Required score gap between top fuzzy matches to avoid ambiguous diff application.",
    )
    parser.add_argument(
        "--population_pool_mode",
        type=str,
        default="dual",
        choices=["dual", "single"],
        help="Mode of population pool, either 'dual' (separate success/fail pools, more balanced exploration strategy tries to explore more diverse solutions from failed candidates) or 'single' (combined pool, more aggressive exploitation strategy focusing on successful candidates)."
    )
    parser.add_argument(
        "--evaluation_mode",
        type=str,
        default="standard",
        choices=["standard", "gen0"],
        help="Select 'gen0' for latency-optimized initial generation scoring; default 'standard' runs the full evolutionary loop.",
    )
    parser.add_argument(
        "--gen0_evaluate_best",
        action="store_true",
        help="When running in Gen0 mode, also run full functional, synthesis, and PPA evaluation on the selected best candidate and store the logs under Gen0/best_candidate/.",
    )
    parser.add_argument(
        "--gen0_prompt_file",
        type=str,
        help="Path to a standalone text file describing the problem for Gen0 mode. When provided, benchmark discovery is skipped and a single custom Gen0 run is executed.",
    )
    parser.add_argument(
        "--gen0_prompt_name",
        type=str,
        default=None,
        help="Optional name to use for the synthetic problem when --gen0_prompt_file is supplied. Defaults to the prompt filename stem.",
    )
    parser.add_argument(
        "--gen0_prompt_encoding",
        type=str,
        default="utf-8",
        help="Encoding to use when reading --gen0_prompt_file (default: utf-8).",
    )
    parser.add_argument(
        "--multiprocessing_mode",
        type=str,
        default=None,
        help=argparse.SUPPRESS,
    )

    # CVDP INTEGRATION: CVDP JSONL path and category filter
    # Currently only supports non-agentic, no-commercial code generation
    # cid002 and cid003
    default_cvdp_jsonl = os.path.join(
        benchmark_root, "cvdp", "cvdp_v1.0.2_nonagentic_code_generation_no_commercial.jsonl"
    )
    parser.add_argument(
        "--cvdp_jsonl",
        type=str,
        default=default_cvdp_jsonl,
        help="Path to the CVDP non-agentic, no-commercial JSONL file.",
    )
    parser.add_argument(
        "--cvdp_simulation_timeout_s",
        type=int,
        default=120,
        help="Timeout in seconds for CVDP pytest/cocotb harness execution (default: 120).",
    )
    parser.add_argument(
        "--cvdp_categories",
        nargs="+",
        default=["cid002", "cid003"],
        help="CVDP category filter (default: cid002 cid003).",
    )
    parser.add_argument(
        "--prompt_profile",
        type=str,
        default=None,
        help="Specify the system prompt profile (e.g. 'default', 'batchpick', etc.). "
             "If not set, defaults to 'batchpick' for Gen0/BatchPick mode and 'default' for standard mode.",
    )


    try:
        args, config_from_file, raw_argv = parse_args_with_config(
            parser, config_parser, argv=raw_argv
        )
    except ConfigError as exc:
        print(f"Configuration error: {exc}")
        sys.exit(2)

    custom_prompt_mode = bool(args.gen0_prompt_file)
    if custom_prompt_mode:
        if args.evaluation_mode != "gen0":
            print(
                "Custom Gen0 prompt mode requires '--evaluation_mode gen0'. Please update the arguments."
            )
            sys.exit(2)
        prompt_path = os.path.abspath(args.gen0_prompt_file)
        if not os.path.isfile(prompt_path):
            print(f"Custom Gen0 prompt file not found: {prompt_path}")
            sys.exit(1)
        args.gen0_prompt_file = prompt_path
        if args.gen0_prompt_name:
            prompt_label = args.gen0_prompt_name
        else:
            prompt_label = Path(prompt_path).stem or "custom_prompt"
            args.gen0_prompt_name = prompt_label
        if args.problems:
            print("Warning: --problems is ignored when --gen0_prompt_file is supplied.")
        args.problems = [prompt_label]
        args.benchmarks = [CUSTOM_PROMPT_BENCHMARK]
        args.gen0_prompt_benchmark = CUSTOM_PROMPT_BENCHMARK
    else:
        args.gen0_prompt_benchmark = None

    api_key = None
    if args.api_backend != "vllm":  # vllm does not require an API key
        # Map backends to their required environment variables
        api_key_env_vars = {
            "openai": "OPENAI_API_KEY",
            "openrouter": "OPENROUTER_API_KEY",
            "deepseek": "DEEPSEEK_API_KEY",
            "gemini": "GEMINI_API_KEY",
        }
        # Check for the correct key based on the selected backend
        required_key_var = api_key_env_vars.get(args.api_backend, None)
        if required_key_var:
            api_key = os.getenv(required_key_var)
            if not api_key:
                print(
                    f"LLM Initialization Error: The environment variable '{required_key_var}' must be set for the '{args.api_backend}' backend."
                )
                exit(1)
    else:
        preflight = preflight_vllm_model(
            host=args.vllm_host,
            port=args.vllm_port,
            min_model_len=args.vllm_min_model_len,
            timeout_s=args.vllm_preflight_timeout_s,
        )
        endpoint = preflight.get("endpoint")
        model_id = preflight.get("model_id")
        max_len = preflight.get("max_model_len")
        print(
            f"[vLLM preflight] endpoint={endpoint} model={model_id} "
            f"max_model_len={max_len} min_required={args.vllm_min_model_len}"
        )
        if preflight.get("warning"):
            print(f"[vLLM preflight] WARNING: {preflight['warning']}")

    tasks_to_run = _discover_tasks(
        args,
        benchmark_root=benchmark_root,
        custom_prompt_mode=custom_prompt_mode,
    )
    if not tasks_to_run:
        print("No valid problems found to run. Exiting.")
        sys.exit(1)

    config_from_file = translate_evolution_legacy_parallelism_config(
        args,
        config_from_file=config_from_file,
        raw_argv=raw_argv,
    )
    resolved_parallelism = resolve_evolution_parallelism_config(
        args,
        task_count=len(tasks_to_run),
    )
    apply_resolved_parallelism_args(args, resolved_parallelism)

    run_datetime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    start_time = time.time()
    model_name_cleaned = args.model_name.replace("/", "_")
    master_log_dir = os.path.join(args.save_path, model_name_cleaned)
    os.makedirs(master_log_dir, exist_ok=True)
    comprehensive_log_path = os.path.join(master_log_dir, f"{run_datetime}_run_log.txt")
    summary_results_path = os.path.join(
        master_log_dir, f"{run_datetime}_summary_results.txt"
    )
    run_config_path = os.path.join(master_log_dir, f"{run_datetime}_config.yaml")
    hidden_legacy_keys = {
        "multiprocessing_mode",
        "num_workers",
        "parallelism_mode",
    }
    allowed_keys = {
        action.dest
        for action in parser._actions
        if action.dest not in {"help", *hidden_legacy_keys}
    }
    snapshot_run_configuration(
        args,
        run_config_path,
        config_from_file=config_from_file,
        argv=raw_argv,
        allowed_keys=allowed_keys,
    )

    results_data = []
    original_stdout = sys.stdout
    runtime = build_elastic_parallelism_runtime(
        resolved_parallelism,
        task_count=len(tasks_to_run),
    )
    args.resolved_parallelism_config = resolved_parallelism
    args.parallelism_handles = runtime.handles if runtime is not None else None
    interrupted = False

    try:
        try:
            with StreamRedirector(filepath=comprehensive_log_path):
                print(f"--- EoH Framework Run Started: {run_datetime} ---")
                log_args = {
                    key: value
                    for key, value in vars(args).items()
                    if key
                    not in {
                        "multiprocessing_mode",
                        "num_workers",
                        "parallelism_handles",
                        "parallelism_mode",
                        "resolved_parallelism_config",
                    }
                }
                print(f"Arguments: {log_args}")
                print("-" * 50)

                if custom_prompt_mode:
                    print(
                        f"Custom Gen0 prompt run: benchmark='{args.gen0_prompt_benchmark}', problem='{args.gen0_prompt_name}', prompt_file='{args.gen0_prompt_file}'."
                    )
                if args.evaluation_mode == "gen0":
                    print(
                        f"\nRunning Gen0 latency mode sequentially for {len(tasks_to_run)} problems."
                    )
                    results_data = [
                        run_problem_worker(task)
                        for task in tqdm(
                            tasks_to_run,
                            total=len(tasks_to_run),
                            desc="Running problems",
                            file=original_stdout,
                        )
                    ]
                elif resolved_parallelism.problem_processes <= 1:
                    print(
                        f"\nStarting sequential execution for {len(tasks_to_run)} problems."
                    )
                    results_data = [
                        run_problem_worker(task)
                        for task in tqdm(
                            tasks_to_run,
                            total=len(tasks_to_run),
                            desc="Running problems",
                            file=original_stdout,
                        )
                    ]
                else:
                    print(
                        f"\nStarting elastic execution with {resolved_parallelism.problem_processes} active problem worker(s) and {resolved_parallelism.total_worker_slots} total worker slot(s) for {len(tasks_to_run)} problems."
                    )
                    indexed_tasks = list(enumerate(tasks_to_run))
                    results_data = _run_indexed_tasks_with_pool(
                        process_count=resolved_parallelism.problem_processes,
                        indexed_tasks=indexed_tasks,
                        original_stdout=original_stdout,
                    )
                    print("\n--- All parallel tasks completed successfully.---")
        except KeyboardInterrupt:
            interrupted = True
            print("run_evolution.py interrupted. Cleaning up worker pool state.")

    finally:
        end_time = time.time()
        completion_label = "interrupted" if interrupted else "completed"
        print("\n--- Aggregation & Finalization Step ---")
        with open(comprehensive_log_path, "a", encoding="utf-8") as log_file:
            log_file.write(
                "\n\n" + "=" * 20 + " AGGREGATED INDIVIDUAL LOGS " + "=" * 20 + "\n"
            )
            if not results_data:
                log_file.write(
                    "\nNo results were returned from worker processes. This may be due to an early crash.\nCheck individual problem directories for logs.\n"
                )
            else:
                for result_str, individual_log_path in results_data:
                    try:
                        path_parts = individual_log_path.split(os.sep)
                        problem_identifier = os.path.join(
                            path_parts[-3], path_parts[-2]
                        )

                        with open(
                            individual_log_path, "r", encoding="utf-8"
                        ) as f_individual:
                            log_contents = f_individual.read()

                        log_file.write(f"\n{problem_identifier}:\n")
                        log_file.write(f"{{\n{log_contents}\n}}\n")
                        log_file.write("-" * 50 + "\n")

                    except Exception as e:
                        log_file.write(
                            f"\n--- Error processing log {individual_log_path}: {e} ---\n"
                        )
            if interrupted:
                log_file.write("\nRun interrupted by user.\n")
            log_file.write(f"\n--- EoH Framework Run {completion_label} ---\n")
            log_file.write(f"Total run time: {end_time - start_time:.2f} seconds\n")
        if results_data:
            try:
                with open(summary_results_path, "w") as summary_file:
                    for result_str, _ in results_data:
                        summary_file.write(f"{result_str}\n")
                print(f"\nSummary results saved to: {summary_results_path}")
            except Exception as e:
                print(f"Error writing summary results file: {e}")

        print(
            f"Comprehensive run log with aggregated details saved to: {comprehensive_log_path}"
        )
        print(f"Total run time: {end_time - start_time:.2f} seconds")
        print(f"--- EoH Framework Run {completion_label} ---")
        if runtime is not None:
            runtime.close()
    if interrupted:
        raise SystemExit(130)


if __name__ == "__main__":
    main()
