import asyncio
import datetime
import json
import math
import os
import random
import re
import shutil
import time
import uuid
from collections import defaultdict
from typing import Any, Literal, TypeVar, cast, get_args, overload

# Import from local modules
from .evaluation import SynthesisEvaluator, VerilogEvaluator
from .llm import LLMInterface
from .logging import EoHLogger

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
    "failed_syntax",
    "failed_functionality",
    "failed_synthesis",
    "failed_synthesis_functionality",
]
"""
Defines the status of a heuristic candidate.
- **new**: Newly created candidate, not yet evaluated.
- **success**: Successfully passed all evaluations (syntax, functionality, synthesis, PPA).
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
    ):
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

    def _save_result_to_file(
        self,
        code_content: str,
        thought_content: str,
        generation_num: int,
        sample_idx_in_generation: int,
        strategy: EvolStrategyMethod | None = None,
    ) -> tuple[str, str]:
        """
        Save the generated code and thought process to ``<save_path>/Gen<k>/``.

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

        :return: Tuple containing the file paths of the saved code and thought files.
        :rtype: tuple[str, str]
        """
        model_name_cleaned = self.llm.model_name.replace("/", "_")
        directory_path = os.path.join(
            self.base_save_path,
            model_name_cleaned,
            self.benchmark_name,
            self.problem_name,
            f"Gen{generation_num}",
        )
        os.makedirs(directory_path, exist_ok=True)

        base_name = f"{self.problem_name}_{strategy}_sample{sample_idx_in_generation}"
        code_file_path = os.path.join(directory_path, f"{base_name}.sv")
        thought_file_path = os.path.join(directory_path, f"{base_name}_thought.txt")

        with open(code_file_path, "w") as f:
            f.write(str(code_content))
        with open(thought_file_path, "w") as f:
            f.write(str(thought_content))

        self._copy_misc_files(directory_path)
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

        func_passed, func_failed, feedback_requests, feedback_request_candidates = (
            [],
            [],
            [],
            [],
        )

        # Stage 1: Functional Simulation
        for cand in candidates_to_evaluate:
            sim_results = self.evaluator.evaluate(
                cand.code_file_path, test_sv_file, ref_sv_file
            )

            if sim_results["status"] == "compilation_error":
                cand.status = "failed_syntax"
                log = sim_results.get(
                    "compilation_stderr", "Compilation log not available."
                )
            else:
                is_success = False
                if sim_results["status"] == "success":
                    output = sim_results.get("simulation_stdout", "")
                    m_match = re.search(r"^Mismatches: (\d+)", output, re.M)
                    # Check for simulation success based on output in two ways:
                    # Case 1: Check for "Mismatches: X in Y samples" in simulation output (VerilogEvalv2 format)
                    # This regex matches the expected output format from VerilogEval
                    # It captures the number of mismatches in the first group.
                    # If there are no mismatches (X==0), it means the design is functionally correct.
                    # Case 2: Check for "===========Your Design Passed===========" in simulation output (RTLLMv2 format)
                    if (
                        m_match and int(m_match.group(1)) == 0
                    ) or "===========Your Design Passed===========" in output:
                        is_success = True

                if is_success:
                    func_passed.append(cand)
                    continue
                else:
                    cand.status = "failed_functionality"
                    log = f"Compilation Log:\n{sim_results.get('compilation_stderr')}\n\nSimulation Log:\n{sim_results.get('simulation_stdout')}\n{sim_results.get('simulation_stderr')}"

            # If we reach here, the candidate has failed syntax or functionality
            cand.score = -float("inf")
            feedback_request_candidates.append(cand)
            feedback_requests.append(
                {
                    "problem_def": self.problem_description,
                    "verilog_code": cand.code,
                    "simulation_log": log,
                }
            )
            func_failed.append(cand)

        # Stage 2: Synthesis and PPA for functionally correct candidates
        for cand in func_passed:
            report_base_path = cand.code_file_path.rsplit(".", 1)[0]
            output_dir = os.path.dirname(cand.code_file_path)

            # Find the module name from the reference file (synthesis_top_module_names.json is expected to exist within the benchmark directory)
            # This is needed to ensure the synthesis evaluator knows which module to synthesize.
            # Important as each benchmark may have a different top module name.
            # (RTLLM uses individual problem name and VerilogEvalv2 uses TopModule)
            # And sometimes the LLM will generate multiple modules in the same file as part of hierarchical design.
            # In previous versions, we used the first module name found in the file.
            # This lead to some situations where the synthesized module was not the intended top module.
            # Now, we will use a JSON file that maps problem names to top module names.
            # If the file does not exist, we will use a default module name "TopModule".
            # This is a fallback mechanism to ensure synthesis can proceed even if the JSON file is missing
            top_module_name_file = os.path.join(
                self.benchmark_path, "synthesis_top_module_names.json"
            )
            if not os.path.exists(top_module_name_file):
                print(
                    "WARNING: Top module name file not found. Using default module name 'TopModule'."
                )
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
                cand.feedback = f"Functionality OK and Synthesis OK. Now focus on improving PPA metrics while preserving functionality. PPA metrics (tns/wns/eff_clk_period: ns, power: W, area: um^2): {cand.ppa_metrics}, Reference PPA metrics: {self.ref_ppa_metrics},  PPA score: {cand.score:.4f}, Try to improve PPA metrics further. If effective clockspeed is close to 0.0, than focus on improving area and power metrics."
                feedback_request_candidates.append(cand)
                feedback_requests.append(
                    {
                        "problem_def": self.problem_description,
                        "verilog_code": cand.code,
                        "simulation_log": cand.feedback,
                    }
                )
            else:
                cand.score = -float("inf")
                cand.synthesis_success = synth_results["synthesis_success"]
                cand.synthesis_functionality = synth_results[
                    "synthesis_functionality_success"
                ]
                log = f"Synthesis or PPA failed.\nLog:\n{synth_results.get('synthesis_log', 'N/A')}"

                if not synth_results["synthesis_success"]:
                    cand.status = "failed_synthesis"
                    log = f"Functionality OK, but synthesis failed.\nLog:\n{synth_results.get('synthesis_log', 'N/A')}"
                elif not synth_results["synthesis_functionality_success"]:
                    cand.status = "failed_synthesis_functionality"
                    log = f"Functionality OK, Synthesis OK, but Post-Synthesis Functional Check failed (Yosys have trouble synthesizing the implementation try to improve synthesizability).\nLog:\n{synth_results.get('synthesis_log', 'N/A')}"
                else:  # PPA failed but synth was ok
                    cand.status = "failed_synthesis"

                feedback_request_candidates.append(cand)
                feedback_requests.append(
                    {
                        "problem_def": self.problem_description,
                        "verilog_code": cand.code,
                        "simulation_log": log,
                    }
                )
                func_failed.append(cand)

        # Stage 3: Batch LLM Feedback Generation for all failures
        if feedback_requests:
            print(
                f"Requesting LLM feedback for {len(feedback_request_candidates)} candidates (both failed and successful)..."
            )
            feedback_results = asyncio.run(
                self.llm.generate_batch_feedback(
                    feedback_requests,
                    self.default_llm_temp,
                    self.default_llm_top_p,
                    self.default_llm_max_tokens,
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

        :param parent: The parent candidate to format.
        :type parent: Heuristic
        :param example_num: The example number for formatting. (default is 1) Useful for fusion strategy where we have two parents.
        :type example_num: int
        """
        parent_prompt = (
            f"<Example {example_num}>:\n"
            f"```thought\n{parent.thought}\n```\n"
            f"```code\n{parent.code}\n```\n"
            f"```feedback\n{parent.feedback}\n```\n"
        )
        if parent.ppa_success:
            parent_prompt += (
                f"```ppa_metrics\n{json.dumps(parent.ppa_metrics, indent=2)}\n```\n"
            )
        return parent_prompt

    def _create_prompt_M_F(self, parents: list[Heuristic]) -> str:  # Fix
        """
        Creates a prompt for the 'Fix' mutation strategy.
        This strategy is used when a previous attempt has failed, and the goal is to fix the code based on feedback.

        :param parents: List of parent candidates to use as examples.
        :type parents: list[Heuristic]
        :return: The formatted prompt string.
        :rtype: str
        """
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nThe following attempt failed. Use the feedback to fix it.\n\n"
            f"{parent_info}\nYour task is to fix the code based on the feedback. Provide a new thought process explaining the fix and the corrected code."
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
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nHere is a previous solution.\n\n{parent_info}\n"
            f"Your task is to simplify this solution. Reduce complexity while maintaining functionality. Provide your simplified thought and code."
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
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nHere is one approach.\n\n{parent_info}\n"
            f"Your task is to generate a completely new and different solution. Come up with a novel architectural idea. Describe your new idea and provide the code."
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
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nHere is a solution.\n\n{parent_info}\n"
            f"Your task is to refactor this code. The core idea must be the same, but implement it with a different structure (e.g., use `assign` instead of `always`, restructure a state machine). Explain the refactoring and provide the new code."
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
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nHere is a solution.\n\n{parent_info}\n"
            f"Your task is to improve this solution. If it failed, make it correct. If it succeeded, optimize it for better PPA based on its metrics. Describe your improvement strategy and provide the improved code."
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
        parent1_info = self._format_parent_for_prompt(parents[0], 1)
        parent2_info = self._format_parent_for_prompt(parents[1], 2)
        return (
            f"{self.problem_description}\n\nHere are two different successful solutions.\n\n{parent1_info}\n{parent2_info}\n"
            f"Your task is to create a superior solution by fusing the best ideas from both examples. Analyze their strengths and combine them. Explain your fusion strategy and provide the new code."
        )

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
        results = asyncio.run(
            self.llm.generate_n_responses(
                prompt=self.problem_description,
                n=self.population_size,
                temperature=self.default_llm_temp,
                top_p=self.default_llm_top_p,
                max_tokens=self.default_llm_max_tokens,
            )
        )

        initial_candidates = []
        for i, (thought, code) in enumerate(results):
            if thought and code:
                code_path, _ = self._save_result_to_file(
                    code, thought, 0, i + 1, "initial"
                )
                cand = Heuristic(
                    thought=thought,
                    code=code,
                    feedback="",
                    generation=0,
                    strategy="initial",
                    origin_pool="initial",
                )
                cand.code_file_path = code_path
                initial_candidates.append(cand)

        if not initial_candidates:
            print(
                "WARNING: No valid candidates generated during initialization. Check LLM responses."
            )
            print(f"LLM Responses: {results}")
            raise RuntimeError(
                "Failed to generate any valid candidates during initialization."
            )
        print(f"Generated {len(initial_candidates)} initial candidates. Evaluating...")
        self._evaluate_candidates(initial_candidates)

        for cand in initial_candidates:
            if cand.status == "success":
                self.success_pool.append(cand)
            else:
                self.fail_pool.append(cand)

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

    def evolve_one_generation(self):
        """Performs one generation of the REvolution algorithm."""
        self.current_generation += 1
        print(f"\n--- Starting Generation {self.current_generation} ---")
        self.gen_start_time = time.time()

        strategies = {
            "M-F": {"func": self._create_prompt_M_F, "num_parents": 1},
            "M-S": {"func": self._create_prompt_M_S, "num_parents": 1},
            "M-E": {"func": self._create_prompt_M_E, "num_parents": 1},
            "M-R": {"func": self._create_prompt_M_R, "num_parents": 1},
            "M-I": {"func": self._create_prompt_M_I, "num_parents": 1},
            "C-F": {"func": self._create_prompt_C_F, "num_parents": 2},
        }
        # fail_strats, success_strats = ['M-F','M-S','M-E','M-R','M-I'], ['M-S','M-E','M-R','M-I','C-F']

        total_current_pop = len(self.fail_pool) + len(self.success_pool)
        if total_current_pop == 0:
            return "STOP"

        num_from_fail = round(
            self.num_offspring_lambda * len(self.fail_pool) / total_current_pop
        )
        num_from_success = self.num_offspring_lambda - num_from_fail

        prompts: list[str] = []
        metadata: list[dict[str, Any]] = []

        success_strategy_average_probabilities = {s: 0.0 for s in self.success_strats}
        fail_strategy_average_probabilities = {s: 0.0 for s in self.fail_strats}

        # Track strategies selected in this generation's loop for UCB
        fail_strategies_selected_this_gen = set()
        success_strategies_selected_this_gen = set()

        # Generate from Fail Pool
        if self.fail_pool:
            for _ in range(num_from_fail):
                strat_name, prob_dist_dict = self._select_strategy(
                    "fail", self.fail_strats, fail_strategies_selected_this_gen
                )
                if strat_name is None or prob_dist_dict is None:
                    print("No valid fail strategies available. Skipping...")
                    continue
                fail_strategies_selected_this_gen.add(strat_name)
                parents = random.choices(
                    self.fail_pool, k=strategies[strat_name]["num_parents"]
                )
                prompts.append(strategies[strat_name]["func"](parents))
                metadata.append(
                    {
                        "parents": parents,
                        "strategy": strat_name,
                        "pool": "fail",
                        "prob_dist": prob_dist_dict,
                    }
                )
                print(
                    f"Fail Pool Evolve Debug: Selected parents {parents} for strategy {strat_name} with prob_dist {prob_dist_dict}"
                )
                for k, v in prob_dist_dict.items():
                    fail_strategy_average_probabilities[k] += v
            # Normalize probabilities for fail strategies
            if num_from_fail > 0:
                for k in fail_strategy_average_probabilities.keys():
                    fail_strategy_average_probabilities[k] /= num_from_fail

        # Generate from Success Pool
        if self.success_pool:
            available_success_strategies = self.success_strats.copy()
            # First check if we have enough candidates in the success pool for the strategy that requires fusion
            if len(self.success_pool) < 2:
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
                # Weighted selection for success pool
                weights = [
                    c.score - min(p.score for p in self.success_pool) + 0.1
                    for c in self.success_pool
                ]
                parents = random.choices(
                    self.success_pool,
                    weights=weights,
                    k=strategies[strat_name]["num_parents"],
                )
                # if the strategy is fusion, we need two parents that are different
                if (
                    strat_name == "C-F"
                    and len(parents) == 2
                    and parents[0].id == parents[1].id
                ):
                    # If both parents are the same, we need to select a different one
                    # This is a rare case, but can happen if the success pool has only one candidate
                    # Sample again without the same parent and weights
                    available_strategies = [
                        p for p in self.success_pool if p.id != parents[0].id
                    ]
                    updated_weights = [
                        c.score - min(p.score for p in available_strategies) + 0.1
                        for c in available_strategies
                    ]
                    if available_strategies:
                        parents[1] = random.choices(
                            available_strategies, weights=updated_weights, k=1
                        )[0]
                # print(f'Debug: Selected parents {parents} for strategy {strat_name} with weights {weights} with available strategies {available_strategies}')
                prompts.append(strategies[strat_name]["func"](parents))
                metadata.append(
                    {
                        "parents": parents,
                        "strategy": strat_name,
                        "pool": "success",
                        "prob_dist": prob_dist_dict,
                    }
                )
                print(
                    f"Success Pool Evolve Debug: Selected parents {parents} for strategy {strat_name} with prob_dist {prob_dist_dict}"
                )
                for k, v in prob_dist_dict.items():
                    success_strategy_average_probabilities[k] += v
            # Normalize probabilities for success strategies
            if num_from_success > 0:
                for k in success_strategy_average_probabilities.keys():
                    success_strategy_average_probabilities[k] /= num_from_success

        # Form dictionary of strategy probabilities for logging
        strategy_avg_selection_probabilities = {
            "fail_pool": fail_strategy_average_probabilities,
            "success_pool": success_strategy_average_probabilities,
        }

        if not prompts:
            return "STOP"

        llm_results = asyncio.run(
            self.llm.generate_batch_responses(
                prompts,
                self.default_llm_temp,
                self.default_llm_top_p,
                self.default_llm_max_tokens,
            )
        )

        new_offspring = []
        for i, (thought, code) in enumerate(llm_results):
            if thought and code:
                meta = metadata[i]
                code_path, _ = self._save_result_to_file(
                    code, thought, self.current_generation, i + 1, meta["strategy"]
                )
                # pool_type
                if meta["pool"] == "fail":
                    candidate_origin_pool = "fail_pool"
                else:
                    candidate_origin_pool = "success_pool"
                cand = Heuristic(
                    thought=thought,
                    code=code,
                    feedback="",
                    generation=self.current_generation,
                    parent_ids=[p.id for p in meta["parents"]],
                    strategy=meta["strategy"],
                    origin_pool=candidate_origin_pool,
                )
                cand.code_file_path = code_path
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
            best_by_power = min(
                successful_candidates,
                key=lambda c: c.ppa_metrics.get("power", float("inf")),
            )
            best_by_area = min(
                successful_candidates,
                key=lambda c: c.ppa_metrics.get("area", float("inf")),
            )

            champions = [best_by_score, best_by_power, best_by_area]

            # Conditionally add the delay champion for sequential circuits only
            # As combinatorial circuits do not have a meaningful clock period and eff_clk_period are set to 0.0
            # Current clk_period(0.01 ns) is used as a threshold to determine if the circuit is sequential
            # This is a heuristic, but it works well for most cases
            is_sequential = self.ref_ppa_metrics.get("eff_clk_period") != 0.0
            if is_sequential:
                best_by_delay = min(
                    successful_candidates,
                    key=lambda c: c.ppa_metrics.get("eff_clk_period", float("inf")),
                )
                champions.append(best_by_delay)

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
            )
            self.logger.meta_strategy_name = self.strategy_selection_method
            self.initialize_population()
        except Exception as e:
            print(f"Critical error during initialization: {e}")
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
            import traceback

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
