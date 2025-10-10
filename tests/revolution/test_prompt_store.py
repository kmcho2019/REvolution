from revolution.prompt_store import PromptStore, safe_format


def test_prompt_store_roundtrip(tmp_path):
    store = PromptStore(root_dir=str(tmp_path), profile="profile")

    path = store.write("evolve/M-F/whole", "content\n")
    assert store.has("evolve.M-F.whole")
    assert store.read("evolve/M-F/whole") == "content\n"
    assert store.list_keys() == ["evolve/M-F/whole"]
    assert path.endswith(".txt")


def test_safe_format_leaves_unknown_placeholders():
    template = "Hello {name}, keep {unknown}"
    assert safe_format(template, name="World") == "Hello World, keep {unknown}"


def test_concat_helpers_parse_and_persist(tmp_path):
    store = PromptStore(root_dir=str(tmp_path), profile="profile")
    concat = tmp_path / "bundle.txt"
    concat.write_text(
        "===== PROMPT: evolve/M-F/whole =====\n"
        "line A\n"
        "===== END PROMPT =====\n\n"
        "===== PROMPT: feedback/system =====\n"
        "line B\n"
        "===== END PROMPT =====\n"
    )

    sections = store.load_from_concat(str(concat), write_to_disk=True)
    assert sections["evolve/M-F/whole"] == "line A\n"
    assert store.has("feedback/system")

    store.write("feedback/system", "custom\n")
    store.load_from_concat(str(concat), write_to_disk=True, overwrite=False)
    assert store.read("feedback/system") == "custom\n"

    out = tmp_path / "roundtrip.txt"
    store.save_concat(str(out))
    text = out.read_text()
    assert "PROMPT: evolve/M-F/whole" in text
    assert "line A" in text
