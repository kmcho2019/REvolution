import argparse

import pytest
import yaml

from revolution.configuration import (
    ConfigError,
    parse_args_with_config,
    snapshot_run_configuration,
)


def _build_parsers() -> tuple[argparse.ArgumentParser, argparse.ArgumentParser]:
    config_parser = argparse.ArgumentParser(add_help=False)
    config_parser.add_argument("--config", type=str)

    parser = argparse.ArgumentParser(parents=[config_parser])
    parser.add_argument("--foo", type=int, default=1)
    parser.add_argument("--bar", type=str, default="default")
    parser.add_argument("--flag", action="store_true")
    return parser, config_parser


def test_parse_args_with_config_merges_defaults_and_cli(tmp_path):
    parser, config_parser = _build_parsers()
    config_file = tmp_path / "config.yaml"
    config_file.write_text("foo: 5\nbar: from-config\n", encoding="utf-8")

    args, config_values, recorded_argv = parse_args_with_config(
        parser,
        config_parser,
        ["--config", str(config_file), "--bar", "cli-value", "--flag"],
    )

    assert args.foo == 5
    assert args.bar == "cli-value"
    assert args.flag is True
    assert config_values == {"foo": 5, "bar": "from-config"}
    assert recorded_argv == (
        "--config",
        str(config_file),
        "--bar",
        "cli-value",
        "--flag",
    )


def test_parse_args_with_config_rejects_unknown_options(tmp_path):
    parser, config_parser = _build_parsers()
    config_file = tmp_path / "config.yaml"
    config_file.write_text("unknown: true\n", encoding="utf-8")

    with pytest.raises(ConfigError, match="Unknown option"):
        parse_args_with_config(
            parser,
            config_parser,
            ["--config", str(config_file)],
        )


def test_snapshot_run_configuration_writes_expected_yaml(tmp_path):
    parser, config_parser = _build_parsers()
    config_file = tmp_path / "config.yaml"
    config_file.write_text("foo: 7\nbar: from-config\n", encoding="utf-8")

    args, config_values, _ = parse_args_with_config(
        parser,
        config_parser,
        ["--config", str(config_file)],
    )

    output_path = tmp_path / "snapshot.yaml"
    snapshot_run_configuration(
        args,
        output_path,
        config_from_file=config_values,
        argv=["--config", str(config_file)],
    )

    assert output_path.exists()
    data = yaml.safe_load(output_path.read_text(encoding="utf-8"))

    assert data["resolved_arguments"]["foo"] == 7
    assert data["resolved_arguments"]["bar"] == "from-config"
    assert data["resolved_arguments"]["flag"] is False
    assert data["config_file_values"] == config_values
    assert data["config_file_path"].endswith("config.yaml")
    assert data["command_line_arguments"] == ["--config", str(config_file)]
