module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// One-hot encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
// State A logic
assign next_state[0] = (~in & state[0]) | (~in & state[2]); // Go to A from A or C when in=0
assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]); // Go to B from A, B, or D when in=1
assign next_state[2] = (~in & state[1]); // Go to C from B when in=0
assign next_state[3] = (in & state[2]); // Go to D from C when in=1

assign out = state[3]; // Output is 1 only when in state D

endmodule