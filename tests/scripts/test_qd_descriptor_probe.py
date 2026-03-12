import json
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from scripts.qd_descriptor_probe import main as qd_descriptor_probe_main  # noqa: E402


def test_qd_descriptor_probe_emits_selected_axes(capsys):
    code = qd_descriptor_probe_main(
        ["--archive_type", "grid", "--circuit_type", "combinational"]
    )
    captured = capsys.readouterr()
    payload = json.loads(captured.out)
    assert code == 0
    assert payload["axes"] == ["g_A", "g_P"]
    assert payload["requirements"]["requires_ppa"] is True
