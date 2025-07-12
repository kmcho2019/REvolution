module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 should be 1 when the current state is A and w = 1
assign Y1 = y[0] & w;

// Y3 should be 1 when the current state is B and w = 0, or C and w = 0, or E and w = 0, or D and w = 0
assign Y3 = (y[1] | y[2] | y[4] | y[3]) & ~w;

endmodule