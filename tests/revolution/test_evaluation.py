import shutil
import subprocess
from unittest.mock import MagicMock

from revolution.evaluation import VerilogEvaluator


def test_verilog_evaluator_compilation_error(mocker):
    """
    Tests that VerilogEvaluator correctly handles a compilation error.
    """
    # Arrange: Mock subprocess.run to simulate a failed compilation
    mock_process = MagicMock()
    mock_process.returncode = 1  # Non-zero return code indicates an error
    mock_process.stdout = ""
    mock_process.stderr = "Syntax error at line 5."

    mocker.patch("shutil.which", return_value=True)
    mocker.patch("subprocess.run", return_value=mock_process)

    # We also need to mock os.path.isfile to prevent FileNotFoundError
    mocker.patch("os.path.isfile", return_value=True)
    mocker.patch("os.makedirs")  # Mock makedirs to avoid creating directories

    evaluator = VerilogEvaluator(
        iverilog_executable_path="/fake/iverilog", vvp_executable_path="/fake/vvp"
    )

    # Action
    results = evaluator.evaluate(
        generated_sv_file="dut.sv", test_sv_file="tb.sv", ref_sv_file=None
    )

    # Assert
    assert results["status"] == "compilation_error"
    assert "Syntax error" in results["compilation_stderr"]
    assert results["compiled_file_path"] is None  # No vvp file should be created


def foo():
    a = shutil
    b = subprocess
    return a, b
