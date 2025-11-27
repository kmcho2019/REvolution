import asyncio
from concurrent.futures import ThreadPoolExecutor
import datetime
import json
import math
import os
import random
import re
import shutil
import time
import traceback
import uuid
from collections import defaultdict
from typing import Any, Iterator, Literal, TypeVar, cast, get_args, overload
from difflib import SequenceMatcher # Used for fuzzy matching in "diff" mode

# Imports used for CVDP Integration
import subprocess
from pathlib import Path

# Import from local modules
from .evaluation import SynthesisEvaluator, VerilogEvaluator
from .llm import LLMInterface, LLMRequest
from .logging import EoHLogger
from .prompt_store import PromptStore, safe_format # Able to load prompts from files


# Literal Typing for strategies (M-F, M-S, M-E, M-R, M-I, C-F, ...)
EvolStrategyMethod = Literal["initial", "M-F", "M-S", "M-E", "M-R", "M-I", "C-F"]
"""
Defines the set of all possible evolutionary strategies.
- **initial**: The first set of candidates generated from the problem description.
- **M-F**: Mutate-Fix: Corrects functional errors from parent.
- **M-S**: Mutate-Simplify: Simplifies the design while preserving functionality
- **M-E**: Mutate-Explore: Generates completely new designs based on parent.
- **M-R**: Mutate-Refactor: Maintains original thought from parent but refactors code.
- **M-I**: Mutate-Improve: Make general enhancements from parent.
- **C-F**: Crossover-Fusion: Combines the thought and code of two successful parents.
"""
EvolStrategyMethodFail = Literal["M-F", "M-S", "M-E", "M-R", "M-I"]
"""
Define the set of all possible evolutionary strategies for failing candidates(fail_pool).
- **M-F**: Mutate-Fix: Corrects functional errors from parent.
- **M-S**: Mutate-Simplify: Simplifies the design while preserving functionality
- **M-E**: Mutate-Explore: Generates completely new designs based on parent.
- **M-R**: Mutate-Refactor: Maintains original thought from parent but refactors code.
- **M-I**: Mutate-Improve: Make general enhancements from parent.
"""
EvolStrategyMethodSuccess = Literal["M-S", "M-E", "M-R", "M-I", "C-F"]
"""
Define the set of all possible evolutionary strategies for successful candidates(success_pool).
- **M-S**: Mutate-Simplify: Simplifies the design while preserving functionality
- **M-E**: Mutate-Explore: Generates completely new designs based on parent.
- **M-R**: Mutate-Refactor: Maintains original thought from parent but refactors code.
- **M-I**: Mutate-Improve: Make general enhancements from parent.
- **C-F**: Crossover-Fusion: Combines the thought and code of two successful parents.
"""

# Generic TypeVar for strategy types
StrategyT = TypeVar("StrategyT", EvolStrategyMethodFail, EvolStrategyMethodSuccess)
"""
Defines a generic type variable for strategy types, which can be either EvolStrategyMethodFail or EvolStrategyMethodSuccess.
"""


# Literal Typing for status
HeuristicStatus = Literal[
    "new",
    "success",
    "failed_format",
    "failed_diff",
    "failed_syntax",
    "failed_functionality",
    "failed_synthesis",
    "failed_synthesis_functionality",
]
"""
Defines the status of a heuristic candidate.
- **new**: Newly created candidate, not yet evaluated.
- **success**: Successfully passed all evaluations (syntax, functionality, synthesis, PPA).
- **failed_format**: LLM code output violated required output format/schema (e.g., violated JSON format).
- **failed_diff**: LLM produced a 'diff' but it could not be applied cleanly. (only occurs during 'diff' mode, never in 'whole' mode)
- **failed_syntax**: Failed syntax check during compilation.
- **failed_functionality**: Failed functional simulation against the reference design.
- **failed_synthesis**: Failed synthesis process.
- **failed_synthesis_functionality**: Synthesis successful, but post-synthesis functionality check failed.
"""

# Literal Typing for heuristic origin pool
HeuristicOriginPool = Literal["initial", "fail_pool", "success_pool"]
"""
Defines the origin pools for heuristic candidates.
- **initial**: The original pool of candidates generated from the problem description prompt from 0th generation.
- **fail_pool**: The pool of candidates that failed at least one evaluation.
- **success_pool**: The pool of candidates that passed all evaluations with valid fitness scores.
"""

# Literal Typing for strategy selection methods
StrategySelectionMethod = Literal["random", "epsilon-greedy", "ucb"]
"""
Defines the strategy selection methods for dynamic strategy selection.
- **random**: Randomly selects a strategy from the available strategies.
- **epsilon-greedy**: Greedy selection with exploration (epsilon) for strategy selection.
- **ucb**: Upper Confidence Bound selection for balancing exploration and exploitation but, uses softmax probabilities for selection.
"""

# Literal Typing to add a toggle type for population layout
PopulationPoolMode = Literal["dual", "single"]


class Heuristic:
    """
    Represents a single candidate solution in the evolutionary process.

    This class holds the "genetic" material (thought and code), evaluation
    results, and metadata about its origin and performance.

    :param id: Unique identifier for the heuristic (UUID).
    :type id: str
    :param thought: The design strategy or "thought process" from the LLM.
    :type thought: str
    :param code: The generated Verilog code.
    :type code: str
    :param feedback: The analysis or feedback received after evaluation.
    :type feedback: str
    :param score: The fitness score, typically based on PPA improvement.
    :type score: float
    :param generation: The generation number in which this heuristic was created.
    :type generation: int
    :param parent_ids: A list of IDs of the parent(s).
    :type parent_ids: list[str]
    :param status: The current evaluation status of the candidate.
    :type status: HeuristicStatus
    :param synthesis_success: Whether synthesis was successful.
    :type synthesis_success: bool
    :param synthesis_functionality: Whether post-synthesis functionality check was successful.
    :type synthesis_functionality: bool
    :param ppa_success: Whether PPA evaluation was successful.
    :type ppa_success: bool
    :param ppa_metrics: The PPA metrics obtained from synthesis (if applicable).
    :type ppa_metrics: dict[str, float]
    :param code_file_path: The file path where the Verilog code is saved.
    :type code_file_path: str
    :param strategy: The evolutionary strategy used to generate this heuristic.
    :type strategy: EvolStrategyMethod
    :param reward_from_parent: The reward obtained by the strategy that created this heuristic.
    :type reward_from_parent: float
    :param origin_pool: The population pool this heuristic originated from.
    :type origin_pool: HeuristicOriginPool
    :param generated_mode: Which mode produced this candidate ("whole" or "diff").
    :type generated_mode: Literal["whole", "diff"] | None
    """

    def __init__(
        self,
        thought: str,
        code: str,
        feedback: str,
        score: float = 0.0,
        generation: int = 0,
        parent_ids: list[str] | None = None,
        status: HeuristicStatus = "new",
        strategy: EvolStrategyMethod = "initial",
        origin_pool: HeuristicOriginPool = "initial",
    ) -> None:
        self.id: str = str(uuid.uuid4())  # Use UUID for unique ID
        self.thought: str = thought
        self.code: str = code
        self.feedback: str = feedback  # Feedback from LLM
        self.score: float = score
        self.generation: int = generation
        self.parent_ids: list[str] = parent_ids if parent_ids else []
        # New attributes for synthesis and PPA
        self.status: HeuristicStatus = status  # Status can be 'new', 'success', 'failed_syntax', 'failed_functionality', 'failed_synthesis', 'failed_synthesis_functionality'
        self.synthesis_success: bool = False
        self.synthesis_functionality: bool = False
        self.ppa_success: bool = False
        self.ppa_metrics: dict[str, float] = {}
        # File path to the code for evaluation purposes
        self.code_file_path: str = ""
        self.strategy: EvolStrategyMethod = strategy  # Strategy used to generate this heuristic, e.g., "initial", "M-F", "C-F", etc. (Total of 6 strategies + "initial")
        self.reward_from_parent: float = (
            0.0  # Reward obtained by the strategy that created this heuristic
        )
        self.origin_pool: HeuristicOriginPool = (
            origin_pool  # "initial", "fail_pool", or "success_pool"
        )
        self.generated_mode: Literal["whole", "diff"] | None = None

    def __repr__(self) -> str:
        """String representation for debugging and logging."""
        thought_repr = self.thought[:50]
        ppa_info = "PPA: Not run or failed"
        if self.ppa_success and self.ppa_metrics:
            # Format PPA metrics for cleaner display
            clk = self.ppa_metrics.get("eff_clk_period")
            area = self.ppa_metrics.get("area")
            power = self.ppa_metrics.get("power")
            # Check if clk, area, power are not None
            if clk is not None and area is not None and power is not None:
                # Format the PPA string with 4 decimal places for clk and 2 for area, power
                ppa_str = f"Eff. Clk: {clk:.4f}ns, Area: {area:.2f}, Power: {power:.4e}"
                ppa_info = f"PPA: ({ppa_str})"
            else:
                ppa_info = f"PPA: Incomplete metrics or not available (clk: {clk}, area: {area}, power: {power})"
        return (
            f"Heuristic(ID: {self.id}, Gen: {self.generation}, Origin: {self.origin_pool}, Strategy: {self.strategy}, Score: {self.score:.4f}, "
            f"Status: {self.status}, Thought: '{thought_repr}...', Parents: {self.parent_ids}, {ppa_info})"
        )


# Entire class executing for the new REvolution framework for each problem in the benchmark.
class EoHEngine:
    """
    The main engine for the REvolution evolutionary framework.

    This class orchestrates the entire evolutionary process for a single
    hardware design problem, including population management, evaluation,
    selection, and generation of new candidates.

    :param base_save_path: Base directory for saving results.
    :type base_save_path: str
    :param benchmark_name: Name of the benchmark being solved.
    :type benchmark_name: str
    :param problem_name: Name of the specific problem being solved.
    :type problem_name: str
    :param benchmark_path: Path to the benchmark directory.
    :type benchmark_path: str
    :param problem_description: Text description of the design problem.
    :type problem_description: str
    :param llm: The interface for communicating with LLMs.
    :type llm: LLMInterface
    :param evaluator: The tool for Verilog simulation.
    :type evaluator: VerilogEvaluator
    :param synthesis_evaluator: The tool for synthesis and PPA evaluation.
    :type synthesis_evaluator: SynthesisEvaluator
    :param population_size: Number of individuals in the population (μ).
    :type population_size: int
    :param num_offspring_lambda: Number of offspring to generate each generation (λ).
    :type num_offspring_lambda: int
    :param num_generations: Total number of generations to run.
    :type num_generations: int
    :param default_llm_temp: Default temperature for LLM sampling.
    :type default_llm_temp: float
    :param default_llm_top_p: Default top-p sampling parameter for LLM.
    :type default_llm_top_p: float
    :param default_llm_max_tokens: Default maximum tokens for LLM responses.
    :type default_llm_max_tokens: int
    :param clk_period: Clock period for the design, used in PPA evaluation.
    :type clk_period: float
    :param fail_pool: Population of failing candidates.
    :type fail_pool: list[Heuristic]
    :param success_pool: Population of successful candidates.
    :type success_pool: list[Heuristic]
    :param strategy_selection_method: Method for dynamic strategy selection (e.g., "random", "epsilon-greedy", "ucb").
    :type strategy_selection_method: StrategySelectionMethod
    :param epsilon: Epsilon value for epsilon-greedy strategy.
    :type epsilon: float
    :param ucb_c: Exploration parameter for UCB strategy.
    :type ucb_c: float
    :param fail_strats: List of strategies for failing candidates.
    :type fail_strats: List[EvolStrategyMethodFail]
    :param success_strats: List of strategies for successful candidates.
    :type success_strats: List[EvolStrategyMethodSuccess]
    :param fail_strategy_stats: Statistics for failing strategies.
    :type fail_strategy_stats: dict[EvolStrategyMethodFail, dict[str, int | float]]
    :param success_strategy_stats: Statistics for successful strategies.
    :type success_strategy_stats: dict[EvolStrategyMethodSuccess, dict[str, int | float]]
    :param current_generation: Current generation number.
    :type current_generation: int
    :param ref_ppa_metrics: Reference PPA metrics for comparison and fitness score calculation.
    :type ref_ppa_metrics: dict[str, float]
    :param logger: Logger instance for logging events and results.
    :type logger: EoHLogger
    :param run_start_time: Start time of the entire run.
    :type run_start_time: float
    :param run_start_utc: Start time of the run in UTC.
    :type run_start_utc: datetime.datetime
    :param gen_start_time: Start time of the current generation.
    :type gen_start_time: float
    :param generation_mode: Mode for generation (whole or diff).
    :type generation_mode: Literal["whole", "diff"]
    :param population_pool_mode: "dual" (existing behavior) or "single" to keep all candidates in one pool.
                                 Strategies still respect status: M-F selects failed parents; C-F selects successful parents.
    :type population_pool_mode: PopulationPoolMode
    :param require_strict_format: Whether to require strict adherence to output format/schema.
    :type require_strict_format: bool
    :param candidate_workers: Number of parallel workers to use when evaluating candidates within a generation. Values <= 1 disable candidate-level parallelism.
    :type candidate_workers: int | None
    """

    def __init__(
        self,
        # benchmark_dir: Path,
        benchmark_name: str,
        problem_name: str,
        llm_interface: LLMInterface,
        verilog_evaluator: VerilogEvaluator,
        synthesis_evaluator: SynthesisEvaluator,
        population_size: int = 10,
        num_generations: int = 5,
        default_llm_temp: float = 1.0,
        default_llm_top_p: float = 0.95,
        default_llm_max_tokens: int = 2048,
        base_save_path: str | None = None,
        strategy_selection_method: StrategySelectionMethod = "random",
        epsilon: float = 0.1,
        ucb_c: float = 2.0,
        generation_mode: Literal["whole", "diff"] = "whole",
        champion_metrics_config: list[dict[str, Any]] | None = None,
        population_pool_mode: PopulationPoolMode = "dual",
        require_strict_format: bool = True,
        prompt_profile: str = "default",
        prompt_root: str | None = None,
        candidate_workers: int | None = None,
    ):
        self.generation_mode: Literal["whole", "diff"] = generation_mode
        self.base_save_path: str = (
            base_save_path
            if base_save_path
            else os.path.join(os.getcwd(), "verilog_eoh_results")
        )
        self.benchmark_name: str = benchmark_name
        self.problem_name: str = problem_name
        self.benchmark_path: str = os.path.abspath(
            os.path.join(
                os.path.dirname(os.path.abspath(__file__)),
                "..",
                "..",
                "data",
                "bench",
                self.benchmark_name,
            )
        )
        self.problem_description: str = self.load_problem_description()
        self.llm: LLMInterface = llm_interface
        self.evaluator: VerilogEvaluator = verilog_evaluator
        self.synthesis_evaluator: SynthesisEvaluator = synthesis_evaluator
        self.population_size: int = population_size
        self.num_offspring_lambda: int = (
            population_size  # λ, number of offspring to generate
        )
        self.num_generations: int = num_generations
        self.default_llm_temp: float = default_llm_temp
        self.default_llm_top_p: float = default_llm_top_p
        self.default_llm_max_tokens: int = default_llm_max_tokens
        self.clk_period: float = synthesis_evaluator.clk_period

        self.require_strict_format: bool = require_strict_format

        # Candidate-level concurrency configuration
        self.candidate_workers: int = (
            candidate_workers if candidate_workers and candidate_workers > 0 else 0
        )
        self.parallelize_candidates: bool = self.candidate_workers > 1

        # Champion Metrics Configuration
        # Defines the configuration for champion metrics.
        # It allows the best candidate to be selected based on specific metrics.
        # This was added to allow for more flexible champion selection based on user-defined metrics.
        # If None, it defaults to the original behavior of selecting based on power, area, and effective clock period.
        # Each metric can have a goal (e.g., "minimize" or "maximize") and an optional condition for when to apply it.
        self.champion_metrics_config: list[dict[str, Any]]
        if champion_metrics_config is None:
            # Default configuration for RTL (original behavior)
            self.champion_metrics_config = [
                {"name": "power", "goal": "minimize"},
                {"name": "area", "goal": "minimize"},
                {
                    "name": "eff_clk_period",
                    "goal": "minimize",
                    "condition": lambda engine, candidates: engine.ref_ppa_metrics.get(
                        "eff_clk_period", 0.0
                    )
                    != 0.0,
                },
            ]
        else:
            self.champion_metrics_config = champion_metrics_config

        # Population pool mode + single-pool storage
        self.population_pool_mode: PopulationPoolMode = population_pool_mode
        self.population: list[
            Heuristic
        ] = []  # used when population_pool_mode == "single"

        # Simplified to two population pools
        self.fail_pool: list[Heuristic] = []
        self.success_pool: list[Heuristic] = []

        # Add attributes for dynamic strategy selection using meta-strategies
        # Formulate problem of picking which strategy to use as a multi-armed bandit problem
        self.strategy_selection_method: StrategySelectionMethod = (
            strategy_selection_method  # "random", "epsilon-greedy", "ucb"
        )
        self.epsilon: float = epsilon  # For epsilon-greedy strategy (default 0.1)
        self.ucb_c: float = (
            ucb_c  # Exploration parameter for UCB strategy (default 2.0)
        )

        self.fail_strats: list[EvolStrategyMethodFail] = list(
            get_args(EvolStrategyMethodFail)
        )
        self.success_strats: list[EvolStrategyMethodSuccess] = list(
            get_args(EvolStrategyMethodSuccess)
        )
        self.fail_strategy_stats: dict[
            EvolStrategyMethodFail, dict[str, int | float]
        ] = {s: {"count": 0, "value": 0.0} for s in self.fail_strats}
        self.success_strategy_stats: dict[
            EvolStrategyMethodSuccess, dict[str, int | float]
        ] = {s: {"count": 0, "value": 0.0} for s in self.success_strats}

        self.current_generation: int = 0
        self.ref_ppa_metrics: dict[str, float] = {}
        self.logger: EoHLogger | None = None
        self.run_start_time: float = 0
        self.run_start_utc: datetime.datetime | None = None
        self.gen_start_time: float = 0

        # --- Diff application tunables (ported from Aider-style behavior) ---
        self.diff_similarity_threshold: float = 0.80   # accept fuzzy match if >= this ratio
        self.diff_length_scale: float = 0.10           # +/- window around SEARCH size (in lines)
        self.diff_allow_dots: bool = True              # treat "..." lines in SEARCH/REPLACE as wildcards

        # (single-pool ablation knobs; no effect in "dual")
        self.single_fail_allocation_cap: float = 0.25     # max fraction of offspring from failed parents once any success exists
        self.single_success_min_fraction: float = 0.80    # survivor selection keeps at least this fraction successes
        self.single_success_weight_exp: float = 1.5       # >1.0 increases winner-take-all among successful parents

       # Where to look for prompts; default to data/prompts/<profile>
        pr_root = prompt_root or os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "..", "..", "data", "prompts"
        )
        self.prompts = PromptStore(root_dir=os.path.abspath(pr_root), profile=prompt_profile)
        # Debug PromptStore
        print(f"[EoHEngine] Initialized PromptStore root_dir:{os.path.abspath(pr_root)}, profile:{prompt_profile}.")
        print(f"[EoHEngine] Using PromptStore at root: {self.prompts.root_dir}, profile: {self.prompts.profile}")


    def load_problem_description(self) -> str:
        """
        Load the text prompt ``<problem>_prompt.txt`` from the benchmark folder.

        :return: The problem description text.
        :rtype: str
        """
        prompt_path = os.path.join(
            self.benchmark_path, f"{self.problem_name}_prompt.txt"
        )
        if os.path.exists(prompt_path):
            with open(prompt_path, "r") as f:
                return f.read().strip()
        else:
            raise FileNotFoundError(
                f"Problem description file not found: {prompt_path}"
            )

    def _copy_misc_files(self, output_directory: str) -> None:
        """
        Copy non-RTL auxiliary files required by some test-benches to *output_directory*.

        :param output_directory: Directory where the files should be copied.
        :type output_directory: str

        :return: None
        :rtype: None
        """
        misc_files = [
            f
            for f in os.listdir(self.benchmark_path)
            if f.startswith(self.problem_name)
            and not f.endswith(
                (
                    "_makefile",
                    "_ifc.txt",
                    "_ppa.txt",
                    "_prompt.txt",
                    "_ref.sv",
                    "_test.sv",
                    "_compiled.vvp",
                    "_simulation.log",
                    "_ref.syn.v",
                )
            )
        ]
        for file_name in misc_files:
            source_path = os.path.join(self.benchmark_path, file_name)
            dest_path = os.path.join(output_directory, file_name)
            if not os.path.exists(dest_path):
                shutil.copy(source_path, dest_path)

    def _normalize_code_text(self, s: str) -> str:
        """
        Convert escaped sequences (\\n, \\t, \\r) into real characters when it looks like
        we got an escaped JSON string instead of plain code. Heuristics avoid over-decoding.
        """
        # Always normalize CRLF -> LF
        s0 = s.replace("\r\n", "\n")

        # If there are MANY literal "\n" and FEW real newlines, treat as escaped
        lit = s0.count("\\n")
        real = s0.count("\n")
        if lit >= 2 and real <= max(1, lit // 4):
            # Try a safe one-pass decode
            try:
                # decode common escapes: \n, \t, \r, \", \uXXXX
                s1 = s0.encode("utf-8").decode("unicode_escape")
            except Exception:
                # Fallback conservative replacements
                s1 = (
                    s0.replace("\\r\\n", "\n")
                    .replace("\\n", "\n")
                    .replace("\\t", "\t")
                    .replace('\\"', '"')
                )
            # Strip accidental outer quotes (rare, but happens)
            if (s1.startswith('"') and s1.endswith('"')) or (s1.startswith("'") and s1.endswith("'")):
                # Only strip if it looks like a single-line wrapper
                if "\n" in s1[1:-1]:
                    s1 = s1[1:-1]
            return s1

        return s0

    def _save_result_to_file(
        self,
        code_content: str,
        thought_content: str,
        generation_num: int,
        sample_idx_in_generation: int,
        strategy: EvolStrategyMethod | None = None,
        diff_content: str | None = None,
    ) -> tuple[str, str]:
        """
        Save the generated code and thought process to ``<save_path>/Gen<k>/``.
        If diff_content is JSON with code.edits, also write {base_name}_diff.json
        and emit a legacy fenced .diff synthesized from the JSON hunks.
        If diff_content is legacy text, write it as-is to {base_name}.diff.

        :param code_content: The Verilog code to save.
        :type code_content: str
        :param thought_content: The thought process or strategy description to save.
        :type thought_content: str
        :param generation_num: The generation number (k) for this candidate.
        :type generation_num: int
        :param sample_idx_in_generation: The index of this sample in the generation.
        :type sample_idx_in_generation: int
        :param strategy: The evolutionary strategy used to generate this candidate.
        :type strategy: EvolStrategyMethod | None
        :param diff_content: The diff content if applicable (for "diff" generation mode).
        :type diff_content: str | None

        :return: Tuple containing the file paths of the saved code and thought files.
        :rtype: tuple[str, str]
        """
        model_name_cleaned = self.llm.model_name.replace("/", "_")
        generation_path = os.path.join(
            self.base_save_path,
            model_name_cleaned,
            self.benchmark_name,
            self.problem_name,
            f"Gen{generation_num}",
        )
        os.makedirs(generation_path, exist_ok=True)

        base_name = f"{self.problem_name}_sample{sample_idx_in_generation}_{strategy}"
        candidate_dir = os.path.join(generation_path, base_name)
        os.makedirs(candidate_dir, exist_ok=True)

        code_file_path = os.path.join(candidate_dir, "code.sv")
        thought_file_path = os.path.join(candidate_dir, "thought.txt")
        diff_file_path = os.path.join(candidate_dir, "diff.txt")
        json_diff_file_path = os.path.join(candidate_dir, "diff.json")

        with open(code_file_path, "w") as f:
            # Normalize escaped newlines/tabs/quotes if present
            normalized_code = self._normalize_code_text(str(code_content))
            f.write(normalized_code)
        with open(thought_file_path, "w") as f:
            f.write(str(thought_content))

        # Also save diff artifacts if provided
        if diff_content:
            wrote_legacy = False
            try:
                parsed = json.loads(diff_content)
                # Treat as JSON diff; save pretty JSON
                with open(json_diff_file_path, "w") as f:
                    f.write(json.dumps(parsed, indent=2))

                # Extract edits: support both top-level "edits" and "code": {"edits": ...}
                edits = None
                if isinstance(parsed, dict):
                    if isinstance(parsed.get("code"), dict) and "edits" in parsed["code"]:
                        edits = parsed["code"]["edits"]
                    elif "edits" in parsed:
                        edits = parsed["edits"]

                legacy_parts: list[str] = []
                if isinstance(edits, list) and edits:
                    for edit in edits:
                        file_path = (edit.get("file") or code_file_path)
                        hunks = edit.get("hunks", [])
                        for h in hunks:
                            search = h.get("search", "")
                            replace = h.get("replace", "")
                            # Ensure trailing newlines for parser compatibility
                            if search and not search.endswith("\n"):
                                search += "\n"
                            if replace and not replace.endswith("\n"):
                                replace += "\n"
                            legacy_parts.append(
                                f"{file_path}\n```\n"
                                f"<<<<<<< SEARCH\n{search}=======\n{replace}>>>>>>> REPLACE\n"
                                f"```\n"
                            )
                # If we built at least one block, write legacy .diff; otherwise fall back to raw content
                legacy_text = "".join(legacy_parts) if legacy_parts else str(diff_content)
                with open(diff_file_path, "w") as f:
                    f.write(legacy_text)
                wrote_legacy = True
            except Exception:
                # Not JSON; write legacy diff as-is
                pass

            if not wrote_legacy:
                with open(diff_file_path, "w") as f:
                    f.write(str(diff_content))

        self._copy_misc_files(candidate_dir)
        return code_file_path, thought_file_path

    def _calculate_reference_ppa(self) -> None:
        """
        Loads the pre-calculated PPA metrics for the reference design.
        If the PPA file is missing or malformed, it sets default high values.
        """
        print(f"\n--- Calculating Reference PPA for {self.problem_name} ---")
        # Instead of synthesizing the reference Verilog file, we will use the pre-synthesized reference file.
        # This is to ensure that we have a consistent reference PPA across all runs.
        # The reference Verilog file is expected to be in the benchmark directory with the name <problem_name>_ppa.txt
        # Format of the reference PPA file is:
        # tns,wns,eff_clk_period,power,area
        # value0,value1,value2,value3,value4
        # Example:
        # tns,wns,eff_clk_period,power,area
        # 0.0,0.0,0.0,2.36e-08,1.0
        # If the file does not exist, we will use default high PPA values.

        ref_ppa_file = os.path.join(self.benchmark_path, f"{self.problem_name}_ppa.txt")
        if os.path.exists(ref_ppa_file):
            with open(ref_ppa_file, "r") as f:
                lines = f.readlines()
                if len(lines) < 2:
                    print(
                        f"WARNING: Reference PPA file {ref_ppa_file} is malformed. Using default high PPA values."
                    )
                    self.ref_ppa_metrics = {
                        "tns": 0.0,
                        "wns": 0.0,
                        "eff_clk_period": self.clk_period,
                        "area": 1e4,
                        "power": 1.0,
                    }
                    return

                # Parse the second line for metrics
                values = lines[1].strip().split(",")
                if len(values) < 5:
                    print(
                        f"WARNING: Reference PPA file {ref_ppa_file} does not contain enough values. Using default high PPA values."
                    )
                    self.ref_ppa_metrics = {
                        "tns": 0.0,
                        "wns": 0.0,
                        "eff_clk_period": self.clk_period,
                        "area": 1e4,
                        "power": 1.0,
                    }
                    return

                # If area and power are zero, we also call warning and set it to high values
                if float(values[3]) == 0.0 or float(values[4]) == 0.0:
                    print(
                        f"WARNING: Reference PPA file {ref_ppa_file} has zero area or power. Using default high PPA values."
                    )
                    self.ref_ppa_metrics = {
                        "tns": 0.0,
                        "wns": 0.0,
                        "eff_clk_period": self.clk_period,
                        "area": 1e4,
                        "power": 1.0,
                    }
                    return

                self.ref_ppa_metrics = {
                    "tns": float(values[0]),
                    "wns": float(values[1]),
                    "eff_clk_period": float(values[2]),
                    "power": float(values[3]),
                    "area": float(values[4]),
                }
                print(f"Reference PPA loaded successfully: {self.ref_ppa_metrics}")

    def _calculate_fitness_score(self, candidate: Heuristic) -> float:
        """
        Calculates a fitness score for a successful candidate based on PPA improvement.
        Fitness score formula:
        * P_gen = candidate's power
        * A_gen = candidate's area
        * T_gen = candidate's effective clock period
        * P_ref = reference power
        * A_ref = reference area
        * T_ref = reference effective clock period
        - if sequential circuit:
        fitness = (-(P_gen - P_ref) / P_ref + -(A_gen - A_ref) / A_ref + -(T_gen - T_ref) / T_ref) / 3
        - if combinational circuit:
        fitness = (-(P_gen - P_ref) / P_ref + -(A_gen - A_ref) / A_ref) / 2

        :param candidate: The candidate Heuristic to score.
        :type candidate: Heuristic
        :return: The calculated fitness score. PPA improvement compared to the reference design results in higher score.
        :rtype: float
        """
        if not candidate.ppa_success or not self.ref_ppa_metrics:
            return 0

        P_gen = candidate.ppa_metrics.get("power")
        A_gen = candidate.ppa_metrics.get("area")
        T_gen = candidate.ppa_metrics.get("eff_clk_period")

        P_ref = self.ref_ppa_metrics.get("power")
        A_ref = self.ref_ppa_metrics.get("area")
        T_ref = self.ref_ppa_metrics.get("eff_clk_period")

        if any(v is None for v in [P_gen, A_gen, T_gen, P_ref, A_ref, T_ref]):
            print(
                f"Warning: Missing PPA values for {candidate.id} or reference. Assigning low fitness."
            )
            return 0
        else:
            # Reassign values so that they are not None
            # Because of earlier check, we know that they are not None
            # But we add this to avoid type errors
            p_gen = P_gen if P_gen else 1.0
            a_gen = A_gen if A_gen else 1.0
            t_gen = T_gen if T_gen else 1.0
            p_ref = P_ref if P_ref else 1.0
            a_ref = A_ref if A_ref else 1.0
            t_ref = T_ref if T_ref else 1.0

        power_improvement = (p_gen - p_ref) / p_ref
        area_improvement = (a_gen - a_ref) / a_ref
        timing_improvement = None  # Default to None for combinational circuits

        # A non-zero TNS or WNS in reference implies a sequential circuit for this calculation
        # Combinatorial circuits will have TNS and WNS as 0, and eff_clk_period of 0
        # If T_ref is 0.0 than it is a combinational circuit
        if t_ref == 0.0:
            is_sequential = False
        else:
            is_sequential = True

        if is_sequential:
            timing_improvement = (t_gen - t_ref) / t_ref
            total_improvement = (
                power_improvement + area_improvement + timing_improvement
            ) / 3
        else:  # Combinational
            total_improvement = (power_improvement + area_improvement) / 2

        # Fitness is maximized, and lower improvement % is better. So, fitness = -improvement.
        return -total_improvement

    def _save_feedback_files(
        self, candidate: Heuristic, feedback: dict[str, int | str | None]
    ) -> None:
        """
        Helper to save feedback files for a failed candidate.
        This function creates a feedback file named `<code_base_name>_feedback.txt` in the same directory as the candidate's code file.

        :param candidate: The candidate for which feedback is being saved.
        :type candidate: Heuristic
        :param feedback: The feedback dictionary containing score, justification, and analysis.
        :type feedback: dict[str, int | str | None]
        :return: None
        :rtype: None
        """
        base_path = candidate.code_file_path.rsplit(".", 1)[0]
        feedback_file_path = f"{base_path}_feedback.txt"
        with open(feedback_file_path, "w") as f:
            f.write(
                f"Score: {feedback.get('score', 'N/A')}\nJustification: {feedback.get('justification', 'N/A')}\n\nANALYSIS:\n{feedback.get('analysis', '')}"
            )

    def _resolve_top_module_name(self) -> str:
        top_module_name_file = os.path.join(
            self.benchmark_path, "synthesis_top_module_names.json"
        )
        if not os.path.exists(top_module_name_file):
            print(
                "WARNING: Top module name file not found. Using default module name 'TopModule'."
            )
            return "TopModule"
        with open(top_module_name_file, "r", encoding="utf-8") as f:
            top_module_names = json.load(f)
        return top_module_names.get(self.problem_name, "TopModule")

    def _evaluate_candidate_pipeline(
        self,
        cand: Heuristic,
        test_sv_file: str,
        ref_sv_file: str | None,
        top_module_name: str,
    ) -> tuple[Heuristic, dict[str, str] | None]:
        feedback_payload: dict[str, str] | None = None

        if getattr(cand, "status", None) in ("failed_format", "failed_diff"):
            cand.score = -float("inf")
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": cand.code,
                "simulation_log": f"Candidate failed format or diff compliance checks. Status: {cand.status}",
            }
            return cand, feedback_payload

        sim_results = self.evaluator.evaluate(
            cand.code_file_path, test_sv_file, ref_sv_file
        )

        if sim_results["status"] == "compilation_error":
            cand.status = "failed_syntax"
            cand.score = -float("inf")
            log = sim_results.get(
                "compilation_stderr", "Compilation log not available."
            )
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": cand.code,
                "simulation_log": log,
            }
            return cand, feedback_payload

        is_success = False
        if sim_results["status"] == "success":
            output = sim_results.get("simulation_stdout", "")
            m_match = re.search(r"^Mismatches: (\d+)", output, re.M)
            if (m_match and int(m_match.group(1)) == 0) or (
                "===========Your Design Passed===========" in output
            ):
                is_success = True

        if not is_success:
            cand.status = "failed_functionality"
            cand.score = -float("inf")
            log = (
                f"Compilation Log:\n{sim_results.get('compilation_stderr')}\n\n"
                f"Simulation Log:\n{sim_results.get('simulation_stdout')}\n{sim_results.get('simulation_stderr')}"
            )
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": cand.code,
                "simulation_log": log,
            }
            return cand, feedback_payload

        # Stage 2: Synthesis and PPA for functionally correct candidates
        report_base_path = cand.code_file_path.rsplit(".", 1)[0]
        output_dir = os.path.dirname(cand.code_file_path)
        synth_results = self.synthesis_evaluator.evaluate(
            cand.code_file_path,
            self.problem_name,
            top_module_name,
            output_dir,
            report_base_path,
            self.evaluator,
            test_sv_file,
            ref_sv_file,
        )

        if (
            synth_results["synthesis_success"]
            and synth_results["synthesis_functionality_success"]
            and synth_results["ppa_success"]
        ):
            cand.status = "success"
            cand.synthesis_success = True
            cand.synthesis_functionality = True
            cand.ppa_success = True
            cand.ppa_metrics = synth_results["ppa_metrics"]
            cand.score = self._calculate_fitness_score(cand)
            cand.feedback = (
                "Functionality OK and Synthesis OK. Now focus on improving PPA metrics while "
                "preserving functionality. PPA metrics (tns/wns/eff_clk_period: ns, power: W, area: um^2): "
                f"{cand.ppa_metrics}, Reference PPA metrics: {self.ref_ppa_metrics},  PPA score: {cand.score:.4f}, "
                "Try to improve PPA metrics further. If effective clockspeed is close to 0.0, than focus on improving area and power metrics."
            )
            feedback_payload = {
                "problem_def": self.problem_description,
                "code": cand.code,
                "simulation_log": cand.feedback,
            }
        else:
            cand.score = -float("inf")
            cand.synthesis_success = synth_results["synthesis_success"]
            cand.synthesis_functionality = synth_results[
                "synthesis_functionality_success"
            ]

            if not synth_results["synthesis_success"]:
                cand.status = "failed_synthesis"
                log = (
                    "Functionality OK, but synthesis failed.\nLog:\n"
                    f"{synth_results.get('synthesis_log', 'N/A')}"
                )
            elif not synth_results["synthesis_functionality_success"]:
                cand.status = "failed_synthesis_functionality"
                log = (
                    "Functionality OK, Synthesis OK, but Post-Synthesis Functional Check failed "
                    "(Yosys have trouble synthesizing the implementation try to improve synthesizability).\nLog:\n"
                    f"{synth_results.get('synthesis_log', 'N/A')}"
                )
            else:
                cand.status = "failed_synthesis"
                log = (
                    "Synthesis or PPA failed.\nLog:\n"
                    f"{synth_results.get('synthesis_log', 'N/A')}"
                )

            feedback_payload = {
                "problem_def": self.problem_description,
                "code": cand.code,
                "simulation_log": log,
            }

        return cand, feedback_payload

    def _evaluate_candidates(self, candidates_to_evaluate: list[Heuristic]) -> None:
        """
        Evaluates a list of new candidates through the full pipeline (syntax, func, synth).
        Updates each candidate object with its final status, feedback, and score.

        :param candidates_to_evaluate: List of Heuristic candidates to evaluate.
        :type candidates_to_evaluate: list[Heuristic]

        :return: None
        :rtype: None
        """
        if not candidates_to_evaluate:
            return

        print(f"\n--- Evaluating {len(candidates_to_evaluate)} New Candidates ---")
        test_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_test.sv")
        ref_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_ref.sv")
        top_module_name = self._resolve_top_module_name()

        if self.parallelize_candidates:
            with ThreadPoolExecutor(max_workers=self.candidate_workers) as executor:
                results = [
                    executor.submit(
                        self._evaluate_candidate_pipeline,
                        cand,
                        test_sv_file,
                        ref_sv_file,
                        top_module_name,
                    )
                    for cand in candidates_to_evaluate
                ]
                evaluated = [future.result() for future in results]
        else:
            evaluated = [
                self._evaluate_candidate_pipeline(
                    cand, test_sv_file, ref_sv_file, top_module_name
                )
                for cand in candidates_to_evaluate
            ]

        feedback_request_candidates: list[Heuristic] = []
        feedback_requests: list[dict[str, str]] = []

        # 1. Load raw templates
        feedback_rtl_sys_prompt = self.prompts.read("feedback/system")
        feedback_rtl_user_tpl = self.prompts.read("feedback/user")
        
        user_overrides: list[str] | None = [] if feedback_rtl_user_tpl else None

        for cand, feedback_payload in evaluated:
            if feedback_payload:
                feedback_request_candidates.append(cand)
                feedback_requests.append(feedback_payload)

                # Apply safe_format using data from the feedback_payload
                if feedback_rtl_user_tpl:
                    formatted_prompt = safe_format(
                        feedback_rtl_user_tpl,
                        problem_def=feedback_payload.get("problem_def", ""),
                        code=feedback_payload.get("code", ""),
                        simulation_log=feedback_payload.get("simulation_log", "")
                    )
                    user_overrides.append(formatted_prompt)

        # Stage 3: Batch LLM Feedback Generation for all failures
        if feedback_requests:
            print(
                f"Requesting LLM feedback for {len(feedback_request_candidates)} candidates (both failed and successful)..."
            )

            # Debug logs
            print(f"[EoHEngine] Using feedback system prompt: {bool(feedback_rtl_sys_prompt)}")
            print(f"[EoHEngine] Using feedback user template: {bool(feedback_rtl_user_tpl)}")

            # Prepare system prompt list (same prompt for everyone)
            system_overrides = (
                [feedback_rtl_sys_prompt] * len(feedback_requests) 
                if feedback_rtl_sys_prompt 
                else None
            )

            feedback_results = asyncio.run(
                self.llm.generate_batch_feedback(
                    feedback_requests,
                    self.default_llm_temp,
                    self.default_llm_top_p,
                    self.default_llm_max_tokens,
                    system_prompt_override=system_overrides,
                    user_prompt_override=user_overrides,
                )
            )
            for cand, feedback_data in zip(
                feedback_request_candidates, feedback_results
            ):
                cand.feedback = feedback_data.get(
                    "analysis", "Feedback generation failed."
                )
                self._save_feedback_files(cand, feedback_data)

    # Prompt generation functions for the 6 new strategies
    def _format_parent_for_prompt(self, parent: Heuristic, example_num: int = 1) -> str:
        """
        Helper to format a parent candidate for inclusion in a prompt.
        Returns a JSON string (no markdown fences).

        :param parent: The parent candidate to format.
        :type parent: Heuristic
        :param example_num: The example number for formatting. (default is 1) Useful for fusion strategy where we have two parents.
        :type example_num: int
        """
        parent_payload: dict[str, Any] = {
            "example": example_num,
            "thought": parent.thought,
            "code": parent.code,
            "feedback": parent.feedback,
        }
        if parent.ppa_success:
            parent_payload["ppa_metrics"] = parent.ppa_metrics
        return json.dumps(parent_payload, indent=2)

    def _create_prompt_M_F(self, parents: list[Heuristic]) -> str:  # Fix
        """
        Creates a prompt for the 'Fix' mutation strategy.
        This strategy is used when a previous attempt has failed, and the goal is to fix the code based on feedback.

        :param parents: List of parent candidates to use as examples.
        :type parents: list[Heuristic]
        :return: The formatted prompt string.
        :rtype: str
        """
        parent = parents[0]
        if self.generation_mode == "whole":
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "fix_failed_attempt",
                "problem_description": self.problem_description,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-F/whole")
            if tpl:
                return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
            
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Use the JSON context to generate a corrected solution.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "<brief explanation of the fix>",\n'
                '  "code": "<full, runnable Verilog as one JSON string>"\n'
                "}\n"
                "Rules: valid JSON only (no markdown). Escape newlines as \\n and quotes.\n"
                r'All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )
        else:  # diff mode
            with open(parent.code_file_path, "r") as f:
                parent_code = f.read()
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "fix_failed_attempt_via_patch",
                "problem_description": self.problem_description,
                "file_to_edit": parent.code_file_path,
                "original_file": parent_code,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-F/diff")
            if tpl:
                return safe_format(
                    tpl,
                    context_json=json.dumps(context_obj, indent=2),
                    file_to_edit=parent.code_file_path,
                    original_file=parent_code,
                )
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Use the JSON context to propose precise edits.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "diff",\n'
                '  "thought": "<brief explanation of the changes>",\n'
                '  "code": {\n'
                '    "edits": [\n'
                f'      {{ "file": "{parent.code_file_path}", "hunks": [\n'
                '          { "search": "<exact original text>\\n", "replace": "<replacement text>\\n" }\n'
                "        ] }\n"
                "    ]\n"
                "  }\n"
                "}\n"
                "Rules: valid JSON only; SEARCH must match exactly; escape newlines as \\n.\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                r'- All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )

    def _create_prompt_M_S(self, parents: list[Heuristic]) -> str:  # Simplify
        """
        Creates a prompt for the 'Simplify' mutation strategy.
        This strategy is used to simplify a previous solution while maintaining its functionality.
        :param parents: List of parent candidates to use as examples.
        :type parents: list[Heuristic]
        :return: The formatted prompt string.
        :rtype: str
        """
        parent = parents[0]
        if self.generation_mode == "whole":
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "simplify_solution",
                "problem_description": self.problem_description,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-S/whole")
            if tpl:
                return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Simplify the solution while preserving functionality.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "<how you simplify without changing behavior>",\n'
                '  "code": "<full, runnable Verilog as one JSON string>"\n'
                "}\n"
                "Rules: valid JSON only; escape newlines as \\n and quotes.\n"
                r'All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )
        else:
            with open(parent.code_file_path, "r") as f:
                parent_code = f.read()
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "simplify_via_patch",
                "problem_description": self.problem_description,
                "file_to_edit": parent.code_file_path,
                "original_file": parent_code,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-S/diff")
            if tpl:
                return safe_format(
                    tpl,
                    context_json=json.dumps(context_obj, indent=2),
                    file_to_edit=parent.code_file_path,
                    original_file=parent_code,
                )
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Edit the file to reduce complexity while preserving behavior.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "diff",\n'
                '  "thought": "<what you simplified and why>",\n'
                '  "code": {\n'
                '    "edits": [\n'
                f'      {{ "file": "{parent.code_file_path}", "hunks": [\n'
                '          { "search": "<exact original text>\\n", "replace": "<replacement text>\\n" }\n'
                "        ] }\n"
                "    ]\n"
                "  }\n"
                "}\n"
                "Rules: valid JSON only; exact SEARCH match; escape newlines as \\n.\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                r'- All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )


    def _create_prompt_M_E(self, parents: list[Heuristic]) -> str:  # Explore
        """
        Creates a prompt for the 'Explore' mutation strategy.
        This strategy is used to generate a completely new solution based on a previous one.
        :param parents: List of parent candidates to use as examples.
        :type parents: list[Heuristic]
        :return: The formatted prompt string.
        :rtype: str
        """
        parent = parents[0]
        if self.generation_mode == "whole":
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "explore_new_architecture",
                "problem_description": self.problem_description,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-E/whole")
            if tpl:
                return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Propose a novel architectural idea (different from the parent).\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "<your new idea>",\n'
                '  "code": "<full, runnable Verilog as one JSON string>"\n'
                "}\n"
                "Rules: valid JSON only; escape newlines as \\n.\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                r'- All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )
        else:
            with open(parent.code_file_path, "r") as f:
                parent_code = f.read()
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "explore_new_architecture_via_patch",
                "problem_description": self.problem_description,
                "file_to_edit": parent.code_file_path,
                "original_file": parent_code,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-E/diff")
            if tpl:
                return safe_format(
                    tpl,
                    context_json=json.dumps(context_obj, indent=2),
                    file_to_edit=parent.code_file_path,
                    original_file=parent_code,
                )
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Edit the file to implement a substantially different solution.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "diff",\n'
                '  "thought": "<describe the new direction>",\n'
                '  "code": {\n'
                '    "edits": [\n'
                f'      {{ "file": "{parent.code_file_path}", "hunks": [\n'
                '          { "search": "<exact original text>\\n", "replace": "<replacement text>\\n" }\n'
                "        ] }\n"
                "    ]\n"
                "  }\n"
                "}\n"
                "Rules: valid JSON only; exact SEARCH match; escape newlines as \\n.\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                r'- All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )

    def _create_prompt_M_R(self, parents: list[Heuristic]) -> str:  # Refactor
        """
        Creates a prompt for the 'Refactor' mutation strategy.
        This strategy is used to refactor a previous solution while maintaining its functionality.
        :param parents: List of parent candidates to use as examples.
        :type parents: list[Heuristic]
        :return: The formatted prompt string.
        :rtype: str
        """
        parent = parents[0]
        if self.generation_mode == "whole":
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "refactor_code_same_intent",
                "problem_description": self.problem_description,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-R/whole")
            if tpl:
                return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Refactor to a cleaner structure while preserving the core idea.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "<what you refactor and why>",\n'
                '  "code": "<full, runnable Verilog as one JSON string>"\n'
                "}\n"
                "Rules: valid JSON only; escape newlines as \\n.\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                r'- All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )
        else:
            with open(parent.code_file_path, "r") as f:
                parent_code = f.read()
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "refactor_via_patch_same_intent",
                "problem_description": self.problem_description,
                "file_to_edit": parent.code_file_path,
                "original_file": parent_code,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-R/diff")
            if tpl:
                return safe_format(
                    tpl,
                    context_json=json.dumps(context_obj, indent=2),
                    file_to_edit=parent.code_file_path,
                    original_file=parent_code,
                )
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Edit the file to refactor structure (same intent).\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "diff",\n'
                '  "thought": "<refactoring plan>",\n'
                '  "code": {\n'
                '    "edits": [\n'
                f'      {{ "file": "{parent.code_file_path}", "hunks": [\n'
                '          { "search": "<exact original text>\\n", "replace": "<replacement text>\\n" }\n'
                "        ] }\n"
                "    ]\n"
                "  }\n"
                "}\n"
                "Rules: valid JSON only; exact SEARCH match; escape newlines as \\n.\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                r'- All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )

    def _create_prompt_M_I(self, parents: list[Heuristic]) -> str:  # Improve
        """
        Creates a prompt for the 'Improve' mutation strategy.
        This strategy is used to improve a previous solution while maintaining its functionality.
        :param parents: List of parent candidates to use as examples.
        :type parents: list[Heuristic]
        :return: The formatted prompt string.
        :rtype: str
        """
        parent = parents[0]
        if self.generation_mode == "whole":
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "improve_solution",
                "problem_description": self.problem_description,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-I/whole")
            if tpl:
                return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Improve correctness (if failed) or PPA (if succeeded).\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "<improvement strategy>",\n'
                '  "code": "<full, runnable Verilog as one JSON string>"\n'
                "}\n"
                "Rules: valid JSON only; escape newlines as \\n.\n"
                r'All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )
        else:
            with open(parent.code_file_path, "r") as f:
                parent_code = f.read()
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "improve_via_patch",
                "problem_description": self.problem_description,
                "file_to_edit": parent.code_file_path,
                "original_file": parent_code,
                "parent": parent_obj,
            }
            tpl = self.prompts.read("evolve/M-I/diff")
            if tpl:
                return safe_format(
                    tpl,
                    context_json=json.dumps(context_obj, indent=2),
                    file_to_edit=parent.code_file_path,
                    original_file=parent_code,
                )
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Edit the file to fix issues and/or optimize PPA.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "diff",\n'
                '  "thought": "<what you improved and why>",\n'
                '  "code": {\n'
                '    "edits": [\n'
                f'      {{ "file": "{parent.code_file_path}", "hunks": [\n'
                '          { "search": "<exact original text>\\n", "replace": "<replacement text>\\n" }\n'
                "        ] }\n"
                "    ]\n"
                "  }\n"
                "}\n"
                "Rules: valid JSON only; exact SEARCH match; escape newlines as \\n.\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                r'- All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )

    def _create_prompt_C_F(self, parents: list[Heuristic]) -> str:  # Fusion
        """
        Creates a prompt for the 'Fusion' mutation strategy.
        This strategy is used to create a new solution by combining elements from multiple previous solutions.
        :param parents: List of parent candidates to use as examples.
        :type parents: list[Heuristic]
        :return: The formatted prompt string.
        :rtype: str
        """
        parent1 = parents[0]
        parent2 = parents[1]
        if self.generation_mode == "whole":
            p1_obj = json.loads(self._format_parent_for_prompt(parent1, 1))
            p2_obj = json.loads(self._format_parent_for_prompt(parent2, 2))
            context_obj = {
                "task": "fuse_two_successes",
                "problem_description": self.problem_description,
                "parents": [p1_obj, p2_obj],
            }
            tpl = self.prompts.read("evolve/C-F/whole")
            if tpl:
                return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Fuse the best ideas from both successful solutions into a superior one.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "<fusion strategy>",\n'
                '  "code": "<full, runnable Verilog as one JSON string>"\n'
                "}\n"
                "Rules: valid JSON only; escape newlines as \\n."
            )
        else:
            with open(parent1.code_file_path, "r") as f:
                parent1_code = f.read()
            with open(parent2.code_file_path, "r") as f:
                parent2_code = f.read()
            p1_obj = json.loads(self._format_parent_for_prompt(parent1, 1))
            p2_obj = json.loads(self._format_parent_for_prompt(parent2, 2))
            # update p1_obj/p2_obj 'code' to reflect exact on-disk content for precise diff context
            p1_obj["code"] = parent1_code
            p2_obj["code"] = parent2_code
            context_obj = {
                "task": "fuse_two_successes_via_patch",
                "problem_description": self.problem_description,
                "file_to_edit": parent1.code_file_path,  # edit Example 1 by default
                "original_file": parent1_code,
                "parents": [p1_obj, p2_obj],
            }
            tpl = self.prompts.read("evolve/C-F/diff")
            if tpl:
                return safe_format(
                    tpl,
                    context_json=json.dumps(context_obj, indent=2),
                    file_to_edit=parent1.code_file_path,
                    original_file=parent1_code,
                )
            # Fallback to built-in prompt if no template found
            return (
                "You are an expert Verilog design assistant.\n"
                "Edit Example 1 by fusing the best ideas from both examples.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "diff",\n'
                '  "thought": "<fusion rationale and changes>",\n'
                '  "code": {\n'
                '    "edits": [\n'
                f'      {{ "file": "{parent1.code_file_path}", "hunks": [\n'
                '          { "search": "<exact original text>\\n", "replace": "<replacement text>\\n" }\n'
                "        ] }\n"
                "    ]\n"
                "  }\n"
                "}\n"
                "Rules: valid JSON only; exact SEARCH match; escape newlines as \\n.\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                r'- All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.'
            )

    def _parse_diff_block(self, diff_text: str) -> Iterator[tuple[str, str, str]]:
        """
        Parses a diff text and yields tuples of (file_path, search_block, replace_block).

        :param diff_text: The diff text to parse.
        :return: An iterator of tuples, where each tuple contains the file path,
                the search block, and the replace block.
        :rtype: Iterator[tuple[str, str, str]]
        """
        lines = diff_text.splitlines(keepends=True)
        i = 0
        while i < len(lines):
            file_path = lines[i].strip()
            i += 1
            if i < len(lines) and lines[i].strip() == "```":
                i += 1

            # Find search block
            if i < len(lines) and lines[i].strip() == "<<<<<<< SEARCH":
                i += 1
                search_block = []
                while i < len(lines) and lines[i].strip() != "=======":
                    search_block.append(lines[i])
                    i += 1

                # Find replace block
                if i < len(lines) and lines[i].strip() == "=======":
                    i += 1
                    replace_block = []
                    while i < len(lines) and lines[i].strip() != ">>>>>>> REPLACE":
                        replace_block.append(lines[i])
                        i += 1

                    if i < len(lines) and lines[i].strip() == ">>>>>>> REPLACE":
                        i += 1
                        if i < len(lines) and lines[i].strip() == "```":
                            i += 1
                        yield file_path, "".join(search_block), "".join(replace_block)
                        continue
            i += 1

    def _do_replace(self, content: str, original: str, updated: str, filename: str | None = None) -> str | None:
        """
        Perform a SEARCH/REPLACE on `content`, allowing whitespace drift, '...' wildcards,
        and fuzzy matching (SequenceMatcher) as a last resort.

        :param content: The original content to modify.
        :type content: str
        :param original: The exact text to search for in the content.
        :type original: str
        :param updated: The text to replace the original with.
        :type updated: str
        :param filename: The filename optionally used to strip accidental filename wrappers.
        :type filenmae: str
        :return: The modified content with the original replaced by updated, or None if the replacement failed.
        :rtype: str | None
        """
        if content is None:
            return None

        # New-file or "append" case: empty SEARCH means "append REPLACE"
        if not original.strip():
            return (content or "") + updated

        # Be robust to accidental code fences / filename wrappers
        original = self._strip_quoted_wrapping(original, filename)
        updated  = self._strip_quoted_wrapping(updated, filename)

        # Exact unique match first (fast path)
        count = content.count(original)
        if count == 1:
            return content.replace(original, updated, 1)
        # If multiple identical occurrences exist, we'll try the fuzzy path to pick one.

        # Progressive strategies
        res = self._replace_most_similar_chunk(content, original, updated)
        return res

    # ----- _do_replace helpers start
    # Functions inspired by Aider's diff style.
    # Particularly https://github.com/Aider-AI/aider/blob/main/aider/coders/editblock_coder.py
    def _strip_quoted_wrapping(self, text: str, fname: str | None = None) -> str:
        """
        Remove simple wrappers like triple-backtick fences and an optional leading filename line.
        Kept intentionally conservative.
        """
        if not text:
            return text

        lines = text.splitlines()
        if not lines:
            return text

        # strip an initial filename line if it looks like "<name>" or "<name>:"
        if fname:
            base = os.path.basename(fname)
            head = lines[0].strip().strip("`").rstrip(":")
            if head == base or head == fname:
                lines = lines[1:] if len(lines) > 1 else []

        # strip triple backtick fences
        if len(lines) >= 2 and lines[0].strip().startswith("```") and lines[-1].strip().startswith("```"):
            lines = lines[1:-1]

        out = "\n".join(lines)
        if out and not out.endswith("\n"):
            out += "\n"
        return out


    def _prep_lines(self, s: str) -> tuple[str, list[str]]:
        if s and not s.endswith("\n"):
            s += "\n"
        return s, s.splitlines(keepends=True)


    def _perfect_replace(self, whole_lines: list[str], part_lines: list[str], replace_lines: list[str]) -> str | None:
        part_len = len(part_lines)
        if part_len == 0:
            return None
        part_tup = tuple(part_lines)
        for i in range(0, len(whole_lines) - part_len + 1):
            if tuple(whole_lines[i:i+part_len]) == part_tup:
                return "".join(whole_lines[:i] + replace_lines + whole_lines[i+part_len:])
        return None


    def _match_but_for_leading_whitespace(self, whole_lines: list[str], part_lines: list[str]) -> str | None:
        num = len(part_lines)
        if num == 0:
            return None

        # all non-whitespace equal?
        if not all(whole_lines[i].lstrip() == part_lines[i].lstrip() for i in range(num)):
            return None

        # uniform indent delta?
        indents = set(
            whole_lines[i][: len(whole_lines[i]) - len(part_lines[i])]
            for i in range(num) if whole_lines[i].strip()
        )
        if len(indents) != 1:
            return None
        return indents.pop()


    def _replace_missing_leading_ws(self, whole_lines: list[str], part_lines: list[str], replace_lines: list[str]) -> str | None:
        # compute the minimum left trim among non-empty lines (both SEARCH and REPLACE)
        leading = [len(p) - len(p.lstrip()) for p in part_lines if p.strip()] + \
                [len(p) - len(p.lstrip()) for p in replace_lines if p.strip()]
        if leading and min(leading) > 0:
            k = min(leading)
            part_lines    = [p[k:] if p.strip() else p for p in part_lines]
            replace_lines = [p[k:] if p.strip() else p for p in replace_lines]

        n = len(part_lines)
        for i in range(0, len(whole_lines) - n + 1):
            add = self._match_but_for_leading_whitespace(whole_lines[i:i+n], part_lines)
            if add is None:
                continue
            fixed_replace = [add + r if r.strip() else r for r in replace_lines]
            return "".join(whole_lines[:i] + fixed_replace + whole_lines[i+n:])
        return None


    def _try_dotdotdots(self, whole: str, part: str, replace: str) -> str | None:
        """
        Support '...' lines in SEARCH/REPLACE as wildcards between fixed chunks.
        """
        if not self.diff_allow_dots:
            return None

        dots_re = re.compile(r"(^\s*\.\.\.\n)", re.MULTILINE | re.DOTALL)

        part_pieces    = re.split(dots_re, part)
        replace_pieces = re.split(dots_re, replace)
        # same number of pieces and all wildcard separators identical?
        if len(part_pieces) != len(replace_pieces):
            return None
        if len(part_pieces) == 1:
            return None  # no dots at all

        if not all(part_pieces[i] == replace_pieces[i] for i in range(1, len(part_pieces), 2)):
            return None

        # keep only the literal chunks at even indices; wildcards at odd indices
        part_chunks    = [part_pieces[i] for i in range(0, len(part_pieces), 2)]
        replace_chunks = [replace_pieces[i] for i in range(0, len(replace_pieces), 2)]

        # now do an exact replace for each literal chunk (must be unique)
        w = whole
        for p, r in zip(part_chunks, replace_chunks):
            if not p and not r:
                continue
            if not p and r:
                if not w.endswith("\n"):
                    w += "\n"
                w += r
                continue
            # unique exact occurrence?
            c = w.count(p)
            if c != 1:
                return None
            w = w.replace(p, r, 1)
        return w


    def _replace_closest_edit_distance(
        self,
        whole_lines: list[str],
        part: str,
        part_lines: list[str],
        replace_lines: list[str],
    ) -> str | None:
        """
        Sliding-window fuzzy match: pick the chunk with the highest ratio to SEARCH.
        Window length varies +/- diff_length_scale around SEARCH length (in lines).
        """
        min_len = max(1, math.floor(len(part_lines) * (1.0 - self.diff_length_scale)))
        max_len = max(min_len, math.ceil(len(part_lines) * (1.0 + self.diff_length_scale)))

        best_ratio = 0.0
        best_i = -1
        best_j = -1

        for length in range(min_len, max_len + 1):
            for i in range(0, len(whole_lines) - length + 1):
                cand = "".join(whole_lines[i:i+length])
                ratio = SequenceMatcher(None, cand, part).ratio()
                if ratio > best_ratio:
                    best_ratio = ratio
                    best_i = i
                    best_j = i + length

        if best_ratio >= self.diff_similarity_threshold and best_i >= 0:
            return "".join(whole_lines[:best_i] + replace_lines + whole_lines[best_j:])
        return None


    def _perfect_or_ws(self, whole_lines: list[str], part_lines: list[str], replace_lines: list[str]) -> str | None:
        # exact
        res = self._perfect_replace(whole_lines, part_lines, replace_lines)
        if res:
            return res
        # flexible on leading whitespace
        return self._replace_missing_leading_ws(whole_lines, part_lines, replace_lines)


    def _replace_most_similar_chunk(self, whole: str, part: str, replace: str) -> str | None:
        """
        Best-effort replace:
        1) exact / leading-whitespace-tolerant
        2) tolerate leading blank line in SEARCH
        3) '...' wildcard chunks
        4) fuzzy sliding-window (SequenceMatcher)
        """
        whole, whole_lines     = self._prep_lines(whole)
        part, part_lines       = self._prep_lines(part)
        replace, replace_lines = self._prep_lines(replace)

        # 1) exact or whitespace-tolerant
        res = self._perfect_or_ws(whole_lines, part_lines, replace_lines)
        if res:
            return res

        # 2) drop spurious leading blank line in SEARCH
        if len(part_lines) > 2 and not part_lines[0].strip():
            res = self._perfect_or_ws(whole_lines, part_lines[1:], replace_lines)
            if res:
                return res

        # 3) '...' wildcards
        try:
            res = self._try_dotdotdots(whole, part, replace)
            if res:
                return res
        except Exception:
            # fall back to fuzzy
            pass

        # 4) fuzzy sliding-window
        res = self._replace_closest_edit_distance(whole_lines, part, part_lines, replace_lines)
        if res:
            return res

        return None
    # ----- _do_replace helpers end

    # Apply JSON-based edit hunks (code.edits[])
    def _apply_json_edits(
        self,
        original_content: str,
        edits_obj: dict[str, Any],
        target_file_path: str | None = None,
    ) -> str | None:
        """
        Apply JSON diff object of the form:
        {
        "edits": [
            {
            "file": "<path/to/file>",
            "hunks": [
                {"search": "<exact text>\\n", "replace": "<replacement>\\n"}
            ]
            },
            ...
        ]
        }

        If target_file_path is provided, prefer that file's edits. Otherwise:
        - if there is exactly one edit, use it;
        - else use the first edit block.

        :param original_content: The original content to modify.
        :type original_content: str
        :param edits_obj: The JSON diff object containing edits.
        :type edits_obj: dict[str, Any]
        :param target_file_path: Optional file path which tells the diff-applier which file's edits to use when the JSON contains edits for multiple files.
        :type target_file_path: str | None
        :return: The modified content after applying all edits, or None if any replacement failed.
        :rtype: str | None
        """
        edits = edits_obj.get("edits")
        if not isinstance(edits, list) or not edits:
            print("WARNING: JSON diff object missing or empty 'edits'.")
            return None

        chosen_edit = None
        if target_file_path:
            for e in edits:
                if isinstance(e, dict) and e.get("file") == target_file_path:
                    chosen_edit = e
                    break
        if chosen_edit is None:
            chosen_edit = edits[0]

        hunks = chosen_edit.get("hunks")
        if not isinstance(hunks, list) or not hunks:
            print("WARNING: JSON diff edit missing or empty 'hunks'.")
            return None

        new_content = original_content
        for h in hunks:
            if not isinstance(h, dict):
                print(f"WARNING: Malformed hunk: {h}")
                return None
            search = h.get("search", "")
            replace = h.get("replace", "")

            # Keep newline semantics consistent with legacy path
            if search and not search.endswith("\n"):
                search += "\n"
            if replace and not replace.endswith("\n"):
                replace += "\n"

            file_hint = chosen_edit.get("file") if isinstance(chosen_edit, dict) else None
            result = self._do_replace(new_content, search, replace, filename=file_hint or target_file_path)
            if result is None:
                return None
            new_content = result

        return new_content


    def _apply_diff(self, original_content: str, diff_text: str, target_file_path: str | None = None) -> str | None:
        """
        Applies a diff text with one or more SEARCH/REPLACE blocks to the original content.
        Applies either:
        - JSON diff (preferred): {"edits":[{"file":..., "hunks":[{"search":..., "replace":...}, ...]}, ...]}
        - Legacy fenced diff format with <<<<<<< SEARCH / ======= / >>>>>>> REPLACE

        If JSON contains multiple files, will prefer edits for target_file_path if provided.

        :param original_content: The original content to modify.
        :type original_content: str
        :param diff_text: The diff text containing one or more SEARCH/REPLACE blocks.
        :type diff_text: str
        :return: The modified content after applying all SEARCH/REPLACE blocks, or None if any replacement failed.
        :rtype: str | None
        """
        # First try JSON
        try:
            obj = json.loads(diff_text)
            if isinstance(obj, dict) and "edits" in obj:
                return self._apply_json_edits(original_content, obj, target_file_path)
        except Exception:
            pass  # Not JSON; fall through to legacy parser

        # --- Legacy fenced diff path (existing code below unchanged) ---
        new_content = original_content
        edits = list(self._parse_diff_block(diff_text))

        if not edits:
            print(
                "WARNING: Could not parse any valid diff blocks from the LLM response."
            )
            print(f"Original diff_text:\n{diff_text}\n")
            return None

        for file_path, search_block, replace_block in edits:
            # Strip trailing newlines added by LLM
            search_block = search_block.rstrip("\n")
            # The user's provided logic expects a newline, let's stick to simple replacement
            if not search_block.endswith("\n"):
                search_block += "\n"
            if not replace_block.endswith("\n"):
                replace_block += "\n"

            result = self._do_replace(new_content, search_block, replace_block, filename=file_path)
            if result is None:
                # Debug print diff_text if it fails
                # Print original diff_text for debugging
                print(
                    f"DEBUG: Original diff_text for failed replacement:\n{diff_text}\n"
                )
                return None  # Abort on first failed replacement
            new_content = result
        return new_content

    # Helpers (_get_fail_view, _get_success_view) to view pools depending on mode
    def _get_fail_view(self) -> list[Heuristic]:
        """Return the current 'failed' parents view based on population mode."""
        if self.population_pool_mode == "single":
            return [c for c in self.population if c.status != "success"]
        return self.fail_pool

    def _get_success_view(self) -> list[Heuristic]:
        """Return the current 'successful' parents view based on population mode."""
        if self.population_pool_mode == "single":
            return [c for c in self.population if c.status == "success"]
        return self.success_pool

    def _save_format_error_artifacts(self, code_file_path: str, fmt_meta: dict[str, Any]) -> None:
        """
        Persist raw model output + parse error for audit/metrics.
        For LLM format errors, this captures the original code and the error details.

        :param code_file_path: The path to the code file being processed.
        :type code_file_path: str
        :param fmt_meta: Metadata about the formatting process, including any errors.
        :type fmt_meta: dict[str, Any]

        """
        base = code_file_path.rsplit(".", 1)[0]
        meta_path = f"{base}_format_error.json"
        try:
            fmt_meta_out = {
                "timestamp_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
                **fmt_meta,
            }
            with open(meta_path, "w", encoding="utf-8") as f:
                json.dump(fmt_meta_out, f, indent=2)
        except Exception:
            pass

    def _save_diff_error_artifacts(
        self,
        code_file_path: str,
        diff_payload: str,
        parent_file: str | None = None,
        reason: str | None = None,
    ) -> None:
        """
        Persist the failed diff payload and context for auditing.

        :param code_file_path: The path to the code file being processed.
        :type code_file_path: str
        :param diff_payload: The diff payload that failed to apply.
        :type diff_payload: str
        :param parent_file: The parent file being modified, if any.
        :type parent_file: str | None
        :param reason: The reason for the failure.
        :type reason: str | None
        """
        base = code_file_path.rsplit(".", 1)[0]
        meta_path = f"{base}_diff_apply_error.json"
        try:
            meta = {
                "timestamp_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
                "parent_file": parent_file,
                "reason": reason or "apply_diff returned None",
                "diff": diff_payload,
            }
            with open(meta_path, "w", encoding="utf-8") as f:
                json.dump(meta, f, indent=2)
        except Exception:
            pass

    def initialize_population(self) -> None:
        """
        Creates and evaluates the initial population.

        This method generates the initial population of candidates using the LLM,
        evaluates them, and categorizes them into success and failure pools.
        It also logs the results of the initial generation.

        """
        print(f"\n--- Initializing Population (Size: {self.population_size}) ---")
        self.gen_start_time = time.time()
        # For initial population generation the strategy is always "initial".
        # This is the first generation, so we do not have any previous strategies to select from
        strategy_avg_selection_probabilities = {
            "initial": 1.0
        }  # Only the initial strategy is available
        results_with_meta = asyncio.run(
            self.llm.generate_n_responses(
                prompt=self.problem_description,
                n=self.population_size,
                temperature=self.default_llm_temp,
                top_p=self.default_llm_top_p,
                max_tokens=self.default_llm_max_tokens,
                generation_mode="whole", #self.generation_mode, # Always use "whole" mode for initial generation.
                system_prompt_override=self._get_generation_system_prompt("whole"),
            )
        )

        initial_candidates = []
        for i, (thought, code_content, meta) in enumerate(results_with_meta):
            # [FORMAT-ERROR] Decide status up front based on strict parse
            is_format_ok = meta.get("format_ok", False)

            # Choose something to save as "code" even if format is bad (for auditing)
            material_to_save = code_content or meta.get("raw", "") or ""

            code_path, _ = self._save_result_to_file(
                material_to_save, thought or "", 0, i + 1, "initial", None
            )

            cand = Heuristic(
                thought=thought or "",
                code=material_to_save,
                feedback=("" if is_format_ok else f"FORMAT_ERROR: {meta.get('error','unknown')}"),
                generation=0,
                strategy="initial",
                origin_pool="initial",
                status=("new" if is_format_ok else "failed_format"),  # [FORMAT-ERROR] NEW
            )
            cand.code_file_path = code_path
            cand.generated_mode = "whole"  # Initial Gen0 generations is always "whole"

            if not is_format_ok and self.require_strict_format:
                # Persist error artifacts; do NOT evaluate this candidate
                self._save_format_error_artifacts(code_path, meta)  # [FORMAT-ERROR] NEW

            initial_candidates.append(cand)
            
        print(f"Generated {len(initial_candidates)} initial candidates. Evaluating...")
        self._evaluate_candidates(initial_candidates)

        for cand in initial_candidates:
            if cand.status == "success":
                self.success_pool.append(cand)
            else:
                self.fail_pool.append(cand)

        # In single-pool mode, keep everyone together
        if self.population_pool_mode == "single":
            self.population = initial_candidates[:]

        gen0_runtime = time.time() - self.gen_start_time
        llm_stat_dict = asyncio.run(self.llm.get_and_reset_usage_stats())
        llm_calls = llm_stat_dict.get("api_calls", 0)
        llm_prompt_tokens = llm_stat_dict.get("prompt_tokens", 0)
        llm_completion_tokens = llm_stat_dict.get("completion_tokens", 0)
        llm_code_prompt_tokens = llm_stat_dict.get("code_prompt_tokens", 0)
        llm_code_completion_tokens = llm_stat_dict.get("code_completion_tokens", 0)
        llm_feedback_prompt_tokens = llm_stat_dict.get("feedback_prompt_tokens", 0)
        llm_feedback_completion_tokens = llm_stat_dict.get(
            "feedback_completion_tokens", 0
        )
        if self.logger:
            self.logger.log_generation(
                0,
                initial_candidates,
                gen0_runtime,
                llm_calls,
                llm_prompt_tokens,
                llm_completion_tokens,
                llm_code_prompt_tokens,
                llm_code_completion_tokens,
                llm_feedback_prompt_tokens,
                llm_feedback_completion_tokens,
                llm_stat_dict,
                defaultdict(float),
                defaultdict(float),
                self.fail_strategy_stats,
                self.success_strategy_stats,
                strategy_avg_selection_probabilities,  # For initial generation dict[str, float] is used as there is only one strategy available
            )  # No rewards for initial generation

        print(
            f"--- Initial Population Processed. Success: {len(self.success_pool)}, Fail: {len(self.fail_pool)} ---"
        )
        if self.success_pool:
            self.success_pool.sort(key=lambda c: c.score, reverse=True)
            print(f"Best initial candidate: {self.success_pool[0]}")

    def _run_selection_algorithm(
        self,
        method: StrategySelectionMethod,
        available_strategies: list[StrategyT],
        stats_dict: dict[StrategyT, dict[str, int | float]],
        selected_this_gen: set[StrategyT],
    ) -> tuple[StrategyT, dict[StrategyT, float]]:
        """
        Implements the core logic for the multi-armed bandit strategy selection algorithms.

        This is a generic helper function that operates on a specific, type-safe set of strategies
        (either for the 'fail' or 'success' pool) and their corresponding statistics. It is called
        by the `_select_strategy` dispatcher. This approach ensures type safety and avoids
        code duplication between the two pools.

        The method implements the following selection algorithms:
        - **random**: Selects a strategy with uniform random probability.
        - **epsilon-greedy**: Selects the current best-performing strategy (exploitation) with probability
          `1-epsilon`, and explores a random strategy with probability `epsilon`.
        - **ucb**: Uses the Upper Confidence Bound (UCB1) formula to balance exploration and exploitation.
          It ensures all strategies are tried at least once before applying the UCB formula. Selection is
          done via a softmax over the UCB scores to allow for probabilistic choice rather than a hard argmax.

        :param method: The selection algorithm to use ('random', 'epsilon-greedy', 'ucb').
        :type method: StrategySelectionMethod
        :param available_strategies: A list of the strategies available for selection in the current pool.
        :type available_strategies: list[StrategyT]
        :param stats_dict: A dictionary containing the performance statistics ('count' and 'value') for each strategy.
        :type stats_dict: dict[StrategyT, dict[str, int | float]]
        :param selected_this_gen: A set of strategies already chosen in the current generation's loop. This is
                                  crucial for the UCB algorithm's initialization phase to ensure each
                                  strategy is tried once.
        :type selected_this_gen: set[StrategyT]
        :type StrategyT: A TypeVar representing either EvolStrategyMethodFail or EvolStrategyMethodSuccess.

        :return: A tuple containing the selected strategy and a dictionary representing the ex-ante
                 probability distribution over all available strategies for this selection event.
                 This function assumes `available_strategies` is not empty and will not return None.
        :rtype: tuple[StrategyT, dict[StrategyT, float]]
        """
        if method == "random":
            dist = {s: 1.0 / len(available_strategies) for s in available_strategies}
            choice = random.choice(available_strategies)
            return choice, dist

        elif method == "epsilon-greedy":
            # Probability should be ex-ante, so we calculate it before making the selection
            # The top strategy or those that are tied should get 1 - self.epsilon probability in total,
            # and the rest should get self.epsilon / (number of non-top strategies) probability.
            n = len(available_strategies)
            # Identify best strategies (max value)
            max_score = max(stats_dict[s]["value"] for s in available_strategies)
            best_strategies = [
                s for s in available_strategies if stats_dict[s]["value"] == max_score
            ]
            k = len(best_strategies)

            # Build probability distribution
            dist: dict[StrategyT, float] = {}
            for s in available_strategies:
                base_prob = self.epsilon / n
                if s in best_strategies:
                    dist[s] = base_prob + (1 - self.epsilon) / k
                else:
                    dist[s] = base_prob

            # Select strategy based on epsilon-greedy logic
            if random.random() < self.epsilon:
                selected = random.choice(available_strategies)
            else:
                selected = (
                    random.choice(best_strategies)
                    if k > 0
                    else random.choice(available_strategies)
                )
            return selected, dist

        elif method == "ucb":
            # --- Initialization Phase ---
            # Identify all strategies that have not been selected yet.
            untried_strategies = [
                s
                for s in available_strategies
                if stats_dict[s]["count"] == 0 and s not in selected_this_gen
            ]
            # If there are untried strategies, randomly select one. This ensures that for the
            # first evolution, strategies are selected as evenly as possible, and each
            # strategy is guaranteed to be chosen once before moving to exploration.
            if untried_strategies:
                prob = 1.0 / len(untried_strategies)
                dist = {s: prob for s in untried_strategies}
                return random.choice(untried_strategies), dist

            # --- Exploration Phase (Standard UCB) ---
            # Once all strategies have been tried at least once, use the UCB formula.
            total_pulls = sum(stats_dict[s]["count"] for s in available_strategies)

            # If total_pulls is 0, it means no strategies have been selected yet.
            # Or haven't updated their stats yet. As stats update happens only after evaluation,
            # of generation and strategy selection happens before evaluation,
            # we can end up in this situation at the start of the run.
            # In this case, we cannot compute UCB scores since we have no data.
            # Also this causes issues with log(0) and division by zero in UCB formula.
            # So just select one randomly.
            if total_pulls == 0:
                prob = 1.0 / len(available_strategies)
                dist = {s: prob for s in available_strategies}
                return random.choice(available_strategies), dist

            ucb_scores: dict[StrategyT, float] = {}
            for strat in available_strategies:
                # If a strategy has 0 pulls, its exploration value is infinite.
                # This prevents a ZeroDivisionError and correctly prioritizes it.
                # Infinite seems to cause nan issues in softmax, so we set it to a very high value.
                # This is a common trick in UCB to handle untried arms.
                if stats_dict[strat]["count"] == 0:
                    ucb_scores[strat] = 1e3  # Large constant for untried arms
                    continue

                avg_reward = stats_dict[strat]["value"]
                exploration_term = self.ucb_c * math.sqrt(
                    math.log(total_pulls) / stats_dict[strat]["count"]
                )
                ucb_scores[strat] = avg_reward + exploration_term

            # Use softmax to choose a strategy based on UCB scores
            # This allows for a probabilistic selection based on the scores
            # We found that argmax can lead to premature convergence, so we use a softmax approach to encourage exploration
            # Use the max trick to avoid overflow in exponentiation
            # Compute softmax probabilities
            scores = [ucb_scores[s] for s in available_strategies]
            max_score = max(scores) if scores else 0.0
            exp_scores = [math.exp(score - max_score) for score in scores]
            sum_exp = sum(exp_scores)
            weights = (
                [s / sum_exp for s in exp_scores]
                if sum_exp > 0
                else [1.0 / len(scores)] * len(scores)
            )
            dist = dict(zip(available_strategies, weights))
            # Select strategy using softmax distribution
            selected = random.choices(available_strategies, weights=weights, k=1)[0]
            return selected, dist

        else:  # Fallback
            print(f"[WARNING] Unknown method '{method}'. Defaulting to random.")
            dist = {s: 1.0 / len(available_strategies) for s in available_strategies}
            return random.choice(available_strategies), dist

    @overload
    def _select_strategy(
        self,
        pool_type: Literal["fail"],
        available_strategies: list[EvolStrategyMethodFail],
        selected_this_gen: set[EvolStrategyMethodFail] | None = None,
    ) -> tuple[
        EvolStrategyMethodFail | None, dict[EvolStrategyMethodFail, float] | None
    ]: ...

    @overload
    def _select_strategy(
        self,
        pool_type: Literal["success"],
        available_strategies: list[EvolStrategyMethodSuccess],
        selected_this_gen: set[EvolStrategyMethodSuccess] | None = None,
    ) -> tuple[
        EvolStrategyMethodSuccess | None, dict[EvolStrategyMethodSuccess, float] | None
    ]: ...

    def _select_strategy(
        self,
        pool_type: Literal["fail", "success"],
        available_strategies: list[Any],
        selected_this_gen: set[Any] | None = None,
    ) -> tuple[Any | None, dict[Any, float] | None]:
        """
        Selects a strategy by dispatching to the core selection logic based on pool type.

        This method is an overloaded dispatcher. Based on the `pool_type` ('fail' or 'success'),
        it calls the generic `_run_selection_algorithm` with the correctly typed strategy lists
        and statistics dictionaries. This design ensures that operations within the selection
        logic are type-safe.

        It returns the selected strategy along with a dictionary representing the ex-ante
        probability distribution of all available strategies for that selection event.
        The probability is calculated *before* the selection is made, which is useful for
        analyzing the behavior of the selection algorithm.

        If no strategies are available for the given pool, it returns (None, None).

        :param pool_type: The pool to select a strategy for ('fail' or 'success').
        :type pool_type: Literal['fail', 'success']
        :param available_strategies: A list of strategies available for the specified pool.
        :type available_strategies: list[EvolStrategyMethodFail] | list[EvolStrategyMethodSuccess]
        :param selected_this_gen: A set of strategies already selected in the current generation. This is
                                  passed to the UCB algorithm to handle its initialization phase. Defaults to None.
        :type selected_this_gen: set[EvolStrategyMethodFail] | set[EvolStrategyMethodSuccess] | None

        :return: A tuple containing the selected strategy name and a dictionary of its selection probabilities.
                 Returns (None, None) if the `available_strategies` list is empty.
        :rtype: tuple[ EvolStrategyMethodFail | EvolStrategyMethodSuccess | None, dict[EvolStrategyMethodFail | EvolStrategyMethodSuccess, float] | None]
        """
        if not available_strategies:
            return None, None

        sel_gen = selected_this_gen if selected_this_gen is not None else set()

        if pool_type == "fail":
            return self._run_selection_algorithm(
                self.strategy_selection_method,
                available_strategies,
                self.fail_strategy_stats,
                sel_gen,
            )
        else:  # pool_type == "success"
            return self._run_selection_algorithm(
                self.strategy_selection_method,
                available_strategies,
                self.success_strategy_stats,
                sel_gen,
            )

    # Allow per-request system-prompt selection
    def _get_generation_system_prompt(self, mode: Literal["whole","diff"] | None = None) -> str | None:
        """
        Returns the system prompt for code generation during evolution.
        Subclasses can override this to provide a custom system prompt.
        By default, it loads the system prompt in the default directory of data/prompts/default/

        :param mode: Optional generation mode ('whole' or 'diff') to select a specific system prompt.
                        If None, uses the instance's current generation_mode.
        :type mode: Literal["whole","diff"] | None
        :return: The system prompt string, or None if not found.
        :rtype: str | None
        """
        use_mode = mode or self.generation_mode
        # First try profile-specific files (e.g., default/system/whole.txt)
        return self.prompts.read(f"system/{use_mode}")

    # A helper: call a prompt-builder under a temporary generation_mode
    def _with_mode(self, mode: Literal["whole", "diff"], fn, *args, **kwargs) -> str:
        """
        A helper function with calls a prompt-builder under a temporary generation_mode.
        Helps to tempoarily switch self.generation_mode just for prompt construction.
        This is used to override generation_mode settings for init/failed where it will always use whole.
        Where it doesn't make sense to use diff mode.

        :param mode: The generation mode to temporarily set ('whole' or 'diff').
        :type Literal["whole", "diff"]

        :rtype str
        """
        old_mode = self.generation_mode
        try:
            self.generation_mode = mode
            return fn(*args, **kwargs)
        finally:
            self.generation_mode = old_mode

    def evolve_one_generation(self):
        """Performs one generation of the REvolution algorithm."""
        self.current_generation += 1
        print(f"\n--- Starting Generation {self.current_generation} ---")
        self.gen_start_time = time.time()

        # Allows current default system prompt to be overriden if necessary
        generation_system_prompt = self._get_generation_system_prompt()

        strategies = {
            "M-F": {"func": self._create_prompt_M_F, "num_parents": 1},
            "M-S": {"func": self._create_prompt_M_S, "num_parents": 1},
            "M-E": {"func": self._create_prompt_M_E, "num_parents": 1},
            "M-R": {"func": self._create_prompt_M_R, "num_parents": 1},
            "M-I": {"func": self._create_prompt_M_I, "num_parents": 1},
            "C-F": {"func": self._create_prompt_C_F, "num_parents": 2},
        }
        # fail_strats, success_strats = ['M-F','M-S','M-E','M-R','M-I'], ['M-S','M-E','M-R','M-I','C-F']

        # Compute views from selected mode
        fail_view = self._get_fail_view()
        success_view = self._get_success_view()
        total_current_pop = len(fail_view) + len(success_view)
        if total_current_pop == 0:
            return "STOP"

        # (single-mode resource coupling: starve fails once we have successes)
        if self.population_pool_mode == "single" and len(success_view) > 0:
            raw_fail = round(self.num_offspring_lambda * len(fail_view) / total_current_pop)
            cap = math.floor(self.num_offspring_lambda * self.single_fail_allocation_cap)
            num_from_fail = max(1 if len(fail_view) > 0 else 0, min(raw_fail, cap))
        else: # dual-mode, no starvation, fail/success allocated proportionately
            num_from_fail = round(
                self.num_offspring_lambda * len(fail_view) / total_current_pop
            )
        num_from_success = self.num_offspring_lambda - num_from_fail

        if self.population_pool_mode == "single":
            print(f"[single] offspring allocation -> fail:{num_from_fail}, "
                f"success:{num_from_success} (cap={self.single_fail_allocation_cap:.2f})")

        llm_requests: list[LLMRequest] = []
        metadata: list[dict[str, Any]] = []

        success_strategy_average_probabilities = {s: 0.0 for s in self.success_strats}
        fail_strategy_average_probabilities = {s: 0.0 for s in self.fail_strats}

        fail_strategies_selected_this_gen = set()
        success_strategies_selected_this_gen = set()

        # Generate from "failed" parents (M-F, M-S/E/R/I)
        if fail_view:
            for _ in range(num_from_fail):
                strat_name, prob_dist_dict = self._select_strategy(
                    "fail", self.fail_strats, fail_strategies_selected_this_gen
                )
                if strat_name is None or prob_dist_dict is None:
                    print("No valid fail strategies available. Skipping...")
                    continue
                fail_strategies_selected_this_gen.add(strat_name)
                parents = random.choices(
                    fail_view, k=strategies[strat_name]["num_parents"]
                )

                # This snippet enforces "whole" mode for failed parents and allows inherited classes to override default system prompt
                req_mode = "whole" # Always override input config to use "whole" generation mode for failed candidates
                prompt_text = self._with_mode(req_mode, strategies[strat_name]["func"], parents) # Switches prompt_text based on req_mode
                request_system_prompt = self._get_generation_system_prompt(req_mode)
                if request_system_prompt:
                    llm_request = LLMRequest(
                        prompt=prompt_text,
                        generation_mode=req_mode,
                        system_prompt=request_system_prompt,
                    )
                else:
                    llm_request = LLMRequest(
                        prompt=prompt_text,
                        generation_mode=req_mode,
                    )

                llm_requests.append(llm_request)
                metadata.append(
                    {
                        "parents": parents,
                        "strategy": strat_name,
                        "pool": "fail",
                        "prob_dist": prob_dist_dict,
                        "resolved_mode": req_mode,
                    }
                )
                for k, v in prob_dist_dict.items():
                    fail_strategy_average_probabilities[k] += v
            if num_from_fail > 0:
                for k in fail_strategy_average_probabilities.keys():
                    fail_strategy_average_probabilities[k] /= num_from_fail

        # Generate from "successful" parents (M-S/E/R/I and C-F)
        if success_view:
            available_success_strategies = self.success_strats.copy()
            if len(success_view) < 2 and "C-F" in available_success_strategies:
                available_success_strategies.remove("C-F")
            for _ in range(num_from_success):
                strat_name, prob_dist_dict = self._select_strategy(
                    "success",
                    available_success_strategies,
                    success_strategies_selected_this_gen,
                )
                if strat_name is None or prob_dist_dict is None:
                    print("No valid success strategies available. Skipping...")
                    continue
                success_strategies_selected_this_gen.add(strat_name)

                # Weighted parent choice by score among successes
                base = min(p.score for p in success_view) if success_view else 0.0
                # (accentuate exploitation only in single mode)
                if self.population_pool_mode == "single":
                    weights = [
                        max(c.score - base + 0.1, 1e-6) ** self.single_success_weight_exp
                        for c in success_view
                    ]
                else: # dual-mode, no accentuation, with base weight 0.1, score linearly weighs parent selection probability
                    weights = [c.score - base + 0.1 for c in success_view]
                parents = random.choices(
                    success_view,
                    weights=weights,
                    k=strategies[strat_name]["num_parents"],
                )

                # Ensure different parents for C-F
                if (
                    strat_name == "C-F"
                    and len(parents) == 2
                    and parents[0].id == parents[1].id
                ):
                    alt_pool = [p for p in success_view if p.id != parents[0].id]
                    if alt_pool:
                        base_alt = min(p.score for p in alt_pool)
                        alt_weights = [c.score - base_alt + 0.1 for c in alt_pool]
                        parents[1] = random.choices(alt_pool, weights=alt_weights, k=1)[
                            0
                        ]

                # This snippet allows inherited classes to override default system prompt
                req_mode = self.generation_mode  # respect the engine's original/global setting if parent(s) isn't from fail_pool or is a success
                prompt_text = self._with_mode(req_mode, strategies[strat_name]["func"], parents) # Switches prompt_text based on req_mode
                request_system_prompt = self._get_generation_system_prompt(req_mode)
                if request_system_prompt:
                    llm_request = LLMRequest(
                        prompt=prompt_text,
                        generation_mode=req_mode,
                        system_prompt=request_system_prompt,
                    )
                else:
                    llm_request = LLMRequest(
                        prompt=prompt_text,
                        generation_mode=req_mode,
                    )

                llm_requests.append(llm_request)
                metadata.append(
                    {
                        "parents": parents,
                        "strategy": strat_name,
                        "pool": "success",
                        "prob_dist": prob_dist_dict,
                        "resolved_mode": req_mode,
                    }
                )
                for k, v in prob_dist_dict.items():
                    success_strategy_average_probabilities[k] += v
            if num_from_success > 0:
                for k in success_strategy_average_probabilities.keys():
                    success_strategy_average_probabilities[k] /= num_from_success

        # Form dictionary of strategy probabilities for logging
        strategy_avg_selection_probabilities = {
            "fail_pool": fail_strategy_average_probabilities,
            "success_pool": success_strategy_average_probabilities,
        }

        if not llm_requests:
            return "STOP"

        llm_results_with_meta = asyncio.run(
            self.llm.generate_batch_responses(
                llm_requests,
                self.default_llm_temp,
                self.default_llm_top_p,
                self.default_llm_max_tokens,
            )
        )

        new_offspring = []
        for i, (thought, code_content, meta) in enumerate(llm_results_with_meta):
            meta_rec = metadata[i]
            strategy = meta_rec["strategy"]
            is_format_ok = meta.get("format_ok", False)

            # When format fails, we still save the raw for auditing—skip diff application/execution
            if not is_format_ok and self.require_strict_format:
                code_path, _ = self._save_result_to_file(
                    (code_content or meta.get("raw", "") or ""),
                    thought or "",
                    self.current_generation,
                    i + 1,
                    strategy,
                    None,
                )
                self._save_format_error_artifacts(code_path, meta)  # [FORMAT-ERROR] NEW
                cand = Heuristic(
                    thought=thought or "",
                    code=(code_content or meta.get("raw", "") or ""),
                    feedback=f"FORMAT_ERROR: {meta.get('error','unknown')}",
                    generation=self.current_generation,
                    parent_ids=[p.id for p in meta_rec["parents"]],
                    strategy=strategy,
                    origin_pool=("fail_pool" if meta_rec["pool"] == "fail" else "success_pool"),
                    status="failed_format",  # [FORMAT-ERROR] NEW
                )
                cand.code_file_path = code_path
                new_offspring.append(cand)
                continue  # Skip diff/whole processing for bad format

            # When the format is good apply the necessary transformations
            final_code, diff_to_save = "", ""
            # Check if the offspring was generated using "whole" or "diff"
            # Decide using per-request resolved mode, not the global engine setting
            # As sometimes the global engine setting is sometimes overriden for initial generation or for failed parents.
            resolved_mode = meta_rec.get("resolved_mode", self.generation_mode)

            # If offspring was generated under "diff" mode then _apply_diff is needed
            if resolved_mode == "diff":
                diff_to_save = code_content
                original_code = ""
                with open(meta_rec["parents"][0].code_file_path, "r") as f:
                    original_code = f.read()
                # If original_code or diff_to_save is None then save it as "" empty string
                if original_code is None:
                    original_code = ""
                if diff_to_save is None:
                    diff_to_save = ""
                new_code = self._apply_diff(original_code, diff_to_save, target_file_path=meta_rec["parents"][0].code_file_path)
                if new_code:  # Diff application successful
                    final_code = new_code
                else:  # Diff application failed
                    print(f"WARNING: Diff application failed for candidate {i + 1} in generation {self.current_generation}. Applying fallback logic.")
                    # Save the original code with diff appended as a fallback
                    diff_fail_warning = "WARNING: Diff application failed. Using original code with diff appended."
                    final_code = (
                        original_code
                        + "\n"
                        + diff_fail_warning
                        + "\n"
                        + diff_to_save
                    )

                    code_path, _ = self._save_result_to_file(
                        final_code or "",
                        thought or "",
                        self.current_generation,
                        i + 1,
                        strategy,
                        diff_to_save,
                    )
                    self._save_diff_error_artifacts(
                        code_path,
                        diff_to_save,
                        parent_file=meta_rec["parents"][0].code_file_path,
                        reason="SEARCH/REPLACE did not match",
                    )
                    cand = Heuristic(
                        thought=thought or "",
                        code=original_code,
                        feedback="DIFF_APPLY_ERROR: could not apply LLM diff.",
                        generation=self.current_generation,
                        parent_ids=[p.id for p in meta_rec["parents"]],
                        strategy=strategy,
                        origin_pool=("fail_pool" if meta_rec["pool"] == "fail" else "success_pool"),
                        status="failed_diff",  # [DIFF-ERROR]
                    )
                    cand.code_file_path = code_path
                    cand.generated_mode = "diff"  # [DIFF-ERROR]
                    new_offspring.append(cand)
                    continue                     
            else:  # whole mode
                final_code = code_content

            # When the returned code satisfies output and diff formats
            code_path, _ = self._save_result_to_file(
                final_code or "", thought or "", self.current_generation, i + 1, strategy, diff_to_save
            )
            # pool_type
            if meta_rec["pool"] == "fail":
                candidate_origin_pool = "fail_pool"
            else:
                candidate_origin_pool = "success_pool"
            cand = Heuristic(
                thought=thought or "",
                code=final_code or "",
                feedback="",
                generation=self.current_generation,
                parent_ids=[p.id for p in meta_rec["parents"]],
                strategy=meta_rec["strategy"],
                origin_pool=candidate_origin_pool,
            )
            cand.code_file_path = code_path
            cand.generated_mode = resolved_mode
            new_offspring.append(cand)

        self._evaluate_candidates(new_offspring)

        # For different pools/population types track strategy rewards separately
        fail_rewards_this_gen = defaultdict(float)
        success_rewards_this_gen = defaultdict(float)

        # Reward calculation and strategy statistics/weight update
        for i, cand in enumerate(new_offspring):
            meta = metadata[i]
            strategy_name = meta["strategy"]
            parent_pool_type = meta["pool"]
            parent = meta["parents"][
                0
            ]  # For simplicity, use the first parent for comparison
            cand_parents = meta[
                "parents"
            ]  # Could either be a single parent or two parents for fusion
            reward = 0.0

            if parent_pool_type == "fail":
                # Reward is 1 if it moves from fail to success, 0 otherwise
                if parent.status != "success" and cand.status == "success":
                    reward = 1.0
            elif parent_pool_type == "success":
                # Reward is 1 if there is metric improvement, or 0 if none/worse
                # Also take the fact that there are sometimes there are two parents,
                # There has to be metric improvement over two parents in this case
                if len(cand_parents) == 1:
                    # Single parent case
                    if parent.status == "success" and cand.status == "success":
                        if cand.score > parent.score:
                            reward = 1.0
                elif len(cand_parents) == 2:
                    # Two parents case (fusion)
                    parent1, parent2 = cand_parents
                    if (
                        parent1.status == "success"
                        and parent2.status == "success"
                        and cand.status == "success"
                    ):
                        # Reward is the difference between the best child and the best parent
                        best_parent_score = max(parent1.score, parent2.score)
                        if cand.score > best_parent_score:
                            reward = 1.0

            cand.reward_from_parent = reward
            # Populate the correct reward dictionary based on the pool type
            if parent_pool_type == "fail":
                fail_rewards_this_gen[strategy_name] += reward
            else:
                success_rewards_this_gen[strategy_name] += reward

            # Update strategy stats
            # Use nonstationary bandit approach to update strategy statistics (Section 2.5 of Sutton and Barto book)
            # Q_(n+1) = Q_n + alpha * (R_n - Q_n)
            # where alpha = 1 / (n) is the learning rate,
            # 1 / (n) satisfies the stochastic approximation condition
            # sigma alpha_n = infinity, and sigma alpha_n^2 < infinity
            # R_n is the reward from the parent, and Q_n is the current value of the strategy
            if parent_pool_type == "fail":
                s = self.fail_strategy_stats[
                    cast(EvolStrategyMethodFail, strategy_name)
                ]
            else:  # parent_pool_type == "success"
                s = self.success_strategy_stats[
                    cast(EvolStrategyMethodSuccess, strategy_name)
                ]

            s["count"] += 1  # Increment the count of times this strategy was used
            s["value"] = s["value"] + (reward - s["value"]) / (s["count"])

        # Survivor Selection (Elitism)
        candidate_pool = self.success_pool + new_offspring
        # Shuffle the candidate pool to ensure diversity
        random.shuffle(candidate_pool)
        candidate_pool.sort(key=lambda c: c.score, reverse=True)

        # When selecting the next generation, we take the top N candidates based on score
        # However, also try to find the candidates that have the best power, area, and timing metrics
        next_gen_population = []
        added_ids = set()  # Ensure unique candidates in the next generation

        # 1. Filter for successful candidates that can be ranked by PPA
        successful_candidates = [
            c for c in candidate_pool if c.status == "success" and c.ppa_success
        ]

        if successful_candidates:
            # 2. Identify champions for each metric
            # These champions are always relevant
            best_by_score = max(successful_candidates, key=lambda c: c.score)
            champions = [best_by_score]

            # Dynamically select other champions based on the configuration
            for metric_config in self.champion_metrics_config:
                # Check if the condition for this champion is met
                condition = metric_config.get(
                    "condition", lambda engine, candidates: True
                )
                if not condition(self, successful_candidates):
                    continue

                metric_name = metric_config["name"]

                # Filter for candidates that actually have this metric
                candidates_with_metric = [
                    c for c in successful_candidates if metric_name in c.ppa_metrics
                ]
                if not candidates_with_metric:
                    continue

                goal = metric_config["goal"]
                champion = None
                if goal == "minimize":
                    champion = min(
                        candidates_with_metric, key=lambda c: c.ppa_metrics[metric_name]
                    )
                elif goal == "maximize":
                    champion = max(
                        candidates_with_metric, key=lambda c: c.ppa_metrics[metric_name]
                    )

                if champion:
                    champions.append(champion)

            # 3. Add unique champions to the next generation
            for champ in champions:
                if champ.id not in added_ids:
                    next_gen_population.append(champ)
                    added_ids.add(champ.id)

        # 4. Fill remaining spots with top-scoring candidates (elitism)
        candidate_pool.sort(key=lambda c: c.score, reverse=True)

        for cand in candidate_pool:
            if len(next_gen_population) >= self.population_size:
                break
            if cand.id not in added_ids:
                next_gen_population.append(cand)
                added_ids.add(cand.id)

        # Population Redivision
        self.fail_pool.clear()
        self.success_pool.clear()
        for cand in next_gen_population:
            if cand.status == "success":
                self.success_pool.append(cand)
            else:
                self.fail_pool.append(cand)

        # In single-pool mode, the authoritative pool is one list
        if self.population_pool_mode == "single":
            self.population = next_gen_population

        gen_runtime = time.time() - self.gen_start_time
        # get_and_reset_usage_stats is an async function, so we need to run it in the event loop
        # This will reset the API call count and usage stats for the next generation
        llm_stat_dict = asyncio.run(self.llm.get_and_reset_usage_stats())
        llm_calls = llm_stat_dict.get("api_calls", 0)
        llm_prompt_tokens = llm_stat_dict.get("prompt_tokens", 0)
        llm_completion_tokens = llm_stat_dict.get("completion_tokens", 0)
        llm_code_prompt_tokens = llm_stat_dict.get("code_prompt_tokens", 0)
        llm_code_completion_tokens = llm_stat_dict.get("code_completion_tokens", 0)
        llm_feedback_prompt_tokens = llm_stat_dict.get("feedback_prompt_tokens", 0)
        llm_feedback_completion_tokens = llm_stat_dict.get(
            "feedback_completion_tokens", 0
        )
        # Check that self.logger is not None before logging should have been initialized during initialization
        if self.logger:
            self.logger.log_generation(
                self.current_generation,
                new_offspring,
                gen_runtime,
                llm_calls,
                llm_prompt_tokens,
                llm_completion_tokens,
                llm_code_prompt_tokens,
                llm_code_completion_tokens,
                llm_feedback_prompt_tokens,
                llm_feedback_completion_tokens,
                llm_stat_dict,
                fail_rewards_this_gen,
                success_rewards_this_gen,
                self.fail_strategy_stats,
                self.success_strategy_stats,
                strategy_avg_selection_probabilities,
            )
        else:
            print(
                "WARNING: Logger is not initialized. Generation statistics will not be logged."
            )

        print(
            f"--- Gen {self.current_generation} Complete. Pools: Success({len(self.success_pool)}), Fail({len(self.fail_pool)}) ---"
        )
        if self.success_pool:
            print(f"Best candidate: {self.success_pool[0]}")
        return None

    def run(self):
        """Main entry point to run the evolutionary framework."""
        print(
            f"--- Starting REvolution Run: Problem '{self.benchmark_name}/{self.problem_name}' ---"
        )
        self.run_start_time = time.time()
        self.run_start_utc = datetime.datetime.now(datetime.timezone.utc)

        try:
            self._calculate_reference_ppa()
            self.logger = EoHLogger(
                self.problem_name,
                self.benchmark_name,
                self.llm.model_name,
                self.base_save_path,
                self.ref_ppa_metrics,
                self.generation_mode,
            )
            self.logger.meta_strategy_name = self.strategy_selection_method
            self.initialize_population()
        except Exception as e:
            print(f"Critical error during initialization: {e}")
            # Print the full call stack, showing exactly where the error occurred.
            print(f"An exception of type {type(e).__name__} occurred.")
            print("Detailed traceback:")
            traceback.print_exc()  # Used to print traces
            return f"{self.problem_name},initialization_failed"

        for _ in range(self.num_generations):
            if self.evolve_one_generation() == "STOP":
                break

        print("\n--- REvolution Run Finished ---")
        total_runtime = time.time() - self.run_start_time
        end_utc = datetime.datetime.now(datetime.timezone.utc)
        if self.logger:
            self.logger.finalize_summary(
                self.run_start_utc,
                end_utc,
                total_runtime,
                self.current_generation,
                self.success_pool,
            )

        if self.success_pool:
            best_solution = self.success_pool[0]
            print(f"Final Best Solution Found:\n{best_solution}")
            final_report = best_solution.ppa_metrics.get("report_path", "N/A")
            final_score = (
                best_solution.score if best_solution.score is not None else "N/A"
            )
            # # Debug print success pool
            # print(f"Success Pool: {[str(c) for c in self.success_pool]}")
            return f"{self.problem_name},success,{best_solution.code_file_path},{final_report},{final_score}"
        else:
            print("No functionally correct and synthesizable solution found.")
            return f"{self.problem_name},failed"


class SingleShotEngine(EoHEngine):
    """
    A simplified engine for performing n-shot evaluation without evolution.

    This class generates an initial population of a specified size (`num_samples`),
    evaluates all candidates through the full syntax, functionality, and PPA
    pipeline, and then reports the results. It is functionally equivalent to
    running the `EoHEngine` for zero generations (i.e., only the initialization step).

    This is useful for establishing baseline performance for a given LLM on a
    problem set without the influence of evolutionary feedback.

    :param benchmark_name: Name of the benchmark being solved.
    :type benchmark_name: str
    :param problem_name: Name of the specific problem being solved.
    :type problem_name: str
    :param llm_interface: The interface for communicating with LLMs.
    :type llm_interface: LLMInterface
    :param verilog_evaluator: The tool for Verilog simulation.
    :type verilog_evaluator: VerilogEvaluator
    :param synthesis_evaluator: The tool for synthesis and PPA evaluation.
    :type synthesis_evaluator: SynthesisEvaluator
    :param num_samples: The number of initial candidates to generate and evaluate (n-shot) (Default: 20).
    :type num_samples: int
    :param default_llm_temp: Default temperature for LLM sampling.
    :type default_llm_temp: float
    :param default_llm_top_p: Default top-p sampling parameter for LLM.
    :type default_llm_top_p: float
    :param default_llm_max_tokens: Default maximum tokens for LLM responses.
    :type default_llm_max_tokens: int
    :param base_save_path: Base directory for saving results.
    :type base_save_path: str
    """

    def __init__(
        self,
        benchmark_name: str,
        problem_name: str,
        llm_interface: LLMInterface,
        verilog_evaluator: VerilogEvaluator,
        synthesis_evaluator: SynthesisEvaluator,
        num_samples: int = 20,
        default_llm_temp: float = 1.0,
        default_llm_top_p: float = 0.95,
        default_llm_max_tokens: int = 2048,
        base_save_path: str | None = None,
        generation_mode: Literal["whole", "diff"] = "whole",
        prompt_profile: str = "default",
        prompt_root: str | None = None,
    ):
        # Initialize the parent EoHEngine with num_generations=0.
        # This makes the single-shot engine a special case of the evolutionary engine.
        super().__init__(
            benchmark_name=benchmark_name,
            problem_name=problem_name,
            llm_interface=llm_interface,
            verilog_evaluator=verilog_evaluator,
            synthesis_evaluator=synthesis_evaluator,
            population_size=num_samples,  # Use num_samples as the population size
            num_generations=0,  # Key difference: no evolution
            default_llm_temp=default_llm_temp,
            default_llm_top_p=default_llm_top_p,
            default_llm_max_tokens=default_llm_max_tokens,
            base_save_path=base_save_path,
            # Evolutionary parameters are not used but required by parent __init__
            strategy_selection_method="random",
            epsilon=0.1,
            ucb_c=2.0,
            generation_mode=generation_mode,
            prompt_profile=prompt_profile,
            prompt_root=prompt_root,
        )

    def _evaluate_candidates(self, candidates_to_evaluate: list[Heuristic]) -> None:
        """
        Evaluates candidates for the single-shot run.

        This overridden method performs syntax, functional, and synthesis
        evaluations but **skips the expensive LLM feedback generation step**,
        as it is not needed for baseline n-shot analysis.

        :param candidates_to_evaluate: List of Heuristic candidates to evaluate.
        :type candidates_to_evaluate: list[Heuristic]

        :return: None
        :rtype: None
        """
        if not candidates_to_evaluate:
            return

        print(
            f"\n--- Evaluating {len(candidates_to_evaluate)} New Candidates (No Feedback) ---"
        )
        test_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_test.sv")
        ref_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_ref.sv")

        func_passed = []

        # Stage 1: Functional Simulation
        for cand in candidates_to_evaluate:
            # Stage 1-1: Check for formatting errors
            if getattr(cand, "status", None) in ("failed_format", "failed_diff"):
                cand.score = -float("inf")
                continue
            sim_results = self.evaluator.evaluate(
                cand.code_file_path, test_sv_file, ref_sv_file
            )

            if sim_results["status"] == "compilation_error":
                cand.status = "failed_syntax"
            else:
                is_success = False
                if sim_results["status"] == "success":
                    output = sim_results.get("simulation_stdout", "")
                    m_match = re.search(r"^Mismatches: (\d+)", output, re.M)
                    if (
                        m_match and int(m_match.group(1)) == 0
                    ) or "===========Your Design Passed===========" in output:
                        is_success = True

                if is_success:
                    func_passed.append(cand)
                    continue
                else:
                    cand.status = "failed_functionality"

            # If we reach here, the candidate has failed. Set score and continue.
            cand.score = -float("inf")

        # Stage 2: Synthesis and PPA for functionally correct candidates
        for cand in func_passed:
            report_base_path = cand.code_file_path.rsplit(".", 1)[0]
            output_dir = os.path.dirname(cand.code_file_path)

            # Get top module name for synthesis
            top_module_name_file = os.path.join(
                self.benchmark_path, "synthesis_top_module_names.json"
            )
            if not os.path.exists(top_module_name_file):
                top_module_name = "TopModule"
            else:
                with open(top_module_name_file, "r") as f:
                    top_module_names = json.load(f)
                top_module_name = top_module_names.get(self.problem_name, "TopModule")

            synth_results = self.synthesis_evaluator.evaluate(
                cand.code_file_path,
                self.problem_name,
                top_module_name,
                output_dir,
                report_base_path,
                self.evaluator,
                test_sv_file,
                ref_sv_file,
            )

            if (
                synth_results["synthesis_success"]
                and synth_results["synthesis_functionality_success"]
                and synth_results["ppa_success"]
            ):
                cand.status = "success"
                cand.synthesis_success = True
                cand.synthesis_functionality = True
                cand.ppa_success = True
                cand.ppa_metrics = synth_results["ppa_metrics"]
                cand.score = self._calculate_fitness_score(cand)
            else:
                cand.score = -float("inf")
                cand.synthesis_success = synth_results["synthesis_success"]
                cand.synthesis_functionality = synth_results[
                    "synthesis_functionality_success"
                ]
                if not synth_results["synthesis_success"]:
                    cand.status = "failed_synthesis"
                elif not synth_results["synthesis_functionality_success"]:
                    cand.status = "failed_synthesis_functionality"
                else:
                    cand.status = "failed_synthesis"

        # <<< Stage 3 (LLM Feedback Generation) is intentionally omitted. >>>

    def run(self) -> str:
        """
        Main entry point to run the single-shot evaluation.

        This method orchestrates the process:
        1. Sets up the run environment and logger.
        2. Calculates reference PPA metrics.
        3. Initializes the population by generating `num_samples` candidates.
        4. Evaluates all candidates.
        5. Finalizes logging and reports the best-performing candidate.

        :return: A string summarizing the outcome of the run.
        :rtype: str
        """
        print(
            f"--- Starting Single-Shot Run (n={self.population_size}): Problem '{self.benchmark_name}/{self.problem_name}' ---"
        )
        self.run_start_time = time.time()
        self.run_start_utc = datetime.datetime.now(datetime.timezone.utc)

        try:
            self._calculate_reference_ppa()
            self.logger = EoHLogger(
                self.problem_name,
                self.benchmark_name,
                self.llm.model_name,
                self.base_save_path,
                self.ref_ppa_metrics,
            )
            self.logger.meta_strategy_name = (
                "n-shot"  # Indicate this is not an evolutionary run
            )
            self.initialize_population()  # This generates, evaluates, and logs Gen 0
        except Exception as e:
            print(f"Critical error during single-shot run: {e}")
            traceback.print_exc()
            return f"{self.problem_name},single_shot_failed"

        # The evolutionary loop from EoHEngine.run() is intentionally omitted.

        print("\n--- Single-Shot Run Finished ---")
        total_runtime = time.time() - self.run_start_time
        end_utc = datetime.datetime.now(datetime.timezone.utc)

        if self.logger:
            # Finalize the summary after the single generation (Gen 0)
            self.logger.finalize_summary(
                self.run_start_utc,
                end_utc,
                total_runtime,
                self.current_generation,  # Will be 0
                self.success_pool,
            )

        if self.success_pool:
            # The success_pool is sorted by score within initialize_population.
            best_solution = self.success_pool[0]
            print(f"Final Best Solution Found:\n{best_solution}")
            final_report = best_solution.ppa_metrics.get("report_path", "N/A")
            final_score = (
                best_solution.score if best_solution.score is not None else "N/A"
            )
            return f"{self.problem_name},success,{best_solution.code_file_path},{final_report},{final_score}"
        else:
            print("No functionally correct and synthesizable solution found.")
            return f"{self.problem_name},failed"

# >>> CVDP INTEGRATION: New subclass for CVDP problems
# Prototype, with limited functionality
# Works only for non-agentic, no-commercial problems
# Currently aimed at non-agentic, no-commercial cid002, cid003 category problems.
# Does not support PPA metrics only functionality
# Plan on adding PPA metric support through Yosys + OpenROAD
# Expanding to more benchmarks
class _NoOpVerilogEvaluator:
    """Placeholder evaluator used by latency-only mode."""

    def evaluate(self, *args: Any, **kwargs: Any) -> dict[str, Any]:
        raise RuntimeError("Verilog evaluation not available in Gen0 latency mode.")


class _NoOpSynthesisEvaluator:
    """Placeholder synthesis evaluator used by latency-only mode."""

    clk_period: float = 0.0

    def evaluate(self, *args: Any, **kwargs: Any) -> dict[str, Any]:
        raise RuntimeError("Synthesis not available in Gen0 latency mode.")


class Gen0LatencyEngine(EoHEngine):
    """
    Generate Gen0 candidates, score via LLM feedback, and return the top option.
    Implements a minimal evolutionary engine that only performs the initial
    candidate generation and LLM feedback scoring steps, without any evolution.
    Used for BatchPick or gen0 mode runs where latency is critical.
    """

    def __init__(
        self,
        benchmark_name: str,
        problem_name: str,
        llm_interface: LLMInterface,
        verilog_evaluator: VerilogEvaluator | None,
        synthesis_evaluator: SynthesisEvaluator | None,
        population_size: int = 10,
        base_save_path: str | None = None,
        default_llm_temp: float = 1.0,
        default_llm_top_p: float = 0.95,
        default_llm_max_tokens: int = 2048,
        require_strict_format: bool = True,
        prompt_profile: str = "default",
        prompt_root: str | None = None,
        candidate_workers: int | None = None,
        custom_prompt_path: str | None = None,
        custom_prompt_encoding: str = "utf-8",
        evaluate_best_candidate: bool = False,
    ) -> None:
        self._custom_prompt_path: str | None = (
            os.path.abspath(custom_prompt_path) if custom_prompt_path else None
        )
        self._custom_prompt_encoding: str = custom_prompt_encoding
        self._custom_prompt_text_cache: str | None = None
        self.custom_prompt_mode: bool = self._custom_prompt_path is not None
        stub_eval = verilog_evaluator or _NoOpVerilogEvaluator()
        stub_synth = synthesis_evaluator or _NoOpSynthesisEvaluator()
        super().__init__(
            benchmark_name=benchmark_name,
            problem_name=problem_name,
            llm_interface=llm_interface,
            verilog_evaluator=stub_eval,  # type: ignore[arg-type]
            synthesis_evaluator=stub_synth,  # type: ignore[arg-type]
            population_size=population_size,
            num_generations=0,
            base_save_path=base_save_path,
            default_llm_temp=default_llm_temp,
            default_llm_top_p=default_llm_top_p,
            default_llm_max_tokens=default_llm_max_tokens,
            strategy_selection_method="random",
            epsilon=0.0,
            ucb_c=0.0,
            generation_mode="whole",
            population_pool_mode="single",
            require_strict_format=require_strict_format,
            prompt_profile=prompt_profile,
            prompt_root=prompt_root,
            candidate_workers=candidate_workers,
        )
        self.population_size = population_size
        self.best_candidate: Heuristic | None = None
        self.best_candidate_dir: str | None = None
        self.best_candidate_snapshot_dir: str | None = None
        self.best_candidate_metadata_path: str | None = None
        self.enable_full_evaluation: bool = (
            evaluate_best_candidate and not self.custom_prompt_mode
        )
        if evaluate_best_candidate and self.custom_prompt_mode:
            print(
                "Gen0/BatchPick custom prompt mode detected; --gen0_evaluate_best is ignored because no benchmark artefacts exist."
            )
        self._provided_verilog_evaluator = verilog_evaluator
        self._provided_synthesis_evaluator = synthesis_evaluator

    def run(self) -> str:
        print(
            f"--- Starting Gen0/BatchPick Latency Run: Problem '{self.benchmark_name}/{self.problem_name}' ---"
        )
        self.run_start_time = time.time()
        self.run_start_utc = datetime.datetime.now(datetime.timezone.utc)

        try:
            candidates = self._generate_gen0_candidates()
            scored_candidates = self._score_candidates_via_feedback(candidates)
        except Exception as exc:
            print(f"Gen0/BatchPick latency run failed: {exc}")
            traceback.print_exc()
            return f"{self.problem_name},gen0_failed"

        if scored_candidates:
            self.best_candidate = scored_candidates[0]
            self.best_candidate_dir = os.path.dirname(
                self.best_candidate.code_file_path
            )
            candidate_dirname = (
                os.path.basename(self.best_candidate_dir)
                if self.best_candidate_dir
                else "unknown"
            )
            print(
                f"Selected best candidate {self.best_candidate.id} ({candidate_dirname}) with feedback score {self.best_candidate.score:.2f}"
            )
            snapshot_dir = None
            if self.best_candidate_dir:
                snapshot_dir = self._snapshot_best_candidate(self.best_candidate_dir)
                self.best_candidate_snapshot_dir = snapshot_dir
                if snapshot_dir:
                    print(
                        f"Copied best candidate artefacts to '{snapshot_dir}' for quick access."
                    )
            evaluation_root = snapshot_dir or self.best_candidate_dir
            if self.enable_full_evaluation and evaluation_root:
                self._evaluate_best_candidate(evaluation_root)
            return (
                f"{self.problem_name},gen0_success,{self.best_candidate.code_file_path},{self.best_candidate.score}"
            )

        print("No viable candidates scored during Gen0 latency run.")
        return f"{self.problem_name},gen0_failed"

    def _snapshot_best_candidate(self, candidate_dir: str) -> str | None:
        """
        Copy the best candidate's artefacts into a dedicated quick-reference directory.

        :param candidate_dir: The source directory containing the candidate artefacts.
        :return: The destination directory path, or None if the copy failed.
        """
        if not os.path.isdir(candidate_dir):
            print(
                f"Unable to snapshot best candidate: source directory '{candidate_dir}' is missing."
            )
            return None

        model_name_cleaned = self.llm.model_name.replace("/", "_")
        gen0_root = os.path.join(
            self.base_save_path,
            model_name_cleaned,
            self.benchmark_name,
            self.problem_name,
            "Gen0",
        )
        snapshot_dir = os.path.join(gen0_root, "best_candidate")
        os.makedirs(snapshot_dir, exist_ok=True)

        try:
            shutil.copytree(
                candidate_dir,
                snapshot_dir,
                dirs_exist_ok=True,
            )
            metadata_path = os.path.join(snapshot_dir, "best_candidate_metadata.json")
            payload = {
                "candidate_directory": candidate_dir,
                "candidate_id": getattr(self.best_candidate, "id", None),
                "score": getattr(self.best_candidate, "score", None),
                "copied_at": datetime.datetime.now(datetime.timezone.utc).isoformat(),
            }
            with open(metadata_path, "w", encoding="utf-8") as meta_file:
                json.dump(payload, meta_file, indent=2)
            self.best_candidate_metadata_path = metadata_path
        except Exception as exc:  # pragma: no cover - filesystem errors are rare
            print(f"Failed to copy best candidate artefacts: {exc}")
            traceback.print_exc()
            return None

        return snapshot_dir

    def _update_best_candidate_metadata(
        self, artefact_dir: str, updates: dict[str, Any]
    ) -> None:
        """Merge additional information into the best-candidate metadata file."""
        metadata_path = self.best_candidate_metadata_path
        if not metadata_path or not metadata_path.startswith(artefact_dir):
            metadata_path = os.path.join(
                artefact_dir, "best_candidate_metadata.json"
            )

        existing: dict[str, Any] = {}
        if os.path.exists(metadata_path):
            try:
                with open(metadata_path, "r", encoding="utf-8") as meta_file:
                    existing = json.load(meta_file)
            except json.JSONDecodeError:  # pragma: no cover - corrupted file rare
                existing = {}

        # Ensure candidate basics remain available even if created outside snapshot helper.
        if "candidate_id" not in existing and self.best_candidate:
            existing["candidate_id"] = self.best_candidate.id
        if "candidate_directory" not in existing and self.best_candidate_dir:
            existing["candidate_directory"] = self.best_candidate_dir

        existing.update(updates)

        with open(metadata_path, "w", encoding="utf-8") as meta_file:
            json.dump(existing, meta_file, indent=2)
        self.best_candidate_metadata_path = metadata_path

    def _evaluate_best_candidate(self, artefact_dir: str) -> None:
        """Optionally run full evaluation on the selected best candidate."""
        if not self.enable_full_evaluation or not self.best_candidate:
            return

        verilog_eval = self._provided_verilog_evaluator
        synth_eval = self._provided_synthesis_evaluator
        if verilog_eval is None or synth_eval is None:
            message = (
                "Skipping Gen0 optional evaluation because evaluators were not provided."
            )
            print(message)
            self._update_best_candidate_metadata(
                artefact_dir,
                {
                    "evaluation": {
                        "status": "skipped_no_evaluator",
                        "reason": message,
                        "timestamp": datetime.datetime.now(
                            datetime.timezone.utc
                        ).isoformat(),
                    }
                },
            )
            return

        code_path = os.path.join(artefact_dir, "code.sv")
        if not os.path.exists(code_path):
            message = (
                f"Skipping Gen0 optional evaluation; missing code artefact at '{code_path}'."
            )
            print(message)
            self._update_best_candidate_metadata(
                artefact_dir,
                {
                    "evaluation": {
                        "status": "skipped_missing_code",
                        "reason": message,
                        "timestamp": datetime.datetime.now(
                            datetime.timezone.utc
                        ).isoformat(),
                    }
                },
            )
            return

        test_sv = os.path.join(self.benchmark_path, f"{self.problem_name}_test.sv")
        if not os.path.exists(test_sv):
            message = (
                f"No matching testbench found at '{test_sv}'. "
                "Gen0 optional evaluation will be skipped."
            )
            print(message)
            self._update_best_candidate_metadata(
                artefact_dir,
                {
                    "evaluation": {
                        "status": "skipped_missing_testbench",
                        "reason": message,
                        "timestamp": datetime.datetime.now(
                            datetime.timezone.utc
                        ).isoformat(),
                    }
                },
            )
            return

        ref_sv = os.path.join(self.benchmark_path, f"{self.problem_name}_ref.sv")
        if not os.path.exists(ref_sv):
            ref_sv = None

        evaluation_timestamp = datetime.datetime.now(datetime.timezone.utc).isoformat()
        simulation_summary: dict[str, Any] = {"status": "not_run"}
        synthesis_summary: dict[str, Any] = {}
        final_status = "pending"

        try:
            sim_results = verilog_eval.evaluate(
                code_path,
                test_sv,
                ref_sv,
                output_directory=artefact_dir,
            )

            # Parse stdout to confirm success even if exit code is 0
            if sim_results.get("status") == "success":
                output = sim_results.get("simulation_stdout", "")
                
                # Check 1: VerilogEval style "Mismatches: 0"
                m_match = re.search(r"^Mismatches: (\d+)", output, re.M)
                
                # Check 2: RTLLM style "Your Design Passed"
                is_functional_success = False
                if (m_match and int(m_match.group(1)) == 0) or \
                   "===========Your Design Passed===========" in output:
                    is_functional_success = True
                
                if not is_functional_success:
                    # Explicitly override status so the check below catches it
                    sim_results["status"] = "functional_failure"

            simulation_summary = {
                "status": sim_results.get("status"),
                "log_file": sim_results.get("log_file_path"),
                "compiled_file": sim_results.get("compiled_file_path"),
                "compilation_stderr": sim_results.get("compilation_stderr"),
                "simulation_stderr": sim_results.get("simulation_stderr"),
            }
        except Exception as exc:  # pragma: no cover - subprocess errors mocked in tests
            final_status = "simulation_exception"
            message = f"Gen0 optional evaluation failed during simulation: {exc}"
            print(message)
            self.best_candidate.status = "failed_functionality"
            self._update_best_candidate_metadata(
                artefact_dir,
                {
                    "evaluation": {
                        "status": final_status,
                        "reason": message,
                        "timestamp": evaluation_timestamp,
                        "simulation": simulation_summary,
                    }
                },
            )
            return

        if simulation_summary["status"] != "success":
            final_status = "simulation_failed"
            self.best_candidate.status = "failed_functionality"
            print(
                f"Gen0 optional evaluation halted: simulation returned status '{simulation_summary['status']}'."
            )
            self._update_best_candidate_metadata(
                artefact_dir,
                {
                    "evaluation": {
                        "status": final_status,
                        "timestamp": evaluation_timestamp,
                        "simulation": simulation_summary,
                    }
                },
            )
            return

        top_module_name = self._resolve_top_module_name()
        report_base_path = os.path.join(artefact_dir, "best_candidate")
        ppa_metrics: dict[str, Any] | None = None
        try:
            synth_results = synth_eval.evaluate(
                code_path,
                self.problem_name,
                top_module_name,
                artefact_dir,
                report_base_path,
                verilog_eval,
                test_sv,
                ref_sv,
            )
            synthesis_summary = {
                "synthesis_success": synth_results.get("synthesis_success"),
                "synthesis_functionality_success": synth_results.get(
                    "synthesis_functionality_success"
                ),
                "ppa_success": synth_results.get("ppa_success"),
                "synthesis_log": synth_results.get("synthesis_log"),
            }
            ppa_metrics = synth_results.get("ppa_metrics")
        except Exception as exc:  # pragma: no cover - subprocess errors mocked in tests
            final_status = "synthesis_exception"
            message = f"Gen0 optional evaluation failed during synthesis/PPA: {exc}"
            print(message)
            self._update_best_candidate_metadata(
                artefact_dir,
                {
                    "evaluation": {
                        "status": final_status,
                        "reason": message,
                        "timestamp": evaluation_timestamp,
                        "simulation": simulation_summary,
                        "synthesis": synthesis_summary,
                    }
                },
            )
            return

        all_success = (
            synthesis_summary.get("synthesis_success")
            and synthesis_summary.get("synthesis_functionality_success")
            and synthesis_summary.get("ppa_success")
        )

        if all_success:
            final_status = "completed"
            print("Gen0 optional evaluation completed successfully.")
            if isinstance(ppa_metrics, dict):
                self.best_candidate.ppa_metrics = ppa_metrics
                self.best_candidate.ppa_success = True
                self.best_candidate.synthesis_success = True
                self.best_candidate.synthesis_functionality = True
                self.best_candidate.status = "success"
        else:
            final_status = "synthesis_failed"
            print("Gen0 optional evaluation finished with synthesis/PPA failures.")
            self.best_candidate.synthesis_success = bool(
                synthesis_summary.get("synthesis_success")
            )
            self.best_candidate.synthesis_functionality = bool(
                synthesis_summary.get("synthesis_functionality_success")
            )
            self.best_candidate.ppa_success = bool(
                synthesis_summary.get("ppa_success")
            )
            if not synthesis_summary.get("synthesis_success"):
                self.best_candidate.status = "failed_synthesis"
            elif not synthesis_summary.get("synthesis_functionality_success"):
                self.best_candidate.status = "failed_synthesis_functionality"
            else:
                self.best_candidate.status = "failed_synthesis"

        self._update_best_candidate_metadata(
            artefact_dir,
            {
                "evaluation": {
                    "status": final_status,
                    "timestamp": evaluation_timestamp,
                    "simulation": simulation_summary,
                    "synthesis": synthesis_summary,
                    "ppa_metrics": ppa_metrics if all_success else None,
                    "testbench": test_sv,
                    "reference": ref_sv,
                }
            },
        )

    def _generate_gen0_candidates(self) -> list[Heuristic]:
        print(f"\n--- Generating Gen0/BatchPick Candidates (Size: {self.population_size}) ---")
        self.gen_start_time = time.time()

        # Load system prompt via PromptStore (inherited from EoHEngine)
        # Defaults to 'system/whole' if no profile override
        gen_system_prompt = self._get_generation_system_prompt("whole")

        # Debug logging for prompt mechanism
        print(f"[Gen0/BatchPick] Using generation system prompt: {bool(gen_system_prompt)}")
        if gen_system_prompt:
             print(f"[Gen0/BatchPick] Prompt source: {self.prompts._abs_path_for('system/whole')}")
        
        results_with_meta = asyncio.run(
            self.llm.generate_n_responses(
                prompt=self.problem_description,
                n=self.population_size,
                temperature=self.default_llm_temp,
                top_p=self.default_llm_top_p,
                max_tokens=self.default_llm_max_tokens,
                generation_mode="whole",
                system_prompt_override=gen_system_prompt,
            )
        )

        candidates: list[Heuristic] = []
        for i, (thought, code_content, meta) in enumerate(results_with_meta):
            is_format_ok = bool(meta.get("format_ok", False))
            material_to_save = code_content or meta.get("raw", "") or ""
            code_path, _ = self._save_result_to_file(
                material_to_save,
                thought or "",
                0,
                i + 1,
                "initial",
                None,
            )
            cand = Heuristic(
                thought=thought or "",
                code=material_to_save,
                feedback="" if is_format_ok else f"FORMAT_ERROR: {meta.get('error', 'unknown')}",
                generation=0,
                strategy="initial",
                origin_pool="initial",
                status="new" if is_format_ok else "failed_format",
            )
            cand.code_file_path = code_path
            cand.generated_mode = "whole"
            if not is_format_ok and self.require_strict_format:
                self._save_format_error_artifacts(code_path, meta)
            candidates.append(cand)

        return candidates

    def _score_candidates_via_feedback(
        self, candidates: list[Heuristic]
    ) -> list[Heuristic]:
        if not candidates:
            return []

        print(f"\n--- Scoring {len(candidates)} Candidates via LLM Feedback ---")

        # 1. Load feedback prompts/prompt template via PromptStore
        feedback_rtl_sys_prompt = self.prompts.read("feedback/system")
        feedback_rtl_user_tpl = self.prompts.read("feedback/user")

        # Debug logging
        print(f"[Gen0/BatchPick] Using feedback system prompt: {bool(feedback_rtl_sys_prompt)}")
        print(f"[Gen0/BatchPick] Using feedback user template: {bool(feedback_rtl_user_tpl)}")
        if feedback_rtl_sys_prompt:
             print(f"[Gen0/BatchPick] Feedback system prompt path: {self.prompts._abs_path_for('feedback/system')}")

        feedback_requests: list[dict[str, str]] = []
        user_overrides: list[str] | None = [] if feedback_rtl_user_tpl else None
        for cand in candidates:
            simulation_log = (
                "Latencymode: no simulation available. Provide quality estimate using heuristics."
            )
            if cand.status == "failed_format":
                simulation_log = (
                    f"Candidate failed format parsing. Details: {cand.feedback}. Provide guidance and score despite format issue."
                )
            # Standard payload for the Interface (fallback data if needed)
            feedback_requests.append(
                {
                    "problem_def": self.problem_description,
                    "code": cand.code,
                    "simulation_log": simulation_log,
                }
            )

            # 2. Apply safe_format if a custom template exists
            if feedback_rtl_user_tpl:
                formatted_prompt = safe_format(
                    feedback_rtl_user_tpl,
                    problem_def=self.problem_description,
                    code=cand.code,
                    simulation_log=simulation_log
                )
                user_overrides.append(formatted_prompt)
            cand.score = float("-inf")

        # Prepare system prompt list (same prompt for everyone)
        system_overrides = (
            [feedback_rtl_sys_prompt] * len(feedback_requests) 
            if feedback_rtl_sys_prompt 
            else None
        )

        # 3. Pass the formatted overrides to the interface
        feedback_results = asyncio.run(
            self.llm.generate_batch_feedback(
                feedback_requests,
                self.default_llm_temp,
                self.default_llm_top_p,
                self.default_llm_max_tokens,
                system_prompt_override=system_overrides,
                user_prompt_override=user_overrides,
            )
        )

        for cand, feedback in zip(candidates, feedback_results):
            score_val = feedback.get("score")
            try:
                cand.score = float(score_val)
            except (TypeError, ValueError):
                cand.score = float("-inf")
            cand.feedback = feedback.get("analysis", "")
            self._save_feedback_files(cand, feedback)

        candidates.sort(
            key=lambda c: c.score if c.score is not None else float("-inf"),
            reverse=True,
        )
        self.success_pool = candidates[:]
        self.fail_pool = []
        return candidates

    def load_problem_description(self) -> str:
        """
        Load a custom Gen0 prompt when provided, otherwise defer to the benchmark prompt.
        """
        if self.custom_prompt_mode:
            if self._custom_prompt_text_cache is not None:
                return self._custom_prompt_text_cache
            if self._custom_prompt_path is None:
                raise RuntimeError(
                    "Gen0 custom prompt mode flagged without a prompt path."
                )
            prompt_path = Path(self._custom_prompt_path)
            if not prompt_path.is_file():
                raise FileNotFoundError(
                    f"Custom Gen0 prompt file not found: {prompt_path}"
                )
            text = prompt_path.read_text(encoding=self._custom_prompt_encoding).strip()
            if not text:
                raise ValueError(
                    f"Custom Gen0 prompt file '{prompt_path}' is empty."
                )
            self._custom_prompt_text_cache = text
            return text
        return super().load_problem_description()

    def _copy_misc_files(self, output_directory: str) -> None:
        if self.custom_prompt_mode:
            return
        super()._copy_misc_files(output_directory)


class CVDPEngine(EoHEngine):
    """
    Adapter engine for CVDP (non-agentic, no-commercial) problems that ship with a
    cocotb/pytest harness. It bypasses VerilogEval-style testbenches and runs the
    provided Python tests directly.

    Usage:
        engine = CVDPEngine(
            cvdp_jsonl_path="data/bench/cvdp/cvdp_v1.0.2_nonagentic_code_generation_no_commercial.jsonl",
            cvdp_id="cvdp_copilot_64b66b_decoder_0001",   # or another 'id' in the JSONL
            benchmark_name="cvdp",
            problem_name="cvdp_copilot_64b66b_decoder_0001",
            llm_interface=llm,
            verilog_evaluator=verilog_evaluator,   # unused here but required by base
            synthesis_evaluator=synthesis_evaluator, # unused for CVDP; safe to pass a dummy
            population_size=10,
            num_generations=5,
        )
    """

    def __init__(
        self,
        cvdp_jsonl_path: str,
        cvdp_id: str,
        simulation_timeout_s: int = 300,
        prompt_profile: str = "default",
        prompt_root: str | None = None,
        *args,
        **kwargs,
    ):
        # Stash CVDP config BEFORE calling super().__init__ so our overridden
        # load_problem_description() can see them when base __init__ calls it.
        self.cvdp_jsonl_path: str = cvdp_jsonl_path
        self.cvdp_id: str = cvdp_id
        self.cvdp_record: dict[str, Any] | None = None

        super().__init__(
            prompt_profile=prompt_profile,
            prompt_root=prompt_root,
            *args, **kwargs
            )  # calls load_problem_description()

        # CVDP: turn off PPA logic (we don't synthesize in this adapter)
        self.ref_ppa_metrics = {}  # keep empty
        # The base class occasionally copies “misc files” from a benchmark dir.
        # There's no on-disk bench folder for CVDP, so make this a no-op by flag.
        self._cvdp_noop_copy_misc = True

        # Set simulation timeout time
        self.simulation_timeout_s = simulation_timeout_s

    # ---- Overrides & helpers ----

    def _copy_misc_files(self, output_directory: str) -> None:
        # For CVDP nothing to copy from a static bench dir.
        if getattr(self, "_cvdp_noop_copy_misc", False):
            return
        return super()._copy_misc_files(output_directory)

    def load_problem_description(self) -> str:
        """
        For CVDP, load the JSONL and return the 'input.prompt' for cvdp_id.
        """
        if not self.cvdp_record:
            rec = self._cvdp_find_record(self.cvdp_jsonl_path, self.cvdp_id)
            if rec is None:
                raise FileNotFoundError(
                    f"CVDP id '{self.cvdp_id}' not found in: {self.cvdp_jsonl_path}"
                )
            self.cvdp_record = rec
        # Plain prompt text becomes the initial generation problem description.
        return self.cvdp_record["input"]["prompt"]

    def _calculate_reference_ppa(self) -> None:
        """
        Disable PPA baseline for CVDP (we don't synthesize / run OpenROAD here).
        """
        self.ref_ppa_metrics = {}

    def _cvdp_find_record(self, jsonl_path: str, rec_id: str) -> dict | None:
        with open(jsonl_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    obj = json.loads(line)
                except Exception:
                    continue
                if obj.get("id") == rec_id:
                    return obj
        return None

    def _cvdp_materialize_harness(
        self,
        run_root: Path,
        candidate_sv_text: str,
    ) -> dict[str, str]:
        """
        Write the CVDP harness files to 'run_root' and drop the current candidate's
        RTL into the requested 'rtl/<file>.sv'. Also rewrite src/.env to point to
        absolute paths on this machine (no Docker compose required).

        Returns a dict with: {
          "dut_path": str,
          "pytest_entry": str,
          "log_path": str
        }
        """
        assert self.cvdp_record is not None, "cvdp_record must be loaded first"
        harness_files: dict[str, str] = self.cvdp_record["harness"]["files"]
        out_ctx: dict[str, str] = self.cvdp_record["output"]["context"]

        run_root.mkdir(parents=True, exist_ok=True)

        # 1) Write all harness files verbatim
        for rel, content in harness_files.items():
            out_path = run_root / rel
            out_path.parent.mkdir(parents=True, exist_ok=True)
            text = content

            # Fix src/.env to use absolute local paths (no container paths)
            if rel == "src/.env":
                # Determine the DUT relative path CVDP expects (first key in context)
                # e.g., "rtl/decoder_64b66b.sv"
                dut_rel = next(iter(out_ctx.keys()))
                dut_abs = (run_root / dut_rel).resolve()
                src_abs = (run_root / "src").resolve()
                
                # Replace only the relevant lines; keep others intact.
                # VERILOG_SOURCES= <abs path>
                # PYTHONPATH should point to local src
                lines = []
                for line in text.splitlines():
                    if line.strip().startswith("VERILOG_SOURCES"):
                        lines.append(f"VERILOG_SOURCES = {dut_abs.as_posix()}")
                    elif line.strip().startswith("PYTHONPATH"):
                        lines.append(f"PYTHONPATH = {src_abs.as_posix()}")
                    else:
                        lines.append(line)
                text = "\n".join(lines)


            out_path.write_text(text, encoding="utf-8")

        # 2) Write the candidate DUT into requested 'rtl/<file>.sv'
        dut_rel = next(iter(out_ctx.keys()))
        dut_abs = (run_root / dut_rel)
        dut_abs.parent.mkdir(parents=True, exist_ok=True)

        # normalize escaped sequences in case the LLM returned JSON-escaped string
        normalized_code = self._normalize_code_text(candidate_sv_text)
        dut_abs.write_text(normalized_code, encoding="utf-8")

        return {
            "dut_path": str(dut_abs),
            "pytest_entry": str((run_root / "src" / "test_runner.py").resolve()),
            "log_path": str((run_root / "pytest.log").resolve()),
            "env_file": str((run_root / "src" / ".env").resolve()),
        }

    # Simple .env parser
    def _cvdp_parse_envfile(self, env_path: Path) -> dict[str, str]:
        """
        Parse KEY=VALUE lines, ignoring blanks and comments; keep last occurrence.
        """
        env = {}
        try:
            for raw in env_path.read_text(encoding="utf-8").splitlines():
                line = raw.strip()
                if not line or line.startswith("#"):
                    continue
                if "=" not in line:
                    continue
                k, v = line.split("=", 1)
                k = k.strip()
                v = v.strip()
                # strip optional surrounding quotes
                if (v.startswith('"') and v.endswith('"')) or (v.startswith("'") and v.endswith("'")):
                    v = v[1:-1]
                env[k] = v
        except FileNotFoundError:
            pass
        return env

    def _cvdp_run_pytest(self, run_root: Path, pytest_entry: str, log_path: str, env_file: str) -> tuple[str, str, str, int]:
        """
        Run `pytest` on the provided harness. Return (status, stdout, stderr, returncode).
        """
        cmd = [
            "pytest",
            "-o", f"cache_dir={str((run_root / '.cache').resolve())}",
            pytest_entry,
            "-v",
            "-s",
        ]
        try:
            # Load env from src/.env and pass it to pytest
            child_env = os.environ.copy()
            dot_env = self._cvdp_parse_envfile(Path(env_file))
            # Ensure PYTHONPATH includes the src path from .env
            if "PYTHONPATH" in dot_env and dot_env["PYTHONPATH"]:
                pp = dot_env["PYTHONPATH"]
                child_env["PYTHONPATH"] = pp if "PYTHONPATH" not in child_env else (pp + os.pathsep + child_env["PYTHONPATH"])
            # Copy all .env vars (VERILOG_SOURCES, SIM, TOPLEVEL, MODULE, etc.)
            for k, v in dot_env.items():
                child_env[k] = v

            proc = subprocess.run(
                cmd,
                cwd=str(run_root),
                capture_output=True,
                text=True,
                check=False,
                env=child_env,
                timeout=self.simulation_timeout_s
            )
        except FileNotFoundError as e:
            # pytest not installed / not on PATH
            out, err, rc = "", f"Pytest invocation failed: {e}", 127
            Path(log_path).write_text(f"COMMAND: {' '.join(cmd)}\nSTDERR:\n{err}\n", encoding="utf-8")
            return "simulation_error", out, err, rc

        stdout = proc.stdout or ""
        stderr = proc.stderr or ""
        Path(log_path).write_text(
            f"COMMAND: {' '.join(cmd)}\n\nSTDOUT:\n{stdout}\n\nSTDERR:\n{stderr}\n",
            encoding="utf-8",
        )

        status = "success" if proc.returncode == 0 else "simulation_error"
        return status, stdout, stderr, proc.returncode

    # --- Core override: evaluate via cocotb/pytest instead of VerilogEval ---
    def _evaluate_candidates(self, candidates_to_evaluate: list[Heuristic]) -> None:
        """
        CVDP path: run the provided cocotb harness (pytest). If all tests pass,
        mark candidate as 'success' with score=0. Otherwise, classify failures:

        - Non-zero pytest exit → failed_functionality
        - Can't compile/simulate → failed_syntax (best-effort heuristic)
        """
        if not candidates_to_evaluate:
            return

        print(f"\n--- [CVDP] Evaluating {len(candidates_to_evaluate)} candidates via cocotb/pytest ---")
        assert self.cvdp_record is not None, "cvdp_record must be loaded first"

        # FEEDBACK: we will collect logs and then request batch LLM feedback
        feedback_requests: list[dict[str, str]] = []
        feedback_request_candidates: list[Heuristic] = []

        for cand in candidates_to_evaluate:
            # Check if the response adheres to format
            if getattr(cand, "status", None) in ("failed_format", "failed_diff"):
                cand.score = -float("inf")
                feedback_request_candidates.append(cand)
                feedback_requests.append(
                    {
                        "problem_def": self.problem_description,
                        "code": cand.code,
                        "simulation_log": f"Candidate failed format or diff compliance checks. Status: {cand.status}",
                    }
                )
                continue
            # Put a per-candidate harness beside its saved code
            cand_dir = Path(cand.code_file_path).parent
            run_root = cand_dir / f"cvdp_harness_{cand.id[:8]}"
            try:
                paths = self._cvdp_materialize_harness(run_root, cand.code)
                status, stdout, stderr, rc = self._cvdp_run_pytest(
                    run_root, paths["pytest_entry"], paths["log_path"], paths["env_file"]
                )

                combined_log = (
                    f"=== PYTEST COMMAND ===\n"
                    f"{(run_root / 'pytest.log').read_text(encoding='utf-8') if Path(paths['log_path']).exists() else ''}\n"
                    f"=== STDOUT ===\n{stdout}\n\n=== STDERR ===\n{stderr}\n"
                )

                if status == "success":
                    cand.status = "success"
                    cand.score = 0.0
                    # FEEDBACK: successes also get feedback to guide simplification/robustness
                    cand.feedback = "CVDP cocotb harness: all tests passed."
                    feedback_request_candidates.append(cand)
                    feedback_requests.append({
                        "problem_def": self.problem_description,
                        "code": cand.code,
                        # Ask LLM to propose safe, incremental improvements without breaking interface
                        "simulation_log": (
                            "All tests passed under the CVDP cocotb harness.\n"
                            "Provide targeted suggestions to simplify RTL, remove redundant logic, "
                            "and improve synthesizability/robustness while preserving the DUT name, "
                            "ports, parameter defaults, and behavior expected by the harness.\n\n"
                            + combined_log
                        ),
                    })
                else:
                    # Heuristic: if stderr mentions syntax/parse, call it syntax; else functionality.
                    if re.search(r"(syntax error|parse error|unexpected token)", stderr, re.I):
                        cand.status = "failed_syntax"
                    else:
                        cand.status = "failed_functionality"
                    cand.score = -float("inf")
                    # FEEDBACK: failed candidates ask for precise, actionable fixes
                    cand.feedback = "CVDP harness failed; LLM feedback requested for fix."
                    feedback_request_candidates.append(cand)
                    feedback_requests.append({
                        "problem_def": self.problem_description,
                        "code": cand.code,
                        "simulation_log": (
                            "The cocotb/pytest harness failed. "
                            "Analyze the logs to identify the root cause (module/name/port mismatches, "
                            "reset/latency, wrong header decoding, signed arithmetic, packing order, etc.). "
                            "Give concrete patch-style guidance and minimal fixes that keep the public interface "
                            "and module name compatible with the harness.\n\n"
                            + combined_log
                        ),
                    })
            except Exception as e:
                cand.status = "failed_functionality"
                cand.score = -float("inf")
                cand.feedback = f"CVDP evaluation exception: {e}"
                # FEEDBACK: still try to get LLM feedback on exception
                feedback_request_candidates.append(cand)
                feedback_requests.append({
                    "problem_def": self.problem_description,
                    "code": cand.code,
                    "simulation_log": f"Exception while running harness:\n{e}\n",
                })

        # FEEDBACK: batch LLM feedback (mirrors your base engine behavior)
        if feedback_requests:
            try:
                print(f"[CVDP] Requesting LLM feedback for {len(feedback_requests)} candidates...")
                feedback_rtl_sys_prompt = self.prompts.read("feedback/system")
                feedback_rtl_user_prompt = self.prompts.read("feedback/user")
                input_system_prompt_override = [feedback_rtl_sys_prompt] * len(feedback_requests) if feedback_rtl_sys_prompt else None
                input_user_prompt_override = [feedback_rtl_user_prompt] * len(feedback_requests) if feedback_rtl_user_prompt else None
                feedback_results = asyncio.run(
                    self.llm.generate_batch_feedback(
                        feedback_requests,
                        self.default_llm_temp,
                        self.default_llm_top_p,
                        self.default_llm_max_tokens,
                        system_prompt_override=input_system_prompt_override,
                        user_prompt_override=input_user_prompt_override,
                    )
                )
                for cand, fb in zip(feedback_request_candidates, feedback_results):
                    # Persist detailed analysis for downstream strategies (M-F/M-S/…)
                    feedback = fb.get("analysis", "Feedback generation failed.")
                    # If feedback not str assign it as one
                    if not isinstance(feedback, str):
                        feedback = "Feedback generation failed."
                    cand.feedback = feedback
                    self._save_feedback_files(cand, fb)  # writes <base>_feedback.txt
            except Exception as e:
                print(f"[CVDP] Feedback generation error: {e}")

        # NOTE: No synthesis/PPA step for CVDP yet. Still pending.
# <<< CVDP INTEGRATION
