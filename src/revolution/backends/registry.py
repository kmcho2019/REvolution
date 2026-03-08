from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class BackendMetadata:
    backend_name: str
    default_prompt_profile: str
    supports_cvdp: bool = False


BACKEND_REGISTRY: dict[str, BackendMetadata] = {
    "revolution": BackendMetadata(
        backend_name="revolution",
        default_prompt_profile="default",
    ),
    "funsearch": BackendMetadata(
        backend_name="funsearch",
        default_prompt_profile="funsearch",
    ),
    "eoh": BackendMetadata(
        backend_name="eoh",
        default_prompt_profile="eoh",
        supports_cvdp=True,
    ),
    "codeevolve": BackendMetadata(
        backend_name="codeevolve",
        default_prompt_profile="codeevolve",
    ),
}


def registered_backend_names() -> list[str]:
    return list(BACKEND_REGISTRY.keys())


def default_prompt_profile_for_backend(backend_name: str) -> str:
    metadata = BACKEND_REGISTRY.get(backend_name)
    if metadata is None:
        return "default"
    return metadata.default_prompt_profile


def backend_supports_cvdp(backend_name: str) -> bool:
    metadata = BACKEND_REGISTRY.get(backend_name)
    return bool(metadata and metadata.supports_cvdp)
