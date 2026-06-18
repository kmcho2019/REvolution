from __future__ import annotations

import hashlib
import re

_BLOCK_COMMENT_RE = re.compile(r"/\*.*?\*/", re.DOTALL)
_LINE_COMMENT_RE = re.compile(r"//.*")
_INSTANCE_RE = re.compile(
    r"^\s*([A-Za-z_$][\w$]*)\s+(?:#\s*\(.*?\)\s*)?([A-Za-z_$][\w$]*)\s*\((.*?)\)\s*;",
    re.DOTALL | re.MULTILINE,
)
_PIN_RE = re.compile(r"\.([A-Za-z_$][\w$]*)\s*\((.*?)\)", re.DOTALL)
_DECLARATION_WORDS = frozenset(
    {
        "assign",
        "input",
        "inout",
        "module",
        "output",
        "parameter",
        "reg",
        "wire",
    }
)


def strip_verilog_comments(source: str) -> str:
    """Remove Verilog line and block comments."""

    without_blocks = _BLOCK_COMMENT_RE.sub("", source)
    return _LINE_COMMENT_RE.sub("", without_blocks)


def canonical_netlist_hash(source: str) -> str:
    """Hash a deterministic netlist view for duplicate-elite audits.

    The hash ignores comments, whitespace, instance names, and instance
    ordering. It keeps cell types, named pin names, and connected net names,
    so it is a duplicate-audit signal rather than a formal equivalence proof.
    """

    canonical = "\n".join(_canonical_instances(source))
    return hashlib.sha256(canonical.encode("utf-8")).hexdigest()


def motif_signature_hash(source: str) -> str:
    """Hash cell-type and pin-arity counts for coarse motif diversity."""

    counts: dict[str, int] = {}
    for cell_type, pin_count, _pins in _instances(source):
        key = f"{cell_type}:{pin_count}"
        counts[key] = counts.get(key, 0) + 1
    signature = "\n".join(f"{key}:{counts[key]}" for key in sorted(counts))
    return hashlib.sha256(signature.encode("utf-8")).hexdigest()


def _canonical_instances(source: str) -> tuple[str, ...]:
    rows = []
    for cell_type, pin_count, pins in _instances(source):
        if pins:
            pin_text = ",".join(f"{pin}={net}" for pin, net in pins)
        else:
            pin_text = f"positional_arity={pin_count}"
        rows.append(f"{cell_type}|{pin_text}")
    return tuple(sorted(rows))


def _instances(source: str) -> tuple[tuple[str, int, tuple[tuple[str, str], ...]], ...]:
    text = strip_verilog_comments(source)
    instances = []
    for match in _INSTANCE_RE.finditer(text):
        cell_type = match.group(1)
        if cell_type in _DECLARATION_WORDS:
            continue
        port_blob = match.group(3)
        named_pins = tuple(
            sorted(
                (
                    pin,
                    _normalize_token(net),
                )
                for pin, net in _PIN_RE.findall(port_blob)
            )
        )
        pin_count = len(named_pins) if named_pins else _positional_pin_count(port_blob)
        instances.append((cell_type, pin_count, named_pins))
    return tuple(instances)


def _positional_pin_count(port_blob: str) -> int:
    cleaned = _normalize_token(port_blob)
    if not cleaned:
        return 0
    return len([part for part in cleaned.split(",") if part])


def _normalize_token(value: str) -> str:
    return re.sub(r"\s+", "", value)

