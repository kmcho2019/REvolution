module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is set (next state B) if current state is A and w is 0
assign Y1 = (~w) & y[0];

// Y3 is set (next state D) if:
// - Current state is B and w is 1
// - Current state is C and w is 1
// - Current state is E and w is 1
// - Current state is F and w is 0
assign Y3 = (w & (y[1] | y[2])) | (~w & y[5]) | (w & y[4]);

endmodule