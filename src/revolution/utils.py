import os
import sys
from typing import Any, TextIO, Type


# StreamRedirector class for systematic output redirection and error logging
# This class is used to redirect stdout and stderr to a file for each problem
# And then aggregate the outputs in a systematic way.
class StreamRedirector:
    """
    Context manager that redirects both stdout and stderr to a specified log file.

    Useful in multiprocessing or any block of code where you need to capture
    everything that would normally print to the console.

    Upon entering, it opens (and creates parent directories for) the given file
    path and rebinds sys.stdout and sys.stderr to that file handle. Upon exit,
    it flushes and closes the file and restores the original streams.

    :param filepath: Path to the log file where output should be written.
    """

    def __init__(self, filepath: str):
        """
        :param filepath: Full path (including filename) of the log file.
        """
        self.filepath = filepath
        self.original_stdout: TextIO = sys.stdout
        self.original_stderr: TextIO = sys.stderr
        self.log_file: TextIO | None = None

    def __enter__(self) -> "StreamRedirector":
        """
        Enter the runtime context.

        - Creates parent directories as needed.
        - Opens the log file for writing (UTF-8).
        - Redirects both stdout and stderr to the opened file.

        :returns: The StreamRedirector instance (so that .log_file can be accessed if needed).
        """
        # Ensure the directory for the log file exists
        os.makedirs(os.path.dirname(self.filepath), exist_ok=True)
        # Open the log file in write mode
        self.log_file = open(self.filepath, "w", encoding="utf-8")
        # Redirect stdout and stderr
        sys.stdout = self.log_file
        sys.stderr = self.log_file
        return self

    def __exit__(
        self,
        exc_type: Type[BaseException] | None,
        exc_val: BaseException | None,
        exc_tb: Any | None,
    ) -> None:
        """
        Exit the runtime context.

        - Flushes any pending writes.
        - Closes the log file.
        - Restores original stdout and stderr.

        :param exc_type: Exception class if raised in the block, otherwise None.
        :param exc_val: Instance of the exception if raised, otherwise None.
        :param exc_tb: Traceback object if an exception was raised, otherwise None.
        """
        # Flush the file and restore original stdout/stderr
        if self.log_file:
            self.log_file.flush()
        sys.stdout = self.original_stdout
        sys.stderr = self.original_stderr
        if self.log_file:
            self.log_file.close()
