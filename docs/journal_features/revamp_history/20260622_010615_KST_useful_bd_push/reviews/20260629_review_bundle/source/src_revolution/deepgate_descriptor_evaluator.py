from __future__ import annotations

import hashlib
import json
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path

import numpy as np


@dataclass(frozen=True)
class DeepGateProjectionArtifact:
    """Frozen projection contract for pooled DeepGate descriptors."""

    axes: tuple[str, ...]
    mean: tuple[float, ...]
    components: tuple[tuple[float, ...], ...]


def load_deepgate_projection_artifact(path: str | Path) -> DeepGateProjectionArtifact:
    payload = json.loads(Path(path).read_text(encoding="utf-8"))
    assert payload["artifact_kind"] == "deepgate_pooled_projection_v0"
    axes = tuple(str(axis) for axis in payload["axes"])
    mean = tuple(float(value) for value in payload["mean"])
    components = tuple(
        tuple(float(value) for value in component)
        for component in payload["components"]
    )
    assert axes
    assert len(axes) == len(components)
    assert all(len(component) == len(mean) for component in components)
    return DeepGateProjectionArtifact(axes=axes, mean=mean, components=components)


def deepgate_projection_values(
    embedding: np.ndarray,
    artifact: DeepGateProjectionArtifact,
) -> dict[str, float]:
    vector = np.asarray(embedding, dtype=np.float64)
    mean = np.asarray(artifact.mean, dtype=np.float64)
    components = np.asarray(artifact.components, dtype=np.float64)
    assert vector.shape == mean.shape
    projected = components @ (vector - mean)
    return dict(zip(artifact.axes, (float(value) for value in projected), strict=True))


class DeepGatePooledDescriptorEvaluator:
    """Run the isolated DeepGate bridge and return frozen projection axes."""

    def __init__(
        self,
        artifact_path: str | Path,
        *,
        repo_root: Path | None = None,
        timeout_seconds: int = 180,
    ) -> None:
        root = repo_root or Path(__file__).resolve().parents[2]
        self.artifact_path = Path(artifact_path)
        self.artifact = load_deepgate_projection_artifact(self.artifact_path)
        self.deepgate_python = (
            root / "exp/diversity_check/encoder_envs/deepgate3_probe/bin/python"
        )
        self.extract_script = root / "scripts/extract_deepgate_pooled_metrics.py"
        self.timeout_seconds = max(1, int(timeout_seconds))
        self._cache: dict[str, dict[str, float]] = {}

    def extract_metrics(
        self,
        *,
        code_file_path: str | Path,
        top_module_name: str,
    ) -> dict[str, float]:
        code_path = Path(code_file_path)
        assert code_path.is_file(), f"missing RTL file: {code_path}"
        assert self.artifact_path.is_file(), f"missing DeepGate artifact: {self.artifact_path}"
        assert self.deepgate_python.is_file(), f"missing DeepGate python: {self.deepgate_python}"
        assert self.extract_script.is_file(), f"missing DeepGate script: {self.extract_script}"
        digest = hashlib.sha256(
            code_path.read_bytes() + top_module_name.encode("utf-8")
        ).hexdigest()
        cached = self._cache.get(digest)
        if cached is not None:
            return dict(cached)

        with tempfile.TemporaryDirectory(prefix="deepgate_pooled_") as tmp:
            tmp_dir = Path(tmp)
            output_json = tmp_dir / "metrics.json"
            self._run(
                [
                    str(self.deepgate_python),
                    str(self.extract_script),
                    "--code",
                    str(code_path),
                    "--top",
                    top_module_name,
                    "--projection-artifact",
                    str(self.artifact_path),
                    "--output-json",
                    str(output_json),
                    "--work-dir",
                    str(tmp_dir),
                    "--max-aig-vars",
                    "700",
                    "--max-cone-ands",
                    "700",
                    "--max-cones",
                    "3",
                ]
            )
            payload = json.loads(output_json.read_text(encoding="utf-8"))
        metrics = {key: float(value) for key, value in payload["metrics"].items()}
        for axis in self.artifact.axes:
            assert axis in metrics
        self._cache[digest] = metrics
        return dict(metrics)

    def _run(self, args: list[str]) -> subprocess.CompletedProcess[str]:
        result = subprocess.run(
            args,
            text=True,
            capture_output=True,
            check=False,
            timeout=self.timeout_seconds,
        )
        assert result.returncode == 0, result.stderr[-2000:]
        return result
