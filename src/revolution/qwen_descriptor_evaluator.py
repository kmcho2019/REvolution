from __future__ import annotations

import hashlib
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import numpy as np


IDENT_RE = re.compile(r"\b[A-Za-z_][A-Za-z0-9_$]*\b")
PORT_DECL_RE = re.compile(
    r"\b(input|output|inout)\b\s*(?:wire|reg|logic)?\s*(?:signed\s*)?"
    r"(?:\[[^\]]+\]\s*)?([A-Za-z_][A-Za-z0-9_$]*)"
)
NET_DECL_RE = re.compile(
    r"\b(wire|reg|logic)\b\s*(?:signed\s*)?(?:\[[^\]]+\]\s*)?([^;]+);",
    re.DOTALL,
)
BLOCK_COMMENT_RE = re.compile(r"/\*.*?\*/", re.DOTALL)
LINE_COMMENT_RE = re.compile(r"//.*")

VERILOG_WORDS = {
    "always",
    "assign",
    "begin",
    "case",
    "default",
    "else",
    "end",
    "endcase",
    "endmodule",
    "if",
    "inout",
    "input",
    "logic",
    "module",
    "negedge",
    "or",
    "output",
    "parameter",
    "posedge",
    "reg",
    "signed",
    "wire",
}


@dataclass(frozen=True)
class QwenProjectionArtifact:
    """Frozen projection contract for Qwen canonical-RTL descriptors."""

    model_id: str
    axes: tuple[str, ...]
    mean: tuple[float, ...]
    components: tuple[tuple[float, ...], ...]


def load_qwen_projection_artifact(path: str | Path) -> QwenProjectionArtifact:
    payload = json.loads(Path(path).read_text(encoding="utf-8"))
    assert payload["artifact_kind"] == "qwen_canonical_rtl_projection_v0"
    axes = tuple(str(axis) for axis in payload["axes"])
    mean = tuple(float(value) for value in payload["mean"])
    components = tuple(
        tuple(float(value) for value in component)
        for component in payload["components"]
    )
    assert axes
    assert len(axes) == len(components)
    assert all(len(component) == len(mean) for component in components)
    return QwenProjectionArtifact(
        model_id=str(payload["model_id"]),
        axes=axes,
        mean=mean,
        components=components,
    )


def qwen_projection_values(
    embedding: np.ndarray,
    artifact: QwenProjectionArtifact,
) -> dict[str, float]:
    vector = np.asarray(embedding, dtype=np.float64)
    mean = np.asarray(artifact.mean, dtype=np.float64)
    components = np.asarray(artifact.components, dtype=np.float64)
    assert vector.shape == mean.shape
    projected = components @ (vector - mean)
    return dict(zip(artifact.axes, (float(value) for value in projected), strict=True))


class QwenCanonicalRTLEmbeddingEvaluator:
    """Embed canonical RTL with Qwen3 and return frozen projection axes."""

    def __init__(self, artifact_path: str | Path) -> None:
        self.artifact = load_qwen_projection_artifact(artifact_path)
        self._model: Any | None = None
        self._cache: dict[str, dict[str, float]] = {}

    def extract_metrics(self, code_text: str) -> dict[str, float]:
        canonical = canonical_qwen_rtl(code_text)
        digest = hashlib.sha256(canonical.encode("utf-8")).hexdigest()
        cached = self._cache.get(digest)
        if cached is not None:
            return dict(cached)
        matrix = self._model_encode([canonical])
        assert matrix.shape == (1, len(self.artifact.mean))
        values = qwen_projection_values(matrix[0], self.artifact)
        self._cache[digest] = values
        return dict(values)

    def _model_encode(self, texts: list[str]) -> np.ndarray:
        if self._model is None:
            import torch  # type: ignore
            from sentence_transformers import SentenceTransformer  # type: ignore

            device = "cuda" if torch.cuda.is_available() else "cpu"
            self._model = SentenceTransformer(self.artifact.model_id, device=device)
        model = self._model
        assert model is not None
        matrix = model.encode(
            texts,
            batch_size=1,
            normalize_embeddings=True,
            show_progress_bar=False,
        )
        return np.asarray(matrix, dtype=np.float32)


def canonical_qwen_rtl(text: str) -> str:
    return _canonical_text(_role_normalize(_strip_comments(text)))


def _strip_comments(text: str) -> str:
    return LINE_COMMENT_RE.sub("", BLOCK_COMMENT_RE.sub("", text))


def _role_normalize(text: str) -> str:
    mapping = _declared_roles(text)
    counters: dict[str, int] = {}

    def replace(match: re.Match[str]) -> str:
        token = match.group(0)
        if match.start() > 0 and text[match.start() - 1] == "'":
            return token
        if token in VERILOG_WORDS:
            return token
        if token not in mapping:
            mapping[token] = _next_name(counters, "tmp")
        return mapping[token]

    return IDENT_RE.sub(replace, text)


def _declared_roles(text: str) -> dict[str, str]:
    mapping: dict[str, str] = {}
    counters: dict[str, int] = {}
    for role, token in PORT_DECL_RE.findall(text):
        if token not in VERILOG_WORDS and token not in mapping:
            mapping[token] = _next_name(counters, role)
    for role, body in NET_DECL_RE.findall(text):
        prefix = "reg" if role == "reg" else "wire"
        for token in IDENT_RE.findall(body):
            if token not in VERILOG_WORDS and token not in mapping:
                mapping[token] = _next_name(counters, prefix)
    return mapping


def _next_name(counters: dict[str, int], prefix: str) -> str:
    index = counters.get(prefix, 0)
    counters[prefix] = index + 1
    return f"{prefix}_{index:04d}"


def _canonical_text(text: str) -> str:
    statements = []
    for part in text.split(";"):
        statement = " ".join(part.split())
        if statement:
            statements.append(statement + ";")
    return "\n".join(statements) + "\n"
