module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is 1 when current state is A and w is 1
assign Y1 = y[0] && w;

// Y3 is 1 when current state is B and w is 1, or when current state is F and w is 1
assign Y3 = (y[1] && w) || (y[5] && w);

endmodule