import os
import re 
import uuid
import subprocess
import shutil 
import random
from openai import OpenAI, AsyncOpenAI, APIConnectionError, RateLimitError, InternalServerError, APITimeoutError # added for async support


import os
import subprocess
import re

import argparse

import multiprocessing
import datetime

import asyncio # added for async support for calling OpenAI API

# Imports for logging
import json
from collections import defaultdict
import numpy as np
import time

import math # Used for UCB calculation

import sys # Used for stream redirection


def find_module_name(verilog_code):
    """
    Parse Verilog code to find the module name.
    Useful as each problem has a different module name.
    Also, each benchmark have different conventions for module names.
    Example:
    - RTLLM: different module names for each problem (e.g. `accu`, ...)
    - VerilogEval-Code-Complete: module name is always `TopModule`
    """
    match = re.search(r'\bmodule\s+(\w+)', verilog_code)
    if match:
        return match.group(1)
    return None

# StreamRedirector class for systematic output redirection and error logging
# This class is used to redirect stdout and stderr to a file for each problem
# And then aggregate the outputs in a systematic way.
class StreamRedirector:
    """
    A context manager to redirect stdout and stderr to a file.
    This helps in capturing all outputs from a block of code, especially
    in a multiprocessing context where outputs can get jumbled.
    """
    def __init__(self, filepath):
        self.filepath = filepath
        self.original_stdout = sys.stdout
        self.original_stderr = sys.stderr
        self.log_file = None

    def __enter__(self):
        # Ensure the directory for the log file exists
        os.makedirs(os.path.dirname(self.filepath), exist_ok=True)
        # Open the log file in write mode
        self.log_file = open(self.filepath, 'w', encoding='utf-8')
        # Redirect stdout and stderr
        sys.stdout = self.log_file
        sys.stderr = self.log_file
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        # Flush the file and restore original stdout/stderr
        if self.log_file:
            self.log_file.flush()
        sys.stdout = self.original_stdout
        sys.stderr = self.original_stderr
        if self.log_file:
            self.log_file.close()

class EoHLogger:
    """
    Handles logging for the evolutionary coding process.
    Creates a detailed generation-by-generation log and a final summary for each problem.
    """
    def __init__(self, problem_name, benchmark_name, model_name, save_path, ref_ppa):
        self.problem_name = problem_name
        self.benchmark_name = benchmark_name
        self.model_name = model_name
        self.ref_ppa_metrics = ref_ppa or {}

        # Setup save paths
        model_name_cleaned = model_name.replace("/", "_")
        self.log_dir = os.path.join(save_path, model_name_cleaned, benchmark_name, problem_name)
        os.makedirs(self.log_dir, exist_ok=True)
        self.gen_log_path = os.path.join(self.log_dir, "generation_log.jsonl")
        self.summary_path = os.path.join(self.log_dir, f"{problem_name}_summary.json")

        # Initialize generation log file delete if it exists
        if os.path.exists(self.gen_log_path):
            os.remove(self.gen_log_path)

        # Data for final summary
        self.generation_stats_summary = []
        self.all_candidates_generated = set()
        self.all_syntax_passed = set()
        self.all_func_passed = set()
        self.all_synth_passed = set()
        self.total_llm_api_calls = 0
        self.strategy_counter = defaultdict(int)  # Accumulated across generations, count of how many times each strategy was used
        # Add attributes for tracking rewards and meta-strategies
        # Initialize rewards for fail and success pools as dictionaries with default float values(0.0)
        self.fail_pool_strategy_rewards = defaultdict(float)
        self.success_pool_strategy_rewards = defaultdict(float)
        self.meta_strategy_name = "random"  # Default meta-strategy name to be updated by engine

    def _calculate_ppa_stats(self, ppa_candidates):
        """Helper to calculate best/avg PPA metrics and scores for a list of candidates."""
        if not ppa_candidates:
            return {
                "best_score": None, "average_score": None,
                "best_metrics": {}, "average_metrics": {}
            }

        scores = [c.score for c in ppa_candidates]
        best_cand = max(ppa_candidates, key=lambda c: c.score)

        metrics = [c.ppa_metrics for c in ppa_candidates if c.ppa_metrics and all(isinstance(v, (int, float)) for v in c.ppa_metrics.values() if isinstance(v, (int, float)))]
        avg_metrics = {}
        if metrics:
            # Get all keys from all metrics dictionaries
            all_keys = set(key for m in metrics for key in m if isinstance(m[key], (int, float)))
            for key in all_keys:
                values = [m[key] for m in metrics if key in m]
                if values:
                    avg_metrics[key] = np.mean(values)

        return {
            "best_score": max(scores) if scores else None,
            "average_score": np.mean(scores) if scores else None,
            "best_metrics": best_cand.ppa_metrics if best_cand else {},
            "average_metrics": avg_metrics
        }

    def log_generation(self, generation_num, candidates_this_gen, runtime_sec, llm_calls_this_gen, fail_rewards_this_gen, success_rewards_this_gen, fail_strategy_stats, success_strategy_stats):
        """Logs the statistics for a single generation."""
        total_generated = len(candidates_this_gen)
        if total_generated == 0:
            print("Logger: No new candidates to log for this generation.")
            return

        # 1. Group candidates by strategy
        candidates_by_strategy = defaultdict(list)
        strategy_count_this_gen = defaultdict(int)
        for c in candidates_this_gen:
            candidates_by_strategy[c.strategy].append(c)
            strategy_count_this_gen[c.strategy] += 1
            self.strategy_counter[c.strategy] += 1  # accumulate

        # 2. Calculate total success rates
        total_syntax_success = sum(1 for c in candidates_this_gen if c.status != 'failed_syntax')
        total_func_success = sum(1 for c in candidates_this_gen if c.status != 'failed_syntax' and c.status != 'failed_functionality')
        total_synth_success = sum(1 for c in candidates_this_gen if c.status == 'success')

        # 3. Calculate strategy-wise success rates
        strategy_success_rates = {}
        for strategy, candidates in candidates_by_strategy.items():
            count = len(candidates)
            if count == 0: continue
            strategy_success_rates[strategy] = {
                "syntax": sum(1 for c in candidates if c.status != 'failed_syntax') / count,
                "functionality": sum(1 for c in candidates if c.status not in ['failed_syntax', 'failed_functionality']) / count,
                "synthesis_ppa": sum(1 for c in candidates if c.status == 'success') / count
            }

        # 4. Calculate generation-wide PPA stats
        ppa_candidates_this_gen = [c for c in candidates_this_gen if c.status == 'success']
        generation_ppa_stats = self._calculate_ppa_stats(ppa_candidates_this_gen)

        # 5. Calculate strategy-wise PPA stats
        strategy_ppa_stats = {}
        for strategy, candidates in candidates_by_strategy.items():
            ppa_cands = [c for c in candidates if c.status == 'success']
            if ppa_cands:
                strategy_ppa_stats[strategy] = self._calculate_ppa_stats(ppa_cands)

        # 6. Update accumulated strategy rewards for each pool
        for strategy, reward in fail_rewards_this_gen.items():
            self.fail_pool_strategy_rewards[strategy] += reward
        for strategy, reward in success_rewards_this_gen.items():
            self.success_pool_strategy_rewards[strategy] += reward

        # 7. Assemble log entry
        log_entry = {
            "generation": generation_num,
            "timestamp": datetime.datetime.now(datetime.timezone.utc).isoformat(),
            "runtime_seconds": runtime_sec,
            "llm_api_calls": llm_calls_this_gen,
            "strategy_counts_this_generation": dict(strategy_count_this_gen),
            "strategy_values_after_evolution": { 
                # Use fail_strategy_stats and success_strategy_stats, actual Q-values used to select strategies next generation
                # fail_strategy_stats and success_strategy_stats structure:
                # key: strategy name
                # value: dictionary {"count": 0, "value": 0.0}, 
                # count is how many times this strategy was used, value is the Q-value to be used for next generation selection
                # We want to only print the Q-values, not the counts.
                "fail_pool": {k: v["value"] for k, v in fail_strategy_stats.items()},
                "success_pool": {k: v["value"] for k, v in success_strategy_stats.items()}
            },
            "accumulated_strategy_rewards": {
                "fail_pool": dict(self.fail_pool_strategy_rewards),
                "success_pool": dict(self.success_pool_strategy_rewards)
            },
            "strategy_rewards_this_generation": {
                "fail_pool": dict(fail_rewards_this_gen),
                "success_pool": dict(success_rewards_this_gen)
            },
            "success_rates": {
                "total_syntax": total_syntax_success / total_generated if total_generated > 0 else 0,
                "total_functionality": total_func_success / total_generated if total_generated > 0 else 0,
                "total_synthesis_ppa": total_synth_success / total_generated if total_generated > 0 else 0
            },
            "strategy_success_rates": strategy_success_rates,
            "generation_ppa": generation_ppa_stats,
            "strategy_ppa": strategy_ppa_stats
        }

        # 8. Write to file and update accumulators
        def numpy_converter(o):
            if isinstance(o, (np.generic, np.ndarray)):
                return o.item() if o.size == 1 else o.tolist()
            if isinstance(o, float) and (np.isnan(o) or np.isinf(o)):
                return None
            return o

        with open(self.gen_log_path, 'a') as f:
            f.write(json.dumps(log_entry, default=numpy_converter) + '\n')

        self.total_llm_api_calls += llm_calls_this_gen
        self.generation_stats_summary.append({
            "generation": generation_num,
            "runtime_seconds": runtime_sec,
            "llm_api_calls": llm_calls_this_gen,
            "best_score": generation_ppa_stats.get("best_score"),
            "average_score": generation_ppa_stats.get("average_score")
        })
        for c in candidates_this_gen:
            self.all_candidates_generated.add(c.id)
            if c.status != 'failed_syntax': self.all_syntax_passed.add(c.id)
            if c.status not in ['failed_syntax', 'failed_functionality']: self.all_func_passed.add(c.id)
            if c.status == 'success': self.all_synth_passed.add(c.id)

    def finalize_summary(self, start_utc, end_utc, total_runtime_sec, total_generations, final_ppa_pool):
        """Calculates and writes the final problem summary."""
        # 1. Final PPA stats from the last generation's ppa_pool
        final_ppa_stats = self._calculate_ppa_stats(final_ppa_pool)

        # 2. Strategy-wise PPA for the final pool
        final_strategy_ppa_stats = {}
        if final_ppa_pool:
            candidates_by_strategy = defaultdict(list)
            for c in final_ppa_pool:
                candidates_by_strategy[c.strategy].append(c)
            for strategy, candidates in candidates_by_strategy.items():
                if candidates:
                    final_strategy_ppa_stats[strategy] = self._calculate_ppa_stats(candidates)

        # 3. Accumulated success rates across all generations
        total_unique_generated = len(self.all_candidates_generated)
        acc_rates = {"syntax": 0, "functionality": 0, "synthesis_ppa": 0}
        if total_unique_generated > 0:
            acc_rates["syntax"] = len(self.all_syntax_passed) / total_unique_generated
            acc_rates["functionality"] = len(self.all_func_passed) / total_unique_generated
            acc_rates["synthesis_ppa"] = len(self.all_synth_passed) / total_unique_generated

        # 4. Assemble summary data
        summary_data = {
            "problem_name": self.problem_name,
            "benchmark_name": self.benchmark_name,
            "model_name": self.model_name,
            "strategy_selection_method": self.meta_strategy_name,
            "start_time": start_utc.isoformat(),
            "end_time": end_utc.isoformat(),
            "total_runtime_seconds": total_runtime_sec,
            "total_llm_api_calls": self.total_llm_api_calls,
            "total_generations": total_generations,
            "total_candidates_generated": total_unique_generated,
            "accumulated_strategy_counts:": dict(self.strategy_counter),
            "accumulated_strategy_rewards": {
                "fail_pool": dict(self.fail_pool_strategy_rewards),
                "success_pool": dict(self.success_pool_strategy_rewards)
            },
            "accumulated_success_rates": acc_rates,
            "ref_ppa_metric": self.ref_ppa_metrics,
            "final_population_ppa": final_ppa_stats,
            "final_strategy_ppa": final_strategy_ppa_stats,
            "generation_statistics": self.generation_stats_summary,
        }

        # 5. Write to file
        def numpy_converter(o):
            if isinstance(o, (np.generic, np.ndarray)):
                return o.item() if o.size == 1 else o.tolist()
            if isinstance(o, float) and (np.isnan(o) or np.isinf(o)):
                return None
            return o

        with open(self.summary_path, 'w') as f:
            json.dump(summary_data, f, indent=2, default=numpy_converter)
        print(f"Final summary saved to: {self.summary_path}")


class SynthesisEvaluator:
    def __init__(self, yosys_path="yosys", openroad_path="openroad", pdk_path="./pdk"):
        self.yosys_path = yosys_path
        self.openroad_path = openroad_path
        self.pdk_path = pdk_path

        # Synthesis clk period in nanoseconds
        self.clk_period = 0.01  # ns

        # Get the directory where this script (main.py) is located.
        script_main_dir = os.path.dirname(os.path.abspath(__file__)) 
        # From there, construct the path to the 'script' directory (.../EoR/script)
        self.script_root_dir = os.path.abspath(os.path.join(script_main_dir, ".."))
        # The ref directory is inside the script root
        self.ref_dir_path = os.path.join(self.script_root_dir, "script", "ref")
        # The pdk directory is the same level as the script root
        self.pdk_path = os.path.abspath(os.path.join(self.script_root_dir, "pdk"))

        # Print directories for debugging
        # print(f"Script Main Directory: {script_main_dir}")
        # print(f"Script Root Directory: {self.script_root_dir}")
        # print(f"Reference Directory: {self.ref_dir_path}")
        # print(f"PDK Directory: {self.pdk_path}")

    def evaluate(self, verilog_file, problem_name, output_directory, report_base_path):
        """
        Performs synthesis and PPA analysis on a given Verilog file.
        The report files will be named based on `report_base_path`.
        """
        if not os.path.exists(output_directory):
            os.makedirs(output_directory)

        synthesis_success, synthesis_log = self._run_synthesis(verilog_file, problem_name, output_directory, report_base_path)

        if not synthesis_success:
            return {
                "synthesis_success": False,
                "ppa_success": False,
                "synthesis_log": synthesis_log,
                "ppa_metrics": None
            }

        ppa_metrics = self._parse_ppa_log(synthesis_log)

        return {
            "synthesis_success": True,
            "ppa_success": True,
            "synthesis_log": synthesis_log,
            "ppa_metrics": ppa_metrics
        }

    def _run_synthesis(self, verilog_file, problem_name, output_directory, report_base_path):
        """
        Runs the Yosys synthesis script.
        Synthesis report saved based on report_base_path.
        """

        clk_period = self.clk_period # ns

        # Extract the actual internal module name from the Verilog file
        module_name = find_module_name(open(verilog_file, 'r').read())

        sdc_file_path = self._create_sdc_file(verilog_file, module_name, output_directory, clk_period=clk_period)
        yosys_script_path = self._create_yosys_script(verilog_file, module_name, output_directory, clk_period)
        openroad_script_path = self._create_openroad_script(sdc_file_path, module_name, output_directory)

        report_path = report_base_path + "_synthesis_report.rpt" #os.path.join(output_directory, f"{problem_name}_synthesis_report.rpt")

        command = f"yosys {yosys_script_path} && openroad {openroad_script_path} | tee {report_path}"

        # log_path = os.path.join(output_directory, "yosys.log")

        process = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        if process.returncode == 0:
            print(f"Synthesis completed successfully. Report saved to {report_path}")
            return True, report_path
        else:
            print(f"Synthesis failed. Error: {process.stderr.decode()}")
            # Return the path to the report even on failure to aid debugging
            with open(report_path, "a") as f:
                f.write("\n\n--- SYNTHESIS FAILED ---\n")
                f.write(process.stderr.decode())
            return False, report_path
    
    def _create_sdc_file(self, verilog_file, module_name, output_directory, clk_period):
        """
        Creates a simple SDC file for timing constraints.
        """
        clk_ports = []
        clk_pattern = r'\b(clk|Clock|clock|Clk|CLK|CK|ck)\w*'

        with open(verilog_file, 'r') as inFile:
            lines = inFile.read().split(';')
            for line in lines:
                if f"module {module_name}" in line:
                    ob = line.find('(')
                    cb = line.rfind(')')
                    matches = re.findall(clk_pattern, line[ob:cb-1])
                    if matches:
                        clk_ports.extend(matches)
                    else:
                        clk_ports.append("f_clk")
                break

        sdc_lines = []
        sdc_lines.append(f"current_design {module_name}\n")
        sdc_lines.append(f"set clk_name clk\n")
        sdc_lines.append(f"set clk_period {clk_period}\n")
        for clk_port in clk_ports:
            sdc_lines.append(f"create_clock -name $clk_name -period $clk_period [get_ports {clk_port}]\n")

        sdc_gen = f"{output_directory}/{module_name}.sdc"
        with open(sdc_gen, 'w') as outfile:
            for sdc_line in sdc_lines:
                outfile.write(sdc_line)

        return sdc_gen

    def _create_yosys_script(self, verilog_file, module_name, output_directory, clk_period):
        yosys_ref = os.path.join(self.ref_dir_path, 'ref.yosys.tcl')
        yosys_gen = f'{output_directory}/{module_name}.yosys.tcl'

        with open(yosys_ref, 'r') as infile:
            with open(yosys_gen, 'w') as outfile:
                text = infile.read()
                text = text.replace("__VERILOG_FILE__", os.path.abspath(verilog_file))
                text = text.replace("__MODULE_NAME__", module_name) # Reverted to using module_name directly as we now extract it from the Verilog file
                text = text.replace("__OUTPUT_DIR__", os.path.abspath(output_directory))
                text = text.replace("__REF_DIR__", self.ref_dir_path)
                text = text.replace("__PDK_DIR__", os.path.abspath(self.pdk_path))
                text = text.replace("__CLK_PERIOD__", str(clk_period * 1000))
                outfile.write(text)

        return yosys_gen

    def _create_openroad_script(self, sdc_file_path, module_name, output_directory):
        # A simplified OpenROAD script. This may need to be adapted for your specific PDK and design.
        or_ref = os.path.join(self.ref_dir_path, 'ref.openroad.tcl')
        or_gen = f'{output_directory}/{module_name}.openroad.tcl'

        with open(or_ref, 'r') as infile:
            with open(or_gen, 'w') as outfile:
                text = infile.read()
                text = text.replace("__UTIL_DIR__", os.path.join(self.script_root_dir, "script", "util"))
                text = text.replace("__PDK_DIR__", os.path.abspath(self.pdk_path))
                text = text.replace("__DESIGN_NAME__", module_name)
                text = text.replace("__MODULE_NAME__", module_name) # Reverted to using module_name directly as we now extract it from the Verilog file
                text = text.replace("__NETLIST__", os.path.abspath(f'{output_directory}/{module_name}.syn.v'))
                text = text.replace("__SDC__", sdc_file_path)
                text = text.replace("__UTILIZATION__", str(0.5))
                outfile.write(text)

        return or_gen

    def _parse_ppa_log(self, report_path):
        """
        A simple parser for the OpenROAD log to extract PPA metrics.
        """
        tns, wns, power, area = None, None, None, None

        try:
            with open(report_path, 'r') as file:
                for line in file:
                    parts = line.split()
                    if not parts:  # Skip empty lines
                        continue

                    try:
                        # Handle TNS and WNS
                        if parts[0] == 'tns':
                            tns = float(parts[2] if parts[1] == 'max' else parts[1])
                        elif parts[0] == 'wns':
                            wns = float(parts[2] if parts[1] == 'max' else parts[1])
                        # Handle Power and Area
                        elif line.startswith('Total'):
                            power = float(parts[4])
                        elif line.startswith('Design area'):
                            area = float(parts[2])
                    except (ValueError, IndexError):
                        # Safely ignore lines that don't parse correctly
                        continue
        except FileNotFoundError:
            print(f"Error: PPA report file not found at {report_path}")
            return {"tns": None, "wns": None, "eff_clk_period": None, "power": None, "area": None, "report_path": None}

        # Calculate effective clock period only if wns was found
        eff_clk_period = None
        if wns is not None:
            eff_clk_period = self.clk_period - wns

        ppa_path = report_path.replace(".rpt", ".ppa")
        with open(ppa_path, 'w') as f:
            f.write('tns,wns,eff_clk_period,power,area\n')
            f.write(f'{tns},{wns},{eff_clk_period},{power},{area}')

        return {
            "tns": tns,
            "wns": wns,
            "eff_clk_period": eff_clk_period,
            "power": power,
            "area": area,
            "report_path": ppa_path
        }


class VerilogEvaluator:
    def __init__(self, iverilog_executable_path, vvp_executable_path):
        if not shutil.which(iverilog_executable_path):
            raise FileNotFoundError(
                f"Icarus Verilog executable (iverilog) not found or not executable at: {iverilog_executable_path}. "
                f"Please provide a valid absolute path or ensure it's in your system PATH."
            )
        self.iverilog_executable = iverilog_executable_path

        if not shutil.which(vvp_executable_path):
            raise FileNotFoundError(
                f"Icarus Verilog runtime (vvp) not found or not executable at: {vvp_executable_path}. "
                f"Please provide a valid absolute path or ensure it's in your system PATH."
            )
        self.vvp_executable = vvp_executable_path

        # Base flags for iverilog compilation
        self.base_iverilog_flags = ["-Wall", "-Winfloop", "-Wno-timescale", "-g2012"]

    def evaluate(self, generated_sv_file, test_sv_file, ref_sv_file,
                 top_module_name="tb", output_directory=None, simulation_timeout_seconds=60):
        """
        Compiles and simulates the given Verilog files.

        Args:
            generated_sv_file (str): Path to the generated Verilog file (DUT).
            test_sv_file (str): Path to the testbench Verilog file.
            ref_sv_file (str): Path to the reference Verilog file.
            top_module_name (str, optional): Name of the top-level Verilog module in the testbench. Defaults to "tb".
            output_directory (str, optional): Directory to store compiled outputs and logs.
                                             Defaults to the directory of generated_sv_file.
            simulation_timeout_seconds (int, optional): Timeout for the simulation run in seconds. Defaults to 30.

        Returns:
            dict: A dictionary containing the evaluation results:
                {
                    "status": "success" | "compilation_error" | "simulation_error" | "simulation_timeout" | "file_error",
                    "log_file_path": str,  // Path to the detailed log file
                    "compiled_file_path": str, // Path to the compiled .vvp file, None if compilation failed
                    "compilation_stdout": str,
                    "compilation_stderr": str,
                    "simulation_stdout": str, // Empty if simulation did not run or failed before output
                    "simulation_stderr": str  // Empty if simulation did not run or failed before output
                }
        """
        # --- 1. Determine paths and prepare ---
        if not os.path.isfile(generated_sv_file):
            return self._format_result("file_error", log_file_path=None, compiled_file_path=None,
                                     comp_stderr=f"Generated Verilog file not found: {generated_sv_file}")
        if not os.path.isfile(test_sv_file):
            return self._format_result("file_error", log_file_path=None, compiled_file_path=None,
                                     comp_stderr=f"Test Verilog file not found: {test_sv_file}")
        if not os.path.isfile(ref_sv_file):
            return self._format_result("file_error", log_file_path=None, compiled_file_path=None,
                                     comp_stderr=f"Reference Verilog file not found: {ref_sv_file}")

        if output_directory is None:
            actual_output_dir = os.path.dirname(generated_sv_file)
        else:
            actual_output_dir = output_directory
            os.makedirs(actual_output_dir, exist_ok=True)

        output_basename = os.path.splitext(os.path.basename(generated_sv_file))[0]
        compiled_vvp_file = os.path.join(actual_output_dir, output_basename + "_compiled.vvp")
        log_file = os.path.join(actual_output_dir, output_basename + "_simulation.log")

        # Initialize result components
        comp_stdout, comp_stderr = "", ""
        sim_stdout, sim_stderr = "", ""

        # --- 2. Compile Verilog files ---
        compile_cmd_list = [self.iverilog_executable]
        compile_cmd_list.extend(self.base_iverilog_flags)
        compile_cmd_list.extend(["-s", top_module_name]) # Specify top module
        compile_cmd_list.extend(["-o", compiled_vvp_file])
        compile_cmd_list.append(generated_sv_file)
        compile_cmd_list.append(test_sv_file)
        compile_cmd_list.append(ref_sv_file)

        print(f"INFO: Compile command: {' '.join(compile_cmd_list)}")
        with open(log_file, "w", encoding="utf-8") as lf:
            lf.write("--- Compilation Phase ---\n")
            lf.write(f"Command: {' '.join(compile_cmd_list)}\n\n")
            try:
                compile_process = subprocess.run(
                    compile_cmd_list,
                    capture_output=True,
                    text=True,
                    check=False # Do not raise exception on non-zero exit
                )
                comp_stdout = compile_process.stdout or ""
                comp_stderr = compile_process.stderr or ""

                lf.write(f"Return Code: {compile_process.returncode}\n")
                lf.write("Stdout:\n")
                lf.write(comp_stdout + "\n")
                lf.write("Stderr:\n")
                lf.write(comp_stderr + "\n")

                if compile_process.returncode != 0:
                    print(f"ERROR: Compilation failed. See {log_file} for details.")
                    return self._format_result("compilation_error", log_file, None,
                                             comp_stdout, comp_stderr)
                print(f"INFO: Compilation successful. Output: {compiled_vvp_file}")

            except FileNotFoundError:
                # This case should ideally be caught by __init__, but as a safeguard:
                error_msg = f"Icarus Verilog executable (iverilog) not found during compilation. Path: {self.iverilog_executable}"
                print(f"ERROR: {error_msg}")
                lf.write(f"CRITICAL ERROR: {error_msg}\n")
                return self._format_result("file_error", log_file, None, comp_stderr=error_msg)
            except Exception as e:
                error_msg = f"An unexpected error occurred during compilation: {e}"
                print(f"ERROR: {error_msg}")
                lf.write(f"CRITICAL ERROR: {error_msg}\n")
                return self._format_result("compilation_error", log_file, None, comp_stderr=error_msg)

            lf.write("\n--- Simulation Phase ---\n")
            # --- 3. Simulate the compiled VVP file ---
            # The compiled .vvp file is typically made executable by iverilog using a shebang
            # pointing to the vvp runtime.
            if os.name != 'nt': # On non-Windows systems, ensure it's executable
                try:
                    os.chmod(compiled_vvp_file, 0o755) # rwxr-xr-x
                except OSError as e:
                    print(f"WARNING: Could not set execute permission on {compiled_vvp_file}: {e}")
                    lf.write(f"WARNING: Could not set execute permission on {compiled_vvp_file}: {e}\n")


            # Execute using the vvp runtime directly
            run_cmd_list = [self.vvp_executable, compiled_vvp_file]
            print(f"INFO: Simulation command: {' '.join(run_cmd_list)}")
            lf.write(f"Command: {' '.join(run_cmd_list)}\n\n")

            # Set the working directory to the location of the testbench file (this is to include the miscellaneous files sometimes required by the testbench)
            # Some modules in RTLLM have files that supply the input and output files for the testbench
            # Examples: Prob013_test_data.dat, Prob026_asyn_fifo_tdata.txt, Prob026_asyn_fifo_rempty.txt, 
            # Prob026_asyn_fifo_wfull.txt, Prob035_calendar_reference.txt, Prob045_alu_reference.dat,
            # Prob049_signal_generator_tri_gen.txt
            simulation_working_dir = os.path.dirname(generated_sv_file)
            print(f"INFO: Running simulation in directory: {simulation_working_dir}")
            lf.write(f"Working Directory: {simulation_working_dir}\n\n")

            try:
                run_process = subprocess.run(
                    run_cmd_list,
                    capture_output=True,
                    text=True,
                    timeout=simulation_timeout_seconds,
                    check=False, # Do not raise exception on non-zero exit
                    cwd=simulation_working_dir  # Set the working directory for the simulation
                )
                sim_stdout = run_process.stdout or ""
                sim_stderr = run_process.stderr or ""

                lf.write(f"Return Code: {run_process.returncode}\n")
                lf.write("Stdout:\n")
                lf.write(sim_stdout + "\n")
                lf.write("Stderr:\n")
                lf.write(sim_stderr + "\n")

                if run_process.returncode == 0:
                    print(f"INFO: Simulation successful. See {log_file} for details.")
                    return self._format_result("success", log_file, compiled_vvp_file,
                                             comp_stdout, comp_stderr, sim_stdout, sim_stderr)
                else:
                    # Non-zero return code could be due to $finish(X) with X!=0, or runtime errors.
                    print(f"ERROR: Simulation finished with non-zero status ({run_process.returncode}). See {log_file} for details.")
                    return self._format_result("simulation_error", log_file, compiled_vvp_file,
                                             comp_stdout, comp_stderr, sim_stdout, sim_stderr)

            except subprocess.TimeoutExpired:
                timeout_msg = f"Simulation timed out after {simulation_timeout_seconds} seconds."
                print(f"ERROR: {timeout_msg}")
                lf.write(f"TIMEOUT ERROR: {timeout_msg}\n")
                # Capture any partial output before timeout
                # (Note: subprocess.run with timeout might not populate stdout/stderr for timed-out process easily)
                return self._format_result("simulation_timeout", log_file, compiled_vvp_file,
                                         comp_stdout, comp_stderr, sim_stderr=timeout_msg)
            except FileNotFoundError:
                # This case should ideally be caught by __init__, but as a safeguard:
                error_msg = f"vvp executable not found during simulation. Path: {self.vvp_executable}"
                print(f"ERROR: {error_msg}")
                lf.write(f"CRITICAL ERROR: {error_msg}\n")
                return self._format_result("file_error", log_file, compiled_vvp_file,
                                         comp_stdout, comp_stderr, sim_stderr=error_msg)
            except Exception as e:
                error_msg = f"An unexpected error occurred during simulation: {e}"
                print(f"ERROR: {error_msg}")
                lf.write(f"CRITICAL ERROR: {error_msg}\n")
                return self._format_result("simulation_error", log_file, compiled_vvp_file,
                                         comp_stdout, comp_stderr, sim_stderr=error_msg)

    def _format_result(self, status, log_file_path, compiled_file_path,
                       comp_stdout="", comp_stderr="", sim_stdout="", sim_stderr=""):
        """Helper method to format the return dictionary."""
        return {
            "status": status,
            "log_file_path": log_file_path,
            "compiled_file_path": compiled_file_path,
            "compilation_stdout": comp_stdout,
            "compilation_stderr": comp_stderr,
            "simulation_stdout": sim_stdout,
            "simulation_stderr": sim_stderr
        }

class LLMInterface:
    def __init__(self, api_key=None, model_name="gpt-3.5-turbo", max_retries=5, base_delay=2):
        if not api_key: 
            raise ValueError("API key is required for LLMInterface initialization.")
        
        self.api_key = api_key
        self.model_name = model_name
        self.max_retries = max_retries  # Maximum number of retries
        self.base_delay = base_delay    # Base delay in seconds for backoff

        self.api_call_count = 0  # Initialize API call counter
        self.lock = asyncio.Lock()  # Make counter thread-safe with async calls

        
    # Method for managing API call count in a thread-safe manner
    async def _increment_call_count(self, n=1):
        async with self.lock:
            self.api_call_count += n
    
    # Synchronous method that will be called my main engine thread
    def get_and_reset_api_calls(self):
        count = self.api_call_count
        self.api_call_count = 0  # Reset the counter after getting the value
        return count

    def parse_thought_and_code(self, response_text):
        thought_match = re.search(r"```thought\s*\n(.*?)\n```", response_text, re.DOTALL)
        code_match = re.search(r"```code\s*\n(.*?)\n```", response_text, re.DOTALL)

        thought = thought_match.group(1).strip() if thought_match else None
        code = code_match.group(1).strip() if code_match else None

        # When either thought or code is not found, we do not raise an exception.
        # Instead of raising exception ValueError for parsing issues or missing blocks,
        # we just return the original response text.
        # This allows the caller to handle the error gracefully, e.g., by logging it or
        # retrying with a different prompt.

        if thought is None or code is None:
            append_text = "\n\n--- WARNING: Parsing Issues ---\n"
            if thought is None:
                print(f"Warning: Could not parse 'thought' from LLM response. Expected ```thought ... ``` block. Response:\n{response_text[:500]}...")
                append_text += "Could not parse 'thought' from LLM response. Expected ```thought ... ``` block.(PARSE_ERROR)\n"
            if code is None:
                print(f"Warning: Could not parse 'code' from LLM response. Expected ```code ... ``` block. Response:\n{response_text[:500]}...")
                append_text += "Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)\n"

            # Append to the response text to indicate parsing issues
            response_text_with_issues = response_text + append_text
            return response_text_with_issues, response_text_with_issues
        else:
            return thought, code

    async def generate_response(self, prompt, temperature=1.0, top_p=1.0, max_tokens=2048):
        # print(f"\n--- LLM Request ---")
        # print(f"Prompt (first 200 chars):\n{prompt[:200]}...")
        # print(f"Model: {self.model_name}, Temperature: {temperature}, Max Tokens: {max_tokens}, Top P: {top_p}")

        full_response_text = ""
        
        system_prompt_content = (
            "You are an expert Verilog design assistant. "
            "Your role is to address Verilog-related problems posed by the user. "
            "For each problem, you must provide both a 'thought' and the corresponding 'code'. "
            "The 'thought' is your conceptual idea for solving the problem. "
            "The 'code' is the Verilog implementation of your 'thought'.\n"
            "Strictly format your response as follows:\n"
            "```thought\n"
            "[Your concise design idea (thought) here]\n"
            "```\n"
            "```code\n"
            "[Your complete, runnable Verilog implementation of the thought here]\n"
            "```"
        )
        
        # Use 'async with' to manage the client's lifecycle correctly
        async with AsyncOpenAI(api_key=self.api_key, timeout=120) as client:
            for attempt in range(self.max_retries):
                try:
                    # Increment the API call count
                    await self._increment_call_count()
                    chat_completion = await client.chat.completions.create(
                        messages=[
                            {
                                "role": "system",
                                "content": system_prompt_content,
                            },
                            {
                                "role": "user",
                                "content": prompt,
                            }
                        ],
                        model=self.model_name,
                        temperature=temperature,
                        max_tokens=max_tokens,
                        top_p=top_p 
                    )
                    full_response_text = chat_completion.choices[0].message.content.strip()
                    thought, code = self.parse_thought_and_code(full_response_text)
                    return thought, code

                except (APIConnectionError, RateLimitError, APITimeoutError, InternalServerError) as e:
                    print(f"OpenAI API call failed on attempt {attempt + 1}/{self.max_retries}: {e}")
                    if attempt + 1 == self.max_retries:
                        print("Max retries reached. Failing the request.")
                        return None, None
                    
                    delay = (self.base_delay * 2 ** attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)

                except Exception as e:
                    print(f"An unexpected, non-retriable error occurred in generate_response: {e}")
                    return None, None



    # This new method uses the 'n' parameter for more efficient batching of identical prompts.
    async def generate_n_responses(self, prompt, n, temperature=1.0, top_p=1.0, max_tokens=2048):
        """
        Generates 'n' different responses for a single prompt in a single API call.
        """
        print(f"\n--- Sending Single-Prompt Batch Request for {n} responses ---")

        system_prompt_content = (
            "You are an expert Verilog design assistant. "
            "Your role is to address Verilog-related problems posed by the user. "
            "For each problem, you must provide both a 'thought' and the corresponding 'code'. "
            "The 'thought' is your conceptual idea for solving the problem. "
            "The 'code' is the Verilog implementation of your 'thought'.\n"
            "Strictly format your response as follows:\n"
            "```thought\n"
            "[Your concise design idea (thought) here]\n"
            "```\n"
            "```code\n"
            "[Your complete, runnable Verilog implementation of the thought here]\n"
            "```"
        )

        async with AsyncOpenAI(api_key=self.api_key, timeout=120) as client:
            for attempt in range(self.max_retries):
                try:
                    # Increment the API call count
                    await self._increment_call_count(n)  # Increment by 'n' since we're requesting n completions
                    chat_completion = await client.chat.completions.create(
                        messages=[
                            {"role": "system", "content": system_prompt_content},
                            {"role": "user", "content": prompt}
                        ],
                        model=self.model_name,
                        n=n,  # Request n completions
                        temperature=temperature,
                        max_tokens=max_tokens,
                        top_p=top_p
                    )
                    
                    # Parse each of the 'n' choices in the response
                    parsed_results = []
                    for choice in chat_completion.choices:
                        full_response_text = choice.message.content.strip()
                        try:
                            thought, code = self.parse_thought_and_code(full_response_text)
                            parsed_results.append((thought, code))
                        except ValueError as e:
                            print(f"Warning: Failed to parse one of the initial responses: {e}")
                            # Debug
                            # print(f"\nSystem prompt: \n{system_prompt_content}")
                            # print(f"\nUser prompt: \n{prompt}")
                            # print(f"\nFull response text: \n{full_response_text}...")  # Print the text for context
                            parsed_results.append((None, None)) # Add a failure marker
                    
                    print("--- Single-Prompt Batch Response Received ---")
                    return parsed_results

                except (APIConnectionError, RateLimitError, APITimeoutError, InternalServerError) as e:
                    print(f"OpenAI API call failed on attempt {attempt + 1}/{self.max_retries}: {e}")
                    if attempt + 1 == self.max_retries:
                        print("Max retries reached. Failing the request.")
                        return [(None, None)] * n # Return failures
                    
                    # Exponential backoff with jitter
                    delay = (self.base_delay * 2 ** attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)
                    
                except Exception as e:
                    print(f"An unexpected, non-retriable error occurred in generate_n_responses: {e}")
                    return [(None, None)] * n


    async def generate_feedback(self, problem_def, verilog_code, simulation_log, temperature=1.0, top_p=1.0, max_tokens=2048):
        """
        Verilog 코드, 시뮬레이션 로그, 문제 정의를 LLM에 보내 코드의 오류를 분석하고 점수를 매기게 합니다.
        점수, 채점 이유, 분석 내용이 포함된 딕셔너리를 반환합니다.
        """
        # print(f"\n--- LLM Feedback Generation Request ---")
        # print(f"Verilog Code (first 200 chars):\n{verilog_code[:200]}...")
        # print(f"Simulation Log (first 500 chars):\n{simulation_log[:500]}...")
        # print(f"Model: {self.model_name}, Temperature: {temperature}, Max Tokens: {max_tokens}, Top P: {top_p}")

        # --- 시스템 프롬프트 수정 ---
        # 점수 채점 및 포맷팅 지침이 추가되었습니다.
        system_prompt_content = (
            "You are a Verilog debugging expert. You will be given a problem description, Verilog code, and a simulation failure log.\n"
            "First, use the problem description to understand the high-level design intent. "
            "Then, analyze the Verilog code and simulation log to pinpoint the exact code sections causing the errors. "
            "For each issue, explain the cause from the code's perspective, linking the low-level error back to the original design intent. "
            "Cite all relevant code sections.\n\n"
            
            "**CRITICAL RULE: Under no circumstances should you provide any solutions, fixes, or corrected code snippets. Your sole purpose is to analyze the existing code and identify the problems, not to solve them.**\n\n"
            
            "After your analysis, you **must** provide a score for the code on a scale of 0 to 10 based on the following criteria:\n"
            "* **10 points:** The code is perfect and passes all simulation tests.\n"
            "* **1-9 points:** The code is syntactically correct but fails simulation. The score should reflect the severity and number of functional errors found in the log.\n"
            "* **0 points:** The code has syntax errors and would not compile.\n\n"
            
            "Your entire response **must** strictly follow this format, using the provided tags. Do not add any text outside the tags:\n"
            "```text\n"
            "<SCORE>\n"
            "[Your score from 0 to 10]\n"
            "</SCORE>\n\n"
            "<JUSTIFICATION>\n"
            "[A brief, one or two-sentence justification for your score]\n"
            "</JUSTIFICATION>\n\n"
            "<ANALYSIS>\n"
            "[Your detailed analysis of the bug(s) as previously instructed. **Remember: Do NOT suggest any fixes or write corrected code in this section.**]\n"
            "</ANALYSIS>\n"
            "```"
        )
                
        user_prompt = (
            "I wrote some Verilog code to solve a given problem, but it failed the simulation. "
            "Please analyze the code and provide your feedback in the requested format.\n\n"
            "Problem Description:\n"
            "```problem\n"
            f"{problem_def}\n"
            "```\n\n"
            "Verilog Code:\n"
            "```verilog\n"
            f"{verilog_code}\n"
            "```\n\n"
            "Simulation Log:\n"
            "```log\n"
            f"{simulation_log}\n"
            "```\n\n"
        )

        async with AsyncOpenAI(api_key=self.api_key, timeout=120) as client:
            for attempt in range(self.max_retries):
                try:
                    # Increment the API call count
                    await self._increment_call_count()
                    chat_completion = await client.chat.completions.create(
                        messages=[
                            {"role": "system", "content": system_prompt_content},
                            {"role": "user", "content": user_prompt}
                        ],
                        model=self.model_name,
                        temperature=temperature,
                        max_tokens=max_tokens,
                        top_p=top_p
                    )
                    feedback_text = chat_completion.choices[0].message.content.strip()
                    # print("LLM Response Received. Parsing feedback...")
                    return self._parse_feedback_response(feedback_text)
                except (APIConnectionError, RateLimitError, APITimeoutError, InternalServerError) as e:
                    print(f"OpenAI API call for feedback failed on attempt {attempt + 1}/{self.max_retries}: {e}")
                    if attempt + 1 == self.max_retries:
                        print("Max retries reached. Failing the feedback request.")
                        return {
                            'score': 0,
                            'justification': 'LLM call for feedback failed after multiple retries.',
                            'analysis': f"Could not generate feedback due to a persistent API error: {e}"
                        }
                    
                    delay = (self.base_delay * 2 ** attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)

                except Exception as e:
                    print(f"An unexpected, non-retriable error occurred in generate_feedback: {e}")
                    return {
                        'score': 0,
                        'justification': 'An unexpected error occurred during the LLM call.',
                        'analysis': f"Could not generate feedback due to an unexpected error: {e}"
                    }
        return {
            'score': 0,
            'justification': 'LLM call for feedback failed.',
            'analysis': f"Could not generate feedback due to an API error: {e}"
        }
    
    def _parse_feedback_response(self, feedback_text):
        # Helper to parse the structured feedback response
        # This function extracts the score, justification, and analysis from the LLM response
        parsed_feedback = {
            'score': None,
            'justification': 'Parsing failed.',
            'analysis': feedback_text # Default to raw text if parsing fails
        }
        try:
            score_match = re.search(r'<SCORE>(.*?)</SCORE>', feedback_text, re.DOTALL)
            justification_match = re.search(r'<JUSTIFICATION>(.*?)</JUSTIFICATION>', feedback_text, re.DOTALL)
            analysis_match = re.search(r'<ANALYSIS>(.*?)</ANALYSIS>', feedback_text, re.DOTALL)

            if score_match:
                parsed_feedback['score'] = int(score_match.group(1).strip())
            if justification_match:
                parsed_feedback['justification'] = justification_match.group(1).strip()
            if analysis_match:
                parsed_feedback['analysis'] = analysis_match.group(1).strip()

        except Exception as e:
            print(f"Error parsing LLM feedback: {e}. Returning raw text.")

        return parsed_feedback

    # Method for batching code generation requests
    async def generate_batch_responses(self, prompts, temperature, top_p, max_tokens):
        """
        Generates responses for a batch of prompts concurrently.
        """
        print(f"\n--- Sending Batch LLM Request for {len(prompts)} prompts ---")
        tasks = [
            self.generate_response(prompt, temperature, top_p, max_tokens)
            for prompt in prompts
        ]
        results = await asyncio.gather(*tasks)
        print("--- Batch LLM Response Received ---")
        return results

    # Method for batching feedback generation requests
    async def generate_batch_feedback(self, feedback_requests, temperature, top_p, max_tokens):
        """
        Generates feedback for a batch of candidates concurrently.
        Each request is a dictionary with problem_def, verilog_code, and simulation_log.
        """
        print(f"\n--- Sending Batch LLM Feedback Request for {len(feedback_requests)} candidates ---")
        tasks = [
            self.generate_feedback(
                req['problem_def'], req['verilog_code'], req['simulation_log'],
                temperature, top_p, max_tokens
            ) for req in feedback_requests
        ]
        results = await asyncio.gather(*tasks)
        print("--- Batch LLM Feedback Received ---")
        return results


class Heuristic:
    def __init__(self, thought, code, feedback, score=0.0, generation=0, parent_ids=None, status="syntax", strategy="initial"):
        self.id = str(uuid.uuid4()) # Use UUID for unique ID
        self.thought = thought 
        self.code = code
        self.feedback = feedback # Feedback from LLM
        self.score = score
        self.generation = generation 
        self.parent_ids = parent_ids if parent_ids else [] 
        # New attributes for synthesis and PPA
        self.status = status # Status can be 'new', 'success', 'failed_syntax', 'failed_functionality', 'failed_synthesis'
        self.synthesis_success = False
        self.ppa_success = False
        self.ppa_metrics = {}
        # File path to the code for evaluation purposes
        self.code_file_path = ""
        self.strategy = strategy  # Strategy used to generate this heuristic, e.g., "initial", "M-F", "C-F", etc. (Total of 6 strategies + "initial")
        self.reward_from_parent = 0.0 # Reward obtained by the strategy that created this heuristic

    def __repr__(self):
        thought_repr = self.thought[:50] 
        ppa_info = "PPA: Not run or failed"
        if self.ppa_success and self.ppa_metrics:
            # Format PPA metrics for cleaner display
            clk = self.ppa_metrics.get('eff_clk_period')
            area = self.ppa_metrics.get('area')
            power = self.ppa_metrics.get('power')
            ppa_str = f"Eff. Clk: {clk:.4f}ns, Area: {area:.2f}, Power: {power:.4e}"
            ppa_info = f"PPA: ({ppa_str})"
        return (f"Heuristic(ID: {self.id}, Gen: {self.generation}, Strategy: {self.strategy}, Score: {self.score:.4f}, "
                f"Status: {self.status}, Thought: '{thought_repr}...', Parents: {self.parent_ids}, {ppa_info})")

# Entire class executing for the new REvolution framework for each problem in the benchmark.
class EoHEngine:
    def __init__(self, benchmark_name, problem_name, llm_interface, verilog_evaluator, synthesis_evaluator,
                 population_size=10, num_generations=5,
                 default_llm_temp=1.0, default_llm_top_p=0.95, default_llm_max_tokens=2048, base_save_path=None,
                 strategy_selection_method="random", epsilon=0.1, ucb_c=2.0):

        self.base_save_path = base_save_path if base_save_path else os.path.join(os.getcwd(), "verilog_eoh_results")
        self.benchmark_name = benchmark_name
        self.problem_name = problem_name
        self.benchmark_path = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "bench", self.benchmark_name))
        self.problem_description = self.load_problem_description()
        self.llm = llm_interface
        self.evaluator = verilog_evaluator
        self.synthesis_evaluator = synthesis_evaluator
        self.population_size = population_size
        self.num_offspring_lambda = population_size  # λ, number of offspring to generate
        self.num_generations = num_generations
        self.default_llm_temp = default_llm_temp
        self.default_llm_top_p = default_llm_top_p
        self.default_llm_max_tokens = default_llm_max_tokens
        self.clk_period = synthesis_evaluator.clk_period

        # Simplified to two population pools
        self.fail_pool = []
        self.success_pool = []

        # Add attributes for dynamic strategy selection using meta-strategies
        # Formulate problem of picking which strategy to use as a multi-armed bandit problem
        self.strategy_selection_method = strategy_selection_method  # "random", "epsilon-greedy", "ucb"
        self.epsilon = epsilon  # For epsilon-greedy strategy (default 0.1)
        self.ucb_c = ucb_c  # Exploration parameter for UCB strategy (default 2.0)

        self.fail_strats = ["M-F", "M-S", "M-E", "M-R", "M-I"]
        self.success_strats = ["M-S", "M-E", "M-R", "M-I", "C-F"]

        self.fail_strategy_stats = {s: {'count': 0, 'value': 0.0} for s in self.fail_strats}
        self.success_strategy_stats = {s: {'count': 0, 'value': 0.0} for s in self.success_strats} 
        
        self.current_generation = 0
        self.ref_ppa_metrics = {}
        self.logger = None
        self.run_start_time = 0
        self.run_start_utc = None
        self.gen_start_time = 0

    def load_problem_description(self):
        prompt_path = os.path.join(self.benchmark_path, f"{self.problem_name}_prompt.txt")
        if os.path.exists(prompt_path):
            with open(prompt_path, "r") as f:
                return f.read().strip()
        else:
            raise FileNotFoundError(f"Problem description file not found: {prompt_path}")

    def _copy_misc_files(self, output_directory):
        misc_files = [f for f in os.listdir(self.benchmark_path) if f.startswith(self.problem_name) and not f.endswith(('_makefile','_ifc.txt', '_ppa.txt', '_prompt.txt', '_ref.sv', '_test.sv'))]
        for file_name in misc_files:
            source_path = os.path.join(self.benchmark_path, file_name)
            dest_path = os.path.join(output_directory, file_name)
            if not os.path.exists(dest_path):
                shutil.copy(source_path, dest_path)

    def _save_result_to_file(self, code_content, thought_content, generation_num, sample_idx_in_generation, strategy=None):
        model_name_cleaned = self.llm.model_name.replace("/", "_")
        directory_path = os.path.join(self.base_save_path, model_name_cleaned, self.benchmark_name, self.problem_name, f"Gen{generation_num}")
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
        ref_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_ref.sv")
        if not os.path.exists(ref_sv_file):
            print(f"WARNING: Reference Verilog file not found. Using default high PPA values.")
            self.ref_ppa_metrics = {"tns": 0.0, "wns": 0.0, "eff_clk_period": self.clk_period, "area": 1e6, "power": 1.0}
            return
        
        ref_output_dir = os.path.join(self.base_save_path, "reference_synthesis", self.benchmark_name, self.problem_name)
        ref_report_base_path = os.path.join(ref_output_dir, f"{self.problem_name}_ref")
        synthesis_results = self.synthesis_evaluator.evaluate(ref_sv_file, self.problem_name, ref_output_dir, ref_report_base_path)

        if synthesis_results and synthesis_results.get("ppa_success"):
            self.ref_ppa_metrics = synthesis_results["ppa_metrics"]
            print(f"Reference PPA calculated successfully: {self.ref_ppa_metrics}")
        else:
            print("WARNING: Reference PPA synthesis failed. Using default high values.")
            self.ref_ppa_metrics = {"tns": 0.0, "wns": 0.0, "eff_clk_period": self.clk_period, "area": 1e6, "power": 1.0}

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
            print(f"Warning: Missing PPA values for {candidate.id} or reference. Assigning low fitness.")
            return 0

        # Avoid division by zero for reference values
        P_ref = P_ref if P_ref > 1e-12 else 1e-12
        A_ref = A_ref if A_ref > 1e-12 else 1e-12
        T_ref = T_ref if T_ref > 1e-12 else 1e-12

        power_improvement = (P_gen - P_ref) / P_ref
        area_improvement = (A_gen - A_ref) / A_ref
        
        # A non-zero TNS or WNS in reference implies a sequential circuit for this calculation
        # Combinatorial circuits will have TNS and WNS as 0, and eff_clk_period of 0
        is_sequential = (self.ref_ppa_metrics.get("tns", 0) != 0 or self.ref_ppa_metrics.get("wns", 0) != 0 or self.ref_ppa_metrics.get("eff_clk_period", 0) != 0)

        if is_sequential:
            timing_improvement = (T_gen - T_ref) / T_ref
            total_improvement = (power_improvement + area_improvement + timing_improvement) / 3
        else: # Combinational
            total_improvement = (power_improvement + area_improvement) / 2
            
        # Fitness is maximized, and lower improvement % is better. So, fitness = -improvement.
        return -total_improvement

    def _save_feedback_files(self, candidate, feedback):
        """Helper to save feedback files for a failed candidate."""
        base_path = candidate.code_file_path.rsplit('.', 1)[0]
        feedback_file_path = f"{base_path}_feedback.txt"
        with open(feedback_file_path, "w") as f:
            f.write(f"Score: {feedback.get('score', 'N/A')}\nJustification: {feedback.get('justification', 'N/A')}\n\nANALYSIS:\n{feedback.get('analysis', '')}")

    def _evaluate_candidates(self, candidates_to_evaluate):
        """
        Evaluates a list of new candidates through the full pipeline (syntax, func, synth).
        Updates each candidate object with its final status, feedback, and score.
        """
        if not candidates_to_evaluate: return

        print(f"\n--- Evaluating {len(candidates_to_evaluate)} New Candidates ---")
        test_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_test.sv")
        ref_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_ref.sv")
        
        func_passed, func_failed, feedback_requests = [], [], []

        # Stage 1: Functional Simulation
        for cand in candidates_to_evaluate:
            sim_results = self.evaluator.evaluate(cand.code_file_path, test_sv_file, ref_sv_file)
            
            if sim_results['status'] == 'compilation_error':
                cand.status = 'failed_syntax'
                log = sim_results.get("compilation_stderr", "Compilation log not available.")
            else:
                is_success = False
                if sim_results['status'] == 'success':
                    output = sim_results.get('simulation_stdout', '')
                    m_match = re.search(r'^Mismatches: (\d+)', output, re.M)
                    # Check for simulation success based on output in two ways:
                    # Case 1: Check for "Mismatches: X in Y samples" in simulation output (VerilogEvalv2 format)
                    # This regex matches the expected output format from VerilogEval
                    # It captures the number of mismatches in the first group.
                    # If there are no mismatches (X==0), it means the design is functionally correct.
                    # Case 2: Check for "===========Your Design Passed===========" in simulation output (RTLLMv2 format)
                    if (m_match and int(m_match.group(1)) == 0) or "===========Your Design Passed===========" in output:
                        is_success = True
                
                if is_success:
                    func_passed.append(cand)
                    continue
                else:
                    cand.status = 'failed_functionality'
                    log = f"Compilation Log:\n{sim_results.get('compilation_stderr')}\n\nSimulation Log:\n{sim_results.get('simulation_stdout')}\n{sim_results.get('simulation_stderr')}"

            # If we reach here, the candidate has failed syntax or functionality
            cand.score = -float('inf')
            feedback_requests.append({'problem_def': self.problem_description, 'verilog_code': cand.code, 'simulation_log': log})
            func_failed.append(cand)

        # Stage 2: Synthesis and PPA for functionally correct candidates
        for cand in func_passed:
            report_base_path = cand.code_file_path.rsplit('.', 1)[0]
            output_dir = os.path.dirname(cand.code_file_path)
            synth_results = self.synthesis_evaluator.evaluate(cand.code_file_path, self.problem_name, output_dir, report_base_path)

            if synth_results["synthesis_success"] and synth_results["ppa_success"]:
                cand.status = 'success'
                cand.synthesis_success = True
                cand.ppa_success = True
                cand.ppa_metrics = synth_results["ppa_metrics"]
                cand.score = self._calculate_fitness_score(cand)
                cand.feedback = f"Synthesis successful. PPA score: {cand.score:.4f}"
            else:
                cand.status = 'failed_synthesis'
                cand.score = -float('inf')
                cand.synthesis_success = False
                log = f"Functionality OK, but synthesis failed.\nLog:\n{synth_results.get('synthesis_log', 'N/A')}"
                feedback_requests.append({'problem_def': self.problem_description, 'verilog_code': cand.code, 'simulation_log': log})
                func_failed.append(cand)

        # Stage 3: Batch LLM Feedback Generation for all failures
        if feedback_requests:
            print(f"Requesting LLM feedback for {len(func_failed)} failed candidates...")
            feedback_results = asyncio.run(self.llm.generate_batch_feedback(feedback_requests, self.default_llm_temp, self.default_llm_top_p, self.default_llm_max_tokens))
            for cand, feedback_data in zip(func_failed, feedback_results):
                cand.feedback = feedback_data.get('analysis', 'Feedback generation failed.')
                self._save_feedback_files(cand, feedback_data)

    # Prompt generation functions for the 6 new strategies
    def _format_parent_for_prompt(self, parent, example_num=1):
        """Helper to format a parent candidate for inclusion in a prompt."""
        parent_prompt = (f"<Example {example_num}>:\n"
                         f"```thought\n{parent.thought}\n```\n"
                         f"```code\n{parent.code}\n```\n"
                         f"```feedback\n{parent.feedback}\n```\n")
        if parent.ppa_success:
            parent_prompt += f"```ppa_metrics\n{json.dumps(parent.ppa_metrics, indent=2)}\n```\n"
        return parent_prompt

    def _create_prompt_M_F(self, parents): # Fix
        parent_info = self._format_parent_for_prompt(parents[0])
        return (f"{self.problem_description}\n\nThe following attempt failed. Use the feedback to fix it.\n\n"
                f"{parent_info}\nYour task is to fix the code based on the feedback. Provide a new thought process explaining the fix and the corrected code.")

    def _create_prompt_M_S(self, parents): # Simplify
        parent_info = self._format_parent_for_prompt(parents[0])
        return (f"{self.problem_description}\n\nHere is a previous solution.\n\n{parent_info}\n"
                f"Your task is to simplify this solution. Reduce complexity while maintaining functionality. Provide your simplified thought and code.")

    def _create_prompt_M_E(self, parents): # Explore
        parent_info = self._format_parent_for_prompt(parents[0])
        return (f"{self.problem_description}\n\nHere is one approach.\n\n{parent_info}\n"
                f"Your task is to generate a completely new and different solution. Come up with a novel architectural idea. Describe your new idea and provide the code.")

    def _create_prompt_M_R(self, parents): # Refactor
        parent_info = self._format_parent_for_prompt(parents[0])
        return (f"{self.problem_description}\n\nHere is a solution.\n\n{parent_info}\n"
                f"Your task is to refactor this code. The core idea must be the same, but implement it with a different structure (e.g., use `assign` instead of `always`, restructure a state machine). Explain the refactoring and provide the new code.")

    def _create_prompt_M_I(self, parents): # Improve
        parent_info = self._format_parent_for_prompt(parents[0])
        return (f"{self.problem_description}\n\nHere is a solution.\n\n{parent_info}\n"
                f"Your task is to improve this solution. If it failed, make it correct. If it succeeded, optimize it for better PPA based on its metrics. Describe your improvement strategy and provide the improved code.")

    def _create_prompt_C_F(self, parents): # Fusion
        parent1_info = self._format_parent_for_prompt(parents[0], 1)
        parent2_info = self._format_parent_for_prompt(parents[1], 2)
        return (f"{self.problem_description}\n\nHere are two different successful solutions.\n\n{parent1_info}\n{parent2_info}\n"
                f"Your task is to create a superior solution by fusing the best ideas from both examples. Analyze their strengths and combine them. Explain your fusion strategy and provide the new code.")

    def initialize_population(self):
        """Creates and evaluates the initial population."""
        print(f"\n--- Initializing Population (Size: {self.population_size}) ---")
        self.gen_start_time = time.time()
        
        results = asyncio.run(self.llm.generate_n_responses(
            prompt=self.problem_description, n=self.population_size,
            temperature=self.default_llm_temp, top_p=self.default_llm_top_p, max_tokens=self.default_llm_max_tokens
        ))

        initial_candidates = []
        for i, (thought, code) in enumerate(results):
            if thought and code:
                code_path, _ = self._save_result_to_file(code, thought, 0, i + 1, "initial")
                cand = Heuristic(thought, code, "", generation=0, strategy="initial")
                cand.code_file_path = code_path
                initial_candidates.append(cand)
        
        if not initial_candidates:
            print("WARNING: No valid candidates generated during initialization. Check LLM responses.")
            print(f"LLM Responses: {results}")
            raise RuntimeError("Failed to generate any valid candidates during initialization.")

        self._evaluate_candidates(initial_candidates)
        
        for cand in initial_candidates:
            if cand.status == 'success':
                self.success_pool.append(cand)
            else:
                self.fail_pool.append(cand)
        
        gen0_runtime = time.time() - self.gen_start_time
        llm_calls = self.llm.get_and_reset_api_calls()
        self.logger.log_generation(0, initial_candidates, gen0_runtime, llm_calls, {}, {}, self.fail_strategy_stats, self.success_strategy_stats) # No rewards for initial generation

        print(f"--- Initial Population Processed. Success: {len(self.success_pool)}, Fail: {len(self.fail_pool)} ---")
        if self.success_pool:
            self.success_pool.sort(key=lambda c: c.score, reverse=True)
            print(f"Best initial candidate: {self.success_pool[0]}")

    def _select_strategy(self, pool_type, available_strategies):
        """Selects a strategy based on the chosen multi-armed bandit algorithm."""
        if not available_strategies:
            print(f"No available strategies for pool type '{pool_type}'. Returning None.")
            return None

        stats_dict = self.fail_strategy_stats if pool_type == 'fail' else self.success_strategy_stats
        method = self.strategy_selection_method

        if method == "random":
            return random.choice(available_strategies)

        elif method == "epsilon-greedy":
            if random.random() < self.epsilon:
                return random.choice(available_strategies)
            else:
                # Select the best-performing strategy from those available
                # Break ties randomly in case of multiple strategies with the same score
                max_score = max(stats_dict[s]["value"] for s in available_strategies)
                best_strategies = [s for s in available_strategies if stats_dict[s]["value"] == max_score]
                if len(best_strategies) > 1:
                    return random.choice(best_strategies)
                else:
                    # If only one best strategy, return it
                    return best_strategies[0] if best_strategies else random.choice(available_strategies)

        elif method == "ucb":
            # --- Initialization Phase ---
            # Identify all strategies that have not been selected yet.
            untried_strategies = [s for s in available_strategies if stats_dict[s]["count"] == 0]

            # If there are untried strategies, randomly select one. This ensures that for the
            # first evolution, strategies are selected as evenly as possible, and each
            # strategy is guaranteed to be chosen once before moving to exploration.
            if untried_strategies:
                return random.choice(untried_strategies)
            elif self.current_generation == 0:
                # If we are still in the first generation and all strategies have been tried,
                # we can randomly select one as evaluation hasn't been done yet.
                # So rewards are not available.
                return random.choice(available_strategies)

            # --- Exploration Phase (Standard UCB) ---
            # Once all strategies have been tried at least once, use the UCB formula.
            total_pulls = sum(stats_dict[s]["count"] for s in available_strategies)
            ucb_scores = {}
            for strat in available_strategies:
                avg_reward = stats_dict[strat]["value"]
                exploration_term = self.ucb_c * math.sqrt(math.log(total_pulls) / stats_dict[strat]["count"])
                ucb_scores[strat] = avg_reward + exploration_term
            
            # Return the strategy with the highest UCB score
            # Need to break ties randomly if multiple strategies have the same score
            max_score = max(ucb_scores.values())
            best_strategies = [s for s, score in ucb_scores.items() if score == max_score]
            if len(best_strategies) > 1:
                return random.choice(best_strategies)
            else:
                return max(ucb_scores, key=ucb_scores.get)

        else: # Fallback to random
            return random.choice(available_strategies)


    def evolve_one_generation(self):
        """Performs one generation of the REvolution algorithm."""
        self.current_generation += 1
        print(f"\n--- Starting Generation {self.current_generation} ---")
        self.gen_start_time = time.time()

        strategies = {"M-F": {"func": self._create_prompt_M_F, "num_parents": 1},
                      "M-S": {"func": self._create_prompt_M_S, "num_parents": 1},
                      "M-E": {"func": self._create_prompt_M_E, "num_parents": 1},
                      "M-R": {"func": self._create_prompt_M_R, "num_parents": 1},
                      "M-I": {"func": self._create_prompt_M_I, "num_parents": 1},
                      "C-F": {"func": self._create_prompt_C_F, "num_parents": 2}}
        # fail_strats, success_strats = ['M-F','M-S','M-E','M-R','M-I'], ['M-S','M-E','M-R','M-I','C-F']

        total_current_pop = len(self.fail_pool) + len(self.success_pool)
        if total_current_pop == 0: 
            return "STOP"

        num_from_fail = round(self.num_offspring_lambda * len(self.fail_pool) / total_current_pop)
        num_from_success = self.num_offspring_lambda - num_from_fail

        prompts, metadata = [], []

        # Generate from Fail Pool
        if self.fail_pool:
            for _ in range(num_from_fail):
                strat_name = self._select_strategy("fail", self.fail_strats)
                parents = random.choices(self.fail_pool, k=strategies[strat_name]["num_parents"])
                prompts.append(strategies[strat_name]["func"](parents))
                metadata.append({"parents": parents, "strategy": strat_name, "pool": "fail"})
        
        # Generate from Success Pool
        if self.success_pool:
            available_success_strategies = self.success_strats.copy()
            # First check if we have enough candidates in the success pool for the strategy that requires fusion
            if len(self.success_pool) < 2:
                available_success_strategies.remove("C-F")
            for _ in range(num_from_success):
                strat_name = self._select_strategy("success", available_success_strategies)
                # Weighted selection for success pool
                weights = [c.score - min(p.score for p in self.success_pool) + 0.1 for c in self.success_pool]
                parents = random.choices(self.success_pool, weights=weights, k=strategies[strat_name]["num_parents"])
                # print(f'Debug: Selected parents {parents} for strategy {strat_name} with weights {weights} with available strategies {available_strategies}')
                prompts.append(strategies[strat_name]["func"](parents))
                metadata.append({"parents": parents, "strategy": strat_name, "pool": "success"})

        if not prompts: 
            return "STOP"

        llm_results = asyncio.run(self.llm.generate_batch_responses(prompts, self.default_llm_temp, self.default_llm_top_p, self.default_llm_max_tokens))
        
        new_offspring = []
        for i, (thought, code) in enumerate(llm_results):
            if thought and code:
                meta = metadata[i]
                code_path, _ = self._save_result_to_file(code, thought, self.current_generation, i + 1, meta["strategy"])
                cand = Heuristic(thought, code, "", self.current_generation, [p.id for p in meta["parents"]], strategy=meta["strategy"])
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
            parent = meta["parents"][0] # For simplicity, use the first parent for comparison
            cand_parents = meta["parents"] # Could either be a single parent or two parents for fusion
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
                    if parent1.status == "success" and parent2.status == "success" and cand.status == "success":
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
            stats_dict = self.fail_strategy_stats if parent_pool_type == "fail" else self.success_strategy_stats

            s = stats_dict[strategy_name]
            s["count"] += 1  # Increment the count of times this strategy was used
            s["value"] = s["value"] + (reward - s["value"]) / (s["count"])

        # Survivor Selection (Elitism)
        candidate_pool = self.success_pool + new_offspring
        # Shuffle the candidate pool to ensure diversity
        random.shuffle(candidate_pool)
        candidate_pool.sort(key=lambda c: c.score, reverse=True)
        next_gen_population = candidate_pool[:self.population_size]

        # Population Redivision
        self.fail_pool.clear()
        self.success_pool.clear()
        for cand in next_gen_population:
            if cand.status == 'success':
                self.success_pool.append(cand)
            else:
                self.fail_pool.append(cand)

        gen_runtime = time.time() - self.gen_start_time
        llm_calls = self.llm.get_and_reset_api_calls()
        if self.logger:
            self.logger.log_generation(self.current_generation, new_offspring, gen_runtime, llm_calls, fail_rewards_this_gen, success_rewards_this_gen, self.fail_strategy_stats, self.success_strategy_stats)

        print(f"--- Gen {self.current_generation} Complete. Pools: Success({len(self.success_pool)}), Fail({len(self.fail_pool)}) ---")
        if self.success_pool:
            print(f"Best candidate: {self.success_pool[0]}")
        return None

    def run(self):
        """Main entry point to run the evolutionary framework."""
        print(f"--- Starting REvolution Run: Problem '{self.benchmark_name}/{self.problem_name}' ---")
        self.run_start_time = time.time()
        self.run_start_utc = datetime.datetime.now(datetime.timezone.utc)

        try:
            self._calculate_reference_ppa()
            self.logger = EoHLogger(self.problem_name, self.benchmark_name, self.llm.model_name, self.base_save_path, self.ref_ppa_metrics)
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
            self.logger.finalize_summary(self.run_start_utc, end_utc, total_runtime, self.current_generation, self.success_pool)

        if self.success_pool:
            best_solution = self.success_pool[0]
            print(f"Final Best Solution Found:\n{best_solution}")
            final_report = best_solution.ppa_metrics.get("report_path", "N/A")
            final_score = best_solution.score if best_solution.score is not None else "N/A"
            # # Debug print success pool
            # print(f"Success Pool: {[str(c) for c in self.success_pool]}")
            return f"{self.problem_name},success,{best_solution.code_file_path},{final_report},{final_score}"
        else:
            print("No functionally correct and synthesizable solution found.")
            return f"{self.problem_name},failed"
        
    
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
    problem_log_dir = os.path.join(args.save_path, model_name_cleaned, benchmark, problem)
    # The EoHEngine will create this directory, but we ensure it exists early.
    os.makedirs(problem_log_dir, exist_ok=True)
    individual_log_path = os.path.join(problem_log_dir, "problem_run.log")
    

    # Redirect all output from this worker to the individual log file
    with StreamRedirector(filepath=individual_log_path):
            
        print(f"\n[Worker PID: {os.getpid()}] Starting problem: {benchmark}/{problem}\n")
        
        # Initialize objects within the worker process to avoid pickling issues
        llm_interface = LLMInterface(api_key=os.getenv("OPENAI_API_KEY"), model_name=args.model_name)
        verilog_evaluator = VerilogEvaluator(iverilog_executable_path=IVERILOG_EXECUTABLE, vvp_executable_path=VVP_EXECUTABLE)
        synthesis_evaluator = SynthesisEvaluator()

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
            ucb_c=args.ucb_c
        )
        result_str = eoh_engine.run()
        # Return the result string and the path to the individual log file created for this problem
        print(f"[Worker PID: {os.getpid()}] Finished problem: {benchmark}/{problem}\n")
    return result_str, individual_log_path

if __name__ == "__main__":
    # MODIFIED: Use argparse to make the script configurable
    parser = argparse.ArgumentParser(description="Run the EoH framework on specified Verilog benchmarks.")
    
    # List of all available benchmarks in the 'bench' directory
    # Current benches: ['RTLLM', 'VerilogEval-Code-Complete', 'VerilogEval-Spec-to-RTL']
    benchmark_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'bench'))
    available_benchmarks = [d for d in os.listdir(benchmark_root) if os.path.isdir(os.path.join(benchmark_root, d))]
    
    parser.add_argument(
        '--benchmarks',
        nargs='+',
        default=available_benchmarks,
        choices=available_benchmarks,
        help=f'A list of benchmark suites to run. Default is all available. Choices: {available_benchmarks}'
    )
    parser.add_argument('--problems', nargs='+',
                        help='A list of specific problem names to run. If not provided, all problems in the suite will be run.')
    parser.add_argument('--model_name', type=str, default="gpt-4.1-mini", help='Name of the OpenAI model to use.')
    parser.add_argument('--population_size', type=int, default=5, help='Number of candidates in each generation.')
    parser.add_argument('--num_generations', type=int, default=5, help='Number of evolutionary generations to run.')
    parser.add_argument('--save_path', type=str, default=os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "exp")), help='Base path to save results.') # Default is ./exp, defined relative to main.py
    parser.add_argument('--num_workers', type=int, default=10, help='Number of parallel processes to use.')
    parser.add_argument('--temperature', type=float, default=1.0)
    parser.add_argument('--top_p', type=float, default=0.95)
    parser.add_argument('--max_tokens', type=int, default=2048)
    parser.add_argument('--strategy_selection', type=str, default='random', choices=['random', 'epsilon-greedy', 'ucb'],
                        help='The meta-strategy for selecting genetic operators.')
    parser.add_argument('--epsilon', type=float, default=0.1,
                        help='The exploration factor for the epsilon-greedy strategy.')
    parser.add_argument('--ucb_c', type=float, default=2.0,
                        help='The exploration constant (c) for the UCB strategy.')


    args = parser.parse_args()

    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
    IVERILOG_EXECUTABLE = "/project/cad-team/LX_Semicon/kjmin/iverilog/install/bin/iverilog"
    VVP_EXECUTABLE = "/project/cad-team/LX_Semicon/kjmin/iverilog/install/bin/vvp"
    YOSYS_EXECUTABLE = "/project/cad-team/LX_Semicon/kmcho/yosys/yosys"
    OPENROAD_EXECUTABLE = "/project/cad-team/LX_Semicon/kjmin/openroad/install/bin/openroad"

    try:
        if not OPENAI_API_KEY:
            raise ValueError("A valid OpenAI API key must be set in the environment variable OPENAI_API_KEY.")
        # llm_interface = LLMInterface(api_key=OPENAI_API_KEY, model_name=args.model_name)
    except (ValueError, RuntimeError) as e:
        print(f"LLM Initialization Error: {e}")
        exit(1)
        
    # verilog_evaluator = VerilogEvaluator(iverilog_executable_path=IVERILOG_EXECUTABLE, vvp_executable_path=VVP_EXECUTABLE)
    # synthesis_evaluator = SynthesisEvaluator()


    # Main execution block now handles comprehensive, aggregated logging
    # --- Task Preparation ---
    run_datetime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    start_time = time.time()
    model_name_cleaned = args.model_name.replace("/", "_")
    # Define path for the new comprehensive log file for the entire run
    master_log_dir = os.path.join(args.save_path, model_name_cleaned)
    comprehensive_log_path = os.path.join(master_log_dir, f"{run_datetime}_run_log.txt")
    
    # Define path for the summary results file (similar to the original script's master log)
    summary_results_path = os.path.join(master_log_dir, f"{run_datetime}_summary_results.txt")

    # Use a list to store results before writing to files
    results_data = []
    tasks_to_run = [] # Define this before the try block


    # The `finally` block will handle aggregation.
    try:
        # Redirect all output from this main script to the comprehensive log file
        with StreamRedirector(filepath=comprehensive_log_path):
            print(f"--- EoH Framework Run Started: {run_datetime} ---")
            print(f"Arguments: {vars(args)}")
            print("-" * 50)

            # --- Task Preparation ---
            # Task preparation loop to populate tasks_to_run
            for benchmark in args.benchmarks:
                benchmark_dir = os.path.join(benchmark_root, benchmark)
                problems_file = os.path.join(benchmark_dir, 'problems.txt')
                if not os.path.exists(problems_file):
                    print(f"Warning: 'problems.txt' not found in {benchmark_dir}. Skipping.")
                    continue
                with open(problems_file, "r") as f:
                    all_problems = [line.strip() for line in f if line.strip()]
                
                problems_to_process = args.problems if args.problems else all_problems
                for problem in problems_to_process:
                    if problem in all_problems:
                        tasks_to_run.append((benchmark, problem, args))


            if not tasks_to_run:
                print("No valid problems found to run. Exiting.")
            else:
                print(f"\nStarting parallel execution with {args.num_workers} workers for {len(tasks_to_run)} problems.")
                
                with multiprocessing.Pool(processes=args.num_workers) as pool:
                    # This is the line that might fail
                    results_data = pool.map(run_problem_worker, tasks_to_run)

                print("\n--- All parallel tasks completed successfully.---")
            end_time = time.time()
            print(f"Total run time: {end_time - start_time:.2f} seconds")

    finally:
        # --- This block will ALWAYS run, even if the pool crashes ---
        print("\n--- Aggregation & Finalization Step ---")
        
        # Re-open the comprehensive log in append mode to add aggregation results
        with open(comprehensive_log_path, "a", encoding='utf-8') as log_file:
            log_file.write("\n\n" + "="*20 + " AGGREGATED INDIVIDUAL LOGS " + "="*20 + "\n")
            
            # Check if any results were produced before a potential crash
            if not results_data:
                log_file.write("\nNo results were returned from worker processes. This may be due to an early crash.\nCheck individual problem directories for logs.\n")
            else:
                for result_str, individual_log_path in results_data:
                    try:
                        path_parts = individual_log_path.split(os.sep)
                        problem_identifier = os.path.join(path_parts[-3], path_parts[-2])
                        
                        with open(individual_log_path, 'r', encoding='utf-8') as f_individual:
                            log_contents = f_individual.read()
                        
                        log_file.write(f"\n{problem_identifier}:\n")
                        log_file.write(f"{{\n{log_contents}\n}}\n")
                        log_file.write("-" * 50 + "\n")

                    except Exception as e:
                        log_file.write(f"\n--- Error processing log {individual_log_path}: {e} ---\n")

        # --- Write the summary results file ---
        if results_data:
            try:
                with open(summary_results_path, "w") as summary_file:
                    for result_str, _ in results_data:
                        summary_file.write(f"{result_str}\n")
                print(f"\nSummary results saved to: {summary_results_path}")
            except Exception as e:
                print(f"Error writing summary results file: {e}")

        print(f"Comprehensive run log with aggregated details saved to: {comprehensive_log_path}")
        print(f"Total run time: {end_time - start_time:.2f} seconds")
        print("--- EoH Framework Run Completed ---")