module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic (Moore machine)
assign out = state[3]; // Output is 1 only when in state D

// State transition logic
assign next_state[0] = (~in & state[0]) | (in & state[0]) | (~in & state[2]); // Transition to A
assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]); // Transition to B
assign next_state[2] = (~in & state[1]) | (~in & state[3]); // Transition to C
assign next_state[3] = (in & state[2]); // Transition to D

endmodule