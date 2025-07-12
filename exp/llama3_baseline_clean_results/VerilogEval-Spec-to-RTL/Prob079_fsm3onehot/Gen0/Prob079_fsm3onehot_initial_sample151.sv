module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic based on current state and input
assign next_state[0] = (~in & state[0]) | (~in & state[2]); // Next state A
assign next_state[1] = (state[1] & (~in | in)) | (state[3] & in); // Next state B
assign next_state[2] = (~in & state[1]) | (~in & state[3]); // Next state C
assign next_state[3] = (in & state[2]); // Next state D

// Output logic
assign out = state[3]; // Output is 1 when in state D

endmodule