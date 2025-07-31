import os
import re
import shutil
import subprocess
from typing import Dict, Any, List

class SynthesisEvaluator:
    def __init__(self, yosys_path="yosys", openroad_path="openroad", pdk_path="./pdk"):
        self.yosys_path = yosys_path
        self.openroad_path = openroad_path
        self.pdk_path = pdk_path

        # Synthesis clk period in nanoseconds
        self.clk_period = 0.01  # ns

        # Get the directory where this script is located (./src/revolution/evaluation.py)
        script_main_dir = os.path.dirname(os.path.abspath(__file__))
        # From there, construct the path to the 'scripts' directory (../../scripts)
        self.script_root_dir = os.path.abspath(os.path.join(script_main_dir, "..", ".."))
        # The ref directory is inside the script root
        self.ref_dir_path = os.path.join(self.script_root_dir, "scripts", "ref")
        # The pdk directory is in the data directory (../../data/pdk)
        self.pdk_path = os.path.abspath(os.path.join(self.script_root_dir, "data", "pdk"))

        # Print directories for debugging
        print(f"Script Main Directory: {script_main_dir}")
        print(f"Script Root Directory: {self.script_root_dir}")
        print(f"Reference Directory: {self.ref_dir_path}")
        print(f"PDK Directory: {self.pdk_path}")

    def evaluate(self, verilog_file, problem_name, synth_top_module_name, output_directory, report_base_path, verilog_evaluator, test_sv_file, ref_sv_file):
        """
        Performs synthesis and PPA analysis on a given Verilog file.
        The report files will be named based on `report_base_path`.
        return format:
        {
            "synthesis_success": bool,  # True if synthesis was successful
            "synthesis_functionality_success": bool,  # True if functionality test passed on the synthesized netlist
            "ppa_success": bool,  # True if PPA analysis was successful
            "synthesis_log": str, # Path to the synthesis report log file
            "ppa_metrics": dict,  # PPA metrics dictionary with keys like "tns", "wns", "eff_clk_period", "power", "area", "report_path"
        }
        """
        if not os.path.exists(output_directory):
            os.makedirs(output_directory)

        synthesized_netlist_path = verilog_file.replace(".sv", ".syn.v")

        synthesis_success, synthesis_log = self._run_synthesis(verilog_file, problem_name, synth_top_module_name, output_directory, report_base_path, synthesized_netlist_path)

        if not synthesis_success:
            return {
                "synthesis_success": False,
                "synthesis_functionality_success": False,  # No functionality test if synthesis failed
                "ppa_success": False,
                "synthesis_log": synthesis_log,
                "ppa_metrics": None
            }

        # After synthesis add post-synthesis functionality test
        synthesis_functionality_success, func_check_log = self._check_synthesis_functionality(
            synthesized_netlist_path,
            test_sv_file,
            ref_sv_file,
            "tb", # Assuming the top module name for the testbench is "tb"
            output_directory,
            verilog_evaluator
        )

        if not synthesis_functionality_success:
            return {
                "synthesis_success": True,
                "synthesis_functionality_success": False,
                "ppa_success": False,
                "synthesis_log": f"{synthesis_log}\n\n--- Post-Synthesis Functional Verification Log ---\n{func_check_log}",
                "ppa_metrics": None
            }

        ppa_metrics = self._parse_ppa_log(synthesis_log)

        return {
            "synthesis_success": True,
            "synthesis_functionality_success": True,
            "ppa_success": True,
            "synthesis_log": synthesis_log,
            "ppa_metrics": ppa_metrics
        }

    def _run_synthesis(self, verilog_file, problem_name, synth_top_module_name, output_directory, report_base_path, synthesized_netlist_path):
        """
        Runs the Yosys synthesis script.
        Synthesis report saved based on report_base_path.
        """

        clk_period = self.clk_period # ns

        output_file = synthesized_netlist_path

        sdc_file_path = self._create_sdc_file(verilog_file, synth_top_module_name, output_directory, clk_period=clk_period)
        yosys_script_path = self._create_yosys_script(verilog_file, synth_top_module_name, output_directory, clk_period, output_file)
        openroad_script_path = self._create_openroad_script(sdc_file_path, synth_top_module_name, output_directory, output_file)

        report_path = report_base_path + "_synthesis_report.rpt" #os.path.join(output_directory, f"{problem_name}_synthesis_report.rpt")

        command = f"yosys {yosys_script_path} && openroad {openroad_script_path} | tee {report_path}"

        # log_path = os.path.join(output_directory, "yosys.log")

        print(f"INFO: Running synthesis command: {command}")

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

    # Method for post-synthesis functionality check/verification
    def _check_synthesis_functionality(self, synthesized_netlist, test_sv, ref_sv, tb_top_module, output_dir, verilog_evaluator):
        """
        Runs a functional simulation on the synthesized netlist using the provided testbench.
        """
        # need to include the verilog files from pdk for simulation of synthesized netlist
        pdk_verilog_lib = os.path.join(self.pdk_path, "Nangate45", "work_around_yosys", "cells.v")
        if not os.path.exists(pdk_verilog_lib):
            error_msg = f"PDK Verilog library not found at: {pdk_verilog_lib}"
            print(f"ERROR: {error_msg}")
            return False, error_msg

        # The evaluator expects a list of files. The synthesized netlist replaces the original DUT.
        # The VerilogEvaluator's evaluate method has been slightly adapted to accept a list of files
        # Example: iverilog -Wall -Winfloop -Wno-timescale -g2012 -o compiled.vvp -s tb testbench.sv synthesized_netlist.syn.v pdk_verilog_lib.v
        sim_results = verilog_evaluator.evaluate(
            generated_sv_file=[synthesized_netlist, pdk_verilog_lib], # Pass synthesized netlist and PDK lib
            test_sv_file=test_sv,
            ref_sv_file=ref_sv,
            top_module_name=tb_top_module
            # Don't use output_directory here, if we pass the synthesized_netlist its .syn suffix will differentiate it from the rtl simulation
        )

        if sim_results["status"] == "compilation_error":
            print(f"Synthesis functionality check failed during compilation: {sim_results.get('compilation_stderr', 'Compilation log not available')}")
        log = f"Compilation Log:\n{sim_results.get('compilation_stderr')}\n\nSimulation Log:\n{sim_results.get('simulation_stdout')}\n{sim_results.get('simulation_stderr')}"

        if sim_results['status'] == 'success':
            output = sim_results.get('simulation_stdout', '')
            # Check for simulation output in two ways:
            # Looks for "Mismatches: 0" in the output (VerilogEvalv2)
            # or checks for "===========Your Design Passed===========" in the output (RTLLMv2)
            m_match = re.search(r'^Mismatches: (\d+)', output, re.M)
            if (m_match and int(m_match.group(1)) == 0) or "===========Your Design Passed===========" in output:
                return True, log

        return False, log


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

    def _create_yosys_script(self, verilog_file, module_name, output_directory, clk_period, output_file):
        yosys_ref = os.path.join(self.ref_dir_path, 'ref.yosys.tcl')
        yosys_gen = f'{output_directory}/{module_name}.yosys.tcl'

        with open(yosys_ref, 'r') as infile:
            with open(yosys_gen, 'w') as outfile:
                text = infile.read()
                text = text.replace("__VERILOG_FILE__", os.path.abspath(verilog_file))
                text = text.replace("__MODULE_NAME__", module_name) # Reverted to using module_name directly as we now extract it from the Verilog file
                text = text.replace("__OUTPUT_DIR__", os.path.abspath(output_directory))
                text = text.replace("__OUTPUT_FILE__", output_file)
                text = text.replace("__REF_DIR__", self.ref_dir_path)
                text = text.replace("__PDK_DIR__", os.path.abspath(self.pdk_path))
                text = text.replace("__CLK_PERIOD__", str(clk_period * 1000))
                outfile.write(text)

        return yosys_gen

    def _create_openroad_script(self, sdc_file_path, module_name, output_directory, output_file):
        # A simplified OpenROAD script. This may need to be adapted for your specific PDK and design.
        or_ref = os.path.join(self.ref_dir_path, 'ref.openroad.tcl')
        or_gen = f'{output_directory}/{module_name}.openroad.tcl'

        with open(or_ref, 'r') as infile:
            with open(or_gen, 'w') as outfile:
                text = infile.read()
                text = text.replace("__UTIL_DIR__", os.path.join(self.script_root_dir, "scripts", "util"))
                text = text.replace("__PDK_DIR__", os.path.abspath(self.pdk_path))
                text = text.replace("__DESIGN_NAME__", module_name)
                text = text.replace("__MODULE_NAME__", module_name) # Reverted to using module_name directly as we now extract it from the Verilog file
                text = text.replace("__NETLIST__", os.path.abspath(f'{output_file}'))
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
            if wns < 0.0: # Indicates that it is a sequential design
                eff_clk_period = self.clk_period - wns
            else: # Indicates that it is a combinational design
                eff_clk_period = 0.0

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
            generated_sv_file (str, list): Path to the generated Verilog file (or list of files consisting of actual test file and pdk verilog files when used for synthesis functionality check).
                (Note when giving a list of files the first path should be the generated Verilog file, the rest are additional files to include in the compilation).
                (This is important because the first file in the list is used to determine output_basename in case of a list and no output_directory is given).
            test_sv_file (str): Path to the testbench Verilog file.
            ref_sv_file (str, None): Path to the reference Verilog file. (Sometimes could be omitted by passing None)
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
        # Handl single file or list of files for test_sv_file
        if isinstance(generated_sv_file, str):
            dut_files = [generated_sv_file]
            output_basename = os.path.splitext(os.path.basename(generated_sv_file))[0]
            if not os.path.isfile(generated_sv_file):
                return self._format_result("file_error", log_file_path=None, compiled_file_path=None,
                                         comp_stderr=f"Generated Verilog file not found: {generated_sv_file}")
            # Determine paths using the string
            if output_directory is None:
                actual_output_dir = os.path.dirname(generated_sv_file)
            else:
                actual_output_dir = output_directory
            output_basename = os.path.splitext(os.path.basename(generated_sv_file))[0]

        elif isinstance(generated_sv_file, list):
            dut_files = generated_sv_file
            # The first file in the list is considered the generated Verilog file and used to determine the output basename
            main_dut_file = dut_files[0]
            # Check for duplicates within the list while ensuring the first file is always included first
            dut_files = list(dict.fromkeys(dut_files))  # Removes duplicates while preserving order
            for f in dut_files:
                if not os.path.isfile(f):
                    return self._format_result("file_error", log_file_path=None, compiled_file_path=None,
                                             comp_stderr=f"Additional Verilog file not found: {f}")

            # Determine paths using the FIRST element of the list
            if output_directory is None:
                actual_output_dir = os.path.dirname(main_dut_file)
            else:
                actual_output_dir = output_directory
            output_basename = os.path.splitext(os.path.basename(main_dut_file))[0]
        else:
            return self._format_result("file_error", log_file_path=None, compiled_file_path=None,
                                     comp_stderr="Invalid type for generated_sv_file. Expected str or list of str.")

        if not os.path.isfile(test_sv_file):
            return self._format_result("file_error", log_file_path=None, compiled_file_path=None,
                                     comp_stderr=f"Test Verilog file not found: {test_sv_file}")
        # Check if the reference file is provided and exists
        if ref_sv_file is None:
            pass
        elif not os.path.isfile(ref_sv_file):
            # If ref_sv_file is not None, it should be a valid file path
            # If it is None, we skip this check
            return self._format_result("file_error", log_file_path=None, compiled_file_path=None,
                                     comp_stderr=f"Reference Verilog file not found: {ref_sv_file}")




        os.makedirs(actual_output_dir, exist_ok=True)
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
        compile_cmd_list.extend(dut_files)  # Add the generated Verilog file(s)
        # Add logic for testing for duplicate files, if the same file is given multiple times, it should be added only once
        # This guard is necessary as when applying this function for reference files ref_sv_file might be the same as generated_sv_file,
        # So we need to ensure we don't add it multiple times. To avoid simulation errors.
        if test_sv_file not in dut_files:
            compile_cmd_list.append(test_sv_file)
        if ref_sv_file not in dut_files:
            # Skip adding ref_sv_file if it is None
            # This is to avoid errors when the reference file is not provided
            if ref_sv_file is not None:
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
            simulation_working_dir = os.path.dirname(dut_files[0])
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