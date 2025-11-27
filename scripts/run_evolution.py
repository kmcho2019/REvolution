import argparse
import datetime
import multiprocessing
import os
import sys
import time

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
from revolution.configuration import (
    ConfigError,
    parse_args_with_config,
    snapshot_run_configuration,
)

CUSTOM_PROMPT_BENCHMARK = "CustomPrompt"


# Wrapper function for multiprocessing
def run_problem_worker(args_tuple):
    """
    Wrapper function to run a single problem instance.
    This function will be executed by each worker process.
    All stdout/stderr from this process is redirected to a problem-specific log file.
    """
    # Unpack arguments
    benchmark, problem, args = args_tuple

    # Individual Log Setup
    model_name_cleaned = args.model_name.replace("/", "_")
    problem_log_dir = os.path.join(
        args.save_path, model_name_cleaned, benchmark, problem
    )
    # The EoHEngine will create this directory, but we ensure it exists early.
    os.makedirs(problem_log_dir, exist_ok=True)
    individual_log_path = os.path.join(problem_log_dir, "problem_run.log")

    evaluation_mode = getattr(args, "evaluation_mode", "standard")
    candidate_workers = (
        args.num_workers
        if evaluation_mode != "gen0" and getattr(args, "multiprocessing_mode", "problem") == "candidate"
        else 0
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
    with StreamRedirector(filepath=individual_log_path):
        print(
            f"\n[Worker PID: {os.getpid()}] Starting problem: {benchmark}/{problem}\n"
        )

        # Initialize objects within the worker process to avoid pickling issues
        # Determine the API key based on the selected backend
        api_key = None
        if args.api_backend == "openai":
            api_key = os.getenv("OPENAI_API_KEY")
        elif args.api_backend == "openrouter":
            api_key = os.getenv("OPENROUTER_API_KEY")
        elif args.api_backend == "deepseek":
            api_key = os.getenv("DEEPSEEK_API_KEY")
        elif args.api_backend == "gemini":
            api_key = os.getenv("GEMINI_API_KEY")


        if args.api_backend != "vllm":  # vllm does not require an API key
            if not api_key:
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
                    iverilog_executable_path="iverilog", vvp_executable_path="vvp"
                )
                synthesis_evaluator = SynthesisEvaluator()
            else:
                verilog_evaluator = None
                synthesis_evaluator = None
        else:
            verilog_evaluator = VerilogEvaluator(
                iverilog_executable_path="iverilog", vvp_executable_path="vvp"
            )
            synthesis_evaluator = SynthesisEvaluator()

        # Choose engine based on benchmarks
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
                prompt_profile=target_prompt_profile,             # System prompt profile
                prompt_root=None,                     # Use default prompt root (data/prompts/)                              
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
            eoh_engine = CVDPEngine(
                cvdp_jsonl_path=args.cvdp_jsonl,
                cvdp_id=problem,                         # 'problem' is the CVDP item id
                problem_name=problem,                    # for logging/paths
                benchmark_name=benchmark,
                llm_interface=llm_interface,
                verilog_evaluator=verilog_evaluator,     # unused by CVDP adapter, but fine
                synthesis_evaluator=synthesis_evaluator, # unused for CVDP
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
                prompt_profile=target_prompt_profile,             # System prompt profile
                prompt_root=None,                     # Use default prompt root (data/prompts/)  
                candidate_workers=candidate_workers,
            )
        else: # None CVDP benchmarks (e.g. RTLLM, VerilogEval)
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
                prompt_profile=target_prompt_profile,             # System prompt profile
                prompt_root=None,                     # Use default prompt root (data/prompts/)  
                candidate_workers=candidate_workers,
            )
        result_str = eoh_engine.run()
        # Return the result string and the path to the individual log file created for this problem
        print(f"[Worker PID: {os.getpid()}] Finished problem: {benchmark}/{problem}\n")
    return result_str, individual_log_path


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
        default=8888,
        help="Port for the vLLM OpenAI-compatible server.",
    )
    parser.add_argument(
        "--vllm_host",
        type=str,
        default="localhost",
        help="Hostname or IP for the vLLM OpenAI-compatible server.",
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
        "--num_workers",
        type=int,
        default=10,
        help="Number of worker processes (problem mode) or candidate-evaluation threads (candidate mode).",
    )
    parser.add_argument("--temperature", type=float, default=1.0)
    parser.add_argument("--top_p", type=float, default=0.95)
    parser.add_argument("--max_tokens", type=int, default=2048)
    parser.add_argument(
        "--strategy_selection",
        type=str,
        default="random",
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
        default="problem",
        choices=["problem", "candidate"],
        help="Parallelism granularity: 'problem' (default) distributes problems across processes; 'candidate' keeps one problem per process and parallelizes candidate evaluation within the engine.",
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
            parser, config_parser
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

    # --- Task helpers ---
    # >>> CVDP INTEGRATION: helper to read CVDP ids filtered by categories (case-insensitive)
    def _load_cvdp_ids(jsonl_path: str, allowed_categories: list[str], selected_ids: list[str] | None):
        allowed = {c.lower() for c in allowed_categories}
        ids = []
        try:
            with open(jsonl_path, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        obj = json.loads(line)
                    except Exception:
                        continue
                    cid = obj.get("id")
                    cats = [c.lower() for c in obj.get("categories", [])]
                    # print('---\n')
                    # print(cid)
                    # print(cats)
                    if not cid:
                        continue
                    # If user specified explicit ids for cvdp, keep intersection only
                    if selected_ids is not None and cid not in selected_ids:
                        # print(f"[CVDP] Skipping non-selected id: {cid}, selected_ids={selected_ids}")
                        continue
                    # Keep only items having any of the allowed categories
                    if any(c in allowed for c in cats):
                        # print(f"[CVDP] Keeping id: {cid}")
                        ids.append(cid)
        except FileNotFoundError:
            print(f"[CVDP] JSONL not found: {jsonl_path}")
        return ids


    # Main execution block now handles comprehensive, aggregated logging
    # --- Task Preparation ---
    run_datetime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    start_time = time.time()
    model_name_cleaned = args.model_name.replace("/", "_")
    # Define path for the new comprehensive log file for the entire run
    master_log_dir = os.path.join(args.save_path, model_name_cleaned)
    os.makedirs(master_log_dir, exist_ok=True)
    comprehensive_log_path = os.path.join(master_log_dir, f"{run_datetime}_run_log.txt")

    # Define path for the summary results file (similar to the original script's master log)
    summary_results_path = os.path.join(
        master_log_dir, f"{run_datetime}_summary_results.txt"
    )
    run_config_path = os.path.join(master_log_dir, f"{run_datetime}_config.yaml")
    snapshot_run_configuration(
        args,
        run_config_path,
        config_from_file=config_from_file,
        argv=raw_argv,
    )

    # Use a list to store results before writing to files
    results_data = []
    tasks_to_run = []  # Define this before the try block

    # Save a reference to the real stdout before it gets redirected
    # This allows us to print to the console even when redirecting output
    # This is to allow the progress bar to print to the console
    original_stdout = sys.stdout

    # The `finally` block will handle aggregation.
    try:
        # Redirect all output from this main script to the comprehensive log file
        with StreamRedirector(filepath=comprehensive_log_path):
            print(f"--- EoH Framework Run Started: {run_datetime} ---")
            print(f"Arguments: {vars(args)}")
            print("-" * 50)

            # --- Task Preparation ---
            # Task preparation loop to populate tasks_to_run
            if custom_prompt_mode:
                print(
                    f"Custom Gen0 prompt run: benchmark='{args.gen0_prompt_benchmark}', problem='{args.gen0_prompt_name}', prompt_file='{args.gen0_prompt_file}'."
                )
                tasks_to_run.append(
                    (args.gen0_prompt_benchmark, args.gen0_prompt_name, args)
                )
            else:
                for benchmark in args.benchmarks:
                    benchmark_dir = os.path.join(benchmark_root, benchmark)
                    print(f"benchmark_dir: {benchmark_dir}, benchmark_root: {benchmark_root}, benchmark: {benchmark}\n")

                    # CVDP INTEGRATION: build tasks from JSONL
                    if benchmark.lower() == "cvdp":
                        # For cvdp, if --problems provided treat them as explicit CVDP ids
                        selected_ids = args.problems if args.problems else None
                        cvdp_ids = _load_cvdp_ids(
                            args.cvdp_jsonl, args.cvdp_categories, selected_ids
                        )
                        if not cvdp_ids:
                            print(
                                f"[CVDP] No matching problems found (categories={args.cvdp_categories}). Skipping."
                            )
                            continue
                        for cid in cvdp_ids:
                            tasks_to_run.append((benchmark, cid, args))
                        continue

                    # Non-CVDP flow: use problems.txt
                    problems_file = os.path.join(benchmark_dir, "problems.txt")
                    if not os.path.exists(problems_file):
                        print(
                            f"Warning: 'problems.txt' not found in {benchmark_dir}. Skipping."
                        )
                        continue
                    with open(problems_file, "r") as f:
                        all_problems = [line.strip() for line in f if line.strip()]

                    problems_to_process = args.problems if args.problems else all_problems
                    print(f"problems_to_process: {problems_to_process}\n")
                    for problem in problems_to_process:
                        if problem in all_problems:
                            tasks_to_run.append((benchmark, problem, args))

            if not tasks_to_run:
                print("No valid problems found to run. Exiting.")
            else:
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
                elif args.multiprocessing_mode == "candidate":
                    worker_count = max(1, args.num_workers)
                    print(
                        f"\nStarting candidate-level evaluation with {worker_count} worker(s) per problem across {len(tasks_to_run)} problems."
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
                elif args.num_workers <= 1:
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
                        f"\nStarting parallel execution with {args.num_workers} workers for {len(tasks_to_run)} problems."
                    )

                    indexed_tasks = list(enumerate(tasks_to_run))

                    with multiprocessing.Pool(processes=args.num_workers) as pool:
                        results_iterator = pool.imap_unordered(
                            run_indexed_problem_worker, indexed_tasks
                        )

                        unordered_results = list(
                            tqdm(
                                results_iterator,
                                total=len(indexed_tasks),
                                desc="Running problems",
                                file=original_stdout,
                            )
                        )
                    unordered_results.sort(key=lambda x: x[0])
                    results_data = [result[1] for result in unordered_results]
                    print("\n--- All parallel tasks completed successfully.---")

    finally:
        end_time = time.time()
        # --- This block will ALWAYS run, even if the pool crashes ---
        print("\n--- Aggregation & Finalization Step ---")

        # Re-open the comprehensive log in append mode to add aggregation results
        with open(comprehensive_log_path, "a", encoding="utf-8") as log_file:
            log_file.write(
                "\n\n" + "=" * 20 + " AGGREGATED INDIVIDUAL LOGS " + "=" * 20 + "\n"
            )

            # Check if any results were produced before a potential crash
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
            log_file.write("\n--- EoH Framework Run Completed ---\n")
            log_file.write(f"Total run time: {end_time - start_time:.2f} seconds\n")
        # --- Write the summary results file ---
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
        print("--- EoH Framework Run Completed ---")


if __name__ == "__main__":
    main()
