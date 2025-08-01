import os
import sys
from typing import TextIO, Optional


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
        self.log_file = open(self.filepath, "w", encoding="utf-8")
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
