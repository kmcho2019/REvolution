import argparse
from pathlib import Path

import pytest
import yaml

from revolution.configuration import (
    ConfigError,
    load_config_file,
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


def test_load_config_file_accepts_legacy_snapshot_format(tmp_path):
    config_file = tmp_path / "legacy_snapshot.yaml"
    config_file.write_text(
        yaml.safe_dump(
            {
                "resolved_arguments": {"foo": 9, "bar": "legacy", "flag": True},
                "command_line_arguments": ["--foo", "9"],
                "config_file_values": {"foo": 9},
            },
            sort_keys=True,
        ),
        encoding="utf-8",
    )

    loaded = load_config_file(config_file)
    assert loaded == {"foo": 9, "bar": "legacy", "flag": True}


def test_snapshot_run_configuration_writes_runnable_and_meta_yaml(tmp_path):
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
    meta_path = tmp_path / "snapshot_meta.yaml"
    assert meta_path.exists()
    meta = yaml.safe_load(meta_path.read_text(encoding="utf-8"))

    assert data["foo"] == 7
    assert data["bar"] == "from-config"
    assert data["flag"] is False
    assert "resolved_arguments" not in data

    assert meta["config_file_values"] == config_values
    assert meta["config_file_path"].endswith("config.yaml")
    assert meta["command_line_arguments"] == ["--config", str(config_file)]
    assert meta["snapshot_format"] == "runnable_config_with_metadata_sidecar_v1"


def test_generated_runnable_snapshot_is_reusable_as_config(tmp_path):
    parser, config_parser = _build_parsers()
    source_config = tmp_path / "source.yaml"
    source_config.write_text("foo: 11\nbar: source\n", encoding="utf-8")

    args, config_values, _ = parse_args_with_config(
        parser,
        config_parser,
        ["--config", str(source_config)],
    )
    generated_config = tmp_path / "generated_config.yaml"
    snapshot_run_configuration(
        args,
        generated_config,
        config_from_file=config_values,
        argv=["--config", str(source_config)],
    )

    rerun_args, _, _ = parse_args_with_config(
        parser,
        config_parser,
        ["--config", str(generated_config)],
    )
    assert rerun_args.foo == 11
    assert rerun_args.bar == "source"
    assert rerun_args.flag is False


def test_parse_args_with_config_coerces_typed_defaults(tmp_path):
    config_parser = argparse.ArgumentParser(add_help=False)
    config_parser.add_argument("--config", type=str)
    parser = argparse.ArgumentParser(parents=[config_parser])
    parser.add_argument("--save_root", type=Path, default=tmp_path / "default")
    parser.add_argument("--seeds", nargs="+", type=int, default=[42])

    config_file = tmp_path / "typed.yaml"
    config_file.write_text(
        "save_root: ./exp/my_ablation\nseeds:\n  - 7\n  - 8\n",
        encoding="utf-8",
    )
    args, config_values, _ = parse_args_with_config(
        parser,
        config_parser,
        ["--config", str(config_file)],
    )
    assert isinstance(args.save_root, Path)
    assert args.save_root == Path("./exp/my_ablation")
    assert args.seeds == [7, 8]
    assert config_values["save_root"] == Path("./exp/my_ablation")


def test_snapshot_run_configuration_filters_non_parser_keys(tmp_path):
    args = argparse.Namespace(foo=1, bar="x", runtime_only_key="ignore")
    output_path = tmp_path / "filtered.yaml"
    snapshot_run_configuration(
        args,
        output_path,
        allowed_keys={"foo", "bar"},
    )
    payload = yaml.safe_load(output_path.read_text(encoding="utf-8"))
    assert payload == {"foo": 1, "bar": "x"}
