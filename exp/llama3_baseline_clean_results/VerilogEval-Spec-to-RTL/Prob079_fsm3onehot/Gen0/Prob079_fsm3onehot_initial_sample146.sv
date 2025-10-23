module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Next State Logic
// Assuming one-hot encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
assign next_state[0] = (~in & state[0]) | (~in & state[2]) | (in & state[2]); // A
assign next_state[1] = (in & state[0]) | (~in & state[1]) | (in & state[1]) | (~in & state[3]) | (in & state[3]); // B
assign next_state[2] = (~in & state[1]) | (~in & state[3]); // C
assign next_state[3] = (in & state[2]); // D

// Output Logic
assign out = state[3]; // Output is 1 only when in state D

endmodule