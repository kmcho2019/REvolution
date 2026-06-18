"""Auto-BD research utilities."""

from revolution.auto_bd.method_specs import (
    AUTO_BD_METHODS_DIR,
    AUTO_BD_SCAFFOLD_DIR,
    FORBIDDEN_DESCRIPTOR_INPUTS,
    AutoBDMethodSpec,
    method_directory,
    method_spec,
    method_specs,
    validate_method_registry,
)
from revolution.auto_bd.random_descriptor import (
    RANDOM_DESCRIPTOR_SEED,
    RANDOM_HASH_AXES,
    random_hash_descriptor_values,
)

__all__ = [
    "AUTO_BD_METHODS_DIR",
    "AUTO_BD_SCAFFOLD_DIR",
    "FORBIDDEN_DESCRIPTOR_INPUTS",
    "AutoBDMethodSpec",
    "method_directory",
    "method_spec",
    "method_specs",
    "RANDOM_DESCRIPTOR_SEED",
    "RANDOM_HASH_AXES",
    "random_hash_descriptor_values",
    "validate_method_registry",
]
