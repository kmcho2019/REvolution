module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding: y[5:0] = 000001, 000010, 000100, 001000, 010000, 100000 for states A, B, ..., F, respectively

// Logic equations for next-state signals Y1 and Y3
assign Y1 = y[3] & w;
assign Y3 = (y[1] & ~w) | (y[5] & w);

endmodule