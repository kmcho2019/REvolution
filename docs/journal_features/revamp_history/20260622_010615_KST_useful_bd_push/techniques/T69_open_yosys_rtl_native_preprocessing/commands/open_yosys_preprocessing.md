# T69 Open-Yosys Preprocessing Commands

All commands were run from `/workspace`.

## Storage Check

```bash
df -h /workspace /tmp /
df -ih /workspace
```

Observed `/workspace`: `27T` total, `23T` used, `3.5T` available, `87%`
used. The T69 generated artifacts were kept under `exp/verification/` and are
about `14M`.

## MasterRTL Open-Source SOG

```bash
rm -rf exp/verification/t69_masterrtl_open_yosys
mkdir -p exp/verification/t69_masterrtl_open_yosys

(cd exp/external_repos/MasterRTL/ys_script && \
  yosys -q -p 'read_verilog ../example/verilog/TinyRocket/plusarg_reader.v; read_verilog ../example/verilog/TinyRocket/chipyard.TestHarness.TinyRocketConfig.top.v; hierarchy -check -top Rocket; proc; flatten; opt; fsm; opt; memory; opt; techmap; opt; write_verilog /workspace/exp/verification/t69_masterrtl_open_yosys/TinyRocket_sog_open.v')
```

Raw parse failed on generated inline attributes:

```bash
rm -rf exp/verification/t69_masterrtl_open_parse
mkdir -p exp/verification/t69_masterrtl_open_parse

(cd exp/external_repos/MasterRTL/vlg2ir && \
  /workspace/exp/venvs/rtl_native_verify/bin/python analyze.py \
    /workspace/exp/verification/t69_masterrtl_open_yosys/TinyRocket_sog_open.v \
    -N TinyRocket -C sog \
    -O /workspace/exp/verification/t69_masterrtl_open_parse/)
```

Clean generated attributes and parse again:

```bash
perl -0777 -pe 's/\(\*.*?\*\)//gs' \
  exp/verification/t69_masterrtl_open_yosys/TinyRocket_sog_open.v \
  > exp/verification/t69_masterrtl_open_yosys/TinyRocket_sog_open_clean.v

rm -rf exp/verification/t69_masterrtl_open_parse_clean
mkdir -p exp/verification/t69_masterrtl_open_parse_clean

(cd exp/external_repos/MasterRTL/vlg2ir && \
  /workspace/exp/venvs/rtl_native_verify/bin/python analyze.py \
    /workspace/exp/verification/t69_masterrtl_open_yosys/TinyRocket_sog_open_clean.v \
    -N TinyRocketOpen -C sog \
    -O /workspace/exp/verification/t69_masterrtl_open_parse_clean/)
```

## RTL-Timer Open-Source SOG BOG

```bash
rm -rf exp/verification/t69_rtltimer_open_yosys
mkdir -p exp/verification/t69_rtltimer_open_yosys

(cd exp/external_repos/RTL-Timer/vlg2bog/scr_ys && \
  yosys -q -p 'read_verilog ../rtl_example/chipyard/rtl/TinyRocket/chipyard.TestHarness.TinyRocketConfig.top.v; read_verilog ../rtl_example/chipyard/rtl/TinyRocket/plusarg_reader.v; hierarchy -top Rocket; proc; opt -fast; fsm; opt -fast; memory; opt -fast; techmap; opt -fast; rename -wire t:$*DFF*; dfflibmap -liberty ./lib/nangate45_sog.lib; abc -liberty ./lib/nangate45_sog.lib; clean; write_verilog /workspace/exp/verification/t69_rtltimer_open_yosys/TinyRocket.sog.open.v')
```

Apply the cleaner-equivalent transformation to a copy:

```bash
perl -ne 's/\(\*.*\*\)//g; s|/\*.*||g; print if /\S/' \
  exp/verification/t69_rtltimer_open_yosys/TinyRocket.sog.open.v \
  > exp/verification/t69_rtltimer_open_yosys/TinyRocket.sog.open_clean.v
```

## Syntax Checks

```bash
yosys -q -p 'read_verilog exp/verification/t69_masterrtl_open_yosys/TinyRocket_sog_open_clean.v; hierarchy -top Rocket; stat'

yosys -q -p 'read_verilog exp/verification/t69_rtltimer_open_yosys/TinyRocket.sog.open_clean.v; hierarchy -top Rocket; stat'
```

## Tables And Figure

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T69_open_yosys_rtl_native_preprocessing/tools/write_t69_summary.py
```
