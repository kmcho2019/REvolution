# T68 Upstream Verification Commands

## Clone And Record Commits

```bash
mkdir -p exp/external_repos
git clone --depth 1 https://github.com/hkust-zhiyao/MasterRTL.git \
  exp/external_repos/MasterRTL
git clone --depth 1 https://github.com/hkust-zhiyao/RTL-Timer.git \
  exp/external_repos/RTL-Timer
git -C exp/external_repos/MasterRTL rev-parse HEAD
git -C exp/external_repos/RTL-Timer rev-parse HEAD
```

Recorded commits:

- MasterRTL: `5bccf38f8db7bb511a793a709863e7cb1b333ab5`
- RTL-Timer: `206ff4078368c251d2fafaffcc648282c68316f1`

## Environment

```bash
yosys -V
uv venv exp/venvs/rtl_native_verify --python 3.11
uv pip install --python exp/venvs/rtl_native_verify/bin/python \
  ply networkx xgboost scikit-learn pandas numpy scipy matplotlib
```

Yosys version:

```text
Yosys 0.54+29 (git sha1 7b0c1fe49, g++ 11.4.0-1ubuntu1~22.04.3 -fPIC -O3)
```

## Upstream Conversion Attempts

```bash
cd exp/external_repos/MasterRTL/ys_script
yosys -q run_TinyRocket_sog.ys
```

Result:

```text
ERROR: Command syntax error: This version of Yosys is built without Verific support.
```

```bash
cd exp/external_repos/RTL-Timer/vlg2bog/scr_ys
python3 auto_run_vlg2bog.py
```

Result: the generated Yosys script hits the same `read -verific` error and
then the wrapper fails when the expected BOG output is missing.

## MasterRTL Graph Parse

The upstream wrapper uses `python3` through `os.system`, so it ignores the
isolated environment. Direct invocation is required:

```bash
cd exp/external_repos/MasterRTL/vlg2ir
/workspace/exp/venvs/rtl_native_verify/bin/python analyze.py \
  ../example/verilog/TinyRocket_sog.v \
  -N TinyRocket \
  -C sog \
  -O /workspace/exp/verification/masterrtl_analyze_direct2/
```

Result: `TinyRocket_sog.pkl` and `TinyRocket_sog_node_dict.pkl` are generated.

Regenerate the package metrics and figure:

```bash
/workspace/exp/venvs/rtl_native_verify/bin/python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T68_source_verified_rtl_native_extractors/tools/verify_upstream_artifacts.py
```

## MasterRTL Model Load

```bash
cd exp/external_repos/MasterRTL/ML_model/infer
/workspace/exp/venvs/rtl_native_verify/bin/python infer.py
```

Result:

```text
Predicted Power: [0.]
```

This verifies that the shipped XGBoost pickle deserializes, but it is not an
accuracy or useful-output result because the repository's TinyRocket example
labels are zero and the model returns a constant `0.0` on nonzero feature
vectors.
