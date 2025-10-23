module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

// Next state logic
assign next_state[0] = (~in & state[0]) | (~in & state[2]); // A or C when in=0
assign next_state[1] = (in & state[0]) | (~in & state[1]) | (in & state[2]) | (in & state[3]); // B when in=1 from A, or always from B, or when in=1 from C or D
assign next_state[2] = (~in & state[1]); // C when in=0 from B
assign next_state[3] = (in & state[2]); // D when in=1 from C

// Output logic
assign out = state[3]; // Output is 1 only for state D

endmodule