module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic
assign next_state[0] = (~in & state[2]) | (~in & state[0]);  // A or C when in=0
assign next_state[1] = (in & (state[0] | state[1] | state[3])); // B when in=1 from A/B/D
assign next_state[2] = (~in & state[1]) | (~in & state[3]) | (in & state[2]); // C when in=0 from B/D or in=1 from C
assign next_state[3] = in & state[2]; // D when in=1 from C

// Output logic
assign out = state[3]; // Output 1 only when in state D

endmodule