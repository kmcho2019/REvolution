module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

// State transition logic using direct logic equations
assign next_state[0] = (~in & (state[0] | state[2])) | (in & state[1]); // A or C when in=0, or B when in=1
assign next_state[1] = (in & state[0]) | (~in & state[2]) | state[1]; // B when in=1 and A, C when in=0, or B when in=1
assign next_state[2] = (~in & state[1]) | (in & state[2]); // C when in=0 and B, or D when in=1 and C
assign next_state[3] = (in & state[2]); // D when in=1 and C

// Output logic
assign out = state[3]; // Output is 1 only for state D

endmodule