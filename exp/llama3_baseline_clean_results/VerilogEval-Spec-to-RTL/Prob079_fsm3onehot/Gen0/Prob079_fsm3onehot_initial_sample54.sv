module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
assign next_state[0] = (~in & state[0]) | (~in & state[2]);  // Transition to state A (4'b0001)
assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]);  // Transition to state B (4'b0010)
assign next_state[2] = (~in & state[1]) | (in & state[3]);  // Transition to state C (4'b0100)
assign next_state[3] = (in & state[2]);  // Transition to state D (4'b1000)

// Output logic
assign out = state[3];  // Output is 1 when in state D, 0 otherwise

endmodule