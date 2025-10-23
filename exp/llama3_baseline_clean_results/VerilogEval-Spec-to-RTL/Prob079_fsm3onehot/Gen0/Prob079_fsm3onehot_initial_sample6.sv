module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic
assign out = state[3]; // Since output is 1 only for state D (4'b1000)

// Next state logic
assign next_state[0] = (~in & (state[0] | state[2])) | (in & state[1]); // Next state A
assign next_state[1] = (in & state[0]) | (in & state[1]) | (~in & state[3]); // Next state B
assign next_state[2] = (~in & state[1]) | (~in & state[3]); // Next state C
assign next_state[3] = in & state[2]; // Next state D

endmodule