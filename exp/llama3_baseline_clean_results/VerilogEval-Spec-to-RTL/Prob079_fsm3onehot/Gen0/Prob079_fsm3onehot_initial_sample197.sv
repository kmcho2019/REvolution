module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic
assign next_state[0] = (~in & state[0]) | (~in & state[2]); // A from A or C when in=0
assign next_state[1] = (in & state[0]) | (state[1] & ~in) | (in & state[3]) | (~in & state[3]); // B from A when in=1, or from B when in=0, or from D when in=0 or in=1
assign next_state[2] = (~in & state[1]) | (in & state[2]); // C from B when in=0, or from C when in=1
assign next_state[3] = (in & state[2]); // D from C when in=1

// Output logic
assign out = state[3]; // Output is 1 when in state D

endmodule