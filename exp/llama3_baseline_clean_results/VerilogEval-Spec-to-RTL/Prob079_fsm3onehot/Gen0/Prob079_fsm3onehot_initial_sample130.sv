module TopModule(
    input  in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic for each state
assign next_state[0] = (~in & (state[0] | state[2])) | (in & state[1] & ~state[3]); // A (4'b0001)
assign next_state[1] = in & (state[0] | state[1] | state[3]); // B (4'b0010)
assign next_state[2] = ~in & state[2]; // C (4'b0100)
assign next_state[3] = in & state[2]; // D (4'b1000)

// Output logic based on the state transition table
assign out = state[3]; // Output '1' only when in state D

endmodule