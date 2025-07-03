import os
import re 
import uuid
import subprocess
import shutil 
import random
from openai import OpenAI


import os
import subprocess
import re

import argparse

import multiprocessing
import datetime


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
        print(f"Script Main Directory: {script_main_dir}")
        print(f"Script Root Directory: {self.script_root_dir}")
        print(f"Reference Directory: {self.ref_dir_path}")
        print(f"PDK Directory: {self.pdk_path}")

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
        tns, wns, power, area = "None", "None", "None", "None"

        with open(report_path, 'r') as file:
            for line in file:
                parts = line.split()
                if not parts:  # Skip empty lines
                    continue

                # Handle TNS and WNS, which may have a 'max' keyword
                if parts[0] == 'tns':
                    if len(parts) > 1 and parts[1] == 'max':
                        tns = float(parts[2])
                    elif len(parts) > 1:
                        tns = float(parts[1])
                elif parts[0] == 'wns':
                    if len(parts) > 1 and parts[1] == 'max':
                        wns = float(parts[2])
                    elif len(parts) > 1:
                        wns = float(parts[1])
                
                # Handle Power and Area as before
                elif line.startswith('Total'):
                    power = float(parts[4])
                elif line.startswith('Design area'):
                    area = float(parts[2])

        # Effective clock period (delay or performance metric) eff_clk_period = clk_period - wns
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

            try:
                run_process = subprocess.run(
                    run_cmd_list,
                    capture_output=True,
                    text=True,
                    timeout=simulation_timeout_seconds,
                    check=False # Do not raise exception on non-zero exit
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
    def __init__(self, api_key=None, model_name="gpt-3.5-turbo"):
        if not api_key: 
            raise ValueError("API key is required for LLMInterface initialization.")
        
        self.api_key = api_key
        self.model_name = model_name
        self.client = None
        try:
            self.client = OpenAI(api_key=self.api_key)
            print(f"OpenAI client initialized successfully (Model: {self.model_name})")
        except Exception as e:
            raise RuntimeError(f"Failed to initialize OpenAI client: {e}")

    def parse_thought_and_code(self, response_text):
        thought_match = re.search(r"```thought\s*\n(.*?)\n```", response_text, re.DOTALL)
        code_match = re.search(r"```code\s*\n(.*?)\n```", response_text, re.DOTALL)

        thought = thought_match.group(1).strip() if thought_match else None
        code = code_match.group(1).strip() if code_match else None

        if thought is None:
            error_message = f"Could not parse 'thought' from LLM response. Expected ```thought ... ``` block. Response:\n{response_text[:500]}..."
            raise ValueError(error_message)
            
        if code is None:
            error_message = f"Could not parse 'code' from LLM response. Expected ```code ... ``` block. Response:\n{response_text[:500]}..."
            raise ValueError(error_message)

        return thought, code

    def generate_response(self, prompt, temperature=1.0, top_p=1.0, max_tokens=2048):
        print(f"\n--- LLM Request ---")
        print(f"Prompt (first 200 chars):\n{prompt[:200]}...")
        print(f"Model: {self.model_name}, Temperature: {temperature}, Max Tokens: {max_tokens}, Top P: {top_p}")

        if not self.client: 
            raise RuntimeError("OpenAI client not initialized. Cannot generate response.")

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
        
        try:
            chat_completion = self.client.chat.completions.create(
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

        except Exception as e:
            raise RuntimeError(f"OpenAI API call failed: {e}") 

        print(f"LLM Full Response (first 200 chars):\n{full_response_text[:200]}...\n--- LLM Request End ---\n")
        
        thought, code = self.parse_thought_and_code(full_response_text)
            
        return thought, code

    def generate_feedback(self, problem_def, verilog_code, simulation_log, temperature=1.0, top_p=1.0, max_tokens=2048):
        """
        Verilog 코드, 시뮬레이션 로그, 문제 정의를 LLM에 보내 코드의 오류를 분석하고 점수를 매기게 합니다.
        점수, 채점 이유, 분석 내용이 포함된 딕셔너리를 반환합니다.
        """
        print(f"\n--- LLM Feedback Generation Request ---")
        print(f"Verilog Code (first 200 chars):\n{verilog_code[:200]}...")
        print(f"Simulation Log (first 500 chars):\n{simulation_log[:500]}...")
        print(f"Model: {self.model_name}, Temperature: {temperature}, Max Tokens: {max_tokens}, Top P: {top_p}")

        if not self.client:
            raise RuntimeError("OpenAI client not initialized. Cannot generate feedback.")

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

        try:
            chat_completion = self.client.chat.completions.create(
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
            print("LLM Response Received. Parsing feedback...")

        except Exception as e:
            print(f"Error during OpenAI API call for feedback: {e}")
            raise RuntimeError(f"OpenAI API call for feedback failed: {e}")

        # --- 응답 파싱 로직 추가 ---
        # 지정된 포맷에 따라 점수, 채점 이유, 분석 내용을 추출합니다.
        parsed_feedback = {
            'score': None,
            'justification': 'Parsing failed.',
            'analysis': feedback_text # 파싱 실패 시 원본 텍스트를 반환
        }
        try:
            # 정규 표현식을 사용하여 각 태그 사이의 내용을 추출
            score_match = re.search(r'<SCORE>(.*?)</SCORE>', feedback_text, re.DOTALL)
            justification_match = re.search(r'<JUSTIFICATION>(.*?)</JUSTIFICATION>', feedback_text, re.DOTALL)
            analysis_match = re.search(r'<ANALYSIS>(.*?)</ANALYSIS>', feedback_text, re.DOTALL)

            if score_match:
                # 점수는 정수(int)로 변환
                parsed_feedback['score'] = int(score_match.group(1).strip())
            if justification_match:
                parsed_feedback['justification'] = justification_match.group(1).strip()
            if analysis_match:
                parsed_feedback['analysis'] = analysis_match.group(1).strip()
            
            print(f"LLM Feedback Parsed Successfully. Score: {parsed_feedback['score']}")

        except Exception as e:
            print(f"Error parsing LLM feedback: {e}. Returning raw text.")
            # 파싱 중 에러가 발생해도 원본 텍스트는 analysis 키에 남아있습니다.

        print(f"--- LLM Feedback Generation Request End ---\n")
        return parsed_feedback

class Heuristic:
    def __init__(self, thought, code, feedback, score=0.0, generation=0, parent_ids=None, status="syntax"):
        self.id = str(uuid.uuid4()) # Use UUID for unique ID
        self.thought = thought 
        self.code = code
        self.feedback = feedback # Feedback from LLM
        self.score = score
        self.generation = generation 
        self.parent_ids = parent_ids if parent_ids else [] 
        # New attributes for synthesis and PPA
        self.status = status # Can be either "syntax", functionality", "ppa", or "optimized"
        self.synthesis_success = False
        self.ppa_success = False
        self.ppa_metrics = {}
        # File path to the code for evaluation purposes
        self.code_file_path = ""

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
        return (f"Heuristic(ID: {self.id}, Gen: {self.generation}, Score: {self.score:.4f}, "
                f"Status: {self.status}, Thought: '{thought_repr}...', Parents: {self.parent_ids}, {ppa_info})")

class EoHEngine:
    def __init__(self, benchmark_name, problem_name, llm_interface, verilog_evaluator, synthesis_evaluator,
                 population_size=20, num_generations=20, num_ppa_iterations=10,
                 default_llm_temp=1.0, default_llm_top_p=1.0, default_llm_max_tokens=2048, base_save_path=None): 
        
        self.base_save_path = base_save_path if base_save_path else os.path.join(os.getcwd(), "verilog_eoh_results")
        self.benchmark_name = benchmark_name # Changed problem_type to benchmark_name for clarity
        self.problem_name = problem_name
        # Currently ./EoR/bench/<benchmark_name> is the path to the benchmark directory
        # And current location of this script is ./EoR/script/main.py == os.path.abspath(__file__)
        # Finds the location of bench based on the script's location
        # Need to be updated if the script is moved
        self.benchmark_path = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "bench", self.benchmark_name))
        self.problem_description = self.load_problem_description() # Uses internal variables to retrieve the problem description
        self.llm = llm_interface
        self.evaluator = verilog_evaluator
        self.synthesis_evaluator = synthesis_evaluator
        self.population_size = population_size
        self.num_generations = num_generations
        self.num_ppa_iterations = num_ppa_iterations
        self.default_llm_temp = default_llm_temp
        self.default_llm_top_p = default_llm_top_p
        self.default_llm_max_tokens = default_llm_max_tokens
        self.clk_period = self.synthesis_evaluator.clk_period # ns

        # Pools for different types of heuristics, replaces self.population = []
        self.syntax_pool = []
        self.functionality_pool = []
        self.ppa_pool = []


        
        self.current_generation = 0
        self.history = [] 
        # NEW: To store reference PPA metrics calculated dynamically
        self.ref_ppa_metrics = {}

    def load_problem_description(self):
        # Construct the paths dynamically based on benchmark instead of relying on hardcoded paths 
        prompt_path = os.path.join(self.benchmark_path, f"{self.problem_name}_prompt.txt")
        print(f"Loading prompt from: {prompt_path}")

        if os.path.exists(prompt_path):
            with open(prompt_path, "r") as f:
                return f.read().strip()
        else:
            raise FileNotFoundError(f"Problem description file not found: {prompt_path}")
    
    # Method to calculate the reference PPA metrics used to calculate the PPA score
    def _calculate_reference_ppa(self):
        """
        Synthesizes the reference Verilog module to establish baseline PPA metrics.
        """
        print(f"\n--- Calculating Reference PPA for {self.problem_name} ---")
        ref_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_ref.sv")

        if not os.path.exists(ref_sv_file):
            print(f"WARNING: Reference Verilog file not found at {ref_sv_file}. Cannot calculate reference PPA.")
            # Set defaults that make any valid synthesis result look good.
            self.ref_ppa_metrics = {"tns": 0.0, "wns": 0.0, "eff_clk_period": self.clk_period, "area": float('inf'), "power": float('inf')}
            return

        # Create a dedicated directory for the reference synthesis to keep results separate
        ref_output_dir = os.path.join(self.base_save_path, "reference_synthesis", self.benchmark_name, self.problem_name)
        os.makedirs(ref_output_dir, exist_ok=True)

        # Create a unique base path for the reference PPA report
        ref_report_base_path = os.path.join(ref_output_dir, f"{self.problem_name}_ref")
        
        print(f"Synthesizing reference design: {ref_sv_file}")
        # The module name is assumed to be the problem name (e.g., "Prob001_accu")
        synthesis_results = self.synthesis_evaluator.evaluate(
            verilog_file=ref_sv_file,
            problem_name=self.problem_name, 
            output_directory=ref_output_dir,
            report_base_path=ref_report_base_path
        )



        if synthesis_results and synthesis_results.get("ppa_success"):
            self.ref_ppa_metrics = synthesis_results["ppa_metrics"]
            print(f"Reference PPA calculated successfully: {self.ref_ppa_metrics}")
            # Also save the reference PPA metrics to experiment directory for easier access
            try:
                source_ppa_path = synthesis_results["ppa_metrics"].get("report_path")
                if source_ppa_path and os.path.exists(source_ppa_path):
                    model_name_cleaned = self.llm.model_name.replace("/", "_")
                    exp_problem_dir = os.path.join(self.base_save_path, model_name_cleaned, self.benchmark_name, self.problem_name)
                    os.makedirs(exp_problem_dir, exist_ok=True)
                    dest_ppa_path = os.path.join(exp_problem_dir, f"{self.problem_name}_reference.ppa")
                    shutil.copy(source_ppa_path, dest_ppa_path)
                    print(f"Copied reference PPA report to: {dest_ppa_path}")
            except Exception as e:
                print(f"WARNING: Failed to copy reference PPA report to experiment directory: {e}")
        else:
            print("WARNING: Reference PPA synthesis failed. Using default high values for scoring.")
            self.ref_ppa_metrics = {"tns": 0, "wns": 0, "eff_clk_period": self.clk_period, "area": 100, "power": 100}

    def _save_result_to_file(self, code_content, thought_content, generation_num, sample_idx_in_generation, strategy=None):
        """
        Saves the Verilog code to a structured file path.
        Filename includes generation number and a unique index for that generation.
        Returns the path to the saved file.
        """
        model_name_cleaned = self.llm.model_name.replace("/", "_") 
        directory_path = os.path.join(
            self.base_save_path,
            model_name_cleaned,
            self.benchmark_name,
            self.problem_name,
            f"Gen{generation_num}" 
        )
        os.makedirs(directory_path, exist_ok=True)
        
        code_file_name = f"{self.problem_name}_sample{sample_idx_in_generation}.sv"
        if strategy:
            code_file_name = f"{self.problem_name}_{strategy}_sample{sample_idx_in_generation}.sv"
        code_file_path = os.path.join(directory_path, code_file_name)
        
        thought_file_name = f"{self.problem_name}_sample{sample_idx_in_generation}_thought.txt"
        if strategy:
            thought_file_name = f"{self.problem_name}_{strategy}_sample{sample_idx_in_generation}_thought.txt"
        thought_file_path = os.path.join(directory_path, thought_file_name)

        try:
            with open(code_file_path, "w") as f:
                f.write(code_content)
            print(f"Verilog code saved to: {code_file_path}")
            
            with open(thought_file_path, "w") as f:
                f.write(thought_content)
            print(f"Thought saved to: {thought_file_path}")
            
            return code_file_path, thought_file_path
        
        except IOError as e:
            print(f"Error saving code to file {code_file_path} or {thought_file_path}: {e}")
            raise 

    def initialize_population(self):
        """
        Creates the initial population and places them within the syntax pool. 
        LLM generates thoughts and codes.
        All codes are generated and saved first, then evaluated in a batch.
        Raises errors immediately if LLM call or parsing fails.
        """
        print(f"\n--- Initializing Population (Size: {self.population_size}) ---")

        # Instead of storing tuples we will store Heuristic objects directly
        # generated_candidates = [] # To store (thought, code, code_file_path) tuples

        print(f"Step 1: Generating {self.population_size} initial code candidates...")
        for i in range(self.population_size):
            print(f"Generating initial candidate {i+1}/{self.population_size}...")
            try:
                thought, code = self.llm.generate_response(
                    prompt=self.problem_description,
                    max_tokens=self.default_llm_max_tokens,
                    temperature=self.default_llm_temp,
                    top_p=self.default_llm_top_p
                )

                code_file_path, thought_file_path = self._save_result_to_file(code, thought, generation_num=0, sample_idx_in_generation=i+1)
                heuristic = Heuristic(
                    thought=thought,
                    code=code,
                    feedback="",
                    score=0.0,  # Initial score is 0
                    generation=0,
                    parent_ids=[],  # No parents for initial generation
                    status="syntax",
                )
                heuristic.code_file_path = code_file_path  # Save the file path in the heuristic
                self.syntax_pool.append(heuristic)  # Add to syntax pool
                #generated_candidates.append({"thought": thought, "code": code, "code_file_path": code_file_path, "thought_file_path":thought_file_path, "generation": 0, "parent_ids": []})

            except (ValueError, RuntimeError) as e: # Errors from LLM or saving file
                print(f"Critical error generating initial candidate {i+1}: {e}")
                print("Stopping population initialization.")
                raise
            except Exception as e:
                print(f"Unexpected critical error during initial candidate {i+1} generation: {e}")
                raise

        print(f"--- Initial Population Generation Complete. All {len(self.syntax_pool)} candidates are in the syntax pool. ---")

    
    def _evaluate_and_promote_candidate(self, candidate, sample_idx):
        """
        Evaluates a single candidate and promotes it to the next pool if it passes.
        """
        print(f"Evaluating candidate {candidate.id} from status {candidate.status}")
        # Paths to the test and reference Verilog files constructed dynamically using benchmark_path and problem_name
        test_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_test.sv")
        ref_sv_file = os.path.join(self.benchmark_path, f"{self.problem_name}_ref.sv")

        # Stage 1: Syntax and Functionality Check
        if candidate.status == 'syntax' or candidate.status == 'functionality':
            results = self.evaluator.evaluate(candidate.code_file_path, test_sv_file, ref_sv_file)

            if results['status'] == "compilation_error":
                print("Result: Compilation error. Stays in syntax_pool.")
                # Optionally update feedback with compilation error
                self.syntax_pool.append(candidate)  # Re-add to syntax pool
                return None

            mismatch_pattern = r'^Mismatches: (\d+) in \d+ samples$'
            match = re.search(mismatch_pattern, results.get('simulation_stdout', ''), re.MULTILINE)

            if results['status'] == "success" and match and int(match.group(1)) == 0:
                print("Result: Functionally correct. Promoting to ppa_pool.")
                candidate.status = 'ppa'
                candidate.score = 10.0 # Base score for being functional
                candidate.feedback = "Functionally correct."
                self.ppa_pool.append(candidate)
                # Now, do the first PPA evaluation
                self._evaluate_and_promote_candidate(candidate, sample_idx)

            else: # Functional failure
                print("Result: Functional failure. Moving to functionality_pool.")
                candidate.status = 'functionality'
                feedback = self.llm.generate_feedback(
                    problem_def=self.problem_description,
                    verilog_code=candidate.code,
                    simulation_log=results["compilation_stdout"] + "\n" + results["compilation_stderr"] + "\n" + results['simulation_stdout'] + "\n" + results['simulation_stderr'],
                    temperature=self.default_llm_temp,
                    top_p=self.default_llm_top_p,
                    max_tokens=self.default_llm_max_tokens
                )
                candidate.feedback = feedback['analysis']
                candidate.score = feedback['score']
                self.functionality_pool.append(candidate)

                # Save the feedback file and score file
                model_name_cleaned = self.llm.model_name.replace("/", "_")
                # Get the code file name from the candidate and cut off the .sv extension
                code_file_name = os.path.basename(candidate.code_file_path).rsplit('.', 1)[0] # e.g., "Prob001_accu_sample1"
                feedback_file_path = os.path.join(self.base_save_path,
                                                  model_name_cleaned,
                                                  self.benchmark_name,
                                                  self.problem_name,
                                                  f"Gen{candidate.generation}",
                                                  f"{code_file_name}_{candidate.status}_feedback_{candidate.id}.txt")
                # If there is no directory, create it
                os.makedirs(os.path.dirname(feedback_file_path), exist_ok=True)
                with open(feedback_file_path, "w") as f:
                    f.write(feedback['analysis'])

                score_file_path = os.path.join(self.base_save_path,
                                                model_name_cleaned,
                                                self.benchmark_name,
                                                self.problem_name,
                                                f"Gen{candidate.generation}",
                                                f"{code_file_name}_{candidate.status}_score_{candidate.id}.txt")
                with open(score_file_path, "w") as f:
                    f.write(f"Score: {feedback['score']}\nJustification: {feedback['justification']}")
                print(f"Feedback saved to: {feedback_file_path}")
                print(f"Score and justification saved to: {score_file_path}")

        # Stage 2: PPA Evaluation
        elif candidate.status == 'ppa' or candidate.status == 'optimized':
            print(f"Synthesizing candidate {candidate.id} for PPA evaluation...")
            report_base_path = candidate.code_file_path.rsplit('.', 1)[0] # Base path for PPA report
            output_dir = os.path.dirname(candidate.code_file_path)
            synthesis_results = self.synthesis_evaluator.evaluate(candidate.code_file_path, self.problem_name, output_dir, report_base_path)

            if synthesis_results["synthesis_success"] and synthesis_results["ppa_success"]:
                candidate.synthesis_success = True
                candidate.ppa_success = True
                candidate.ppa_metrics = synthesis_results["ppa_metrics"]

                # PPA metrics scoring with eff_clk_period, area, and power
                ref_eff_clk_period = self.ref_ppa_metrics.get("eff_clk_period") # unit ns
                ref_area = self.ref_ppa_metrics.get("area") # unit um^2
                ref_power = self.ref_ppa_metrics.get("power") # unit W
                


                eff_clk_period = candidate.ppa_metrics.get("eff_clk_period")
                area = candidate.ppa_metrics.get("area")
                power = candidate.ppa_metrics.get("power")
                # Update score based on PPA. The 10.0 base score indicates functionality.
                # score = 0 : indicates that the candiate has not passed synthesis or requires at least twice area/power/delay compared to the reference design
                # score = 1 : indicates that the candidate has passed synthesis and has equal area/power/delay compared to the reference design
                # score = 2 : indicates that the candidate has passed synthesis and has zero area/power/delay compared to the reference design (e.g., a perfect design)
                perf_score = 2 - min(eff_clk_period / (ref_eff_clk_period + 1e-10), 2) # Scale to [0, 2]
                power_score = 2 - min(power / (ref_power + 1e-10), 2) # Scale to [0, 2]
                area_score = 2 - min(area / (ref_area + 1e-10), 2) # Scale to [0, 2]

                candidate.score = 10.0 + perf_score + power_score + area_score
                # candidate.score = 10.0 + 1 + (1/ (cost + 1e-9)) # Add inverse of cost to score and 1 score for successful synthesis

                print(f"PPA evaluation successful for {candidate.id}. PPA Metrics: {candidate.ppa_metrics}")

            else:
                print(f"Synthesis failed for {candidate.id}. Keeping it in its current pool for now.")
                candidate.feedback += "\n\n--- Synthesis Failed ---\n" + synthesis_results.get("synthesis_log", "")
                candidate.score += 0 # Keep the score the same for synthesis failure


    def evolve_one_generation(self):
        """
        Performs one generation of evolution by creating and evaluating a large number of new heuristics.
        """
        self.current_generation += 1
        print(f"\n--- Starting Generation {self.current_generation} Evolution ---")

        # Each strategy will generate population_size candidates
        strategies_config = [
            {"name": "E1", "func": self._apply_prompt_strategy_E1, "num_parents": 2},
            {"name": "E2", "func": self._apply_prompt_strategy_E2, "num_parents": 2},
            {"name": "M1", "func": self._apply_prompt_strategy_M1, "num_parents": 1},
            {"name": "M3", "func": self._apply_prompt_strategy_M3, "num_parents": 2},
        ]

        generated_candidates_data = []

        # Determine which pools to draw parents from
        # Prioritize improving PPA if we have functional candidates
        if self.ppa_pool:
            parent_pool = self.ppa_pool
            print("Focusing evolution on PPA optimization.")
        # Otherwise, focus on achieving functionality
        elif self.functionality_pool:
            parent_pool = self.functionality_pool
            print("Focusing evolution on fixing functional errors.")
        # If all else fails, work from the syntax pool
        else:
            parent_pool = self.syntax_pool
            print("Focusing evolution on fixing syntax errors.")
        
        if not parent_pool:
             print("No candidates in any pool to evolve from. Stopping.")
             return "STOP"

        print(f"Step 1: Generating new candidates for generation {self.current_generation}...")
        for config in strategies_config:
            strategy_name = config["name"]
            strategy_func = config["func"]
            num_parents = config["num_parents"]
            num_to_create = self.population_size # Each strategy creates population_size candidates

            print(f"Applying Strategy {strategy_name} (Target: {num_to_create})...")
            for i in range(1, num_to_create + 1):
                try:
                    parents = self._select_parents(num_parents=num_parents, parent_pool=parent_pool)
                    if not parents:
                        print(f"Not enough parents available for strategy {strategy_name}. Skipping candidate generation.")
                        continue

                    new_thought, new_code = strategy_func(parents)
                    # Sample index is now strategy-specific to avoid collision
                    code_file_path, thought_file_path = self._save_result_to_file(new_code, new_thought, self.current_generation, i, strategy=strategy_name)

                    new_candidate = Heuristic(
                        thought=new_thought, code=new_code, feedback="",
                        generation=self.current_generation,
                        parent_ids=[p.id for p in parents],
                        status='syntax', # All new candidates start at the syntax stage
                    )
                    new_candidate.code_file_path = code_file_path  # Save the file path in the heuristic
                    generated_candidates_data.append(new_candidate)


                except (ValueError, RuntimeError, IOError) as e:
                    print(f"Critical error generating candidate via {strategy_name}: {e}")
                    raise
                except Exception as e:
                    print(f"Unexpected critical error during {strategy_name} candidate generation: {e}")
                    raise

        print(f"\nStep 2: Evaluating {len(generated_candidates_data)} new candidates...")
        # Clear the syntax and functionality pools. We will repopulate them with the new generation.
        # PPA pool remains, as they are our best candidates so far.
        self.syntax_pool.clear()
        self.functionality_pool.clear()

        for i, candidate in enumerate(generated_candidates_data):
            self._evaluate_and_promote_candidate(candidate, i)

        # Elitism: Ensure the best candidates are not lost
        self.functionality_pool.sort(key=lambda h: h.score, reverse=True)
        self.ppa_pool.sort(key=lambda h: h.score, reverse=True)

        # Trim pools to population size to prevent them from growing indefinitely
        self.functionality_pool = self.functionality_pool[:self.population_size]
        self.ppa_pool = self.ppa_pool[:self.population_size]


        print(f"--- Generation {self.current_generation} Complete ---")
        print(f"Pool Sizes: Syntax({len(self.syntax_pool)}), Functionality({len(self.functionality_pool)}), PPA({len(self.ppa_pool)})")
        if self.ppa_pool:
            print(f"Best PPA candidate so far: {self.ppa_pool[0]}")
        elif self.functionality_pool:
            print(f"Best functional candidate so far: {self.functionality_pool[0]}")
        
        return None # Continue evolution

    def _select_parents(self, num_parents=2, parent_pool=None):
        if not parent_pool:
            return []

        # Use score for selection pressure
        weights = [(h.score + 0.1) ** 2.0 for h in parent_pool]
        
        # Handle case where all weights are zero
        if all(w == 0 for w in weights):
            return random.choices(parent_pool, k=num_parents)
        
        # random.choices를 사용하여 간단하게 부모 선택 (중복 허용)
        # 이 방식이 더 효율적이고 일반적인 유전 알고리즘 관행에 부합합니다.
        return random.choices(parent_pool, weights=weights, k=num_parents)

    def _apply_prompt_strategy_E1(self, parent):
        parent_prompt = ""
        for i, p in enumerate(parent):
            parent_prompt += (
                f"<Example {i+1}>:\n"
                "```thought\n"
                f"{p.thought}\n"
                "```\n"
                "```code\n"
                f"{p.code}\n"
                "```\n"
                "```feedback\n"
                f"{p.feedback}\n"
                "```\n\n"
            )
            if p.status in ['ppa', 'optimized']:
                parent_prompt += "```ppa_metrics\n" + str(p.ppa_metrics) + "\n```\n\n"

        prompt = (
            self.problem_description +
            f"Here are my attempts at solving the same problem, including my thought process, code, and feedback.\n\n"
            f"{parent_prompt}\n\n"
            "Based on the examples above, please implement a unique approach (thought and code) to solve the problem, making it as different from the provided examples as possible. "
            "If the examples include PPA metrics, consider them to find a completely new, potentially better, architectural approach. "
            "Remember to format your response with ```thought ... ``` and ```code ... ``` blocks."
        )
        return self.llm.generate_response(
            prompt, 
            temperature=self.default_llm_temp, 
            top_p=self.default_llm_top_p,
            max_tokens=self.default_llm_max_tokens
        )

    def _apply_prompt_strategy_E2(self, parent):
        parent_prompt = ""
        for i, p in enumerate(parent):
            parent_prompt += (
                f"<Example {i+1}>:\n"
                "```thought\n"
                f"{p.thought}\n"
                "```\n"
                "```code\n"
                f"{p.code}\n"
                "```\n"
                "```feedback\n"
                f"{p.feedback}\n"
                "```\n\n"
            )

            if p.status in ['ppa', 'optimized']:
                parent_prompt += "```ppa_metrics\n" + str(p.ppa_metrics) + "\n```\n\n"


        prompt = (
            self.problem_description +
            f"\nHere are my attempts at solving the same problem, including my thought process, code, and feedback.\n\n"
            f"{parent_prompt}\n\n"
            "Please refer to the examples above to find their common idea, develop it further, and then implement the best possible thought process and code to solve the problem. "
            "If PPA metrics are present, your goal is to optimize the code to improve Power, Performance, and Area while preserving functionality. "
            "Remember to format your response with ```thought ... ``` and ```code ... ``` blocks."
        )
        return self.llm.generate_response(
            prompt, 
            temperature=self.default_llm_temp, 
            top_p=self.default_llm_top_p,
            max_tokens=self.default_llm_max_tokens
        )

    def _apply_prompt_strategy_M1(self, parent):
        parent_prompt = ""
        for i, p in enumerate(parent):
            parent_prompt += (
                f"<Example {i+1}>:\n"
                "```thought\n"
                f"{p.thought}\n"
                "```\n"
                "```code\n"
                f"{p.code}\n"
                "```\n"
                "```feedback\n"
                f"{p.feedback}\n"
                "```\n\n"
            )

            if p.status in ['ppa', 'optimized']:
                parent_prompt += "```ppa_metrics\n" + str(p.ppa_metrics) + "\n```\n\n"


        prompt = (
            self.problem_description +
            f"Here are my attempts at solving the same problem, including my thought process, code, and feedback.\n\n"
            f"{parent_prompt}\n\n"
            "Using the examples above, please modify them to improve the thought process and code for a better solution. "
            "If PPA metrics are present, your goal is to optimize the code to improve Power, Performance, and Area while preserving functionality. "
            "Remember to format your response with ```thought ... ``` and ```code ... ``` blocks."
        )
        return self.llm.generate_response(
            prompt, 
            temperature=self.default_llm_temp, 
            top_p=self.default_llm_top_p,
            max_tokens=self.default_llm_max_tokens
        )

    def _apply_prompt_strategy_M3(self, parent):
        parent_prompt = ""
        for i, p in enumerate(parent):
            parent_prompt += (
                f"<Example {i+1}>:\n"
                "```thought\n"
                f"{p.thought}\n"
                "```\n"
                "```code\n"
                f"{p.code}\n"
                "```\n"
                "```feedback\n"
                f"{p.feedback}\n"
                "```\n\n"
            )
            if p.status in ['ppa', 'optimized']:
                parent_prompt += "```ppa_metrics\n" + str(p.ppa_metrics) + "\n```\n\n"

        prompt = (
            self.problem_description +
            f"Here are my attempts at solving the same problem, including my thought process, code, and feedback.\n\n"
            f"{parent_prompt}\n\n"
            "Please refer to the examples above to simplify the thought process and code. You can do this by identifying the essential parts and removing the unnecessary ones to solve the problem. "
            "If PPA metrics are present, your goal is to optimize the code to improve Power, Performance, and Area while preserving functionality. "
            "Remember to format your response with ```thought ... ``` and ```code ... ``` blocks."
        )
        return self.llm.generate_response(
            prompt, 
            temperature=self.default_llm_temp, 
            top_p=self.default_llm_top_p,
            max_tokens=self.default_llm_max_tokens
        )

    def _apply_ppa_optimization_prompt(self, current_best_solution):
        """
        Creates a prompt to ask the LLM to optimize a functionally correct solution for PPA.
        """
        ppa_metrics = current_best_solution.ppa_metrics
        ppa_report_str = (
            f"Current PPA Metrics:\n"
            f"- Area: {ppa_metrics.get('area', 'N/A')} um^2\n"
            f"- Power: {ppa_metrics.get('power', 'N/A')} uW\n"
            f"- Effective Clock Period: {ppa_metrics.get('eff_clk_period', 'N/A')} ns\n"
            f"- Worst Negative Slack (WNS): {ppa_metrics.get('wns', 'N/A')} ns\n"
            f"- Total Negative Slack (TNS): {ppa_metrics.get('tns', 'N/A')} ns\n"
        )

        prompt = (
            f"The following Verilog code correctly implements the desired functionality for the problem:\n\n"
            f"**Problem Description:**\n{self.problem_description}\n\n"
            f"**Functionally Correct Verilog Code:**\n"
            f"```verilog\n{current_best_solution.code}\n```\n\n"
            f"This code was synthesized, and its Power, Performance, and Area (PPA) report is as follows:\n"
            f"```report\n{ppa_report_str}\n```\n\n"
            f"**Your task is to optimize the provided Verilog code to improve its PPA metrics (reduce area and power, improve timing by making slack less negative or more positive) while strictly preserving its original functionality.**\n\n"
            f"Analyze the code and the report, then provide a new version of the code that is better optimized. "
            f"Do not change the module's input/output ports.\n\n"
            f"Format your response with a `thought` on your optimization strategy and the resulting `code`.\n"
            f"```thought\n"
            f"[Your concise optimization idea here]\n"
            f"```\n"
            f"```code\n"
            f"[Your complete, optimized, and functionally identical Verilog code here]\n"
            f"```"
        )

        return self.llm.generate_response(
            prompt,
            temperature=0.4,  # Lower temperature for more focused, less creative changes
            top_p=self.default_llm_top_p,
            max_tokens=self.default_llm_max_tokens
        )

    def run(self):
        """
        Runs the unified evolutionary framework.
        """
        print(f"--- Starting Unified EoH Run: Problem '{self.benchmark_name}/{self.problem_name}' ---")
        print(f"Generations: {self.num_generations}, Population Size: {self.population_size}")

        try:
            # Calculate reference PPA metrics before starting the evolution
            self._calculate_reference_ppa()
            print(f"Reference PPA Metrics: {self.ref_ppa_metrics}")
            self.initialize_population()
            # Initial evaluation of the first generation
            print("\n--- Evaluating Initial Population ---")
            initial_candidates = list(self.syntax_pool) # Create a copy to iterate over
            self.syntax_pool.clear()
            for i, candidate in enumerate(initial_candidates):
                self._evaluate_and_promote_candidate(candidate, i)
            
            print("--- Initial Evaluation Complete ---")
            print(f"Pool Sizes: Syntax({len(self.syntax_pool)}), Functionality({len(self.functionality_pool)}), PPA({len(self.ppa_pool)})")


        except (RuntimeError, ValueError, Exception) as e:
            print(f"Critical error during population initialization: {e}")
            print("EoH run aborted.")
            return f"{self.problem_name},initialization_failed"

        # Main evolution loop
        for gen in range(self.num_generations):
            if self.evolve_one_generation() == "STOP":
                break

        # --- End of Evolution ---
        print("\n--- EoH Run Finished ---")
        
        # Determine the best solution
        best_solution = None
        if self.ppa_pool:
            self.ppa_pool.sort(key=lambda h: h.score, reverse=True)
            best_solution = self.ppa_pool[0]
            print("Final best solution is from PPA pool.")
        elif self.functionality_pool:
            self.functionality_pool.sort(key=lambda h: h.score, reverse=True)
            best_solution = self.functionality_pool[0]
            print("No PPA-optimized solution, best solution is from functionality pool.")
        elif self.syntax_pool:
            self.syntax_pool.sort(key=lambda h: h.score, reverse=True)
            best_solution = self.syntax_pool[0]
            print("No functional solution, best solution is from syntax pool.")

        if not best_solution:
            print("No solution found in any pool.")
            return f"{self.problem_name},failed"
            
        print("Final Best Solution Found:")
        print(best_solution)

        final_ppa_report_path = best_solution.ppa_metrics.get("report_path", "N/A")
        return f"{self.problem_name},success_optimized,{best_solution.code_file_path},{final_ppa_report_path}"
    
# Wrapper function for multiprocessing
def run_problem_worker(args_tuple):
    """
    Wrapper function to run a single problem instance.
    This function will be executed by each worker process.
    """
    # Unpack arguments
    benchmark, problem, args = args_tuple
    
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
        default_llm_max_tokens=args.max_tokens
    )
    result_str = eoh_engine.run()
    return result_str

if __name__ == "__main__":
    # MODIFIED: Use argparse to make the script configurable
    parser = argparse.ArgumentParser(description="Run the EoH framework on specified Verilog benchmarks.")
    
    # List of all available benchmarks in the 'bench' directory
    # Current benches: ['RTLLM', 'VerilogEval-Code-Complete', 'VerilogEval-Spec-to-RTL']
    available_benchmarks = [d for d in os.listdir('./bench') if os.path.isdir(os.path.join('./bench', d))]
    
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
    parser.add_argument('--top_p', type=float, default=1.0)
    parser.add_argument('--max_tokens', type=int, default=2048)

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

    # --- Task Preparation ---
    run_datetime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    tasks_to_run = []
    for benchmark in args.benchmarks:
        benchmark_dir = os.path.join('bench', benchmark)
        problems_file = os.path.join(benchmark_dir, 'problems.txt')
        if not os.path.exists(problems_file):
            print(f"Warning: 'problems.txt' not found in {benchmark_dir}. Skipping.")
            continue
        with open(problems_file, "r") as f:
            all_problems = [line.strip() for line in f if line.strip()]
        
        problems_to_process = args.problems if args.problems else all_problems
        for problem in problems_to_process:
            if problem in all_problems:
                # Package all arguments for the worker function into a tuple
                tasks_to_run.append((benchmark, problem, args))

    if not tasks_to_run:
        print("No valid problems found to run. Exiting.")
        exit(0)

    # --- Multiprocessing Execution ---
    print(f"\nStarting parallel execution with {args.num_workers} workers for {len(tasks_to_run)} problems.")
    
    with multiprocessing.Pool(processes=args.num_workers) as pool:
        results = pool.map(run_problem_worker, tasks_to_run)

    # --- Result Aggregation ---
    print("\n--- All parallel tasks completed. Aggregating results. ---")
    # A single log file for the entire run, can be split by benchmark if needed
    model_name_cleaned = args.model_name.replace("/", "_")

    master_log_path = os.path.join(args.save_path, model_name_cleaned, run_datetime + "_master_run_log.txt")
    with open(master_log_path, "w") as log_file:
        for result_str in results:
            log_file.write(f"{result_str}\n")
    
    print(f"\nEoH process finished. Master log saved to: {master_log_path}")