from pathlib import Path

from scripts.report_tcad_edit_breadth_premise import _edit_ratio


def test_edit_ratio_counts_parent_and_child_lines(tmp_path: Path) -> None:
    parent = tmp_path / "parent.sv"
    child = tmp_path / "child.sv"
    parent.write_text("a\nb\nc\n", encoding="utf-8")
    child.write_text("a\nx\nc\nd\n", encoding="utf-8")

    assert _edit_ratio(str(parent), str(child)) == 3 / 7
