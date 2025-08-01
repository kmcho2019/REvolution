from __future__ import annotations

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
from pathlib import Path
from typing import Any, Dict, List, Optional, Set, Tuple

# Import from local modules
from .evaluation import SynthesisEvaluator, VerilogEvaluator
from .llm import LLMInterface
from .logging import EoHLogger


class Heuristic:
    """Represents a single candidate solution in the evolutionary process.

    This class holds the "genetic" material (thought and code), evaluation
    results, and metadata about its origin and performance.

    Attributes:
        id (str): A unique identifier for the heuristic.
        thought (str): The design strategy or "thought process" from the LLM.
        code (str): The generated Verilog code.
        feedback (str): The analysis or feedback received after evaluation.
        score (float): The fitness score, typically based on PPA improvement.
        generation (int): The generation number in which this heuristic was created.
        parent_ids (List[str]): A list of IDs of the parent(s).
        status (str): The current evaluation status of the candidate.
        synthesis_success (bool): Whether the code was successfully synthesized.
        synthesis_functionality (bool): Whether the synthesized netlist passed functional checks.
        ppa_success (bool): Whether PPA metrics were successfully extracted.
        ppa_metrics (Dict[str, Any]): A dictionary of PPA metrics.
        code_file_path (Path): The path to the saved Verilog file for this heuristic.
        strategy (str): The evolutionary strategy used to generate this heuristic.
        reward_from_parent (float): The reward value calculated for the strategy.
        origin_pool (str): The population pool this heuristic originated from.
    """

    def __init__(
        self,
        thought: str,
        code: str,
        feedback: str,
        score: float = 0.0,
        generation: int = 0,
        parent_ids: Optional[List[str]] = None,
        status: str = "syntax",
        strategy: str = "initial",
        origin_pool: str = "initial",
    ):
        self.id: str = str(uuid.uuid4())  # Use UUID for unique ID
        self.thought: str = thought
        self.code: str = code
        self.feedback: str = feedback  # Feedback from LLM
        self.score: float = score
        self.generation: int = generation
        self.parent_ids: List[str] = parent_ids if parent_ids else []
        # New attributes for synthesis and PPA
        self.status: str = status  # Status can be 'new', 'success', 'failed_syntax', 'failed_functionality', 'failed_synthesis', 'failed_synthesis_functionality'
        self.synthesis_success: bool = False
        self.synthesis_functionality: bool = False
        self.ppa_success: bool = False
        self.ppa_metrics: Dict[str, Any] = {}
        # File path to the code for evaluation purposes
        self.code_file_path: Path = Path("")
        self.strategy: str = strategy  # Strategy used to generate this heuristic, e.g., "initial", "M-F", "C-F", etc. (Total of 6 strategies + "initial")
        self.reward_from_parent: float = (
            0.0  # Reward obtained by the strategy that created this heuristic
        )
        self.origin_pool: str = origin_pool  # "initial", "fail_pool", or "success_pool"

    def __repr__(self) -> str:
        thought_repr = self.thought[:50]
        ppa_info = "PPA: Not run or failed"
        if self.ppa_success and self.ppa_metrics:
            # Format PPA metrics for cleaner display
            clk = self.ppa_metrics.get("eff_clk_period")
            area = self.ppa_metrics.get("area")
            power = self.ppa_metrics.get("power")
            ppa_str = f"Eff. Clk: {clk:.4f}ns, Area: {area:.2f}, Power: {power:.4e}"
            ppa_info = f"PPA: ({ppa_str})"
        return (
            f"Heuristic(ID: {self.id}, Gen: {self.generation}, Origin: {self.origin_pool}, Strategy: {self.strategy}, Score: {self.score:.4f}, "
            f"Status: {self.status}, Thought: '{thought_repr}...', Parents: {self.parent_ids}, {ppa_info})"
        )


# Entire class executing for the new REvolution framework for each problem in the benchmark.
class EoHEngine:
    """The main engine for the REvolution evolutionary framework.

    This class orchestrates the entire evolutionary process for a single
    hardware design problem, including population management, evaluation,
    selection, and generation of new candidates.

    Attributes:
        benchmark_dir (Path): Path to the directory for the specific benchmark.
        benchmark_name (str): Name of the benchmark being solved.
        output_dir (Path): Root directory for saving all experiment outputs.
        problem_name (str): The name of the specific problem being solved.
        llm (LLMInterface): The interface for communicating with LLMs.
        evaluator (VerilogEvaluator): The tool for Verilog simulation.
        synthesis_evaluator (SynthesisEvaluator): The tool for synthesis and PPA.
        population_size (int): The number of individuals in the population (μ).
        num_offspring_lambda (int): The number of offspring to generate each gen (λ).
        num_generations (int): The total number of generations to run.
        problem_description (str): The text description of the design problem.
        fail_pool (List[Heuristic]): The population of failing candidates.
        success_pool (List[Heuristic]): The population of successful candidates.
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
        base_save_path: Optional[Path] = None,
        strategy_selection_method: str = "random",
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
        self.fail_pool: List[Heuristic] = []
        self.success_pool: List[Heuristic] = []

        # Add attributes for dynamic strategy selection using meta-strategies
        # Formulate problem of picking which strategy to use as a multi-armed bandit problem
        self.strategy_selection_method = (
            strategy_selection_method  # "random", "epsilon-greedy", "ucb"
        )
        self.epsilon = epsilon  # For epsilon-greedy strategy (default 0.1)
        self.ucb_c = ucb_c  # Exploration parameter for UCB strategy (default 2.0)

        self.fail_strats = ["M-F", "M-S", "M-E", "M-R", "M-I"]
        self.success_strats = ["M-S", "M-E", "M-R", "M-I", "C-F"]

        self.fail_strategy_stats = {
            s: {"count": 0, "value": 0.0} for s in self.fail_strats
        }
        self.success_strategy_stats = {
            s: {"count": 0, "value": 0.0} for s in self.success_strats
        }

        self.current_generation = 0
        self.ref_ppa_metrics = {}
        self.logger = None
        self.run_start_time = 0
        self.run_start_utc = None
        self.gen_start_time = 0

    def load_problem_description(self):
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

    def _copy_misc_files(self, output_directory):
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
        code_content,
        thought_content,
        generation_num,
        sample_idx_in_generation,
        strategy=None,
    ):
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

    def _calculate_reference_ppa(self):
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

    def _calculate_fitness_score(self, candidate):
        """Calculates a fitness score for a successful candidate based on PPA improvement."""
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

        power_improvement = (P_gen - P_ref) / P_ref
        area_improvement = (A_gen - A_ref) / A_ref
        timing_improvement = None  # Default to None for combinational circuits

        # A non-zero TNS or WNS in reference implies a sequential circuit for this calculation
        # Combinatorial circuits will have TNS and WNS as 0, and eff_clk_period of 0
        # If T_ref is 0.0 than it is a combinational circuit
        if T_ref == 0.0:
            is_sequential = False
        else:
            is_sequential = True

        if is_sequential:
            timing_improvement = (T_gen - T_ref) / T_ref
            total_improvement = (
                power_improvement + area_improvement + timing_improvement
            ) / 3
        else:  # Combinational
            total_improvement = (power_improvement + area_improvement) / 2

        # Fitness is maximized, and lower improvement % is better. So, fitness = -improvement.
        return -total_improvement

    def _save_feedback_files(self, candidate, feedback):
        """Helper to save feedback files for a failed candidate."""
        base_path = candidate.code_file_path.rsplit(".", 1)[0]
        feedback_file_path = f"{base_path}_feedback.txt"
        with open(feedback_file_path, "w") as f:
            f.write(
                f"Score: {feedback.get('score', 'N/A')}\nJustification: {feedback.get('justification', 'N/A')}\n\nANALYSIS:\n{feedback.get('analysis', '')}"
            )

    def _evaluate_candidates(self, candidates_to_evaluate):
        """
        Evaluates a list of new candidates through the full pipeline (syntax, func, synth).
        Updates each candidate object with its final status, feedback, and score.
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
                    f"WARNING: Top module name file not found. Using default module name 'TopModule'."
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
    def _format_parent_for_prompt(self, parent, example_num=1):
        """Helper to format a parent candidate for inclusion in a prompt."""
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

    def _create_prompt_M_F(self, parents):  # Fix
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nThe following attempt failed. Use the feedback to fix it.\n\n"
            f"{parent_info}\nYour task is to fix the code based on the feedback. Provide a new thought process explaining the fix and the corrected code."
        )

    def _create_prompt_M_S(self, parents):  # Simplify
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nHere is a previous solution.\n\n{parent_info}\n"
            f"Your task is to simplify this solution. Reduce complexity while maintaining functionality. Provide your simplified thought and code."
        )

    def _create_prompt_M_E(self, parents):  # Explore
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nHere is one approach.\n\n{parent_info}\n"
            f"Your task is to generate a completely new and different solution. Come up with a novel architectural idea. Describe your new idea and provide the code."
        )

    def _create_prompt_M_R(self, parents):  # Refactor
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nHere is a solution.\n\n{parent_info}\n"
            f"Your task is to refactor this code. The core idea must be the same, but implement it with a different structure (e.g., use `assign` instead of `always`, restructure a state machine). Explain the refactoring and provide the new code."
        )

    def _create_prompt_M_I(self, parents):  # Improve
        parent_info = self._format_parent_for_prompt(parents[0])
        return (
            f"{self.problem_description}\n\nHere is a solution.\n\n{parent_info}\n"
            f"Your task is to improve this solution. If it failed, make it correct. If it succeeded, optimize it for better PPA based on its metrics. Describe your improvement strategy and provide the improved code."
        )

    def _create_prompt_C_F(self, parents):  # Fusion
        parent1_info = self._format_parent_for_prompt(parents[0], 1)
        parent2_info = self._format_parent_for_prompt(parents[1], 2)
        return (
            f"{self.problem_description}\n\nHere are two different successful solutions.\n\n{parent1_info}\n{parent2_info}\n"
            f"Your task is to create a superior solution by fusing the best ideas from both examples. Analyze their strengths and combine them. Explain your fusion strategy and provide the new code."
        )

    def initialize_population(self):
        """Creates and evaluates the initial population."""
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
                    thought,
                    code,
                    "",
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
        llm_calls = self.llm.get_and_reset_api_calls()
        self.logger.log_generation(
            0,
            initial_candidates,
            gen0_runtime,
            llm_calls,
            {},
            {},
            self.fail_strategy_stats,
            self.success_strategy_stats,
            strategy_avg_selection_probabilities,
        )  # No rewards for initial generation

        print(
            f"--- Initial Population Processed. Success: {len(self.success_pool)}, Fail: {len(self.fail_pool)} ---"
        )
        if self.success_pool:
            self.success_pool.sort(key=lambda c: c.score, reverse=True)
            print(f"Best initial candidate: {self.success_pool[0]}")

    def _select_strategy(self, pool_type, available_strategies, selected_this_gen=None):
        """
        Selects a strategy based on the chosen multi-armed bandit algorithm.
        Also return the probability distribution of strategies for debugging purposes.
        The probability should be ex-ante, for example for epsilon-greedy, it should be the probability of selecting each strategy before the selection is made.
        pool_type: 'fail' or 'success' to indicate which pool we are selecting from
        available_strategies: List of strategies available for the given pool type.
        Returns the selected strategy name and dictionary with key: strategy name and value: probability of selection.
        If no strategies are available, returns None, None.
        Args:
            pool_type (str): 'fail' or 'success' to indicate which pool.
            available_strategies (list): List of strategies available for the pool.
            selected_this_gen (set, optional): Strategies already selected in this generation's loop. Defaults to None.

        Returns:
            tuple: The selected strategy name and a dictionary of selection probabilities.
        """
        if not available_strategies:
            print(
                f"No available strategies for pool type '{pool_type}'. Returning None."
            )
            return None, None

        if selected_this_gen is None:
            selected_this_gen = set()

        stats_dict = (
            self.fail_strategy_stats
            if pool_type == "fail"
            else self.success_strategy_stats
        )
        method = self.strategy_selection_method

        if method == "random":
            dist = {s: 1.0 / len(available_strategies) for s in available_strategies}
            return random.choice(available_strategies), dist

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
            dist = {}
            for s in available_strategies:
                base_prob = self.epsilon / n
                if s in best_strategies:
                    dist[s] = base_prob + (1 - self.epsilon) / k
                else:
                    dist[s] = base_prob

            # Select strategy
            if random.random() < self.epsilon:
                selected = random.choice(available_strategies)
            else:
                selected = (
                    random.choice(best_strategies) if k > 1 else best_strategies[0]
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
            print(f"Debug UCB: Untried strategies: {untried_strategies}")
            # If there are untried strategies, randomly select one. This ensures that for the
            # first evolution, strategies are selected as evenly as possible, and each
            # strategy is guaranteed to be chosen once before moving to exploration.
            if untried_strategies:
                # untried_strategies should have equal probability of selection
                prob = 1.0 / len(untried_strategies)
                dist = {s: prob for s in untried_strategies}
                print(
                    f"Debug UCB: Untried strategies selected with equal probability: {dist}"
                )
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

            ucb_scores = {}
            for strat in available_strategies:
                # If a strategy has 0 pulls, its exploration value is infinite.
                # This prevents a ZeroDivisionError and correctly prioritizes it.
                # Infinite seems to cause nan issues in softmax, so we set it to a very high value.
                # This is a common trick in UCB to handle untried arms.
                if stats_dict[strat]["count"] == 0:
                    ucb_scores[strat] = (
                        1000  # Use a large constant instead of infinity to avoid NaN issues in softmax
                    )
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
            max_score = max(scores)
            exp_scores = [math.exp(score - max_score) for score in scores]
            sum_exp = sum(exp_scores)
            weights = [exp_score / sum_exp for exp_score in exp_scores]
            print(
                f"Debug UCB: Strategy scores: {ucb_scores}, Weights: {weights}, dist: {dict(zip(available_strategies, weights))}"
            )
            dist = dict(zip(available_strategies, weights))

            # Select strategy using softmax distribution
            selected = random.choices(available_strategies, weights=weights, k=1)[0]
            return selected, dist

        else:  # Fallback to random
            print(
                f"[WARNING] Unknown strategy selection method '{method}'. Defaulting to random selection."
            )
            prob = 1.0 / len(available_strategies)
            dist = {s: prob for s in available_strategies}
            return random.choice(available_strategies), dist

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

        prompts, metadata = [], []

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
                if strat_name is None:
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
                if strat_name is None:
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
                    thought,
                    code,
                    "",
                    self.current_generation,
                    [p.id for p in meta["parents"]],
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
            stats_dict = (
                self.fail_strategy_stats
                if parent_pool_type == "fail"
                else self.success_strategy_stats
            )

            s = stats_dict[strategy_name]
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
                key=lambda c: c.ppa_metrics.get("power")
                if c.ppa_metrics.get("power") is not None
                else float("inf"),
            )
            best_by_area = min(
                successful_candidates,
                key=lambda c: c.ppa_metrics.get("area")
                if c.ppa_metrics.get("area") is not None
                else float("inf"),
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
                    key=lambda c: c.ppa_metrics.get("eff_clk_period")
                    if c.ppa_metrics.get("eff_clk_period") is not None
                    else float("inf"),
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
        llm_calls = self.llm.get_and_reset_api_calls()
        if self.logger:
            self.logger.log_generation(
                self.current_generation,
                new_offspring,
                gen_runtime,
                llm_calls,
                fail_rewards_this_gen,
                success_rewards_this_gen,
                self.fail_strategy_stats,
                self.success_strategy_stats,
                strategy_avg_selection_probabilities,
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
