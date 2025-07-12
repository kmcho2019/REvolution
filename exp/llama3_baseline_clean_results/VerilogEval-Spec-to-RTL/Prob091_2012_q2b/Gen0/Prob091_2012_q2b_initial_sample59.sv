module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// For state B, y[1] is 1
// For state D, y[3] is 1
assign Y1 = (y[0] & w) | (y[1] & w) | (y[3] & w); // Set Y1 when current state is A or B and w is 1, or when current state is D and w is 1
assign Y3 = y[3]; // Set Y3 when current state is D

endmodule