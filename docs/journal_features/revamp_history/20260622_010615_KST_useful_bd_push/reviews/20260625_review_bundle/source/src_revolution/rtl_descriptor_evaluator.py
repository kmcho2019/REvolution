from __future__ import annotations

import math
import re
import shlex
import subprocess
from pathlib import Path


_RTL_INSTANCE_RE = re.compile(
    r"^\s*([A-Za-z_][A-Za-z0-9_$]*)\s+(?:#\s*\([^;]*?\)\s*)?([A-Za-z_][A-Za-z0-9_$]*)\s*\(",
    re.M | re.S,
)
_AST_NODE_RE = re.compile(r"^(?P<indent>\s+)(?P<node>AST_[A-Z0-9_]+|ATTR)\b")
_STATE_PARAM_RE = re.compile(
    r"\b(?:localparam|parameter)\b[^;]*?\b([A-Za-z_][A-Za-z0-9_]*)\b[^;]*?=",
    re.I,
)
_WIRE_DECL_RE = re.compile(r"^\s*(?:wire|logic|reg)\b", re.M)
_COMMENT_BLOCK_RE = re.compile(r"/\*.*?\*/", re.S)
_IDENTIFIER_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_$]*")

_RESERVED_RTL_WORDS = {
    "if",
    "else",
    "case",
    "endcase",
    "always",
    "always_ff",
    "always_comb",
    "always_latch",
    "assign",
    "wire",
    "logic",
    "reg",
    "module",
    "endmodule",
    "input",
    "output",
    "inout",
    "begin",
    "end",
    "for",
    "while",
    "generate",
    "endgenerate",
    "function",
    "endfunction",
    "task",
    "endtask",
    "localparam",
    "parameter",
}

_CONTROL_AST_NODES = {
    "AST_CASE",
    "AST_COND",
    "AST_FOR",
    "AST_WHILE",
    "AST_REPEAT",
    "AST_GENFOR",
    "AST_GENIF",
}
_PROCEDURAL_AST_NODES = {
    "AST_ALWAYS",
    "AST_INITIAL",
}


class RTLDescriptorEvaluator:
    """Extract lightweight RTL, AST, and netlist-estimate descriptors."""

    def __init__(self, *, ast_timeout_seconds: int = 30) -> None:
        self.ast_timeout_seconds = max(1, int(ast_timeout_seconds))

    def extract_metrics(
        self,
        *,
        code_text: str,
        code_file_path: str | Path | None,
        mapped_cell_count: float | int | None = None,
    ) -> dict[str, float]:
        """Collect lightweight descriptor metrics from candidate RTL artifacts."""
        metrics = self.extract_text_metrics(code_text)

        netlist_text = self._load_netlist_text(code_file_path)
        wire_count = (
            self._count_netlist_wires(netlist_text)
            if netlist_text is not None
            else self._count_wire_like_declarations(code_text)
        )
        denom = max(float(mapped_cell_count or 0.0), 1.0)
        metrics.update(
            {
                "wire_count_log_est": math.log1p(max(wire_count, 0)),
                "wire_cell_ratio_est": float(wire_count) / denom,
            }
        )

        ast_text = self._load_ast_dump(code_file_path)
        metrics.update(self.extract_ast_metrics(ast_text, mapped_cell_count=mapped_cell_count))
        return metrics

    def extract_text_metrics(self, code_text: str) -> dict[str, float]:
        """Extract source-text descriptor counts from RTL text."""
        lines = code_text.splitlines()
        stripped_lines = [line.strip() for line in lines]
        timing_text = _strip_comments(code_text)

        rtl_instance_count = 0
        for cell_type, _ in _RTL_INSTANCE_RE.findall(code_text):
            if cell_type.lower() in _RESERVED_RTL_WORDS:
                continue
            rtl_instance_count += 1

        state_names = {
            name
            for name in _STATE_PARAM_RE.findall(code_text)
            if re.search(r"(state|^s\d+|_s\d+|idle|wait|run|done|start|stop|error)", name, re.I)
        }

        metrics = {
            "rtl_line_count": float(len(lines)),
            "rtl_nonempty_line_count": float(sum(bool(line) for line in stripped_lines)),
            "rtl_char_count": float(len(code_text)),
            "always_count": float(len(re.findall(r"\balways(?:_ff|_comb|_latch)?\b", code_text))),
            "assign_count": float(len(re.findall(r"\bassign\b", code_text))),
            "if_count": float(len(re.findall(r"\bif\b", code_text))),
            "case_count": float(len(re.findall(r"\bcase[zx]?\b", code_text))),
            "for_count": float(len(re.findall(r"\bfor\b", code_text))),
            "ternary_count": float(code_text.count("?")),
            "shift_op_count": float(code_text.count("<<") + code_text.count(">>")),
            "rtl_instance_count_est": float(rtl_instance_count),
            "fsm_state_count_est": float(len(state_names)),
        }
        metrics.update(_timing_risk_metrics(timing_text))
        return metrics

    def extract_ast_metrics(
        self,
        ast_text: str | None,
        *,
        mapped_cell_count: float | int | None = None,
    ) -> dict[str, float]:
        """Extract AST-shape descriptors from a Yosys AST dump when available."""
        if not ast_text:
            return {
                "ast_depth_est": 0.0,
                "ctrl_depth_est": 0.0,
                "math_op_ast_count": 0.0,
                "resource_sharing_ratio_est": 0.0,
                "rtl_cyclomatic_total_log": 0.0,
                "rtl_cyclomatic_max_log": 0.0,
            }

        in_dump = False
        stack: list[tuple[int, str]] = []
        max_ast_depth = 0
        max_ctrl_depth = 0
        add_count = 0
        mul_count = 0
        cyclomatic_stack: list[int] = []
        cyclomatic_scores: list[int] = []

        lines = ast_text.splitlines()
        for line_idx, line in enumerate(lines):
            if "Dumping AST after simplification:" in line:
                in_dump = True
                continue
            if not in_dump:
                continue
            if line.startswith("End of script."):
                break

            match = _AST_NODE_RE.match(line)
            if match is None:
                continue
            indent = len(match.group("indent"))
            node = match.group("node")
            while stack and stack[-1][0] >= indent:
                _, popped_node = stack.pop()
                if popped_node in _PROCEDURAL_AST_NODES and cyclomatic_stack:
                    cyclomatic_scores.append(cyclomatic_stack.pop())
            stack.append((indent, node))

            node_depth = len(stack) - 1
            max_ast_depth = max(max_ast_depth, node_depth)
            ctrl_depth = sum(1 for _, stack_node in stack if stack_node in _CONTROL_AST_NODES)
            max_ctrl_depth = max(max_ctrl_depth, ctrl_depth)

            if node in _PROCEDURAL_AST_NODES:
                cyclomatic_stack.append(1)
            elif cyclomatic_stack and node == "AST_CASE":
                child_cond_count = self._count_case_branch_alternatives(
                    lines,
                    start_index=line_idx,
                    current_indent=indent,
                )
                cyclomatic_stack[-1] += max(1, child_cond_count)

            if node == "AST_ADD":
                add_count += 1
            elif node == "AST_MUL":
                mul_count += 1

        while stack:
            _, popped_node = stack.pop()
            if popped_node in _PROCEDURAL_AST_NODES and cyclomatic_stack:
                cyclomatic_scores.append(cyclomatic_stack.pop())

        denom = max(float(mapped_cell_count or 0.0), 1.0)
        math_op_ast_count = add_count + mul_count
        cyclomatic_total = float(sum(cyclomatic_scores))
        cyclomatic_max = float(max(cyclomatic_scores)) if cyclomatic_scores else 0.0
        return {
            "ast_depth_est": float(max_ast_depth),
            "ctrl_depth_est": float(max_ctrl_depth),
            "math_op_ast_count": float(math_op_ast_count),
            "resource_sharing_ratio_est": float(math_op_ast_count) / denom,
            # Keep the raw score under the log-transformed axis name so the descriptor
            # registry can apply the same projection logic used by cell_count_log.
            "rtl_cyclomatic_total_log": cyclomatic_total,
            "rtl_cyclomatic_max_log": cyclomatic_max,
        }

    def _count_case_branch_alternatives(
        self,
        lines: list[str],
        *,
        start_index: int,
        current_indent: int,
    ) -> int:
        cond_count = 0
        for line in lines[start_index + 1 :]:
            match = _AST_NODE_RE.match(line)
            if match is None:
                continue
            indent = len(match.group("indent"))
            if indent <= current_indent:
                break
            if indent == current_indent + 2 and match.group("node") == "AST_COND":
                cond_count += 1
        return cond_count

    def _load_netlist_text(self, code_file_path: str | Path | None) -> str | None:
        if code_file_path is None:
            return None
        path = Path(code_file_path)
        try:
            netlist_path = path.with_suffix(".syn.v")
        except ValueError:
            return None
        if not netlist_path.is_file():
            return None
        return netlist_path.read_text(encoding="utf-8", errors="ignore")

    def _count_netlist_wires(self, netlist_text: str) -> int:
        return sum(1 for line in netlist_text.splitlines() if line.lstrip().startswith("wire "))

    def _count_wire_like_declarations(self, code_text: str) -> int:
        return len(_WIRE_DECL_RE.findall(code_text))

    def _load_ast_dump(self, code_file_path: str | Path | None) -> str | None:
        if code_file_path is None:
            return None
        path = Path(code_file_path)
        if not path.is_file():
            return None
        command = [
            "yosys",
            "-Q",
            "-p",
            f"read_verilog -sv -no_dump_ptr -dump_ast2 {shlex.quote(str(path))}",
        ]
        try:
            completed = subprocess.run(
                command,
                check=False,
                capture_output=True,
                text=True,
                timeout=self.ast_timeout_seconds,
            )
        except (FileNotFoundError, subprocess.TimeoutExpired):
            return None
        if completed.returncode != 0:
            return None
        output = "\n".join(part for part in (completed.stdout, completed.stderr) if part).strip()
        return output or None


def _strip_comments(text: str) -> str:
    return re.sub(r"//.*", " ", _COMMENT_BLOCK_RE.sub(" ", text))


def _timing_risk_metrics(text: str) -> dict[str, float]:
    identifiers = [
        token for token in _IDENTIFIER_RE.findall(text) if token.lower() not in _RESERVED_RTL_WORDS
    ]
    counts = {token: identifiers.count(token) for token in set(identifiers)}
    posedge_count = _count_word(text, "posedge")
    negedge_count = _count_word(text, "negedge")
    pipeline_events = posedge_count + negedge_count + text.count("<=")
    control_count = _count_word(text, "if") + _count_word(text, "case") + text.count("?")
    mul_count = text.count("*")
    shift_count = text.count("<<") + text.count(">>")
    arith_count = len(re.findall(r"(?<![<>=!])[+\-*/%](?![<>=])", text)) + shift_count
    compare_count = len(re.findall(r"==|!=|>=|<=|(?<!<)<(?![=<])|(?<!>)>(?![=>])", text))
    logic_count = len(re.findall(r"&&|\|\||[&|^~]", text))
    max_rhs_operator_count = _max_rhs_operator_count(text)
    max_fanout = max(counts.values()) if counts else 0
    risk = (
        (2.0 * arith_count)
        + (3.0 * mul_count)
        + (1.5 * shift_count)
        + (1.5 * control_count)
        + compare_count
        + (2.0 * max_rhs_operator_count)
        + (0.15 * max_fanout)
        - (0.5 * pipeline_events)
    )
    return {
        "pipeline_event_count": float(pipeline_events),
        "control_count": float(control_count),
        "arith_count": float(arith_count),
        "mul_count": float(mul_count),
        "compare_count": float(compare_count),
        "logic_op_count": float(logic_count),
        "max_rhs_operator_count": float(max_rhs_operator_count),
        "unique_identifier_count": float(len(counts)),
        "max_identifier_fanout": float(max_fanout),
        "timing_risk_score": max(0.0, float(risk)),
        "control_pipeline_ratio": float(control_count + 1.0) / float(pipeline_events + 1.0),
        "timing_risk_entropy": _entropy(
            [arith_count, control_count, compare_count, logic_count, max_fanout]
        ),
    }


def _count_word(text: str, word: str) -> int:
    return len(re.findall(rf"\b{re.escape(word)}\b", text))


def _max_rhs_operator_count(text: str) -> int:
    max_count = 0
    for match in re.finditer(r"=\s*([^;]+);", text):
        rhs = match.group(1)
        count = len(re.findall(r"==|!=|>=|<=|&&|\|\||<<|>>|[+\-*/%&|^~?:<>]", rhs))
        max_count = max(max_count, count)
    return max_count


def _entropy(values: list[int]) -> float:
    total = sum(values)
    if total == 0:
        return 0.0
    entropy = 0.0
    for value in values:
        if value:
            probability = value / total
            entropy -= probability * math.log2(probability)
    return entropy
