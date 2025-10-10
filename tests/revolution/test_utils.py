import sys

import pytest

from revolution.utils import StreamRedirector


def test_stream_redirector_captures_and_restores(tmp_path):
    log_path = tmp_path / "logs" / "capture.log"
    original_stdout = sys.stdout
    original_stderr = sys.stderr

    with StreamRedirector(str(log_path)):
        print("hello stdout")
        print("hello stderr", file=sys.stderr)

    assert sys.stdout is original_stdout
    assert sys.stderr is original_stderr
    content = log_path.read_text()
    assert "hello stdout" in content
    assert "hello stderr" in content


def test_stream_redirector_restores_after_exception(tmp_path):
    log_path = tmp_path / "exc" / "error.log"
    original_stdout = sys.stdout
    original_stderr = sys.stderr

    with pytest.raises(RuntimeError):
        with StreamRedirector(str(log_path)):
            print("before crash")
            raise RuntimeError("boom")

    assert sys.stdout is original_stdout
    assert sys.stderr is original_stderr
    assert "before crash" in log_path.read_text()
