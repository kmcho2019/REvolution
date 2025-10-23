module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
assign next_state[0] = (~in & state[0]) | (in & state[2]) | (~in & state[3]); // A
assign next_state[1] = (in & state[0]) | (~in & state[1]) | (in & state[3]); // B
assign next_state[2] = (~in & state[1]) | (in & state[3]); // C
assign next_state[3] = (in & state[2]); // D

// Output logic
assign out = state[3]; // Output 1 when state is D, 0 otherwise

endmodule