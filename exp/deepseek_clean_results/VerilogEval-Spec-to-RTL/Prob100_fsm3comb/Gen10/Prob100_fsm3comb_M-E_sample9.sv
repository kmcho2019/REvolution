module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// LUT for next_state[1] (MSB): 
// Format is [A_in0, A_in1, B_in0, B_in1, C_in0, C_in1, D_in0, D_in1]
parameter NS1_LUT = 8'b00_01_10_01;

// LUT for next_state[0] (LSB):
parameter NS0_LUT = 8'b00_01_00_10;

// Compute LUT index: {state[1:0], in} (3 bits)
wire [2:0] lut_index = {state, in};

// Next state computation using the LUTs
assign next_state[1] = NS1_LUT[lut_index];
assign next_state[0] = NS0_LUT[lut_index];

// Output is high only when in state D (11)
assign out = &state;  // AND of both state bits (only true for state D)

endmodule