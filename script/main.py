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

class SynthesisEvaluator:
    def __init__(self, yosys_path="yosys", openroad_path="openroad", pdk_path="../pdk"):
        self.yosys_path = yosys_path
        self.openroad_path = openroad_path
        self.pdk_path = pdk_path

    def evaluate(self, verilog_file, module_name, output_directory):
        """
        Performs synthesis and PPA analysis on a given Verilog file.
        """
        if not os.path.exists(output_directory):
            os.makedirs(output_directory)

        synthesis_success, synthesis_log = self._run_synthesis(verilog_file, module_name, output_directory)

        if not synthesis_success:
            return {
                "synthesis_success": False,
                "ppa_success": False,
                "synthesis_log": synthesis_log,
                "ppa_metrics": None
            }

        ppa_success, ppa_metrics, ppa_log = self._run_ppa_analysis(module_name, output_directory)

        return {
            "synthesis_success": True,
            "ppa_success": ppa_success,
            "synthesis_log": synthesis_log,
            "ppa_metrics": ppa_metrics,
            "ppa_log": ppa_log
        }

    def _run_synthesis(self, verilog_file, module_name, output_directory):
        """
        Runs the Yosys synthesis script.
        """
        clk_period = 0.01 # ns
        sdc_file_path = self._create_sdc_file(verilog_file, module_name, output_directory, clk_period=clk_period)
        yosys_script_path = self._create_yosys_script(verilog_file, module_name, output_directory, clk_period)
        openroad_script_path = self._create_openroad_script(sdc_file_path, module_name, output_directory)

        report_path = os.path.join(output_directory, f"{module_name}_synthesis_report.rpt")

        command = f"yosys {yosys_script_path} && openroad {openroad_script_path} | tee {report_path}"

        log_path = os.path.join(output_directory, "yosys.log")

        process = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        try:
            process = subprocess.run(command, capture_output=True, text=True, check=True)
            return True, process.stdout
        except subprocess.CalledProcessError as e:
            return False, e.stdout + e.stderr
    
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
        yosys_ref = f'./ref/ref.yosys.tcl'
        yosys_gen = f'{output_directory}/{module_name}.yosys.tcl'

        with open(yosys_ref, 'r') as infile:
            with open(yosys_gen, 'w') as outfile:
                text = infile.read()
                text = text.replace("__VERILOG_FILE__", os.path.abspath(verilog_file))
                text = text.replace("__MODULE_NAME__", module_name)
                text = text.replace("__OUTPUT_DIR__", os.path.abspath(output_directory))
                text = text.replace("__REF_DIR__", os.path.abspath('./ref'))
                text = text.replace("__PDK_DIR__", os.path.abspath(self.pdk_path))
                text = text.replace("__CLK_PERIOD__", str(clk_period * 1000))
                outfile.write(text)

        return yosys_gen

    def _create_openroad_script(self, sdc_file_path, module_name, output_directory):
        # A simplified OpenROAD script. This may need to be adapted for your specific PDK and design.
        or_ref = f'./ref/ref.openroad.tcl'
        or_gen = f'{output_directory}/{module_name}.openroad.tcl'

        with open(or_ref, 'r') as infile:
            with open(or_gen, 'w') as outfile:
                text = infile.read()
                text = text.replace("__UTIL_DIR__", os.path.abspath('./util'))
                text = text.replace("__PDK_DIR__", os.path.abspath(self.pdk_path))
                text = text.replace("__DESIGN_NAME__", module_name)
                text = text.replace("__MODULE_NAME__", module_name)
                text = text.replace("__NETLIST__", os.path.abspath(f'{output_directory}/{module_name}.syn.v'))
                text = text.replace("__SDC__", sdc_file_path)
                text = text.replace("__UTILIZATION__", str(0.5))
                outfile.write(text)

        return or_gen

    def _run_ppa_analysis(self, module_name, output_directory):
        """
        Runs the OpenROAD PPA analysis script.
        """
        openroad_script_path = self._create_openroad_script(module_name, output_directory)
        log_path = os.path.join(output_directory, "openroad.log")

        command = [self.openroad_path, "-exit", openroad_script_path]
        try:
            process = subprocess.run(command, capture_output=True, text=True, check=True)
            ppa_metrics = self._parse_ppa_log(log_path)
            return True, ppa_metrics, process.stdout
        except subprocess.CalledProcessError as e:
            return False, None, e.stdout + e.stderr


    def _parse_ppa_log(self, report_path):
        """
        A simple parser for the OpenROAD log to extract PPA metrics.
        """
        tns, wns, power, area = "None", "None", "None", "None"

        with open(report_path, 'r') as file:
            for line in file:
                if line.startswith('tns'):
                    tns = float(line.split()[1])
                elif line.startswith('wns'):
                    wns = float(line.split()[1])
                elif line.startswith('Total'):
                    power = float(line.split()[4])
                elif line.startswith('Design area'):
                    area = float(line.split()[2])

        ppa_path = report_path.replace(".rpt", ".ppa")
        with open(ppa_path, 'w') as f:
            f.write('tns,wns,power,area\n')
            f.write(f'{tns},{wns},{power},{area}')


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
    def __init__(self, thought, code, feedback, score=0.0, generation=0, parent_ids=None):
        self.id = str(uuid.uuid4()) # Use UUID for unique ID
        self.thought = thought 
        self.code = code
        self.feedback = feedback # Feedback from LLM
        self.score = score
        self.generation = generation 
        self.parent_ids = parent_ids if parent_ids else [] 
        # New attributes for synthesis and PPA
        self.synthesis_success = False
        self.ppa_success = False
        self.ppa_metrics = {}

    def __repr__(self):
        thought_repr = self.thought[:50] 
        return (f"Heuristic(ID: {self.id}, Gen: {self.generation}, Score: {self.score:.4f}, "
                f"Thought: '{thought_repr}...', Parents: {self.parent_ids})")

class EoHEngine:
    def __init__(self, problem_type, problem_name, llm_interface, verilog_evaluator,
                 population_size=20, num_generations=20,
                 default_llm_temp=1.0, default_llm_top_p=1.0, default_llm_max_tokens=2048, base_save_path=None): 
        
        self.base_save_path = base_save_path if base_save_path else os.path.join(os.getcwd(), "verilog_eoh_results")
        self.problem_type = problem_type
        self.problem_name = problem_name
        self.problem_description = self.load_problem_description(problem_type, problem_name) 
        self.llm = llm_interface
        self.evaluator = verilog_evaluator
        self.population_size = population_size
        self.num_generations = num_generations
        self.default_llm_temp = default_llm_temp
        self.default_llm_top_p = default_llm_top_p
        self.default_llm_max_tokens = default_llm_max_tokens

        self.population = []
        self.current_generation = 0
        self.history = [] 

    def load_problem_description(self, problem_type, problem_name):
        prompt_path = f"/project/cad-team/LX_Semicon/kjmin/verilog-eval/{problem_type}/{problem_name}_prompt.txt"
        print(prompt_path)

        if os.path.exists(f"/project/cad-team/LX_Semicon/kjmin/verilog-eval/{problem_type}/{problem_name}_prompt.txt"):
            with open(f"/project/cad-team/LX_Semicon/kjmin/verilog-eval/{self.problem_type}/{problem_name}_prompt.txt", "r") as f:
                return f.read().strip()
        else:
            raise FileNotFoundError(f"Problem description file not found for {problem_name} in {self.problem_type}.")

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
            self.problem_type,
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
        Creates the initial population. LLM generates thoughts and codes.
        All codes are generated and saved first, then evaluated in a batch.
        Raises errors immediately if LLM call or parsing fails.
        """
        print(f"\n--- Initializing Population (Size: {self.population_size}) ---")
        
        generated_candidates = [] # To store (thought, code, code_file_path) tuples

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
                generated_candidates.append({"thought": thought, "code": code, "code_file_path": code_file_path, "thought_file_path":thought_file_path, "generation": 0, "parent_ids": []})
                
            except (ValueError, RuntimeError) as e: # Errors from LLM or saving file
                print(f"Critical error generating initial candidate {i+1}: {e}")
                print("Stopping population initialization.")
                raise 
            except Exception as e:
                print(f"Unexpected critical error during initial candidate {i+1} generation: {e}")
                raise

        if len(generated_candidates) != self.population_size:
            raise RuntimeError(f"Code generation for population incomplete ({len(generated_candidates)}/{self.population_size}). Check logic.")

        print(f"\nStep 2: Evaluating {len(generated_candidates)} generated code candidates...")
        initial_heuristics = []
        for i, candidate_data in enumerate(generated_candidates):
            print(f"Evaluating candidate {i+1}/{len(generated_candidates)}: {candidate_data['code_file_path']}")
            try:

                base_dir = os.path.join('/project/cad-team/LX_Semicon/kjmin/verilog-eval', self.problem_type)
                test_sv_file = os.path.join(base_dir, f"{self.problem_name}_test.sv")
                ref_sv_file = os.path.join(base_dir, f"{self.problem_name}_ref.sv")
                results = self.evaluator.evaluate(candidate_data['code_file_path'], test_sv_file, ref_sv_file)
                
                mismatch_pattern = r'^Mismatches: (\d+) in \d+ samples$'
                evaluation_succeeded = False # 최종 성공 여부를 저장할 변수

                if results['status'] == "success":
                    match = re.search(mismatch_pattern, results['simulation_stdout'], re.MULTILINE)
                    if match:
                        num_mismatches = int(match.group(1))
                        if num_mismatches == 0:
                            evaluation_succeeded = True
                            print(f"Candidate {i+1} evaluation succeeded with status: {results['status']} and 0 mismatches.")
                            return f"{self.problem_name},0,init,{candidate_data['code_file_path']}"
                        else:
                            print(f"Candidate {i+1} evaluation failed: {num_mismatches} mismatches found.")
                    else:
                        # Mismatch 패턴이 아예 없는 경우, 성공으로 간주할지 아니면 이것도 실패로 처리할지 결정해야 합니다.
                        # 여기서는 Mismatch 패턴이 없으면 성공으로 간주하지 않고 피드백을 생성하도록 합니다.
                        # 만약 Mismatch 패턴이 없는 경우도 성공으로 처리하고 싶다면, 이 else 블록을 수정하거나
                        # evaluation_succeeded = True 로 설정할 수 있습니다.
                        print(f"Candidate {i+1} evaluation failed: Mismatch pattern not found in simulation output.")

                else:
                    print(f"Candidate {i+1} evaluation failed with status: {results['status']}")

                if not evaluation_succeeded:
                    feedback = self.llm.generate_feedback(
                        problem_def=self.problem_description,
                        verilog_code=candidate_data['code'],
                        simulation_log=results["compilation_stdout"] + "\n" + results["compilation_stderr"] + "\n" + results['simulation_stdout'] + "\n" + results['simulation_stderr'],
                        temperature=self.default_llm_temp,
                        top_p=self.default_llm_top_p,
                        max_tokens=self.default_llm_max_tokens
                    )

                    model_name_cleaned = self.llm.model_name.replace("/", "_")
                    feedback_file_path = os.path.join(self.base_save_path,
                                                    model_name_cleaned,
                                                    self.problem_type,
                                                    self.problem_name,
                                                    f"Gen{candidate_data['generation']}",
                                                    f"{self.problem_name}_sample{i+1}_feedback.txt")

                    # 디렉토리가 없는 경우 생성
                    os.makedirs(os.path.dirname(feedback_file_path), exist_ok=True)

                    with open(feedback_file_path, "w") as f:
                        f.write(feedback['analysis'])
                    print(f"Feedback saved to: {feedback_file_path}")

                    score_file_path = os.path.join(self.base_save_path,
                                                    model_name_cleaned,
                                                    self.problem_type,
                                                    self.problem_name,
                                                    f"Gen{candidate_data['generation']}",
                                                    f"{self.problem_name}_sample{i+1}_score.txt")
                    with open(score_file_path, "w") as f:
                        f.write(f"Score: {feedback['score']}\nJustification: {feedback['justification']}")
                    print(f"Score and justification saved to: {score_file_path}")

                heuristic = Heuristic(
                    thought=candidate_data['thought'], 
                    code=candidate_data['code'], 
                    score = feedback['score'],
                    feedback=feedback['analysis'],
                    generation=candidate_data['generation'], 
                    parent_ids=candidate_data['parent_ids'],
                )
                initial_heuristics.append(heuristic)
                print(f"Evaluated heuristic: {heuristic}")

            except Exception as e: # Catch evaluation errors
                print(f"Critical error evaluating candidate {candidate_data['code_file_path']}: {e}")
                print("Stopping population initialization due to evaluation error.")
                raise

        print(f"--- Batch Evaluation for Initialization Complete ---\n")

        if len(initial_heuristics) != self.population_size:
             # This should ideally not be reached if individual evaluations are also critical
            raise RuntimeError(f"Population initialization incomplete after evaluation ({len(initial_heuristics)}/{self.population_size}).")

        self.population = initial_heuristics
        self.population.sort(key=lambda h: h.score, reverse=True)
        print(f"--- Initial Population Generation Complete (Initialized: {len(self.population)}) ---")

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
        
        print(f"Step 1: Generating new candidates for generation {self.current_generation}...")
        for config in strategies_config:
            strategy_name = config["name"]
            strategy_func = config["func"]
            num_parents = config["num_parents"]
            num_to_create = self.population_size # Each strategy creates population_size candidates

            print(f"Applying Strategy {strategy_name} (Target: {num_to_create})...")
            for i in range(1, num_to_create + 1):
                try:
                    parents = self._select_parents(num_parents=num_parents)
                    
                    new_thought, new_code = strategy_func(parents)
                    # Sample index is now strategy-specific to avoid collision
                    code_file_path, thought_file_path = self._save_result_to_file(new_code, new_thought, self.current_generation, i, strategy=strategy_name)
                    
                    generated_candidates_data.append({
                        "thought": new_thought, "code": new_code, "code_file_path": code_file_path, 
                        "thought_file_path": thought_file_path, "generation": self.current_generation, 
                        "parent_ids": [p.id for p in parents], "sample_idx": i, "strategy": strategy_name
                    })
                except (ValueError, RuntimeError, IOError) as e:
                    print(f"Critical error generating candidate via {strategy_name}: {e}")
                    raise
                except Exception as e:
                    print(f"Unexpected critical error during {strategy_name} candidate generation: {e}")
                    raise

        print(f"\nStep 2: Evaluating {len(generated_candidates_data)} new candidates...")
        new_heuristics = []
        for i, candidate_data in enumerate(generated_candidates_data):
            print(f"Evaluating candidate {i+1}/{len(generated_candidates_data)}: {candidate_data['code_file_path']}")
            try:
                base_dir = os.path.join('/project/cad-team/LX_Semicon/kjmin/verilog-eval', self.problem_type)
                test_sv_file = os.path.join(base_dir, f"{self.problem_name}_test.sv")
                ref_sv_file = os.path.join(base_dir, f"{self.problem_name}_ref.sv")
                
                if not os.path.exists(test_sv_file):
                    with open(test_sv_file, "w") as f: f.write("// Dummy test file\n")
                if not os.path.exists(ref_sv_file):
                    with open(ref_sv_file, "w") as f: f.write("// Dummy ref file\n")
                
                results = self.evaluator.evaluate(candidate_data['code_file_path'], test_sv_file, ref_sv_file)
                evaluation_succeeded = (results['status'] == 'success' and 'Mismatches: 0' in results['simulation_stdout'])
                
                feedback_analysis = "N/A"
                final_score = 1.0 if evaluation_succeeded else 0.0

                if not evaluation_succeeded:
                    print(f"Candidate {i+1} evaluation failed. Generating feedback...")
                    feedback_data = self.llm.generate_feedback(
                        self.problem_description, candidate_data['code'], 
                        "\n".join(results.values()), self.default_llm_temp, self.default_llm_top_p, self.default_llm_max_tokens
                    )
                    feedback_analysis = feedback_data['analysis']
                    final_score = feedback_data['score']

                    # Save feedback files
                    model_name_cleaned = self.llm.model_name.replace("/", "_")
                    feedback_file_path = os.path.join(self.base_save_path, model_name_cleaned, self.problem_type, self.problem_name, f"Gen{self.current_generation}", f"{self.problem_name}_{candidate_data['strategy']}_sample{candidate_data['sample_idx']}_feedback.txt")
                    score_file_path = os.path.join(self.base_save_path, model_name_cleaned, self.problem_type, self.problem_name, f"Gen{self.current_generation}", f"{self.problem_name}_{candidate_data['strategy']}_sample{candidate_data['sample_idx']}_score.txt")
                    os.makedirs(os.path.dirname(feedback_file_path), exist_ok=True)
                    with open(feedback_file_path, "w") as f: f.write(feedback_analysis)
                    with open(score_file_path, "w") as f: f.write(f"Score: {final_score}\nJustification: {feedback_data['justification']}")
                else:
                    print(f"Candidate {i+1} evaluation succeeded with no mismatches.")
                    return f"{self.problem_name},{self.current_generation},{candidate_data['strategy']},{candidate_data['code_file_path']}"

                heuristic = Heuristic(
                    candidate_data['thought'], candidate_data['code'], feedback_analysis, final_score,
                    self.current_generation, candidate_data['parent_ids']
                )
                
                new_heuristics.append(heuristic)
                print(f"Processed heuristic: {heuristic}")
            except Exception as e:
                print(f"Critical error evaluating candidate {candidate_data['code_file_path']}: {e}")
                raise

        # Elitism: Combine the old population with all new heuristics and keep the best
        combined_population = self.population + new_heuristics
        combined_population.sort(key=lambda h: h.score, reverse=True)
        self.population = combined_population[:self.population_size]
        
        print(f"--- Generation {self.current_generation} Complete ({len(new_heuristics)} new created) ---")

    def _select_parents(self, num_parents=2):
        if not self.population: 
            raise RuntimeError("Cannot select parents from an empty population.")

        # 거듭제곱을 통해 선택 압력 강화
        selection_pressure = 2.0 
        weights = [(h.score + 0.1) ** selection_pressure for h in self.population]
        
        # random.choices를 사용하여 간단하게 부모 선택 (중복 허용)
        # 이 방식이 더 효율적이고 일반적인 유전 알고리즘 관행에 부합합니다.
        return random.choices(self.population, weights=weights, k=num_parents)

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

        prompt = (
            self.problem_description +
            f"Here are my attempts at solving the same problem, including my thought process, code, and feedback.\n\n"
            f"{parent_prompt}\n\n"
            "Based on the examples above, please implement a unique approach (thought and code) to solve the problem, making it as different from the provided examples as possible. "
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

        prompt = (
            self.problem_description +
            f"\nHere are my attempts at solving the same problem, including my thought process, code, and feedback.\n\n"
            f"{parent_prompt}\n\n"
            "Please refer to the examples above to find their common idea, develop it further, and then implement the best possible thought process and code to solve the problem. "
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

        prompt = (
            self.problem_description +
            f"Here are my attempts at solving the same problem, including my thought process, code, and feedback.\n\n"
            f"{parent_prompt}\n\n"
            "Using the examples above, please modify them to improve the thought process and code for a better solution. "
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

        prompt = (
            self.problem_description +
            f"Here are my attempts at solving the same problem, including my thought process, code, and feedback.\n\n"
            f"{parent_prompt}\n\n"
            "Please refer to the examples above to simplify the thought process and code. You can do this by identifying the essential parts and removing the unnecessary ones to solve the problem. "
            "Remember to format your response with ```thought ... ``` and ```code ... ``` blocks."
        )
        return self.llm.generate_response(
            prompt, 
            temperature=self.default_llm_temp, 
            top_p=self.default_llm_top_p,
            max_tokens=self.default_llm_max_tokens
        )

    def run(self):
        print(f"--- Starting EoH Run: Problem '{self.problem_type}/{self.problem_name}' ---")
        print(f"Generations: {self.num_generations}, Population: {self.population_size}")
        
        try:
            out_str = self.initialize_population() 
        except (RuntimeError, ValueError, Exception) as e: 
            print(f"Critical error during population initialization: {e}")
            print("EoH run aborted.")
            return [], self.history 
        
        if out_str:
            return out_str

        print(f"Initial population initialized with {len(self.population)} heuristics.")

        while self.current_generation < self.num_generations:
            if not self.population : 
                print(f"Stopping evolution at generation {self.current_generation} due to empty population (unexpected).")
                break
            try:
                out_str = self.evolve_one_generation()
                if out_str:
                    return out_str  # If a heuristic passed evaluation, return immediately 
            except (RuntimeError, ValueError, Exception) as e: 
                print(f"Critical error during generation {self.current_generation} evolution: {e}")
                print("EoH run aborted.")
                return self.population, self.history 

        return f"{self.problem_name},failed"
        exit()

        print("\n--- EoH Run Complete ---")
        print("Final Population:")
        if self.population:
            for h in self.population:
                print(h)
        else:
            print("Final population is empty.")
        
        print("\nEvolution Process Summary (Best/Avg Fitness per Generation):")
        for record in self.history:
            print(f"Gen {record['generation']}: Best {record['best_fitness']:.4f}, Avg {record['avg_fitness']:.4f}, Best ID: {record['best_heuristic_id']}")
        
        return self.population, self.history

if __name__ == "__main__":
    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", None) 

    MODEL_NAME = "gpt-3.5-turbo" # alternative models, gpt-4.1, gpt-4.1-mini, gpt-4.1-nano, o3, o4-mini
    # SELECTED_PROBLEMS = "Prob078_dualedge" 
    PROBLEM_TYPE = "dataset_code-complete-iccad2023" 
    POPULATION_SIZE = 10      
    NUM_GENERATIONS = 20      
    DEFAULT_LLM_TEMP = 1.0
    DEFAULT_LLM_TOP_P = 1.0 
    USER_BASE_SAVE_PATH = "/project/cad-team/LX_Semicon/kjmin/EoR/exp" 
    iverilog_executable = "/project/cad-team/LX_Semicon/kjmin/iverilog/install/bin/iverilog"
    vvp_executable = "/project/cad-team/LX_Semicon/kjmin/iverilog/install/bin/vvp"

    with open("/project/cad-team/LX_Semicon/kjmin/verilog-eval/dataset_code-complete-iccad2023/problems.txt", "r") as f:
        problems = f.read().strip().splitlines()

    try:
        if not OPENAI_API_KEY: 
            raise ValueError("A valid OpenAI API key must be set. Found placeholder or missing key.")
        llm_interface = LLMInterface(api_key=OPENAI_API_KEY, model_name=MODEL_NAME)
    except (ValueError, RuntimeError) as e:
        print(f"LLM Initialization Error: {e}")
        print("Please set the OPENAI_API_KEY environment variable or update it in the script.")
        exit(1) 
        
    verilog_evaluator = VerilogEvaluator(
        iverilog_executable_path=iverilog_executable,
        vvp_executable_path=vvp_executable
    )

    with open("../log.txt", "w") as log_file:
        for problem in problems:
            # if "Prob078_dualedge" not in problem: 
            #     continue
            eoh_engine = EoHEngine(
                problem_name=problem,
                problem_type=PROBLEM_TYPE, 
                llm_interface=llm_interface,
                verilog_evaluator=verilog_evaluator,
                population_size=POPULATION_SIZE,
                num_generations=NUM_GENERATIONS,
                default_llm_temp=DEFAULT_LLM_TEMP, 
                default_llm_top_p=DEFAULT_LLM_TOP_P,
                base_save_path=USER_BASE_SAVE_PATH 
            )
            out_str = eoh_engine.run()
            log_file.write(f"{out_str}\n")
            print(out_str)

    # print("\nEoH process finished.")
    # if final_population:
    #     print(f"Best heuristic in final generation: {final_population[0]}")
    # else:
    #     print("No heuristics in the final population.")


    # print("\n--- Measuring Baseline LLM Performance (No EoH) ---")
    
    # print("Requesting direct code generation from baseline LLM...")
    # try:
    #     baseline_prompt_for_parser = f"For the Verilog problem: {eoh_engine.problem_description}, provide a Verilog code solution. " \
    #                                  f"Start with a thought like 'Direct code generation for baseline.' " \
    #                                  f"Format your response with ```thought ... ``` and ```code ... ``` blocks."

    #     baseline_thought, baseline_code = llm_interface.generate_response(
    #         baseline_prompt_for_parser, 
    #         temperature=0.5, 
    #         top_p=1.0
    #     ) 
        
    #     if baseline_code: 
    #         # For baseline, use a specific subdirectory and a fixed sample index (e.g., 0 or "baseline")
    #         baseline_file_path = eoh_engine._save_code_to_file(baseline_code, generation_num="Baseline", sample_idx_in_generation=0)

    #         baseline_fitness = verilog_evaluator.evaluate(baseline_file_path, SELECTED_PROBLEM) 
    #         print(f"Baseline LLM generated code (thought: '{baseline_thought[:50]}...'), File: {baseline_file_path}")
    #         print(f"Baseline LLM fitness: {baseline_fitness:.4f}")
    #     else: 
    #         print("Failed to generate or parse baseline code.") 
    #         print(f"Baseline LLM fitness: 0.0")
    # except (ValueError, RuntimeError) as e: 
    #     print(f"Error during baseline LLM call or parsing: {e}")
    #     print(f"Baseline LLM fitness: 0.0")
    # except Exception as e: 
    #     print(f"Unexpected error during baseline measurement: {e}")
    #     print(f"Baseline LLM fitness: 0.0")

    # print("---------------------------------------------")