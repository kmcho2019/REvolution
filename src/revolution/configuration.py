from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Sequence

import yaml


class ConfigError(Exception):
    """Raised when a configuration file cannot be parsed or validated."""


def load_config_file(path: str | Path) -> dict[str, Any]:
    """
    Load a configuration file from YAML or JSON into a dictionary.

    :param path: Path to the configuration file.
    :raises ConfigError: If the file cannot be read or is invalid.
    :return: Parsed configuration dictionary.
    """
    config_path = Path(path).expanduser().resolve()
    if not config_path.exists():
        raise ConfigError(f"Configuration file not found at {config_path}")

    suffix = config_path.suffix.lower()
    try:
        raw_text = config_path.read_text(encoding="utf-8")
    except OSError as exc:
        raise ConfigError(f"Unable to read configuration file: {config_path}") from exc

    if suffix in {".yaml", ".yml"}:
        try:
            data = yaml.safe_load(raw_text) or {}
        except yaml.YAMLError as exc:
            raise ConfigError(f"Failed to parse YAML config: {config_path}") from exc
    elif suffix == ".json":
        try:
            data = json.loads(raw_text)
        except json.JSONDecodeError as exc:
            raise ConfigError(f"Failed to parse JSON config: {config_path}") from exc
    else:
        raise ConfigError(
            f"Unsupported configuration format '{suffix}'. Use .yaml, .yml, or .json."
        )

    if not isinstance(data, dict):
        raise ConfigError("Configuration file must contain a top-level mapping/object.")

    return data


def dump_config_file(config: dict[str, Any], path: str | Path) -> None:
    """
    Persist a configuration dictionary to the given path in YAML format.

    :param config: Configuration data to persist.
    :param path: Destination file path.
    """
    destination = Path(path)
    destination.parent.mkdir(parents=True, exist_ok=True)
    with destination.open("w", encoding="utf-8") as handle:
        yaml.safe_dump(config, handle, sort_keys=True)


def parse_args_with_config(
    parser: argparse.ArgumentParser,
    config_parser: argparse.ArgumentParser,
    argv: Sequence[str] | None = None,
) -> tuple[argparse.Namespace, dict[str, Any], Sequence[str]]:
    """
    Parse command line arguments with optional configuration file defaults.

    :param parser: The fully constructed argument parser.
    :param config_parser: A lightweight parser containing the --config option.
    :param argv: Optional list of arguments. Defaults to sys.argv[1:].
    :raises ConfigError: If the configuration includes unknown options.
    :return: Tuple of (parsed args, config data, resolved argv).
    """
    config_namespace, remaining_args = config_parser.parse_known_args(argv)
    resolved_argv: Sequence[str]
    if argv is None:
        resolved_argv = tuple(sys.argv[1:])
    else:
        resolved_argv = tuple(argv)

    config_data: dict[str, Any] = {}
    if getattr(config_namespace, "config", None):
        config_data = load_config_file(config_namespace.config)
        known_dests = {action.dest for action in parser._actions if action.dest != "help"}
        unknown_keys = sorted(set(config_data) - known_dests)
        if unknown_keys:
            raise ConfigError(
                f"Unknown option(s) in configuration file: {', '.join(unknown_keys)}"
            )
        parser.set_defaults(**config_data)

    args = parser.parse_args(remaining_args, namespace=config_namespace)
    return args, config_data, resolved_argv


def namespace_to_dict(namespace: argparse.Namespace) -> dict[str, Any]:
    """
    Convert an argparse namespace to a dictionary with JSON-serializable values.

    :param namespace: Parsed arguments namespace.
    :return: Dictionary representation suitable for YAML/JSON serialization.
    """
    def _convert(value: Any) -> Any:
        if isinstance(value, Path):
            return str(value)
        if isinstance(value, (list, tuple)):
            return [_convert(item) for item in value]
        if isinstance(value, set):
            return sorted(_convert(item) for item in value)
        if isinstance(value, dict):
            return {str(key): _convert(val) for key, val in value.items()}
        return value

    return {key: _convert(val) for key, val in vars(namespace).items()}


def snapshot_run_configuration(
    args: argparse.Namespace,
    output_path: str | Path,
    *,
    config_from_file: dict[str, Any] | None = None,
    argv: Sequence[str] | None = None,
) -> None:
    """
    Persist the effective runtime configuration for reproducibility.

    :param args: Parsed arguments after merging CLI and config file values.
    :param output_path: Destination path for the snapshot.
    :param config_from_file: Raw config values loaded from the file, if any.
    :param argv: Original CLI arguments (excluding the script name).
    """
    snapshot: dict[str, Any] = {
        "resolved_arguments": namespace_to_dict(args),
    }
    if argv is not None:
        snapshot["command_line_arguments"] = list(argv)
    config_path = getattr(args, "config", None)
    if config_path:
        snapshot["config_file_path"] = str(Path(config_path).expanduser().resolve())
    if config_from_file:
        snapshot["config_file_values"] = config_from_file

    dump_config_file(snapshot, output_path)
