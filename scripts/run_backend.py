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
    EoHBackend,
    EoHBackendConfig,
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
from revolution.runtime import (  # noqa: E402
    ArtifactWriter,
    CVDPEvaluator,
    CandidateEvaluator,
    build_cvdp_problem_context,
    load_cvdp_record,
    load_problem_context,
    select_cvdp_ids,
)
from revolution.utils import StreamRedirector  # noqa: E402
from revolution.vllm_preflight import preflight_vllm_model  # noqa: E402


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
    if args.backend == "eoh":
        return "eoh"
    return "default"


def _effective_save_path(args: argparse.Namespace) -> str:
    if getattr(args, "backend_subdir", True):
        return os.path.join(args.save_path, args.backend)
    return args.save_path


def _load_reference_ppa_metrics(problem_context) -> dict[str, float]:
    ref_ppa_file = (
        problem_context.benchmark_path / f"{problem_context.problem_name}_ppa.txt"
    )
    if not ref_ppa_file.is_file():
        return {}

    lines = ref_ppa_file.read_text(encoding="utf-8").splitlines()
    if len(lines) < 2:
        return {}
    values = lines[1].split(",")
    if len(values) < 5:
        return {}
    try:
        tns = float(values[0])
        wns = float(values[1])
        eff_clk_period = float(values[2])
        power = float(values[3])
        area = float(values[4])
    except ValueError:
        return {}
    if power == 0.0 or area == 0.0:
        return {}
    return {
        "tns": tns,
        "wns": wns,
        "eff_clk_period": eff_clk_period,
        "power": power,
        "area": area,
    }


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

    if benchmark.lower() == "cvdp":
        record = load_cvdp_record(args.cvdp_jsonl, problem)
        if record is None:
            raise FileNotFoundError(
                f"CVDP id '{problem}' not found in JSONL '{args.cvdp_jsonl}'."
            )
        problem_context = build_cvdp_problem_context(
            benchmark_name=benchmark,
            cvdp_id=problem,
            jsonl_path=args.cvdp_jsonl,
            cvdp_record=record,
        )
        ref_ppa_metrics: dict[str, float] = {}
        candidate_evaluator = CVDPEvaluator(
            context=problem_context,
            cvdp_jsonl_path=args.cvdp_jsonl,
            cvdp_id=problem,
            simulation_timeout_s=args.cvdp_simulation_timeout_s,
        )
    else:
        problem_context = load_problem_context(benchmark, problem)
        ref_ppa_metrics = _load_reference_ppa_metrics(problem_context)
        candidate_evaluator = CandidateEvaluator(
            context=problem_context,
            problem_description=problem_context.problem_description,
            verilog_evaluator=verilog_evaluator,
            synthesis_evaluator=synthesis_evaluator,
            ref_ppa_metrics=ref_ppa_metrics,
            evaluation_mode=args.evaluation_mode,
            accelerated_synthesis_top_k=args.accelerated_synthesis_top_k,
        )

    prompt_store = PromptStore(root_dir=prompt_root, profile=prompt_profile)
    effective_save_path = _effective_save_path(args)
    artifact_writer = ArtifactWriter(
        save_path=effective_save_path,
        model_name=args.model_name,
        benchmark_name=benchmark,
        problem_name=problem,
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
        metadata={
            "seed": task_seed,
            "primary_budget_axis": getattr(args, "primary_budget_axis", None),
            "max_llm_calls_per_problem": getattr(
                args, "max_llm_calls_per_problem", None
            ),
            "evaluation_mode": args.evaluation_mode,
            "accelerated_synthesis_top_k": args.accelerated_synthesis_top_k,
            "cvdp_jsonl": getattr(args, "cvdp_jsonl", None),
            "cvdp_simulation_timeout_s": getattr(args, "cvdp_simulation_timeout_s", None),
        },
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
            diff_apply_policy=args.diff_apply_policy,
            diff_max_tokens=args.diff_max_tokens,
            diff_compact_context=args.diff_compact_context,
            diff_similarity_threshold=args.diff_similarity_threshold,
            diff_fuzzy_margin=args.diff_fuzzy_margin,
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

    if args.backend == "eoh":
        eoh_operators = tuple(str(op).lower() for op in args.eoh_operators)
        eoh_population_size = max(1, int(args.eoh_population_size))
        eoh_num_generations = max(0, int(args.eoh_num_generations))
        eoh_max_evaluations = args.eoh_max_evaluations
        if eoh_max_evaluations is None:
            eoh_max_evaluations = (
                2 * eoh_population_size
                + eoh_num_generations * eoh_population_size * len(eoh_operators)
            )
        eoh_max_llm_calls = args.eoh_max_llm_calls
        if eoh_max_llm_calls is None:
            eoh_max_llm_calls = getattr(args, "max_llm_calls_per_problem", None)

        eoh_cfg = EoHBackendConfig(
            population_size=eoh_population_size,
            num_generations=eoh_num_generations,
            operators=eoh_operators,
            parent_count=max(1, int(args.eoh_parent_count)),
            selection_method=args.eoh_selection_method,
            management_method=args.eoh_management_method,
            generation_mode=args.generation_mode,
            default_llm_temp=args.temperature,
            default_llm_top_p=args.top_p,
            default_llm_max_tokens=args.max_tokens,
            diff_max_tokens=args.diff_max_tokens,
            max_evaluations=eoh_max_evaluations,
            max_llm_calls=eoh_max_llm_calls,
            max_runtime_seconds=args.eoh_max_runtime_seconds,
            max_llm_tokens=args.eoh_max_llm_tokens,
            prompt_profile=prompt_profile,
            prompt_root=prompt_root,
            strict_prompt_keys=args.eoh_strict_prompt_keys,
            seed=task_seed,
            candidate_workers=args.candidate_workers,
            diff_apply_policy=args.diff_apply_policy,
            diff_similarity_threshold=args.diff_similarity_threshold,
            diff_fuzzy_margin=args.diff_fuzzy_margin,
        )
        return EoHBackend(context=context, services=services, config=eoh_cfg)

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
        description="Run REvolution/FunSearch/EoH backends on benchmark problems.",
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

    parser.add_argument(
        "--backend",
        type=str,
        default="revolution",
        choices=["revolution", "funsearch", "eoh"],
    )
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
    parser.add_argument(
        "--vllm_preflight_timeout_s",
        type=float,
        default=5.0,
    )
    parser.add_argument(
        "--vllm_min_model_len",
        type=int,
        default=int(os.getenv("VLLM_MIN_MODEL_LEN", "128000")),
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
    parser.add_argument(
        "--diff_apply_policy",
        type=str,
        default="hybrid",
        choices=["strict", "hybrid", "fuzzy"],
    )
    parser.add_argument("--diff_max_tokens", type=int, default=1024)
    parser.add_argument(
        "--diff_compact_context",
        action=argparse.BooleanOptionalAction,
        default=True,
    )
    parser.add_argument("--diff_similarity_threshold", type=float, default=0.86)
    parser.add_argument("--diff_fuzzy_margin", type=float, default=0.03)
    parser.add_argument("--prompt_profile", type=str, default=None)
    parser.add_argument("--prompt_root", type=str, default=None)
    parser.add_argument(
        "--backend_subdir",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="When true (default), writes backend outputs under <save_path>/<backend>/...",
    )
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument(
        "--primary_budget_axis",
        type=str,
        default=None,
        choices=["candidate_evaluations", "llm_calls", "dual_gate"],
        help=argparse.SUPPRESS,
    )
    parser.add_argument(
        "--max_llm_calls_per_problem",
        type=int,
        default=None,
        help=argparse.SUPPRESS,
    )
    default_cvdp_jsonl = os.path.abspath(
        os.path.join(
            os.path.dirname(__file__),
            "..",
            "data",
            "bench",
            "cvdp",
            "cvdp_v1.0.2_nonagentic_code_generation_no_commercial.jsonl",
        )
    )
    parser.add_argument(
        "--cvdp_jsonl",
        type=str,
        default=default_cvdp_jsonl,
        help="Path to CVDP non-agentic JSONL dataset.",
    )
    parser.add_argument(
        "--cvdp_categories",
        nargs="+",
        default=["cid002", "cid003"],
        help="CVDP category filter used when benchmark includes cvdp.",
    )
    parser.add_argument(
        "--cvdp_simulation_timeout_s",
        type=int,
        default=120,
        help="Timeout in seconds for CVDP harness pytest execution.",
    )

    # REvolution-specific
    parser.add_argument("--population_size", type=int, default=5)
    parser.add_argument("--num_generations", type=int, default=5)
    parser.add_argument(
        "--strategy_selection",
        type=str,
        default="ucb",
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

    # EoH-specific
    parser.add_argument("--eoh_population_size", type=int, default=5)
    parser.add_argument("--eoh_num_generations", type=int, default=5)
    parser.add_argument(
        "--eoh_operators",
        nargs="+",
        default=["e1", "e2", "m1", "m2", "m3"],
        help="EoH operator schedule per generation.",
    )
    parser.add_argument("--eoh_parent_count", type=int, default=2)
    parser.add_argument(
        "--eoh_selection_method",
        type=str,
        default="rank",
        choices=["rank", "random", "tournament"],
    )
    parser.add_argument(
        "--eoh_management_method",
        type=str,
        default="elitism",
        choices=["elitism"],
    )
    parser.add_argument("--eoh_max_evaluations", type=int, default=None)
    parser.add_argument("--eoh_max_llm_calls", type=int, default=None)
    parser.add_argument("--eoh_max_llm_tokens", type=int, default=None)
    parser.add_argument("--eoh_max_runtime_seconds", type=float, default=None)
    parser.add_argument(
        "--eoh_strict_prompt_keys",
        action=argparse.BooleanOptionalAction,
        default=True,
    )
    return parser, config_parser


def _discover_tasks(args: argparse.Namespace) -> list[tuple[str, str, argparse.Namespace]]:
    benchmark_root = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "..", "data", "bench")
    )
    tasks: list[tuple[str, str, argparse.Namespace]] = []
    for benchmark in args.benchmarks:
        if benchmark.lower() == "cvdp":
            if args.backend != "eoh":
                print(
                    f"Skipping benchmark '{benchmark}' for backend '{args.backend}' "
                    "(cvdp support is currently enabled for backend=eoh)."
                )
                continue
            selected_ids = args.problems if args.problems else None
            cvdp_ids = select_cvdp_ids(
                args.cvdp_jsonl,
                args.cvdp_categories,
                selected_ids,
            )
            if not cvdp_ids:
                print(
                    f"[CVDP] No matching IDs found for categories={args.cvdp_categories}. Skipping."
                )
                continue
            for cvdp_id in cvdp_ids:
                tasks.append((benchmark, cvdp_id, args))
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
    allowed_keys = {action.dest for action in parser._actions if action.dest != "help"}
    snapshot_run_configuration(
        args,
        run_config_path,
        config_from_file=config_from_file,
        argv=raw_argv,
        allowed_keys=allowed_keys,
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
