import json
import os
import re
import signal
import shutil
import subprocess
import traceback
from pathlib import Path
from typing import Any, Literal, NamedTuple

_NETLIST_INSTANCE_RE = re.compile(
    r"^\s*([\\$A-Za-z_][\\$A-Za-z0-9_]*)\s+([\\$A-Za-z_][\\$A-Za-z0-9_]*)\s*\(",
    re.M,
)
_SEQ_CELL_PATTERNS = (
    re.compile(r"(^|_)DFF"),
    re.compile(r"(^|_)SDFF"),
    re.compile(r"(^|_)ADFF"),
    re.compile(r"(^|_)DLH"),
    re.compile(r"(^|_)DLL"),
    re.compile(r"(^|_)LHQ"),
    re.compile(r"(^|_)LATCH"),
)
_MUX_CELL_PATTERNS = (
    re.compile(r"MUX"),
    re.compile(r"MXI"),
)
_ARITH_CELL_PATTERNS = (
    re.compile(r"(^|_)FA"),
    re.compile(r"(^|_)HA"),
    re.compile(r"ADD"),
    re.compile(r"ADDF"),
    re.compile(r"FADD"),
)
_PROCESS_TERMINATION_GRACE_SECONDS = 5.0


class _CommandResult(NamedTuple):
    returncode: int
    stdout: str
    stderr: str
    timed_out: bool


def _run_command(
    command: list[str],
    *,
    timeout_s: int | float | None,
    cwd: str | None = None,
) -> _CommandResult:
    popen_kwargs: dict[str, Any] = {
        "stdout": subprocess.PIPE,
        "stderr": subprocess.PIPE,
        "text": True,
        "cwd": cwd,
    }
    if os.name != "nt":
        popen_kwargs["start_new_session"] = True

    process = subprocess.Popen(command, **popen_kwargs)
    try:
        stdout, stderr = process.communicate(timeout=timeout_s)
        return _CommandResult(
            returncode=process.returncode if process.returncode is not None else -1,
            stdout=stdout or "",
            stderr=stderr or "",
            timed_out=False,
        )
    except subprocess.TimeoutExpired:
        if os.name == "nt":
            process.terminate()
        else:
            try:
                os.killpg(process.pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
        try:
            stdout, stderr = process.communicate(
                timeout=_PROCESS_TERMINATION_GRACE_SECONDS
            )
        except subprocess.TimeoutExpired:
            if os.name == "nt":
                process.kill()
            else:
                try:
                    os.killpg(process.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
            stdout, stderr = process.communicate()
        return _CommandResult(
            returncode=process.returncode if process.returncode is not None else -1,
            stdout=stdout or "",
            stderr=stderr or "",
            timed_out=True,
        )


class VerilogEvaluator:
    """
    Handles the compilation and simulation of Verilog files using Icarus Verilog.

    This class provides a standardized way to run Verilog simulations,
    capturing outputs, handling errors, and managing timeouts.
    """

    def __init__(
        self,
        iverilog_executable_path: str,
        vvp_executable_path: str,
        default_simulation_timeout_seconds: int = 60,
    ) -> None:
        if not shutil.which(iverilog_executable_path):
            raise FileNotFoundError(
                f"Icarus Verilog executable (iverilog) not found or not executable at: {iverilog_executable_path}. "
                f"Please provide a valid absolute path or ensure it's in your system PATH."
            )
        self.iverilog_executable: str = iverilog_executable_path

        if not shutil.which(vvp_executable_path):
            raise FileNotFoundError(
                f"Icarus Verilog runtime (vvp) not found or not executable at: {vvp_executable_path}. "
                f"Please provide a valid absolute path or ensure it's in your system PATH."
            )
        self.vvp_executable: str = vvp_executable_path
        self.default_simulation_timeout_seconds = int(default_simulation_timeout_seconds)

        # Base flags for iverilog compilation
        self.base_iverilog_flags: list[str] = [
            "-Wall",
            "-Winfloop",
            "-Wno-timescale",
            "-g2012",
        ]

    def evaluate(
        self,
        generated_sv_file: str | list[str],
        test_sv_file: str,
        ref_sv_file: str | None,
        top_module_name: str = "tb",
        output_directory: str | None = None,
        simulation_timeout_seconds: int | None = None,
        enable_vcd_probe: bool = False,
    ) -> dict[str, Any]:
        """
        Compiles and simulates the given Verilog files.
        The generated Verilog file(s) is compiled to generate a `.vvp` file,
        then runs the simulation using the provided testbench file.

        :param generated_sv_file: Path to the generated Verilog file, or a list of files
            (e.g., DUT + PDK cells). If a list is provided, the first file is assumed to
            be the primary DUT used for naming outputs.
        :type generated_sv_file: str | list[str]

        :param test_sv_file: Path to the Verilog testbench file.
        :type test_sv_file: str

        :param ref_sv_file: Optional path to a reference Verilog file for simulation comparison.
        :type ref_sv_file: str | None

        :param top_module_name: Name of the top-level module in the testbench. Defaults to "tb".
        :type top_module_name: str

        :param output_directory: Directory to store compiled outputs and logs.
            Defaults to the directory of ``generated_sv_file``.
        :type output_directory: str | None

        :param simulation_timeout_seconds: Timeout for simulation execution in seconds. Defaults to 60.
        :type simulation_timeout_seconds: int

        :return: Dictionary containing the following keys:

            - ``status`` (str): One of "success", "compilation_error", "simulation_error", "simulation_timeout", or "file_error".
            - ``log_file_path`` (str | None): Path to the full simulation log.
            - ``compiled_file_path`` (str | None): Path to the compiled `.vvp` file, or None if compilation failed.
            - ``compilation_stdout`` (str): Standard output from the compiler.
            - ``compilation_stderr`` (str): Standard error from the compiler.
            - ``simulation_stdout`` (str): Standard output from the simulator.
            - ``simulation_stderr`` (str): Standard error from the simulator.
            - ``vcd_file_path`` (str | None): Path to an emitted activity VCD
              when `enable_vcd_probe=True`.
        :rtype: dict[str, Any]
        """

        vcd_file_path: str | None = None
        effective_timeout = (
            self.default_simulation_timeout_seconds
            if simulation_timeout_seconds is None
            else int(simulation_timeout_seconds)
        )

        # --- 1. Determine paths and prepare ---
        # Handle single file or list of files for test_sv_file
        if isinstance(generated_sv_file, str):
            dut_files = [generated_sv_file]
            output_basename = os.path.splitext(os.path.basename(generated_sv_file))[0]
            if not os.path.isfile(generated_sv_file):
                return self._format_result(
                    "file_error",
                    log_file_path=None,
                    compiled_file_path=None,
                    comp_stderr=f"Generated Verilog file not found: {generated_sv_file}",
                )
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
            dut_files = list(
                dict.fromkeys(dut_files)
            )  # Removes duplicates while preserving order
            for f in dut_files:
                if not os.path.isfile(f):
                    return self._format_result(
                        "file_error",
                        log_file_path=None,
                        compiled_file_path=None,
                        comp_stderr=f"Additional Verilog file not found: {f}",
                    )

            # Determine paths using the FIRST element of the list
            if output_directory is None:
                actual_output_dir = os.path.dirname(main_dut_file)
            else:
                actual_output_dir = output_directory
            output_basename = os.path.splitext(os.path.basename(main_dut_file))[0]
        else:
            return self._format_result(
                "file_error",
                log_file_path=None,
                compiled_file_path=None,
                comp_stderr="Invalid type for generated_sv_file. Expected str or list of str.",
            )

        if not os.path.isfile(test_sv_file):
            return self._format_result(
                "file_error",
                log_file_path=None,
                compiled_file_path=None,
                comp_stderr=f"Test Verilog file not found: {test_sv_file}",
            )
        # Check if the reference file is provided and exists
        if ref_sv_file is None:
            pass
        elif not os.path.isfile(ref_sv_file):
            # If ref_sv_file is not None, it should be a valid file path
            # If it is None, we skip this check
            return self._format_result(
                "file_error",
                log_file_path=None,
                compiled_file_path=None,
                comp_stderr=f"Reference Verilog file not found: {ref_sv_file}",
            )

        actual_output_dir = os.path.abspath(actual_output_dir)
        os.makedirs(actual_output_dir, exist_ok=True)
        compiled_vvp_file = os.path.join(
            actual_output_dir, output_basename + "_compiled.vvp"
        )
        log_file = os.path.join(actual_output_dir, output_basename + "_simulation.log")
        vcd_file_path = (
            os.path.join(actual_output_dir, output_basename + "_activity.vcd")
            if enable_vcd_probe
            else None
        )
        compile_test_sv_file = (
            self._prepare_vcd_probe_testbench(
                test_sv_file,
                top_module_name=top_module_name,
                output_directory=actual_output_dir,
                vcd_file_path=vcd_file_path,
            )
            if enable_vcd_probe and vcd_file_path is not None
            else test_sv_file
        )

        # Initialize result components
        comp_stdout, comp_stderr = "", ""
        sim_stdout, sim_stderr = "", ""

        # --- 2. Compile Verilog files ---
        compile_cmd_list = [self.iverilog_executable]
        compile_cmd_list.extend(self.base_iverilog_flags)
        compile_cmd_list.extend(["-s", top_module_name])  # Specify top module
        compile_cmd_list.extend(["-o", compiled_vvp_file])
        compile_cmd_list.extend(dut_files)  # Add the generated Verilog file(s)
        # Add logic for testing for duplicate files, if the same file is given multiple times, it should be added only once
        # This guard is necessary as when applying this function for reference files ref_sv_file might be the same as generated_sv_file,
        # So we need to ensure we don't add it multiple times. To avoid simulation errors.
        if compile_test_sv_file not in dut_files:
            compile_cmd_list.append(compile_test_sv_file)
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
                compile_process = _run_command(
                    compile_cmd_list,
                    timeout_s=effective_timeout,
                )
                comp_stdout = compile_process.stdout or ""
                comp_stderr = compile_process.stderr or ""

                lf.write(f"Return Code: {compile_process.returncode}\n")
                lf.write("Stdout:\n")
                lf.write(comp_stdout + "\n")
                lf.write("Stderr:\n")
                lf.write(comp_stderr + "\n")
                lf.write(f"Timed Out: {compile_process.timed_out}\n")

                if compile_process.timed_out:
                    timeout_msg = (
                        f"Compilation timed out after {effective_timeout} seconds."
                    )
                    print(f"ERROR: {timeout_msg}")
                    lf.write(f"TIMEOUT ERROR: {timeout_msg}\n")
                    return self._format_result(
                        "compilation_error",
                        log_file,
                        None,
                        comp_stdout,
                        timeout_msg,
                        vcd_file_path=vcd_file_path,
                    )
                if compile_process.returncode != 0:
                    print(f"ERROR: Compilation failed. See {log_file} for details.")
                    return self._format_result(
                        "compilation_error",
                        log_file,
                        None,
                        comp_stdout,
                        comp_stderr,
                        vcd_file_path=vcd_file_path,
                    )
                print(f"INFO: Compilation successful. Output: {compiled_vvp_file}")

            except FileNotFoundError:
                # This case should ideally be caught by __init__, but as a safeguard:
                error_msg = f"Icarus Verilog executable (iverilog) not found during compilation. Path: {self.iverilog_executable}"
                print(f"ERROR: {error_msg}")
                lf.write(f"CRITICAL ERROR: {error_msg}\n")
                return self._format_result(
                    "file_error",
                    log_file,
                    None,
                    comp_stderr=error_msg,
                    vcd_file_path=vcd_file_path,
                )
            except Exception as e:
                error_msg = f"An unexpected error occurred during compilation: {e}"
                print(f"ERROR: {error_msg}")
                lf.write(f"CRITICAL ERROR: {error_msg}\n")
                return self._format_result(
                    "compilation_error",
                    log_file,
                    None,
                    comp_stderr=error_msg,
                    vcd_file_path=vcd_file_path,
                )

            lf.write("\n--- Simulation Phase ---\n")
            # --- 3. Simulate the compiled VVP file ---
            # The compiled .vvp file is typically made executable by iverilog using a shebang
            # pointing to the vvp runtime.
            if os.name != "nt":  # On non-Windows systems, ensure it's executable
                try:
                    os.chmod(compiled_vvp_file, 0o755)  # rwxr-xr-x
                except OSError as e:
                    print(
                        f"WARNING: Could not set execute permission on {compiled_vvp_file}: {e}"
                    )
                    lf.write(
                        f"WARNING: Could not set execute permission on {compiled_vvp_file}: {e}\n"
                    )

            # Execute using the vvp runtime directly
            run_cmd_list = [self.vvp_executable, compiled_vvp_file]
            print(f"INFO: Simulation command: {' '.join(run_cmd_list)}")
            lf.write(f"Command: {' '.join(run_cmd_list)}\n\n")

            # Set the working directory to the location of the testbench file (this is to include the miscellaneous files sometimes required by the testbench)
            # Some modules in RTLLM have files that supply the input and output files for the testbench
            # Examples: Prob013_test_data.dat, Prob026_asyn_fifo_tdata.txt, Prob026_asyn_fifo_rempty.txt,
            # Prob026_asyn_fifo_wfull.txt, Prob035_calendar_reference.txt, Prob045_alu_reference.dat,
            # Prob049_signal_generator_tri_gen.txt
            simulation_working_dir = os.path.abspath(os.path.dirname(dut_files[0]))
            print(f"INFO: Running simulation in directory: {simulation_working_dir}")
            lf.write(f"Working Directory: {simulation_working_dir}\n\n")

            try:
                run_process = _run_command(
                    run_cmd_list,
                    timeout_s=effective_timeout,
                    cwd=simulation_working_dir,  # Set the working directory for the simulation
                )
                sim_stdout = run_process.stdout or ""
                sim_stderr = run_process.stderr or ""

                lf.write(f"Return Code: {run_process.returncode}\n")
                lf.write("Stdout:\n")
                lf.write(sim_stdout + "\n")
                lf.write("Stderr:\n")
                lf.write(sim_stderr + "\n")
                lf.write(f"Timed Out: {run_process.timed_out}\n")

                if run_process.timed_out:
                    timeout_msg = (
                        f"Simulation timed out after {effective_timeout} seconds."
                    )
                    print(f"ERROR: {timeout_msg}")
                    lf.write(f"TIMEOUT ERROR: {timeout_msg}\n")
                    return self._format_result(
                        "simulation_timeout",
                        log_file,
                        compiled_vvp_file,
                        comp_stdout,
                        comp_stderr,
                        sim_stdout,
                        timeout_msg,
                        vcd_file_path=vcd_file_path,
                    )
                if run_process.returncode == 0:
                    print(f"INFO: Simulation successful. See {log_file} for details.")
                    return self._format_result(
                        "success",
                        log_file,
                        compiled_vvp_file,
                        comp_stdout,
                        comp_stderr,
                        sim_stdout,
                        sim_stderr,
                        vcd_file_path=vcd_file_path,
                    )
                else:
                    # Non-zero return code could be due to $finish(X) with X!=0, or runtime errors.
                    print(
                        f"ERROR: Simulation finished with non-zero status ({run_process.returncode}). See {log_file} for details."
                    )
                    return self._format_result(
                        "simulation_error",
                        log_file,
                        compiled_vvp_file,
                        comp_stdout,
                        comp_stderr,
                        sim_stdout,
                        sim_stderr,
                        vcd_file_path=vcd_file_path,
                    )

            except FileNotFoundError:
                # This case should ideally be caught by __init__, but as a safeguard:
                error_msg = f"vvp executable not found during simulation. Path: {self.vvp_executable}"
                print(f"ERROR: {error_msg}")
                lf.write(f"CRITICAL ERROR: {error_msg}\n")
                return self._format_result(
                    "file_error",
                    log_file,
                    compiled_vvp_file,
                    comp_stdout,
                    comp_stderr,
                    sim_stderr=error_msg,
                    vcd_file_path=vcd_file_path,
                )
            except Exception as e:
                error_msg = f"An unexpected error occurred during simulation: {e}"
                print(f"ERROR: {error_msg}")
                lf.write(f"CRITICAL ERROR: {error_msg}\n")
                return self._format_result(
                    "simulation_error",
                    log_file,
                    compiled_vvp_file,
                    comp_stdout,
                    comp_stderr,
                    sim_stderr=error_msg,
                    vcd_file_path=vcd_file_path,
                )

    def _prepare_vcd_probe_testbench(
        self,
        test_sv_file: str,
        *,
        top_module_name: str,
        output_directory: str,
        vcd_file_path: str,
    ) -> str:
        """Create a temporary testbench copy with a VCD probe injected."""
        testbench_text = Path(test_sv_file).read_text(encoding="utf-8", errors="ignore")
        instrumented = self._inject_vcd_probe(
            testbench_text,
            top_module_name=top_module_name,
            vcd_file_path=vcd_file_path,
        )
        if instrumented == testbench_text:
            return test_sv_file
        probe_path = os.path.join(
            output_directory,
            f"{Path(test_sv_file).stem}_qd_probe{Path(test_sv_file).suffix}",
        )
        with open(probe_path, "w", encoding="utf-8") as handle:
            handle.write(instrumented)
        return probe_path

    def _inject_vcd_probe(
        self,
        testbench_text: str,
        *,
        top_module_name: str,
        vcd_file_path: str,
    ) -> str:
        """Inject a dumpfile/dumpvars block into the target testbench module."""
        module_pattern = re.compile(rf"\bmodule\s+{re.escape(top_module_name)}\b")
        endmodule_pattern = re.compile(r"\bendmodule\b")
        module_match = module_pattern.search(testbench_text)
        if module_match is None:
            return testbench_text
        end_match = endmodule_pattern.search(testbench_text, module_match.end())
        if end_match is None:
            return testbench_text
        escaped_vcd_path = vcd_file_path.replace("\\", "\\\\")
        probe = (
            "\n// QD dynamic descriptor probe\n"
            "initial begin\n"
            f'  $dumpfile("{escaped_vcd_path}");\n'
            f"  $dumpvars(0, {top_module_name});\n"
            "end\n\n"
        )
        return f"{testbench_text[:end_match.start()]}{probe}{testbench_text[end_match.start():]}"

    def _format_result(
        self,
        status: Literal[
            "success",
            "compilation_error",
            "simulation_error",
            "simulation_timeout",
            "file_error",
        ],
        log_file_path: str | None,
        compiled_file_path: str | None,
        comp_stdout: str = "",
        comp_stderr: str = "",
        sim_stdout: str = "",
        sim_stderr: str = "",
        vcd_file_path: str | None = None,
    ) -> dict[str, str | None]:
        """Helper method to format the return dictionary.

        :param status: Status of the evaluation.
        :type status: Literal["success", "compilation_error", "simulation_error", "simulation_timeout", "file_error"]
        :param log_file_path: Path to the log file.
        :type log_file_path: str | None
        :param compiled_file_path: Path to the compiled VVP file.
        :type compiled_file_path: str | None
        :param comp_stdout: Standard output from the compilation.
        :type comp_stdout: str
        :param comp_stderr: Standard error from the compilation.
        :type comp_stderr: str
        :param sim_stdout: Standard output from the simulation.
        :type sim_stdout: str
        :param sim_stderr: Standard error from the simulation.
        :type sim_stderr: str
        :return: A dictionary containing the evaluation results.
        :rtype: dict[str, str | None]
        """
        return {
            "status": status,
            "log_file_path": log_file_path,
            "compiled_file_path": compiled_file_path,
            "compilation_stdout": comp_stdout,
            "compilation_stderr": comp_stderr,
            "simulation_stdout": sim_stdout,
            "simulation_stderr": sim_stderr,
            "vcd_file_path": vcd_file_path,
        }


class SynthesisEvaluator:
    """
    Manages the hardware synthesis and PPA evaluation flow using Yosys and OpenROAD.
    """

    def __init__(
        self,
        yosys_path: str = "yosys",
        openroad_path: str = "openroad",
        pdk_path: str | None = None,
        default_simulation_timeout_s: int = 300,
        default_synthesis_timeout_s: int = 300,
    ) -> None:
        """
        Initialize the synthesis evaluator with toolchain paths and environment configuration.

        :param yosys_path: Path to the Yosys binary.
        :param openroad_path: Path to the OpenROAD binary.
        :param pdk_path: Path to the standard cell PDK directory.
        """
        self.yosys_path: str = yosys_path
        self.openroad_path: str = openroad_path
        self.default_simulation_timeout_s = int(default_simulation_timeout_s)
        self.default_synthesis_timeout_s = int(default_synthesis_timeout_s)

        # Synthesis clk period in nanoseconds
        self.clk_period: float = 0.01  # ns

        # Get the directory where this script is located (./src/revolution/evaluation.py)
        script_main_dir = os.path.dirname(os.path.abspath(__file__))
        # From there, construct the path to the 'scripts' directory (../../scripts)
        self.script_root_dir: str = os.path.abspath(
            os.path.join(script_main_dir, "..", "..")
        )
        # The ref directory is inside the script root
        self.ref_dir_path: str = os.path.join(self.script_root_dir, "scripts", "ref")
        # The pdk directory is in the data directory (../../data/pdk)
        default_pdk_path = os.path.abspath(
            os.path.join(self.script_root_dir, "data", "pdk")
        )
        self.pdk_path: str = (
            default_pdk_path if pdk_path is None else os.path.abspath(pdk_path)
        )

        # Print directories for debugging
        print(f"Script Main Directory: {script_main_dir}")
        print(f"Script Root Directory: {self.script_root_dir}")
        print(f"Reference Directory: {self.ref_dir_path}")
        print(f"PDK Directory: {self.pdk_path}")

    def evaluate(
        self,
        verilog_file: str,
        problem_name: str,
        synth_top_module_name: str,
        output_directory: str,
        report_base_path: str,
        verilog_evaluator: VerilogEvaluator,
        test_sv_file: str,
        ref_sv_file: str | None,
        simulation_timeout_s: int | None = None,
        synthesis_timeout_s: int | None = None,
    ) -> dict[str, bool | str | None | dict[str, Any]]:
        """
        Performs synthesis, PPA analysis, and post-synthesis verification.
        Run Yosys synthesis script, to convert the Verilog file to a synthesized netlist.
        Then uses VerilogEvaluator to run a functional simulation on the synthesized netlist
        using the provided testbench and reference design (if available).
        (Depending on benchmark testbench requires a reference design to compare against).
        Finally, uses the netlist to run OpenROAD to perform PPA analysis.

        :param verilog_file: Path to the input Verilog file.
        :param problem_name: Name of the problem/design.
        :param synth_top_module_name: Name of the top-level module for synthesis.
        :param output_directory: Directory for all generated files.
        :param report_base_path: Base path for naming report files.
        :param verilog_evaluator: An instance of VerilogEvaluator for simulation.
        :param test_sv_file: Path to the testbench for functional verification.
        :param ref_sv_file: Path to the reference design for the testbench (optional).
        :param simulation_timeout_s: Timeout for the simulation in seconds.
        :return: A dictionary containing the synthesis and PPA results.
        """
        if not os.path.exists(output_directory):
            os.makedirs(output_directory)

        synthesized_netlist_path = verilog_file.replace(".sv", ".syn.v")
        effective_simulation_timeout_s = (
            self.default_simulation_timeout_s
            if simulation_timeout_s is None
            else int(simulation_timeout_s)
        )
        effective_synthesis_timeout_s = (
            self.default_synthesis_timeout_s
            if synthesis_timeout_s is None
            else int(synthesis_timeout_s)
        )

        synthesis_success, synthesis_log = self._run_synthesis(
            verilog_file,
            problem_name,
            synth_top_module_name,
            output_directory,
            report_base_path,
            synthesized_netlist_path,
            synthesis_timeout_s=effective_synthesis_timeout_s,
        )

        if not synthesis_success:
            return {
                "synthesis_success": False,
                "synthesis_functionality_success": False,  # No functionality test if synthesis failed
                "ppa_success": False,
                "synthesis_log": synthesis_log,
                "ppa_metrics": None,
                "structural_metrics": {},
                "physical_metrics": {},
                "metrics_sidecar_path": None,
            }

        structural_metrics = self._extract_structural_metrics(synthesized_netlist_path)

        # After synthesis add post-synthesis functionality test
        synthesis_functionality_success, func_check_log = (
            self._check_synthesis_functionality(
                synthesized_netlist_path,
                test_sv_file,
                ref_sv_file,
                "tb",  # Assuming the top module name for the testbench is "tb"
                output_directory,
                verilog_evaluator,
                simulation_timeout_s=effective_simulation_timeout_s,
            )
        )

        if not synthesis_functionality_success:
            return {
                "synthesis_success": True,
                "synthesis_functionality_success": False,
                "ppa_success": False,
                "synthesis_log": f"{synthesis_log}\n\n--- Post-Synthesis Functional Verification Log ---\n{func_check_log}",
                "ppa_metrics": None,
                "structural_metrics": structural_metrics,
                "physical_metrics": self._parse_openroad_physical_metrics(
                    synthesis_log
                ),
                "metrics_sidecar_path": None,
            }

        ppa_metrics = self._parse_ppa_log(synthesis_log)
        physical_metrics = self._parse_openroad_physical_metrics(synthesis_log)
        metrics_sidecar_path = self._write_metrics_sidecar(
            synthesis_log,
            ppa_metrics=ppa_metrics,
            structural_metrics=structural_metrics,
            physical_metrics=physical_metrics,
        )

        return {
            "synthesis_success": True,
            "synthesis_functionality_success": True,
            "ppa_success": True,
            "synthesis_log": synthesis_log,
            "ppa_metrics": ppa_metrics,
            "structural_metrics": structural_metrics,
            "physical_metrics": physical_metrics,
            "metrics_sidecar_path": metrics_sidecar_path,
        }

    def _run_synthesis(
        self,
        verilog_file: str,
        problem_name: str,
        synth_top_module_name: str,
        output_directory: str,
        report_base_path: str,
        synthesized_netlist_path: str,
        synthesis_timeout_s: int = 300,
    ) -> tuple[bool, str]:
        """
        Runs the Yosys and OpenROAD synthesis script.

        :param verilog_file: Path to the input Verilog file.
        :param problem_name: Name of the problem/design.
        :param synth_top_module_name: Name of the top-level module for synthesis.
        :param output_directory: Directory for all generated files.
        :param report_base_path: Base path for naming report files.
        :param synthesized_netlist_path: Path to save the synthesized netlist.
        :param synthesis_timeout_s: Timeout for the synthesis process in seconds.
        :return: A tuple containing a success boolean and the path to the report log.
        """

        clk_period = self.clk_period  # ns

        output_file = synthesized_netlist_path

        sdc_file_path = self._create_sdc_file(
            verilog_file, synth_top_module_name, output_directory, clk_period=clk_period
        )
        yosys_script_path = self._create_yosys_script(
            verilog_file,
            synth_top_module_name,
            output_directory,
            clk_period,
            output_file,
        )
        openroad_script_path = self._create_openroad_script(
            sdc_file_path, synth_top_module_name, output_directory, output_file
        )

        report_path = (
            report_base_path + "_synthesis_report.rpt"
        )  # os.path.join(output_directory, f"{problem_name}_synthesis_report.rpt")

        yosys_command = [self.yosys_path, yosys_script_path]
        openroad_command = [self.openroad_path, openroad_script_path]
        report_lines: list[str] = []

        def _append_stage(stage_name: str, command: list[str], result: _CommandResult) -> None:
            report_lines.append(f"--- {stage_name.upper()} ---\n")
            report_lines.append(f"Command: {' '.join(command)}\n")
            report_lines.append(f"Return Code: {result.returncode}\n")
            report_lines.append(f"Timed Out: {result.timed_out}\n")
            report_lines.append("Stdout:\n")
            report_lines.append(result.stdout)
            report_lines.append("\nStderr:\n")
            report_lines.append(result.stderr)
            report_lines.append("\n\n")

        def _write_report() -> None:
            with open(report_path, "w", encoding="utf-8") as handle:
                handle.write("".join(report_lines))

        print(f"INFO: Running synthesis command: {' '.join(yosys_command)}")

        try:
            yosys_result = _run_command(
                yosys_command,
                timeout_s=synthesis_timeout_s,
            )
            _append_stage("yosys", yosys_command, yosys_result)
            if yosys_result.timed_out:
                timeout_msg = (
                    f"Synthesis timed out in stage 'yosys' after {synthesis_timeout_s} seconds."
                )
                print(f"ERROR: {timeout_msg}")
                report_lines.append(
                    f"--- SYNTHESIS/Physical Design FAILED: TIMEOUT ---\n{timeout_msg}\n"
                )
                _write_report()
                return False, report_path
            if yosys_result.returncode != 0:
                print(f"Synthesis failed. Error: {yosys_result.stderr}")
                report_lines.append("\n--- SYNTHESIS FAILED ---\n")
                _write_report()
                return False, report_path

            print(f"INFO: Running synthesis command: {' '.join(openroad_command)}")
            openroad_result = _run_command(
                openroad_command,
                timeout_s=synthesis_timeout_s,
            )
            _append_stage("openroad", openroad_command, openroad_result)
            if openroad_result.timed_out:
                timeout_msg = (
                    f"Synthesis timed out in stage 'openroad' after {synthesis_timeout_s} seconds."
                )
                print(f"ERROR: {timeout_msg}")
                report_lines.append(
                    f"--- SYNTHESIS/Physical Design FAILED: TIMEOUT ---\n{timeout_msg}\n"
                )
                _write_report()
                return False, report_path
            if openroad_result.returncode == 0:
                _write_report()
                print(f"Synthesis completed successfully. Report saved to {report_path}")
                return True, report_path
            print(f"Synthesis failed. Error: {openroad_result.stderr}")
            report_lines.append("\n--- SYNTHESIS FAILED ---\n")
            _write_report()
            return False, report_path

        except Exception as e:
            error_msg = f"An unexpected error occurred while running the synthesis process: {e}"
            tb = traceback.format_exc()
            print(f"ERROR: {error_msg}")
            # Overwrite the report file with the crash details
            with open(report_path, "w", encoding="utf-8") as f:
                f.write(f"--- SYNTHESIS/Physical Design FAILED: UNEXPECTED CRASH ---\n{error_msg}\n\nTraceback:\n{tb}\n")
            return False, report_path

    # Method for post-synthesis functionality check/verification
    def _check_synthesis_functionality(
        self,
        synthesized_netlist: str,
        test_sv: str,
        ref_sv: str | None,
        tb_top_module: str,
        output_dir: str,
        verilog_evaluator: VerilogEvaluator,
        simulation_timeout_s: int = 300,
    ) -> tuple[bool, str]:
        """
        Runs a functional simulation on the synthesized netlist using the provided testbench.

        :param synthesized_netlist: Path to the synthesized netlist file.
        :param test_sv: Path to the testbench Verilog file.
        :param ref_sv: Path to the reference design Verilog file (optional).
        :param tb_top_module: Name of the top-level module in the testbench.
        :param output_dir: Directory for output files.
        :param verilog_evaluator: An instance of VerilogEvaluator for simulation.
        :param simulation_timeout_s: Timeout for the simulation in seconds.
        :return: A tuple containing a success boolean and the log of the simulation.
        """
        # need to include the verilog files from pdk for simulation of synthesized netlist
        pdk_verilog_lib = os.path.join(
            self.pdk_path, "Nangate45", "work_around_yosys", "cells.v"
        )
        if not os.path.exists(pdk_verilog_lib):
            error_msg = f"PDK Verilog library not found at: {pdk_verilog_lib}"
            print(f"ERROR: {error_msg}")
            return False, error_msg

        # The evaluator expects a list of files. The synthesized netlist replaces the original DUT.
        # The VerilogEvaluator's evaluate method has been slightly adapted to accept a list of files
        # Example: iverilog -Wall -Winfloop -Wno-timescale -g2012 -o compiled.vvp -s tb testbench.sv synthesized_netlist.syn.v pdk_verilog_lib.v
        sim_results = verilog_evaluator.evaluate(
            generated_sv_file=[
                synthesized_netlist,
                pdk_verilog_lib,
            ],  # Pass synthesized netlist and PDK lib
            test_sv_file=test_sv,
            ref_sv_file=ref_sv,
            top_module_name=tb_top_module,
            simulation_timeout_seconds=simulation_timeout_s,
            # Don't use output_directory here, if we pass the synthesized_netlist its .syn suffix will differentiate it from the rtl simulation
        )

        if sim_results["status"] == "compilation_error":
            print(
                f"Synthesis functionality check failed during compilation: {sim_results.get('compilation_stderr', 'Compilation log not available')}"
            )
        log = f"Compilation Log:\n{sim_results.get('compilation_stderr')}\n\nSimulation Log:\n{sim_results.get('simulation_stdout')}\n{sim_results.get('simulation_stderr')}"

        if sim_results["status"] == "success":
            output = sim_results.get("simulation_stdout", "")
            # Check for simulation output in two ways:
            # Looks for "Mismatches: 0" in the output (VerilogEvalv2)
            # or checks for "===========Your Design Passed===========" in the output (RTLLMv2)
            m_match = re.search(r"^Mismatches: (\d+)", output, re.M)
            if (
                m_match and int(m_match.group(1)) == 0
            ) or "===========Your Design Passed===========" in output:
                return True, log

        return False, log

    def _create_sdc_file(
        self,
        verilog_file: str,
        module_name: str,
        output_directory: str,
        clk_period: float,
    ) -> str:
        """
        Creates a simple SDC file for timing constraints.

        :param verilog_file: Path to the Verilog file to extract clock ports from.
        :param module_name: Name of the top-level module in the Verilog file.
        :param output_directory: Directory to save the SDC file.
        :param clk_period: Clock period in nanoseconds.
        :return: Path to the generated SDC file.
        """
        clk_ports = []
        clk_pattern = r"\b(clk|Clock|clock|Clk|CLK|CK|ck)\w*"

        with open(verilog_file, "r") as inFile:
            lines = inFile.read().split(";")
            for line in lines:
                if f"module {module_name}" in line:
                    ob = line.find("(")
                    cb = line.rfind(")")
                    matches = re.findall(clk_pattern, line[ob : cb - 1])
                    if matches:
                        clk_ports.extend(matches)
                    else:
                        clk_ports.append("f_clk")
                break

        sdc_lines = []
        sdc_lines.append(f"current_design {module_name}\n")
        sdc_lines.append("set clk_name clk\n")
        sdc_lines.append(f"set clk_period {clk_period}\n")
        for clk_port in clk_ports:
            sdc_lines.append(
                f"create_clock -name $clk_name -period $clk_period [get_ports {clk_port}]\n"
            )

        sdc_gen = f"{output_directory}/{module_name}.sdc"
        with open(sdc_gen, "w") as outfile:
            for sdc_line in sdc_lines:
                outfile.write(sdc_line)

        return sdc_gen

    def _create_yosys_script(
        self,
        verilog_file: str,
        module_name: str,
        output_directory: str,
        clk_period: float,
        output_file: str,
    ) -> str:
        """Creates a Yosys synthesis script from a template.

        :param verilog_file: Path to the Verilog file to be synthesized.
        :param module_name: Name of the top-level module in the Verilog file.
        :param output_directory: Directory to save the generated Yosys script.
        :param clk_period: Clock period in nanoseconds.
        :param output_file: Name of the output file for the synthesized netlist.
        :return: Path to the generated Yosys script.
        """
        yosys_ref = os.path.join(self.ref_dir_path, "ref.yosys.tcl")
        yosys_gen = f"{output_directory}/{module_name}.yosys.tcl"

        with open(yosys_ref, "r") as infile:
            with open(yosys_gen, "w") as outfile:
                text = infile.read()
                text = text.replace("__VERILOG_FILE__", os.path.abspath(verilog_file))
                text = text.replace(
                    "__MODULE_NAME__", module_name
                )  # Reverted to using module_name directly as we now extract it from the Verilog file
                text = text.replace("__OUTPUT_DIR__", os.path.abspath(output_directory))
                text = text.replace("__OUTPUT_FILE__", output_file)
                text = text.replace("__REF_DIR__", self.ref_dir_path)
                text = text.replace("__PDK_DIR__", os.path.abspath(self.pdk_path))
                text = text.replace("__CLK_PERIOD__", str(clk_period * 1000))
                outfile.write(text)

        return yosys_gen

    def _create_openroad_script(
        self,
        sdc_file_path: str,
        module_name: str,
        output_directory: str,
        output_file: str,
    ) -> str:
        """Creates an OpenROAD script from a template.

        :param sdc_file_path: Path to the SDC file for timing constraints.
        :param module_name: Name of the top-level module in the Verilog file.
        :param output_directory: Directory to save the generated OpenROAD script.
        :param output_file: Name of the output file for the synthesized netlist.
        :return: Path to the generated OpenROAD script.
        """
        # A simplified OpenROAD script. This may need to be adapted for your specific PDK and design.
        or_ref = os.path.join(self.ref_dir_path, "ref.openroad.tcl")
        or_gen = f"{output_directory}/{module_name}.openroad.tcl"

        with open(or_ref, "r") as infile:
            with open(or_gen, "w") as outfile:
                text = infile.read()
                text = text.replace(
                    "__UTIL_DIR__",
                    os.path.join(self.script_root_dir, "scripts", "util"),
                )
                text = text.replace("__PDK_DIR__", os.path.abspath(self.pdk_path))
                text = text.replace("__DESIGN_NAME__", module_name)
                text = text.replace(
                    "__MODULE_NAME__", module_name
                )  # Reverted to using module_name directly as we now extract it from the Verilog file
                text = text.replace("__NETLIST__", os.path.abspath(f"{output_file}"))
                text = text.replace("__SDC__", sdc_file_path)
                text = text.replace("__UTILIZATION__", str(0.5))
                outfile.write(text)

        return or_gen

    def _parse_ppa_log(self, report_path: str) -> dict[str, float | str | None]:
        """
        Parses an OpenROAD log to extract Power, Performance, and Area (PPA) metrics.

        :param report_path: Path to the synthesis report file.
        :return: A dictionary with PPA metrics, or None if parsing fails.
        """
        tns, wns, power, area = None, None, None, None

        try:
            with open(report_path, "r") as file:
                for line in file:
                    parts = line.split()
                    if not parts:  # Skip empty lines
                        continue

                    try:
                        # Handle TNS and WNS
                        if parts[0] == "tns":
                            tns = float(parts[2] if parts[1] == "max" else parts[1])
                        elif parts[0] == "wns":
                            wns = float(parts[2] if parts[1] == "max" else parts[1])
                        # Handle Power and Area
                        elif line.startswith("Total"):
                            power = float(parts[4])
                        elif line.startswith("Design area"):
                            area = float(parts[2])
                    except (ValueError, IndexError):
                        # Safely ignore lines that don't parse correctly
                        continue
        except FileNotFoundError:
            print(f"Error: PPA report file not found at {report_path}")
            return {
                "tns": None,
                "wns": None,
                "eff_clk_period": None,
                "power": None,
                "area": None,
                "report_path": None,
            }

        # Calculate effective clock period only if wns was found
        eff_clk_period = None
        if wns is not None:
            if wns < 0.0:  # Indicates that it is a sequential design
                eff_clk_period = self.clk_period - wns
            else:  # Indicates that it is a combinational design
                eff_clk_period = 0.0

        ppa_path = report_path.replace(".rpt", ".ppa")
        with open(ppa_path, "w") as f:
            f.write("tns,wns,eff_clk_period,power,area\n")
            f.write(f"{tns},{wns},{eff_clk_period},{power},{area}")

        return {
            "tns": tns,
            "wns": wns,
            "eff_clk_period": eff_clk_period,
            "power": power,
            "area": area,
            "report_path": ppa_path,
        }

    def _parse_openroad_physical_metrics(self, report_path: str) -> dict[str, float]:
        """Parse lightweight OpenROAD physical metrics from the synthesis report."""
        metrics: dict[str, float] = {}
        try:
            with open(report_path, "r", encoding="utf-8") as file:
                report_text = file.read()
        except FileNotFoundError:
            return metrics

        utilization_match = re.search(
            r"Design area\s+[-+0-9.eE]+\s+u\^2\s+([-+0-9.eE]+)%\s+utilization",
            report_text,
            re.IGNORECASE,
        )
        if utilization_match:
            try:
                metrics["utilization"] = float(utilization_match.group(1))
            except ValueError:
                pass

        regex_extractors: dict[str, tuple[str, int]] = {
            "wirelength": (r"wire\s*length[^0-9-+]*([-+0-9.eE]+)", 1),
            "cts_buffer_count": (
                r"(?:cts|clock tree)[^\\n]*buffer(?:_count)?[^0-9-+]*([-+0-9.eE]+)",
                1,
            ),
            "repair_buffer_count": (
                r"repair_design_buffer_count[^0-9-+]*([-+0-9.eE]+)",
                1,
            ),
            "hold_buffer_count": (r"hold_buffer_count[^0-9-+]*([-+0-9.eE]+)", 1),
        }
        for metric_name, (pattern, group_idx) in regex_extractors.items():
            match = re.search(pattern, report_text, re.IGNORECASE)
            if match is None:
                continue
            try:
                metrics[metric_name] = float(match.group(group_idx))
            except ValueError:
                continue

        return metrics

    def _write_metrics_sidecar(
        self,
        report_path: str,
        *,
        ppa_metrics: dict[str, float | str | None],
        structural_metrics: dict[str, float],
        physical_metrics: dict[str, float],
    ) -> str | None:
        """Write a machine-readable sidecar for parsed OpenROAD/PPA metrics."""
        sidecar_path = report_path.replace(".rpt", ".metrics.json")
        payload = {
            "report_path": report_path,
            "ppa_metrics": ppa_metrics,
            "structural_metrics": structural_metrics,
            "physical_metrics": physical_metrics,
        }
        with open(sidecar_path, "w", encoding="utf-8") as handle:
            json.dump(payload, handle, indent=2)
        return sidecar_path

    def _extract_structural_metrics(self, synthesized_netlist_path: str) -> dict[str, float]:
        """Recover coarse structural metrics from the synthesized netlist when available."""
        if not os.path.isfile(synthesized_netlist_path):
            return {}
        try:
            with open(
                synthesized_netlist_path,
                "r",
                encoding="utf-8",
                errors="ignore",
            ) as handle:
                netlist_text = handle.read()
        except OSError:
            return {}
        cell_counts: dict[str, int] = {}
        for cell_type, _ in _NETLIST_INSTANCE_RE.findall(netlist_text):
            clean_type = cell_type.replace("\\", "")
            cell_counts[clean_type] = cell_counts.get(clean_type, 0) + 1

        total_cells = max(sum(cell_counts.values()), 0)
        sequential_cells = self._sum_matching_cell_types(cell_counts, _SEQ_CELL_PATTERNS)
        mux_cells = self._sum_matching_cell_types(cell_counts, _MUX_CELL_PATTERNS)
        arithmetic_cells = self._sum_matching_cell_types(cell_counts, _ARITH_CELL_PATTERNS)
        combinational_cells = max(total_cells - sequential_cells, 0)
        denom = max(total_cells, 1)
        return {
            "total_cells": float(total_cells),
            "sequential_cells": float(sequential_cells),
            "combinational_cells": float(combinational_cells),
            "mux_cells": float(mux_cells),
            "arithmetic_cells": float(arithmetic_cells),
            "seq_ratio": sequential_cells / denom,
            "comb_ratio": combinational_cells / denom,
            "mux_ratio": mux_cells / denom,
            "adder_ratio": arithmetic_cells / denom,
            "ltp_noff": 0.0,
            "cell_count_log": float(total_cells),
        }

    def _sum_matching_cell_types(
        self,
        cell_counts: dict[str, int],
        patterns: tuple[re.Pattern[str], ...],
    ) -> int:
        total = 0
        for cell_type, count in cell_counts.items():
            upper = cell_type.upper()
            if any(pattern.search(upper) for pattern in patterns):
                total += int(count)
        return total
