module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Common subexpressions
wire state_0_to_4 = |state[4:0];
wire state_7_to_9 = |state[9:7];
wire state_5_or_6 = |state[6:5];

// Output logic with shared term optimization
wire out_common = state[9];
assign out1 = out_common | state[8];
assign out2 = out_common | state[7];

// Next state logic with optimized structure
assign next_state[0] = (~in & (state_0_to_4 | state_7_to_9)) | 
                      (~in & state_5_or_6);

assign next_state[1] = in & (state[0] | state[8] | state[9]);
assign next_state[2] = in & state[1];
assign next_state[3] = in & state[2];
assign next_state[4] = in & state[3];
assign next_state[5] = in & state[4];
assign next_state[6] = in & state[5];
assign next_state[7] = in & (|state[6:7]);  // Combined using bitwise OR
assign next_state[8] = ~in & state[5];
assign next_state[9] = ~in & state[6];

endmodule