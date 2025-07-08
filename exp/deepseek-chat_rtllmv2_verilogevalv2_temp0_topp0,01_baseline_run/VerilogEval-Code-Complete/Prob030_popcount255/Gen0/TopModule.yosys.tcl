yosys -import

set VERILOG_FILE /project/cad-team/LX_Semicon/kmcho/EoR/exp/deepseek-chat/VerilogEval-Code-Complete/Prob030_popcount255/Gen0/Prob030_popcount255_initial_sample1.sv
set MODULE_NAME TopModule
set OUTPUT_DIR /project/cad-team/LX_Semicon/kmcho/EoR/exp/deepseek-chat/VerilogEval-Code-Complete/Prob030_popcount255/Gen0
set REF_DIR /project/cad-team/LX_Semicon/kmcho/EoR/script/ref
set PDK_DIR /project/cad-team/LX_Semicon/kmcho/EoR/pdk
set ABC_CLOCK_PERIOD_IN_PS 10.0
set LIBERTY_PATH ${PDK_DIR}/Nangate45/Nangate45_typ.lib
set CLKGATE_MAP_FILE ${PDK_DIR}/cells_clkgate.v
set LATCH_MAP_FILE ${PDK_DIR}/cells_latch.v
set ADDER_MAP_FILE ${PDK_DIR}/cells_adders.v

# Read verilog files
read_verilog -defer -sv $VERILOG_FILE

# Read standard cells and macros as blackbox inputs
read_liberty -lib ${LIBERTY_PATH}

# Read platform specific mapfile for OPENROAD_CLKGATE cells
read_verilog -defer $CLKGATE_MAP_FILE

# Generic synthesis
synth  -top ${MODULE_NAME} -flatten

# Optimize the design
opt -purge

# Technology mapping of adders
# extract the full adders
extract_fa
# map full adders
techmap -map $ADDER_MAP_FILE
techmap
# Quick optimization
opt -fast -purge

# Technology mapping of latches
techmap -map $LATCH_MAP_FILE

# Technology mapping of flip-flops
# dfflibmap only supports one liberty file
dfflibmap -liberty $LIBERTY_PATH
opt

set constr [open ${OUTPUT_DIR}/${MODULE_NAME}.abc.constr w]
puts $constr "set_driving_cell BUF_X1"
puts $constr "set_load 3.898"
close $constr

puts "Using ABC speed script."
set abc_script ${REF_DIR}/ref.abc.script

# Technology mapping for cells
# ABC supports multiple liberty files, but the hook from Yosys to ABC doesn't
puts "\[FLOW\] Set ABC_CLOCK_PERIOD_IN_PS to: $ABC_CLOCK_PERIOD_IN_PS"

abc -D $ABC_CLOCK_PERIOD_IN_PS \
    -script $abc_script \
    -liberty $LIBERTY_PATH \
    -constr ${OUTPUT_DIR}/${MODULE_NAME}.abc.constr

# Replace undef values with defined constants
setundef -zero

# Splitting nets resolves unwanted compound assign statements in netlist (assign {..} = {..})
splitnets

# Remove unused cells and wires
opt_clean -purge

# Technology mapping of constant hi- and/or lo-drivers
set TIEHI_CELL_AND_PORT "LOGIC1_X1 Z"
set TIELO_CELL_AND_PORT "LOGIC0_X1 Z"

hilomap -singleton \
        -hicell {*}$TIEHI_CELL_AND_PORT \
        -locell {*}$TIELO_CELL_AND_PORT

# Insert buffer cells for pass through wires
set MIN_BUF_CELL_AND_PORTS "BUF_X1 A Z"
insbuf -buf {*}$MIN_BUF_CELL_AND_PORTS

# Write synthesized design
write_verilog -noattr -noexpr -nohex -nodec ${OUTPUT_DIR}/${MODULE_NAME}.syn.v

