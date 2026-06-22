import argparse
import datetime
import json
import multiprocessing
import os
import random
import sys
import time
import traceback
from pathlib import Path
from typing import cast

from tqdm import tqdm

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.backends import (  # noqa: E402
    CodeEvolveBackend,
    CodeEvolveBackendConfig,
    BackendExecutionContext,
    BackendServices,
    EoHBackend,
    EoHBackendConfig,
    FunSearchBackend,
    FunSearchBackendConfig,
    RevolutionBackend,
    RevolutionBackendConfig,
    backend_supports_cvdp,
    default_prompt_profile_for_backend,
    registered_backend_names,
)
from revolution.configuration import (  # noqa: E402
    ConfigError,
    parse_args_with_config,
    snapshot_run_configuration,
)
from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator  # noqa: E402
from revolution.verilator_evaluation import VerilatorEvaluator  # noqa: E402
from revolution.llm import LLMInterface  # noqa: E402
from revolution.prompt_store import PromptStore  # noqa: E402
from revolution.runtime import (  # noqa: E402
    ArtifactWriter,
    CVDPEvaluator,
    CandidateEvaluator,
    ProblemSpec,
    build_cvdp_problem_spec,
    build_problem_spec,
    build_cvdp_problem_context,
    build_realbench_problem_context,
    build_realbench_problem_spec,
    load_cvdp_record,
    load_realbench_record,
    load_realbench_reference_ppa_metrics,
    load_problem_context,
    select_cvdp_ids,
    select_realbench_problem_ids,
)
from revolution.runtime.parallelism import (  # noqa: E402
    BACKEND_LEGACY_CLI_OPTIONS,
    FixedProblemConcurrencyController,
    apply_resolved_parallelism_args,
    build_elastic_parallelism_runtime,
    build_problem_concurrency_controller,
    reject_legacy_cli_options,
    resolve_backend_parallelism_config,
    summarize_scheduler_telemetry,
    translate_backend_legacy_parallelism_config,
)
from revolution.utils import StreamRedirector  # noqa: E402
from revolution.vllm_preflight import preflight_vllm_model  # noqa: E402

_DEFAULT_DIFF_MAX_TOKENS = 1024
_LARGE_CONTEXT_TOKEN_FLOOR = 128000


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
    return default_prompt_profile_for_backend(args.backend)


def _resolve_codeevolve_diff_max_tokens(args: argparse.Namespace) -> int:
    """Resolve the effective diff-token budget for CodeEvolve.

    Live smoke runs against reasoning-oriented vLLM models showed that the
    generic diff default (`1024`) can silently undercut an intentionally large
    `--max_tokens` setting. For CodeEvolve diff runs, if the user kept the
    generic default but requested a larger overall generation budget on a large
    vLLM endpoint, promote the diff budget to match `--max_tokens`.
    """

    if args.backend != "codeevolve":
        return int(args.diff_max_tokens)
    if args.generation_mode != "diff":
        return int(args.diff_max_tokens)
    if args.api_backend != "vllm":
        return int(args.diff_max_tokens)
    if int(args.diff_max_tokens) != _DEFAULT_DIFF_MAX_TOKENS:
        return int(args.diff_max_tokens)
    if int(args.max_tokens) <= int(args.diff_max_tokens):
        return int(args.diff_max_tokens)
    if int(getattr(args, "vllm_min_model_len", 0)) < 128000:
        return int(args.diff_max_tokens)

    print(
        "[codeevolve] promoting diff_max_tokens to match max_tokens for a "
        "large-context vLLM diff run."
    )
    return int(args.max_tokens)


def _collect_vllm_token_budget_warnings(
    args: argparse.Namespace,
    *,
    reported_model_len: int | None = None,
) -> list[str]:
    """Return warnings for undersized token budgets on large-context vLLM runs."""

    if args.api_backend != "vllm":
        return []

    min_model_len = int(getattr(args, "vllm_min_model_len", 0) or 0)
    max_model_len = int(reported_model_len or 0)
    if max(min_model_len, max_model_len) < _LARGE_CONTEXT_TOKEN_FLOOR:
        return []

    warnings: list[str] = []
    if int(args.max_tokens) < _LARGE_CONTEXT_TOKEN_FLOOR:
        warnings.append(
            "max_tokens is below 128000 on a large-context vLLM endpoint; "
            "reasoning-oriented runs can truncate code/JSON and invalidate "
            "benchmark conclusions."
        )
    if int(args.diff_max_tokens) < _LARGE_CONTEXT_TOKEN_FLOOR:
        warnings.append(
            "diff_max_tokens is below 128000 on a large-context vLLM endpoint; "
            "diff outputs can truncate even when max_tokens is large."
        )
    return warnings


def _effective_save_path(args: argparse.Namespace) -> str:
    if getattr(args, "backend_subdir", True):
        return os.path.abspath(os.path.join(args.save_path, args.backend))
    return os.path.abspath(args.save_path)


def _parallelism_metadata(args: argparse.Namespace) -> dict[str, object]:
    return {
        "total_worker_slots": getattr(args, "total_worker_slots", None),
        "max_active_problems": getattr(args, "max_active_problems", None),
        "max_workers_per_problem": getattr(args, "max_workers_per_problem", None),
    }


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
    problem_concurrency,
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
        iverilog_executable_path="iverilog",
        vvp_executable_path="vvp",
        default_simulation_timeout_seconds=args.rtl_simulation_timeout_s,
    )
    synthesis_evaluator = SynthesisEvaluator(
        default_simulation_timeout_s=args.post_synthesis_simulation_timeout_s,
        default_synthesis_timeout_s=args.synthesis_timeout_s,
    )

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
        problem_spec: ProblemSpec = build_cvdp_problem_spec(
            problem_context,
            cvdp_record=record,
            supports_reference_ppa=False,
        )
        candidate_evaluator = cast(
            CandidateEvaluator,
            CVDPEvaluator(
                context=problem_context,
                cvdp_jsonl_path=args.cvdp_jsonl,
                cvdp_id=problem,
                simulation_timeout_s=args.cvdp_simulation_timeout_s,
            ),
        )
    elif benchmark.lower() == "realbench":
        record = load_realbench_record(args.realbench_root, problem)
        if record is None:
            raise FileNotFoundError(
                f"RealBench problem '{problem}' not found in manifest under '{args.realbench_root}'."
            )
        problem_context = build_realbench_problem_context(
            benchmark_name=benchmark,
            problem_name=problem,
            realbench_root=args.realbench_root,
            realbench_record=record,
        )
        ref_ppa_metrics = load_realbench_reference_ppa_metrics(
            args.realbench_root,
            record,
        )
        problem_spec = build_realbench_problem_spec(
            problem_context,
            realbench_record=record,
            supports_reference_ppa=bool(ref_ppa_metrics),
        )
        functional_evaluator = verilog_evaluator
        capabilities = problem_spec.capabilities
        if (
            capabilities is not None
            and capabilities.functional_harness_kind == "verilator_testbench"
        ):
            functional_evaluator = VerilatorEvaluator(
                default_simulation_timeout_seconds=args.rtl_simulation_timeout_s,
            )
        candidate_evaluator = CandidateEvaluator(
            context=problem_context,
            problem_description=problem_context.problem_description,
            verilog_evaluator=functional_evaluator,
            synthesis_evaluator=synthesis_evaluator,
            ref_ppa_metrics=ref_ppa_metrics,
            problem_spec=problem_spec,
            evaluation_mode=args.evaluation_mode,
            accelerated_synthesis_top_k=args.accelerated_synthesis_top_k,
            quality_mode=args.qd_quality_mode,
            alpha=args.qd_alpha,
            beta=args.qd_beta,
            gamma=args.qd_gamma,
            descriptor_profile=args.qd_descriptor_profile,
            descriptor_axes=args.qd_descriptor_axes,
            descriptor_file=args.qd_descriptor_file,
            archive_type=args.qd_archive_type,
        )
    else:
        problem_context = load_problem_context(benchmark, problem)
        ref_ppa_metrics = _load_reference_ppa_metrics(problem_context)
        problem_spec = build_problem_spec(
            problem_context,
            supports_reference_ppa=bool(ref_ppa_metrics),
        )
        functional_evaluator = verilog_evaluator
        capabilities = problem_spec.capabilities
        if (
            capabilities is not None
            and capabilities.functional_harness_kind == "verilator_testbench"
        ):
            functional_evaluator = VerilatorEvaluator(
                default_simulation_timeout_seconds=args.rtl_simulation_timeout_s,
            )
        candidate_evaluator = CandidateEvaluator(
            context=problem_context,
            problem_description=problem_context.problem_description,
            verilog_evaluator=functional_evaluator,
            synthesis_evaluator=synthesis_evaluator,
            ref_ppa_metrics=ref_ppa_metrics,
            problem_spec=problem_spec,
            evaluation_mode=args.evaluation_mode,
            accelerated_synthesis_top_k=args.accelerated_synthesis_top_k,
            quality_mode=args.qd_quality_mode,
            alpha=args.qd_alpha,
            beta=args.qd_beta,
            gamma=args.qd_gamma,
            descriptor_profile=args.qd_descriptor_profile,
            descriptor_axes=args.qd_descriptor_axes,
            descriptor_file=args.qd_descriptor_file,
            archive_type=args.qd_archive_type,
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
        problem_concurrency=problem_concurrency,
    )
    context = BackendExecutionContext(
        backend_name=args.backend,
        model_name=args.model_name,
        benchmark_name=benchmark,
        problem_name=problem,
        problem_context=problem_context,
        problem_spec=problem_spec,
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
            "rtl_simulation_timeout_s": getattr(args, "rtl_simulation_timeout_s", None),
            "synthesis_timeout_s": getattr(args, "synthesis_timeout_s", None),
            "post_synthesis_simulation_timeout_s": getattr(
                args, "post_synthesis_simulation_timeout_s", None
            ),
            "search_mode": getattr(args, "search_mode", "revolution"),
            **_parallelism_metadata(args),
        },
    )

    if args.backend == "revolution":
        backend_cfg = RevolutionBackendConfig(
            search_mode=args.search_mode,
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
            classic_operator_kind=args.classic_operator_kind,
            diff_apply_policy=args.diff_apply_policy,
            diff_max_tokens=args.diff_max_tokens,
            diff_compact_context=args.diff_compact_context,
            diff_similarity_threshold=args.diff_similarity_threshold,
            diff_fuzzy_margin=args.diff_fuzzy_margin,
            require_strict_format=True,
            prompt_profile=prompt_profile,
            prompt_root=prompt_root,
            candidate_workers=args.max_workers_per_problem,
            qd_archive_type=args.qd_archive_type,
            qd_num_cells=args.qd_num_cells,
            qd_fill_target_fraction=args.qd_fill_target_fraction,
            qd_improve_backfill_fraction=args.qd_improve_backfill_fraction,
            qd_cell_reservoir=args.qd_cell_reservoir,
            qd_cell_mode=args.qd_cell_mode,
            qd_max_elites_per_cell=args.qd_max_elites_per_cell,
            qd_objectives=args.qd_objectives,
            qd_two_parent_probability=args.qd_two_parent_probability,
            qd_neighbor_k=args.qd_neighbor_k,
            qd_cvt_warmup_successes=args.qd_cvt_warmup_successes,
            qd_grid_quantile_warmup_successes=args.qd_grid_quantile_warmup_successes,
            qd_grid_quantile_warmup_max_buffer=args.qd_grid_quantile_warmup_max_buffer,
            qd_quality_mode=args.qd_quality_mode,
            qd_alpha=args.qd_alpha,
            qd_beta=args.qd_beta,
            qd_gamma=args.qd_gamma,
            qd_descriptor_profile=args.qd_descriptor_profile,
            qd_descriptor_axes=tuple(args.qd_descriptor_axes or []),
            qd_descriptor_file=args.qd_descriptor_file,
            qd_enable_descriptor_experiments=args.qd_enable_descriptor_experiments,
            qd_descriptor_probe_budget=args.qd_descriptor_probe_budget,
            qd_grid_axes=tuple(args.qd_grid_axes or []),
            qd_cvt_axes=tuple(args.qd_cvt_axes or []),
            qd_fail_generation_mode=args.qd_fail_generation_mode,
            qd_seed_generation_mode=args.qd_seed_generation_mode,
            qd_backfill_generation_mode=args.qd_backfill_generation_mode,
            qd_refine_generation_mode=args.qd_refine_generation_mode,
            qd_crossover_generation_mode=args.qd_crossover_generation_mode,
            qd_formal_mode=args.qd_formal_mode,
            qd_operator_kind=args.qd_operator_kind,
            qd_operator_one_parent_fraction=args.qd_operator_one_parent_fraction,
            qd_operator_archive_context_size=args.qd_operator_archive_context_size,
            qd_operator_fail_feedback_chars=args.qd_operator_fail_feedback_chars,
            qd_operator_two_parent_allow_intra_bin=args.qd_operator_two_parent_allow_intra_bin,
            qd_rebinning_kind=args.qd_rebinning_kind,
            qd_rebinning_recent_generations=args.qd_rebinning_recent_generations,
            qd_rebinning_min_archive_members=args.qd_rebinning_min_archive_members,
            qd_rebinning_cooldown_generations=args.qd_rebinning_cooldown_generations,
            qd_rebinning_base_p_threshold=args.qd_rebinning_base_p_threshold,
            representation_kind=args.representation_kind,
            code_samples_per_thought=args.code_samples_per_thought,
            qd_thought_code_seeded=args.qd_thought_code_seeded,
            qd_seed_sample_fraction=args.qd_seed_sample_fraction,
            qd_champion_lane_fraction=args.qd_champion_lane_fraction,
            qd_parent_selection=args.qd_parent_selection,
            representative_sample=args.representative_sample,
            repair_kind=args.repair_kind,
            repair_max_attempts_per_sample=args.repair_max_attempts_per_sample,
            repair_max_attempts_per_thought=args.repair_max_attempts_per_thought,
            repair_evidence=args.repair_evidence,
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
            candidate_workers=args.max_workers_per_problem,
            diff_apply_policy=args.diff_apply_policy,
            diff_similarity_threshold=args.diff_similarity_threshold,
            diff_fuzzy_margin=args.diff_fuzzy_margin,
        )
        return EoHBackend(context=context, services=services, config=eoh_cfg)

    if args.backend == "codeevolve":
        try:
            scheduler_kwargs = json.loads(args.codeevolve_scheduler_kwargs_json)
        except json.JSONDecodeError as exc:
            raise ValueError(
                "--codeevolve_scheduler_kwargs_json must be valid JSON."
            ) from exc
        if not isinstance(scheduler_kwargs, dict):
            raise ValueError(
                "--codeevolve_scheduler_kwargs_json must decode to a JSON object."
            )
        effective_diff_max_tokens = _resolve_codeevolve_diff_max_tokens(args)
        codeevolve_cfg = CodeEvolveBackendConfig(
            num_islands=max(1, int(args.codeevolve_num_islands)),
            num_epochs=max(0, int(args.codeevolve_num_epochs)),
            init_pop=max(1, int(args.codeevolve_init_pop)),
            exploration_rate=float(args.codeevolve_exploration_rate),
            selection_policy=args.codeevolve_selection_policy,
            roulette_by_rank=bool(args.codeevolve_roulette_by_rank),
            meta_prompting=bool(args.codeevolve_meta_prompting),
            num_inspirations=max(0, int(args.codeevolve_num_inspirations)),
            max_chat_depth=max(0, int(args.codeevolve_max_chat_depth)),
            migration_topology=args.codeevolve_migration_topology,
            migration_interval=max(1, int(args.codeevolve_migration_interval)),
            migration_rate=float(args.codeevolve_migration_rate),
            use_scheduler=bool(args.codeevolve_use_scheduler),
            scheduler_type=args.codeevolve_scheduler_type,
            scheduler_kwargs=scheduler_kwargs,
            generation_mode=args.generation_mode,
            default_llm_temp=args.temperature,
            default_llm_top_p=args.top_p,
            default_llm_max_tokens=args.max_tokens,
            diff_max_tokens=effective_diff_max_tokens,
            max_evaluations=args.codeevolve_max_evaluations,
            max_llm_calls=args.codeevolve_max_llm_calls,
            max_llm_tokens=args.codeevolve_max_llm_tokens,
            max_runtime_seconds=args.codeevolve_max_runtime_seconds,
            prompt_profile=prompt_profile,
            prompt_root=prompt_root,
            strict_prompt_keys=args.codeevolve_strict_prompt_keys,
            seed=task_seed,
            candidate_workers=args.max_workers_per_problem,
            diff_apply_policy=args.diff_apply_policy,
            diff_similarity_threshold=args.diff_similarity_threshold,
            diff_fuzzy_margin=args.diff_fuzzy_margin,
        )
        return CodeEvolveBackend(context=context, services=services, config=codeevolve_cfg)

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
        candidate_workers=args.max_workers_per_problem,
    )
    return FunSearchBackend(context=context, services=services, config=fs_cfg)


def run_problem_worker(args_tuple: tuple[str, str, argparse.Namespace, int]):
    benchmark, problem, args, task_index = args_tuple
    task_seed = _derive_seed(args.seed, task_index)
    if task_seed is not None:
        os.environ["PYTHONHASHSEED"] = str(task_seed)
        random.seed(task_seed)

    model_name_cleaned = args.model_name.replace("/", "_")
    effective_save_path = _effective_save_path(args)
    problem_log_dir = os.path.join(effective_save_path, model_name_cleaned, benchmark, problem)
    os.makedirs(problem_log_dir, exist_ok=True)
    individual_log_path = os.path.join(problem_log_dir, "problem_run.log")

    config = getattr(args, "resolved_parallelism_config", None)
    handles = getattr(args, "parallelism_handles", None)
    if config is None:
        fallback_workers = max(
            1,
            int(getattr(args, "max_workers_per_problem", 1) or 1),
        )
        problem_concurrency = FixedProblemConcurrencyController(fallback_workers)
    else:
        problem_id = f"{benchmark}/{problem}/{task_index}"
        problem_concurrency = build_problem_concurrency_controller(
            config,
            problem_id=problem_id,
            handles=handles,
        )

    problem_concurrency.open_problem()
    try:
        with StreamRedirector(filepath=individual_log_path):
            print(
                f"\n[Worker PID: {os.getpid()}] backend={args.backend} starting {benchmark}/{problem} seed={task_seed}\n"
            )
            try:
                backend = _build_backend(
                    args,
                    benchmark,
                    problem,
                    task_seed,
                    problem_concurrency,
                )
                result = backend.run()
            except Exception as exc:
                traceback.print_exc()
                print(
                    f"[Worker PID: {os.getpid()}] failed {benchmark}/{problem} error={exc}\n"
                )
                return f"{problem},worker_error,{exc}", individual_log_path
            print(
                f"[Worker PID: {os.getpid()}] finished {benchmark}/{problem} status={result.status}\n"
            )
            return result.result_string, individual_log_path
    finally:
        problem_concurrency.close_problem()


def run_indexed_problem_worker(indexed_task):
    index, payload = indexed_task
    benchmark, problem, args = payload
    result = run_problem_worker((benchmark, problem, args, index))
    return index, result


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
    if "RealBench" not in available_benchmarks:
        available_benchmarks.append("RealBench")
    available_benchmarks = sorted(set(available_benchmarks))

    parser.add_argument(
        "--backend",
        type=str,
        default="revolution",
        choices=registered_backend_names(),
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
    parser.add_argument("--total_worker_slots", type=int, default=1)
    parser.add_argument("--max_active_problems", type=int, default=None)
    parser.add_argument("--max_workers_per_problem", type=int, default=None)
    parser.add_argument(
        "--parallelism_mode",
        type=str,
        default="elastic",
        help=argparse.SUPPRESS,
    )
    parser.add_argument("--num_workers", type=int, default=None, help=argparse.SUPPRESS)
    parser.add_argument(
        "--candidate_workers",
        type=int,
        default=None,
        help=argparse.SUPPRESS,
    )
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
    parser.add_argument(
        "--search_mode",
        type=str,
        default="revolution",
        choices=["revolution", "revolution_qd"],
    )
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
        help=(
            "CVDP category filter used when benchmark includes cvdp. "
            "Entries match challenge ids (cid002) or difficulty labels "
            "(medium); pass 'all' to select every dataset record."
        ),
    )
    parser.add_argument(
        "--cvdp_simulation_timeout_s",
        type=int,
        default=120,
        help="Timeout in seconds for CVDP harness pytest execution.",
    )
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
        "--realbench_root",
        type=str,
        default=os.path.abspath(
            os.path.join(os.path.dirname(__file__), "..", "data", "bench", "RealBench")
        ),
        help="Path to a RealBench module-manifest root.",
    )
    parser.add_argument(
        "--realbench_subset",
        type=str,
        default="module",
        choices=["module"],
        help="RealBench subset selector. Only module-level tasks are supported on this branch.",
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
    parser.add_argument(
        "--classic_operator_kind",
        type=str,
        default="eoh_strategies",
        choices=["eoh_strategies", "single_thought_operator"],
    )
    parser.add_argument(
        "--qd_archive_type",
        type=str,
        default="grid",
        choices=["grid", "cvt", "grid_quantile"],
    )
    parser.add_argument("--qd_num_cells", type=int, default=64)
    parser.add_argument("--qd_fill_target_fraction", type=float, default=0.25)
    parser.add_argument("--qd_improve_backfill_fraction", type=float, default=0.20)
    parser.add_argument("--qd_cell_reservoir", type=int, default=2)
    parser.add_argument(
        "--qd_cell_mode",
        type=str,
        default="scalar_elite",
        choices=["scalar_elite", "pareto_front", "elite_pareto_slot"],
    )
    parser.add_argument("--qd_max_elites_per_cell", type=int, default=1)
    parser.add_argument(
        "--qd_objectives",
        type=str,
        default="ppa",
        choices=["ppa"],
    )
    parser.add_argument("--qd_two_parent_probability", type=float, default=0.5)
    parser.add_argument("--qd_neighbor_k", type=int, default=8)
    parser.add_argument("--qd_cvt_warmup_successes", type=int, default=None)
    parser.add_argument("--qd_grid_quantile_warmup_successes", type=int, default=20)
    parser.add_argument("--qd_grid_quantile_warmup_max_buffer", type=int, default=0)
    parser.add_argument(
        "--qd_quality_mode",
        type=str,
        default="auto",
        choices=["auto", "ppa", "functional_only"],
    )
    parser.add_argument("--qd_alpha", type=float, default=None)
    parser.add_argument("--qd_beta", type=float, default=None)
    parser.add_argument("--qd_gamma", type=float, default=None)
    parser.add_argument("--qd_descriptor_profile", type=str, default=None)
    parser.add_argument("--qd_descriptor_axes", nargs="+", default=None)
    parser.add_argument("--qd_descriptor_file", type=str, default=None)
    parser.add_argument(
        "--qd_enable_descriptor_experiments",
        action=argparse.BooleanOptionalAction,
        default=False,
    )
    parser.add_argument("--qd_descriptor_probe_budget", type=int, default=0)
    parser.add_argument("--qd_grid_axes", nargs="+", default=None)
    parser.add_argument("--qd_cvt_axes", nargs="+", default=None)
    parser.add_argument(
        "--qd_fail_generation_mode",
        type=str,
        default="auto",
        choices=["auto", "whole", "diff"],
    )
    parser.add_argument(
        "--qd_seed_generation_mode",
        type=str,
        default="auto",
        choices=["auto", "whole", "diff"],
    )
    parser.add_argument(
        "--qd_backfill_generation_mode",
        type=str,
        default="auto",
        choices=["auto", "whole", "diff"],
    )
    parser.add_argument(
        "--qd_refine_generation_mode",
        type=str,
        default="auto",
        choices=["auto", "whole", "diff"],
    )
    parser.add_argument(
        "--qd_crossover_generation_mode",
        type=str,
        default="auto",
        choices=["auto", "whole", "diff"],
    )
    parser.add_argument(
        "--qd_formal_mode",
        type=str,
        default="auto",
        choices=["off", "auto", "required"],
    )
    parser.add_argument(
        "--qd_operator_kind",
        type=str,
        default="eoh_strategies",
        choices=["eoh_strategies", "single_thought_operator"],
    )
    parser.add_argument("--qd_operator_one_parent_fraction", type=float, default=0.5)
    parser.add_argument("--qd_operator_archive_context_size", type=int, default=4)
    parser.add_argument("--qd_operator_fail_feedback_chars", type=int, default=0)
    parser.add_argument(
        "--qd_operator_two_parent_allow_intra_bin",
        action=argparse.BooleanOptionalAction,
        default=True,
    )
    parser.add_argument(
        "--qd_rebinning_kind",
        type=str,
        default="disabled",
        choices=["disabled", "ks_triggered"],
    )
    parser.add_argument("--qd_rebinning_recent_generations", type=int, default=3)
    parser.add_argument("--qd_rebinning_min_archive_members", type=int, default=20)
    parser.add_argument("--qd_rebinning_cooldown_generations", type=int, default=3)
    parser.add_argument("--qd_rebinning_base_p_threshold", type=float, default=0.05)
    parser.add_argument(
        "--representation_kind",
        type=str,
        default="code_individual",
        choices=["code_individual", "thought_only"],
    )
    parser.add_argument("--code_samples_per_thought", type=int, default=4)
    parser.add_argument(
        "--qd_thought_code_seeded",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="Seed thought realization with the best parent code (doc 15 Fix B).",
    )
    parser.add_argument("--qd_seed_sample_fraction", type=float, default=1.0,
        help="Fraction of k samples that are seeded vs whole-regen leaps (B\u2032 hybrid; 1.0=pure Fix B).")
    parser.add_argument("--qd_champion_lane_fraction", type=float, default=0.0,
        help="Fraction of QD parents drawn from the global best (doc 15 Fix A champion lane).")
    parser.add_argument("--qd_parent_selection", type=str, default="cell_crowded_tournament",
        choices=["cell_crowded_tournament", "nsga2_global_rank"],
        help="QD parent selection: per-cell crowded tournament (default) or global "
             "NSGA-II non-domination-rank + crowding (smooth-QD V2, doc 16).")
    parser.add_argument(
        "--representative_sample",
        type=str,
        default="best_successful_quality",
        choices=["best_successful_quality"],
    )
    parser.add_argument(
        "--repair_kind",
        type=str,
        default="none",
        choices=["none", "bounded_local_repair"],
    )
    parser.add_argument("--repair_max_attempts_per_sample", type=int, default=0)
    parser.add_argument("--repair_max_attempts_per_thought", type=int, default=0)
    parser.add_argument(
        "--repair_evidence",
        type=str,
        default="stage_scoped_logs",
        choices=["stage_scoped_logs"],
    )

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

    # CodeEvolve-specific
    parser.add_argument("--codeevolve_num_islands", type=int, default=3)
    parser.add_argument("--codeevolve_num_epochs", type=int, default=50)
    parser.add_argument("--codeevolve_init_pop", type=int, default=10)
    parser.add_argument("--codeevolve_exploration_rate", type=float, default=0.2)
    parser.add_argument(
        "--codeevolve_selection_policy",
        type=str,
        default="roulette",
        choices=["roulette", "random"],
    )
    parser.add_argument(
        "--codeevolve_roulette_by_rank",
        action=argparse.BooleanOptionalAction,
        default=True,
    )
    parser.add_argument(
        "--codeevolve_meta_prompting",
        action=argparse.BooleanOptionalAction,
        default=True,
    )
    parser.add_argument("--codeevolve_num_inspirations", type=int, default=2)
    parser.add_argument("--codeevolve_max_chat_depth", type=int, default=3)
    parser.add_argument(
        "--codeevolve_migration_topology",
        type=str,
        default="ring",
        choices=[
            "directed_ring",
            "ring",
            "complete",
            "inward_star",
            "outward_star",
            "star",
            "empty",
        ],
    )
    parser.add_argument("--codeevolve_migration_interval", type=int, default=25)
    parser.add_argument("--codeevolve_migration_rate", type=float, default=0.1)
    parser.add_argument(
        "--codeevolve_use_scheduler",
        action=argparse.BooleanOptionalAction,
        default=True,
    )
    parser.add_argument(
        "--codeevolve_scheduler_type",
        type=str,
        default="plateau",
        choices=["plateau", "fixed"],
    )
    parser.add_argument(
        "--codeevolve_scheduler_kwargs_json",
        type=str,
        default='{"min_rate": 0.2, "max_rate": 0.5, "plateau_threshold": 5, "increase_factor": 1.05, "decrease_factor": 0.95}',
    )
    parser.add_argument("--codeevolve_max_evaluations", type=int, default=None)
    parser.add_argument("--codeevolve_max_llm_calls", type=int, default=None)
    parser.add_argument("--codeevolve_max_llm_tokens", type=int, default=None)
    parser.add_argument("--codeevolve_max_runtime_seconds", type=float, default=None)
    parser.add_argument(
        "--codeevolve_strict_prompt_keys",
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
            if not backend_supports_cvdp(args.backend):
                print(
                    f"Skipping benchmark '{benchmark}' for backend '{args.backend}' "
                    "(cvdp support is currently enabled only for registered CVDP-capable backends)."
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
        if benchmark.lower() == "realbench":
            selected_ids = args.problems if args.problems else None
            realbench_ids = select_realbench_problem_ids(
                args.realbench_root,
                selected_ids=selected_ids,
                subset=args.realbench_subset,
            )
            if not realbench_ids:
                print(
                    f"[RealBench] No matching IDs found under {args.realbench_root} "
                    f"for subset={args.realbench_subset}. Skipping."
                )
                continue
            for realbench_id in realbench_ids:
                tasks.append((benchmark, realbench_id, args))
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
    if args.problems:
        matched = {problem for _, problem, _ in tasks}
        missing = [p for p in args.problems if p not in matched]
        # A mistyped or mis-benchmarked problem must fail loudly, not
        # silently shrink the run (2026-06-12: Prob045_alu dropped from a
        # locked screen because it was listed under the wrong benchmark).
        assert not missing, f"problems not found in any listed benchmark: {missing}"
    return tasks


def main(argv: list[str] | None = None) -> int:
    raw_input_argv = list(sys.argv[1:] if argv is None else argv)
    try:
        reject_legacy_cli_options(
            raw_input_argv,
            runner_name="run_backend.py",
            legacy_options=BACKEND_LEGACY_CLI_OPTIONS,
        )
    except ValueError as exc:
        print(f"Configuration error: {exc}")
        return 2

    parser, config_parser = _build_parser()
    try:
        args, config_from_file, raw_argv = parse_args_with_config(
            parser, config_parser, argv=argv
        )
    except ConfigError as exc:
        print(f"Configuration error: {exc}")
        return 2

    if (
        args.backend == "revolution"
        and args.search_mode == "revolution_qd"
        and args.population_pool_mode == "single"
    ):
        print(
            "Configuration error: search_mode=revolution_qd does not support "
            "population_pool_mode=single."
        )
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
        for warning in _collect_vllm_token_budget_warnings(
            args,
            reported_model_len=preflight.get("max_model_len"),
        ):
            print(f"[vLLM budget] WARNING: {warning}")

    tasks_to_run = _discover_tasks(args)
    if not tasks_to_run:
        print("No valid tasks found to run.")
        return 1

    config_from_file = translate_backend_legacy_parallelism_config(
        args,
        config_from_file=config_from_file,
        raw_argv=raw_argv,
    )
    resolved_parallelism = resolve_backend_parallelism_config(
        args,
        task_count=len(tasks_to_run),
    )
    apply_resolved_parallelism_args(args, resolved_parallelism)

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
    hidden_legacy_keys = {
        "candidate_workers",
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

    original_stdout = sys.stdout
    results_data = []
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
                print(f"--- Backend run started: {run_datetime} backend={args.backend} ---")
                log_args = {
                    key: value
                    for key, value in vars(args).items()
                    if key
                    not in {
                        "candidate_workers",
                        "num_workers",
                        "parallelism_handles",
                        "parallelism_mode",
                        "resolved_parallelism_config",
                    }
                }
                print(f"Arguments: {log_args}")
                print("-" * 50)
                if resolved_parallelism.problem_processes <= 1:
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
                    results_data = _run_indexed_tasks_with_pool(
                        process_count=resolved_parallelism.problem_processes,
                        indexed_tasks=indexed_tasks,
                        original_stdout=original_stdout,
                    )
                print("--- All backend tasks completed ---")
        except KeyboardInterrupt:
            interrupted = True
            print("run_backend.py interrupted. Cleaning up worker pool state.")
    finally:
        end_time = time.time()
        completion_label = "interrupted" if interrupted else "completed"
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
            if interrupted:
                log_file.write("\nRun interrupted by user.\n")
            log_file.write(f"\n--- Backend run {completion_label} ---\n")
            log_file.write(f"Total run time: {end_time - start_time:.2f} seconds\n")

        if results_data:
            with open(summary_results_path, "w", encoding="utf-8") as summary_file:
                for result_str, _ in results_data:
                    summary_file.write(f"{result_str}\n")

        print(f"Comprehensive run log saved to: {comprehensive_log_path}")
        if results_data:
            print(f"Summary results saved to: {summary_results_path}")
        print(f"Total run time: {end_time - start_time:.2f} seconds")
        if runtime is not None:
            try:
                telemetry_events = runtime.drain_telemetry_events()
                telemetry_summary = summarize_scheduler_telemetry(
                    telemetry_events,
                    total_worker_slots=resolved_parallelism.total_worker_slots,
                )
                telemetry_summary["run_wall_seconds"] = end_time - start_time
                telemetry_summary["parallelism_config"] = {
                    "total_worker_slots": resolved_parallelism.total_worker_slots,
                    "max_active_problems": resolved_parallelism.max_active_problems,
                    "max_workers_per_problem": resolved_parallelism.max_workers_per_problem,
                    "problem_processes": resolved_parallelism.problem_processes,
                }
                telemetry_path = os.path.join(
                    master_log_dir, f"{run_datetime}_{args.backend}_scheduler_telemetry.json"
                )
                events_path = os.path.join(
                    master_log_dir,
                    f"{run_datetime}_{args.backend}_scheduler_telemetry_events.jsonl",
                )
                with open(telemetry_path, "w", encoding="utf-8") as handle:
                    json.dump(telemetry_summary, handle, indent=2)
                with open(events_path, "w", encoding="utf-8") as handle:
                    for event in telemetry_events:
                        handle.write(json.dumps(event) + "\n")
                print(f"Scheduler telemetry saved to: {telemetry_path}")
            except Exception as exc:  # pragma: no cover - telemetry must not break runs
                print(f"WARNING: failed to write scheduler telemetry: {exc}")
            runtime.close()
    if interrupted:
        return 130
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
